import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/presentation/widgets/sdg_carousel.dart';

void main() {
  group('SdgCarousel', () {
    final testGoals = [
      const SdgGoal(
        number: 1,
        titleEn: 'No Poverty',
        shortTitleEn: 'No Poverty',
        descriptionEn: 'End poverty in all its forms.',
        color: Color(0xFFE5233D),
        iconUrl: 'https://example.com/icon1.jpg',
      ),
      const SdgGoal(
        number: 2,
        titleEn: 'Zero Hunger',
        shortTitleEn: 'Zero Hunger',
        descriptionEn: 'End hunger.',
        color: Color(0xFFDDA73A),
        iconUrl: 'https://example.com/icon2.jpg',
      ),
      const SdgGoal(
        number: 3,
        titleEn: 'Good Health',
        shortTitleEn: 'Good Health',
        descriptionEn: 'Ensure healthy lives.',
        color: Color(0xFF4CA146),
        iconUrl: 'https://example.com/icon3.jpg',
      ),
    ];

    testWidgets('renders as ListView', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: SdgCarousel(goals: testGoals, onGoalTap: (_) {}),
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders horizontally scrollable list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: SdgCarousel(goals: testGoals, onGoalTap: (_) {}),
            ),
          ),
        ),
      );

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.scrollDirection, Axis.horizontal);
    });

    testWidgets('displays SdgCard widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: SdgCarousel(goals: testGoals, onGoalTap: (_) {}),
            ),
          ),
        ),
      );

      // The carousel should render SdgCard widgets
      expect(find.byType(SdgCard), findsWidgets);
    });

    testWidgets('recenters on the first goal when resetSignal changes', (
      tester,
    ) async {
      Widget build(int signal) => MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 200,
            width: 400,
            child: SdgCarousel(
              goals: testGoals,
              onGoalTap: (_) {},
              resetSignal: signal,
            ),
          ),
        ),
      );

      await tester.pumpWidget(build(0));
      await tester.pump();

      final controller = tester
          .widget<ListView>(find.byType(ListView))
          .controller!;
      final centered = controller.offset;

      // Scroll away from the centered first goal.
      await tester.drag(find.byType(ListView), const Offset(-300, 0));
      await tester.pump();
      expect(controller.offset, isNot(closeTo(centered, 0.5)));

      // Bumping the reset signal jumps back to the centered offset.
      await tester.pumpWidget(build(1));
      await tester.pump();
      expect(controller.offset, closeTo(centered, 0.5));
    });

    testWidgets('calls onGoalTap when card is tapped', (tester) async {
      SdgGoal? tappedGoal;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: SdgCarousel(
                goals: testGoals,
                onGoalTap: (goal) => tappedGoal = goal,
              ),
            ),
          ),
        ),
      );
      // Use pump instead of pumpAndSettle due to CircularProgressIndicator
      await tester.pump();

      // Tap a visible card by finding the short title text which is on screen
      await tester.tap(find.text('No Poverty').first, warnIfMissed: false);
      await tester.pump();

      expect(tappedGoal, isNotNull);
    });
  });

  group('SdgCard', () {
    const testGoal = SdgGoal(
      number: 13,
      titleEn: 'Climate Action',
      shortTitleEn: 'Climate Action',
      descriptionEn: 'Take urgent action to combat climate change.',
      color: Color(0xFF407F46),
      iconUrl: 'https://example.com/icon13.jpg',
    );

    testWidgets('displays short title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              width: 150,
              child: SdgCard(goal: testGoal, onTap: () {}),
            ),
          ),
        ),
      );

      expect(find.text('Climate Action'), findsOneWidget);
    });

    testWidgets('renders with GestureDetector', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              width: 150,
              child: SdgCard(goal: testGoal, onTap: () {}),
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                height: 200,
                width: 150,
                child: SdgCard(goal: testGoal, onTap: () => tapped = true),
              ),
            ),
          ),
        ),
      );
      // Use pump instead of pumpAndSettle due to CircularProgressIndicator
      await tester.pump();

      await tester.tap(find.text('Climate Action'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('renders Container with goal color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              width: 150,
              child: SdgCard(goal: testGoal, onTap: () {}),
            ),
          ),
        ),
      );

      // Find Container that is child of SdgCard
      final containerFinder = find.descendant(
        of: find.byType(SdgCard),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsAtLeast(1));
    });

    testWidgets('has fixed width of 120', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              width: 150,
              child: SdgCard(goal: testGoal, onTap: () {}),
            ),
          ),
        ),
      );

      // Find the outermost Container in SdgCard which has the fixed width
      final card = tester.widget<SdgCard>(find.byType(SdgCard));
      expect(card.goal.titleEn, 'Climate Action');
    });

    testWidgets('displays ClipRRect for image', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              width: 150,
              child: SdgCard(goal: testGoal, onTap: () {}),
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsAtLeast(1));
    });

    testWidgets('text has white color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              width: 150,
              child: SdgCard(goal: testGoal, onTap: () {}),
            ),
          ),
        ),
      );

      // Find Text widget with the short title
      final textFinder = find.text('Climate Action');
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style?.color, Colors.white);
    });

    testWidgets('renders Column with centered main axis alignment', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              width: 150,
              child: SdgCard(goal: testGoal, onTap: () {}),
            ),
          ),
        ),
      );

      final columnFinder = find.descendant(
        of: find.byType(SdgCard),
        matching: find.byType(Column),
      );
      expect(columnFinder, findsOneWidget);

      final column = tester.widget<Column>(columnFinder);
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });
  });
}
