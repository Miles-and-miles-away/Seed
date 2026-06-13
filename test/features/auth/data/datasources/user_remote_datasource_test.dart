import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/data/datasources/user_remote_datasource.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';

class _MockFirebaseFunctions extends Mock implements FirebaseFunctions {}

class _MockHttpsCallable extends Mock implements HttpsCallable {}

class _MockHttpsCallableResult extends Mock
    implements HttpsCallableResult<Object?> {}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late UserRemoteDataSourceImpl dataSource;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = UserRemoteDataSourceImpl(
      firestore: fakeFirestore,
    );
  });

  CollectionReference<Map<String, dynamic>> usersCollection() =>
      fakeFirestore.collection(AppConstants.collectionUsers);

  Future<void> seedUser(
    String uid, {
    String email = 'test@example.com',
    int points = 0,
    String language = 'en',
  }) async {
    await usersCollection().doc(uid).set({
      'email': email,
      'points': points,
      'level': 1,
      'currentStreak': 0,
      'longestStreak': 0,
      'language': language,
      'notificationTime': '09:00',
      'emailVerified': false,
      'totalCo2Grams': 0,
      'totalActionsCount': 0,
      'eggPendingDiscovery': false,
      'notificationsEnabled': true,
      'mascots': <Map<String, dynamic>>[],
      'sdgStats': <String, dynamic>{},
    });
  }

  group('UserRemoteDataSourceImpl', () {
    group('getUser', () {
      test('returns user when doc exists', () async {
        await seedUser('u1', email: 'a@b.com', points: 50);

        final result = await dataSource.getUser('u1');

        expect(result, isNotNull);
        expect(result!.uid, 'u1');
        expect(result.email, 'a@b.com');
        expect(result.points, 50);
      });

      test('returns null when doc missing', () async {
        final result = await dataSource.getUser('nonexistent');

        expect(result, isNull);
      });
    });

    group('createUser', () {
      test('creates user document in Firestore', () async {
        const user = AppUserModel(
          uid: 'u1',
          email: 'new@example.com',
        );

        await dataSource.createUser(user);

        final doc = await usersCollection().doc('u1').get();
        expect(doc.exists, isTrue);
        expect(doc.data()!['email'], 'new@example.com');
        // uid should not be stored in the document
        expect(
          doc.data()!.containsKey('uid'),
          isFalse,
        );
      });

      test(
        'stores all fields correctly',
        () async {
          const user = AppUserModel(
            uid: 'u1',
            email: 'user@test.com',
            displayName: 'Test User',
            language: 'ja',
            points: 100,
            level: 5,
          );

          await dataSource.createUser(user);

          final doc = await usersCollection().doc('u1').get();
          final data = doc.data()!;
          expect(data['displayName'], 'Test User');
          expect(data['language'], 'ja');
          expect(data['points'], 100);
          expect(data['level'], 5);
        },
      );
    });

    group('updateUser', () {
      test('updates specific fields', () async {
        await seedUser('u1');

        await dataSource.updateUser('u1', {
          'points': 500,
          'level': 3,
        });

        final doc = await usersCollection().doc('u1').get();
        expect(doc.data()!['points'], 500);
        expect(doc.data()!['level'], 3);
        // Unchanged fields preserved
        expect(doc.data()!['email'], 'test@example.com');
      });
    });

    group('watchUser', () {
      test('emits user on changes', () async {
        await seedUser('u1', email: 'watch@test.com');

        final stream = dataSource.watchUser('u1');

        await expectLater(
          stream,
          emits(
            predicate<AppUserModel?>(
              (u) => u != null && u.uid == 'u1' && u.email == 'watch@test.com',
            ),
          ),
        );
      });

      test(
        'emits null for nonexistent user',
        () async {
          final stream = dataSource.watchUser('nonexistent');

          await expectLater(stream, emits(isNull));
        },
      );
    });

    group('deleteUser', () {
      // Deletion is server-side (rules make actionLog immutable from
      // clients): the data source must invoke the deleteUserAccount
      // callable and propagate its failures.
      late _MockFirebaseFunctions functions;
      late _MockHttpsCallable callable;

      setUp(() {
        functions = _MockFirebaseFunctions();
        callable = _MockHttpsCallable();
        when(() => functions.httpsCallable('deleteUserAccount'))
            .thenReturn(callable);
        dataSource = UserRemoteDataSourceImpl(
          firestore: fakeFirestore,
          functions: functions,
        );
      });

      test('invokes the deleteUserAccount callable', () async {
        when(() => callable.call<Object?>())
            .thenAnswer((_) async => _MockHttpsCallableResult());

        await dataSource.deleteUser();

        verify(() => callable.call<Object?>()).called(1);
      });

      test('propagates callable failures', () async {
        when(() => callable.call<Object?>()).thenThrow(
          FirebaseFunctionsException(
            code: 'unauthenticated',
            message: 'Sign in required',
          ),
        );

        await expectLater(
          dataSource.deleteUser(),
          throwsA(isA<FirebaseFunctionsException>()),
        );
      });
    });
  });
}
