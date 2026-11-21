import '../../../helpers/calculation_notes_i18n.dart';

void main() {
  calculationNotesI18nTests(
    'data/app/energy_behaviors.json',
    'behaviors',
    complete: true,
    exceptions: {
      'dishwasher_eco': {'15': '3h15 is written 3時間15分 / 3 h 15 min'},
      'led_bulb': {'8.5': 'the Philips spec is quoted in English'},
      'tv': {'50': 'ES glosses 50V型 as 50 pulgadas'},
    },
  );
}
