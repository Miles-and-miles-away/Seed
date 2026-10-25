import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';

/// Distinct figures a pool needs before the fact games unlock; also the
/// small Fact pairs board's pair count.
const factGamesMinFacts = 3;

/// Facts that can be dealt from [pool]: one per distinct `keyFigureEn`,
/// since two facts with the same figure cannot share a board or a round.
int distinctFigureCount(Iterable<EcoFact> pool) => {
  for (final fact in pool)
    if (fact.isPlayable) fact.keyFigureEn,
}.length;
