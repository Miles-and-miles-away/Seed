import 'package:seed_app/features/fact_games/domain/figure_text.dart';

const _jaScales = {'兆': 1e12, '億': 1e8, '万': 1e4};

// A digit after a letter is a unit exponent or a formula: km2, CO2.
final _number = RegExp(r'(?<![A-Za-z\d.,])\d[\d.,]*');
final _jaScaled = RegExp(r'(\d[\d.,]*)([兆億万])');

double _value(String token, String locale) {
  if (locale == 'ja') {
    var total = 0.0;
    var rest = token;
    for (final match in _jaScaled.allMatches(token)) {
      final piece = double.parse(match[1]!.replaceAll(',', ''));
      total += piece * _jaScales[match[2]]!;
      rest = rest.replaceFirst(match[0]!, '');
    }
    return rest.isEmpty
        ? total
        : total + double.parse(rest.replaceAll(',', ''));
  }
  final plain = locale == 'es'
      ? token.replaceAll('.', '').replaceAll(',', '.')
      : token.replaceAll(',', '');
  return double.parse(plain);
}

/// The significant digits of each number, so "132 million", "1億3200万"
/// and "132 millones" all read as ['132'].
List<String> figureDigits(String figure, String locale) => [
  for (final match in (locale == 'ja' ? figureNumber : _number).allMatches(
    figure,
  ))
    _value(
      match[0]!.replaceFirst(RegExp(r'[.,]+$'), ''),
      locale,
    ).toStringAsFixed(6).replaceAll('.', '').replaceAll(RegExp(r'^0+|0+$'), ''),
];
