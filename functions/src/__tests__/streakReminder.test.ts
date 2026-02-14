import {
  getNotificationText,
  getUsersAtRisk,
  sendReminders,
} from '../streakReminder';

// --- Mock firebase-admin modules ---

const mockWhere = jest.fn().mockReturnThis();
const mockCollection = jest.fn(() => ({
  where: mockWhere,
  doc: jest.fn((id: string) => ({
    update: jest.fn(),
  })),
}));

const mockDb = {
  collection: mockCollection,
} as unknown as FirebaseFirestore.Firestore;

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
  beforeEach(() => {
    jest.clearAllMocks();
    mockWhere.mockReturnThis();
  });

  it('queries with correct filters', async () => {
    const todayStart = new Date('2025-06-15T00:00:00Z');
    mockWhere.mockReturnValue({
      where: mockWhere,
      get: jest.fn().mockResolvedValue({ docs: [] }),
    });

    await getUsersAtRisk(mockDb, todayStart);

    expect(mockCollection).toHaveBeenCalledWith('users');
    expect(mockWhere).toHaveBeenCalledWith(
      'notificationsEnabled',
      '==',
      true,
    );
    expect(mockWhere).toHaveBeenCalledWith(
      'currentStreak',
      '>',
      0,
    );
    expect(mockWhere).toHaveBeenCalledWith(
      'lastActionDate',
      '<',
      expect.anything(),
    );
  });

  it('returns matching documents', async () => {
    const docs = [
      fakeDoc('user1', {
        currentStreak: 5,
        fcmToken: 'token1',
      }),
    ];
    mockWhere.mockReturnValue({
      where: mockWhere,
      get: jest.fn().mockResolvedValue({ docs }),
    });

    const todayStart = new Date('2025-06-15T00:00:00Z');
    const result = await getUsersAtRisk(
      mockDb,
      todayStart,
    );

    expect(result).toHaveLength(1);
    expect(result[0].id).toBe('user1');
  });
});

describe('sendReminders', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('sends notification to users with FCM tokens', async () => {
    mockSend.mockResolvedValue('message-id-1');

    const docs = [
      fakeDoc('user1', {
        fcmToken: 'valid-token',
        language: 'en',
        currentStreak: 7,
      }),
    ];

    const result = await sendReminders(
      mockDb,
      mockMessaging,
      docs,
    );

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
    const docs = [
      fakeDoc('user1', {
        language: 'en',
        currentStreak: 3,
        // no fcmToken
      }),
    ];

    const result = await sendReminders(
      mockDb,
      mockMessaging,
      docs,
    );

    expect(mockSend).not.toHaveBeenCalled();
    expect(result.skipped).toBe(1);
    expect(result.sent).toBe(0);
  });

  it('sends Japanese notification for ja users', async () => {
    mockSend.mockResolvedValue('message-id-2');

    const docs = [
      fakeDoc('user-ja', {
        fcmToken: 'ja-token',
        language: 'ja',
        currentStreak: 14,
      }),
    ];

    await sendReminders(mockDb, mockMessaging, docs);

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

      const docs = [
        fakeDoc('user-unknown', {
          fcmToken: 'token-unknown',
          language: 'es',
          currentStreak: 2,
        }),
      ];

      await sendReminders(mockDb, mockMessaging, docs);

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

      const docs = [
        fakeDoc('user-no-lang', {
          fcmToken: 'token-no-lang',
          currentStreak: 5,
          // no language field
        }),
      ];

      await sendReminders(mockDb, mockMessaging, docs);

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
    const mockUpdate = jest.fn();
    const mockDocRef = jest.fn(() => ({
      update: mockUpdate,
    }));
    const dbWithCleanup = {
      collection: jest.fn(() => ({
        doc: mockDocRef,
      })),
    } as unknown as FirebaseFirestore.Firestore;

    const error = new Error('Token not registered');
    (error as unknown as { code: string }).code =
      'messaging/registration-token-not-registered';
    mockSend.mockRejectedValue(error);

    const docs = [
      fakeDoc('user-bad-token', {
        fcmToken: 'expired-token',
        language: 'en',
        currentStreak: 10,
      }),
    ];

    const result = await sendReminders(
      dbWithCleanup,
      mockMessaging,
      docs,
    );

    expect(mockDocRef).toHaveBeenCalledWith(
      'user-bad-token',
    );
    expect(mockUpdate).toHaveBeenCalledWith({
      fcmToken: null,
    });
    expect(result.failed).toBe(1);
  });

  it(
    'cleans up invalid-registration-token errors',
    async () => {
      const mockUpdate = jest.fn();
      const mockDocRef = jest.fn(() => ({
        update: mockUpdate,
      }));
      const dbWithCleanup = {
        collection: jest.fn(() => ({
          doc: mockDocRef,
        })),
      } as unknown as FirebaseFirestore.Firestore;

      const error = new Error('Invalid token');
      (error as unknown as { code: string }).code =
        'messaging/invalid-registration-token';
      mockSend.mockRejectedValue(error);

      const docs = [
        fakeDoc('user-invalid', {
          fcmToken: 'malformed-token',
          language: 'en',
          currentStreak: 3,
        }),
      ];

      const result = await sendReminders(
        dbWithCleanup,
        mockMessaging,
        docs,
      );

      expect(mockUpdate).toHaveBeenCalledWith({
        fcmToken: null,
      });
      expect(result.failed).toBe(1);
    },
  );

  it('handles multiple users in a batch', async () => {
    mockSend.mockResolvedValue('message-id');

    const docs = [
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
    ];

    const result = await sendReminders(
      mockDb,
      mockMessaging,
      docs,
    );

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

    const docs = [
      fakeDoc('user-err', {
        fcmToken: 'token-err',
        language: 'en',
        currentStreak: 5,
      }),
    ];

    const result = await sendReminders(
      mockDb,
      mockMessaging,
      docs,
    );

    // Should not throw, just count as failed
    expect(result.failed).toBe(1);
    expect(result.sent).toBe(0);
  });

  it(
    'includes streak_reminder type in data payload',
    async () => {
      mockSend.mockResolvedValue('msg-id');

      const docs = [
        fakeDoc('user-data', {
          fcmToken: 'token-data',
          language: 'en',
          currentStreak: 12,
        }),
      ];

      await sendReminders(mockDb, mockMessaging, docs);

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
