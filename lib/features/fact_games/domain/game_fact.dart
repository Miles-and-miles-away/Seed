import 'package:flutter/foundation.dart';

import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';

/// Where a fact comes from.
enum GameFactKind { ecoFact }

/// A fact from any source, resolved for one locale: the unit the fact
/// games deal, pair and ask.
@immutable
class GameFact {
  const GameFact({
    required this.id,
    required this.kind,
    required this.title,
    required this.text,
    required this.figure,
    required this.figureEn,
  });

  /// Unique across kinds, such as `fact:12`; two cards pair on it.
  final String id;
  final GameFactKind kind;
  final String title;

  /// Contains [figure] exactly once.
  final String text;
  final String figure;

  /// The figure in English: the canonical value key, since JA and ES can
  /// write one value two ways.
  final String figureEn;
}

/// The playable eco-facts of [facts] in [locale].
List<GameFact> ecoGameFacts(Iterable<EcoFact> facts, String locale) => [
  for (final fact in facts)
    if (fact.isPlayable)
      GameFact(
        id: 'fact:${fact.dayOfYear}',
        kind: GameFactKind.ecoFact,
        title: fact.name(locale),
        text: fact.fact(locale),
        figure: fact.keyFigure(locale)!,
        figureEn: fact.keyFigureEn,
      ),
];
