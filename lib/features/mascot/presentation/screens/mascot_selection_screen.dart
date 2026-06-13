import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import '../providers/mascot_providers.dart';
import '../widgets/mascot_display.dart';

/// Screen for new users to select and name their mascot.
///
/// This is shown after account creation if the user doesn't have a mascot yet.
class MascotSelectionScreen extends ConsumerStatefulWidget {
  const MascotSelectionScreen({super.key});

  @override
  ConsumerState<MascotSelectionScreen> createState() =>
      _MascotSelectionScreenState();
}

class _MascotSelectionScreenState extends ConsumerState<MascotSelectionScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedSpeciesIndex = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final speciesList = ref
        .read(
          mascotSpeciesDataProvider,
        )
        .value;
    if (speciesList == null) return;

    final species = speciesList[_selectedSpeciesIndex];

    await ref.read(mascotProvider.notifier).selectMascot(
          speciesId: species.id,
          name: _nameController.text.trim(),
        );

    if (mounted) {
      // Navigate to home
      context.go(appRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final speciesAsync = ref.watch(mascotSpeciesDataProvider);
    final speciesList = speciesAsync.value;

    if (speciesList == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(spacingXxl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: spacingXxl),

                // Title
                Text(
                  l10n.mascotSelectionTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacingSm),

                // Subtitle
                Text(
                  l10n.mascotSelectionSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: spacingXxxl),

                // Mascot preview
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Species selector (for multiple species)
                        if (speciesList.length > 1)
                          _buildSpeciesSelector(locale, speciesList),

                        // Mascot preview with first stage
                        MascotAvatar(
                          assetPath: speciesList[_selectedSpeciesIndex]
                              .evolutionStages
                              .first
                              .assetPath,
                          size: 180,
                        ),

                        const SizedBox(height: spacingLg),

                        // Species name and description
                        Text(
                          speciesList[_selectedSpeciesIndex].name(locale),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: spacingSm),
                        Text(
                          speciesList[_selectedSpeciesIndex]
                              .description(locale),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Name input
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.mascotNameLabel,
                    hintText: l10n.mascotNameHint,
                    prefixIcon: const Icon(Icons.edit),
                    border: OutlineInputBorder(
                      borderRadius: borderRadiusMd,
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.mascotNameRequired;
                    }
                    if (value.trim().length >
                        AppConstants.maxMascotNameLength) {
                      return l10n.mascotNameTooLong;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: spacingXxl),

                // Submit button
                FilledButton(
                  onPressed: _isSubmitting ? null : _onSubmit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: spacingLg,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: borderRadiusMd,
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: spacingXxl,
                          height: spacingXxl,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(l10n.mascotSelectionConfirm),
                ),

                const SizedBox(height: spacingLg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeciesSelector(
    String locale,
    List<MascotSpeciesModel> speciesList,
  ) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: speciesList.length,
        itemBuilder: (context, index) {
          final species = speciesList[index];
          final isSelected = index == _selectedSpeciesIndex;

          return GestureDetector(
            onTap: () => setState(() => _selectedSpeciesIndex = index),
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(
                horizontal: spacingSm,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: borderRadiusMd,
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MascotAvatar(
                    assetPath: species.evolutionStages.first.assetPath,
                    size: 50,
                    animate: false,
                  ),
                  const SizedBox(height: spacingXs),
                  Text(
                    species.name(locale),
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
