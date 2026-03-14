import { initializeApp } from 'firebase-admin/app';

initializeApp();

export { sendStreakReminders } from './streakReminder';
export {
  validateActionPoints,
} from './validateActionPoints';
