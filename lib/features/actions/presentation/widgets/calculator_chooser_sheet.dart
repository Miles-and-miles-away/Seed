import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';

/// Bottom-sheet chooser for the three carbon calculators (Phase 8).
///
/// All three are live. Pops with the chosen route
/// so the caller navigates with a still-mounted context rather than
/// the sheet's disposed one.
class CalculatorChooserSheet extends StatefulWidget {
  const CalculatorChooserSheet({super.key});

  static Future<void> show(BuildContext context) async {
    final route = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      shape: sheetShape,
      builder: (_) => const CalculatorChooserSheet(),
    );
    if (route != null && context.mounted) await context.push(route);
  }

  @override
  State<CalculatorChooserSheet> createState() => _CalculatorChooserSheetState();
}

class _CalculatorChooserSheetState extends State<CalculatorChooserSheet> {
  final _sheetKey = GlobalKey();

  /// Index of the tile the walkthrough is explaining, or null.
  final _spotlight = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _spotlight.dispose();
    super.dispose();
  }

  /// The sheet's screen rect, extended up over the drag handle.
  Rect? _sheetRect() {
    final box = _sheetKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    return Rect.fromLTRB(
      rect.left,
      rect.top - kMinInteractiveDimension,
      rect.right,
      rect.bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tiles = [
      (
        icon: Icons.commute,
        color: ActionCategory.transport.color,
        label: l10n.categoryTransport,
        route: appRoutes.transportCalculator,
      ),
      (
        icon: Icons.restaurant,
        color: ActionCategory.food.color,
        label: l10n.categoryFood,
        route: appRoutes.foodCalculator,
      ),
      (
        icon: Icons.bolt,
        color: ActionCategory.energy.color,
        label: l10n.calculatorHomeEnergy,
        route: appRoutes.energyCalculator,
      ),
    ];
    return WalkthroughTrigger(
      item: WalkthroughItem.calculators,
      spotlight: _sheetRect,
      onPage: (page) => _spotlight.value = page,
      child: SafeArea(
        key: _sheetKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            spacingLg,
            0,
            spacingLg,
            spacingLg,
          ),
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
              ValueListenableBuilder<int?>(
                valueListenable: _spotlight,
                builder: (context, page, _) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final (i, tile) in tiles.indexed)
                      _CalculatorTile(
                        icon: tile.icon,
                        color: tile.color,
                        label: tile.label,
                        // Dim the tiles not being explained; the current
                        // one keeps its colour and gets a gold ring.
                        dimmed: page != null && page != i,
                        ringed: page == i,
                        onTap: () => Navigator.pop(context, tile.route),
                      ),
                  ],
                ),
              ),
            ],
          ),
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
    this.dimmed = false,
    this.ringed = false,
  });

  final IconData icon;
  final bool dimmed;
  final bool ringed;

  /// The domain's own colour, so the three calculators read as the same
  /// three categories the Action Log uses.
  final Color color;

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedOpacity(
      opacity: dimmed ? opacityMuted : 1,
      duration: durationNormal,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadiusMd,
        child: Padding(
          padding: const EdgeInsets.all(spacingSm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: ringed
                      ? Border.all(color: AppColors.gold, width: 3)
                      : null,
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: color.withValues(alpha: opacityLight),
                  child: Icon(icon, color: color),
                ),
              ),
              const SizedBox(height: spacingSm),
              Text(label, style: theme.textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
