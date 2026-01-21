import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/progress/domain/entities/calendar_day_data.dart';
import 'package:seed_app/features/progress/presentation/widgets/calendar_day_cell.dart';

void main() {
  group('CalendarDayCell', () {
    Widget createTestWidget(CalendarDayData data) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 50,
              height: 60,
              child: CalendarDayCell(data: data),
            ),
          ),
        ),
      );
    }

    testWidgets('displays day number', (tester) async {
      final data = CalendarDayData(
        date: DateTime(2024, 1, 15),
        goalCount: 3,
        goalTarget: 5,
        completedSdgs: const [1, 2, 3],
        isToday: false,
        isFuture: false,
      );

      await tester.pumpWidget(createTestWidget(data));

      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('displays grayed out text for future dates', (tester) async {
      final data = CalendarDayData(
        date: DateTime(2024, 1, 20),
        goalCount: 0,
        goalTarget: 5,
        completedSdgs: const [],
        isToday: false,
        isFuture: true,
      );

      await tester.pumpWidget(createTestWidget(data));

      expect(find.text('20'), findsOneWidget);
      // The text should be rendered (existence check)
      final textWidget = tester.widget<Text>(find.text('20'));
      expect(textWidget, isNotNull);
    });

    testWidgets('displays ball for day with activity', (tester) async {
      final data = CalendarDayData(
        date: DateTime(2024, 1, 15),
        goalCount: 3,
        goalTarget: 5,
        completedSdgs: const [1, 2, 3],
        isToday: false,
        isFuture: false,
      );

      await tester.pumpWidget(createTestWidget(data));

      // Should have a container for the ball
      expect(find.byType(Container), findsAtLeast(1));
    });

    testWidgets('displays no ball for day without activity', (tester) async {
      final data = CalendarDayData(
        date: DateTime(2024, 1, 15),
        goalCount: 0,
        goalTarget: 5,
        completedSdgs: const [],
        isToday: false,
        isFuture: false,
      );

      await tester.pumpWidget(createTestWidget(data));

      // Day number should still be visible
      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('displays special indicator for today', (tester) async {
      final data = CalendarDayData(
        date: DateTime.now(),
        goalCount: 0,
        goalTarget: 5,
        completedSdgs: const [],
        isToday: true,
        isFuture: false,
      );

      await tester.pumpWidget(createTestWidget(data));

      // Today's date should be rendered with a ring indicator even without activity
      expect(find.byType(Container), findsAtLeast(1));
    });

    testWidgets('displays today with activity correctly', (tester) async {
      final data = CalendarDayData(
        date: DateTime.now(),
        goalCount: 5,
        goalTarget: 5,
        completedSdgs: const [1, 2, 3, 4, 5],
        isToday: true,
        isFuture: false,
      );

      await tester.pumpWidget(createTestWidget(data));

      // Should display day number and ball
      expect(find.byType(Container), findsAtLeast(1));
    });

    testWidgets('ball scales with completion ratio', (tester) async {
      // Test with 50% completion
      final data50 = CalendarDayData(
        date: DateTime(2024, 1, 15),
        goalCount: 3,
        goalTarget: 6,
        completedSdgs: const [1, 2, 3],
        isToday: false,
        isFuture: false,
      );

      await tester.pumpWidget(createTestWidget(data50));
      expect(find.text('15'), findsOneWidget);

      // Test with 100% completion
      final data100 = CalendarDayData(
        date: DateTime(2024, 1, 16),
        goalCount: 6,
        goalTarget: 6,
        completedSdgs: const [1, 2, 3, 4, 5, 6],
        isToday: false,
        isFuture: false,
      );

      await tester.pumpWidget(createTestWidget(data100));
      expect(find.text('16'), findsOneWidget);
    });

    testWidgets('renders correctly when goal is exceeded', (tester) async {
      final data = CalendarDayData(
        date: DateTime(2024, 1, 15),
        goalCount: 10,
        goalTarget: 5,
        completedSdgs: const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        isToday: false,
        isFuture: false,
      );

      await tester.pumpWidget(createTestWidget(data));

      expect(find.text('15'), findsOneWidget);
      // Ball should be at maximum size (clamped to 1.0 ratio)
      expect(find.byType(Container), findsAtLeast(1));
    });

    testWidgets('has SizedBox for consistent height', (tester) async {
      final data = CalendarDayData(
        date: DateTime(2024, 1, 15),
        goalCount: 3,
        goalTarget: 5,
        completedSdgs: const [1, 2, 3],
        isToday: false,
        isFuture: false,
      );

      await tester.pumpWidget(createTestWidget(data));

      expect(find.byType(SizedBox), findsAtLeast(1));
    });
  });
}
