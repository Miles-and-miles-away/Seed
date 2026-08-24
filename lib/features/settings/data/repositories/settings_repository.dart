import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seed_app/core/constants/app_constants.dart';

import '../models/notification_schedule_model.dart';
import '../models/user_settings_model.dart';

/// User settings persistence.
///
/// Settings are stored as a nested object within the user document
/// at the 'settings' field, rather than a separate subcollection.
class SettingsRepository {
  SettingsRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection(AppConstants.collectionUsers).doc(uid);

  /// Mints a Firestore auto-ID client-side (no network call).
  String _newId() =>
      _firestore.collection(AppConstants.collectionUsers).doc().id;

  /// Parses the settings field out of a user document, falling back to
  /// defaults (with the user's top-level language preference) when the
  /// document or field is missing.
  UserSettingsModel _settingsFromData(Map<String, dynamic>? data) {
    if (data == null) return UserSettingsModel.defaultSettings();

    // Malformed remote data falls back to defaults, keeping the language.
    final language = data[AppConstants.fieldLanguage];
    final fallback = UserSettingsModel.defaultSettings(
      language: language is String ? language : 'en',
    );
    final settingsData = data[AppConstants.fieldSettings];
    if (settingsData is! Map<String, dynamic>) return fallback;

    try {
      return UserSettingsModel.fromJson(settingsData);
    } on Object {
      return fallback;
    }
  }

  Future<UserSettingsModel> _getSettings(String uid) async {
    final doc = await _userDoc(uid).get();
    return _settingsFromData(doc.data());
  }

  /// Watches user settings for real-time updates.
  Stream<UserSettingsModel> watchSettings(String uid) {
    return _userDoc(
      uid,
    ).snapshots().map((doc) => _settingsFromData(doc.data()));
  }

  /// Enables or disables all notifications.
  Future<void> setNotificationsEnabled(
    String uid, {
    required bool enabled,
  }) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldNotificationsEnabled}':
          enabled,
      AppConstants.fieldNotificationsEnabled: enabled,
    });
  }

  /// Enables or disables smart reminders.
  Future<void> setSmartRemindersEnabled(
    String uid, {
    required bool enabled,
  }) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldSmartRemindersEnabled}':
          enabled,
    });
  }

  /// Updates the language preference.
  Future<void> setLanguage(String uid, String language) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldLanguage}': language,
      AppConstants.fieldLanguage: language,
    });
  }

  /// Enables or disables analytics and crashlytics collection.
  Future<void> setAnalyticsEnabled(String uid, {required bool enabled}) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldAnalyticsEnabled}':
          enabled,
    });
  }

  /// Marks a streak milestone as seen.
  Future<void> markMilestoneSeen(String uid, int weekNumber) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}'
              '.${AppConstants.fieldSeenStreakMilestones}'
              '.$weekNumber':
          true,
    });
  }

  /// Adds a new reminder at the specified time.
  ///
  /// Returns the created schedule model, or null if max reminders reached.
  Future<NotificationScheduleModel?> addReminder(
    String uid, {
    required TimeOfDay time,
    String? label,
  }) async {
    final settings = await _getSettings(uid);
    if (!settings.canAddReminder) {
      return null;
    }

    final schedule = NotificationScheduleModel(
      id: _newId(),
      hour: time.hour,
      minute: time.minute,
      label: label ?? '',
    );

    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldReminderSchedules}':
          FieldValue.arrayUnion([schedule.toJson()]),
    });
    return schedule;
  }

  /// Removes a reminder by its ID.
  Future<void> removeReminder(String uid, String scheduleId) async {
    await _updateSchedules(
      uid,
      (schedules) => schedules
          .where((s) => s[AppConstants.fieldId] != scheduleId)
          .toList(),
    );
  }

  /// Updates a reminder's time.
  Future<void> updateReminderTime(
    String uid,
    String scheduleId,
    TimeOfDay time,
  ) {
    return _updateReminderSchedule(uid, scheduleId, {
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
    return _updateReminderSchedule(uid, scheduleId, {
      AppConstants.fieldIsEnabled: enabled,
    });
  }

  /// Updates a reminder's label.
  Future<void> updateReminderLabel(
    String uid,
    String scheduleId,
    String label,
  ) {
    return _updateReminderSchedule(uid, scheduleId, {
      AppConstants.fieldLabel: label,
    });
  }

  Future<void> _updateReminderSchedule(
    String uid,
    String scheduleId,
    Map<String, dynamic> updates,
  ) async {
    await _updateSchedules(
      uid,
      (schedules) => schedules
          .map(
            (s) =>
                s[AppConstants.fieldId] == scheduleId ? {...s, ...updates} : s,
          )
          .toList(),
    );
  }

  /// Read-modify-write of the reminder schedules array.
  Future<void> _updateSchedules(
    String uid,
    List<Map<String, dynamic>> Function(List<Map<String, dynamic>>) transform,
  ) async {
    final doc = await _userDoc(uid).get();
    final settingsData =
        doc.data()?[AppConstants.fieldSettings] as Map<String, dynamic>?;
    if (settingsData == null) return;

    final schedules =
        (settingsData[AppConstants.fieldReminderSchedules] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldReminderSchedules}':
          transform(schedules),
    });
  }
}
