import 'dart:collection';
import 'dart:math';

import 'package:seed_app/features/fact_games/domain/game_fact.dart';

/// Distinct figures a pool needs to deal; also the small Fact pairs
/// board's pair count.
const factGamesMinFacts = 3;

/// Discovered Eco-Dex entries that open Fact pairs.
const factPairsMinEcoDex = 5;

/// Discovered Eco-Dex entries that open Fact recall.
const factRecallMinEcoDex = 10;

/// Facts that can be dealt from [pool]: one per distinct `figureEn`,
/// since two facts with the same figure cannot share a board or a round.
int distinctFigureCount(Iterable<GameFact> pool) =>
    {for (final fact in pool) fact.figureEn}.length;

/// Up to [count] facts from [pool] that [accept] takes, one deal group at a
/// time in a shuffled order, so no two in a row share a group while another
/// group has facts left. Within a group, facts outside [avoidIds] come first.
List<GameFact> dealInTurn(
  List<GameFact> pool, {
  required int count,
  required Random random,
  required bool Function(GameFact fact) accept,
  Set<String> avoidIds = const {},
}) {
  final shuffled = [...pool]..shuffle(random);
  final queues = <FactDealGroup, Queue<GameFact>>{};
  for (final fact in [
    ...shuffled.where((f) => !avoidIds.contains(f.id)),
    ...shuffled.where((f) => avoidIds.contains(f.id)),
  ]) {
    queues.putIfAbsent(fact.dealGroup, Queue.new).add(fact);
  }
  final groups = Queue.of([...queues.keys]..shuffle(random));
  final dealt = <GameFact>[];
  while (dealt.length < count && groups.isNotEmpty) {
    final group = groups.removeFirst();
    final queue = queues[group]!;
    while (queue.isNotEmpty) {
      final fact = queue.removeFirst();
      if (accept(fact)) {
        dealt.add(fact);
        groups.add(group);
        break;
      }
    }
  }
  return dealt;
}
