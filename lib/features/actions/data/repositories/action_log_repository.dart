import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/services/streak_service.dart';
import '../datasources/action_log_remote_datasource.dart';
import '../models/action_log_model.dart';
import '../models/action_model.dart';

/// Repository for logging actions and managing user statistics.
class ActionLogRepository {
  ActionLogRepository({
    required this.dataSource,
    required this.firestore,
  });

  final ActionLogRemoteDataSource dataSource;
  final FirebaseFirestore firestore;

  /// Watches all action logs for the current user.
  Stream<List<ActionLogModel>> watchUserActionLogs(String userId) =>
      dataSource.watchUserActionLogs(userId);

  /// Gets recent action logs for the home screen.
  Future<List<ActionLogModel>> getRecentActionLogs(
    String userId,
    int limit,
  ) =>
      dataSource.getRecentActionLogs(userId, limit);

  /// Logs an action and updates user statistics atomically.
  ///
  /// This uses a Firestore transaction to:
  /// 1. Create the action log document
  /// 2. Update user points, level, and streak information
  ///
  /// Returns an [ActionLogResult] containing the logged action and
  /// any streak milestone information.
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

    await firestore.runTransaction((transaction) async {
      // Get current user data
      final userDoc = await transaction.get(userRef);
      final userData = userDoc.data() ?? {};

      // Calculate new points and level
      final currentPoints = (userData['points'] as int?) ?? 0;
      final newPoints = currentPoints + action.points;
      final newLevel = _calculateLevel(newPoints);

      // Calculate streak using the StreakService for milestone detection
      final lastActionDate = _parseDate(userData['lastActionDate']);
      final currentStreak = (userData['currentStreak'] as int?) ?? 0;
      final longestStreak = (userData['longestStreak'] as int?) ?? 0;

      final streakResult = StreakService.instance.calculateStreakUpdate(
        lastActionDate: lastActionDate,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        now: now,
      );

      // Capture the milestone info for return value
      crossedMilestoneWeek = streakResult.crossedMilestoneWeek;
      newCurrentStreak = streakResult.currentStreak;

      // Prepare action log data
      final logData = actionLog.toJson()..remove('id'); // Don't store id

      // Create action log document and update user document
      transaction
        ..set(actionLogRef, logData)
        ..update(userRef, {
          'points': newPoints,
          'level': newLevel,
          'currentStreak': streakResult.currentStreak,
          'longestStreak': streakResult.longestStreak,
          'lastActionDate': Timestamp.fromDate(now),
        });
    });

    return ActionLogResult(
      actionLog: actionLog,
      crossedMilestoneWeek: crossedMilestoneWeek,
      newStreakDays: newCurrentStreak,
    );
  }

  /// Calculates the user's level based on total points.
  ///
  /// Uses the formula: level = floor(log(points/100 * (scaling-1) + 1) / log(scaling)) + 1
  /// This creates a scaling progression where each level requires more points.
  int _calculateLevel(int totalPoints) {
    if (totalPoints < AppConstants.pointsPerLevel) {
      return 1;
    }

    const scalingFactor = AppConstants.levelScalingFactor;
    const basePoints = AppConstants.pointsPerLevel;

    // Calculate level using logarithmic formula
    // Points needed for level n: basePoints * (scalingFactor^(n-1) - 1) / (scalingFactor - 1)
    // Solving for n: n = log((points * (scalingFactor - 1) / basePoints) + 1) / log(scalingFactor) + 1
    final ratio = (totalPoints * (scalingFactor - 1) / basePoints) + 1;
    final level = (math.log(ratio) / math.log(scalingFactor)).floor() + 1;

    return math.max(1, level);
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
///
/// Contains the logged action and any streak milestone information.
class ActionLogResult {
  const ActionLogResult({
    required this.actionLog,
    required this.newStreakDays,
    this.crossedMilestoneWeek,
  });

  /// The logged action.
  final ActionLogModel actionLog;

  /// The week milestone that was crossed (if any).
  /// Only set when the streak crosses a weekly milestone threshold (7, 14, 21, etc.).
  final int? crossedMilestoneWeek;

  /// The new streak in days after logging.
  final int newStreakDays;

  /// Whether a milestone celebration should be shown.
  bool get shouldShowMilestone => crossedMilestoneWeek != null;
}
