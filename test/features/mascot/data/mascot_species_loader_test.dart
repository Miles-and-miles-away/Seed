import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/mascot/data/mascot_species_loader.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loadMascotSpecies', () {
    test('loads species list from bundled asset', () async {
      final species = await loadMascotSpecies();

      expect(species, isNotEmpty);
      // Every species must at least have an id and name.
      for (final s in species) {
        expect(s.id, isNotEmpty);
        expect(s.nameEn, isNotEmpty);
        expect(s.evolutionStages, isNotEmpty);
      }
    });

    test('species IDs are unique', () async {
      final species = await loadMascotSpecies();

      final ids = species.map((s) => s.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('evolution stages within a species are sorted by level', () async {
      final species = await loadMascotSpecies();

      for (final s in species) {
        final levels = s.evolutionStages.map((e) => e.level).toList();
        final sorted = [...levels]..sort();
        expect(levels, sorted, reason: 'species ${s.id} stages not sorted');
      }
    });
  });

  group('getSpeciesById', () {
    const species = [
      MascotSpeciesModel(
        id: 'seed',
        nameEn: 'Seed',
        nameJa: 'シード',
        descriptionEn: '',
        descriptionJa: '',
        evolutionStages: [],
      ),
      MascotSpeciesModel(
        id: 'leaf',
        nameEn: 'Leaf',
        nameJa: 'リーフ',
        descriptionEn: '',
        descriptionJa: '',
        evolutionStages: [],
      ),
    ];

    test('returns the matching species', () {
      expect(getSpeciesById('leaf', species)!.id, 'leaf');
    });

    test('returns null for unknown id', () {
      expect(getSpeciesById('dragon', species), isNull);
    });

    test('returns null for empty list', () {
      expect(getSpeciesById('seed', const []), isNull);
    });
  });
}
