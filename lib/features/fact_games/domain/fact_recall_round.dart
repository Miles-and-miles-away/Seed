import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:seed_app/features/fact_games/domain/fact_games_pool.dart';
import 'package:seed_app/features/fact_games/domain/figure_text.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';

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

  final GameFact fact;
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

/// Valid decoy figures for [fact] among [candidates], resolved in the
/// same locale: the pairs of the first tier that has any. Empty means the
/// fact cannot be asked, which the data rule forbids.
///
/// Candidates are other facts' figures, one per value (the first in
/// [candidates] order), in the answer's unit or family and not already in
/// the blanked text. Tiers prefer the answer's shape, then the answer's
/// own numbers scaled, then its unit, then its family; no pair shares a
/// shape the answer lacks, so the answer is never the odd one out by
/// format alone.
List<(String, String)> decoyPairs(
  GameFact fact,
  List<GameFact> candidates,
  String blank,
) {
  final answer = fact.figure;
  final blanked = fact.text.replaceAll(answer, blank);
  bool fair(String figure) => wholeNumberMatches(figure, blanked).isEmpty;
  final byValue = <String, GameFact>{};
  for (final candidate in candidates) {
    if (candidate.figureEn == fact.figureEn || !fair(candidate.figure)) {
      continue;
    }
    byValue.putIfAbsent(candidate.figureEn, () => candidate);
  }

  final key = figureUnitKey(fact.figureEn);
  final family = figureFamilies[key];
  final shape = figureShape(answer);
  final related = [
    for (final candidate in byValue.values)
      if (figureUnitKey(candidate.figureEn) case final k
          when k == key || (family != null && figureFamilies[k] == family))
        candidate,
  ];
  List<(String, String)> pairsOf(List<GameFact> tier) => [
    for (var i = 0; i < tier.length; i++)
      for (var j = i + 1; j < tier.length; j++)
        if (figureShape(tier[i].figure) case final a
            when a != figureShape(tier[j].figure) || a == shape)
          (tier[i].figure, tier[j].figure),
  ];
  final sameShape = pairsOf([
    for (final c in related)
      if (figureShape(c.figure) == shape) c,
  ]);
  if (sameShape.isNotEmpty) return sameShape;
  final scaled = [
    for (final (a, b) in scaledDecoyPairs(
      answer,
      fact.locale,
      key,
      comparison: fact.recallOnly,
    ))
      if (fair(a) && fair(b)) (a, b),
  ];
  if (scaled.isNotEmpty) return scaled;
  for (final tier in [
    [
      for (final c in related)
        if (figureUnitKey(c.figureEn) == key) c,
    ],
    related,
  ]) {
    final pairs = pairsOf(tier);
    if (pairs.isNotEmpty) return pairs;
  }
  return const [];
}

/// A dealt round and its play state. Its facts are resolved for one
/// locale, so a round belongs to that locale.
class FactRecallRound {
  FactRecallRound._(this.questions);

  /// Asks up to [factRecallRoundLength] facts from [pool] with distinct
  /// figures, kinds in turn, those outside [avoidIds] first, so a new
  /// round asks new facts where the pool allows. Decoys come from
  /// [allPlayable]; a recall-only fact's are its own figure scaled, since
  /// another fact's multiple could sit too close to it.
  factory FactRecallRound.deal({
    required List<GameFact> pool,
    required List<GameFact> allPlayable,
    required String blank,
    required Random random,
    Set<String> avoidIds = const {},
  }) {
    assert(
      distinctFigureCount(pool) >= factGamesMinFacts,
      'Deal only from a pool with $factGamesMinFacts distinct figures',
    );
    final figures = <String>{};
    final decoys = <String, List<(String, String)>>{};
    final facts = dealInTurn(
      pool,
      count: factRecallRoundLength,
      random: random,
      avoidIds: avoidIds,
      accept: (fact) {
        if (figures.contains(fact.figureEn)) return false;
        final pairs = decoyPairs(
          fact,
          fact.recallOnly ? const [] : allPlayable,
          blank,
        );
        // Action text comes from Firestore, so it may predate the data rule.
        assert(
          pairs.isNotEmpty || fact.kind == GameFactKind.action,
          '${fact.id} has no decoys',
        );
        if (pairs.isEmpty) return false;
        figures.add(fact.figureEn);
        decoys[fact.id] = pairs;
        return true;
      },
    );
    final questions = <RecallQuestion>[];
    for (final fact in facts) {
      final pairs = decoys[fact.id]!;
      final (a, b) = pairs[random.nextInt(pairs.length)];
      final answer = fact.figure;
      final options = [answer, a, b]..shuffle(random);
      final text = fact.text;
      questions.add(
        RecallQuestion(
          fact: fact,
          title: fact.title,
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

  /// Facts asked in this round, passed as `avoidIds` to the next deal.
  Set<String> get askedIds => {for (final q in questions) q.fact.id};
}
