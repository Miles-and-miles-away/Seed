import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/actions/data/datasources/action_library_remote_datasource.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ActionLibraryRemoteDataSourceImpl dataSource;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = ActionLibraryRemoteDataSourceImpl(
      firestore: fakeFirestore,
    );
  });

  Future<void> seedAction(
    String id, {
    bool isActive = true,
    int sortOrder = 0,
  }) async {
    await fakeFirestore
        .collection(AppConstants.collectionActionLibrary)
        .doc(id)
        .set({
      'nameEn': 'Action $id',
      'nameJa': 'Action $id JA',
      'category': 'energy',
      'points': 10,
      'co2Grams': 100,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'relatedSdgs': ['7'],
    });
  }

  group('ActionLibraryRemoteDataSourceImpl', () {
    group('watchActions', () {
      test('returns stream of active actions', () async {
        await seedAction('a1', sortOrder: 1);
        await seedAction('a2', sortOrder: 2);
        await seedAction('a3', isActive: false);

        final stream = dataSource.watchActions();

        await expectLater(
          stream,
          emits(
            predicate<List<ActionModel>>(
              (list) =>
                  list.length == 2 && list[0].id == 'a1' && list[1].id == 'a2',
            ),
          ),
        );
      });

      test('returns empty list when no actions', () async {
        final stream = dataSource.watchActions();

        await expectLater(stream, emits(isEmpty));
      });

      test(
        'orders by sortOrder',
        () async {
          await seedAction('z', sortOrder: 3);
          await seedAction('a', sortOrder: 1);
          await seedAction('m', sortOrder: 2);

          final stream = dataSource.watchActions();

          await expectLater(
            stream,
            emits(
              predicate<List<ActionModel>>(
                (list) =>
                    list[0].id == 'a' && list[1].id == 'm' && list[2].id == 'z',
              ),
            ),
          );
        },
      );
    });

    group('getAction', () {
      test('returns action by ID', () async {
        await seedAction('a1');

        final result = await dataSource.getAction('a1');

        expect(result, isNotNull);
        expect(result!.id, 'a1');
        expect(result.nameEn, 'Action a1');
        expect(result.points, 10);
      });

      test('returns null for missing ID', () async {
        final result = await dataSource.getAction('nonexistent');

        expect(result, isNull);
      });

      test(
        'returns inactive actions too',
        () async {
          await seedAction('a1', isActive: false);

          final result = await dataSource.getAction('a1');

          expect(result, isNotNull);
          expect(result!.isActive, isFalse);
        },
      );
    });
  });
}
