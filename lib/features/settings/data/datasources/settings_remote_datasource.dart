import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
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
    final settingsData = data['settings'] as Map<String, dynamic>?;

    if (settingsData == null) {
      // Return default settings with user's language preference
      final language = data['language'] as String? ?? 'en';
      return UserSettingsModel.defaultSettings(language: language);
    }

    return UserSettingsModel.fromJson(settingsData);
  }

  @override
  Future<void> updateSettings(String uid, UserSettingsModel settings) async {
    await _userDoc(uid).update({
      'settings': settings.toJson(),
      // Also update top-level language for backwards compatibility
      'language': settings.language,
    });
  }

  @override
  Stream<UserSettingsModel> watchSettings(String uid) {
    return _userDoc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return UserSettingsModel.defaultSettings();
      }

      final data = doc.data()!;
      final settingsData = data['settings'] as Map<String, dynamic>?;

      if (settingsData == null) {
        final language = data['language'] as String? ?? 'en';
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
      'settings.reminderSchedules': FieldValue.arrayUnion([schedule.toJson()]),
    });
  }

  @override
  Future<void> removeReminderSchedule(String uid, String scheduleId) async {
    // First get current schedules, then filter and update
    final doc = await _userDoc(uid).get();
    final data = doc.data();
    if (data == null) return;

    final settingsData = data['settings'] as Map<String, dynamic>?;
    if (settingsData == null) return;

    final schedules = (settingsData['reminderSchedules'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    final updatedSchedules =
        schedules.where((s) => s['id'] != scheduleId).toList();

    await _userDoc(uid).update({
      'settings.reminderSchedules': updatedSchedules,
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

    final settingsData = data['settings'] as Map<String, dynamic>?;
    if (settingsData == null) return;

    final schedules = (settingsData['reminderSchedules'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    final updatedSchedules = schedules.map((s) {
      if (s['id'] == scheduleId) {
        return {...s, ...updates};
      }
      return s;
    }).toList();

    await _userDoc(uid).update({
      'settings.reminderSchedules': updatedSchedules,
    });
  }

  @override
  Future<void> updateNotificationsEnabled(
    String uid, {
    required bool enabled,
  }) async {
    await _userDoc(uid).update({
      'settings.notificationsEnabled': enabled,
      // Also update top-level field for backwards compatibility
      'notificationsEnabled': enabled,
    });
  }

  @override
  Future<void> updateSmartRemindersEnabled(
    String uid, {
    required bool enabled,
  }) async {
    await _userDoc(uid).update({
      'settings.smartRemindersEnabled': enabled,
    });
  }

  @override
  Future<void> updateLanguage(String uid, String language) async {
    await _userDoc(uid).update({
      'settings.language': language,
      // Also update top-level field for backwards compatibility
      'language': language,
    });
  }

  @override
  Future<void> updateAnalyticsEnabled(
    String uid, {
    required bool enabled,
  }) async {
    await _userDoc(uid).update({
      'settings.analyticsEnabled': enabled,
    });
  }

  @override
  Future<void> markMilestoneSeen(String uid, int weekNumber) async {
    await _userDoc(uid).update({
      'settings.seenStreakMilestones.$weekNumber': true,
    });
  }
}
