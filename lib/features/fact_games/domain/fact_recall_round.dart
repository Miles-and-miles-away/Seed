import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/fact_games_pool.dart';
import 'package:seed_app/features/fact_games/domain/figure_text.dart';

/// Questions in a full round; smaller pools ask each distinct figure once.
const factRecallRoundLength = 5;

/// One fact with its figure blanked, and three figures to choose from.
@immutable
class RecallQuestion {
  const RecallQuestion({
    required this.fact,
    required this.title,
    required this.blanked,
    required this.revealed,
    required this.options,
    required this.answerIndex,
  });

  final EcoFact fact;
  final String title;

  /// The fact text with its figure replaced by the blank.
  final String blanked;

  /// The fact text as written.
  final String revealed;

  /// The fact's figure and two decoys, shuffled.
  final List<String> options;
  final int answerIndex;

  String get answer => options[answerIndex];
}

/// Valid decoy pairs for [fact] in [locale]: the pairs of the first tier
/// that has any. Empty means the fact cannot be asked, which the data
/// rule forbids.
///
/// Candidates are other facts' figures, one per value, in the answer's
/// unit or family and not already in the blanked text. Tiers prefer the
/// answer's shape, then its unit; no pair shares a shape the answer
/// lacks, so the answer is never the odd one out by format alone.
List<(EcoFact, EcoFact)> decoyPairs(
  EcoFact fact,
  List<EcoFact> allPlayable,
  String locale,
  String blank,
) {
  final answer = fact.keyFigure(locale)!;
  final blanked = fact.fact(locale).replaceAll(answer, blank);
  final byValue = <String, EcoFact>{};
  final byDay = [...allPlayable]
    ..sort((a, b) => a.dayOfYear.compareTo(b.dayOfYear));
  for (final candidate in byDay) {
    if (!candidate.isPlayable || candidate.keyFigureEn == fact.keyFigureEn) {
      continue;
    }
    final figure = candidate.keyFigure(locale)!;
    if (wholeNumberMatches(figure, blanked).isNotEmpty) continue;
    byValue.putIfAbsent(candidate.keyFigureEn, () => candidate);
  }

  final key = figureUnitKey(fact.keyFigureEn);
  final family = figureFamilies[key];
  final shape = figureShape(answer);
  String shapeOf(EcoFact f) => figureShape(f.keyFigure(locale)!);
  final related = [
    for (final candidate in byValue.values)
      if (figureUnitKey(candidate.keyFigureEn) case final k
          when k == key || (family != null && figureFamilies[k] == family))
        candidate,
  ];
  for (final tier in [
    [
      for (final c in related)
        if (shapeOf(c) == shape) c,
    ],
    [
      for (final c in related)
        if (figureUnitKey(c.keyFigureEn) == key) c,
    ],
    related,
  ]) {
    final pairs = [
      for (var i = 0; i < tier.length; i++)
        for (var j = i + 1; j < tier.length; j++)
          if (shapeOf(tier[i]) case final a
              when a != shapeOf(tier[j]) || a == shape)
            (tier[i], tier[j]),
    ];
    if (pairs.isNotEmpty) return pairs;
  }
  return const [];
}

/// A dealt round and its play state. Strings are resolved at deal time,
/// so a round belongs to one locale.
class FactRecallRound {
  FactRecallRound._(this.questions);

  /// Asks up to [factRecallRoundLength] facts from [pool] with distinct
  /// figures, those outside [avoidDays] first, so a new round asks new
  /// facts where the pool allows. Decoys come from [allPlayable].
  factory FactRecallRound.deal({
    required List<EcoFact> pool,
    required List<EcoFact> allPlayable,
    required String locale,
    required String blank,
    required Random random,
    Set<int> avoidDays = const {},
  }) {
    assert(
      distinctFigureCount(pool) >= factGamesMinFacts,
      'Deal only from a pool with $factGamesMinFacts distinct figures',
    );
    final shuffled = [...pool]..shuffle(random);
    final figures = <String>{};
    final questions = <RecallQuestion>[];
    for (final fact in [
      ...shuffled.where((f) => !avoidDays.contains(f.dayOfYear)),
      ...shuffled.where((f) => avoidDays.contains(f.dayOfYear)),
    ]) {
      if (questions.length == factRecallRoundLength) break;
      // EN is canonical: JA and ES can write one value two ways.
      if (!fact.isPlayable || figures.contains(fact.keyFigureEn)) continue;
      final pairs = decoyPairs(fact, allPlayable, locale, blank);
      assert(pairs.isNotEmpty, 'Day ${fact.dayOfYear} has no decoys');
      if (pairs.isEmpty) continue;
      figures.add(fact.keyFigureEn);
      final (a, b) = pairs[random.nextInt(pairs.length)];
      final answer = fact.keyFigure(locale)!;
      final options = [answer, a.keyFigure(locale)!, b.keyFigure(locale)!]
        ..shuffle(random);
      final text = fact.fact(locale);
      questions.add(
        RecallQuestion(
          fact: fact,
          title: fact.name(locale),
          blanked: text.replaceAll(answer, blank),
          revealed: text,
          options: List.unmodifiable(options),
          answerIndex: options.indexOf(answer),
        ),
      );
    }
    return FactRecallRound._(List.unmodifiable(questions));
  }

  final List<RecallQuestion> questions;
  int _index = 0;
  int? _chosen;
  int _correct = 0;

  /// The current question, or [questions]' length once finished.
  int get index => _index;

  /// The option tapped on the current question.
  int? get chosen => _chosen;

  int get correct => _correct;

  bool get finished => _index >= questions.length;

  bool get isLast => _index == questions.length - 1;

  RecallQuestion get question => questions[_index];

  /// Records the answer to the current question. Returns whether it was
  /// right, or null when ignored (already answered, or finished).
  bool? answer(int option) {
    if (finished || _chosen != null) return null;
    _chosen = option;
    final right = option == question.answerIndex;
    if (right) _correct++;
    return right;
  }

  /// Moves to the next question; a no-op before an answer or once
  /// finished.
  void next() {
    if (finished || _chosen == null) return;
    _index++;
    _chosen = null;
  }

  /// Days asked in this round, passed as `avoidDays` to the next deal.
  Set<int> get askedDays => {for (final q in questions) q.fact.dayOfYear};
}
