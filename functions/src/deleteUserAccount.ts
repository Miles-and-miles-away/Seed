import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { getFirestore } from 'firebase-admin/firestore';
import { getAuth } from 'firebase-admin/auth';
import { logger } from 'firebase-functions';

const USERS_COLLECTION = 'users';

/** Minimal Auth surface needed for account deletion. */
export interface AuthDeleter {
  deleteUser(uid: string): Promise<void>;
}

export interface DeleteUserAccountResult {
  success: boolean;
}

/**
 * Deletes all data for the given user: the Firestore user
 * document with every subcollection (actionLog,
 * dailySummaries), then the Auth user.
 *
 * Firestore data is deleted first so that a failure leaves
 * the Auth account intact and the deletion retryable.
 */
export async function handleDeleteUserAccount(
  db: FirebaseFirestore.Firestore,
  auth: AuthDeleter,
  uid: string | undefined,
): Promise<DeleteUserAccountResult> {
  if (!uid) {
    throw new HttpsError(
      'unauthenticated',
      'Authentication is required to delete an account.',
    );
  }

  logger.info(`Account deletion requested for user ${uid}`);

  const userDocRef = db
    .collection(USERS_COLLECTION)
    .doc(uid);

  try {
    await db.recursiveDelete(userDocRef);
  } catch (err: unknown) {
    logger.error(
      `Failed to delete Firestore data for user ${uid}`,
      err,
    );
    // Auth user is intentionally kept so the client can
    // retry the deletion.
    throw new HttpsError(
      'internal',
      'Failed to delete account data. Please try again.',
    );
  }

  logger.info(`Deleted Firestore data for user ${uid}`);

  try {
    await auth.deleteUser(uid);
  } catch (err: unknown) {
    const error = err as { code?: string };
    // Already deleted (e.g. a retried call): treat as done.
    if (error.code === 'auth/user-not-found') {
      logger.warn(
        `Auth user ${uid} already deleted; ` +
          'treating as success',
      );
      return { success: true };
    }
    logger.error(
      `Failed to delete Auth user ${uid}`,
      err,
    );
    throw new HttpsError(
      'internal',
      'Failed to delete account. Please try again.',
    );
  }

  logger.info(`Deleted Auth user ${uid}`);
  return { success: true };
}

/**
 * Callable Cloud Function for GDPR right-to-erasure.
 * Operates only on the authenticated caller's own account.
 */
export const deleteUserAccount = onCall(
  {
    memory: '256MiB',
    region: 'us-central1',
    maxInstances: 10,
    enforceAppCheck: true,
  },
  async (request) =>
    handleDeleteUserAccount(
      getFirestore(),
      getAuth(),
      request.auth?.uid,
    ),
);
