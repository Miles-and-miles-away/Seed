import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_stats_provider.dart';
import 'package:seed_app/features/progress/presentation/widgets/co2_total_card.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_info_sheet.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_row.dart';
import 'package:seed_app/features/progress/presentation/widgets/time_period_selector.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// The Impact segment body on the Progress screen. Owns the selected
/// [TimePeriod] state, renders the period selector + headline total
/// card, and reserves vertical space for the §6.3 (equivalencies) and
/// §6.4 (charts) sections that ship later.
class ImpactDashboard extends ConsumerStatefulWidget {
  const ImpactDashboard({super.key});

  @override
  ConsumerState<ImpactDashboard> createState() => _ImpactDashboardState();
}

class _ImpactDashboardState extends ConsumerState<ImpactDashboard> {
  TimePeriod _period = TimePeriod.today;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final statsAsync = ref.watch(co2StatsProvider(_period));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TimePeriodSelector(
            selected: _period,
            onChanged: (p) => setState(() => _period = p),
          ),
          const SizedBox(height: Spacing.lg),
          statsAsync.when(
            data: (stats) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Co2TotalCard(stats: stats),
                // Equivalencies make no sense at zero -- four "0"
                // cards read as failure. Hide the whole section
                // until the user has logged at least one action.
                if (stats.totalGrams > 0) ...[
                  const SizedBox(height: Spacing.lg),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: Spacing.xs),
                        child: Text(
                          l10n.equivalentToHeader,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline, size: 18),
                        tooltip: l10n.impactInfoTooltip,
                        color: theme.colorScheme.onSurfaceVariant,
                        visualDensity: VisualDensity.compact,
                        onPressed: () => EquivalencyInfoSheet.show(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.sm),
                  EquivalencyRow(totalGrams: stats.totalGrams),
                ],
              ],
            ),
            loading: () => const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox(
              height: 160,
              child: Center(child: ErrorDisplay()),
            ),
          ),
          // 6.4 Charts will mount below here.
          const SizedBox(height: Spacing.xxl),
        ],
      ),
    );
  }
}
