import {
  getNotificationText,
  getUsersAtRisk,
  recordReminderSends,
  sendReminders,
} from '../streakReminder';

const TODAY = '2025-06-15';

// --- Mock firebase-admin modules ---

function makeDbMock() {
  const docUpdate = jest.fn();
  const doc = jest.fn((id: string) => ({
    id,
    update: docUpdate,
  }));
  const collection = jest.fn(() => ({ doc }));
  const batchUpdate = jest.fn();
  const batchCommit = jest
    .fn()
    .mockResolvedValue(undefined);
  const batch = jest.fn(() => ({
    update: batchUpdate,
    commit: batchCommit,
  }));
  const db = {
    collection,
    batch,
  } as unknown as FirebaseFirestore.Firestore;
  return {
    db,
    collection,
    doc,
    docUpdate,
    batch,
    batchUpdate,
    batchCommit,
  };
}

// Query mock whose chainable methods all return the query
function makeQueryDb(docs: unknown[]) {
  const query = {
    where: jest.fn(),
    orderBy: jest.fn(),
    limit: jest.fn(),
    startAfter: jest.fn(),
    get: jest.fn().mockResolvedValue({ docs }),
  };
  query.where.mockReturnValue(query);
  query.orderBy.mockReturnValue(query);
  query.limit.mockReturnValue(query);
  query.startAfter.mockReturnValue(query);
  const collection = jest.fn(() => query);
  const db = {
    collection,
  } as unknown as FirebaseFirestore.Firestore;
  return { db, collection, query };
}

const mockSend = jest.fn();
const mockMessaging = {
  send: mockSend,
} as unknown as ReturnType<
  typeof import('firebase-admin/messaging').getMessaging
>;

// Helper to build a fake Firestore query doc
function fakeDoc(
  id: string,
  data: Record<string, unknown>,
) {
  return {
    id,
    data: () => data,
    ref: { path: `users/${id}` },
  } as unknown as FirebaseFirestore.QueryDocumentSnapshot;
}

async function runReminders(
  docs: FirebaseFirestore.QueryDocumentSnapshot[],
  mocks = makeDbMock(),
) {
  const result = await sendReminders(
    mocks.db,
    mockMessaging,
    docs,
    TODAY,
  );
  return { result, ...mocks };
}

// --- Tests ---

describe('getNotificationText', () => {
  it('returns English text by default', () => {
    const result = getNotificationText('en', 5);
    expect(result.title).toBe(
      "Don't break your streak!",
    );
    expect(result.body).toContain('5-day streak');
    expect(result.body).toContain('Log an action today');
  });

  it('returns Japanese text for ja', () => {
    const result = getNotificationText('ja', 10);
    expect(result.title).toBe(
      'ストリークを途切れさせないで!',
    );
    expect(result.body).toContain('10日連続');
  });

  it('returns Spanish text for es', () => {
    const result = getNotificationText('es', 8);
    expect(result.title).toBe(
      'No pierdas tu racha!',
    );
    expect(result.body).toContain('racha de 8 dias');
  });

  it('falls back to English for unknown languages', () => {
    const result = getNotificationText('fr', 3);
    expect(result.title).toBe(
      "Don't break your streak!",
    );
    expect(result.body).toContain('3-day streak');
  });

  it('includes the correct streak count', () => {
    const result = getNotificationText('en', 42);
    expect(result.body).toContain('42-day streak');
  });
});

describe('getUsersAtRisk', () => {
  it('queries with correct filters and paging', async () => {
    const { db, collection, query } = makeQueryDb([]);
    const todayStart = new Date('2025-06-15T00:00:00Z');

    await getUsersAtRisk(db, todayStart);

    expect(collection).toHaveBeenCalledWith('users');
    expect(query.where).toHaveBeenCalledWith(
      'notificationsEnabled',
      '==',
      true,
    );
    expect(query.where).toHaveBeenCalledWith(
      'currentStreak',
      '>',
      0,
    );
    expect(query.where).toHaveBeenCalledWith(
      'lastActionDate',
      '<',
      expect.anything(),
    );
    expect(query.orderBy).toHaveBeenCalledWith(
      'lastActionDate',
    );
    expect(query.limit).toHaveBeenCalledWith(500);
  });

  it('does not apply a cursor on the first page', async () => {
    const { db, query } = makeQueryDb([]);
    const todayStart = new Date('2025-06-15T00:00:00Z');

    await getUsersAtRisk(db, todayStart);

    expect(query.startAfter).not.toHaveBeenCalled();
  });

  it('applies the cursor for subsequent pages', async () => {
    const { db, query } = makeQueryDb([]);
    const todayStart = new Date('2025-06-15T00:00:00Z');
    const cursor = fakeDoc('last-of-page', {});

    await getUsersAtRisk(db, todayStart, 100, cursor);

    expect(query.startAfter).toHaveBeenCalledWith(cursor);
    expect(query.limit).toHaveBeenCalledWith(100);
  });

  it('returns matching documents', async () => {
    const docs = [
      fakeDoc('user1', {
        currentStreak: 5,
        fcmToken: 'token1',
      }),
    ];
    const { db } = makeQueryDb(docs);
    const todayStart = new Date('2025-06-15T00:00:00Z');

    const result = await getUsersAtRisk(db, todayStart);

    expect(result).toHaveLength(1);
    expect(result[0].id).toBe('user1');
  });
});

describe('sendReminders', () => {
  it('sends notification to users with FCM tokens', async () => {
    mockSend.mockResolvedValue('message-id-1');

    const { result } = await runReminders([
      fakeDoc('user1', {
        fcmToken: 'valid-token',
        language: 'en',
        currentStreak: 7,
      }),
    ]);

    expect(mockSend).toHaveBeenCalledTimes(1);
    expect(mockSend).toHaveBeenCalledWith({
      token: 'valid-token',
      notification: {
        title: "Don't break your streak!",
        body: 'You have a 7-day streak. Log an action today!',
      },
      data: {
        type: 'streak_reminder',
        userId: 'user1',
      },
    });
    expect(result.sent).toBe(1);
    expect(result.skipped).toBe(0);
    expect(result.failed).toBe(0);
  });

  it('skips users without FCM tokens', async () => {
    const { result } = await runReminders([
      fakeDoc('user1', {
        language: 'en',
        currentStreak: 3,
        // no fcmToken
      }),
    ]);

    expect(mockSend).not.toHaveBeenCalled();
    expect(result.skipped).toBe(1);
    expect(result.sent).toBe(0);
  });

  it(
    'skips users already reminded today',
    async () => {
      const { result, batch } = await runReminders([
        fakeDoc('user-deduped', {
          fcmToken: 'token-deduped',
          language: 'en',
          currentStreak: 9,
          lastStreakReminderDate: TODAY,
        }),
      ]);

      expect(mockSend).not.toHaveBeenCalled();
      expect(batch).not.toHaveBeenCalled();
      expect(result.skipped).toBe(1);
      expect(result.sent).toBe(0);
    },
  );

  it(
    'sends when the last reminder was a previous day',
    async () => {
      mockSend.mockResolvedValue('message-id-prev');

      const { result } = await runReminders([
        fakeDoc('user-prev', {
          fcmToken: 'token-prev',
          language: 'en',
          currentStreak: 4,
          lastStreakReminderDate: '2025-06-14',
        }),
      ]);

      expect(mockSend).toHaveBeenCalledTimes(1);
      expect(result.sent).toBe(1);
      expect(result.skipped).toBe(0);
    },
  );

  it(
    'records the reminder date for sent users',
    async () => {
      mockSend.mockResolvedValue('message-id-rec');

      const { doc, batchUpdate, batchCommit } = await runReminders([
        fakeDoc('user-rec', {
          fcmToken: 'token-rec',
          language: 'en',
          currentStreak: 6,
        }),
      ]);

      expect(doc).toHaveBeenCalledWith('user-rec');
      expect(batchUpdate).toHaveBeenCalledWith(
        expect.objectContaining({ id: 'user-rec' }),
        { lastStreakReminderDate: TODAY },
      );
      expect(batchCommit).toHaveBeenCalledTimes(1);
    },
  );

  it(
    'does not record the reminder date on failure',
    async () => {
      const error = new Error('Send failed');
      (error as unknown as { code: string }).code =
        'messaging/internal-error';
      mockSend.mockRejectedValue(error);

      const { result, batch } = await runReminders([
        fakeDoc('user-fail', {
          fcmToken: 'token-fail',
          language: 'en',
          currentStreak: 2,
        }),
      ]);

      expect(batch).not.toHaveBeenCalled();
      expect(result.failed).toBe(1);
    },
  );

  it('sends Japanese notification for ja users', async () => {
    mockSend.mockResolvedValue('message-id-2');

    await runReminders([
      fakeDoc('user-ja', {
        fcmToken: 'ja-token',
        language: 'ja',
        currentStreak: 14,
      }),
    ]);

    expect(mockSend).toHaveBeenCalledWith(
      expect.objectContaining({
        notification: {
          title: 'ストリークを途切れさせないで!',
          body:
            '14日連続ストリーク中。' +
            '今日もアクションを記録しよう!',
        },
      }),
    );
  });

  it(
    'defaults to English for unknown language',
    async () => {
      mockSend.mockResolvedValue('message-id-3');

      await runReminders([
        fakeDoc('user-unknown', {
          fcmToken: 'token-unknown',
          language: 'fr',
          currentStreak: 2,
        }),
      ]);

      expect(mockSend).toHaveBeenCalledWith(
        expect.objectContaining({
          notification: expect.objectContaining({
            title: "Don't break your streak!",
          }),
        }),
      );
    },
  );

  it(
    'defaults to English when language is missing',
    async () => {
      mockSend.mockResolvedValue('message-id-4');

      await runReminders([
        fakeDoc('user-no-lang', {
          fcmToken: 'token-no-lang',
          currentStreak: 5,
          // no language field
        }),
      ]);

      expect(mockSend).toHaveBeenCalledWith(
        expect.objectContaining({
          notification: expect.objectContaining({
            title: "Don't break your streak!",
          }),
        }),
      );
    },
  );

  it('cleans up invalid registration tokens', async () => {
    const error = new Error('Token not registered');
    (error as unknown as { code: string }).code =
      'messaging/registration-token-not-registered';
    mockSend.mockRejectedValue(error);

    const { result, doc, docUpdate } = await runReminders([
      fakeDoc('user-bad-token', {
        fcmToken: 'expired-token',
        language: 'en',
        currentStreak: 10,
      }),
    ]);

    expect(doc).toHaveBeenCalledWith('user-bad-token');
    expect(docUpdate).toHaveBeenCalledWith({
      fcmToken: null,
    });
    expect(result.failed).toBe(1);
  });

  it(
    'cleans up invalid-registration-token errors',
    async () => {
      const error = new Error('Invalid token');
      (error as unknown as { code: string }).code =
        'messaging/invalid-registration-token';
      mockSend.mockRejectedValue(error);

      const { result, docUpdate } = await runReminders([
        fakeDoc('user-invalid', {
          fcmToken: 'malformed-token',
          language: 'en',
          currentStreak: 3,
        }),
      ]);

      expect(docUpdate).toHaveBeenCalledWith({
        fcmToken: null,
      });
      expect(result.failed).toBe(1);
    },
  );

  it('handles multiple users in a batch', async () => {
    mockSend.mockResolvedValue('message-id');

    const { result } = await runReminders([
      fakeDoc('u1', {
        fcmToken: 't1',
        language: 'en',
        currentStreak: 3,
      }),
      fakeDoc('u2', {
        fcmToken: 't2',
        language: 'ja',
        currentStreak: 7,
      }),
      fakeDoc('u3', {
        // no token
        language: 'en',
        currentStreak: 1,
      }),
      fakeDoc('u4', {
        fcmToken: 't4',
        language: 'en',
        currentStreak: 30,
      }),
    ]);

    expect(mockSend).toHaveBeenCalledTimes(3);
    expect(result.sent).toBe(3);
    expect(result.skipped).toBe(1);
    expect(result.failed).toBe(0);
  });

  it('handles send errors gracefully', async () => {
    const genericError = new Error('Network error');
    (genericError as unknown as { code: string }).code =
      'messaging/internal-error';
    mockSend.mockRejectedValue(genericError);

    const { result } = await runReminders([
      fakeDoc('user-err', {
        fcmToken: 'token-err',
        language: 'en',
        currentStreak: 5,
      }),
    ]);

    // Should not throw, just count as failed
    expect(result.failed).toBe(1);
    expect(result.sent).toBe(0);
  });

  it(
    'includes streak_reminder type in data payload',
    async () => {
      mockSend.mockResolvedValue('msg-id');

      await runReminders([
        fakeDoc('user-data', {
          fcmToken: 'token-data',
          language: 'en',
          currentStreak: 12,
        }),
      ]);

      expect(mockSend).toHaveBeenCalledWith(
        expect.objectContaining({
          data: {
            type: 'streak_reminder',
            userId: 'user-data',
          },
        }),
      );
    },
  );
});

describe('recordReminderSends', () => {
  it('writes the date for each user in one batch', async () => {
    const { db, batch, batchUpdate, batchCommit } =
      makeDbMock();

    await recordReminderSends(
      db,
      ['u1', 'u2', 'u3'],
      TODAY,
    );

    expect(batch).toHaveBeenCalledTimes(1);
    expect(batchUpdate).toHaveBeenCalledTimes(3);
    expect(batchUpdate).toHaveBeenCalledWith(
      expect.objectContaining({ id: 'u1' }),
      { lastStreakReminderDate: TODAY },
    );
    expect(batchCommit).toHaveBeenCalledTimes(1);
  });

  it('chunks writes at the Firestore batch limit', async () => {
    const { db, batch, batchUpdate, batchCommit } =
      makeDbMock();
    const userIds = Array.from(
      { length: 501 },
      (_, i) => `user-${i}`,
    );

    await recordReminderSends(db, userIds, TODAY);

    expect(batch).toHaveBeenCalledTimes(2);
    expect(batchUpdate).toHaveBeenCalledTimes(501);
    expect(batchCommit).toHaveBeenCalledTimes(2);
  });

  it('does nothing for an empty user list', async () => {
    const { db, batch } = makeDbMock();

    await recordReminderSends(db, [], TODAY);

    expect(batch).not.toHaveBeenCalled();
  });
});
