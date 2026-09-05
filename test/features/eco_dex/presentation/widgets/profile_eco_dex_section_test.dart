import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_image.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/profile_eco_dex_section.dart';

import '../../../../helpers/test_helpers.dart';
import '../../eco_dex_fixtures.dart';

EcoDexEntry _entry(String id) => ecoDexEntry(
  id,
  category: 'climate',
  nameEn: 'name-$id',
  factEn: 'fact-$id',
);

List<Override> _overrides({
  required List<EcoDexEntry> entries,
  required List<String> discovered,
}) => [
  ecoDexDataProvider.overrideWith(
    (_) async => ecoDexDataFor(entries, category: climateCategory),
  ),
  ecoDexDiscoveredProvider.overrideWith((_) => discovered),
  ecoDexAvailableIconsProvider.overrideWith((_) async => <String>{}),
];

Widget _wrap({
  required List<EcoDexEntry> entries,
  required List<String> discovered,
}) => createTestWidget(
  overrides: _overrides(entries: entries, discovered: discovered),
  locale: const Locale('en'),
  scaffold: true,
  child: const ProfileEcoDexSection(),
);

void main() {
  group('ProfileEcoDexSection', () {
    testWidgets('renders count and empty hint when nothing discovered', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(entries: [_entry('e1'), _entry('e2')], discovered: const []),
      );
      await tester.pump();

      expect(find.text('0 / 2 discovered'), findsOneWidget);
      expect(find.textContaining('Log your first action'), findsOneWidget);
    });

    testWidgets('shows most recent discoveries with an overflow chip', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          entries: [for (var i = 1; i <= 5; i++) _entry('e$i')],
          discovered: const ['e1', 'e2', 'e3', 'e4'],
        ),
      );
      await tester.pump();

      // Three most recent thumbnails plus the "+1 more" chip.
      expect(find.byType(EcoDexEntryImage), findsNWidgets(3));
      expect(find.text('+1'), findsOneWidget);
      expect(find.text('4 / 5 discovered'), findsOneWidget);
    });

    testWidgets('tapping a thumbnail opens the entry sheet', (tester) async {
      await tester.pumpWidget(
        _wrap(entries: [_entry('e1')], discovered: const ['e1']),
      );
      await tester.pump();

      await tester.tap(find.byType(EcoDexEntryImage));
      await tester.pumpAndSettle();

      expect(find.text('fact-e1'), findsOneWidget);
    });

    testWidgets('tapping the card deep-links to the Eco-Dex tab', (
      tester,
    ) async {
      String? receivedTab;
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(body: ProfileEcoDexSection()),
          ),
          GoRoute(
            path: appRoutes.progress,
            builder: (_, state) {
              receivedTab = state.uri.queryParameters['tab'];
              return const Scaffold(body: Text('PROGRESS_SCREEN'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: _overrides(entries: [_entry('e1')], discovered: const []),
          child: MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            routerConfig: router,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(ProfileEcoDexSection));
      await tester.pumpAndSettle();

      expect(find.text('PROGRESS_SCREEN'), findsOneWidget);
      expect(receivedTab, 'ecodex');
    });
  });
}
