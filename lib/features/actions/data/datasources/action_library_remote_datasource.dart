import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';

/// Action library data operations, backed by Firestore.
class ActionLibraryRemoteDataSource {
  ActionLibraryRemoteDataSource({required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection(AppConstants.collectionActionLibrary);

  Stream<List<ActionModel>> watchActions() {
    return _collection
        .where(AppConstants.fieldIsActive, isEqualTo: true)
        .orderBy(AppConstants.fieldSortOrder)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(ActionModel.fromFirestore).toList();
    });
  }

  Future<List<ActionModel>> getActions() async {
    final snapshot = await _collection
        .where(AppConstants.fieldIsActive, isEqualTo: true)
        .orderBy(AppConstants.fieldSortOrder)
        .get();
    return snapshot.docs.map(ActionModel.fromFirestore).toList();
  }

  Future<ActionModel?> getAction(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return ActionModel.fromFirestore(doc);
  }
}
