import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loadEcoFacts', () {
    test('loads exactly 366 facts', () async {
      final facts = await loadEcoFacts();
      expect(facts.length, ECO_FACT_COUNT);
    });

    test('no duplicate dayOfYear values', () async {
      final facts = await loadEcoFacts();
      final days = facts.map((f) => f.dayOfYear).toSet();
      expect(days.length, facts.length);
    });

    test('all dayOfYear values from 1 to 366', () async {
      final facts = await loadEcoFacts();
      final days = facts.map((f) => f.dayOfYear).toSet();
      for (var i = 1; i <= ECO_FACT_COUNT; i++) {
        expect(days.contains(i), isTrue, reason: 'Missing day $i');
      }
    });

    test('all categories are valid', () async {
      const validCategories = {
        'comparison',
        'individual',
        'mythBuster',
        'natureWonder',
        'positiveNews',
      };
      final facts = await loadEcoFacts();
      for (final fact in facts) {
        expect(
          validCategories.contains(fact.category),
          isTrue,
          reason: 'Invalid category "${fact.category}" '
              'for day ${fact.dayOfYear}',
        );
      }
    });

    test('relatedSdgs are in valid range 1-17', () async {
      final facts = await loadEcoFacts();
      for (final fact in facts) {
        for (final sdg in fact.relatedSdgs) {
          expect(
            sdg >= 1 && sdg <= 17,
            isTrue,
            reason: 'SDG $sdg out of range '
                'for day ${fact.dayOfYear}',
          );
        }
      }
    });

    test('all facts have non-empty factEn', () async {
      final facts = await loadEcoFacts();
      for (final fact in facts) {
        expect(
          fact.factEn.isNotEmpty,
          isTrue,
          reason: 'Empty factEn for day ${fact.dayOfYear}',
        );
      }
    });

    test('all facts have non-empty sourceEn', () async {
      final facts = await loadEcoFacts();
      for (final fact in facts) {
        expect(
          fact.sourceEn.isNotEmpty,
          isTrue,
          reason: 'Empty sourceEn for day ${fact.dayOfYear}',
        );
      }
    });
  });

  group('dayOfYear', () {
    test('Jan 1 is day 1', () {
      expect(dayOfYear(DateTime(2025)), 1);
    });

    test('Dec 31 non-leap year is day 365', () {
      expect(dayOfYear(DateTime(2025, 12, 31)), 365);
    });

    test('Feb 28 is day 59', () {
      expect(dayOfYear(DateTime(2025, 2, 28)), 59);
    });

    test('Mar 1 non-leap year is day 60', () {
      expect(dayOfYear(DateTime(2025, 3)), 60);
    });

    test('leap year Dec 31 is day 366', () {
      // 2024 is a leap year, Dec 31 is day 366
      expect(dayOfYear(DateTime(2024, 12, 31)), 366);
    });

    test('leap year Feb 29 is day 60', () {
      expect(dayOfYear(DateTime(2024, 2, 29)), 60);
    });

    test('mid-summer date is exact in DST timezones', () {
      // Local-time arithmetic was off by one for the whole DST
      // half-year; this fails under TZ=America/New_York with the
      // old implementation.
      expect(dayOfYear(DateTime(2026, 7)), 182);
    });

    test('US DST transition days remain distinct', () {
      expect(
        dayOfYear(DateTime(2026, 3, 9)) - dayOfYear(DateTime(2026, 3, 8)),
        1,
      );
    });
  });

  group('formatDateKey', () {
    test('formats date correctly', () {
      expect(formatDateKey(DateTime(2025, 3, 15)), '2025-03-15');
    });

    test('pads single digit month and day', () {
      expect(formatDateKey(DateTime(2025, 1, 5)), '2025-01-05');
    });
  });
}
