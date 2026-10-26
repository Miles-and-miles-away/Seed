import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/eco_dex/data/eco_dex_entries_data.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/fact_recall_round.dart';
import 'package:seed_app/features/fact_games/domain/figure_text.dart';

import '../../fact_games/figure_digits.dart';

const _maxFigureLength = 18;
const _locales = ['en', 'ja', 'es'];
const _blank = '____';
const _playableFloor = 11;

// Eco-Dex entries stand in as facts numbered after the year's days.
const _firstDexDay = 1000;

final _digit = RegExp(r'\d');

bool _insideLongerNumber(String figure, String text) =>
    figure.allMatches(text).length > wholeNumberMatches(figure, text).length;

EcoFact _asFact(EcoDexEntry entry, int day) => EcoFact(
  dayOfYear: day,
  category: entry.category,
  nameEn: entry.nameEn,
  nameJa: entry.nameJa,
  nameEs: entry.nameEs,
  factEn: entry.factEn,
  factJa: entry.factJa,
  factEs: entry.factEs,
  sourceEn: '',
  keyFigureEn: entry.keyFigureEn,
  keyFigureJa: entry.keyFigureJa,
  keyFigureEs: entry.keyFigureEs,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<EcoDexEntry> entries;
  late List<EcoDexEntry> playable;
  late List<EcoFact> dexFacts;
  late List<EcoFact> allPlayable;

  setUpAll(() async {
    entries = (await loadEcoDexData()).entries;
    playable = entries.where((e) => e.keyFigureEn.isNotEmpty).toList();
    dexFacts = [
      for (final (i, entry) in playable.indexed)
        _asFact(entry, _firstDexDay + i),
    ];
    allPlayable = [
      ...(await loadEcoFacts()).where((f) => f.isPlayable),
      ...dexFacts,
    ];
  });

  test('key figures are set in all three languages or none', () {
    final partial = [
      for (final entry in entries)
        if (_locales.map(entry.keyFigure).nonNulls.length case final count
            when count != 0 && count != 3)
          entry.id,
    ];
    expect(partial, isEmpty);
  });

  test('each figure occurs once in its text, as a whole number', () {
    final bad = [
      for (final entry in playable)
        for (final locale in _locales)
          if (entry.keyFigure(locale)! case final figure
              when wholeNumberMatches(figure, entry.fact(locale)).length != 1 ||
                  _insideLongerNumber(figure, entry.fact(locale)))
            '${entry.id} $locale: $figure',
    ];
    expect(bad, isEmpty);
  });

  test('each figure is at most $_maxFigureLength characters', () {
    final long = [
      for (final entry in playable)
        for (final locale in _locales)
          if (entry.keyFigure(locale)!.length > _maxFigureLength)
            '${entry.id} $locale: ${entry.keyFigure(locale)}',
    ];
    expect(long, isEmpty);
  });

  test('the JA and ES figures carry the same digits as EN', () {
    final mismatched = [
      for (final entry in playable)
        if (figureDigits(entry.keyFigureEn, 'en').join(' ') case final en
            when en.isEmpty ||
                en != figureDigits(entry.keyFigureJa, 'ja').join(' ') ||
                en != figureDigits(entry.keyFigureEs, 'es').join(' '))
          '${entry.id}: ${_locales.map(entry.keyFigure).join(' / ')}',
    ];
    expect(mismatched, isEmpty);
  });

  test('no figure on an entry whose title has a digit', () {
    final giveaways = [
      for (final entry in playable)
        if (_locales.any((l) => _digit.hasMatch(entry.name(l)))) entry.id,
    ];
    expect(giveaways, isEmpty);
  });

  test("every figure's unit key is in a family", () {
    final unplaced = [
      for (final entry in playable)
        if (!figureFamilies.containsKey(figureUnitKey(entry.keyFigureEn)))
          '${entry.id}: ${figureUnitKey(entry.keyFigureEn)}',
    ];
    expect(unplaced, isEmpty);
  });

  test('figures agree with eco-fact figures that read the same', () {
    final clashes = [
      for (final locale in _locales)
        for (final group in groupBy(
          allPlayable,
          (f) => f.keyFigure(locale),
        ).values)
          if (group.map((f) => f.keyFigureEn).toSet().length > 1 &&
              group.any((f) => f.dayOfYear >= _firstDexDay))
            '$locale: ${group.map((f) => f.keyFigureEn).toSet()}',
      for (final locale in ['ja', 'es'])
        for (final group in groupBy(allPlayable, (f) => f.keyFigureEn).values)
          if (group.map((f) => f.keyFigure(locale)).toSet().length > 1 &&
              group.any((f) => f.dayOfYear >= _firstDexDay))
            '$locale: ${group.map((f) => f.keyFigure(locale)).toSet()}',
    ];
    expect(clashes, isEmpty);
  });

  test('every figure has two valid decoys in each language', () {
    final unaskable = [
      for (final fact in dexFacts)
        for (final locale in _locales)
          if (decoyPairs(fact, allPlayable, locale, _blank).isEmpty)
            '${fact.nameEn} $locale: ${fact.keyFigure(locale)}',
    ];
    expect(unaskable, isEmpty);
  });

  test('at least $_playableFloor entries are playable', () {
    expect(playable.length, greaterThanOrEqualTo(_playableFloor));
  });
}
