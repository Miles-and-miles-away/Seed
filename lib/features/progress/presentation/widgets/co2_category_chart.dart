import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/domain/entities/co2_chart_data.dart';

/// Donut chart + legend showing which action categories drove the
/// user's CO2 savings across the dashboard's current window.
///
/// Slices come pre-sorted from [Co2CategoryData], with everything
/// outside the top 5 already rolled into a single "Other" wedge.
/// The center of the donut shows the total kg the donut represents;
/// the legend below lists each slice with its localized name, color,
/// and share percentage.
class Co2CategoryChart extends StatelessWidget {
  const Co2CategoryChart({required this.data, super.key});

  static const double _donutHeight = 180;
  static const double _centerSpaceRadius = 52;
  static const double _sectionRadius = 30;

  final Co2CategoryData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final otherColor = theme.colorScheme.outlineVariant.withValues(
      alpha: opacityHeavy,
    );

    final totalKg = data.totalGrams / 1000.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        spacingLg,
        spacingLg,
        spacingLg,
        spacingMd,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.categoryChartTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: spacingMd),
          SizedBox(
            height: _donutHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: _centerSpaceRadius,
                    sections: [
                      for (final slice in data.slices)
                        PieChartSectionData(
                          value: slice.grams.toDouble(),
                          color: slice.category?.color ?? otherColor,
                          radius: _sectionRadius,
                          showTitle: false,
                        ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      totalKg.toStringAsFixed(1),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.kgUnit,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: spacingMd),
          _Legend(slices: data.slices, otherColor: otherColor),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.slices, required this.otherColor});

  final List<Co2CategorySlice> slices;
  final Color otherColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Wrap(
      spacing: spacingMd,
      runSpacing: spacingXs,
      children: [
        for (final slice in slices)
          _LegendItem(
            color: slice.category?.color ?? otherColor,
            label: slice.isOther
                ? l10n.categoryOther
                : slice.category!.displayName(l10n),
            percentage: slice.percentage,
          ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.percentage,
  });

  final Color color;
  final String label;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: spacingXs),
        Text(label, style: theme.textTheme.labelMedium),
        const SizedBox(width: spacingXxs),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
