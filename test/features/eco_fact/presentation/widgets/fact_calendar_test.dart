import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';

import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/fact_calendar.dart';

void main() {
  group('FactCalendar', () {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    Widget buildWidget({
      List<FactCalendarDay>? calendarData,
    }) {
      final data = calendarData ??
          List.generate(
            DateTime(now.year, now.month + 1, 0).day,
            (i) {
              final date = DateTime(now.year, now.month, i + 1);
              final today = DateTime(now.year, now.month, now.day);
              return FactCalendarDay(
                date: date,
                isViewed: i < now.day - 1,
                isToday: date.isAtSameMomentAs(today),
                isFuture: date.isAfter(today),
              );
            },
          );

      return ProviderScope(
        overrides: [
          factCalendarDataProvider.overrideWith((_) async => data),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: FactCalendar(),
            ),
          ),
        ),
      );
    }

    testWidgets('shows month header', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      final monthStr = DateFormat.yMMMM().format(currentMonth);
      expect(find.text(monthStr), findsOneWidget);
    });

    testWidgets('shows day numbers', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Check first and last day of month
      expect(find.text('1'), findsWidgets);
      final lastDay = DateTime(now.year, now.month + 1, 0).day;
      expect(find.text('$lastDay'), findsWidgets);
    });

    testWidgets('shows navigation arrows', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(
        find.byIcon(Icons.chevron_left),
        findsOneWidget,
      );
      expect(
        find.byIcon(Icons.chevron_right),
        findsOneWidget,
      );
    });

    testWidgets(
      'previous month button is tappable',
      (tester) async {
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.chevron_left));
        // Should not throw
      },
    );
  });
}
