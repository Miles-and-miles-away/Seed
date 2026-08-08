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
/// (milk/tofu/sugar/peanuts), the ~0.43 cluster (tree nuts/root
/// veg/apples/potatoes), tree nuts vs peanuts (0.43 vs 3.23 --
/// the 7.5x gap is P&N's orchard land-use-change credit, and the
/// ordering inverts to peanuts-below once the credit is stripped), the ~0.5 brassica/onion cluster, and the 2026-07-19
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

  String basis(String id) =>
      (byId[id]!['weight_basis'] as String?) ?? 'as_purchased';

  List<String> idsInGroups(Set<String> groups) => byId.values
      .where((i) => groups.contains(i['group'] as String))
      .map((i) => i['id'] as String)
      .toList();

  test('1. beef is the dataset maximum', () {
    // 70.3608 (D6, production-weighted). The margin narrowed sharply
    // in v2: #2 is now instant coffee at 62.33 (+12.9%), a per-kg
    // figure for a powder used 1.8 g at a time. Re-derive before
    // adding any item above 60.
    for (final id in byId.keys) {
      if (id == 'beef') continue;
      expect(factor('beef'), greaterThan(factor(id)), reason: id);
    }
  });

  test('2. meat chain: beef > lamb > pork > chicken > tofu > potatoes', () {
    // Thinnest link is pork > chicken at +24.7% -- it thins to
    // +18% (fragile) under a median revintage, so re-derive this
    // pin at the next data pass instead of assuming it survives.
    const chain = ['beef', 'lamb', 'pork', 'chicken', 'tofu', 'potatoes'];
    for (var i = 0; i < chain.length - 1; i++) {
      expect(
        factor(chain[i]),
        greaterThan(factor(chain[i + 1])),
        reason: '${chain[i]} > ${chain[i + 1]}',
      );
    }
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

  test('7. chicken > every as-purchased staple, veg, fruit, plant protein', () {
    // Restricted to as-purchased weights in v2. Dried and concentrated
    // plant products legitimately exceed chicken per kg because the
    // water is gone -- dried shiitake 18.62 and tomato paste 11.14 both
    // clear it -- so comparing them against a fresh-weight meat per kg
    // is the canned-vs-dry-beans error, not a broken ordering.
    final groups = const {'staples', 'vegetables', 'fruit', 'plant_protein'};
    for (final id in idsInGroups(groups)) {
      if (basis(id) != 'as_purchased') continue;
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
    // Owner decisions 2026-07-18/19 (rationale in
    // RESEARCH_FOOD.md). None of these is reachable by the ordering pins
    // above: reverting chocolate to the median 18.7, oats to the
    // raw anchor 2.48, or beer to a packaged-LCA figure would
    // otherwise pass the whole suite silently.
    expect(factor('dark_chocolate'), 46.65); // D1: mean, not 18.7
    expect(factor('oats'), 1.84); // D3: (2.48 + 1.20) / 2
    expect(factor('beer'), 1.2); // D2: P&N anchor
  });

  test('11b. the tree-nut / peanut split ships exactly', () {
    // Both are P&N rows, and nothing in the ordering pins would
    // catch a regression: peanuts shipped aliased onto the 0.43
    // tree-nut row until 2026-08-08, 7.5x below their own
    // Groundnuts row. Pin both values and the separation.
    expect(factor('tree_nuts'), 0.43); // P&N "Nuts", credit incl.
    expect(factor('peanuts'), 3.23); // P&N "Groundnuts"
    expect(factor('peanuts'), greaterThan(factor('tree_nuts')));
  });

  test('12. the tier-2 seafood ordering holds within its own source', () {
    // fish_wild 9.5 was retired in v2: it was assembled by a
    // harmonisation recipe the seafood review found unsound, and it
    // split into white_fish and tuna at Gephart's own boundary.
    // These five are all tier-2 and outside each other's tie groups,
    // so the ordering is a like-for-like claim. squid and salmon are
    // deliberately excluded -- each ties a member below.
    const order = ['crab_lobster', 'tuna', 'small_fish', 'bivalves', 'seaweed'];
    for (var i = 0; i < order.length - 1; i++) {
      expect(
        factor(order[i]),
        greaterThan(factor(order[i + 1])),
        reason: '${order[i]} > ${order[i + 1]}',
      );
    }
    expect(byId.containsKey('fish_wild'), isFalse);
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
    expect(factor('plant_based_meat'), 4.5);
    expect(factor('tea'), 9.0);
    expect(factor('beans_canned'), 1.7); // drained basis
    // v2 seafood: Gephart rows ship at their published precision, and
    // the two prawn values are the ones the source decision turned on.
    // A silent revert to the retired recipe's 9.5 / 5.5, or to
    // Gephart's bare farmed-shrimp 9.43, must fail here.
    expect(factor('white_fish'), 5.1250386);
    expect(factor('tuna'), 7.6290536);
    expect(factor('small_fish'), 3.8779404);
    expect(factor('prawns_farmed'), 26.87);
    expect(factor('prawns_wild'), 34.08);
  });
  test('16. every item carries English search aliases', () {
    // Umbrella items are unfindable without them: nobody searches
    // "Root vegetables", they search "carrots". A new item shipping
    // with an empty list is silently unreachable from the picker.
    for (final item in byId.values) {
      final terms = item['search_terms_en'] as List<dynamic>? ?? const [];
      expect(terms, isNotEmpty, reason: '${item['id']} has no search_terms_en');
      // An alias repeating the item's own name buys nothing -- the
      // name is already matched, and ahead of aliases.
      expect(
        terms.map((t) => (t as String).toLowerCase()),
        isNot(contains((item['name_en'] as String).toLowerCase())),
        reason: '${item['id']} aliases its own name',
      );
    }
  });

  test('17. no imperial units in user-facing serving names', () {
    // Display copy is metric everywhere (grams and millilitres). The
    // imperial that remains in calculation_notes is load-bearing
    // provenance: the USDA and CarbonCloud sources define their
    // portions in oz and tbsp, and dropping those makes the
    // derivations impossible to check against the source.
    final imperial = RegExp(
      r'\b(oz|ounces?|lbs?|pounds?|pints?|cups?|tbsp|tsp)\b',
      caseSensitive: false,
    );
    for (final item in byId.values) {
      for (final serving in (item['servings'] as List<dynamic>? ?? const [])) {
        final preset = serving as Map<String, dynamic>;
        for (final field in ['name_en', 'name_ja', 'name_es']) {
          final name = preset[field] as String? ?? '';
          expect(
            imperial.hasMatch(name),
            isFalse,
            reason: '${item['id']}/${preset['id']} $field = "$name"',
          );
        }
      }
    }
  });
  test('18. wild prawns sit above farmed, never below', () {
    // The counterintuitive part of the 2026-08-02 research pass, and
    // the whole reason the value is ratio-scaled rather than assembled
    // additively like fish_wild: Gephart 2021 measures both at one
    // boundary and puts wild ABOVE farmed (11.96 vs 9.43), because
    // trawling for prawns is exceptionally fuel-intensive. The
    // additive recipe would have shipped 18.60 and inverted this.
    expect(factor('prawns_wild'), greaterThan(factor('prawns_farmed')));
    expect(
      factor('prawns_wild') / factor('prawns_farmed'),
      closeTo(11.956739 / 9.428016, 0.01),
      reason: 'wild/farmed must track the Gephart like-for-like ratio',
    );
    expect(factor('prawns_wild'), 34.08); // assembled-value pin
  });

  test('19. beef stays the dataset maximum after the prawn addition', () {
    // 34.08 lands 4th, above coffee; only beef, dark chocolate and
    // lamb sit higher. A silent jump past beef would mean the ratio
    // was applied to the wrong anchor.
    final maxFactor = byId.values
        .map((i) => (i['kg_co2e_per_kg'] as num).toDouble())
        .reduce((a, b) => a > b ? a : b);
    expect(maxFactor, factor('beef'));
    expect(factor('prawns_wild'), lessThan(factor('lamb')));
  });
}
