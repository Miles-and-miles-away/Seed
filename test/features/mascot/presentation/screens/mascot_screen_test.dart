import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/mascot/data/mascot_species_loader.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/screens/mascot_screen.dart';

import '../../../../helpers/test_helpers.dart';

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
    userOverride(_testUser),
    activeMascotProvider.overrideWith((_) => Stream.value(_testMascot)),
    allMascotsProvider.overrideWith((_) => Stream.value([_testMascot])),
  ];

  // Warm the bundled species asset on the real event loop. rootBundle IO does
  // not run under the fake test clock, so without this the species future
  // resolves on the first test only and later tests stay on the loading
  // spinner. Warming inside runAsync populates rootBundle's cache so the
  // provider resolves on the next pump in every test.
  Future<void> warmSpeciesBundle(WidgetTester tester) async {
    await tester.runAsync(loadMascotSpecies);
  }

  Future<void> pumpMascotScreen(WidgetTester tester) async {
    sizeViewport(tester);
    await warmSpeciesBundle(tester);
    await tester.pumpWidget(
      createTestWidget(overrides: overrides, child: const MascotScreen()),
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
