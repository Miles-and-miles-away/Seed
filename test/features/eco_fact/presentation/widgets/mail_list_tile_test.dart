import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/mail_list_tile.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('MailListTile', () {
    testWidgets('unread shows filled mail icon and dot', (tester) async {
      await tester.pumpWidget(
        wrap(
          MailListTile(
            subject: 'Hello',
            date: DateTime(2026, 4, 15),
            state: MailRowState.unread,
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mail), findsOneWidget);
      expect(find.byIcon(Icons.drafts_outlined), findsNothing);
      expect(find.byIcon(Icons.lock_outline), findsNothing);
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('read shows outline mail icon, no dot', (tester) async {
      await tester.pumpWidget(
        wrap(
          MailListTile(
            subject: 'Old',
            date: DateTime(2026, 1, 10),
            state: MailRowState.read,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.drafts_outlined), findsOneWidget);
      expect(find.byIcon(Icons.mail), findsNothing);
    });

    testWidgets('locked shows padlock icon', (tester) async {
      await tester.pumpWidget(
        wrap(
          MailListTile(
            subject: 'Locked',
            date: DateTime(2026, 4, 15),
            state: MailRowState.locked,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('tap fires callback when unread', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        wrap(
          MailListTile(
            subject: 'Tap me',
            date: DateTime(2026, 4, 15),
            state: MailRowState.unread,
            onTap: () => tapped++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tap me'));
      expect(tapped, 1);
    });
  });
}
