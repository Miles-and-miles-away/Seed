import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';

/// Bottom-sheet chooser for the three carbon calculators (Phase 8).
///
/// All three are live. Pops with the chosen route
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
                  color: ActionCategory.transport.color,
                  label: l10n.categoryTransport,
                  onTap: () =>
                      Navigator.pop(context, appRoutes.transportCalculator),
                ),
                _CalculatorTile(
                  icon: Icons.restaurant,
                  color: ActionCategory.food.color,
                  label: l10n.categoryFood,
                  onTap: () => Navigator.pop(context, appRoutes.foodCalculator),
                ),
                _CalculatorTile(
                  icon: Icons.bolt,
                  color: ActionCategory.energy.color,
                  label: l10n.calculatorHomeEnergy,
                  onTap: () =>
                      Navigator.pop(context, appRoutes.energyCalculator),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One calculator option.
class _CalculatorTile extends StatelessWidget {
  const _CalculatorTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;

  /// The domain's own colour, so the three calculators read as the same
  /// three categories the Action Log uses.
  final Color color;

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadiusMd,
      child: Padding(
        padding: const EdgeInsets.all(spacingSm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withValues(alpha: opacityLight),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: spacingSm),
            Text(label, style: theme.textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}
