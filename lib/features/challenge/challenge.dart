/// Challenge feature barrel file
/// Export all challenge-related classes here
library;

// Data layer
export 'data/challenge_templates_data.dart';

// Domain layer - Models
export 'domain/models/active_multi_day_challenge.dart';
export 'domain/models/challenge_templates.dart';

// Domain layer - Services
export 'domain/services/challenge_selection_service.dart';

// Presentation layer - Providers
export 'presentation/providers/challenge_providers.dart';

// Presentation layer - Screens
export 'presentation/screens/challenges_screen.dart';

// Presentation layer - Widgets
export 'presentation/widgets/daily_challenge_card.dart';
export 'presentation/widgets/multi_day_challenge_card.dart';
