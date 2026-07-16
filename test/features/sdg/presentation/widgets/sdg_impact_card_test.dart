import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/sdg/presentation/widgets/sdg_impact_card.dart';

void main() {
  Widget wrap(Widget child, {AppUserModel? user}) => ProviderScope(
    overrides: [currentUserProvider.overrideWith((_) => Stream.value(user))],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    ),
  );

  testWidgets('shows zero counts when the user has no logged impact', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const SdgImpactCard(goalNumber: 7, goalColor: Colors.orange)),
    );
    await tester.pump();

    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('renders the user stats for the target SDG', (tester) async {
    await tester.pumpWidget(
      wrap(
        const SdgImpactCard(goalNumber: 11, goalColor: Colors.orange),
        user: const AppUserModel(
          uid: 'u',
          email: 'e',
          sdgStats: {
            '11': {'count': 4, 'co2': 2500},
          },
        ),
      ),
    );
    await tester.pump();

    expect(find.text('4'), findsOneWidget);
    // formatCO2Compact(2500) = "2.5kg".
    expect(find.text('2.5kg'), findsOneWidget);
  });
}
