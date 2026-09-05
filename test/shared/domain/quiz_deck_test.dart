import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/shared/domain/quiz_deck.dart';

QuizCard _card(String id, double magnitude) => QuizCard(
  id: id,
  title: id,
  subtitle: '1 use',
  magnitude: magnitude,
  revealText: '${magnitude}x',
);

// The real dataset's tie cluster: kettle and ih_hob differ by 0.3% and
// display identically, so they must never be dealt against each other.
final _cards = [
  _card('kettle', 0.116278),
  _card('ih_hob', 0.116598),
  _card('dryer', 4.5),
  _card('led_bulb', 0.0085),
  _card('line_dry', 0),
];

QuizDeck _deck({List<QuizCard>? cards, int seed = 7, double gap = 20}) =>
    QuizDeck(cards: cards ?? _cards, minGapPercent: gap, random: Random(seed));

void main() {
  group('QuizDeck.tooClose', () {
    test('a gap of exactly the minimum is dealable', () {
      // The bar is "< min", matching the calculators' verdict gate:
      // 5 vs 4 is exactly 20% and must pass.
      expect(QuizDeck.tooClose(5, 4, 20), isFalse);
      expect(QuizDeck.tooClose(4, 5, 20), isFalse);
      expect(QuizDeck.tooClose(5, 4.1, 20), isTrue);
    });

    test('zero against anything positive is a full gap', () {
      expect(QuizDeck.tooClose(0, 0.0085, 20), isFalse);
      expect(QuizDeck.tooClose(4.5, 0, 20), isFalse);
    });

    test('two zeros have no ordering, so they are too close', () {
      expect(QuizDeck.tooClose(0, 0, 20), isTrue);
    });
  });

  group('QuizDeck', () {
    test('never deals a near-tie against the current card', () {
      // Every seed, every draw: the 0.3% pair must never be adjacent.
      for (var seed = 0; seed < 30; seed++) {
        final deck = _deck(seed: seed);
        var previous = deck.current!;
        for (var draw = 0; draw < 20; draw++) {
          final next = deck.drawNext()!;
          expect(
            QuizDeck.tooClose(previous.magnitude, next.magnitude, 20),
            isFalse,
            reason: 'seed $seed dealt ${previous.id} then ${next.id}',
          );
          previous = next;
        }
      }
    });

    test('the zero card is dealt and keeps play going', () {
      final ids = <String>{};
      for (var seed = 0; seed < 30; seed++) {
        final deck = _deck(seed: seed);
        ids.add(deck.current!.id);
        for (var draw = 0; draw < 10; draw++) {
          ids.add(deck.drawNext()!.id);
        }
      }
      expect(ids, contains('line_dry'));
    });

    test('deals without replacement, then reshuffles to continue', () {
      final deck = _deck();
      final firstPass = <String>[deck.current!.id];
      for (var i = 0; i < _cards.length - 1; i++) {
        firstPass.add(deck.drawNext()!.id);
      }
      expect(firstPass.toSet(), hasLength(_cards.length));
      // The pile is empty; play continues on a fresh shuffle rather
      // than stalling.
      final afterRefill = deck.drawNext();
      expect(afterRefill, isNotNull);
      expect(afterRefill!.id, isNot(firstPass.last));
    });

    test('a deck of near-ties degrades to null rather than throwing', () {
      final deck = _deck(
        cards: [_card('kettle', 0.116278), _card('ih_hob', 0.116598)],
      );
      expect(deck.current, isNotNull);
      expect(deck.drawNext(), isNull);
      // Still callable: the screen shows an exhausted state, not a crash.
      expect(deck.drawNext(), isNull);
    });

    test('an empty deck has no current card and deals nothing', () {
      final deck = _deck(cards: []);
      expect(deck.current, isNull);
      expect(deck.drawNext(), isNull);
    });
  });
}
