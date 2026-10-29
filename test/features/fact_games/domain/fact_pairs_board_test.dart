import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/fact_games/domain/fact_pairs_board.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';

import '../fact_games_fixtures.dart';

void main() {
  FactPairsBoard deal(int facts, {int seed = 1, String locale = 'en'}) =>
      FactPairsBoard.deal(
        ecoGameFacts(playableFacts(facts), locale),
        Random(seed),
      );

  /// Indices of the two cards of the pair holding [index].
  int partnerOf(FactPairsBoard board, int index) => board.cards.indexed
      .firstWhere(
        (e) => e.$1 != index && e.$2.factId == board.cards[index].factId,
      )
      .$1;

  int nonPartnerOf(FactPairsBoard board, int index) => board.cards.indexed
      .firstWhere((e) => e.$2.factId != board.cards[index].factId)
      .$1;

  group('deal', () {
    for (final (facts, cards) in [(6, 12), (9, 12), (3, 6), (5, 6)]) {
      test('$facts facts deal $cards cards', () {
        final board = deal(facts);
        expect(board.cards, hasLength(cards));
        expect(board.pairCount, cards ~/ 2);
      });
    }

    test('every fact gives one title card and one figure card', () {
      final board = deal(8);
      final days = {for (final card in board.cards) card.factId};
      expect(days, hasLength(6));
      for (final day in days) {
        final pair = board.cards.where((c) => c.factId == day).toList();
        expect(pair.map((c) => c.face), unorderedEquals(FactFace.values));
        final title = pair.firstWhere((c) => c.face == FactFace.title);
        final figure = pair.firstWhere((c) => c.face == FactFace.figure);
        expect(title.text, title.fact.title);
        expect(figure.text, figure.fact.figure);
      }
    });

    test('resolves strings in the locale it was dealt in', () {
      final board = deal(6, locale: 'ja');
      for (final card in board.cards) {
        expect(
          card.text,
          card.face == FactFace.title ? card.fact.title : card.fact.figure,
        );
        expect(card.fact.title, startsWith('タイトル'));
      }
    });

    test('never shows one figure twice', () {
      final pool = [
        for (var day = 1; day <= 12; day++)
          playableFact(day, figure: '${day % 7} kg'),
      ];
      for (var seed = 0; seed < 20; seed++) {
        final board = FactPairsBoard.deal(
          ecoGameFacts(pool, 'en'),
          Random(seed),
        );
        final figures = [
          for (final c in board.cards)
            if (c.face == FactFace.figure) c.text,
        ];
        expect(figures.toSet(), hasLength(figures.length));
      }
    });

    test('five facts sharing a figure and two others deal 3 pairs', () {
      final pool = [
        for (var day = 1; day <= 5; day++) playableFact(day, figure: '50%'),
        playableFact(6),
        playableFact(7),
      ];
      for (var seed = 0; seed < 10; seed++) {
        final board = FactPairsBoard.deal(
          ecoGameFacts(pool, 'en'),
          Random(seed),
        );
        expect(board.cards, hasLength(6));
      }
    });

    test('figures equal in EN but grouped differently in JA never pair '
        'on one board', () {
      final pool = [
        playableFact(166, figure: '132 million', figureJa: '1億3200万人'),
        playableFact(290, figure: '132 million', figureJa: '1億3,200万人'),
        ...playableFacts(6),
      ];
      for (var seed = 0; seed < 20; seed++) {
        final board = FactPairsBoard.deal(
          ecoGameFacts(pool, 'ja'),
          Random(seed),
        );
        final ids = {for (final c in board.cards) c.factId};
        expect(ids.containsAll(['fact:166', 'fact:290']), isFalse);
      }
    });
  });

  group('flip', () {
    test('first, then match for the partner', () {
      final board = deal(6);
      expect(board.flip(0), FlipResult.first);
      expect(board.faceUp, {0});
      expect(board.moves, 0);
      final partner = partnerOf(board, 0);
      expect(board.flip(partner), FlipResult.match);
      expect(board.matched, {0, partner});
      expect(board.faceUp, isEmpty);
      expect(board.moves, 1);
      expect(board.matchedPairs, 1);
    });

    test('a miss holds both up, ignores a third flip, and hides', () {
      final board = deal(6);
      final other = nonPartnerOf(board, 0);
      board.flip(0);
      expect(board.flip(other), FlipResult.miss);
      expect(board.faceUp, {0, other});
      expect(board.moves, 1);

      final third = List.generate(
        12,
        (i) => i,
      ).firstWhere((i) => i != 0 && i != other);
      expect(board.flip(third), FlipResult.ignored);
      expect(board.moves, 1);

      board.hideMiss();
      expect(board.faceUp, isEmpty);
      expect(board.matched, isEmpty);
    });

    test('a face-up or matched card ignores flips', () {
      final board = deal(6)..flip(0);
      expect(board.flip(0), FlipResult.ignored);
      final partner = partnerOf(board, 0);
      board.flip(partner);
      expect(board.flip(0), FlipResult.ignored);
      expect(board.flip(partner), FlipResult.ignored);
      expect(board.moves, 1);
    });

    test('finished after the last match', () {
      final board = deal(3);
      final days = {for (final c in board.cards) c.factId}.toList();
      for (final (i, day) in days.indexed) {
        expect(board.finished, isFalse);
        final pair = [
          for (final (j, c) in board.cards.indexed)
            if (c.factId == day) j,
        ];
        board
          ..flip(pair.first)
          ..flip(pair.last);
        expect(board.matchedPairs, i + 1);
      }
      expect(board.finished, isTrue);
      expect(board.moves, 3);
    });
  });
}
