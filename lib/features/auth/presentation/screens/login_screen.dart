import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/validators.dart';
import '../providers/auth_providers.dart';
import '../utils/listen_auth_result.dart';
import '../utils/sign_in_with_social.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/or_divider.dart';
import '../widgets/social_sign_in_button.dart';
import '../widgets/social_sign_in_row.dart';

/// Login screen with email/password and social sign-in options.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isCooldown = false;
  SocialProvider? _pendingSocial;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _isCooldown = true);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer(
      const Duration(seconds: AppConstants.authCooldownSeconds),
      () {
        if (mounted) setState(() => _isCooldown = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isLoading = authState.isLoading;

    listenAuthResult(context, ref, onError: _startCooldown);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(spacingXxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: spacingHuge),
                Icon(Icons.eco, size: 64, color: theme.colorScheme.primary),
                const SizedBox(height: spacingLg),
                Text(
                  l10n.authWelcomeBack,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacingSm),
                Text(
                  l10n.authSignInSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacingHuge),
                AuthTextField(
                  controller: _emailController,
                  label: l10n.authEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  textInputAction: TextInputAction.next,
                  validator: (v) => validateEmail(
                    v,
                    emptyError: l10n.authValidationEmailRequired,
                    invalidError: l10n.authValidationEmailInvalid,
                  ),
                ),
                const SizedBox(height: spacingLg),
                AuthTextField(
                  controller: _passwordController,
                  label: l10n.authPassword,
                  obscurable: true,
                  prefixIcon: Icons.lock_outlined,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSignIn(),
                  validator: (v) => validatePassword(
                    v,
                    emptyError: l10n.authValidationPasswordRequired,
                    shortError: l10n.authValidationPasswordShort,
                  ),
                ),
                const SizedBox(height: spacingSm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading ? null : _showForgotPasswordDialog,
                    child: Text(l10n.authForgotPassword),
                  ),
                ),
                const SizedBox(height: spacingXxl),
                FilledButton(
                  onPressed: isLoading || _isCooldown ? null : _handleSignIn,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(spacingHuge),
                  ),
                  child: isLoading && _pendingSocial == null
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.authSignIn),
                ),
                const SizedBox(height: spacingXxl),
                OrDivider(label: l10n.authOrContinueWith),
                const SizedBox(height: spacingXxl),
                SocialSignInRow(
                  isLoading: isLoading,
                  isCooldown: _isCooldown,
                  pendingProvider: _pendingSocial,
                  onPressed: (provider) {
                    setState(() => _pendingSocial = provider);
                    signInWithSocial(ref, provider);
                  },
                ),
                const SizedBox(height: spacingHuge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.authNoAccount, style: theme.textTheme.bodyMedium),
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () => context.go(appRoutes.register),
                      child: Text(l10n.authRegister),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignIn() {
    setState(() => _pendingSocial = null);
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(authProvider.notifier)
          .signInWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  Future<void> _showForgotPasswordDialog() {
    return showDialog<void>(
      context: context,
      builder: (_) =>
          _ForgotPasswordDialog(initialEmail: _emailController.text),
    );
  }
}

/// The reset-email dialog owns its controller so Flutter disposes it
/// when the dialog element unmounts -- after the exit animation.
/// Disposing in a finally after `await showDialog` crashed: the pop
/// dismisses the keyboard, the inset change rebuilds the departing
/// dialog, and its TextField touched a disposed controller.
class _ForgotPasswordDialog extends ConsumerStatefulWidget {
  const _ForgotPasswordDialog({required this.initialEmail});

  final String initialEmail;

  @override
  ConsumerState<_ForgotPasswordDialog> createState() =>
      _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends ConsumerState<_ForgotPasswordDialog> {
  late final _emailController = TextEditingController(
    text: widget.initialEmail,
  );
  String? _errorText;
  bool _isSending = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final email = _emailController.text.trim();
    final validationError = validateEmail(
      email,
      emptyError: l10n.authValidationEmailRequired,
      invalidError: l10n.authValidationEmailInvalid,
    );
    if (validationError != null) {
      setState(() => _errorText = validationError);
      return;
    }

    setState(() {
      _errorText = null;
      _isSending = true;
    });
    await ref.read(authProvider.notifier).sendPasswordResetEmail(email);
    if (!mounted) return;

    // Failures surface through the authProvider listener in the login
    // screen's build (mapped, localized); keep the dialog open so the
    // user can retry or cancel.
    if (ref.read(authProvider).hasError) {
      setState(() => _isSending = false);
      return;
    }

    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.authForgotPasswordSent)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.authForgotPasswordTitle),
      content: TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: l10n.authEmail,
          hintText: l10n.authForgotPasswordHint,
          errorText: _errorText,
        ),
        keyboardType: TextInputType.emailAddress,
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: _isSending ? null : () => Navigator.pop(context),
          child: Text(l10n.buttonCancel),
        ),
        FilledButton(
          onPressed: _isSending ? null : _handleSend,
          child: Text(l10n.authForgotPasswordSend),
        ),
      ],
    );
  }
}
