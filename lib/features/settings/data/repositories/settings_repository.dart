import 'package:flutter/material.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:uuid/uuid.dart';

import '../datasources/settings_remote_datasource.dart';
import '../models/notification_schedule_model.dart';
import '../models/user_settings_model.dart';

/// Repository that coordinates settings operations.
///
/// Provides a clean API for the presentation layer to interact with
/// user settings, including notification preferences and language.
class SettingsRepository {
  SettingsRepository({
    required SettingsRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  final SettingsRemoteDataSource _dataSource;
  final _uuid = const Uuid();

  /// Gets the current user settings.
  Future<UserSettingsModel> getSettings(String uid) {
    return _dataSource.getSettings(uid);
  }

  /// Watches user settings for real-time updates.
  Stream<UserSettingsModel> watchSettings(String uid) {
    return _dataSource.watchSettings(uid);
  }

  /// Updates all user settings at once.
  Future<void> updateSettings(String uid, UserSettingsModel settings) {
    return _dataSource.updateSettings(uid, settings);
  }

  /// Enables or disables all notifications.
  Future<void> setNotificationsEnabled(String uid, {required bool enabled}) {
    return _dataSource.updateNotificationsEnabled(uid, enabled: enabled);
  }

  /// Enables or disables smart reminders.
  Future<void> setSmartRemindersEnabled(String uid, {required bool enabled}) {
    return _dataSource.updateSmartRemindersEnabled(uid, enabled: enabled);
  }

  /// Updates the language preference.
  Future<void> setLanguage(String uid, String language) {
    return _dataSource.updateLanguage(uid, language);
  }

  /// Adds a new reminder at the specified time.
  ///
  /// Returns the created schedule model, or null if max reminders reached.
  Future<NotificationScheduleModel?> addReminder(
    String uid, {
    required TimeOfDay time,
    String? label,
  }) async {
    // Check if user can add more reminders
    final settings = await _dataSource.getSettings(uid);
    if (!settings.canAddReminder) {
      return null;
    }

    final schedule = NotificationScheduleModel(
      id: _uuid.v4(),
      hour: time.hour,
      minute: time.minute,
      label: label ?? '',
    );

    await _dataSource.addReminderSchedule(uid, schedule);
    return schedule;
  }

  /// Removes a reminder by its ID.
  Future<void> removeReminder(String uid, String scheduleId) {
    return _dataSource.removeReminderSchedule(uid, scheduleId);
  }

  /// Updates a reminder's time.
  Future<void> updateReminderTime(
    String uid,
    String scheduleId,
    TimeOfDay time,
  ) {
    return _dataSource.updateReminderSchedule(uid, scheduleId, {
      AppConstants.fieldHour: time.hour,
      AppConstants.fieldMinute: time.minute,
    });
  }

  /// Enables or disables a specific reminder.
  Future<void> setReminderEnabled(
    String uid,
    String scheduleId, {
    required bool enabled,
  }) {
    return _dataSource.updateReminderSchedule(uid, scheduleId, {
      AppConstants.fieldIsEnabled: enabled,
    });
  }

  /// Updates a reminder's label.
  Future<void> updateReminderLabel(
    String uid,
    String scheduleId,
    String label,
  ) {
    return _dataSource.updateReminderSchedule(uid, scheduleId, {
      AppConstants.fieldLabel: label,
    });
  }

  /// Enables or disables analytics and crashlytics collection.
  Future<void> setAnalyticsEnabled(
    String uid, {
    required bool enabled,
  }) {
    return _dataSource.updateAnalyticsEnabled(uid, enabled: enabled);
  }

  /// Marks a streak milestone as seen.
  Future<void> markMilestoneSeen(String uid, int weekNumber) {
    return _dataSource.markMilestoneSeen(uid, weekNumber);
  }

  /// Creates default settings for a new user.
  Future<void> initializeSettings(String uid, {String language = 'en'}) async {
    final settings = UserSettingsModel.defaultSettings(language: language);
    await _dataSource.updateSettings(uid, settings);
  }
}
