import 'package:firebase_auth/firebase_auth.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// Maps Firebase Auth errors to localized, user-friendly messages.
///
/// Unknown codes and non-auth errors fall back to the localized generic
/// message; raw Firebase exception text is never shown to users.
String mapAuthErrorToMessage(Object error, AppLocalizations l10n) {
  final code = switch (error) {
    FirebaseAuthException(:final code) => code,
    AuthException(:final code) => code,
    _ => null,
  };
  return code == null ? l10n.errorGeneric : _mapAuthCode(code, l10n);
}

String _mapAuthCode(String code, AppLocalizations l10n) {
  switch (code) {
    // Sign up errors
    case 'email-already-in-use':
      return l10n.errorAuthEmailInUse;
    case 'invalid-email':
      return l10n.errorAuthInvalidEmail;
    case 'operation-not-allowed':
      return l10n.errorAuthOperationNotAllowed;
    case 'weak-password':
      return l10n.errorAuthWeakPassword;

    // Sign in errors. user-not-found and wrong-password collapse into
    // one message so responses never reveal whether an email is
    // registered (account enumeration).
    case 'user-disabled':
      return l10n.errorAuthUserDisabled;
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return l10n.errorAuthInvalidCredentials;

    // Rate limiting
    case 'too-many-requests':
      return l10n.errorAuthTooManyRequests;

    // Network errors
    case 'network-request-failed':
      return l10n.errorAuthNetwork;

    // Social sign-in errors
    case 'sign-in-cancelled':
      return l10n.errorAuthSignInCancelled;
    case 'account-exists-with-different-credential':
      return l10n.errorAuthAccountExistsWithDifferentCredential;

    // Email verification
    case 'expired-action-code':
      return l10n.errorAuthLinkExpired;
    case 'invalid-action-code':
      return l10n.errorAuthLinkInvalid;

    default:
      return l10n.errorGeneric;
  }
}

/// Custom exception for auth errors to provide consistent error handling.
class AuthException implements Exception {
  AuthException({required this.code, this.message});

  final String code;
  final String? message;

  @override
  String toString() => 'AuthException: [$code] $message';
}
