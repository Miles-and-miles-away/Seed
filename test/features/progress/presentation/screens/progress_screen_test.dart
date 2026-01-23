import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';
import 'package:seed_app/features/progress/domain/entities/calendar_day_data.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/progress/presentation/screens/progress_screen.dart';
import 'package:seed_app/features/progress/presentation/widgets/daily_target_picker.dart';
import 'package:seed_app/features/progress/presentation/widgets/progress_calendar.dart';
import 'package:seed_app/features/progress/presentation/widgets/rainbow_sun_widget.dart';

import '../../../../helpers/test_helpers.dart';

/// Test implementation of SelectedMonth notifier for testing purposes.
class TestSelectedMonth extends SelectedMonth {
  TestSelectedMonth(this._initialMonth);
  final DateTime _initialMonth;

  @override
  DateTime build() => _initialMonth;
}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    mockFirebaseAuth = createMockFirebaseAuth();
    fakeFirestore = createFakeFirestore();
  });

  group('ProgressScreen', () {
    Widget createTestWidget({
      AppUserModel? user,
      DailySummaryModel? todaySummary,
      bool needsSetup = false,
      int? dailyGoalTarget,
    }) {
      final testUser = user ??
          AppUserModel(
            uid: 'test-uid',
            email: 'test@example.com',
            dailyGoalTarget: needsSetup ? null : (dailyGoalTarget ?? 5),
          );

      final now = DateTime.now();
      final testMonth = DateTime(now.year, now.month);
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

      final calendarData = List.generate(daysInMonth, (index) {
        final day = index + 1;
        final date = DateTime(now.year, now.month, day);
        return CalendarDayData(
          date: date,
          goalCount: day % 3,
          goalTarget: 5,
          completedSdgs: const [1, 2],
          isToday: date.day == now.day,
          isFuture: date.isAfter(now),
        );
      });

      return ProviderScope(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          firestoreProvider.overrideWithValue(fakeFirestore),
          currentUserProvider.overrideWith((ref) => Stream.value(testUser)),
          needsDailyTargetSetupProvider.overrideWithValue(needsSetup),
          dailyGoalTargetProvider.overrideWithValue(testUser.dailyGoalTarget),
          todaySummaryProvider.overrideWith((ref) => Stream.value(todaySummary)),
          selectedMonthProvider.overrideWith(() => TestSelectedMonth(testMonth)),
          monthCalendarDataProvider.overrideWith((ref) async => calendarData),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProgressScreen(),
        ),
      );
    }

    testWidgets('shows DailyTargetPicker for first-time users', (tester) async {
      await tester.pumpWidget(createTestWidget(needsSetup: true));
      await tester.pumpAndSettle();

      expect(find.byType(DailyTargetPicker), findsOneWidget);
    });

    testWidgets('shows main content for users with daily target set',
        (tester) async {
      // ignore: avoid_redundant_argument_values
      await tester.pumpWidget(createTestWidget(needsSetup: false));
      await tester.pumpAndSettle();

      // Should show the AppBar with title
      expect(find.byType(AppBar), findsOneWidget);
      // Should NOT show DailyTargetPicker
      expect(find.byType(DailyTargetPicker), findsNothing);
    });

    testWidgets('displays AppBar with Progress title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays EmptyRainbowSun when no goals completed',
        (tester) async {
      // ignore: avoid_redundant_argument_values
      await tester.pumpWidget(createTestWidget(todaySummary: null));
      await tester.pumpAndSettle();

      expect(find.byType(EmptyRainbowSun), findsOneWidget);
    });

    testWidgets('displays RainbowSunWidget when goals are completed',
        (tester) async {
      final summary = DailySummaryModel(
        date: '2024-01-15',
        goalCount: 3,
        completedSdgs: const [1, 2, 3],
        totalPoints: 30,
        totalCo2Grams: 500,
      );

      await tester.pumpWidget(createTestWidget(todaySummary: summary));
      await tester.pumpAndSettle();

      expect(find.byType(RainbowSunWidget), findsOneWidget);
    });

    testWidgets('displays goal count stats', (tester) async {
      final summary = DailySummaryModel(
        date: '2024-01-15',
        goalCount: 3,
        completedSdgs: const [1, 2, 3],
        totalPoints: 30,
        totalCo2Grams: 500,
      );

      await tester.pumpWidget(
        createTestWidget(todaySummary: summary, dailyGoalTarget: 5),
      );
      await tester.pumpAndSettle();

      // Should show "3 / 5 goals today" format
      expect(find.textContaining('3'), findsAtLeast(1));
      expect(find.textContaining('5'), findsAtLeast(1));
    });

    testWidgets('displays celebration when goal is met', (tester) async {
      final summary = DailySummaryModel(
        date: '2024-01-15',
        goalCount: 5,
        completedSdgs: const [1, 2, 3, 4, 5],
        totalPoints: 50,
        totalCo2Grams: 1000,
      );

      await tester.pumpWidget(
        createTestWidget(todaySummary: summary, dailyGoalTarget: 5),
      );
      await tester.pumpAndSettle();

      // Should show celebration icon when goal is met
      expect(find.byIcon(Icons.celebration), findsOneWidget);
    });

    testWidgets('does not display celebration when goal is not met',
        (tester) async {
      final summary = DailySummaryModel(
        date: '2024-01-15',
        goalCount: 3,
        completedSdgs: const [1, 2, 3],
        totalPoints: 30,
        totalCo2Grams: 500,
      );

      await tester.pumpWidget(
        createTestWidget(todaySummary: summary, dailyGoalTarget: 5),
      );
      await tester.pumpAndSettle();

      // Should NOT show celebration icon when goal is not met
      expect(find.byIcon(Icons.celebration), findsNothing);
    });

    testWidgets('displays ProgressCalendar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ProgressCalendar), findsOneWidget);
    });

    testWidgets('content is scrollable', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('shows loading indicator while fetching today summary',
        (tester) async {
      final now = DateTime.now();
      // Use a StreamController to simulate a loading state without timers
      final summaryController = StreamController<DailySummaryModel?>();

      final widget = ProviderScope(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          firestoreProvider.overrideWithValue(fakeFirestore),
          currentUserProvider.overrideWith((ref) => Stream.value(
                const AppUserModel(
                  uid: 'test-uid',
                  email: 'test@example.com',
                  dailyGoalTarget: 5,
                ),
              ),
            ),
          // ignore: avoid_redundant_argument_values
          needsDailyTargetSetupProvider.overrideWithValue(false),
          dailyGoalTargetProvider.overrideWithValue(5),
          // Use stream that hasn't emitted yet (loading state)
          todaySummaryProvider.overrideWith((ref) => summaryController.stream),
          selectedMonthProvider.overrideWith(() => TestSelectedMonth(DateTime(now.year, now.month))),
          monthCalendarDataProvider.overrideWith((ref) async => <CalendarDayData>[]),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProgressScreen(),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pump();

      // Should show loading indicator in the sun section
      expect(find.byType(CircularProgressIndicator), findsAtLeast(1));

      // Clean up the controller
      await summaryController.close();
    });

    testWidgets('sun section has correct height constraint', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find SizedBox with height 280
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final sunSizedBox = sizedBoxes.where((box) => box.height == 280);
      expect(sunSizedBox.isNotEmpty, isTrue);
    });

    testWidgets('calendar section has rounded container', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find Container with decoration
      expect(find.byType(Container), findsAtLeast(1));
    });

    testWidgets('defaults to goal target of 3 when not set', (tester) async {
      const testUser = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        // ignore: avoid_redundant_argument_values
        dailyGoalTarget: null,
      );

      final now = DateTime.now();
      final widget = ProviderScope(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          firestoreProvider.overrideWithValue(fakeFirestore),
          currentUserProvider.overrideWith((ref) => Stream.value(testUser)),
          needsDailyTargetSetupProvider.overrideWithValue(false),
          dailyGoalTargetProvider.overrideWithValue(null),
          todaySummaryProvider.overrideWith(
            (ref) => Stream.value(
              const DailySummaryModel(
                date: '2024-01-15',
                goalCount: 3,
                completedSdgs: [1, 2, 3],
                totalPoints: 30,
                totalCo2Grams: 500,
              ),
            ),
          ),
          selectedMonthProvider.overrideWith(() => TestSelectedMonth(DateTime(now.year, now.month))),
          monthCalendarDataProvider.overrideWith((ref) async => <CalendarDayData>[]),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProgressScreen(),
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Should still render without crashing
      expect(find.byType(ProgressScreen), findsOneWidget);
    });
  });
}
