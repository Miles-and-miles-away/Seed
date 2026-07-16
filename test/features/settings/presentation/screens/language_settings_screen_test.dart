import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/screens/language_settings_screen.dart';

void main() {
  Widget createTestWidget({
    required Widget child,
    String currentLanguage = 'en',
  }) {
    return ProviderScope(
      overrides: [
        // Override the currentLanguageProvider to return our test value
        currentLanguageProvider.overrideWith((ref) => currentLanguage),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(currentLanguage),
        home: child,
      ),
    );
  }

  group('LanguageSettingsScreen', () {
    testWidgets('renders all languages', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const LanguageSettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Check that all three languages are shown by their native names
      expect(find.text('English'), findsWidgets);
      expect(find.text('Español'), findsOneWidget);
      expect(find.text('日本語'), findsOneWidget);
    });

    testWidgets('shows English option with subtitle', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const LanguageSettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Native name as title, English name as subtitle
      expect(find.text('English'), findsWidgets);
    });

    testWidgets('shows Spanish option with native name and subtitle', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: const LanguageSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Español'), findsOneWidget);
      expect(find.text('Spanish'), findsOneWidget);
    });

    testWidgets('shows Japanese option with native name and subtitle', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: const LanguageSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('日本語'), findsOneWidget);
      expect(find.text('Japanese'), findsOneWidget);
    });

    testWidgets('shows checkmark on current language (English)', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(child: const LanguageSettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Find the check_circle icon which indicates selection
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows checkmark on current language (Spanish)', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LanguageSettingsScreen(),
          currentLanguage: 'es',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows checkmark on current language (Japanese)', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LanguageSettingsScreen(),
          currentLanguage: 'ja',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('has app bar with title', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const LanguageSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      // Title should be "Language" in English
      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('displays description text', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const LanguageSettingsScreen()),
      );
      await tester.pumpAndSettle();

      // The description about choosing preferred language should be visible
      expect(find.textContaining('preferred'), findsOneWidget);
    });

    testWidgets('displays note about content', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const LanguageSettingsScreen()),
      );
      await tester.pumpAndSettle();

      // The note about action library content
      expect(find.textContaining('content'), findsOneWidget);
    });

    testWidgets('renders ListTile for each language', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const LanguageSettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Should have 3 ListTiles for the 3 languages
      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets('has dividers between sections', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const LanguageSettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Should have dividers (before and after the language list)
      expect(find.byType(Divider), findsWidgets);
    });
  });
}
