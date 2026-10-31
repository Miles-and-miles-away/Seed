import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/quiz/presentation/quiz_cards.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';

/// Below this ratio a comparison reads as a percentage more, not a
/// multiple.
const _percentBelowRatio = 2.0;

/// A curated comparison of two calculator items on one basis: [more]
/// emits a multiple of [less]. The sentence is written by hand per
/// language; only the figure comes from the data.
typedef CalculatorComparison = ({
  String id,
  GameFactKind kind,
  String more,
  String less,
  String Function(AppLocalizations l10n, String figure) sentence,
});

/// The comparisons Fact recall asks, by item id. Food compares kg CO2e
/// per kg, transport g CO2e per passenger-km, and energy kWh per unit of
/// electricity, where the grid factor cancels.
final List<CalculatorComparison> calculatorComparisons = [
  (
    id: 'food:beef-tofu',
    kind: GameFactKind.food,
    more: 'beef',
    less: 'tofu',
    sentence: (l10n, figure) => l10n.factRecallBeefTofu(figure),
  ),
  (
    id: 'food:chicken-beans',
    kind: GameFactKind.food,
    more: 'chicken',
    less: 'beans_lentils',
    sentence: (l10n, figure) => l10n.factRecallChickenBeans(figure),
  ),
  (
    id: 'food:beef-chicken',
    kind: GameFactKind.food,
    more: 'beef',
    less: 'chicken',
    sentence: (l10n, figure) => l10n.factRecallBeefChicken(figure),
  ),
  (
    id: 'food:lamb-pork',
    kind: GameFactKind.food,
    more: 'lamb',
    less: 'pork',
    sentence: (l10n, figure) => l10n.factRecallLambPork(figure),
  ),
  (
    id: 'food:milk-oat',
    kind: GameFactKind.food,
    more: 'milk_dairy',
    less: 'oat_milk',
    sentence: (l10n, figure) => l10n.factRecallMilkOat(figure),
  ),
  (
    id: 'transport:flight-shinkansen',
    kind: GameFactKind.transport,
    more: 'flight_domestic',
    less: 'rail_shinkansen',
    sentence: (l10n, figure) => l10n.factRecallFlightShinkansen(figure),
  ),
  (
    id: 'transport:jet-longhaul',
    kind: GameFactKind.transport,
    more: 'private_jet',
    less: 'flight_longhaul',
    sentence: (l10n, figure) => l10n.factRecallPrivateJet(figure),
  ),
  (
    id: 'transport:ferry-car-foot',
    kind: GameFactKind.transport,
    more: 'ferry_car',
    less: 'ferry_foot',
    sentence: (l10n, figure) => l10n.factRecallFerry(figure),
  ),
  (
    id: 'transport:car-coach',
    kind: GameFactKind.transport,
    more: 'car_petrol_avg',
    less: 'coach',
    sentence: (l10n, figure) => l10n.factRecallCarCoach(figure),
  ),
  (
    id: 'transport:car-bus',
    kind: GameFactKind.transport,
    more: 'car_petrol_avg',
    less: 'bus_city',
    sentence: (l10n, figure) => l10n.factRecallCarBus(figure),
  ),
  (
    id: 'transport:car-rail',
    kind: GameFactKind.transport,
    more: 'car_petrol_avg',
    less: 'rail_national',
    sentence: (l10n, figure) => l10n.factRecallCarRail(figure),
  ),
  (
    id: 'energy:bulbs',
    kind: GameFactKind.energy,
    more: 'incandescent_bulb',
    less: 'led_bulb',
    sentence: (l10n, figure) => l10n.factRecallBulbs(figure),
  ),
  (
    id: 'energy:showers',
    kind: GameFactKind.energy,
    more: 'shower_electric',
    less: 'shower_heatpump',
    sentence: (l10n, figure) => l10n.factRecallShowers(figure),
  ),
  (
    id: 'energy:washes',
    kind: GameFactKind.energy,
    more: 'wash_hot',
    less: 'wash_cold',
    sentence: (l10n, figure) => l10n.factRecallWashes(figure),
  ),
  (
    id: 'energy:cooling',
    kind: GameFactKind.energy,
    more: 'aircon_cooling',
    less: 'fan',
    sentence: (l10n, figure) => l10n.factRecallCooling(figure),
  ),
  (
    id: 'energy:dryers',
    kind: GameFactKind.energy,
    more: 'dryer_vented',
    less: 'dryer_heatpump',
    sentence: (l10n, figure) => l10n.factRecallDryers(figure),
  ),
  (
    id: 'energy:dishwasher',
    kind: GameFactKind.energy,
    more: 'dishwasher_normal',
    less: 'dishwasher_eco',
    sentence: (l10n, figure) => l10n.factRecallDishwasher(figure),
  ),
];

/// Comparisons whose sentence states a percentage more ("57% more").
const _percentComparisons = {'transport:car-bus', 'energy:dishwasher'};

/// Comparisons whose [CalculatorComparison.more] is a car driven alone:
/// its per-vehicle value at one occupant is per passenger.
const _drivenAlone = {
  'transport:car-coach',
  'transport:car-bus',
  'transport:car-rail',
};

/// [ratio] as the figure of a comparison: a whole percentage more below
/// 2x, otherwise a multiple with one decimal below 10x ("7.1 times") and
/// whole above ("22 times").
String comparisonFigure(AppLocalizations l10n, double ratio) {
  final locale = l10n.localeName;
  if (ratio < _percentBelowRatio) {
    return '${formatDecimal((ratio - 1) * 100, locale, maxDigits: 0)}%';
  }
  final digits = ratio >= 10 ? 0 : 1;
  final rounded = double.parse(ratio.toStringAsFixed(digits));
  return l10n.factRecallTimes(
    rounded,
    formatDecimal(rounded, locale, maxDigits: digits),
  );
}

/// Ratios of [calculatorComparisons] by id, over the items Higher or
/// Lower deals, plus cars driven alone. A comparison whose items are
/// missing, off the deck, on different units, or whose ratio no longer
/// fits its sentence is left out; the data test pins that none is.
Map<String, double> comparisonRatios({
  required List<FoodItem> foods,
  required List<TransportMode> modes,
  required List<EnergyBehavior> behaviors,
}) {
  final food = {
    for (final item in foods)
      if (isQuizFood(item)) item.id: item.kgCo2ePerKg,
  };
  final transport = {
    for (final mode in modes)
      if (isQuizTransport(mode)) mode.id: mode.gCo2ePerKm,
  };
  final drivenAlone = {
    for (final mode in modes)
      if (mode.perVehicle) mode.id: mode.gCo2ePerKm,
  };
  final energy = {
    for (final behavior in behaviors)
      if (isQuizEnergy(behavior) &&
          behavior.carrier == EnergyCarrier.electricity)
        behavior.id: behavior,
  };
  double? ratioOf(CalculatorComparison c) => switch (c.kind) {
    GameFactKind.food => _ratio(food[c.more], food[c.less]),
    GameFactKind.transport => _ratio(
      (_drivenAlone.contains(c.id) ? drivenAlone : transport)[c.more],
      transport[c.less],
    ),
    GameFactKind.energy => switch ((energy[c.more], energy[c.less])) {
      (final more?, final less?) when more.unit == less.unit => _ratio(
        more.kwhPerUnit,
        less.kwhPerUnit,
      ),
      _ => null,
    },
    _ => null,
  };
  return {
    for (final c in calculatorComparisons)
      if (ratioOf(c) case final ratio?
          when ratio > 1 &&
              (ratio < _percentBelowRatio) ==
                  _percentComparisons.contains(c.id))
        c.id: ratio,
  };
}

double? _ratio(double? more, double? less) =>
    more == null || less == null || less <= 0 ? null : more / less;

/// The comparisons of [ratios] as Fact recall facts in [l10n]'s language,
/// titled with their calculator's name; [en] writes each `figureEn`.
List<GameFact> calculatorGameFacts(
  Map<String, double> ratios,
  AppLocalizations l10n,
  AppLocalizations en,
) => [
  for (final c in calculatorComparisons)
    if (ratios[c.id] case final ratio?) _fact(c, ratio, l10n, en),
];

GameFact _fact(
  CalculatorComparison c,
  double ratio,
  AppLocalizations l10n,
  AppLocalizations en,
) {
  final figure = comparisonFigure(l10n, ratio);
  final title = switch (c.kind) {
    GameFactKind.food => l10n.foodCalculatorTitle,
    GameFactKind.transport => l10n.transportCalculatorTitle,
    _ => l10n.energyCalculatorTitle,
  };
  return GameFact(
    id: c.id,
    kind: c.kind,
    title: title,
    clue: title,
    text: keepUnitsTogether(c.sentence(l10n, figure)),
    figure: figure,
    figureEn: comparisonFigure(en, ratio),
    locale: l10n.localeName,
    recallOnly: true,
  );
}
