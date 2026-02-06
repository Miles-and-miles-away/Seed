/// Settings feature barrel file
/// Export all settings-related classes here
library;

// Data layer - Datasources
export 'data/datasources/settings_remote_datasource.dart';

// Data layer - Models
export 'data/models/notification_schedule_model.dart';
export 'data/models/user_settings_model.dart';

// Data layer - Repositories
export 'data/repositories/settings_repository.dart';

// Presentation layer - Providers
export 'presentation/providers/settings_providers.dart';

// Presentation layer - Screens
export 'presentation/screens/about_screen.dart';
export 'presentation/screens/account_settings_screen.dart';
export 'presentation/screens/language_settings_screen.dart';
export 'presentation/screens/notification_settings_screen.dart';
export 'presentation/screens/settings_screen.dart';

// Presentation layer - Widgets
export 'presentation/widgets/settings_section.dart';
export 'presentation/widgets/settings_tile.dart';
export 'presentation/widgets/streak_milestone_dialog.dart';
