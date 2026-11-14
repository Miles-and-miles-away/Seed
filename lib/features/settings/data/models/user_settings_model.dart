import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/settings/data/models/action_reminder_model.dart';

part 'user_settings_model.freezed.dart';
part 'user_settings_model.g.dart';

/// Model representing user settings stored in Firestore.
///
/// This is stored as an embedded document within the user document
/// at `users/{userId}/settings` or as a field `settings` on the user doc.
@freezed
abstract class UserSettingsModel with _$UserSettingsModel {
  const factory UserSettingsModel({
    /// Daily reminder to complete the challenge that unlocks the fact.
    @Default(false) bool notificationsEnabled,

    /// Local time of the daily reminder.
    @Default(AppConstants.defaultReminderHour) int reminderHour,
    @Default(AppConstants.defaultReminderMinute) int reminderMinute,

    /// Master switch for the reminders in [actionReminders].
    @Default(false) bool actionRemindersEnabled,

    /// Reminders the user set on library actions, by action id.
    @Default({}) Map<String, ActionReminder> actionReminders,

    /// Language the user chose ('en', 'es' or 'ja'); null if never chosen.
    String? language,

    /// Whether user has completed initial onboarding.
    @Default(false) bool hasSeenOnboarding,

    /// Map of streak week milestones that have been seen.
    /// Key: week number (1, 2, 3, etc.), Value: whether seen.
    @Default({}) Map<String, bool> seenStreakMilestones,

    /// Whether the streak grace period has been used (Phase 4 foundation).
    /// When true, user cannot use grace period again until streak resets.
    @Default(false) bool streakGracePeriodUsed,

    /// Whether analytics and crashlytics collection is enabled.
    @Default(true) bool analyticsEnabled,

    /// Preferred theme: a ThemeMode name ('system', 'light', 'dark').
    @Default('system') String themeMode,

    /// Walkthrough item ids the user has found (see WalkthroughItem).
    @Default([]) List<String> walkthroughFound,
  }) = _UserSettingsModel;

  const UserSettingsModel._();

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);

  /// Creates default settings for a new user.
  factory UserSettingsModel.defaultSettings() => const UserSettingsModel();
}

/// Extension methods for UserSettingsModel.
extension UserSettingsModelX on UserSettingsModel {
  /// Checks if a streak milestone week has been seen.
  bool hasSeenMilestone(int weekNumber) =>
      seenStreakMilestones[weekNumber.toString()] ?? false;
}
