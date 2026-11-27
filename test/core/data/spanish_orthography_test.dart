import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/helpers.dart';

/// Words once shipped unaccented; bare forms that are words (mas) left out.
const _accentedForms = [
  'acuáticos',
  'acuíferos',
  'agrícola',
  'agrícolas',
  'aquí',
  'aritmética',
  'armonía',
  'artículos',
  'autobús',
  'avión',
  'añadido',
  'añadir',
  'baño',
  'biodiésel',
  'básicos',
  'calefacción',
  'cartón',
  'champú',
  'científicos',
  'ciudadanía',
  'climática',
  'climático',
  'cocción',
  'contemporáneas',
  'contraídas',
  'créditos',
  'después',
  'división',
  'diésel',
  'día',
  'dólares',
  'ecología',
  'ecológica',
  'ecológicamente',
  'ecológico',
  'económicas',
  'económicos',
  'electrónica',
  'electrónicos',
  'eléctrica',
  'eléctrico',
  'energética',
  'energéticas',
  'energéticos',
  'energía',
  'enseñanza',
  'enseñar',
  'estén',
  'evaporación',
  'exóticas',
  'fabricación',
  'fenómenos',
  'fría',
  'genética',
  'genéticos',
  'habitación',
  'halógena',
  'hincapié',
  'hábitats',
  'hábitos',
  'hídricos',
  'ilícitas',
  'indígenas',
  'jabón',
  'jardín',
  'jurídica',
  'jóvenes',
  'macroeconómica',
  'mañana',
  'meteorológicos',
  'micropréstamo',
  'micropréstamos',
  'millón',
  'minorías',
  'montañosos',
  'mínimos',
  'ningún',
  'niñas',
  'niño',
  'opción',
  'organización',
  'país',
  'países',
  'pequeñas',
  'pequeños',
  'petición',
  'plástica',
  'plástico',
  'política',
  'políticas',
  'portátil',
  'prácticos',
  'públicos',
  'químicos',
  'recién',
  'recolección',
  'reseña',
  'reunión',
  'reúsa',
  'ríos',
  'según',
  'sequía',
  'sequías',
  'sesión',
  'sólido',
  'sólidos',
  'también',
  'tecnología',
  'tecnologías',
  'tecnológica',
  'tecnológico',
  'teóricos',
  'través',
  'técnica',
  'técnicas',
  'técnico',
  'vehículo',
  'vínculos',
  'ámbitos',
  'árbol',
  'áridas',
  'índole',
];

final _bareToAccented = {
  for (final word in _accentedForms) foldForSearch(word): word,
};

final _bareWord = RegExp(
  '(?<!\\p{L})(${_bareToAccented.keys.join('|')})(?!\\p{L})',
  caseSensitive: false,
  unicode: true,
);

/// "9,500": es-ES groups thousands with a period. "0,125" is a decimal.
final _commaThousands = RegExp(r'(?<![\d.,])[1-9]\d{0,2},\d{3}(?![\d,])');

/// "2.7": es-ES writes the decimal with a comma. "2.700" is a grouping.
final _periodDecimal = RegExp(r'(?<![\d.,])\d+\.\d{1,2}(?!\d)');

final _latinAmericanLexis = RegExp(
  r'(?<!\p{L})(autos?|costos?|carne de res|refrigerador(es)?|computadoras?'
  r'|empaques?|celular(es)?)(?!\p{L})',
  caseSensitive: false,
  unicode: true,
);

/// UN text, kept for a pass against the official Spanish wording.
const _lexisExempt = 'data/app/sdg_targets.json';

const _files = [
  'data/seed/co2_actions_database.json',
  'data/app/challenge_templates.json',
  'data/app/eco_dex_entries.json',
  'data/app/eco_facts.json',
  'data/app/energy_behaviors.json',
  'data/app/food_items.json',
  'data/app/mascot_species.json',
  'data/app/sdg_goals.json',
  'data/app/sdg_resources.json',
  'data/app/sdg_targets.json',
  'data/app/transport_modes.json',
];

final _spanishKey = RegExp(r'(_es|Es)$');

/// Verbatim sources, URLs and aliases are not prose.
final _excludedKey = RegExp('^(source|quote|search_terms_)|[Uu]rl');

/// Notes cite section numbers and sources such as Which?, checked against EN.
bool _isNote(_Field field) => field.path.contains('calculation_notes');

typedef _Field = ({String file, String path, String text});

void _collect(Object? node, String file, String path, List<_Field> out) {
  if (node is Map<String, dynamic>) {
    for (final MapEntry(:key, :value) in node.entries) {
      if (value is String) {
        if (_spanishKey.hasMatch(key) && !_excludedKey.hasMatch(key)) {
          out.add((file: file, path: '$path.$key', text: value));
        }
      } else {
        _collect(value, file, '$path.${node['id'] ?? key}', out);
      }
    }
  } else if (node is List<dynamic>) {
    for (final (i, item) in node.indexed) {
      final id = item is Map<String, dynamic>
          ? item['id'] ?? item['action_id'] ?? item['code'] ?? item['dayOfYear']
          : null;
      _collect(item, file, '$path[${id ?? i}]', out);
    }
  }
}

List<String> _hits(List<_Field> fields, String Function(_Field) check) => [
  for (final field in fields)
    if (check(field) case final hit when hit.isNotEmpty)
      '${field.file}${field.path}: $hit',
];

void main() {
  final fields = <_Field>[];
  for (final file in _files) {
    _collect(jsonDecode(File(file).readAsStringSync()), file, '', fields);
  }

  test('the scope reaches every displayed Spanish field', () {
    expect(fields.where((f) => f.path.endsWith('.name_es')), isNotEmpty);
    expect(fields.where((f) => f.path.endsWith('.descriptionEs')), isNotEmpty);
    expect(fields.where(_isNote), isNotEmpty);
    expect(fields.where((f) => f.path.contains('.source')), isEmpty);
  });

  test('the patterns catch the defects they guard', () {
    expect(_bareWord.hasMatch('Reciclar Carton'), isTrue);
    expect(_bareWord.hasMatch('Reciclar cartón, ébano'), isFalse);
    expect(_commaThousands.hasMatch('9,500 millones'), isTrue);
    expect(_commaThousands.hasMatch('0,125 kg'), isFalse);
    expect(_periodDecimal.hasMatch('2.7kg'), isTrue);
    expect(_periodDecimal.hasMatch('2.700g'), isFalse);
    expect(_latinAmericanLexis.hasMatch('en auto'), isTrue);
    expect(_latinAmericanLexis.hasMatch('en autobús'), isFalse);
  });

  test('no word is missing its accent or ñ', () {
    final wrong = _hits(fields, (f) {
      return [
        for (final m in _bareWord.allMatches(f.text))
          '${m[0]} -> ${_bareToAccented[m[0]!.toLowerCase()]}',
      ].join(', ');
    });
    expect(wrong, isEmpty);
  });

  test('every ! and ? has its opening ¡ and ¿', () {
    int count(String text, String mark) => mark.allMatches(text).length;
    final wrong = _hits(fields.where((f) => !_isNote(f)).toList(), (f) {
      final unpaired =
          count(f.text, '!') > count(f.text, '¡') ||
          count(f.text, '?') > count(f.text, '¿');
      return unpaired ? f.text : '';
    });
    expect(wrong, isEmpty);
  });

  test('numbers use es-ES thousands and decimal marks', () {
    final wrong = _hits(fields.where((f) => !_isNote(f)).toList(), (f) {
      return [
        for (final pattern in [_commaThousands, _periodDecimal])
          ...pattern.allMatches(f.text).map((m) => m[0]),
      ].join(', ');
    });
    expect(wrong, isEmpty);
  });

  test('vocabulary is es-ES, not Latin American', () {
    final wrong = _hits(
      fields.where((f) => f.file != _lexisExempt).toList(),
      (f) => _latinAmericanLexis.allMatches(f.text).map((m) => m[0]).join(', '),
    );
    expect(wrong, isEmpty);
  });
}
