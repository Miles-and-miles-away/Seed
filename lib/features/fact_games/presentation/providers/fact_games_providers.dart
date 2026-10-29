import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';

part 'fact_games_providers.g.dart';

/// Unlocked facts the fact games can deal in [locale], one per dayOfYear.
///
/// Unlocked or viewed, as the inbox counts them: older reads predate
/// `unlockedFactDates`. Unread facts are included, so a match shows the
/// user a fact they skipped.
@riverpod
Future<List<GameFact>> factGamesPool(Ref ref, String locale) async {
  final userFuture = ref.watch(currentUserProvider.future);
  final factsFuture = ref.watch(ecoFactsProvider.future);
  final user = await userFuture;
  final facts = await factsFuture;
  if (user == null) return const [];
  final days = {
    for (final key in {...user.unlockedFactDates, ...user.viewedFactDates})
      if (DateTime.tryParse(key) case final date?) dayOfYear(date),
  };
  return ecoGameFacts(
    facts.where((fact) => days.contains(fact.dayOfYear)),
    locale,
  );
}

/// Every playable fact, locked or not: Fact recall's decoy candidates.
@riverpod
Future<List<GameFact>> factGamesAllPlayable(Ref ref, String locale) async =>
    ecoGameFacts(await ref.watch(ecoFactsProvider.future), locale);
