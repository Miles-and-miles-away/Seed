import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/data/impact_equivalencies_data.dart';
import 'package:seed_app/features/progress/domain/entities/co2_stats.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_stats_provider.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_row.dart';
import 'package:seed_app/features/progress/presentation/widgets/impact_dashboard.dart';

const _equivalencyFixture = <EquivalencyMetadata>[
  EquivalencyMetadata(
    type: EquivalencyType.trees,
    gramsPerUnit: 21000,
    sourceName: 'EPA',
    sourceUrl: 'https://example.org/epa',
  ),
  EquivalencyMetadata(
    type: EquivalencyType.carKm,
    gramsPerUnit: 200,
    sourceName: 'DEFRA',
    sourceUrl: 'https://example.org/defra',
  ),
  EquivalencyMetadata(
    type: EquivalencyType.phoneCharges,
    gramsPerUnit: 8,
    sourceName: 'EPA',
    sourceUrl: 'https://example.org/epa',
  ),
  EquivalencyMetadata(
    type: EquivalencyType.burgers,
    gramsPerUnit: 3000,
    sourceName: 'OWID',
    sourceUrl: 'https://example.org/owid',
  ),
];

/// Returns a [Co2Stats] keyed to a stable per-period total so test
/// assertions can identify which period was queried by the rendered
/// kg value.
Co2Stats _statsFor(TimePeriod period) {
  return switch (period) {
    TimePeriod.today => const Co2Stats(
        totalGrams: 1500,
        previousTotalGrams: 0,
        percentChange: 0,
        period: TimePeriod.today,
      ),
    TimePeriod.thisWeek => const Co2Stats(
        totalGrams: 7200,
        previousTotalGrams: 0,
        percentChange: 0,
        period: TimePeriod.thisWeek,
      ),
    TimePeriod.thisMonth => const Co2Stats(
        totalGrams: 30500,
        previousTotalGrams: 0,
        percentChange: 0,
        period: TimePeriod.thisMonth,
      ),
    TimePeriod.allTime => const Co2Stats(
        totalGrams: 184000,
        previousTotalGrams: 0,
        percentChange: 0,
        period: TimePeriod.allTime,
      ),
  };
}

Widget _wrap(Widget child) => ProviderScope(
      overrides: [
        co2StatsProvider.overrideWith((ref, period) async => _statsFor(period)),
        impactEquivalenciesDataProvider
            .overrideWith((_) async => _equivalencyFixture),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );

Future<void> _pumpDashboard(WidgetTester tester) async {
  await tester.pumpWidget(_wrap(const ImpactDashboard()));
  await tester.pumpAndSettle();
}

void main() {
  group('ImpactDashboard', () {
    testWidgets('defaults to Today and shows today total', (tester) async {
      await _pumpDashboard(tester);

      // 1500g -> 1.5 kg
      expect(find.text('1.5 kg'), findsOneWidget);
      expect(find.text('CO2 saved today'), findsOneWidget);
    });

    testWidgets('switching to This Week updates the displayed total',
        (tester) async {
      await _pumpDashboard(tester);

      await tester.tap(find.text('This Week'));
      await tester.pumpAndSettle();

      // 7200g -> 7.2 kg
      expect(find.text('7.2 kg'), findsOneWidget);
      expect(find.text('CO2 saved this week'), findsOneWidget);
      // Previous selection no longer rendered.
      expect(find.text('1.5 kg'), findsNothing);
    });

    testWidgets('switching to This Month updates the displayed total',
        (tester) async {
      await _pumpDashboard(tester);

      await tester.tap(find.text('This Month'));
      await tester.pumpAndSettle();

      // 30500g -> 30.5 kg
      expect(find.text('30.5 kg'), findsOneWidget);
      expect(find.text('CO2 saved this month'), findsOneWidget);
    });

    testWidgets('switching to All Time updates the displayed total',
        (tester) async {
      await _pumpDashboard(tester);

      await tester.tap(find.text('All Time'));
      await tester.pumpAndSettle();

      // 184000g -> 184.0 kg
      expect(find.text('184.0 kg'), findsOneWidget);
      expect(find.text('CO2 saved all time'), findsOneWidget);
    });

    testWidgets('hides equivalencies section when total is zero',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            co2StatsProvider.overrideWith(
              (ref, period) async => const Co2Stats(
                totalGrams: 0,
                previousTotalGrams: 0,
                percentChange: 0,
                period: TimePeriod.today,
              ),
            ),
            impactEquivalenciesDataProvider
                .overrideWith((_) async => _equivalencyFixture),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: ImpactDashboard()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0.0 kg'), findsOneWidget);
      expect(find.text('Equivalent to'), findsNothing);
      expect(find.byType(EquivalencyRow), findsNothing);
    });
  });
}
