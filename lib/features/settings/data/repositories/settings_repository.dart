import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/shared/data/language_store.dart';

import '../models/action_reminder_model.dart';
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

  /// Parses the settings field out of a user document, falling back to
  /// defaults when the document or field is missing or malformed.
  UserSettingsModel _settingsFromData(Map<String, dynamic>? data) {
    final fallback = UserSettingsModel.defaultSettings();
    final settingsData = data?[AppConstants.fieldSettings];
    if (settingsData is! Map<String, dynamic>) return fallback;

    // Rules do not check settings.language; an unknown code reads as unset.
    final language = settingsData[AppConstants.fieldLanguage];
    final supported = language is String && isSupportedLanguage(language)
        ? language
        : null;
    try {
      return UserSettingsModel.fromJson({
        ...settingsData,
        AppConstants.fieldActionReminders: _parsableReminders(
          settingsData[AppConstants.fieldActionReminders],
        ),
      }).copyWith(language: supported);
    } on Object {
      // Keep the language and found list, or the tour replays every start.
      final found = settingsData[AppConstants.fieldWalkthroughFound];
      return fallback.copyWith(
        language: supported,
        walkthroughFound: found is List
            ? found.whereType<String>().toList()
            : const [],
      );
    }
  }

  /// The entries of [data] that parse, so one bad reminder cannot reset
  /// every other setting.
  static Map<String, dynamic> _parsableReminders(Object? data) => {
    if (data is Map<String, dynamic>)
      for (final MapEntry(:key, :value) in data.entries)
        if (_parses(value)) key: value,
  };

  static bool _parses(Object? json) {
    if (json is! Map<String, dynamic>) return false;
    try {
      ActionReminder.fromJson(json);
      return true;
    } on Object {
      return false;
    }
  }

  /// Watches user settings for real-time updates.
  Stream<UserSettingsModel> watchSettings(String uid) {
    return _userDoc(
      uid,
    ).snapshots().map((doc) => _settingsFromData(doc.data()));
  }

  /// Enables or disables the daily reminder.
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

  /// Sets the daily reminder time.
  Future<void> setReminderTime(String uid, TimeOfDay time) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldReminderHour}':
          time.hour,
      '${AppConstants.fieldSettings}.${AppConstants.fieldReminderMinute}':
          time.minute,
    });
  }

  /// Turns the action reminders on or off.
  Future<void> setActionRemindersEnabled(
    String uid, {
    required bool enabled,
  }) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldActionRemindersEnabled}':
          enabled,
    });
  }

  /// Saves the reminder for [actionId], turning action reminders on
  /// when [enable] is set.
  Future<void> setActionReminder(
    String uid,
    String actionId,
    ActionReminder reminder, {
    required bool enable,
  }) async {
    await _userDoc(uid).update({
      _actionReminderPath(actionId): reminder.toJson(),
      if (enable)
        '${AppConstants.fieldSettings}.${AppConstants.fieldActionRemindersEnabled}':
            true,
    });
  }

  /// Deletes the reminder for [actionId].
  Future<void> deleteActionReminder(String uid, String actionId) async {
    await _userDoc(
      uid,
    ).update({_actionReminderPath(actionId): FieldValue.delete()});
  }

  FieldPath _actionReminderPath(String actionId) => FieldPath([
    AppConstants.fieldSettings,
    AppConstants.fieldActionReminders,
    actionId,
  ]);

  /// Updates the language preference.
  Future<void> setLanguage(String uid, String language) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldLanguage}': language,
      AppConstants.fieldLanguage: language,
    });
  }

  /// Writes [language] to an account that never chose one. A transaction
  /// reads the server copy, so offline it throws rather than guess.
  Future<void> backfillLanguage(String uid, String language) {
    return _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(_userDoc(uid));
      final settings = doc.data()?[AppConstants.fieldSettings];
      if (!doc.exists ||
          (settings is Map && settings[AppConstants.fieldLanguage] != null)) {
        return;
      }
      transaction.update(_userDoc(uid), {
        '${AppConstants.fieldSettings}.${AppConstants.fieldLanguage}': language,
        AppConstants.fieldLanguage: language,
      });
    });
  }

  /// Updates the theme preference (a [ThemeMode] name).
  Future<void> setThemeMode(String uid, String themeMode) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldThemeMode}': themeMode,
    });
  }

  /// Enables or disables analytics and crashlytics collection.
  Future<void> setAnalyticsEnabled(String uid, {required bool enabled}) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldAnalyticsEnabled}':
          enabled,
    });
  }

  /// Records a walkthrough item as found.
  Future<void> markWalkthroughFound(String uid, String itemId) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldWalkthroughFound}':
          FieldValue.arrayUnion([itemId]),
    });
  }

  /// Forgets every found walkthrough item so the tour replays.
  Future<void> resetWalkthrough(String uid) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldWalkthroughFound}':
          <String>[],
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
}
