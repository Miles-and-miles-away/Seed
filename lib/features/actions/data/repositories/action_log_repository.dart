import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/achievements/data/datasources/achievements_remote_datasource.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_checker.dart';
import 'package:seed_app/features/actions/data/datasources/action_log_remote_datasource.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/domain/services/challenge_selection_service.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/mascot/data/models/egg_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/features/mascot/data/services/egg_hatching_service.dart';
import 'package:seed_app/shared/services/streak_service.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Repository for logging actions and managing user statistics.
class ActionLogRepository {
  ActionLogRepository({
    required this.dataSource,
    required this.firestore,
    required this.dailyChallengeTemplates,
    required this.multiDayChallengeTemplates,
    required this.mascotSpecies,
    required this.achievementsDataSource,
    required this.achievementDefinitions,
    this.eggHatchingService = const EggHatchingService(),
    this.achievementChecker = const AchievementChecker(),
  });

  final ActionLogRemoteDataSource dataSource;
  final FirebaseFirestore firestore;
  final List<DailyChallengeTemplate> dailyChallengeTemplates;
  final List<MultiDayChallengeTemplate> multiDayChallengeTemplates;
  final List<MascotSpeciesModel> mascotSpecies;
  final EggHatchingService eggHatchingService;

  /// Catalog of achievements evaluated after each action. Empty list
  /// disables the checker entirely (useful for narrow unit tests).
  final List<AchievementDefinition> achievementDefinitions;

  /// Datasource that exposes the user's achievement subcollection.
  /// Used for the pre-txn "already unlocked" read and the in-txn
  /// `transaction.get(docRef)` race-check before writing a new
  /// unlock record.
  final AchievementsRemoteDataSource achievementsDataSource;

  final AchievementChecker achievementChecker;

  /// Watches all action logs for the current user.
  Stream<List<ActionLogModel>> watchUserActionLogs(
    String userId,
  ) =>
      dataSource.watchUserActionLogs(userId);

  /// Gets recent action logs for the home screen.
  Future<List<ActionLogModel>> getRecentActionLogs(
    String userId,
    int limit,
  ) =>
      dataSource.getRecentActionLogs(userId, limit);

  /// Logs an action and updates user statistics atomically.
  ///
  /// Handles: global points/level, per-mascot leveling,
  /// egg discovery flag, and egg hatching streak.
  Future<ActionLogResult> logAction({
    required String userId,
    required ActionModel action,
    required String languageCode,
    String? note,
  }) async {
    final now = DateTime.now();
    final userRef =
        firestore.collection(AppConstants.collectionUsers).doc(userId);
    final actionLogRef = dataSource.getActionLogCollection(userId).doc();

    final actionLog = ActionLogModel(
      id: actionLogRef.id,
      actionId: action.id,
      actionName: action.name(languageCode),
      category: action.category,
      points: action.points,
      co2Grams: action.co2Grams,
      loggedAt: now,
      note: note,
      relatedSdgs: action.relatedSdgs,
    );

    int? crossedMilestoneWeek;
    var newCurrentStreak = 1;
    String? hatchedMascotId;
    var challengeCompleted = false;
    var newlyUnlockedAchievements = const <AchievementDefinition>[];

    // Pre-txn snapshot is a fast-path filter to skip already-unlocked
    // candidates. The in-txn `transaction.get(docRef)` below is the
    // actual race guard against concurrent action logs.
    final preTxnUnlockedIds = achievementDefinitions.isEmpty
        ? const <String>{}
        : (await achievementsDataSource.getUserAchievements(userId))
            .map((r) => r.id)
            .toSet();
    final achievementsCollection =
        achievementsDataSource.getAchievementsCollection(userId);

    await firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userRef);
      final userData = userDoc.data() ?? {};

      // 1. Global points/level -- always update. `var` because the
      // achievement checker may add bonus points at the end of the
      // txn, which can also push the user past a level threshold.
      final currentPoints = (userData[AppConstants.fieldPoints] as int?) ?? 0;
      var newPoints = currentPoints + action.points;
      var newLevel = calculateLevel(newPoints);

      // 2. Streak calculation
      final lastActionDate = _parseDate(
        userData[AppConstants.fieldLastActionDate],
      );
      final currentStreak =
          (userData[AppConstants.fieldCurrentStreak] as int?) ?? 0;
      final longestStreak =
          (userData[AppConstants.fieldLongestStreak] as int?) ?? 0;

      final streakResult = StreakService.instance.calculateStreakUpdate(
        lastActionDate: lastActionDate,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        now: now,
      );
      crossedMilestoneWeek = streakResult.crossedMilestoneWeek;
      newCurrentStreak = streakResult.currentStreak;

      // 2b. Denormalized aggregate counters
      final currentCo2 =
          (userData[AppConstants.fieldTotalCo2Grams] as int?) ?? 0;
      final currentActionCount =
          (userData[AppConstants.fieldTotalActionsCount] as int?) ?? 0;

      // Per-category action counts
      final catCountsRaw = (userData[AppConstants.fieldCategoryActionCounts]
              as Map<String, dynamic>?) ??
          {};
      final updatedCatCounts = Map<String, dynamic>.from(catCountsRaw);
      final oldCatCount = (updatedCatCounts[action.category] as int?) ?? 0;
      updatedCatCounts[action.category] = oldCatCount + 1;

      // Per-SDG stats
      final sdgStatsRaw =
          (userData[AppConstants.fieldSdgStats] as Map<String, dynamic>?) ?? {};
      final updatedSdgStats = Map<String, dynamic>.from(sdgStatsRaw);
      for (final sdg in action.relatedSdgs) {
        final existing = (updatedSdgStats[sdg] as Map<String, dynamic>?) ?? {};
        final oldCount = (existing[AppConstants.fieldCount] as int?) ?? 0;
        final oldCo2 = (existing[AppConstants.fieldCo2] as int?) ?? 0;
        updatedSdgStats[sdg] = {
          AppConstants.fieldCount: oldCount + 1,
          AppConstants.fieldCo2: oldCo2 + action.co2Grams,
        };
      }

      // Base update map
      final updates = <String, dynamic>{
        AppConstants.fieldPoints: newPoints,
        AppConstants.fieldLevel: newLevel,
        AppConstants.fieldCurrentStreak: streakResult.currentStreak,
        AppConstants.fieldLongestStreak: streakResult.longestStreak,
        AppConstants.fieldLastActionDate: Timestamp.fromDate(now),
        AppConstants.fieldTotalCo2Grams: currentCo2 + action.co2Grams,
        AppConstants.fieldTotalActionsCount: currentActionCount + 1,
        AppConstants.fieldSdgStats: updatedSdgStats,
        AppConstants.fieldCategoryActionCounts: updatedCatCounts,
        AppConstants.fieldUniqueActionIds: FieldValue.arrayUnion([action.id]),
      };

      // 3. Per-mascot leveling
      final activeMascotId =
          userData[AppConstants.fieldActiveMascotId] as String?;
      final mascotsRaw =
          (userData[AppConstants.fieldMascots] as List<dynamic>?) ?? [];
      final mascots = mascotsRaw
          .map(
            (e) => Map<String, dynamic>.from(e as Map),
          )
          .toList();

      if (activeMascotId != null && mascots.isNotEmpty) {
        final idx = mascots.indexWhere(
          (m) => m[AppConstants.fieldId] == activeMascotId,
        );
        if (idx != -1) {
          final isFullyEvolved =
              (mascots[idx][AppConstants.fieldIsFullyEvolved] as bool?) ??
                  false;

          if (!isFullyEvolved) {
            final oldMascotPts =
                (mascots[idx][AppConstants.fieldMascotPoints] as int?) ?? 0;
            final newMascotPts = oldMascotPts + action.points;
            final newMascotLevel = calculateLevel(newMascotPts);
            final nowFullyEvolved =
                newMascotLevel >= AppConstants.maxEvolutionLevel;

            mascots[idx][AppConstants.fieldMascotPoints] = newMascotPts;
            mascots[idx][AppConstants.fieldMascotLevel] = newMascotLevel;
            mascots[idx][AppConstants.fieldIsFullyEvolved] = nowFullyEvolved;
            updates[AppConstants.fieldMascots] = mascots;

            // 4. Egg pending discovery
            if (nowFullyEvolved &&
                userData[AppConstants.fieldEgg] == null &&
                !(userData[AppConstants.fieldEggPendingDiscovery] as bool? ??
                    false)) {
              updates[AppConstants.fieldEggPendingDiscovery] = true;
              updates[AppConstants.fieldEggPendingDiscoverySince] =
                  Timestamp.fromDate(now);
            }
          }
        }
      }

      // 5. Egg hatching streak
      if (userData[AppConstants.fieldEgg] != null) {
        final eggMap = Map<String, dynamic>.from(
          userData[AppConstants.fieldEgg] as Map,
        );
        final egg = EggModel.fromJson(eggMap);
        final eggResult = eggHatchingService.calculateEggStreakUpdate(egg, now);

        if (eggResult.shouldHatch) {
          // Hatch the egg
          final species = eggHatchingService.selectHatchingSpecies(
            mascots.map(MascotModel.fromJson).toList(),
            mascotSpecies,
          );
          final newMascotId = _uuid.v4();
          hatchedMascotId = newMascotId;

          final newMascot = MascotModel(
            id: newMascotId,
            speciesId: species.id,
            createdAt: now,
          ).toJson();

          // Ensure we have latest mascots list
          final currentMascots = updates.containsKey(AppConstants.fieldMascots)
              ? updates[AppConstants.fieldMascots] as List
              : mascots;
          updates[AppConstants.fieldMascots] = [
            ...currentMascots,
            newMascot,
          ];
          updates[AppConstants.fieldEgg] = FieldValue.delete();
        } else {
          updates[AppConstants.fieldEgg] = {
            ...eggMap,
            AppConstants.fieldHatchingStreakDays: eggResult.newStreakDays,
            AppConstants.fieldLastHatchingActivityDate: Timestamp.fromDate(now),
          };
        }
      }

      // 6. Daily challenge completion
      final challengeCompletedDate =
          userData[AppConstants.fieldChallengeCompletedDate] as String? ?? '';
      final todayKey = formatDateKey(now);

      if (challengeCompletedDate != todayKey) {
        final recentIds =
            (userData[AppConstants.fieldRecentChallengeIds] as List<dynamic>?)
                    ?.cast<String>() ??
                [];
        final challenge = selectDailyChallenge(
          userId,
          now,
          recentIds,
          dailyChallengeTemplates,
        );

        if (challenge.category == action.category) {
          challengeCompleted = true;
          final yesterdayKey = formatDateKey(
            now.subtract(const Duration(days: 1)),
          );
          final oldStreak =
              (userData[AppConstants.fieldChallengeStreak] as int?) ?? 0;
          final newStreak =
              challengeCompletedDate == yesterdayKey ? oldStreak + 1 : 1;

          updates[AppConstants.fieldChallengeCompletedDate] = todayKey;
          updates[AppConstants.fieldChallengeStreak] = newStreak;
          updates[AppConstants.fieldChallengesCompleted] =
              ((userData[AppConstants.fieldChallengesCompleted] as int?) ?? 0) +
                  1;
          updates[AppConstants.fieldRecentChallengeIds] = [
            challenge.id,
            ...recentIds.take(AppConstants.recentChallengeIdsLimit - 1),
          ];
          updates[AppConstants.fieldUnlockedFactDates] =
              FieldValue.arrayUnion([todayKey]);
        }
      }

      // 7. Multi-day challenge progress
      final multiDay = userData[AppConstants.fieldActiveMultiDayChallenge]
          as Map<String, dynamic>?;
      if (multiDay != null && multiDay.isNotEmpty) {
        final mdTemplateId = multiDay[AppConstants.fieldTemplateId] as String;
        final template = multiDayChallengeTemplates.firstWhere(
          (t) => t.id == mdTemplateId,
        );
        final lastDate =
            multiDay[AppConstants.fieldLastCompletionDate] as String? ?? '';
        final todayKey2 = formatDateKey(now);

        if (lastDate != todayKey2) {
          final categoryMatch =
              template.category == null || template.category == action.category;
          if (categoryMatch) {
            final yesterdayKey = formatDateKey(
              now.subtract(const Duration(days: 1)),
            );
            final currentDay =
                (multiDay[AppConstants.fieldCurrentDay] as int?) ?? 0;

            if (lastDate == '' || lastDate == yesterdayKey) {
              final newDay = currentDay + 1;
              final target =
                  (multiDay[AppConstants.fieldTargetDays] as int?) ?? 0;

              if (newDay >= target) {
                updates[AppConstants.fieldActiveMultiDayChallenge] =
                    <String, dynamic>{};
                updates[AppConstants.fieldCompletedMultiDayChallenges] =
                    FieldValue.arrayUnion([mdTemplateId]);
              } else {
                updates[AppConstants.fieldActiveMultiDayChallenge] = {
                  ...multiDay,
                  AppConstants.fieldCurrentDay: newDay,
                  AppConstants.fieldLastCompletionDate: todayKey2,
                };
              }
            } else {
              // Streak broken -- reset to day 1
              updates[AppConstants.fieldActiveMultiDayChallenge] = {
                ...multiDay,
                AppConstants.fieldCurrentDay: 1,
                AppConstants.fieldLastCompletionDate: todayKey2,
              };
            }
          }
        }
      }

      // 8. Achievements -- evaluate criteria against the post-update
      // user state, then atomically write unlock records + fold bonus
      // points into the same user-doc update. All in-txn reads must
      // precede in-txn writes; we read each candidate doc first to
      // skip any that a concurrent txn already unlocked.
      if (achievementDefinitions.isNotEmpty) {
        final supportedSdgIds = updatedSdgStats.keys
            .where(
              (k) =>
                  ((updatedSdgStats[k] as Map<String, dynamic>?)?[
                          AppConstants.fieldCount] as int? ??
                      0) >
                  0,
            )
            .toSet();
        final categoryCounts = <String, int>{
          for (final entry in updatedCatCounts.entries)
            entry.key: (entry.value as int?) ?? 0,
        };
        final state = AchievementUserState(
          totalActionsCount: currentActionCount + 1,
          totalCo2Grams: currentCo2 + action.co2Grams,
          currentStreak: streakResult.currentStreak,
          level: newLevel,
          categoryActionCounts: categoryCounts,
          supportedSdgIds: supportedSdgIds,
        );
        final candidates = achievementChecker.findNewlyUnlocked(
          definitions: achievementDefinitions,
          alreadyUnlockedIds: preTxnUnlockedIds,
          state: state,
        );

        // Issue all candidate reads in parallel so RPC latency
        // overlaps; reads must still precede any in-txn write.
        final candidateSnaps = await Future.wait([
          for (final c in candidates)
            transaction.get(achievementsCollection.doc(c.id)),
        ]);
        final actuallyNew = <AchievementDefinition>[
          for (var i = 0; i < candidates.length; i++)
            if (!candidateSnaps[i].exists) candidates[i],
        ];

        if (actuallyNew.isNotEmpty) {
          var bonusPoints = 0;
          for (final a in actuallyNew) {
            transaction.set(achievementsCollection.doc(a.id), {
              AppConstants.fieldUnlockedAt: FieldValue.serverTimestamp(),
            });
            bonusPoints += a.bonusPoints;
          }
          newPoints += bonusPoints;
          newLevel = calculateLevel(newPoints);
          updates[AppConstants.fieldPoints] = newPoints;
          updates[AppConstants.fieldLevel] = newLevel;
          newlyUnlockedAchievements = actuallyNew;
        }
      }

      // Write action log + user updates
      final logData = actionLog.toJson()..remove('id');
      transaction
        ..set(actionLogRef, logData)
        ..update(userRef, updates);
    });

    return ActionLogResult(
      actionLog: actionLog,
      crossedMilestoneWeek: crossedMilestoneWeek,
      newStreakDays: newCurrentStreak,
      hatchedMascotId: hatchedMascotId,
      challengeCompleted: challengeCompleted,
      newlyUnlockedAchievements: newlyUnlockedAchievements,
    );
  }

  /// Parses a date from Firestore data.
  DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}

/// Result of logging an action.
class ActionLogResult {
  const ActionLogResult({
    required this.actionLog,
    required this.newStreakDays,
    this.crossedMilestoneWeek,
    this.hatchedMascotId,
    this.challengeCompleted = false,
    this.newlyUnlockedAchievements = const [],
  });

  final ActionLogModel actionLog;

  /// Weekly milestone crossed (if any).
  final int? crossedMilestoneWeek;

  /// The new streak in days after logging.
  final int newStreakDays;

  /// ID of newly hatched mascot (if egg hatched).
  final String? hatchedMascotId;

  /// Whether today's daily challenge was completed.
  final bool challengeCompleted;

  /// Achievements unlocked by this action, in catalog order. The
  /// §6.9 celebration screen consumes this list; empty when the
  /// action did not satisfy any new criteria.
  final List<AchievementDefinition> newlyUnlockedAchievements;

  bool get shouldShowMilestone => crossedMilestoneWeek != null;

  bool get didHatchEgg => hatchedMascotId != null;

  bool get didUnlockAchievement => newlyUnlockedAchievements.isNotEmpty;
}
