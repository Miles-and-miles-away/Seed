import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/presentation/screens/action_log_screen.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_card.dart';

/// A tile in exactly the box the grid gives it, at the width of one
/// cell on a 402pt phone.
Widget _cell(double scale) {
  final scaler = TextScaler.linear(scale);
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(textScaler: scaler),
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: 179,
              height: ActionLogScreen.tileHeightFor(scaler),
              child: ActionTile(
                accentColor: Colors.amber,
                contentColor: Colors.amber,
                icon: Icons.bolt,
                // The tallest a tile gets: a title that wraps to the
                // two-line cap, plus the SDG badge row.
                title: 'Attend Eco Group Meeting About Something',
                badgeLabel: '21 points',
                footer: const SizedBox(height: 18, width: 60),
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('action tile height', () {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets('the tallest tile fits its cell at text scale $scale', (
        tester,
      ) async {
        await tester.pumpWidget(_cell(scale));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }

    test('the cell grows only by the text it holds', () {
      final single = ActionLogScreen.tileHeightFor(TextScaler.noScaling);
      final double_ = ActionLogScreen.tileHeightFor(TextScaler.linear(2));
      // The chrome -- accent bar, padding, icon, gaps -- does not
      // scale, so doubling the text must not double the cell.
      expect(double_, lessThan(single * 2));
      expect(double_, greaterThan(single));
    });
  });
}
