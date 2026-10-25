import '../../../helpers/calculation_notes_i18n.dart';

// Each food translation batch raises this to the notes it has landed.
const _translatedFloor = 0;

void main() {
  calculationNotesI18nTests(
    'data/app/food_items.json',
    'items',
    complete: false,
    minTranslated: _translatedFloor,
  );
}
