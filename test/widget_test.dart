// Widget tests for Seed app.
//
// This file contains basic smoke tests. For comprehensive widget tests, see:
// - test/features/auth/presentation/screens/login_screen_test.dart
// - test/features/sdg/presentation/screens/home_screen_test.dart
//
// Test setup uses:
// - fake_cloud_firestore for Firestore mocking
// - mocktail for FirebaseAuth mocking
// - See test/helpers/test_helpers.dart for shared utilities

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('basic MaterialApp smoke test', (tester) async {
    // Basic test to ensure Flutter test infrastructure is working
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: Center(child: Text('Seed App'))),
        ),
      ),
    );

    expect(find.text('Seed App'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('ProviderScope is properly initialized', (tester) async {
    // Verify Riverpod provider scope works correctly
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: _TestConsumerWidget())),
    );

    expect(find.text('Provider works!'), findsOneWidget);
  });
}

/// Simple consumer widget to verify Riverpod setup
class _TestConsumerWidget extends ConsumerWidget {
  const _TestConsumerWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(body: Center(child: Text('Provider works!')));
  }
}
