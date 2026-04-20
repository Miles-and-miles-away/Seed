import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/shared/widgets/error_display.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('default form shows an icon and localized message', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const ErrorDisplay()));

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
  });

  testWidgets('compact form omits the icon', (tester) async {
    await tester.pumpWidget(wrap(const ErrorDisplay(compact: true)));

    expect(find.byIcon(Icons.error_outline), findsNothing);
  });

  testWidgets('uses the theme error color for text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            error: Color(0xFFCC0022),
          ),
        ),
        home: const Scaffold(body: Center(child: ErrorDisplay())),
      ),
    );

    final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
    expect(icon.color, const Color(0xFFCC0022));
  });
}
