import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';

/// Interface for action library data operations.
abstract class ActionLibraryRemoteDataSource {
  /// Watches all active actions from the library.
  Stream<List<ActionModel>> watchActions();

  /// Gets a single action by ID.
  Future<ActionModel?> getAction(String id);
}

/// Implementation of [ActionLibraryRemoteDataSource] using Firestore.
class ActionLibraryRemoteDataSourceImpl
    implements ActionLibraryRemoteDataSource {
  ActionLibraryRemoteDataSourceImpl({required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection(AppConstants.collectionActionLibrary);

  @override
  Stream<List<ActionModel>> watchActions() {
    return _collection
        .where(AppConstants.fieldIsActive, isEqualTo: true)
        .orderBy(AppConstants.fieldSortOrder)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(ActionModel.fromFirestore).toList();
    });
  }

  @override
  Future<ActionModel?> getAction(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return ActionModel.fromFirestore(doc);
  }
}
