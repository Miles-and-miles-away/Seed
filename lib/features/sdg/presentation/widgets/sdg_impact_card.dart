import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import '../providers/sdg_stats_provider.dart';

/// Displays the user's impact stats for a specific SDG.
class SdgImpactCard extends ConsumerWidget {
  const SdgImpactCard({
    required this.goalNumber,
    required this.goalColor,
    super.key,
  });

  final int goalNumber;
  final Color goalColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final stats = ref.watch(
      sdgStatsProvider(goalNumber),
    );

    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: Radii.borderLg,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(
            alpha: Opacities.half,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insights,
                color: goalColor,
                size: 20,
              ),
              const SizedBox(width: Spacing.sm),
              Text(
                l10n.sdgYourImpact,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.check_circle_outline,
                  value: stats.actionsLogged.toString(),
                  label: l10n.sdgActionsLogged(
                    stats.actionsLogged,
                  ),
                  color: goalColor,
                ),
              ),
              const SizedBox(width: Spacing.lg),
              Expanded(
                child: _StatTile(
                  icon: Icons.eco,
                  value: formatCO2Compact(
                    stats.co2SavedGrams,
                  ),
                  label: l10n.sdgCo2SavedForGoal(
                    formatCO2Compact(
                      stats.co2SavedGrams,
                    ),
                  ),
                  color: goalColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: Radii.borderMd,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: Spacing.sm),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
