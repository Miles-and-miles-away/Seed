import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/settings/data/models/action_reminder_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/data/repositories/settings_repository.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/providers/app_language_provider.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';
import 'package:seed_app/shared/providers/notification_providers.dart';

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

/// The app language: the account's choice, else this device's pick,
/// else the OS language. Computed, never stored. On Android 13+ the app
/// owns its per-app locale, so an OS-side change made after the last
/// pick is the user editing this app's language and wins on that device.
/// Elsewhere an OS change is the whole device and never overrides a pick.
@riverpod
String currentLanguage(Ref ref) {
  final os = resolveOsLanguage(ref.watch(osLocalesProvider));
  final stored = ref.watch(deviceLanguageProvider).pick;
  final perApp =
      (ref.watch(androidSdkProvider).value ?? 0) >= perAppLocaleMinSdk;
  if (perApp && stored != null && os != stored.os) return os;
  final account = ref.watch(userIdProvider) == null
      ? null
      : ref.watch(pendingLanguagePushProvider) ??
            _setting(ref, (s) => s.language, null);
  return account ?? stored?.language ?? os;
}

/// Returns whether the daily reminder is enabled.
@riverpod
bool notificationsEnabled(Ref ref) =>
    _setting(ref, (s) => s.notificationsEnabled, false);

/// The daily reminder time.
@riverpod
TimeOfDay reminderTime(Ref ref) => _setting(
  ref,
  (s) => TimeOfDay(hour: s.reminderHour, minute: s.reminderMinute),
  const TimeOfDay(
    hour: AppConstants.defaultReminderHour,
    minute: AppConstants.defaultReminderMinute,
  ),
);

/// Whether action reminders are switched on.
@riverpod
bool actionRemindersEnabled(Ref ref) =>
    _setting(ref, (s) => s.actionRemindersEnabled, false);

/// Action reminders with a reminder still to come, by action id; once
/// the library loads, only those for actions it still has.
@riverpod
Map<String, ActionReminder> actionReminders(Ref ref) {
  final now = ref.watch(clockProvider)();
  final library = ref.watch(actionLibraryProvider).value;
  final ids = library == null ? null : {for (final a in library) a.id};
  return _setting(
    ref,
    (s) => {
      for (final MapEntry(key: id, value: reminder)
          in s.actionReminders.entries)
        if (_hasNext(reminder, now) && (ids?.contains(id) ?? true))
          id: reminder,
    },
    const {},
  );
}

bool _hasNext(ActionReminder reminder, DateTime now) {
  final next = reminderDays(
    now: now,
    hour: reminder.hour,
    minute: reminder.minute,
    weekdays: reminder.weekdays,
  ).firstOrNull;
  return next != null && reminder.coversDay(next);
}

/// Returns whether analytics collection is enabled.
@riverpod
bool analyticsEnabled(Ref ref) =>
    _setting(ref, (s) => s.analyticsEnabled, true);

/// Walkthrough item ids the user has found, or null while signed out or
/// until settings load, so nothing shimmers or pops on a guess.
@riverpod
Set<String>? walkthroughFound(Ref ref) {
  if (ref.watch(userIdProvider) == null) return null;
  return _setting(ref, (s) => s.walkthroughFound.toSet(), null);
}

/// Returns the preferred theme mode, defaulting to the system setting.
@riverpod
ThemeMode themeMode(Ref ref) {
  final name = _setting(ref, (s) => s.themeMode, ThemeMode.system.name);
  return ThemeMode.values.asNameMap()[name] ?? ThemeMode.system;
}

/// The app locale for [currentLanguageProvider].
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

  /// Asks the OS for notification permission; true once granted.
  Future<bool> _permitted() async {
    final status = await ref.read(fcmServiceProvider).requestPermissions();
    if (!ref.mounted) return false;
    ref.invalidate(notificationPermissionStatusProvider);
    return status == AuthorizationStatus.authorized ||
        status == AuthorizationStatus.provisional;
  }

  /// Toggles the daily reminder on/off.
  ///
  /// Turning on requests OS notification permission first and returns
  /// false, leaving the setting off, when the OS refuses.
  Future<bool> toggleNotifications({required bool enabled}) async {
    if (enabled && !await _permitted()) return false;
    // Not awaited: offline the write completes only on server ack.
    unawaited(
      _write((uid, repo) async {
        await repo.setNotificationsEnabled(uid, enabled: enabled);

        final analytics = ref.read(analyticsServiceProvider);
        if (enabled) {
          await analytics.logNotificationEnabled();
        } else {
          await analytics.logNotificationDisabled();
        }
      }),
    );
    return true;
  }

  /// Toggles action reminders, like [toggleNotifications].
  Future<bool> toggleActionReminders({required bool enabled}) async {
    if (enabled && !await _permitted()) return false;
    unawaited(
      _write(
        (uid, repo) => repo.setActionRemindersEnabled(uid, enabled: enabled),
      ),
    );
    return true;
  }

  /// Saves the reminder for [actionId], switching action reminders on
  /// when [enable] is set and the OS allows notifications. Returns false
  /// when it refuses; the reminder is kept for when the user allows them.
  Future<bool> saveActionReminder(
    String actionId,
    ActionReminder reminder, {
    required bool enable,
  }) async {
    final permitted = await _permitted();
    unawaited(
      _write(
        (uid, repo) => repo.setActionReminder(
          uid,
          actionId,
          reminder,
          enable: enable && permitted,
        ),
      ),
    );
    return permitted;
  }

  /// Deletes the reminder for [actionId].
  Future<void> deleteActionReminder(String actionId) =>
      _write((uid, repo) => repo.deleteActionReminder(uid, actionId));

  /// Toggles analytics and crashlytics collection.
  Future<void> toggleAnalytics({required bool enabled}) {
    return _write((uid, repo) async {
      await repo.setAnalyticsEnabled(uid, enabled: enabled);
      final analytics = ref.read(analyticsServiceProvider);
      await analytics.setCollectionEnabled(enabled: enabled);
      await ref
          .read(crashlyticsProvider)
          .setCrashlyticsCollectionEnabled(enabled);
      analytics.setEnabled(enabled: enabled);
    });
  }

  /// Updates the account's language.
  Future<void> updateLanguage(String language) =>
      _write((uid, repo) => repo.setLanguage(uid, language));

  /// Updates the theme preference.
  Future<void> updateThemeMode(ThemeMode mode) =>
      _write((uid, repo) => repo.setThemeMode(uid, mode.name));

  /// Sets the daily reminder time.
  Future<void> updateReminderTime(TimeOfDay time) =>
      _write((uid, repo) => repo.setReminderTime(uid, time));

  /// Marks a streak milestone as seen.
  Future<void> markMilestoneSeen(int weekNumber) =>
      _write((uid, repo) => repo.markMilestoneSeen(uid, weekNumber));

  /// Records a walkthrough item as found.
  Future<void> markWalkthroughFound(String itemId) =>
      _write((uid, repo) => repo.markWalkthroughFound(uid, itemId));

  /// Replays the walkthrough from the start.
  Future<void> resetWalkthrough() => _write((uid, repo) async {
    await repo.resetWalkthrough(uid);
    await ref.read(analyticsServiceProvider).logWalkthroughReset();
  });
}
