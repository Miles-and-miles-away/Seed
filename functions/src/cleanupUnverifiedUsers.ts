import { onSchedule } from 'firebase-functions/v2/scheduler';
import { getFirestore } from 'firebase-admin/firestore';
import { getAuth, UserRecord } from 'firebase-admin/auth';
import { logger } from 'firebase-functions';

const USERS_COLLECTION = 'users';
const MAX_UNVERIFIED_AGE_MS = 7 * 24 * 60 * 60 * 1000;
const LIST_PAGE_SIZE = 1000;

/** Minimal Auth surface needed for the cleanup. */
export interface AuthUserLister {
  listUsers(
    maxResults: number,
    pageToken?: string,
  ): Promise<{ users: UserRecord[]; pageToken?: string }>;
  deleteUser(uid: string): Promise<void>;
}

/**
 * Only password accounts that never verified: anyone can register
 * someone else's address, and it would otherwise sit here forever and
 * block the real owner from signing up. Social accounts arrive verified.
 */
export function isStaleUnverified(
  user: UserRecord,
  nowMs: number,
): boolean {
  return (
    !user.emailVerified &&
    user.providerData.length > 0 &&
    user.providerData.every((p) => p.providerId === 'password') &&
    nowMs - Date.parse(user.metadata.creationTime) > MAX_UNVERIFIED_AGE_MS
  );
}

/** Deletes stale unverified accounts and their user documents. */
export async function handleCleanupUnverifiedUsers(
  db: FirebaseFirestore.Firestore,
  auth: AuthUserLister,
  nowMs: number = Date.now(),
): Promise<number> {
  const stale: string[] = [];
  let pageToken: string | undefined;
  do {
    const page = await auth.listUsers(LIST_PAGE_SIZE, pageToken);
    for (const user of page.users) {
      if (isStaleUnverified(user, nowMs)) stale.push(user.uid);
    }
    pageToken = page.pageToken;
  } while (pageToken);

  let deleted = 0;
  for (const uid of stale) {
    try {
      // Data first, as in deleteUserAccount, so a failure stays retryable.
      await db.recursiveDelete(db.collection(USERS_COLLECTION).doc(uid));
      await auth.deleteUser(uid);
      deleted++;
    } catch (err: unknown) {
      logger.error(`Failed to clean up unverified user ${uid}`, err);
    }
  }
  logger.info(`Deleted ${deleted} of ${stale.length} unverified accounts`);
  return deleted;
}

export const cleanupUnverifiedUsers = onSchedule(
  {
    schedule: '0 3 * * *',
    timeZone: 'UTC',
    retryCount: 1,
    memory: '256MiB',
    region: 'asia-northeast1',
    maxInstances: 1,
  },
  async () => {
    await handleCleanupUnverifiedUsers(getFirestore(), getAuth());
  },
);
