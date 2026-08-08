import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Schema validation for data/app/food_items.json
/// (built from Plan/RESEARCH_FOOD.md sections 2-5).
///
/// No food feature module exists yet, so the dataset is read
/// straight from disk (`flutter test` runs with the package root
/// as cwd) instead of through a loader.
void main() {
  const itemCount = 166;
  const validGroups = {
    'meat',
    'seafood',
    'dairy_eggs',
    'plant_protein',
    'staples',
    'vegetables',
    'fruit',
    'drinks',
    'treats',
    'oils',
    'nuts_seeds',
    'condiments',
    'prepared',
  };

  late Map<String, dynamic> root;
  late List<Map<String, dynamic>> items;

  setUpAll(() {
    final raw = File('data/app/food_items.json').readAsStringSync();
    root = json.decode(raw) as Map<String, dynamic>;
    items = (root['items'] as List<dynamic>).cast<Map<String, dynamic>>();
  });

  group('food_items.json dataset validation', () {
    test('contains exactly $itemCount items', () {
      expect(items.length, itemCount);
    });

    test('ids are unique snake_case', () {
      final ids = items.map((i) => i['id'] as String).toList();
      expect(ids.toSet().length, ids.length);
      for (final id in ids) {
        expect(RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(id), isTrue, reason: id);
      }
    });

    test('groups are from the known set', () {
      for (final item in items) {
        final group = item['group'] as String;
        expect(
          validGroups.contains(group),
          isTrue,
          reason: 'Invalid group "$group" for ${item['id']}',
        );
      }
    });

    test('all three locale names are present', () {
      for (final item in items) {
        final id = item['id'] as String;
        expect(item['name_en'] as String, isNotEmpty, reason: id);
        expect(item['name_ja'] as String, isNotEmpty, reason: id);
        expect(item['name_es'] as String, isNotEmpty, reason: id);
      }
    });

    test('factors are strictly positive', () {
      for (final item in items) {
        expect(
          (item['kg_co2e_per_kg'] as num).toDouble(),
          greaterThan(0),
          reason: item['id'] as String,
        );
      }
    });

    test('every item has at least one complete source', () {
      for (final item in items) {
        final id = item['id'] as String;
        final sources = (item['sources'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
        expect(sources, isNotEmpty, reason: id);
        for (final source in sources) {
          expect(source['name'] as String, isNotEmpty, reason: id);
          expect(
            source['url'] as String,
            startsWith('https://'),
            reason: '$id: ${source['url']}',
          );
          expect(source['quote'] as String, isNotEmpty, reason: id);
          expect(source['accessed'] as String, isNotEmpty, reason: id);
        }
      }
    });

    test('servings have positive grams and all three locale names', () {
      for (final item in items) {
        final id = item['id'] as String;
        final servings = (item['servings'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
        // Every shipped item has researched presets; an empty list
        // would make this loop pass vacuously.
        expect(servings, isNotEmpty, reason: id);
        final presetIds = servings.map((p) => p['id'] as String).toList();
        expect(
          presetIds.toSet().length,
          presetIds.length,
          reason: '$id has duplicate preset ids',
        );
        for (final preset in servings) {
          expect(
            (preset['grams'] as num).toDouble(),
            greaterThan(0),
            reason: '$id/${preset['id']}',
          );
          expect(preset['name_en'] as String, isNotEmpty, reason: id);
          expect(preset['name_ja'] as String, isNotEmpty, reason: id);
          expect(preset['name_es'] as String, isNotEmpty, reason: id);
        }
      }
    });

    test('every item documents its calculation', () {
      for (final item in items) {
        expect(
          item['calculation_notes'] as String,
          isNotEmpty,
          reason: item['id'] as String,
        );
      }
    });

    test('group sizes match the researched dataset', () {
      // Data pin: catches silent group reassignment, which no
      // other test observes (RESEARCH_FOOD.md section 4).
      // `peas` moved plant_protein -> vegetables on 2026-08-02 with
      // its anchor correction: P&N's Peas row is dry split peas,
      // and P&N files green peas under Vegetables.
      // `nuts` split into tree_nuts + peanuts on 2026-08-08: peanuts
      // were aliased onto the tree-nut row at 0.43, 7.5x below their
      // own P&N Groundnuts row.
      // v2 (2026-08-08) widened the dataset to 166 items and retired
      // five umbrella rows into species rows (root_vegetables,
      // cabbage_broccoli, onions_leeks, citrus, berries) plus
      // fish_wild, which the seafood source decision replaced with
      // white_fish and tuna.
      const expected = {
        'meat': 8,
        'seafood': 11,
        'dairy_eggs': 9,
        'plant_protein': 12,
        'nuts_seeds': 2,
        'staples': 15,
        'vegetables': 43,
        'fruit': 21,
        'drinks': 18,
        'treats': 8,
        'oils': 6,
        'condiments': 9,
        'prepared': 4,
      };
      final counts = <String, int>{};
      for (final item in items) {
        counts.update(item['group'] as String, (c) => c + 1, ifAbsent: () => 1);
      }
      expect(counts, expected);
    });

    test('every row carries the v2 metadata keys', () {
      // The four v1 rows carried forward through the v2 merge arrived
      // without these, and two of them are exactly the rows that need
      // `weight_basis`: beans/lentils is a DRY factor and canned beans
      // a DRAINED one. Absent the key the picker and editor show no
      // basis label, which is the ~2.5x error class those labels exist
      // to prevent. Model defaults would have hidden it.
      const required = {
        'category_anchor',
        'source_tier',
        'statistic',
        'weight_basis',
        'entry_mode',
        'default_serving_id',
        'comparable',
        'confidence',
      };
      const bases = {'as_purchased', 'dry', 'drained', 'edible', 'concentrate'};
      for (final item in items) {
        final id = item['id'] as String;
        for (final key in required) {
          expect(item.containsKey(key), isTrue, reason: '$id lacks $key');
        }
        expect(bases, contains(item['weight_basis'] as String), reason: id);
        expect(
          const ['grams', 'preset_only'],
          contains(item['entry_mode'] as String),
          reason: id,
        );
        // A preset-only item with no resolvable default would open on
        // the raw grams field it is meant to avoid.
        final presetIds = (item['servings'] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .map((p) => p['id'] as String);
        expect(presetIds, contains(item['default_serving_id']), reason: id);
      }
    });

    test('peanuts are never aliased onto the tree-nut row', () {
      // The tree-nut row is 0.43 only because of a land-use-change
      // credit for orchards; P&N put groundnuts on their own row at
      // 3.23. A peanut alias here routes peanuts 7.5x too low, which
      // is what shipped until 2026-08-08 (RESEARCH_FOOD.md 3.3).
      final tree = items.firstWhere((i) => i['id'] == 'tree_nuts');
      final aliases = [
        ...(tree['search_terms_en'] as List<dynamic>),
        ...(tree['search_terms_ja'] as List<dynamic>),
        ...(tree['search_terms_es'] as List<dynamic>),
      ].map((t) => (t as String).toLowerCase());
      for (final banned in ['peanut', 'groundnut', 'cacahu', 'maní', '落花生']) {
        expect(
          aliases.any((a) => a.contains(banned)),
          isFalse,
          reason: 'tree_nuts must not answer to "$banned"',
        );
      }
      final peanuts = items.firstWhere((i) => i['id'] == 'peanuts');
      expect((peanuts['kg_co2e_per_kg'] as num).toDouble(), 3.23);
    });

    test('beans never carries the famous peas quote', () {
      // The OWID "peas emit just 1 kilogram" sentence belongs to
      // Peas (0.98); attached to Beans & lentils (1.79) it would
      // overstate the item by ~80% (RESEARCH_FOOD.md section 8).
      final beans = items.firstWhere((i) => i['id'] == 'beans_lentils');
      final text = json.encode(beans).toLowerCase();
      expect(text.contains('peas emit just 1 kilogram'), isFalse);
    });
  });

  group('food_items.json metadata', () {
    test('carries the scope contract for the methodology sheet', () {
      final metadata = root['metadata'] as Map<String, dynamic>;
      expect(metadata['version'], 2);
      final scope = metadata['scope'] as String;
      // The scope must record the statistic (means), the losses
      // basis, and the do-not-sum warning against the transport
      // calculator's operational-only boundary (RESEARCH_FOOD.md
      // section 2).
      expect(scope, contains('MEANS'));
      expect(scope, contains('losses'));
      expect(scope, contains('land-use change'));
      expect(scope, contains('transport calculator'));
      expect(metadata['primary_source'] as String, contains('Poore'));
      expect(metadata['basis'] as String, isNotEmpty);
      // Table-row/CSV-row citation convention must stay declared;
      // several sources depend on it to be honest.
      expect(metadata['citation_note'] as String, isNotEmpty);
    });
  });
}
