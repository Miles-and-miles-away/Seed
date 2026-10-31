import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _affordance = 'lib/shared/widgets/info_affordance.dart';
const _colours = 'lib/core/theme/app_colors.dart';

final _glyph = RegExp(r'Icons\.\w*(info|help|question|support)\w*');

// Strings are matched first so a '//' inside one is not taken as a comment.
final _stringOrComment = RegExp(
  r'''('(?:\\.|[^'\\\n])*'|"(?:\\.|[^"\\\n])*")|//[^\n]*|/\*[\s\S]*?\*/''',
);

String _stripComments(String source) =>
    source.replaceAllMapped(_stringOrComment, (m) => m[1] ?? '');

bool _scanned(String path) =>
    path.endsWith('.dart') &&
    !path.endsWith('.g.dart') &&
    !path.endsWith('.freezed.dart') &&
    !path.contains('/l10n/generated/');

/// Matches of [pattern] per file in `lib/`, comments stripped.
Map<String, int> _uses(RegExp pattern) => {
  for (final file in Directory('lib').listSync(recursive: true))
    if (file is File && _scanned(file.path))
      if (pattern.allMatches(_stripComments(file.readAsStringSync())).length
          case final count when count > 0)
        file.path: count,
};

void main() {
  test('the info glyph is drawn only by the shared widgets and the Settings '
      'About row', () {
    expect(_uses(RegExp(r'\bInfoGlyph\b')), {_affordance: 4});
    expect(_uses(_glyph), {
      'lib/features/settings/presentation/screens/settings_screen.dart': 1,
    });
  });

  test('the violet is declared once per tone', () {
    expect(
      _uses(
        RegExp(
          r'deepPurple|A258D5|B388FF|162,\s*88,\s*213|179,\s*136,\s*255',
          caseSensitive: false,
        ),
      ),
      {_colours: 2},
    );
  });

  test('the info colour is used only by the shared widgets', () {
    expect(_uses(RegExp('infoLight|infoDark|infoColor')), {
      _colours: 5,
      _affordance: 2,
    });
  });

  test('a commented-out use does not count', () {
    const source = '''
// Icons.info_outline
final a = Icons.info_outline; // Icons.help
final url = 'https://example.org/Icons.info';
final b = 'see //x'; final c = Icons.live_help_outlined;
/* Icons.info_outline
   Icons.help */
''';
    expect(_glyph.allMatches(_stripComments(source)).length, 3);
  });
}
