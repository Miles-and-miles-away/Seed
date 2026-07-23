import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// Bottom-sheet chooser for the three carbon calculators (Phase 8).
///
/// Transport and food are live; home energy (Part 3) is shown disabled
/// until its calculator ships. Pops with the chosen route
/// so the caller navigates with a still-mounted context rather than
/// the sheet's disposed one.
class CalculatorChooserSheet extends StatelessWidget {
  const CalculatorChooserSheet({super.key});

  static Future<void> show(BuildContext context) async {
    final route = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
      builder: (_) => const CalculatorChooserSheet(),
    );
    if (route != null && context.mounted) await context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(spacingLg, 0, spacingLg, spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.calculatorsSheetTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: spacingLg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CalculatorTile(
                  icon: Icons.commute,
                  label: l10n.categoryTransport,
                  onTap: () =>
                      Navigator.pop(context, appRoutes.transportCalculator),
                ),
                _CalculatorTile(
                  icon: Icons.restaurant,
                  label: l10n.categoryFood,
                  onTap: () => Navigator.pop(context, appRoutes.foodCalculator),
                ),
                _CalculatorTile(
                  icon: Icons.bolt,
                  label: l10n.calculatorHomeEnergy,
                  comingSoonLabel: l10n.calculatorComingSoon,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One calculator option. Disabled (null [onTap]) tiles dim and show a
/// "coming soon" caption instead of being tappable.
class _CalculatorTile extends StatelessWidget {
  const _CalculatorTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.comingSoonLabel,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? comingSoonLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadiusMd,
        child: Padding(
          padding: const EdgeInsets.all(spacingSm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: enabled
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest,
                child: Icon(
                  icon,
                  color: enabled
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: spacingSm),
              Text(label, style: theme.textTheme.labelLarge),
              if (comingSoonLabel != null)
                Text(
                  comingSoonLabel!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
