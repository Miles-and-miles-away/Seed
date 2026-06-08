import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/settings/presentation/feedback_mailto.dart';
import 'package:seed_app/features/settings/presentation/screens/feedback_screen.dart';
import 'package:seed_app/shared/providers/package_info_provider.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late _MockFirebaseAuth mockAuth;

  setUp(() {
    mockAuth = _MockFirebaseAuth();
    when(() => mockAuth.currentUser).thenReturn(null);
  });

  PackageInfo fakePackageInfo() => PackageInfo(
        appName: 'Seed',
        packageName: 'com.seed.app',
        version: '1.2.0',
        buildNumber: '42',
      );

  Widget createTestWidget({bool packageInfoError = false}) {
    return ProviderScope(
      overrides: [
        firebaseAuthProvider.overrideWithValue(mockAuth),
        packageInfoProvider.overrideWith(
          (ref) => packageInfoError
              ? Future<PackageInfo>.error(Exception('unavailable'))
              : Future.value(fakePackageInfo()),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const FeedbackScreen(),
      ),
    );
  }

  group('FeedbackScreen', () {
    testWidgets('renders title, category chips and submit button',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Send Feedback'), findsWidgets);
      expect(find.text('Bug Report'), findsOneWidget);
      expect(find.text('Feature Request'), findsOneWidget);
      expect(find.text('General Feedback'), findsOneWidget);
      expect(find.text('Submit Feedback'), findsOneWidget);
    });

    testWidgets('submit button is disabled when description is empty',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('submit button enables once description is non-empty',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Something is broken');
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('submit button stays disabled for whitespace-only input',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '   \n  ');
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('description field caps input length', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.maxLength, feedbackDescriptionMaxLength);
    });

    testWidgets('submit recovers when package info fails to load',
        (tester) async {
      await tester.pumpWidget(createTestWidget(packageInfoError: true));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Something is broken');
      await tester.pump();
      await tester.ensureVisible(find.text('Submit Feedback'));
      await tester.tap(find.text('Submit Feedback'));
      await tester.pumpAndSettle();

      // Spinner must reset and the failure snackbar must show.
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        find.text("Couldn't open your mail app. Please try again."),
        findsOneWidget,
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('tapping a category chip selects it', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Bug Report is selected by default; tap Feature Request.
      await tester.tap(find.text('Feature Request'));
      await tester.pump();

      final featureChip = tester.widget<ChoiceChip>(
        find.ancestor(
          of: find.text('Feature Request'),
          matching: find.byType(ChoiceChip),
        ),
      );
      expect(featureChip.selected, isTrue);

      final bugChip = tester.widget<ChoiceChip>(
        find.ancestor(
          of: find.text('Bug Report'),
          matching: find.byType(ChoiceChip),
        ),
      );
      expect(bugChip.selected, isFalse);
    });

    testWidgets('metadata footer shows app version and locale', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.textContaining('App v1.2.0 (42)'),
        findsOneWidget,
      );
      expect(
        find.textContaining('en'),
        findsWidgets,
      );
    });

    testWidgets('shows metadata note explaining what is sent', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'The following info is included to help us investigate:',
        ),
        findsOneWidget,
      );
    });
  });
}
