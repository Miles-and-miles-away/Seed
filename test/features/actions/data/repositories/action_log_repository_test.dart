import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/actions/data/datasources/action_log_remote_datasource.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/data/repositories/action_log_repository.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';

const _uid = 'user-1';

const _action = ActionModel(
  id: 'walk',
  nameEn: 'Walk instead of drive',
  nameJa: '歩く',
  category: 'transport',
  points: 20,
  co2Grams: 500,
  relatedSdgs: ['11', '13'],
);

const _actionNoSdgs = ActionModel(
  id: 'learn',
  nameEn: 'Read an article',
  nameJa: '記事を読む',
  category: 'learn',
  points: 0,
  isLearnOnly: true,
);

const _transportDaily = DailyChallengeTemplate(
  id: 'daily-transport',
  category: 'transport',
  titleEn: 'Use clean transport',
  titleEs: '',
  titleJa: '',
);

const _waterDaily = DailyChallengeTemplate(
  id: 'daily-water',
  category: 'water',
  titleEn: 'Save water',
  titleEs: '',
  titleJa: '',
);

const _mdTransport = MultiDayChallengeTemplate(
  id: 'md-transport',
  category: 'transport',
  targetDays: 3,
  titleEn: '3-day transport',
  titleEs: '',
  titleJa: '',
  descriptionEn: '',
  descriptionEs: '',
  descriptionJa: '',
);

const _mdAnyCategory = MultiDayChallengeTemplate(
  id: 'md-any',
  category: null,
  targetDays: 3,
  titleEn: 'Any 3-day',
  titleEs: '',
  titleJa: '',
  descriptionEn: '',
  descriptionEs: '',
  descriptionJa: '',
);

final _species = [
  const MascotSpeciesModel(
    id: 'seed',
    nameEn: 'Seed',
    nameJa: 'シード',
    descriptionEn: '',
    descriptionJa: '',
    evolutionStages: [],
  ),
  const MascotSpeciesModel(
    id: 'leaf',
    nameEn: 'Leaf',
    nameJa: 'リーフ',
    descriptionEn: '',
    descriptionJa: '',
    evolutionStages: [],
  ),
];

void main() {
  late FakeFirebaseFirestore firestore;
  late ActionLogRepository repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = ActionLogRepository(
      dataSource: ActionLogRemoteDataSource(firestore: firestore),
      firestore: firestore,
      dailyChallengeTemplates: const [_transportDaily],
      multiDayChallengeTemplates: const [_mdTransport, _mdAnyCategory],
      mascotSpecies: _species,
    );
  });

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser() =>
      firestore.collection(AppConstants.collectionUsers).doc(_uid).get();

  Future<void> seedUser(Map<String, dynamic> data) async {
    await firestore.collection(AppConstants.collectionUsers).doc(_uid).set({
      'uid': _uid,
      ...data,
    });
  }

  Map<String, dynamic> mascot({
    required String id,
    String speciesId = 'seed',
    int points = 0,
    int level = 1,
    bool isFullyEvolved = false,
  }) => {
    AppConstants.fieldId: id,
    AppConstants.fieldSpeciesId: speciesId,
    AppConstants.fieldName: 'M-$id',
    AppConstants.fieldMascotPoints: points,
    AppConstants.fieldMascotLevel: level,
    AppConstants.fieldIsFullyEvolved: isFullyEvolved,
    'equippedItems': <String>[],
    AppConstants.fieldLastSeenStage: 1,
  };

  group('logAction — core points and level', () {
    test('first action ever creates points and sets streak to 1', () async {
      await seedUser({});

      final result = await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final data = (await getUser()).data()!;
      expect(data[AppConstants.fieldPoints], 20);
      expect(data[AppConstants.fieldLevel], 1);
      expect(data[AppConstants.fieldCurrentStreak], 1);
      expect(data[AppConstants.fieldLongestStreak], 1);
      expect(data[AppConstants.fieldTotalCo2Grams], 500);
      expect(data[AppConstants.fieldTotalActionsCount], 1);
      expect(result.newStreakDays, 1);
      expect(result.crossedMilestoneWeek, isNull);
      expect(result.hatchedMascotId, isNull);
    });

    test('accumulates points from prior value', () async {
      await seedUser({
        AppConstants.fieldPoints: 50,
        AppConstants.fieldTotalActionsCount: 3,
        AppConstants.fieldTotalCo2Grams: 100,
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final data = (await getUser()).data()!;
      expect(data[AppConstants.fieldPoints], 70);
      expect(data[AppConstants.fieldTotalActionsCount], 4);
      expect(data[AppConstants.fieldTotalCo2Grams], 600);
    });

    test('level increments when threshold crossed', () async {
      // pointsPerLevel=100, scale=1.5 → level 2 requires exactly 100 points.
      await seedUser({AppConstants.fieldPoints: 95});

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final data = (await getUser()).data()!;
      expect(data[AppConstants.fieldPoints], 115);
      expect(data[AppConstants.fieldLevel], 2);
    });

    test('zero-point learn-only action still writes log', () async {
      await seedUser({AppConstants.fieldPoints: 50});

      await repository.logAction(
        userId: _uid,
        action: _actionNoSdgs,
        languageCode: 'en',
      );

      final data = (await getUser()).data()!;
      expect(data[AppConstants.fieldPoints], 50);
      expect(data[AppConstants.fieldTotalActionsCount], 1);
      final logs = await firestore
          .collection(AppConstants.collectionUsers)
          .doc(_uid)
          .collection(AppConstants.collectionActionLog)
          .get();
      expect(logs.docs, hasLength(1));
    });
  });

  group('logAction — streak behaviour', () {
    test('same-day action does not increment streak', () async {
      final now = DateTime.now();
      await seedUser({
        AppConstants.fieldLastActionDate: Timestamp.fromDate(now),
        AppConstants.fieldCurrentStreak: 5,
        AppConstants.fieldLongestStreak: 5,
      });

      final result = await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      expect((await getUser()).data()![AppConstants.fieldCurrentStreak], 5);
      expect(result.newStreakDays, 5);
    });

    test('consecutive day increments streak', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await seedUser({
        AppConstants.fieldLastActionDate: Timestamp.fromDate(yesterday),
        AppConstants.fieldCurrentStreak: 5,
        AppConstants.fieldLongestStreak: 5,
      });

      final result = await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final data = (await getUser()).data()!;
      expect(data[AppConstants.fieldCurrentStreak], 6);
      expect(data[AppConstants.fieldLongestStreak], 6);
      expect(result.newStreakDays, 6);
    });

    test('crossing week-one milestone surfaces in result', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await seedUser({
        AppConstants.fieldLastActionDate: Timestamp.fromDate(yesterday),
        AppConstants.fieldCurrentStreak: 6,
        AppConstants.fieldLongestStreak: 6,
      });

      final result = await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      expect(result.newStreakDays, 7);
      expect(result.crossedMilestoneWeek, 1);
      expect(result.shouldShowMilestone, isTrue);
    });

    test('gap day resets streak to 1', () async {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      await seedUser({
        AppConstants.fieldLastActionDate: Timestamp.fromDate(threeDaysAgo),
        AppConstants.fieldCurrentStreak: 10,
        AppConstants.fieldLongestStreak: 10,
      });

      final result = await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final data = (await getUser()).data()!;
      expect(data[AppConstants.fieldCurrentStreak], 1);
      // Longest preserved through reset
      expect(data[AppConstants.fieldLongestStreak], 10);
      expect(result.newStreakDays, 1);
    });
  });

  group('logAction — aggregate counters', () {
    test('per-SDG counters accumulate for all related SDGs', () async {
      await seedUser({
        AppConstants.fieldSdgStats: {
          '11': {AppConstants.fieldCount: 2, AppConstants.fieldCo2: 100},
        },
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final stats =
          (await getUser()).data()![AppConstants.fieldSdgStats]
              as Map<String, dynamic>;
      expect(stats['11'], {
        AppConstants.fieldCount: 3,
        AppConstants.fieldCo2: 600,
      });
      expect(stats['13'], {
        AppConstants.fieldCount: 1,
        AppConstants.fieldCo2: 500,
      });
    });

    test('per-category counts and unique action IDs update', () async {
      await seedUser({
        AppConstants.fieldCategoryActionCounts: {'transport': 2, 'water': 5},
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final data = (await getUser()).data()!;
      final counts =
          data[AppConstants.fieldCategoryActionCounts] as Map<String, dynamic>;
      expect(counts['transport'], 3);
      expect(counts['water'], 5);
      final uniques = data[AppConstants.fieldUniqueActionIds] as List<dynamic>;
      expect(uniques, contains('walk'));
    });

    test('action with no related SDGs leaves sdgStats untouched', () async {
      await seedUser({
        AppConstants.fieldSdgStats: {
          '11': {AppConstants.fieldCount: 2, AppConstants.fieldCo2: 100},
        },
      });

      await repository.logAction(
        userId: _uid,
        action: _actionNoSdgs,
        languageCode: 'en',
      );

      final stats =
          (await getUser()).data()![AppConstants.fieldSdgStats]
              as Map<String, dynamic>;
      expect(stats, hasLength(1));
      expect(stats['11'], {
        AppConstants.fieldCount: 2,
        AppConstants.fieldCo2: 100,
      });
    });
  });

  group('logAction — mascot leveling', () {
    test('no active mascot means no mascot mutation', () async {
      await seedUser({});

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      expect(
        (await getUser()).data()!.containsKey(AppConstants.fieldMascots),
        isFalse,
      );
    });

    test('active mascot accumulates points and level', () async {
      await seedUser({
        AppConstants.fieldActiveMascotId: 'm1',
        AppConstants.fieldMascots: [mascot(id: 'm1', points: 90)],
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final mascots =
          (await getUser()).data()![AppConstants.fieldMascots] as List<dynamic>;
      final updated = mascots.first as Map<String, dynamic>;
      expect(updated[AppConstants.fieldMascotPoints], 110);
      expect(updated[AppConstants.fieldMascotLevel], 2);
      expect(updated[AppConstants.fieldIsFullyEvolved], isFalse);
    });

    test('already fully-evolved mascot is not updated', () async {
      await seedUser({
        AppConstants.fieldActiveMascotId: 'm1',
        AppConstants.fieldMascots: [
          mascot(id: 'm1', points: 9999, level: 50, isFullyEvolved: true),
        ],
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final mascots =
          (await getUser()).data()![AppConstants.fieldMascots] as List<dynamic>;
      final updated = mascots.first as Map<String, dynamic>;
      expect(updated[AppConstants.fieldMascotPoints], 9999);
      expect(updated[AppConstants.fieldIsFullyEvolved], isTrue);
    });

    test('crossing to fully evolved triggers egg pending discovery', () async {
      // Seed just below the level-50 threshold to avoid large arithmetic here.
      final pointsForLevel50 = calculatePointsForLevel(50);
      await seedUser({
        AppConstants.fieldActiveMascotId: 'm1',
        AppConstants.fieldMascots: [
          mascot(id: 'm1', points: pointsForLevel50 - 1, level: 49),
        ],
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final data = (await getUser()).data()!;
      final m =
          (data[AppConstants.fieldMascots] as List).first
              as Map<String, dynamic>;
      expect(m[AppConstants.fieldIsFullyEvolved], isTrue);
      expect(data[AppConstants.fieldEggPendingDiscovery], isTrue);
      expect(
        data[AppConstants.fieldEggPendingDiscoverySince],
        isA<Timestamp>(),
      );
    });

    test('does not reset pending discovery when already flagged', () async {
      final alreadySince = Timestamp.fromDate(
        DateTime.now().subtract(const Duration(days: 2)),
      );
      await seedUser({
        AppConstants.fieldActiveMascotId: 'm1',
        AppConstants.fieldMascots: [mascot(id: 'm1', points: 50)],
        AppConstants.fieldEggPendingDiscovery: true,
        AppConstants.fieldEggPendingDiscoverySince: alreadySince,
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final data = (await getUser()).data()!;
      expect(data[AppConstants.fieldEggPendingDiscovery], isTrue);
      expect(data[AppConstants.fieldEggPendingDiscoverySince], alreadySince);
    });
  });

  group('logAction — egg hatching', () {
    test('egg streak increments on consecutive day', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await seedUser({
        AppConstants.fieldEgg: {
          'receivedAt': Timestamp.fromDate(yesterday),
          AppConstants.fieldHatchingStreakDays: 5,
          AppConstants.fieldLastHatchingActivityDate: Timestamp.fromDate(
            yesterday,
          ),
        },
      });

      final result = await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final egg =
          (await getUser()).data()![AppConstants.fieldEgg]
              as Map<String, dynamic>;
      expect(egg[AppConstants.fieldHatchingStreakDays], 6);
      expect(result.hatchedMascotId, isNull);
    });

    test('egg hatches at 30-day streak and adds mascot', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final existingMascot = mascot(id: 'm1', isFullyEvolved: true);
      await seedUser({
        AppConstants.fieldActiveMascotId: 'm1',
        AppConstants.fieldMascots: [existingMascot],
        AppConstants.fieldEgg: {
          'receivedAt': Timestamp.fromDate(yesterday),
          AppConstants.fieldHatchingStreakDays: 29,
          AppConstants.fieldLastHatchingActivityDate: Timestamp.fromDate(
            yesterday,
          ),
        },
      });

      final result = await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      expect(result.hatchedMascotId, isNotNull);
      expect(result.didHatchEgg, isTrue);
      final data = (await getUser()).data()!;
      expect(data.containsKey(AppConstants.fieldEgg), isFalse);
      final mascots = data[AppConstants.fieldMascots] as List<dynamic>;
      expect(mascots, hasLength(2));
    });

    test('hatched species prefers one not already fully evolved', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      // Seed user with species 'seed' already fully evolved.
      // Only 'leaf' should remain as a valid hatching candidate.
      await seedUser({
        AppConstants.fieldActiveMascotId: 'm1',
        AppConstants.fieldMascots: [mascot(id: 'm1', isFullyEvolved: true)],
        AppConstants.fieldEgg: {
          'receivedAt': Timestamp.fromDate(yesterday),
          AppConstants.fieldHatchingStreakDays: 29,
          AppConstants.fieldLastHatchingActivityDate: Timestamp.fromDate(
            yesterday,
          ),
        },
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final mascots =
          (await getUser()).data()![AppConstants.fieldMascots] as List<dynamic>;
      final newMascot = mascots.last as Map<String, dynamic>;
      expect(newMascot[AppConstants.fieldSpeciesId], 'leaf');
    });
  });

  group('logAction — daily challenge', () {
    test('marks challenge completed when category matches', () async {
      await seedUser({});

      final result = await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final data = (await getUser()).data()!;
      expect(result.challengeCompleted, isTrue);
      expect(
        data[AppConstants.fieldChallengeCompletedDate],
        formatDateKey(DateTime.now()),
      );
      expect(data[AppConstants.fieldChallengeStreak], 1);
      expect(data[AppConstants.fieldChallengesCompleted], 1);
      expect(
        data[AppConstants.fieldUnlockedFactDates],
        contains(formatDateKey(DateTime.now())),
      );
    });

    test('category mismatch leaves challenge untouched', () async {
      final repoWaterOnly = ActionLogRepository(
        dataSource: ActionLogRemoteDataSource(firestore: firestore),
        firestore: firestore,
        dailyChallengeTemplates: const [_waterDaily],
        multiDayChallengeTemplates: const [],
        mascotSpecies: _species,
      );
      await seedUser({});

      final result = await repoWaterOnly.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      expect(result.challengeCompleted, isFalse);
      final data = (await getUser()).data()!;
      expect(
        data.containsKey(AppConstants.fieldChallengeCompletedDate),
        isFalse,
      );
    });

    test('does not re-complete once marked for today', () async {
      final todayKey = formatDateKey(DateTime.now());
      await seedUser({
        AppConstants.fieldChallengeCompletedDate: todayKey,
        AppConstants.fieldChallengeStreak: 3,
        AppConstants.fieldChallengesCompleted: 10,
      });

      final result = await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      expect(result.challengeCompleted, isFalse);
      final data = (await getUser()).data()!;
      expect(data[AppConstants.fieldChallengeStreak], 3);
      expect(data[AppConstants.fieldChallengesCompleted], 10);
    });

    test('yesterday completion continues the challenge streak', () async {
      final yesterdayKey = formatDateKey(
        DateTime.now().subtract(const Duration(days: 1)),
      );
      await seedUser({
        AppConstants.fieldChallengeCompletedDate: yesterdayKey,
        AppConstants.fieldChallengeStreak: 3,
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      expect((await getUser()).data()![AppConstants.fieldChallengeStreak], 4);
    });

    test('gap in completion resets streak to 1', () async {
      final twoDaysAgoKey = formatDateKey(
        DateTime.now().subtract(const Duration(days: 2)),
      );
      await seedUser({
        AppConstants.fieldChallengeCompletedDate: twoDaysAgoKey,
        AppConstants.fieldChallengeStreak: 10,
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      expect((await getUser()).data()![AppConstants.fieldChallengeStreak], 1);
    });

    test('recent challenge IDs are capped', () async {
      final existing = List<String>.generate(
        AppConstants.recentChallengeIdsLimit,
        (i) => 'old-$i',
      );
      await seedUser({AppConstants.fieldRecentChallengeIds: existing});

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final ids =
          (await getUser()).data()![AppConstants.fieldRecentChallengeIds]
              as List<dynamic>;
      expect(ids, hasLength(AppConstants.recentChallengeIdsLimit));
      expect(ids.first, 'daily-transport');
    });
  });

  group('logAction — multi-day challenge', () {
    Map<String, dynamic> activeMultiDay({
      String templateId = 'md-transport',
      int currentDay = 0,
      int target = 3,
      String lastDate = '',
    }) => {
      AppConstants.fieldTemplateId: templateId,
      AppConstants.fieldCurrentDay: currentDay,
      AppConstants.fieldTargetDays: target,
      AppConstants.fieldLastCompletionDate: lastDate,
      AppConstants.fieldStartDate: formatDateKey(DateTime.now()),
    };

    test('increments currentDay when matching category on new day', () async {
      await seedUser({
        AppConstants.fieldActiveMultiDayChallenge: activeMultiDay(),
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final md =
          (await getUser()).data()![AppConstants.fieldActiveMultiDayChallenge]
              as Map<String, dynamic>;
      expect(md[AppConstants.fieldCurrentDay], 1);
      expect(
        md[AppConstants.fieldLastCompletionDate],
        formatDateKey(DateTime.now()),
      );
    });

    test('completes and clears challenge at target days', () async {
      final yesterdayKey = formatDateKey(
        DateTime.now().subtract(const Duration(days: 1)),
      );
      await seedUser({
        AppConstants.fieldActiveMultiDayChallenge: activeMultiDay(
          currentDay: 2,
          lastDate: yesterdayKey,
        ),
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final data = (await getUser()).data()!;
      // Completion is proven by the ID landing in the completed list;
      // fake_cloud_firestore preserves the pre-existing map fields even
      // when production code assigns an empty map, so assert on the
      // side-effect instead of emptiness.
      expect(
        data[AppConstants.fieldCompletedMultiDayChallenges],
        contains('md-transport'),
      );
    });

    test('gap day resets currentDay to 1', () async {
      final threeDaysAgoKey = formatDateKey(
        DateTime.now().subtract(const Duration(days: 3)),
      );
      await seedUser({
        AppConstants.fieldActiveMultiDayChallenge: activeMultiDay(
          currentDay: 2,
          lastDate: threeDaysAgoKey,
        ),
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final md =
          (await getUser()).data()![AppConstants.fieldActiveMultiDayChallenge]
              as Map<String, dynamic>;
      expect(md[AppConstants.fieldCurrentDay], 1);
    });

    test('same-day action does not double-count', () async {
      final todayKey = formatDateKey(DateTime.now());
      await seedUser({
        AppConstants.fieldActiveMultiDayChallenge: activeMultiDay(
          currentDay: 1,
          lastDate: todayKey,
        ),
      });

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final md =
          (await getUser()).data()![AppConstants.fieldActiveMultiDayChallenge]
              as Map<String, dynamic>;
      expect(md[AppConstants.fieldCurrentDay], 1);
    });

    test('category-less multi-day challenge counts any action', () async {
      await seedUser({
        AppConstants.fieldActiveMultiDayChallenge: activeMultiDay(
          templateId: 'md-any',
        ),
      });

      // Use learn-only (different category) to prove the null-category path.
      await repository.logAction(
        userId: _uid,
        action: _actionNoSdgs,
        languageCode: 'en',
      );

      final md =
          (await getUser()).data()![AppConstants.fieldActiveMultiDayChallenge]
              as Map<String, dynamic>;
      expect(md[AppConstants.fieldCurrentDay], 1);
    });
  });

  group('logAction — persistence of action log', () {
    test('writes log document with correct fields', () async {
      await seedUser({});

      final result = await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
        note: 'Felt great',
      );

      final logs = await firestore
          .collection(AppConstants.collectionUsers)
          .doc(_uid)
          .collection(AppConstants.collectionActionLog)
          .get();
      expect(logs.docs, hasLength(1));
      final data = logs.docs.first.data();
      expect(data['actionId'], 'walk');
      expect(data['actionName'], 'Walk instead of drive');
      expect(data['category'], 'transport');
      expect(data['points'], 20);
      expect(data['co2Grams'], 500);
      expect(data['note'], 'Felt great');
      expect(data['relatedSdgs'], ['11', '13']);
      expect(result.actionLog.id, isNotEmpty);
    });

    test('localizes action name using language code', () async {
      await seedUser({});

      final result = await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'ja',
      );

      expect(result.actionLog.actionName, '歩く');
    });
  });

  group('watchUserActionLogs', () {
    test('watchUserActionLogs delegates to data source', () async {
      await seedUser({});
      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final stream = repository.watchUserActionLogs(_uid, limit: 50);

      await expectLater(
        stream,
        emits(predicate<List<Object?>>((list) => list.length == 1)),
      );
    });
  });

  group('logAction — daily summary', () {
    // Written inside the same transaction as the action log so the
    // Progress tab can never diverge from the log history.
    Future<Map<String, dynamic>> getSummary() async {
      final doc = await firestore
          .collection(AppConstants.collectionUsers)
          .doc(_uid)
          .collection(AppConstants.collectionDailySummaries)
          .doc(formatDateKey(DateTime.now()))
          .get();
      expect(doc.exists, isTrue);
      return doc.data()!;
    }

    test('creates today summary on first log', () async {
      await seedUser({});

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final data = await getSummary();
      expect(data[AppConstants.fieldDate], formatDateKey(DateTime.now()));
      expect(data[AppConstants.fieldGoalCount], 1);
      expect(data[AppConstants.fieldTotalPoints], 20);
      expect(data[AppConstants.fieldTotalCo2Grams], 500);
      expect(data[AppConstants.fieldCompletedSdgs], containsAll([11, 13]));
      expect(data[AppConstants.fieldCategoryCo2Grams], {'transport': 500});
    });

    test('increments existing summary and dedups SDGs', () async {
      await seedUser({});

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );
      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      final data = await getSummary();
      expect(data[AppConstants.fieldGoalCount], 2);
      expect(data[AppConstants.fieldTotalPoints], 40);
      expect(data[AppConstants.fieldTotalCo2Grams], 1000);
      final sdgs = data[AppConstants.fieldCompletedSdgs] as List<dynamic>;
      expect(sdgs.toSet().length, sdgs.length);
      expect(sdgs, containsAll([11, 13]));
      expect(data[AppConstants.fieldCategoryCo2Grams], {'transport': 1000});
    });

    test('tracks distinct categories independently', () async {
      await seedUser({});

      await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );
      await repository.logAction(
        userId: _uid,
        action: _actionNoSdgs,
        languageCode: 'en',
      );

      final data = await getSummary();
      final categoryCo2 =
          data[AppConstants.fieldCategoryCo2Grams] as Map<String, dynamic>;
      expect(categoryCo2['transport'], 500);
      expect(categoryCo2['learn'], 0);
      expect(data[AppConstants.fieldTotalCo2Grams], 500);
    });
  });

  group('logAction — resilience', () {
    test('tolerates a stale multi-day challenge template', () async {
      // A template removed in an app update must not brick logging
      // (firstWhere with no orElse used to throw and fail the whole
      // transaction). fake_cloud_firestore merges map updates, so the
      // {} clear itself is not observable here; assert that the log
      // succeeds and no challenge progress/completion was recorded.
      await seedUser({
        AppConstants.fieldActiveMultiDayChallenge: {
          AppConstants.fieldTemplateId: 'removed-template',
          AppConstants.fieldCurrentDay: 2,
          AppConstants.fieldTargetDays: 5,
          AppConstants.fieldLastCompletionDate: '',
        },
      });

      final result = await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      expect(result.actionLog.points, 20);
      final data = (await getUser()).data()!;
      expect(data[AppConstants.fieldPoints], 20);
      final md =
          data[AppConstants.fieldActiveMultiDayChallenge]
              as Map<String, dynamic>;
      expect(md[AppConstants.fieldCurrentDay], 2);
      expect(data[AppConstants.fieldCompletedMultiDayChallenges], isNull);
    });

    test('disposes egg instead of hatching at the mascot cap', () async {
      // Hatching a 21st mascot would violate the security rules'
      // cap and reject every future log.
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      await seedUser({
        AppConstants.fieldActiveMascotId: 'm0',
        AppConstants.fieldMascots: List.generate(
          AppConstants.maxMascotsPerUser,
          (i) => mascot(id: 'm$i', isFullyEvolved: true),
        ),
        AppConstants.fieldEgg: {
          'receivedAt': Timestamp.fromDate(yesterday),
          AppConstants.fieldHatchingStreakDays: 29,
          AppConstants.fieldLastHatchingActivityDate: Timestamp.fromDate(
            yesterday,
          ),
        },
      });

      final result = await repository.logAction(
        userId: _uid,
        action: _action,
        languageCode: 'en',
      );

      expect(result.hatchedMascotId, isNull);
      final data = (await getUser()).data()!;
      expect(data.containsKey(AppConstants.fieldEgg), isFalse);
      expect(
        data[AppConstants.fieldMascots] as List<dynamic>,
        hasLength(AppConstants.maxMascotsPerUser),
      );
    });
  });
}
