import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/settings/presentation/screens/about_screen.dart';

void main() {
  Widget createTestWidget({Widget? child}) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: child ?? const AboutScreen(),
      ),
    );
  }

  group('AboutScreen', () {
    testWidgets('renders app header with Seed title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Seed'), findsOneWidget);
      expect(find.text('Grow your sustainability habits'), findsOneWidget);
    });

    testWidgets('renders version section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // The version section header (uppercase from SettingsSection)
      expect(find.text('VERSION'), findsOneWidget);
      // Subtitle text
      expect(find.text('Seed - Sustainability Habit Tracker'), findsOneWidget);
    });

    testWidgets('renders legal section with Privacy Policy', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('LEGAL'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('renders legal section with Terms of Service', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Terms of Service'), findsOneWidget);
    });

    testWidgets('renders Open Source Licenses link', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Open Source Licenses'), findsOneWidget);
    });

    testWidgets('renders Support section with Send Feedback tile',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll down to find the Support section
      await tester.scrollUntilVisible(
        find.text('SUPPORT'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('SUPPORT'), findsOneWidget);
      expect(find.text('Send Feedback'), findsOneWidget);
    });

    testWidgets('renders footer with SDG acknowledgment', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

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
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // The eco icon is used as the app icon
      expect(find.byIcon(Icons.eco), findsWidgets);
    });

    testWidgets('renders setting tiles with icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for the icons used in the settings tiles
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.byIcon(Icons.privacy_tip_outlined), findsOneWidget);
      expect(find.byIcon(Icons.description_outlined), findsOneWidget);
      expect(find.byIcon(Icons.source_outlined), findsOneWidget);
    });

    testWidgets('renders feedback tile subtitle', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final subtitle = find.text('Report a bug or share your thoughts');
      await tester.scrollUntilVisible(
        subtitle,
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(subtitle, findsOneWidget);
    });

    testWidgets('has correct app bar title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // The app bar title from localization
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('renders feedback tile mail icon when scrolled',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byIcon(Icons.mail_outline),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mail_outline), findsOneWidget);
    });
  });
}
