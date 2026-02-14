import { onSchedule } from 'firebase-functions/v2/scheduler';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';
import { getMessaging } from 'firebase-admin/messaging';
import { logger } from 'firebase-functions';

const SCHEDULE_CRON = '0 20 * * *'; // 8 PM UTC daily
const USERS_COLLECTION = 'users';
const BATCH_SIZE = 500;

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
 * Queries Firestore for users at risk of losing their streak.
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
) {
  const snapshot = await db
    .collection(USERS_COLLECTION)
    .where('notificationsEnabled', '==', true)
    .where('currentStreak', '>', 0)
    .where(
      'lastActionDate',
      '<',
      Timestamp.fromDate(todayStart),
    )
    .get();

  return snapshot.docs;
}

/**
 * Sends streak reminder notifications and cleans up
 * invalid FCM tokens.
 */
export async function sendReminders(
  db: FirebaseFirestore.Firestore,
  messaging: ReturnType<typeof getMessaging>,
  docs: FirebaseFirestore.QueryDocumentSnapshot[],
) {
  let sent = 0;
  let skipped = 0;
  let failed = 0;

  for (let i = 0; i < docs.length; i += BATCH_SIZE) {
    const batch = docs.slice(i, i + BATCH_SIZE);
    const results = await Promise.allSettled(
      batch.map(async (doc) => {
        const data = doc.data();
        const token: string | undefined = data.fcmToken;

        if (!token) {
          skipped++;
          return;
        }

        const language: string =
          data.language ?? DEFAULT_LANGUAGE;
        const streak: number = data.currentStreak ?? 0;
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

  return { sent, skipped, failed };
}

/** Scheduled Cloud Function: streak break reminder. */
export const sendStreakReminders = onSchedule(
  {
    schedule: SCHEDULE_CRON,
    timeZone: 'UTC',
    retryCount: 1,
    memory: '256MiB',
  },
  async () => {
    const db = getFirestore();
    const messaging = getMessaging();

    const todayStart = new Date();
    todayStart.setUTCHours(0, 0, 0, 0);

    logger.info(
      `Running streak reminders for ${todayStart.toISOString()}`,
    );

    const docs = await getUsersAtRisk(db, todayStart);

    if (docs.length === 0) {
      logger.info('No users at risk of losing streak');
      return;
    }

    logger.info(`Found ${docs.length} users at risk`);

    const { sent, skipped, failed } = await sendReminders(
      db,
      messaging,
      docs,
    );

    logger.info(
      `Streak reminders complete: ` +
        `${sent} sent, ${skipped} skipped, ${failed} failed`,
    );
  },
);
