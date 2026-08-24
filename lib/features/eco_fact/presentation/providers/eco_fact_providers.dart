import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/challenge.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';

part 'eco_fact_providers.g.dart';

/// Loads and caches all eco-facts from the JSON asset.
///
/// keepAlive: static bundled data; autoDispose would re-parse the
/// 440 KB asset on every screen revisit.
@Riverpod(keepAlive: true)
Future<List<EcoFact>> ecoFacts(Ref ref) => loadEcoFacts();

/// Today's eco-fact based on the day of year.
@riverpod
Future<EcoFact?> todayEcoFact(Ref ref) async {
  final facts = await ref.watch(ecoFactsProvider.future);
  final today = dayOfYear(DateTime.now());
  for (final fact in facts) {
    if (fact.dayOfYear == today) return fact;
  }
  // Defensive: a malformed data edit must not turn the home screen
  // into a StateError.
  return null;
}

/// Whether today's fact has been viewed.
@riverpod
bool isTodayFactViewed(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return false;
  final todayKey = formatDateKey(DateTime.now());
  return user.viewedFactDates.contains(todayKey);
}

/// Whether the eco-fact is locked behind challenge completion.
@riverpod
bool isEcoFactLocked(Ref ref) {
  return !ref.watch(isTodayChallengeCompletedProvider);
}

/// True when the user has an unread, unlocked fact (drives red dot).
@riverpod
bool hasUnreadFact(Ref ref) {
  final viewed = ref.watch(isTodayFactViewedProvider);
  final unlocked = ref.watch(isTodayChallengeCompletedProvider);
  return !viewed && unlocked;
}

/// One mail row in the eco-fact inbox.
class EcoFactInboxItem {
  const EcoFactInboxItem({
    required this.date,
    required this.dateKey,
    required this.fact,
    required this.isRead,
    required this.isLocked,
  });

  final DateTime date;
  final String dateKey;
  final EcoFact fact;
  final bool isRead;
  final bool isLocked;
}

/// Inbox rows, newest first. Contains today's fact (locked or unlocked)
/// plus any previously-viewed facts, matching the "mail already read"
/// metaphor. Future mail types (announcements etc.) can be merged in
/// later.
@riverpod
Future<List<EcoFactInboxItem>> ecoFactInbox(Ref ref) async {
  final user = ref.watch(currentUserProvider).value;
  final facts = await ref.watch(ecoFactsProvider.future);
  final isLockedToday = ref.watch(isEcoFactLockedProvider);

  final factsByDay = {for (final f in facts) f.dayOfYear: f};
  final viewedKeys = user?.viewedFactDates.toSet() ?? const <String>{};
  final unlockedKeys = user?.unlockedFactDates.toSet() ?? const <String>{};

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final todayKey = formatDateKey(today);

  // Union of every dateKey that should surface in the inbox: today
  // always, plus any past date that was unlocked or viewed.
  final allKeys = <String>{todayKey, ...unlockedKeys, ...viewedKeys};
  final items = <EcoFactInboxItem>[];

  for (final key in allKeys) {
    // Date-only ISO strings parse to local midnight.
    final date = DateTime.tryParse(key);
    if (date == null) continue;
    final fact = factsByDay[dayOfYear(date)];
    if (fact == null) continue;

    final isToday = key == todayKey;
    items.add(
      EcoFactInboxItem(
        date: date,
        dateKey: key,
        fact: fact,
        isRead: viewedKeys.contains(key),
        isLocked: isToday && isLockedToday,
      ),
    );
  }

  items.sort((a, b) => b.date.compareTo(a.date));
  return items;
}

/// Notifier to mark an eco-fact as viewed.
@riverpod
class FactViewedNotifier extends _$FactViewedNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Marks today's fact as viewed.
  Future<void> markViewed() => _markDateViewed(formatDateKey(DateTime.now()));

  /// Marks an arbitrary date's fact as viewed. Safe no-op for a date
  /// already in `viewedFactDates`.
  Future<void> markDateViewed(String dateKey) => _markDateViewed(dateKey);

  Future<void> _markDateViewed(String dateKey) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;
    if (user.viewedFactDates.contains(dateKey)) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final firestore = ref.read(firestoreProvider);
      // ponytail: unbounded array on the user doc (~365 entries/year,
      // re-shipped to listeners on every user-doc write). Cap to the
      // last year (derive older reads from a count) if doc size or
      // listener bandwidth ever matters.
      await firestore
          .collection(AppConstants.collectionUsers)
          .doc(user.uid)
          .update({
            AppConstants.fieldViewedFactDates: FieldValue.arrayUnion([dateKey]),
          });
    });

    if (ref.mounted) {
      state = result;
    }
  }
}
