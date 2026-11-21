import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// AppBar action that opens Settings, shared by Home and Profile.
class SettingsIconButton extends StatelessWidget {
  const SettingsIconButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    icon: const Icon(Icons.settings_outlined),
    tooltip: AppLocalizations.of(context).settingsTitle,
    onPressed: () => context.push(appRoutes.settings),
  );
}
