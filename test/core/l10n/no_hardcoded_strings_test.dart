import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

/// Calls whose first argument is shown as text. Matched as a substring,
/// so `RichText(`, `SelectableText(` and `PhraseText(` count too.
const _textCalls = ['Text('];

/// Named arguments that put text in front of the user, in any call.
const _textArguments = [
  'tooltip:',
  'label:',
  'labelText:',
  'semanticsLabel:',
  'semanticLabel:',
  'hintText:',
  'helperText:',
  'errorText:',
  'counterText:',
  'prefixText:',
  'suffixText:',
  'hint:',
  'message:',
  'title:',
  'confirmLabel:',
  'cancelLabel:',
];

/// Named arguments that are shown as text only inside these calls.
const _callArguments = {
  'TextSpan(': ['text:'],
  'Semantics(': ['value:'],
};

/// Literals that are meant to read the same in every language, keyed by
/// file so an exception in one file does not excuse the text elsewhere.
const _allowed = <String, Set<String>>{
  // The brand name is not translated.
  'lib/app/app.dart': {'Seed'},
  'lib/features/settings/presentation/screens/about_screen.dart': {'Seed'},
  // Chemical formulas and the CO2e unit symbol read the same in every locale.
  'lib/features/progress/presentation/widgets/day_detail_bottom_sheet.dart': {
    'CO',
  },
  'lib/shared/widgets/comparison_widgets.dart': {' CO2e'},
  // Reminders are postponed; localise this when they ship.
  'lib/shared/providers/notification_providers.dart': {
    'Time to make an impact!',
  },
};

/// Source with comments blanked out, leaving string literals intact, so a
/// `//` inside a URL is not mistaken for a comment.
String _stripComments(String source) {
  final out = StringBuffer();
  var i = 0;
  while (i < source.length) {
    final rest = source.substring(i);
    if (rest.startsWith('//')) {
      final end = source.indexOf('\n', i);
      i = end == -1 ? source.length : end;
      continue;
    }
    if (rest.startsWith('/*')) {
      final end = source.indexOf('*/', i + 2);
      i = end == -1 ? source.length : end + 2;
      continue;
    }
    final quote = _quoteAt(source, i);
    if (quote != null) {
      final end = _literalEnd(source, i, quote);
      out.write(source.substring(i, end));
      i = end;
      continue;
    }
    out.write(source[i]);
    i++;
  }
  return out.toString();
}

/// The quote sequence opening a literal at [i] (`'`, `"`, `'''`, `"""`,
/// with an optional `r` prefix), or null.
String? _quoteAt(String s, int i) {
  var start = i;
  if (s[i] == 'r' && i + 1 < s.length && (s[i + 1] == "'" || s[i + 1] == '"')) {
    if (i > 0 && RegExp(r'[\w$]').hasMatch(s[i - 1])) return null;
    start = i + 1;
  }
  if (s[start] != "'" && s[start] != '"') return null;
  final triple = s.startsWith(s[start] * 3, start);
  return (start > i ? 'r' : '') + (triple ? s[start] * 3 : s[start]);
}

/// Index just past the literal opened by [quote] at [i]. Steps over
/// `${...}` interpolations, which may hold literals of their own.
int _literalEnd(String s, int i, String quote) {
  final raw = quote.startsWith('r');
  final delimiter = raw ? quote.substring(1) : quote;
  var j = i + quote.length;
  while (j < s.length) {
    if (!raw && s[j] == r'\') {
      j += 2;
      continue;
    }
    if (!raw && s.startsWith(r'${', j)) {
      j = _argumentEnd(s, j + 2) + 1;
      continue;
    }
    if (s.startsWith(delimiter, j)) return j + delimiter.length;
    if (delimiter.length == 1 && s[j] == '\n') return j;
    j++;
  }
  return s.length;
}

/// Index of the `,`, `;` or closing bracket that ends the argument starting
/// at [i]. Reports each literal in it to [onLiteral] with its start index.
int _argumentEnd(
  String s,
  int start, [
  void Function(int start, String body)? onLiteral,
]) {
  var i = start;
  var depth = 0;
  while (i < s.length) {
    final quote = _quoteAt(s, i);
    if (quote != null) {
      final end = _literalEnd(s, i, quote);
      final bodyStart = i + quote.length;
      final bodyEnd = end - quote.length + (quote.startsWith('r') ? 1 : 0);
      onLiteral?.call(i, s.substring(bodyStart, max(bodyStart, bodyEnd)));
      i = end;
      continue;
    }
    final c = s[i];
    if ('([{'.contains(c)) {
      depth++;
    } else if (')]}'.contains(c)) {
      if (depth == 0) return i;
      depth--;
    } else if ((c == ',' || c == ';') && depth == 0) {
      return i;
    }
    i++;
  }
  return i;
}

Iterable<int> _indicesOf(String source, String pattern) sync* {
  for (var at = source.indexOf(pattern); at != -1;) {
    yield at;
    at = source.indexOf(pattern, at + pattern.length);
  }
}

/// [literal]'s text with every `$name` and `${...}` interpolation removed.
String _withoutInterpolation(String literal) {
  final out = StringBuffer();
  var i = 0;
  while (i < literal.length) {
    final escape = RegExp(
      r'\\(u\{[0-9a-fA-F]+\}|u[0-9a-fA-F]{4}|x[0-9a-fA-F]{2}|.)',
    ).matchAsPrefix(literal, i);
    if (escape != null) {
      i = escape.end;
      continue;
    }
    if (literal.startsWith(r'${', i)) {
      var depth = 1;
      i += 2;
      while (i < literal.length && depth > 0) {
        if (literal[i] == '{') depth++;
        if (literal[i] == '}') depth--;
        i++;
      }
      continue;
    }
    if (literal[i] == r'$') {
      final match = RegExp(r'\$[A-Za-z_]\w*').matchAsPrefix(literal, i);
      if (match != null) {
        i = match.end;
        continue;
      }
    }
    out.write(literal[i]);
    i++;
  }
  return out.toString();
}

final _letter = RegExp(r'\p{L}', unicode: true);

/// Every user-visible literal in [path]: each literal anywhere in a text
/// argument (so ternaries, adjacent literals and `+` count), with
/// interpolations removed, that still contains a letter.
List<String> hardCodedText(String path) {
  final source = _stripComments(File(path).readAsStringSync());
  final found = SplayTreeMap<int, String>();
  void scanArgument(int from) => _argumentEnd(source, from, (start, body) {
    final text = _withoutInterpolation(body);
    if (_letter.hasMatch(text)) found[start] = text;
  });

  for (final opener in [..._textCalls, ..._textArguments]) {
    for (final at in _indicesOf(source, opener)) {
      scanArgument(at + opener.length);
    }
  }
  for (final MapEntry(key: call, value: names) in _callArguments.entries) {
    for (final at in _indicesOf(source, call)) {
      var i = at + call.length;
      while (i < source.length) {
        while (i < source.length && source[i].trim().isEmpty) {
          i++;
        }
        for (final name in names) {
          if (source.startsWith(name, i)) scanArgument(i + name.length);
        }
        i = _argumentEnd(source, i);
        if (i >= source.length || source[i] != ',') break;
        i++;
      }
    }
  }
  return found.values.toList();
}

bool _scanned(String path) =>
    path.endsWith('.dart') &&
    !path.endsWith('.g.dart') &&
    !path.endsWith('.freezed.dart') &&
    !path.contains('/l10n/generated/') &&
    !path.contains('/data/') &&
    !path.endsWith('legal_content.dart');

void main() {
  test('user-visible text comes from the ARB files', () {
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .map((f) => f.path)
        .where(_scanned)
        .toList();
    expect(files, isNotEmpty);

    final offenders = <String>[];
    for (final path in files) {
      final allowed = _allowed[path] ?? const <String>{};
      for (final text in hardCodedText(path)) {
        if (!allowed.contains(text)) offenders.add('$path: "$text"');
      }
    }
    expect(offenders, isEmpty);
  });

  group('the scanner', () {
    late Directory dir;
    setUp(() => dir = Directory.systemTemp.createTempSync('literal_guard'));
    tearDown(() => dir.deleteSync(recursive: true));

    List<String> scan(String source) {
      final file = File('${dir.path}/sample.dart')..writeAsStringSync(source);
      return hardCodedText(file.path);
    }

    test('finds a literal on the line after Text(', () {
      expect(scan("Text(\n  'Complete goals!',\n)"), ['Complete goals!']);
    });

    test('ignores interpolation-only literals', () {
      expect(scan(r"Text('$value'); Text('${goal.number}');"), isEmpty);
      expect(scan(r"Text('+$remaining')"), isEmpty);
    });

    test('ignores comments but not a // inside a URL string', () {
      expect(scan("// Text('Error: oops')\nText(l10n.ok)"), isEmpty);
      expect(scan("final url = 'https://example.org'; Text('Hello')"), [
        'Hello',
      ]);
    });

    test('finds a multi-line TextSpan text: in any argument position', () {
      expect(scan("Text.rich(TextSpan(\n  text: 'Hello there',\n))"), [
        'Hello there',
      ]);
      expect(scan("TextSpan(style: s, text: 'Hello there')"), ['Hello there']);
      expect(scan("TextSpan(children: [WidgetSpan(child: x)], text: 'Hi')"), [
        'Hi',
      ]);
    });

    test('finds every literal in a ternary, adjacent literals and +', () {
      expect(scan("Text(isOn ? 'On now' : 'Off now')"), ['On now', 'Off now']);
      expect(scan("Text(\n  '\${a}'\n  ' points left',\n)"), [' points left']);
      expect(scan("Text(name + ' points')"), [' points']);
    });

    test('finds literals in nested interpolation without losing its place', () {
      expect(scan(r"Text('${a ? 'x' : 'y'} done'); Text('Next')"), [
        ' done',
        'Next',
      ]);
    });

    test('covers labels, semantics and decorations', () {
      expect(scan("showConfirmDialog(context, confirmLabel: 'Delete it')"), [
        'Delete it',
      ]);
      expect(scan("Icon(Icons.x, semanticLabel: 'Close it')"), ['Close it']);
      expect(scan("Semantics(label: l, value: 'Half full')"), ['Half full']);
      expect(scan("InputDecoration(prefixText: 'About ')"), ['About ']);
    });

    test('stops at the end of the argument', () {
      expect(scan("Text(l10n.ok, key: Key('done-button'))"), isEmpty);
      expect(scan("Text(a); final b = 'Not text';"), isEmpty);
    });
  });
}
