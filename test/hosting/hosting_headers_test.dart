import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _forbiddenSources = [
  "'unsafe-inline'",
  "'unsafe-eval'",
  'data:',
  'http:',
];

Map<String, String> _hostingHeaders() {
  final config =
      jsonDecode(File('firebase.json').readAsStringSync())
          as Map<String, dynamic>;
  final hosting = config['hosting'] as Map<String, dynamic>;
  final rule = (hosting['headers'] as List<dynamic>)
      .cast<Map<String, dynamic>>()
      .singleWhere((r) => r['source'] == '**');
  return {
    for (final h
        in (rule['headers'] as List<dynamic>).cast<Map<String, dynamic>>())
      h['key'] as String: h['value'] as String,
  };
}

Map<String, List<String>> _directives(String csp) => {
  for (final part
      in csp.split(';').map((p) => p.trim()).where((p) => p.isNotEmpty))
    part.split(RegExp(r'\s+')).first: part.split(RegExp(r'\s+')).sublist(1),
};

List<File> _hostedPages() => Directory('public')
    .listSync(recursive: true)
    .whereType<File>()
    .where((f) => f.path.endsWith('.html'))
    .toList();

void main() {
  final headers = _hostingHeaders();
  final csp = _directives(headers['Content-Security-Policy']!);

  test('the hosting CSP is strict', () {
    expect(csp['default-src'], ["'none'"]);
    expect(csp['frame-ancestors'], ["'none'"]);
    expect(csp['base-uri'], ["'none'"]);
    expect(csp['form-action'], ["'none'"]);
    for (final entry in csp.entries) {
      for (final source in entry.value) {
        expect(
          _forbiddenSources.contains(source) || source.contains('*'),
          isFalse,
          reason: '${entry.key} allows $source',
        );
      }
    }
  });

  test('the hosting companion headers are set', () {
    expect(headers['X-Content-Type-Options'], 'nosniff');
    expect(headers['Referrer-Policy'], isNotEmpty);
    expect(headers['Permissions-Policy'], isNotEmpty);
  });

  test('hosted pages have no inline script or style', () {
    final pages = _hostedPages();
    expect(pages, isNotEmpty);
    for (final page in pages) {
      final html = page.readAsStringSync();
      expect(html, isNot(contains('<style')), reason: page.path);
      expect(
        RegExp(r'<script(?![^>]*\ssrc=)').hasMatch(html),
        isFalse,
        reason: '${page.path} has an inline script',
      );
      expect(
        RegExp(
          r'<[^>]+\s(on[a-z]+|style)=',
          caseSensitive: false,
        ).hasMatch(html),
        isFalse,
        reason: '${page.path} has an inline handler or style attribute',
      );
    }
  });

  test('hosted pages load only same-origin files that exist', () {
    final ref = RegExp(
      r'<(?:script|img|link\b[^>]*\brel="stylesheet")[^>]*\s(?:src|href)="([^"]+)"',
    );
    for (final page in _hostedPages()) {
      for (final match in ref.allMatches(page.readAsStringSync())) {
        final url = match.group(1)!;
        expect(url, startsWith('/'), reason: '${page.path} loads $url');
        expect(url, isNot(startsWith('//')), reason: '${page.path} loads $url');
        expect(
          File('public$url').existsSync(),
          isTrue,
          reason: '${page.path} loads missing $url',
        );
      }
    }
  });
}
