import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Migrates old single-mascot user data to the new
/// multi-mascot array format. Idempotent and safe to
/// run multiple times.
class MascotMigrationService {
  MascotMigrationService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Checks and migrates user if they have old `mascot` field
  /// but no `mascots` array.
  Future<void> migrateIfNeeded(String userId) async {
    final userRef =
        _firestore.collection(AppConstants.collectionUsers).doc(userId);

    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(userRef);
      final data = doc.data();
      if (data == null) return;

      // Already migrated or no mascot to migrate
      if (data.containsKey(AppConstants.fieldMascots) &&
          data[AppConstants.fieldMascots] is List &&
          (data[AppConstants.fieldMascots] as List).isNotEmpty) {
        return;
      }

      final oldMascot = data['mascot'];
      if (oldMascot == null || oldMascot is! Map) return;

      final mascotMap = Map<String, dynamic>.from(oldMascot);

      // Generate ID and copy global stats to mascot
      final userPoints = (data[AppConstants.fieldPoints] as int?) ?? 0;
      final mascotLevel = calculateLevel(userPoints);
      final mascotId = _uuid.v4();

      mascotMap[AppConstants.fieldId] = mascotId;
      mascotMap[AppConstants.fieldMascotPoints] = userPoints;
      mascotMap[AppConstants.fieldMascotLevel] = mascotLevel;
      mascotMap[AppConstants.fieldIsFullyEvolved] =
          mascotLevel >= AppConstants.maxEvolutionLevel;

      tx.update(userRef, {
        AppConstants.fieldMascots: [mascotMap],
        AppConstants.fieldActiveMascotId: mascotId,
        'mascot': FieldValue.delete(),
      });
    });
  }
}
