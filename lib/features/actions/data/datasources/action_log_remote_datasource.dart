import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';

/// Interface for action log data operations.
abstract class ActionLogRemoteDataSource {
  /// Creates a new action log entry for a user.
  Future<ActionLogModel> createActionLog(String userId, ActionLogModel log);

  /// Watches action logs for a user, most recent first, capped at
  /// [limit] entries (the history grows unbounded otherwise).
  Stream<List<ActionLogModel>> watchUserActionLogs(
    String userId, {
    required int limit,
  });

  /// Watches action logs whose loggedAt falls in [start, end).
  Stream<List<ActionLogModel>> watchActionLogsForRange(
    String userId,
    DateTime start,
    DateTime end,
  );

  /// Gets action logs whose loggedAt falls in [start, end).
  Future<List<ActionLogModel>> getActionLogsForRange(
    String userId,
    DateTime start,
    DateTime end,
  );

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

  @override
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

  @override
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

  @override
  Future<List<ActionLogModel>> getActionLogsForRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final snapshot = await _rangeQuery(userId, start, end).get();
    return snapshot.docs.map(ActionLogModel.fromFirestore).toList();
  }

  @override
  Future<List<ActionLogModel>> getRecentActionLogs(
    String userId,
    int limit,
  ) async {
    final snapshot = await _userActionLogs(userId)
        .orderBy(AppConstants.fieldLoggedAt, descending: true)
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
