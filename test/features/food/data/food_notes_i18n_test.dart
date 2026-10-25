import '../../../helpers/calculation_notes_i18n.dart';

// Batches land in file order; each raises this to the notes now translated.
const _translatedFloor = 125;

void main() {
  calculationNotesI18nTests(
    'data/app/food_items.json',
    'items',
    complete: false,
    minTranslated: _translatedFloor,
    exceptions: {
      'tea': {'3103': 'ISO 3103 is a standard number, not 3.103 in ES'},
      'cocoa_powder': {'18100': 'Agribalyse row 18100 is a code, not 18.100'},
    },
  );
}
