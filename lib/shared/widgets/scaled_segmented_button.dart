import 'dart:math';

import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// A single-select [SegmentedButton] whose labels never wrap and share one
/// scale: when the widest label is too long for its segment, every label
/// shrinks by the same factor, so siblings never render at different sizes.
///
/// Labels are measured here, outside the button, against the screen width
/// less [horizontalInset], rather than through a `LayoutBuilder`: the button
/// sizes segments from intrinsic widths, and a `LayoutBuilder` anywhere in
/// that path asserts under intrinsic layout (for example inside a dialog).
class ScaledSegmentedButton<T extends Object> extends StatelessWidget {
  const ScaledSegmentedButton({
    required this.segments,
    required this.selected,
    required this.onSelected,
    this.horizontalInset = 2 * spacingLg,
    super.key,
  });

  /// Each segment's value and label, in display order.
  final List<(T, String)> segments;
  final T selected;
  final ValueChanged<T> onSelected;

  /// Screen width not available to the control (its parents' padding).
  /// Callers inside a card, dialog or width-capped column must pass the
  /// true inset: too small a value over-estimates the slot, and labels then
  /// clip without any layout error.
  final double horizontalInset;

  static const _padding = spacingSm;

  /// Room for the segment border, which paints inside the segment, and for
  /// glyph rounding at a scaled font size.
  static const _borderSlack = 4.0;

  @override
  Widget build(BuildContext context) {
    final style =
        Theme.of(context).textTheme.labelLarge ?? const TextStyle(fontSize: 14);
    final fontSize = style.fontSize ?? 14;
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final width = MediaQuery.sizeOf(context).width - horizontalInset;

    final slot = width / segments.length - 2 * _padding - _borderSlack;
    final widest = segments
        .map((s) => _labelWidth(s.$2, style, scaler, direction))
        .reduce(max);
    final shrink = slot > 0 && widest > slot ? slot / widest : 1.0;
    final labelScaler = TextScaler.linear(
      scaler.scale(fontSize) * shrink / fontSize,
    );

    return SegmentedButton<T>(
      segments: [
        for (final (value, label) in segments)
          ButtonSegment(
            value: value,
            label: Text(
              label,
              maxLines: 1,
              softWrap: false,
              textScaler: labelScaler,
            ),
          ),
      ],
      selected: {selected},
      onSelectionChanged: (set) => onSelected(set.first),
      // The default checkmark steals width from the selected segment.
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: _padding),
      ),
    );
  }

  static double _labelWidth(
    String label,
    TextStyle style,
    TextScaler scaler,
    TextDirection direction,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: style),
      textDirection: direction,
      textScaler: scaler,
      maxLines: 1,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }
}
