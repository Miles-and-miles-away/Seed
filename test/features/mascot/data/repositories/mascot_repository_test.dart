import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/mascot/data/mascot_species_data.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/repositories/mascot_repository.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MascotRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = MascotRepository(firestore: fakeFirestore);
  });

  group('MascotRepository', () {
    group('getUserMascot', () {
      test('returns null when user has no mascot', () async {
        // Create user without mascot
        await fakeFirestore.collection('users').doc('user123').set({
          'uid': 'user123',
          'email': 'test@example.com',
        });

        final mascot = await repository.getUserMascot('user123');

        expect(mascot, isNull);
      });

      test('returns mascot when user has one', () async {
        // Create user with mascot
        await fakeFirestore.collection('users').doc('user123').set({
          'uid': 'user123',
          'email': 'test@example.com',
          'mascot': {
            'speciesId': 'seed',
            'name': 'Sprouty',
            'equippedItems': <String>[],
            'lastSeenStage': 1,
          },
        });

        final mascot = await repository.getUserMascot('user123');

        expect(mascot, isNotNull);
        expect(mascot!.speciesId, 'seed');
        expect(mascot.name, 'Sprouty');
      });

      test('returns null when mascot field is null', () async {
        await fakeFirestore.collection('users').doc('user123').set({
          'uid': 'user123',
          'email': 'test@example.com',
          'mascot': null,
        });

        final mascot = await repository.getUserMascot('user123');

        expect(mascot, isNull);
      });
    });

    group('watchUserMascot', () {
      test('emits null when user has no mascot', () async {
        await fakeFirestore.collection('users').doc('user123').set({
          'uid': 'user123',
          'email': 'test@example.com',
        });

        final stream = repository.watchUserMascot('user123');

        await expectLater(stream, emits(isNull));
      });

      test('emits mascot when user has one', () async {
        await fakeFirestore.collection('users').doc('user123').set({
          'uid': 'user123',
          'email': 'test@example.com',
          'mascot': {
            'speciesId': 'seed',
            'name': 'Leafy',
            'equippedItems': <String>[],
            'lastSeenStage': 2,
          },
        });

        final stream = repository.watchUserMascot('user123');

        await expectLater(
          stream,
          emits(
            predicate<MascotModel?>(
              (m) => m != null && m.speciesId == 'seed' && m.name == 'Leafy',
            ),
          ),
        );
      });
    });

    group('setUserMascot', () {
      test('creates mascot field on user document', () async {
        // Create user without mascot
        await fakeFirestore.collection('users').doc('user123').set({
          'uid': 'user123',
          'email': 'test@example.com',
        });

        const mascot = MascotModel(
          speciesId: 'seed',
          name: 'Sprouty',
        );

        await repository.setUserMascot('user123', mascot);

        final doc = await fakeFirestore.collection('users').doc('user123').get();
        final data = doc.data()!;
        expect(data['mascot'], isNotNull);
        expect(data['mascot']['speciesId'], 'seed');
        expect(data['mascot']['name'], 'Sprouty');
      });
    });

    group('updateMascotName', () {
      test('updates only the mascot name', () async {
        await fakeFirestore.collection('users').doc('user123').set({
          'uid': 'user123',
          'email': 'test@example.com',
          'mascot': {
            'speciesId': 'seed',
            'name': 'OldName',
            'equippedItems': <String>[],
            'lastSeenStage': 1,
          },
        });

        await repository.updateMascotName('user123', 'NewName');

        final doc = await fakeFirestore.collection('users').doc('user123').get();
        expect(doc.data()!['mascot']['name'], 'NewName');
        expect(doc.data()!['mascot']['speciesId'], 'seed');
      });
    });

    group('updateLastSeenStage', () {
      test('updates the last seen stage', () async {
        await fakeFirestore.collection('users').doc('user123').set({
          'uid': 'user123',
          'email': 'test@example.com',
          'mascot': {
            'speciesId': 'seed',
            'name': 'Sprouty',
            'equippedItems': <String>[],
            'lastSeenStage': 1,
          },
        });

        await repository.updateLastSeenStage('user123', 2);

        final doc = await fakeFirestore.collection('users').doc('user123').get();
        expect(doc.data()!['mascot']['lastSeenStage'], 2);
      });
    });

    group('selectMascot', () {
      test('creates mascot with species and name', () async {
        await fakeFirestore.collection('users').doc('user123').set({
          'uid': 'user123',
          'email': 'test@example.com',
        });

        await repository.selectMascot(
          userId: 'user123',
          speciesId: 'seed',
          name: 'MyPlant',
        );

        final doc = await fakeFirestore.collection('users').doc('user123').get();
        final mascotData = doc.data()!['mascot'] as Map<String, dynamic>;
        expect(mascotData['speciesId'], 'seed');
        expect(mascotData['name'], 'MyPlant');
        expect(mascotData['lastSeenStage'], 1);
        expect(mascotData['createdAt'], isNotNull);
      });
    });

    group('hasMascot', () {
      test('returns false when user has no mascot', () async {
        await fakeFirestore.collection('users').doc('user123').set({
          'uid': 'user123',
          'email': 'test@example.com',
        });

        final result = await repository.hasMascot('user123');

        expect(result, isFalse);
      });

      test('returns true when user has a mascot', () async {
        await fakeFirestore.collection('users').doc('user123').set({
          'uid': 'user123',
          'email': 'test@example.com',
          'mascot': {
            'speciesId': 'seed',
            'name': 'Sprouty',
            'equippedItems': <String>[],
            'lastSeenStage': 1,
          },
        });

        final result = await repository.hasMascot('user123');

        expect(result, isTrue);
      });
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
        final species = await repository.getSpecies('seed');

        expect(species, isNotNull);
        expect(species!.id, 'seed');
        expect(species.nameEn, 'Seed');
      });

      test('returns null for unknown species', () async {
        final species = await repository.getSpecies('unknown');

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
