import { HttpsError } from 'firebase-functions/v2/https';
import {
  handleDeleteUserAccount,
} from '../deleteUserAccount';

const UID = 'user-123';

// --- Mock firebase-admin modules ---

function makeMocks() {
  const docRef = { path: `users/${UID}` };
  const doc = jest.fn(() => docRef);
  const collection = jest.fn(() => ({ doc }));
  const recursiveDelete = jest
    .fn()
    .mockResolvedValue(undefined);
  const db = {
    collection,
    recursiveDelete,
  } as unknown as FirebaseFirestore.Firestore;
  const deleteUser = jest
    .fn()
    .mockResolvedValue(undefined);
  const auth = { deleteUser };
  return {
    db,
    collection,
    doc,
    docRef,
    recursiveDelete,
    deleteUser,
    auth,
  };
}

async function expectHttpsError(
  promise: Promise<unknown>,
  code: string,
) {
  let caught: unknown;
  try {
    await promise;
    throw new Error('Expected promise to reject');
  } catch (err) {
    caught = err;
  }
  expect(caught).toBeInstanceOf(HttpsError);
  expect((caught as HttpsError).code).toBe(code);
}

// --- Tests ---

describe('handleDeleteUserAccount', () => {
  it('deletes Firestore data and the Auth user', async () => {
    const {
      db,
      collection,
      doc,
      docRef,
      recursiveDelete,
      deleteUser,
      auth,
    } = makeMocks();

    const result = await handleDeleteUserAccount(
      db,
      auth,
      UID,
    );

    expect(collection).toHaveBeenCalledWith('users');
    expect(doc).toHaveBeenCalledWith(UID);
    expect(recursiveDelete).toHaveBeenCalledWith(docRef);
    expect(deleteUser).toHaveBeenCalledWith(UID);
    expect(result).toEqual({ success: true });
  });

  it(
    'deletes Firestore data before the Auth user',
    async () => {
      const { db, recursiveDelete, deleteUser, auth } =
        makeMocks();

      await handleDeleteUserAccount(db, auth, UID);

      const deleteDataOrder =
        recursiveDelete.mock.invocationCallOrder[0];
      const deleteAuthOrder =
        deleteUser.mock.invocationCallOrder[0];
      expect(deleteDataOrder).toBeLessThan(
        deleteAuthOrder,
      );
    },
  );

  it('rejects unauthenticated calls', async () => {
    const { db, recursiveDelete, deleteUser, auth } =
      makeMocks();

    await expectHttpsError(
      handleDeleteUserAccount(db, auth, undefined),
      'unauthenticated',
    );

    expect(recursiveDelete).not.toHaveBeenCalled();
    expect(deleteUser).not.toHaveBeenCalled();
  });

  it(
    'keeps the Auth user when Firestore deletion fails',
    async () => {
      const { db, recursiveDelete, deleteUser, auth } =
        makeMocks();
      recursiveDelete.mockRejectedValue(
        new Error('Firestore unavailable'),
      );

      await expectHttpsError(
        handleDeleteUserAccount(db, auth, UID),
        'internal',
      );

      // Account stays intact so the client can retry.
      expect(deleteUser).not.toHaveBeenCalled();
    },
  );

  it(
    'treats auth/user-not-found as success',
    async () => {
      const { db, deleteUser, auth } = makeMocks();
      const error = new Error('No such user');
      (error as unknown as { code: string }).code =
        'auth/user-not-found';
      deleteUser.mockRejectedValue(error);

      const result = await handleDeleteUserAccount(
        db,
        auth,
        UID,
      );

      expect(result).toEqual({ success: true });
    },
  );

  it(
    'throws internal on other Auth deletion failures',
    async () => {
      const { db, deleteUser, auth } = makeMocks();
      const error = new Error('Auth backend down');
      (error as unknown as { code: string }).code =
        'auth/internal-error';
      deleteUser.mockRejectedValue(error);

      await expectHttpsError(
        handleDeleteUserAccount(db, auth, UID),
        'internal',
      );
    },
  );
});
