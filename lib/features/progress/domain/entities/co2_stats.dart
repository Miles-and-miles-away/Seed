import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/features/progress/domain/entities/time_period.dart';

part 'co2_stats.freezed.dart';

/// Aggregated CO2 totals for a given [TimePeriod], plus the total for
/// the previous period of the same length, used to drive the
/// period-over-period comparison badge on the Impact dashboard.
@freezed
abstract class Co2Stats with _$Co2Stats {
  const factory Co2Stats({
    required int totalGrams,
    required int previousTotalGrams,
    required double percentChange,
    required TimePeriod period,
  }) = _Co2Stats;

  const Co2Stats._();

  /// Whether the comparison badge should be shown. Hidden for all-time
  /// (no meaningful previous period) and when the previous total is 0
  /// (avoids divide-by-zero / "+infinity%" labels).
  bool get hasComparison =>
      period != TimePeriod.allTime && previousTotalGrams > 0;

  /// Convenience: the total expressed in kilograms with one decimal,
  /// e.g. 412g -> 0.4, 2543g -> 2.5, 42008g -> 42.0.
  double get totalKg => totalGrams / 1000.0;
}
