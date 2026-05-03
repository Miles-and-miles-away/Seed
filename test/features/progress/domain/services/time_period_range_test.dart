import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/domain/services/time_period_range.dart';

void main() {
  group('TimePeriodRange.current', () {
    test('today covers [midnight, midnight + 1 day)', () {
      final now = DateTime(2026, 5, 3, 14, 30);
      final range = TimePeriodRange.current(TimePeriod.today, now: now);

      expect(range.start, DateTime(2026, 5, 3));
      expect(range.end, DateTime(2026, 5, 4));
    });

    test('thisWeek starts on Monday and ends the following Monday', () {
      // 2026-05-03 is a Sunday.
      final now = DateTime(2026, 5, 3, 12);
      final range = TimePeriodRange.current(TimePeriod.thisWeek, now: now);

      // Week containing Sunday 2026-05-03 starts on Monday 2026-04-27.
      expect(range.start, DateTime(2026, 4, 27));
      expect(range.end, DateTime(2026, 5, 4));
      expect(range.start.weekday, DateTime.monday);
    });

    test('thisWeek when called on a Monday still starts that Monday', () {
      // 2026-05-04 is a Monday.
      final now = DateTime(2026, 5, 4, 9);
      final range = TimePeriodRange.current(TimePeriod.thisWeek, now: now);

      expect(range.start, DateTime(2026, 5, 4));
      expect(range.end, DateTime(2026, 5, 11));
    });

    test('thisMonth covers calendar month from the 1st', () {
      final now = DateTime(2026, 5, 15, 18);
      final range = TimePeriodRange.current(TimePeriod.thisMonth, now: now);

      expect(range.start, DateTime(2026, 5));
      expect(range.end, DateTime(2026, 6));
    });

    test('thisMonth handles December rollover', () {
      final now = DateTime(2026, 12, 20);
      final range = TimePeriodRange.current(TimePeriod.thisMonth, now: now);

      expect(range.start, DateTime(2026, 12));
      expect(range.end, DateTime(2027));
    });

    test('thisMonth handles February in a leap year', () {
      final now = DateTime(2028, 2, 15);
      final range = TimePeriodRange.current(TimePeriod.thisMonth, now: now);

      expect(range.start, DateTime(2028, 2));
      expect(range.end, DateTime(2028, 3));
    });

    test('allTime ends at today (exclusive)', () {
      final now = DateTime(2026, 5, 3, 14, 30);
      final range = TimePeriodRange.current(TimePeriod.allTime, now: now);

      expect(range.end, DateTime(2026, 5, 3));
      expect(range.start.isBefore(range.end), isTrue);
    });
  });

  group('TimePeriodRange.previous', () {
    test('previous of today is yesterday', () {
      final now = DateTime(2026, 5, 3);
      final range = TimePeriodRange.previous(TimePeriod.today, now: now);

      expect(range.start, DateTime(2026, 5, 2));
      expect(range.end, DateTime(2026, 5, 3));
    });

    test('previous of thisWeek is last week (Mon-Mon)', () {
      // 2026-05-03 is a Sunday; this week starts Mon 2026-04-27.
      final now = DateTime(2026, 5, 3);
      final range = TimePeriodRange.previous(TimePeriod.thisWeek, now: now);

      expect(range.start, DateTime(2026, 4, 20));
      expect(range.end, DateTime(2026, 4, 27));
      expect(range.start.weekday, DateTime.monday);
    });

    test('previous of thisMonth handles January -> previous December', () {
      final now = DateTime(2026, 1, 10);
      final range = TimePeriodRange.previous(TimePeriod.thisMonth, now: now);

      expect(range.start, DateTime(2025, 12));
      expect(range.end, DateTime(2026));
    });

    test('previous of allTime is a zero-width range at today', () {
      final now = DateTime(2026, 5, 3);
      final range = TimePeriodRange.previous(TimePeriod.allTime, now: now);

      expect(range.start, range.end);
    });
  });

  group('DST behavior', () {
    test('day arithmetic does not drift across hypothetical DST', () {
      // Spring-forward day in US Pacific 2026 is March 8. Even on
      // systems that observe DST, calendar arithmetic via the
      // DateTime constructor keeps day boundaries at local midnight.
      final now = DateTime(2026, 3, 8, 14);
      final range = TimePeriodRange.current(TimePeriod.today, now: now);

      expect(range.start.hour, 0);
      expect(range.end.hour, 0);
      expect(range.end.day - range.start.day, 1);
    });
  });
}
