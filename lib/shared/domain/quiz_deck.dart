import 'dart:math';

import 'package:flutter/foundation.dart';

/// One card of a higher-or-lower deck (Phase 8, energy explore).
///
/// Strings are resolved at deck-build time, so a deck belongs to one
/// locale and must not outlive it. [magnitude] is any figure that is
/// self-consistent within its own domain -- default-preset kWh for the
/// energy deck -- never a cross-domain ratio.
@immutable
class QuizCard {
  const QuizCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.magnitude,
    required this.revealText,
    this.revealDetail = '',
  });

  final String id;
  final String title;
  final String subtitle;
  final double magnitude;

  /// Shown once the card is face up, e.g. its multiple of the anchor.
  final String revealText;

  /// Optional smaller second line under [revealText], e.g. the gram
  /// figure behind a multiple. Empty where the domain has nothing to
  /// add.
  final String revealDetail;
}

/// The two answers a player can give.
enum QuizGuess { higher, lower }

/// Deals cards that are far enough apart to have a right answer.
///
/// Domain-generic on purpose: a food or transport deck is a data
/// mapping, not a rewrite. [minGapPercent] is the honesty bar -- pairs
/// inside it are skipped rather than dealt, because two figures that
/// display identically have no higher-or-lower answer.
class QuizDeck {
  QuizDeck({
    required List<QuizCard> cards,
    required this.minGapPercent,
    Random? random,
  }) : _cards = List.unmodifiable(cards),
       _random = random ?? Random() {
    _pile = [..._cards]..shuffle(_random);
    _current = _pile.isEmpty ? null : _pile.removeLast();
  }

  final List<QuizCard> _cards;
  final Random _random;
  final double minGapPercent;

  late List<QuizCard> _pile;
  QuizCard? _current;

  /// The card most recently dealt: what the next draw is measured
  /// against. Null only for an empty deck.
  QuizCard? get current => _current;

  /// Deals the next card, or null when nothing in the deck clears the
  /// gap against [current]. Draws without replacement; an exhausted
  /// pile refills and reshuffles, minus the current card.
  QuizCard? drawNext() {
    final from = _current;
    if (from == null) return null;
    var card = _takeEligible(from);
    if (card == null) {
      _pile = [
        for (final c in _cards)
          if (c.id != from.id) c,
      ]..shuffle(_random);
      card = _takeEligible(from);
    }
    if (card == null) return null;
    _current = card;
    return card;
  }

  QuizCard? _takeEligible(QuizCard from) {
    final index = _pile.lastIndexWhere(
      (c) => !tooClose(c.magnitude, from.magnitude, minGapPercent),
    );
    return index < 0 ? null : _pile.removeAt(index);
  }

  /// Whether two magnitudes are within [minGapPercent] of each other,
  /// on the same delta shape the calculators' verdict gate uses. Two
  /// zeros are always too close: they have no ordering at all.
  static bool tooClose(double a, double b, double minGapPercent) {
    final high = max(a, b);
    if (high <= 0) return true;
    return (high - min(a, b)) / high * 100 < minGapPercent;
  }
}
