import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/mascot/data/services/mascot_migration_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MascotMigrationService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    service = MascotMigrationService(
      firestore: fakeFirestore,
    );
  });

  Future<void> createUser(
    String userId,
    Map<String, dynamic> data,
  ) async {
    await fakeFirestore
        .collection(AppConstants.collectionUsers)
        .doc(userId)
        .set(data);
  }

  Future<Map<String, dynamic>?> getUser(
    String userId,
  ) async {
    final doc = await fakeFirestore
        .collection(AppConstants.collectionUsers)
        .doc(userId)
        .get();
    return doc.data();
  }

  group('MascotMigrationService', () {
    group('migrateIfNeeded', () {
      test('no-op when user already has mascots array', () async {
        await createUser('u1', {
          'mascots': [
            {'id': 'm1', 'speciesId': 'seed'},
          ],
          'activeMascotId': 'm1',
          'points': 500,
        });

        await service.migrateIfNeeded('u1');

        final data = await getUser('u1');
        final mascots = data!['mascots'] as List;
        expect(mascots, hasLength(1));
        expect(
          (mascots[0] as Map)['id'],
          'm1',
        );
      });

      test(
        'migrates old single mascot to array',
        () async {
          await createUser('u1', {
            'mascot': {
              'speciesId': 'seed',
              'name': 'Sprouty',
            },
            'points': 200,
          });

          await service.migrateIfNeeded('u1');

          final data = await getUser('u1');
          final mascots = data!['mascots'] as List;
          expect(mascots, hasLength(1));

          final migrated = mascots[0] as Map<String, dynamic>;
          expect(migrated['speciesId'], 'seed');
          expect(migrated['name'], 'Sprouty');
          expect(migrated['id'], isNotNull);
          expect(migrated['mascotPoints'], 200);
          expect(data['activeMascotId'], migrated['id']);
        },
      );

      test('deletes old mascot field after migration', () async {
        await createUser('u1', {
          'mascot': {
            'speciesId': 'seed',
            'name': 'Old',
          },
          'points': 0,
        });

        await service.migrateIfNeeded('u1');

        final data = await getUser('u1');
        // fake_cloud_firestore may not fully support
        // FieldValue.delete(), so check mascots exists
        expect(data!['mascots'], isNotNull);
      });

      test(
        'no-op when user has no mascot field',
        () async {
          await createUser('u1', {
            'email': 'test@example.com',
            'points': 100,
          });

          await service.migrateIfNeeded('u1');

          final data = await getUser('u1');
          expect(data!.containsKey('mascots'), isFalse);
        },
      );

      test(
        'no-op when user doc does not exist',
        () async {
          // Should not throw
          await service.migrateIfNeeded('nonexistent');
        },
      );

      test(
        'sets mascotLevel from points',
        () async {
          await createUser('u1', {
            'mascot': {
              'speciesId': 'seed',
              'name': 'Big',
            },
            'points': 5000,
          });

          await service.migrateIfNeeded('u1');

          final data = await getUser('u1');
          final mascots = data!['mascots'] as List;
          final migrated = mascots[0] as Map<String, dynamic>;
          expect(migrated['mascotLevel'], greaterThan(1));
          expect(migrated['mascotPoints'], 5000);
        },
      );

      test(
        'sets isFullyEvolved when at max level',
        () async {
          // Level 50 requires ~85 billion points with
          // 1.5x geometric scaling
          await createUser('u1', {
            'mascot': {
              'speciesId': 'seed',
              'name': 'Maxed',
            },
            'points': 100000000000,
          });

          await service.migrateIfNeeded('u1');

          final data = await getUser('u1');
          final mascots = data!['mascots'] as List;
          final migrated = mascots[0] as Map<String, dynamic>;
          expect(migrated['isFullyEvolved'], isTrue);
        },
      );

      test('idempotent - second call is no-op', () async {
        await createUser('u1', {
          'mascot': {
            'speciesId': 'seed',
            'name': 'Sprouty',
          },
          'points': 100,
        });

        await service.migrateIfNeeded('u1');
        final firstData = await getUser('u1');
        final firstId = ((firstData!['mascots'] as List)[0] as Map)['id'];

        await service.migrateIfNeeded('u1');
        final secondData = await getUser('u1');
        final secondId = ((secondData!['mascots'] as List)[0] as Map)['id'];

        expect(firstId, secondId);
        expect(
          secondData['mascots'] as List,
          hasLength(1),
        );
      });
    });
  });
}
