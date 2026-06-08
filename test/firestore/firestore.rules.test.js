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

// Seed data bypassing rules (admin-equivalent), e.g. read-only collections
// and cross-document references the rules depend on.
async function seed(docPath, data) {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), docPath), data);
  });
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

describe('users/{userId} write — ownership', () => {
  test('owner can write their own document', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), `users/${ALICE}`), baseUserDoc),
    );
  });

  test('a user cannot write another user document', async () => {
    await assertFails(
      setDoc(doc(bobDb(), `users/${ALICE}`), baseUserDoc),
    );
  });

  test('an unauthenticated client cannot write', async () => {
    await assertFails(
      setDoc(doc(anonDb(), `users/${ALICE}`), baseUserDoc),
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

describe('users/{userId} write — score integrity', () => {
  // Defense-in-depth: scoring runs client-side, so rules can't prove a jump
  // is earned, but they enforce types and that points/level never decrease.

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

  test('allows points to increase', async () => {
    await seed(`users/${ALICE}`, {...baseUserDoc, points: 100});
    await assertSucceeds(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {...baseUserDoc, points: 150}),
    );
  });

  test('rejects points decreasing (reset/tamper)', async () => {
    await seed(`users/${ALICE}`, {...baseUserDoc, points: 100});
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {...baseUserDoc, points: 50}),
    );
  });

  test('rejects level decreasing', async () => {
    await seed(`users/${ALICE}`, {...baseUserDoc, level: 5});
    await assertFails(
      setDoc(doc(aliceDb(), `users/${ALICE}`), {...baseUserDoc, level: 2}),
    );
  });
});

describe('users/{userId}/actionLog/{logId}', () => {
  const ACTION_ID = 'recycle';
  const logPath = `users/${ALICE}/actionLog/log1`;

  // The create rule requires points to equal the library definition.
  const validLog = {
    actionId: ACTION_ID,
    actionName: 'Recycle',
    category: 'waste',
    points: 10,
    co2Grams: 500,
    loggedAt: Timestamp.now(),
  };

  beforeEach(async () => {
    await seed(`actionLibrary/${ACTION_ID}`, {points: 10});
  });

  test('owner can create a well-formed entry', async () => {
    await assertSucceeds(setDoc(doc(aliceDb(), logPath), validLog));
  });

  test('rejects points that disagree with the action library', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), logPath), {...validLog, points: 9999}),
    );
  });

  test('rejects an entry missing a required field', async () => {
    const {co2Grams, ...missingCo2} = validLog;
    await assertFails(setDoc(doc(aliceDb(), logPath), missingCo2));
  });

  test('rejects points above the hard cap even if the library agrees',
    async () => {
      // points == library still has to clear the absolute 0..10000 bound.
      await seed('actionLibrary/whale', {points: 20000});
      await assertFails(
        setDoc(doc(aliceDb(), logPath), {
          ...validLog,
          actionId: 'whale',
          points: 20000,
        }),
      );
    });

  test('allows a note at the 200-char limit', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), logPath), {...validLog, note: 'x'.repeat(200)}),
    );
  });

  test('rejects a note over 200 chars', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), logPath), {...validLog, note: 'x'.repeat(201)}),
    );
  });

  test('allows relatedSdgs up to 17 entries', async () => {
    await assertSucceeds(
      setDoc(doc(aliceDb(), logPath), {
        ...validLog,
        relatedSdgs: Array.from({length: 17}, (_, i) => `${i + 1}`),
      }),
    );
  });

  test('rejects relatedSdgs over 17 entries', async () => {
    await assertFails(
      setDoc(doc(aliceDb(), logPath), {
        ...validLog,
        relatedSdgs: Array.from({length: 18}, (_, i) => `${i + 1}`),
      }),
    );
  });

  test('rejects a second entry inside the 5s rate-limit window', async () => {
    // A recent lastActionDate must block the next create.
    await seed(`users/${ALICE}`, {...baseUserDoc, lastActionDate: Timestamp.now()});
    await assertFails(setDoc(doc(aliceDb(), logPath), validLog));
  });

  test('allows an entry once the rate-limit window has passed', async () => {
    const tenSecondsAgo = Timestamp.fromMillis(Timestamp.now().toMillis() - 10000);
    await seed(`users/${ALICE}`, {...baseUserDoc, lastActionDate: tenSecondsAgo});
    await assertSucceeds(setDoc(doc(aliceDb(), logPath), validLog));
  });

  test('another user cannot create entries in someone else log', async () => {
    await assertFails(setDoc(doc(bobDb(), logPath), validLog));
  });

  test('entries are immutable (no update)', async () => {
    await seed(logPath, validLog);
    await assertFails(
      updateDoc(doc(aliceDb(), logPath), {points: 10}),
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
