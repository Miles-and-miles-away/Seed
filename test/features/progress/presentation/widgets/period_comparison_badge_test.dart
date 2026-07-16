import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/domain/entities/co2_stats.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/presentation/widgets/period_comparison_badge.dart';

Widget _wrap(Widget child) => MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  group('PeriodComparisonBadge', () {
    testWidgets('renders empty when previous total is 0', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PeriodComparisonBadge(
            stats: Co2Stats(
              totalGrams: 1000,
              previousTotalGrams: 0,
              percentChange: 0,
              period: TimePeriod.today,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_upward), findsNothing);
      expect(find.byIcon(Icons.arrow_downward), findsNothing);
    });

    testWidgets('renders empty for all-time period', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PeriodComparisonBadge(
            stats: Co2Stats(
              totalGrams: 5000,
              previousTotalGrams: 4000,
              percentChange: 25,
              period: TimePeriod.allTime,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_upward), findsNothing);
      expect(find.textContaining('vs.'), findsNothing);
    });

    testWidgets('shows up arrow + percent + reference for positive change', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const PeriodComparisonBadge(
            stats: Co2Stats(
              totalGrams: 1150,
              previousTotalGrams: 1000,
              percentChange: 15,
              period: TimePeriod.today,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
      expect(find.text('15% vs. yesterday'), findsOneWidget);
    });

    testWidgets('shows down arrow for negative change', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PeriodComparisonBadge(
            stats: Co2Stats(
              totalGrams: 700,
              previousTotalGrams: 1000,
              percentChange: -30,
              period: TimePeriod.thisWeek,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
      expect(find.text('30% vs. last week'), findsOneWidget);
    });

    testWidgets('uses period-specific reference label for thisMonth', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const PeriodComparisonBadge(
            stats: Co2Stats(
              totalGrams: 30000,
              previousTotalGrams: 20000,
              percentChange: 50,
              period: TimePeriod.thisMonth,
            ),
          ),
        ),
      );

      expect(find.text('50% vs. last month'), findsOneWidget);
    });
  });
}
