import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/presentation/widgets/rainbow_sun_painter.dart';
import 'package:seed_app/features/progress/presentation/widgets/rainbow_sun_widget.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(child: SizedBox(width: 200, height: 200, child: child)),
        ),
      );

  group('RainbowSunWidget', () {
    final colors = List<Color>.generate(17, (_) => Colors.red);

    // Finder for the CustomPaint *inside* RainbowSunWidget — there can be
    // wrapper CustomPaints (RepaintBoundary implementation details) above it.
    Finder innerCustomPaint() => find.descendant(
          of: find.byType(RainbowSunWidget),
          matching: find.byWidgetPredicate(
            (w) => w is CustomPaint && w.painter is RainbowSunPainter,
          ),
        );

    testWidgets('renders a CustomPaint with the rainbow sun painter',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          RainbowSunWidget(
            goalCount: 2,
            goalTarget: 3,
            completedSdgs: const [1, 2],
            sdgColors: colors,
          ),
        ),
      );

      expect(innerCustomPaint(), findsOneWidget);
    });

    testWidgets('rebuilds with updated completedSdgs', (tester) async {
      Widget build(List<int> completed) => wrap(
            RainbowSunWidget(
              goalCount: 1,
              goalTarget: 3,
              completedSdgs: completed,
              sdgColors: colors,
            ),
          );

      await tester.pumpWidget(build(const [1]));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(build(const [1, 2]));
      await tester.pump();

      final painter = tester.widget<CustomPaint>(innerCustomPaint()).painter!
          as RainbowSunPainter;
      expect(painter.completedSdgs, [1, 2]);
    });
  });

  group('EmptyRainbowSun', () {
    testWidgets('renders the call-to-action text', (tester) async {
      await tester.pumpWidget(wrap(const EmptyRainbowSun()));

      expect(find.text('Complete goals to grow your sun!'), findsOneWidget);
    });
  });
}
