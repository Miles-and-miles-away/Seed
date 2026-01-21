import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/action_log_model.dart';

/// Interface for action log data operations.
abstract class ActionLogRemoteDataSource {
  /// Creates a new action log entry for a user.
  Future<ActionLogModel> createActionLog(String userId, ActionLogModel log);

  /// Watches all action logs for a user, ordered by most recent first.
  Stream<List<ActionLogModel>> watchUserActionLogs(String userId);

  /// Gets the most recent action logs for a user.
  Future<List<ActionLogModel>> getRecentActionLogs(String userId, int limit);

  /// Gets a reference to the action log collection for transactions.
  CollectionReference<Map<String, dynamic>> getActionLogCollection(
    String userId,
  );
}

/// Implementation of [ActionLogRemoteDataSource] using Firestore.
class ActionLogRemoteDataSourceImpl implements ActionLogRemoteDataSource {
  ActionLogRemoteDataSourceImpl({required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> _userActionLogs(String userId) =>
      firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .collection(AppConstants.collectionActionLog);

  @override
  Future<ActionLogModel> createActionLog(
    String userId,
    ActionLogModel log,
  ) async {
    final docRef = _userActionLogs(userId).doc();
    final logWithId = log.copyWith(id: docRef.id);

    // Convert to JSON and handle the Timestamp conversion
    final data = logWithId.toJson()..remove('id'); // Don't store id in document

    await docRef.set(data);
    return logWithId;
  }

  @override
  Stream<List<ActionLogModel>> watchUserActionLogs(String userId) {
    return _userActionLogs(userId)
        .orderBy('loggedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(ActionLogModel.fromFirestore).toList(),
        );
  }

  @override
  Future<List<ActionLogModel>> getRecentActionLogs(
    String userId,
    int limit,
  ) async {
    final snapshot = await _userActionLogs(userId)
        .orderBy('loggedAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map(ActionLogModel.fromFirestore).toList();
  }

  @override
  CollectionReference<Map<String, dynamic>> getActionLogCollection(
    String userId,
  ) =>
      _userActionLogs(userId);
}
