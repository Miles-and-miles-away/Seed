import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/utils/app_logger.dart';
import 'package:seed_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:seed_app/features/auth/data/datasources/user_remote_datasource.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/data/repositories/auth_repository.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/providers/notification_providers.dart';

part 'auth_providers.g.dart';

// =============================================================================
// Firebase Instance Providers
// =============================================================================

@riverpod
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

@riverpod
FirebaseFirestore firestore(Ref ref) => FirebaseFirestore.instance;

// =============================================================================
// Data Source Providers
// =============================================================================

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource(firebaseAuth: ref.watch(firebaseAuthProvider));
}

@riverpod
UserRemoteDataSource userRemoteDataSource(Ref ref) {
  return UserRemoteDataSource(firestore: ref.watch(firestoreProvider));
}

// =============================================================================
// Repository Provider
// =============================================================================

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    authDataSource: ref.watch(authRemoteDataSourceProvider),
    userDataSource: ref.watch(userRemoteDataSourceProvider),
  );
}

// =============================================================================
// Auth State Providers
// =============================================================================

/// Stream of Firebase auth state changes.
@riverpod
Stream<User?> authStateChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

/// UID of the signed-in user, or null when signed out.
///
/// Providers that only need the identity must watch this instead of
/// [currentUserProvider]: the user document changes on every logged
/// action, so whole-doc watchers tear down and recreate their
/// Firestore listeners/queries each time.
@riverpod
String? userId(Ref ref) {
  return ref.watch(authStateChangesProvider.select((auth) => auth.value?.uid));
}

/// Stream of the current app user from Firestore.
/// Updates in real-time when user data changes.
@riverpod
Stream<AppUserModel?> currentUser(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.watch(authRepositoryProvider).watchCurrentUser();
    },
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
}

// =============================================================================
// Auth Notifier - Handles Auth Actions
// =============================================================================

/// Notifier that handles authentication actions.
/// Uses AsyncValue to track loading and error states.
///
/// Kept alive: it is the app-global auth controller, and its methods run
/// multi-step async work (sign-out clears FCM then signs out of Firebase).
/// As an autoDispose provider it was disposed mid-flight when the caller
/// only `read` it (e.g. the profile logout button), so `ref` reads after
/// the first await threw and the Firebase sign-out never ran.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Sets loading, runs [body], keeps its outcome unless disposed meanwhile.
  Future<void> _guarded(Future<void> Function() body) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(body);
    if (!ref.mounted) return;
    state = result;
  }

  /// Signs in with email and password.
  Future<void> signInWithEmailAndPassword(String email, String password) =>
      _guarded(() async {
        await ref
            .read(authRepositoryProvider)
            .signInWithEmailAndPassword(email, password);
        await ref.read(analyticsServiceProvider).logLogin(method: 'email');
      });

  /// Creates a new user with email and password.
  /// Sends a verification email after account creation.
  Future<void> createUserWithEmailAndPassword(String email, String password) =>
      _guarded(() async {
        await ref
            .read(authRepositoryProvider)
            .createUserWithEmailAndPassword(email, password);
        await ref.read(analyticsServiceProvider).logSignUp(method: 'email');
      });

  /// Signs in with Google.
  Future<void> signInWithGoogle() => _guarded(() async {
    await ref.read(authRepositoryProvider).signInWithGoogle();
    // Note: For social sign-in, we track as login since we can't easily
    // distinguish first-time from returning users without modifying the repo.
    await ref.read(analyticsServiceProvider).logLogin(method: 'google');
  });

  /// Signs in with Apple.
  Future<void> signInWithApple() => _guarded(() async {
    await ref.read(authRepositoryProvider).signInWithApple();
    await ref.read(analyticsServiceProvider).logLogin(method: 'apple');
  });

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail(String email) => _guarded(
    () => ref.read(authRepositoryProvider).sendPasswordResetEmail(email),
  );

  /// Resends the verification email.
  Future<void> resendVerificationEmail() =>
      _guarded(() => ref.read(authRepositoryProvider).sendEmailVerification());

  /// Reloads the current user to check verification status.
  Future<void> reloadUser() =>
      _guarded(() => ref.read(authRepositoryProvider).reloadCurrentUser());

  /// Signs out the current user.
  Future<void> signOut() => _guarded(() async {
    // FCM cleanup is best-effort: it must never block sign-out. On iOS
    // deleteToken() throws when the APNS token hasn't arrived yet, which
    // would otherwise abort the whole sign-out and leave the user logged in.
    try {
      final fcm = ref.read(fcmServiceProvider);
      await fcm.removeStoredToken();
      await fcm.deleteToken();
    } on Object catch (e) {
      // Expected on iOS when the APNS token isn't set yet (e.g. simulator).
      appLogger.info('FCM cleanup skipped during sign-out: $e');
    }
    await ref.read(authRepositoryProvider).signOut();
    await ref.read(analyticsServiceProvider).logLogout();
    await ref.read(analyticsServiceProvider).setUserId(null);
    await ref.read(crashlyticsProvider).setUserIdentifier('');
  });

  /// Re-authenticates the user with email/password.
  /// Required before sensitive operations.
  Future<void> reauthenticateWithEmailPassword(String email, String password) =>
      _guarded(
        () => ref
            .read(authRepositoryProvider)
            .reauthenticateWithEmailPassword(email, password),
      );

  /// Updates the user's email address.
  /// Requires re-authentication first.
  Future<void> updateEmail(String newEmail) =>
      _guarded(() => ref.read(authRepositoryProvider).updateEmail(newEmail));

  /// Updates the user's password.
  /// Requires re-authentication first.
  Future<void> updatePassword(String newPassword) => _guarded(
    () => ref.read(authRepositoryProvider).updatePassword(newPassword),
  );

  /// Updates the user's display name.
  ///
  /// Optimistic: the Firestore write is applied to the local cache
  /// immediately, so [currentUserProvider] reflects the change without
  /// waiting for the server. Unlike the auth-lifecycle actions, this does
  /// not flip the global auth [state] to loading (a profile edit is not an
  /// auth transition, and doing so would gate any screen watching auth on a
  /// server round-trip). Rethrows so callers can surface failures.
  Future<void> updateDisplayName(String displayName) async {
    await ref.read(authRepositoryProvider).updateDisplayName(displayName);
  }

  /// Updates the user's personal sustainability goal.
  ///
  /// Optimistic and non-blocking for the same reasons as
  /// [updateDisplayName]. Rethrows so callers can surface failures.
  Future<void> updatePersonalGoal(String personalGoal) async {
    await ref.read(authRepositoryProvider).updatePersonalGoal(personalGoal);
  }

  /// Deletes the user's account and all data.
  /// Requires re-authentication first.
  Future<void> deleteAccount() =>
      _guarded(() => ref.read(authRepositoryProvider).deleteAccount());
}
