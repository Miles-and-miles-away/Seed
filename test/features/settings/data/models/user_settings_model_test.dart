import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';

void main() {
  group('UserSettingsModel', () {
    group('construction', () {
      test('creates model with default values', () {
        const model = UserSettingsModel();

        expect(model.notificationsEnabled, isFalse);
        expect(model.reminderHour, 18);
        expect(model.reminderMinute, 0);
        expect(model.language, isNull);
        expect(model.hasSeenOnboarding, isFalse);
        expect(model.seenStreakMilestones, isEmpty);
        expect(model.streakGracePeriodUsed, isFalse);
      });

      test('creates model with all fields specified', () {
        const model = UserSettingsModel(
          reminderHour: 7,
          reminderMinute: 30,
          language: 'ja',
          hasSeenOnboarding: true,
          seenStreakMilestones: {'1': true, '2': true},
          streakGracePeriodUsed: true,
        );

        expect(model.notificationsEnabled, isFalse);
        expect(model.reminderHour, 7);
        expect(model.reminderMinute, 30);
        expect(model.language, 'ja');
        expect(model.hasSeenOnboarding, isTrue);
        expect(model.seenStreakMilestones, {'1': true, '2': true});
        expect(model.streakGracePeriodUsed, isTrue);
      });

      test('defaultSettings() leaves the reminder off', () {
        final model = UserSettingsModel.defaultSettings();

        expect(model.language, isNull);
        expect(model.notificationsEnabled, isFalse);
      });
    });

    group('fromJson', () {
      test('creates model from complete JSON', () {
        final json = {
          'notificationsEnabled': true,
          'reminderHour': 20,
          'reminderMinute': 15,
          'language': 'ja',
          'hasSeenOnboarding': true,
          'seenStreakMilestones': {'1': true},
          'streakGracePeriodUsed': true,
        };

        final model = UserSettingsModel.fromJson(json);

        expect(model.notificationsEnabled, isTrue);
        expect(model.reminderHour, 20);
        expect(model.reminderMinute, 15);
        expect(model.language, 'ja');
        expect(model.hasSeenOnboarding, isTrue);
        expect(model.seenStreakMilestones['1'], isTrue);
        expect(model.streakGracePeriodUsed, isTrue);
      });

      test('creates model from minimal JSON (uses defaults)', () {
        final json = <String, dynamic>{};

        final model = UserSettingsModel.fromJson(json);

        expect(model.notificationsEnabled, isFalse);
        expect(model.reminderHour, 18);
        expect(model.language, isNull);
      });

      test('ignores fields from the old multi-reminder settings', () {
        final json = {
          'reminderSchedules': [
            {'id': 'r1', 'hour': 9, 'minute': 0},
          ],
          'smartRemindersEnabled': false,
        };

        final model = UserSettingsModel.fromJson(json);

        expect(model, const UserSettingsModel());
      });

      test('handles missing optional fields', () {
        final json = {'language': 'es'};

        final model = UserSettingsModel.fromJson(json);

        expect(model.language, 'es');
        expect(model.notificationsEnabled, isFalse);
        expect(model.seenStreakMilestones, isEmpty);
      });
    });

    group('toJson', () {
      test('converts model to JSON correctly', () {
        const model = UserSettingsModel(
          reminderHour: 8,
          language: 'ja',
          hasSeenOnboarding: true,
        );

        final json = model.toJson();

        expect(json['notificationsEnabled'], isFalse);
        expect(json['reminderHour'], 8);
        expect(json['reminderMinute'], 0);
        expect(json['language'], 'ja');
        expect(json['hasSeenOnboarding'], isTrue);
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
        expect(original.language, isNull);
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
    group('hasSeenMilestone', () {
      test('returns false for unseen milestone', () {
        const model = UserSettingsModel(seenStreakMilestones: {'1': true});

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
  });
}
