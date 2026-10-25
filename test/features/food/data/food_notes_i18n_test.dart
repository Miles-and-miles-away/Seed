import '../../../helpers/calculation_notes_i18n.dart';

// Batches land in file order; each raises this to the notes now translated.
const _translatedFloor = 85;

void main() {
  calculationNotesI18nTests(
    'data/app/food_items.json',
    'items',
    complete: false,
    minTranslated: _translatedFloor,
  );
}
