import 'package:firebase_auth/firebase_auth.dart';

/// Maps Firebase Auth errors to user-friendly messages.
String mapAuthErrorToMessage(Object error) {
  if (error is FirebaseAuthException) {
    return _mapFirebaseAuthCode(error.code, error.message);
  }
  return 'An unexpected error occurred. Please try again.';
}

String _mapFirebaseAuthCode(String code, String? fallbackMessage) {
  switch (code) {
    // Sign up errors
    case 'email-already-in-use':
      return 'An account already exists with this email address.';
    case 'invalid-email':
      return 'Please enter a valid email address.';
    case 'operation-not-allowed':
      return 'This sign-in method is not enabled. Please contact support.';
    case 'weak-password':
      return 'Password is too weak. Please use at least 6 characters.';

    // Sign in errors
    case 'user-disabled':
      return 'This account has been disabled. Please contact support.';
    case 'user-not-found':
      return 'No account found with this email address.';
    case 'wrong-password':
      return 'Incorrect password. Please try again.';
    case 'invalid-credential':
      return 'Invalid email or password. Please try again.';

    // Rate limiting
    case 'too-many-requests':
      return 'Too many attempts. Please wait a moment and try again.';

    // Network errors
    case 'network-request-failed':
      return 'Network error. Please check your internet connection.';

    // Social sign-in errors
    case 'sign-in-cancelled':
      return 'Sign-in was cancelled.';
    case 'account-exists-with-different-credential':
      return 'An account already exists with this email using a different sign-in method.';

    // Email verification
    case 'expired-action-code':
      return 'This link has expired. Please request a new one.';
    case 'invalid-action-code':
      return 'This link is invalid. Please request a new one.';

    default:
      return fallbackMessage ?? 'An error occurred. Please try again.';
  }
}
