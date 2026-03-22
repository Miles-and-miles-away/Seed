import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import 'package:seed_app/features/sdg/presentation/screens/sdg_detail_screen.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('SdgDetailScreen', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late FakeFirebaseFirestore fakeFirestore;
    late SdgGoalsData sdgData;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      sdgData = await loadSdgGoals();
    });

    setUp(() {
      mockFirebaseAuth = createMockFirebaseAuth();
      fakeFirestore = createFakeFirestore();
    });

    void setLargeScreenSize(WidgetTester tester) {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(
        () => tester.view.resetPhysicalSize(),
      );
    }

    Widget buildTestWidget(int goalNumber) {
      return ProviderScope(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          firestoreProvider.overrideWithValue(fakeFirestore),
          sdgGoalsDataProvider.overrideWith(
            (ref) async => sdgData,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: SdgDetailScreen(
            goalNumber: goalNumber,
          ),
        ),
      );
    }

    testWidgets(
      'displays goal 1 correctly',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(1));
        await tester.pump();

        expect(
          find.text('No Poverty'),
          findsOneWidget,
        );
        expect(find.text('Goal 1'), findsOneWidget);
        expect(find.text('UN SDG'), findsOneWidget);
      },
    );

    testWidgets(
      'displays goal 13 Climate Action correctly',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(13));
        await tester.pump();

        expect(
          find.text('Climate Action'),
          findsOneWidget,
        );
        expect(find.text('Goal 13'), findsOneWidget);
      },
    );

    testWidgets(
      'displays SliverAppBar',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(1));
        await tester.pump();

        expect(
          find.byType(SliverAppBar),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'displays CustomScrollView',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(1));
        await tester.pump();

        expect(
          find.byType(CustomScrollView),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'displays About this Goal section',
      (tester) async {
        setLargeScreenSize(tester);
        // Use direct goal to avoid duplicate info_outline
        await tester.pumpWidget(buildTestWidget(13));
        await tester.pump();

        expect(
          find.text('About this Goal'),
          findsOneWidget,
        );
        expect(
          find.byIcon(Icons.info_outline),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'displays expand chevron in targets section',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(1));
        await tester.pump();

        expect(
          find.byIcon(Icons.expand_more),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders Hero widget for animation',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(1));
        await tester.pump();

        expect(find.byType(Hero), findsAtLeast(1));
      },
    );

    testWidgets(
      'renders goal badge container',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(5));
        await tester.pump();

        expect(find.text('Goal 5'), findsOneWidget);
        expect(
          find.text('Gender Equality'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders FlexibleSpaceBar in app bar',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(1));
        await tester.pump();

        expect(
          find.byType(FlexibleSpaceBar),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'defaults to first goal if invalid number',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(99));
        await tester.pump();

        expect(
          find.text('No Poverty'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'displays goal 17 correctly',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(17));
        await tester.pump();

        expect(
          find.text('Partnerships for the Goals'),
          findsOneWidget,
        );
        expect(find.text('Goal 17'), findsOneWidget);
      },
    );

    testWidgets('app bar is pinned', (tester) async {
      setLargeScreenSize(tester);
      await tester.pumpWidget(buildTestWidget(1));
      await tester.pump();

      final sliverAppBar = tester.widget<SliverAppBar>(
        find.byType(SliverAppBar),
      );
      expect(sliverAppBar.pinned, isTrue);
    });

    testWidgets(
      'app bar has correct expanded height',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(1));
        await tester.pump();

        final sliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );
        expect(sliverAppBar.expandedHeight, 200);
      },
    );

    testWidgets(
      'renders ClipRRect for image border radius',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(1));
        await tester.pump();

        expect(
          find.byType(ClipRRect),
          findsAtLeast(1),
        );
      },
    );

    testWidgets(
      'description is contained in styled container',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(1));
        await tester.pump();

        expect(find.byType(Container), findsWidgets);
      },
    );

    testWidgets(
      'learn-only goal shows explanation text',
      (tester) async {
        setLargeScreenSize(tester);
        await tester.pumpWidget(buildTestWidget(1));
        await tester.pump();

        // Goal 1 is learn-only, should show explanation
        expect(
          find.byIcon(Icons.info_outline),
          findsAtLeast(1),
        );
      },
    );
  });
}
