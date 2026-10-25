import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/domain/services/energy_calculator.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_display.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/presentation/widgets/food_display.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/domain/services/flight_band.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_display.dart';
import 'package:seed_app/shared/domain/quiz_deck.dart';

/// A domain a round can be drawn from.
///
/// Every round stays inside one of these. A food-versus-electricity pair
/// would set a cradle-to-retail lifecycle figure against an operational
/// one, which is a scope error rather than a hard question, and a
/// food-to-electricity ratio also inherits grid variance linearly where
/// a within-domain one does not (decision E8, and the never-sum warning
/// in all three dataset metadata blocks). Mixing which domain a round
/// comes from is fine; mixing a pair is not.
enum QuizDomain {
  energy,
  food,
  transport;

  ActionCategory get category => switch (this) {
    QuizDomain.energy => ActionCategory.energy,
    QuizDomain.food => ActionCategory.food,
    QuizDomain.transport => ActionCategory.transport,
  };

  /// The fill behind a token.
  Color get color => category.color;

  /// The same colour darkened enough to carry text: the raw category
  /// colours are fills, and amber reads 1.6:1 on white.
  Color ink(Brightness brightness, {bool large = false}) =>
      category.textColorOn(brightness, large: large);

  /// What one card of this domain measures, stated above the tokens so
  /// the user knows what they are comparing.
  String basis(AppLocalizations l10n) => switch (this) {
    QuizDomain.energy => l10n.quizBasisEnergy,
    QuizDomain.food => l10n.quizBasisFood,
    QuizDomain.transport => l10n.quizBasisTransport,
  };

  /// How this domain's figures are measured. The energy note only
  /// claims any-grid validity when the reveal leads with a multiple.
  String note(
    AppLocalizations l10n, {
    required double gridFactor,
    required bool hasAnchor,
  }) => switch (this) {
    QuizDomain.energy =>
      hasAnchor
          ? l10n.energyGridBasisNoteRatio(gridFactor.round())
          : l10n.energyGridBasisNote(gridFactor.round()),
    QuizDomain.food => l10n.quizNoteFood,
    QuizDomain.transport => l10n.quizNoteTransport,
  };
}

/// An energy behaviour at its default preset. With an anchor
/// ([anchorKwh] above zero) the reveal leads with the multiple and the
/// grams follow (rule 26); without one it states grams alone.
QuizCard energyQuizCard(
  AppLocalizations l10n,
  String locale,
  EnergyBehavior behavior, {
  required double anchorKwh,
  required String anchorPhrase,
  required double gridFactor,
}) {
  final kwh = EnergyCalculator.defaultPresetKwh(behavior);
  final grams = formatCO2Compact((kwh * gridFactor).round(), locale);
  final hasAnchor = anchorKwh > 0;
  return QuizCard(
    id: 'energy:${behavior.id}',
    title: keepUnitsTogether(behavior.name(locale)),
    subtitle: keepUnitsTogether(behavior.defaultPreset?.name(locale) ?? ''),
    magnitude: kwh,
    revealText: hasAnchor
        ? l10n.energyExploreSheetMultiple(
            formatEnergyMultiple(locale, kwh / anchorKwh),
            anchorPhrase,
          )
        : grams,
    revealDetail: hasAnchor ? grams : '',
    groupLabel: energyGroupLabel(l10n, behavior.comparableGroup),
  );
}

/// Grams CO2e of one default serving: `kg CO2e per kg x serving
/// grams`, the same arithmetic the food calculator uses.
QuizCard foodQuizCard(AppLocalizations l10n, String locale, FoodItem item) {
  final serving = item.defaultServing!;
  final grams = item.kgCo2ePerKg * serving.grams;
  return QuizCard(
    id: 'food:${item.id}',
    title: item.name(locale),
    subtitle: keepUnitsTogether(servingHeadline(serving.name(locale))),
    magnitude: grams,
    revealText: formatCO2Compact(grams.round(), locale),
    groupLabel: foodGroupLabel(l10n, item.group),
  );
}

/// Flight bands carry DEFRA's average route length, because "domestic"
/// is a jurisdiction, not a distance, and a player has no other way
/// to rank it against short-haul.
QuizCard transportQuizCard(
  AppLocalizations l10n,
  String locale,
  TransportMode mode,
) => QuizCard(
  id: 'transport:${mode.id}',
  title: mode.name(locale),
  subtitle: switch (mode.id) {
    flightModeDomestic => l10n.quizFlightDomesticNote,
    flightModeShortHaul => l10n.quizFlightShortHaulNote,
    flightModeLongHaul => l10n.quizFlightLongHaulNote,
    _ => '',
  },
  magnitude: mode.gCo2ePerKm,
  revealText: l10n.quizPerKm(formatCO2Compact(mode.gCo2ePerKm.round(), locale)),
  groupLabel: transportGroupLabel(l10n, mode.group),
);
