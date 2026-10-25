import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';

part 'fact_games_providers.g.dart';

/// Unlocked facts the fact games can deal, one per dayOfYear.
///
/// Unlocked or viewed, as the inbox counts them: older reads predate
/// `unlockedFactDates`. Unread facts are included, so a match shows the
/// user a fact they skipped.
@riverpod
Future<List<EcoFact>> factGamesPool(Ref ref) async {
  final userFuture = ref.watch(currentUserProvider.future);
  final factsFuture = ref.watch(ecoFactsProvider.future);
  final user = await userFuture;
  final facts = await factsFuture;
  if (user == null) return const [];
  final days = {
    for (final key in {...user.unlockedFactDates, ...user.viewedFactDates})
      if (DateTime.tryParse(key) case final date?) dayOfYear(date),
  };
  return [
    for (final fact in facts)
      if (fact.isPlayable && days.contains(fact.dayOfYear)) fact,
  ];
}
