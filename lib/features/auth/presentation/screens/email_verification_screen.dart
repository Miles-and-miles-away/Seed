import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_error_mapper.dart';
import '../providers/auth_providers.dart';

/// Screen shown after registration prompting user to verify their email.
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
    final isLoading = authState.isLoading;

    // Get the current user's email
    final userEmail = authChanges.asData?.value?.email ?? '';

    // Listen for auth errors
    ref.listen<AsyncValue<void>>(authProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(mapAuthErrorToMessage(error)),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleSignOut,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email icon
            Container(
              padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 32),

            // Title
            Text(
              'Check Your Email',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              'We sent a verification link to:',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              userEmail,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Click the link in the email to verify your account, '
              'then return here and tap the button below.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Check verification button
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
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                _checkingVerification
                    ? 'Checking...'
                    : "I've Verified My Email",
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 16),

            // Resend email button
            OutlinedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      ref
                          .read(authProvider.notifier)
                          .resendVerificationEmail();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Verification email sent!'),
                        ),
                      );
                    },
              icon: isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: const Text('Resend Email'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 32),

            // Sign out / use different account
            TextButton(
              onPressed: isLoading ? null : _handleSignOut,
              child: const Text('Use a Different Email'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkEmailVerified() async {
    setState(() => _checkingVerification = true);

    try {
      // Reload the user to get updated emailVerified status
      await ref.read(authProvider.notifier).reloadUser();

      // Check if email is now verified
      final user = ref.read(authStateChangesProvider).asData?.value;
      if (user != null && user.emailVerified) {
        // Email verified - router will handle navigation
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email verified! Welcome to Seed!'),
              backgroundColor: AppColors.success,
            ),
          );
          // Force router refresh by navigating to home
          context.go(AppRoutes.home);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Email not verified yet. Please check your inbox and click the verification link.',
              ),
              backgroundColor: AppColors.warning,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _checkingVerification = false);
      }
    }
  }

  void _handleSignOut() {
    ref.read(authProvider.notifier).signOut();
    context.go(AppRoutes.login);
  }
}
