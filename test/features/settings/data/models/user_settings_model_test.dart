import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/data/models/notification_schedule_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';

void main() {
  group('UserSettingsModel', () {
    group('construction', () {
      test('creates model with default values', () {
        const model = UserSettingsModel();

        expect(model.notificationsEnabled, isTrue);
        expect(model.reminderSchedules, isEmpty);
        expect(model.smartRemindersEnabled, isTrue);
        expect(model.language, 'en');
        expect(model.hasSeenOnboarding, isFalse);
        expect(model.seenStreakMilestones, isEmpty);
        expect(model.streakGracePeriodUsed, isFalse);
      });

      test('creates model with all fields specified', () {
        final reminders = [
          const NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
          const NotificationScheduleModel(id: 'r2', hour: 18, minute: 0),
        ];

        final model = UserSettingsModel(
          notificationsEnabled: false,
          reminderSchedules: reminders,
          smartRemindersEnabled: false,
          language: 'ja',
          hasSeenOnboarding: true,
          seenStreakMilestones: {'1': true, '2': true},
          streakGracePeriodUsed: true,
        );

        expect(model.notificationsEnabled, isFalse);
        expect(model.reminderSchedules, hasLength(2));
        expect(model.smartRemindersEnabled, isFalse);
        expect(model.language, 'ja');
        expect(model.hasSeenOnboarding, isTrue);
        expect(model.seenStreakMilestones, {'1': true, '2': true});
        expect(model.streakGracePeriodUsed, isTrue);
      });

      test('defaultSettings() creates correct default reminder', () {
        final model = UserSettingsModel.defaultSettings();

        expect(model.language, 'en');
        expect(model.reminderSchedules, hasLength(1));
        expect(model.reminderSchedules.first.id, 'default_morning');
        expect(model.reminderSchedules.first.hour, 9);
        expect(model.reminderSchedules.first.minute, 0);
        expect(model.reminderSchedules.first.label, 'Morning');
      });

      test('defaultSettings() accepts custom language', () {
        final model = UserSettingsModel.defaultSettings(language: 'es');

        expect(model.language, 'es');
      });
    });

    group('fromJson', () {
      test('creates model from complete JSON', () {
        final json = {
          'notificationsEnabled': false,
          'reminderSchedules': [
            {
              'id': 'r1',
              'hour': 9,
              'minute': 0,
              'isEnabled': true,
              'label': ''
            },
          ],
          'smartRemindersEnabled': false,
          'language': 'ja',
          'hasSeenOnboarding': true,
          'seenStreakMilestones': {'1': true},
          'streakGracePeriodUsed': true,
        };

        final model = UserSettingsModel.fromJson(json);

        expect(model.notificationsEnabled, isFalse);
        expect(model.reminderSchedules, hasLength(1));
        expect(model.smartRemindersEnabled, isFalse);
        expect(model.language, 'ja');
        expect(model.hasSeenOnboarding, isTrue);
        expect(model.seenStreakMilestones['1'], isTrue);
        expect(model.streakGracePeriodUsed, isTrue);
      });

      test('creates model from minimal JSON (uses defaults)', () {
        final json = <String, dynamic>{};

        final model = UserSettingsModel.fromJson(json);

        expect(model.notificationsEnabled, isTrue);
        expect(model.reminderSchedules, isEmpty);
        expect(model.smartRemindersEnabled, isTrue);
        expect(model.language, 'en');
      });

      test('handles empty reminderSchedules array', () {
        final json = {
          'reminderSchedules': <Map<String, dynamic>>[],
        };

        final model = UserSettingsModel.fromJson(json);

        expect(model.reminderSchedules, isEmpty);
      });

      test('handles missing optional fields', () {
        final json = {
          'language': 'es',
        };

        final model = UserSettingsModel.fromJson(json);

        expect(model.language, 'es');
        expect(model.notificationsEnabled, isTrue);
        expect(model.seenStreakMilestones, isEmpty);
      });
    });

    group('toJson', () {
      test('converts model to JSON correctly', () {
        const model = UserSettingsModel(
          notificationsEnabled: false,
          smartRemindersEnabled: false,
          language: 'ja',
          hasSeenOnboarding: true,
        );

        final json = model.toJson();

        expect(json['notificationsEnabled'], isFalse);
        expect(json['smartRemindersEnabled'], isFalse);
        expect(json['language'], 'ja');
        expect(json['hasSeenOnboarding'], isTrue);
      });

      test('serializes reminderSchedules array', () {
        const model = UserSettingsModel(
          reminderSchedules: [
            NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
            NotificationScheduleModel(id: 'r2', hour: 18, minute: 30),
          ],
        );

        final json = model.toJson();

        expect(json['reminderSchedules'], isA<List<dynamic>>());
        expect(json['reminderSchedules'] as List, hasLength(2));
      });
    });

    group('copyWith', () {
      test('creates copy with modified fields', () {
        const original = UserSettingsModel();

        final copy = original.copyWith(
          language: 'ja',
          notificationsEnabled: false,
        );

        expect(copy.language, 'ja');
        expect(copy.notificationsEnabled, isFalse);
      });

      test('original remains unchanged', () {
        const original = UserSettingsModel();

        final copy = original.copyWith(language: 'ja');

        expect(copy.language, 'ja');
        expect(original.language, 'en');
      });
    });

    group('equality', () {
      test('two models with same values are equal', () {
        const model1 = UserSettingsModel();

        const model2 = UserSettingsModel();

        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('two models with different values are not equal', () {
        const model1 = UserSettingsModel();
        const model2 = UserSettingsModel(language: 'ja');

        expect(model1, isNot(equals(model2)));
      });
    });
  });

  group('UserSettingsModelX extension', () {
    group('enabledReminders', () {
      test('returns only enabled schedules', () {
        const model = UserSettingsModel(
          reminderSchedules: [
            NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
            NotificationScheduleModel(
              id: 'r2',
              hour: 12,
              minute: 0,
              isEnabled: false,
            ),
            NotificationScheduleModel(id: 'r3', hour: 18, minute: 0),
          ],
        );

        final enabled = model.enabledReminders;

        expect(enabled, hasLength(2));
        expect(enabled.map((r) => r.id), containsAll(['r1', 'r3']));
      });

      test('returns empty when all disabled', () {
        const model = UserSettingsModel(
          reminderSchedules: [
            NotificationScheduleModel(
              id: 'r1',
              hour: 9,
              minute: 0,
              isEnabled: false,
            ),
            NotificationScheduleModel(
              id: 'r2',
              hour: 12,
              minute: 0,
              isEnabled: false,
            ),
          ],
        );

        expect(model.enabledReminders, isEmpty);
      });

      test('returns empty when no reminders', () {
        const model = UserSettingsModel();

        expect(model.enabledReminders, isEmpty);
      });
    });

    group('canAddReminder', () {
      test('returns true when under 5 reminders', () {
        const model = UserSettingsModel(
          reminderSchedules: [
            NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
            NotificationScheduleModel(id: 'r2', hour: 12, minute: 0),
          ],
        );

        expect(model.canAddReminder, isTrue);
      });

      test('returns true when exactly 4 reminders', () {
        const model = UserSettingsModel(
          reminderSchedules: [
            NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
            NotificationScheduleModel(id: 'r2', hour: 10, minute: 0),
            NotificationScheduleModel(id: 'r3', hour: 11, minute: 0),
            NotificationScheduleModel(id: 'r4', hour: 12, minute: 0),
          ],
        );

        expect(model.canAddReminder, isTrue);
      });

      test('returns false when at 5 reminders', () {
        const model = UserSettingsModel(
          reminderSchedules: [
            NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
            NotificationScheduleModel(id: 'r2', hour: 10, minute: 0),
            NotificationScheduleModel(id: 'r3', hour: 11, minute: 0),
            NotificationScheduleModel(id: 'r4', hour: 12, minute: 0),
            NotificationScheduleModel(id: 'r5', hour: 13, minute: 0),
          ],
        );

        expect(model.canAddReminder, isFalse);
      });

      test('returns true when no reminders', () {
        const model = UserSettingsModel();

        expect(model.canAddReminder, isTrue);
      });
    });

    group('enabledReminderCount', () {
      test('returns correct count', () {
        const model = UserSettingsModel(
          reminderSchedules: [
            NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
            NotificationScheduleModel(
              id: 'r2',
              hour: 12,
              minute: 0,
              isEnabled: false,
            ),
            NotificationScheduleModel(id: 'r3', hour: 18, minute: 0),
          ],
        );

        expect(model.enabledReminderCount, 2);
      });

      test('returns 0 when none enabled', () {
        const model = UserSettingsModel(
          reminderSchedules: [
            NotificationScheduleModel(
              id: 'r1',
              hour: 9,
              minute: 0,
              isEnabled: false,
            ),
          ],
        );

        expect(model.enabledReminderCount, 0);
      });

      test('returns 0 when no reminders', () {
        const model = UserSettingsModel();

        expect(model.enabledReminderCount, 0);
      });
    });

    group('hasSeenMilestone', () {
      test('returns false for unseen milestone', () {
        const model = UserSettingsModel(
          seenStreakMilestones: {'1': true},
        );

        expect(model.hasSeenMilestone(2), isFalse);
      });

      test('returns true for seen milestone', () {
        const model = UserSettingsModel(
          seenStreakMilestones: {'1': true, '2': true},
        );

        expect(model.hasSeenMilestone(1), isTrue);
        expect(model.hasSeenMilestone(2), isTrue);
      });

      test('returns false when no milestones recorded', () {
        const model = UserSettingsModel();

        expect(model.hasSeenMilestone(1), isFalse);
      });
    });

    group('withMilestoneSeen', () {
      test('adds new milestone', () {
        const model = UserSettingsModel();

        final updated = model.withMilestoneSeen(1);

        expect(updated.seenStreakMilestones['1'], isTrue);
      });

      test('preserves existing milestones', () {
        const model = UserSettingsModel(
          seenStreakMilestones: {'1': true, '2': true},
        );

        final updated = model.withMilestoneSeen(3);

        expect(updated.seenStreakMilestones['1'], isTrue);
        expect(updated.seenStreakMilestones['2'], isTrue);
        expect(updated.seenStreakMilestones['3'], isTrue);
      });

      test('does not modify original model', () {
        const model = UserSettingsModel();

        final _ = model.withMilestoneSeen(1);

        expect(model.seenStreakMilestones, isEmpty);
      });

      test('handles overwriting existing milestone', () {
        const model = UserSettingsModel(
          seenStreakMilestones: {'1': true},
        );

        final updated = model.withMilestoneSeen(1);

        expect(updated.seenStreakMilestones['1'], isTrue);
        expect(updated.seenStreakMilestones.length, 1);
      });
    });
  });
}
