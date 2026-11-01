import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seed_app/core/utils/auth_error_mapper.dart';
import 'package:seed_app/core/utils/is_offline.dart' as net;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Web (server) OAuth client ID for the Firebase project. Passing it as
/// google_sign_in's serverClientId makes authenticate() mint an ID token
/// with this audience, which is what Firebase accepts for the Google
/// provider. The iOS client ID is read from the bundled
/// GoogleService-Info.plist automatically.
const String _googleServerClientId =
    '49522523534-9qnjjncgea403kq4364bvc55lf9u40r8.apps.googleusercontent.com';

const String _appleProviderId = 'apple.com';
const String _googleProviderId = 'google.com';
const String _passwordProviderId = 'password';
const int _nonceLength = 32;

/// Firebase Auth operations.
class AuthRemoteDataSource {
  AuthRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    Future<bool> Function() isOffline = net.isOffline,
  }) : _firebaseAuth = firebaseAuth,
       _isOffline = isOffline;

  final FirebaseAuth _firebaseAuth;
  final Future<bool> Function() _isOffline;

  /// The provider SDKs report a broken sheet as a plain cancel when the
  /// network is down, so a failure is checked against reachability first.
  Future<AuthException> _socialSignInFailure({
    required bool cancelled,
    required String failureCode,
    required String message,
  }) async {
    if (await _isOffline()) {
      return AuthException(code: 'sign-in-offline', message: message);
    }
    return AuthException(
      code: cancelled ? authCodeSignInCancelled : failureCode,
      message: message,
    );
  }

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
    return _firebaseAuth.signInWithCredential(await _googleCredential());
  }

  Future<OAuthCredential> _googleCredential() async {
    await _ensureGoogleSignInInitialized();

    final GoogleSignInAccount account;
    try {
      account = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      throw await _socialSignInFailure(
        cancelled: e.code == GoogleSignInExceptionCode.canceled,
        failureCode: 'google-sign-in-failed',
        message: 'Google sign-in failed: ${e.description ?? e.code.name}',
      );
    }

    // Firebase authenticates with the Google ID token minted for the web
    // (server) client; initialize() sets that audience via serverClientId.
    final idToken = account.authentication.idToken;
    return GoogleAuthProvider.credential(idToken: idToken);
  }

  /// Apple embeds the nonce's hash in its ID token and Firebase checks the
  /// raw value against it, so a captured token cannot be replayed.
  Future<(AuthorizationCredentialAppleID, String)> _appleCredential(
    List<AppleIDAuthorizationScopes> scopes,
  ) async {
    final random = Random.secure();
    final rawNonce = base64Url.encode(
      List.generate(_nonceLength, (_) => random.nextInt(256)),
    );
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: scopes,
        nonce: sha256.convert(utf8.encode(rawNonce)).toString(),
      );
      return (credential, rawNonce);
    } on SignInWithAppleAuthorizationException catch (e) {
      throw await _socialSignInFailure(
        cancelled: e.code == AuthorizationErrorCode.canceled,
        failureCode: 'apple-sign-in-failed',
        message: 'Apple sign-in failed: ${e.code.name} ${e.message}',
      );
    }
  }

  Future<UserCredential> signInWithApple() async {
    final (appleCredential, rawNonce) = await _appleCredential([
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ]);

    final oauthCredential = OAuthProvider(_appleProviderId).credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode,
    );

    return _firebaseAuth.signInWithCredential(oauthCredential);
  }

  bool _hasProvider(String providerId) =>
      _firebaseAuth.currentUser?.providerData.any(
        (p) => p.providerId == providerId,
      ) ??
      false;

  /// Re-prompts the social provider so the server sees a recent sign-in;
  /// password users re-enter their password in the UI instead. Returns the
  /// fresh Apple authorization code on iOS, which revocation needs.
  Future<String?> reauthenticateWithSocialProvider() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw AuthException(code: 'no-user', message: 'No user signed in');
    }
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        _hasProvider(_appleProviderId)) {
      final (appleCredential, rawNonce) = await _appleCredential(const []);
      // No accessToken: the single-use code is kept for revocation.
      await user.reauthenticateWithCredential(
        OAuthProvider(_appleProviderId).credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
        ),
      );
      return appleCredential.authorizationCode;
    }
    if (_hasProvider(_googleProviderId) && !_hasProvider(_passwordProviderId)) {
      await user.reauthenticateWithCredential(await _googleCredential());
    }
    return null;
  }

  /// Mints a token carrying the latest sign-in time for the server.
  Future<void> refreshIdToken() async {
    await _firebaseAuth.currentUser?.getIdToken(true);
  }

  Future<void> revokeAppleSignIn(String authorizationCode) =>
      _firebaseAuth.revokeTokenWithAuthorizationCode(authorizationCode);

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
    final user = _firebaseAuth.currentUser;
    if (user == null) return;
    await user.reload();
    // Firestore rules read email_verified from the ID token, which
    // reload() leaves stale for up to an hour.
    await user.getIdToken(true);
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
