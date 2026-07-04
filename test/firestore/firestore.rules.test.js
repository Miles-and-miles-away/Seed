// Security-rules tests for firestore.rules, run against the Firestore
// emulator. Launch with `npm run test:rules` from the repo root, which
// boots the emulator via `firebase emulators:exec` and then runs Jest.
//
// These cover what neither the Dart fakes (fake_cloud_firestore ignores
// rules) nor the functions mocks can verify: the rules artifact itself.

const fs = require('fs');
const path = require('path');
const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require('@firebase/rules-unit-testing');
const {
  doc,
  setDoc,
  getDoc,
  updateDoc,
  deleteDoc,
  deleteField,
  writeBatch,
  serverTimestamp,
  increment,
  Timestamp,
} = require('firebase/firestore');

const PROJECT_ID = 'demo-seed';
const RULES_PATH = path.resolve(__dirname, '../../firestore.rules');

const ALICE = 'alice';
const BOB = 'bob';

let testEnv;

// A minimal valid user document. Individual tests spread overrides on top.
const baseUserDoc = {email: 'alice@example.com', points: 0, level: 1};

function aliceDb() {
  return testEnv.authenticatedContext(ALICE).firestore();
}

function bobDb() {
  return testEnv.authenticatedContext(BOB).firestore();
}

function anonDb() {
  return testEnv.unauthenticatedContext().firestore();
}

// Email/password account context; gameplay writes require
// email_verified for the password provider.
function alicePasswordDb(emailVerified) {
  return testEnv
    .authenticatedContext(ALICE, {
      email_verified: emailVerified,
      firebase: {sign_in_provider: 'password'},
    })
    .firestore();
}

// Seed data bypassing rules (admin-equivalent), e.g. read-only collections
// and cross-document references the rules depend on.
async function seed(docPath, data) {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), docPath), data);
  });
}

function secondsAgo(seconds) {
  return Timestamp.fromMillis(Timestamp.now().toMillis() - seconds * 1000);
}

beforeAll(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: {
      rules: fs.readFileSync(RULES_PATH, 'utf8'),
      host: '127.0.0.1',
      port: 8080,
    },
  });
});

afterAll(async () => {
  await testEnv.cleanup();
});

beforeEach(async () => {
  await testEnv.clearFirestore();
});

describe('users/{userId} read', () => {
  test('owner can read their own document', async () => {
    await seed(`users/${ALICE}`, baseUserDoc);
    await assertSucceeds(getDoc(doc(aliceDb(), `users/${ALICE}`)));
  });

  test('another user cannot read it', async () => {
    await seed(`users/${ALICE}`, baseUserDoc);
    await assertFails(getDoc(doc(bobDb(), `users/${ALICE}`)));
  });

  test('an unauthenticated client cannot read it', async () => {
    await seed(`users/${ALICE}`, baseUserDoc);
    await assertFails(getDoc(doc(anonDb(), `users/${ALICE}`)));
  });
});

describe('users/{userId} create', () => {
  test('owner can create their own document with zeroed state', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), `users/${ALICE}`), baseUserDoc),
    );
  });

  test('a user cannot create another user document', async () => {
    await assertFails(
      setDoc(doc(bobDb(), `users/${ALICE}`), baseUserDoc),
    );
  });

  test('an unauthenticated client cannot create one', async () => {
    await assertFails(
      setDoc(doc(anonDb(), `users/${ALICE}`), baseUserDoc),
    );
  });

  test('rejects creating with pre-loaded points', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        points: 500,
      }),
    );
  });

  test('rejects creating with a pre-loaded streak', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        currentStreak: 30,
      }),
    );
  });

  test('rejects creating with lastActionDate already set', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        lastActionDate: Timestamp.now(),
      }),
    );
  });

  test('allows a null lastActionDate (model default)', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        lastActionDate: null,
      }),
    );
  });

  test('allows an empty email (hidden by social provider)', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        email: '',
      }),
    );
  });

  test('rejects fields outside the whitelist', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        adminFlag: true,
      }),
    );
  });
});

describe('users/{userId} write — mascots limit', () => {
  const mascot = {id: 'm', speciesId: 's', name: 'M', mascotLevel: 1};

  test('allows up to 20 mascots', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        mascots: Array.from({length: 20}, () => mascot),
      }),
    );
  });

  test('rejects more than 20 mascots', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        mascots: Array.from({length: 21}, () => mascot),
      }),
    );
  });
});

describe('users/{userId} write — language enum', () => {
  for (const language of ['en', 'es', 'ja']) {
    test(`allows supported language "${language}"`, async () => {
      await assertSucceeds(
        setDoc(doc(aliceDb(), `users/${ALICE}`), {
          ...baseUserDoc,
          language,
        }),
      );
    });
  }

  test('rejects an unsupported language', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        language: 'fr',
      }),
    );
  });
});

describe('users/{userId} write — displayName validation', () => {
  test('allows null', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        displayName: null,
      }),
    );
  });

  test('allows a normal name', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        displayName: 'EcoMiles',
      }),
    );
  });

  test('allows a 50-character name (boundary)', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        displayName: 'x'.repeat(50),
      }),
    );
  });

  test('rejects a 51-character name', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        displayName: 'x'.repeat(51),
      }),
    );
  });

  test('rejects an empty string', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        displayName: '',
      }),
    );
  });

  test('rejects a non-string value', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        displayName: 42,
      }),
    );
  });
});

describe('users/{userId} write — personalGoal validation', () => {
  test('allows null', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        personalGoal: null,
      }),
    );
  });

  test('allows a preset id', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        personalGoal: 'save_world',
      }),
    );
  });

  test('allows a 100-character custom goal (boundary)', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        personalGoal: 'x'.repeat(100),
      }),
    );
  });

  test('rejects a 101-character custom goal', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        personalGoal: 'x'.repeat(101),
      }),
    );
  });

  test('rejects an empty string', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        personalGoal: '',
      }),
    );
  });

  test('rejects a non-string value', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {
        ...baseUserDoc,
        personalGoal: ['save_world'],
      }),
    );
  });
});

describe('users/{userId} update — score integrity', () => {
  // Scoring runs client-side; the rules enforce types, monotonicity,
  // bounded jumps, and that any points increase arrives in an
  // action-log shaped write (lastActionDate bumped to the server time,
  // exactly one new action counted).

  test('rejects non-integer points', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {...baseUserDoc, points: 1.5}),
    );
  });

  test('rejects negative points', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {...baseUserDoc, points: -10}),
    );
  });

  test('rejects a level below 1', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {...baseUserDoc, level: 0}),
    );
  });

  test('allows an action-shaped points increase', async () => {
    await seed(`users/${ALICE}`, {
      ...baseUserDoc,
      points: 100,
      totalActionsCount: 3,
      lastActionDate: secondsAgo(10),
    });
    await assertSucceeds(
      updateDoc(doc(aliceDb(), `users/${ALICE}`), {
        points: 150,
        totalActionsCount: increment(1),
        lastActionDate: serverTimestamp(),
      }),
    );
  });

  test('rejects a bare points increase (no action-log shape)', async () => {
    await seed(`users/${ALICE}`, {...baseUserDoc, points: 100});
    await assertFails(
      updateDoc(doc(aliceDb(), `users/${ALICE}`), {points: 150}),
    );
  });

  test('rejects a points jump above 10000 even when action-shaped',
    async () => {
      await seed(`users/${ALICE}`, {
        ...baseUserDoc,
        points: 100,
        totalActionsCount: 3,
        lastActionDate: secondsAgo(10),
      });
      await assertFails(
        updateDoc(doc(aliceDb(), `users/${ALICE}`), {
          points: 100 + 10001,
          totalActionsCount: increment(1),
          lastActionDate: serverTimestamp(),
        }),
      );
    });

  test('rejects points decreasing (reset/tamper)', async () => {
    await seed(`users/${ALICE}`, {...baseUserDoc, points: 100});
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {...baseUserDoc, points: 50}),
    );
  });

  test('rejects removing the points field (reset-by-delete)', async () => {
    await seed(`users/${ALICE}`, {...baseUserDoc, points: 100});
    await assertFails(
      updateDoc(doc(aliceDb(), `users/${ALICE}`), {points: deleteField()}),
    );
  });

  test('rejects level decreasing', async () => {
    await seed(`users/${ALICE}`, {...baseUserDoc, level: 5});
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {...baseUserDoc, level: 2}),
    );
  });

  test('rejects totalCo2Grams decreasing', async () => {
    await seed(`users/${ALICE}`, {...baseUserDoc, totalCo2Grams: 5000});
    await assertFails(
      updateDoc(doc(aliceDb(), `users/${ALICE}`), {totalCo2Grams: 100}),
    );
  });

  test('rejects backdating lastActionDate', async () => {
    await seed(`users/${ALICE}`, {
      ...baseUserDoc,
      lastActionDate: secondsAgo(10),
    });
    await assertFails(
      updateDoc(doc(aliceDb(), `users/${ALICE}`), {
        lastActionDate: secondsAgo(3600),
      }),
    );
  });

  test('allows unrelated settings updates without gameplay fields',
    async () => {
      await seed(`users/${ALICE}`, {
        ...baseUserDoc,
        points: 100,
        lastActionDate: secondsAgo(1),
      });
      await assertSucceeds(
        updateDoc(doc(aliceDb(), `users/${ALICE}`), {
          'settings.analyticsEnabled': false,
        }),
      );
    });

  test('owner cannot delete their user document (server-side only)',
    async () => {
      await seed(`users/${ALICE}`, baseUserDoc);
      await assertFails(deleteDoc(doc(aliceDb(), `users/${ALICE}`)));
    });
});

describe('users/{userId} update — large established document', () => {
  // Regression: update validation must check only the diff, not the whole
  // merged document. Re-validating every field on a fully-populated doc
  // blows Firestore's 1000-expression cap and denies ALL writes once a
  // user has accumulated enough data -- which silently locked out every
  // established user when the field whitelist was first hardened.
  // A doc with every whitelisted field present, sized like real usage.
  const establishedUserDoc = {
    email: 'alice@example.com',
    displayName: 'Alice',
    photoUrl: null,
    personalGoal: 'inspire_others',
    points: 820,
    level: 5,
    currentStreak: 1,
    longestStreak: 2,
    language: 'en',
    notificationTime: '09:00',
    createdAt: Timestamp.now(),
    emailVerified: true,
    dailyGoalTarget: 3,
    mascots: [{
      id: 'm1', speciesId: 'seed', mascotPoints: 170, mascotLevel: 2,
      isFullyEvolved: false, co2SavedGrams: 0, lastSeenStage: 1,
      name: 'Pip', equippedItems: [], createdAt: Timestamp.now(),
    }],
    activeMascotId: 'm1',
    egg: null,
    eggPendingDiscovery: false,
    notificationsEnabled: true,
    lastActionDate: secondsAgo(10),
    streakGracePeriodAvailable: true,
    fcmToken: 'fcm-token',
    totalCo2Grams: 8455,
    totalActionsCount: 14,
    sdgStats: {
      1: {co2: 0, count: 2}, 2: {co2: 0, count: 2}, 3: {co2: 490, count: 1},
      6: {co2: 615, count: 2}, 7: {co2: 2375, count: 3}, 8: {co2: 0, count: 2},
      10: {co2: 0, count: 2}, 11: {co2: 865, count: 2}, 12: {co2: 7575, count: 9},
      13: {co2: 5340, count: 8}, 14: {co2: 100, count: 2}, 15: {co2: 0, count: 1},
      16: {co2: 0, count: 1},
    },
    viewedFactDates: ['2026-04-15', '2026-04-19', '2026-06-05'],
    unlockedFactDates: ['2026-04-19', '2026-06-05'],
    challengeCompletedDate: '2026-06-05',
    challengeStreak: 1,
    challengesCompleted: 3,
    recentChallengeIds: ['water_3', 'transport_3', 'recycling_1'],
    activeMultiDayChallenge: {},
    completedMultiDayChallenges: [],
    ecodexDiscovered: [
      'climate_01', 'climate_02', 'bio_01', 'bio_02', 'bio_03', 'bio_04',
      'bio_08', 'people_01', 'people_03', 'people_05', 'people_08',
      'selfless_01', 'gem_02', 'gem_03', 'energy_04', 'bio_06', 'journey_13',
    ],
    uniqueActionIds: [
      'recycle_aluminum_can', 'buy_fair_trade', 'escooter_trip',
      'collect_rainwater', 'cold_wash', 'borrow_instead_buy',
      'attend_climate_event', 'beach_cleanup',
    ],
    categoryActionCounts: {
      advocacy: 1, community: 1, consumption: 3, energy: 1, recycling: 1,
      transport: 1, water: 1,
    },
    settings: {language: 'en'},
    lastStreakReminderDate: '2026-06-05',
  };

  test('allows an action-shaped scoring update on a full-sized doc',
    async () => {
      await seed(`users/${ALICE}`, establishedUserDoc);
      await assertSucceeds(
        updateDoc(doc(aliceDb(), `users/${ALICE}`), {
          points: 838,
          level: 6,
          currentStreak: 1,
          totalCo2Grams: 8455,
          totalActionsCount: increment(1),
          lastActionDate: serverTimestamp(),
          sdgStats: {...establishedUserDoc.sdgStats, 13: {co2: 5340, count: 9}},
          categoryActionCounts: {
            ...establishedUserDoc.categoryActionCounts, advocacy: 2,
          },
          mascots: establishedUserDoc.mascots,
        }),
      );
    });

  test('still rejects a junk field on a full-sized doc', async () => {
    await seed(`users/${ALICE}`, establishedUserDoc);
    await assertFails(
      updateDoc(doc(aliceDb(), `users/${ALICE}`), {
        points: 838,
        totalActionsCount: increment(1),
        lastActionDate: serverTimestamp(),
        hackerField: 'x',
      }),
    );
  });
});

describe('users/{userId}/actionLog/{logId}', () => {
  const ACTION_ID = 'recycle';
  const logPath = `users/${ALICE}/actionLog/log1`;

  // The create rule requires points AND co2Grams to equal the library
  // definition, and the log to arrive in the same transaction/batch as
  // the matching user-doc update.
  const validLog = {
    actionId: ACTION_ID,
    actionName: 'Recycle',
    category: 'waste',
    points: 10,
    co2Grams: 500,
    loggedAt: Timestamp.now(),
  };

  // Commits an actionLog create coupled with the user-doc update the
  // rules demand, mirroring the client's logAction transaction.
  function logActionBatch(db, logOverrides = {}, userOverrides = {}) {
    const batch = writeBatch(db);
    batch.set(doc(db, logPath), {...validLog, ...logOverrides});
    batch.update(doc(db, `users/${ALICE}`), {
      lastActionDate: serverTimestamp(),
      totalActionsCount: increment(1),
      ...userOverrides,
    });
    return batch.commit();
  }

  beforeEach(async () => {
    await seed(`actionLibrary/${ACTION_ID}`, {points: 10, co2Grams: 500});
    await seed(`users/${ALICE}`, baseUserDoc);
  });

  test('owner can create a well-formed coupled entry', async () => {
    await assertSucceeds(logActionBatch(aliceDb()));
  });

  test('the full client transaction shape (log + user + summary) passes',
    async () => {
      // Mirrors ActionLogRepository.logAction, which writes the daily
      // summary in the same transaction as the log and user update.
      const db = aliceDb();
      const today = new Date().toISOString().slice(0, 10);
      const batch = writeBatch(db);
      batch.set(doc(db, logPath), validLog);
      batch.update(doc(db, `users/${ALICE}`), {
        lastActionDate: serverTimestamp(),
        totalActionsCount: increment(1),
        points: 10,
        totalCo2Grams: 500,
      });
      batch.set(doc(db, `users/${ALICE}/dailySummaries/${today}`), {
        date: today,
        goalCount: 1,
        completedSdgs: [12],
        totalPoints: 10,
        totalCo2Grams: 500,
        categoryCo2Grams: {waste: 500},
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      });
      await assertSucceeds(batch.commit());
    });

  test('rejects a standalone create (no user-doc update)', async () => {
    await assertFails(setDoc(doc(aliceDb(), logPath), validLog));
  });

  test('rejects a create that does not count the action', async () => {
    const db = aliceDb();
    const batch = writeBatch(db);
    batch.set(doc(db, logPath), validLog);
    batch.update(doc(db, `users/${ALICE}`), {
      lastActionDate: serverTimestamp(),
    });
    await assertFails(batch.commit());
  });

  test('rejects points that disagree with the action library', async () => {
    await assertFails(logActionBatch(aliceDb(), {points: 9999}));
  });

  test('rejects co2Grams that disagree with the action library',
    async () => {
      await assertFails(logActionBatch(aliceDb(), {co2Grams: 999999}));
    });

  test('rejects an entry missing a required field', async () => {
    const {co2Grams, ...missingCo2} = validLog;
    const db = aliceDb();
    const batch = writeBatch(db);
    batch.set(doc(db, logPath), missingCo2);
    batch.update(doc(db, `users/${ALICE}`), {
      lastActionDate: serverTimestamp(),
      totalActionsCount: increment(1),
    });
    await assertFails(batch.commit());
  });

  test('rejects fields outside the whitelist', async () => {
    await assertFails(logActionBatch(aliceDb(), {bonus: 1}));
  });

  test('rejects points above the hard cap even if the library agrees',
    async () => {
      // points == library still has to clear the absolute 0..10000 bound.
      await seed('actionLibrary/whale', {points: 20000, co2Grams: 1});
      await assertFails(
        logActionBatch(aliceDb(), {
          actionId: 'whale',
          points: 20000,
          co2Grams: 1,
        }),
      );
    });

  test('rejects loggedAt more than 24h in the past', async () => {
    await assertFails(
      logActionBatch(aliceDb(), {loggedAt: secondsAgo(25 * 3600)}),
    );
  });

  test('rejects loggedAt more than 24h in the future', async () => {
    await assertFails(
      logActionBatch(aliceDb(), {loggedAt: secondsAgo(-25 * 3600)}),
    );
  });

  test('allows a note at the 200-char limit', async () => {
    await assertSucceeds(
      logActionBatch(aliceDb(), {note: 'x'.repeat(200)}),
    );
  });

  test('rejects a note over 200 chars', async () => {
    await assertFails(
      logActionBatch(aliceDb(), {note: 'x'.repeat(201)}),
    );
  });

  test('allows an explicitly null note', async () => {
    await assertSucceeds(logActionBatch(aliceDb(), {note: null}));
  });

  test('allows relatedSdgs up to 17 entries', async () => {
    await assertSucceeds(
      logActionBatch(aliceDb(), {
        relatedSdgs: Array.from({length: 17}, (_, i) => `${i + 1}`),
      }),
    );
  });

  test('rejects relatedSdgs over 17 entries', async () => {
    await assertFails(
      logActionBatch(aliceDb(), {
        relatedSdgs: Array.from({length: 18}, (_, i) => `${i + 1}`),
      }),
    );
  });

  test('rejects a second entry inside the 5s rate-limit window',
    async () => {
      await seed(`users/${ALICE}`, {
        ...baseUserDoc,
        lastActionDate: Timestamp.now(),
      });
      await assertFails(logActionBatch(aliceDb()));
    });

  test('allows an entry once the rate-limit window has passed', async () => {
    await seed(`users/${ALICE}`, {
      ...baseUserDoc,
      lastActionDate: secondsAgo(10),
    });
    await assertSucceeds(logActionBatch(aliceDb()));
  });

  test('a verified password account can log', async () => {
    await assertSucceeds(logActionBatch(alicePasswordDb(true)));
  });

  test('an unverified password account cannot log', async () => {
    await assertFails(logActionBatch(alicePasswordDb(false)));
  });

  test('another user cannot create entries in someone else log',
    async () => {
      await assertFails(setDoc(doc(bobDb(), logPath), validLog));
    });

  test('entries are immutable (no update)', async () => {
    await seed(logPath, validLog);
    await assertFails(
      updateDoc(doc(aliceDb(), logPath), {points: 10}),
    );
  });

  test('entries cannot be deleted by the client', async () => {
    await seed(logPath, validLog);
    await assertFails(deleteDoc(doc(aliceDb(), logPath)));
  });
});

describe('users/{userId}/dailySummaries/{summaryId}', () => {
  const SUMMARY_ID = '2026-06-10';
  const summaryPath = `users/${ALICE}/dailySummaries/${SUMMARY_ID}`;

  const validSummary = {
    date: SUMMARY_ID,
    goalCount: 1,
    completedSdgs: [12, 13],
    totalPoints: 10,
    totalCo2Grams: 500,
    categoryCo2Grams: {waste: 500},
    createdAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
  };

  test('owner can read their own summary', async () => {
    await seed(summaryPath, validSummary);
    await assertSucceeds(getDoc(doc(aliceDb(), summaryPath)));
  });

  test('another user cannot read it', async () => {
    await seed(summaryPath, validSummary);
    await assertFails(getDoc(doc(bobDb(), summaryPath)));
  });

  test('owner can create a well-formed summary', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), summaryPath), validSummary),
    );
  });

  test('owner can increment an existing summary', async () => {
    await seed(summaryPath, validSummary);
    await assertSucceeds(
      updateDoc(doc(aliceDb(), summaryPath), {
        goalCount: increment(1),
        totalPoints: increment(10),
        totalCo2Grams: increment(500),
        'categoryCo2Grams.waste': increment(500),
        updatedAt: serverTimestamp(),
      }),
    );
  });

  test('rejects a non-date document id', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}/dailySummaries/junk`), {
        ...validSummary,
        date: 'junk',
      }),
    );
  });

  test('rejects a date field that mismatches the id', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), summaryPath), {
        ...validSummary,
        date: '2026-01-01',
      }),
    );
  });

  test('rejects fields outside the whitelist', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), summaryPath), {
        ...validSummary,
        payload: 'x'.repeat(100),
      }),
    );
  });

  test('rejects negative totals', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), summaryPath), {
        ...validSummary,
        totalPoints: -5,
      }),
    );
  });

  test('rejects a non-integer goalCount', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), summaryPath), {
        ...validSummary,
        goalCount: 1.5,
      }),
    );
  });

  test('rejects completedSdgs over 17 entries', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), summaryPath), {
        ...validSummary,
        completedSdgs: Array.from({length: 18}, (_, i) => i + 1),
      }),
    );
  });

  test('another user cannot write it', async () => {
    await assertFails(
      setDoc(doc(bobDb(), summaryPath), validSummary),
    );
  });

  test('summaries cannot be deleted by the client', async () => {
    await seed(summaryPath, validSummary);
    await assertFails(deleteDoc(doc(aliceDb(), summaryPath)));
  });

  test('an unverified password account cannot write summaries',
    async () => {
      await assertFails(
        setDoc(doc(alicePasswordDb(false), summaryPath), validSummary),
      );
    });
});

describe('read-only collections', () => {
  const cases = [
    ['actionLibrary', 'a1'],
    ['mascotSpecies', 's1'],
    ['cosmeticItems', 'c1'],
  ];

  for (const [collection, id] of cases) {
    test(`${collection} is readable when authenticated`, async () => {
      await seed(`${collection}/${id}`, {name: 'x'});
      await assertSucceeds(getDoc(doc(aliceDb(), `${collection}/${id}`)));
    });

    test(`${collection} is not client-writable`, async () => {
      await assertFails(
        setDoc(doc(aliceDb(), `${collection}/${id}`), {name: 'x'}),
      );
    });
  }
});
