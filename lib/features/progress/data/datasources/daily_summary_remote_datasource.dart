import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';

/// Remote data source for daily summaries stored in Firestore.
class DailySummaryRemoteDataSource {
  DailySummaryRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  /// Get the daily summaries collection for a user.
  CollectionReference<Map<String, dynamic>> _summariesCollection(
    String userId,
  ) =>
      _firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .collection(AppConstants.collectionDailySummaries);

  /// Get today's date string in YYYY-MM-DD format.
  String _todayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Convert a DateTime to date string in YYYY-MM-DD format.
  String _dateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Stream today's daily summary for a user.
  Stream<DailySummaryModel?> watchTodaySummary(String userId) {
    final todayId = _todayDateString();
    return _summariesCollection(userId).doc(todayId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return DailySummaryModel.fromJson(doc.data()!);
    });
  }

  /// Get a specific day's summary.
  Future<DailySummaryModel?> getSummary(String userId, DateTime date) async {
    final dateId = _dateToString(date);
    final doc = await _summariesCollection(userId).doc(dateId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return DailySummaryModel.fromJson(doc.data()!);
  }

  /// Get summaries for a date range (for calendar view).
  Future<List<DailySummaryModel>> getSummariesInRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final startId = _dateToString(startDate);
    final endId = _dateToString(endDate);

    final snapshot = await _summariesCollection(userId)
        .where(AppConstants.fieldDate, isGreaterThanOrEqualTo: startId)
        .where(AppConstants.fieldDate, isLessThanOrEqualTo: endId)
        .get();

    return snapshot.docs
        .map((doc) => DailySummaryModel.fromJson(doc.data()))
        .toList();
  }

  // NOTE: summary increments on action logging happen inside
  // ActionLogRepository.logAction's transaction so they can never
  // diverge from the action log; this data source only reads.
}
