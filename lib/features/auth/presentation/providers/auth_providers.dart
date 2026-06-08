import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:seed_app/features/auth/data/datasources/user_remote_datasource.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/data/repositories/auth_repository.dart';
import 'package:seed_app/shared/providers/notification_providers.dart';
import 'package:seed_app/shared/services/analytics_service.dart';

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
  return AuthRemoteDataSourceImpl(
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
}

@riverpod
UserRemoteDataSource userRemoteDataSource(Ref ref) {
  return UserRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
  );
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
    error: (_, __) => Stream.value(null),
  );
}

// =============================================================================
// Auth Notifier - Handles Auth Actions
// =============================================================================

/// Notifier that handles authentication actions.
/// Uses AsyncValue to track loading and error states.
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Signs in with email and password.
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
            email,
            password,
          );
      await AnalyticsService.instance.logLogin(method: 'email');
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Creates a new user with email and password.
  /// Sends a verification email after account creation.
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).createUserWithEmailAndPassword(
            email,
            password,
          );
      await AnalyticsService.instance.logSignUp(method: 'email');
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Signs in with Google.
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      // Note: For social sign-in, we track as login since we can't easily
      // distinguish first-time from returning users without modifying the repo.
      await AnalyticsService.instance.logLogin(method: 'google');
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Signs in with Apple.
  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithApple();
      await AnalyticsService.instance.logLogin(method: 'apple');
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Resends the verification email.
  Future<void> resendVerificationEmail() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).sendEmailVerification();
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Reloads the current user to check verification status.
  Future<void> reloadUser() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).reloadCurrentUser();
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      // Clear FCM token before signing out (userId still available)
      final fcm = ref.read(fcmServiceProvider);
      await fcm.removeStoredToken();
      await fcm.deleteToken();
      await ref.read(authRepositoryProvider).signOut();
      await AnalyticsService.instance.logLogout();
      await AnalyticsService.instance.setUserId(null);
      await FirebaseCrashlytics.instance.setUserIdentifier('');
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Re-authenticates the user with email/password.
  /// Required before sensitive operations.
  Future<void> reauthenticateWithEmailPassword(
    String email,
    String password,
  ) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).reauthenticateWithEmailPassword(
            email,
            password,
          );
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Updates the user's email address.
  /// Requires re-authentication first.
  Future<void> updateEmail(String newEmail) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).updateEmail(newEmail);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Updates the user's password.
  /// Requires re-authentication first.
  Future<void> updatePassword(String newPassword) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).updatePassword(newPassword);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Updates the user's display name.
  Future<void> updateDisplayName(String displayName) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).updateDisplayName(displayName);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Updates the user's personal sustainability goal.
  Future<void> updatePersonalGoal(String personalGoal) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).updatePersonalGoal(personalGoal);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Deletes the user's account and all data.
  /// Requires re-authentication first.
  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).deleteAccount();
    });
    if (!ref.mounted) return;
    state = result;
  }
}
