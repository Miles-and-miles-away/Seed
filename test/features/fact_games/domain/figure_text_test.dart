import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/fact_games/domain/figure_text.dart';

void main() {
  group('wholeNumberMatches', () {
    test('finds a figure that stands alone', () {
      expect(wholeNumberMatches('5%', 'About 5% of'), hasLength(1));
      expect(wholeNumberMatches('3.2 kg', '3.2 kg of CO2'), hasLength(1));
    });

    test('skips a figure inside a longer number', () {
      expect(wholeNumberMatches('5%', 'About 85% of'), isEmpty);
      expect(wholeNumberMatches('0.9', 'just 10.9 kg'), isEmpty);
      expect(wholeNumberMatches('10', 'over 10.5 tonnes'), isEmpty);
      expect(wholeNumberMatches('1,5', '1,500 litros'), isEmpty);
    });

    test('counts each whole occurrence', () {
      expect(wholeNumberMatches('20%', '20% here, 120% there, 20% again'), [
        isA<Match>().having((m) => m.start, 'start', 0),
        isA<Match>().having((m) => m.start, 'start', 22),
      ]);
    });
  });

  group('figureUnitKey', () {
    for (final (figure, key) in [
      ('124 kg', 'kg'),
      ('8,800 tonnes', 'tonnes'),
      ('8 to 15 tonnes', 'tonnes'),
      ('1-2 tonnes', 'tonnes'),
      ('58+ degrees C', 'degreesc'),
      ('10-15%', '%'),
      (r'$4.5 trillion', r'$trillion'),
      ('3x', 'x'),
      ('132 million', 'million'),
      ('40', ''),
    ]) {
      test('"$figure" is "$key"', () => expect(figureUnitKey(figure), key));
    }
  });

  group('figureShape', () {
    for (final (figure, shape) in [
      ('8 to 15 tonnes', '# to # tonnes'),
      ('58+ degrees C', '#+ degrees c'),
      ('1億3,200万人', '#人'),
      ('6 L', '# l'),
      ('3万5,000 km2', '# km2'),
      ('CO2  50 kg', 'co2 # kg'),
    ]) {
      test('"$figure" is "$shape"', () => expect(figureShape(figure), shape));
    }
  });
}
