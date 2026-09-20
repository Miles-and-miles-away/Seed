import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/progress/domain/entities/co2_chart_data.dart';

Co2TrendPoint _point(int day, int grams) =>
    Co2TrendPoint(date: DateTime(2026, 6, day), grams: grams);

Co2TrendData _trend(List<Co2TrendPoint> points) => Co2TrendData(
  points: points,
  averageGrams: 0,
  windowStart: DateTime(2026, 6),
  windowEnd: DateTime(2026, 6, 8),
);

void main() {
  group('Co2TrendData.isPlottable', () {
    test('needs at least two days of activity', () {
      expect(_trend([]).isPlottable, isFalse);
      expect(_trend([_point(1, 10)]).isPlottable, isFalse);
      expect(_trend([_point(1, 10), _point(2, 20)]).isPlottable, isTrue);
    });
  });

  group('Co2TrendData.trendFit', () {
    test('fits the slope and intercept of a rising line', () {
      // Days 1, 3, 5 (x = 0, 2, 4) at 100, 300, 500 g.
      final fit = _trend([
        _point(1, 100),
        _point(3, 300),
        _point(5, 500),
      ]).trendFit!;

      expect(fit.slope, closeTo(100, 0.001));
      expect(fit.intercept, closeTo(100, 0.001));
    });

    test('fits a falling line through scattered days', () {
      final fit = _trend([
        _point(1, 400),
        _point(2, 200),
        _point(6, 100),
      ]).trendFit!;

      expect(fit.slope, lessThan(0));
    });

    test('has no fit without two distinct days', () {
      expect(_trend([_point(1, 100)]).trendFit, isNull);
      expect(_trend([_point(1, 100), _point(1, 300)]).trendFit, isNull);
      expect(_trend([]).trendFit, isNull);
    });
  });

  group('Co2CategoryData.isPlottable', () {
    const slice = Co2CategorySlice(
      category: ActionCategory.food,
      grams: 10,
      percentage: 100,
    );

    test('hides an empty donut', () {
      expect(
        const Co2CategoryData(slices: [], totalGrams: 0).isPlottable,
        isFalse,
      );
      expect(
        const Co2CategoryData(slices: [], totalGrams: 10).isPlottable,
        isFalse,
      );
      expect(
        const Co2CategoryData(slices: [slice], totalGrams: 0).isPlottable,
        isFalse,
      );
    });

    test('shows a donut with data, even a single gram', () {
      expect(
        const Co2CategoryData(slices: [slice], totalGrams: 10).isPlottable,
        isTrue,
      );
      expect(
        const Co2CategoryData(slices: [slice], totalGrams: 1).isPlottable,
        isTrue,
      );
    });
  });

  test('Co2CategorySlice.isOther marks only the null category', () {
    const other = Co2CategorySlice(category: null, grams: 1, percentage: 1);
    const food = Co2CategorySlice(
      category: ActionCategory.food,
      grams: 1,
      percentage: 1,
    );

    expect(other.isOther, isTrue);
    expect(food.isOther, isFalse);
  });
}
