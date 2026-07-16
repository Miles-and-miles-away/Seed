import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// Supported social sign-in providers.
enum SocialProvider { google, apple }

/// A button for social sign-in (Google, Apple).
class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    required this.provider,
    this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final SocialProvider provider;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final (icon, label, backgroundColor, foregroundColor) = switch (provider) {
      SocialProvider.google => (
        Icons.g_mobiledata,
        'Google',
        isDark ? const Color(0xFF4285F4) : Colors.white,
        isDark ? Colors.white : Colors.black87,
      ),
      SocialProvider.apple => (
        Icons.apple,
        'Apple',
        isDark ? Colors.white : Colors.black,
        isDark ? Colors.black : Colors.white,
      ),
    };

    return SizedBox(
      height: spacingHuge,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          side: BorderSide(
            color: isDark ? Colors.transparent : theme.colorScheme.outline,
          ),
          shape: RoundedRectangleBorder(borderRadius: borderRadiusMd),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foregroundColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: spacingXxl),
                  const SizedBox(width: spacingSm),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
