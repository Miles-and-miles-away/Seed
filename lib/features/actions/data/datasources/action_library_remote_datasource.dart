import 'dart:async';

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
    const server = GetOptions(source: Source.server);
    var snapshot = await query.get(const GetOptions(source: Source.cache));
    if (snapshot.docs.isEmpty) {
      snapshot = await query.get(server);
    } else {
      // Refreshes the cache, so a reseed shows on the next start.
      unawaited(query.get(server).then((_) {}, onError: (_) {}));
    }
    return snapshot.docs.map(ActionModel.fromFirestore).toList();
  }
}
