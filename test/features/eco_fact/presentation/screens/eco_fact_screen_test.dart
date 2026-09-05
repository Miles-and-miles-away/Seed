import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/eco_fact/presentation/screens/eco_fact_screen.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/mail_list_tile.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  EcoFactInboxItem buildItem({
    required DateTime date,
    required bool isRead,
    required bool isLocked,
    String name = 'Test subject',
  }) {
    final fact = EcoFact(
      dayOfYear: dayOfYear(date),
      category: 'positiveNews',
      nameEn: name,
      factEn: 'Body text',
      sourceEn: 'Test source',
      relatedSdgs: const [13],
    );
    return EcoFactInboxItem(
      date: date,
      dateKey: formatDateKey(date),
      fact: fact,
      isRead: isRead,
      isLocked: isLocked,
    );
  }

  Widget buildScreen(List<EcoFactInboxItem> items) => createTestWidget(
    overrides: [ecoFactInboxProvider.overrideWith((_) async => items)],
    child: const EcoFactScreen(),
  );

  group('EcoFactScreen (inbox)', () {
    testWidgets('renders Inbox app bar title', (tester) async {
      await tester.pumpWidget(buildScreen([]));
      await tester.pumpAndSettle();

      expect(find.text('Inbox'), findsOneWidget);
    });

    testWidgets('shows empty state when no items', (tester) async {
      await tester.pumpWidget(buildScreen([]));
      await tester.pumpAndSettle();

      expect(find.textContaining('No mail yet'), findsOneWidget);
      expect(find.byType(MailListTile), findsNothing);
    });

    testWidgets('renders a row per inbox item', (tester) async {
      final items = [
        buildItem(
          date: DateTime.now(),
          isRead: false,
          isLocked: false,
          name: 'Unread today',
        ),
        buildItem(
          date: DateTime.now().subtract(const Duration(days: 3)),
          isRead: true,
          isLocked: false,
          name: 'Read earlier',
        ),
      ];
      await tester.pumpWidget(buildScreen(items));
      await tester.pumpAndSettle();

      expect(find.byType(MailListTile), findsNWidgets(2));
      expect(find.text('Unread today'), findsOneWidget);
      expect(find.text('Read earlier'), findsOneWidget);
    });

    testWidgets('locked today row shows locked subject', (tester) async {
      final items = [
        buildItem(
          date: DateTime.now(),
          isRead: false,
          isLocked: true,
          name: 'Should be hidden',
        ),
      ];
      await tester.pumpWidget(buildScreen(items));
      await tester.pumpAndSettle();

      expect(find.text('Locked eco-fact'), findsOneWidget);
      expect(find.text('Should be hidden'), findsNothing);
    });
  });
}
