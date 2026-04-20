import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';

void main() {
  group('DailySummaryModel', () {
    test('defaults all optional fields to zero/empty', () {
      const m = DailySummaryModel(date: '2026-04-19');

      expect(m.goalCount, 0);
      expect(m.completedSdgs, isEmpty);
      expect(m.totalPoints, 0);
      expect(m.totalCo2Grams, 0);
      expect(m.createdAt, isNull);
      expect(m.updatedAt, isNull);
    });

    test('fromJson decodes all fields including timestamps', () {
      final now = DateTime.utc(2026, 4, 19, 10);
      final m = DailySummaryModel.fromJson({
        'date': '2026-04-19',
        'goalCount': 3,
        'completedSdgs': [3, 11],
        'totalPoints': 45,
        'totalCo2Grams': 1200,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });

      expect(m.date, '2026-04-19');
      expect(m.goalCount, 3);
      expect(m.completedSdgs, [3, 11]);
      expect(m.totalPoints, 45);
      expect(m.totalCo2Grams, 1200);
      expect(m.createdAt!.millisecondsSinceEpoch, now.millisecondsSinceEpoch);
    });

    test('fromJson tolerates missing optional fields', () {
      final m = DailySummaryModel.fromJson({'date': '2026-04-19'});

      expect(m.goalCount, 0);
      expect(m.completedSdgs, isEmpty);
    });

    test('toJson round-trips and the date is preserved', () {
      const m = DailySummaryModel(
        date: '2026-04-19',
        goalCount: 2,
        completedSdgs: [3],
      );

      final round = DailySummaryModel.fromJson(m.toJson());
      expect(round.date, m.date);
      expect(round.goalCount, m.goalCount);
      expect(round.completedSdgs, m.completedSdgs);
    });
  });
}
