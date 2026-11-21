import { UserRecord } from 'firebase-admin/auth';
import {
  handleCleanupUnverifiedUsers,
  isStaleUnverified,
} from '../cleanupUnverifiedUsers';

const NOW = Date.parse('2026-11-01T00:00:00Z');
const OLD = 'Mon, 20 Oct 2026 00:00:00 GMT';
const RECENT = 'Fri, 30 Oct 2026 00:00:00 GMT';

function user(
  uid: string,
  {
    verified = false,
    providers = ['password'],
    created = OLD,
  }: { verified?: boolean; providers?: string[]; created?: string } = {},
): UserRecord {
  return {
    uid,
    emailVerified: verified,
    providerData: providers.map((providerId) => ({ providerId })),
    metadata: { creationTime: created },
  } as unknown as UserRecord;
}

describe('isStaleUnverified', () => {
  it('flags an old unverified password account', () => {
    expect(isStaleUnverified(user('a'), NOW)).toBe(true);
  });

  it.each([
    ['a verified account', user('a', { verified: true })],
    ['a recent sign-up', user('a', { created: RECENT })],
    ['a social account', user('a', { providers: ['google.com'] })],
    [
      'a password account linked to a social one',
      user('a', { providers: ['password', 'apple.com'] }),
    ],
    ['an account with no providers', user('a', { providers: [] })],
  ])('keeps %s', (_, record) => {
    expect(isStaleUnverified(record, NOW)).toBe(false);
  });
});

describe('handleCleanupUnverifiedUsers', () => {
  function makeMocks(pages: UserRecord[][]) {
    const recursiveDelete = jest.fn().mockResolvedValue(undefined);
    const db = {
      collection: jest.fn(() => ({
        doc: jest.fn((uid: string) => ({ path: `users/${uid}` })),
      })),
      recursiveDelete,
    } as unknown as FirebaseFirestore.Firestore;
    const listUsers = jest.fn((_max: number, token?: string) => {
      const index = token ? Number(token) : 0;
      return Promise.resolve({
        users: pages[index],
        pageToken: index + 1 < pages.length ? String(index + 1) : undefined,
      });
    });
    const deleteUser = jest.fn().mockResolvedValue(undefined);
    return { db, recursiveDelete, auth: { listUsers, deleteUser } };
  }

  it('deletes only stale accounts across every page, data first', async () => {
    const { db, recursiveDelete, auth } = makeMocks([
      [user('stale1'), user('verified', { verified: true })],
      [user('stale2'), user('recent', { created: RECENT })],
    ]);

    const deleted = await handleCleanupUnverifiedUsers(db, auth, NOW);

    expect(deleted).toBe(2);
    expect(auth.deleteUser.mock.calls).toEqual([['stale1'], ['stale2']]);
    expect(recursiveDelete.mock.invocationCallOrder[0]).toBeLessThan(
      auth.deleteUser.mock.invocationCallOrder[0],
    );
  });

  it('keeps the Auth user and continues when data deletion fails', async () => {
    const { db, recursiveDelete, auth } = makeMocks([
      [user('broken'), user('stale')],
    ]);
    recursiveDelete.mockRejectedValueOnce(new Error('unavailable'));

    const deleted = await handleCleanupUnverifiedUsers(db, auth, NOW);

    expect(deleted).toBe(1);
    expect(auth.deleteUser.mock.calls).toEqual([['stale']]);
  });
});
