import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seed_app/core/utils/auth_error_mapper.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Web (server) OAuth client ID for the Firebase project. Passing it as
/// google_sign_in's serverClientId makes authenticate() mint an ID token
/// with this audience, which is what Firebase accepts for the Google
/// provider. The iOS client ID is read from the bundled
/// GoogleService-Info.plist automatically.
const String _googleServerClientId =
    '49522523534-9qnjjncgea403kq4364bvc55lf9u40r8.apps.googleusercontent.com';

/// Firebase Auth operations.
class AuthRemoteDataSource {
  AuthRemoteDataSource({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  // google_sign_in 7.x requires initialize() before authenticate()/disconnect.
  // Run it once per process and reuse the result.
  static Future<void>? _googleInit;

  Future<void> _ensureGoogleSignInInitialized() {
    return _googleInit ??= GoogleSignIn.instance.initialize(
      serverClientId: _googleServerClientId,
    );
  }

  /// Emits on sign-in/out AND on user updates like `reload()`.
  ///
  /// Uses `userChanges()` rather than `authStateChanges()` so email
  /// verification propagates: `authStateChanges()` does not fire after
  /// `reload()`, so the router would keep a stale unverified user and bounce
  /// a just-verified user back to the verification screen.
  Stream<User?> get authStateChanges => _firebaseAuth.userChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendEmailVerification() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

    final GoogleSignInAccount account;
    try {
      account = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      throw AuthException(
        code: e.code == GoogleSignInExceptionCode.canceled
            ? 'sign-in-cancelled'
            : 'google-sign-in-failed',
        message: 'Google sign-in failed: ${e.description ?? e.code.name}',
      );
    }

    // Firebase authenticates with the Google ID token minted for the web
    // (server) client; initialize() sets that audience via serverClientId.
    final idToken = account.authentication.idToken;
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithApple() async {
    final AuthorizationCredentialAppleID appleCredential;
    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      throw AuthException(
        code: e.code == AuthorizationErrorCode.canceled
            ? 'sign-in-cancelled'
            : 'apple-sign-in-failed',
        message: 'Apple sign-in failed: ${e.code.name} ${e.message}',
      );
    }

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return _firebaseAuth.signInWithCredential(oauthCredential);
  }

  Future<void> signOut() async {
    // Firebase sign-out is what actually logs the user out and drives the
    // auth-state redirect, so it must be awaited and complete first.
    await _firebaseAuth.signOut();
    // Revoking the Google grant is best-effort cleanup: disconnect() throws
    // for users who never signed in with Google (GoogleSignIn was never
    // initialized) and can hang on the iOS simulator. It must never block or
    // fail sign-out, so fire it detached and swallow both failure modes.
    try {
      unawaited(GoogleSignIn.instance.disconnect().catchError((Object _) {}));
    } on Object catch (_) {
      // GoogleSignIn not initialized -- nothing to revoke.
    }
  }

  Future<void> reloadCurrentUser() async {
    await _firebaseAuth.currentUser?.reload();
  }

  Future<void> reauthenticateWithEmailPassword(
    String email,
    String password,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw AuthException(code: 'no-user', message: 'No user signed in');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);
  }

  Future<void> updateEmail(String newEmail) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw AuthException(code: 'no-user', message: 'No user signed in');
    }

    // verifyBeforeUpdateEmail sends a verification to new email first
    await user.verifyBeforeUpdateEmail(newEmail);
  }

  Future<void> updatePassword(String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw AuthException(code: 'no-user', message: 'No user signed in');
    }

    await user.updatePassword(newPassword);
  }
}
