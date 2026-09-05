import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import '../providers/actions_providers.dart';

/// A compact sort control for the action list.
///
/// Icon-only because it shares the search row: labels run to "Puntos
/// (Mayor a menor)", which squeezed the field to 107px on a 360pt
/// phone. The tooltip and the menu's check name the active option.
class ActionSortDropdown extends ConsumerWidget {
  const ActionSortDropdown({super.key});

  /// Matches the search field's collapsed height beside it.
  static const _buttonSize = 48.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final selectedOption = ref.watch(selectedSortOptionProvider);

    return PopupMenuButton<ActionSortOption>(
      initialValue: selectedOption,
      tooltip: selectedOption.displayName(l10n),
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
              const SizedBox(width: spacingMd),
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
                Icon(Icons.check, size: 18, color: theme.colorScheme.primary),
            ],
          ),
        );
      }).toList(),
      child: Container(
        width: _buttonSize,
        height: _buttonSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.sort, size: 22, color: theme.colorScheme.primary),
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
