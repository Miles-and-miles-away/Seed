import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:seed_app/features/settings/data/models/notification_schedule_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late SettingsRemoteDataSourceImpl dataSource;

  const testUid = 'test-user';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = SettingsRemoteDataSourceImpl(
      firestore: fakeFirestore,
    );
  });

  DocumentReference userDoc(String uid) => fakeFirestore
      .collection(AppConstants.collectionUsers)
      .doc(uid);

  Future<void> seedUserWithSettings(
    String uid,
    Map<String, dynamic> settings, {
    String? language,
  }) async {
    await userDoc(uid).set({
      'email': 'test@example.com',
      'settings': settings,
      if (language != null) 'language': language,
    });
  }

  Future<void> seedUserWithoutSettings(
    String uid, {
    String language = 'en',
  }) async {
    await userDoc(uid).set({
      'email': 'test@example.com',
      'language': language,
    });
  }

  Map<String, dynamic> settingsJson({
    bool notificationsEnabled = true,
    bool smartRemindersEnabled = true,
    String language = 'en',
    bool analyticsEnabled = true,
    List<Map<String, dynamic>> reminderSchedules = const [],
  }) =>
      {
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
  }) =>
      {
        'id': id,
        'hour': hour,
        'minute': minute,
        'isEnabled': isEnabled,
        'label': label,
      };

  group('SettingsRemoteDataSourceImpl', () {
    group('getSettings', () {
      test('returns settings from user doc', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(language: 'ja'),
        );

        final result =
            await dataSource.getSettings(testUid);

        expect(result.language, 'ja');
        expect(result.notificationsEnabled, isTrue);
      });

      test(
        'returns defaults when no settings field',
        () async {
          await seedUserWithoutSettings(testUid);

          final result =
              await dataSource.getSettings(testUid);

          expect(result.language, 'en');
          expect(result.notificationsEnabled, isTrue);
        },
      );

      test(
        'returns defaults with user language fallback',
        () async {
          await seedUserWithoutSettings(
            testUid,
            language: 'ja',
          );

          final result =
              await dataSource.getSettings(testUid);

          expect(result.language, 'ja');
        },
      );

      test(
        'returns defaults when user doc missing',
        () async {
          final result =
              await dataSource.getSettings(testUid);

          expect(result.notificationsEnabled, isTrue);
          expect(result.language, 'en');
        },
      );
    });

    group('updateSettings', () {
      test('writes settings to user doc', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(),
        );

        const newSettings = UserSettingsModel(
          language: 'ja',
          notificationsEnabled: false,
        );
        await dataSource.updateSettings(
          testUid,
          newSettings,
        );

        final doc = await userDoc(testUid).get();
        final data =
            doc.data() as Map<String, dynamic>;
        final saved = data['settings']
            as Map<String, dynamic>;
        expect(saved['language'], 'ja');
        expect(saved['notificationsEnabled'], isFalse);
        // Top-level language also updated
        expect(data['language'], 'ja');
      });
    });

    group('watchSettings', () {
      test(
        'emits settings from user doc',
        () async {
          await seedUserWithSettings(
            testUid,
            settingsJson(language: 'ja'),
          );

          final stream =
              dataSource.watchSettings(testUid);

          await expectLater(
            stream,
            emits(
              predicate<UserSettingsModel>(
                (s) => s.language == 'ja',
              ),
            ),
          );
        },
      );

      test(
        'emits defaults when no settings',
        () async {
          await seedUserWithoutSettings(testUid);

          final stream =
              dataSource.watchSettings(testUid);

          await expectLater(
            stream,
            emits(
              predicate<UserSettingsModel>(
                (s) =>
                    s.notificationsEnabled &&
                    s.language == 'en',
              ),
            ),
          );
        },
      );
    });

    group('addReminderSchedule', () {
      test('adds reminder to schedules array', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(
            reminderSchedules: [
              reminderJson(id: 'r1'),
            ],
          ),
        );

        const newSchedule = NotificationScheduleModel(
          id: 'r2',
          hour: 18,
          minute: 30,
          label: 'Evening',
        );
        await dataSource.addReminderSchedule(
          testUid,
          newSchedule,
        );

        final doc = await userDoc(testUid).get();
        final data =
            doc.data() as Map<String, dynamic>;
        final settings = data['settings']
            as Map<String, dynamic>;
        final schedules = settings['reminderSchedules']
            as List<dynamic>;
        expect(schedules, hasLength(2));
      });
    });

    group('removeReminderSchedule', () {
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

        await dataSource.removeReminderSchedule(
          testUid,
          'r1',
        );

        final doc = await userDoc(testUid).get();
        final data =
            doc.data() as Map<String, dynamic>;
        final settings = data['settings']
            as Map<String, dynamic>;
        final schedules = settings['reminderSchedules']
            as List<dynamic>;
        expect(schedules, hasLength(1));
        expect(
          (schedules[0] as Map)['id'],
          'r2',
        );
      });

      test(
        'no-op when schedule ID not found',
        () async {
          await seedUserWithSettings(
            testUid,
            settingsJson(
              reminderSchedules: [
                reminderJson(id: 'r1'),
              ],
            ),
          );

          await dataSource.removeReminderSchedule(
            testUid,
            'nonexistent',
          );

          final doc = await userDoc(testUid).get();
          final data =
              doc.data() as Map<String, dynamic>;
          final settings = data['settings']
              as Map<String, dynamic>;
          final schedules = settings['reminderSchedules']
              as List<dynamic>;
          expect(schedules, hasLength(1));
        },
      );
    });

    group('updateReminderSchedule', () {
      test('updates matching schedule fields', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(
            reminderSchedules: [
              reminderJson(
                id: 'r1',
                hour: 9,
                minute: 0,
              ),
            ],
          ),
        );

        await dataSource.updateReminderSchedule(
          testUid,
          'r1',
          {'hour': 14, 'minute': 30},
        );

        final doc = await userDoc(testUid).get();
        final data =
            doc.data() as Map<String, dynamic>;
        final settings = data['settings']
            as Map<String, dynamic>;
        final schedules = settings['reminderSchedules']
            as List<dynamic>;
        final updated =
            schedules[0] as Map<String, dynamic>;
        expect(updated['hour'], 14);
        expect(updated['minute'], 30);
      });
    });

    group('updateNotificationsEnabled', () {
      test('updates both settings and top-level', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(notificationsEnabled: true),
        );

        await dataSource.updateNotificationsEnabled(
          testUid,
          enabled: false,
        );

        final doc = await userDoc(testUid).get();
        final data =
            doc.data() as Map<String, dynamic>;
        final settings = data['settings']
            as Map<String, dynamic>;
        expect(settings['notificationsEnabled'], isFalse);
        expect(data['notificationsEnabled'], isFalse);
      });
    });

    group('updateSmartRemindersEnabled', () {
      test('updates smart reminders flag', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(smartRemindersEnabled: true),
        );

        await dataSource.updateSmartRemindersEnabled(
          testUid,
          enabled: false,
        );

        final doc = await userDoc(testUid).get();
        final data =
            doc.data() as Map<String, dynamic>;
        final settings = data['settings']
            as Map<String, dynamic>;
        expect(
          settings['smartRemindersEnabled'],
          isFalse,
        );
      });
    });

    group('updateLanguage', () {
      test(
        'updates both settings and top-level language',
        () async {
          await seedUserWithSettings(
            testUid,
            settingsJson(language: 'en'),
          );

          await dataSource.updateLanguage(testUid, 'ja');

          final doc = await userDoc(testUid).get();
          final data =
              doc.data() as Map<String, dynamic>;
          final settings = data['settings']
              as Map<String, dynamic>;
          expect(settings['language'], 'ja');
          expect(data['language'], 'ja');
        },
      );
    });

    group('updateAnalyticsEnabled', () {
      test('updates analytics flag', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(analyticsEnabled: true),
        );

        await dataSource.updateAnalyticsEnabled(
          testUid,
          enabled: false,
        );

        final doc = await userDoc(testUid).get();
        final data =
            doc.data() as Map<String, dynamic>;
        final settings = data['settings']
            as Map<String, dynamic>;
        expect(settings['analyticsEnabled'], isFalse);
      });
    });

    group('markMilestoneSeen', () {
      test('marks week milestone as seen', () async {
        await seedUserWithSettings(
          testUid,
          settingsJson(),
        );

        await dataSource.markMilestoneSeen(testUid, 1);

        final doc = await userDoc(testUid).get();
        final data =
            doc.data() as Map<String, dynamic>;
        final settings = data['settings']
            as Map<String, dynamic>;
        final milestones = settings[
            'seenStreakMilestones'] as Map<String, dynamic>;
        expect(milestones['1'], isTrue);
      });

      test(
        'marks multiple milestones independently',
        () async {
          await seedUserWithSettings(
            testUid,
            settingsJson(),
          );

          await dataSource.markMilestoneSeen(testUid, 1);
          await dataSource.markMilestoneSeen(testUid, 4);

          final doc = await userDoc(testUid).get();
          final data =
              doc.data() as Map<String, dynamic>;
          final settings = data['settings']
              as Map<String, dynamic>;
          final milestones = settings[
                  'seenStreakMilestones']
              as Map<String, dynamic>;
          expect(milestones['1'], isTrue);
          expect(milestones['4'], isTrue);
        },
      );
    });
  });
}
