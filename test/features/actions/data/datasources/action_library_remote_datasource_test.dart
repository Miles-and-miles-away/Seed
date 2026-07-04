import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/actions/data/datasources/action_library_remote_datasource.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ActionLibraryRemoteDataSource dataSource;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = ActionLibraryRemoteDataSource(
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

  group('ActionLibraryRemoteDataSource', () {
    group('getActions', () {
      test('returns active actions ordered by sortOrder', () async {
        await seedAction('z', sortOrder: 3);
        await seedAction('a', sortOrder: 1);
        await seedAction('m', sortOrder: 2);
        await seedAction('inactive', isActive: false);

        final result = await dataSource.getActions();

        expect(result.map((a) => a.id), ['a', 'm', 'z']);
      });

      test('returns empty list when no actions', () async {
        final result = await dataSource.getActions();

        expect(result, isEmpty);
      });
    });
  });
}
