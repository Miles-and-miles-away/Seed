import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/auth_error_mapper.dart';

// Mock class for FirebaseAuthException
// ignore: avoid_implementing_value_types
class MockFirebaseAuthException extends Mock implements FirebaseAuthException {}

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));
  late MockFirebaseAuthException mockError;

  MockFirebaseAuthException errorWithCode(String code) {
    when(() => mockError.code).thenReturn(code);
    when(() => mockError.message).thenReturn(null);
    return mockError;
  }

  setUp(() {
    mockError = MockFirebaseAuthException();
  });

  group('mapAuthErrorToMessage', () {
    group('sign up errors', () {
      test('maps email-already-in-use', () {
        expect(
          mapAuthErrorToMessage(errorWithCode('email-already-in-use'), l10n),
          l10n.errorAuthEmailInUse,
        );
      });

      test('maps invalid-email', () {
        expect(
          mapAuthErrorToMessage(errorWithCode('invalid-email'), l10n),
          l10n.errorAuthInvalidEmail,
        );
      });

      test('maps operation-not-allowed', () {
        expect(
          mapAuthErrorToMessage(errorWithCode('operation-not-allowed'), l10n),
          l10n.errorAuthOperationNotAllowed,
        );
      });

      test('maps weak-password', () {
        expect(
          mapAuthErrorToMessage(errorWithCode('weak-password'), l10n),
          l10n.errorAuthWeakPassword,
        );
      });
    });

    group('sign in errors', () {
      test('maps user-disabled', () {
        expect(
          mapAuthErrorToMessage(errorWithCode('user-disabled'), l10n),
          l10n.errorAuthUserDisabled,
        );
      });

      test('collapses user-not-found, wrong-password and invalid-credential '
          'into one shared message (no account enumeration)', () {
        // Same message for all three so responses never reveal whether
        // an email is registered.
        const codes = [
          'user-not-found',
          'wrong-password',
          'invalid-credential',
        ];
        for (final code in codes) {
          expect(
            mapAuthErrorToMessage(errorWithCode(code), l10n),
            l10n.errorAuthInvalidCredentials,
            reason: 'code: $code',
          );
        }
        expect(
          l10n.errorAuthInvalidCredentials,
          'Invalid email or password. Please try again.',
        );
      });
    });

    group('rate limiting', () {
      test('maps too-many-requests', () {
        expect(
          mapAuthErrorToMessage(errorWithCode('too-many-requests'), l10n),
          l10n.errorAuthTooManyRequests,
        );
      });
    });

    group('network errors', () {
      test('maps network-request-failed', () {
        expect(
          mapAuthErrorToMessage(errorWithCode('network-request-failed'), l10n),
          l10n.errorAuthNetwork,
        );
      });
    });

    group('social sign-in errors', () {
      test('maps sign-in-cancelled', () {
        expect(
          mapAuthErrorToMessage(errorWithCode('sign-in-cancelled'), l10n),
          l10n.errorAuthSignInCancelled,
        );
      });

      test('maps account-exists-with-different-credential', () {
        expect(
          mapAuthErrorToMessage(
            errorWithCode('account-exists-with-different-credential'),
            l10n,
          ),
          l10n.errorAuthAccountExistsWithDifferentCredential,
        );
      });
    });

    group('email verification errors', () {
      test('maps expired-action-code', () {
        expect(
          mapAuthErrorToMessage(errorWithCode('expired-action-code'), l10n),
          l10n.errorAuthLinkExpired,
        );
      });

      test('maps invalid-action-code', () {
        expect(
          mapAuthErrorToMessage(errorWithCode('invalid-action-code'), l10n),
          l10n.errorAuthLinkInvalid,
        );
      });
    });

    group('unknown errors', () {
      test('never surfaces raw Firebase text for unknown codes', () {
        when(() => mockError.code).thenReturn('unknown-error-code');
        when(() => mockError.message).thenReturn('Raw Firebase message');

        final message = mapAuthErrorToMessage(mockError, l10n);

        expect(message, l10n.errorGeneric);
        expect(message, isNot(contains('Raw Firebase message')));
      });

      test('returns generic message for non-FirebaseAuthException', () {
        expect(
          mapAuthErrorToMessage(Exception('Some other error'), l10n),
          l10n.errorGeneric,
        );
      });

      test('returns generic message for string error', () {
        expect(mapAuthErrorToMessage('String error', l10n), l10n.errorGeneric);
      });
    });

    group('localization', () {
      test('returns Japanese messages for the ja locale', () {
        final l10nJa = lookupAppLocalizations(const Locale('ja'));

        expect(
          mapAuthErrorToMessage(errorWithCode('wrong-password'), l10nJa),
          l10nJa.errorAuthInvalidCredentials,
        );
        expect(
          l10nJa.errorAuthInvalidCredentials,
          isNot(l10n.errorAuthInvalidCredentials),
        );
      });

      test('returns Spanish messages for the es locale', () {
        final l10nEs = lookupAppLocalizations(const Locale('es'));

        expect(
          mapAuthErrorToMessage(errorWithCode('weak-password'), l10nEs),
          l10nEs.errorAuthWeakPassword,
        );
        expect(l10nEs.errorAuthWeakPassword, isNot(l10n.errorAuthWeakPassword));
      });
    });
  });
}
