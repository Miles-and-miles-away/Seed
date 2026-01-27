import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../mascot/data/models/mascot_model.dart';

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

    /// The user's mascot (null if not yet selected).
    MascotModel? mascot,

    // Phase 3 fields

    /// Master toggle for notifications.
    @Default(true) bool notificationsEnabled,

    /// Date of the user's last logged action (for streak calculation).
    @TimestampConverter() DateTime? lastActionDate,

    /// Whether streak grace period is available (Phase 4 foundation).
    /// Resets to true when streak breaks.
    @Default(true) bool streakGracePeriodAvailable,

    /// FCM token for push notifications.
    String? fcmToken,
  }) = _AppUserModel;

  factory AppUserModel.fromJson(Map<String, dynamic> json) =>
      _$AppUserModelFromJson(json);
}

/// Converts Firestore Timestamp to/from DateTime.
class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}
