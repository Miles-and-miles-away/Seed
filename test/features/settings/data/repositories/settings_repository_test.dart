import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
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
    bool smartRemindersEnabled = true,
    String language = 'en',
    bool analyticsEnabled = true,
    List<Map<String, dynamic>> reminderSchedules = const [],
  }) => {
    'notificationsEnabled': notificationsEnabled,
    'smartRemindersEnabled': smartRemindersEnabled,
    'language': language,
    'analyticsEnabled': analyticsEnabled,
    'reminderSchedules': reminderSchedules,
    'hasSeenOnboarding': false,
    'seenStreakMilestones': <String, dynamic>{},
    'streakGracePeriodUsed': false,
  };

  Map<String, dynamic> reminderJson({
    required String id,
    int hour = 9,
    int minute = 0,
    bool isEnabled = true,
    String label = '',
  }) => {
    'id': id,
    'hour': hour,
    'minute': minute,
    'isEnabled': isEnabled,
    'label': label,
  };

  Future<List<dynamic>> savedSchedules() async {
    final doc = await userDoc(testUid).get();
    final data = doc.data()! as Map<String, dynamic>;
    final settings = data['settings'] as Map<String, dynamic>;
    return settings['reminderSchedules'] as List<dynamic>;
  }

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
              (s) => !s.notificationsEnabled && s.language == 'en',
            ),
          ),
        );
      });

      test('emits defaults with user language fallback', () async {
        await seedUserWithoutSettings(testUid, language: 'ja');

        final stream = repository.watchSettings(testUid);

        await expectLater(
          stream,
          emits(predicate<UserSettingsModel>((s) => s.language == 'ja')),
        );
      });

      test('emits defaults when user doc missing', () async {
        final stream = repository.watchSettings(testUid);

        await expectLater(
          stream,
          emits(
            predicate<UserSettingsModel>(
              (s) => !s.notificationsEnabled && s.language == 'en',
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
              (s) => !s.notificationsEnabled && s.language == 'en',
            ),
          ),
        );
      });
    });

    group('addReminder', () {
      test('appends schedule and returns it', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(reminderSchedules: [reminderJson(id: 'r1')]),
        );

        final result = await repository.addReminder(
          testUid,
          time: const TimeOfDay(hour: 18, minute: 30),
          label: 'Evening',
        );

        expect(result, isNotNull);
        expect(result!.hour, 18);
        expect(result.minute, 30);
        expect(result.label, 'Evening');
        expect(result.id, isNotEmpty);

        final schedules = await savedSchedules();
        expect(schedules, hasLength(2));
      });

      test('returns null when at max reminders', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(
            reminderSchedules: [
              for (var i = 0; i < AppConstants.maxRemindersPerUser; i++)
                reminderJson(id: 'r$i', hour: 9 + i),
            ],
          ),
        );

        final result = await repository.addReminder(
          testUid,
          time: const TimeOfDay(hour: 18, minute: 30),
        );

        expect(result, isNull);

        final schedules = await savedSchedules();
        expect(schedules, hasLength(AppConstants.maxRemindersPerUser));
      });

      test('creates reminder with empty label when none provided', () async {
        await seedUserWithSettings(testUid, settingsJson());

        final result = await repository.addReminder(
          testUid,
          time: const TimeOfDay(hour: 9, minute: 0),
        );

        expect(result, isNotNull);
        expect(result!.label, '');
      });
    });

    group('removeReminder', () {
      test('removes schedule by ID', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(
            reminderSchedules: [
              reminderJson(id: 'r1', label: 'Morning'),
              reminderJson(id: 'r2', label: 'Evening'),
            ],
          ),
        );

        await repository.removeReminder(testUid, 'r1');

        final schedules = await savedSchedules();
        expect(schedules, hasLength(1));
        expect((schedules[0] as Map)['id'], 'r2');
      });

      test('no-op when schedule ID not found', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(reminderSchedules: [reminderJson(id: 'r1')]),
        );

        await repository.removeReminder(testUid, 'nonexistent');

        final schedules = await savedSchedules();
        expect(schedules, hasLength(1));
      });
    });

    group('updateReminderTime', () {
      test('updates matching schedule fields', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(
            reminderSchedules: [
              reminderJson(id: 'r1'),
              reminderJson(id: 'r2'),
            ],
          ),
        );

        await repository.updateReminderTime(
          testUid,
          'r1',
          const TimeOfDay(hour: 14, minute: 30),
        );

        final schedules = await savedSchedules();
        final updated = schedules[0] as Map<String, dynamic>;
        expect(updated['hour'], 14);
        expect(updated['minute'], 30);
        final untouched = schedules[1] as Map<String, dynamic>;
        expect(untouched['hour'], 9);
      });
    });

    group('setReminderEnabled', () {
      test('updates isEnabled on the matching schedule', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(reminderSchedules: [reminderJson(id: 'r1')]),
        );

        await repository.setReminderEnabled(testUid, 'r1', enabled: false);

        final schedules = await savedSchedules();
        expect((schedules[0] as Map)['isEnabled'], isFalse);
      });
    });

    group('updateReminderLabel', () {
      test('updates label on the matching schedule', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(reminderSchedules: [reminderJson(id: 'r1')]),
        );

        await repository.updateReminderLabel(testUid, 'r1', 'Work Time');

        final schedules = await savedSchedules();
        expect((schedules[0] as Map)['label'], 'Work Time');
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

    group('setSmartRemindersEnabled', () {
      test('updates smart reminders flag', () async {
        await seedUserWithSettings(testUid, settingsJson());

        await repository.setSmartRemindersEnabled(testUid, enabled: false);

        final doc = await userDoc(testUid).get();
        final data = doc.data()! as Map<String, dynamic>;
        final settings = data['settings'] as Map<String, dynamic>;
        expect(settings['smartRemindersEnabled'], isFalse);
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
