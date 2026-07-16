import 'package:flutter/widgets.dart';

/// Index to insert a line break for the most even two-line split, or -1 to
/// leave wrapping untouched.
///
/// Only balances when greedy wrapping (how Flutter wraps naturally) would
/// produce exactly two lines: one line needs no break, and three-plus lines
/// fall back to normal wrapping. Among valid two-line splits it picks the one
/// whose line widths differ least, avoiding a lone orphan word on line two.
int balancedBreakIndex(
  List<double> wordWidths,
  double spaceWidth,
  double maxWidth,
) {
  if (wordWidths.length < 2 || !maxWidth.isFinite) return -1;

  var lines = 1;
  var current = wordWidths.first;
  for (var i = 1; i < wordWidths.length; i++) {
    if (current + spaceWidth + wordWidths[i] <= maxWidth) {
      current += spaceWidth + wordWidths[i];
    } else {
      lines++;
      current = wordWidths[i];
    }
  }
  if (lines != 2) return -1;

  double lineWidth(int start, int end) {
    var total = 0.0;
    for (var i = start; i < end; i++) {
      total += wordWidths[i];
    }
    return total + spaceWidth * (end - start - 1);
  }

  var best = -1;
  var bestDelta = double.infinity;
  for (var i = 1; i < wordWidths.length; i++) {
    final w1 = lineWidth(0, i);
    final w2 = lineWidth(i, wordWidths.length);
    if (w1 > maxWidth || w2 > maxWidth) continue;
    final delta = (w1 - w2).abs();
    if (delta < bestDelta) {
      bestDelta = delta;
      best = i;
    }
  }
  return best;
}

/// [Text] that rebalances a two-line wrap so both lines are as even as
/// possible instead of orphaning a single word. Flutter has no
/// `text-wrap: balance` equivalent. One-line and three-plus-line text wraps
/// normally.
class BalancedText extends StatelessWidget {
  const BalancedText(this.text, {this.style, this.textAlign, super.key});

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final resolvedStyle = DefaultTextStyle.of(context).style.merge(style);
    final scaler = MediaQuery.textScalerOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Text(
          _balanced(constraints.maxWidth, resolvedStyle, scaler),
          style: style,
          textAlign: textAlign,
        );
      },
    );
  }

  String _balanced(double maxWidth, TextStyle style, TextScaler scaler) {
    final words = text.split(' ');
    if (words.length < 2) return text;

    double measure(String s) => (TextPainter(
      text: TextSpan(text: s, style: style),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
    )..layout()).width;

    final wordWidths = words.map(measure).toList();
    final breakAt = balancedBreakIndex(wordWidths, measure(' '), maxWidth);
    if (breakAt == -1) return text;

    return '${words.sublist(0, breakAt).join(' ')}\n'
        '${words.sublist(breakAt).join(' ')}';
  }
}
