import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/data/mascot_species_loader.dart';
import 'package:seed_app/features/mascot/presentation/screens/mascot_selection_screen.dart';

const _localizationDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

void main() {
  // The real mascotSpeciesDataProvider loads bundled SVG assets, so the
  // MascotAvatar can render. currentUserProvider is forced to null so the
  // notifier's selectMascot returns early (no Firestore needed). A fresh
  // override list is built per pump so closures are not shared across the
  // independent ProviderScopes each test creates.
  ProviderScope wrap(Widget child) => ProviderScope(
        overrides: [
          currentUserProvider.overrideWith((_) => Stream.value(null)),
        ],
        child: child,
      );

  // Give the test a tall viewport so the full-height selection screen does
  // not overflow the default 800x600 surface (an overflow throws and tears
  // down the tree, breaking later finders).
  Future<void> sizeViewport(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  // Warm the bundled species asset on the real event loop. rootBundle IO does
  // not run under the fake test clock, so without this the species future
  // resolves on the first test only and later tests stay on the loading
  // spinner. Warming inside runAsync populates rootBundle's cache so the
  // provider resolves on the next pump in every test.
  Future<void> warmSpeciesBundle(WidgetTester tester) async {
    await tester.runAsync(loadMascotSpecies);
  }

  // Pump until [finder] resolves or the budget runs out. Used instead of
  // pumpAndSettle because the mascot has infinite idle animations that never
  // settle. Each step yields to the real event loop via runAsync so the
  // (cache-warmed) species future can complete and the screen rebuild past
  // its loading spinner.
  Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder,
  ) async {
    for (var i = 0; i < 30 && finder.evaluate().isEmpty; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
  }

  Future<void> pumpSelectionScreen(WidgetTester tester) async {
    await sizeViewport(tester);
    await warmSpeciesBundle(tester);
    await tester.pumpWidget(
      wrap(
        const MaterialApp(
          localizationsDelegates: _localizationDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MascotSelectionScreen(),
        ),
      ),
    );
    await pumpUntilFound(tester, find.byType(TextFormField));
  }

  // Dispose the tree and flush pending zero-duration animation timers.
  Future<void> disposeAndFlush(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('MascotSelectionScreen', () {
    testWidgets('renders title, name field and confirm button', (tester) async {
      await pumpSelectionScreen(tester);

      expect(find.text('Choose Your Companion'), findsOneWidget);
      expect(find.text('Give your companion a name'), findsOneWidget);
      expect(find.text("Let's Grow Together!"), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('empty name shows the required-name error', (tester) async {
      await pumpSelectionScreen(tester);

      await tester.enterText(find.byType(TextFormField), '');
      await tester.tap(find.text("Let's Grow Together!"));
      await tester.pump();

      expect(find.text('Please enter a name'), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('21-character name shows the too-long error', (tester) async {
      await pumpSelectionScreen(tester);

      await tester.enterText(find.byType(TextFormField), 'A' * 21);
      await tester.tap(find.text("Let's Grow Together!"));
      await tester.pump();

      expect(
        find.text('Name must be 20 characters or less'),
        findsOneWidget,
      );

      await disposeAndFlush(tester);
    });

    testWidgets('single-character name is valid and navigates home',
        (tester) async {
      await sizeViewport(tester);
      await warmSpeciesBundle(tester);
      final router = GoRouter(
        initialLocation: '/mascot-selection',
        routes: [
          GoRoute(
            path: '/mascot-selection',
            builder: (_, __) => const MascotSelectionScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (_, __) => const Scaffold(
              body: Text('HOME-OK'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        wrap(
          MaterialApp.router(
            localizationsDelegates: _localizationDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
      await pumpUntilFound(tester, find.byType(TextFormField));

      await tester.enterText(find.byType(TextFormField), 'A');
      await tester.tap(find.text("Let's Grow Together!"));
      await tester.pump();
      await tester.pump();

      // Navigation to /home means the validator passed (1 char is valid).
      expect(find.text('HOME-OK'), findsOneWidget);
      expect(find.text('Please enter a name'), findsNothing);
      expect(
        find.text('Name must be 20 characters or less'),
        findsNothing,
      );

      await disposeAndFlush(tester);
    });
  });
}
