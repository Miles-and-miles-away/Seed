import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../shared/services/streak_service.dart';
import '../../../mascot/data/mascot_species_data.dart';
import '../../../mascot/data/models/egg_model.dart';
import '../../../mascot/data/models/mascot_model.dart';
import '../../../mascot/data/services/egg_hatching_service.dart';
import '../datasources/action_log_remote_datasource.dart';
import '../models/action_log_model.dart';
import '../models/action_model.dart';

const _uuid = Uuid();

/// Repository for logging actions and managing user statistics.
class ActionLogRepository {
  ActionLogRepository({
    required this.dataSource,
    required this.firestore,
    this.eggHatchingService = const EggHatchingService(),
  });

  final ActionLogRemoteDataSource dataSource;
  final FirebaseFirestore firestore;
  final EggHatchingService eggHatchingService;

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
    final userRef = firestore
        .collection(AppConstants.collectionUsers)
        .doc(userId);
    final actionLogRef =
        dataSource.getActionLogCollection(userId).doc();

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

    await firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userRef);
      final userData = userDoc.data() ?? {};

      // 1. Global points/level -- always update
      final currentPoints =
          (userData['points'] as int?) ?? 0;
      final newPoints = currentPoints + action.points;
      final newLevel = calculateLevel(newPoints);

      // 2. Streak calculation
      final lastActionDate =
          _parseDate(userData['lastActionDate']);
      final currentStreak =
          (userData['currentStreak'] as int?) ?? 0;
      final longestStreak =
          (userData['longestStreak'] as int?) ?? 0;

      final streakResult =
          StreakService.instance.calculateStreakUpdate(
        lastActionDate: lastActionDate,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        now: now,
      );
      crossedMilestoneWeek =
          streakResult.crossedMilestoneWeek;
      newCurrentStreak = streakResult.currentStreak;

      // 2b. Denormalized aggregate counters
      final currentCo2 =
          (userData['totalCo2Grams'] as int?) ?? 0;
      final currentActionCount =
          (userData['totalActionsCount'] as int?) ?? 0;

      // Per-SDG stats
      final sdgStatsRaw = (userData['sdgStats']
              as Map<String, dynamic>?) ??
          {};
      final updatedSdgStats =
          Map<String, dynamic>.from(sdgStatsRaw);
      for (final sdg in action.relatedSdgs) {
        final existing = (updatedSdgStats[sdg]
                as Map<String, dynamic>?) ??
            {};
        final oldCount =
            (existing['count'] as int?) ?? 0;
        final oldCo2 =
            (existing['co2'] as int?) ?? 0;
        updatedSdgStats[sdg] = {
          'count': oldCount + 1,
          'co2': oldCo2 + action.co2Grams,
        };
      }

      // Base update map
      final updates = <String, dynamic>{
        'points': newPoints,
        'level': newLevel,
        'currentStreak': streakResult.currentStreak,
        'longestStreak': streakResult.longestStreak,
        'lastActionDate': Timestamp.fromDate(now),
        'totalCo2Grams': currentCo2 + action.co2Grams,
        'totalActionsCount': currentActionCount + 1,
        'sdgStats': updatedSdgStats,
      };

      // 3. Per-mascot leveling
      final activeMascotId =
          userData['activeMascotId'] as String?;
      final mascotsRaw =
          (userData['mascots'] as List<dynamic>?) ?? [];
      final mascots = mascotsRaw
          .map(
            (e) => Map<String, dynamic>.from(e as Map),
          )
          .toList();

      if (activeMascotId != null && mascots.isNotEmpty) {
        final idx = mascots.indexWhere(
          (m) => m['id'] == activeMascotId,
        );
        if (idx != -1) {
          final isFullyEvolved =
              (mascots[idx]['isFullyEvolved'] as bool?) ??
                  false;

          if (!isFullyEvolved) {
            final oldMascotPts =
                (mascots[idx]['mascotPoints'] as int?) ?? 0;
            final newMascotPts =
                oldMascotPts + action.points;
            final newMascotLevel =
                calculateLevel(newMascotPts);
            final nowFullyEvolved = newMascotLevel >=
                AppConstants.maxEvolutionLevel;

            mascots[idx]['mascotPoints'] = newMascotPts;
            mascots[idx]['mascotLevel'] = newMascotLevel;
            mascots[idx]['isFullyEvolved'] =
                nowFullyEvolved;
            updates['mascots'] = mascots;

            // 4. Egg pending discovery
            if (nowFullyEvolved &&
                userData['egg'] == null &&
                !(userData['eggPendingDiscovery']
                        as bool? ??
                    false)) {
              updates['eggPendingDiscovery'] = true;
              updates['eggPendingDiscoverySince'] =
                  Timestamp.fromDate(now);
            }
          }
        }
      }

      // 5. Egg hatching streak
      if (userData['egg'] != null) {
        final eggMap = Map<String, dynamic>.from(
          userData['egg'] as Map,
        );
        final egg = EggModel.fromJson(eggMap);
        final eggResult = eggHatchingService
            .calculateEggStreakUpdate(egg, now);

        if (eggResult.shouldHatch) {
          // Hatch the egg
          final species =
              eggHatchingService.selectHatchingSpecies(
            mascots
                .map(MascotModel.fromJson)
                .toList(),
            defaultMascotSpecies,
          );
          final newMascotId = _uuid.v4();
          hatchedMascotId = newMascotId;

          final newMascot = MascotModel(
            id: newMascotId,
            speciesId: species.id,
            createdAt: now,
          ).toJson();

          // Ensure we have latest mascots list
          final currentMascots =
              updates.containsKey('mascots')
                  ? updates['mascots'] as List
                  : mascots;
          updates['mascots'] = [
            ...currentMascots,
            newMascot,
          ];
          updates['egg'] = FieldValue.delete();
        } else {
          updates['egg'] = {
            ...eggMap,
            'hatchingStreakDays': eggResult.newStreakDays,
            'lastHatchingActivityDate':
                Timestamp.fromDate(now),
          };
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
  });

  final ActionLogModel actionLog;

  /// Weekly milestone crossed (if any).
  final int? crossedMilestoneWeek;

  /// The new streak in days after logging.
  final int newStreakDays;

  /// ID of newly hatched mascot (if egg hatched).
  final String? hatchedMascotId;

  bool get shouldShowMilestone =>
      crossedMilestoneWeek != null;

  bool get didHatchEgg => hatchedMascotId != null;
}
