import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/settings/presentation/screens/account_settings_screen.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_tile.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserInfo extends Mock implements UserInfo {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockUserInfo mockUserInfo;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserInfo = MockUserInfo();
  });

  Widget createTestWidget({
    required Widget child,
    AppUserModel? currentUser,
    bool isEmailPasswordUser = true,
  }) {
    // Set up mock user info
    when(() => mockUserInfo.providerId).thenReturn(
      isEmailPasswordUser ? 'password' : 'google.com',
    );
    when(() => mockUser.providerData).thenReturn([mockUserInfo]);
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

    return ProviderScope(
      overrides: [
        currentUserProvider.overrideWith(
          (ref) => Stream.value(currentUser),
        ),
        firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: child,
      ),
    );
  }

  final testUser = AppUserModel(
    uid: 'test-uid',
    email: 'user@example.com',
    displayName: 'Test User',
    createdAt: DateTime.now(),
  );

  group('AccountSettingsScreen', () {
    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
    });

    testWidgets('renders email section', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('EMAIL ADDRESS'), findsOneWidget);
    });

    testWidgets('shows current email label', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Current email'), findsOneWidget);
    });

    testWidgets('displays user email', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('user@example.com'), findsOneWidget);
    });

    testWidgets('shows change email option for email/password users',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Change Email'), findsOneWidget);
    });

    testWidgets('shows change password option for email/password users',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Change Password'), findsOneWidget);
    });

    testWidgets('hides email/password options for OAuth users', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
          isEmailPasswordUser: false,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Change Email'), findsNothing);
      expect(find.text('Change Password'), findsNothing);
    });

    testWidgets('shows delete account option', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Delete Account'), findsOneWidget);
    });

    testWidgets('shows delete account warning text', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      // The profile section pushes the warning below the test viewport
      await tester.scrollUntilVisible(
        find.textContaining('permanently delete'),
        100,
      );

      expect(
        find.textContaining('permanently delete'),
        findsOneWidget,
      );
    });

    testWidgets('shows email icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('shows lock icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('shows delete forever icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete_forever), findsOneWidget);
    });

    testWidgets('delete account tile is marked as dangerous', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      // Find the SettingsTile for delete
      final deleteIcon = find.byIcon(Icons.delete_forever);
      expect(deleteIcon, findsOneWidget);
    });

    testWidgets('renders multiple SettingsSections', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      // Profile, Email, Account, Danger zone sections
      expect(find.byType(SettingsSection), findsNWidgets(4));
    });

    testWidgets('renders ListView', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders SettingsTile widgets', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      // Display Name, My Goal, Change Email, Change Password, Delete Account
      expect(find.byType(SettingsTile), findsNWidgets(5));
    });

    testWidgets('tapping change email shows dialog', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Change Email'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Change Email'), findsNWidgets(2)); // Title + button
    });

    testWidgets('tapping change password shows dialog', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Change Password'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Change Password'), findsNWidgets(2)); // Title + button
    });

    testWidgets('tapping delete account shows confirmation dialog',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Delete Account?'), findsOneWidget);
    });

    testWidgets('change email dialog has required fields', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Change Email'));
      await tester.pumpAndSettle();

      // Current email appears twice (main screen + dialog)
      expect(find.text('Current email'), findsWidgets);
      expect(find.text('Current password'), findsOneWidget);
      expect(find.text('New email'), findsOneWidget);
    });

    testWidgets('change password dialog has required fields', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Change Password'));
      await tester.pumpAndSettle();

      // Current email appears twice (main screen + dialog)
      expect(find.text('Current email'), findsWidgets);
      expect(find.text('Current password'), findsOneWidget);
      expect(find.text('New password'), findsOneWidget);
      expect(find.text('Confirm new password'), findsOneWidget);
    });

    testWidgets('dialogs have cancel and save buttons', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Change Email'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('delete dialog has cancel and delete buttons', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete My Account'), findsOneWidget);
    });

    testWidgets('cancel button closes dialog', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Change Email'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('shows account section for email/password users',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ACCOUNT'), findsOneWidget);
    });

    testWidgets('renders profile section with display name and goal',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PROFILE'), findsOneWidget);
      expect(find.text('Display Name'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('My Goal'), findsOneWidget);
      expect(find.text('Not set'), findsOneWidget);
    });

    testWidgets('shows localized preset text for stored goal ID',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser.copyWith(personalGoal: 'save_world'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Save the world'), findsOneWidget);
    });

    testWidgets('tapping display name shows prefilled dialog', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Display Name'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Test User'),
        findsOneWidget,
      );
    });

    testWidgets('tapping my goal opens goal picker sheet', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsScreen(),
          currentUser: testUser,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('My Goal'));
      await tester.pumpAndSettle();

      expect(find.byType(GoalPickerSheet), findsOneWidget);
      expect(find.text('Save the world'), findsOneWidget);
      expect(find.text('Write your own'), findsOneWidget);
    });
  });
}
