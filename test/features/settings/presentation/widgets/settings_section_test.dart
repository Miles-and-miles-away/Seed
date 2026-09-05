import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_section.dart';

void main() {
  Future<void> pumpSection(
    WidgetTester tester, {
    String title = 'Section',
    bool showTopDivider = false,
    List<Widget> children = const [ListTile(title: Text('Item'))],
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettingsSection(
            title: title,
            showTopDivider: showTopDivider,
            children: children,
          ),
        ),
      ),
    );
  }

  group('SettingsSection', () {
    testWidgets('renders title', (tester) async {
      await pumpSection(
        tester,
        title: 'Notifications',
        children: const [ListTile(title: Text('Item 1'))],
      );

      expect(find.text('NOTIFICATIONS'), findsOneWidget);
    });

    testWidgets('renders children', (tester) async {
      await pumpSection(
        tester,
        title: 'Test Section',
        children: const [
          ListTile(title: Text('First Item')),
          ListTile(title: Text('Second Item')),
        ],
      );

      expect(find.text('First Item'), findsOneWidget);
      expect(find.text('Second Item'), findsOneWidget);
    });

    testWidgets('shows divider when showTopDivider is true', (tester) async {
      await pumpSection(tester, showTopDivider: true);

      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('does not show top divider by default', (tester) async {
      await pumpSection(tester);

      // Should not find any divider when showTopDivider is false (default)
      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('applies correct title styling', (tester) async {
      await pumpSection(tester);

      // Title should be uppercased
      expect(find.text('SECTION'), findsOneWidget);
      expect(find.text('Section'), findsNothing);
    });

    testWidgets('renders with empty children list', (tester) async {
      await pumpSection(
        tester,
        title: 'Empty Section',
        children: const <Widget>[],
      );

      expect(find.text('EMPTY SECTION'), findsOneWidget);
    });

    testWidgets('renders multiple items correctly', (tester) async {
      await pumpSection(
        tester,
        title: 'Multiple Items',
        children: const [
          ListTile(title: Text('Item 1')),
          ListTile(title: Text('Item 2')),
          ListTile(title: Text('Item 3')),
        ],
      );

      expect(find.byType(ListTile), findsNWidgets(3));
    });
  });
}
