import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification_schedule_model.dart';

part 'user_settings_model.freezed.dart';
part 'user_settings_model.g.dart';

/// Model representing user settings stored in Firestore.
///
/// This is stored as an embedded document within the user document
/// at `users/{userId}/settings` or as a field `settings` on the user doc.
@freezed
abstract class UserSettingsModel with _$UserSettingsModel {
  const factory UserSettingsModel({
    /// Master toggle for all notifications.
    @Default(true) bool notificationsEnabled,

    /// List of scheduled reminder times (max 5).
    @Default([]) List<NotificationScheduleModel> reminderSchedules,

    /// Whether to use smart reminders (only notify if no action logged today).
    @Default(true) bool smartRemindersEnabled,

    /// Preferred language code ('en' or 'ja').
    @Default('en') String language,

    /// Whether user has completed initial onboarding.
    @Default(false) bool hasSeenOnboarding,

    /// Map of streak week milestones that have been seen.
    /// Key: week number (1, 2, 3, etc.), Value: whether seen.
    @Default({}) Map<String, bool> seenStreakMilestones,

    /// Whether the streak grace period has been used (Phase 4 foundation).
    /// When true, user cannot use grace period again until streak resets.
    @Default(false) bool streakGracePeriodUsed,
  }) = _UserSettingsModel;

  const UserSettingsModel._();

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);

  /// Creates default settings for a new user.
  factory UserSettingsModel.defaultSettings({String language = 'en'}) {
    return UserSettingsModel(
      language: language,
      reminderSchedules: [
        // Default morning reminder at 9:00 AM
        const NotificationScheduleModel(
          id: 'default_morning',
          hour: 9,
          minute: 0,
          label: 'Morning',
        ),
      ],
    );
  }
}

/// Extension methods for UserSettingsModel.
extension UserSettingsModelX on UserSettingsModel {
  /// Returns only the enabled reminder schedules.
  List<NotificationScheduleModel> get enabledReminders =>
      reminderSchedules.where((r) => r.isEnabled).toList();

  /// Returns whether the user can add more reminders (max 5).
  bool get canAddReminder => reminderSchedules.length < 5;

  /// Returns the count of enabled reminders.
  int get enabledReminderCount => enabledReminders.length;

  /// Checks if a streak milestone week has been seen.
  bool hasSeenMilestone(int weekNumber) =>
      seenStreakMilestones[weekNumber.toString()] ?? false;

  /// Returns a copy with the milestone marked as seen.
  UserSettingsModel withMilestoneSeen(int weekNumber) {
    final updated = Map<String, bool>.from(seenStreakMilestones);
    updated[weekNumber.toString()] = true;
    return copyWith(seenStreakMilestones: updated);
  }
}
