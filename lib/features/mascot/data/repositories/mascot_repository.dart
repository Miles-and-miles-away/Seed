import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../mascot_species_data.dart';
import '../models/mascot_model.dart';
import '../models/mascot_species_model.dart';

/// Repository for mascot-related data operations.
///
/// Handles CRUD operations for user mascots and species data.
class MascotRepository {
  MascotRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Gets the users collection reference.
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection(AppConstants.collectionUsers);

  /// Streams the user's mascot data.
  ///
  /// Returns `null` if the user has no mascot selected yet.
  Stream<MascotModel?> watchUserMascot(String userId) {
    return _usersCollection.doc(userId).snapshots().map((doc) {
      final data = doc.data();
      if (data == null || !data.containsKey('mascot') || data['mascot'] == null) {
        return null;
      }
      return MascotModel.fromJson(data['mascot'] as Map<String, dynamic>);
    });
  }

  /// Gets the user's mascot data once.
  Future<MascotModel?> getUserMascot(String userId) async {
    final doc = await _usersCollection.doc(userId).get();
    final data = doc.data();
    if (data == null || !data.containsKey('mascot') || data['mascot'] == null) {
      return null;
    }
    return MascotModel.fromJson(data['mascot'] as Map<String, dynamic>);
  }

  /// Creates or updates the user's mascot.
  Future<void> setUserMascot(String userId, MascotModel mascot) async {
    await _usersCollection.doc(userId).update({
      'mascot': mascot.toJson(),
    });
  }

  /// Updates only the mascot name.
  Future<void> updateMascotName(String userId, String name) async {
    await _usersCollection.doc(userId).update({
      'mascot.name': name,
    });
  }

  /// Updates the last seen evolution stage.
  Future<void> updateLastSeenStage(String userId, int stage) async {
    await _usersCollection.doc(userId).update({
      'mascot.lastSeenStage': stage,
    });
  }

  /// Selects a mascot for a new user (creates the mascot field).
  Future<void> selectMascot({
    required String userId,
    required String speciesId,
    required String name,
  }) async {
    final mascot = MascotModel(
      speciesId: speciesId,
      name: name,
      createdAt: DateTime.now(),
    );

    await _usersCollection.doc(userId).update({
      'mascot': mascot.toJson(),
    });
  }

  /// Gets all available mascot species.
  ///
  /// Currently uses hardcoded data. In the future, this will fetch from
  /// the `mascotSpecies` Firestore collection.
  Future<List<MascotSpeciesModel>> getAllSpecies() async {
    // For MVP, return hardcoded species data
    // TODO: Fetch from Firestore in Phase 4 when adding more species
    return defaultMascotSpecies;
  }

  /// Gets a specific mascot species by ID.
  Future<MascotSpeciesModel?> getSpecies(String speciesId) async {
    // For MVP, return hardcoded species data
    return getSpeciesById(speciesId);
  }

  /// Checks if a user has selected a mascot.
  Future<bool> hasMascot(String userId) async {
    final mascot = await getUserMascot(userId);
    return mascot != null;
  }
}
