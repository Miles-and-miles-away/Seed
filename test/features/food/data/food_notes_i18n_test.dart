import '../../../helpers/calculation_notes_i18n.dart';

void main() {
  calculationNotesI18nTests(
    'data/app/food_items.json',
    'items',
    complete: true,
    exceptions: {
      'tea': {'3103': 'ISO 3103 is a standard number, not 3.103 in ES'},
      'cocoa_powder': {'18100': 'Agribalyse row 18100 is a code, not 18.100'},
      'coconut_oil': {'3.2': 'v3.2 in the verbatim AGRIBALYSE credit'},
    },
  );
}
