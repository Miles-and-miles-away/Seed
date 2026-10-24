import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/ja_phrase.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/shared/data/language_store.dart';
import 'package:seed_app/shared/providers/app_language_provider.dart';

import 'memory_language_store.dart';

export 'memory_language_store.dart';

// =============================================================================
// Mock Classes
// =============================================================================

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUserInfo extends Mock implements UserInfo {}

// =============================================================================
// Test Wrapper Widget
// =============================================================================

/// Wraps a widget with MaterialApp and ProviderScope for testing.
Widget createTestWidget({
  required Widget child,
  FirebaseAuth? firebaseAuth,
  FirebaseFirestore? firestore,
  List<Override> overrides = const [],
  bool scaffold = false,
  Locale? locale,
  ThemeData? theme,
  LanguageStore? languageStore,
}) {
  return ProviderScope(
    overrides: [
      languageStoreOverride(languageStore),
      if (firebaseAuth != null)
        firebaseAuthProvider.overrideWithValue(firebaseAuth),
      if (firestore != null) firestoreProvider.overrideWithValue(firestore),
      ...overrides,
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: theme,
      home: scaffold ? Scaffold(body: child) : child,
    ),
  );
}

// =============================================================================
// Provider Container Helpers
// =============================================================================

/// Backs [languageStoreProvider] with [store], a returning device's
/// in-memory store by default.
Override languageStoreOverride([LanguageStore? store]) =>
    languageStoreProvider.overrideWithValue(store ?? MemoryLanguageStore());

Override userOverride(AppUserModel? user) =>
    currentUserProvider.overrideWith((_) => Stream.value(user));

/// A container that is disposed with the test and has already let
/// [warm] (the current user by default) emit once, so synchronous
/// reads see settled state.
Future<ProviderContainer> pumpedContainer(
  List<Override> overrides, {
  ProviderListenable<Object?>? warm,
  LanguageStore? languageStore,
}) async {
  final container = ProviderContainer(
    overrides: [languageStoreOverride(languageStore), ...overrides],
  );
  addTearDown(container.dispose);
  container.listen(warm ?? currentUserProvider, (_, _) {});
  await Future<void>.delayed(Duration.zero);
  return container;
}

// =============================================================================
// Widget Test Helpers
// =============================================================================

/// CachedNetworkImage resolves its cache directory via path_provider,
/// which has no platform implementation under test.
void stubPathProvider() {
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (methodCall) async {
        switch (methodCall.method) {
          case 'getTemporaryDirectory':
          case 'getApplicationSupportDirectory':
          case 'getApplicationDocumentsDirectory':
            return '/tmp';
        }
        return null;
      });
}

/// A tall phone viewport so long screens lay out without scrolling.
void sizeViewport(WidgetTester tester, {Size size = const Size(1200, 2400)}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

/// Loads Roboto (in `test/fonts/`) under the family name Material uses on
/// Android, which is the test platform. The default test font draws every
/// Latin glyph 1em wide, so Spanish and English layouts need real metrics;
/// kana and kanji are 1em in both, so Japanese layouts do not.
Future<void> loadTestFonts() async {
  final loader = FontLoader('Roboto');
  for (final file in ['Roboto-Regular.ttf', 'Roboto-Medium.ttf']) {
    final bytes = File('test/fonts/$file').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

/// Phone widths the layout tests run at: a 320pt stress width, a small
/// Android, the smallest current iPhones and the tester's iPhone.
const testPhoneWidths = [320.0, 360.0, 375.0, 393.0];

/// Laid-out lines of the text [finder] matches, word joiners removed.
List<String> renderedLines(WidgetTester tester, Finder finder) {
  final paragraph = tester.renderObject<RenderParagraph>(
    find
        .descendant(
          of: finder,
          matching: find.byType(RichText),
          matchRoot: true,
        )
        .first,
  );
  final text = paragraph.text.toPlainText(includeSemanticsLabels: false);
  final lines = <String>[];
  double? lineTop;
  for (var i = 0; i < text.length; i++) {
    final top = paragraph
        .getOffsetForCaret(TextPosition(offset: i), Rect.zero)
        .dy;
    if (top != lineTop) lines.add('');
    lineTop = top;
    lines.last += text[i];
  }
  return [for (final line in lines) stripWordJoiners(line)];
}

/// SF Pro measures 5-8% wider than Roboto for the same Latin text, so
/// Spanish layout tests run at this fraction of a phone width to stand in
/// for iOS.
const robotoToSfWidthFactor = 0.92;

/// Expects no overflow at [widths] in JA and ES at text scale 1 and 2; loads Roboto.
void stressWidthLayoutTests(
  Widget Function(Locale locale, ThemeData? theme) build, {
  List<double> widths = const [320],
  Future<void> Function(WidgetTester tester, Locale locale)? act,
}) => group('in Japanese and Spanish', () {
  setUpAll(loadTestFonts);
  for (final width in widths) {
    for (final language in ['ja', 'es']) {
      for (final scale in [1.0, 2.0]) {
        testWidgets(
          'lays out at ${width.round()}pt in $language at text scale $scale',
          (tester) async {
            sizeViewport(
              tester,
              size: Size(
                language == 'es' ? width * robotoToSfWidthFactor : width,
                640,
              ),
            );
            tester.platformDispatcher.textScaleFactorTestValue = scale;
            addTearDown(
              tester.platformDispatcher.clearTextScaleFactorTestValue,
            );
            final locale = Locale(language);
            await tester.pumpWidget(
              build(
                locale,
                // Roboto has no kana, so Japanese keeps the test font.
                language == 'ja' ? ThemeData(fontFamily: 'FlutterTest') : null,
              ),
            );
            await tester.pumpAndSettle();
            await act?.call(tester, locale);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
});

/// Pump until [finder] resolves or the budget runs out. For screens with
/// infinite idle animations that never settle; each step yields to the
/// real event loop via runAsync so asset futures and streams can emit.
Future<void> pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 30 && finder.evaluate().isEmpty; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump();
  }
}

// =============================================================================
// Mock Setup Helpers
// =============================================================================

/// Creates a mock FirebaseAuth with common configurations.
MockFirebaseAuth createMockFirebaseAuth({
  User? currentUser,
  Stream<User?>? authStateChanges,
}) {
  final mockAuth = MockFirebaseAuth();

  when(() => mockAuth.currentUser).thenReturn(currentUser);
  // Production observes userChanges() (see AuthRemoteDataSource.authStateChanges);
  // the [authStateChanges] param feeds it. authStateChanges() is stubbed too
  // for any direct callers.
  when(
    mockAuth.userChanges,
  ).thenAnswer((_) => authStateChanges ?? Stream.value(currentUser));
  when(mockAuth.authStateChanges).thenAnswer((_) => Stream.value(currentUser));

  return mockAuth;
}

/// Creates a mock User with common configurations.
MockUser createMockUser({
  String uid = 'test-uid',
  String? email = 'test@example.com',
  bool emailVerified = true,
  String? displayName = 'Test User',
  List<UserInfo>? providerData,
}) {
  final mockUser = MockUser();

  when(() => mockUser.uid).thenReturn(uid);
  when(() => mockUser.email).thenReturn(email);
  when(() => mockUser.emailVerified).thenReturn(emailVerified);
  when(() => mockUser.displayName).thenReturn(displayName);

  // Create default provider data if not specified
  var resolvedProviderData = providerData;
  if (resolvedProviderData == null) {
    final mockUserInfo = MockUserInfo();
    when(() => mockUserInfo.providerId).thenReturn('password');
    resolvedProviderData = [mockUserInfo];
  }
  when(() => mockUser.providerData).thenReturn(resolvedProviderData);

  return mockUser;
}

/// WCAG contrast ratio between two opaque colours.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}

/// Approximates Android's nonlinear 200% font scale, which doubles small
/// type but grows large type less.
class NonlinearScaler200 extends TextScaler {
  const NonlinearScaler200();

  static const _from = [8.0, 10, 12, 14, 18, 20, 24, 30, 100];
  static const _to = [16.0, 20, 24, 26, 30, 34, 36, 38, 100];

  @override
  double scale(double fontSize) {
    if (fontSize <= _from.first) return fontSize * _to.first / _from.first;
    for (var i = 1; i < _from.length; i++) {
      if (fontSize <= _from[i]) {
        final t = (fontSize - _from[i - 1]) / (_from[i] - _from[i - 1]);
        return _to[i - 1] + t * (_to[i] - _to[i - 1]);
      }
    }
    return fontSize;
  }

  @override
  double get textScaleFactor => 2;
}
