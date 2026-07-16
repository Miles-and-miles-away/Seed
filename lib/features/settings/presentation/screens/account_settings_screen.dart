import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/app_logger.dart';
import 'package:seed_app/core/utils/auth_error_mapper.dart';
import 'package:seed_app/core/utils/utf16_length_limiting_text_input_formatter.dart';
import 'package:seed_app/core/utils/validators.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

/// Screen for managing account settings.
///
/// Includes options to change email, change password, and delete account.
/// All sensitive operations require re-authentication.
class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUser = currentUserAsync.value;
    // Until the user stream emits, show placeholders so the profile tiles
    // don't briefly flash "Not set" for an existing display name / goal.
    final isUserLoading = !currentUserAsync.hasValue;
    final firebaseUser = ref.watch(firebaseAuthProvider).currentUser;

    // Check if user signed in with email/password
    final isEmailPasswordUser =
        firebaseUser?.providerData.any((p) => p.providerId == 'password') ??
        false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountSettingsTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              top: false,
              child: ListView(
                children: [
                  // Profile (display name + personal goal)
                  SettingsSection(
                    title: l10n.accountSettingsProfile,
                    children: [
                      SettingsTile(
                        leading: const Icon(Icons.person_outline),
                        title: l10n.accountSettingsDisplayName,
                        subtitle:
                            currentUser?.displayName ??
                            l10n.accountSettingsNotSet,
                        subtitleWidget: isUserLoading
                            ? const SkeletonLine()
                            : null,
                        onTap: isUserLoading
                            ? null
                            : () => _showChangeDisplayNameDialog(context),
                      ),
                      SettingsTile(
                        leading: const Icon(Icons.flag_outlined),
                        title: l10n.myGoalTitle,
                        subtitle: currentUser?.personalGoal == null
                            ? l10n.accountSettingsNotSet
                            : localizedPersonalGoal(
                                currentUser!.personalGoal!,
                                l10n,
                              ),
                        subtitleWidget: isUserLoading
                            ? const SkeletonLine()
                            : null,
                        onTap: isUserLoading ? null : _showGoalPicker,
                      ),
                    ],
                  ),

                  // Current email display
                  SettingsSection(
                    title: l10n.accountSettingsEmail,
                    children: [
                      ListTile(
                        title: Text(l10n.accountSettingsCurrentEmail),
                        subtitle: Text(
                          currentUser?.email ?? firebaseUser?.email ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Email/Password management (only for email/password users)
                  if (isEmailPasswordUser) ...[
                    SettingsSection(
                      title: l10n.settingsAccount,
                      children: [
                        SettingsTile(
                          leading: const Icon(Icons.email_outlined),
                          title: l10n.accountSettingsChangeEmail,
                          onTap: () => _showChangeEmailDialog(context),
                        ),
                        SettingsTile(
                          leading: const Icon(Icons.lock_outline),
                          title: l10n.accountSettingsChangePassword,
                          onTap: () => _showChangePasswordDialog(context),
                        ),
                      ],
                    ),
                  ],

                  // Danger zone
                  SettingsSection(
                    title: '',
                    children: [
                      SettingsTile(
                        leading: Icon(
                          Icons.delete_forever,
                          color: theme.colorScheme.error,
                        ),
                        title: l10n.accountSettingsDeleteAccount,
                        dangerous: true,
                        onTap: () => _showDeleteAccountDialog(context),
                      ),
                    ],
                  ),

                  // Warning text
                  Padding(
                    padding: const EdgeInsets.all(spacingLg),
                    child: Text(
                      l10n.accountSettingsDeleteAccountWarning,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _showChangeDisplayNameDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final currentName = ref.read(currentUserProvider).value?.displayName;
    final nameController = TextEditingController(text: currentName ?? '');
    final formKey = GlobalKey<FormState>();

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.accountSettingsDisplayName),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              autofocus: true,
              maxLength: AppConstants.maxDisplayNameLength,
              // Cap on UTF-16 units to match the Firestore rule's .size().
              inputFormatters: [
                Utf16LengthLimitingTextInputFormatter(
                  AppConstants.maxDisplayNameLength,
                ),
              ],
              decoration: InputDecoration(
                labelText: l10n.accountSettingsDisplayName,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.accountSettingsDisplayNameRequired;
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.buttonCancel),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, true);
                }
              },
              child: Text(l10n.buttonSave),
            ),
          ],
        ),
      );

      if ((result ?? false) && mounted) {
        await _changeDisplayName(nameController.text.trim());
      }
    } finally {
      nameController.dispose();
    }
  }

  Future<void> _changeDisplayName(String displayName) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    // Optimistic: the Firestore write lands in the local cache immediately,
    // so the tile updates without blanking the screen on a slow/offline save.
    String message;
    try {
      await ref.read(authProvider.notifier).updateDisplayName(displayName);
      message = l10n.accountSettingsDisplayNameUpdated;
    } on Exception catch (e) {
      appLogger.error('Account: display name update failed', error: e);
      message = mapAuthErrorToMessage(e, l10n);
    }

    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showGoalPicker() async {
    final l10n = AppLocalizations.of(context);
    final currentGoal = ref.read(currentUserProvider).value?.personalGoal;
    final goal = await GoalPickerSheet.show(context, initialGoal: currentGoal);
    if (goal == null || goal == currentGoal || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    String message;
    try {
      await ref.read(authProvider.notifier).updatePersonalGoal(goal);
      message = l10n.myGoalUpdated;
    } on Exception {
      message = l10n.errorGeneric;
    }

    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showChangeEmailDialog(BuildContext context) async {
    final currentEmailController = TextEditingController();
    final passwordController = TextEditingController();
    final newEmailController = TextEditingController();

    // Re-open prefilled on a save failure (e.g. wrong password) so the typed
    // emails are never lost; only the password is cleared for re-entry.
    try {
      while (await _promptChangeEmail(
        currentEmailController,
        passwordController,
        newEmailController,
      )) {
        if (!mounted) break;
        // Trim emails to match what the dialog validators accepted.
        final saved = await _changeEmail(
          currentEmailController.text.trim(),
          passwordController.text,
          newEmailController.text.trim(),
        );
        if (saved || !mounted) break;
        passwordController.clear();
      }
    } finally {
      currentEmailController.dispose();
      passwordController.dispose();
      newEmailController.dispose();
    }
  }

  /// Shows the change-email form, returning true when the user confirms with
  /// valid input and false when they cancel or dismiss it.
  Future<bool> _promptChangeEmail(
    TextEditingController currentEmailController,
    TextEditingController passwordController,
    TextEditingController newEmailController,
  ) {
    final l10n = AppLocalizations.of(context);
    return _showFormDialog(
      title: l10n.accountSettingsChangeEmail,
      children: [
        _emailField(currentEmailController, l10n.accountSettingsCurrentEmail),
        const SizedBox(height: spacingLg),
        _passwordField(passwordController, l10n.accountSettingsCurrentPassword),
        const SizedBox(height: spacingLg),
        _emailField(newEmailController, l10n.accountSettingsNewEmail),
      ],
    );
  }

  /// Re-authenticates then updates the email. Returns true on success so the
  /// caller can stop retrying; false leaves the dialog's input to re-open.
  Future<bool> _changeEmail(
    String currentEmail,
    String password,
    String newEmail,
  ) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isLoading = true);

    try {
      await ref
          .read(authProvider.notifier)
          .reauthenticateWithEmailPassword(currentEmail, password);
      await ref.read(authProvider.notifier).updateEmail(newEmail);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.accountSettingsEmailUpdated)),
        );
      }
      return true;
    } on Exception catch (e) {
      appLogger.error('Account: email update failed', error: e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mapAuthErrorToMessage(e, l10n))));
      }
      return false;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final currentEmailController = TextEditingController();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    // Re-open prefilled on a save failure (e.g. wrong current password) so the
    // email and new password aren't lost; only the current password clears.
    try {
      while (await _promptChangePassword(
        currentEmailController,
        currentPasswordController,
        newPasswordController,
        confirmPasswordController,
      )) {
        if (!mounted) break;
        // Trim the email to match what the dialog validator accepted.
        final saved = await _changePassword(
          currentEmailController.text.trim(),
          currentPasswordController.text,
          newPasswordController.text,
        );
        if (saved || !mounted) break;
        currentPasswordController.clear();
      }
    } finally {
      currentEmailController.dispose();
      currentPasswordController.dispose();
      newPasswordController.dispose();
      confirmPasswordController.dispose();
    }
  }

  /// Shows the change-password form, returning true when the user confirms
  /// with valid input and false when they cancel or dismiss it.
  Future<bool> _promptChangePassword(
    TextEditingController currentEmailController,
    TextEditingController currentPasswordController,
    TextEditingController newPasswordController,
    TextEditingController confirmPasswordController,
  ) {
    final l10n = AppLocalizations.of(context);
    return _showFormDialog(
      title: l10n.accountSettingsChangePassword,
      children: [
        _emailField(currentEmailController, l10n.accountSettingsCurrentEmail),
        const SizedBox(height: spacingLg),
        _passwordField(
          currentPasswordController,
          l10n.accountSettingsCurrentPassword,
        ),
        const SizedBox(height: spacingLg),
        _passwordField(
          newPasswordController,
          l10n.accountSettingsNewPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.authValidationPasswordRequired;
            }
            if (value.length < 6) {
              return l10n.authValidationPasswordShort;
            }
            return null;
          },
        ),
        const SizedBox(height: spacingLg),
        _passwordField(
          confirmPasswordController,
          l10n.accountSettingsConfirmNewPassword,
          validator: (value) {
            if (value != newPasswordController.text) {
              return l10n.accountSettingsPasswordMismatch;
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Re-authenticates then updates the password. Returns true on success so
  /// the caller can stop retrying; false leaves the input to re-open.
  Future<bool> _changePassword(
    String email,
    String currentPassword,
    String newPassword,
  ) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isLoading = true);

    try {
      await ref
          .read(authProvider.notifier)
          .reauthenticateWithEmailPassword(email, currentPassword);
      await ref.read(authProvider.notifier).updatePassword(newPassword);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.accountSettingsPasswordUpdated)),
        );
      }
      return true;
    } on Exception catch (e) {
      appLogger.error('Account: password update failed', error: e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mapAuthErrorToMessage(e, l10n))));
      }
      return false;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    final firebaseUser = ref.read(firebaseAuthProvider).currentUser;
    final isEmailPasswordUser =
        firebaseUser?.providerData.any((p) => p.providerId == 'password') ??
        false;

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // Re-open prefilled on a re-auth failure so the typed email isn't lost;
    // only the password is cleared for re-entry.
    try {
      while (await _promptDeleteAccount(
        emailController,
        passwordController,
        isEmailPasswordUser,
      )) {
        if (!mounted) break;
        // Trim the email to match what the dialog validator accepted.
        final deleted = await _deleteAccount(
          emailController.text.trim(),
          passwordController.text,
          isEmailPasswordUser,
        );
        if (deleted || !mounted) break;
        passwordController.clear();
      }
    } finally {
      emailController.dispose();
      passwordController.dispose();
    }
  }

  /// Shows the delete-account confirmation (with re-auth fields for
  /// email/password users), returning true when the user confirms.
  Future<bool> _promptDeleteAccount(
    TextEditingController emailController,
    TextEditingController passwordController,
    bool isEmailPasswordUser,
  ) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // A Form with no fields validates trivially, so the confirm button
    // works unchanged for OAuth users with no re-auth fields.
    return _showFormDialog(
      title: l10n.accountSettingsDeleteConfirmTitle,
      confirmText: l10n.accountSettingsDeleteConfirmButton,
      dangerous: true,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.accountSettingsDeleteConfirmMessage),
        if (isEmailPasswordUser) ...[
          const SizedBox(height: spacingLg),
          Text(
            l10n.accountSettingsReauthRequired,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: spacingSm),
          _emailField(emailController, l10n.authEmail),
          const SizedBox(height: spacingSm),
          _passwordField(passwordController, l10n.authPassword),
        ],
      ],
    );
  }

  /// Shared scaffold for the account dialogs: an [AlertDialog] wrapping
  /// [children] in a scrollable [Form], with cancel/confirm actions where
  /// confirm validates the form before popping true.
  Future<bool> _showFormDialog({
    required String title,
    required List<Widget> children,
    String? confirmText,
    bool dangerous = false,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final formKey = GlobalKey<FormState>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: dangerous ? TextStyle(color: theme.colorScheme.error) : null,
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: crossAxisAlignment,
              children: children,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.buttonCancel),
          ),
          FilledButton(
            style: dangerous
                ? FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                  )
                : null,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, true);
              }
            },
            child: Text(confirmText ?? l10n.buttonSave),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  TextFormField _emailField(TextEditingController controller, String label) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.emailAddress,
      validator: (value) => validateEmail(
        value,
        emptyError: l10n.authValidationEmailRequired,
        invalidError: l10n.authValidationEmailInvalid,
      ),
    );
  }

  TextFormField _passwordField(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
  }) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: true,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return l10n.authValidationPasswordRequired;
            }
            return null;
          },
    );
  }

  /// Re-authenticates if required then deletes the account, navigating to
  /// login on success (returns true). Returns false on failure so the
  /// caller can re-open the dialog with the typed email preserved.
  Future<bool> _deleteAccount(
    String email,
    String password,
    bool requiresReauth,
  ) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isLoading = true);

    try {
      if (requiresReauth && email.isNotEmpty && password.isNotEmpty) {
        await ref
            .read(authProvider.notifier)
            .reauthenticateWithEmailPassword(email, password);
      }

      await ref.read(authProvider.notifier).deleteAccount();

      if (mounted) {
        context.go(appRoutes.login);
      }
      return true;
    } on Exception catch (e) {
      appLogger.error('Account: account deletion failed', error: e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mapAuthErrorToMessage(e, l10n))));
      }
      return false;
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
