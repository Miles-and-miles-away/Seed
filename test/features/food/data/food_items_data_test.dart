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
  const itemCount = 37;
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
    });
  });
}
