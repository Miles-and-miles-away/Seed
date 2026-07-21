import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Sanity invariants from Plan/RESEARCH_FOOD.md section 6.
///
/// These are DATA PINS for the shipped mean-with-losses values,
/// not truth claims: several orderings flip under the median
/// statistic or a boundary change, so every pin must be
/// re-derived at the next data pass rather than assumed to
/// survive it. The never-pin clusters (section 6) are
/// intentionally NOT tested: palm vs olive (boundary-dependent),
/// fish vs pork, prawns vs cheese, coffee vs cheese/prawns and
/// chocolate vs lamb/cheese (all flip under medians), oats vs
/// tomatoes, the ~1.8 cluster (oats/beans/wine), berries vs
/// bread/pasta, eggs vs rice, butter vs pork, soy vs oat milk,
/// soy milk vs peas (exact tie), the ~3.2 cluster
/// (milk/tofu/sugar), the ~0.43 cluster (nuts/root veg/apples/
/// potatoes), the ~0.5 brassica/onion cluster, and the 2026-07-19
/// additions' ties: fish_wild vs chicken (9.50 vs 9.87, 3.9%),
/// plant_based_meat vs eggs (4.5 vs 4.67, 3.8%) and vs rice
/// (4.5 vs 4.45, 1.1%), tea vs chicken (9.0 vs 9.87) and vs
/// fish_wild (9.0 vs 9.50), small_fish vs eggs (5.5 vs 4.67,
/// 17.8%) and vs plant_based_meat (5.5 vs 4.5, adjacent), and
/// beans_canned (drained) vs beans_lentils (dry) (1.7 vs 1.79 --
/// different bases, never compare).
void main() {
  late Map<String, Map<String, dynamic>> byId;

  setUpAll(() {
    final raw = File('data/app/food_items.json').readAsStringSync();
    final root = json.decode(raw) as Map<String, dynamic>;
    final items = (root['items'] as List<dynamic>).cast<Map<String, dynamic>>();
    byId = {for (final item in items) item['id'] as String: item};
  });

  double factor(String id) => (byId[id]!['kg_co2e_per_kg'] as num).toDouble();

  List<String> idsInGroups(Set<String> groups) => byId.values
      .where((i) => groups.contains(i['group'] as String))
      .map((i) => i['id'] as String)
      .toList();

  test('1. beef (beef herd) is the dataset maximum', () {
    // 99.48; margin vs #2 chocolate 46.65 = +113%.
    for (final id in byId.keys) {
      if (id == 'beef_beef_herd') continue;
      expect(factor('beef_beef_herd'), greaterThan(factor(id)), reason: id);
    }
  });

  test('2. meat chain: beef > lamb > pork > chicken > tofu > potatoes', () {
    // Thinnest link is pork > chicken at +24.7% -- it thins to
    // +18% (fragile) under a median revintage, so re-derive this
    // pin at the next data pass instead of assuming it survives.
    const chain = [
      'beef_beef_herd',
      'lamb',
      'pork',
      'chicken',
      'tofu',
      'potatoes',
    ];
    for (var i = 0; i < chain.length - 1; i++) {
      expect(
        factor(chain[i]),
        greaterThan(factor(chain[i + 1])),
        reason: '${chain[i]} > ${chain[i + 1]}',
      );
    }
  });

  test('3. herd ratio stays inside the 2.5-3.5 band', () {
    // Actual 2.99. Never pin a strict "> 3x": the plan's original
    // claim is false under both statistics (2.99 mean, 2.86
    // median) -- a knife-edge failure by 0.4% if pinned as
    // written.
    final ratio = factor('beef_beef_herd') / factor('beef_dairy_herd');
    expect(ratio, greaterThan(2.5));
    expect(ratio, lessThan(3.5));
  });

  test('4. cheese > chicken', () {
    // 23.88 > 9.87, +142%.
    expect(factor('cheese'), greaterThan(factor('chicken')));
  });

  test('5. plant milks at double strength still beat dairy milk', () {
    // max(0.98, 0.90) x 2 = 1.96 < 3.15 (+61% margin) -- stronger
    // than the plain ordering and safe under both statistics.
    final worstPlantMilk = [
      factor('soy_milk'),
      factor('oat_milk'),
    ].reduce((a, b) => a > b ? a : b);
    expect(worstPlantMilk * 2, lessThan(factor('milk_dairy')));
  });

  test('6. rice > every other staple', () {
    // 4.45 vs oats 1.84 (+142%, margin improved by decision D3);
    // bread/pasta 1.57; potatoes 0.46.
    for (final id in idsInGroups(const {'staples'})) {
      if (id == 'rice') continue;
      expect(factor('rice'), greaterThan(factor(id)), reason: id);
    }
  });

  test('7. chicken > every staple, vegetable, fruit, plant protein', () {
    // Cheapest meat 9.87 vs the group maximum rice 4.45, +122%.
    final groups = const {'staples', 'vegetables', 'fruit', 'plant_protein'};
    for (final id in idsInGroups(groups)) {
      expect(factor('chicken'), greaterThan(factor(id)), reason: id);
    }
  });

  test('8. beer < wine per litre', () {
    // 1.2 < 1.79, +49%. Per SERVING the ordering reverses (330 ml
    // can 0.40 kg > 150 ml glass 0.27 kg) -- copy must name the
    // serving, not the liquid.
    expect(factor('beer'), lessThan(factor('wine')));
  });

  test('9. prawns (farmed) > fish (farmed)', () {
    // 26.87 > 13.63, +97%; medians 11.8 > 5.1 -- stable across
    // statistics.
    expect(factor('prawns_farmed'), greaterThan(factor('fish_farmed')));
  });

  test('10. coffee per-cup guardrail stays under 0.5 kg', () {
    // Pins the 100x-error protection, not an ordering: the cup
    // preset (10 g dry grounds) x 28.53/kg = 0.2853 kg CO2e. A
    // 250 "ml" typo in the grams field would compute 7.13 kg.
    final servings = (byId['coffee']!['servings'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final cup = servings.firstWhere((s) => s['id'] == 'cup_10g_grounds');
    final grams = (cup['grams'] as num).toDouble();
    expect(grams * factor('coffee') / 1000, lessThan(0.5));
  });

  test('11. decision pins: D1/D2/D3 values ship exactly', () {
    // Owner decisions 2026-07-18/19 (PDR_FOOD_CALCULATOR.md
    // section 2). None of these is reachable by the ordering pins
    // above: reverting chocolate to the median 18.7, oats to the
    // raw anchor 2.48, or beer to a packaged-LCA figure would
    // otherwise pass the whole suite silently.
    expect(factor('dark_chocolate'), 46.65); // D1: mean, not 18.7
    expect(factor('oats'), 1.84); // D3: (2.48 + 1.20) / 2
    expect(factor('beer'), 1.2); // D2: P&N anchor
  });

  test('12. farmed fish > wild fish > small oily fish', () {
    // 13.63 > 9.50 (+43%) > 5.5 (+73%). Source-supported: wild
    // fisheries burn fuel but carry no feed or land-use-change
    // stages, and small pelagics are the most fuel-efficient
    // fisheries (purse seine 71 L/tonne).
    expect(factor('fish_farmed'), greaterThan(factor('fish_wild')));
    expect(factor('fish_wild'), greaterThan(factor('small_fish')));
  });

  test('13. plant-based meat sits between tofu and chicken', () {
    // 3.16 < 4.5 (+42%) < 9.87 (+119%). The eggs tie (4.67, 3.8%)
    // is on the never-pin list above.
    expect(factor('plant_based_meat'), greaterThan(factor('tofu')));
    expect(factor('plant_based_meat'), lessThan(factor('chicken')));
  });

  test('14. tea < coffee per kg, and per-cup stays under 50 g', () {
    // 9.0 < 28.53 (+217%). Per-cup guardrail mirrors coffee's:
    // the 2 g / 3 g dry-leaf presets give 18 / 27 g CO2e; a user
    // typing 250 "ml" into the grams field would compute 2.25 kg.
    expect(factor('tea'), lessThan(factor('coffee')));
    final servings = (byId['tea']!['servings'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    expect(servings, isNotEmpty);
    for (final preset in servings) {
      final grams = (preset['grams'] as num).toDouble();
      expect(
        grams * factor('tea') / 1000,
        lessThan(0.05),
        reason: preset['id'] as String,
      );
    }
  });

  test('15. assembled-value pins: 2026-07-19 additions ship exactly', () {
    // Same rationale as the D1-D3 pins: none of these non-P&N
    // assembled values is reachable by the ordering pins above,
    // so a silent revert to a narrower-boundary source value
    // (e.g. Gephart 7.63, Heller & Keoleian 3.4, or the Kenya tea
    // 2.0) would otherwise pass the whole suite.
    expect(factor('fish_wild'), 9.5);
    expect(factor('plant_based_meat'), 4.5);
    expect(factor('tea'), 9.0);
    expect(factor('small_fish'), 5.5); // 2026-07-20 addition
    expect(factor('beans_canned'), 1.7); // 2026-07-20, drained basis
  });
}
