import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
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

    final reference = switch (stats.period) {
      TimePeriod.today => l10n.vsYesterday,
      TimePeriod.thisWeek => l10n.vsLastWeek,
      TimePeriod.thisMonth => l10n.vsLastMonth,
      TimePeriod.allTime => '',
    };

    final percent = stats.percentChange.abs().toStringAsFixed(0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: Spacing.xs),
        Text(
          '$percent% $reference',
          style: theme.textTheme.bodyMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
