import 'package:firebase_auth/firebase_auth.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/app_user_model.dart';

/// Repository that coordinates authentication and user data operations.
class AuthRepository {
  AuthRepository({
    required AuthRemoteDataSource authDataSource,
    required UserRemoteDataSource userDataSource,
  })  : _authDataSource = authDataSource,
        _userDataSource = userDataSource;

  final AuthRemoteDataSource _authDataSource;
  final UserRemoteDataSource _userDataSource;

  /// Stream of Firebase auth state changes.
  Stream<User?> get authStateChanges => _authDataSource.authStateChanges;

  /// The currently signed-in Firebase user.
  User? get currentUser => _authDataSource.currentUser;

  /// Signs in with email and password.
  /// Returns the app user after fetching/creating their Firestore document.
  Future<AppUserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _authDataSource.signInWithEmailAndPassword(
      email,
      password,
    );
    return _getOrCreateUser(credential.user!);
  }

  /// Creates a new user with email and password.
  /// Sends a verification email and creates the Firestore document.
  Future<AppUserModel> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _authDataSource.createUserWithEmailAndPassword(
      email,
      password,
    );

    // Send verification email
    await _authDataSource.sendEmailVerification();

    return _createNewUser(credential.user!);
  }

  /// Sends email verification to the current user.
  Future<void> sendEmailVerification() async {
    await _authDataSource.sendEmailVerification();
  }

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    await _authDataSource.sendPasswordResetEmail(email);
  }

  /// Signs in with Google.
  /// Returns the app user after fetching/creating their Firestore document.
  Future<AppUserModel> signInWithGoogle() async {
    final credential = await _authDataSource.signInWithGoogle();
    return _getOrCreateUser(credential.user!);
  }

  /// Signs in with Apple.
  /// Returns the app user after fetching/creating their Firestore document.
  Future<AppUserModel> signInWithApple() async {
    final credential = await _authDataSource.signInWithApple();
    return _getOrCreateUser(credential.user!);
  }

  /// Signs out the current user from all providers.
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  /// Gets the current app user from Firestore.
  Future<AppUserModel?> getCurrentUser() async {
    final firebaseUser = _authDataSource.currentUser;
    if (firebaseUser == null) return null;
    return _userDataSource.getUser(firebaseUser.uid);
  }

  /// Watches the current user document for real-time updates.
  Stream<AppUserModel?> watchCurrentUser() {
    final firebaseUser = _authDataSource.currentUser;
    if (firebaseUser == null) return Stream.value(null);
    return _userDataSource.watchUser(firebaseUser.uid);
  }

  /// Reloads the current user to check for email verification status.
  Future<void> reloadCurrentUser() async {
    await _authDataSource.reloadCurrentUser();
  }

  /// Updates the email verified status in Firestore.
  Future<void> updateEmailVerified(String uid, {required bool verified}) async {
    await _userDataSource
        .updateUser(uid, {AppConstants.fieldEmailVerified: verified});
  }

  /// Gets an existing user or creates a new one.
  Future<AppUserModel> _getOrCreateUser(User firebaseUser) async {
    var appUser = await _userDataSource.getUser(firebaseUser.uid);
    if (appUser == null) {
      appUser = await _createNewUser(firebaseUser);
    } else {
      // Update emailVerified status if it has changed
      if (appUser.emailVerified != firebaseUser.emailVerified) {
        await _userDataSource.updateUser(
          firebaseUser.uid,
          {AppConstants.fieldEmailVerified: firebaseUser.emailVerified},
        );
        appUser = appUser.copyWith(emailVerified: firebaseUser.emailVerified);
      }
    }
    return appUser;
  }

  /// Creates a new user document in Firestore.
  Future<AppUserModel> _createNewUser(User firebaseUser) async {
    final newUser = AppUserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      emailVerified: firebaseUser.emailVerified,
      createdAt: DateTime.now(),
    );
    await _userDataSource.createUser(newUser);
    return newUser;
  }

  /// Re-authenticates the user with email/password.
  /// Required before sensitive operations.
  Future<void> reauthenticateWithEmailPassword(
    String email,
    String password,
  ) async {
    await _authDataSource.reauthenticateWithEmailPassword(email, password);
  }

  /// Updates the current user's email address.
  /// Sends verification to new email before update takes effect.
  Future<void> updateEmail(String newEmail) async {
    await _authDataSource.updateEmail(newEmail);
  }

  /// Updates the current user's password.
  Future<void> updatePassword(String newPassword) async {
    await _authDataSource.updatePassword(newPassword);
  }

  /// Deletes the current user's account and all associated data.
  Future<void> deleteAccount() async {
    final user = currentUser;
    if (user != null) {
      // Delete Firestore user document first
      await _userDataSource.deleteUser(user.uid);
    }
    // Then delete the Firebase Auth account
    await _authDataSource.deleteAccount();
  }
}
