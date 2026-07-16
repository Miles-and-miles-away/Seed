import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_dex/data/eco_dex_entries_data.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_category_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_progress_header.dart';

EcoDexEntry _entry(String id) => EcoDexEntry(
  id: id,
  category: 'forests',
  nameEn: id,
  nameJa: '',
  nameEs: '',
  factEn: '',
  factJa: '',
  factEs: '',
  sourceUrl: '',
  iconName: id,
  condition: const EcoDexCondition.totalActions(count: 1),
  hintEn: '',
  hintJa: '',
  hintEs: '',
);

Widget _wrap({
  required List<EcoDexEntry> entries,
  required List<String> discovered,
}) {
  final data = EcoDexData(
    categories: const [
      EcoDexCategory(
        id: 'forests',
        nameEn: 'Forests',
        nameJa: '森',
        nameEs: 'Bosques',
      ),
    ],
    entries: entries,
  );
  return ProviderScope(
    overrides: [
      currentUserProvider.overrideWith(
        (_) => Stream.value(
          AppUserModel(uid: 'u', email: 'e', ecodexDiscovered: discovered),
        ),
      ),
      ecoDexDataProvider.overrideWith((_) async => data),
      // Bypass the kDebugMode-only debug force list so tests reflect only
      // the discovered set provided to _wrap.
      ecoDexDiscoveredProvider.overrideWith((_) => discovered),
    ],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: EcoDexProgressHeader(),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('progress bar is zero with nothing discovered', (tester) async {
    await tester.pumpWidget(
      _wrap(
        entries: [_entry('a'), _entry('b'), _entry('c')],
        discovered: const [],
      ),
    );
    await tester.pump();

    final bar = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, 0);
  });

  testWidgets('progress bar reflects discovery ratio', (tester) async {
    await tester.pumpWidget(
      _wrap(
        entries: [_entry('a'), _entry('b'), _entry('c'), _entry('d')],
        discovered: const ['a', 'b'],
      ),
    );
    await tester.pump();

    final bar = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, 0.5);
  });

  testWidgets('falls back to 0 progress when total is zero', (tester) async {
    await tester.pumpWidget(_wrap(entries: const [], discovered: const []));
    await tester.pump();

    final bar = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, 0);
  });

  testWidgets('info button opens the explainer sheet', (tester) async {
    await tester.pumpWidget(
      _wrap(entries: [_entry('a')], discovered: const []),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    expect(find.text('About the Eco-Dex'), findsOneWidget);
    expect(find.textContaining('unlock automatically'), findsOneWidget);
  });
}
