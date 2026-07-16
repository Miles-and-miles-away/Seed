import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/shared/widgets/info_sheet.dart';

void main() {
  group('InfoSheet', () {
    testWidgets('renders title and body', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoSheet(title: 'How it works', body: 'Body copy.'),
          ),
        ),
      );

      expect(find.text('How it works'), findsOneWidget);
      expect(find.text('Body copy.'), findsOneWidget);
    });

    testWidgets('show() opens the sheet modally', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () =>
                    InfoSheet.show(context, title: 'Title', body: 'Body'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(InfoSheet), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });
  });
}
