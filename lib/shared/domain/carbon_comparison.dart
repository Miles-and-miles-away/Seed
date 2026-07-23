import 'dart:math';

import 'package:flutter/foundation.dart';

/// Best/worst summary of 2-3 option totals for a calculator comparison
/// view (Phase 8). Pure arithmetic; the widget layer owns labels, bars,
/// and the "emits X less" copy.
@immutable
class ComparisonSummary {
  const ComparisonSummary({
    required this.bestIndex,
    required this.worstIndex,
    required this.deltaGrams,
    required this.deltaPercent,
  });

  /// Index (into the input list) of the lowest-emitting option.
  final int bestIndex;

  /// Index of the highest-emitting option (bars scale to this).
  final int worstIndex;

  /// worst - best, in grams CO2e (>= 0).
  final double deltaGrams;

  /// Reduction of best relative to worst, 0-100. Zero when the worst
  /// option emits nothing (all-zero comparison, e.g. walk vs cycle).
  final double deltaPercent;
}

/// Summarises [totals] (grams CO2e per option) for a comparison view.
/// Returns null for fewer than two options -- there is no comparison to
/// draw. The first minimum/maximum wins ties, so the summary is stable
/// across rebuilds.
ComparisonSummary? compareTotals(List<double> totals) {
  if (totals.length < 2) return null;
  var bestIndex = 0;
  var worstIndex = 0;
  for (var i = 1; i < totals.length; i++) {
    if (totals[i] < totals[bestIndex]) bestIndex = i;
    if (totals[i] > totals[worstIndex]) worstIndex = i;
  }
  final worst = totals[worstIndex];
  final delta = worst - totals[bestIndex];
  return ComparisonSummary(
    bestIndex: bestIndex,
    worstIndex: worstIndex,
    deltaGrams: delta,
    deltaPercent: worst <= 0 ? 0 : delta / worst * 100,
  );
}

/// Points awarded for banking a calculator choice (Phase 8).
///
/// The library uses `co2Grams^0.4 x effort x rarity x impact`, but a user
/// comparison has no human-rated effort/rarity/impact, so this applies
/// the CO2 term with neutral (1.0) multipliers. Floors at 1 so any honest
/// choice is worth logging.
int choicePoints(int co2Grams) {
  if (co2Grams <= 0) return 1;
  return max(1, pow(co2Grams, 0.4).round());
}
