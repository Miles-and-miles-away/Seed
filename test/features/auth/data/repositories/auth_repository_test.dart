import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:seed_app/features/auth/data/datasources/user_remote_datasource.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/data/repositories/auth_repository.dart';

class _MockAuthDataSource extends Mock implements AuthRemoteDataSource {}

class _MockUserDataSource extends Mock implements UserRemoteDataSource {}

class _MockUser extends Mock implements User {}

class _MockCredential extends Mock implements UserCredential {}

void main() {
  late _MockAuthDataSource authDs;
  late _MockUserDataSource userDs;
  late AuthRepository repository;

  const uid = 'abc123';
  const email = 'user@example.com';

  _MockUser fakeFirebaseUser({bool emailVerified = true}) {
    final user = _MockUser();
    when(() => user.uid).thenReturn(uid);
    when(() => user.email).thenReturn(email);
    when(() => user.displayName).thenReturn('Test');
    when(() => user.photoURL).thenReturn(null);
    when(() => user.emailVerified).thenReturn(emailVerified);
    return user;
  }

  setUpAll(() {
    registerFallbackValue(
      const AppUserModel(uid: 'fallback', email: 'fallback@x.com'),
    );
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    authDs = _MockAuthDataSource();
    userDs = _MockUserDataSource();
    repository = AuthRepository(
      authDataSource: authDs,
      userDataSource: userDs,
    );
  });

  group('pass-through getters', () {
    test('authStateChanges forwards the stream', () {
      final stream = Stream<User?>.value(null);
      when(() => authDs.authStateChanges).thenAnswer((_) => stream);

      expect(repository.authStateChanges, equals(stream));
    });

    test('currentUser forwards from data source', () {
      final user = fakeFirebaseUser();
      when(() => authDs.currentUser).thenReturn(user);

      expect(repository.currentUser, same(user));
    });
  });

  group('signInWithEmailAndPassword', () {
    test('returns existing app user unchanged when verification matches',
        () async {
      final user = fakeFirebaseUser();
      final credential = _MockCredential();
      when(() => credential.user).thenReturn(user);
      when(() => authDs.signInWithEmailAndPassword(email, 'pw'))
          .thenAnswer((_) async => credential);

      const existing = AppUserModel(
        uid: uid,
        email: email,
        points: 100,
        emailVerified: true,
      );
      when(() => userDs.getUser(uid)).thenAnswer((_) async => existing);

      final result = await repository.signInWithEmailAndPassword(email, 'pw');

      expect(result, existing);
      verifyNever(() => userDs.updateUser(any(), any()));
      verifyNever(() => userDs.createUser(any()));
    });

    test('syncs emailVerified to Firestore when it changed', () async {
      final user = fakeFirebaseUser();
      final credential = _MockCredential();
      when(() => credential.user).thenReturn(user);
      when(() => authDs.signInWithEmailAndPassword(email, 'pw'))
          .thenAnswer((_) async => credential);

      const stale = AppUserModel(uid: uid, email: email);
      when(() => userDs.getUser(uid)).thenAnswer((_) async => stale);
      when(() => userDs.updateUser(uid, any())).thenAnswer((_) async {});

      final result = await repository.signInWithEmailAndPassword(email, 'pw');

      expect(result.emailVerified, isTrue);
      verify(
        () => userDs.updateUser(
          uid,
          {AppConstants.fieldEmailVerified: true},
        ),
      ).called(1);
    });

    test('creates Firestore user when none exists', () async {
      final user = fakeFirebaseUser();
      final credential = _MockCredential();
      when(() => credential.user).thenReturn(user);
      when(() => authDs.signInWithEmailAndPassword(email, 'pw'))
          .thenAnswer((_) async => credential);
      when(() => userDs.getUser(uid)).thenAnswer((_) async => null);
      when(() => userDs.createUser(any())).thenAnswer((_) async {});

      final result = await repository.signInWithEmailAndPassword(email, 'pw');

      expect(result.uid, uid);
      expect(result.email, email);
      expect(result.createdAt, isNotNull);
      verify(() => userDs.createUser(any())).called(1);
    });
  });

  group('createUserWithEmailAndPassword', () {
    test('creates Firestore doc and triggers email verification', () async {
      final user = fakeFirebaseUser(emailVerified: false);
      final credential = _MockCredential();
      when(() => credential.user).thenReturn(user);
      when(() => authDs.createUserWithEmailAndPassword(email, 'pw'))
          .thenAnswer((_) async => credential);
      when(() => authDs.sendEmailVerification()).thenAnswer((_) async {});
      when(() => userDs.createUser(any())).thenAnswer((_) async {});

      final result = await repository.createUserWithEmailAndPassword(
        email,
        'pw',
      );

      expect(result.uid, uid);
      expect(result.email, email);
      expect(result.emailVerified, isFalse);
      verify(() => authDs.sendEmailVerification()).called(1);
      verify(() => userDs.createUser(any())).called(1);
    });

    test('clamps overly long provider display names', () async {
      final user = fakeFirebaseUser(emailVerified: false);
      when(() => user.displayName)
          .thenReturn('x' * (AppConstants.maxDisplayNameLength + 30));
      final credential = _MockCredential();
      when(() => credential.user).thenReturn(user);
      when(() => authDs.createUserWithEmailAndPassword(email, 'pw'))
          .thenAnswer((_) async => credential);
      when(() => authDs.sendEmailVerification()).thenAnswer((_) async {});
      when(() => userDs.createUser(any())).thenAnswer((_) async {});

      final result = await repository.createUserWithEmailAndPassword(
        email,
        'pw',
      );

      expect(
        result.displayName,
        'x' * AppConstants.maxDisplayNameLength,
      );
    });

    test('stores null when provider display name is empty', () async {
      final user = fakeFirebaseUser(emailVerified: false);
      when(() => user.displayName).thenReturn('');
      final credential = _MockCredential();
      when(() => credential.user).thenReturn(user);
      when(() => authDs.createUserWithEmailAndPassword(email, 'pw'))
          .thenAnswer((_) async => credential);
      when(() => authDs.sendEmailVerification()).thenAnswer((_) async {});
      when(() => userDs.createUser(any())).thenAnswer((_) async {});

      final result = await repository.createUserWithEmailAndPassword(
        email,
        'pw',
      );

      expect(result.displayName, isNull);
    });
  });

  group('signInWithGoogle / signInWithApple', () {
    test('Google path reuses _getOrCreateUser', () async {
      final user = fakeFirebaseUser();
      final credential = _MockCredential();
      when(() => credential.user).thenReturn(user);
      when(() => authDs.signInWithGoogle()).thenAnswer((_) async => credential);
      when(() => userDs.getUser(uid)).thenAnswer((_) async => null);
      when(() => userDs.createUser(any())).thenAnswer((_) async {});

      final result = await repository.signInWithGoogle();

      expect(result.uid, uid);
      verify(() => userDs.createUser(any())).called(1);
    });

    test('Apple path reuses _getOrCreateUser', () async {
      final user = fakeFirebaseUser();
      final credential = _MockCredential();
      when(() => credential.user).thenReturn(user);
      when(() => authDs.signInWithApple()).thenAnswer((_) async => credential);
      const existing =
          AppUserModel(uid: uid, email: email, emailVerified: true);
      when(() => userDs.getUser(uid)).thenAnswer((_) async => existing);

      final result = await repository.signInWithApple();

      expect(result, existing);
    });
  });

  group('getCurrentUser / watchCurrentUser', () {
    test('returns null when no firebase user', () async {
      when(() => authDs.currentUser).thenReturn(null);

      expect(await repository.getCurrentUser(), isNull);
      verifyNever(() => userDs.getUser(any()));
    });

    test('fetches app user when signed in', () async {
      final user = fakeFirebaseUser();
      when(() => authDs.currentUser).thenReturn(user);
      const existing = AppUserModel(uid: uid, email: email);
      when(() => userDs.getUser(uid)).thenAnswer((_) async => existing);

      expect(await repository.getCurrentUser(), existing);
    });

    test('watchCurrentUser emits null when no firebase user', () async {
      when(() => authDs.currentUser).thenReturn(null);

      await expectLater(repository.watchCurrentUser(), emits(isNull));
    });

    test('watchCurrentUser delegates to user data source when signed in', () {
      final user = fakeFirebaseUser();
      when(() => authDs.currentUser).thenReturn(user);
      const existing = AppUserModel(uid: uid, email: email);
      when(() => userDs.watchUser(uid))
          .thenAnswer((_) => Stream.value(existing));

      expect(repository.watchCurrentUser(), emits(existing));
    });
  });

  group('updateEmailVerified', () {
    test('writes the flag through user data source', () async {
      when(() => userDs.updateUser(uid, any())).thenAnswer((_) async {});

      await repository.updateEmailVerified(uid, verified: true);

      verify(
        () => userDs.updateUser(
          uid,
          {AppConstants.fieldEmailVerified: true},
        ),
      ).called(1);
    });
  });

  group('updateDisplayName / updatePersonalGoal', () {
    test('updateDisplayName writes through user data source', () async {
      final user = fakeFirebaseUser();
      when(() => authDs.currentUser).thenReturn(user);
      when(() => userDs.updateUser(uid, any())).thenAnswer((_) async {});

      await repository.updateDisplayName('Eco Hero');

      verify(
        () => userDs.updateUser(
          uid,
          {AppConstants.fieldDisplayName: 'Eco Hero'},
        ),
      ).called(1);
    });

    test('updateDisplayName is a no-op when signed out', () async {
      when(() => authDs.currentUser).thenReturn(null);

      await repository.updateDisplayName('Eco Hero');

      verifyNever(() => userDs.updateUser(any(), any()));
    });

    test('updatePersonalGoal writes through user data source', () async {
      final user = fakeFirebaseUser();
      when(() => authDs.currentUser).thenReturn(user);
      when(() => userDs.updateUser(uid, any())).thenAnswer((_) async {});

      await repository.updatePersonalGoal('save_world');

      verify(
        () => userDs.updateUser(
          uid,
          {AppConstants.fieldPersonalGoal: 'save_world'},
        ),
      ).called(1);
    });

    test('updatePersonalGoal is a no-op when signed out', () async {
      when(() => authDs.currentUser).thenReturn(null);

      await repository.updatePersonalGoal('save_world');

      verifyNever(() => userDs.updateUser(any(), any()));
    });
  });

  group('deleteAccount', () {
    test('deletes Firestore doc before Firebase account', () async {
      final currentUser = fakeFirebaseUser();
      when(() => authDs.currentUser).thenReturn(currentUser);
      when(() => userDs.deleteUser(uid)).thenAnswer((_) async {});
      when(() => authDs.deleteAccount()).thenAnswer((_) async {});

      await repository.deleteAccount();

      verifyInOrder([
        () => userDs.deleteUser(uid),
        () => authDs.deleteAccount(),
      ]);
    });

    test('still calls auth deleteAccount when no current user', () async {
      when(() => authDs.currentUser).thenReturn(null);
      when(() => authDs.deleteAccount()).thenAnswer((_) async {});

      await repository.deleteAccount();

      verifyNever(() => userDs.deleteUser(any()));
      verify(() => authDs.deleteAccount()).called(1);
    });
  });

  group('simple delegations', () {
    test('signOut forwards', () async {
      when(() => authDs.signOut()).thenAnswer((_) async {});

      await repository.signOut();

      verify(() => authDs.signOut()).called(1);
    });

    test('sendEmailVerification forwards', () async {
      when(() => authDs.sendEmailVerification()).thenAnswer((_) async {});

      await repository.sendEmailVerification();

      verify(() => authDs.sendEmailVerification()).called(1);
    });

    test('sendPasswordResetEmail forwards', () async {
      when(() => authDs.sendPasswordResetEmail(email)).thenAnswer((_) async {});

      await repository.sendPasswordResetEmail(email);

      verify(() => authDs.sendPasswordResetEmail(email)).called(1);
    });

    test('reloadCurrentUser forwards', () async {
      when(() => authDs.reloadCurrentUser()).thenAnswer((_) async {});

      await repository.reloadCurrentUser();

      verify(() => authDs.reloadCurrentUser()).called(1);
    });

    test('reauthenticateWithEmailPassword forwards', () async {
      when(() => authDs.reauthenticateWithEmailPassword(email, 'pw'))
          .thenAnswer((_) async {});

      await repository.reauthenticateWithEmailPassword(email, 'pw');

      verify(() => authDs.reauthenticateWithEmailPassword(email, 'pw'))
          .called(1);
    });

    test('updateEmail forwards', () async {
      when(() => authDs.updateEmail('new@example.com'))
          .thenAnswer((_) async {});

      await repository.updateEmail('new@example.com');

      verify(() => authDs.updateEmail('new@example.com')).called(1);
    });

    test('updatePassword forwards', () async {
      when(() => authDs.updatePassword('newpw')).thenAnswer((_) async {});

      await repository.updatePassword('newpw');

      verify(() => authDs.updatePassword('newpw')).called(1);
    });
  });
}
