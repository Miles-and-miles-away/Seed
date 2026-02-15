import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/mascot/data/mascot_species_data.dart';
import 'package:seed_app/features/mascot/data/models/egg_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
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
    await fakeFirestore
        .collection('users')
        .doc(userId)
        .set({
      'uid': userId,
      'email': 'test@example.com',
      if (mascots.isNotEmpty) 'mascots': mascots,
      if (activeMascotId != null)
        'activeMascotId': activeMascotId,
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
  }) =>
      {
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
    group('watchAllMascots', () {
      test('emits empty list when no mascots', () async {
        await createUserWithMascots('user1', []);

        final stream = repository.watchAllMascots('user1');

        await expectLater(stream, emits(isEmpty));
      });

      test('emits mascot list', () async {
        await createUserWithMascots('user1', [
          mascotJson(id: 'm1', name: 'Leafy'),
          mascotJson(id: 'm2', name: 'Mossy'),
        ]);

        final stream = repository.watchAllMascots('user1');

        await expectLater(
          stream,
          emits(
            predicate<List<MascotModel>>(
              (list) =>
                  list.length == 2 &&
                  list[0].id == 'm1' &&
                  list[1].id == 'm2',
            ),
          ),
        );
      });
    });

    group('watchActiveMascot', () {
      test('emits null when no active mascot', () async {
        await createUserWithMascots('user1', []);

        final stream =
            repository.watchActiveMascot('user1');

        await expectLater(stream, emits(isNull));
      });

      test('emits active mascot', () async {
        await createUserWithMascots(
          'user1',
          [
            mascotJson(id: 'm1', name: 'Leafy'),
            mascotJson(id: 'm2', name: 'Mossy'),
          ],
          activeMascotId: 'm2',
        );

        final stream =
            repository.watchActiveMascot('user1');

        await expectLater(
          stream,
          emits(
            predicate<MascotModel?>(
              (m) =>
                  m != null &&
                  m.id == 'm2' &&
                  m.name == 'Mossy',
            ),
          ),
        );
      });
    });

    group('watchEgg', () {
      test('emits null when no egg', () async {
        await createUserWithMascots('user1', []);

        final stream = repository.watchEgg('user1');

        await expectLater(stream, emits(isNull));
      });

      test('emits egg when present', () async {
        final now = DateTime(2024, 6, 15);
        await createUserWithMascots(
          'user1',
          [],
          extra: {
            'egg': {
              'receivedAt': now.toIso8601String(),
              'hatchingStreakDays': 5,
            },
          },
        );

        final stream = repository.watchEgg('user1');

        await expectLater(
          stream,
          emits(
            predicate<EggModel?>(
              (e) => e != null && e.hatchingStreakDays == 5,
            ),
          ),
        );
      });
    });

    group('watchHasMascot', () {
      test('emits false when no mascots', () async {
        await createUserWithMascots('user1', []);

        final stream =
            repository.watchHasMascot('user1');

        await expectLater(stream, emits(isFalse));
      });

      test('emits true when mascots exist', () async {
        await createUserWithMascots('user1', [
          mascotJson(id: 'm1'),
        ]);

        final stream =
            repository.watchHasMascot('user1');

        await expectLater(stream, emits(isTrue));
      });
    });

    group('addMascot', () {
      test('adds mascot and sets active', () async {
        await createUserWithMascots('user1', []);

        const mascot = MascotModel(
          id: 'm1',
          speciesId: 'seed',
          name: 'Sprouty',
        );
        await repository.addMascot('user1', mascot);

        final doc = await fakeFirestore
            .collection('users')
            .doc('user1')
            .get();
        final data = doc.data()!;
        final mascots =
            data['mascots'] as List<dynamic>;
        expect(mascots, hasLength(1));
        expect(
          (mascots[0] as Map)['speciesId'],
          'seed',
        );
        expect(data['activeMascotId'], 'm1');
      });
    });

    group('setActiveMascot', () {
      test('updates activeMascotId', () async {
        await createUserWithMascots(
          'user1',
          [
            mascotJson(id: 'm1'),
            mascotJson(id: 'm2'),
          ],
          activeMascotId: 'm1',
        );

        await repository.setActiveMascot('user1', 'm2');

        final doc = await fakeFirestore
            .collection('users')
            .doc('user1')
            .get();
        expect(doc.data()!['activeMascotId'], 'm2');
      });
    });

    group('updateMascotInArray', () {
      test('updates mascot by id', () async {
        await createUserWithMascots('user1', [
          mascotJson(id: 'm1', name: 'Old'),
        ]);

        const updated = MascotModel(
          id: 'm1',
          speciesId: 'seed',
          name: 'Updated',
          mascotPoints: 100,
        );
        await repository.updateMascotInArray(
          'user1',
          updated,
        );

        final doc = await fakeFirestore
            .collection('users')
            .doc('user1')
            .get();
        final mascots =
            doc.data()!['mascots'] as List<dynamic>;
        final first = mascots[0] as Map;
        expect(first['name'], 'Updated');
        expect(first['mascotPoints'], 100);
      });
    });

    group('updateMascotName', () {
      test('renames mascot in array', () async {
        await createUserWithMascots('user1', [
          mascotJson(id: 'm1', name: 'OldName'),
          mascotJson(id: 'm2', name: 'Other'),
        ]);

        await repository.updateMascotName(
          'user1',
          'm1',
          'NewName',
        );

        final doc = await fakeFirestore
            .collection('users')
            .doc('user1')
            .get();
        final mascots =
            doc.data()!['mascots'] as List<dynamic>;
        expect(
          (mascots[0] as Map)['name'],
          'NewName',
        );
        // Other mascot unchanged
        expect(
          (mascots[1] as Map)['name'],
          'Other',
        );
      });
    });

    group('updateLastSeenStage', () {
      test('updates stage for specific mascot', () async {
        await createUserWithMascots('user1', [
          mascotJson(id: 'm1'),
        ]);

        await repository.updateLastSeenStage(
          'user1',
          'm1',
          3,
        );

        final doc = await fakeFirestore
            .collection('users')
            .doc('user1')
            .get();
        final mascots =
            doc.data()!['mascots'] as List<dynamic>;
        expect(
          (mascots[0] as Map)['lastSeenStage'],
          3,
        );
      });
    });

    group('createEgg', () {
      test('creates egg and clears pending flag', () async {
        await createUserWithMascots(
          'user1',
          [],
          extra: {'eggPendingDiscovery': true},
        );

        final egg = EggModel(
          receivedAt: DateTime(2024, 6, 15),
        );
        await repository.createEgg('user1', egg);

        final doc = await fakeFirestore
            .collection('users')
            .doc('user1')
            .get();
        final data = doc.data()!;
        expect(data['egg'], isNotNull);
        expect(data['eggPendingDiscovery'], false);
      });
    });

    group('removeEgg', () {
      test('removes egg from user', () async {
        await createUserWithMascots(
          'user1',
          [],
          extra: {
            'egg': {
              'receivedAt':
                  DateTime(2024, 6, 15).toIso8601String(),
              'hatchingStreakDays': 10,
            },
          },
        );

        await repository.removeEgg('user1');

        final doc = await fakeFirestore
            .collection('users')
            .doc('user1')
            .get();
        expect(doc.data()!.containsKey('egg'), isFalse);
      });
    });

    group('clearEggPendingDiscovery', () {
      test('clears the flag', () async {
        await createUserWithMascots(
          'user1',
          [],
          extra: {'eggPendingDiscovery': true},
        );

        await repository.clearEggPendingDiscovery(
          'user1',
        );

        final doc = await fakeFirestore
            .collection('users')
            .doc('user1')
            .get();
        expect(
          doc.data()!['eggPendingDiscovery'],
          false,
        );
      });
    });

    group('selectMascot', () {
      test(
        'creates mascot array with one mascot',
        () async {
          await createUserWithMascots('user1', []);

          await repository.selectMascot(
            userId: 'user1',
            speciesId: 'seed',
            name: 'MyPlant',
          );

          final doc = await fakeFirestore
              .collection('users')
              .doc('user1')
              .get();
          final data = doc.data()!;
          final mascots =
              data['mascots'] as List<dynamic>;
          expect(mascots, hasLength(1));
          final first =
              mascots[0] as Map<String, dynamic>;
          expect(first['speciesId'], 'seed');
          expect(first['name'], 'MyPlant');
          expect(first['lastSeenStage'], 1);
          expect(first['id'], isNotNull);
          expect(data['activeMascotId'], first['id']);
        },
      );
    });

    group('getAllSpecies', () {
      test('returns default species list', () async {
        final species = await repository.getAllSpecies();

        expect(species, isNotEmpty);
        expect(species.first.id, 'seed');
      });
    });

    group('getSpecies', () {
      test('returns species by id', () async {
        final species =
            await repository.getSpecies('seed');

        expect(species, isNotNull);
        expect(species!.id, 'seed');
        expect(species.nameEn, 'Seed');
      });

      test('returns null for unknown species', () async {
        final species =
            await repository.getSpecies('unknown');

        expect(species, isNull);
      });
    });
  });

  group('getSpeciesById (static function)', () {
    test('returns seed species', () {
      final species = getSpeciesById('seed');

      expect(species, isNotNull);
      expect(species!.id, 'seed');
      expect(species.evolutionStages, hasLength(4));
    });

    test('returns null for unknown id', () {
      final species = getSpeciesById('dragon');

      expect(species, isNull);
    });
  });
}
