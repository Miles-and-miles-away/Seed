import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import '../models/notification_schedule_model.dart';
import '../models/user_settings_model.dart';

/// Interface for Firestore settings operations.
abstract class SettingsRemoteDataSource {
  /// Gets user settings from the user document.
  Future<UserSettingsModel> getSettings(String uid);

  /// Updates user settings in the user document.
  Future<void> updateSettings(String uid, UserSettingsModel settings);

  /// Watches user settings for real-time updates.
  Stream<UserSettingsModel> watchSettings(String uid);

  /// Adds a new reminder schedule.
  Future<void> addReminderSchedule(
    String uid,
    NotificationScheduleModel schedule,
  );

  /// Removes a reminder schedule by ID.
  Future<void> removeReminderSchedule(String uid, String scheduleId);

  /// Updates a specific reminder schedule.
  Future<void> updateReminderSchedule(
    String uid,
    String scheduleId,
    Map<String, dynamic> updates,
  );

  /// Updates the notifications enabled flag.
  Future<void> updateNotificationsEnabled(String uid, {required bool enabled});

  /// Updates the smart reminders flag.
  Future<void> updateSmartRemindersEnabled(String uid, {required bool enabled});

  /// Updates the language preference.
  Future<void> updateLanguage(String uid, String language);

  /// Updates the analytics enabled flag.
  Future<void> updateAnalyticsEnabled(
    String uid, {
    required bool enabled,
  });

  /// Marks a streak milestone as seen.
  Future<void> markMilestoneSeen(String uid, int weekNumber);
}

/// Implementation of [SettingsRemoteDataSource] using Cloud Firestore.
///
/// Settings are stored as a nested object within the user document
/// at the 'settings' field, rather than a separate subcollection.
class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  SettingsRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection(AppConstants.collectionUsers);

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _usersCollection.doc(uid);

  @override
  Future<UserSettingsModel> getSettings(String uid) async {
    final doc = await _userDoc(uid).get();
    if (!doc.exists || doc.data() == null) {
      return UserSettingsModel.defaultSettings();
    }

    final data = doc.data()!;
    final settingsData =
        data[AppConstants.fieldSettings] as Map<String, dynamic>?;

    if (settingsData == null) {
      // Return default settings with user's language preference
      final language = data[AppConstants.fieldLanguage] as String? ?? 'en';
      return UserSettingsModel.defaultSettings(language: language);
    }

    return UserSettingsModel.fromJson(settingsData);
  }

  @override
  Future<void> updateSettings(String uid, UserSettingsModel settings) async {
    await _userDoc(uid).update({
      AppConstants.fieldSettings: settings.toJson(),
      AppConstants.fieldLanguage: settings.language,
    });
  }

  @override
  Stream<UserSettingsModel> watchSettings(String uid) {
    return _userDoc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return UserSettingsModel.defaultSettings();
      }

      final data = doc.data()!;
      final settingsData =
          data[AppConstants.fieldSettings] as Map<String, dynamic>?;

      if (settingsData == null) {
        final language = data[AppConstants.fieldLanguage] as String? ?? 'en';
        return UserSettingsModel.defaultSettings(language: language);
      }

      return UserSettingsModel.fromJson(settingsData);
    });
  }

  @override
  Future<void> addReminderSchedule(
    String uid,
    NotificationScheduleModel schedule,
  ) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldReminderSchedules}':
          FieldValue.arrayUnion([schedule.toJson()]),
    });
  }

  @override
  Future<void> removeReminderSchedule(String uid, String scheduleId) async {
    // First get current schedules, then filter and update
    final doc = await _userDoc(uid).get();
    final data = doc.data();
    if (data == null) return;

    final settingsData =
        data[AppConstants.fieldSettings] as Map<String, dynamic>?;
    if (settingsData == null) return;

    final schedules =
        (settingsData[AppConstants.fieldReminderSchedules] as List<dynamic>?)
                ?.cast<Map<String, dynamic>>() ??
            [];

    final updatedSchedules =
        schedules.where((s) => s[AppConstants.fieldId] != scheduleId).toList();

    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldReminderSchedules}':
          updatedSchedules,
    });
  }

  @override
  Future<void> updateReminderSchedule(
    String uid,
    String scheduleId,
    Map<String, dynamic> updates,
  ) async {
    // Get current schedules, update the matching one, and save
    final doc = await _userDoc(uid).get();
    final data = doc.data();
    if (data == null) return;

    final settingsData =
        data[AppConstants.fieldSettings] as Map<String, dynamic>?;
    if (settingsData == null) return;

    final schedules =
        (settingsData[AppConstants.fieldReminderSchedules] as List<dynamic>?)
                ?.cast<Map<String, dynamic>>() ??
            [];

    final updatedSchedules = schedules.map((s) {
      if (s[AppConstants.fieldId] == scheduleId) {
        return {...s, ...updates};
      }
      return s;
    }).toList();

    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldReminderSchedules}':
          updatedSchedules,
    });
  }

  @override
  Future<void> updateNotificationsEnabled(
    String uid, {
    required bool enabled,
  }) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldNotificationsEnabled}':
          enabled,
      AppConstants.fieldNotificationsEnabled: enabled,
    });
  }

  @override
  Future<void> updateSmartRemindersEnabled(
    String uid, {
    required bool enabled,
  }) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldSmartRemindersEnabled}':
          enabled,
    });
  }

  @override
  Future<void> updateLanguage(String uid, String language) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldLanguage}': language,
      AppConstants.fieldLanguage: language,
    });
  }

  @override
  Future<void> updateAnalyticsEnabled(
    String uid, {
    required bool enabled,
  }) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}.${AppConstants.fieldAnalyticsEnabled}':
          enabled,
    });
  }

  @override
  Future<void> markMilestoneSeen(String uid, int weekNumber) async {
    await _userDoc(uid).update({
      '${AppConstants.fieldSettings}'
          '.${AppConstants.fieldSeenStreakMilestones}'
          '.$weekNumber': true,
    });
  }
}
