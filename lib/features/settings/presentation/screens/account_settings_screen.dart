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

typedef _ChangeEmailInput = ({
  String currentEmail,
  String password,
  String newEmail,
});

typedef _ChangePasswordInput = ({
  String email,
  String currentPassword,
  String newPassword,
});

typedef _DeleteAccountInput = ({String email, String password});

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

  /// Whether the signed-in Firebase user authenticates with email/password.
  bool get _isEmailPasswordUser =>
      ref
          .read(firebaseAuthProvider)
          .currentUser
          ?.providerData
          .any((p) => p.providerId == 'password') ??
      false;

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
    final isEmailPasswordUser = _isEmailPasswordUser;

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
                            : _showChangeDisplayNameDialog,
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
                          onTap: _showChangeEmailDialog,
                        ),
                        SettingsTile(
                          leading: const Icon(Icons.lock_outline),
                          title: l10n.accountSettingsChangePassword,
                          onTap: _showChangePasswordDialog,
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
                        onTap: _showDeleteAccountDialog,
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

  Future<void> _showChangeDisplayNameDialog() async {
    final currentName = ref.read(currentUserProvider).value?.displayName;
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _DisplayNameDialog(initialName: currentName ?? ''),
    );
    if (name == null || !mounted) return;
    await _changeDisplayName(name);
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

  Future<void> _showChangeEmailDialog() async {
    var currentEmail = '';
    var newEmail = '';

    // Re-open prefilled on a save failure (e.g. wrong password) so the typed
    // emails are never lost; only the password must be re-entered.
    while (true) {
      final input = await showDialog<_ChangeEmailInput>(
        context: context,
        builder: (_) => _ChangeEmailDialog(
          initialCurrentEmail: currentEmail,
          initialNewEmail: newEmail,
        ),
      );
      if (input == null || !mounted) return;

      final saved = await _changeEmail(
        input.currentEmail,
        input.password,
        input.newEmail,
      );
      if (saved || !mounted) return;
      currentEmail = input.currentEmail;
      newEmail = input.newEmail;
    }
  }

  /// Shows the spinner while [op] runs, then reports [successMessage] and
  /// calls [onSuccess], or logs under [logLabel] and shows the mapped auth
  /// error. Returns true on success so the caller can stop retrying; false
  /// re-opens the dialog with input kept.
  Future<bool> _runReauthed({
    required Future<void> Function(AuthNotifier auth) op,
    required String logLabel,
    String? successMessage,
    VoidCallback? onSuccess,
  }) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isLoading = true);

    try {
      await op(ref.read(authProvider.notifier));

      if (mounted) {
        if (successMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(successMessage)));
        }
        onSuccess?.call();
      }
      return true;
    } on Exception catch (e) {
      appLogger.error(logLabel, error: e);
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

  /// Re-authenticates then updates the email.
  Future<bool> _changeEmail(
    String currentEmail,
    String password,
    String newEmail,
  ) {
    final l10n = AppLocalizations.of(context);
    return _runReauthed(
      op: (auth) async {
        await auth.reauthenticateWithEmailPassword(currentEmail, password);
        await auth.updateEmail(newEmail);
      },
      logLabel: 'Account: email update failed',
      successMessage: l10n.accountSettingsEmailUpdated,
    );
  }

  Future<void> _showChangePasswordDialog() async {
    var email = '';
    var newPassword = '';

    // Re-open prefilled on a save failure (e.g. wrong current password) so
    // the email and new password aren't lost; only the current password must
    // be re-entered.
    while (true) {
      final input = await showDialog<_ChangePasswordInput>(
        context: context,
        builder: (_) => _ChangePasswordDialog(
          initialEmail: email,
          initialNewPassword: newPassword,
        ),
      );
      if (input == null || !mounted) return;

      final saved = await _changePassword(
        input.email,
        input.currentPassword,
        input.newPassword,
      );
      if (saved || !mounted) return;
      email = input.email;
      newPassword = input.newPassword;
    }
  }

  /// Re-authenticates then updates the password.
  Future<bool> _changePassword(
    String email,
    String currentPassword,
    String newPassword,
  ) {
    final l10n = AppLocalizations.of(context);
    return _runReauthed(
      op: (auth) async {
        await auth.reauthenticateWithEmailPassword(email, currentPassword);
        await auth.updatePassword(newPassword);
      },
      logLabel: 'Account: password update failed',
      successMessage: l10n.accountSettingsPasswordUpdated,
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    final isEmailPasswordUser = _isEmailPasswordUser;
    var email = '';

    // Re-open prefilled on a re-auth failure so the typed email isn't lost;
    // only the password must be re-entered.
    while (true) {
      final input = await showDialog<_DeleteAccountInput>(
        context: context,
        builder: (_) => _DeleteAccountDialog(
          initialEmail: email,
          requiresReauth: isEmailPasswordUser,
        ),
      );
      if (input == null || !mounted) return;

      final deleted = await _deleteAccount(
        input.email,
        input.password,
        requiresReauth: isEmailPasswordUser,
      );
      if (deleted || !mounted) return;
      email = input.email;
    }
  }

  /// Re-authenticates if required then deletes the account, navigating to
  /// login on success.
  Future<bool> _deleteAccount(
    String email,
    String password, {
    required bool requiresReauth,
  }) {
    return _runReauthed(
      op: (auth) async {
        if (requiresReauth && email.isNotEmpty && password.isNotEmpty) {
          await auth.reauthenticateWithEmailPassword(email, password);
        }
        await auth.deleteAccount();
      },
      logLabel: 'Account: account deletion failed',
      onSuccess: () => context.go(appRoutes.login),
    );
  }
}

/// The dialogs below own their controllers as State fields so Flutter
/// disposes them when the dialog element unmounts, after the exit animation.
/// Disposing right after `await showDialog` crashed: the pop dismisses the
/// keyboard, the inset change rebuilds the departing dialog, and its fields
/// touched a disposed controller.
class _DisplayNameDialog extends StatefulWidget {
  const _DisplayNameDialog({required this.initialName});

  final String initialName;

  @override
  State<_DisplayNameDialog> createState() => _DisplayNameDialogState();
}

class _DisplayNameDialogState extends State<_DisplayNameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _FormDialog(
      title: l10n.accountSettingsDisplayName,
      formKey: _formKey,
      onConfirm: () => Navigator.pop(context, _nameController.text.trim()),
      children: [
        TextFormField(
          controller: _nameController,
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
      ],
    );
  }
}

class _ChangeEmailDialog extends StatefulWidget {
  const _ChangeEmailDialog({
    required this.initialCurrentEmail,
    required this.initialNewEmail,
  });

  final String initialCurrentEmail;
  final String initialNewEmail;

  @override
  State<_ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<_ChangeEmailDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _currentEmailController = TextEditingController(
    text: widget.initialCurrentEmail,
  );
  final _passwordController = TextEditingController();
  late final _newEmailController = TextEditingController(
    text: widget.initialNewEmail,
  );

  @override
  void dispose() {
    _currentEmailController.dispose();
    _passwordController.dispose();
    _newEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _FormDialog(
      title: l10n.accountSettingsChangeEmail,
      formKey: _formKey,
      // Trim emails to match what the field validators accepted.
      onConfirm: () => Navigator.pop(context, (
        currentEmail: _currentEmailController.text.trim(),
        password: _passwordController.text,
        newEmail: _newEmailController.text.trim(),
      )),
      children: [
        _emailField(
          context,
          _currentEmailController,
          l10n.accountSettingsCurrentEmail,
        ),
        const SizedBox(height: spacingLg),
        _passwordField(
          context,
          _passwordController,
          l10n.accountSettingsCurrentPassword,
        ),
        const SizedBox(height: spacingLg),
        _emailField(context, _newEmailController, l10n.accountSettingsNewEmail),
      ],
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog({
    required this.initialEmail,
    required this.initialNewPassword,
  });

  final String initialEmail;
  final String initialNewPassword;

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController = TextEditingController(
    text: widget.initialEmail,
  );
  final _currentPasswordController = TextEditingController();
  late final _newPasswordController = TextEditingController(
    text: widget.initialNewPassword,
  );
  // Validation forces confirm == new, so the same initial value re-fills
  // both fields when the dialog re-opens after a failed save.
  late final _confirmPasswordController = TextEditingController(
    text: widget.initialNewPassword,
  );

  @override
  void dispose() {
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _FormDialog(
      title: l10n.accountSettingsChangePassword,
      formKey: _formKey,
      // Trim the email to match what the field validator accepted.
      onConfirm: () => Navigator.pop(context, (
        email: _emailController.text.trim(),
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      )),
      children: [
        _emailField(
          context,
          _emailController,
          l10n.accountSettingsCurrentEmail,
        ),
        const SizedBox(height: spacingLg),
        _passwordField(
          context,
          _currentPasswordController,
          l10n.accountSettingsCurrentPassword,
        ),
        const SizedBox(height: spacingLg),
        _passwordField(
          context,
          _newPasswordController,
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
          context,
          _confirmPasswordController,
          l10n.accountSettingsConfirmNewPassword,
          validator: (value) {
            if (value != _newPasswordController.text) {
              return l10n.accountSettingsPasswordMismatch;
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog({
    required this.initialEmail,
    required this.requiresReauth,
  });

  final String initialEmail;
  final bool requiresReauth;

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController = TextEditingController(
    text: widget.initialEmail,
  );
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // A Form with no fields validates trivially, so the confirm button
    // works unchanged for OAuth users with no re-auth fields.
    return _FormDialog(
      title: l10n.accountSettingsDeleteConfirmTitle,
      formKey: _formKey,
      // Trim the email to match what the field validator accepted.
      onConfirm: () => Navigator.pop(context, (
        email: _emailController.text.trim(),
        password: _passwordController.text,
      )),
      confirmText: l10n.accountSettingsDeleteConfirmButton,
      dangerous: true,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.accountSettingsDeleteConfirmMessage),
        if (widget.requiresReauth) ...[
          const SizedBox(height: spacingLg),
          Text(
            l10n.accountSettingsReauthRequired,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: spacingSm),
          _emailField(context, _emailController, l10n.authEmail),
          const SizedBox(height: spacingSm),
          _passwordField(context, _passwordController, l10n.authPassword),
        ],
      ],
    );
  }
}

/// Shared scaffold for the account dialogs: an [AlertDialog] wrapping
/// [children] in a scrollable [Form], with cancel/confirm actions where
/// confirm validates the form before invoking [onConfirm].
class _FormDialog extends StatelessWidget {
  const _FormDialog({
    required this.title,
    required this.formKey,
    required this.onConfirm,
    required this.children,
    this.confirmText,
    this.dangerous = false,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final String title;
  final GlobalKey<FormState> formKey;
  final VoidCallback onConfirm;
  final List<Widget> children;
  final String? confirmText;
  final bool dangerous;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return AlertDialog(
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
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.buttonCancel),
        ),
        FilledButton(
          style: dangerous
              ? FilledButton.styleFrom(backgroundColor: theme.colorScheme.error)
              : null,
          onPressed: () {
            if (formKey.currentState!.validate()) {
              onConfirm();
            }
          },
          child: Text(confirmText ?? l10n.buttonSave),
        ),
      ],
    );
  }
}

TextFormField _emailField(
  BuildContext context,
  TextEditingController controller,
  String label,
) {
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
  BuildContext context,
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
