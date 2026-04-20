import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/validators.dart';

void main() {
  String? run(String? input) => validateEmail(
        input,
        emptyError: 'empty',
        invalidError: 'invalid',
      );

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

    test('trims leading and trailing whitespace before matching', () {
      expect(run('  alice@example.com '), isNull);
    });

    test('rejects TLDs shorter than 2 characters', () {
      expect(run('alice@example.c'), 'invalid');
    });

    test('rejects unicode-only local part (regex is ASCII-only)', () {
      expect(run('日本@example.com'), 'invalid');
    });
  });
}
