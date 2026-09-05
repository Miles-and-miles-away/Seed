import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_progress_header.dart';

import '../../../../helpers/test_helpers.dart';
import '../../eco_dex_fixtures.dart';

Widget _wrap({
  required List<EcoDexEntry> entries,
  required List<String> discovered,
}) => createTestWidget(
  overrides: [
    userOverride(
      AppUserModel(uid: 'u', email: 'e', ecodexDiscovered: discovered),
    ),
    ecoDexDataProvider.overrideWith((_) async => ecoDexDataFor(entries)),
    // Bypass the kDebugMode-only debug force list so tests reflect only
    // the discovered set provided to _wrap.
    ecoDexDiscoveredProvider.overrideWith((_) => discovered),
  ],
  scaffold: true,
  child: const Padding(
    padding: EdgeInsets.all(16),
    child: EcoDexProgressHeader(),
  ),
);

void main() {
  testWidgets('progress bar is zero with nothing discovered', (tester) async {
    await tester.pumpWidget(
      _wrap(
        entries: [ecoDexEntry('a'), ecoDexEntry('b'), ecoDexEntry('c')],
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
        entries: [
          ecoDexEntry('a'),
          ecoDexEntry('b'),
          ecoDexEntry('c'),
          ecoDexEntry('d'),
        ],
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
      _wrap(entries: [ecoDexEntry('a')], discovered: const []),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    expect(find.text('About the Eco-Dex'), findsOneWidget);
    expect(find.textContaining('unlock automatically'), findsOneWidget);
  });
}
