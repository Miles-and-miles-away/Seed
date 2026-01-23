import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/utils/auth_error_mapper.dart';

// Mock class for FirebaseAuthException
// ignore: avoid_implementing_value_types
class MockFirebaseAuthException extends Mock implements FirebaseAuthException {}

void main() {
  group('mapAuthErrorToMessage', () {
    late MockFirebaseAuthException mockError;

    setUp(() {
      mockError = MockFirebaseAuthException();
    });

    group('sign up errors', () {
      test('maps email-already-in-use', () {
        when(() => mockError.code).thenReturn('email-already-in-use');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(message, 'An account already exists with this email address.');
      });

      test('maps invalid-email', () {
        when(() => mockError.code).thenReturn('invalid-email');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(message, 'Please enter a valid email address.');
      });

      test('maps operation-not-allowed', () {
        when(() => mockError.code).thenReturn('operation-not-allowed');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(
          message,
          'This sign-in method is not enabled. Please contact support.',
        );
      });

      test('maps weak-password', () {
        when(() => mockError.code).thenReturn('weak-password');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(
          message,
          'Password is too weak. Please use at least 6 characters.',
        );
      });
    });

    group('sign in errors', () {
      test('maps user-disabled', () {
        when(() => mockError.code).thenReturn('user-disabled');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(
          message,
          'This account has been disabled. Please contact support.',
        );
      });

      test('maps user-not-found', () {
        when(() => mockError.code).thenReturn('user-not-found');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(message, 'No account found with this email address.');
      });

      test('maps wrong-password', () {
        when(() => mockError.code).thenReturn('wrong-password');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(message, 'Incorrect password. Please try again.');
      });

      test('maps invalid-credential', () {
        when(() => mockError.code).thenReturn('invalid-credential');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(message, 'Invalid email or password. Please try again.');
      });
    });

    group('rate limiting', () {
      test('maps too-many-requests', () {
        when(() => mockError.code).thenReturn('too-many-requests');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(
          message,
          'Too many attempts. Please wait a moment and try again.',
        );
      });
    });

    group('network errors', () {
      test('maps network-request-failed', () {
        when(() => mockError.code).thenReturn('network-request-failed');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(
          message,
          'Network error. Please check your internet connection.',
        );
      });
    });

    group('social sign-in errors', () {
      test('maps sign-in-cancelled', () {
        when(() => mockError.code).thenReturn('sign-in-cancelled');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(message, 'Sign-in was cancelled.');
      });

      test('maps account-exists-with-different-credential', () {
        when(() => mockError.code)
            .thenReturn('account-exists-with-different-credential');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(
          message,
          'An account already exists with this email using a different sign-in method.',
        );
      });
    });

    group('email verification errors', () {
      test('maps expired-action-code', () {
        when(() => mockError.code).thenReturn('expired-action-code');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(message, 'This link has expired. Please request a new one.');
      });

      test('maps invalid-action-code', () {
        when(() => mockError.code).thenReturn('invalid-action-code');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(message, 'This link is invalid. Please request a new one.');
      });
    });

    group('unknown errors', () {
      test('uses fallback message for unknown code', () {
        when(() => mockError.code).thenReturn('unknown-error-code');
        when(() => mockError.message).thenReturn('Custom fallback message');

        final message = mapAuthErrorToMessage(mockError);

        expect(message, 'Custom fallback message');
      });

      test('uses default message when no fallback provided', () {
        when(() => mockError.code).thenReturn('unknown-error-code');
        when(() => mockError.message).thenReturn(null);

        final message = mapAuthErrorToMessage(mockError);

        expect(message, 'An error occurred. Please try again.');
      });

      test('returns generic message for non-FirebaseAuthException', () {
        final error = Exception('Some other error');
        final message = mapAuthErrorToMessage(error);

        expect(message, 'An unexpected error occurred. Please try again.');
      });

      test('returns generic message for string error', () {
        const error = 'String error';
        final message = mapAuthErrorToMessage(error);

        expect(message, 'An unexpected error occurred. Please try again.');
      });
    });
  });
}
