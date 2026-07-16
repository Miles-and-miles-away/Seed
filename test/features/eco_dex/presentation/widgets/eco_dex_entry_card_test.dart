import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/domain/models/eco_dex_entry_state.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_card.dart';

EcoDexEntry _entry({String id = 'e1', String nameEn = 'Forests'}) =>
    EcoDexEntry(
      id: id,
      category: 'forests',
      nameEn: nameEn,
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

void main() {
  Widget wrap(Widget child) => ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: Center(child: SizedBox(width: 100, height: 100, child: child)),
      ),
    ),
  );

  testWidgets('locked entry renders ??? label and lock icon', (tester) async {
    await tester.pumpWidget(
      wrap(
        EcoDexEntryCard(
          entryState: EcoDexEntryState(entry: _entry(), isDiscovered: false),
          locale: 'en',
        ),
      ),
    );

    expect(find.text('???'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });

  testWidgets('discovered entry shows the localized name', (tester) async {
    await tester.pumpWidget(
      wrap(
        EcoDexEntryCard(
          entryState: EcoDexEntryState(
            entry: _entry(nameEn: 'Bees'),
            isDiscovered: true,
          ),
          locale: 'en',
        ),
      ),
    );

    expect(find.text('Bees'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsNothing);
  });
}
