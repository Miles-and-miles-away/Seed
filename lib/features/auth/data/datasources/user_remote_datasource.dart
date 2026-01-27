import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
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

  /// Deletes a user document and all subcollections.
  Future<void> deleteUser(String uid);
}

/// Implementation of [UserRemoteDataSource] using Cloud Firestore.
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  UserRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

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
  Future<void> deleteUser(String uid) async {
    final userDoc = _usersCollection.doc(uid);

    // Delete action log subcollection
    final actionLogs = await userDoc
        .collection(AppConstants.collectionActionLog)
        .get();
    for (final doc in actionLogs.docs) {
      await doc.reference.delete();
    }

    // Delete the user document itself
    await userDoc.delete();
  }
}
