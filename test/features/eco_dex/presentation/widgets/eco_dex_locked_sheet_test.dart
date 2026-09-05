import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_locked_sheet.dart';

import '../../../../helpers/test_helpers.dart';
import '../../eco_dex_fixtures.dart';

void main() {
  Widget wrap(Widget child, {AppUserModel? user}) => createTestWidget(
    overrides: [userOverride(user)],
    scaffold: true,
    child: child,
  );

  EcoDexEntry makeEntry({
    String hintEn = 'Walk five times',
    String hintEs = '',
    EcoDexCondition condition = const EcoDexCondition.totalActions(count: 5),
  }) => ecoDexEntry(
    'e1',
    category: 'transport',
    nameEn: 'Walking',
    iconName: 'walking',
    hintEn: hintEn,
    hintEs: hintEs,
    condition: condition,
  );

  testWidgets('shows lock icon and hint in the active locale', (tester) async {
    await tester.pumpWidget(
      wrap(EcoDexLockedSheet(entry: makeEntry(), locale: 'en')),
    );
    await tester.pump();

    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.text('Walk five times'), findsOneWidget);
  });

  testWidgets('falls back to English when localized hint is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        EcoDexLockedSheet(
          entry: makeEntry(hintEn: 'English hint'),
          locale: 'es',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('English hint'), findsOneWidget);
  });

  testWidgets('uses the Spanish hint when provided', (tester) async {
    await tester.pumpWidget(
      wrap(
        EcoDexLockedSheet(
          entry: makeEntry(hintEn: 'EN', hintEs: 'Pista española'),
          locale: 'es',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Pista española'), findsOneWidget);
  });

  testWidgets('shows progress toward a numeric condition', (tester) async {
    await tester.pumpWidget(
      wrap(
        EcoDexLockedSheet(entry: makeEntry(), locale: 'en'),
        user: const AppUserModel(uid: 'u', email: 'e', totalActionsCount: 3),
      ),
    );
    await tester.pump();

    expect(find.text('3 / 5'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('hides progress for a binary condition', (tester) async {
    await tester.pumpWidget(
      wrap(
        EcoDexLockedSheet(
          entry: makeEntry(condition: const EcoDexCondition.profileComplete()),
          locale: 'en',
        ),
        user: const AppUserModel(uid: 'u', email: 'e'),
      ),
    );
    await tester.pump();

    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('hides progress when no user is signed in', (tester) async {
    await tester.pumpWidget(
      wrap(EcoDexLockedSheet(entry: makeEntry(), locale: 'en')),
    );
    await tester.pump();

    expect(find.byType(LinearProgressIndicator), findsNothing);
  });
}
