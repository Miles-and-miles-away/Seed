import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/app_logger.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/auth.dart';
import 'package:seed_app/features/challenge/challenge.dart';
import 'package:seed_app/features/settings/settings.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';
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

/// Every instant at [hour]:[minute] after [now] on one of [weekdays]
/// ([DateTime.weekday] values), soonest first.
Iterable<DateTime> reminderDays({
  required DateTime now,
  required int hour,
  required int minute,
  List<int> weekdays = const [1, 2, 3, 4, 5, 6, 7],
}) sync* {
  // Without a real weekday the loop would never yield.
  final days = weekdays.where(
    (d) => d >= DateTime.monday && d <= DateTime.sunday,
  );
  if (days.isEmpty) return;
  for (var day = 0; ; day++) {
    final time = DateTime(now.year, now.month, now.day + day, hour, minute);
    if (time.isAfter(now) && days.contains(time.weekday)) yield time;
  }
}

/// The next [count] daily challenge reminders at [time] after [now],
/// skipping today once its challenge is [doneToday].
List<DateTime> reminderTimes({
  required DateTime now,
  required TimeOfDay time,
  required bool doneToday,
  int count = AppConstants.reminderDaysAhead,
}) => reminderDays(
  now: now,
  hour: time.hour,
  minute: time.minute,
).where((t) => !doneToday || !isSameCalendarDay(t, now)).take(count).toList();

/// The days of [reminder] within [AppConstants.reminderDaysAhead] of
/// [now], skipping today once its action is [doneToday].
List<DateTime> actionReminderTimes(
  ActionReminder reminder, {
  required DateTime now,
  required bool doneToday,
}) {
  final end = DateTime(
    now.year,
    now.month,
    now.day + AppConstants.reminderDaysAhead,
  );
  return reminderDays(
        now: now,
        hour: reminder.hour,
        minute: reminder.minute,
        weekdays: reminder.weekdays,
      )
      .takeWhile((t) => t.isBefore(end) && reminder.coversDay(t))
      .where((t) => !doneToday || !isSameCalendarDay(t, now))
      .toList();
}

/// Keeps the pending reminders in step with the settings, today's
/// challenge and logs, and the app language. Kept alive from SeedApp,
/// and rebuilt on resume in case the time zone changed.
///
/// The daily challenge reminders come first; action reminders fill what
/// is left of the OS limit, soonest first, so many of them reach fewer
/// days ahead.
@Riverpod(keepAlive: true)
Future<void> reminderScheduler(Ref ref) async {
  final listener = AppLifecycleListener(onResume: ref.invalidateSelf);
  ref.onDispose(listener.dispose);
  // Loading or failing reads as disabled; keep the queue, never cancel it.
  if (ref.watch(
    userSettingsProvider.select((s) => s.isLoading || s.hasError),
  )) {
    return;
  }
  final now = ref.read(clockProvider)();
  final l10n = lookupAppLocalizations(ref.watch(appLocaleProvider));
  final challengeOn = ref.watch(notificationsEnabledProvider);
  // Until the user loads, today's challenge reads as not done.
  if (challengeOn &&
      ref.watch(currentUserProvider.select((user) => user.isLoading))) {
    return;
  }
  final reminders = <Reminder>[
    if (challengeOn)
      for (final time in reminderTimes(
        now: now,
        time: ref.watch(reminderTimeProvider),
        doneToday: ref.watch(isTodayChallengeCompletedProvider),
      ))
        (
          time: time,
          title: l10n.notifReminderTitle,
          body: l10n.notifReminderBody,
          channelId: NotificationService.challengeChannelId,
          payload: null,
        ),
  ];

  final actionReminders = ref.watch(actionRemindersEnabledProvider)
      ? ref.watch(actionRemindersProvider)
      : const <String, ActionReminder>{};
  if (actionReminders.isNotEmpty) {
    final library = ref.watch(actionLibraryProvider);
    final today = ref.watch(todayActionsProvider);
    if (library.isLoading || library.hasError || today.isLoading) return;
    final logged = {...?today.value?.map((log) => log.actionId)};
    final actions = {for (final a in library.value ?? <ActionModel>[]) a.id: a};
    final language = ref.watch(currentLanguageProvider);
    final actionTimes = <Reminder>[
      for (final MapEntry(key: id, value: reminder) in actionReminders.entries)
        if (actions[id] case final action?)
          for (final time in actionReminderTimes(
            reminder,
            now: now,
            doneToday: logged.contains(id),
          ))
            (
              time: time,
              title: action.name(language),
              body: l10n.notifActionReminderBody,
              channelId: NotificationService.actionChannelId,
              payload: appRoutes.actionLogForAction(
                action.category,
                id,
                log: true,
              ),
            ),
    ]..sort((a, b) => a.time.compareTo(b.time));
    reminders.addAll(
      actionTimes.take(AppConstants.maxPendingNotifications - reminders.length),
    );
  }

  try {
    await ref
        .read(notificationServiceProvider)
        .scheduleReminders(
          reminders,
          channels: {
            NotificationService.challengeChannelId: (
              name: l10n.notifDailyReminder,
              description: l10n.notifDailyReminderSubtitle,
            ),
            NotificationService.actionChannelId: (
              name: l10n.notifActionReminders,
              description: l10n.notifActionRemindersSubtitle,
            ),
          },
        );
  } on Object catch (e, stack) {
    appLogger.error('Reminder scheduling failed', error: e, stackTrace: stack);
  }
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

    // FCMService persists the token itself; only the fetch is needed here.
    await fcmService.getToken();
  }
}

/// Whether the OS lets this app post notifications, rechecked on
/// resume since the user changes it in the OS settings.
@riverpod
Future<bool> notificationPermissionStatus(Ref ref) {
  final listener = AppLifecycleListener(onResume: ref.invalidateSelf);
  ref.onDispose(listener.dispose);
  return ref.read(notificationServiceProvider).checkPermissions();
}

/// Provider for FCM authorization status.
@riverpod
Future<AuthorizationStatus> fcmAuthorizationStatus(Ref ref) async {
  final fcmService = ref.read(fcmServiceProvider);
  return fcmService.requestPermissions();
}
