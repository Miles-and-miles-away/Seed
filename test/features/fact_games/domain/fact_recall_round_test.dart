import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/fact_recall_round.dart';
import 'package:seed_app/features/fact_games/domain/figure_text.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';

import '../fact_games_fixtures.dart';

const _blank = '____';

FactRecallRound _deal(
  List<EcoFact> pool, {
  List<EcoFact>? allPlayable,
  String locale = 'en',
  int seed = 1,
  Set<String> avoidIds = const {},
}) => FactRecallRound.deal(
  pool: ecoGameFacts(pool, locale),
  allPlayable: ecoGameFacts(allPlayable ?? pool, locale),
  blank: _blank,
  random: Random(seed),
  avoidIds: avoidIds,
);

List<(String, String)> _decoyPairs(
  List<EcoFact> facts, {
  String locale = 'en',
}) {
  final resolved = ecoGameFacts(facts, locale);
  return decoyPairs(resolved.first, resolved, _blank);
}

/// A playable fact whose text in every language is [text].
EcoFact _factWithText(int day, String figure, String text) => EcoFact(
  dayOfYear: day,
  category: 'energy',
  nameEn: 'Title $day',
  factEn: text,
  factJa: text,
  factEs: text,
  sourceEn: 'Source',
  keyFigureEn: figure,
  keyFigureJa: figure,
  keyFigureEs: figure,
);

Set<String> _decoyFigures(List<(String, String)> pairs) => {
  for (final (a, b) in pairs) ...[a, b],
};

void main() {
  group('deal', () {
    for (final (size, length) in [(3, 3), (4, 4), (5, 5), (9, 5)]) {
      test('a pool of $size asks $length questions', () {
        expect(_deal(playableFacts(size)).questions, hasLength(length));
      });
    }

    test('asks each figure once, however many facts carry it', () {
      final pool = [
        for (var day = 1; day <= 8; day++)
          playableFact(day, figure: '${day % 4 + 1} kg'),
      ];
      for (var seed = 0; seed < 20; seed++) {
        final figures = [
          for (final q in _deal(pool, seed: seed).questions) q.fact.figureEn,
        ];
        expect(figures, hasLength(4));
        expect(figures.toSet(), hasLength(4));
      }
    });

    test('three options, exactly one right, the figure blanked', () {
      final round = _deal(playableFacts(12));
      for (final q in round.questions) {
        expect(q.options, hasLength(3));
        expect(q.options.where((o) => o == q.fact.figure), hasLength(1));
        expect(q.answer, q.fact.figure);
        expect(q.revealed, q.fact.text);
        expect(q.blanked, q.revealed.replaceAll(q.answer, _blank));
        expect(q.blanked, isNot(contains(q.answer)));
        expect(q.title, q.fact.title);
      }
    });

    test("resolves strings in the deal's locale", () {
      final pool = [
        for (var day = 1; day <= 4; day++)
          playableFact(day, figureJa: '$day キロ'),
      ];
      final round = _deal(pool, locale: 'ja');
      for (final q in round.questions) {
        expect(q.answer, endsWith('キロ'));
        expect(q.options.every((o) => o.endsWith('キロ')), isTrue);
        expect(q.title, startsWith('タイトル'));
        expect(q.blanked, q.fact.text.replaceAll(q.answer, _blank));
      }
    });

    test('decoys differ from the answer and each other', () {
      for (var seed = 0; seed < 20; seed++) {
        for (final q in _deal(playableFacts(12), seed: seed).questions) {
          expect(q.options.toSet(), hasLength(3));
        }
      }
    });

    test('avoidIds is honoured while the pool allows', () {
      final pool = playableFacts(10);
      final first = _deal(pool);
      final second = _deal(pool, seed: 2, avoidIds: first.askedIds);
      expect(second.askedIds.intersection(first.askedIds), isEmpty);

      final small = playableFacts(7);
      final a = _deal(small);
      final b = _deal(small, seed: 2, avoidIds: a.askedIds);
      final leftOut = {for (final f in small) 'fact:${f.dayOfYear}'}
        ..removeAll(a.askedIds);
      expect(b.askedIds.containsAll(leftOut), isTrue);
      expect(b.questions, hasLength(5));
    });

    test('Play again with a pool of three re-asks the same three', () {
      final pool = playableFacts(3);
      final first = _deal(pool);
      final again = _deal(pool, seed: 3, avoidIds: first.askedIds);
      expect(again.askedIds, first.askedIds);
    });
  });

  group('decoyPairs', () {
    test("prefers the answer's shape", () {
      final facts = [
        playableFact(1, figure: '5 kg'),
        playableFact(2, figure: '7 kg'),
        playableFact(3, figure: '9 kg'),
        playableFact(4, figure: '1-2 kg'),
        playableFact(5, figure: '3 tonnes'),
      ];
      final pairs = _decoyPairs(facts);
      expect(_decoyFigures(pairs), {'7 kg', '9 kg'});
    });

    test('then its own numbers scaled, keeping its shape', () {
      final facts = [
        playableFact(1, figure: '10-20 years'),
        playableFact(2, figure: '5 years'),
        playableFact(3, figure: '8 years'),
      ];
      expect(_decoyPairs(facts).toSet(), {
        ('5-10 years', '20-40 years'),
        ('20-40 years', '40-80 years'),
      });
    });

    test('scaled decoys put the answer low, middle or high', () {
      final facts = [playableFact(1, figure: '40 kg')];
      expect(_decoyPairs(facts), [
        ('10 kg', '20 kg'),
        ('20 kg', '80 kg'),
        ('80 kg', '160 kg'),
      ]);
    });

    test('scaled decoys keep the locale number style and sensible '
        'precision', () {
      final facts = [
        playableFact(1, figure: '4.2 times', figureEs: '4,2 veces'),
        playableFact(2, figure: '1,500 tonnes', figureEs: '1.500 toneladas'),
      ];
      expect(_decoyPairs(facts, locale: 'es'), [
        ('1,1 veces', '2,1 veces'),
        ('2,1 veces', '8,4 veces'),
        ('8,4 veces', '17 veces'),
      ]);
      expect(_decoyPairs(facts.reversed.toList(), locale: 'es'), [
        ('380 toneladas', '750 toneladas'),
        ('750 toneladas', '3.000 toneladas'),
        ('3.000 toneladas', '6.000 toneladas'),
      ]);
    });

    test('a lone 1 is never scaled, nor scaled to 1, and cents stay', () {
      expect(_decoyPairs([playableFact(1, figure: '1 million')]), isEmpty);
      expect(_decoyPairs([playableFact(1, figure: '2 years')]), [
        ('4 years', '8 years'),
      ]);
      expect(_decoyPairs([playableFact(1, figure: r'$4.30')]), [
        (r'$1.10', r'$2.10'),
        (r'$2.10', r'$8.60'),
        (r'$8.60', r'$17.00'),
      ]);
    });

    test('a number before a scale word never drops below 1', () {
      final trillion = [
        playableFact(1, figure: r'$1.8 trillion', figureEs: '1,8 billones'),
      ];
      expect(_decoyPairs(trillion), [(r'$3.6 trillion', r'$7.2 trillion')]);
      expect(_decoyPairs(trillion, locale: 'es'), [
        ('3,6 billones', '7,2 billones'),
      ]);
      expect(
        _decoyPairs([
          playableFact(1, figure: '1.2 million', figureEs: '1,2 millones'),
        ], locale: 'es'),
        [('2,4 millones', '4,8 millones')],
      );
    });

    test('a share never passes 100% when scaled', () {
      final facts = [playableFact(1, figure: '60%')];
      expect(_decoyPairs(facts), [('15%', '30%')]);
    });

    // A Japanese scale compound is never scaled, so the real tiers below
    // are what it gets.
    test('then the unit key, never a pair sharing a shape the answer '
        'lacks', () {
      final facts = [
        playableFact(1, figure: '5 kg', figureJa: '5万 kg'),
        playableFact(2, figure: '7 kg'),
        playableFact(3, figure: '1-2 kg'),
        playableFact(4, figure: '3-4 kg'),
        playableFact(5, figure: '3 tonnes'),
      ];
      final pairs = _decoyPairs(facts, locale: 'ja');
      expect(pairs.toSet(), {('7 kg', '1-2 kg'), ('7 kg', '3-4 kg')});
    });

    test('then the family, never outside it', () {
      final facts = [
        playableFact(1, figure: '5 kg', figureJa: '5万 kg'),
        playableFact(2, figure: '7 kg'),
        playableFact(3, figure: '3 tonnes'),
        playableFact(4, figure: '4 tonnes'),
        playableFact(5, figure: '2 g'),
        playableFact(6, figure: '9%'),
        playableFact(7, figure: '6 litres'),
        playableFact(8, figure: '8 hours'),
      ];
      final pairs = _decoyPairs(facts, locale: 'ja');
      expect(pairs.toSet(), {
        ('7 kg', '3 tonnes'),
        ('7 kg', '4 tonnes'),
        ('7 kg', '2 g'),
        ('3 tonnes', '2 g'),
        ('4 tonnes', '2 g'),
      });
      for (final (a, b) in pairs) {
        for (final decoy in [a, b]) {
          expect(figureFamilies[figureUnitKey(decoy)], figureFamilies['kg']);
        }
      }
    });

    test('a value on six facts is one candidate, as a value on one', () {
      final facts = [
        playableFact(1, figure: '10%'),
        for (var day = 2; day <= 7; day++) playableFact(day, figure: '90%'),
        playableFact(8, figure: '40%'),
        playableFact(9, figure: '30%'),
      ];
      final pairs = _decoyPairs(facts);
      expect(_decoyFigures(pairs), {'90%', '40%', '30%'});
      expect(pairs, hasLength(3));
    });

    test('a figure already in the blanked text is never a decoy', () {
      final facts = [
        _factWithText(1, '10%', 'It saves 10% and wastes 20%, not 85%.'),
        playableFact(2, figure: '20%'),
        playableFact(3, figure: '5%'),
        playableFact(4, figure: '30%'),
        playableFact(5, figure: '40%'),
      ];
      final pairs = _decoyPairs(facts);
      // 5% sits only inside 85%, so it is still a fair decoy.
      expect(_decoyFigures(pairs), {'5%', '30%', '40%'});
    });

    test('is empty when no pair is valid', () {
      final facts = [
        playableFact(1, figure: '5 kg', figureJa: '5万 kg'),
        playableFact(2, figure: '7 kg'),
        playableFact(3, figure: '9%'),
      ];
      expect(_decoyPairs(facts, locale: 'ja'), isEmpty);
    });
  });

  group('play', () {
    test('answer is right or wrong once, then ignored', () {
      final round = _deal(playableFacts(5));
      final q = round.question;
      final wrong = (q.answerIndex + 1) % 3;
      expect(round.answer(wrong), isFalse);
      expect(round.chosen, wrong);
      expect(round.answer(q.answerIndex), isNull);
      expect(round.correct, 0);

      round.next();
      expect(round.index, 1);
      expect(round.chosen, isNull);
      expect(round.answer(round.question.answerIndex), isTrue);
      expect(round.correct, 1);
    });

    test('next is a no-op before an answer and once finished', () {
      final round = _deal(playableFacts(3))..next();
      expect(round.index, 0);
      for (var i = 0; i < 3; i++) {
        expect(round.finished, isFalse);
        expect(round.isLast, i == 2);
        round
          ..answer(round.question.answerIndex)
          ..next();
      }
      expect(round.finished, isTrue);
      expect(round.correct, 3);
      expect(round.answer(0), isNull);
      round.next();
      expect(round.index, 3);
    });
  });
}
