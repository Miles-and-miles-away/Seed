import 'dart:io';

import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/auth/presentation/widgets/social_sign_in_button.dart';

/// Google beside Apple (iOS only), all disabled while any sign-in runs.
class SocialSignInRow extends StatelessWidget {
  const SocialSignInRow({
    required this.isLoading,
    required this.isCooldown,
    required this.pendingProvider,
    required this.onPressed,
    super.key,
  });

  final bool isLoading;
  final bool isCooldown;

  /// The provider whose button shows the spinner while [isLoading].
  final SocialProvider? pendingProvider;
  final ValueChanged<SocialProvider> onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _button(SocialProvider.google)),
        if (Platform.isIOS) ...[
          const SizedBox(width: spacingLg),
          Expanded(child: _button(SocialProvider.apple)),
        ],
      ],
    );
  }

  Widget _button(SocialProvider provider) => SocialSignInButton(
    provider: provider,
    isLoading: isLoading && pendingProvider == provider,
    onPressed: isLoading || isCooldown ? null : () => onPressed(provider),
  );
}
