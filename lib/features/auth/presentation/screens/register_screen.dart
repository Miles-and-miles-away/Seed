import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/utils/auth_error_mapper.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_sign_in_button.dart';

/// Registration screen with email/password and social sign-in.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _isCooldown = false;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
        next.when(
          data: (_) {
            if (previous?.isLoading ?? false) {
              context.go(appRoutes.emailVerification);
            }
          },
          loading: () {},
          error: (error, _) {
            _startCooldown();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  mapAuthErrorToMessage(error),
                ),
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
                const SizedBox(height: spacingXxxl),
                Icon(
                  Icons.eco,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: spacingLg),
                Text(
                  l10n.authCreateAccount,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacingSm),
                Text(
                  l10n.authCreateAccountSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacingXxxl),
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
                  textInputAction: TextInputAction.next,
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
                const SizedBox(height: spacingLg),
                AuthTextField(
                  controller: _confirmPasswordController,
                  label: l10n.authConfirmPassword,
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: Icons.lock_outlined,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSignUp(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      );
                    },
                  ),
                  validator: (v) => _validateConfirmPassword(v, l10n),
                ),
                const SizedBox(height: spacingLg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(
                                () => _acceptedTerms = value ?? false,
                              );
                            },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: spacingMd,
                        ),
                        child: Text.rich(
                          TextSpan(
                            text: l10n.authAgreePrefix,
                            style: theme.textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: l10n.settingsTerms,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.push(
                                        appRoutes.terms,
                                      ),
                              ),
                              TextSpan(
                                text: l10n.authAgreeAnd,
                              ),
                              TextSpan(
                                text: l10n.settingsPrivacy,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.push(
                                        appRoutes.privacy,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacingXxl),
                FilledButton(
                  onPressed: isLoading || _isCooldown ? null : _handleSignUp,
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
                      : Text(l10n.authCreateAccount),
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
                        l10n.authOrSignUpWith,
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
                const SizedBox(height: spacingXxxl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.authHaveAccount,
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed:
                          isLoading ? null : () => context.go(appRoutes.login),
                      child: Text(l10n.authSignIn),
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
    if (value == null || value.isEmpty) {
      return l10n.authValidationEmailRequired;
    }
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return l10n.authValidationEmailInvalid;
    }
    return null;
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

  String? _validateConfirmPassword(
    String? value,
    AppLocalizations l10n,
  ) {
    if (value == null || value.isEmpty) {
      return l10n.authValidationConfirmRequired;
    }
    if (value != _passwordController.text) {
      return l10n.accountSettingsPasswordMismatch;
    }
    return null;
  }

  void _handleSignUp() {
    final l10n = AppLocalizations.of(context);
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.authAcceptTermsError),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authProvider.notifier).createUserWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }
}
