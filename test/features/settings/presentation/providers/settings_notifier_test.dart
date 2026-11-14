import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/settings/data/models/action_reminder_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/providers/notification_providers.dart';
import 'package:seed_app/shared/services/analytics_service.dart';
import 'package:seed_app/shared/services/fcm_service.dart';

import '../../../../helpers/test_helpers.dart';

class _MockFcmService extends Mock implements FCMService {}

class _RecordingAnalytics extends Fake implements AnalyticsService {
  final events = <String>[];

  @override
  Future<void> logNotificationEnabled() async => events.add('enabled');

  @override
  Future<void> logNotificationDisabled() async => events.add('disabled');

  @override
  Future<void> logLanguageChanged({required String language}) async =>
      events.add('language:$language');

  @override
  Future<void> setCollectionEnabled({required bool enabled}) async =>
      events.add('collection:$enabled');

  @override
  void setEnabled({required bool enabled}) => events.add('runtime:$enabled');

  @override
  Future<void> logWalkthroughReset() async => events.add('walkthrough_reset');
}

class _RecordingCrashlytics extends Fake implements FirebaseCrashlytics {
  bool? collectionEnabled;

  @override
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async =>
      collectionEnabled = enabled;
}

const _uid = 'u';

void main() {
  late FakeFirebaseFirestore firestore;
  late _MockFcmService fcm;
  late _RecordingAnalytics analytics;
  late _RecordingCrashlytics crashlytics;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    await firestore.collection(AppConstants.collectionUsers).doc(_uid).set({
      'uid': _uid,
      AppConstants.fieldSettings: <String, dynamic>{},
    });
    fcm = _MockFcmService();
    analytics = _RecordingAnalytics();
    crashlytics = _RecordingCrashlytics();
  });

  Future<ProviderContainer> container({bool signedIn = true}) =>
      pumpedContainer([
        firestoreProvider.overrideWithValue(firestore),
        userOverride(
          signedIn ? const AppUserModel(uid: _uid, email: 'e') : null,
        ),
        fcmServiceProvider.overrideWithValue(fcm),
        analyticsServiceProvider.overrideWithValue(analytics),
        crashlyticsProvider.overrideWithValue(crashlytics),
      ]);

  Future<Map<String, dynamic>> userDoc() async =>
      (await firestore.collection(AppConstants.collectionUsers).doc(_uid).get())
          .data()!;

  Future<Map<String, dynamic>> settingsField() async =>
      (await userDoc())[AppConstants.fieldSettings] as Map<String, dynamic>;

  group('toggleNotifications', () {
    test('enabling asks for OS permission, then persists and logs', () async {
      when(
        fcm.requestPermissions,
      ).thenAnswer((_) async => AuthorizationStatus.authorized);
      final c = await container();

      await c
          .read(settingsProvider.notifier)
          .toggleNotifications(enabled: true);
      await pumpEventQueue();

      final settings = await settingsField();
      expect(settings[AppConstants.fieldNotificationsEnabled], isTrue);
      expect((await userDoc())[AppConstants.fieldNotificationsEnabled], isTrue);
      expect(analytics.events, ['enabled']);
      expect(c.read(settingsProvider).hasValue, isTrue);
    });

    test('provisional permission counts as granted', () async {
      when(
        fcm.requestPermissions,
      ).thenAnswer((_) async => AuthorizationStatus.provisional);
      final c = await container();

      await c
          .read(settingsProvider.notifier)
          .toggleNotifications(enabled: true);
      await pumpEventQueue();

      expect(
        (await settingsField())[AppConstants.fieldNotificationsEnabled],
        isTrue,
      );
    });

    test('a declined permission leaves the setting untouched', () async {
      when(
        fcm.requestPermissions,
      ).thenAnswer((_) async => AuthorizationStatus.denied);
      final c = await container();

      final permitted = await c
          .read(settingsProvider.notifier)
          .toggleNotifications(enabled: true);

      expect(permitted, isFalse);
      expect(
        (await settingsField()).containsKey(
          AppConstants.fieldNotificationsEnabled,
        ),
        isFalse,
      );
      expect(analytics.events, isEmpty);
      expect(c.read(settingsProvider).hasError, isFalse);
    });

    test('disabling skips the permission prompt and logs', () async {
      final c = await container();

      await c
          .read(settingsProvider.notifier)
          .toggleNotifications(enabled: false);
      await pumpEventQueue();

      verifyNever(fcm.requestPermissions);
      expect(
        (await settingsField())[AppConstants.fieldNotificationsEnabled],
        isFalse,
      );
      expect(analytics.events, ['disabled']);
    });
  });

  group('action reminders', () {
    const reminder = ActionReminder(hour: 9, minute: 15, weekdays: [1, 5]);

    Future<Map<String, dynamic>?> reminders() async =>
        (await settingsField())[AppConstants.fieldActionReminders]
            as Map<String, dynamic>?;

    void permission(AuthorizationStatus status) =>
        when(fcm.requestPermissions).thenAnswer((_) async => status);

    test('saving asks for permission and switches reminders on', () async {
      permission(AuthorizationStatus.authorized);
      final c = await container();

      final permitted = await c
          .read(settingsProvider.notifier)
          .saveActionReminder('bag', reminder, enable: true);
      await pumpEventQueue();

      expect(permitted, isTrue);
      expect((await reminders())!['bag'], reminder.toJson());
      expect(
        (await settingsField())[AppConstants.fieldActionRemindersEnabled],
        isTrue,
      );
    });

    test('saving without enable leaves the switch alone', () async {
      permission(AuthorizationStatus.authorized);
      final c = await container();

      await c
          .read(settingsProvider.notifier)
          .saveActionReminder('bag', reminder, enable: false);
      await pumpEventQueue();

      expect((await reminders())!['bag'], reminder.toJson());
      expect(
        (await settingsField()).containsKey(
          AppConstants.fieldActionRemindersEnabled,
        ),
        isFalse,
      );
    });

    test('saving while refused keeps the reminder, switched off', () async {
      permission(AuthorizationStatus.denied);
      final c = await container();

      final permitted = await c
          .read(settingsProvider.notifier)
          .saveActionReminder('bag', reminder, enable: true);
      await pumpEventQueue();

      expect(permitted, isFalse);
      expect((await reminders())!['bag'], reminder.toJson());
      expect(
        (await settingsField()).containsKey(
          AppConstants.fieldActionRemindersEnabled,
        ),
        isFalse,
      );
    });

    test('deleting removes only that reminder', () async {
      permission(AuthorizationStatus.authorized);
      final c = await container();
      final notifier = c.read(settingsProvider.notifier);
      await notifier.saveActionReminder('bag', reminder, enable: true);
      await notifier.saveActionReminder('bus', reminder, enable: true);
      await pumpEventQueue();

      await notifier.deleteActionReminder('bag');

      expect((await reminders())!.keys, ['bus']);
    });

    test('the switch needs permission to turn on', () async {
      permission(AuthorizationStatus.denied);
      final c = await container();
      final notifier = c.read(settingsProvider.notifier);

      expect(await notifier.toggleActionReminders(enabled: true), isFalse);
      permission(AuthorizationStatus.authorized);
      expect(await notifier.toggleActionReminders(enabled: true), isTrue);
      await pumpEventQueue();
      expect(
        (await settingsField())[AppConstants.fieldActionRemindersEnabled],
        isTrue,
      );
    });
  });

  group('other toggles', () {
    test('toggleAnalytics persists and switches every collector', () async {
      final c = await container();

      await c.read(settingsProvider.notifier).toggleAnalytics(enabled: false);

      expect(
        (await settingsField())[AppConstants.fieldAnalyticsEnabled],
        isFalse,
      );
      expect(analytics.events, ['collection:false', 'runtime:false']);
      expect(crashlytics.collectionEnabled, isFalse);
    });

    test('updateReminderTime persists hour and minute', () async {
      final c = await container();

      await c
          .read(settingsProvider.notifier)
          .updateReminderTime(const TimeOfDay(hour: 7, minute: 45));

      final settings = await settingsField();
      expect(settings[AppConstants.fieldReminderHour], 7);
      expect(settings[AppConstants.fieldReminderMinute], 45);
    });

    test('updateThemeMode persists the chosen mode', () async {
      final c = await container();

      await c.read(settingsProvider.notifier).updateThemeMode(ThemeMode.dark);

      expect((await settingsField())[AppConstants.fieldThemeMode], 'dark');
    });

    test(
      'updateLanguage persists both copies; the pick logs, not this',
      () async {
        final c = await container();

        await c.read(settingsProvider.notifier).updateLanguage('ja');

        expect((await settingsField())[AppConstants.fieldLanguage], 'ja');
        expect((await userDoc())[AppConstants.fieldLanguage], 'ja');
        expect(analytics.events, isEmpty);
      },
    );

    test(
      'markWalkthroughFound accumulates and resetWalkthrough logs',
      () async {
        final c = await container();
        final notifier = c.read(settingsProvider.notifier);

        await notifier.markWalkthroughFound('quiz');
        await notifier.markWalkthroughFound('sdg');
        await notifier.markWalkthroughFound('quiz');
        expect((await settingsField())['walkthroughFound'], ['quiz', 'sdg']);
        expect(analytics.events, isEmpty);

        await notifier.resetWalkthrough();
        expect((await settingsField())['walkthroughFound'], isEmpty);
        expect(analytics.events, ['walkthrough_reset']);
      },
    );

    test('markMilestoneSeen records the week', () async {
      final c = await container();

      await c.read(settingsProvider.notifier).markMilestoneSeen(2);

      final seen =
          (await settingsField())[AppConstants.fieldSeenStreakMilestones]
              as Map<String, dynamic>;
      expect(seen['2'], isTrue);
    });
  });

  test('signed out: every write errors without touching Firestore', () async {
    final c = await container(signedIn: false);
    final before = await userDoc();

    final notifier = c.read(settingsProvider.notifier);
    await notifier.updateLanguage('ja');
    expect(c.read(settingsProvider).hasError, isTrue);

    await notifier.updateReminderTime(const TimeOfDay(hour: 8, minute: 0));
    expect(c.read(settingsProvider).hasError, isTrue);

    await notifier.resetWalkthrough();
    expect(c.read(settingsProvider).hasError, isTrue);
    expect(await userDoc(), before);
    expect(analytics.events, isEmpty);
  });
}
