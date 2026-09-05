import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/presentation/screens/about_screen.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      createTestWidget(child: const AboutScreen(), locale: const Locale('en')),
    );
    await tester.pumpAndSettle();
  }

  group('AboutScreen', () {
    testWidgets('renders app header with Seed title', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Seed'), findsOneWidget);
      expect(find.text('Grow your sustainability habits'), findsOneWidget);
    });

    testWidgets('renders version section', (tester) async {
      await pumpScreen(tester);

      // The version section header (uppercase from SettingsSection)
      expect(find.text('VERSION'), findsOneWidget);
      // Subtitle text
      expect(find.text('Seed - Sustainability Habit Tracker'), findsOneWidget);
    });

    testWidgets('renders legal section with Privacy Policy', (tester) async {
      await pumpScreen(tester);

      expect(find.text('LEGAL'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('renders legal section with Terms of Service', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Terms of Service'), findsOneWidget);
    });

    testWidgets('renders Open Source Licenses link', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Open Source Licenses'), findsOneWidget);
    });

    testWidgets('renders footer with SDG acknowledgment', (tester) async {
      await pumpScreen(tester);

      // Scroll to the bottom
      await tester.scrollUntilVisible(
        find.text('Made with care for our planet.'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('UN Sustainable Development Goals'),
        findsOneWidget,
      );
      expect(find.text('Made with care for our planet.'), findsOneWidget);
    });

    testWidgets('renders app icon', (tester) async {
      await pumpScreen(tester);

      // The eco icon is used as the app icon
      expect(find.byIcon(Icons.eco), findsWidgets);
    });

    testWidgets('renders setting tiles with icons', (tester) async {
      await pumpScreen(tester);

      // Check for the icons used in the settings tiles
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.byIcon(Icons.privacy_tip_outlined), findsOneWidget);
      expect(find.byIcon(Icons.description_outlined), findsOneWidget);
      expect(find.byIcon(Icons.source_outlined), findsOneWidget);
    });

    testWidgets('has correct app bar title', (tester) async {
      await pumpScreen(tester);

      // The app bar title from localization
      expect(find.text('About'), findsOneWidget);
    });
  });
}
