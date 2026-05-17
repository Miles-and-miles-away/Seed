import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/progress/domain/entities/co2_chart_data.dart';
import 'package:seed_app/features/progress/presentation/widgets/co2_category_chart.dart';

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
  group('Co2CategoryChart', () {
    testWidgets('renders title, donut center, and legend with percentages',
        (tester) async {
      const data = Co2CategoryData(
        slices: [
          Co2CategorySlice(
            category: ActionCategory.transport,
            grams: 750,
            percentage: 75,
          ),
          Co2CategorySlice(
            category: ActionCategory.food,
            grams: 250,
            percentage: 25,
          ),
        ],
        totalGrams: 1000,
      );

      await tester.pumpWidget(_wrap(const Co2CategoryChart(data: data)));
      await tester.pumpAndSettle();

      expect(find.text('By category'), findsOneWidget);
      expect(find.byType(PieChart), findsOneWidget);

      // Donut center shows total kg.
      expect(find.text('1.0'), findsOneWidget);
      expect(find.text('kg'), findsOneWidget);

      // Legend percentages render.
      expect(find.text('75%'), findsOneWidget);
      expect(find.text('25%'), findsOneWidget);
    });

    testWidgets('labels the lumped slice as "Other"', (tester) async {
      const data = Co2CategoryData(
        slices: [
          Co2CategorySlice(
            category: ActionCategory.transport,
            grams: 800,
            percentage: 80,
          ),
          Co2CategorySlice(
            category: null,
            grams: 200,
            percentage: 20,
          ),
        ],
        totalGrams: 1000,
      );

      await tester.pumpWidget(_wrap(const Co2CategoryChart(data: data)));
      await tester.pumpAndSettle();

      expect(find.text('Other'), findsOneWidget);
    });
  });
}
