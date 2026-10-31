import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';

import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/energy/data/energy_behaviors_data.dart';
import 'package:seed_app/features/energy/presentation/providers/energy_providers.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';
import 'package:seed_app/features/fact_games/fact_games.dart';
import 'package:seed_app/features/fact_games/presentation/calculator_facts.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import 'package:seed_app/features/transport/data/transport_modes_data.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';

import '../../../../helpers/test_helpers.dart';
import '../../fact_games_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final facts = [...playableFacts(10), unplayableFact(11)];

  Future<List<int>> poolDays(AppUserModel? user) async {
    final container = await pumpedContainer([
      userOverride(user),
      ecoFactsProvider.overrideWith((_) async => facts),
      ...emptyTextSources(),
    ]);
    final pool = await container.read(factGamesPoolProvider('en').future);
    return [for (final fact in pool) int.parse(fact.id.split(':').last)];
  }

  group('factGamesPoolProvider', () {
    test('is the union of unlocked and viewed dates', () async {
      final days = await poolDays(
        const AppUserModel(
          uid: 'u',
          email: 'e',
          unlockedFactDates: ['2026-01-02', '2026-01-03'],
          viewedFactDates: ['2026-01-03', '2026-01-05'],
        ),
      );
      expect(days, [2, 3, 5]);
    });

    test('holds one fact per dayOfYear across years', () async {
      final days = await poolDays(
        const AppUserModel(
          uid: 'u',
          email: 'e',
          unlockedFactDates: ['2025-01-04', '2026-01-04'],
          viewedFactDates: ['2024-01-04'],
        ),
      );
      expect(days, [4]);
    });

    test('leaves out facts without a figure and bad keys', () async {
      final days = await poolDays(
        const AppUserModel(
          uid: 'u',
          email: 'e',
          unlockedFactDates: ['2026-01-01', '2026-01-11', 'not-a-date'],
        ),
      );
      expect(days, [1]);
    });

    test('is empty with no user', () async {
      expect(await poolDays(null), isEmpty);
    });
  });

  group('the other sources', () {
    const user = AppUserModel(
      uid: 'u',
      email: 'e',
      ecodexDiscovered: ['climate_01'],
    );
    final action = ActionModel(
      id: 'cycle',
      nameEn: 'Cycle',
      nameJa: '自転車',
      category: 'transport',
      points: 1,
      co2Grams: 1100,
      descriptionLongEn: 'Cycling saves about **1.1 kg** of CO2. More.',
    );

    Future<List<String>> ids(
      String provider, {
      List<Override> overrides = const [],
    }) async {
      final container = await pumpedContainer([
        userOverride(user),
        ecoFactsProvider.overrideWith((_) async => const []),
        actionLibraryProvider.overrideWith((_) async => [action]),
        ...overrides,
      ]);
      final facts = await container.read(
        provider == 'pool'
            ? factGamesPoolProvider('en').future
            : factGamesAllPlayableProvider('en').future,
      );
      return [for (final fact in facts) fact.id];
    }

    test('the pool has every SDG and action fact and discovered Eco-Dex '
        'entries only', () async {
      final pool = await ids('pool');
      expect(pool.where((id) => id.startsWith('sdg:')), hasLength(8));
      expect(pool, contains('action:cycle'));
      expect(pool.where((id) => id.startsWith('ecodex:')), [
        'ecodex:climate_01',
      ]);
    });

    test('decoy candidates hold every Eco-Dex entry', () async {
      final all = await ids('all');
      expect(
        all.where((id) => id.startsWith('ecodex:')).length,
        greaterThan(1),
      );
    });

    test('a failed source leaves the others', () async {
      final pool = await ids(
        'pool',
        overrides: [
          sdgGoalsDataProvider.overrideWith((_) => Future.error('broken')),
        ],
      );
      expect(pool.where((id) => id.startsWith('sdg:')), isEmpty);
      expect(pool, containsAll(['action:cycle', 'ecodex:climate_01']));
    });
  });

  group('factGamesAllPlayableProvider', () {
    test('is every playable fact, locked or not, and nothing else', () async {
      final container = await pumpedContainer([
        userOverride(null),
        ecoFactsProvider.overrideWith((_) async => facts),
        ...emptyTextSources(),
      ]);
      final all = await container.read(
        factGamesAllPlayableProvider('en').future,
      );
      expect(
        [for (final fact in all) fact.id],
        [for (var day = 1; day <= 10; day++) 'fact:$day'],
      );
    });
  });

  group('factGamesCalculatorFactsProvider', () {
    test('a failed calculator leaves the other comparisons', () async {
      final modes = await loadTransportModes();
      final behaviors = await loadEnergyBehaviors();
      final container = await pumpedContainer([
        foodItemsProvider.overrideWith((_) => Future.error('offline')),
        transportModesProvider.overrideWith((_) async => modes),
        energyBehaviorsProvider.overrideWith((_) async => behaviors),
      ]);
      final facts = await container.read(
        factGamesCalculatorFactsProvider('es').future,
      );
      expect(
        [for (final fact in facts) fact.id],
        [
          for (final c in calculatorComparisons)
            if (c.kind != GameFactKind.food) c.id,
        ],
      );
      expect(facts.every((f) => f.recallOnly && f.locale == 'es'), isTrue);
    });
  });

  group('distinctFigureCount', () {
    test('counts each EN figure once and skips unplayable facts', () {
      expect(
        distinctFigureCount(
          ecoGameFacts([
            playableFact(1, figure: '5 kg'),
            playableFact(2, figure: '5 kg'),
            playableFact(3),
            unplayableFact(4),
          ], 'en'),
        ),
        2,
      );
    });
  });
}
