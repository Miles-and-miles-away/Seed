/// Settings feature barrel file
/// Export all settings-related classes here
library;

// Data layer - Models
export 'data/models/action_reminder_model.dart';
export 'data/models/user_settings_model.dart';

// Data layer - Repositories
export 'data/repositories/settings_repository.dart';

// Presentation layer - Providers
export 'presentation/providers/language_sync_provider.dart';
export 'presentation/providers/settings_providers.dart';

// Presentation layer - Screens
export 'presentation/screens/about_screen.dart';
export 'presentation/screens/account_settings_screen.dart';
export 'presentation/screens/feedback_screen.dart';
export 'presentation/screens/language_settings_screen.dart';
export 'presentation/screens/reminders_screen.dart';
export 'presentation/screens/settings_screen.dart';

// Presentation layer - Widgets
export 'presentation/widgets/action_reminder_sheet.dart';
export 'presentation/widgets/daily_reminder_tiles.dart';
export 'presentation/widgets/language_picker_sheet.dart';
export 'presentation/widgets/language_tile.dart';
export 'presentation/widgets/settings_icon_button.dart';
export 'presentation/widgets/settings_section.dart';
export 'presentation/widgets/settings_tile.dart';
export 'presentation/widgets/streak_milestone_dialog.dart';
