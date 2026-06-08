import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
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
    final currentUser = ref.watch(currentUserProvider).value;
    final firebaseUser = ref.watch(firebaseAuthProvider).currentUser;

    // Check if user signed in with email/password
    final isEmailPasswordUser =
        firebaseUser?.providerData.any((p) => p.providerId == 'password') ??
            false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accountSettingsTitle),
      ),
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
                        subtitle: currentUser?.displayName ??
                            l10n.accountSettingsNotSet,
                        onTap: () => _showChangeDisplayNameDialog(context),
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
                        onTap: _showGoalPicker,
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
              decoration: InputDecoration(
                labelText: l10n.accountSettingsDisplayName,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.accountSettingsDisplayName;
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
    setState(() => _isLoading = true);

    await ref.read(authProvider.notifier).updateDisplayName(displayName);

    if (!mounted) return;
    setState(() => _isLoading = false);
    // Errors are captured in the notifier state, not thrown
    final failed = ref.read(authProvider).hasError;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          failed ? l10n.errorGeneric : l10n.accountSettingsDisplayNameUpdated,
        ),
      ),
    );
  }

  Future<void> _showGoalPicker() async {
    final l10n = AppLocalizations.of(context);
    final currentGoal = ref.read(currentUserProvider).value?.personalGoal;
    final goal = await GoalPickerSheet.show(context, initialGoal: currentGoal);
    if (goal == null || goal == currentGoal || !mounted) return;

    setState(() => _isLoading = true);

    await ref.read(authProvider.notifier).updatePersonalGoal(goal);

    if (!mounted) return;
    setState(() => _isLoading = false);
    // Errors are captured in the notifier state, not thrown
    final failed = ref.read(authProvider).hasError;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failed ? l10n.errorGeneric : l10n.myGoalUpdated),
      ),
    );
  }

  Future<void> _showChangeEmailDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final currentEmailController = TextEditingController();
    final passwordController = TextEditingController();
    final newEmailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.accountSettingsChangeEmail),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentEmailController,
                  decoration: InputDecoration(
                    labelText: l10n.accountSettingsCurrentEmail,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => validateEmail(
                    value,
                    emptyError: l10n.authEmail,
                    invalidError: l10n.authEmail,
                  ),
                ),
                const SizedBox(height: spacingLg),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: l10n.accountSettingsCurrentPassword,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.authPassword;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: spacingLg),
                TextFormField(
                  controller: newEmailController,
                  decoration: InputDecoration(
                    labelText: l10n.accountSettingsNewEmail,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => validateEmail(
                    value,
                    emptyError: l10n.authEmail,
                    invalidError: l10n.authEmail,
                  ),
                ),
              ],
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
        await _changeEmail(
          currentEmailController.text,
          passwordController.text,
          newEmailController.text,
        );
      }
    } finally {
      currentEmailController.dispose();
      passwordController.dispose();
      newEmailController.dispose();
    }
  }

  Future<void> _changeEmail(
    String currentEmail,
    String password,
    String newEmail,
  ) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isLoading = true);

    try {
      // Re-authenticate first
      await ref
          .read(authProvider.notifier)
          .reauthenticateWithEmailPassword(currentEmail, password);

      // Then update email
      await ref.read(authProvider.notifier).updateEmail(newEmail);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.accountSettingsEmailUpdated)),
        );
      }
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final currentEmailController = TextEditingController();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.accountSettingsChangePassword),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: currentEmailController,
                    decoration: InputDecoration(
                      labelText: l10n.accountSettingsCurrentEmail,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => validateEmail(
                      value,
                      emptyError: l10n.authEmail,
                      invalidError: l10n.authEmail,
                    ),
                  ),
                  const SizedBox(height: spacingLg),
                  TextFormField(
                    controller: currentPasswordController,
                    decoration: InputDecoration(
                      labelText: l10n.accountSettingsCurrentPassword,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.authPassword;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: spacingLg),
                  TextFormField(
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      labelText: l10n.accountSettingsNewPassword,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.authPassword;
                      }
                      if (value.length < 6) {
                        return l10n.authPassword;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: spacingLg),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: l10n.accountSettingsConfirmNewPassword,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value != newPasswordController.text) {
                        return l10n.accountSettingsPasswordMismatch;
                      }
                      return null;
                    },
                  ),
                ],
              ),
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
        await _changePassword(
          currentEmailController.text,
          currentPasswordController.text,
          newPasswordController.text,
        );
      }
    } finally {
      currentEmailController.dispose();
      currentPasswordController.dispose();
      newPasswordController.dispose();
      confirmPasswordController.dispose();
    }
  }

  Future<void> _changePassword(
    String email,
    String currentPassword,
    String newPassword,
  ) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isLoading = true);

    try {
      // Re-authenticate first
      await ref
          .read(authProvider.notifier)
          .reauthenticateWithEmailPassword(email, currentPassword);

      // Then update password
      await ref.read(authProvider.notifier).updatePassword(newPassword);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.accountSettingsPasswordUpdated)),
        );
      }
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final firebaseUser = ref.read(firebaseAuthProvider).currentUser;
    final isEmailPasswordUser =
        firebaseUser?.providerData.any((p) => p.providerId == 'password') ??
            false;

    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            l10n.accountSettingsDeleteConfirmTitle,
            style: TextStyle(color: theme.colorScheme.error),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: l10n.authEmail,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => validateEmail(
                          value,
                          emptyError: l10n.authEmail,
                          invalidError: l10n.authEmail,
                        ),
                      ),
                      const SizedBox(height: spacingSm),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: l10n.authPassword,
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.authPassword;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.buttonCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
              onPressed: () {
                if (!isEmailPasswordUser ||
                    (formKey.currentState?.validate() ?? false)) {
                  Navigator.pop(context, true);
                }
              },
              child: Text(l10n.accountSettingsDeleteConfirmButton),
            ),
          ],
        ),
      );

      if ((result ?? false) && mounted) {
        await _deleteAccount(
          emailController.text,
          passwordController.text,
          isEmailPasswordUser,
        );
      }
    } finally {
      emailController.dispose();
      passwordController.dispose();
    }
  }

  Future<void> _deleteAccount(
    String email,
    String password,
    bool requiresReauth,
  ) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isLoading = true);

    try {
      // Re-authenticate first if needed
      if (requiresReauth && email.isNotEmpty && password.isNotEmpty) {
        await ref
            .read(authProvider.notifier)
            .reauthenticateWithEmailPassword(email, password);
      }

      // Delete account
      await ref.read(authProvider.notifier).deleteAccount();

      // Navigate to login after deletion
      if (mounted) {
        context.go(appRoutes.login);
      }
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
