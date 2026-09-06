import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import '../models/app_user_model.dart';

/// Firestore user document operations.
class UserRemoteDataSource {
  UserRemoteDataSource({
    required FirebaseFirestore firestore,
    FirebaseFunctions? functions,
  }) : _firestore = firestore,
       _functionsOverride = functions;

  final FirebaseFirestore _firestore;
  final FirebaseFunctions? _functionsOverride;

  // Resolved lazily so constructing the data source (e.g. in tests)
  // does not require an initialized Firebase app.
  FirebaseFunctions get _functions =>
      _functionsOverride ??
      FirebaseFunctions.instanceFor(region: AppConstants.functionsRegion);

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection(AppConstants.collectionUsers);

  Future<AppUserModel?> getUser(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return AppUserModel.fromJson({...doc.data()!, 'uid': uid});
  }

  Future<void> createUser(AppUserModel user) async {
    // Remove uid from document data since it's the document ID
    final data = user.toJson()..remove('uid');
    await _usersCollection.doc(user.uid).set(data);
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).update(data);
  }

  Stream<AppUserModel?> watchUser(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return AppUserModel.fromJson({...doc.data()!, 'uid': uid});
    });
  }

  Future<void> deleteUser() async {
    // Deletion must run server-side: the rules make actionLog entries
    // immutable from clients, and only the Admin SDK can remove
    // subcollections (dailySummaries included) and the Auth user.
    await _functions.httpsCallable('deleteUserAccount').call<Object?>();
  }
}
