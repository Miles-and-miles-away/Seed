import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/shared/models/custom_action_model.dart';

/// FNV-1a 64-bit offset basis and prime (canonical constants).
const int _kFnvOffset = 0xcbf29ce484222325;
const int _kFnvPrime = 0x100000001b3;

/// Persists user-created actions banked from a calculator comparison
/// (Phase 8) under `users/{uid}/customActions`. A template must exist
/// before its log is written: the relaxed actionLog rule validates the
/// log's points and co2Grams against the stored template.
class CustomActionRepository {
  const CustomActionRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) =>
      _firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .collection(AppConstants.collectionCustomActions);

  /// Ensures a template for [action] exists and returns it with its id.
  ///
  /// The id is a stable content hash, so re-banking an identical choice
  /// reuses one template instead of minting a fresh doc every time. That
  /// keeps the log's `actionId` (and thus the user's `uniqueActionIds`
  /// set) from inflating on repeats, and leaves at most one orphan per
  /// distinct choice if a later log fails. Templates are immutable
  /// (`allow update: if false`), so an existing one is reused as-is
  /// rather than rewritten.
  Future<CustomAction> create(String userId, CustomAction action) async {
    final id = _stableId(action);
    final ref = _collection(userId).doc(id);
    final withId = action.copyWith(id: id);
    final existing = await ref.get();
    if (!existing.exists) {
      final data = withId.toJson()
        ..remove('id')
        ..['createdAt'] = FieldValue.serverTimestamp();
      await ref.set(data);
    }
    return withId;
  }

  /// Deterministic doc id from the fields that define a template's
  /// logging fingerprint (name, co2, points). Pure-Dart FNV-1a so it is
  /// stable across runs -- `String.hashCode` is not.
  String _stableId(CustomAction action) {
    final canonical = '${action.name}|${action.co2Grams}|${action.points}';
    var hash = _kFnvOffset;
    for (final byte in utf8.encode(canonical)) {
      hash ^= byte;
      hash *= _kFnvPrime; // wraps at 64 bits (AOT/native ints)
    }
    return hash.toUnsigned(64).toRadixString(16);
  }
}
