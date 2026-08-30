import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/actions/data/datasources/action_log_remote_datasource.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/domain/services/challenge_selection_service.dart';
import 'package:seed_app/features/mascot/data/models/egg_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/features/mascot/data/services/egg_hatching_service.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';
import 'package:seed_app/shared/services/streak_service.dart';

/// Repository for logging actions and managing user statistics.
class ActionLogRepository {
  ActionLogRepository({
    required this.dataSource,
    required this.firestore,
    required this.dailyChallengeTemplates,
    required this.multiDayChallengeTemplates,
    required this.mascotSpecies,
    this.eggHatchingService = const EggHatchingService(),
  });

  final ActionLogRemoteDataSource dataSource;
  final FirebaseFirestore firestore;
  final List<DailyChallengeTemplate> dailyChallengeTemplates;
  final List<MultiDayChallengeTemplate> multiDayChallengeTemplates;
  final List<MascotSpeciesModel> mascotSpecies;
  final EggHatchingService eggHatchingService;

  /// Watches the most recent [limit] action logs for the user.
  Stream<List<ActionLogModel>> watchUserActionLogs(
    String userId, {
    required int limit,
  }) => dataSource.watchUserActionLogs(userId, limit: limit);

  /// Watches action logs whose loggedAt falls in [start, end).
  Stream<List<ActionLogModel>> watchActionLogsForRange(
    String userId,
    DateTime start,
    DateTime end,
  ) => dataSource.watchActionLogsForRange(userId, start, end);

  /// Gets action logs whose loggedAt falls in [start, end).
  Future<List<ActionLogModel>> getActionLogsForRange(
    String userId,
    DateTime start,
    DateTime end,
  ) => dataSource.getActionLogsForRange(userId, start, end);

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
    final userRef = firestore
        .collection(AppConstants.collectionUsers)
        .doc(userId);
    final actionLogRef = dataSource.getActionLogCollection(userId).doc();
    final summaryRef = userRef
        .collection(AppConstants.collectionDailySummaries)
        .doc(formatDateKey(now));

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
    var newTotalActionsCount = 1;

    await firestore.runTransaction((transaction) async {
      // Firestore retries this closure on contention; reset the
      // captured outputs so values from an abandoned attempt cannot
      // leak into the result (e.g. a celebration for a hatch the
      // final attempt did not perform).
      crossedMilestoneWeek = null;
      newCurrentStreak = 1;
      hatchedMascotId = null;
      challengeCompleted = false;
      newTotalActionsCount = 1;

      final userDoc = await transaction.get(userRef);
      final summaryDoc = await transaction.get(summaryRef);
      final userData = userDoc.data() ?? {};

      // 1. Global points/level -- always update. Points represent
      // real CO2 savings only (no bonus mechanics).
      final currentPoints = (userData[AppConstants.fieldPoints] as int?) ?? 0;
      final newPoints = currentPoints + action.points;
      final newLevel = calculateLevel(newPoints);

      // 2. Streak calculation
      final lastActionDate = _parseDate(
        userData[AppConstants.fieldLastActionDate],
      );
      final currentStreak =
          (userData[AppConstants.fieldCurrentStreak] as int?) ?? 0;
      final longestStreak =
          (userData[AppConstants.fieldLongestStreak] as int?) ?? 0;

      final streakResult = calculateStreakUpdate(
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
      newTotalActionsCount = currentActionCount + 1;

      // Per-category action counts
      final catCountsRaw =
          (userData[AppConstants.fieldCategoryActionCounts]
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

      // Base update map. lastActionDate must be the server timestamp:
      // the rules rate-limit compares it against request.time, so a
      // skewed device clock must not be able to lock the user out (or
      // bypass the limit).
      final updates = <String, dynamic>{
        AppConstants.fieldPoints: newPoints,
        AppConstants.fieldLevel: newLevel,
        AppConstants.fieldCurrentStreak: streakResult.currentStreak,
        AppConstants.fieldLongestStreak: streakResult.longestStreak,
        AppConstants.fieldLastActionDate: FieldValue.serverTimestamp(),
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
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      if (activeMascotId != null && mascots.isNotEmpty) {
        final idx = mascots.indexWhere(
          (m) => m[AppConstants.fieldId] == activeMascotId,
        );
        if (idx != -1) {
          // CO2 collected together accrues for the active mascot's whole
          // life, even after it is fully evolved.
          final oldMascotCo2 =
              (mascots[idx][AppConstants.fieldMascotCo2Grams] as int?) ?? 0;
          mascots[idx][AppConstants.fieldMascotCo2Grams] =
              oldMascotCo2 + action.co2Grams;
          updates[AppConstants.fieldMascots] = mascots;

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
          }
        }

        // 4. Egg pending discovery: reaching the unlock stage earns the
        // egg that carries the species the user did not start with.
        if (userData[AppConstants.fieldEgg] == null &&
            !(userData[AppConstants.fieldEggPendingDiscovery] as bool? ??
                false) &&
            eggHatchingService.hasUnlockedNextSpecies(
              mascots.map(MascotModel.fromJson).toList(),
              mascotSpecies,
            )) {
          updates[AppConstants.fieldEggPendingDiscovery] = true;
          updates[AppConstants.fieldEggPendingDiscoverySince] =
              Timestamp.fromDate(now);
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
          // Ensure we have latest mascots list
          final currentMascots = updates.containsKey(AppConstants.fieldMascots)
              ? updates[AppConstants.fieldMascots] as List
              : mascots;
          if (currentMascots.length >= AppConstants.maxMascotsPerUser) {
            // At the mascot cap the rules would reject the whole
            // transaction on every attempt; dispose the egg instead
            // of hatching so logging keeps working.
            updates[AppConstants.fieldEgg] = FieldValue.delete();
          } else {
            // Hatch the egg
            final species = eggHatchingService.selectHatchingSpecies(
              mascots.map(MascotModel.fromJson).toList(),
              mascotSpecies,
            );
            // Firestore auto-ID minted client-side (no network call).
            final newMascotId = firestore
                .collection(AppConstants.collectionUsers)
                .doc()
                .id;
            hatchedMascotId = newMascotId;

            final newMascot = MascotModel(
              id: newMascotId,
              speciesId: species.id,
              createdAt: now,
            ).toJson();

            updates[AppConstants.fieldMascots] = [...currentMascots, newMascot];
            updates[AppConstants.fieldEgg] = FieldValue.delete();
          }
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
          final yesterdayKey = formatDateKey(previousCalendarDay(now));
          final oldStreak =
              (userData[AppConstants.fieldChallengeStreak] as int?) ?? 0;
          final newStreak = challengeCompletedDate == yesterdayKey
              ? oldStreak + 1
              : 1;

          updates[AppConstants.fieldChallengeCompletedDate] = todayKey;
          updates[AppConstants.fieldChallengeStreak] = newStreak;
          updates[AppConstants.fieldChallengesCompleted] =
              ((userData[AppConstants.fieldChallengesCompleted] as int?) ?? 0) +
              1;
          updates[AppConstants.fieldRecentChallengeIds] = [
            challenge.id,
            ...recentIds.take(AppConstants.recentChallengeIdsLimit - 1),
          ];
          // ponytail: unbounded array on the user doc; cap to the last
          // year if doc size ever matters (see viewedFactDates note in
          // eco_fact_providers.dart).
          updates[AppConstants.fieldUnlockedFactDates] = FieldValue.arrayUnion([
            todayKey,
          ]);
        }
      }

      // 7. Multi-day challenge progress
      final multiDay =
          userData[AppConstants.fieldActiveMultiDayChallenge]
              as Map<String, dynamic>?;
      if (multiDay != null && multiDay.isNotEmpty) {
        final mdTemplateId = multiDay[AppConstants.fieldTemplateId] as String;
        final template = multiDayChallengeTemplates.firstWhereOrNull(
          (t) => t.id == mdTemplateId,
        );
        final lastDate =
            multiDay[AppConstants.fieldLastCompletionDate] as String? ?? '';
        final todayKey2 = formatDateKey(now);

        if (template == null) {
          // Template removed in an app update while still active for
          // this user: clear the stale challenge instead of throwing,
          // which would fail every subsequent log.
          updates[AppConstants.fieldActiveMultiDayChallenge] =
              <String, dynamic>{};
        } else if (lastDate != todayKey2) {
          final categoryMatch =
              template.category == null || template.category == action.category;
          if (categoryMatch) {
            final yesterdayKey = formatDateKey(previousCalendarDay(now));
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

      // Daily summary for the Progress tab, written in this same
      // transaction (with the same `now`) so the calendar and charts
      // can never diverge from the action log -- it was previously a
      // separate transaction whose failures were swallowed and which
      // could land on the wrong day across midnight.
      final sdgNumbers = action.relatedSdgs
          .map(int.tryParse)
          .whereType<int>()
          .toList();
      final Map<String, dynamic> summaryData;
      if (summaryDoc.exists) {
        final existing = DailySummaryModel.fromJson(summaryDoc.data()!);
        final categoryCo2 = Map<String, int>.from(existing.categoryCo2Grams);
        categoryCo2[action.category] =
            (categoryCo2[action.category] ?? 0) + action.co2Grams;
        summaryData = existing
            .copyWith(
              goalCount: existing.goalCount + 1,
              completedSdgs: {
                ...existing.completedSdgs,
                ...sdgNumbers,
              }.toList(),
              totalPoints: existing.totalPoints + action.points,
              totalCo2Grams: existing.totalCo2Grams + action.co2Grams,
              categoryCo2Grams: categoryCo2,
              updatedAt: now,
            )
            .toJson();
      } else {
        summaryData = DailySummaryModel(
          date: formatDateKey(now),
          goalCount: 1,
          completedSdgs: sdgNumbers.toSet().toList(),
          totalPoints: action.points,
          totalCo2Grams: action.co2Grams,
          categoryCo2Grams: {action.category: action.co2Grams},
          createdAt: now,
          updatedAt: now,
        ).toJson();
      }

      // Write action log + user updates. Null fields (e.g. an absent
      // note) are stripped: the rules validate types on present keys,
      // and a literal null would fail the string check.
      final logData = actionLog.toJson()
        ..remove('id')
        ..removeWhere((key, value) => value == null);
      transaction
        ..set(actionLogRef, logData)
        ..set(summaryRef, summaryData)
        ..update(userRef, updates);
    });

    return ActionLogResult(
      actionLog: actionLog,
      crossedMilestoneWeek: crossedMilestoneWeek,
      newStreakDays: newCurrentStreak,
      hatchedMascotId: hatchedMascotId,
      challengeCompleted: challengeCompleted,
      newTotalActionsCount: newTotalActionsCount,
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
    this.newTotalActionsCount = 1,
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

  /// The user's total action count after this log; lets callers wait
  /// for the user stream to catch up before evaluating unlocks.
  final int newTotalActionsCount;

  bool get shouldShowMilestone => crossedMilestoneWeek != null;

  bool get didHatchEgg => hatchedMascotId != null;
}
