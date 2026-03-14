import {
  onDocumentCreated,
} from 'firebase-functions/v2/firestore';
import { getFirestore } from 'firebase-admin/firestore';
import { logger } from 'firebase-functions';

const USERS_COLLECTION = 'users';
const ACTION_LOG_SUBCOLLECTION = 'actionLog';
const ACTION_LIBRARY_COLLECTION = 'actionLibrary';
const POINTS_FIELD = 'points';
const ACTION_ID_FIELD = 'actionId';

interface ActionLogData {
  actionId?: string;
  points?: number;
  [key: string]: unknown;
}

interface ActionLibraryData {
  points?: number;
  [key: string]: unknown;
}

/**
 * Recalculates total points for a user by summing
 * all action log entries.
 */
async function recalculateUserPoints(
  db: FirebaseFirestore.Firestore,
  userId: string,
): Promise<number> {
  const actionLogs = await db
    .collection(USERS_COLLECTION)
    .doc(userId)
    .collection(ACTION_LOG_SUBCOLLECTION)
    .get();

  let totalPoints = 0;
  for (const doc of actionLogs.docs) {
    const data = doc.data();
    totalPoints += (data[POINTS_FIELD] as number) ?? 0;
  }

  await db
    .collection(USERS_COLLECTION)
    .doc(userId)
    .update({ [POINTS_FIELD]: totalPoints });

  return totalPoints;
}

/**
 * Firestore trigger that validates points on newly
 * created action log entries against the action library.
 *
 * If the client-submitted points differ from the
 * canonical value, the document is corrected and the
 * user's total points are recalculated.
 */
export const validateActionPoints = onDocumentCreated(
  {
    document:
      `${USERS_COLLECTION}/{userId}/` +
      `${ACTION_LOG_SUBCOLLECTION}/{actionLogId}`,
    memory: '256MiB',
  },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      logger.warn('No document data in event');
      return;
    }

    const actionLogData = snapshot.data() as ActionLogData;
    const { userId } = event.params;
    const db = getFirestore();

    const actionId = actionLogData[ACTION_ID_FIELD];
    if (!actionId) {
      logger.warn(
        `Action log ${snapshot.id} for user ${userId} ` +
          'is missing actionId field',
      );
      return;
    }

    const submittedPoints =
      actionLogData[POINTS_FIELD] ?? 0;

    // Look up canonical points from action library
    const libraryDoc = await db
      .collection(ACTION_LIBRARY_COLLECTION)
      .doc(actionId)
      .get();

    if (!libraryDoc.exists) {
      logger.warn(
        `Action "${actionId}" not found in ` +
          `${ACTION_LIBRARY_COLLECTION}. ` +
          `User: ${userId}, log: ${snapshot.id}`,
      );
      return;
    }

    const libraryData =
      libraryDoc.data() as ActionLibraryData;
    const canonicalPoints =
      libraryData[POINTS_FIELD];

    if (canonicalPoints === undefined) {
      logger.warn(
        `Action "${actionId}" in ` +
          `${ACTION_LIBRARY_COLLECTION} has no ` +
          `${POINTS_FIELD} field`,
      );
      return;
    }

    if (submittedPoints === canonicalPoints) {
      return;
    }

    // Points mismatch detected
    logger.warn(
      `Points mismatch for user ${userId}, ` +
        `log ${snapshot.id}: ` +
        `submitted=${submittedPoints}, ` +
        `expected=${canonicalPoints}`,
    );

    // Correct the action log document
    await snapshot.ref.update({
      [POINTS_FIELD]: canonicalPoints,
    });

    // Recalculate user total points
    const newTotal = await recalculateUserPoints(
      db,
      userId,
    );

    logger.info(
      `Corrected points for user ${userId}. ` +
        `New total: ${newTotal}`,
    );
  },
);
