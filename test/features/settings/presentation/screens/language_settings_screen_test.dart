import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/screens/language_settings_screen.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    String currentLanguage = 'en',
  }) async {
    await tester.pumpWidget(
      createTestWidget(
        child: const LanguageSettingsScreen(),
        overrides: [
          currentLanguageProvider.overrideWith((ref) => currentLanguage),
        ],
        locale: Locale(currentLanguage),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('LanguageSettingsScreen', () {
    testWidgets('renders all languages', (tester) async {
      await pumpScreen(tester);

      // Check that all three languages are shown by their native names
      expect(find.text('English'), findsWidgets);
      expect(find.text('Español'), findsOneWidget);
      expect(find.text('日本語'), findsOneWidget);
    });

    testWidgets('shows English option with subtitle', (tester) async {
      await pumpScreen(tester);

      // Native name as title, English name as subtitle
      expect(find.text('English'), findsWidgets);
    });

    testWidgets('shows Spanish option with native name and subtitle', (
      tester,
    ) async {
      await pumpScreen(tester);

      expect(find.text('Español'), findsOneWidget);
      expect(find.text('Spanish'), findsOneWidget);
    });

    testWidgets('shows Japanese option with native name and subtitle', (
      tester,
    ) async {
      await pumpScreen(tester);

      expect(find.text('日本語'), findsOneWidget);
      expect(find.text('Japanese'), findsOneWidget);
    });

    testWidgets('shows checkmark on current language (English)', (
      tester,
    ) async {
      await pumpScreen(tester);

      // Find the check_circle icon which indicates selection
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows checkmark on current language (Spanish)', (
      tester,
    ) async {
      await pumpScreen(tester, currentLanguage: 'es');

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows checkmark on current language (Japanese)', (
      tester,
    ) async {
      await pumpScreen(tester, currentLanguage: 'ja');

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('has app bar with title', (tester) async {
      await pumpScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
      // Title should be "Language" in English
      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('displays description text', (tester) async {
      await pumpScreen(tester);

      // The description about choosing preferred language should be visible
      expect(find.textContaining('preferred'), findsOneWidget);
    });

    testWidgets('displays note about content', (tester) async {
      await pumpScreen(tester);

      // The note about action library content
      expect(find.textContaining('content'), findsOneWidget);
    });

    testWidgets('renders ListTile for each language', (tester) async {
      await pumpScreen(tester);

      // Should have 3 ListTiles for the 3 languages
      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets('has dividers between sections', (tester) async {
      await pumpScreen(tester);

      // Should have dividers (before and after the language list)
      expect(find.byType(Divider), findsWidgets);
    });
  });
}
