import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Action-data consistency from Plan/PDR_FOOD_CALCULATOR.md.
///
/// Decision D1 (means dataset-wide) forces corrections to the
/// food swap actions in data/seed/co2_actions_database.json;
/// those corrections land in the SAME PR as this dataset so the
/// app never shows two numbers for one swap. This suite asserts
/// the shipped action deltas reproduce the dataset-implied deltas
/// (0.1 kg of meat avoided minus a documented plant-alternative
/// baseline) within 10%.
void main() {
  // Standardized plant-alternative baseline (section 7, closed
  // 2026-07-20): every meatless action deducts 200 g CO2e per
  // 100 g serving (beans/lentils, OWID "Other Pulses" 1.79 kg/kg
  // = 179 g, rounded up to 200 g). Before standardization the
  // beef action used 200 g but chicken/pork used a 100 g peas
  // baseline.
  const plantAltBaselineG = 200.0;

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

  /// A tier action covers several items, so the honest bound is
  /// the SMALLEST implied delta among them -- crediting the
  /// tier's worst item would overstate every other choice. Same
  /// rule as plant_milk below.
  void expectAtOrBelowTierMinimum(String actionId, List<String> itemIds) {
    final implied = itemIds
        .map((id) => impliedGrams(id, plantAltBaselineG))
        .reduce((a, b) => a < b ? a : b);
    final shipped = shippedGrams(actionId);
    expect(implied, greaterThan(0), reason: actionId);
    expect(
      shipped,
      lessThanOrEqualTo(implied),
      reason:
          '$actionId shipped $shipped vs binding (smallest) '
          'dataset-implied ${implied.toStringAsFixed(0)} across $itemIds',
    );
    // Not so conservative it stops meaning anything.
    expect(shipped / implied, greaterThan(0.5), reason: actionId);
  }

  test('skip_high_impact_food binds to lamb, not beef', () {
    // Covers beef and lamb. Lamb 3972 - 200 = 3772 -> ships 3700.
    // Beef implies 6836; crediting that for a lamb skip would
    // overstate by 80%.
    expectAtOrBelowTierMinimum('skip_high_impact_food', ['beef', 'lamb']);
  });

  test('skip_medium_impact_food binds to chicken, not pork', () {
    // Covers chicken and pork. Chicken 987 - 200 = 787 -> ships
    // 780. Pork implies 1031.
    expectAtOrBelowTierMinimum('skip_medium_impact_food', ['chicken', 'pork']);
  });

  test('the retired per-item meat actions stay unshipped', () {
    // beef/chicken/pork merged into the two tier actions above;
    // pork moved to research_only_records, which the seeder does
    // not read. A silent revert would double-count the swap.
    for (final retired in const [
      'meatless_meal_beef',
      'meatless_meal_chicken',
      'meatless_meal_pork',
    ]) {
      expect(actionById.containsKey(retired), isFalse, reason: retired);
    }
  });

  test('plant_milk stays honestly conservative', () {
    // The action covers plant milks generically, so the binding
    // conservative bound is the SMALLEST implied delta across the
    // shipped plant milks: soy (543 g), not oat (562 g). Shipped
    // 460 g must sit at or below it.
    final impliedOat =
        (factorById['milk_dairy']! - factorById['oat_milk']!) * 0.25 * 1000;
    final impliedSoy =
        (factorById['milk_dairy']! - factorById['soy_milk']!) * 0.25 * 1000;
    final binding = impliedSoy < impliedOat ? impliedSoy : impliedOat;
    final shipped = shippedGrams('plant_milk');
    expect(shipped, greaterThan(0));
    expect(
      shipped,
      lessThanOrEqualTo(binding),
      reason:
          'shipped $shipped vs binding dataset-implied bound '
          '${binding.toStringAsFixed(0)}',
    );
  });

  test('decision pin: plant_milk ships exactly 460 g', () {
    // Deliberately conservative value, kept unchanged through the
    // 2026-07 correction pass; a silent change here is a points-
    // economy change.
    expect(shippedGrams('plant_milk'), 460);
  });

  test('skip_fish derivation stays consistent with the dataset', () {
    // skip_fish is a seeder-only library action (not in this DB), so
    // this pins the arithmetic its co2Grams is derived from: a white
    // fish fillet minus the 200 g beans baseline (2026-07-23 owner
    // call). Re-based on white_fish 2026-08-08 -- the seafood source
    // decision retired the assembled fish_wild 9.5 this used to read,
    // and the reward fell from 1200 g to 560 g with it. If white_fish
    // drifts out of the [560, 660) band the seeder value must move too.
    final derived = 0.15 * factorById['white_fish']! * 1000 - plantAltBaselineG;
    expect(derived, greaterThanOrEqualTo(560));
    expect(derived, lessThan(660));
    // The retired value must not come back as a silent revert.
    expect(factorById.containsKey('fish_wild'), isFalse);
  });
}
