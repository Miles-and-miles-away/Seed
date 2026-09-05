import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/eco_dex/domain/models/eco_dex_entry_state.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_card.dart';

import '../../../../helpers/test_helpers.dart';
import '../../eco_dex_fixtures.dart';

void main() {
  Widget wrap(Widget child) => createTestWidget(
    scaffold: true,
    child: Center(child: SizedBox(width: 100, height: 100, child: child)),
  );

  testWidgets('locked entry renders ??? label and lock icon', (tester) async {
    await tester.pumpWidget(
      wrap(
        EcoDexEntryCard(
          entryState: EcoDexEntryState(
            entry: ecoDexEntry('e1'),
            isDiscovered: false,
          ),
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
            entry: ecoDexEntry('e1', nameEn: 'Bees'),
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
