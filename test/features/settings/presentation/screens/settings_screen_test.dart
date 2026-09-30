import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/data/repositories/settings_repository.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_section.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../walkthrough/walkthrough_test_support.dart';

void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    UserSettingsModel settings = const UserSettingsModel(),
  }) async {
    sizeViewport(tester);
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

    testWidgets(
      'theme selector fits a phone width and shows the current mode',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await pumpScreen(
          tester,
          settings: const UserSettingsModel(themeMode: 'dark'),
        );

        expect(find.text('Theme'), findsOneWidget);
        expect(find.byType(SegmentedButton<ThemeMode>), findsOneWidget);
        expect(
          tester
              .widget<SegmentedButton<ThemeMode>>(
                find.byType(SegmentedButton<ThemeMode>),
              )
              .selected,
          {ThemeMode.dark},
        );
      },
    );

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

      expect(find.byType(SettingsSection), findsNWidgets(5));
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

    group('replay walkthrough', () {
      late FakeFirebaseFirestore firestore;
      late SettingsRepository repo;
      late RecordingWalkthroughAnalytics analytics;

      setUp(() async {
        firestore = FakeFirebaseFirestore();
        repo = SettingsRepository(firestore: firestore);
        analytics = RecordingWalkthroughAnalytics();
        await firestore.collection('users').doc(walkthroughTestUid).set({
          'uid': walkthroughTestUid,
        });
        await repo.markWalkthroughFound(walkthroughTestUid, 'intro');
        await repo.markWalkthroughFound(walkthroughTestUid, 'quiz');
      });

      Future<List<String>> found() =>
          foundInFirestore(firestore, walkthroughTestUid);

      Future<void> pumpAndOpenDialog(WidgetTester tester) async {
        sizeViewport(tester);
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const WarmUser(child: SettingsScreen()),
            ),
            GoRoute(
              path: '/home',
              builder: (_, _) => const Scaffold(body: Text('Home stub')),
            ),
          ],
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: walkthroughOverrides(
              settings: repo.watchSettings(walkthroughTestUid),
              firestore: firestore,
              analytics: analytics,
            ),
            child: MaterialApp.router(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('en'),
              routerConfig: router,
            ),
          ),
        );
        await pumpUntilFound(tester, find.text('Replay walkthrough'));
        await tester.tap(find.text('Replay walkthrough'));
        await pumpUntilFound(tester, find.byType(AlertDialog));
        expect(find.byType(AlertDialog), findsOneWidget);
      }

      testWidgets('cancel leaves the found list alone', (tester) async {
        await pumpAndOpenDialog(tester);
        await tester.tap(find.text('Cancel'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(AlertDialog), findsNothing);
        expect(await found(), ['intro', 'quiz']);
        expect(analytics.events, isEmpty);
      });

      testWidgets('confirm empties the list, logs, and goes Home', (
        tester,
      ) async {
        await pumpAndOpenDialog(tester);
        await tester.tap(find.text('Replay'));
        await tester.pump();
        await settleWrites(tester);
        await pumpUntilFound(tester, find.text('Home stub'));

        expect(await found(), isEmpty);
        expect(analytics.events, ['reset']);
        expect(find.text('Home stub'), findsOneWidget);
      });

      testWidgets('the tile lives in the Support section', (tester) async {
        sizeViewport(tester);
        await tester.pumpWidget(
          createTestWidget(
            child: const SettingsScreen(),
            overrides: [
              userSettingsProvider.overrideWith(
                (_) => Stream.value(const UserSettingsModel()),
              ),
            ],
            locale: const Locale('en'),
          ),
        );
        await tester.pumpAndSettle();

        final support = find.ancestor(
          of: find.text('Replay walkthrough'),
          matching: find.byType(SettingsSection),
        );
        expect(tester.widget<SettingsSection>(support).title, 'Support');
      });
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
