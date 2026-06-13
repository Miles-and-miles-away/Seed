import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';
import 'package:seed_app/features/progress/domain/entities/co2_chart_data.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/domain/services/time_period_range.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';

part 'co2_chart_data_provider.g.dart';

/// Daily-points + average for the trend scatter chart.
///
/// The window is a rolling N-day range tied to the dashboard's
/// [TimePeriod] selection (7 / 30 / 90 days -- see
/// [TimePeriodRange.trendWindowDays]). Each daily summary in the
/// window contributes one point; missing days are simply absent.
/// The average is taken across days with data only -- folding in
/// implicit zeros would pull the line down for users who skip days.
/// One fetch of the trend window shared by the trend and category
/// charts (they previously each ran the identical query). Keyed on
/// the user id; refreshed explicitly after logging and at day change.
@riverpod
Future<List<DailySummaryModel>> trendWindowSummaries(
  Ref ref,
  TimePeriod period,
) async {
  final userId = ref.watch(userIdProvider);
  if (userId == null) return const [];

  final range = TimePeriodRange.trendWindow(period);
  return ref.watch(progressRepositoryProvider).getSummariesForDateRange(
        userId,
        range.start,
        range.end,
      );
}

@riverpod
Future<Co2TrendData> co2TrendData(Ref ref, TimePeriod period) async {
  final range = TimePeriodRange.trendWindow(period);
  final summaries = await ref.watch(
    trendWindowSummariesProvider(period).future,
  );

  final points = summaries
      .map(
        (s) => Co2TrendPoint(
          date: _parseDateId(s.date),
          grams: s.totalCo2Grams,
        ),
      )
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  final average = points.isEmpty
      ? 0.0
      : points.map((p) => p.grams).reduce((a, b) => a + b) / points.length;

  return Co2TrendData(
    points: points,
    averageGrams: average,
    windowStart: range.start,
    windowEnd: range.end,
  );
}

/// Top-N category breakdown for the donut, aggregated across daily
/// summaries in the same trend window as [co2TrendData].
///
/// Categories beyond the top [_kTopCategoryCount] roll into a single
/// "Other" slice so the donut stays legible. Unknown category keys
/// (e.g. data written by a future build that introduced a new
/// category) flow into Other rather than being dropped.
@riverpod
Future<Co2CategoryData> co2CategoryData(Ref ref, TimePeriod period) async {
  final summaries = await ref.watch(
    trendWindowSummariesProvider(period).future,
  );
  return buildCategoryData(summaries);
}

/// Pure aggregator extracted from the provider so it can be unit
/// tested without firestore or auth. Exposed for tests via this
/// library's public surface.
Co2CategoryData buildCategoryData(List<DailySummaryModel> summaries) {
  final byCategory = <ActionCategory?, int>{};
  for (final summary in summaries) {
    summary.categoryCo2Grams.forEach((key, grams) {
      final cat = _tryParseCategory(key);
      byCategory.update(cat, (v) => v + grams, ifAbsent: () => grams);
    });
  }

  final total = byCategory.values.fold<int>(0, (a, b) => a + b);
  if (total == 0) return const Co2CategoryData(slices: [], totalGrams: 0);

  // Sort categories by grams desc; keep `null` (already-other) at the
  // end so it merges with the rolled-up tail cleanly.
  final knownEntries = byCategory.entries.where((e) => e.key != null).toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final preexistingOther = byCategory[null] ?? 0;

  final slices = <Co2CategorySlice>[];
  final topCount = knownEntries.length <= _kTopCategoryCount
      ? knownEntries.length
      : _kTopCategoryCount;

  for (var i = 0; i < topCount; i++) {
    final entry = knownEntries[i];
    slices.add(
      Co2CategorySlice(
        category: entry.key,
        grams: entry.value,
        percentage: entry.value / total * 100.0,
      ),
    );
  }

  final tailGrams =
      knownEntries.skip(topCount).fold<int>(0, (a, e) => a + e.value);
  final otherGrams = tailGrams + preexistingOther;
  if (otherGrams > 0) {
    slices.add(
      Co2CategorySlice(
        category: null,
        grams: otherGrams,
        percentage: otherGrams / total * 100.0,
      ),
    );
  }

  return Co2CategoryData(slices: slices, totalGrams: total);
}

const _kTopCategoryCount = 5;

DateTime _parseDateId(String dateId) {
  // `dateId` is always `YYYY-MM-DD` written by
  // DailySummaryRemoteDataSource; parse to local-midnight DateTime.
  final parts = dateId.split('-');
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

ActionCategory? _tryParseCategory(String key) {
  for (final c in ActionCategory.values) {
    if (c.name == key) return c;
  }
  return null;
}
