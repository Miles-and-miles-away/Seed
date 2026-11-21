import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/app/app_bottom_nav.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';

import '../features/walkthrough/walkthrough_test_support.dart';
import '../helpers/test_helpers.dart';

void main() {
  Widget wrap({
    int? currentIndex,
    bool isActionSelected = false,
    ValueChanged<int>? onTabSelected,
    VoidCallback? onActionPressed,
    ValueChanged<bool>? onActionHover,
    double textScale = 1.0,
    List<Override> overrides = const [],
    Locale? locale,
    ThemeData? theme,
  }) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        theme: theme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: Scaffold(
          bottomNavigationBar: AppBottomNav(
            currentIndex: currentIndex,
            isActionSelected: isActionSelected,
            onTabSelected: onTabSelected ?? (_) {},
            onActionPressed: onActionPressed ?? () {},
            onActionHover: onActionHover,
          ),
        ),
      ),
    );
  }

  group('AppBottomNav', () {
    testWidgets('shimmers the Progress, Action and Explore items while '
        'pending', (tester) async {
      await tester.pumpWidget(
        wrap(
          overrides: walkthroughOverrides(
            settings: Stream.value(settingsWith([WalkthroughItem.intro])),
          ),
        ),
      );
      await tester.pump();

      final shimmers = tester
          .widgetList<WalkthroughShimmer>(find.byType(WalkthroughShimmer))
          .map((s) => (s.item, s.orItem));
      expect(shimmers, [
        (WalkthroughItem.progress, null),
        (WalkthroughItem.logAction, null),
        (WalkthroughItem.calculators, WalkthroughItem.quiz),
      ]);
      expect(find.byType(Animate), findsNWidgets(3));
      await flushOverlayTimers(tester);
    });

    testWidgets('the Explore item still sweeps while only the quiz is '
        'pending', (tester) async {
      await tester.pumpWidget(
        wrap(
          overrides: walkthroughOverrides(
            settings: Stream.value(
              settingsWith(
                WalkthroughItem.values.where((i) => i != WalkthroughItem.quiz),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Animate), findsOneWidget);
      expect(
        find.ancestor(of: find.text('Explore'), matching: find.byType(Animate)),
        findsOneWidget,
      );
      await flushOverlayTimers(tester);
    });

    testWidgets('renders all five navigation entries', (tester) async {
      await tester.pumpWidget(wrap());

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Progress'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Mascot'), findsNothing);
    });

    testWidgets('reports the tapped tab index in bar order', (tester) async {
      final tapped = <int>[];
      await tester.pumpWidget(wrap(onTabSelected: tapped.add));

      await tester.tap(find.text('Home'));
      await tester.tap(find.text('Progress'));
      await tester.tap(find.text('Explore'));
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

  group('at large text scales', () {
    // The bar is a fixed row of five destinations, so it overflowed by
    // 4.7pt once the user's text setting passed about 1.8 -- on every
    // screen, since every primary screen shows this bar.
    for (final scale in [1.0, 1.3, 2.0, 3.0]) {
      testWidgets('nothing overflows at text scale $scale', (tester) async {
        tester.view.physicalSize = const Size(402, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(wrap(currentIndex: 0, textScale: scale));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Home'), findsOneWidget);
      });
    }

    testWidgets('labels stop growing, so the bar stays a bar', (tester) async {
      // Material clamps its own NavigationBar labels at 1.3 for the
      // same reason. Past that the bar must not keep growing.
      tester.view.physicalSize = const Size(402, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(wrap(currentIndex: 0));
      await tester.pumpAndSettle();
      final atDefault = tester.getSize(find.byType(BottomAppBar)).height;

      await tester.pumpWidget(wrap(currentIndex: 0, textScale: 1.3));
      await tester.pumpAndSettle();
      final atClamp = tester.getSize(find.byType(BottomAppBar)).height;

      await tester.pumpWidget(wrap(currentIndex: 0, textScale: 3));
      await tester.pumpAndSettle();
      final atTriple = tester.getSize(find.byType(BottomAppBar)).height;

      expect(atDefault, 65, reason: 'the default height is unchanged');
      expect(atClamp, greaterThan(atDefault));
      expect(atTriple, atClamp);
    });

    testWidgets('a label still renders at its normal size by default', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(currentIndex: 0));
      await tester.pumpAndSettle();

      // Read as a value per pump: the render object is reused across
      // pumps, so holding a reference compares the new size with
      // itself and passes whatever the code does.
      final atDefault = tester.getSize(find.text('Home')).height;

      await tester.pumpWidget(wrap(currentIndex: 0, textScale: 1.3));
      await tester.pumpAndSettle();
      final atClamp = tester.getSize(find.text('Home')).height;

      await tester.pumpWidget(wrap(currentIndex: 0, textScale: 3));
      await tester.pumpAndSettle();
      final atTriple = tester.getSize(find.text('Home')).height;

      expect(
        atClamp,
        greaterThan(atDefault),
        reason: 'clamping must not freeze labels at the default size',
      );
      expect(atTriple, atClamp, reason: 'and must stop at the clamp');
    });
  });
  group('five labels at text scale 1.0', () {
    // Japanese uses the default test font, whose 1em glyphs match kana.
    final japanese = ThemeData(fontFamily: 'FlutterTest');

    setUpAll(loadTestFonts);

    const selections = [0, 1, 2, 3];

    Future<void> expectNoLabelScaled(
      WidgetTester tester, {
      required double width,
      required Locale locale,
      ThemeData? theme,
    }) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      // Every label at the selected weight, the widest it draws.
      for (final index in selections) {
        await tester.pumpWidget(
          wrap(
            currentIndex: index,
            isActionSelected: true,
            locale: locale,
            theme: theme,
          ),
        );
        await tester.pumpAndSettle();
        final labels = tester.renderObjectList<RenderParagraph>(
          find.descendant(
            of: find.byType(FittedBox),
            matching: find.byType(RichText),
          ),
        );
        expect(labels, hasLength(5));
        for (final label in labels) {
          final drawn = MatrixUtils.transformRect(
            label.getTransformTo(null),
            Offset.zero & label.size,
          );
          expect(
            drawn.width,
            closeTo(label.size.width, 0.01),
            reason: '${label.text.toPlainText()} at ${width}pt',
          );
        }
      }
    }

    for (final width in testPhoneWidths.where((w) => w >= 360)) {
      testWidgets('no Japanese label shrinks at ${width}pt', (tester) async {
        await expectNoLabelScaled(
          tester,
          width: width,
          locale: const Locale('ja'),
          theme: japanese,
        );
      });

      testWidgets('no Spanish label shrinks at ${width}pt, on Android and '
          'iOS', (tester) async {
        for (final factor in [1.0, robotoToSfWidthFactor]) {
          await expectNoLabelScaled(
            tester,
            width: width * factor,
            locale: const Locale('es'),
          );
        }
      });
    }
  });
}
