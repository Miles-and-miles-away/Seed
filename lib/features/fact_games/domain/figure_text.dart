/// One number in a figure, in any locale: a digit run with `.` and `,`
/// inside, Japanese scale compounds included (1億3,200万), never after a
/// letter, so the 2 of km2 and CO2 is not a number.
final figureNumber = RegExp(
  r'(?<![A-Za-z\d.,])(?:(?:\d[\d.,]*[兆億万])+(?:\d[\d.,]*)?|\d[\d.,]*)',
);

final _digit = RegExp(r'\d');
final _numberChar = RegExp(r'[\d.,]');
final _numberTail = RegExp(r'^[.,]?\d');
final _rangeStart = RegExp(r'\d[\d.,]*\s*(?:-|to)\s*(?=\d)');
final _plusAfterDigit = RegExp(r'(?<=\d)\+');
final _numberParts = RegExp(r'[\d\s.,]');
final _whitespace = RegExp(r'\s+');

/// Occurrences of [figure] in [text] that stand as a whole number: not
/// after a digit, `.` or `,`, and, when [figure] ends in a digit, not
/// followed by more of the number. So `5%` is in "5% of" but not in
/// "85%", and `0.9` is not in "10.9".
List<Match> wholeNumberMatches(String figure, String text) {
  final endsInDigit = _digit.hasMatch(figure[figure.length - 1]);
  return [
    for (final match in figure.allMatches(text))
      if (!(match.start > 0 && _numberChar.hasMatch(text[match.start - 1])) &&
          !(endsInDigit && _numberTail.hasMatch(text.substring(match.end))))
        match,
  ];
}

/// The unit of a canonical EN figure with its numbers removed: "8 to 15
/// tonnes" and "1-2 tonnes" are `tonnes`, "58+ degrees C" is `degreesc`.
String figureUnitKey(String keyFigureEn) => keyFigureEn
    .toLowerCase()
    .replaceAll(_rangeStart, '')
    .replaceAll(_plusAfterDigit, '')
    .replaceAll(_numberParts, '');

/// How [figure] is written, with each number as `#`: `8 to 15 tonnes` is
/// `# to # tonnes`, 1億3,200万人 is `#人`.
String figureShape(String figure) => figure
    .toLowerCase()
    .replaceAll(figureNumber, '#')
    .replaceAll(_whitespace, ' ');

/// Unit keys that measure the same kind of thing, so a decoy is never in
/// another unit's terms. Every playable figure's key is listed.
const figureFamilies = <String, String>{
  '%': 'percent',
  'times': 'times',
  'x': 'times',
  'g': 'mass',
  'kg': 'mass',
  'tonnes': 'mass',
  'gigatonnes': 'mass',
  'litres': 'volume',
  'seconds': 'time',
  'minutes': 'time',
  'hours': 'time',
  'years': 'time',
  'cm': 'length',
  'metres': 'length',
  'km': 'length',
  'degreesc': 'temperature',
  '': 'count',
  'million': 'count',
  'billion': 'count',
  'species': 'species',
  r'$': 'money',
  r'$billion': 'money',
  r'$trillion': 'money',
  'gbpbillion': 'money',
  'dollars': 'money',
};
