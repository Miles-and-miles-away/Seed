import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/eco_fact/presentation/screens/eco_fact_detail_screen.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

const _uid = 'u1';

Future<List<String>> _viewedAfterOpening(
  WidgetTester tester,
  String dateKey,
) async {
  final firestore = FakeFirebaseFirestore();
  final userDoc = firestore.collection(AppConstants.collectionUsers).doc(_uid);
  await userDoc.set({'viewedFactDates': <String>[]});

  final container = ProviderContainer(
    overrides: [
      clockProvider.overrideWithValue(() => DateTime(2026, 6, 17, 12)),
      firestoreProvider.overrideWithValue(firestore),
      currentUserProvider.overrideWith(
        (_) => Stream.value(
          const AppUserModel(uid: _uid, email: 'u1@example.com'),
        ),
      ),
      isEcoFactLockedProvider.overrideWithValue(false),
      ecoFactsProvider.overrideWith(
        (_) async => const [
          EcoFact(
            dayOfYear: 1,
            category: 'positiveNews',
            nameEn: 'n',
            factEn: 'f',
            sourceEn: 's',
            relatedSdgs: [13],
          ),
        ],
      ),
    ],
  )..listen(currentUserProvider, (_, _) {});
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: EcoFactDetailScreen(dateKey: dateKey),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final doc = await userDoc.get();
  return (doc.data()!['viewedFactDates'] as List).cast<String>();
}

void main() {
  testWidgets('a date key marks the fact viewed', (tester) async {
    expect(await _viewedAfterOpening(tester, '2026-01-01'), ['2026-01-01']);
  });

  testWidgets('a deep link key that is not a date key stores nothing', (
    tester,
  ) async {
    // DateTime.tryParse accepts this, with a fraction of any length.
    final key = '2026-01-01T00:00:00.${'0' * 1000}';
    expect(DateTime.tryParse(key), DateTime(2026));

    expect(await _viewedAfterOpening(tester, key), isEmpty);
  });

  testWidgets('a key for a day that does not exist stores nothing', (
    tester,
  ) async {
    // DateTime.tryParse rolls month 99 over into a later year.
    expect(DateTime.tryParse('2026-99-99'), isNotNull);

    expect(await _viewedAfterOpening(tester, '2026-99-99'), isEmpty);
  });
}
