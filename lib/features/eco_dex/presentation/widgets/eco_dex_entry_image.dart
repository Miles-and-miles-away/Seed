import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';

/// Displays the SVG for an Eco-Dex entry when available, or a blank
/// white placeholder when the asset has not yet been produced.
class EcoDexEntryImage extends ConsumerWidget {
  const EcoDexEntryImage({
    required this.iconName,
    required this.size,
    super.key,
  });

  final String iconName;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icons = ref.watch(ecoDexAvailableIconsProvider).value;
    final hasAsset = icons?.contains(iconName) ?? false;

    if (hasAsset) {
      return SvgPicture.asset(
        '$ecoDexAssetPrefix$iconName$ecoDexAssetExt',
        width: size,
        height: size,
      );
    }

    return Container(
      width: size,
      height: size,
      color: Colors.white,
    );
  }
}
