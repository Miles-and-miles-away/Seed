import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/core/utils/firestore_converters.dart';
import 'package:seed_app/features/mascot/data/models/egg_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';

part 'app_user_model.freezed.dart';
part 'app_user_model.g.dart';

/// User model for Firestore serialization/deserialization.
@freezed
abstract class AppUserModel with _$AppUserModel {
  const factory AppUserModel({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default(0) int points,
    @Default(1) int level,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default('en') String language,
    @Default('09:00') String notificationTime,
    @TimestampConverter() DateTime? createdAt,
    @Default(false) bool emailVerified,
    int? dailyGoalTarget,

    /// All owned mascots.
    @Default([]) List<MascotModel> mascots,

    /// ID of the currently active mascot.
    String? activeMascotId,

    /// Pending egg waiting to hatch.
    EggModel? egg,

    /// Flag set when a mascot maxes out evolution.
    @Default(false) bool eggPendingDiscovery,

    /// When the egg pending discovery flag was set.
    @TimestampConverter() DateTime? eggPendingDiscoverySince,

    // Phase 3 fields

    /// Master toggle for notifications.
    @Default(true) bool notificationsEnabled,

    /// Date of the user's last logged action.
    @TimestampConverter() DateTime? lastActionDate,

    /// Whether streak grace period is available.
    @Default(true) bool streakGracePeriodAvailable,

    /// FCM token for push notifications.
    String? fcmToken,

    // Denormalized aggregates (avoid reading entire actionLog)

    /// Total CO2 saved across all actions (grams).
    @Default(0) int totalCo2Grams,

    /// Total number of actions logged.
    @Default(0) int totalActionsCount,

    /// Per-SDG aggregated stats: { "1": { "count": 5, "co2": 1200 } }
    @Default({}) Map<String, Map<String, int>> sdgStats,

    // Phase 5 fields

    /// Dates (yyyy-MM-dd) when the user viewed their daily eco-fact.
    @Default([]) List<String> viewedFactDates,

    // Phase 5.2: Daily challenges

    /// Date (yyyy-MM-dd) when the user last completed a challenge.
    @Default('') String challengeCompletedDate,

    /// Consecutive days of challenge completion.
    @Default(0) int challengeStreak,

    /// Lifetime count of challenges completed.
    @Default(0) int challengesCompleted,

    /// Last N template IDs to avoid repetition.
    @Default([]) List<String> recentChallengeIds,

    /// Active multi-day challenge state map.
    @Default({}) Map<String, dynamic> activeMultiDayChallenge,

    /// IDs of completed multi-day challenge templates.
    @Default([]) List<String> completedMultiDayChallenges,

    // Phase 5.3: Eco-Dex

    /// IDs of discovered Eco-Dex entries.
    @Default([]) List<String> ecodexDiscovered,

    /// Distinct action IDs the user has ever logged.
    @Default([]) List<String> uniqueActionIds,

    /// Per-category action counts: { "food": 12, "energy": 5 }
    @Default({}) Map<String, int> categoryActionCounts,
  }) = _AppUserModel;

  factory AppUserModel.fromJson(Map<String, dynamic> json) =>
      _$AppUserModelFromJson(json);
}

// TimestampConverter is now in core/utils/firestore_converters.dart
