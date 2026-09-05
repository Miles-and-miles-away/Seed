import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_section.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    UserSettingsModel settings = const UserSettingsModel(),
  }) async {
    await tester.pumpWidget(
      createTestWidget(
        child: const SettingsScreen(),
        overrides: [
          userSettingsProvider.overrideWith((ref) => Stream.value(settings)),
        ],
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('SettingsScreen', () {
    testWidgets('renders app bar with settings title', (tester) async {
      await pumpScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('does not render the hidden notifications section', (
      tester,
    ) async {
      // Feature postponed: the section stays hidden until the reminder
      // scheduling pipeline is actually wired up.
      await pumpScreen(tester);

      expect(find.text('NOTIFICATIONS'), findsNothing);
      expect(find.byIcon(Icons.notifications_outlined), findsNothing);
    });

    testWidgets('renders preferences section', (tester) async {
      await pumpScreen(tester);

      expect(find.text('PREFERENCES'), findsOneWidget);
    });

    testWidgets('renders account section', (tester) async {
      await pumpScreen(tester);

      expect(find.text('ACCOUNT'), findsOneWidget);
    });

    testWidgets('renders privacy section', (tester) async {
      await pumpScreen(tester);

      expect(find.text('PRIVACY'), findsOneWidget);
    });

    testWidgets('renders support section with feedback tile', (tester) async {
      await pumpScreen(tester);

      // Support section may require scrolling
      await tester.scrollUntilVisible(find.text('SUPPORT'), 100);
      expect(find.text('SUPPORT'), findsOneWidget);
      expect(find.text('Send Feedback'), findsOneWidget);
      expect(find.text('Report a bug or share your thoughts'), findsOneWidget);
      expect(find.byIcon(Icons.mail_outline), findsOneWidget);
    });

    testWidgets('renders about section', (tester) async {
      await pumpScreen(tester);

      // About section may require scrolling
      await tester.scrollUntilVisible(find.text('ABOUT'), 100);
      expect(find.text('ABOUT'), findsOneWidget);
    });

    testWidgets('shows language setting', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('shows account setting', (tester) async {
      await pumpScreen(tester);

      // Account tile
      expect(find.text('Account'), findsWidgets);
    });

    testWidgets('shows about setting', (tester) async {
      await pumpScreen(tester);

      // Scroll to make the ABOUT section header visible
      await tester.scrollUntilVisible(find.text('ABOUT'), 100);
      expect(find.text('About'), findsWidgets);
    });

    testWidgets('shows correct language display for English', (tester) async {
      await pumpScreen(tester);

      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('shows correct language display for Japanese', (tester) async {
      await pumpScreen(
        tester,
        settings: const UserSettingsModel(language: 'ja'),
      );

      expect(find.text('日本語'), findsOneWidget);
    });

    testWidgets('renders multiple SettingsSections', (tester) async {
      await pumpScreen(tester);

      // 6 sections total, but Support/About may be off-screen
      expect(find.byType(SettingsSection), findsAtLeast(4));
    });

    testWidgets('renders language icon', (tester) async {
      await pumpScreen(tester);

      expect(find.byIcon(Icons.language_outlined), findsOneWidget);
    });

    testWidgets('renders person icon', (tester) async {
      await pumpScreen(tester);

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('renders info icon', (tester) async {
      await pumpScreen(tester);

      await tester.scrollUntilVisible(find.byIcon(Icons.info_outline), 100);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('shows version in about tile', (tester) async {
      await pumpScreen(tester);

      await tester.scrollUntilVisible(find.textContaining('Version'), 100);
      expect(find.textContaining('Version'), findsOneWidget);
    });

    testWidgets('analytics switch reflects enabled state', (tester) async {
      await pumpScreen(tester);

      final switchWidget = tester.widget<Switch>(find.byType(Switch).first);
      expect(switchWidget.value, isTrue);
    });

    testWidgets('analytics switch reflects disabled state', (tester) async {
      await pumpScreen(
        tester,
        settings: const UserSettingsModel(analyticsEnabled: false),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch).first);
      expect(switchWidget.value, isFalse);
    });
  });
}
