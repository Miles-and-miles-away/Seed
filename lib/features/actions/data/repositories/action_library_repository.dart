import '../datasources/action_library_remote_datasource.dart';
import '../models/action_model.dart';

/// Repository for accessing the action library.
class ActionLibraryRepository {
  ActionLibraryRepository({required this.dataSource});

  final ActionLibraryRemoteDataSource dataSource;

  /// Watches all active actions from the library.
  Stream<List<ActionModel>> watchActions() => dataSource.watchActions();

  /// Gets all active actions from the library once.
  Future<List<ActionModel>> getActions() => dataSource.getActions();

  /// Gets a single action by ID.
  Future<ActionModel?> getAction(String id) => dataSource.getAction(id);
}
