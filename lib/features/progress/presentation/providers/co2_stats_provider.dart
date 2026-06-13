import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
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
/// Keyed on the user id (not the whole user doc) so logging an action
/// does not implicitly re-run the queries; ActionLogNotifier and
/// dayChangeProvider invalidate this explicitly when the data moves.
@riverpod
Future<Co2Stats> co2Stats(Ref ref, TimePeriod period) async {
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
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
    // Already aggregated on the user doc; watching just this field is
    // cheap and keeps the all-time figure live.
    currentTotal = ref.watch(
      currentUserProvider.select((user) => user.value?.totalCo2Grams ?? 0),
    );
    previousTotal = 0;
  } else {
    final currentRange = TimePeriodRange.current(period, now: now);
    final previousRange = TimePeriodRange.previous(period, now: now);

    final currentSummaries = await repository.getSummariesForDateRange(
      userId,
      currentRange.start,
      currentRange.end,
    );
    currentTotal = currentSummaries.fold<int>(
      0,
      (sum, s) => sum + s.totalCo2Grams,
    );

    final previousSummaries = await repository.getSummariesForDateRange(
      userId,
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
