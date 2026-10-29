import 'package:seed_app/features/fact_games/domain/game_fact.dart';

/// Distinct figures a pool needs before the fact games unlock; also the
/// small Fact pairs board's pair count.
const factGamesMinFacts = 3;

/// Facts that can be dealt from [pool]: one per distinct `figureEn`,
/// since two facts with the same figure cannot share a board or a round.
int distinctFigureCount(Iterable<GameFact> pool) =>
    {for (final fact in pool) fact.figureEn}.length;
