import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/helpers.dart';

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
    final userRef = _firestore
        .collection(AppConstants.collectionUsers)
        .doc(userId);

    await _firestore.runTransaction((tx) async {
      final doc = await tx.get(userRef);
      final data = doc.data();
      if (data == null) return;

      // Already migrated or no mascot to migrate
      if (data.containsKey('mascots') &&
          data['mascots'] is List &&
          (data['mascots'] as List).isNotEmpty) {
        return;
      }

      final oldMascot = data['mascot'];
      if (oldMascot == null || oldMascot is! Map) return;

      final mascotMap =
          Map<String, dynamic>.from(oldMascot);

      // Generate ID and copy global stats to mascot
      final userPoints = (data['points'] as int?) ?? 0;
      final mascotLevel = calculateLevel(userPoints);
      final mascotId = _uuid.v4();

      mascotMap['id'] = mascotId;
      mascotMap['mascotPoints'] = userPoints;
      mascotMap['mascotLevel'] = mascotLevel;
      mascotMap['isFullyEvolved'] =
          mascotLevel >= AppConstants.maxEvolutionLevel;

      tx.update(userRef, {
        'mascots': [mascotMap],
        'activeMascotId': mascotId,
        'mascot': FieldValue.delete(),
      });
    });
  }
}
