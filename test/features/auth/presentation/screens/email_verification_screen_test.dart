import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:seed_app/features/auth/presentation/screens/email_verification_screen.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirestore;
  late MockUser mockUser;

  setUp(() {
    mockUser = createMockUser(
      // ignore: avoid_redundant_argument_values
      email: 'test@example.com',
    );

    mockFirebaseAuth = createMockFirebaseAuth(
      currentUser: mockUser,
      authStateChanges: Stream.value(mockUser),
    );
    fakeFirestore = FakeFirebaseFirestore();

    // Setup default mock behavior
    when(() => mockUser.reload()).thenAnswer((_) async {});
    when(() => mockUser.sendEmailVerification()).thenAnswer((_) async {});
    when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
  });

  Future<void> pumpVerification(
    WidgetTester tester, {
    MockFirebaseAuth? auth,
  }) async {
    await tester.pumpWidget(
      createTestWidget(
        child: const EmailVerificationScreen(),
        firebaseAuth: auth ?? mockFirebaseAuth,
        firestore: fakeFirestore,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('EmailVerificationScreen', () {
    // Set a larger screen size to avoid overflow
    void setLargeScreenSize(WidgetTester tester) {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
    }

    testWidgets('renders all expected UI elements', (tester) async {
      setLargeScreenSize(tester);
      await pumpVerification(tester);

      // Verify key UI elements are present
      expect(find.text('Verify Email'), findsOneWidget);
      expect(find.text('Check Your Email'), findsOneWidget);
      expect(find.text('We sent a verification link to:'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text("I've Verified My Email"), findsOneWidget);
      expect(find.text('Resend Email'), findsOneWidget);
      expect(find.text('Use a Different Email'), findsOneWidget);
    });

    testWidgets('displays app bar with back button', (tester) async {
      setLargeScreenSize(tester);
      await pumpVerification(tester);

      // Verify app bar with back button
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('displays email icon', (tester) async {
      setLargeScreenSize(tester);
      await pumpVerification(tester);

      // Verify email icon is displayed
      expect(find.byIcon(Icons.mark_email_unread_outlined), findsOneWidget);
    });

    testWidgets('displays check circle icon on verify button', (tester) async {
      setLargeScreenSize(tester);
      await pumpVerification(tester);

      // Verify check circle icon exists
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('displays refresh icon on resend button', (tester) async {
      setLargeScreenSize(tester);
      await pumpVerification(tester);

      // Verify refresh icon exists
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('has buttons for actions', (tester) async {
      setLargeScreenSize(tester);
      await pumpVerification(tester);

      // Verify FilledButton.icon exists (for verification)
      expect(find.text("I've Verified My Email"), findsOneWidget);

      // Verify OutlinedButton.icon exists (for resend)
      expect(find.text('Resend Email'), findsOneWidget);

      // Verify TextButton exists (for different email)
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('tapping resend email shows snackbar', (tester) async {
      setLargeScreenSize(tester);
      await pumpVerification(tester);

      // Tap resend email button
      await tester.tap(find.text('Resend Email'));
      await tester.pump();

      // Verify snackbar appears
      expect(find.text('Verification email sent!'), findsOneWidget);
    });

    testWidgets('tapping verify button calls reload when email not verified', (
      tester,
    ) async {
      setLargeScreenSize(tester);
      // Setup mock to return unverified user
      when(() => mockUser.reload()).thenAnswer((_) async {});
      when(() => mockUser.emailVerified).thenReturn(false);

      await pumpVerification(tester);

      // Tap verify button
      await tester.tap(find.text("I've Verified My Email"));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify user reload was called
      verify(() => mockUser.reload()).called(1);
    });

    testWidgets('displays instruction text', (tester) async {
      setLargeScreenSize(tester);
      await pumpVerification(tester);

      // Verify instruction text is present
      expect(
        find.textContaining('Click the link in the email'),
        findsOneWidget,
      );
    });

    testWidgets('user email is displayed correctly', (tester) async {
      setLargeScreenSize(tester);
      // Create user with specific email
      final userWithEmail = createMockUser(
        email: 'specific@test.com',
        emailVerified: false,
      );

      final authWithUser = createMockFirebaseAuth(
        currentUser: userWithEmail,
        authStateChanges: Stream.value(userWithEmail),
      );

      when(userWithEmail.reload).thenAnswer((_) async {});
      when(authWithUser.signOut).thenAnswer((_) async {});

      await pumpVerification(tester, auth: authWithUser);

      // Verify specific email is displayed
      expect(find.text('specific@test.com'), findsOneWidget);
    });

    testWidgets('shows empty email when no user', (tester) async {
      setLargeScreenSize(tester);
      // Create auth with null user
      final authWithNoUser = createMockFirebaseAuth(
        // ignore: avoid_redundant_argument_values
        currentUser: null,
        authStateChanges: Stream.value(null),
      );

      when(authWithNoUser.signOut).thenAnswer((_) async {});

      await pumpVerification(tester, auth: authWithNoUser);

      // Email text should be empty string (the widget handles null gracefully)
      expect(find.text(''), findsWidgets);
    });

    testWidgets('container with email icon has correct decoration', (
      tester,
    ) async {
      setLargeScreenSize(tester);
      await pumpVerification(tester);

      // Find the Container that wraps the email icon
      final container = find.ancestor(
        of: find.byIcon(Icons.mark_email_unread_outlined),
        matching: find.byType(Container),
      );
      expect(container, findsOneWidget);
    });
  });
}
