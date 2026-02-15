import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/enums/action_category.dart';

/// Number of logical items: "All" + each category.
final _cycleLength = ActionCategory.values.length + 1;

/// Large multiplier so the list appears infinite.
const _repeatCount = 100;

/// Estimated average chip width for initial offset.
const _estimatedChipWidth = 100.0;

/// A tab bar for filtering actions by category.
/// Scrolls infinitely in a loop in both directions.
class ActionCategoryTabs extends StatefulWidget {
  const ActionCategoryTabs({
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  final ActionCategory? selectedCategory;
  final ValueChanged<ActionCategory?> onCategorySelected;

  @override
  State<ActionCategoryTabs> createState() =>
      _ActionCategoryTabsState();
}

class _ActionCategoryTabsState
    extends State<ActionCategoryTabs> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final midCycle = _repeatCount ~/ 2;
    final offset =
        midCycle * _cycleLength * _estimatedChipWidth;
    _scrollController = ScrollController(
      initialScrollOffset: offset,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 48,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        itemCount: _cycleLength * _repeatCount,
        itemBuilder: (context, index) {
          final i = index % _cycleLength;

          if (i == 0) {
            return Padding(
              padding:
                  const EdgeInsets.only(right: 8),
              child: _CategoryChip(
                label: l10n.allCategories,
                icon: Icons.grid_view,
                color: theme.colorScheme.primary,
                isSelected:
                    widget.selectedCategory == null,
                onTap: () => widget
                    .onCategorySelected(null),
              ),
            );
          }

          final category =
              ActionCategory.values[i - 1];
          return Padding(
            padding:
                const EdgeInsets.only(right: 8),
            child: _CategoryChip(
              label: category.displayName(l10n),
              icon: category.icon,
              color: category.color,
              isSelected:
                  widget.selectedCategory ==
                      category,
              onTap: () => widget
                  .onCategorySelected(category),
            ),
          );
        },
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
      labelStyle:
          theme.textTheme.labelMedium?.copyWith(
        color: isSelected
            ? Colors.white
            : theme.colorScheme.onSurface,
        fontWeight: isSelected
            ? FontWeight.bold
            : FontWeight.normal,
      ),
      backgroundColor: theme.colorScheme.surface,
      selectedColor: color,
      side: BorderSide(
        color: isSelected
            ? color
            : theme.colorScheme.outline
                .withValues(alpha: 0.3),
      ),
      onSelected: (_) => onTap(),
    );
  }
}
