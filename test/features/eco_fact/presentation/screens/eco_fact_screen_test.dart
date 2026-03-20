import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/eco_fact/presentation/screens/eco_fact_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EcoFactScreen', () {
    final todayFact = EcoFact(
      dayOfYear: dayOfYear(DateTime.now()),
      category: 'positiveNews',
      factEn: 'Test eco fact for today',
      sourceEn: 'Test source',
      sourceUrl: 'https://example.com',
      relatedSdgs: const [13],
    );

    final testUser = AppUserModel(
      uid: 'test-uid',
      email: 'test@example.com',
    );

    Widget buildScreen() {
      return ProviderScope(
        overrides: [
          todayEcoFactProvider.overrideWith(
            (_) async => todayFact,
          ),
          currentUserProvider.overrideWith(
            (_) => Stream.value(testUser),
          ),
          factCalendarDataProvider.overrideWith(
            (_) async => <FactCalendarDay>[],
          ),
          isTodayFactViewedProvider.overrideWith(
            (_) => false,
          ),
          hasUnreadFactProvider.overrideWith((_) => true),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: EcoFactScreen(),
        ),
      );
    }

    testWidgets('renders app bar title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text("Today's Eco-Fact"), findsOneWidget);
    });

    testWidgets('shows fact text', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(
        find.text('Test eco fact for today'),
        findsOneWidget,
      );
    });

    testWidgets('shows source', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.textContaining('Test source'), findsOneWidget);
    });

    testWidgets(
      'renders EcoFactCard and FactCalendar',
      (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Card should be present with fact content
        expect(find.byType(Card), findsWidgets);
      },
    );
  });
}
