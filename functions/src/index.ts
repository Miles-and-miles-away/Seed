import { initializeApp } from 'firebase-admin/app';

initializeApp();

export { cleanupUnverifiedUsers } from './cleanupUnverifiedUsers';
export { deleteUserAccount } from './deleteUserAccount';
