import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/progress/domain/entities/co2_stats.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/domain/services/time_period_range.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';

part 'co2_stats_provider.g.dart';

/// Aggregated CO2 totals for the Impact dashboard.
///
/// Computes the sum of `totalCo2Grams` across daily summaries in the
/// requested period and the equivalent previous-period total used for
/// the period-over-period comparison badge.
///
/// For [TimePeriod.allTime] we read `user.totalCo2Grams` directly
/// (already aggregated on the user doc) and treat the previous period
/// as zero-width so the comparison badge stays hidden.
@riverpod
Future<Co2Stats> co2Stats(Ref ref, TimePeriod period) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) {
    return Co2Stats(
      totalGrams: 0,
      previousTotalGrams: 0,
      percentChange: 0,
      period: period,
    );
  }

  final now = DateTime.now();
  final repository = ref.watch(progressRepositoryProvider);

  final int currentTotal;
  final int previousTotal;

  if (period == TimePeriod.allTime) {
    currentTotal = user.totalCo2Grams;
    previousTotal = 0;
  } else {
    final currentRange = TimePeriodRange.current(period, now: now);
    final previousRange = TimePeriodRange.previous(period, now: now);

    final currentSummaries = await repository.getSummariesForDateRange(
      user.uid,
      currentRange.start,
      currentRange.end,
    );
    currentTotal = currentSummaries.fold<int>(
      0,
      (sum, s) => sum + s.totalCo2Grams,
    );

    final previousSummaries = await repository.getSummariesForDateRange(
      user.uid,
      previousRange.start,
      previousRange.end,
    );
    previousTotal = previousSummaries.fold<int>(
      0,
      (sum, s) => sum + s.totalCo2Grams,
    );
  }

  final percentChange = previousTotal > 0
      ? ((currentTotal - previousTotal) / previousTotal) * 100.0
      : 0.0;

  return Co2Stats(
    totalGrams: currentTotal,
    previousTotalGrams: previousTotal,
    percentChange: percentChange,
    period: period,
  );
}
