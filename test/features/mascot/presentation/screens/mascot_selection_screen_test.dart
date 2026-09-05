import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/data/mascot_species_loader.dart';
import 'package:seed_app/features/mascot/presentation/screens/mascot_selection_screen.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  // The real mascotSpeciesDataProvider loads bundled SVG assets, so the
  // MascotAvatar can render. The validation-only tests force
  // currentUserProvider to null so selectMascot never reaches Firestore;
  // the navigation test supplies a real user instead. A fresh override is
  // built per pump so closures are not shared across the independent
  // ProviderScopes each test creates.

  // Warm the bundled species asset on the real event loop. rootBundle IO does
  // not run under the fake test clock, so without this the species future
  // resolves on the first test only and later tests stay on the loading
  // spinner. Warming inside runAsync populates rootBundle's cache so the
  // provider resolves on the next pump in every test.
  Future<void> warmSpeciesBundle(WidgetTester tester) async {
    await tester.runAsync(loadMascotSpecies);
  }

  Future<void> pumpSelectionScreen(WidgetTester tester) async {
    sizeViewport(tester);
    await warmSpeciesBundle(tester);
    await tester.pumpWidget(
      createTestWidget(
        overrides: [userOverride(null)],
        child: const MascotSelectionScreen(),
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

      expect(find.text('Name must be 20 characters or less'), findsOneWidget);

      await disposeAndFlush(tester);
    });

    testWidgets('single-character name is valid and navigates home', (
      tester,
    ) async {
      sizeViewport(tester);
      await warmSpeciesBundle(tester);
      final router = GoRouter(
        initialLocation: '/mascot-selection',
        routes: [
          GoRoute(
            path: '/mascot-selection',
            builder: (_, _) => const MascotSelectionScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (_, _) => const Scaffold(body: Text('HOME-OK')),
          ),
        ],
      );

      // A real user and Firestore: navigating home has to follow an actual
      // successful write, not a no-op that leaves the state untouched.
      final firestore = FakeFirebaseFirestore();
      await firestore
          .collection(AppConstants.collectionUsers)
          .doc('u')
          .set(<String, dynamic>{});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userOverride(const AppUserModel(uid: 'u', email: 'e')),
            firestoreProvider.overrideWithValue(firestore),
          ],
          // app.dart keeps currentUserProvider alive through the theme
          // seed; with no watcher it is autoDispose and each read of it
          // is a fresh loading state with a null user.
          child: Consumer(
            builder: (_, ref, _) {
              ref.watch(currentUserProvider);
              return MaterialApp.router(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: router,
              );
            },
          ),
        ),
      );
      await pumpUntilFound(tester, find.byType(TextFormField));

      await tester.enterText(find.byType(TextFormField), 'A');
      await tester.tap(find.text("Let's Grow Together!"));
      await pumpUntilFound(tester, find.text('HOME-OK'));

      // Navigation to /home means the validator passed (1 char is valid).
      expect(find.text('HOME-OK'), findsOneWidget);
      expect(find.text('Please enter a name'), findsNothing);
      expect(find.text('Name must be 20 characters or less'), findsNothing);

      await disposeAndFlush(tester);
    });
  });
}
