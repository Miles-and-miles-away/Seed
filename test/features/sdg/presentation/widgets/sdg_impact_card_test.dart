import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/sdg/presentation/widgets/sdg_impact_card.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  Widget wrap(Widget child, {AppUserModel? user}) => createTestWidget(
    scaffold: true,
    overrides: [userOverride(user)],
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );

  testWidgets('shows zero counts when the user has no logged impact', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const SdgImpactCard(goalNumber: 7, goalColor: Colors.orange)),
    );
    await tester.pump();

    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('renders the user stats for the target SDG', (tester) async {
    await tester.pumpWidget(
      wrap(
        const SdgImpactCard(goalNumber: 11, goalColor: Colors.orange),
        user: const AppUserModel(
          uid: 'u',
          email: 'e',
          sdgStats: {
            '11': {'count': 4, 'co2': 2500},
          },
        ),
      ),
    );
    await tester.pump();

    expect(find.text('4'), findsOneWidget);
    // formatCO2Compact(2500) = "2.5kg".
    expect(find.text('2.5kg'), findsOneWidget);
  });
}
