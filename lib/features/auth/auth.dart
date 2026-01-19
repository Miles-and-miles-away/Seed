/// Auth feature barrel file
/// Export all auth-related classes here
library;

// Data layer
export 'data/models/app_user_model.dart';
export 'data/repositories/auth_repository.dart';

// Presentation layer
export 'presentation/providers/auth_providers.dart';
export 'presentation/screens/email_verification_screen.dart';
export 'presentation/screens/login_screen.dart';
export 'presentation/screens/register_screen.dart';
export 'presentation/widgets/auth_text_field.dart';
export 'presentation/widgets/social_sign_in_button.dart';
