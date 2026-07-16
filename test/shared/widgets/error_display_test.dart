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

  testWidgets('shows no retry button when onRetry is omitted', (tester) async {
    await tester.pumpWidget(wrap(const ErrorDisplay()));

    expect(find.byType(FilledButton), findsNothing);
    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets('tapping the retry button invokes the callback', (tester) async {
    var retries = 0;
    await tester.pumpWidget(wrap(ErrorDisplay(onRetry: () => retries++)));

    expect(find.byIcon(Icons.refresh), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    expect(retries, 1);
  });

  testWidgets('compact form shows a tappable retry button', (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      wrap(ErrorDisplay(compact: true, onRetry: () => retries++)),
    );

    expect(find.byIcon(Icons.error_outline), findsNothing);
    await tester.tap(find.byType(TextButton));
    expect(retries, 1);
  });

  testWidgets('renders the message override instead of the generic one', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const ErrorDisplay(message: 'Custom message')),
    );

    expect(find.text('Custom message'), findsOneWidget);
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
          colorScheme: const ColorScheme.light(error: Color(0xFFCC0022)),
        ),
        home: const Scaffold(body: Center(child: ErrorDisplay())),
      ),
    );

    final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
    expect(icon.color, const Color(0xFFCC0022));
  });
}
