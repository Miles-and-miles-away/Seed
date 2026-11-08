import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/settings/data/models/action_reminder_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/data/repositories/settings_repository.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late SettingsRepository repository;

  const testUid = 'test-user';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = SettingsRepository(firestore: fakeFirestore);
  });

  DocumentReference userDoc(String uid) =>
      fakeFirestore.collection(AppConstants.collectionUsers).doc(uid);

  Future<void> seedUserWithSettings(
    String uid,
    Map<String, dynamic> settings, {
    String? language,
  }) async {
    await userDoc(uid).set({
      'email': 'test@example.com',
      'settings': settings,
      'language': ?language,
    });
  }

  Future<void> seedUserWithoutSettings(
    String uid, {
    String language = 'en',
  }) async {
    await userDoc(uid).set({'email': 'test@example.com', 'language': language});
  }

  Map<String, dynamic> settingsJson({
    bool notificationsEnabled = true,
    String language = 'en',
    bool analyticsEnabled = true,
  }) => {
    'notificationsEnabled': notificationsEnabled,
    'language': language,
    'analyticsEnabled': analyticsEnabled,
    'hasSeenOnboarding': false,
    'seenStreakMilestones': <String, dynamic>{},
    'streakGracePeriodUsed': false,
  };

  group('SettingsRepository', () {
    group('watchSettings', () {
      test('emits settings from user doc', () async {
        await seedUserWithSettings(testUid, settingsJson(language: 'ja'));

        final stream = repository.watchSettings(testUid);

        await expectLater(
          stream,
          emits(predicate<UserSettingsModel>((s) => s.language == 'ja')),
        );
      });

      test('emits defaults when no settings field', () async {
        await seedUserWithoutSettings(testUid);

        final stream = repository.watchSettings(testUid);

        await expectLater(
          stream,
          emits(
            predicate<UserSettingsModel>(
              (s) => !s.notificationsEnabled && s.language == null,
            ),
          ),
        );
      });

      test('ignores the top-level language, which is not a choice', () async {
        await seedUserWithoutSettings(testUid, language: 'ja');

        final stream = repository.watchSettings(testUid);

        await expectLater(
          stream,
          emits(predicate<UserSettingsModel>((s) => s.language == null)),
        );
      });

      test('an unsupported settings language reads as unset', () async {
        await seedUserWithSettings(testUid, settingsJson(language: 'fr'));

        final stream = repository.watchSettings(testUid);

        await expectLater(
          stream,
          emits(predicate<UserSettingsModel>((s) => s.language == null)),
        );
      });

      test('malformed settings keep a valid language', () async {
        await userDoc(testUid).set({
          'settings': {'language': 'es', 'notificationsEnabled': 'yes'},
        });

        final stream = repository.watchSettings(testUid);

        await expectLater(
          stream,
          emits(predicate<UserSettingsModel>((s) => s.language == 'es')),
        );
      });

      test('emits defaults when user doc missing', () async {
        final stream = repository.watchSettings(testUid);

        await expectLater(
          stream,
          emits(
            predicate<UserSettingsModel>(
              (s) => !s.notificationsEnabled && s.language == null,
            ),
          ),
        );
      });

      test('emits defaults when settings field is malformed', () async {
        await userDoc(testUid).set({
          'email': 'test@example.com',
          'settings': 'not-a-map',
          'language': 42,
        });

        final stream = repository.watchSettings(testUid);

        await expectLater(
          stream,
          emits(
            predicate<UserSettingsModel>(
              (s) => !s.notificationsEnabled && s.language == null,
            ),
          ),
        );
      });
    });

    group('setNotificationsEnabled', () {
      test('updates both settings and top-level', () async {
        await seedUserWithSettings(testUid, settingsJson());

        await repository.setNotificationsEnabled(testUid, enabled: false);

        final doc = await userDoc(testUid).get();
        final data = doc.data()! as Map<String, dynamic>;
        final settings = data['settings'] as Map<String, dynamic>;
        expect(settings['notificationsEnabled'], isFalse);
        expect(data['notificationsEnabled'], isFalse);
      });
    });

    group('setReminderTime', () {
      test('writes hour and minute into settings', () async {
        await seedUserWithSettings(testUid, settingsJson());

        await repository.setReminderTime(
          testUid,
          const TimeOfDay(hour: 20, minute: 45),
        );

        final settings = await repository.watchSettings(testUid).first;
        expect(settings.reminderHour, 20);
        expect(settings.reminderMinute, 45);
      });
    });

    group('action reminders', () {
      const reminder = ActionReminder(
        hour: 7,
        minute: 5,
        weekdays: [1, 3],
        lastDay: '2026-12-01',
      );

      test('round-trip by action id and delete one at a time', () async {
        await seedUserWithSettings(testUid, settingsJson());

        await repository.setActionReminder(
          testUid,
          'bag',
          reminder,
          enable: true,
        );
        await repository.setActionReminder(
          testUid,
          'bus',
          reminder.copyWith(lastDay: null),
          enable: false,
        );
        var settings = await repository.watchSettings(testUid).first;
        expect(settings.actionRemindersEnabled, isTrue);
        expect(settings.actionReminders, {
          'bag': reminder,
          'bus': reminder.copyWith(lastDay: null),
        });

        await repository.deleteActionReminder(testUid, 'bag');
        await repository.setActionRemindersEnabled(testUid, enabled: false);
        settings = await repository.watchSettings(testUid).first;
        expect(settings.actionReminders.keys, ['bus']);
        expect(settings.actionRemindersEnabled, isFalse);
      });

      test('a malformed reminder is dropped, not every setting', () async {
        await seedUserWithSettings(testUid, {
          ...settingsJson(analyticsEnabled: false),
          'hasSeenOnboarding': true,
          AppConstants.fieldActionRemindersEnabled: true,
          AppConstants.fieldActionReminders: {
            'bag': reminder.toJson(),
            'bus': {'hour': 9},
            'cup': 'nonsense',
          },
        });

        final settings = await repository.watchSettings(testUid).first;

        expect(settings.actionReminders, {'bag': reminder});
        expect(settings.actionRemindersEnabled, isTrue);
        expect(settings.analyticsEnabled, isFalse);
        expect(settings.hasSeenOnboarding, isTrue);
      });
    });

    group('setLanguage', () {
      test('updates both settings and top-level language', () async {
        await seedUserWithSettings(testUid, settingsJson());

        await repository.setLanguage(testUid, 'ja');

        final doc = await userDoc(testUid).get();
        final data = doc.data()! as Map<String, dynamic>;
        final settings = data['settings'] as Map<String, dynamic>;
        expect(settings['language'], 'ja');
        expect(data['language'], 'ja');
      });
    });

    group('backfillLanguage', () {
      Future<Map<String, dynamic>> saved() async =>
          (await userDoc(testUid).get()).data()! as Map<String, dynamic>;

      test('writes both copies when the account has no choice', () async {
        await seedUserWithoutSettings(testUid);

        await repository.backfillLanguage(testUid, 'ja');

        final data = await saved();
        expect(data['language'], 'ja');
        expect((data['settings'] as Map<String, dynamic>)['language'], 'ja');
      });

      test('leaves an existing choice alone', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(language: 'es'),
          language: 'es',
        );

        await repository.backfillLanguage(testUid, 'ja');

        final data = await saved();
        expect(data['language'], 'es');
        expect((data['settings'] as Map<String, dynamic>)['language'], 'es');
      });

      test('does not create a missing user document', () async {
        await repository.backfillLanguage(testUid, 'ja');

        expect((await userDoc(testUid).get()).exists, isFalse);
      });
    });

    group('setAnalyticsEnabled', () {
      test('updates analytics flag', () async {
        await seedUserWithSettings(testUid, settingsJson());

        await repository.setAnalyticsEnabled(testUid, enabled: false);

        final doc = await userDoc(testUid).get();
        final data = doc.data()! as Map<String, dynamic>;
        final settings = data['settings'] as Map<String, dynamic>;
        expect(settings['analyticsEnabled'], isFalse);
      });
    });

    group('walkthrough', () {
      test('marks items found without duplicates and resets them', () async {
        await seedUserWithSettings(testUid, settingsJson());

        await repository.markWalkthroughFound(testUid, 'quiz');
        await repository.markWalkthroughFound(testUid, 'sdg');
        await repository.markWalkthroughFound(testUid, 'quiz');

        var settings = await repository.watchSettings(testUid).first;
        expect(settings.walkthroughFound, ['quiz', 'sdg']);

        await repository.resetWalkthrough(testUid);

        settings = await repository.watchSettings(testUid).first;
        expect(settings.walkthroughFound, isEmpty);
      });
    });

    group('markMilestoneSeen', () {
      test('marks week milestones as seen independently', () async {
        await seedUserWithSettings(testUid, settingsJson());

        await repository.markMilestoneSeen(testUid, 1);
        await repository.markMilestoneSeen(testUid, 4);

        final doc = await userDoc(testUid).get();
        final data = doc.data()! as Map<String, dynamic>;
        final settings = data['settings'] as Map<String, dynamic>;
        final milestones =
            settings['seenStreakMilestones'] as Map<String, dynamic>;
        expect(milestones['1'], isTrue);
        expect(milestones['4'], isTrue);
      });
    });
  });
}
