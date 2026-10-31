import 'package:flutter/foundation.dart';

import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/figure_text.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';

/// Where a fact comes from: picks its title and where it opens.
enum GameFactKind { ecoFact, sdg, action, ecoDex, food, transport, energy }

/// The source a deal rotates by: the three calculators count as one.
enum FactDealGroup { ecoFact, sdg, action, ecoDex, calculator }

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
    required this.locale,
    this.recallOnly = false,
    this.source,
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

  /// The language [title], [text] and [figure] are written in.
  final String locale;

  /// A calculator comparison: Fact recall only, never a Fact pairs face,
  /// and never counted towards a lock.
  final bool recallOnly;

  /// The record the fact was made from (an `EcoFact`, `SdgGoal`,
  /// `ActionModel` or `EcoDexEntry`), so a screen can open it in full.
  final Object? source;

  FactDealGroup get dealGroup => switch (kind) {
    GameFactKind.ecoFact => FactDealGroup.ecoFact,
    GameFactKind.sdg => FactDealGroup.sdg,
    GameFactKind.action => FactDealGroup.action,
    GameFactKind.ecoDex => FactDealGroup.ecoDex,
    GameFactKind.food ||
    GameFactKind.transport ||
    GameFactKind.energy => FactDealGroup.calculator,
  };
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
        locale: locale,
        source: fact,
      ),
];

/// The SDG goals of [goals] with a key figure, in [locale]: the
/// description's sentence that carries the figure, under the short title.
List<GameFact> sdgGameFacts(Iterable<SdgGoal> goals, String locale) => [
  for (final goal in goals)
    if ((goal.keyFigure(locale), goal.keyFigureEn) case (
      final figure?,
      final figureEn,
    ) when figureEn.isNotEmpty)
      if (_sentenceWith(goal.description(locale), figure) case final text?)
        GameFact(
          id: 'sdg:${goal.number}',
          kind: GameFactKind.sdg,
          title: goal.shortTitle(locale),
          text: text,
          figure: figure,
          figureEn: figureEn,
          locale: locale,
          source: goal,
        ),
];

/// The Eco-Dex entries of [entries] with a key figure, in [locale].
List<GameFact> ecoDexGameFacts(Iterable<EcoDexEntry> entries, String locale) =>
    [
      for (final entry in entries)
        if (entry.keyFigure(locale) case final figure?
            when entry.keyFigureEn.isNotEmpty)
          GameFact(
            id: 'ecodex:${entry.id}',
            kind: GameFactKind.ecoDex,
            title: entry.name(locale),
            text: entry.fact(locale),
            figure: figure,
            figureEn: entry.keyFigureEn,
            locale: locale,
            source: entry,
          ),
    ];

/// The library actions of [actions] whose info text opens with one bold
/// CO2 figure in every language, in [locale]: that first sentence. The
/// text comes from Firestore, so an action whose text breaks the rule is
/// skipped rather than dealt.
List<GameFact> actionGameFacts(Iterable<ActionModel> actions, String locale) =>
    [
      for (final action in actions)
        if (action.co2Grams > 0)
          if ((
                actionInfoFigure(action.descriptionLong(locale)),
                actionInfoFigure(action.descriptionLongEn),
              )
              case ((final text, final figure)?, (_, final figureEn)?))
            GameFact(
              id: 'action:${action.id}',
              kind: GameFactKind.action,
              title: action.name(locale),
              text: text,
              figure: figure,
              figureEn: figureEn,
              locale: locale,
              source: action,
            ),
    ];

/// The first sentence of an action's markdown info text, links and bold
/// removed, and its one bold run; null unless there is exactly one and it
/// stands once in the sentence.
(String, String)? actionInfoFigure(String markdown) {
  final plain = markdown.replaceAllMapped(_markdownLink, (m) => m[1]!);
  final first = _sentences(plain).firstOrNull;
  if (first == null) return null;
  final runs = _bold.allMatches(first).toList();
  if (runs.length != 1) return null;
  final figure = runs.single[1]!;
  final text = first.replaceAll('**', '');
  return wholeNumberMatches(figure, text).length == 1 ? (text, figure) : null;
}

/// A full stop ends a sentence only before a space, so "4.9%" stays whole.
final _sentenceEnd = RegExp(r'(?<=[.!?])\s+|(?<=[。！？])');
final _markdownLink = RegExp(r'\[([^\]]*)\]\([^)]*\)');
final _bold = RegExp(r'\*\*(.+?)\*\*');

List<String> _sentences(String text) => [
  for (final sentence in text.split(_sentenceEnd))
    if (sentence.trim().isNotEmpty) sentence.trim(),
];

/// The sentence of [text] that states [figure] once as a whole number.
String? _sentenceWith(String text, String figure) => _sentences(
  text,
).where((s) => wholeNumberMatches(figure, s).length == 1).firstOrNull;
