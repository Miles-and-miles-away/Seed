import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/date_helpers.dart';

void main() {
  group('dateOnlyUtc', () {
    test('strips the time and projects into UTC', () {
      final projected = dateOnlyUtc(DateTime(2026, 6, 12, 23, 45));
      expect(projected, DateTime.utc(2026, 6, 12));
      expect(projected.isUtc, isTrue);
    });
  });

  group('calendarDaysBetween', () {
    test('returns 0 for the same calendar day', () {
      expect(
        calendarDaysBetween(
          DateTime(2026, 6, 12, 0, 1),
          DateTime(2026, 6, 12, 23, 59),
        ),
        0,
      );
    });

    test('returns 1 for consecutive days regardless of time', () {
      expect(
        calendarDaysBetween(
          DateTime(2026, 6, 12, 23, 59),
          DateTime(2026, 6, 13, 0, 1),
        ),
        1,
      );
    });

    test('counts whole gaps', () {
      expect(calendarDaysBetween(DateTime(2026, 6), DateTime(2026, 6, 12)), 11);
    });

    test('spans month and year boundaries', () {
      expect(
        calendarDaysBetween(
          DateTime(2026, 12, 31, 18),
          DateTime(2027, 1, 1, 6),
        ),
        1,
      );
    });

    test('is negative when the clock moves to an earlier day', () {
      // Travelling west across timezones can legitimately produce
      // a "now" on the previous calendar day.
      expect(
        calendarDaysBetween(
          DateTime(2026, 6, 12, 0, 30),
          DateTime(2026, 6, 11, 23),
        ),
        -1,
      );
    });

    test('US spring-forward 2026 days still count as 1 apart', () {
      // In a DST zone, local-midnight difference for Mar 8 -> Mar 9
      // is 23h (0 days). The UTC projection must yield exactly 1.
      expect(
        calendarDaysBetween(DateTime(2026, 3, 8), DateTime(2026, 3, 9)),
        1,
      );
      expect(
        calendarDaysBetween(DateTime(2026, 3, 7), DateTime(2026, 3, 9)),
        2,
      );
    });
  });

  group('previousCalendarDay', () {
    test('returns the prior day within a month', () {
      expect(
        previousCalendarDay(DateTime(2026, 6, 12, 0, 30)),
        DateTime(2026, 6, 11),
      );
    });

    test('crosses month boundaries', () {
      expect(previousCalendarDay(DateTime(2026, 3)), DateTime(2026, 2, 28));
      expect(previousCalendarDay(DateTime(2028, 3)), DateTime(2028, 2, 29));
    });

    test('crosses year boundaries', () {
      expect(previousCalendarDay(DateTime(2026)), DateTime(2025, 12, 31));
    });
  });

  group('formatDateLabel', () {
    final l10n = lookupAppLocalizations(const Locale('en'));

    setUpAll(() => initializeDateFormatting('en'));

    test('labels today and yesterday', () {
      final now = DateTime.now();
      expect(formatDateLabel(now, l10n, 'en'), l10n.today);
      expect(
        formatDateLabel(previousCalendarDay(now), l10n, 'en'),
        l10n.yesterday,
      );
    });

    test('includes the year only for other years', () {
      final now = DateTime.now();
      // A same-year date at least 2 days back (or forward in January).
      final sameYear = now.month == 1 && now.day <= 3
          ? DateTime(now.year, 6, 15)
          : DateTime(now.year, now.month, now.day - 3);
      expect(
        formatDateLabel(sameYear, l10n, 'en'),
        isNot(contains('${sameYear.year}')),
      );
      expect(
        formatDateLabel(DateTime(now.year - 1, 6, 15), l10n, 'en'),
        contains('${now.year - 1}'),
      );
    });
  });
}
