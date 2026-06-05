import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/domain/entities/co2_stats.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/presentation/widgets/period_comparison_badge.dart';

/// Headline card on the Impact dashboard: the total CO2 saved for the
/// selected period in kilograms (one decimal), the period header,
/// and a comparison badge against the previous equivalent period.
class Co2TotalCard extends StatelessWidget {
  const Co2TotalCard({required this.stats, super.key});

  final Co2Stats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final headerText = switch (stats.period) {
      TimePeriod.today => l10n.co2SavedToday,
      TimePeriod.thisWeek => l10n.co2SavedThisWeek,
      TimePeriod.thisMonth => l10n.co2SavedThisMonth,
      TimePeriod.allTime => l10n.co2SavedAllTime,
    };

    final kgText = '${stats.totalKg.toStringAsFixed(1)} ${l10n.kgUnit}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(spacingXl),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(
          alpha: opacityMedium,
        ),
        borderRadius: borderRadiusLg,
      ),
      child: Column(
        children: [
          Text(
            kgText,
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: spacingXs),
          Text(
            headerText,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: spacingMd),
          PeriodComparisonBadge(stats: stats),
        ],
      ),
    );
  }
}
