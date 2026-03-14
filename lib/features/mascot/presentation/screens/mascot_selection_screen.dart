import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/mascot/data/mascot_species_data.dart';
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

    final species = defaultMascotSpecies[_selectedSpeciesIndex];

    await ref.read(mascotProvider.notifier).selectMascot(
          speciesId: species.id,
          name: _nameController.text.trim(),
        );

    if (mounted) {
      // Navigate to home
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),

                // Title
                Text(
                  l10n.mascotSelectionTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  l10n.mascotSelectionSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Mascot preview
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Species selector (for when we have multiple species)
                        if (defaultMascotSpecies.length > 1)
                          _buildSpeciesSelector(locale),

                        // Mascot preview with first stage
                        MascotPreview(
                          assetPath: defaultMascotSpecies[_selectedSpeciesIndex]
                              .evolutionStages
                              .first
                              .assetPath,
                          size: 180,
                        ),

                        const SizedBox(height: 16),

                        // Species name and description
                        Text(
                          defaultMascotSpecies[_selectedSpeciesIndex]
                              .getName(locale),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          defaultMascotSpecies[_selectedSpeciesIndex]
                              .getDescription(locale),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.mascotNameRequired;
                    }
                    if (value.trim().length < 2) {
                      return l10n.mascotNameTooShort;
                    }
                    if (value.trim().length > 20) {
                      return l10n.mascotNameTooLong;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Submit button
                FilledButton(
                  onPressed: _isSubmitting ? null : _onSubmit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(l10n.mascotSelectionConfirm),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeciesSelector(String locale) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: defaultMascotSpecies.length,
        itemBuilder: (context, index) {
          final species = defaultMascotSpecies[index];
          final isSelected = index == _selectedSpeciesIndex;

          return GestureDetector(
            onTap: () => setState(() => _selectedSpeciesIndex = index),
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
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
                  MascotPreview(
                    assetPath: species.evolutionStages.first.assetPath,
                    size: 50,
                    animate: false,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    species.getName(locale),
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
