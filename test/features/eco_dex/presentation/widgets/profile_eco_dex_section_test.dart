import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_dex/data/eco_dex_entries_data.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_category_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_image.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/profile_eco_dex_section.dart';

EcoDexEntry _entry(String id) => EcoDexEntry(
      id: id,
      category: 'climate',
      nameEn: 'name-$id',
      nameJa: '',
      nameEs: '',
      factEn: 'fact-$id',
      factJa: '',
      factEs: '',
      sourceUrl: '',
      iconName: id,
      condition: const EcoDexCondition.totalActions(count: 1),
      hintEn: '',
      hintJa: '',
      hintEs: '',
    );

EcoDexData _data(List<EcoDexEntry> entries) => EcoDexData(
      categories: const [
        EcoDexCategory(
          id: 'climate',
          nameEn: 'Climate',
          nameJa: '気候',
          nameEs: 'Clima',
        ),
      ],
      entries: entries,
    );

Widget _scoped({
  required List<EcoDexEntry> entries,
  required List<String> discovered,
  required Widget child,
}) {
  return ProviderScope(
    overrides: [
      ecoDexDataProvider.overrideWith((_) async => _data(entries)),
      ecoDexDiscoveredProvider.overrideWith((_) => discovered),
      ecoDexAvailableIconsProvider.overrideWith((_) async => <String>{}),
    ],
    child: child,
  );
}

Widget _wrap({
  required List<EcoDexEntry> entries,
  required List<String> discovered,
}) {
  return _scoped(
    entries: entries,
    discovered: discovered,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const Scaffold(body: ProfileEcoDexSection()),
    ),
  );
}

void main() {
  group('ProfileEcoDexSection', () {
    testWidgets('renders count and empty hint when nothing discovered',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          entries: [_entry('e1'), _entry('e2')],
          discovered: const [],
        ),
      );
      await tester.pump();

      expect(find.text('0 / 2 discovered'), findsOneWidget);
      expect(
        find.textContaining('Log your first action'),
        findsOneWidget,
      );
    });

    testWidgets('shows most recent discoveries with an overflow chip',
        (tester) async {
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
        _wrap(
          entries: [_entry('e1')],
          discovered: const ['e1'],
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(EcoDexEntryImage));
      await tester.pumpAndSettle();

      expect(find.text('fact-e1'), findsOneWidget);
    });

    testWidgets('tapping the card deep-links to the Eco-Dex tab',
        (tester) async {
      String? receivedTab;
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const Scaffold(
              body: ProfileEcoDexSection(),
            ),
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
        _scoped(
          entries: [_entry('e1')],
          discovered: const [],
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
