import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';

/// Action log data operations, backed by Firestore.
class ActionLogRemoteDataSource {
  ActionLogRemoteDataSource({required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> _userActionLogs(String userId) =>
      firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .collection(AppConstants.collectionActionLog);

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

  Query<Map<String, dynamic>> _rangeQuery(
    String userId,
    DateTime start,
    DateTime end,
  ) =>
      _userActionLogs(userId)
          .where(
            AppConstants.fieldLoggedAt,
            isGreaterThanOrEqualTo: Timestamp.fromDate(start),
          )
          .where(
            AppConstants.fieldLoggedAt,
            isLessThan: Timestamp.fromDate(end),
          )
          .orderBy(AppConstants.fieldLoggedAt, descending: true);

  Stream<List<ActionLogModel>> watchUserActionLogs(
    String userId, {
    required int limit,
  }) {
    return _userActionLogs(userId)
        .orderBy(AppConstants.fieldLoggedAt, descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(ActionLogModel.fromFirestore).toList(),
        );
  }

  Stream<List<ActionLogModel>> watchActionLogsForRange(
    String userId,
    DateTime start,
    DateTime end,
  ) {
    return _rangeQuery(userId, start, end).snapshots().map(
          (snapshot) =>
              snapshot.docs.map(ActionLogModel.fromFirestore).toList(),
        );
  }

  Future<List<ActionLogModel>> getActionLogsForRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final snapshot = await _rangeQuery(userId, start, end).get();
    return snapshot.docs.map(ActionLogModel.fromFirestore).toList();
  }

  CollectionReference<Map<String, dynamic>> getActionLogCollection(
    String userId,
  ) =>
      _userActionLogs(userId);
}
