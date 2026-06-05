import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/utils/auth_error_mapper.dart';
import 'package:seed_app/core/utils/validators.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_sign_in_button.dart';

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
  bool _obscurePassword = true;
  bool _isCooldown = false;
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
      const Duration(
        seconds: AppConstants.authCooldownSeconds,
      ),
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

    ref.listen<AsyncValue<void>>(
      authProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, _) {
            _startCooldown();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(mapAuthErrorToMessage(error)),
                backgroundColor: AppColors.error,
              ),
            );
          },
        );
      },
    );

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
                Icon(
                  Icons.eco,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
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
                  validator: (v) => _validateEmail(v, l10n),
                ),
                const SizedBox(height: spacingLg),
                AuthTextField(
                  controller: _passwordController,
                  label: l10n.authPassword,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outlined,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSignIn(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(
                        () => _obscurePassword = !_obscurePassword,
                      );
                    },
                  ),
                  validator: (v) => _validatePassword(v, l10n),
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
                  child: isLoading
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
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacingLg,
                      ),
                      child: Text(
                        l10n.authOrContinueWith,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: spacingXxl),
                Row(
                  children: [
                    Expanded(
                      child: SocialSignInButton(
                        provider: SocialProvider.google,
                        isLoading: isLoading || _isCooldown,
                        onPressed: () =>
                            ref.read(authProvider.notifier).signInWithGoogle(),
                      ),
                    ),
                    if (Platform.isIOS) ...[
                      const SizedBox(width: spacingLg),
                      Expanded(
                        child: SocialSignInButton(
                          provider: SocialProvider.apple,
                          isLoading: isLoading || _isCooldown,
                          onPressed: () => ref
                              .read(
                                authProvider.notifier,
                              )
                              .signInWithApple(),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: spacingHuge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.authNoAccount,
                      style: theme.textTheme.bodyMedium,
                    ),
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

  String? _validateEmail(
    String? value,
    AppLocalizations l10n,
  ) {
    return validateEmail(
      value,
      emptyError: l10n.authValidationEmailRequired,
      invalidError: l10n.authValidationEmailInvalid,
    );
  }

  String? _validatePassword(
    String? value,
    AppLocalizations l10n,
  ) {
    if (value == null || value.isEmpty) {
      return l10n.authValidationPasswordRequired;
    }
    if (value.length < 6) {
      return l10n.authValidationPasswordShort;
    }
    return null;
  }

  void _handleSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authProvider.notifier).signInWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  void _showForgotPasswordDialog() {
    final l10n = AppLocalizations.of(context);
    final emailController = TextEditingController(
      text: _emailController.text,
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.authForgotPasswordTitle),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: l10n.authEmail,
            hintText: l10n.authForgotPasswordHint,
          ),
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.buttonCancel),
          ),
          FilledButton(
            onPressed: () {
              final email = emailController.text.trim();
              if (emailRegex.hasMatch(email)) {
                ref.read(authProvider.notifier).sendPasswordResetEmail(email);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.authForgotPasswordSent,
                    ),
                  ),
                );
              }
            },
            child: Text(l10n.authForgotPasswordSend),
          ),
        ],
      ),
    );
  }
}
