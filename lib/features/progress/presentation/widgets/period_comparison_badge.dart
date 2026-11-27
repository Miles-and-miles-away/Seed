import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/progress/domain/entities/co2_stats.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';

/// Renders the period-over-period comparison line below the headline
/// total: an arrow, a percent, and a terse "vs. previous period"
/// reference. Returns an empty widget when no comparison is available
/// (all-time view, or previous total of 0).
class PeriodComparisonBadge extends StatelessWidget {
  const PeriodComparisonBadge({required this.stats, super.key});

  final Co2Stats stats;

  @override
  Widget build(BuildContext context) {
    if (!stats.hasComparison) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final isUp = stats.percentChange >= 0;
    final color = isUp ? theme.colorScheme.primary : theme.colorScheme.error;
    final icon = isUp ? Icons.arrow_upward : Icons.arrow_downward;

    final percent = formatDecimal(
      stats.percentChange.abs(),
      l10n.localeName,
      maxDigits: 0,
    );
    final label = switch (stats.period) {
      TimePeriod.today => l10n.comparisonVsYesterday(percent),
      TimePeriod.thisWeek => l10n.comparisonVsLastWeek(percent),
      TimePeriod.thisMonth => l10n.comparisonVsLastMonth(percent),
      TimePeriod.allTime => '$percent%',
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: spacingXs),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: color)),
      ],
    );
  }
}
