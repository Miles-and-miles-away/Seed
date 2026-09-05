import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/mascot/data/mascot_species_loader.dart';
import 'package:seed_app/features/mascot/data/models/egg_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/features/mascot/data/repositories/mascot_repository.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MascotRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = MascotRepository(firestore: fakeFirestore);
  });

  /// Helper to create a user doc with mascots array.
  Future<void> createUserWithMascots(
    String userId,
    List<Map<String, dynamic>> mascots, {
    String? activeMascotId,
    Map<String, dynamic>? extra,
  }) async {
    await fakeFirestore.collection('users').doc(userId).set({
      'uid': userId,
      'email': 'test@example.com',
      if (mascots.isNotEmpty) 'mascots': mascots,
      'activeMascotId': ?activeMascotId,
      ...?extra,
    });
  }

  Map<String, dynamic> mascotJson({
    required String id,
    String speciesId = 'seed',
    String name = 'Sprouty',
    int mascotPoints = 0,
    int mascotLevel = 1,
    bool isFullyEvolved = false,
    int lastSeenStage = 1,
  }) => {
    'id': id,
    'speciesId': speciesId,
    'name': name,
    'mascotPoints': mascotPoints,
    'mascotLevel': mascotLevel,
    'isFullyEvolved': isFullyEvolved,
    'equippedItems': <String>[],
    'lastSeenStage': lastSeenStage,
  };

  group('MascotRepository', () {
    group('setActiveMascot', () {
      test('updates activeMascotId', () async {
        await createUserWithMascots('user1', [
          mascotJson(id: 'm1'),
          mascotJson(id: 'm2'),
        ], activeMascotId: 'm1');

        await repository.setActiveMascot('user1', 'm2');

        final doc = await fakeFirestore.collection('users').doc('user1').get();
        expect(doc.data()!['activeMascotId'], 'm2');
      });
    });

    group('updateMascotName', () {
      test('renames mascot in array', () async {
        await createUserWithMascots('user1', [
          mascotJson(id: 'm1', name: 'OldName'),
          mascotJson(id: 'm2', name: 'Other'),
        ]);

        await repository.updateMascotName('user1', 'm1', 'NewName');

        final doc = await fakeFirestore.collection('users').doc('user1').get();
        final mascots = doc.data()!['mascots'] as List<dynamic>;
        expect((mascots[0] as Map)['name'], 'NewName');
        // Other mascot unchanged
        expect((mascots[1] as Map)['name'], 'Other');
      });
    });

    group('updateLastSeenStage', () {
      test('updates stage for specific mascot', () async {
        await createUserWithMascots('user1', [mascotJson(id: 'm1')]);

        await repository.updateLastSeenStage('user1', 'm1', 3);

        final doc = await fakeFirestore.collection('users').doc('user1').get();
        final mascots = doc.data()!['mascots'] as List<dynamic>;
        expect((mascots[0] as Map)['lastSeenStage'], 3);
      });
    });

    group('createEgg', () {
      test('creates egg and clears pending flag', () async {
        await createUserWithMascots(
          'user1',
          [],
          extra: {'eggPendingDiscovery': true},
        );

        final egg = EggModel(receivedAt: DateTime(2024, 6, 15));
        await repository.createEgg('user1', egg);

        final doc = await fakeFirestore.collection('users').doc('user1').get();
        final data = doc.data()!;
        expect(data['egg'], isNotNull);
        expect(data['eggPendingDiscovery'], false);
      });
    });

    group('selectMascot', () {
      test('creates mascot array with one mascot', () async {
        await createUserWithMascots('user1', []);

        await repository.selectMascot(
          userId: 'user1',
          speciesId: 'seed',
          name: 'MyPlant',
        );

        final doc = await fakeFirestore.collection('users').doc('user1').get();
        final data = doc.data()!;
        final mascots = data['mascots'] as List<dynamic>;
        expect(mascots, hasLength(1));
        final first = mascots[0] as Map<String, dynamic>;
        expect(first['speciesId'], 'seed');
        expect(first['name'], 'MyPlant');
        expect(first['lastSeenStage'], 1);
        expect(first['id'], isNotNull);
        expect(data['activeMascotId'], first['id']);
      });
    });
  });

  group('getSpeciesById', () {
    final testSpecies = [
      MascotSpeciesModel(
        id: 'seed',
        nameEn: 'Seed',
        nameJa: 'シード',
        descriptionEn: 'A seed',
        descriptionJa: '種',
        evolutionStages: [],
      ),
    ];

    test('returns species by id', () {
      final species = getSpeciesById('seed', testSpecies);

      expect(species, isNotNull);
      expect(species!.id, 'seed');
    });

    test('returns null for unknown id', () {
      final species = getSpeciesById('dragon', testSpecies);

      expect(species, isNull);
    });
  });
}
