import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import '../providers/actions_providers.dart';

// ignore_for_file: constant_identifier_names

/// "All" chip + 17 SDGs = 18 logical items.
const _CYCLE_LENGTH = 18;

/// Large multiplier so the list appears infinite.
const _REPEAT_COUNT = 100;

/// Estimated average chip width for initial offset.
const _ESTIMATED_CHIP_WIDTH = 100.0;

/// Horizontal scrollable chips for filtering by SDG.
/// Scrolls infinitely in a loop in both directions.
class SdgFilterChips extends ConsumerStatefulWidget {
  const SdgFilterChips({super.key});

  @override
  ConsumerState<SdgFilterChips> createState() => _SdgFilterChipsState();
}

class _SdgFilterChipsState extends ConsumerState<SdgFilterChips> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final midCycle = _REPEAT_COUNT ~/ 2;
    final offset = midCycle * _CYCLE_LENGTH * _ESTIMATED_CHIP_WIDTH;
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
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final selectedSdg = ref.watch(selectedSdgFilterProvider);
    final goals = ref.watch(sdgGoalsDataProvider).value?.goals;

    if (goals == null) {
      return const SizedBox(height: 40);
    }

    final cycleLength = goals.length + 1;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLg,
        ),
        itemCount: cycleLength * _REPEAT_COUNT,
        itemBuilder: (context, index) {
          final i = index % cycleLength;

          // "All" chip
          if (i == 0) {
            final isSelected = selectedSdg == null;
            return Padding(
              padding: const EdgeInsets.only(right: spacingSm),
              child: FilterChip(
                label: Text(l10n.allCategories),
                selected: isSelected,
                onSelected: (_) {
                  ref
                      .read(
                        selectedSdgFilterProvider.notifier,
                      )
                      .clear();
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
                  borderRadius: borderRadiusXl,
                ),
              ),
            );
          }

          // SDG chips
          final sdg = goals[i - 1];
          final isSelected = selectedSdg == sdg.number;

          return Padding(
            padding: const EdgeInsets.only(right: spacingSm),
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
              label: Text(sdg.shortTitle(locale)),
              selected: isSelected,
              onSelected: (_) {
                if (isSelected) {
                  ref
                      .read(
                        selectedSdgFilterProvider.notifier,
                      )
                      .clear();
                } else {
                  ref
                      .read(
                        selectedSdgFilterProvider.notifier,
                      )
                      .select(sdg.number);
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
                borderRadius: borderRadiusXl,
              ),
            ),
          );
        },
      ),
    );
  }
}
