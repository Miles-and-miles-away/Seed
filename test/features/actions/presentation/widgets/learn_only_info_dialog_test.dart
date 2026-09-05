import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/widgets/learn_only_info_dialog.dart';
import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';

import '../../../../helpers/test_helpers.dart';

Widget _wrap() => createTestWidget(
  overrides: [
    sdgGoalsDataProvider.overrideWith(
      (_) async => const SdgGoalsData(goals: [], goalMap: {}),
    ),
  ],
  scaffold: true,
  child: const SizedBox(),
);

void main() {
  testWidgets('displays the action name and a dismiss button', (tester) async {
    await tester.pumpWidget(_wrap());

    final future = showDialog<void>(
      context: tester.element(find.byType(Scaffold)),
      builder: (_) => const LearnOnlyInfoDialog(
        action: ActionModel(
          id: 'learn-sign',
          nameEn: 'Sign petition',
          nameJa: 'サインする',
          category: 'advocacy',
          points: 0,
          isLearnOnly: true,
          relatedSdgs: ['13'],
        ),
        languageCode: 'en',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sign petition'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);

    // Dismiss so the showDialog future resolves and the test can finish.
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    await future;
  });

  testWidgets('pressing Dismiss closes the dialog', (tester) async {
    await tester.pumpWidget(_wrap());

    final future = showDialog<void>(
      context: tester.element(find.byType(Scaffold)),
      builder: (_) => const LearnOnlyInfoDialog(
        action: ActionModel(
          id: 'learn',
          nameEn: 'Learn',
          nameJa: '',
          category: 'learning',
          points: 0,
          isLearnOnly: true,
        ),
        languageCode: 'en',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    await future;
  });
}
