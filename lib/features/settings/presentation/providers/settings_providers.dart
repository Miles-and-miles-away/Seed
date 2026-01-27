import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/settings_remote_datasource.dart';
import '../../data/models/notification_schedule_model.dart';
import '../../data/models/user_settings_model.dart';
import '../../data/repositories/settings_repository.dart';

part 'settings_providers.g.dart';

// =============================================================================
// Data Source Provider
// =============================================================================

@riverpod
SettingsRemoteDataSource settingsRemoteDataSource(Ref ref) {
  return SettingsRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
  );
}

// =============================================================================
// Repository Provider
// =============================================================================

@riverpod
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(
    dataSource: ref.watch(settingsRemoteDataSourceProvider),
  );
}

// =============================================================================
// Settings State Providers
// =============================================================================

/// Stream of the current user's settings.
/// Returns default settings if no settings are found.
@riverpod
Stream<UserSettingsModel> userSettings(Ref ref) {
  final currentUser = ref.watch(currentUserProvider);

  return currentUser.when(
    data: (user) {
      if (user == null) {
        return Stream.value(UserSettingsModel.defaultSettings());
      }
      return ref.watch(settingsRepositoryProvider).watchSettings(user.uid);
    },
    loading: () => Stream.value(UserSettingsModel.defaultSettings()),
    error: (_, __) => Stream.value(UserSettingsModel.defaultSettings()),
  );
}

/// Returns the list of enabled reminder schedules.
@riverpod
List<NotificationScheduleModel> enabledReminders(Ref ref) {
  final settings = ref.watch(userSettingsProvider);
  return settings.when(
    data: (s) => s.enabledReminders,
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Returns whether the user can add more reminders.
@riverpod
bool canAddReminder(Ref ref) {
  final settings = ref.watch(userSettingsProvider);
  return settings.when(
    data: (s) => s.canAddReminder,
    loading: () => false,
    error: (_, __) => false,
  );
}

/// Returns the current language setting.
@riverpod
String currentLanguage(Ref ref) {
  final settings = ref.watch(userSettingsProvider);
  return settings.when(
    data: (s) => s.language,
    loading: () => 'en',
    error: (_, __) => 'en',
  );
}

/// Returns whether notifications are enabled.
@riverpod
bool notificationsEnabled(Ref ref) {
  final settings = ref.watch(userSettingsProvider);
  return settings.when(
    data: (s) => s.notificationsEnabled,
    loading: () => true,
    error: (_, __) => true,
  );
}

/// Returns whether smart reminders are enabled.
@riverpod
bool smartRemindersEnabled(Ref ref) {
  final settings = ref.watch(userSettingsProvider);
  return settings.when(
    data: (s) => s.smartRemindersEnabled,
    loading: () => true,
    error: (_, __) => true,
  );
}

/// Returns the current app locale based on user settings.
/// Falls back to English if no setting is found.
@riverpod
Locale appLocale(Ref ref) {
  final language = ref.watch(currentLanguageProvider);
  return Locale(language);
}

// =============================================================================
// Settings Notifier - Handles Settings Actions
// =============================================================================

/// Notifier that handles settings mutations.
/// Uses AsyncValue to track loading and error states.
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  String? get _currentUserId {
    final currentUser = ref.read(currentUserProvider);
    return currentUser.value?.uid;
  }

  /// Toggles notifications on/off.
  Future<void> toggleNotifications({required bool enabled}) async {
    final uid = _currentUserId;
    if (uid == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref
          .read(settingsRepositoryProvider)
          .setNotificationsEnabled(uid, enabled: enabled);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Toggles smart reminders on/off.
  Future<void> toggleSmartReminders({required bool enabled}) async {
    final uid = _currentUserId;
    if (uid == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref
          .read(settingsRepositoryProvider)
          .setSmartRemindersEnabled(uid, enabled: enabled);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Updates the language preference.
  Future<void> updateLanguage(String language) async {
    final uid = _currentUserId;
    if (uid == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(settingsRepositoryProvider).setLanguage(uid, language);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Adds a new reminder at the specified time.
  /// Returns the created schedule, or null if max reminders reached.
  Future<NotificationScheduleModel?> addReminder(
    TimeOfDay time, {
    String? label,
  }) async {
    final uid = _currentUserId;
    if (uid == null) return null;

    state = const AsyncValue.loading();
    NotificationScheduleModel? schedule;

    final result = await AsyncValue.guard(() async {
      schedule = await ref
          .read(settingsRepositoryProvider)
          .addReminder(uid, time: time, label: label);
    });

    if (!ref.mounted) return null;
    state = result;
    return schedule;
  }

  /// Removes a reminder by its ID.
  Future<void> removeReminder(String scheduleId) async {
    final uid = _currentUserId;
    if (uid == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(settingsRepositoryProvider).removeReminder(uid, scheduleId);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Updates a reminder's time.
  Future<void> updateReminderTime(String scheduleId, TimeOfDay time) async {
    final uid = _currentUserId;
    if (uid == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref
          .read(settingsRepositoryProvider)
          .updateReminderTime(uid, scheduleId, time);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Toggles a specific reminder on/off.
  Future<void> toggleReminder(String scheduleId, {required bool enabled}) async {
    final uid = _currentUserId;
    if (uid == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref
          .read(settingsRepositoryProvider)
          .setReminderEnabled(uid, scheduleId, enabled: enabled);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Updates a reminder's label.
  Future<void> updateReminderLabel(String scheduleId, String label) async {
    final uid = _currentUserId;
    if (uid == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref
          .read(settingsRepositoryProvider)
          .updateReminderLabel(uid, scheduleId, label);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Marks a streak milestone as seen.
  Future<void> markMilestoneSeen(int weekNumber) async {
    final uid = _currentUserId;
    if (uid == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref
          .read(settingsRepositoryProvider)
          .markMilestoneSeen(uid, weekNumber);
    });
    if (!ref.mounted) return;
    state = result;
  }
}
