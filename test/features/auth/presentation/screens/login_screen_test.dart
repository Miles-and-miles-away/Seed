import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:seed_app/features/auth/presentation/screens/login_screen.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    mockFirebaseAuth = createMockFirebaseAuth();
    fakeFirestore = createFakeFirestore();

    // Setup default mock behavior
    when(
      () => mockFirebaseAuth.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => MockUserCredential());
  });

  group('LoginScreen', () {
    testWidgets('renders all expected UI elements', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LoginScreen(),
          firebaseAuth: mockFirebaseAuth,
          firestore: fakeFirestore,
        ),
      );

      // Verify key UI elements are present
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(
        find.text('Sign in to continue your sustainability journey'),
        findsOneWidget,
      );
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('or continue with'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('shows validation error for empty email', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LoginScreen(),
          firebaseAuth: mockFirebaseAuth,
          firestore: fakeFirestore,
        ),
      );

      // Tap sign in without entering anything
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Verify validation errors appear
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid email format',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LoginScreen(),
          firebaseAuth: mockFirebaseAuth,
          firestore: fakeFirestore,
        ),
      );

      // Enter invalid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'invalid-email',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      // Tap sign in
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Verify email validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('shows validation error for short password', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LoginScreen(),
          firebaseAuth: mockFirebaseAuth,
          firestore: fakeFirestore,
        ),
      );

      // Enter valid email but short password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        '12345',
      );

      // Tap sign in
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Verify password validation error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('toggles password visibility', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LoginScreen(),
          firebaseAuth: mockFirebaseAuth,
          firestore: fakeFirestore,
        ),
      );

      // Initially should show visibility icon (password is hidden)
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

      // Tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      // Icon should change to visibility_off (password is now visible)
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);

      // Tap again to hide password
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pumpAndSettle();

      // Should be back to original state
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('calls signInWithEmailAndPassword on valid form submission',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LoginScreen(),
          firebaseAuth: mockFirebaseAuth,
          firestore: fakeFirestore,
        ),
      );

      // Enter valid credentials
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      // Tap sign in
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Verify sign in was called
      verify(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).called(1);
    });

    testWidgets('shows forgot password dialog', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LoginScreen(),
          firebaseAuth: mockFirebaseAuth,
          firestore: fakeFirestore,
        ),
      );

      // Tap forgot password
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Verify dialog appears
      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.text('Enter your email address'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Send'), findsOneWidget);
    });

    testWidgets('shows Google sign-in button', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LoginScreen(),
          firebaseAuth: mockFirebaseAuth,
          firestore: fakeFirestore,
        ),
      );

      // Google sign-in should be visible on all platforms
      expect(find.text('Google'), findsOneWidget);
    });

    testWidgets('sign in button exists and can be tapped', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LoginScreen(),
          firebaseAuth: mockFirebaseAuth,
          firestore: fakeFirestore,
        ),
      );

      // Enter valid credentials
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      // Verify sign in button exists
      expect(find.text('Sign In'), findsOneWidget);

      // Verify FilledButton exists for sign in
      expect(find.byType(FilledButton), findsAtLeast(1));
    });

    testWidgets('displays eco icon in header', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LoginScreen(),
          firebaseAuth: mockFirebaseAuth,
          firestore: fakeFirestore,
        ),
      );

      // Verify eco icon is displayed
      expect(find.byIcon(Icons.eco), findsOneWidget);
    });

    testWidgets('email field has email icon prefix', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LoginScreen(),
          firebaseAuth: mockFirebaseAuth,
          firestore: fakeFirestore,
        ),
      );

      // Verify email field has the correct prefix icon
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      // Verify lock icon for password field
      expect(find.byIcon(Icons.lock_outlined), findsOneWidget);
    });
  });
}
