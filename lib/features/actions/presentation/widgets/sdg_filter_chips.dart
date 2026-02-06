import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../sdg/data/sdg_data.dart';
import '../providers/actions_providers.dart';

/// Horizontal scrollable chips for filtering actions by SDG.
class SdgFilterChips extends ConsumerWidget {
  const SdgFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final selectedSdg = ref.watch(selectedSdgFilterProvider);

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: sdgGoals.length + 1, // +1 for "All" chip
        itemBuilder: (context, index) {
          // First chip is "All"
          if (index == 0) {
            final isSelected = selectedSdg == null;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(l10n.allCategories),
                selected: isSelected,
                onSelected: (_) {
                  ref.read(selectedSdgFilterProvider.notifier).clear();
                },
                labelStyle: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                selectedColor: theme.colorScheme.primary,
                checkmarkColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }

          // SDG chips
          final sdg = sdgGoals[index - 1];
          final isSelected = selectedSdg == sdg.number;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              avatar: isSelected
                  ? null
                  : CircleAvatar(
                      backgroundColor: sdg.color,
                      radius: 12,
                      child: Text(
                        '${sdg.number}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              label: Text(sdg.shortTitle),
              selected: isSelected,
              onSelected: (_) {
                if (isSelected) {
                  ref.read(selectedSdgFilterProvider.notifier).clear();
                } else {
                  ref.read(selectedSdgFilterProvider.notifier).select(sdg.number);
                }
              },
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              selectedColor: sdg.color,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}
