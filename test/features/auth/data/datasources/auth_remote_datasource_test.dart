import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/features/auth/data/datasources/auth_remote_datasource.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUser extends Mock implements User {}

class _MockUserCredential extends Mock implements UserCredential {}

class _FakeAuthCredential extends Fake implements AuthCredential {}

void main() {
  late _MockFirebaseAuth auth;
  late AuthRemoteDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(_FakeAuthCredential());
  });

  setUp(() {
    auth = _MockFirebaseAuth();
    dataSource = AuthRemoteDataSource(firebaseAuth: auth);
  });

  group('authStateChanges', () {
    test('forwards FirebaseAuth stream', () {
      final stream = Stream<User?>.value(null);
      when(auth.authStateChanges).thenAnswer((_) => stream);

      expect(dataSource.authStateChanges, same(stream));
    });
  });

  group('currentUser', () {
    test('forwards from FirebaseAuth', () {
      final user = _MockUser();
      when(() => auth.currentUser).thenReturn(user);

      expect(dataSource.currentUser, same(user));
    });
  });

  group('signInWithEmailAndPassword', () {
    test('delegates to FirebaseAuth with named args', () async {
      final credential = _MockUserCredential();
      when(
        () => auth.signInWithEmailAndPassword(
          email: 'a@b.com',
          password: 'pw',
        ),
      ).thenAnswer((_) async => credential);

      final result =
          await dataSource.signInWithEmailAndPassword('a@b.com', 'pw');

      expect(result, same(credential));
    });
  });

  group('createUserWithEmailAndPassword', () {
    test('delegates to FirebaseAuth', () async {
      final credential = _MockUserCredential();
      when(
        () => auth.createUserWithEmailAndPassword(
          email: 'a@b.com',
          password: 'pw',
        ),
      ).thenAnswer((_) async => credential);

      final result =
          await dataSource.createUserWithEmailAndPassword('a@b.com', 'pw');

      expect(result, same(credential));
    });
  });

  group('sendEmailVerification', () {
    test('invokes on current user when present', () async {
      final user = _MockUser();
      when(() => auth.currentUser).thenReturn(user);
      when(user.sendEmailVerification).thenAnswer((_) async {});

      await dataSource.sendEmailVerification();

      verify(user.sendEmailVerification).called(1);
    });

    test('no-ops when no current user', () async {
      when(() => auth.currentUser).thenReturn(null);

      await dataSource.sendEmailVerification();
    });
  });

  group('sendPasswordResetEmail', () {
    test('delegates to FirebaseAuth', () async {
      when(() => auth.sendPasswordResetEmail(email: 'a@b.com'))
          .thenAnswer((_) async {});

      await dataSource.sendPasswordResetEmail('a@b.com');

      verify(() => auth.sendPasswordResetEmail(email: 'a@b.com')).called(1);
    });
  });

  group('reloadCurrentUser', () {
    test('calls reload on current user', () async {
      final user = _MockUser();
      when(() => auth.currentUser).thenReturn(user);
      when(user.reload).thenAnswer((_) async {});

      await dataSource.reloadCurrentUser();

      verify(user.reload).called(1);
    });

    test('no-ops when no current user', () async {
      when(() => auth.currentUser).thenReturn(null);

      await dataSource.reloadCurrentUser();
    });
  });

  group('reauthenticateWithEmailPassword', () {
    test('calls reauthenticateWithCredential', () async {
      final user = _MockUser();
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.reauthenticateWithCredential(any()))
          .thenAnswer((_) async => _MockUserCredential());

      await dataSource.reauthenticateWithEmailPassword('a@b.com', 'pw');

      verify(() => user.reauthenticateWithCredential(any())).called(1);
    });

    test('throws AuthException when no user', () async {
      when(() => auth.currentUser).thenReturn(null);

      await expectLater(
        dataSource.reauthenticateWithEmailPassword('a@b.com', 'pw'),
        throwsA(
          isA<AuthException>().having((e) => e.code, 'code', 'no-user'),
        ),
      );
    });
  });

  group('updateEmail', () {
    test('calls verifyBeforeUpdateEmail on current user', () async {
      final user = _MockUser();
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.verifyBeforeUpdateEmail('new@x.com'))
          .thenAnswer((_) async {});

      await dataSource.updateEmail('new@x.com');

      verify(() => user.verifyBeforeUpdateEmail('new@x.com')).called(1);
    });

    test('throws AuthException when no user', () async {
      when(() => auth.currentUser).thenReturn(null);

      await expectLater(
        dataSource.updateEmail('new@x.com'),
        throwsA(
          isA<AuthException>().having((e) => e.code, 'code', 'no-user'),
        ),
      );
    });
  });

  group('updatePassword', () {
    test('calls updatePassword on current user', () async {
      final user = _MockUser();
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.updatePassword('newpw')).thenAnswer((_) async {});

      await dataSource.updatePassword('newpw');

      verify(() => user.updatePassword('newpw')).called(1);
    });

    test('throws AuthException when no user', () async {
      when(() => auth.currentUser).thenReturn(null);

      await expectLater(
        dataSource.updatePassword('newpw'),
        throwsA(
          isA<AuthException>().having((e) => e.code, 'code', 'no-user'),
        ),
      );
    });
  });

  group('AuthException', () {
    test('toString includes code and message', () {
      final ex = AuthException(code: 'x', message: 'hi');
      expect(ex.toString(), 'AuthException: [x] hi');
    });
  });
}
