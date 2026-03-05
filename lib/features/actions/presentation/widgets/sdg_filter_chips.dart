import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../sdg/data/sdg_data.dart';
import '../providers/actions_providers.dart';

/// Number of logical items: "All" + 17 SDGs.
final _cycleLength = sdgGoals.length + 1;

/// Large multiplier so the list appears infinite.
const _repeatCount = 100;

/// Estimated average chip width for initial offset.
const _estimatedChipWidth = 100.0;

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
    final midCycle = _repeatCount ~/ 2;
    final offset = midCycle * _cycleLength * _estimatedChipWidth;
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
    final theme = Theme.of(context);
    final selectedSdg = ref.watch(selectedSdgFilterProvider);

    return SizedBox(
      height: 40,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        itemCount: _cycleLength * _repeatCount,
        itemBuilder: (context, index) {
          final i = index % _cycleLength;

          // "All" chip
          if (i == 0) {
            final isSelected = selectedSdg == null;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
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
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }

          // SDG chips
          final sdg = sdgGoals[i - 1];
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
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}
