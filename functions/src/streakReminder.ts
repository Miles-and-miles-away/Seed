// NOTE(postponed): Part of the notification/reminder feature deferred
// on 2026-06-10 (see lib/shared/providers/notification_providers.dart).
// Deliberately kept in-tree, not dead code -- do not delete or flag in
// dead-code audits. Nothing in lib/ reads lastStreakReminderDate yet;
// that is expected until the feature is revived. Revival checklist:
// - Confirm deployment state with `firebase functions:list`.
// - Switch messaging.send-per-token to messaging.sendEach (one HTTP
//   call per batch, same per-token error results).
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';
import { getMessaging } from 'firebase-admin/messaging';
import { logger } from 'firebase-functions';

const SCHEDULE_CRON = '0 20 * * *'; // 8 PM UTC daily
const USERS_COLLECTION = 'users';
const BATCH_SIZE = 500;
const PAGE_SIZE = 500;
// Firestore allows at most 500 writes per batch.
const WRITE_BATCH_LIMIT = 500;
const LAST_REMINDER_FIELD = 'lastStreakReminderDate';

interface NotificationText {
  title: string;
  body: string;
}

/** Localized notification messages keyed by language code. */
const NOTIFICATION_MESSAGES: Record<
  string,
  (streak: number) => NotificationText
> = {
  en: (streak) => ({
    title: "Don't break your streak!",
    body:
      `You have a ${streak}-day streak. ` +
      'Log an action today!',
  }),
  ja: (streak) => ({
    title: 'ストリークを途切れさせないで!',
    body:
      `${streak}日連続ストリーク中。` +
      '今日もアクションを記録しよう!',
  }),
  es: (streak) => ({
    title: 'No pierdas tu racha!',
    body:
      `Tienes una racha de ${streak} dias. ` +
      'Registra una accion hoy!',
  }),
};

const DEFAULT_LANGUAGE = 'en';

/** Returns localized notification text for the given language. */
export function getNotificationText(
  language: string,
  streak: number,
): NotificationText {
  const builder =
    NOTIFICATION_MESSAGES[language] ??
    NOTIFICATION_MESSAGES[DEFAULT_LANGUAGE];
  return builder(streak);
}

/**
 * Queries Firestore for one page of users at risk of losing
 * their streak. Pages by cursor so an unbounded user count
 * never has to fit in memory at once.
 *
 * Criteria:
 * - notificationsEnabled == true
 * - currentStreak > 0
 * - lastActionDate < start of today (UTC)
 * - Has a valid fcmToken
 */
export async function getUsersAtRisk(
  db: FirebaseFirestore.Firestore,
  todayStart: Date,
  pageSize: number = PAGE_SIZE,
  startAfter?: FirebaseFirestore.QueryDocumentSnapshot,
) {
  // Ordering by the inequality field keeps the cursor
  // stable even though we update user docs mid-run.
  let query = db
    .collection(USERS_COLLECTION)
    .where('notificationsEnabled', '==', true)
    .where('currentStreak', '>', 0)
    .where(
      'lastActionDate',
      '<',
      Timestamp.fromDate(todayStart),
    )
    .orderBy('lastActionDate')
    .limit(pageSize);

  if (startAfter) {
    query = query.startAfter(startAfter);
  }

  const snapshot = await query.get();
  return snapshot.docs;
}

/**
 * Records the reminder date on each notified user doc so a
 * scheduler retry (retryCount > 0) does not re-send.
 */
export async function recordReminderSends(
  db: FirebaseFirestore.Firestore,
  userIds: string[],
  todayDate: string,
) {
  for (
    let i = 0;
    i < userIds.length;
    i += WRITE_BATCH_LIMIT
  ) {
    const chunk = userIds.slice(i, i + WRITE_BATCH_LIMIT);
    const batch = db.batch();
    for (const userId of chunk) {
      batch.update(
        db.collection(USERS_COLLECTION).doc(userId),
        { [LAST_REMINDER_FIELD]: todayDate },
      );
    }
    await batch.commit();
  }
}

/**
 * Sends streak reminder notifications and cleans up
 * invalid FCM tokens.
 */
export async function sendReminders(
  db: FirebaseFirestore.Firestore,
  messaging: ReturnType<typeof getMessaging>,
  docs: FirebaseFirestore.QueryDocumentSnapshot[],
  todayDate: string,
) {
  let sent = 0;
  let skipped = 0;
  let failed = 0;
  const sentUserIds: string[] = [];

  for (let i = 0; i < docs.length; i += BATCH_SIZE) {
    const batch = docs.slice(i, i + BATCH_SIZE);
    const results = await Promise.allSettled(
      batch.map(async (doc) => {
        const data = doc.data();

        // Already reminded today: this run is a retry.
        if (data[LAST_REMINDER_FIELD] === todayDate) {
          skipped++;
          return;
        }

        // DocumentData fields are untyped; narrow before use so a
        // malformed document cannot produce a bogus send.
        const token =
          typeof data.fcmToken === 'string' ? data.fcmToken : undefined;

        if (!token) {
          skipped++;
          return;
        }

        const language =
          typeof data.language === 'string'
            ? data.language
            : DEFAULT_LANGUAGE;
        const streak =
          typeof data.currentStreak === 'number'
            ? data.currentStreak
            : 0;
        const text = getNotificationText(language, streak);

        try {
          await messaging.send({
            token,
            notification: {
              title: text.title,
              body: text.body,
            },
            data: {
              type: 'streak_reminder',
              userId: doc.id,
            },
          });
          sent++;
          sentUserIds.push(doc.id);
        } catch (err: unknown) {
          const error = err as { code?: string };
          // Clean up invalid tokens
          if (
            error.code ===
              'messaging/registration-token-not-registered' ||
            error.code === 'messaging/invalid-registration-token'
          ) {
            await db
              .collection(USERS_COLLECTION)
              .doc(doc.id)
              .update({ fcmToken: null });
            logger.warn(
              `Removed invalid token for user ${doc.id}`,
            );
          }
          failed++;
        }
      }),
    );

    const errors = results.filter(
      (r) => r.status === 'rejected',
    );
    if (errors.length > 0) {
      logger.error(
        `${errors.length} unexpected errors in batch`,
      );
    }
  }

  await recordReminderSends(db, sentUserIds, todayDate);

  return { sent, skipped, failed };
}

/** Scheduled Cloud Function: streak break reminder. */
export const sendStreakReminders = onSchedule(
  {
    schedule: SCHEDULE_CRON,
    timeZone: 'UTC',
    retryCount: 1,
    memory: '256MiB',
    region: 'asia-northeast1',
    maxInstances: 1,
  },
  async () => {
    const db = getFirestore();
    const messaging = getMessaging();

    const todayStart = new Date();
    todayStart.setUTCHours(0, 0, 0, 0);
    const todayDate = todayStart
      .toISOString()
      .slice(0, 10);

    logger.info(
      `Running streak reminders for ${todayStart.toISOString()}`,
    );

    let totalSent = 0;
    let totalSkipped = 0;
    let totalFailed = 0;
    let totalUsers = 0;
    let cursor:
      | FirebaseFirestore.QueryDocumentSnapshot
      | undefined;

    for (;;) {
      const docs = await getUsersAtRisk(
        db,
        todayStart,
        PAGE_SIZE,
        cursor,
      );

      if (docs.length === 0) {
        break;
      }

      totalUsers += docs.length;
      logger.info(
        `Processing page of ${docs.length} at-risk users`,
      );

      const { sent, skipped, failed } =
        await sendReminders(db, messaging, docs, todayDate);
      totalSent += sent;
      totalSkipped += skipped;
      totalFailed += failed;

      if (docs.length < PAGE_SIZE) {
        break;
      }
      cursor = docs[docs.length - 1];
    }

    if (totalUsers === 0) {
      logger.info('No users at risk of losing streak');
      return;
    }

    logger.info(
      `Streak reminders complete: ${totalUsers} users, ` +
        `${totalSent} sent, ${totalSkipped} skipped, ` +
        `${totalFailed} failed`,
    );
  },
);
