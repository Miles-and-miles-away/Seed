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

      await c
          .read(settingsProvider.notifier)
          .toggleNotifications(enabled: true);

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

      verifyNever(fcm.requestPermissions);
      expect(
        (await settingsField())[AppConstants.fieldNotificationsEnabled],
        isFalse,
      );
      expect(analytics.events, ['disabled']);
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

    test('toggleSmartReminders persists', () async {
      final c = await container();

      await c
          .read(settingsProvider.notifier)
          .toggleSmartReminders(enabled: false);

      expect(
        (await settingsField())[AppConstants.fieldSmartRemindersEnabled],
        isFalse,
      );
    });

    test('updateLanguage persists both copies and logs', () async {
      final c = await container();

      await c.read(settingsProvider.notifier).updateLanguage('ja');

      expect((await settingsField())[AppConstants.fieldLanguage], 'ja');
      expect((await userDoc())[AppConstants.fieldLanguage], 'ja');
      expect(analytics.events, ['language:ja']);
    });

    test('markMilestoneSeen records the week', () async {
      final c = await container();

      await c.read(settingsProvider.notifier).markMilestoneSeen(2);

      final seen =
          (await settingsField())[AppConstants.fieldSeenStreakMilestones]
              as Map<String, dynamic>;
      expect(seen['2'], isTrue);
    });
  });

  group('reminders', () {
    test('addReminder returns the schedule it stored', () async {
      final c = await container();

      final schedule = await c
          .read(settingsProvider.notifier)
          .addReminder(const TimeOfDay(hour: 8, minute: 30), label: 'Coffee');

      expect(schedule?.hour, 8);
      expect(schedule?.minute, 30);
      final stored =
          (await settingsField())[AppConstants.fieldReminderSchedules]
              as List<dynamic>;
      expect(stored, hasLength(1));
      expect((stored.single as Map)[AppConstants.fieldLabel], 'Coffee');
    });

    test('removeReminder deletes only the matching schedule', () async {
      final c = await container();
      final notifier = c.read(settingsProvider.notifier);
      final keep = await notifier.addReminder(
        const TimeOfDay(hour: 7, minute: 0),
      );
      final drop = await notifier.addReminder(
        const TimeOfDay(hour: 9, minute: 0),
      );

      await notifier.removeReminder(drop!.id);

      final stored =
          (await settingsField())[AppConstants.fieldReminderSchedules]
              as List<dynamic>;
      expect(stored.map((s) => (s as Map)[AppConstants.fieldId]), [keep!.id]);
    });
  });

  test('signed out: every write errors without touching Firestore', () async {
    final c = await container(signedIn: false);
    final before = await userDoc();

    final notifier = c.read(settingsProvider.notifier);
    await notifier.updateLanguage('ja');
    expect(c.read(settingsProvider).hasError, isTrue);

    final schedule = await notifier.addReminder(
      const TimeOfDay(hour: 8, minute: 0),
    );
    expect(schedule, isNull);
    expect(c.read(settingsProvider).hasError, isTrue);
    expect(await userDoc(), before);
    expect(analytics.events, isEmpty);
  });
}
