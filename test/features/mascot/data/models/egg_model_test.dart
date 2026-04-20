import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/mascot/data/models/egg_model.dart';

void main() {
  group('EggModel', () {
    test('constructs with default streak fields', () {
      final egg = EggModel(receivedAt: DateTime.utc(2026));

      expect(egg.hatchingStreakDays, 0);
      expect(egg.lastHatchingActivityDate, isNull);
    });

    test('fromJson decodes Timestamps to DateTime', () {
      final received = DateTime.utc(2026);
      final last = DateTime.utc(2026, 1, 15);

      final egg = EggModel.fromJson({
        'receivedAt': Timestamp.fromDate(received),
        'hatchingStreakDays': 10,
        'lastHatchingActivityDate': Timestamp.fromDate(last),
      });

      expect(
        egg.receivedAt.millisecondsSinceEpoch,
        received.millisecondsSinceEpoch,
      );
      expect(egg.hatchingStreakDays, 10);
      expect(
        egg.lastHatchingActivityDate!.millisecondsSinceEpoch,
        last.millisecondsSinceEpoch,
      );
    });

    test('fromJson handles missing optional lastHatchingActivityDate', () {
      final egg = EggModel.fromJson({
        'receivedAt': Timestamp.fromDate(DateTime.utc(2026)),
      });

      expect(egg.lastHatchingActivityDate, isNull);
      expect(egg.hatchingStreakDays, 0);
    });

    test('copyWith replaces only the given fields', () {
      final egg = EggModel(
        receivedAt: DateTime.utc(2026),
        hatchingStreakDays: 3,
      );

      final updated = egg.copyWith(hatchingStreakDays: 15);

      expect(updated.hatchingStreakDays, 15);
      expect(updated.receivedAt, egg.receivedAt);
    });
  });
}
