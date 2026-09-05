import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/auth/presentation/widgets/social_sign_in_button.dart';

/// Starts the [provider] sign-in; the outcome arrives via [authProvider].
void signInWithSocial(WidgetRef ref, SocialProvider provider) {
  final notifier = ref.read(authProvider.notifier);
  switch (provider) {
    case SocialProvider.google:
      notifier.signInWithGoogle();
    case SocialProvider.apple:
      notifier.signInWithApple();
  }
}
