import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_card.dart';

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
  group('EquivalencyCard', () {
    testWidgets('renders trees with one decimal place', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const EquivalencyCard(
            equivalency: ImpactEquivalency(
              type: EquivalencyType.trees,
              value: 2.4,
            ),
          ),
        ),
      );

      expect(find.text('2.4'), findsOneWidget);
      expect(find.text('trees / year'), findsOneWidget);
    });

    testWidgets('renders sub-unit trees value', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const EquivalencyCard(
            equivalency: ImpactEquivalency(
              type: EquivalencyType.trees,
              value: 0.2,
            ),
          ),
        ),
      );

      expect(find.text('0.2'), findsOneWidget);
    });

    testWidgets('rounds whole-unit values and groups thousands', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const EquivalencyCard(
            equivalency: ImpactEquivalency(
              type: EquivalencyType.phoneCharges,
              value: 3125.7,
            ),
          ),
        ),
      );

      expect(find.text('3,126'), findsOneWidget);
      expect(find.text('phone charges'), findsOneWidget);
    });

    testWidgets('shows car-km equivalency with localized label', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const EquivalencyCard(
            equivalency: ImpactEquivalency(
              type: EquivalencyType.carKm,
              value: 105,
            ),
          ),
        ),
      );

      expect(find.text('105'), findsOneWidget);
      expect(find.text('km not driven'), findsOneWidget);
    });

    testWidgets('shows burgers equivalency with localized label', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const EquivalencyCard(
            equivalency: ImpactEquivalency(
              type: EquivalencyType.burgers,
              value: 7,
            ),
          ),
        ),
      );

      expect(find.text('7'), findsOneWidget);
      expect(find.text('burgers'), findsOneWidget);
    });
  });
}
