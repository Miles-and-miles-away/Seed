import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/fact_recall_round.dart';
import 'package:seed_app/features/fact_games/domain/figure_text.dart';

import '../fact_games_fixtures.dart';

const _blank = '____';

FactRecallRound _deal(
  List<EcoFact> pool, {
  List<EcoFact>? allPlayable,
  String locale = 'en',
  int seed = 1,
  Set<int> avoidDays = const {},
}) => FactRecallRound.deal(
  pool: pool,
  allPlayable: allPlayable ?? pool,
  locale: locale,
  blank: _blank,
  random: Random(seed),
  avoidDays: avoidDays,
);

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

Set<int> _decoyDays(List<(EcoFact, EcoFact)> pairs) => {
  for (final (a, b) in pairs) ...[a.dayOfYear, b.dayOfYear],
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
          for (final q in _deal(pool, seed: seed).questions) q.fact.keyFigureEn,
        ];
        expect(figures, hasLength(4));
        expect(figures.toSet(), hasLength(4));
      }
    });

    test('three options, exactly one right, the figure blanked', () {
      final round = _deal(playableFacts(12));
      for (final q in round.questions) {
        expect(q.options, hasLength(3));
        expect(q.options.where((o) => o == q.fact.keyFigureEn), hasLength(1));
        expect(q.answer, q.fact.keyFigureEn);
        expect(q.revealed, q.fact.factEn);
        expect(q.blanked, q.revealed.replaceAll(q.answer, _blank));
        expect(q.blanked, isNot(contains(q.answer)));
        expect(q.title, q.fact.nameEn);
      }
    });

    test("resolves strings in the deal's locale", () {
      final pool = [
        for (var day = 1; day <= 4; day++)
          playableFact(day, figureJa: '$day キロ'),
      ];
      final round = _deal(pool, locale: 'ja');
      for (final q in round.questions) {
        expect(q.answer, q.fact.keyFigureJa);
        expect(q.options.every((o) => o.endsWith('キロ')), isTrue);
        expect(q.title, q.fact.nameJa);
        expect(q.blanked, q.fact.factJa.replaceAll(q.answer, _blank));
      }
    });

    test('decoys differ from the answer and each other', () {
      for (var seed = 0; seed < 20; seed++) {
        for (final q in _deal(playableFacts(12), seed: seed).questions) {
          expect(q.options.toSet(), hasLength(3));
        }
      }
    });

    test('avoidDays is honoured while the pool allows', () {
      final pool = playableFacts(10);
      final first = _deal(pool);
      final second = _deal(pool, seed: 2, avoidDays: first.askedDays);
      expect(second.askedDays.intersection(first.askedDays), isEmpty);

      final small = playableFacts(7);
      final a = _deal(small);
      final b = _deal(small, seed: 2, avoidDays: a.askedDays);
      final leftOut = {for (final f in small) f.dayOfYear}
        ..removeAll(a.askedDays);
      expect(b.askedDays.containsAll(leftOut), isTrue);
      expect(b.questions, hasLength(5));
    });

    test('Play again with a pool of three re-asks the same three', () {
      final pool = playableFacts(3);
      final first = _deal(pool);
      final again = _deal(pool, seed: 3, avoidDays: first.askedDays);
      expect(again.askedDays, first.askedDays);
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
      final pairs = decoyPairs(facts.first, facts, 'en', _blank);
      expect(_decoyDays(pairs), {2, 3});
    });

    test('then the unit key, never a pair sharing a shape the answer '
        'lacks', () {
      final facts = [
        playableFact(1, figure: '5 kg'),
        playableFact(2, figure: '7 kg'),
        playableFact(3, figure: '1-2 kg'),
        playableFact(4, figure: '3-4 kg'),
        playableFact(5, figure: '3 tonnes'),
      ];
      final pairs = decoyPairs(facts.first, facts, 'en', _blank);
      expect(
        {for (final (a, b) in pairs) (a.dayOfYear, b.dayOfYear)},
        {(2, 3), (2, 4)},
      );
    });

    test('then the family, never outside it', () {
      final facts = [
        playableFact(1, figure: '5 kg'),
        playableFact(2, figure: '7 kg'),
        playableFact(3, figure: '3 tonnes'),
        playableFact(4, figure: '4 tonnes'),
        playableFact(5, figure: '2 g'),
        playableFact(6, figure: '9%'),
        playableFact(7, figure: '6 litres'),
        playableFact(8, figure: '8 hours'),
      ];
      final pairs = decoyPairs(facts.first, facts, 'en', _blank);
      expect(
        {for (final (a, b) in pairs) (a.dayOfYear, b.dayOfYear)},
        {(2, 3), (2, 4), (2, 5), (3, 5), (4, 5)},
      );
      for (final (a, b) in pairs) {
        for (final decoy in [a, b]) {
          expect(
            figureFamilies[figureUnitKey(decoy.keyFigureEn)],
            figureFamilies['kg'],
          );
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
      final pairs = decoyPairs(facts.first, facts, 'en', _blank);
      expect(_decoyDays(pairs), {2, 8, 9});
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
      final pairs = decoyPairs(facts.first, facts, 'en', _blank);
      // 5% sits only inside 85%, so it is still a fair decoy.
      expect(_decoyDays(pairs), {3, 4, 5});
    });

    test('is empty when no pair is valid', () {
      final facts = [
        playableFact(1, figure: '5 kg'),
        playableFact(2, figure: '7 kg'),
        playableFact(3, figure: '9%'),
      ];
      expect(decoyPairs(facts.first, facts, 'en', _blank), isEmpty);
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
