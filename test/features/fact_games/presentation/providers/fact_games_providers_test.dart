import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/fact_games/fact_games.dart';

import '../../../../helpers/test_helpers.dart';
import '../../fact_games_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final facts = [...playableFacts(10), unplayableFact(11)];

  Future<List<int>> poolDays(AppUserModel? user) async {
    final container = await pumpedContainer([
      userOverride(user),
      ecoFactsProvider.overrideWith((_) async => facts),
    ]);
    final pool = await container.read(factGamesPoolProvider.future);
    return [for (final fact in pool) fact.dayOfYear];
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

  group('distinctFigureCount', () {
    test('counts each EN figure once and skips unplayable facts', () {
      expect(
        distinctFigureCount([
          playableFact(1, figure: '5 kg'),
          playableFact(2, figure: '5 kg'),
          playableFact(3),
          unplayableFact(4),
        ]),
        2,
      );
    });
  });
}
