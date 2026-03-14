import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import '../providers/actions_providers.dart';

/// A dropdown button for selecting the sort order of actions.
class ActionSortDropdown extends ConsumerWidget {
  const ActionSortDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final selectedOption = ref.watch(selectedSortOptionProvider);

    return PopupMenuButton<ActionSortOption>(
      initialValue: selectedOption,
      onSelected: (option) {
        ref.read(selectedSortOptionProvider.notifier).select(option);
      },
      itemBuilder: (context) => ActionSortOption.values.map((option) {
        return PopupMenuItem<ActionSortOption>(
          value: option,
          child: Row(
            children: [
              Icon(
                _getIconForOption(option),
                size: 20,
                color: option == selectedOption
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option.displayName(l10n),
                  style: TextStyle(
                    color: option == selectedOption
                        ? theme.colorScheme.primary
                        : null,
                    fontWeight: option == selectedOption
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (option == selectedOption)
                Icon(
                  Icons.check,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconForOption(selectedOption),
              size: 18,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              selectedOption.displayName(l10n),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForOption(ActionSortOption option) {
    return switch (option) {
      ActionSortOption.alphabeticalAsc => Icons.arrow_downward,
      ActionSortOption.alphabeticalDesc => Icons.arrow_upward,
      ActionSortOption.co2HighToLow => Icons.arrow_downward,
      ActionSortOption.co2LowToHigh => Icons.arrow_upward,
      ActionSortOption.pointsHighToLow => Icons.arrow_downward,
      ActionSortOption.pointsLowToHigh => Icons.arrow_upward,
    };
  }
}
