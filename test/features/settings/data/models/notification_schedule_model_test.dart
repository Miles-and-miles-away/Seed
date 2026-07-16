import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/data/models/notification_schedule_model.dart';

void main() {
  group('NotificationScheduleModel', () {
    group('construction', () {
      test('creates model with required fields', () {
        const model = NotificationScheduleModel(
          id: 'test-id',
          hour: 9,
          minute: 30,
        );

        expect(model.id, 'test-id');
        expect(model.hour, 9);
        expect(model.minute, 30);
      });

      test('has correct default values', () {
        const model = NotificationScheduleModel(
          id: 'test-id',
          hour: 9,
          minute: 0,
        );

        expect(model.isEnabled, isTrue);
        expect(model.label, '');
      });

      test('creates model with all fields', () {
        const model = NotificationScheduleModel(
          id: 'test-id',
          hour: 14,
          minute: 45,
          isEnabled: false,
          label: 'After lunch',
        );

        expect(model.id, 'test-id');
        expect(model.hour, 14);
        expect(model.minute, 45);
        expect(model.isEnabled, isFalse);
        expect(model.label, 'After lunch');
      });
    });

    group('fromJson / toJson', () {
      test('round-trip serialization preserves all fields', () {
        const original = NotificationScheduleModel(
          id: 'reminder-123',
          hour: 8,
          minute: 15,
          label: 'Morning',
        );

        final json = original.toJson();
        final restored = NotificationScheduleModel.fromJson(json);

        expect(restored, equals(original));
      });

      test('handles edge value hour=0 (midnight)', () {
        const model = NotificationScheduleModel(
          id: 'midnight',
          hour: 0,
          minute: 0,
        );

        final json = model.toJson();
        final restored = NotificationScheduleModel.fromJson(json);

        expect(restored.hour, 0);
        expect(restored.minute, 0);
      });

      test('handles edge value hour=23', () {
        const model = NotificationScheduleModel(
          id: 'late-night',
          hour: 23,
          minute: 59,
        );

        final json = model.toJson();
        final restored = NotificationScheduleModel.fromJson(json);

        expect(restored.hour, 23);
        expect(restored.minute, 59);
      });

      test('handles minute=59', () {
        const model = NotificationScheduleModel(
          id: 'test',
          hour: 12,
          minute: 59,
        );

        final json = model.toJson();
        final restored = NotificationScheduleModel.fromJson(json);

        expect(restored.minute, 59);
      });
    });

    group('timeString', () {
      test('formats single digit hours with padding', () {
        const model = NotificationScheduleModel(
          id: 'test',
          hour: 9,
          minute: 30,
        );

        expect(model.timeString, '09:30');
      });

      test('formats single digit minutes with padding', () {
        const model = NotificationScheduleModel(
          id: 'test',
          hour: 14,
          minute: 5,
        );

        expect(model.timeString, '14:05');
      });

      test('formats midnight correctly', () {
        const model = NotificationScheduleModel(id: 'test', hour: 0, minute: 0);

        expect(model.timeString, '00:00');
      });

      test('formats double digit values without extra padding', () {
        const model = NotificationScheduleModel(
          id: 'test',
          hour: 23,
          minute: 59,
        );

        expect(model.timeString, '23:59');
      });
    });

    group('displayTime', () {
      test('formats morning time correctly', () {
        const model = NotificationScheduleModel(id: 'test', hour: 9, minute: 0);

        expect(model.displayTime, '9:00 AM');
      });

      test('formats afternoon time correctly', () {
        const model = NotificationScheduleModel(
          id: 'test',
          hour: 14,
          minute: 30,
        );

        expect(model.displayTime, '2:30 PM');
      });

      test('formats noon correctly', () {
        const model = NotificationScheduleModel(
          id: 'test',
          hour: 12,
          minute: 0,
        );

        expect(model.displayTime, '12:00 PM');
      });

      test('formats midnight correctly', () {
        const model = NotificationScheduleModel(id: 'test', hour: 0, minute: 0);

        expect(model.displayTime, '12:00 AM');
      });

      test('formats 11:59 PM correctly', () {
        const model = NotificationScheduleModel(
          id: 'test',
          hour: 23,
          minute: 59,
        );

        expect(model.displayTime, '11:59 PM');
      });

      test('formats 12:01 AM correctly', () {
        const model = NotificationScheduleModel(id: 'test', hour: 0, minute: 1);

        expect(model.displayTime, '12:01 AM');
      });

      test('formats 1:00 PM correctly', () {
        const model = NotificationScheduleModel(
          id: 'test',
          hour: 13,
          minute: 0,
        );

        expect(model.displayTime, '1:00 PM');
      });

      test('pads minutes with leading zero', () {
        const model = NotificationScheduleModel(id: 'test', hour: 9, minute: 5);

        expect(model.displayTime, '9:05 AM');
      });
    });

    group('notificationId', () {
      test('returns positive integer', () {
        const model = NotificationScheduleModel(
          id: 'test-reminder',
          hour: 9,
          minute: 0,
        );

        expect(model.notificationId, isPositive);
        expect(model.notificationId, isA<int>());
      });

      test('returns same value for same id', () {
        const model1 = NotificationScheduleModel(
          id: 'same-id',
          hour: 9,
          minute: 0,
        );

        const model2 = NotificationScheduleModel(
          id: 'same-id',
          hour: 14,
          minute: 30,
        );

        expect(model1.notificationId, equals(model2.notificationId));
      });

      test('returns different values for different ids', () {
        const model1 = NotificationScheduleModel(
          id: 'id-one',
          hour: 9,
          minute: 0,
        );

        const model2 = NotificationScheduleModel(
          id: 'id-two',
          hour: 9,
          minute: 0,
        );

        expect(model1.notificationId, isNot(equals(model2.notificationId)));
      });

      test('stays within valid notification ID range', () {
        const model = NotificationScheduleModel(
          id: 'very-long-unique-identifier-string-that-might-hash-to-large-value',
          hour: 9,
          minute: 0,
        );

        // Notification IDs must be within 32-bit signed integer range
        expect(model.notificationId, lessThan(2147483647));
        expect(model.notificationId, greaterThanOrEqualTo(0));
      });
    });

    group('copyWith', () {
      test('creates copy with modified fields', () {
        const original = NotificationScheduleModel(
          id: 'test',
          hour: 9,
          minute: 0,
          label: 'Morning',
        );

        final copy = original.copyWith(hour: 10, isEnabled: false);

        expect(copy.id, 'test');
        expect(copy.hour, 10);
        expect(copy.minute, 0);
        expect(copy.isEnabled, isFalse);
        expect(copy.label, 'Morning');
      });

      test('original remains unchanged', () {
        const original = NotificationScheduleModel(
          id: 'test',
          hour: 9,
          minute: 0,
        );

        final copy = original.copyWith(hour: 10);

        expect(copy.hour, 10);
        expect(original.hour, 9);
      });
    });

    group('equality', () {
      test('models with same values are equal', () {
        const model1 = NotificationScheduleModel(
          id: 'test',
          hour: 9,
          minute: 30,
          label: 'Morning',
        );

        const model2 = NotificationScheduleModel(
          id: 'test',
          hour: 9,
          minute: 30,
          label: 'Morning',
        );

        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('models with different values are not equal', () {
        const model1 = NotificationScheduleModel(
          id: 'test-1',
          hour: 9,
          minute: 0,
        );

        const model2 = NotificationScheduleModel(
          id: 'test-2',
          hour: 9,
          minute: 0,
        );

        expect(model1, isNot(equals(model2)));
      });
    });
  });
}
