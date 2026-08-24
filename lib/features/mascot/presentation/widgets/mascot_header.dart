import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';

/// Mascot name (with inline rename) and stage badge shown inside the
/// housing card on the mascot screen.
class MascotHeader extends ConsumerStatefulWidget {
  const MascotHeader({
    required this.name,
    required this.stageName,
    required this.mascotLevel,
    super.key,
  });

  final String name;
  final String stageName;
  final int mascotLevel;

  @override
  ConsumerState<MascotHeader> createState() => _MascotHeaderState();
}

class _MascotHeaderState extends ConsumerState<MascotHeader>
    with AutomaticKeepAliveClientMixin {
  bool _isRenaming = false;
  final _renameController = TextEditingController();
  final _renameFormKey = GlobalKey<FormState>();

  // Keeps an in-progress rename alive when the header scrolls out of
  // the sliver's cache extent.
  @override
  bool get wantKeepAlive => _isRenaming;

  void _setRenaming(bool value) {
    setState(() => _isRenaming = value);
    updateKeepAlive();
  }

  @override
  void dispose() {
    _renameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        _buildNameSection(widget.name, colorScheme),
        const SizedBox(height: spacingSm),
        _buildStageBadge(colorScheme),
      ],
    );
  }

  Widget _buildNameSection(String name, ColorScheme colorScheme) {
    if (_isRenaming) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 150,
            child: Form(
              key: _renameFormKey,
              child: TextFormField(
                controller: _renameController,
                autofocus: true,
                textAlign: TextAlign.center,
                maxLength: AppConstants.maxMascotNameLength,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: spacingMd,
                    vertical: spacingSm,
                  ),
                  border: OutlineInputBorder(borderRadius: borderRadiusSm),
                ),
                validator: (value) {
                  final l10n = AppLocalizations.of(context);
                  if (value == null || value.trim().isEmpty) {
                    return l10n.mascotNameRequired;
                  }
                  if (value.trim().length > AppConstants.maxMascotNameLength) {
                    return l10n.mascotNameTooLong;
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(width: spacingSm),
          IconButton(
            onPressed: _submitRename,
            icon: Icon(Icons.check, color: colorScheme.primary),
          ),
          IconButton(
            onPressed: _cancelRename,
            icon: Icon(Icons.close, color: colorScheme.error),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: spacingSm),
        IconButton(
          onPressed: _startRename,
          icon: Icon(Icons.edit, size: 20, color: colorScheme.onSurfaceVariant),
          tooltip: AppLocalizations.of(context).mascotRename,
        ),
      ],
    );
  }

  void _startRename() {
    _renameController.text = widget.name;
    _setRenaming(true);
  }

  void _cancelRename() {
    _setRenaming(false);
  }

  Future<void> _submitRename() async {
    // Surfaces mascotNameRequired/mascotNameTooLong inline instead of
    // silently ignoring the tap.
    if (!(_renameFormKey.currentState?.validate() ?? false)) {
      return;
    }
    final newName = _renameController.text.trim();

    await ref.read(mascotProvider.notifier).renameMascot(newName);
    if (mounted) _setRenaming(false);
  }

  Widget _buildStageBadge(ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: spacingLg,
        vertical: spacingSm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: borderRadiusXl,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 18, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            '${widget.stageName}'
            ' - ${l10n.levelLabel(widget.mascotLevel)}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
