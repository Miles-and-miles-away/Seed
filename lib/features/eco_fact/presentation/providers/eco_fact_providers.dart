import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';

part 'eco_fact_providers.g.dart';

/// Loads and caches all 365 eco-facts from the JSON asset.
@riverpod
Future<List<EcoFact>> ecoFacts(Ref ref) => loadEcoFacts();

/// Today's eco-fact based on the day of year.
@riverpod
Future<EcoFact?> todayEcoFact(Ref ref) async {
  final facts = await ref.watch(ecoFactsProvider.future);
  final today = dayOfYear(DateTime.now());
  return facts.firstWhere((f) => f.dayOfYear == today);
}

/// Whether today's fact has been viewed.
@riverpod
bool isTodayFactViewed(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return false;
  final todayKey = formatDateKey(DateTime.now());
  return user.viewedFactDates.contains(todayKey);
}

/// True when the user has an unread fact (drives red dot).
@riverpod
bool hasUnreadFact(Ref ref) {
  return !ref.watch(isTodayFactViewedProvider);
}

/// Currently selected month for the fact calendar.
@riverpod
class FactCalendarSelectedMonth extends _$FactCalendarSelectedMonth {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void goToPreviousMonth() {
    state = DateTime(state.year, state.month - 1);
  }

  void goToNextMonth() {
    final now = DateTime.now();
    final nextMonth = DateTime(state.year, state.month + 1);
    if (nextMonth.year < now.year ||
        (nextMonth.year == now.year && nextMonth.month <= now.month)) {
      state = nextMonth;
    }
  }

  bool get canGoToNextMonth {
    final now = DateTime.now();
    return state.year < now.year ||
        (state.year == now.year && state.month < now.month);
  }
}

/// Calendar cell data for a single day.
class FactCalendarDay {
  const FactCalendarDay({
    required this.date,
    required this.isViewed,
    required this.isToday,
    required this.isFuture,
    this.fact,
  });

  final DateTime date;
  final bool isViewed;
  final bool isToday;
  final bool isFuture;
  final EcoFact? fact;
}

/// Calendar data for the selected month.
@riverpod
Future<List<FactCalendarDay>> factCalendarData(Ref ref) async {
  final user = ref.watch(currentUserProvider).value;
  final selectedMonth = ref.watch(factCalendarSelectedMonthProvider);
  final facts = await ref.watch(ecoFactsProvider.future);

  final viewedDates = user?.viewedFactDates.toSet() ?? <String>{};
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final daysInMonth = DateTime(
    selectedMonth.year,
    selectedMonth.month + 1,
    0,
  ).day;

  // Build a lookup map by dayOfYear for fast access
  final factsByDay = {for (final f in facts) f.dayOfYear: f};

  final days = <FactCalendarDay>[];
  for (var d = 1; d <= daysInMonth; d++) {
    final date = DateTime(
      selectedMonth.year,
      selectedMonth.month,
      d,
    );
    final dateKey = formatDateKey(date);
    final doy = dayOfYear(date);
    final isFuture = date.isAfter(today);
    final isToday = date.isAtSameMomentAs(today);

    days.add(
      FactCalendarDay(
        date: date,
        isViewed: viewedDates.contains(dateKey),
        isToday: isToday,
        isFuture: isFuture,
        fact: isFuture ? null : factsByDay[doy],
      ),
    );
  }

  return days;
}

/// Notifier to mark today's eco-fact as viewed.
@riverpod
class FactViewedNotifier extends _$FactViewedNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Marks today's fact as viewed in Firestore.
  Future<void> markViewed() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    final todayKey = formatDateKey(DateTime.now());
    if (user.viewedFactDates.contains(todayKey)) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final firestore = ref.read(firestoreProvider);
      await firestore
          .collection(AppConstants.collectionUsers)
          .doc(user.uid)
          .update({
        'viewedFactDates': FieldValue.arrayUnion([todayKey]),
      });
    });

    if (ref.mounted) {
      state = result;
    }
  }
}
