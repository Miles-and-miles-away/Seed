import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_locked_sheet.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      );

  EcoDexEntry makeEntry({
    String hintEn = 'Walk five times',
    String hintJa = '',
    String hintEs = '',
  }) =>
      EcoDexEntry(
        id: 'e1',
        category: 'transport',
        nameEn: 'Walking',
        nameJa: '',
        nameEs: '',
        factEn: '',
        factJa: '',
        factEs: '',
        sourceUrl: '',
        iconName: 'walking',
        condition: const EcoDexCondition.totalActions(count: 5),
        hintEn: hintEn,
        hintJa: hintJa,
        hintEs: hintEs,
      );

  testWidgets('shows lock icon and hint in the active locale', (tester) async {
    await tester.pumpWidget(
      wrap(
        EcoDexLockedSheet(entry: makeEntry(), locale: 'en'),
      ),
    );

    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.text('Walk five times'), findsOneWidget);
  });

  testWidgets('falls back to English when localized hint is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        EcoDexLockedSheet(
          entry: makeEntry(hintEn: 'English hint'),
          locale: 'es',
        ),
      ),
    );

    expect(find.text('English hint'), findsOneWidget);
  });

  testWidgets('uses the Spanish hint when provided', (tester) async {
    await tester.pumpWidget(
      wrap(
        EcoDexLockedSheet(
          entry: makeEntry(hintEn: 'EN', hintEs: 'Pista española'),
          locale: 'es',
        ),
      ),
    );

    expect(find.text('Pista española'), findsOneWidget);
  });
}
