import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/validators.dart';

void main() {
  String? run(String? input) =>
      validateEmail(input, emptyError: 'empty', invalidError: 'invalid');

  group('validateEmail', () {
    test('returns empty error for null', () {
      expect(run(null), 'empty');
    });

    test('returns empty error for empty or whitespace-only string', () {
      expect(run(''), 'empty');
      expect(run('   '), 'empty');
    });

    test('returns invalid error for missing @', () {
      expect(run('alice.example.com'), 'invalid');
    });

    test('returns invalid error for missing domain', () {
      expect(run('alice@'), 'invalid');
    });

    test('returns invalid error for missing TLD', () {
      expect(run('alice@example'), 'invalid');
    });

    test('accepts standard addresses', () {
      expect(run('alice@example.com'), isNull);
      expect(run('bob.smith@example.co.uk'), isNull);
      expect(run('user-name@sub.example.com'), isNull);
    });

    test('accepts TLDs longer than 4 characters', () {
      expect(run('user@example.email'), isNull);
      expect(run('curator@example.museum'), isNull);
      expect(run('studio@example.design'), isNull);
    });

    test('trims leading and trailing whitespace before matching', () {
      expect(run('  alice@example.com '), isNull);
      // A trailing autocomplete space must not fail validation.
      expect(run('alice@example.com '), isNull);
    });

    test('still rejects malformed addresses', () {
      expect(run('user@example.'), 'invalid');
      expect(run('user@@example.com'), 'invalid');
      expect(run('user name@example.com'), 'invalid');
    });

    test('rejects TLDs shorter than 2 characters', () {
      expect(run('alice@example.c'), 'invalid');
    });

    test('rejects unicode-only local part (regex is ASCII-only)', () {
      expect(run('日本@example.com'), 'invalid');
    });
  });

  group('validatePassword', () {
    String? runPassword(String? input) =>
        validatePassword(input, emptyError: 'empty', shortError: 'short');

    test('returns empty error for null or empty', () {
      expect(runPassword(null), 'empty');
      expect(runPassword(''), 'empty');
    });

    test('rejects five characters and accepts six', () {
      expect(runPassword('abcde'), 'short');
      expect(runPassword('abcdef'), isNull);
    });
  });
}
