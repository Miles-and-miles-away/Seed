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
    // Requires composite index: (isActive ASC, sortOrder ASC)
    return _collection
        .where('isActive', isEqualTo: true)
        .orderBy('sortOrder')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(ActionModel.fromFirestore)
          .toList();
    });
  }

  @override
  Future<ActionModel?> getAction(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return ActionModel.fromFirestore(doc);
  }
}
