import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/services/analytics_service.dart';

import '../../helpers/test_helpers.dart';

const walkthroughTestUid = 'walkthrough-user';

class RecordingWalkthroughAnalytics extends Fake implements AnalyticsService {
  final events = <String>[];

  @override
  Future<void> logWalkthroughItemFound({required String item}) async =>
      events.add('found:$item');

  @override
  Future<void> logWalkthroughCompleted() async => events.add('completed');

  @override
  Future<void> logWalkthroughReset() async => events.add('reset');
}

UserSettingsModel settingsWith(Iterable<WalkthroughItem> found) =>
    UserSettingsModel(walkthroughFound: [for (final i in found) i.name]);

/// A signed-in user with a mascot and no celebration pending, so the
/// walkthrough is live and driven entirely by [settings].
List<Override> walkthroughOverrides({
  required Stream<UserSettingsModel> settings,
  AppUserModel user = const AppUserModel(uid: walkthroughTestUid, email: 'e'),
  FakeFirebaseFirestore? firestore,
  AnalyticsService? analytics,
  bool hasMascot = true,
  bool hasNewEvolution = false,
  bool eggPending = false,
  bool signedIn = true,
}) => [
  if (firestore != null) firestoreProvider.overrideWithValue(firestore),
  userIdProvider.overrideWith((_) => signedIn ? user.uid : null),
  userOverride(user),
  userSettingsProvider.overrideWith((_) => settings),
  hasMascotProvider.overrideWithValue(hasMascot),
  hasNewEvolutionProvider.overrideWithValue(hasNewEvolution),
  shouldShowEggDiscoveryProvider.overrideWithValue(eggPending),
  activeMascotProvider.overrideWith(
    (_) => Stream.value(
      const MascotModel(id: 'm', speciesId: 'seed', name: 'Pip'),
    ),
  ),
  activeMascotAssetPathProvider.overrideWith((_) => null),
  if (analytics != null) analyticsServiceProvider.overrideWithValue(analytics),
];

/// Keeps the current-user stream warm the way the app's always-mounted
/// screens do, so the settings notifier's synchronous read sees a user.
class WarmUser extends ConsumerWidget {
  const WarmUser({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(currentUserProvider);
    return child;
  }
}

/// Unmounts the tree and lets the overlay's animation and confetti timers
/// run out before the framework checks for pending timers.
Future<void> flushOverlayTimers(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(seconds: 1));
  }
}

/// Lets a fake Firestore write settle: its futures ride the fake clock.
Future<void> settleWrites(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// The stored found list, read with a one-shot get rather than a snapshot
/// stream, which cannot be cancelled cleanly under the fake clock.
Future<List<String>> foundInFirestore(
  FakeFirebaseFirestore firestore,
  String uid,
) async {
  final doc = await firestore
      .collection(AppConstants.collectionUsers)
      .doc(uid)
      .get();
  final settings = doc.data()?[AppConstants.fieldSettings];
  if (settings is! Map) return const [];
  final found = settings[AppConstants.fieldWalkthroughFound];
  return found is List ? found.cast<String>() : const [];
}
