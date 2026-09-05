import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';
import 'package:seed_app/features/progress/data/repositories/progress_repository.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/domain/services/time_period_range.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_chart_data_provider.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

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

final _now = DateTime(2026, 6, 17, 12);
final _clock = clockProvider.overrideWithValue(() => _now);

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
      final byCategory = {for (final s in result.slices) s.category: s.grams};
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

  group('buildCategoryData edges', () {
    test('exactly five categories fill the donut with no Other slice', () {
      final result = buildCategoryData([
        _summary('2026-05-01', const {
          'transport': 500,
          'food': 400,
          'energy': 300,
          'water': 200,
          'recycling': 100,
        }),
      ]);

      expect(result.slices, hasLength(5));
      expect(result.slices.any((s) => s.isOther), isFalse);
    });

    test('the Other slice carries its own share of the total', () {
      final result = buildCategoryData([
        _summary('2026-05-01', const {
          'transport': 600,
          'food': 500,
          'energy': 400,
          'water': 300,
          'recycling': 200,
          'consumption': 100,
        }),
      ]);

      final other = result.slices.last;
      expect(other.isOther, isTrue);
      expect(other.percentage, closeTo(100 / 2100 * 100, 0.01));
    });
  });

  group('trend window providers', () {
    late FakeFirebaseFirestore firestore;
    final now = _now;
    final today = DateTime(now.year, now.month, now.day);
    DateTime daysAgo(int n) => DateTime(now.year, now.month, now.day - n);

    setUp(() => firestore = FakeFirebaseFirestore());

    Future<void> seed(
      DateTime day,
      int grams, [
      Map<String, int> byCategory = const {},
    ]) async {
      final key = formatDateKey(day);
      await firestore
          .collection(AppConstants.collectionUsers)
          .doc('u')
          .collection(AppConstants.collectionDailySummaries)
          .doc(key)
          .set({
            'date': key,
            'goalCount': 1,
            'completedSdgs': <int>[],
            'totalPoints': 0,
            'totalCo2Grams': grams,
            'categoryCo2Grams': byCategory,
          });
    }

    ProviderContainer container() {
      final c = ProviderContainer(
        overrides: [
          _clock,
          userIdProvider.overrideWithValue('u'),
          progressRepositoryProvider.overrideWith(
            (_) => ProgressRepository(firestore, clock: () => _now),
          ),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('co2TrendData sorts one point per day and averages them', () async {
      await seed(today, 300);
      await seed(daysAgo(1), 100);
      await seed(daysAgo(3), 200);
      await seed(daysAgo(8), 999);

      final data = await container().read(
        co2TrendDataProvider(TimePeriod.thisWeek).future,
      );

      expect(data.points.map((p) => p.grams), [200, 100, 300]);
      expect(data.points.map((p) => p.date), [daysAgo(3), daysAgo(1), today]);
      expect(data.averageGrams, 200);
      final window = TimePeriodRange.trendWindow(
        TimePeriod.thisWeek,
        now: _now,
      );
      expect(data.windowStart, window.start);
      expect(data.windowEnd, window.end);
      expect(data.isPlottable, isTrue);
    });

    test('the month window reaches back 30 days', () async {
      await seed(today, 300);
      await seed(daysAgo(8), 999);
      await seed(daysAgo(29), 50);
      await seed(daysAgo(30), 1);

      final data = await container().read(
        co2TrendDataProvider(TimePeriod.thisMonth).future,
      );

      expect(data.points.map((p) => p.grams), [50, 999, 300]);
    });

    test('an empty window has no points and a zero average', () async {
      final data = await container().read(
        co2TrendDataProvider(TimePeriod.today).future,
      );

      expect(data.points, isEmpty);
      expect(data.averageGrams, 0);
      expect(data.isPlottable, isFalse);
    });

    test('a single day is not plottable', () async {
      await seed(today, 300);

      final data = await container().read(
        co2TrendDataProvider(TimePeriod.today).future,
      );

      expect(data.points, hasLength(1));
      expect(data.isPlottable, isFalse);
    });

    test('co2CategoryData aggregates categories inside the window', () async {
      await seed(today, 100, const {'transport': 100});
      await seed(daysAgo(1), 75, const {'transport': 50, 'food': 25});
      await seed(daysAgo(8), 500, const {'energy': 500});

      final data = await container().read(
        co2CategoryDataProvider(TimePeriod.thisWeek).future,
      );

      expect(data.totalGrams, 175);
      expect(
        {for (final s in data.slices) s.category: s.grams},
        {ActionCategory.transport: 150, ActionCategory.food: 25},
      );
      expect(data.isPlottable, isTrue);
    });

    test('signed out: both charts are empty', () async {
      await seed(today, 300);
      final c = ProviderContainer(
        overrides: [
          _clock,
          userIdProvider.overrideWithValue(null),
          progressRepositoryProvider.overrideWith(
            (_) => ProgressRepository(firestore, clock: () => _now),
          ),
        ],
      );
      addTearDown(c.dispose);

      final trend = await c.read(co2TrendDataProvider(TimePeriod.today).future);
      final donut = await c.read(
        co2CategoryDataProvider(TimePeriod.today).future,
      );

      expect(trend.points, isEmpty);
      expect(donut.isPlottable, isFalse);
    });
  });

  group('buildCategoryData single-gram edges', () {
    test('a one-gram remainder still gets an Other slice', () {
      final result = buildCategoryData([
        _summary('2026-05-01', const {'transport': 10, 'mystery': 1}),
      ]);

      expect(result.totalGrams, 11);
      expect(result.slices.last.isOther, isTrue);
      expect(result.slices.last.grams, 1);
    });

    test('a single gram in one category is a plottable slice', () {
      final result = buildCategoryData([
        _summary('2026-05-01', const {'food': 1}),
      ]);

      expect(result.slices.map((s) => s.grams), [1]);
      expect(result.isPlottable, isTrue);
    });
  });
}
