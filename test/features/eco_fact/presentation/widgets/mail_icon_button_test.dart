import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/mail_icon_button.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('MailIconButton', () {
    Widget buildWidget({bool hasUnread = true}) => createTestWidget(
      overrides: [hasUnreadFactProvider.overrideWith((_) => hasUnread)],
      child: const Scaffold(appBar: _TestAppBar()),
    );

    testWidgets('renders mail icon', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mail_outline), findsOneWidget);
    });

    testWidgets('shows badge when unread', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      final badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.isLabelVisible, isTrue);
    });

    testWidgets('hides badge when read', (tester) async {
      await tester.pumpWidget(buildWidget(hasUnread: false));
      await tester.pumpAndSettle();

      final badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.isLabelVisible, isFalse);
    });

    testWidgets('renders as IconButton', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(IconButton), findsOneWidget);
    });
  });
}

class _TestAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _TestAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(actions: const [MailIconButton()]);
  }
}
