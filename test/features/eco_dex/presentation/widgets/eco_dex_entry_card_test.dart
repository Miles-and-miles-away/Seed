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

  final scalers = {
    '1.0': TextScaler.noScaling,
    '1.3': const TextScaler.linear(1.3),
    '2.0': const TextScaler.linear(2),
    'Android nonlinear 200%': const NonlinearScaler200(),
  };
  for (final MapEntry(key: name, value: scaler) in scalers.entries) {
    testWidgets('a two-line name fits the grid cell at text scale $name', (
      tester,
    ) async {
      // The cell a 4-column grid gives a card on a 320pt phone.
      const cellWidth = 63.0;
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: MediaQuery(
            data: MediaQueryData(textScaler: scaler),
            child: Center(
              child: SizedBox(
                width: cellWidth,
                height: EcoDexEntryCard.heightFor(scaler),
                child: EcoDexEntryCard(
                  entryState: EcoDexEntryState(
                    entry: ecoDexEntry('e1', nameEn: 'Circular Economy Vision'),
                    isDiscovered: true,
                  ),
                  locale: 'en',
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  }
}
