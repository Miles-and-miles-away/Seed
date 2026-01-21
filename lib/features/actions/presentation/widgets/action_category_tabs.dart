import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/enums/action_category.dart';

/// A tab bar for filtering actions by category.
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

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All" tab
          _CategoryChip(
            label: 'All',
            icon: Icons.grid_view,
            color: theme.colorScheme.primary,
            isSelected: selectedCategory == null,
            onTap: () => onCategorySelected(null),
          ),
          const SizedBox(width: 8),
          // Category tabs
          ...ActionCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _CategoryChip(
                label: category.displayName(l10n),
                icon: category.icon,
                color: category.color,
                isSelected: selectedCategory == category,
                onTap: () => onCategorySelected(category),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      selected: isSelected,
      showCheckmark: false,
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? Colors.white : color,
      ),
      label: Text(label),
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: theme.colorScheme.surface,
      selectedColor: color,
      side: BorderSide(
        color: isSelected ? color : theme.colorScheme.outline.withValues(alpha: 0.3),
      ),
      onSelected: (_) => onTap(),
    );
  }
}
