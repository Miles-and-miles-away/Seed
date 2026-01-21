import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../data/models/action_model.dart';
import '../../domain/enums/action_category.dart';

/// A card widget displaying an action that can be logged.
class ActionCard extends StatelessWidget {
  const ActionCard({
    required this.action,
    required this.languageCode,
    required this.onTap,
    super.key,
  });

  final ActionModel action;
  final String languageCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = ActionCategory.fromString(action.category);
    final categoryColor = category?.color ?? theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category color accent bar
            Container(
              height: 4,
              color: categoryColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Icon(
                      _getIconData(action.iconName),
                      size: 36,
                      color: categoryColor,
                    ),
                    const SizedBox(height: 8),
                    // Action name
                    Text(
                      action.name(languageCode),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Points badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.pointsLabel(action.points),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: categoryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Maps icon name strings to IconData.
  IconData _getIconData(String iconName) {
    return switch (iconName) {
      'recycling' => Icons.recycling,
      'delete' => Icons.delete_outline,
      'local_drink' => Icons.local_drink,
      'shopping_bag' => Icons.shopping_bag,
      'coffee' => Icons.coffee,
      'bike' => Icons.directions_bike,
      'bus' => Icons.directions_bus,
      'train' => Icons.directions_transit,
      'restaurant' => Icons.restaurant,
      'eco' => Icons.eco,
      'compost' => Icons.compost,
      'shopping' => Icons.shopping_cart,
      'bolt' => Icons.bolt,
      'power' => Icons.power_off,
      'dry_cleaning' => Icons.dry_cleaning,
      'water_drop' => Icons.water_drop,
      'shower' => Icons.shower,
      'local_grocery' => Icons.local_grocery_store,
      'takeout' => Icons.takeout_dining,
      _ => Icons.eco,
    };
  }
}
