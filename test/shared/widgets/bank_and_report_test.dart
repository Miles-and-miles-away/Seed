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
