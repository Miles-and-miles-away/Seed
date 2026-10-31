import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_science_bottom_sheet.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_sheet.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/shared/widgets/info_sheet.dart';

/// Opens [fact] after a wrong answer: a calculator comparison opens its
/// calculator, any other fact its sheet over the round, so Back returns to
/// the question.
void openFactSource(BuildContext context, GameFact fact) {
  switch (fact.kind) {
    case GameFactKind.food:
      context.push(appRoutes.foodCalculator);
    case GameFactKind.transport:
      context.push(appRoutes.transportCalculator);
    case GameFactKind.energy:
      context.push(appRoutes.energyCalculator);
    case GameFactKind.ecoFact ||
        GameFactKind.sdg ||
        GameFactKind.action ||
        GameFactKind.ecoDex:
      showFactSheet(context, fact);
  }
}

/// Shows [fact] in full, the same in both games: an eco-fact with its
/// source, an SDG goal's whole description, an action's info sheet, an
/// Eco-Dex entry's sheet, otherwise the game text.
void showFactSheet(BuildContext context, GameFact fact) {
  switch (fact.source) {
    case final EcoFact ecoFact:
      final l10n = AppLocalizations.of(context);
      InfoSheet.show(
        context,
        title: fact.title,
        body:
            '${fact.text}\n\n'
            '${l10n.ecoFactSource}: ${ecoFact.source(fact.locale)}',
      );
    case final SdgGoal goal:
      InfoSheet.show(
        context,
        title: fact.title,
        body: goal.description(fact.locale),
      );
    case final ActionModel action:
      ActionScienceBottomSheet.show(
        context,
        action: action,
        languageCode: fact.locale,
      );
    case final EcoDexEntry entry:
      EcoDexEntrySheet.show(context, entry: entry, locale: fact.locale);
    case _:
      InfoSheet.show(context, title: fact.title, body: fact.text);
  }
}
