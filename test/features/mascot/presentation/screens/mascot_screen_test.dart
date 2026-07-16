import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/data/mascot_species_loader.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/screens/mascot_screen.dart';

const _localizationDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

final _testMascot = MascotModel(
  id: 'm1',
  speciesId: 'seed',
  name: 'Sprouty',
  mascotLevel: 5,
  co2SavedGrams: 1500,
  // Pinned to 2026-01-01 so DateFormat.yMMMd('en') yields "Jan 1, 2026";
  // the month/day literals are intentional even though they are the defaults.
  // ignore: avoid_redundant_argument_values
  createdAt: DateTime(2026, 1, 1),
);

const _testUser = AppUserModel(uid: 'u1', email: 'u@example.com');

void main() {
  // The real mascotSpeciesDataProvider loads bundled assets so the species
  // ("seed") resolves and the screen renders past its loading spinner.
  final overrides = [
    currentUserProvider.overrideWith((_) => Stream.value(_testUser)),
    activeMascotProvider.overrideWith((_) => Stream.value(_testMascot)),
    allMascotsProvider.overrideWith((_) => Stream.value([_testMascot])),
  ];

  // Give the test a tall viewport so the whole scrolling screen (stats
  // section, rename icon) is laid out and findable without scrolling, and so
  // the layout does not overflow the default 800x600 surface.
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
  // (cache-warmed) species future and the overridden mascot streams can emit
  // and the screen rebuild past its loading spinner.
  Future<void> pumpUntilFound(WidgetTester tester, Finder finder) async {
    for (var i = 0; i < 30 && finder.evaluate().isEmpty; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
  }

  Future<void> pumpMascotScreen(WidgetTester tester) async {
    await sizeViewport(tester);
    await warmSpeciesBundle(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: const MaterialApp(
          localizationsDelegates: _localizationDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MascotScreen(),
        ),
      ),
    );
    // The "Our Journey" title only appears once the active mascot + species
    // have resolved.
    await pumpUntilFound(tester, find.text('Our Journey'));
  }

  Future<void> disposeAndFlush(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('MascotScreen', () {
    testWidgets('renders the Our Journey section and mascot name', (
      tester,
    ) async {
      await pumpMascotScreen(tester);

      expect(find.text('Our Journey'), findsOneWidget);
      expect(find.text('Sprouty'), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('shows formatted birthday, CO2 together and days label', (
      tester,
    ) async {
      await pumpMascotScreen(tester);

      // DateFormat.yMMMd('en') for DateTime(2026, 1, 1).
      expect(find.text('Jan 1, 2026'), findsOneWidget);
      // formatCO2Compact(1500) -> "1.5kg".
      expect(find.text('1.5kg'), findsOneWidget);
      // Exact count depends on today's date; just assert the label exists.
      expect(find.text('Days together'), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('tapping the rename icon reveals an editable field', (
      tester,
    ) async {
      await pumpMascotScreen(tester);

      expect(find.byType(TextField), findsNothing);

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);

      await disposeAndFlush(tester);
    });
  });
}
