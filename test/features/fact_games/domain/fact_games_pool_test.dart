import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/fact_games/domain/fact_games_pool.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';

import '../fact_games_fixtures.dart';

List<GameFact> _pool(Map<GameFactKind, int> counts) => [
  for (final MapEntry(key: kind, value: count) in counts.entries)
    for (var i = 0; i < count; i++) kindFact('${kind.name}:$i', kind),
];

void main() {
  group('dealInTurn', () {
    test('never deals one group twice in a row while another has facts', () {
      final pool = _pool({
        GameFactKind.ecoFact: 6,
        GameFactKind.food: 3,
        GameFactKind.transport: 1,
        GameFactKind.energy: 2,
      });
      for (var seed = 0; seed < 50; seed++) {
        final dealt = dealInTurn(
          pool,
          count: pool.length,
          random: Random(seed),
          accept: (_) => true,
        );
        expect(dealt, hasLength(pool.length));
        for (var i = 1; i < dealt.length; i++) {
          if (dealt[i].dealGroup != dealt[i - 1].dealGroup) continue;
          final rest = dealt.skip(i).map((f) => f.dealGroup).toSet();
          expect(rest, {dealt[i].dealGroup}, reason: 'seed $seed at $i');
        }
      }
    });

    test('the three calculators count as one source', () {
      final pool = _pool({
        GameFactKind.ecoFact: 4,
        GameFactKind.food: 1,
        GameFactKind.transport: 1,
        GameFactKind.energy: 1,
      });
      for (var seed = 0; seed < 50; seed++) {
        final dealt = dealInTurn(
          pool,
          count: 5,
          random: Random(seed),
          accept: (_) => true,
        );
        expect(dealt, hasLength(5));
        for (var i = 1; i < dealt.length; i++) {
          expect(
            {dealt[i].dealGroup, dealt[i - 1].dealGroup},
            isNot({FactDealGroup.calculator}),
            reason: 'seed $seed: ${dealt.map((f) => f.id)}',
          );
        }
      }
    });

    test('calculator facts alone still deal', () {
      final pool = _pool({
        GameFactKind.food: 2,
        GameFactKind.transport: 2,
        GameFactKind.energy: 2,
      });
      final dealt = dealInTurn(
        pool,
        count: 5,
        random: Random(2),
        accept: (_) => true,
      );
      expect(dealt, hasLength(5));
    });

    test('a refused fact never puts one kind twice in a row', () {
      final pool = _pool({GameFactKind.ecoFact: 4, GameFactKind.food: 4});
      for (var seed = 0; seed < 50; seed++) {
        final dealt = dealInTurn(
          pool,
          count: 4,
          random: Random(seed),
          accept: (fact) => !fact.id.endsWith(':0'),
        );
        expect(dealt.map((f) => f.id), isNot(contains(endsWith(':0'))));
        for (var i = 1; i < dealt.length; i++) {
          expect(dealt[i].kind, isNot(dealt[i - 1].kind), reason: '$seed');
        }
      }
    });

    test('takes any kind, so new sources join without changes', () {
      final pool = _pool({for (final kind in GameFactKind.values) kind: 1});
      final dealt = dealInTurn(
        pool,
        count: pool.length,
        random: Random(1),
        accept: (_) => true,
      );
      expect(dealt.map((f) => f.kind).toSet(), GameFactKind.values.toSet());
    });

    test('within a kind, facts outside avoidIds come first', () {
      final pool = _pool({GameFactKind.ecoFact: 4, GameFactKind.food: 4});
      final avoid = {'ecoFact:0', 'ecoFact:1', 'food:2'};
      final dealt = dealInTurn(
        pool,
        count: 4,
        random: Random(3),
        avoidIds: avoid,
        accept: (_) => true,
      );
      expect(dealt.map((f) => f.id).toSet().intersection(avoid), isEmpty);
    });

    test('one kind deals in plain shuffled order', () {
      final pool = _pool({GameFactKind.ecoFact: 8});
      final dealt = dealInTurn(
        pool,
        count: 8,
        random: Random(5),
        accept: (_) => true,
      );
      expect(dealt, [...pool]..shuffle(Random(5)));
    });
  });
}
