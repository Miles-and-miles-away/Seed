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
  }) : _authDataSource = authDataSource,
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

  /// Gets an existing user or creates a new one.
  Future<AppUserModel> _getOrCreateUser(User firebaseUser) async {
    var appUser = await _userDataSource.getUser(firebaseUser.uid);
    if (appUser == null) {
      appUser = await _createNewUser(firebaseUser);
    } else {
      // Update emailVerified status if it has changed
      if (appUser.emailVerified != firebaseUser.emailVerified) {
        await _userDataSource.updateUser(firebaseUser.uid, {
          AppConstants.fieldEmailVerified: firebaseUser.emailVerified,
        });
        appUser = appUser.copyWith(emailVerified: firebaseUser.emailVerified);
      }
    }
    return appUser;
  }

  /// Updates the current user's display name in Firestore.
  Future<void> updateDisplayName(String displayName) async {
    final user = currentUser;
    if (user == null) return;
    await _userDataSource.updateUser(user.uid, {
      AppConstants.fieldDisplayName: displayName,
    });
    // Keep the FirebaseAuth profile in sync. Best-effort: Firestore is the
    // source of truth, so a profile-update failure must not fail the save.
    try {
      await user.updateDisplayName(displayName);
    } on FirebaseAuthException {
      // Ignore -- the Firestore write already succeeded.
    }
  }

  /// Updates the current user's personal goal in Firestore.
  Future<void> updatePersonalGoal(String personalGoal) async {
    final user = currentUser;
    if (user == null) return;
    await _userDataSource.updateUser(user.uid, {
      AppConstants.fieldPersonalGoal: personalGoal,
    });
  }

  /// Clamps provider display names so they satisfy Firestore rules
  /// (social providers may supply empty or overly long names).
  String? _clampDisplayName(String? name) {
    if (name == null || name.isEmpty) return null;
    if (name.length <= AppConstants.maxDisplayNameLength) return name;
    return name.substring(0, AppConstants.maxDisplayNameLength);
  }

  /// Creates a new user document in Firestore.
  Future<AppUserModel> _createNewUser(User firebaseUser) async {
    final newUser = AppUserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: _clampDisplayName(firebaseUser.displayName),
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
  ///
  /// Runs server-side via the deleteUserAccount Cloud Function: rules
  /// block client deletes of the action log, and only the Admin SDK
  /// removes subcollections and the Auth user. Re-authentication is
  /// handled by the UI before this call. Signs out locally afterwards
  /// to clear the now-invalid session.
  Future<void> deleteAccount() async {
    await _userDataSource.deleteUser();
    await _authDataSource.signOut();
  }
}
