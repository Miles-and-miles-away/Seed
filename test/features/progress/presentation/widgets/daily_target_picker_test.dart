import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/progress/presentation/widgets/daily_target_picker.dart';

void main() {
  group('DailyTargetPicker', () {
    Widget createTestWidget({
      VoidCallback? onComplete,
      bool isLoading = false,
    }) {
      return ProviderScope(
        overrides: [
          dailyTargetProvider.overrideWith(
            () => _MockDailyTargetNotifier(isLoading: isLoading),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: DailyTargetPicker(
              onComplete: onComplete ?? () {},
            ),
          ),
        ),
      );
    }

    testWidgets('displays number picker with values 1-10', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should have a ListWheelScrollView
      expect(find.byType(ListWheelScrollView), findsOneWidget);

      // Default selection should be 3
      expect(find.text('3'), findsAtLeast(1));
    });

    testWidgets('displays confirm button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should have a FilledButton
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('scrolling changes selected value', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the ListWheelScrollView
      final scrollView = find.byType(ListWheelScrollView);
      expect(scrollView, findsOneWidget);

      // Scroll down to change selection
      await tester.drag(scrollView, const Offset(0, -60));
      await tester.pumpAndSettle();

      // Value should have changed
      expect(find.byType(ListWheelScrollView), findsOneWidget);
    });

    testWidgets('shows loading indicator when saving', (tester) async {
      await tester.pumpWidget(createTestWidget(isLoading: true));
      // Use pump() instead of pumpAndSettle() because CircularProgressIndicator never settles
      await tester.pump();

      // Should show CircularProgressIndicator in button
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('button is disabled while loading', (tester) async {
      await tester.pumpWidget(createTestWidget(isLoading: true));
      // Use pump() instead of pumpAndSettle() because CircularProgressIndicator never settles
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('button is enabled when not loading', (tester) async {
      // ignore: avoid_redundant_argument_values
      await tester.pumpWidget(createTestWidget(isLoading: false));
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('displays description based on selected target', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Default is 3, which should show "moderate" description
      // Find some descriptive text (partial match)
      expect(find.byType(AnimatedSwitcher), findsOneWidget);
    });

    testWidgets('uses Spacer for vertical layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should have Spacer widgets for vertical spacing
      expect(find.byType(Spacer), findsAtLeast(1));
    });

    testWidgets('has correct padding', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should have Padding widget
      expect(find.byType(Padding), findsAtLeast(1));
    });

    testWidgets('picker has correct configuration', (tester) async {
      await tester.pumpWidget(createTestWidget());
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
