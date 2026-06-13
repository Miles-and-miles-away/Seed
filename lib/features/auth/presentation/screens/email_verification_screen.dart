import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/utils/auth_error_mapper.dart';
import '../providers/auth_providers.dart';

/// Screen shown after registration prompting user
/// to verify their email.
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  bool _checkingVerification = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authChanges = ref.watch(authStateChangesProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isLoading = authState.isLoading;

    final userEmail = authChanges.asData?.value?.email ?? '';

    ref.listen<AsyncValue<void>>(
      authProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  mapAuthErrorToMessage(error, l10n),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.authVerifyEmailTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleSignOut,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(spacingXxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(spacingXxl),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mark_email_unread_outlined,
                size: 64,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: spacingXxxl),
            Text(
              l10n.authCheckEmail,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: spacingLg),
            Text(
              l10n.authVerificationSentTo,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: spacingSm),
            Text(
              userEmail,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: spacingLg),
            Text(
              l10n.authVerifyInstructions,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: spacingXxxl),
            FilledButton.icon(
              onPressed: (isLoading || _checkingVerification)
                  ? null
                  : _checkEmailVerified,
              icon: _checkingVerification
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.check_circle_outline,
                    ),
              label: Text(
                _checkingVerification
                    ? l10n.authChecking
                    : l10n.authVerifiedButton,
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(spacingHuge),
              ),
            ),
            const SizedBox(height: spacingLg),
            OutlinedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      ref.read(authProvider.notifier).resendVerificationEmail();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.authVerificationSent,
                          ),
                        ),
                      );
                    },
              icon: isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.refresh),
              label: Text(l10n.authResendEmail),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(spacingHuge),
              ),
            ),
            const SizedBox(height: spacingXxxl),
            TextButton(
              onPressed: isLoading ? null : _handleSignOut,
              child: Text(l10n.authDifferentEmail),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkEmailVerified() async {
    setState(() => _checkingVerification = true);
    final l10n = AppLocalizations.of(context);

    try {
      await ref.read(authProvider.notifier).reloadUser();

      final user = ref.read(authStateChangesProvider).asData?.value;
      if (user != null && user.emailVerified) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.authEmailVerified),
              backgroundColor: AppColors.success,
            ),
          );
          context.go(appRoutes.home);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.authEmailNotVerified,
              ),
              backgroundColor: AppColors.warning,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(
          () => _checkingVerification = false,
        );
      }
    }
  }

  void _handleSignOut() {
    ref.read(authProvider.notifier).signOut();
    context.go(appRoutes.login);
  }
}
