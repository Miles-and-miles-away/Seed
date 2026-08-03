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
  // Standardized plant-alternative baseline (section 7, closed
  // 2026-07-20): every meatless action deducts 200 g CO2e per
  // 100 g serving (beans/lentils, OWID "Other Pulses" 1.79 kg/kg
  // = 179 g, rounded up to 200 g). Before standardization the
  // beef action used 200 g but chicken/pork used a 100 g peas
  // baseline.
  const plantAltBaselineG = 200.0;
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
    // Guard: a non-positive implied delta would make the relative
    // tolerance below unfalsifiable.
    expect(implied, greaterThan(0), reason: actionId);
    expect(
      (shipped - implied).abs() / implied,
      lessThanOrEqualTo(tolerance),
      reason:
          '$actionId shipped $shipped vs dataset-implied '
          '${implied.toStringAsFixed(0)}',
    );
  }

  test('meatless_meal_beef matches the dataset within 10%', () {
    // 7036 - 200 = 6836 -> ships 6800 (savings always round
    // DOWN). Tracks the production-weighted beef value 70.3608
    // (D6); the legacy 9700 encoded the beef-herd-only 99.48.
    expectWithinTolerance(
      'meatless_meal_beef',
      impliedGrams('beef', plantAltBaselineG),
    );
  });

  test('meatless_meal_chicken matches the dataset within 10%', () {
    // 987 - 200 = 787 -> ships 780 (was 880 against the old
    // 100 g peas baseline).
    expectWithinTolerance(
      'meatless_meal_chicken',
      impliedGrams('chicken', plantAltBaselineG),
    );
  });

  test('meatless_meal_pork matches the dataset within 10%', () {
    // 1231 - 200 = 1031 -> ships 1000 (was 1100 against the old
    // 100 g peas baseline).
    expectWithinTolerance(
      'meatless_meal_pork',
      impliedGrams('pork', plantAltBaselineG),
    );
  });

  test('plant_milk_vs_dairy stays honestly conservative', () {
    // The action covers plant milks generically, so the binding
    // conservative bound is the SMALLEST implied delta across the
    // shipped plant milks: soy (543 g), not oat (562 g). Shipped
    // 460 g must sit at or below it.
    final impliedOat =
        (factorById['milk_dairy']! - factorById['oat_milk']!) * 0.25 * 1000;
    final impliedSoy =
        (factorById['milk_dairy']! - factorById['soy_milk']!) * 0.25 * 1000;
    final binding = impliedSoy < impliedOat ? impliedSoy : impliedOat;
    final shipped = shippedGrams('plant_milk_vs_dairy');
    expect(shipped, greaterThan(0));
    expect(
      shipped,
      lessThanOrEqualTo(binding),
      reason:
          'shipped $shipped vs binding dataset-implied bound '
          '${binding.toStringAsFixed(0)}',
    );
  });

  test('decision pin: plant_milk_vs_dairy ships exactly 460 g', () {
    // Deliberately conservative value, kept unchanged through the
    // 2026-07 correction pass; a silent change here is a points-
    // economy change.
    expect(shippedGrams('plant_milk_vs_dairy'), 460);
  });

  test('skip_fish derivation stays consistent with the dataset', () {
    // skip_fish is a seeder-only library action (not in this DB), so
    // this pins the arithmetic its co2Grams is derived from: average
    // white/wild fish, fish_wild x 150 g fillet minus the 200 g beans
    // baseline (2026-07-23 owner call). The seeder ships 1200 g
    // (1225 rounded down to two significant figures); if fish_wild
    // drifts out of the [1200, 1300) band the seeder value must move
    // too, and this test flags it.
    final derived = 0.15 * factorById['fish_wild']! * 1000 - plantAltBaselineG;
    expect(derived, greaterThanOrEqualTo(1200));
    expect(derived, lessThan(1300));
  });
}
