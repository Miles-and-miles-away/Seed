import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/settings/data/models/notification_schedule_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/data/repositories/settings_repository.dart';
import 'package:seed_app/shared/services/analytics_service.dart';

part 'settings_providers.g.dart';

// =============================================================================
// Repository Provider
// =============================================================================

@riverpod
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(firestore: ref.watch(firestoreProvider));
}

// =============================================================================
// Settings State Providers
// =============================================================================

/// Stream of the current user's settings.
/// Returns default settings if no settings are found.
///
/// Keyed on the user id (not the whole user document) so the settings
/// listener survives unrelated user-doc writes.
@riverpod
Stream<UserSettingsModel> userSettings(Ref ref) {
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
    return Stream.value(UserSettingsModel.defaultSettings());
  }
  return ref.watch(settingsRepositoryProvider).watchSettings(userId);
}

/// One field of the current settings, or [fallback] while loading or on error.
T _setting<T>(Ref ref, T Function(UserSettingsModel) pick, T fallback) {
  return ref
      .watch(userSettingsProvider)
      .when(data: pick, loading: () => fallback, error: (_, _) => fallback);
}

/// Returns whether the user can add more reminders.
@riverpod
bool canAddReminder(Ref ref) => _setting(ref, (s) => s.canAddReminder, false);

/// Returns the current language setting.
@riverpod
String currentLanguage(Ref ref) => _setting(ref, (s) => s.language, 'en');

/// Returns whether notifications are enabled.
@riverpod
bool notificationsEnabled(Ref ref) =>
    _setting(ref, (s) => s.notificationsEnabled, true);

/// Returns whether smart reminders are enabled.
@riverpod
bool smartRemindersEnabled(Ref ref) =>
    _setting(ref, (s) => s.smartRemindersEnabled, true);

/// Returns whether analytics collection is enabled.
@riverpod
bool analyticsEnabled(Ref ref) =>
    _setting(ref, (s) => s.analyticsEnabled, true);

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
@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  String? get _currentUserId {
    final currentUser = ref.read(currentUserProvider);
    return currentUser.value?.uid;
  }

  /// Runs [op] for the signed-in user, tracking it in [state].
  Future<void> _write(
    Future<void> Function(String uid, SettingsRepository repo) op,
  ) async {
    final uid = _currentUserId;
    if (uid == null) {
      state = AsyncValue.error(Exception('Not logged in'), StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => op(uid, ref.read(settingsRepositoryProvider)),
    );
    if (!ref.mounted) return;
    state = result;
  }

  /// Toggles notifications on/off.
  Future<void> toggleNotifications({required bool enabled}) {
    return _write((uid, repo) async {
      await repo.setNotificationsEnabled(uid, enabled: enabled);

      // Track analytics
      if (enabled) {
        await AnalyticsService.instance.logNotificationEnabled();
      } else {
        await AnalyticsService.instance.logNotificationDisabled();
      }
    });
  }

  /// Toggles analytics and crashlytics collection.
  Future<void> toggleAnalytics({required bool enabled}) {
    return _write((uid, repo) async {
      await repo.setAnalyticsEnabled(uid, enabled: enabled);
      await AnalyticsService.instance.setCollectionEnabled(enabled: enabled);
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        enabled,
      );
      AnalyticsService.instance.setEnabled(enabled: enabled);
    });
  }

  /// Toggles smart reminders on/off.
  Future<void> toggleSmartReminders({required bool enabled}) => _write(
    (uid, repo) => repo.setSmartRemindersEnabled(uid, enabled: enabled),
  );

  /// Updates the language preference.
  Future<void> updateLanguage(String language) {
    return _write((uid, repo) async {
      await repo.setLanguage(uid, language);
      await AnalyticsService.instance.logLanguageChanged(language: language);
    });
  }

  /// Adds a new reminder at the specified time.
  /// Returns the created schedule, or null if max reminders reached.
  Future<NotificationScheduleModel?> addReminder(
    TimeOfDay time, {
    String? label,
  }) async {
    final uid = _currentUserId;
    if (uid == null) {
      state = AsyncValue.error(Exception('Not logged in'), StackTrace.current);
      return null;
    }

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
  Future<void> removeReminder(String scheduleId) =>
      _write((uid, repo) => repo.removeReminder(uid, scheduleId));

  /// Updates a reminder's time.
  Future<void> updateReminderTime(String scheduleId, TimeOfDay time) =>
      _write((uid, repo) => repo.updateReminderTime(uid, scheduleId, time));

  /// Toggles a specific reminder on/off.
  Future<void> toggleReminder(String scheduleId, {required bool enabled}) =>
      _write(
        (uid, repo) =>
            repo.setReminderEnabled(uid, scheduleId, enabled: enabled),
      );

  /// Updates a reminder's label.
  Future<void> updateReminderLabel(String scheduleId, String label) =>
      _write((uid, repo) => repo.updateReminderLabel(uid, scheduleId, label));

  /// Marks a streak milestone as seen.
  Future<void> markMilestoneSeen(int weekNumber) =>
      _write((uid, repo) => repo.markMilestoneSeen(uid, weekNumber));
}
