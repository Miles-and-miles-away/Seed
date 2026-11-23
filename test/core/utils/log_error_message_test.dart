import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/log_error_message.dart';

import '../../helpers/test_helpers.dart';

void main() {
  Future<String> messageFor(WidgetTester tester, Object? error) async {
    late String message;
    await tester.pumpWidget(
      createTestWidget(
        locale: const Locale('en'),
        child: Builder(
          builder: (context) {
            message = logErrorMessage(context, error);
            return const SizedBox();
          },
        ),
      ),
    );
    return message;
  }

  testWidgets('a timeout reads as offline', (tester) async {
    expect(
      await messageFor(tester, TimeoutException('slow')),
      'Cannot log an action while offline. Check your connection and try again.',
    );
  });

  testWidgets('unavailable reads as offline', (tester) async {
    expect(
      await messageFor(
        tester,
        FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
      ),
      'Cannot log an action while offline. Check your connection and try again.',
    );
  });

  testWidgets('deadline-exceeded reads as offline', (tester) async {
    expect(
      await messageFor(
        tester,
        FirebaseException(plugin: 'cloud_firestore', code: 'deadline-exceeded'),
      ),
      'Cannot log an action while offline. Check your connection and try again.',
    );
  });

  testWidgets('a dropped stream reads as offline', (tester) async {
    expect(
      await messageFor(
        tester,
        FirebaseException(
          plugin: 'cloud_firestore',
          code: 'unknown',
          message: 'Stream removed',
        ),
      ),
      'Cannot log an action while offline. Check your connection and try again.',
    );
  });

  final denied = FirebaseException(
    plugin: 'cloud_firestore',
    code: 'permission-denied',
  );

  testWidgets('permission-denied with no recent log names both causes', (
    tester,
  ) async {
    expect(
      await messageFor(tester, denied),
      'This action could not be logged. Wait a few seconds and try again. '
      "If it fails again, check that your device's date and time are set "
      'automatically.',
    );
  });

  testWidgets('permission-denied right after a log reads as the rate limit', (
    tester,
  ) async {
    markActionLogged();
    expect(
      await messageFor(tester, denied),
      'Please wait a few seconds between actions.',
    );
  });

  testWidgets('a saving above the cap names the limit', (tester) async {
    expect(
      await messageFor(tester, const SavingTooLargeException()),
      'A saving above 100 t is too large to log as one action. '
      'Check the distances and amounts.',
    );
  });

  testWidgets('anything else reads as the generic error', (tester) async {
    expect(
      await messageFor(tester, Exception('boom')),
      'Something went wrong. Please try again.',
    );
  });

  test('the cooldown counts down the rules gap after a log', () {
    markActionLogged();
    final left = actionLogCooldown();
    expect(left, greaterThan(const Duration(seconds: 4)));
    expect(left, lessThanOrEqualTo(const Duration(seconds: 5)));
  });
}
