import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_chart_data_provider.dart';

DailySummaryModel _summary(String date, Map<String, int> byCategory) {
  final total = byCategory.values.fold<int>(0, (a, b) => a + b);
  return DailySummaryModel(
    date: date,
    goalCount: 1,
    totalPoints: 10,
    totalCo2Grams: total,
    categoryCo2Grams: byCategory,
    createdAt: DateTime(2026, 5),
    updatedAt: DateTime(2026, 5),
  );
}

void main() {
  group('buildCategoryData', () {
    test('returns empty when no summaries have category data', () {
      final result = buildCategoryData([
        _summary('2026-05-01', const {}),
        _summary('2026-05-02', const {}),
      ]);
      expect(result.isPlottable, isFalse);
      expect(result.totalGrams, 0);
      expect(result.slices, isEmpty);
    });

    test('aggregates grams per category across summaries', () {
      final result = buildCategoryData([
        _summary('2026-05-01', const {'transport': 100, 'food': 50}),
        _summary('2026-05-02', const {'transport': 200}),
      ]);

      expect(result.totalGrams, 350);
      final byCategory = {
        for (final s in result.slices) s.category: s.grams,
      };
      expect(byCategory[ActionCategory.transport], 300);
      expect(byCategory[ActionCategory.food], 50);
    });

    test('sorts slices by grams descending', () {
      final result = buildCategoryData([
        _summary('2026-05-01', const {'food': 50, 'transport': 200}),
      ]);

      expect(result.slices.first.category, ActionCategory.transport);
      expect(result.slices.last.category, ActionCategory.food);
    });

    test('rolls everything beyond top 5 into an Other slice', () {
      final result = buildCategoryData([
        _summary('2026-05-01', const {
          'transport': 600,
          'food': 500,
          'energy': 400,
          'water': 300,
          'recycling': 200,
          'consumption': 100, // 6th -> Other
          'learning': 50, // 7th -> Other
        }),
      ]);

      expect(result.slices.length, 6); // top 5 + Other
      expect(result.slices.last.isOther, isTrue);
      // 100 + 50 = 150 rolled into Other.
      expect(result.slices.last.grams, 150);
    });

    test('keeps unknown categories under Other rather than dropping', () {
      final result = buildCategoryData([
        _summary('2026-05-01', const {
          'transport': 100,
          'mystery_future_category': 25,
        }),
      ]);

      expect(result.totalGrams, 125);
      final otherSlice = result.slices.firstWhere((s) => s.isOther);
      expect(otherSlice.grams, 25);
    });

    test('computes correct percentage shares that sum to ~100', () {
      final result = buildCategoryData([
        _summary('2026-05-01', const {'transport': 250, 'food': 750}),
      ]);

      final transportSlice = result.slices.firstWhere(
        (s) => s.category == ActionCategory.transport,
      );
      final foodSlice = result.slices.firstWhere(
        (s) => s.category == ActionCategory.food,
      );
      expect(transportSlice.percentage, closeTo(25, 0.01));
      expect(foodSlice.percentage, closeTo(75, 0.01));
    });
  });
}
