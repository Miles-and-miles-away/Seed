import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/auth/presentation/screens/login_screen.dart';
import 'package:seed_app/features/auth/presentation/screens/register_screen.dart';
import 'package:seed_app/features/auth/presentation/widgets/language_pill.dart';
import 'package:seed_app/features/settings/presentation/providers/language_sync_provider.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/widgets/language_picker_sheet.dart';
import 'package:seed_app/shared/data/language_store.dart';
import 'package:seed_app/shared/providers/app_language_provider.dart';

import '../../../../helpers/test_helpers.dart';

const _uid = 'u';

/// MaterialApp on the app language, with the language sync running, as
/// SeedApp has it.
class _LocalisedApp extends ConsumerWidget {
  const _LocalisedApp(this.home);

  final Widget home;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(languageSyncProvider, (_, _) {});
    return MaterialApp(
      locale: ref.watch(appLocaleProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );
  }
}

String _welcome(String code) =>
    lookupAppLocalizations(Locale(code)).authWelcomeBack;

void main() {
  late StreamController<User?> auth;
  late FakeFirebaseFirestore firestore;
  late MemoryLanguageStore store;

  setUp(() {
    auth = StreamController<User?>.broadcast();
    addTearDown(auth.close);
    firestore = FakeFirebaseFirestore();
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    StoredLanguage stored = returningDevice,
    Widget home = const LoginScreen(),
  }) async {
    store = MemoryLanguageStore(stored);
    final firebaseAuth = createMockFirebaseAuth(authStateChanges: auth.stream);
    when(() => firebaseAuth.setLanguageCode(any())).thenAnswer((_) async {});
    sizeViewport(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          languageStoreOverride(store),
          osLocalesProvider.overrideWithBuild((_, _) => const [Locale('en')]),
          firebaseAuthProvider.overrideWithValue(firebaseAuth),
          firestoreProvider.overrideWithValue(firestore),
        ],
        child: _LocalisedApp(home),
      ),
    );
    await tester.pumpAndSettle();
  }

  ProviderContainer containerOf(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));

  testWidgets('a Spanish user who signs out sees sign-in in Spanish', (
    tester,
  ) async {
    await firestore.collection(AppConstants.collectionUsers).doc(_uid).set({
      AppConstants.fieldLanguage: 'es',
      AppConstants.fieldSettings: {AppConstants.fieldLanguage: 'es'},
    });
    await pumpApp(tester);
    expect(find.text(_welcome('en')), findsOneWidget);

    auth.add(createMockUser(uid: _uid));
    await tester.pumpAndSettle();
    expect(find.text(_welcome('es')), findsOneWidget);

    auth.add(null);
    await tester.pumpAndSettle();
    expect(find.text(_welcome('es')), findsOneWidget);
    expect(store.value.pick?.language, 'es');
  });

  group('first launch', () {
    testWidgets('picking a language applies it and closes the sheet', (
      tester,
    ) async {
      await pumpApp(tester, stored: noStoredLanguage);
      expect(find.byType(LanguagePickerSheet), findsOneWidget);

      await tester.tap(find.text('日本語'));
      await tester.pumpAndSettle();

      expect(find.byType(LanguagePickerSheet), findsNothing);
      expect(find.text(_welcome('ja')), findsOneWidget);
      expect(store.value, (
        pick: (language: 'ja', os: 'en'),
        firstLaunchDone: true,
      ));
    });

    testWidgets('dismissing keeps following the device language', (
      tester,
    ) async {
      await pumpApp(tester, stored: noStoredLanguage);

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.byType(LanguagePickerSheet), findsNothing);
      expect(store.value, returningDevice);

      containerOf(
        tester,
      ).read(osLocalesProvider.notifier).update(const [Locale('es', 'ES')]);
      await tester.pumpAndSettle();
      expect(find.text(_welcome('es')), findsOneWidget);
    });

    testWidgets('the next launch does not reopen it', (tester) async {
      await pumpApp(tester, stored: noStoredLanguage);
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      await tester.pumpWidget(const SizedBox());
      await pumpApp(tester, stored: store.value);

      expect(find.byType(LanguagePickerSheet), findsNothing);
    });

    testWidgets('it does not open after a sign-in and sign-out', (
      tester,
    ) async {
      await pumpApp(tester, stored: noStoredLanguage, home: const SizedBox());
      auth.add(createMockUser(uid: _uid));
      await tester.pumpAndSettle();
      auth.add(null);
      await tester.pumpAndSettle();

      await tester.pumpWidget(const SizedBox());
      await pumpApp(tester, stored: store.value);

      expect(find.byType(LanguagePickerSheet), findsNothing);
    });
  });

  group('language pill', () {
    for (final (name, screen) in [
      ('login', const LoginScreen()),
      ('register', const RegisterScreen()),
    ]) {
      testWidgets('opens the picker on $name', (tester) async {
        await pumpApp(tester, home: screen);

        await tester.tap(find.byType(LanguagePill));
        await tester.pumpAndSettle();

        expect(find.byType(LanguagePickerSheet), findsOneWidget);
      });
    }

    testWidgets('is labelled with the language and has a 48dp target', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester);

      expect(find.bySemanticsLabel('Language: English'), findsOneWidget);
      final button = tester.getSize(
        find.descendant(
          of: find.byType(LanguagePill),
          matching: find.byType(TextButton),
        ),
      );
      expect(button.height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(button.width, greaterThanOrEqualTo(kMinInteractiveDimension));
      semantics.dispose();
    });
  });

  for (final language in ['ja', 'es']) {
    for (final width in testPhoneWidths) {
      testWidgets('pill and sheet fit in $language at ${width}pt, scale 2', (
        tester,
      ) async {
        await loadTestFonts();
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await pumpApp(
          tester,
          stored: (
            pick: (language: language, os: 'en'),
            firstLaunchDone: false,
          ),
        );
        sizeViewport(tester, size: Size(width, 800));
        await tester.pumpAndSettle();

        expect(find.byType(LanguagePickerSheet), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
