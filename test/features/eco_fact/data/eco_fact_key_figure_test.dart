import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';

const _maxFigureLength = 18;
const _playableFloor = 204;
const _locales = ['en', 'ja', 'es'];
const _jaScales = {'兆': 1e12, '億': 1e8, '万': 1e4};

final _digit = RegExp(r'\d');
final _numberTail = RegExp(r'^[.,]?\d');

// A digit after a letter is a unit exponent or a formula: km2, CO2.
final _number = RegExp(r'(?<![A-Za-z\d.,])\d[\d.,]*');
final _jaNumber = RegExp(
  r'(?<![A-Za-z\d.,])(?:(?:\d[\d.,]*[兆億万])+(?:\d[\d.,]*)?|\d[\d.,]*)',
);
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
List<String> _digits(String figure, String locale) => [
  for (final match in (locale == 'ja' ? _jaNumber : _number).allMatches(figure))
    _value(
      match[0]!.replaceFirst(RegExp(r'[.,]+$'), ''),
      locale,
    ).toStringAsFixed(6).replaceAll('.', '').replaceAll(RegExp(r'^0+|0+$'), ''),
];

bool _insideLongerNumber(String figure, String text) {
  for (final match in figure.allMatches(text)) {
    final before = match.start > 0 ? text[match.start - 1] : '';
    final endsInDigit = _digit.hasMatch(figure[figure.length - 1]);
    if (RegExp(r'[\d.,]').hasMatch(before) ||
        (endsInDigit && _numberTail.hasMatch(text.substring(match.end)))) {
      return true;
    }
  }
  return false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<EcoFact> facts;
  late List<EcoFact> playable;

  setUpAll(() async {
    facts = await loadEcoFacts();
    playable = facts.where((f) => f.isPlayable).toList();
  });

  test('the digit reader agrees across number formats', () {
    expect(_digits('132 million', 'en'), ['132']);
    expect(_digits('1億3,200万', 'ja'), ['132']);
    expect(_digits('132 millones', 'es'), ['132']);
    expect(_digits('6万3,000ガロン', 'ja'), ['63']);
    expect(_digits('3,5 kg', 'es'), ['35']);
    expect(_digits('3万5,000 km2', 'ja'), ['35']);
    expect(_digits('8 a 15 toneladas', 'es'), ['8', '15']);
  });

  test('key figures are set in all three languages or none', () {
    final partial = [
      for (final fact in facts)
        if (_locales.map(fact.keyFigure).where((f) => f != null).length
            case final count when count != 0 && count != 3)
          fact.dayOfYear,
    ];
    expect(partial, isEmpty);
  });

  test('each figure is a verbatim substring of its fact text', () {
    final missing = [
      for (final fact in playable)
        for (final locale in _locales)
          if (!fact.fact(locale).contains(fact.keyFigure(locale)!))
            '${fact.dayOfYear} $locale: ${fact.keyFigure(locale)}',
    ];
    expect(missing, isEmpty);
  });

  test('no figure sits inside a longer number', () {
    final clipped = [
      for (final fact in playable)
        for (final locale in _locales)
          if (_insideLongerNumber(fact.keyFigure(locale)!, fact.fact(locale)))
            '${fact.dayOfYear} $locale: ${fact.keyFigure(locale)}',
    ];
    expect(clipped, isEmpty);
  });

  test('each figure is at most $_maxFigureLength characters', () {
    final long = [
      for (final fact in playable)
        for (final locale in _locales)
          if (fact.keyFigure(locale)!.length > _maxFigureLength)
            '${fact.dayOfYear} $locale: ${fact.keyFigure(locale)}',
    ];
    expect(long, isEmpty);
  });

  test('the JA and ES figures carry the same digits as EN', () {
    final mismatched = [
      for (final fact in playable)
        if (_digits(fact.keyFigureEn, 'en').join(' ') case final en
            when en.isEmpty ||
                en != _digits(fact.keyFigureJa, 'ja').join(' ') ||
                en != _digits(fact.keyFigureEs, 'es').join(' '))
          '${fact.dayOfYear}: ${_locales.map(fact.keyFigure).join(' / ')}',
    ];
    expect(mismatched, isEmpty);
  });

  test('figures that read the same in any language share keyFigureEn', () {
    final clashes = [
      for (final locale in ['ja', 'es'])
        for (final group in groupBy(
          playable,
          (f) => f.keyFigure(locale),
        ).values)
          if (group.map((f) => f.keyFigureEn).toSet().length > 1)
            group.map((f) => f.dayOfYear).toList(),
    ];
    expect(clashes, isEmpty);
  });

  test('no figure on a fact whose title has a digit', () {
    final giveaways = [
      for (final fact in playable)
        if (_locales.any((l) => _digit.hasMatch(fact.name(l)))) fact.dayOfYear,
    ];
    expect(giveaways, isEmpty);
  });

  test('at least $_playableFloor facts are playable', () {
    expect(playable.length, greaterThanOrEqualTo(_playableFloor));
  });
}
