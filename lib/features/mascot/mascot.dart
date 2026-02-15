/// Mascot feature barrel file
/// Export all mascot-related classes here
library;

// Data layer - Models
export 'data/mascot_species_data.dart';
export 'data/models/egg_model.dart';
export 'data/models/evolution_stage_model.dart';
export 'data/models/mascot_model.dart';
export 'data/models/mascot_species_model.dart';
export 'data/repositories/mascot_repository.dart';
export 'data/services/egg_hatching_service.dart';
export 'data/services/mascot_migration_service.dart';

// Presentation layer
export 'presentation/providers/mascot_providers.dart';
export 'presentation/screens/mascot_screen.dart';
export 'presentation/screens/mascot_selection_screen.dart';
export 'presentation/widgets/egg_discovery_celebration.dart';
export 'presentation/widgets/egg_hatching_celebration.dart';
export 'presentation/widgets/egg_progress_widget.dart';
export 'presentation/widgets/evolution_celebration.dart';
export 'presentation/widgets/mascot_display.dart';
