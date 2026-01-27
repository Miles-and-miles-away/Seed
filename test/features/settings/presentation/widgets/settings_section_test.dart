import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_section.dart';

void main() {
  Widget createTestWidget({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('SettingsSection', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsSection(
            title: 'Notifications',
            children: [
              ListTile(title: Text('Item 1')),
            ],
          ),
        ),
      );

      expect(find.text('NOTIFICATIONS'), findsOneWidget);
    });

    testWidgets('renders children', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsSection(
            title: 'Test Section',
            children: [
              ListTile(title: Text('First Item')),
              ListTile(title: Text('Second Item')),
            ],
          ),
        ),
      );

      expect(find.text('First Item'), findsOneWidget);
      expect(find.text('Second Item'), findsOneWidget);
    });

    testWidgets('shows divider when showTopDivider is true', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsSection(
            title: 'Section',
            showTopDivider: true,
            children: [
              ListTile(title: Text('Item')),
            ],
          ),
        ),
      );

      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('does not show top divider by default', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsSection(
            title: 'Section',
            children: [
              ListTile(title: Text('Item')),
            ],
          ),
        ),
      );

      // Should not find any divider when showTopDivider is false (default)
      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('applies correct title styling', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsSection(
            title: 'Section',
            children: [
              ListTile(title: Text('Item')),
            ],
          ),
        ),
      );

      // Title should be uppercased
      expect(find.text('SECTION'), findsOneWidget);
      expect(find.text('Section'), findsNothing);
    });

    testWidgets('renders with empty children list', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsSection(
            title: 'Empty Section',
            children: <Widget>[],
          ),
        ),
      );

      expect(find.text('EMPTY SECTION'), findsOneWidget);
    });

    testWidgets('renders multiple items correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsSection(
            title: 'Multiple Items',
            children: [
              ListTile(title: Text('Item 1')),
              ListTile(title: Text('Item 2')),
              ListTile(title: Text('Item 3')),
            ],
          ),
        ),
      );

      expect(find.byType(ListTile), findsNWidgets(3));
    });
  });
}
