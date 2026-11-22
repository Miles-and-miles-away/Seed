import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/shared/widgets/bank_and_report.dart';

import '../../helpers/test_helpers.dart';

void main() {
  Future<void> bankWith(
    WidgetTester tester,
    List<AsyncValue<void>> outcomes, {
    required VoidCallback onSuccess,
  }) async {
    await tester.pumpWidget(
      createTestWidget(
        scaffold: true,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => bankAndReport(
              context,
              log: () async => outcomes.removeAt(0),
              successMessage: 'Banked',
              onSuccess: onSuccess,
            ),
            child: const Text('bank'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('bank'));
    await tester.pumpAndSettle();
  }

  testWidgets('offline Retry banks again', (tester) async {
    var successes = 0;
    await bankWith(tester, [
      AsyncValue.error(
        FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
        StackTrace.empty,
      ),
      const AsyncValue.data(null),
    ], onSuccess: () => successes++);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(successes, 1);
    expect(find.text('Banked'), findsOneWidget);
  });

  testWidgets('Retry after its screen closed repeats the error', (
    tester,
  ) async {
    var attempts = 0;
    await tester.pumpWidget(
      createTestWidget(
        scaffold: true,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => Scaffold(
                  body: Builder(
                    builder: (context) => ElevatedButton(
                      onPressed: () => bankAndReport(
                        context,
                        log: () async {
                          attempts++;
                          return AsyncValue.error(
                            FirebaseException(
                              plugin: 'cloud_firestore',
                              code: 'unavailable',
                            ),
                            StackTrace.empty,
                          );
                        },
                        successMessage: 'Banked',
                        onSuccess: () {},
                      ),
                      child: const Text('bank'),
                    ),
                  ),
                ),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('bank'));
    await tester.pumpAndSettle();
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(attempts, 1);
    expect(find.textContaining('while offline'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('a later bank clears a stale Retry', (tester) async {
    var successes = 0;
    await bankWith(tester, [
      AsyncValue.error(
        FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
        StackTrace.empty,
      ),
      const AsyncValue.data(null),
    ], onSuccess: () => successes++);

    await tester.tap(find.text('bank'));
    await tester.pumpAndSettle();

    expect(successes, 1);
    expect(find.text('Banked'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('the offline message times out', (tester) async {
    await bankWith(tester, [
      AsyncValue.error(
        FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
        StackTrace.empty,
      ),
    ], onSuccess: () {});

    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();

    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('a non-offline error offers no Retry', (tester) async {
    await bankWith(tester, [
      AsyncValue.error(Exception('boom'), StackTrace.empty),
    ], onSuccess: () {});

    expect(
      find.text('Something went wrong. Please try again.'),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsNothing);
  });
}
