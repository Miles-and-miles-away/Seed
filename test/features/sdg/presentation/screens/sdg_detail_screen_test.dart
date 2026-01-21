import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/sdg/presentation/screens/sdg_detail_screen.dart';

void main() {
  group('SdgDetailScreen', () {
    // Helper to set screen size large enough to avoid overflow
    void setLargeScreenSize(WidgetTester tester) {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
    }

    testWidgets('displays goal 1 correctly', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      // Use pump instead of pumpAndSettle due to CachedNetworkImage loading
      await tester.pump();

      // Verify goal 1 content
      expect(find.text('No Poverty'), findsOneWidget);
      expect(find.text('Goal 1'), findsOneWidget);
      expect(find.text('UN SDG'), findsOneWidget);
    });

    testWidgets('displays goal 13 Climate Action correctly', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 13),
        ),
      );
      await tester.pump();

      // Verify goal 13 content
      expect(find.text('Climate Action'), findsOneWidget);
      expect(find.text('Goal 13'), findsOneWidget);
    });

    testWidgets('displays SliverAppBar', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      await tester.pump();

      expect(find.byType(SliverAppBar), findsOneWidget);
    });

    testWidgets('displays CustomScrollView', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      await tester.pump();

      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('displays About this Goal section', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      await tester.pump();

      expect(find.text('About this Goal'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('displays Learn More button', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      await tester.pump();

      expect(find.text('Learn More at UN.org'), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    });

    testWidgets('displays Take Action section', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      await tester.pump();

      expect(find.text('Take Action!'), findsOneWidget);
      expect(find.byIcon(Icons.eco), findsAtLeast(1));
    });

    testWidgets('displays action encouragement text', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      await tester.pump();

      expect(
        find.textContaining('Log eco-friendly actions'),
        findsOneWidget,
      );
    });

    testWidgets('renders Hero widget for animation', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      await tester.pump();

      expect(find.byType(Hero), findsOneWidget);
    });

    testWidgets('renders goal badge container', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 5),
        ),
      );
      await tester.pump();

      // Verify goal 5 badge
      expect(find.text('Goal 5'), findsOneWidget);
      expect(find.text('Gender Equality'), findsOneWidget);
    });

    testWidgets('renders FlexibleSpaceBar in app bar', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      await tester.pump();

      expect(find.byType(FlexibleSpaceBar), findsOneWidget);
    });

    testWidgets('displays learn more button with text', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      await tester.pump();

      // FilledButton.icon is a FilledButton factory, verify by finding the text and icon
      expect(find.text('Learn More at UN.org'), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    });

    testWidgets('defaults to first goal if invalid number provided',
        (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 99),
        ),
      );
      await tester.pump();

      // Should fall back to goal 1
      expect(find.text('No Poverty'), findsOneWidget);
    });

    testWidgets('displays goal 17 correctly', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 17),
        ),
      );
      await tester.pump();

      // Verify goal 17 content
      expect(find.text('Partnerships for the Goals'), findsOneWidget);
      expect(find.text('Goal 17'), findsOneWidget);
    });

    testWidgets('app bar is pinned', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      await tester.pump();

      final sliverAppBar =
          tester.widget<SliverAppBar>(find.byType(SliverAppBar));
      expect(sliverAppBar.pinned, isTrue);
    });

    testWidgets('app bar has correct expanded height', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      await tester.pump();

      final sliverAppBar =
          tester.widget<SliverAppBar>(find.byType(SliverAppBar));
      expect(sliverAppBar.expandedHeight, 200);
    });

    testWidgets('renders ClipRRect for image border radius', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      await tester.pump();

      expect(find.byType(ClipRRect), findsAtLeast(1));
    });

    testWidgets('description is contained in styled container', (tester) async {
      setLargeScreenSize(tester);

      await tester.pumpWidget(
        const MaterialApp(
          home: SdgDetailScreen(goalNumber: 1),
        ),
      );
      await tester.pump();

      // Description section should have containers with decoration
      expect(find.byType(Container), findsWidgets);
    });
  });
}
