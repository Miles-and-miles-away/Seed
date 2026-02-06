import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/action_model.dart';

/// Interface for action library data operations.
abstract class ActionLibraryRemoteDataSource {
  /// Watches all active actions from the library.
  Stream<List<ActionModel>> watchActions();

  /// Gets a single action by ID.
  Future<ActionModel?> getAction(String id);
}

/// Implementation of [ActionLibraryRemoteDataSource] using Firestore.
class ActionLibraryRemoteDataSourceImpl implements ActionLibraryRemoteDataSource {
  ActionLibraryRemoteDataSourceImpl({required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection(AppConstants.collectionActionLibrary);

  @override
  Stream<List<ActionModel>> watchActions() {
    // Note: Using only where() to avoid composite index requirement.
    // Sorting is done client-side instead.
    return _collection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map(ActionModel.fromFirestore).toList()
            // Sort client-side by sortOrder
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        });
  }

  @override
  Future<ActionModel?> getAction(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return ActionModel.fromFirestore(doc);
  }
}
