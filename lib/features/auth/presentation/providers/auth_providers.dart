import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/models/app_user_model.dart';
import '../../data/repositories/auth_repository.dart';

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
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
            email,
            password,
          );
    });
  }

  /// Creates a new user with email and password.
  /// Sends a verification email after account creation.
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).createUserWithEmailAndPassword(
            email,
            password,
          );
    });
  }

  /// Signs in with Google.
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    });
  }

  /// Signs in with Apple.
  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithApple();
    });
  }

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
    });
  }

  /// Resends the verification email.
  Future<void> resendVerificationEmail() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).sendEmailVerification();
    });
  }

  /// Reloads the current user to check verification status.
  Future<void> reloadUser() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).reloadCurrentUser();
    });
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
    });
  }
}
