import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/energy/presentation/providers/energy_providers.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';
import 'package:seed_app/features/fact_games/presentation/calculator_facts.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';

part 'fact_games_providers.g.dart';

/// Facts the fact games can deal in [locale]: the user's unlocked
/// eco-facts (one per dayOfYear), their discovered Eco-Dex entries, and
/// every SDG and action fact, whose screens are open to all.
///
/// Eco-facts count when unlocked or viewed, as the inbox counts them:
/// older reads predate `unlockedFactDates`. Unread facts are included, so
/// a match shows the user a fact they skipped.
@riverpod
Future<List<GameFact>> factGamesPool(Ref ref, String locale) async {
  final userFuture = ref.watch(currentUserProvider.future);
  final factsFuture = ref.watch(ecoFactsProvider.future);
  final sourcesFuture = _textSources(ref);
  final user = await userFuture;
  final facts = await factsFuture;
  final (goals, actions, entries) = await sourcesFuture;
  if (user == null) return const [];
  final days = {
    for (final key in {...user.unlockedFactDates, ...user.viewedFactDates})
      if (DateTime.tryParse(key) case final date?) dayOfYear(date),
  };
  final discovered = user.ecodexDiscovered.toSet();
  return [
    ...ecoGameFacts(
      facts.where((fact) => days.contains(fact.dayOfYear)),
      locale,
    ),
    ...sdgGameFacts(goals, locale),
    ...actionGameFacts(actions, locale),
    ...ecoDexGameFacts(
      entries.where((entry) => discovered.contains(entry.id)),
      locale,
    ),
  ];
}

/// Every text fact, locked or not: Fact recall's decoy candidates.
@riverpod
Future<List<GameFact>> factGamesAllPlayable(Ref ref, String locale) async {
  final factsFuture = ref.watch(ecoFactsProvider.future);
  final sourcesFuture = _textSources(ref);
  final facts = await factsFuture;
  final (goals, actions, entries) = await sourcesFuture;
  return [
    ...ecoGameFacts(facts, locale),
    ...sdgGameFacts(goals, locale),
    ...actionGameFacts(actions, locale),
    ...ecoDexGameFacts(entries, locale),
  ];
}

/// SDG goals, library actions and Eco-Dex entries. A source that fails
/// to load gives no facts rather than an error for the whole pool.
Future<(List<SdgGoal>, List<ActionModel>, List<EcoDexEntry>)> _textSources(
  Ref ref,
) async {
  final goalsFuture = _orEmpty(
    ref.watch(sdgGoalsDataProvider.future).then((data) => data.goals),
  );
  final actionsFuture = _orEmpty(ref.watch(actionLibraryProvider.future));
  final entriesFuture = _orEmpty(
    ref.watch(ecoDexDataProvider.future).then((data) => data.entries),
  );
  return (await goalsFuture, await actionsFuture, await entriesFuture);
}

Future<List<T>> _orEmpty<T>(Future<List<T>> data) =>
    data.catchError((Object _) => <T>[]);

/// Calculator comparisons in [locale], Fact recall only: always available
/// and never counted towards the lock. A calculator whose data fails to
/// load gives no comparisons rather than an error.
@riverpod
Future<List<GameFact>> factGamesCalculatorFacts(Ref ref, String locale) async {
  final foodsFuture = _orEmpty(ref.watch(foodItemsProvider.future));
  final modesFuture = _orEmpty(ref.watch(transportModesProvider.future));
  final behaviorsFuture = _orEmpty(ref.watch(energyBehaviorsProvider.future));
  final ratios = comparisonRatios(
    foods: await foodsFuture,
    modes: await modesFuture,
    behaviors: await behaviorsFuture,
  );
  return calculatorGameFacts(
    ratios,
    lookupAppLocalizations(Locale(locale)),
    lookupAppLocalizations(const Locale('en')),
  );
}
