import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/data/sdg_targets.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import 'package:seed_app/features/sdg/presentation/widgets/sdg_targets_section.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  const testGoal = SdgGoal(
    number: 13,
    titleEn: 'Climate Action',
    shortTitleEn: 'Climate Action',
    descriptionEn:
        'Take urgent action to combat climate '
        'change and its impacts.',
    color: Color(0xFF407F46),
    iconUrl: 'https://example.com/icon13.jpg',
  );

  late Map<int, List<SdgTarget>> allTargets;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final jsonString = await rootBundle.loadString('data/app/sdg_targets.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    allTargets = {};
    for (final entry in json.entries) {
      final goalNumber = int.parse(entry.key);
      final targets = (entry.value as List<dynamic>)
          .map((e) => SdgTarget.fromJson(e as Map<String, dynamic>))
          .toList();
      allTargets[goalNumber] = targets;
    }
  });

  Widget buildTestWidget({SdgGoal goal = testGoal}) {
    return createTestWidget(
      scaffold: true,
      overrides: [
        sdgTargetsDataProvider.overrideWith((ref) async => allTargets),
      ],
      child: SingleChildScrollView(
        child: SdgTargetsSection(goal: goal, locale: 'en'),
      ),
    );
  }

  group('SdgTargetsSection', () {
    testWidgets('displays "About this Goal" header', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('About this Goal'), findsOneWidget);
    });

    testWidgets('displays info_outline icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('displays goal description', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text(testGoal.description('en')), findsOneWidget);
    });

    testWidgets('displays expand_more chevron icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.expand_more), findsOneWidget);
    });

    testWidgets('targets section is collapsed by default', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      final crossFade = tester.widget<AnimatedCrossFade>(
        find.byType(AnimatedCrossFade),
      );
      expect(crossFade.crossFadeState, CrossFadeState.showFirst);
    });

    testWidgets('tapping header expands targets section', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.text('About this Goal'));
      await tester.pumpAndSettle();

      expect(find.text('UN Targets'), findsOneWidget);
    });

    testWidgets('shows correct target count for goal 13', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.text('About this Goal'));
      await tester.pumpAndSettle();

      final targets = allTargets[13]!;
      for (final target in targets) {
        expect(find.text(target.code), findsOneWidget);
      }
    });

    testWidgets('shows correct target count for goal 1', (tester) async {
      const goal1 = SdgGoal(
        number: 1,
        titleEn: 'No Poverty',
        shortTitleEn: 'No Poverty',
        descriptionEn: 'End poverty in all its forms.',
        color: Color(0xFFE5233D),
        iconUrl: 'https://example.com/icon1.jpg',
      );
      await tester.pumpWidget(buildTestWidget(goal: goal1));
      await tester.pump();

      await tester.tap(find.text('About this Goal'));
      await tester.pumpAndSettle();

      final targets = allTargets[1]!;
      expect(targets.length, 7);
      expect(find.text('1.1'), findsOneWidget);
      expect(find.text('1.b'), findsOneWidget);
    });

    testWidgets('tapping header twice collapses targets', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.text('About this Goal'));
      await tester.pumpAndSettle();
      final expanded = tester.widget<AnimatedCrossFade>(
        find.byType(AnimatedCrossFade),
      );
      expect(expanded.crossFadeState, CrossFadeState.showSecond);

      await tester.tap(find.text('About this Goal'));
      await tester.pumpAndSettle();
      final collapsed = tester.widget<AnimatedCrossFade>(
        find.byType(AnimatedCrossFade),
      );
      expect(collapsed.crossFadeState, CrossFadeState.showFirst);
    });

    testWidgets('target code badges have goal color', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.text('About this Goal'));
      await tester.pumpAndSettle();

      final codeFinder = find.text('13.1');
      expect(codeFinder, findsOneWidget);

      final text = tester.widget<Text>(codeFinder);
      expect(text.style?.color, testGoal.color);
    });

    testWidgets('renders AnimatedCrossFade for expand animation', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(AnimatedCrossFade), findsOneWidget);
    });

    testWidgets('renders AnimatedRotation for chevron', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(AnimatedRotation), findsOneWidget);
    });

    testWidgets('handles goal with many targets (goal 17)', (tester) async {
      const goal17 = SdgGoal(
        number: 17,
        titleEn: 'Partnerships for the Goals',
        shortTitleEn: 'Partnerships',
        descriptionEn: 'Strengthen partnerships.',
        color: Color(0xFF13496B),
        iconUrl: 'https://example.com/icon17.jpg',
      );
      await tester.pumpWidget(buildTestWidget(goal: goal17));
      await tester.pump();

      await tester.tap(find.text('About this Goal'));
      await tester.pumpAndSettle();

      expect(find.text('UN Targets'), findsOneWidget);
      expect(find.text('17.1'), findsOneWidget);
    });

    testWidgets('wraps in styled Container with border', (tester) async {
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
    });
  });
}
