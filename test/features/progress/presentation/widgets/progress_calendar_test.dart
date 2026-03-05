import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/progress/domain/entities/calendar_day_data.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/progress/presentation/widgets/progress_calendar.dart';

/// Test implementation of SelectedMonth notifier for testing purposes.
class TestSelectedMonth extends SelectedMonth {
  TestSelectedMonth(this._initialMonth);
  final DateTime _initialMonth;

  @override
  DateTime build() => _initialMonth;
}

void main() {
  group('ProgressCalendar', () {
    // Helper to set mobile screen size for tests
    void setMobileScreenSize(WidgetTester tester) {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
    }

    void resetScreenSize(WidgetTester tester) {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    }

    Widget createTestWidget({
      DateTime? selectedMonth,
      List<CalendarDayData>? calendarData,
    }) {
      final now = DateTime.now();
      final testMonth = selectedMonth ?? DateTime(now.year, now.month);

      // Generate test calendar data for the month
      final testData = calendarData ??
          List.generate(
            DateTime(testMonth.year, testMonth.month + 1, 0).day,
            (index) {
              final day = index + 1;
              final date = DateTime(testMonth.year, testMonth.month, day);
              final isToday = date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day;
              final isFuture = date.isAfter(now);

              return CalendarDayData(
                date: date,
                goalCount: isFuture ? 0 : (day % 3 == 0 ? 5 : day % 2),
                goalTarget: 5,
                completedSdgs: isFuture ? const [] : [1, 2],
                isToday: isToday,
                isFuture: isFuture,
              );
            },
          );

      return ProviderScope(
        overrides: [
          // For Notifier providers in Riverpod 3.x, use overrideWith
          selectedMonthProvider
              .overrideWith(() => TestSelectedMonth(testMonth)),
          monthCalendarDataProvider
              .overrideWith((ref) => Future.value(testData)),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ProgressCalendar(),
          ),
        ),
      );
    }

    testWidgets('displays month header', (tester) async {
      setMobileScreenSize(tester);
      addTearDown(() => resetScreenSize(tester));

      // ignore: avoid_redundant_argument_values
      final testMonth = DateTime(2024, 1);
      await tester.pumpWidget(createTestWidget(selectedMonth: testMonth));
      await tester.pumpAndSettle();

      // Should display the month name (January 2024)
      expect(find.textContaining('January'), findsOneWidget);
      expect(find.textContaining('2024'), findsOneWidget);
    });

    testWidgets('displays weekday labels', (tester) async {
      setMobileScreenSize(tester);
      addTearDown(() => resetScreenSize(tester));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should display weekday abbreviations
      expect(find.text('S'), findsAtLeast(2)); // Sunday and Saturday
      expect(find.text('M'), findsOneWidget);
      expect(find.text('T'), findsAtLeast(2)); // Tuesday and Thursday
      expect(find.text('W'), findsOneWidget);
      expect(find.text('F'), findsOneWidget);
    });

    testWidgets('displays navigation arrows', (tester) async {
      setMobileScreenSize(tester);
      addTearDown(() => resetScreenSize(tester));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching data', (tester) async {
      setMobileScreenSize(tester);
      addTearDown(() => resetScreenSize(tester));

      // Use a completer so we can control when the future completes
      final completer = Completer<List<CalendarDayData>>();

      final widget = ProviderScope(
        overrides: [
          // ignore: avoid_redundant_argument_values
          selectedMonthProvider
              .overrideWith(() => TestSelectedMonth(DateTime(2024, 1))),
          monthCalendarDataProvider.overrideWith((ref) => completer.future),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ProgressCalendar(),
          ),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pump(); // Initial build

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the future to clean up
      completer.complete(<CalendarDayData>[]);
      await tester.pump();
    });

    testWidgets('displays calendar grid with days', (tester) async {
      setMobileScreenSize(tester);
      addTearDown(() => resetScreenSize(tester));

      // ignore: avoid_redundant_argument_values
      final testMonth = DateTime(2024, 1);
      await tester.pumpWidget(createTestWidget(selectedMonth: testMonth));
      await tester.pumpAndSettle();

      // January 2024 has 31 days
      // At least day 1 should be visible
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('renders correct number of rows for month', (tester) async {
      setMobileScreenSize(tester);
      addTearDown(() => resetScreenSize(tester));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should have Row widgets for the calendar grid
      expect(find.byType(Row),
          findsAtLeast(5)); // Header + weekday + at least 4 weeks
    });

    testWidgets('next month button is disabled for current month',
        (tester) async {
      setMobileScreenSize(tester);
      addTearDown(() => resetScreenSize(tester));

      final now = DateTime.now();
      await tester.pumpWidget(
        createTestWidget(selectedMonth: DateTime(now.year, now.month)),
      );
      await tester.pumpAndSettle();

      // Find the next button
      final nextButton = find.byIcon(Icons.chevron_right);
      expect(nextButton, findsOneWidget);

      // The IconButton should have null onPressed for current month
      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: nextButton,
          matching: find.byType(IconButton),
        ),
      );
      expect(iconButton.onPressed, isNull);
    });

    testWidgets('displays CalendarDayCell widgets', (tester) async {
      setMobileScreenSize(tester);
      addTearDown(() => resetScreenSize(tester));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // The calendar should contain day cells
      // We're checking that at least some day numbers are displayed
      expect(find.text('15'), findsOneWidget);
    });
  });
}
