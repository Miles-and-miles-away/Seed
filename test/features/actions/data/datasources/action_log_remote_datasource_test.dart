import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/actions/data/datasources/action_log_remote_datasource.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ActionLogRemoteDataSourceImpl dataSource;

  const userId = 'test-user';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = ActionLogRemoteDataSourceImpl(
      firestore: fakeFirestore,
    );
  });

  CollectionReference<Map<String, dynamic>> logsCollection(
    String uid,
  ) =>
      fakeFirestore
          .collection(AppConstants.collectionUsers)
          .doc(uid)
          .collection(AppConstants.collectionActionLog);

  ActionLogModel createLog({
    String id = '',
    String actionId = 'action-1',
    String actionName = 'Recycle',
    String category = 'recycling',
    int points = 10,
    DateTime? loggedAt,
    int co2Grams = 50,
  }) {
    return ActionLogModel(
      id: id,
      actionId: actionId,
      actionName: actionName,
      category: category,
      points: points,
      loggedAt: loggedAt ?? DateTime(2024, 6, 15),
      co2Grams: co2Grams,
    );
  }

  Future<void> seedLog(
    String uid,
    String docId, {
    DateTime? loggedAt,
    int points = 10,
  }) async {
    final time = loggedAt ?? DateTime(2024, 6, 15);
    await logsCollection(uid).doc(docId).set({
      'actionId': 'action-1',
      'actionName': 'Recycle',
      'category': 'recycling',
      'points': points,
      'loggedAt': Timestamp.fromDate(time),
      'co2Grams': 50,
      'relatedSdgs': <String>[],
    });
  }

  group('ActionLogRemoteDataSourceImpl', () {
    group('createActionLog', () {
      test('writes document to Firestore', () async {
        final log = createLog();

        final result =
            await dataSource.createActionLog(userId, log);

        expect(result.id, isNotEmpty);
        expect(result.actionName, 'Recycle');

        final snapshot =
            await logsCollection(userId).get();
        expect(snapshot.docs, hasLength(1));
      });

      test(
        'assigns auto-generated ID',
        () async {
          final log = createLog(id: 'ignored');

          final result =
              await dataSource.createActionLog(userId, log);

          expect(result.id, isNot('ignored'));
          expect(result.id, isNotEmpty);
        },
      );

      test(
        'stores correct field values',
        () async {
          final log = createLog(
            points: 25,
            co2Grams: 100,
            category: 'energy',
          );

          final result =
              await dataSource.createActionLog(userId, log);

          final doc = await logsCollection(userId)
              .doc(result.id)
              .get();
          final data = doc.data()!;
          expect(data['points'], 25);
          expect(data['co2Grams'], 100);
          expect(data['category'], 'energy');
          // id should not be stored in document
          expect(data.containsKey('id'), isFalse);
        },
      );
    });

    group('watchUserActionLogs', () {
      test(
        'returns stream ordered by loggedAt desc',
        () async {
          await seedLog(
            userId,
            'log1',
            loggedAt: DateTime(2024, 6, 13),
          );
          await seedLog(
            userId,
            'log2',
            loggedAt: DateTime(2024, 6, 15),
          );
          await seedLog(
            userId,
            'log3',
            loggedAt: DateTime(2024, 6, 14),
          );

          final stream =
              dataSource.watchUserActionLogs(userId);

          await expectLater(
            stream,
            emits(
              predicate<List<ActionLogModel>>(
                (list) =>
                    list.length == 3 &&
                    list[0].id == 'log2' &&
                    list[1].id == 'log3' &&
                    list[2].id == 'log1',
              ),
            ),
          );
        },
      );

      test('returns empty list for no logs', () async {
        final stream =
            dataSource.watchUserActionLogs(userId);

        await expectLater(stream, emits(isEmpty));
      });
    });

    group('getRecentActionLogs', () {
      test('respects limit parameter', () async {
        await seedLog(
          userId,
          'log1',
          loggedAt: DateTime(2024, 6, 13),
        );
        await seedLog(
          userId,
          'log2',
          loggedAt: DateTime(2024, 6, 15),
        );
        await seedLog(
          userId,
          'log3',
          loggedAt: DateTime(2024, 6, 14),
        );

        final result = await dataSource.getRecentActionLogs(
          userId,
          2,
        );

        expect(result, hasLength(2));
        expect(result[0].id, 'log2');
        expect(result[1].id, 'log3');
      });

      test('returns all when limit exceeds count', () async {
        await seedLog(userId, 'log1');

        final result = await dataSource.getRecentActionLogs(
          userId,
          10,
        );

        expect(result, hasLength(1));
      });
    });

    group('getActionLogCollection', () {
      test('returns correct collection path', () {
        final collection =
            dataSource.getActionLogCollection(userId);

        expect(collection.path, 'users/$userId/actionLog');
      });
    });
  });
}
