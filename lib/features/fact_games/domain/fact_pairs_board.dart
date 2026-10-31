import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:seed_app/features/fact_games/domain/fact_games_pool.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';

/// Pairs on a full board; smaller pools get [factGamesMinFacts] pairs.
const factPairsMaxPairs = 6;

/// One face of a card: a fact's title or its figure.
enum FactFace { title, figure }

@immutable
class FactCard {
  const FactCard({required this.fact, required this.face, required this.text});

  final GameFact fact;
  final FactFace face;
  final String text;

  /// Two cards pair when this matches.
  String get factId => fact.id;
}

enum FlipResult { ignored, first, match, miss }

/// A dealt board and its play state. Its facts are resolved for one
/// locale, so a board belongs to that locale.
class FactPairsBoard {
  FactPairsBoard._(this.cards);

  /// Deals up to [factPairsMaxPairs] facts with distinct figures from
  /// [pool], kinds in turn, cut to [factGamesMinFacts] when fewer were
  /// found, so every row of the grid is full. Recall-only facts never
  /// deal.
  factory FactPairsBoard.deal(List<GameFact> pool, Random random) {
    final figures = <String>{};
    final dealt = dealInTurn(
      pool,
      count: factPairsMaxPairs,
      random: random,
      accept: (fact) => !fact.recallOnly && figures.add(fact.figureEn),
    );
    assert(
      dealt.length >= factGamesMinFacts,
      'Deal only from a pool with $factGamesMinFacts distinct figures',
    );
    final pairs = dealt.length < factPairsMaxPairs
        ? dealt.take(factGamesMinFacts)
        : dealt;
    return FactPairsBoard._(
      [
        for (final fact in pairs) ...[
          FactCard(fact: fact, face: FactFace.title, text: fact.title),
          FactCard(fact: fact, face: FactFace.figure, text: fact.figure),
        ],
      ]..shuffle(random),
    );
  }

  final List<FactCard> cards;
  final _faceUp = <int>{};
  final _matched = <int>{};
  int _moves = 0;

  /// Unmatched cards currently face up: none, the first of a move, or
  /// the two of a miss.
  Set<int> get faceUp => UnmodifiableSetView(_faceUp);

  Set<int> get matched => UnmodifiableSetView(_matched);

  int get moves => _moves;

  int get pairCount => cards.length ~/ 2;

  int get matchedPairs => _matched.length ~/ 2;

  bool get finished => _matched.length == cards.length;

  /// Turns [index] face up. Ignored when it is already up, matched, or
  /// two unmatched cards are showing.
  FlipResult flip(int index) {
    if (_faceUp.contains(index) ||
        _matched.contains(index) ||
        _faceUp.length == 2) {
      return FlipResult.ignored;
    }
    if (_faceUp.isEmpty) {
      _faceUp.add(index);
      return FlipResult.first;
    }
    final first = _faceUp.single;
    _moves += 1;
    if (cards[first].factId == cards[index].factId) {
      _faceUp.clear();
      _matched.addAll([first, index]);
      return FlipResult.match;
    }
    _faceUp.add(index);
    return FlipResult.miss;
  }

  /// Turns the two unmatched cards back down after a miss.
  void hideMiss() {
    if (_faceUp.length == 2) _faceUp.clear();
  }
}
