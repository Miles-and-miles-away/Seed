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
  }) = _AppUserModel;

  factory AppUserModel.fromJson(Map<String, dynamic> json) =>
      _$AppUserModelFromJson(json);
}

// TimestampConverter is now in core/utils/firestore_converters.dart
