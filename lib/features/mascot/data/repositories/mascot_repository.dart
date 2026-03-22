import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:uuid/uuid.dart';
import '../models/egg_model.dart';
import '../models/mascot_model.dart';

const _uuid = Uuid();

/// Repository for mascot-related data operations.
///
/// Handles CRUD for multi-mascot array and egg system.
class MascotRepository {
  MascotRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(
    String userId,
  ) =>
      _firestore.collection(AppConstants.collectionUsers).doc(userId);

  // =========================================================
  // Multi-mascot operations
  // =========================================================

  /// Streams all mascots for a user.
  Stream<List<MascotModel>> watchAllMascots(String userId) {
    return _userDoc(userId).snapshots().map((doc) {
      final data = doc.data();
      if (data == null || !data.containsKey(AppConstants.fieldMascots)) {
        return <MascotModel>[];
      }
      final list = data[AppConstants.fieldMascots] as List<dynamic>? ?? [];
      return list
          .map(
            (e) => MascotModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
    });
  }

  /// Streams the active mascot for a user.
  Stream<MascotModel?> watchActiveMascot(String userId) {
    return _userDoc(userId).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return null;
      final activeId = data[AppConstants.fieldActiveMascotId] as String?;
      if (activeId == null) return null;
      final list = data[AppConstants.fieldMascots] as List<dynamic>? ?? [];
      for (final item in list) {
        final map = Map<String, dynamic>.from(item as Map);
        if (map[AppConstants.fieldId] == activeId) {
          return MascotModel.fromJson(map);
        }
      }
      return null;
    });
  }

  /// Streams the user's egg.
  Stream<EggModel?> watchEgg(String userId) {
    return _userDoc(userId).snapshots().map((doc) {
      final data = doc.data();
      if (data == null || data[AppConstants.fieldEgg] == null) {
        return null;
      }
      return EggModel.fromJson(
        Map<String, dynamic>.from(
          data[AppConstants.fieldEgg] as Map,
        ),
      );
    });
  }

  /// Whether the user has any mascot in the array.
  Stream<bool> watchHasMascot(String userId) {
    return _userDoc(userId).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return false;
      final list = data[AppConstants.fieldMascots] as List<dynamic>? ?? [];
      return list.isNotEmpty;
    });
  }

  /// Adds a mascot to the user's array.
  Future<void> addMascot(
    String userId,
    MascotModel mascot,
  ) async {
    await _userDoc(userId).update({
      AppConstants.fieldMascots: FieldValue.arrayUnion([mascot.toJson()]),
      AppConstants.fieldActiveMascotId: mascot.id,
    });
  }

  /// Sets the active mascot by ID.
  Future<void> setActiveMascot(
    String userId,
    String mascotId,
  ) async {
    await _userDoc(userId).update({
      AppConstants.fieldActiveMascotId: mascotId,
    });
  }

  /// Updates a single mascot in the array via transaction.
  Future<void> updateMascotInArray(
    String userId,
    MascotModel updated,
  ) async {
    final ref = _userDoc(userId);
    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(ref);
      final data = doc.data() ?? {};
      final list = (data[AppConstants.fieldMascots] as List<dynamic>? ?? [])
          .map(
            (e) => Map<String, dynamic>.from(e as Map),
          )
          .toList();

      final idx = list.indexWhere(
        (m) => m[AppConstants.fieldId] == updated.id,
      );
      if (idx == -1) return;
      list[idx] = updated.toJson();
      tx.update(ref, {AppConstants.fieldMascots: list});
    });
  }

  /// Updates the last seen stage for a mascot in the array.
  Future<void> updateLastSeenStage(
    String userId,
    String mascotId,
    int stage,
  ) async {
    final ref = _userDoc(userId);
    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(ref);
      final data = doc.data() ?? {};
      final list = (data[AppConstants.fieldMascots] as List<dynamic>? ?? [])
          .map(
            (e) => Map<String, dynamic>.from(e as Map),
          )
          .toList();

      final idx = list.indexWhere(
        (m) => m[AppConstants.fieldId] == mascotId,
      );
      if (idx == -1) return;
      list[idx][AppConstants.fieldLastSeenStage] = stage;
      tx.update(ref, {AppConstants.fieldMascots: list});
    });
  }

  /// Renames a mascot in the array.
  Future<void> updateMascotName(
    String userId,
    String mascotId,
    String name,
  ) async {
    final ref = _userDoc(userId);
    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(ref);
      final data = doc.data() ?? {};
      final list = (data[AppConstants.fieldMascots] as List<dynamic>? ?? [])
          .map(
            (e) => Map<String, dynamic>.from(e as Map),
          )
          .toList();

      final idx = list.indexWhere(
        (m) => m[AppConstants.fieldId] == mascotId,
      );
      if (idx == -1) return;
      list[idx][AppConstants.fieldName] = name;
      tx.update(ref, {AppConstants.fieldMascots: list});
    });
  }

  /// Creates an egg for the user.
  Future<void> createEgg(String userId, EggModel egg) async {
    await _userDoc(userId).update({
      AppConstants.fieldEgg: egg.toJson(),
      AppConstants.fieldEggPendingDiscovery: false,
      AppConstants.fieldEggPendingDiscoverySince: FieldValue.delete(),
    });
  }

  /// Removes the egg from the user.
  Future<void> removeEgg(String userId) async {
    await _userDoc(userId).update({
      AppConstants.fieldEgg: FieldValue.delete(),
    });
  }

  /// Clears the egg pending discovery flag.
  Future<void> clearEggPendingDiscovery(
    String userId,
  ) async {
    await _userDoc(userId).update({
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
    final mascot = MascotModel(
      id: _uuid.v4(),
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
