import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import '../models/egg_model.dart';
import '../models/mascot_model.dart';

/// Repository for mascot-related data operations.
///
/// Handles CRUD for multi-mascot array and egg system.
class MascotRepository {
  MascotRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String userId) =>
      _firestore.collection(AppConstants.collectionUsers).doc(userId);

  // =========================================================
  // Multi-mascot operations
  // =========================================================

  // NOTE: mascots, the active mascot, and the egg are derived from
  // the user document already streamed by currentUserProvider;
  // dedicated watchers here would duplicate that listener.

  /// Sets the active mascot by ID.
  Future<void> setActiveMascot(String userId, String mascotId) async {
    await _userDoc(userId).update({AppConstants.fieldActiveMascotId: mascotId});
  }

  /// Applies [apply] to [mascotId]'s entry in the mascots array inside a
  /// transaction; a no-op when the mascot is missing.
  Future<void> _mutateMascot(
    String userId,
    String mascotId,
    void Function(Map<String, dynamic> mascot) apply,
  ) async {
    final ref = _userDoc(userId);
    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(ref);
      final data = doc.data() ?? {};
      final list = (data[AppConstants.fieldMascots] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      final idx = list.indexWhere((m) => m[AppConstants.fieldId] == mascotId);
      if (idx == -1) return;
      apply(list[idx]);
      tx.update(ref, {AppConstants.fieldMascots: list});
    });
  }

  /// Updates the last seen stage for a mascot in the array.
  Future<void> updateLastSeenStage(String userId, String mascotId, int stage) =>
      _mutateMascot(
        userId,
        mascotId,
        (m) => m[AppConstants.fieldLastSeenStage] = stage,
      );

  /// Renames a mascot in the array.
  Future<void> updateMascotName(String userId, String mascotId, String name) =>
      _mutateMascot(userId, mascotId, (m) => m[AppConstants.fieldName] = name);

  /// Creates an egg for the user.
  Future<void> createEgg(String userId, EggModel egg) async {
    await _userDoc(userId).update({
      AppConstants.fieldEgg: egg.toJson(),
      AppConstants.fieldEggPendingDiscovery: false,
      AppConstants.fieldEggPendingDiscoverySince: FieldValue.delete(),
    });
  }

  // =========================================================
  // Mascot selection (first-time setup)
  // =========================================================

  /// Selects a mascot for a new user.
  Future<void> selectMascot({
    required String userId,
    required String speciesId,
    required String name,
  }) async {
    // Firestore auto-ID minted client-side (no network call).
    final mascot = MascotModel(
      id: _firestore.collection(AppConstants.collectionUsers).doc().id,
      speciesId: speciesId,
      name: name,
      createdAt: DateTime.now(),
    );

    await _userDoc(userId).update({
      AppConstants.fieldMascots: [mascot.toJson()],
      AppConstants.fieldActiveMascotId: mascot.id,
    });
  }
}
