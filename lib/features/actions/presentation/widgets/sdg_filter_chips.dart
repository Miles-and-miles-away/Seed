import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/presentation/widgets/filter_chip_row.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import '../providers/actions_providers.dart';

/// SDG filter row: rounded-rect chips with a numbered circle, under
/// the category row's stadium chips with a leading icon. Height, fill
/// and label size are shared through [filterChip].
class SdgFilterChips extends ConsumerWidget {
  const SdgFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final selectedSdg = ref.watch(selectedSdgFilterProvider);
    final goals = ref.watch(sdgGoalsDataProvider).value?.goals;

    if (goals == null) {
      return const SizedBox(height: spacingHuge);
    }

    final shape = RoundedRectangleBorder(borderRadius: borderRadiusXl);
    final notifier = ref.read(selectedSdgFilterProvider.notifier);

    return FilterChipRow(
      optionCount: goals.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return filterChip(
            context,
            label: l10n.allCategories,
            isSelected: selectedSdg == null,
            accent: theme.colorScheme.primary,
            onAccent: theme.colorScheme.onPrimary,
            shape: shape,
            onTap: notifier.clear,
          );
        }

        final sdg = goals[index - 1];
        final isSelected = selectedSdg == sdg.number;
        return filterChip(
          context,
          label: sdg.shortTitle(locale),
          isSelected: isSelected,
          accent: sdg.color,
          onAccent: Colors.white,
          shape: shape,
          // The checkmark takes the badge's place when selected.
          avatar: isSelected ? null : _numberBadge(sdg.number, sdg.color),
          onTap: () =>
              isSelected ? notifier.clear() : notifier.select(sdg.number),
        );
      },
    );
  }
}

Widget _numberBadge(int number, Color color) => CircleAvatar(
  backgroundColor: color,
  radius: 12,
  child: Text(
    '$number',
    style: const TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
  ),
);
