import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Interface for Firebase Auth operations.
abstract class AuthRemoteDataSource {
  /// Stream of auth state changes.
  Stream<User?> get authStateChanges;

  /// The currently signed-in user, or null.
  User? get currentUser;

  /// Signs in with email and password.
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  );

  /// Creates a new user with email and password.
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  );

  /// Sends email verification to the current user.
  Future<void> sendEmailVerification();

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail(String email);

  /// Signs in with Google.
  Future<UserCredential> signInWithGoogle();

  /// Signs in with Apple.
  Future<UserCredential> signInWithApple();

  /// Signs out the current user.
  Future<void> signOut();

  /// Reloads the current user to get updated emailVerified status.
  Future<void> reloadCurrentUser();

  /// Re-authenticates the user with email/password.
  /// Required before sensitive operations like email/password change or account deletion.
  Future<void> reauthenticateWithEmailPassword(String email, String password);

  /// Updates the current user's email address.
  /// Requires re-authentication before calling.
  Future<void> updateEmail(String newEmail);

  /// Updates the current user's password.
  /// Requires re-authentication before calling.
  Future<void> updatePassword(String newPassword);
}

/// Implementation of [AuthRemoteDataSource] using Firebase Auth.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> sendEmailVerification() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    // GoogleSignIn v7.x uses singleton pattern with event-driven auth
    final googleSignIn = GoogleSignIn.instance;

    // Set up completer to wait for authentication result
    final completer = Completer<GoogleSignInAccount?>();

    // Listen for authentication events
    StreamSubscription<GoogleSignInAuthenticationEvent>? subscription;
    subscription = googleSignIn.authenticationEvents.listen(
      (event) {
        // Handle different event types
        if (event is GoogleSignInAuthenticationEventSignIn) {
          subscription?.cancel();
          completer.complete(event.user);
        } else if (event is GoogleSignInAuthenticationEventSignOut) {
          subscription?.cancel();
          completer.complete(null);
        }
      },
      onError: (Object error) {
        subscription?.cancel();
        completer.completeError(error);
      },
    );

    // Trigger the sign-in flow
    try {
      await googleSignIn.authenticate();
    } catch (e) {
      await subscription.cancel();
      throw AuthException(
        code: 'google-sign-in-failed',
        message: 'Google sign-in failed: $e',
      );
    }

    final googleUser = await completer.future;
    if (googleUser == null) {
      throw AuthException(
        code: 'sign-in-cancelled',
        message: 'Google sign-in was cancelled',
      );
    }

    // Get the authorization tokens for Firebase
    final authorization =
        await googleSignIn.authorizationClient.authorizeScopes(<String>[]);
    final accessToken = authorization.accessToken;

    // Create Firebase credential
    final credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
    );

    return _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<UserCredential> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return _firebaseAuth.signInWithCredential(oauthCredential);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      GoogleSignIn.instance.disconnect(),
    ]);
  }

  @override
  Future<void> reloadCurrentUser() async {
    await _firebaseAuth.currentUser?.reload();
  }

  @override
  Future<void> reauthenticateWithEmailPassword(
    String email,
    String password,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw AuthException(
        code: 'no-user',
        message: 'No user signed in',
      );
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
  }

  @override
  Future<void> updateEmail(String newEmail) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw AuthException(
        code: 'no-user',
        message: 'No user signed in',
      );
    }

    // verifyBeforeUpdateEmail sends a verification to new email first
    await user.verifyBeforeUpdateEmail(newEmail);
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw AuthException(
        code: 'no-user',
        message: 'No user signed in',
      );
    }

    await user.updatePassword(newPassword);
  }
}

/// Custom exception for auth errors to provide consistent error handling.
class AuthException implements Exception {
  AuthException({
    required this.code,
    this.message,
  });

  final String code;
  final String? message;

  @override
  String toString() => 'AuthException: [$code] $message';
}
