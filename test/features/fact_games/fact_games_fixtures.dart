import 'package:flutter_riverpod/misc.dart';

import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/eco_dex/data/eco_dex_entries_data.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';
import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';

/// A playable fact for [day] whose figure is `{day} kg` unless given.
EcoFact playableFact(
  int day, {
  String? figure,
  String? figureJa,
  String? figureEs,
}) {
  final en = figure ?? '$day kg';
  final ja = figureJa ?? en;
  final es = figureEs ?? en;
  return EcoFact(
    dayOfYear: day,
    category: 'energy',
    nameEn: 'Title $day',
    nameJa: 'タイトル$day',
    nameEs: 'Título $day',
    factEn: 'Fact $day says $en.',
    factJa: 'ファクト$dayは$jaです。',
    factEs: 'El dato $day dice $es.',
    sourceEn: 'Source',
    keyFigureEn: en,
    keyFigureJa: ja,
    keyFigureEs: es,
  );
}

/// A fact with no key figure, which the games never deal.
EcoFact unplayableFact(int day) => EcoFact(
  dayOfYear: day,
  category: 'energy',
  nameEn: 'Title $day',
  factEn: 'Fact $day has no number.',
  sourceEn: 'Source',
);

/// Playable facts for days 1 to [count].
List<EcoFact> playableFacts(int count) => [
  for (var day = 1; day <= count; day++) playableFact(day),
];

/// A resolved English fact of [kind] whose figure is [figure].
GameFact kindFact(
  String id,
  GameFactKind kind, {
  String? figure,
  bool recallOnly = false,
}) {
  final value = figure ?? '${id.hashCode.abs() % 1000 + 2} kg';
  return GameFact(
    id: id,
    kind: kind,
    title: 'Title $id',
    text: 'Fact $id says $value.',
    figure: value,
    figureEn: value,
    locale: 'en',
    recallOnly: recallOnly,
  );
}

/// The pool's SDG, action and Eco-Dex sources, empty, so a test's pool is
/// its eco-facts alone.
List<Override> emptyTextSources() => [
  sdgGoalsDataProvider.overrideWith(
    (_) async => const SdgGoalsData(goals: [], goalMap: {}),
  ),
  actionLibraryProvider.overrideWith((_) async => const []),
  ecoDexDataProvider.overrideWith(
    (_) async => const EcoDexData(categories: [], entries: []),
  ),
];

/// [count] discovered Eco-Dex entries, whatever the user document says.
Override discoveredEntries(int count) =>
    ecoDexDiscoveredCountProvider.overrideWith((_) => count);
