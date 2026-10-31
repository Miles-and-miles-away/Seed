import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';

const _locales = ['en', 'ja', 'es'];
const _minWords = 3;
const _maxWords = 10;

dynamic _readJson(String path) => jsonDecode(File(path).readAsStringSync());

void main() {
  final facts = [
    for (final e in _readJson('data/app/eco_facts.json') as List<dynamic>)
      EcoFact.fromJson(e as Map<String, dynamic>),
  ];
  final goals = [
    for (final e in _readJson('data/app/sdg_goals.json') as List<dynamic>)
      SdgGoal.fromJson(e as Map<String, dynamic>),
  ];
  final entries = [
    for (final e
        in (_readJson('data/app/eco_dex_entries.json')
                as Map<String, dynamic>)['entries']
            as List<dynamic>)
      EcoDexEntry.fromJson(e as Map<String, dynamic>),
  ];

  for (final locale in _locales) {
    test('every $locale pairs fact has a clue that hides its figure', () {
      final dealt = [
        ...ecoGameFacts(facts, locale),
        ...sdgGameFacts(goals, locale),
        ...ecoDexGameFacts(entries, locale),
      ];
      expect(dealt, isNotEmpty);
      final pairable = dealt.where((fact) => fact.clue.isNotEmpty).toList();
      expect(pairable.length, greaterThan(dealt.length * 9 ~/ 10));
      for (final fact in pairable) {
        expect(fact.clue, isNot(contains(fact.figure)), reason: fact.id);
        expect(fact.clue, isNot(contains(fact.figureEn)), reason: fact.id);
        expect(fact.clue, isNot(endsWith('.')), reason: fact.id);
        if (locale == 'en') {
          expect(
            fact.clue.split(' ').length,
            inInclusiveRange(_minWords, _maxWords),
            reason: '${fact.id}: ${fact.clue}',
          );
        }
      }
    });
  }
}
