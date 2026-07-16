import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';

/// Combined state of an entry with its discovery status.
class EcoDexEntryState {
  const EcoDexEntryState({required this.entry, required this.isDiscovered});

  final EcoDexEntry entry;
  final bool isDiscovered;
}
