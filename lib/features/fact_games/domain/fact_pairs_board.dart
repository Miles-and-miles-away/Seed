import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/fact_games_pool.dart';

/// Pairs on a full board; smaller pools get [factGamesMinFacts] pairs.
const factPairsMaxPairs = 6;

/// One face of a card: a fact's title or its figure.
enum FactFace { title, figure }

@immutable
class FactCard {
  const FactCard({required this.fact, required this.face, required this.text});

  final EcoFact fact;
  final FactFace face;
  final String text;

  /// Two cards pair when this matches.
  int get factDay => fact.dayOfYear;
}

enum FlipResult { ignored, first, match, miss }

/// A dealt board and its play state. Strings are resolved at deal time,
/// so a board belongs to one locale.
class FactPairsBoard {
  FactPairsBoard._(this.cards);

  /// Deals up to [factPairsMaxPairs] facts with distinct figures from
  /// [pool], cut to [factGamesMinFacts] when fewer were found, so every
  /// row of the grid is full.
  factory FactPairsBoard.deal(
    List<EcoFact> pool,
    String locale,
    Random random,
  ) {
    final figures = <String>{};
    final dealt = <EcoFact>[];
    for (final fact in [...pool]..shuffle(random)) {
      if (dealt.length == factPairsMaxPairs) break;
      // EN is canonical: JA and ES can write one value two ways.
      if (fact.isPlayable && figures.add(fact.keyFigureEn)) dealt.add(fact);
    }
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
          FactCard(fact: fact, face: FactFace.title, text: fact.name(locale)),
          FactCard(
            fact: fact,
            face: FactFace.figure,
            text: fact.keyFigure(locale)!,
          ),
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
    if (cards[first].factDay == cards[index].factDay) {
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
