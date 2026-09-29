import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import '../walkthrough_items.dart';

part 'walkthrough_providers.g.dart';

/// Whether [item] still shimmers and pops. Nothing is pending until the
/// mascot exists and its celebrations are done (the character does the
/// talking), and no checklist item is pending before the intro.
@riverpod
bool walkthroughPending(Ref ref, WalkthroughItem item) {
  if (!ref.watch(hasMascotProvider) ||
      ref.watch(hasNewEvolutionProvider) ||
      ref.watch(shouldShowEggDiscoveryProvider)) {
    return false;
  }
  final found = ref.watch(walkthroughFoundProvider);
  if (found == null || found.contains(item.name)) return false;
  return item == WalkthroughItem.intro ||
      found.contains(WalkthroughItem.intro.name);
}
