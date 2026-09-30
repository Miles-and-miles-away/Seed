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

  testWidgets('permission-denied reads as the rate limit', (tester) async {
    expect(
      await messageFor(
        tester,
        FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
      ),
      'Please wait a few seconds between actions.',
    );
  });

  testWidgets('anything else reads as the generic error', (tester) async {
    expect(
      await messageFor(tester, Exception('boom')),
      'Something went wrong. Please try again.',
    );
  });
}
