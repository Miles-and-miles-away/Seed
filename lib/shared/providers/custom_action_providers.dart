import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/shared/data/custom_action_repository.dart';

part 'custom_action_providers.g.dart';

/// Repository for banking user-created calculator actions (Phase 8).
/// Shared by every calculator's choice logger (transport, food).
@riverpod
CustomActionRepository customActionRepository(Ref ref) =>
    CustomActionRepository(FirebaseFirestore.instance);
