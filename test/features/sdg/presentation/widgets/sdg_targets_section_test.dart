import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/data/sdg_targets.dart';
import 'package:seed_app/features/sdg/presentation/widgets/sdg_targets_section.dart';

void main() {
  const testGoal = SdgGoal(
    number: 13,
    title: 'Climate Action',
    shortTitle: 'Climate Action',
    description: 'Take urgent action to combat climate '
        'change and its impacts.',
    color: Color(0xFF407F46),
    iconUrl: 'https://example.com/icon13.jpg',
  );

  Widget buildTestWidget({SdgGoal goal = testGoal}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: SdgTargetsSection(
            goal: goal,
            locale: 'en',
          ),
        ),
      ),
    );
  }

  group('SdgTargetsSection', () {
    testWidgets(
      'displays "About this Goal" header',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        expect(
          find.text('About this Goal'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'displays info_outline icon',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        expect(
          find.byIcon(Icons.info_outline),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'displays goal description',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        expect(
          find.text(testGoal.description),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'displays expand_more chevron icon',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        expect(
          find.byIcon(Icons.expand_more),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'targets section is collapsed by default',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        // AnimatedCrossFade should show first child
        final crossFade = tester.widget<AnimatedCrossFade>(
          find.byType(AnimatedCrossFade),
        );
        expect(
          crossFade.crossFadeState,
          CrossFadeState.showFirst,
        );
      },
    );

    testWidgets(
      'tapping header expands targets section',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        await tester.tap(
          find.text('About this Goal'),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('UN Targets'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows correct target count for goal 13',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        await tester.tap(
          find.text('About this Goal'),
        );
        await tester.pumpAndSettle();

        final targets = sdgTargets[13]!;
        for (final target in targets) {
          expect(
            find.text(target.code),
            findsOneWidget,
          );
        }
      },
    );

    testWidgets(
      'shows correct target count for goal 1',
      (tester) async {
        const goal1 = SdgGoal(
          number: 1,
          title: 'No Poverty',
          shortTitle: 'No Poverty',
          description: 'End poverty in all its forms.',
          color: Color(0xFFE5233D),
          iconUrl: 'https://example.com/icon1.jpg',
        );
        await tester.pumpWidget(
          buildTestWidget(goal: goal1),
        );
        await tester.pump();

        await tester.tap(
          find.text('About this Goal'),
        );
        await tester.pumpAndSettle();

        final targets = sdgTargets[1]!;
        expect(targets.length, 7);
        expect(find.text('1.1'), findsOneWidget);
        expect(find.text('1.b'), findsOneWidget);
      },
    );

    testWidgets(
      'tapping header twice collapses targets',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        // Expand
        await tester.tap(
          find.text('About this Goal'),
        );
        await tester.pumpAndSettle();
        final expanded = tester.widget<AnimatedCrossFade>(
          find.byType(AnimatedCrossFade),
        );
        expect(
          expanded.crossFadeState,
          CrossFadeState.showSecond,
        );

        // Collapse
        await tester.tap(
          find.text('About this Goal'),
        );
        await tester.pumpAndSettle();
        final collapsed = tester.widget<AnimatedCrossFade>(
          find.byType(AnimatedCrossFade),
        );
        expect(
          collapsed.crossFadeState,
          CrossFadeState.showFirst,
        );
      },
    );

    testWidgets(
      'target code badges have goal color',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        await tester.tap(
          find.text('About this Goal'),
        );
        await tester.pumpAndSettle();

        // Find code badge text
        final codeFinder = find.text('13.1');
        expect(codeFinder, findsOneWidget);

        final text = tester.widget<Text>(codeFinder);
        expect(
          text.style?.color,
          testGoal.color,
        );
      },
    );

    testWidgets(
      'renders AnimatedCrossFade for expand animation',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        expect(
          find.byType(AnimatedCrossFade),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders AnimatedRotation for chevron',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        expect(
          find.byType(AnimatedRotation),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'handles goal with many targets (goal 17)',
      (tester) async {
        const goal17 = SdgGoal(
          number: 17,
          title: 'Partnerships for the Goals',
          shortTitle: 'Partnerships',
          description: 'Strengthen partnerships.',
          color: Color(0xFF13496B),
          iconUrl: 'https://example.com/icon17.jpg',
        );
        await tester.pumpWidget(
          buildTestWidget(goal: goal17),
        );
        await tester.pump();

        await tester.tap(
          find.text('About this Goal'),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('UN Targets'),
          findsOneWidget,
        );
        expect(find.text('17.1'), findsOneWidget);
      },
    );

    testWidgets(
      'wraps in styled Container with border',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.byType(SdgTargetsSection),
                matching: find.byType(Container),
              )
              .first,
        );
        expect(container.decoration, isNotNull);
      },
    );
  });
}
