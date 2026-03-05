import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:seed_app/features/settings/data/models/notification_schedule_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/data/repositories/settings_repository.dart';

class MockSettingsRemoteDataSource extends Mock
    implements SettingsRemoteDataSource {}

void main() {
  late SettingsRepository repository;
  late MockSettingsRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockSettingsRemoteDataSource();
    repository = SettingsRepository(dataSource: mockDataSource);
  });

  setUpAll(() {
    registerFallbackValue(const UserSettingsModel());
    registerFallbackValue(
      const NotificationScheduleModel(id: 'test', hour: 9, minute: 0),
    );
    registerFallbackValue(<String, dynamic>{});
  });

  const testUid = 'test-user-123';

  group('SettingsRepository', () {
    group('getSettings', () {
      test('returns settings from data source', () async {
        const expectedSettings = UserSettingsModel(language: 'ja');
        when(() => mockDataSource.getSettings(testUid))
            .thenAnswer((_) async => expectedSettings);

        final result = await repository.getSettings(testUid);

        expect(result, equals(expectedSettings));
        verify(() => mockDataSource.getSettings(testUid)).called(1);
      });
    });

    group('watchSettings', () {
      test('returns stream from data source', () {
        const settings1 = UserSettingsModel();
        const settings2 = UserSettingsModel(language: 'ja');
        when(() => mockDataSource.watchSettings(testUid))
            .thenAnswer((_) => Stream.fromIterable([settings1, settings2]));

        final stream = repository.watchSettings(testUid);

        expect(stream, emitsInOrder([settings1, settings2]));
        verify(() => mockDataSource.watchSettings(testUid)).called(1);
      });
    });

    group('updateSettings', () {
      test('calls data source updateSettings', () async {
        const settings = UserSettingsModel(language: 'es');
        when(() => mockDataSource.updateSettings(testUid, settings))
            .thenAnswer((_) async {});

        await repository.updateSettings(testUid, settings);

        verify(() => mockDataSource.updateSettings(testUid, settings))
            .called(1);
      });
    });

    group('setNotificationsEnabled', () {
      test('calls data source with enabled=true', () async {
        when(
          () => mockDataSource.updateNotificationsEnabled(
            testUid,
            enabled: true,
          ),
        ).thenAnswer((_) async {});

        await repository.setNotificationsEnabled(testUid, enabled: true);

        verify(
          () => mockDataSource.updateNotificationsEnabled(
            testUid,
            enabled: true,
          ),
        ).called(1);
      });

      test('calls data source with enabled=false', () async {
        when(
          () => mockDataSource.updateNotificationsEnabled(
            testUid,
            enabled: false,
          ),
        ).thenAnswer((_) async {});

        await repository.setNotificationsEnabled(testUid, enabled: false);

        verify(
          () => mockDataSource.updateNotificationsEnabled(
            testUid,
            enabled: false,
          ),
        ).called(1);
      });
    });

    group('setSmartRemindersEnabled', () {
      test('calls data source with enabled value', () async {
        when(
          () => mockDataSource.updateSmartRemindersEnabled(
            testUid,
            enabled: true,
          ),
        ).thenAnswer((_) async {});

        await repository.setSmartRemindersEnabled(testUid, enabled: true);

        verify(
          () => mockDataSource.updateSmartRemindersEnabled(
            testUid,
            enabled: true,
          ),
        ).called(1);
      });
    });

    group('setLanguage', () {
      test('calls data source updateLanguage', () async {
        when(() => mockDataSource.updateLanguage(testUid, 'ja'))
            .thenAnswer((_) async {});

        await repository.setLanguage(testUid, 'ja');

        verify(() => mockDataSource.updateLanguage(testUid, 'ja')).called(1);
      });
    });

    group('addReminder', () {
      test('returns schedule when under max reminders', () async {
        const currentSettings = UserSettingsModel(
          reminderSchedules: [
            NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
          ],
        );
        when(() => mockDataSource.getSettings(testUid))
            .thenAnswer((_) async => currentSettings);
        when(() => mockDataSource.addReminderSchedule(testUid, any()))
            .thenAnswer((_) async {});

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
        verify(() => mockDataSource.addReminderSchedule(testUid, any()))
            .called(1);
      });

      test('returns null when at max reminders', () async {
        const maxedSettings = UserSettingsModel(
          reminderSchedules: [
            NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
            NotificationScheduleModel(id: 'r2', hour: 10, minute: 0),
            NotificationScheduleModel(id: 'r3', hour: 11, minute: 0),
            NotificationScheduleModel(id: 'r4', hour: 12, minute: 0),
            NotificationScheduleModel(id: 'r5', hour: 13, minute: 0),
          ],
        );
        when(() => mockDataSource.getSettings(testUid))
            .thenAnswer((_) async => maxedSettings);

        final result = await repository.addReminder(
          testUid,
          time: const TimeOfDay(hour: 18, minute: 30),
        );

        expect(result, isNull);
        verifyNever(() => mockDataSource.addReminderSchedule(testUid, any()));
      });

      test('creates reminder with empty label when none provided', () async {
        const currentSettings = UserSettingsModel();
        when(() => mockDataSource.getSettings(testUid))
            .thenAnswer((_) async => currentSettings);
        when(() => mockDataSource.addReminderSchedule(testUid, any()))
            .thenAnswer((_) async {});

        final result = await repository.addReminder(
          testUid,
          time: const TimeOfDay(hour: 9, minute: 0),
        );

        expect(result, isNotNull);
        expect(result!.label, '');
      });
    });

    group('removeReminder', () {
      test('calls data source removeReminderSchedule', () async {
        when(() => mockDataSource.removeReminderSchedule(testUid, 'schedule-1'))
            .thenAnswer((_) async {});

        await repository.removeReminder(testUid, 'schedule-1');

        verify(
          () => mockDataSource.removeReminderSchedule(testUid, 'schedule-1'),
        ).called(1);
      });
    });

    group('updateReminderTime', () {
      test('calls data source with hour and minute', () async {
        when(
          () => mockDataSource.updateReminderSchedule(
            testUid,
            'schedule-1',
            {'hour': 14, 'minute': 30},
          ),
        ).thenAnswer((_) async {});

        await repository.updateReminderTime(
          testUid,
          'schedule-1',
          const TimeOfDay(hour: 14, minute: 30),
        );

        verify(
          () => mockDataSource.updateReminderSchedule(
            testUid,
            'schedule-1',
            {'hour': 14, 'minute': 30},
          ),
        ).called(1);
      });
    });

    group('setReminderEnabled', () {
      test('calls data source with isEnabled field', () async {
        when(
          () => mockDataSource.updateReminderSchedule(
            testUid,
            'schedule-1',
            {'isEnabled': false},
          ),
        ).thenAnswer((_) async {});

        await repository.setReminderEnabled(
          testUid,
          'schedule-1',
          enabled: false,
        );

        verify(
          () => mockDataSource.updateReminderSchedule(
            testUid,
            'schedule-1',
            {'isEnabled': false},
          ),
        ).called(1);
      });
    });

    group('updateReminderLabel', () {
      test('calls data source with label field', () async {
        when(
          () => mockDataSource.updateReminderSchedule(
            testUid,
            'schedule-1',
            {'label': 'Work Time'},
          ),
        ).thenAnswer((_) async {});

        await repository.updateReminderLabel(
          testUid,
          'schedule-1',
          'Work Time',
        );

        verify(
          () => mockDataSource.updateReminderSchedule(
            testUid,
            'schedule-1',
            {'label': 'Work Time'},
          ),
        ).called(1);
      });
    });

    group('markMilestoneSeen', () {
      test('calls data source markMilestoneSeen', () async {
        when(() => mockDataSource.markMilestoneSeen(testUid, 1))
            .thenAnswer((_) async {});

        await repository.markMilestoneSeen(testUid, 1);

        verify(() => mockDataSource.markMilestoneSeen(testUid, 1)).called(1);
      });
    });

    group('initializeSettings', () {
      test('creates default settings with specified language', () async {
        when(() => mockDataSource.updateSettings(testUid, any()))
            .thenAnswer((_) async {});

        await repository.initializeSettings(testUid, language: 'ja');

        verify(
          () => mockDataSource.updateSettings(
            testUid,
            any(
              that: isA<UserSettingsModel>()
                  .having((s) => s.language, 'language', 'ja'),
            ),
          ),
        ).called(1);
      });

      test('uses English as default language', () async {
        when(() => mockDataSource.updateSettings(testUid, any()))
            .thenAnswer((_) async {});

        await repository.initializeSettings(testUid);

        verify(
          () => mockDataSource.updateSettings(
            testUid,
            any(
              that: isA<UserSettingsModel>()
                  .having((s) => s.language, 'language', 'en'),
            ),
          ),
        ).called(1);
      });
    });
  });
}
