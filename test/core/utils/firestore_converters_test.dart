import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/firestore_converters.dart';

void main() {
  group('TimestampConverter', () {
    const converter = TimestampConverter();

    test('fromJson returns null when timestamp is null', () {
      expect(converter.fromJson(null), isNull);
    });

    test('fromJson preserves the same instant', () {
      final date = DateTime.utc(2026, 4, 19, 12, 30);
      final ts = Timestamp.fromDate(date);

      expect(
        converter.fromJson(ts)!.millisecondsSinceEpoch,
        date.millisecondsSinceEpoch,
      );
    });

    test('toJson returns null when date is null', () {
      expect(converter.toJson(null), isNull);
    });

    test('toJson round-trips a DateTime through Timestamp', () {
      final date = DateTime.utc(2026, 4, 19, 12, 30);
      final roundTripped = converter.fromJson(converter.toJson(date));

      expect(
        roundTripped!.millisecondsSinceEpoch,
        date.millisecondsSinceEpoch,
      );
    });
  });

  group('RequiredTimestampConverter', () {
    const converter = RequiredTimestampConverter();

    test('fromJson preserves the same instant', () {
      final date = DateTime.utc(2026, 4, 19);
      final ts = Timestamp.fromDate(date);

      expect(
        converter.fromJson(ts).millisecondsSinceEpoch,
        date.millisecondsSinceEpoch,
      );
    });

    test('toJson converts DateTime to Timestamp', () {
      final date = DateTime.utc(2026, 4, 19);

      expect(converter.toJson(date), Timestamp.fromDate(date));
    });

    test('round-trip preserves the instant', () {
      final date = DateTime.utc(2026, 4, 19, 12, 30, 45, 123);

      final roundTripped = converter.fromJson(converter.toJson(date));

      // Firestore Timestamps have microsecond precision so milliseconds
      // survive but sub-millisecond may not; compare at millisecond level.
      expect(roundTripped.millisecondsSinceEpoch, date.millisecondsSinceEpoch);
    });
  });
}
