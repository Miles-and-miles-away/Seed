import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/theme/app_colors.dart';

const infoIconSize = 20.0;

/// The app's one "tap to explain" control in a row's trailing slot: a
/// reserved-colour info glyph in a 48dp target.
class InfoIconButton extends StatelessWidget {
  const InfoIconButton({
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    icon: const Icon(Icons.info_outline, size: infoIconSize),
    color: infoColor(Theme.of(context).brightness),
    tooltip: tooltip,
    onPressed: onPressed,
  );
}

/// A term followed by the info glyph, one tap target at least 48dp
/// tall. The term is the label, the tooltip the hint.
class TermWithInfo extends StatelessWidget {
  const TermWithInfo({
    required this.term,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final Widget term;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Align(
    // Shrink-wraps the target when a stretched parent forces full width.
    alignment: AlignmentDirectional.centerStart,
    widthFactor: 1,
    heightFactor: 1,
    child: Tooltip(
      message: tooltip,
      // The Semantics hint carries the text; this stops a second read.
      excludeFromSemantics: true,
      child: Semantics(
        button: true,
        hint: tooltip,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadiusSm,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: kMinInteractiveDimension,
              minHeight: kMinInteractiveDimension,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: term),
                const SizedBox(width: spacingXs),
                Icon(
                  Icons.info_outline,
                  size: infoIconSize,
                  color: infoColor(Theme.of(context).brightness),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
