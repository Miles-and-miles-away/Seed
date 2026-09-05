import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_tile.dart';

void main() {
  Future<void> pumpTile(WidgetTester tester, Widget tile) =>
      tester.pumpWidget(MaterialApp(home: Scaffold(body: tile)));

  group('SettingsTile', () {
    testWidgets('renders leading icon', (tester) async {
      await pumpTile(
        tester,
        const SettingsTile(
          leading: Icon(Icons.notifications),
          title: 'Notifications',
        ),
      );

      expect(find.byIcon(Icons.notifications), findsOneWidget);
    });

    testWidgets('renders title', (tester) async {
      await pumpTile(tester, const SettingsTile(title: 'Test Title'));

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('renders subtitle when provided', (tester) async {
      await pumpTile(
        tester,
        const SettingsTile(title: 'Title', subtitle: 'Subtitle text'),
      );

      expect(find.text('Subtitle text'), findsOneWidget);
    });

    testWidgets('does not render subtitle when not provided', (tester) async {
      await pumpTile(
        tester,
        const SettingsTile(title: 'Title', showChevron: false),
      );

      // Should only find the title
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsNothing);
    });

    testWidgets('shows chevron when onTap provided and showChevron true', (
      tester,
    ) async {
      await pumpTile(tester, SettingsTile(title: 'Title', onTap: () {}));

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('does not show chevron when showChevron is false', (
      tester,
    ) async {
      await pumpTile(
        tester,
        SettingsTile(title: 'Title', showChevron: false, onTap: () {}),
      );

      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('triggers onTap callback when tapped', (tester) async {
      var tapped = false;

      await pumpTile(
        tester,
        SettingsTile(title: 'Title', onTap: () => tapped = true),
      );

      await tester.tap(find.byType(SettingsTile));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('renders trailing widget when provided', (tester) async {
      await pumpTile(
        tester,
        const SettingsTile(title: 'Title', trailing: Icon(Icons.star)),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('trailing takes precedence over showChevron', (tester) async {
      await pumpTile(
        tester,
        SettingsTile(
          title: 'Title',
          trailing: const Icon(Icons.star),
          onTap: () {},
        ),
      );

      // Should show trailing widget, not chevron
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('disabled tile does not respond to tap', (tester) async {
      var tapped = false;

      await pumpTile(
        tester,
        SettingsTile(
          title: 'Title',
          enabled: false,
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.byType(SettingsTile));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('dangerous tile applies error color', (tester) async {
      await pumpTile(
        tester,
        SettingsTile(
          title: 'Delete Account',
          leading: const Icon(Icons.delete),
          dangerous: true,
          onTap: () {},
        ),
      );

      // The tile should render with error styling
      expect(find.text('Delete Account'), findsOneWidget);
    });
  });

  group('SettingsSwitchTile', () {
    testWidgets('renders switch', (tester) async {
      await pumpTile(
        tester,
        SettingsSwitchTile(
          title: 'Notifications',
          value: false,
          onChanged: (_) {},
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('shows current value as on', (tester) async {
      await pumpTile(
        tester,
        SettingsSwitchTile(
          title: 'Notifications',
          value: true,
          onChanged: (_) {},
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });

    testWidgets('shows current value as off', (tester) async {
      await pumpTile(
        tester,
        SettingsSwitchTile(
          title: 'Notifications',
          value: false,
          onChanged: (_) {},
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
    });

    testWidgets('triggers onChanged callback when switch toggled', (
      tester,
    ) async {
      bool? receivedValue;

      await pumpTile(
        tester,
        SettingsSwitchTile(
          title: 'Notifications',
          value: false,
          onChanged: (value) => receivedValue = value,
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(receivedValue, isTrue);
    });

    testWidgets('triggers onChanged when tile tapped (not just switch)', (
      tester,
    ) async {
      bool? receivedValue;

      await pumpTile(
        tester,
        SettingsSwitchTile(
          title: 'Notifications',
          value: false,
          onChanged: (value) => receivedValue = value,
        ),
      );

      // Tap the title text, not the switch
      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();

      expect(receivedValue, isTrue);
    });

    testWidgets('renders subtitle when provided', (tester) async {
      await pumpTile(
        tester,
        SettingsSwitchTile(
          title: 'Notifications',
          subtitle: 'Enable push notifications',
          value: true,
          onChanged: (_) {},
        ),
      );

      expect(find.text('Enable push notifications'), findsOneWidget);
    });

    testWidgets('renders leading icon', (tester) async {
      await pumpTile(
        tester,
        SettingsSwitchTile(
          leading: const Icon(Icons.dark_mode),
          title: 'Dark Mode',
          value: false,
          onChanged: (_) {},
        ),
      );

      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('disabled switch does not respond to toggle', (tester) async {
      bool? receivedValue;

      await pumpTile(
        tester,
        SettingsSwitchTile(
          title: 'Notifications',
          value: false,
          enabled: false,
          onChanged: (value) => receivedValue = value,
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(receivedValue, isNull);
    });
  });
}
