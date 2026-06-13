import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import '../models/app_user_model.dart';

/// Interface for Firestore user document operations.
abstract class UserRemoteDataSource {
  /// Gets a user document by UID.
  Future<AppUserModel?> getUser(String uid);

  /// Creates a new user document.
  Future<void> createUser(AppUserModel user);

  /// Updates specific fields in a user document.
  Future<void> updateUser(String uid, Map<String, dynamic> data);

  /// Watches a user document for real-time updates.
  Stream<AppUserModel?> watchUser(String uid);

  /// Deletes the signed-in user's account: the user document, all
  /// subcollections, and the Auth user.
  Future<void> deleteUser();
}

/// Implementation of [UserRemoteDataSource] using Cloud Firestore.
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  UserRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    FirebaseFunctions? functions,
  })  : _firestore = firestore,
        _functionsOverride = functions;

  final FirebaseFirestore _firestore;
  final FirebaseFunctions? _functionsOverride;

  // Resolved lazily so constructing the data source (e.g. in tests)
  // does not require an initialized Firebase app.
  FirebaseFunctions get _functions =>
      _functionsOverride ?? FirebaseFunctions.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection(AppConstants.collectionUsers);

  @override
  Future<AppUserModel?> getUser(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return AppUserModel.fromJson({...doc.data()!, 'uid': uid});
  }

  @override
  Future<void> createUser(AppUserModel user) async {
    // Remove uid from document data since it's the document ID
    final data = user.toJson()..remove('uid');
    await _usersCollection.doc(user.uid).set(data);
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).update(data);
  }

  @override
  Stream<AppUserModel?> watchUser(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return AppUserModel.fromJson({...doc.data()!, 'uid': uid});
    });
  }

  @override
  Future<void> deleteUser() async {
    // Deletion must run server-side: the rules make actionLog entries
    // immutable from clients, and only the Admin SDK can remove
    // subcollections (dailySummaries included) and the Auth user.
    await _functions.httpsCallable('deleteUserAccount').call<Object?>();
  }
}
