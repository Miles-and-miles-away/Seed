import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

/// Categories for eco-friendly actions.
enum ActionCategory {
  recycling,
  transport,
  food,
  energy,
  consumption,
  water,
  community;

  /// Returns the color associated with this category.
  Color get color {
    return switch (this) {
      ActionCategory.recycling => AppColors.categoryRecycling,
      ActionCategory.transport => AppColors.categoryTransport,
      ActionCategory.food => AppColors.categoryFood,
      ActionCategory.energy => AppColors.categoryEnergy,
      ActionCategory.consumption =>
        AppColors.categoryConsumption,
      ActionCategory.water => AppColors.categoryWater,
      ActionCategory.community => AppColors.categoryCommunity,
    };
  }

  /// Returns the icon for this category.
  IconData get icon {
    return switch (this) {
      ActionCategory.recycling => Icons.recycling,
      ActionCategory.transport => Icons.directions_bike,
      ActionCategory.food => Icons.restaurant,
      ActionCategory.energy => Icons.bolt,
      ActionCategory.consumption => Icons.shopping_bag,
      ActionCategory.water => Icons.water_drop,
      ActionCategory.community => Icons.volunteer_activism,
    };
  }

  /// Returns the localized display name for this category.
  String displayName(AppLocalizations l10n) {
    return switch (this) {
      ActionCategory.recycling => l10n.categoryRecycling,
      ActionCategory.transport => l10n.categoryTransport,
      ActionCategory.food => l10n.categoryFood,
      ActionCategory.energy => l10n.categoryEnergy,
      ActionCategory.consumption => l10n.categoryConsumption,
      ActionCategory.water => l10n.categoryWater,
      ActionCategory.community => l10n.categoryCommunity,
    };
  }

  /// Creates an ActionCategory from a string value.
  /// Returns null if the string doesn't match any category.
  static ActionCategory? fromString(String? value) {
    if (value == null) return null;
    return ActionCategory.values.cast<ActionCategory?>().firstWhere(
          (c) => c?.name == value.toLowerCase(),
          orElse: () => null,
        );
  }
}
