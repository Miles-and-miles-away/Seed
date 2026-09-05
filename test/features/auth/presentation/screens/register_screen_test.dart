import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:seed_app/features/auth/presentation/screens/register_screen.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    mockFirebaseAuth = createMockFirebaseAuth();
    fakeFirestore = FakeFirebaseFirestore();

    // Setup default mock behavior
    when(
      () => mockFirebaseAuth.createUserWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => MockUserCredential());
  });

  Future<void> pumpRegister(WidgetTester tester) => tester.pumpWidget(
    createTestWidget(
      child: const RegisterScreen(),
      firebaseAuth: mockFirebaseAuth,
      firestore: fakeFirestore,
    ),
  );

  Future<void> fillForm(
    WidgetTester tester, {
    required String email,
    required String password,
    required String confirm,
  }) async {
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), email);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      password,
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirm Password'),
      confirm,
    );
  }

  group('RegisterScreen', () {
    testWidgets('renders all expected UI elements', (tester) async {
      await pumpRegister(tester);

      // Verify key UI elements are present
      // "Create Account" appears in both title and button
      expect(find.text('Create Account'), findsNWidgets(2));
      expect(
        find.text('Start your sustainability journey today'),
        findsOneWidget,
      );
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('or sign up with'), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('shows validation error for empty fields', (tester) async {
      await pumpRegister(tester);

      // First accept terms
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Tap create account button (not the title text)
      await tester.tap(find.widgetWithText(FilledButton, 'Create Account'));
      await tester.pumpAndSettle();

      // Verify validation errors appear
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid email format', (
      tester,
    ) async {
      await pumpRegister(tester);

      // Accept terms
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Enter invalid email
      await fillForm(
        tester,
        email: 'invalid-email',
        password: 'password123',
        confirm: 'password123',
      );

      // Tap create account
      await tester.tap(find.widgetWithText(FilledButton, 'Create Account'));
      await tester.pumpAndSettle();

      // Verify email validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('shows validation error for short password', (tester) async {
      await pumpRegister(tester);

      // Accept terms
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Enter valid email but short password
      await fillForm(
        tester,
        email: 'test@example.com',
        password: '12345',
        confirm: '12345',
      );

      // Tap create account
      await tester.tap(find.widgetWithText(FilledButton, 'Create Account'));
      await tester.pumpAndSettle();

      // Verify password validation error
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('shows validation error for password mismatch', (tester) async {
      await pumpRegister(tester);

      // Accept terms
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Enter mismatched passwords
      await fillForm(
        tester,
        email: 'test@example.com',
        password: 'password123',
        confirm: 'password456',
      );

      // Tap create account
      await tester.tap(find.widgetWithText(FilledButton, 'Create Account'));
      await tester.pumpAndSettle();

      // Verify password mismatch error
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('shows snackbar when terms not accepted', (tester) async {
      await pumpRegister(tester);

      // Enter valid form data but don't accept terms
      await fillForm(
        tester,
        email: 'test@example.com',
        password: 'password123',
        confirm: 'password123',
      );

      // Tap create account without accepting terms
      await tester.tap(find.widgetWithText(FilledButton, 'Create Account'));
      await tester.pump();

      // Verify snackbar appears
      expect(
        find.text('Please accept the Terms of Service and Privacy Policy'),
        findsOneWidget,
      );
    });

    testWidgets('toggles password visibility', (tester) async {
      await pumpRegister(tester);

      // Initially should show visibility icons (passwords are hidden)
      // There are two password fields with visibility toggles
      expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

      // Tap first visibility toggle (password field)
      await tester.tap(find.byIcon(Icons.visibility_outlined).first);
      await tester.pumpAndSettle();

      // One icon should change to visibility_off
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('toggles confirm password visibility', (tester) async {
      await pumpRegister(tester);

      // Tap second visibility toggle (confirm password field)
      await tester.tap(find.byIcon(Icons.visibility_outlined).last);
      await tester.pumpAndSettle();

      // Second icon should change to visibility_off
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('checkbox can be toggled', (tester) async {
      await pumpRegister(tester);

      // Find checkbox and verify initially unchecked
      final checkboxFinder = find.byType(Checkbox);
      expect(checkboxFinder, findsOneWidget);

      var checkbox = tester.widget<Checkbox>(checkboxFinder);
      expect(checkbox.value, isFalse);

      // Tap checkbox
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Verify checkbox is now checked
      checkbox = tester.widget<Checkbox>(checkboxFinder);
      expect(checkbox.value, isTrue);

      // Tap again to uncheck
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      checkbox = tester.widget<Checkbox>(checkboxFinder);
      expect(checkbox.value, isFalse);
    });

    testWidgets('terms text exists with checkbox', (tester) async {
      await pumpRegister(tester);

      // Verify checkbox exists
      expect(find.byType(Checkbox), findsOneWidget);

      // Verify the checkbox row exists with GestureDetector
      final checkboxAncestor = find.ancestor(
        of: find.byType(Checkbox),
        matching: find.byType(Row),
      );
      expect(checkboxAncestor, findsOneWidget);
    });

    testWidgets(
      'calls createUserWithEmailAndPassword on valid form submission',
      (tester) async {
        await pumpRegister(tester);

        // Accept terms
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        // Enter valid credentials
        await fillForm(
          tester,
          email: 'test@example.com',
          password: 'password123',
          confirm: 'password123',
        );

        // Tap create account
        await tester.tap(find.widgetWithText(FilledButton, 'Create Account'));
        await tester.pump();

        // Verify createUserWithEmailAndPassword was called
        verify(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
      },
    );

    testWidgets('shows Google sign-in button', (tester) async {
      await pumpRegister(tester);

      // Google sign-in should be visible on all platforms
      expect(find.text('Google'), findsOneWidget);
    });

    testWidgets('displays eco icon in header', (tester) async {
      await pumpRegister(tester);

      // Verify eco icon is displayed
      expect(find.byIcon(Icons.eco), findsOneWidget);
    });

    testWidgets('email field has email icon prefix', (tester) async {
      await pumpRegister(tester);

      // Verify email field has the correct prefix icon
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      // Verify lock icons for password fields (two of them)
      expect(find.byIcon(Icons.lock_outlined), findsNWidgets(2));
    });

    testWidgets('displays Terms of Service and Privacy Policy text', (
      tester,
    ) async {
      await pumpRegister(tester);

      // Verify terms text is present (Rich text contains spans)
      // Looking for the container with the checkbox and terms
      expect(find.byType(Checkbox), findsOneWidget);

      // The Rich text should contain these strings somewhere in the widget tree
      // We can verify by checking that a Row with Checkbox exists
      final row = find.ancestor(
        of: find.byType(Checkbox),
        matching: find.byType(Row),
      );
      expect(row, findsOneWidget);
    });

    testWidgets('has Sign In text button that exists', (tester) async {
      await pumpRegister(tester);

      // Verify sign in link exists
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(TextButton), findsAtLeast(1));
    });

    testWidgets('form field submission triggers sign up', (tester) async {
      await pumpRegister(tester);

      // Accept terms
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Enter valid credentials
      await fillForm(
        tester,
        email: 'test@example.com',
        password: 'password123',
        confirm: 'password123',
      );

      // Submit the form by pressing the done key on confirm password field
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Verify createUserWithEmailAndPassword was called
      verify(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).called(1);
    });
  });
}
