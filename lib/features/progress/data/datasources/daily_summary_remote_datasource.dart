import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_logger.dart';

import '../models/daily_summary_model.dart';

part 'daily_summary_remote_datasource.g.dart';

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
        .where('date', isGreaterThanOrEqualTo: startId)
        .where('date', isLessThanOrEqualTo: endId)
        .get();

    return snapshot.docs
        .map((doc) => DailySummaryModel.fromJson(doc.data()))
        .toList();
  }

  /// Create or update today's daily summary when an action is logged.
  Future<void> incrementDailySummary({
    required String userId,
    required int points,
    required int co2Grams,
    required List<int> sdgNumbers,
  }) async {
    final todayId = _todayDateString();
    final docRef = _summariesCollection(userId).doc(todayId);

    AppLogger.debug('DailySummary: Recording action for $userId on $todayId');
    AppLogger.debug(
        'DailySummary: points=$points, co2=$co2Grams, sdgs=$sdgNumbers');

    try {
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);

        if (!doc.exists) {
          // Create new summary for today
          AppLogger.debug('DailySummary: Creating new summary for today');
          final newSummary = DailySummaryModel(
            date: todayId,
            goalCount: 1,
            completedSdgs: sdgNumbers.toSet().toList(),
            totalPoints: points,
            totalCo2Grams: co2Grams,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          transaction.set(docRef, newSummary.toJson());
        } else {
          // Update existing summary
          AppLogger.debug('DailySummary: Updating existing summary');
          final existing = DailySummaryModel.fromJson(doc.data()!);
          final updatedSdgs =
              {...existing.completedSdgs, ...sdgNumbers}.toList();
          transaction.update(docRef, {
            'goalCount': FieldValue.increment(1),
            'completedSdgs': updatedSdgs,
            'totalPoints': FieldValue.increment(points),
            'totalCo2Grams': FieldValue.increment(co2Grams),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      });
      AppLogger.debug('DailySummary: Transaction completed');
    } catch (e, stack) {
      AppLogger.error(
        'DailySummary transaction failed',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }
}

@riverpod
DailySummaryRemoteDataSource dailySummaryRemoteDataSource(Ref ref) {
  return DailySummaryRemoteDataSource(FirebaseFirestore.instance);
}
