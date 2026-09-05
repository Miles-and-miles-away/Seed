import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// Repeats so the row never reaches an edge.
const _repeatCount = 100;

/// Rough chip width, only used to open the row mid-cycle.
const _estimatedChipWidth = 100.0;

/// The endless horizontal filter row the two action filters share: an
/// "All" chip at index 0, then [optionCount] options, repeated.
class FilterChipRow extends StatefulWidget {
  const FilterChipRow({
    required this.optionCount,
    required this.itemBuilder,
    super.key,
  });

  /// Options following the leading "All" chip.
  final int optionCount;

  /// Builds index 0 as "All", 1 to [optionCount] as options.
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  State<FilterChipRow> createState() => _FilterChipRowState();
}

class _FilterChipRowState extends State<FilterChipRow> {
  int get _cycleLength => widget.optionCount + 1;
  late final ScrollController _controller = ScrollController(
    initialScrollOffset:
        (_repeatCount ~/ 2) * _cycleLength * _estimatedChipWidth,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: spacingHuge,
    child: ListView.builder(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: spacingLg),
      itemCount: _cycleLength * _repeatCount,
      itemBuilder: (context, index) =>
          widget.itemBuilder(context, index % _cycleLength),
    ),
  );
}

/// Chrome shared by both filter rows: white fill, outlined, [accent]
/// when selected. [shape] and [avatar] are what keep the rows apart.
///
/// [onAccent] is what reads on [accent], so it is the caller's: white
/// over a brand colour, `onPrimary` over the scheme's own primary,
/// which is a light tone in the dark theme.
Widget filterChip(
  BuildContext context, {
  required String label,
  required bool isSelected,
  required Color accent,
  required Color onAccent,
  required VoidCallback onTap,
  Widget? avatar,
  OutlinedBorder? shape,
  bool showCheckmark = true,
}) {
  final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.only(right: spacingSm),
    child: FilterChip(
      avatar: avatar,
      label: Text(label),
      selected: isSelected,
      showCheckmark: showCheckmark,
      onSelected: (_) => onTap(),
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: isSelected ? onAccent : theme.colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      backgroundColor: theme.colorScheme.surface,
      selectedColor: accent,
      checkmarkColor: onAccent,
      shape: shape,
      side: BorderSide(
        color: isSelected
            ? accent
            : theme.colorScheme.outline.withValues(alpha: opacityMuted),
      ),
    ),
  );
}
