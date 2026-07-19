import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Action-data consistency from Plan/RESEARCH_FOOD.md section 7.
///
/// Decision D1 (means dataset-wide) forces corrections to the
/// food swap actions in data/seed/co2_actions_database.json;
/// those corrections land in the SAME PR as this dataset so the
/// app never shows two numbers for one swap. This suite asserts
/// the shipped action deltas reproduce the dataset-implied deltas
/// (0.1 kg of meat avoided minus a documented plant-alternative
/// baseline) within 10%.
void main() {
  // Plant-alternative baselines per section 7: the beef action
  // documents ~200 g CO2e per 100 g plant alternative; chicken
  // and pork document ~100 g.
  const beefPlantAltG = 200.0;
  const otherPlantAltG = 100.0;
  const tolerance = 0.10;

  late Map<String, double> factorById;
  late Map<String, Map<String, dynamic>> actionById;

  setUpAll(() {
    final foodRoot =
        json.decode(File('data/app/food_items.json').readAsStringSync())
            as Map<String, dynamic>;
    final items = (foodRoot['items'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    factorById = {
      for (final item in items)
        item['id'] as String: (item['kg_co2e_per_kg'] as num).toDouble(),
    };

    final actionsRoot =
        json.decode(
              File('data/seed/co2_actions_database.json').readAsStringSync(),
            )
            as Map<String, dynamic>;
    final actions = (actionsRoot['actions'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    actionById = {
      for (final action in actions) action['action_id'] as String: action,
    };
  });

  double shippedGrams(String actionId) =>
      (actionById[actionId]!['co2_grams'] as num).toDouble();

  /// Dataset-implied saving for a 100 g meat serving swapped to a
  /// plant alternative, in grams CO2e.
  double impliedGrams(String itemId, double plantAltG) =>
      0.1 * factorById[itemId]! * 1000 - plantAltG;

  void expectWithinTolerance(String actionId, double implied) {
    final shipped = shippedGrams(actionId);
    expect(
      (shipped - implied).abs() / implied,
      lessThanOrEqualTo(tolerance),
      reason:
          '$actionId shipped $shipped vs dataset-implied '
          '${implied.toStringAsFixed(0)}',
    );
  }

  test('meatless_meal_beef matches the dataset within 10%', () {
    // 9948 - 200 = 9748 -> corrected action ships ~9700 g. The
    // legacy 6000 g encoded the median 60 kg/kg and must fail
    // here until the section 7 correction lands.
    expectWithinTolerance(
      'meatless_meal_beef',
      impliedGrams('beef_beef_herd', beefPlantAltG),
    );
  });

  test('meatless_meal_chicken matches the dataset within 10%', () {
    // 987 - 100 = 887 -> corrected action ships ~890 g.
    expectWithinTolerance(
      'meatless_meal_chicken',
      impliedGrams('chicken', otherPlantAltG),
    );
  });

  test('meatless_meal_pork matches the dataset within 10%', () {
    // 1231 - 100 = 1131 -> corrected action ships ~1100 g.
    expectWithinTolerance(
      'meatless_meal_pork',
      impliedGrams('pork', otherPlantAltG),
    );
  });

  test('plant_milk_vs_dairy stays honestly conservative', () {
    // Dataset-implied delta per 250 ml: (3.15 - 0.9031262) x 0.25
    // = 562 g. The shipped 460 g deliberately stays BELOW the
    // implied delta (soy variant implies 543 g, still above), so
    // this asserts an upper bound rather than a 10% match.
    final implied =
        (factorById['milk_dairy']! - factorById['oat_milk']!) * 0.25 * 1000;
    final shipped = shippedGrams('plant_milk_vs_dairy');
    expect(shipped, greaterThan(0));
    expect(
      shipped,
      lessThanOrEqualTo(implied),
      reason:
          'shipped $shipped vs dataset-implied '
          '${implied.toStringAsFixed(0)}',
    );
  });
}
