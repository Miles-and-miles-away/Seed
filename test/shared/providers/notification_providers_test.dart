import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/challenge.dart';
import 'package:seed_app/features/settings/data/models/action_reminder_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';
import 'package:seed_app/shared/providers/notification_providers.dart';
import 'package:seed_app/shared/services/notification_service.dart';

import '../../helpers/test_helpers.dart';

const _six = TimeOfDay(hour: 18, minute: 0);

const _bag = ActionModel(
  id: 'bag',
  nameEn: 'Bring a bag',
  nameJa: 'バッグを持参',
  category: 'waste',
  points: 5,
);

const _daily = ActionReminder(
  hour: 12,
  minute: 0,
  weekdays: [1, 2, 3, 4, 5, 6, 7],
);

class _RecordingNotifications extends Fake implements NotificationService {
  final calls = <List<Reminder>>[];

  @override
  Future<void> scheduleReminders(
    List<Reminder> reminders, {
    required Map<String, ReminderChannel> channels,
  }) async => calls.add(reminders);
}

Stream<T> _pending<T>() => StreamController<T>().stream;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('reminderTimes', () {
    test('starts today when the challenge is open and time ahead', () {
      final times = reminderTimes(
        now: DateTime(2026, 11, 7, 9),
        time: _six,
        doneToday: false,
      );

      expect(times, hasLength(AppConstants.reminderDaysAhead));
      expect(times.first, DateTime(2026, 11, 7, 18));
      expect(times[1], DateTime(2026, 11, 8, 18));
    });

    test('starts tomorrow once the time has passed', () {
      final times = reminderTimes(
        now: DateTime(2026, 11, 7, 19),
        time: _six,
        doneToday: false,
      );

      expect(times, hasLength(AppConstants.reminderDaysAhead));
      expect(times.first, DateTime(2026, 11, 8, 18));
    });

    test('skips today once the challenge is done', () {
      final times = reminderTimes(
        now: DateTime(2026, 11, 7, 9),
        time: _six,
        doneToday: true,
      );

      expect(times, hasLength(AppConstants.reminderDaysAhead));
      expect(times.first, DateTime(2026, 11, 8, 18));
    });

    test('rolls over month and year ends', () {
      final times = reminderTimes(
        now: DateTime(2026, 12, 31, 20),
        time: _six,
        doneToday: false,
        count: 2,
      );

      expect(times, [DateTime(2027, 1, 1, 18), DateTime(2027, 1, 2, 18)]);
    });
  });

  group('actionReminderTimes', () {
    // A Saturday.
    final now = DateTime(2026, 11, 7, 9);

    test('fires on its weekdays within the queued days', () {
      final times = actionReminderTimes(
        const ActionReminder(hour: 18, minute: 0, weekdays: [1, 3]),
        now: now,
        doneToday: false,
      );

      expect(times, [
        DateTime(2026, 11, 9, 18),
        DateTime(2026, 11, 11, 18),
        DateTime(2026, 11, 16, 18),
        DateTime(2026, 11, 18, 18),
      ]);
    });

    test('stops after its last day', () {
      final times = actionReminderTimes(
        const ActionReminder(
          hour: 18,
          minute: 0,
          weekdays: [1, 3],
          lastDay: '2026-11-11',
        ),
        now: now,
        doneToday: false,
      );

      expect(times, [DateTime(2026, 11, 9, 18), DateTime(2026, 11, 11, 18)]);
    });

    test('ignores weekdays outside Monday to Sunday', () {
      const broken = ActionReminder(hour: 18, minute: 0, weekdays: [0, 8]);
      const partly = ActionReminder(hour: 18, minute: 0, weekdays: [0, 6]);

      expect(actionReminderTimes(broken, now: now, doneToday: false), isEmpty);
      expect(actionReminderTimes(partly, now: now, doneToday: false), [
        DateTime(2026, 11, 7, 18),
        DateTime(2026, 11, 14, 18),
      ]);
    });

    test('skips today once the action is logged', () {
      const saturdays = ActionReminder(hour: 18, minute: 0, weekdays: [6]);

      expect(actionReminderTimes(saturdays, now: now, doneToday: false), [
        DateTime(2026, 11, 7, 18),
        DateTime(2026, 11, 14, 18),
      ]);
      expect(actionReminderTimes(saturdays, now: now, doneToday: true), [
        DateTime(2026, 11, 14, 18),
      ]);
    });
  });

  group('reminderSchedulerProvider', () {
    late ProviderContainer c;
    late DateTime now;

    Future<_RecordingNotifications> run({
      required UserSettingsModel settings,
      bool doneToday = false,
      List<ActionLogModel> todayLogs = const [],
      List<ActionModel> library = const [_bag],
      Object? loading,
      Object? failing,
    }) async {
      final notifications = _RecordingNotifications();
      now = DateTime(2026, 11, 7, 9);
      c =
          (await pumpedContainer(
              [
                userIdProvider.overrideWithValue('u'),
                userSettingsProvider.overrideWith(
                  (_) => loading == userSettingsProvider
                      ? _pending()
                      : failing == userSettingsProvider
                      ? Stream.error('offline')
                      : Stream.value(settings),
                ),
                currentUserProvider.overrideWith(
                  (_) => loading == currentUserProvider
                      ? _pending()
                      : Stream.value(null),
                ),
                isTodayChallengeCompletedProvider.overrideWithValue(doneToday),
                clockProvider.overrideWithValue(() => now),
                notificationServiceProvider.overrideWithValue(notifications),
                actionLibraryProvider.overrideWith(
                  (_) => loading == actionLibraryProvider
                      ? Completer<List<ActionModel>>().future
                      : failing == actionLibraryProvider
                      ? Future.error('offline')
                      : Future.value(library),
                ),
                todayActionsProvider.overrideWith(
                  (_) => loading == todayActionsProvider
                      ? _pending()
                      : Stream.value(todayLogs),
                ),
              ],
              warm: userSettingsProvider,
              retry: (_, _) => null,
            ))
            ..listen(todayActionsProvider, (_, _) {})
            ..listen(currentUserProvider, (_, _) {});
      if (loading != actionLibraryProvider) {
        await c.read(actionLibraryProvider.future).catchError((_) => library);
      }
      if (loading != todayActionsProvider) {
        await c.read(todayActionsProvider.future);
      }
      await c.read(reminderSchedulerProvider.future);
      return notifications;
    }

    test('waits for everything it reads to load', () async {
      for (final provider in [
        userSettingsProvider,
        currentUserProvider,
        actionLibraryProvider,
        todayActionsProvider,
      ]) {
        final notifications = await run(
          loading: provider,
          settings: const UserSettingsModel(
            notificationsEnabled: true,
            actionRemindersEnabled: true,
            actionReminders: {'bag': _daily},
          ),
        );

        expect(notifications.calls, isEmpty, reason: '$provider');
      }
    });

    for (final provider in [userSettingsProvider, actionLibraryProvider]) {
      test('keeps the queue when $provider fails', () async {
        final notifications = await run(
          failing: provider,
          settings: const UserSettingsModel(
            actionRemindersEnabled: true,
            actionReminders: {'bag': _daily},
          ),
        );

        expect(notifications.calls, isEmpty);
      });
    }

    test('reschedules on resume, as the time zone may have changed', () async {
      final notifications = await run(
        settings: const UserSettingsModel(notificationsEnabled: true),
      );
      now = DateTime(2026, 11, 7, 20);

      final binding = TestWidgetsFlutterBinding.instance;
      for (final state in [
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
        AppLifecycleState.hidden,
        AppLifecycleState.inactive,
        AppLifecycleState.resumed,
      ]) {
        binding.handleAppLifecycleStateChanged(state);
      }
      await c.read(reminderSchedulerProvider.future);

      expect(notifications.calls, hasLength(2));
      expect(notifications.calls.last.first.time, DateTime(2026, 11, 8, 18));
    });

    test('skips today once the challenge is done', () async {
      final notifications = await run(
        doneToday: true,
        settings: const UserSettingsModel(notificationsEnabled: true),
      );

      expect(notifications.calls.single.first.time, DateTime(2026, 11, 8, 18));
    });

    test('schedules localized reminders when enabled', () async {
      final notifications = await run(
        settings: const UserSettingsModel(
          notificationsEnabled: true,
          language: 'en',
        ),
      );

      final reminders = notifications.calls.single;
      expect(reminders.first.time, DateTime(2026, 11, 7, 18));
      expect(reminders.first.title, "Today's eco-fact is waiting");
      expect(reminders.first.payload, isNull);
    });

    test('clears reminders when disabled', () async {
      final notifications = await run(settings: const UserSettingsModel());

      expect(notifications.calls.single, isEmpty);
    });

    test('adds action reminders that open the log dialog', () async {
      final notifications = await run(
        settings: const UserSettingsModel(
          actionRemindersEnabled: true,
          actionReminders: {'bag': _daily},
          language: 'en',
        ),
      );

      final reminders = notifications.calls.single;
      expect(reminders, hasLength(AppConstants.reminderDaysAhead));
      expect(reminders.first.time, DateTime(2026, 11, 7, 12));
      expect(reminders.first.title, 'Bring a bag');
      expect(reminders.first.channelId, NotificationService.actionChannelId);
      expect(Uri.parse(reminders.first.payload!).queryParameters, {
        'category': 'waste',
        'action': 'bag',
        'log': '1',
      });
    });

    test('skips today for an action already logged', () async {
      final notifications = await run(
        settings: const UserSettingsModel(
          actionRemindersEnabled: true,
          actionReminders: {'bag': _daily},
        ),
        todayLogs: [
          ActionLogModel(
            id: 'l',
            actionId: 'bag',
            actionName: 'Bring a bag',
            category: 'waste',
            points: 5,
            loggedAt: DateTime(2026, 11, 7, 8),
          ),
        ],
      );

      expect(notifications.calls.single.first.time, DateTime(2026, 11, 8, 12));
    });

    test('ignores action reminders while switched off or orphaned', () async {
      final off = await run(
        settings: const UserSettingsModel(actionReminders: {'bag': _daily}),
      );
      final orphaned = await run(
        settings: const UserSettingsModel(
          actionRemindersEnabled: true,
          actionReminders: {'gone': _daily},
        ),
      );

      expect(off.calls.single, isEmpty);
      expect(orphaned.calls.single, isEmpty);
    });

    test('keeps the challenge reminders and caps the total', () async {
      final notifications = await run(
        settings: const UserSettingsModel(
          notificationsEnabled: true,
          actionRemindersEnabled: true,
          actionReminders: {'bag': _daily},
        ),
      );
      final ten = [
        for (var i = 0; i < AppConstants.maxActionReminders; i++)
          _bag.copyWith(id: 'bag$i'),
      ];
      final full = await run(
        library: ten,
        settings: UserSettingsModel(
          notificationsEnabled: true,
          actionRemindersEnabled: true,
          actionReminders: {
            for (final (i, action) in ten.indexed)
              action.id: _daily.copyWith(minute: i),
          },
        ),
      );

      final reminders = notifications.calls.single;
      expect(reminders, hasLength(2 * AppConstants.reminderDaysAhead));
      expect(
        reminders.take(AppConstants.reminderDaysAhead).map((r) => r.channelId),
        everyElement(NotificationService.challengeChannelId),
      );
      final capped = full.calls.single;
      expect(capped, hasLength(AppConstants.maxPendingNotifications));
      expect(
        capped.where(
          (r) => r.channelId == NotificationService.challengeChannelId,
        ),
        hasLength(AppConstants.reminderDaysAhead),
      );
      expect(capped.last.time, DateTime(2026, 11, 11, 12, 9));
    });
  });
}
