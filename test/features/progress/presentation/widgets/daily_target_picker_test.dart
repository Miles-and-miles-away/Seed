import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/progress/presentation/widgets/daily_target_picker.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('DailyTargetPicker', () {
    Widget buildTestWidget({VoidCallback? onComplete, bool isLoading = false}) {
      return createTestWidget(
        scaffold: true,
        overrides: [
          dailyTargetProvider.overrideWith(
            () => _MockDailyTargetNotifier(isLoading: isLoading),
          ),
        ],
        child: DailyTargetPicker(onComplete: onComplete ?? () {}),
      );
    }

    testWidgets('displays number picker with values 1-10', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should have a ListWheelScrollView
      expect(find.byType(ListWheelScrollView), findsOneWidget);

      // Default selection should be 3
      expect(find.text('3'), findsAtLeast(1));
    });

    testWidgets('scrolling changes the selected target and its description', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(
        find.text('A balanced challenge — recommended for most users.'),
        findsOneWidget,
      );

      // Two item extents down: 3 -> 5.
      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, -120),
      );
      await tester.pumpAndSettle();

      expect(
        find.text("Ambitious! You're committed to making an impact."),
        findsOneWidget,
      );
    });

    testWidgets('shows loading indicator when saving', (tester) async {
      await tester.pumpWidget(buildTestWidget(isLoading: true));
      // Use pump() instead of pumpAndSettle() because CircularProgressIndicator never settles
      await tester.pump();

      // Should show CircularProgressIndicator in button
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('button is disabled while loading', (tester) async {
      await tester.pumpWidget(buildTestWidget(isLoading: true));
      // Use pump() instead of pumpAndSettle() because CircularProgressIndicator never settles
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('button is enabled when not loading', (tester) async {
      // ignore: avoid_redundant_argument_values
      await tester.pumpWidget(buildTestWidget(isLoading: false));
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('displays description based on selected target', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.text('A balanced challenge — recommended for most users.'),
        findsOneWidget,
      );
    });

    testWidgets('picker has correct configuration', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify ListWheelScrollView exists
      final scrollView = tester.widget<ListWheelScrollView>(
        find.byType(ListWheelScrollView),
      );

      // Check configuration
      expect(scrollView.itemExtent, 60);
      expect(scrollView.physics, isA<FixedExtentScrollPhysics>());
    });
  });
}

/// Mock notifier for testing
class _MockDailyTargetNotifier extends DailyTargetNotifier {
  _MockDailyTargetNotifier({this.isLoading = false});

  final bool isLoading;

  @override
  AsyncValue<void> build() =>
      isLoading ? const AsyncValue.loading() : const AsyncValue.data(null);

  @override
  Future<void> saveTarget(int target) async {
    // No-op for testing
  }
}
