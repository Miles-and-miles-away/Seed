import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/eco_dex/data/eco_dex_entries_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late EcoDexData data;

  setUpAll(() async {
    data = await loadEcoDexData();
  });

  group('loadEcoDexData', () {
    test('loads 9 categories', () {
      expect(data.categories.length, 9);
    });

    test('loads 108 entries', () {
      expect(data.entries.length, 108);
    });

    test('no duplicate entry IDs', () {
      final ids = data.entries.map((e) => e.id).toSet();
      expect(ids.length, data.entries.length);
    });

    test('no duplicate category IDs', () {
      final ids = data.categories.map((c) => c.id).toSet();
      expect(ids.length, data.categories.length);
    });

    test('every entry references a valid category', () {
      final validCats = data.categories.map((c) => c.id).toSet();
      for (final entry in data.entries) {
        expect(
          validCats.contains(entry.category),
          isTrue,
          reason: 'Entry ${entry.id} has invalid category '
              '"${entry.category}"',
        );
      }
    });

    test('all entries have non-empty nameEn', () {
      for (final entry in data.entries) {
        expect(
          entry.nameEn.isNotEmpty,
          isTrue,
          reason: 'Empty nameEn for ${entry.id}',
        );
      }
    });

    test('all entries have non-empty factEn', () {
      for (final entry in data.entries) {
        expect(
          entry.factEn.isNotEmpty,
          isTrue,
          reason: 'Empty factEn for ${entry.id}',
        );
      }
    });

    test('all entries have non-empty hintEn', () {
      for (final entry in data.entries) {
        expect(
          entry.hintEn.isNotEmpty,
          isTrue,
          reason: 'Empty hintEn for ${entry.id}',
        );
      }
    });

    test('all entries have non-empty iconName', () {
      for (final entry in data.entries) {
        expect(
          entry.iconName.isNotEmpty,
          isTrue,
          reason: 'Empty iconName for ${entry.id}',
        );
      }
    });

    test('all categories have non-empty nameEn', () {
      for (final cat in data.categories) {
        expect(
          cat.nameEn.isNotEmpty,
          isTrue,
          reason: 'Empty nameEn for category ${cat.id}',
        );
      }
    });

    test('every category has at least one entry', () {
      for (final cat in data.categories) {
        final count = data.entries.where((e) => e.category == cat.id).length;
        expect(
          count,
          greaterThan(0),
          reason: 'Category ${cat.id} has no entries',
        );
      }
    });
  });
}
