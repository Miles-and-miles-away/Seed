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
    required Widget this.term,
    required this.tooltip,
    required this.onPressed,
    super.key,
  }) : text = null,
       style = null;

  /// The glyph flows after [text] instead of taking a column beside it.
  const TermWithInfo.inline({
    required String this.text,
    required this.tooltip,
    required this.onPressed,
    this.style,
    super.key,
  }) : term = null;

  final Widget? term;
  final String? text;
  final TextStyle? style;
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
                Flexible(child: term ?? _inlineTerm(context)),
                if (term != null) ...[
                  const SizedBox(width: spacingXs),
                  _glyph(context),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _glyph(BuildContext context, [double size = infoIconSize]) => Icon(
    Icons.info_outline,
    size: size,
    color: infoColor(Theme.of(context).brightness),
  );

  Widget _inlineTerm(BuildContext context) {
    // A WidgetSpan scales with the text; this keeps the glyph at 20dp.
    final fontSize =
        DefaultTextStyle.of(context).style.merge(style).fontSize ??
        kDefaultFontSize;
    final unscale = fontSize / MediaQuery.textScalerOf(context).scale(fontSize);
    return Text.rich(
      TextSpan(
        text: text,
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: spacingXs * unscale),
              child: _glyph(context, infoIconSize * unscale),
            ),
          ),
        ],
      ),
      style: style,
    );
  }
}
