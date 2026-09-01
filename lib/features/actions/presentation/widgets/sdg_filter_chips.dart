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

/// The numbered circle that distinguishes an SDG chip from a category
/// chip. Square-ish rows above, circles here.
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

/// Both chips in this row: white fill, outlined, accent when selected.
Widget _chip(
  ThemeData theme, {
  required Widget label,
  required bool isSelected,
  required Color accent,
  required Color onAccent,
  required VoidCallback onTap,
  Widget? avatar,
}) => Padding(
  padding: const EdgeInsets.only(right: spacingSm),
  child: FilterChip(
    avatar: avatar,
    label: label,
    selected: isSelected,
    onSelected: (_) => onTap(),
    labelStyle: theme.textTheme.labelMedium?.copyWith(
      color: isSelected ? onAccent : theme.colorScheme.onSurfaceVariant,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
    ),
    backgroundColor: theme.colorScheme.surface,
    selectedColor: accent,
    checkmarkColor: onAccent,
    shape: RoundedRectangleBorder(borderRadius: borderRadiusXl),
    side: BorderSide(
      color: isSelected
          ? accent
          : theme.colorScheme.outline.withValues(alpha: opacityMuted),
    ),
  ),
);

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
    _scrollController = ScrollController(initialScrollOffset: offset);
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
      return const SizedBox(height: spacingHuge);
    }

    final cycleLength = goals.length + 1;

    // Height, fill and label size are shared with the category row
    // above; the shape and avatar stay different on purpose.
    return SizedBox(
      height: spacingHuge,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: spacingLg),
        itemCount: cycleLength * _REPEAT_COUNT,
        itemBuilder: (context, index) {
          final i = index % cycleLength;

          if (i == 0) {
            final isSelected = selectedSdg == null;
            return _chip(
              theme,
              label: Text(l10n.allCategories),
              isSelected: isSelected,
              accent: theme.colorScheme.primary,
              onAccent: theme.colorScheme.onPrimary,
              onTap: () => ref.read(selectedSdgFilterProvider.notifier).clear(),
            );
          }

          final sdg = goals[i - 1];
          final isSelected = selectedSdg == sdg.number;
          return _chip(
            theme,
            label: Text(sdg.shortTitle(locale)),
            isSelected: isSelected,
            accent: sdg.color,
            onAccent: Colors.white,
            avatar: isSelected ? null : _numberBadge(sdg.number, sdg.color),
            onTap: () {
              final notifier = ref.read(selectedSdgFilterProvider.notifier);
              isSelected ? notifier.clear() : notifier.select(sdg.number);
            },
          );
        },
      ),
    );
  }
}
