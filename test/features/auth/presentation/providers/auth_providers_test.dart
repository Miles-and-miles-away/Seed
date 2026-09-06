import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/data/repositories/auth_repository.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';

import '../../../../helpers/test_helpers.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

/// Lets the auth stream, the rebuild it triggers, and the user stream
/// all emit before reading.
Future<void> settle() async {
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  group('currentUserProvider', () {
    test('streams the Firestore user once auth reports a user', () async {
      final repo = _MockAuthRepository();
      when(
        () => repo.authStateChanges,
      ).thenAnswer((_) => Stream.value(createMockUser(uid: 'abc')));
      when(repo.watchCurrentUser).thenAnswer(
        (_) => Stream.value(const AppUserModel(uid: 'abc', email: 'e')),
      );
      final c = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(c.dispose);

      c.listen(currentUserProvider, (_, _) {});
      await settle();

      expect(c.read(currentUserProvider).value?.uid, 'abc');
      expect(c.read(userIdProvider), 'abc');
    });

    test('is null and never opens the user stream while signed out', () async {
      final repo = _MockAuthRepository();
      when(() => repo.authStateChanges).thenAnswer((_) => Stream.value(null));
      final c = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(c.dispose);

      c.listen(currentUserProvider, (_, _) {});
      await settle();

      expect(c.read(currentUserProvider), isA<AsyncData<AppUserModel?>>());
      expect(c.read(currentUserProvider).value, isNull);
      expect(c.read(userIdProvider), isNull);
      verifyNever(repo.watchCurrentUser);
    });

    test('is null when the auth stream errors', () async {
      final repo = _MockAuthRepository();
      when(
        () => repo.authStateChanges,
      ).thenAnswer((_) => Stream.error(Exception('auth down')));
      final c = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(c.dispose);

      c.listen(currentUserProvider, (_, _) {});
      await settle();

      expect(c.read(currentUserProvider), isA<AsyncData<AppUserModel?>>());
      expect(c.read(currentUserProvider).value, isNull);
      verifyNever(repo.watchCurrentUser);
    });

    test('end to end: Firebase auth user resolves to the user doc', () async {
      final firestore = FakeFirebaseFirestore();
      await firestore.collection(AppConstants.collectionUsers).doc('abc').set({
        'email': 'abc@example.com',
        AppConstants.fieldPoints: 42,
      });
      final auth = createMockFirebaseAuth(
        currentUser: createMockUser(uid: 'abc', email: 'abc@example.com'),
      );
      final c = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(auth),
          firestoreProvider.overrideWithValue(firestore),
        ],
      );
      addTearDown(c.dispose);

      c.listen(currentUserProvider, (_, _) {});
      await settle();

      final user = c.read(currentUserProvider).value;
      expect(user?.uid, 'abc');
      expect(user?.points, 42);
    });
  });
}
