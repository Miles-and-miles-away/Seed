import 'dart:math';

import 'package:seed_app/core/utils/helpers.dart';

/// One number in a figure, in any locale: a digit run with `.` and `,`
/// inside, Japanese scale compounds included (1億3,200万), never after a
/// letter, so the 2 of km2 and CO2 is not a number.
final figureNumber = RegExp(
  r'(?<![A-Za-z\d.,])(?:(?:\d[\d.,]*[兆億万])+(?:\d[\d.,]*)?|\d[\d.,]*)',
);

final _digit = RegExp(r'\d');
final _numberChar = RegExp(r'[\d.,]');
final _numberTail = RegExp(r'^[.,]?\d');
final _rangeStart = RegExp(r'\d[\d.,]*\s*(?:-|to)\s*(?=\d)');
final _plusAfterDigit = RegExp(r'(?<=\d)\+');
final _numberParts = RegExp(r'[\d\s.,]');
final _whitespace = RegExp(r'\s+');
final _jaScale = RegExp('[兆億万]');

/// Occurrences of [figure] in [text] that stand as a whole number: not
/// after a digit, `.` or `,`, and, when [figure] ends in a digit, not
/// followed by more of the number. So `5%` is in "5% of" but not in
/// "85%", and `0.9` is not in "10.9".
List<Match> wholeNumberMatches(String figure, String text) {
  final endsInDigit = _digit.hasMatch(figure[figure.length - 1]);
  return [
    for (final match in figure.allMatches(text))
      if (!(match.start > 0 && _numberChar.hasMatch(text[match.start - 1])) &&
          !(endsInDigit && _numberTail.hasMatch(text.substring(match.end))))
        match,
  ];
}

/// The unit of a canonical EN figure with its numbers removed: "8 to 15
/// tonnes" and "1-2 tonnes" are `tonnes`, "58+ degrees C" is `degreesc`.
String figureUnitKey(String keyFigureEn) => keyFigureEn
    .toLowerCase()
    .replaceAll(_rangeStart, '')
    .replaceAll(_plusAfterDigit, '')
    .replaceAll(_numberParts, '');

/// How [figure] is written, with each number as `#`: `8 to 15 tonnes` is
/// `# to # tonnes`, 1億3,200万人 is `#人`.
String figureShape(String figure) => figure
    .toLowerCase()
    .replaceAll(figureNumber, '#')
    .replaceAll(_whitespace, ' ');

/// Unit keys that measure the same kind of thing, so a decoy is never in
/// another unit's terms. Every playable figure's key is listed.
const figureFamilies = <String, String>{
  '%': 'percent',
  'times': 'times',
  'x': 'times',
  'g': 'mass',
  'kg': 'mass',
  'tonnes': 'mass',
  'gigatonnes': 'mass',
  'litres': 'volume',
  'seconds': 'time',
  'minutes': 'time',
  'hours': 'time',
  'years': 'time',
  'cm': 'length',
  'metres': 'length',
  'km': 'length',
  'degreesc': 'temperature',
  '': 'count',
  'million': 'count',
  'billion': 'count',
  'species': 'species',
  r'$': 'money',
  r'$billion': 'money',
  r'$trillion': 'money',
  'gbpbillion': 'money',
  'dollars': 'money',
};

/// Scale factors of the decoys made from an answer: both below it, one
/// either side, or both above, so the answer sits low, middle or high.
const _scaleSteps = [(0.25, 0.5), (0.5, 2.0), (2.0, 4.0)];

/// Least ratio between two figures' numbers once rounded: 2x before it.
const _minScaledRatio = 1.8;

/// Decoy pairs made by scaling [figure]'s own numbers, in [locale]'s
/// number style, so a range answer gets range decoys: "10-20 years" gives
/// "5-10 years" and "20-40 years". Empty when [figure] has a Japanese
/// scale compound, is a lone 1 (its noun is singular), or no step
/// survives rounding.
///
/// [unitKey] is the figure's [figureUnitKey]: a share never passes 100%
/// and a multiple never drops to 1x.
List<(String, String)> scaledDecoyPairs(
  String figure,
  String locale,
  String unitKey,
) {
  final matches = figureNumber.allMatches(figure).toList();
  if (matches.isEmpty || matches.any((m) => _jaScale.hasMatch(m[0]!))) {
    return const [];
  }
  final (group, decimal) = locale == 'es' ? ('.', ',') : (',', '.');
  final numbers = [
    for (final m in matches)
      double.parse(m[0]!.replaceAll(group, '').replaceAll(decimal, '.')),
  ];
  if (numbers case [1]) return const [];
  final fractions = [
    for (final m in matches)
      if (m[0]!.contains(decimal)) m[0]!.split(decimal).last else '',
  ];
  final decimals = [for (final f in fractions) f.length];
  final family = figureFamilies[unitKey];

  List<double>? scaled(double factor) {
    final values = <double>[];
    for (final (i, n) in numbers.indexed) {
      final v = _round(_twoFigures(n * factor), decimals[i]);
      if (v <= 0 ||
          (numbers.length == 1 && v == 1) ||
          (unitKey == '%' && v > 100) ||
          (family == 'times' && v <= 1)) {
        return null;
      }
      values.add(v);
    }
    return values;
  }

  bool apart(List<double> a, List<double> b) => [
    for (var i = 0; i < a.length; i++) max(a[i], b[i]) / min(a[i], b[i]),
  ].every((ratio) => ratio >= _minScaledRatio);

  String write(List<double> values) {
    var out = figure;
    for (var i = matches.length - 1; i >= 0; i--) {
      out = out.replaceRange(
        matches[i].start,
        matches[i].end,
        formatDecimal(
          values[i],
          locale,
          maxDigits: decimals[i],
          // "4.30" is written to the cent, so its decoys are too.
          minDigits: fractions[i].endsWith('0') ? decimals[i] : 0,
        ),
      );
    }
    return out;
  }

  return [
    for (final (low, high) in _scaleSteps)
      if ((scaled(low), scaled(high)) case (
        final a?,
        final b?,
      ) when apart(a, numbers) && apart(b, numbers) && apart(a, b))
        (write(a), write(b)),
  ];
}

double _twoFigures(double v) {
  if (v == 0) return 0;
  final step = pow(10, (log(v.abs()) / ln10).floor() - 1).toDouble();
  return (v / step).round() * step;
}

double _round(double v, int decimals) {
  final step = pow(10, decimals).toDouble();
  return (v * step).round() / step;
}
