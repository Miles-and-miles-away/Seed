import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/figure_text.dart';

import '../../fact_games/figure_digits.dart';

const _maxFigureLength = 18;
const _playableFloor = 193;
const _locales = ['en', 'ja', 'es'];
final _digit = RegExp(r'\d');

bool _insideLongerNumber(String figure, String text) =>
    figure.allMatches(text).length > wholeNumberMatches(figure, text).length;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<EcoFact> facts;
  late List<EcoFact> playable;

  setUpAll(() async {
    facts = await loadEcoFacts();
    playable = facts.where((f) => f.isPlayable).toList();
  });

  test('the digit reader agrees across number formats', () {
    expect(figureDigits('132 million', 'en'), ['132']);
    expect(figureDigits('1億3,200万', 'ja'), ['132']);
    expect(figureDigits('132 millones', 'es'), ['132']);
    expect(figureDigits('6万3,000ガロン', 'ja'), ['63']);
    expect(figureDigits('3,5 kg', 'es'), ['35']);
    expect(figureDigits('3万5,000 km2', 'ja'), ['35']);
    expect(figureDigits('8 a 15 toneladas', 'es'), ['8', '15']);
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

  test('each figure occurs once in its text, as a whole number', () {
    final repeated = [
      for (final fact in playable)
        for (final locale in _locales)
          if (wholeNumberMatches(
                fact.keyFigure(locale)!,
                fact.fact(locale),
              ).length !=
              1)
            '${fact.dayOfYear} $locale: ${fact.keyFigure(locale)}',
    ];
    expect(repeated, isEmpty);
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
        if (figureDigits(fact.keyFigureEn, 'en').join(' ') case final en
            when en.isEmpty ||
                en != figureDigits(fact.keyFigureJa, 'ja').join(' ') ||
                en != figureDigits(fact.keyFigureEs, 'es').join(' '))
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

  test('facts sharing keyFigureEn write it the same in each language', () {
    final spellings = [
      for (final locale in ['ja', 'es'])
        for (final group in groupBy(playable, (f) => f.keyFigureEn).values)
          if (group.map((f) => f.keyFigure(locale)).toSet().length > 1)
            '$locale: ${group.map((f) => f.dayOfYear).toList()}',
    ];
    expect(spellings, isEmpty);
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
