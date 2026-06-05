import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/domain/entities/co2_chart_data.dart';

/// Scatter-plot trend chart for daily CO2 across the dashboard's
/// rolling window. Each day with logged activity contributes one dot
/// at its actual calendar offset (so gaps in activity show as
/// horizontal gaps, not collapsed adjacent dots). A dashed horizontal
/// line marks the mean across days with data.
///
/// The widget takes [Co2TrendData] directly rather than reading the
/// provider itself so the dashboard can decide whether to render
/// (`data.isPlottable`) and so widget tests don't need provider
/// overrides for charts.
class Co2TrendChart extends StatelessWidget {
  const Co2TrendChart({required this.data, super.key});

  static const double height = 220;

  final Co2TrendData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.MMMd(locale);

    // x-axis is in days since windowStart so calendar gaps render
    // as visual gaps.
    final daysInWindow =
        data.windowEnd.difference(data.windowStart).inDays.toDouble();
    final maxX = math.max<double>(daysInWindow - 1, 1);

    final dotSpots = data.points
        .map(
          (p) => FlSpot(
            p.date.difference(data.windowStart).inDays.toDouble(),
            p.grams / 1000.0,
          ),
        )
        .toList(growable: false);

    final peakKg = dotSpots.fold<double>(0, (a, s) => math.max(a, s.y));
    // Pad headroom so dots don't sit on the top axis; floor at 0.5 kg
    // so a single tiny day doesn't render as a flat axis at y=0.
    final maxY = math.max(peakKg * 1.15, 0.5);
    final avgKg = data.averageGrams / 1000.0;

    final dotsSeries = LineChartBarData(
      spots: dotSpots,
      color: Colors.transparent,
      barWidth: 0,
      dotData: FlDotData(
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 4,
          color: theme.colorScheme.primary,
        ),
      ),
    );

    final avgColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
    final avgSeries = LineChartBarData(
      spots: [FlSpot(0, avgKg), FlSpot(maxX, avgKg)],
      color: avgColor,
      barWidth: 1.5,
      dashArray: const [4, 4],
      dotData: const FlDotData(show: false),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(
        spacingMd,
        spacingLg,
        spacingLg,
        spacingSm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: spacingSm),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.trendChartTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Inline legend for the average line so users know
                // what the dashed line represents.
                Container(
                  width: 16,
                  height: 1.5,
                  decoration: BoxDecoration(
                    color: avgColor,
                  ),
                ),
                const SizedBox(width: spacingXs),
                Text(
                  l10n.trendChartAverageLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: spacingSm),
          SizedBox(
            height: height,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: maxX,
                minY: 0,
                maxY: maxY,
                lineBarsData: [dotsSeries, avgSeries],
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: theme.dividerColor.withValues(alpha: 0.4),
                    strokeWidth: 0.5,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: _yAxisInterval(maxY),
                      getTitlesWidget: (value, meta) => Text(
                        value.toStringAsFixed(1),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: maxX,
                      getTitlesWidget: (value, meta) {
                        // Show only first, middle, last to keep
                        // labels readable across 7/30/90-day windows.
                        final mid = maxX / 2;
                        final epsilon = maxX * 0.02;
                        final atStart = value <= epsilon;
                        final atEnd = value >= maxX - epsilon;
                        final atMid = (value - mid).abs() <= epsilon;
                        if (!atStart && !atEnd && !atMid) {
                          return const SizedBox.shrink();
                        }
                        final date =
                            data.windowStart.add(Duration(days: value.round()));
                        return Padding(
                          padding: const EdgeInsets.only(top: spacingXs),
                          child: Text(
                            dateFormat.format(date),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touched) => touched.map((spot) {
                      // Avg line is barIndex 1; skip its tooltip so
                      // users don't tap the dashed line and get a
                      // confusing "average" duplicate at every x.
                      if (spot.barIndex != 0) return null;
                      final date =
                          data.windowStart.add(Duration(days: spot.x.round()));
                      return LineTooltipItem(
                        '${dateFormat.format(date)}\n'
                        '${spot.y.toStringAsFixed(1)} kg',
                        theme.textTheme.bodySmall ?? const TextStyle(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Pick a y-axis label interval that yields roughly 3-4 grid lines
  /// for a given max value. Avoids label crowding without going
  /// fully bespoke per scale.
  double _yAxisInterval(double maxY) {
    if (maxY <= 1) return 0.25;
    if (maxY <= 5) return 1;
    if (maxY <= 20) return 5;
    if (maxY <= 50) return 10;
    return 25;
  }
}
