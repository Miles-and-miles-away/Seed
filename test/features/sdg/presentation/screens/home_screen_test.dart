import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/sdg/presentation/screens/home_screen.dart';

void main() {
  group('HomeScreen', () {
    // Helper to pump widget and wait for initial frame
    // Note: We use pump() instead of pumpAndSettle() because the SDG carousel
    // contains CachedNetworkImage with CircularProgressIndicator placeholders
    // that never settle due to infinite animations.
    Future<void> pumpHomeScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
      // Allow time for the initial frame to render
      await tester.pump();
    }

    testWidgets('renders app title and logo', (tester) async {
      await pumpHomeScreen(tester);

      // Verify app bar elements
      expect(find.text('Seed'), findsOneWidget);
      expect(find.byIcon(Icons.eco), findsAtLeast(1));
    });

    testWidgets('displays welcome hero section', (tester) async {
      await pumpHomeScreen(tester);

      // Verify hero section content
      expect(find.textContaining('Welcome to Seed'), findsOneWidget);
      expect(
        find.textContaining('Every small action grows into something amazing'),
        findsOneWidget,
      );
      expect(find.text('Small steps, big impact!'), findsOneWidget);
    });

    testWidgets('displays SDG section header', (tester) async {
      await pumpHomeScreen(tester);

      // Verify SDG section
      expect(find.text('Explore the Goals'), findsOneWidget);
      expect(
        find.text('Tap to learn about the UN Sustainable Development Goals'),
        findsOneWidget,
      );
    });

    testWidgets('displays SDG carousel', (tester) async {
      await pumpHomeScreen(tester);

      // The SDG carousel should be present (contains SDG items)
      // Looking for SDG goal indicators - there should be 17 goals
      // At least some should be visible in the carousel
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('hero section has proper styling', (tester) async {
      await pumpHomeScreen(tester);

      // Find the hero container (has gradient decoration)
      final heroContainer = find.ancestor(
        of: find.textContaining('Welcome to Seed'),
        matching: find.byType(Container),
      );
      expect(heroContainer, findsAtLeast(1));
    });

    testWidgets('app bar is floating', (tester) async {
      await pumpHomeScreen(tester);

      // Verify SliverAppBar exists
      expect(find.byType(SliverAppBar), findsOneWidget);

      // Verify it's configured as floating
      final sliverAppBar =
          tester.widget<SliverAppBar>(find.byType(SliverAppBar));
      expect(sliverAppBar.floating, isTrue);
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
      expect(find.text('Explore the Goals'), findsOneWidget);
    });

    testWidgets('uses SafeArea for proper padding', (tester) async {
      await pumpHomeScreen(tester);

      // Verify SafeArea is used (may be multiple in widget tree)
      expect(find.byType(SafeArea), findsAtLeast(1));
    });

    testWidgets('app bar title is centered', (tester) async {
      await pumpHomeScreen(tester);

      final sliverAppBar =
          tester.widget<SliverAppBar>(find.byType(SliverAppBar));
      expect(sliverAppBar.centerTitle, isTrue);
    });
  });
}
