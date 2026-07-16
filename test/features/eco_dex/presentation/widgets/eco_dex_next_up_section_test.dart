import 'package:flutter/material.dart';
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
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_next_up_section.dart';

EcoDexEntry _entry(
  String id, {
  required EcoDexCondition condition,
  String? hintEn,
}) => EcoDexEntry(
  id: id,
  category: 'climate',
  nameEn: id,
  nameJa: '',
  nameEs: '',
  factEn: '',
  factJa: '',
  factEs: '',
  sourceUrl: '',
  iconName: id,
  condition: condition,
  hintEn: hintEn ?? 'hint-$id',
  hintJa: '',
  hintEs: '',
);

Widget _wrap({
  required List<EcoDexEntry> entries,
  required AppUserModel user,
  List<String> discovered = const [],
}) {
  final data = EcoDexData(
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
  return ProviderScope(
    overrides: [
      currentUserProvider.overrideWith((_) => Stream.value(user)),
      ecoDexDataProvider.overrideWith((_) async => data),
      ecoDexDiscoveredProvider.overrideWith((_) => discovered),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const Scaffold(
        body: SingleChildScrollView(child: EcoDexNextUpSection()),
      ),
    ),
  );
}

void main() {
  const user = AppUserModel(
    uid: 'u',
    email: 'e',
    totalActionsCount: 7,
    longestStreak: 3,
  );

  testWidgets('shows closest undiscovered entries sorted by progress', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        entries: [
          _entry('mid', condition: const EcoDexCondition.streakDays(days: 30)),
          _entry(
            'close',
            condition: const EcoDexCondition.totalActions(count: 10),
          ),
        ],
        user: user,
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Next Up'), findsOneWidget);
    expect(find.text('hint-close'), findsOneWidget);
    expect(find.text('hint-mid'), findsOneWidget);
    expect(find.text('7 / 10'), findsOneWidget);
    expect(find.text('3 / 30'), findsOneWidget);

    // Highest fraction (7/10) renders before lower fraction (3/30).
    final closeY = tester.getTopLeft(find.text('hint-close')).dy;
    final midY = tester.getTopLeft(find.text('hint-mid')).dy;
    expect(closeY, lessThan(midY));
  });

  testWidgets('excludes discovered, binary, and zero-progress entries '
      'and respects maxItems', (tester) async {
    await tester.pumpWidget(
      _wrap(
        entries: [
          _entry(
            'done',
            condition: const EcoDexCondition.totalActions(count: 5),
          ),
          _entry('binary', condition: const EcoDexCondition.profileComplete()),
          _entry(
            'zero',
            condition: const EcoDexCondition.co2Saved(grams: 5000),
          ),
          _entry('a', condition: const EcoDexCondition.totalActions(count: 10)),
          _entry('b', condition: const EcoDexCondition.totalActions(count: 20)),
          _entry('c', condition: const EcoDexCondition.totalActions(count: 50)),
          _entry(
            'd',
            condition: const EcoDexCondition.totalActions(count: 1000),
          ),
        ],
        user: user,
        discovered: const ['done'],
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('hint-done'), findsNothing);
    expect(find.text('hint-binary'), findsNothing);
    expect(find.text('hint-zero'), findsNothing);
    expect(find.text('hint-a'), findsOneWidget);
    expect(find.text('hint-b'), findsOneWidget);
    expect(find.text('hint-c'), findsOneWidget);
    // Fourth-best candidate falls outside maxItems (3).
    expect(find.text('hint-d'), findsNothing);
  });

  testWidgets('renders nothing when no candidate has progress', (tester) async {
    await tester.pumpWidget(
      _wrap(
        entries: [
          _entry(
            'zero',
            condition: const EcoDexCondition.co2Saved(grams: 5000),
          ),
        ],
        user: user,
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Next Up'), findsNothing);
  });

  testWidgets('tapping a card opens the locked sheet with progress', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        entries: [
          _entry(
            'close',
            condition: const EcoDexCondition.totalActions(count: 10),
          ),
        ],
        user: user,
      ),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('hint-close'));
    await tester.pumpAndSettle();

    expect(find.text('Undiscovered'), findsOneWidget);
    expect(find.text('7 / 10'), findsNWidgets(2));
  });
}
