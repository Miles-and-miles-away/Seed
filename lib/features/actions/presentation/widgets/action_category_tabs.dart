import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/actions/presentation/widgets/filter_chip_row.dart';

/// Category filter row: stadium chips with a leading icon, over the
/// SDG row's rounded-rect chips with a numbered circle.
class ActionCategoryTabs extends StatelessWidget {
  const ActionCategoryTabs({
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  final ActionCategory? selectedCategory;
  final ValueChanged<ActionCategory?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return FilterChipRow(
      optionCount: ActionCategory.values.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return filterChip(
            context,
            label: l10n.allCategories,
            isSelected: selectedCategory == null,
            accent: theme.colorScheme.primary,
            onAccent: theme.colorScheme.onPrimary,
            showCheckmark: false,
            avatar: Icon(
              Icons.grid_view,
              size: 18,
              color: selectedCategory == null
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
            onTap: () => onCategorySelected(null),
          );
        }

        final category = ActionCategory.values[index - 1];
        final isSelected = selectedCategory == category;
        return filterChip(
          context,
          label: category.displayName(l10n),
          isSelected: isSelected,
          accent: category.color,
          onAccent: Colors.white,
          showCheckmark: false,
          avatar: Icon(
            category.icon,
            size: 18,
            color: isSelected ? Colors.white : category.color,
          ),
          // Clears back to All on a second tap, like the SDG chips.
          onTap: () => onCategorySelected(isSelected ? null : category),
        );
      },
    );
  }
}
