import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/eco_fact_card.dart';
import 'package:seed_app/features/progress/presentation/widgets/day_detail_bottom_sheet.dart';

import '../../../../helpers/test_helpers.dart';

ActionLogModel _log({
  required String id,
  required DateTime loggedAt,
  int points = 10,
  int co2Grams = 100,
}) {
  return ActionLogModel(
    id: id,
    actionId: 'action-$id',
    actionName: 'Action $id',
    category: 'food',
    points: points,
    loggedAt: loggedAt,
    co2Grams: co2Grams,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final fakeFacts = List<EcoFact>.generate(
    366,
    (i) => EcoFact(
      dayOfYear: i + 1,
      category: 'positiveNews',
      factEn: 'Fact for day ${i + 1}',
      sourceEn: 'Test source',
    ),
  );

  Widget buildHarness({
    required AppUserModel user,
    required List<ActionLogModel> logs,
    required DateTime date,
  }) {
    return createTestWidget(
      firestore: FakeFirebaseFirestore(),
      overrides: [
        userOverride(user),
        actionsForDayProvider.overrideWith(
          (_, day) async => logs
              .where(
                (l) =>
                    l.loggedAt.year == day.year &&
                    l.loggedAt.month == day.month &&
                    l.loggedAt.day == day.day,
              )
              .toList(),
        ),
        ecoFactsProvider.overrideWith((_) => Future.value(fakeFacts)),
      ],
      child: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => DayDetailBottomSheet.show(context, date: date),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openSheet(WidgetTester tester) async {
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  const baseUser = AppUserModel(uid: 'u1', email: 'test@example.com');

  group('DayDetailBottomSheet', () {
    testWidgets('shows stats and action list for day with activity', (
      tester,
    ) async {
      final date = DateTime(2024, 5, 10);
      final logs = [
        _log(
          id: 'a',
          loggedAt: DateTime(2024, 5, 10, 9),
          points: 15,
          co2Grams: 500,
        ),
        _log(
          id: 'b',
          loggedAt: DateTime(2024, 5, 10, 14),
          points: 25,
          co2Grams: 1500,
        ),
      ];

      await tester.pumpWidget(
        buildHarness(user: baseUser, logs: logs, date: date),
      );
      await openSheet(tester);

      // Action names rendered
      expect(find.text('Action a'), findsOneWidget);
      expect(find.text('Action b'), findsOneWidget);

      // Count stat = 2
      expect(find.text('2'), findsOneWidget);
      // Points total 40
      expect(find.text('40'), findsOneWidget);
      // CO2 total 2000g → "2.0kg"
      expect(find.text('2.0kg'), findsOneWidget);
    });

    testWidgets('filters out actions from other days', (tester) async {
      final target = DateTime(2024, 5, 10);
      final logs = [
        _log(id: 'keep', loggedAt: DateTime(2024, 5, 10, 9)),
        _log(id: 'drop', loggedAt: DateTime(2024, 5, 9, 23, 59)),
        _log(id: 'drop2', loggedAt: DateTime(2024, 5, 11, 0, 1)),
      ];

      await tester.pumpWidget(
        buildHarness(user: baseUser, logs: logs, date: target),
      );
      await openSheet(tester);

      expect(find.text('Action keep'), findsOneWidget);
      expect(find.text('Action drop'), findsNothing);
      expect(find.text('Action drop2'), findsNothing);
    });

    testWidgets('shows empty state when no actions that day', (tester) async {
      await tester.pumpWidget(
        buildHarness(
          user: baseUser,
          logs: const [],
          date: DateTime(2024, 5, 10),
        ),
      );
      await openSheet(tester);

      expect(find.text('No actions logged this day'), findsOneWidget);
    });

    testWidgets('today with completed challenge shows unlocked fact card', (
      tester,
    ) async {
      final today = DateTime.now();
      final todayKey = formatDateKey(today);
      final user = baseUser.copyWith(challengeCompletedDate: todayKey);

      await tester.pumpWidget(
        buildHarness(
          user: user,
          logs: const [],
          date: DateTime(today.year, today.month, today.day),
        ),
      );
      await openSheet(tester);

      final card = tester.widget<EcoFactCard>(find.byType(EcoFactCard));
      expect(card.isLocked, isFalse);
    });

    testWidgets('today with incomplete challenge shows locked fact card', (
      tester,
    ) async {
      final today = DateTime.now();

      await tester.pumpWidget(
        buildHarness(
          user: baseUser,
          logs: const [],
          date: DateTime(today.year, today.month, today.day),
        ),
      );
      await openSheet(tester);

      final card = tester.widget<EcoFactCard>(find.byType(EcoFactCard));
      expect(card.isLocked, isTrue);
    });

    testWidgets('past day in unlockedFactDates shows unlocked fact card', (
      tester,
    ) async {
      final past = DateTime(2024, 3, 14);
      final user = baseUser.copyWith(unlockedFactDates: [formatDateKey(past)]);

      await tester.pumpWidget(
        buildHarness(user: user, logs: const [], date: past),
      );
      await openSheet(tester);

      final card = tester.widget<EcoFactCard>(find.byType(EcoFactCard));
      expect(card.isLocked, isFalse);
    });

    testWidgets('past day not in any unlock set shows no-fact panel', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildHarness(
          user: baseUser,
          logs: const [],
          date: DateTime(2024, 3, 14),
        ),
      );
      await openSheet(tester);

      expect(find.byType(EcoFactCard), findsNothing);
      expect(find.text('No eco-fact unlocked this day'), findsOneWidget);
    });
  });
}
