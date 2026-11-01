// Mocks are the only way to make a query report it came from the cache.
// ignore_for_file: subtype_of_sealed_class, avoid_implementing_value_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/actions/data/datasources/action_library_remote_datasource.dart';

class _MockFirestore extends Mock implements FirebaseFirestore {}

class _MockCollection extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class _MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class _MockSnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class _MockMetadata extends Mock implements SnapshotMetadata {}

_MockSnapshot _emptySnapshot({required bool fromCache}) {
  final metadata = _MockMetadata();
  when(() => metadata.isFromCache).thenReturn(fromCache);
  final snapshot = _MockSnapshot();
  when(() => snapshot.docs).thenReturn([]);
  when(() => snapshot.metadata).thenReturn(metadata);
  return snapshot;
}

void main() {
  setUpAll(() => registerFallbackValue(const GetOptions()));

  late FakeFirebaseFirestore fakeFirestore;
  late ActionLibraryRemoteDataSource dataSource;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = ActionLibraryRemoteDataSource(firestore: fakeFirestore);
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

      test('asks the server when the cache answers empty', () async {
        final firestore = _MockFirestore();
        final collection = _MockCollection();
        final query = _MockQuery();
        when(
          () => firestore.collection(AppConstants.collectionActionLibrary),
        ).thenReturn(collection);
        when(
          () => collection.where(AppConstants.fieldIsActive, isEqualTo: true),
        ).thenReturn(query);
        when(
          () => query.orderBy(AppConstants.fieldSortOrder),
        ).thenReturn(query);
        final sources = <Source>[];
        when(() => query.get(any())).thenAnswer((invocation) async {
          final options =
              invocation.positionalArguments.firstOrNull as GetOptions? ??
              const GetOptions();
          sources.add(options.source);
          return _emptySnapshot(fromCache: options.source != Source.server);
        });

        await ActionLibraryRemoteDataSource(firestore: firestore).getActions();

        expect(sources, [Source.serverAndCache, Source.server]);
      });
    });
  });
}
