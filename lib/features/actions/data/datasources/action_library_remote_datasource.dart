import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';

/// Action library data operations, backed by Firestore.
class ActionLibraryRemoteDataSource {
  ActionLibraryRemoteDataSource({required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection(AppConstants.collectionActionLibrary);

  Future<List<ActionModel>> getActions() async {
    final query = _collection
        .where(AppConstants.fieldIsActive, isEqualTo: true)
        .orderBy(AppConstants.fieldSortOrder);
    var snapshot = await query.get();
    // A cold start can answer from an empty cache before the first
    // connection; the caller keeps the result, so insist on the server
    // (an offline error shows Retry instead of "No actions found").
    if (snapshot.docs.isEmpty && snapshot.metadata.isFromCache) {
      snapshot = await query.get(const GetOptions(source: Source.server));
    }
    return snapshot.docs.map(ActionModel.fromFirestore).toList();
  }
}
