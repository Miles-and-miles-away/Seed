import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/app/app_bottom_nav.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';

void main() {
  Widget wrap({
    int? currentIndex,
    bool isActionSelected = false,
    ValueChanged<int>? onTabSelected,
    VoidCallback? onActionPressed,
    ValueChanged<bool>? onActionHover,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        bottomNavigationBar: AppBottomNav(
          currentIndex: currentIndex,
          isActionSelected: isActionSelected,
          onTabSelected: onTabSelected ?? (_) {},
          onActionPressed: onActionPressed ?? () {},
          onActionHover: onActionHover,
        ),
      ),
    );
  }

  group('AppBottomNav', () {
    testWidgets('renders all five navigation entries', (tester) async {
      await tester.pumpWidget(wrap());

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Progress'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
      expect(find.text('Mascot'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('reports the tapped tab index in bar order', (tester) async {
      final tapped = <int>[];
      await tester.pumpWidget(wrap(onTabSelected: tapped.add));

      await tester.tap(find.text('Home'));
      await tester.tap(find.text('Progress'));
      await tester.tap(find.text('Mascot'));
      await tester.tap(find.text('Profile'));
      await tester.pump();

      expect(tapped, [0, 1, 2, 3]);
    });

    testWidgets('invokes onActionPressed for the centre button', (
      tester,
    ) async {
      var pressed = 0;
      await tester.pumpWidget(wrap(onActionPressed: () => pressed++));

      await tester.tap(find.text('Action'));
      await tester.pump();

      expect(pressed, 1);
    });

    testWidgets('reports hover enter and exit on the centre button', (
      tester,
    ) async {
      final hovers = <bool>[];
      await tester.pumpWidget(wrap(onActionHover: hovers.add));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Action')));
      await tester.pump();
      expect(hovers, [true]);

      await gesture.moveTo(tester.getCenter(find.text('Home')));
      await tester.pump();
      expect(hovers, [true, false]);
    });

    testWidgets('shows the filled icon only for the selected tab', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(currentIndex: 1));

      // Selected tab uses the filled icon, the rest stay outlined.
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.home), findsNothing);
    });

    testWidgets('highlights the centre action when isActionSelected', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(isActionSelected: true));

      expect(find.byIcon(Icons.add_circle), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsNothing);
    });

    testWidgets('leaves the centre action unselected by default', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(currentIndex: 0));

      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.add_circle), findsNothing);
    });
  });
}
