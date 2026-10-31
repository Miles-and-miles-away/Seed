import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/utils/ja_phrase.dart';

export 'package:seed_app/core/utils/ja_phrase.dart'
    show defaultPhraseMinLineWidth;

/// Phone width the phrase caps are sized for: the narrowest supported.
const phraseNarrowestScreenWidth = 320.0;

/// Material's horizontal inset around an [AlertDialog].
const _dialogInset = 40.0;

/// [AlertDialog] title and content width at [phraseNarrowestScreenWidth].
const phraseDialogMinLineWidth =
    phraseNarrowestScreenWidth - 2 * (_dialogInset + spacingXxl);

/// [Text] for multi-line copy that may be Japanese: lines break between
/// phrases rather than inside words, and never before a closing mark or
/// small kana (see [phraseWrap]).
///
/// [minLineWidth] is the narrowest width this text is laid out at on a
/// [phraseNarrowestScreenWidth] phone; too large a value lets a joined
/// phrase outgrow the line. Text with [maxLines] (here or from
/// [DefaultTextStyle]) only gets the kinsoku joins, because whole-phrase
/// wrapping fills fewer lines and ellipsises earlier. With its own
/// [maxLines] it also measures itself and keeps the plain text when the
/// joins alone would ellipsise it, so it must not sit under an
/// intrinsic-sizing parent such as an [AlertDialog]. [locale] defaults to
/// the app locale; pass it when the text's language can differ.
///
/// Semantics, `toPlainText()` and `find.text` see the clean string: each
/// changed span carries it as its `semanticsLabel`, so link recognisers
/// keep their own semantics nodes. [Text.data] is null once joined.
class PhraseText extends StatelessWidget {
  const PhraseText(
    String this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textScaler,
    this.locale,
    this.minLineWidth = defaultPhraseMinLineWidth,
  }) : textSpan = null;

  const PhraseText.rich(
    InlineSpan this.textSpan, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textScaler,
    this.locale,
    this.minLineWidth = defaultPhraseMinLineWidth,
  }) : data = null;

  final String? data;
  final InlineSpan? textSpan;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextScaler? textScaler;
  final Locale? locale;
  final double minLineWidth;

  @override
  Widget build(BuildContext context) {
    final span = textSpan ?? TextSpan(text: data);
    final language = locale ?? Localizations.maybeLocaleOf(context);
    final mapped = language == null ? span : _wrapped(context, span, language);
    if (identical(mapped, span)) return _text(span, clean: true);
    if (maxLines == null) return _text(mapped);
    return LayoutBuilder(
      builder: (context, constraints) =>
          _joinsEllipsise(context, mapped, span, constraints.maxWidth)
          ? _text(span, clean: true)
          : _text(mapped),
    );
  }

  Widget _text(InlineSpan span, {bool clean = false}) {
    if (clean && data != null) {
      return Text(
        data!,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        textScaler: textScaler,
      );
    }
    return Text.rich(
      span,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textScaler: textScaler,
    );
  }

  bool _joinsEllipsise(
    BuildContext context,
    InlineSpan joined,
    InlineSpan clean,
    double width,
  ) {
    final defaults = DefaultTextStyle.of(context);
    var effective = defaults.style.merge(style);
    if (MediaQuery.boldTextOf(context)) {
      effective = effective.merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    final align = textAlign ?? defaults.textAlign ?? TextAlign.start;
    final direction = Directionality.of(context);
    final scaler = textScaler ?? MediaQuery.textScalerOf(context);
    final key = (
      joined,
      clean,
      effective,
      align,
      direction,
      scaler,
      maxLines,
      width,
    );
    final cached = _ellipsiseMemo.remove(key);
    if (cached != null) return _ellipsiseMemo[key] = cached;

    bool exceeds(InlineSpan span) {
      final painter = TextPainter(
        text: TextSpan(style: effective, children: [span]),
        textAlign: align,
        textDirection: direction,
        textScaler: scaler,
        maxLines: maxLines,
      )..layout(maxWidth: width);
      final result = painter.didExceedMaxLines;
      painter.dispose();
      return result;
    }

    final result = exceeds(joined) && !exceeds(clean);
    if (_ellipsiseMemo.length >= _ellipsiseMemoCapacity) {
      _ellipsiseMemo.remove(_ellipsiseMemo.keys.first);
    }
    return _ellipsiseMemo[key] = result;
  }

  InlineSpan _wrapped(BuildContext context, InlineSpan span, Locale locale) {
    if (locale.languageCode != 'ja') return span;
    final defaults = DefaultTextStyle.of(context);
    final resolved = defaults.style.merge(style);
    final scaler = textScaler ?? MediaQuery.textScalerOf(context);
    final letterSpacing =
        MediaQuery.maybeLetterSpacingOverrideOf(context) ??
        resolved.letterSpacing ??
        0;
    final fontSize = _largestFontSize(
      span,
      resolved.fontSize ?? kDefaultFontSize,
    );
    final maxPhrase = phraseCap(
      minLineWidth,
      scaler.scale(fontSize) + letterSpacing,
    );
    final phrases = (maxLines ?? defaults.maxLines) == null;
    return wrapPhraseSpan(
      span,
      (text) => phraseWrap(
        text,
        locale: locale,
        maxPhrase: maxPhrase,
        phrases: phrases,
      ),
    );
  }
}

/// [root] with [wrap] applied to its plain text as one string, so a
/// style or link boundary does not cut a phrase. Joiners land inside
/// [TextSpan]s only, never in a placeholder; each joined span carries its
/// clean text as `semanticsLabel` and keeps its recogniser. Joiners
/// already in [root] go to [wrap] with the text, which decides them.
InlineSpan wrapPhraseSpan(InlineSpan root, String Function(String) wrap) {
  final plain = root.toPlainText(includeSemanticsLabels: false);
  final wrapped = wrap(plain);
  if (wrapped == plain) return root;

  final joinBefore = <int>{};
  var index = 0;
  for (final unit in wrapped.codeUnits) {
    if (unit == _joinerUnit) {
      joinBefore.add(index);
    } else {
      index++;
    }
  }

  var offset = 0;
  InlineSpan visit(InlineSpan span) {
    if (span is! TextSpan) {
      offset += 1;
      return span;
    }
    final text = span.text;
    String? joined;
    if (text != null) {
      final buffer = StringBuffer();
      for (final unit in text.codeUnits) {
        if (unit == _joinerUnit) continue;
        if (joinBefore.contains(offset++)) buffer.write(wordJoiner);
        buffer.writeCharCode(unit);
      }
      joined = buffer.toString();
    }
    final children = span.children?.map(visit).toList();
    return TextSpan(
      text: joined,
      children: children,
      style: span.style,
      recognizer: span.recognizer,
      mouseCursor: span.mouseCursor,
      onEnter: span.onEnter,
      onExit: span.onExit,
      semanticsLabel:
          span.semanticsLabel ??
          (joined != null && joined.contains(wordJoiner)
              ? stripWordJoiners(joined)
              : null),
      semanticsIdentifier: span.semanticsIdentifier,
      locale: span.locale,
      spellOut: span.spellOut,
    );
  }

  return visit(root);
}

final _joinerUnit = wordJoiner.codeUnitAt(0);

const _ellipsiseMemoCapacity = 512;

typedef _EllipsiseKey = (
  InlineSpan,
  InlineSpan,
  TextStyle,
  TextAlign,
  TextDirection,
  TextScaler,
  int?,
  double,
);

final _ellipsiseMemo = <_EllipsiseKey, bool>{};

double _largestFontSize(InlineSpan span, double inherited) {
  final own = span.style?.fontSize ?? inherited;
  var largest = own;
  if (span is TextSpan) {
    for (final child in span.children ?? const <InlineSpan>[]) {
      final size = _largestFontSize(child, own);
      if (size > largest) largest = size;
    }
  }
  return largest;
}

/// Width lost to the deepest markdown nesting: a quote in a list item.
final _markdownNestingInset =
    const ListConfig().marginLeft +
    const BlockquoteConfig().padding.horizontal +
    const BlockquoteConfig().sideWith;

/// A markdown generator whose paragraphs render through
/// [PhraseText.rich]. [bodyWidth] is the markdown's own width on a
/// [phraseNarrowestScreenWidth] phone; nested lists and quotes are
/// allowed for.
MarkdownGenerator phraseMarkdownGenerator({required double bodyWidth}) {
  final minLineWidth = bodyWidth - _markdownNestingInset;
  return MarkdownGenerator(
    richTextBuilder: (span) =>
        PhraseText.rich(span, minLineWidth: minLineWidth),
  );
}
