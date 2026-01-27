import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/actions/actions.dart';
import '../../features/auth/auth.dart';
import '../../features/settings/settings.dart';
import '../services/services.dart';

part 'notification_providers.g.dart';

/// Provider for the NotificationService singleton.
@riverpod
NotificationService notificationService(Ref ref) {
  return NotificationService.instance;
}

/// Provider for the FCMService singleton.
@riverpod
FCMService fcmService(Ref ref) {
  return FCMService.instance;
}

/// Provider that manages notification scheduling based on user settings.
///
/// This watches user settings and reschedules notifications when they change.
@riverpod
class NotificationScheduler extends _$NotificationScheduler {
  @override
  Future<void> build() async {
    // Watch for settings changes
    final settings = ref.watch(userSettingsProvider).value;
    if (settings == null) return;

    final notificationService = ref.read(notificationServiceProvider);

    // Cancel all existing notifications first
    await notificationService.cancelAllNotifications();

    // If notifications are disabled, don't schedule any
    if (!settings.notificationsEnabled) return;

    // Schedule notifications for each enabled reminder
    for (final reminder in settings.reminderSchedules) {
      if (!reminder.isEnabled) continue;

      await notificationService.scheduleDailyNotification(
        id: reminder.id.hashCode,
        hour: reminder.hour,
        minute: reminder.minute,
        title: 'Time to make an impact!',
        body: 'Log a sustainable action and grow your mascot.',
        payload: 'daily_reminder',
      );
    }
  }

  /// Reschedule all notifications (called after settings change).
  Future<void> reschedule() async {
    ref.invalidateSelf();
  }
}

/// Provider that checks if smart reminder should fire.
///
/// Returns true if the user hasn't logged an action today.
@riverpod
Future<bool> shouldShowSmartReminder(Ref ref) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return false;

  final settings = ref.watch(userSettingsProvider).value;
  if (settings == null) return false;

  // If smart reminders are disabled, always show
  if (!settings.smartRemindersEnabled) return true;

  // Check if user has logged an action today
  final todayActions = await ref.watch(todayActionsProvider.future);
  return todayActions.isEmpty;
}

/// Provider that handles FCM token registration.
///
/// Watches auth state and updates FCM token when user logs in.
@riverpod
class FCMTokenManager extends _$FCMTokenManager {
  @override
  Future<void> build() async {
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return;

    final fcmService = ref.read(fcmServiceProvider);

    // Get and store the current token
    final token = await fcmService.getToken();
    if (token != null) {
      // Token is automatically stored by FCMService._storeToken
    }
  }
}

/// Provider for checking notification permission status.
@riverpod
Future<bool> notificationPermissionStatus(Ref ref) async {
  final notificationService = ref.read(notificationServiceProvider);
  return notificationService.checkPermissions();
}

/// Provider for FCM authorization status.
@riverpod
Future<AuthorizationStatus> fcmAuthorizationStatus(Ref ref) async {
  final fcmService = ref.read(fcmServiceProvider);
  return fcmService.requestPermissions();
}
