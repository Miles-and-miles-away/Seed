import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_sheet.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_locked_sheet.dart';

/// Card for a single Eco-Dex entry (locked or discovered).
class EcoDexEntryCard extends StatelessWidget {
  const EcoDexEntryCard({
    required this.entryState,
    required this.locale,
    super.key,
  });

  final EcoDexEntryState entryState;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDiscovered = entryState.isDiscovered;
    final entry = entryState.entry;

    return GestureDetector(
      onTap: () {
        if (isDiscovered) {
          _showEntrySheet(context);
        } else {
          _showLockedSheet(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDiscovered
              ? theme.colorScheme.primaryContainer.withValues(
                  alpha: Opacities.medium,
                )
              : theme.colorScheme.surfaceContainerHigh.withValues(
                  alpha: Opacities.half,
                ),
          borderRadius: Radii.borderMd,
          border: isDiscovered
              ? Border.all(
                  color: theme.colorScheme.primary.withValues(
                    alpha: Opacities.muted,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isDiscovered)
              Icon(
                _categoryIcon(entry.category),
                size: 28,
                color: theme.colorScheme.primary,
              )
            else
              Icon(
                Icons.lock_outline,
                size: 24,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: Opacities.disabled,
                ),
              ),
            const SizedBox(height: Spacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.xs,
              ),
              child: Text(
                isDiscovered ? entry.name(locale) : '???',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isDiscovered
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: Opacities.disabled,
                        ),
                  fontWeight:
                      isDiscovered ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEntrySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Radii.xl),
        ),
      ),
      builder: (_) => EcoDexEntrySheet(
        entry: entryState.entry,
        locale: locale,
      ),
    );
  }

  void _showLockedSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Radii.xl),
        ),
      ),
      builder: (_) => EcoDexLockedSheet(
        entry: entryState.entry,
        locale: locale,
      ),
    );
  }

  IconData _categoryIcon(String category) {
    return switch (category) {
      'climate' => Icons.thermostat,
      'oceans' => Icons.water,
      'food_systems' => Icons.restaurant,
      'biodiversity' => Icons.park,
      'energy' => Icons.bolt,
      'circular_economy' => Icons.recycling,
      'people_planet' => Icons.public,
      'your_journey' => Icons.flag,
      _ => Icons.eco,
    };
  }
}
