import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/home/presentation/providers/home_providers.dart';
import 'package:seed_app/features/home/presentation/screens/home_screen.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';

import '../../../../helpers/test_helpers.dart';

/// Stubs the router-backed visit signal so the home screen can be pumped in
/// isolation without initializing Firebase (the real provider reads the
/// router, which requires a Firebase app).
class _StubHomeVisitSignal extends HomeVisitSignal {
  @override
  int build() => 0;
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    stubPathProvider();
  });

  group('HomeScreen', () {
    // Helper to pump widget and wait for initial frame
    // Note: We use pump() instead of pumpAndSettle() because the SDG carousel
    // and MascotAvatar contain infinite animations that never settle.
    Future<void> pumpHomeScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Mock hasMascotProvider to return false (show mascot selection prompt)
            hasMascotProvider.overrideWithValue(false),
            homeVisitSignalProvider.overrideWith(_StubHomeVisitSignal.new),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HomeScreen(),
          ),
        ),
      );
      // Allow time for the initial frame to render
      await tester.pump();
    }

    // Dispose the widget tree and flush pending timers
    // flutter_animate creates zero-duration timers that need to be processed
    Future<void> disposeAndFlush(WidgetTester tester) async {
      // Replace widget tree to trigger dispose
      await tester.pumpWidget(const SizedBox.shrink());
      // Pump to process any zero-duration timers from flutter_animate
      // The animations schedule callbacks that need time to complete
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    testWidgets('renders app title and logo', (tester) async {
      await pumpHomeScreen(tester);

      // Verify app bar elements - 'Seed' is the app title from l10n
      expect(find.text('Seed'), findsOneWidget);
      expect(find.byIcon(Icons.eco), findsAtLeast(1));

      await disposeAndFlush(tester);
    });

    testWidgets('displays mascot selection prompt when no mascot', (
      tester,
    ) async {
      await pumpHomeScreen(tester);

      // Verify mascot selection prompt is shown (uses localized strings)
      // The button has a pets icon
      expect(find.byIcon(Icons.pets), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('displays SDG section header', (tester) async {
      await pumpHomeScreen(tester);

      // Verify SDG section
      expect(find.text('Explore the SDG Goals'), findsOneWidget);
      expect(
        find.text('Tap to learn about the UN Sustainable Development Goals'),
        findsOneWidget,
      );

      await disposeAndFlush(tester);
    });

    testWidgets('displays my goal prompt card when no goal set', (
      tester,
    ) async {
      await pumpHomeScreen(tester);

      expect(find.text('My Goal'), findsOneWidget);
      expect(find.text('Tap to set your sustainability goal'), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('displays SDG carousel', (tester) async {
      await pumpHomeScreen(tester);

      // The SDG carousel should be present (contains SDG items)
      // Looking for SDG goal indicators - there should be 17 goals
      // At least some should be visible in the carousel
      expect(find.byType(CustomScrollView), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('mascot selection has proper styling', (tester) async {
      await pumpHomeScreen(tester);

      // Find the mascot selection container (has gradient decoration)
      final mascotContainer = find.ancestor(
        of: find.byIcon(Icons.pets),
        matching: find.byType(Container),
      );
      expect(mascotContainer, findsAtLeast(1));

      await disposeAndFlush(tester);
    });

    testWidgets('app bar is floating', (tester) async {
      await pumpHomeScreen(tester);

      // Verify SliverAppBar exists
      expect(find.byType(SliverAppBar), findsOneWidget);

      // Verify it's configured as floating
      final sliverAppBar = tester.widget<SliverAppBar>(
        find.byType(SliverAppBar),
      );
      expect(sliverAppBar.floating, isTrue);

      await disposeAndFlush(tester);
    });

    testWidgets('scrolls content properly', (tester) async {
      await pumpHomeScreen(tester);

      // Verify CustomScrollView is present and can scroll
      expect(find.byType(CustomScrollView), findsOneWidget);

      // Perform a scroll gesture
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      // Use pump instead of pumpAndSettle to avoid infinite animation timeout
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Content should still be visible after scrolling
      expect(find.text('Explore the SDG Goals'), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('uses SafeArea for proper padding', (tester) async {
      await pumpHomeScreen(tester);

      // Verify SafeArea is used (may be multiple in widget tree)
      expect(find.byType(SafeArea), findsAtLeast(1));

      await disposeAndFlush(tester);
    });

    testWidgets('app bar title is centered', (tester) async {
      await pumpHomeScreen(tester);

      final sliverAppBar = tester.widget<SliverAppBar>(
        find.byType(SliverAppBar),
      );
      expect(sliverAppBar.centerTitle, isTrue);

      await disposeAndFlush(tester);
    });
  });
}
