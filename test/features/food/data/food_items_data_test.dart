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
  const itemCount = 42;
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
      const expected = {
        'meat': 4,
        'seafood': 5,
        'dairy_eggs': 4,
        'plant_protein': 5,
        'staples': 5,
        'vegetables': 5,
        'fruit': 4,
        'drinks': 6,
        'treats': 2,
        'oils': 2,
      };
      final counts = <String, int>{};
      for (final item in items) {
        counts.update(item['group'] as String, (c) => c + 1, ifAbsent: () => 1);
      }
      expect(counts, expected);
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
      expect(metadata['version'], 1);
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
