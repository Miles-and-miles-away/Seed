import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/theme/app_colors.dart';

const infoIconSize = 24.0;

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
    icon: InfoGlyph(color: infoColor(Theme.of(context).brightness)),
    tooltip: tooltip,
    onPressed: onPressed,
  );
}

/// A filled rounded square with a knocked-out "i": the public
/// information sign, which reads the same in every script.
class InfoGlyph extends StatelessWidget {
  const InfoGlyph({required this.color, this.size = infoIconSize, super.key});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _InfoGlyphPainter(color));
}

class _InfoGlyphPainter extends CustomPainter {
  const _InfoGlyphPainter(this.color);

  final Color color;

  // Geometry on Material's 24dp grid: a 20dp box, 2dp dot and stem.
  // Even-odd fill knocks the "i" out so the surface shows through.
  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 24;
    final glyph = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(2 * unit, 2 * unit, 20 * unit, 20 * unit),
          Radius.circular(5 * unit),
        ),
      )
      ..addOval(
        Rect.fromCircle(
          center: Offset(12 * unit, 8 * unit),
          radius: 1.25 * unit,
        ),
      )
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(11 * unit, 10.75 * unit, 2 * unit, 6.5 * unit),
          Radius.circular(unit),
        ),
      );
    canvas.drawPath(glyph, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_InfoGlyphPainter old) => old.color != color;
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

  Widget _glyph(BuildContext context, [double size = infoIconSize]) =>
      InfoGlyph(size: size, color: infoColor(Theme.of(context).brightness));

  Widget _inlineTerm(BuildContext context) {
    // A WidgetSpan scales with the text; this keeps the glyph at 24dp.
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
