import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/features/actions/domain/enums/action_category.dart';

part 'co2_chart_data.freezed.dart';

/// One day on the trend chart: a local-midnight date and the total
/// CO2 logged on that day in grams.
@freezed
abstract class Co2TrendPoint with _$Co2TrendPoint {
  const factory Co2TrendPoint({
    required DateTime date,
    required int grams,
  }) = _Co2TrendPoint;
}

/// Source data for the trend scatter chart: a list of daily points
/// in chronological order, the mean across those points (drawn as a
/// horizontal reference line), and the window bounds the points
/// live within so the chart can spread dots across calendar gaps
/// rather than collapsing them.
@freezed
abstract class Co2TrendData with _$Co2TrendData {
  const factory Co2TrendData({
    required List<Co2TrendPoint> points,
    required double averageGrams,
    required DateTime windowStart,
    required DateTime windowEnd,
  }) = _Co2TrendData;

  const Co2TrendData._();

  /// A 1-point chart isn't a trend. Hide the widget until the user
  /// has activity on at least two distinct days in the window.
  bool get isPlottable => points.length >= 2;
}

/// One wedge on the donut: an action category (null = lumped
/// "Other" bucket), its absolute CO2 contribution in grams, and its
/// share of the total expressed as a 0-100 percentage.
@freezed
abstract class Co2CategorySlice with _$Co2CategorySlice {
  const factory Co2CategorySlice({
    required ActionCategory? category,
    required int grams,
    required double percentage,
  }) = _Co2CategorySlice;

  const Co2CategorySlice._();

  /// Convenience: `true` for the lumped "Other" wedge, `false` for
  /// real categories.
  bool get isOther => category == null;
}

/// Source data for the category donut: slices sorted from largest to
/// smallest (Other always last when present) plus the total CO2 the
/// donut covers. Empty when nothing in the period has a category
/// breakdown (typically because older daily summaries pre-date the
/// `categoryCo2Grams` field).
@freezed
abstract class Co2CategoryData with _$Co2CategoryData {
  const factory Co2CategoryData({
    required List<Co2CategorySlice> slices,
    required int totalGrams,
  }) = _Co2CategoryData;

  const Co2CategoryData._();

  /// Whether the donut should render. Hide when there is no
  /// category-tagged data at all in the period.
  bool get isPlottable => totalGrams > 0 && slices.isNotEmpty;
}
