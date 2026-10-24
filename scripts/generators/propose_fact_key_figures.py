#!/usr/bin/env python3
"""Propose a key figure per eco-fact for the fact games.

For every fact whose titles carry no digit, lists the quantities with a
unit, scale word or percent sign in the EN, JA and ES texts, and
proposes the first EN quantity whose value also occurs in JA and ES,
each as a verbatim substring of its own text. Flags what a reviewer
must judge: titles that may state the figure in words, a figure over
MAX_FIGURE_CHARS, the same value written again in another form, and an
occurrence inside a longer number.

It never edits the data. A person reviews every proposal against the
fact and writes the accepted ones as keyFigureEn/Ja/Es into
data/app/eco_facts.json (rules under Key Figures in Plan/AUDIT_FACT_DATA.md).

    conda activate seed
    python scripts/generators/propose_fact_key_figures.py OUT.json
"""
import json
import math
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
FACTS_PATH = REPO_ROOT / 'data' / 'app' / 'eco_facts.json'
LANGS = ('En', 'Ja', 'Es')
MAX_FIGURE_CHARS = 18
YEAR_RANGE = range(1800, 2101)

EN_NUM = r'\d{1,3}(?:,\d{3})+(?:\.\d+)?|\d+(?:\.\d+)?'
ES_NUM = r'\d{1,3}(?:\.\d{3})+(?:,\d+)?|\d+(?:,\d+)?'
JA_NUM = rf'(?:(?:{EN_NUM})[兆億万])+(?:{EN_NUM})?|{EN_NUM}'

SCALES = {
    'En': {'thousand': 1e3, 'million': 1e6, 'billion': 1e9, 'trillion': 1e12},
    'Es': {
        'mil millones': 1e9,
        'billones': 1e12,
        'billón': 1e12,
        'millones': 1e6,
        'millón': 1e6,
        'mil': 1e3,
    },
}
JA_SCALES = {'兆': 1e12, '億': 1e8, '万': 1e4}

PERCENT = {'%', '％', 'percent', 'per cent', 'por ciento'}
TIMES = {'times', 'x', '倍', 'veces'}
UNITS = {
    'En': [
        '%', 'percent', 'per cent', 'kWh', 'MWh', 'GWh', 'TWh', 'GW', 'MW',
        'kW', 'km²', 'sq km', 'square kilometres', 'km/h', 'km', 'kg', 'mg',
        'g', 'Mt', 'Gt', 'tonnes', 'tonne', 'tons', 'ton', 'litres', 'litre',
        'ml', 'metres', 'metre', 'cm', 'mm', 'm', 'hectares', 'hectare', 'ha',
        'acres', 'degrees C', 'degrees', '°C', 'ppm', 'times', 'x', 'years',
        'year', 'months', 'weeks', 'days', 'hours', 'minutes', 'seconds',
        'gallons', 'dB', 'kcal', 'species',
    ],
    'Ja': [
        '%', '％', 'kWh', 'MWh', 'GWh', 'TWh', 'GW', 'MW', 'kW', 'km²',
        'km2', 'km', 'kg', 'mg', 'g', 'cm', 'mm', 'm', 'ppm', 'dB', 'トン',
        'リットル', 'ヘクタール', '平方キロメートル', 'キロメートル',
        'メートル', 'センチ', '度C', '℃', '度', '倍', '年間', '年', 'か月',
        'カ月', 'ヶ月', '週間', '日', '時間', '分', '秒', 'ドル', 'ガロン',
        '種', 'か国', 'カ国',
    ],
    'Es': [
        '%', 'por ciento', 'kWh', 'MWh', 'GWh', 'TWh', 'GW', 'MW', 'kW',
        'km²', 'kilómetros cuadrados', 'km/h', 'km', 'kg', 'mg', 'g', 'Mt',
        'Gt', 'toneladas', 'tonelada', 'litros', 'litro', 'ml', 'metros',
        'metro', 'cm', 'mm', 'm', 'hectáreas', 'hectárea', 'ha', 'grados C',
        'grados', '°C', 'ppm', 'veces', 'años', 'año', 'meses', 'semanas',
        'días', 'horas', 'minutos', 'segundos', 'galones', 'dB', 'kcal',
        'especies',
    ],
}

TITLE_WORDS = {
    'En': re.compile(
        r'\b(half|halve[sd]?|double[sd]?|twice|triple[sd]?|once|one|two|'
        r'three|four|five|six|seven|eight|nine|ten|twelve|twenty|hundred|'
        r'thousand|million|billion|trillion|third|quarter|dozen|zero|'
        r'single|percent)s?\b',
        re.IGNORECASE,
    ),
    'Ja': re.compile(r'[半倍一二三四五六七八九十百千万億兆零]'),
    'Es': re.compile(
        r'\b(mitad|medio|media|doble|duplica\w*|triple|triplica\w*|un|una|'
        r'uno|dos|tres|cuatro|cinco|seis|siete|ocho|nueve|diez|doce|veinte|'
        r'cien|ciento|mil|millón|millones|billón|tercio|cuarto|cero|'
        r'por ciento)\b',
        re.IGNORECASE,
    ),
}

RESTATED_WORDS = {
    ('pct', 50.0): r'\bhalf\b|\bhalved\b|半|\bmitad\b',
    ('times', 2.0): r'\btwice\b|\bdouble|2倍|\bdoble\b|\bduplica',
    ('times', 3.0): r'\btriple|3倍|\btriplica',
}


def _unit_pattern(lang):
    units = sorted(UNITS[lang], key=len, reverse=True)
    alternatives = '|'.join(re.escape(u) for u in units)
    if lang == 'Ja':
        return rf'(?P<unit>{alternatives})'
    return rf'(?P<unit>{alternatives})(?![A-Za-zÀ-ÿ²])'


def _quantity_pattern(lang):
    unit = _unit_pattern(lang)
    if lang == 'Ja':
        num = rf'(?P<num>{JA_NUM})'
        rng = rf'(?:(?P<lo>{EN_NUM})[〜～])?'
        return re.compile(rf'(?<![\d.,]){rng}{num}\s?(?:{unit})?')
    raw = EN_NUM if lang == 'En' else ES_NUM
    scales = '|'.join(sorted(SCALES[lang], key=len, reverse=True))
    currency = r'(?P<cur>US\$|\$|€|£)?' if lang == 'En' else ''
    rng = rf'(?:(?P<lo>{raw})-)?'
    return re.compile(
        rf'(?<![\d.,A-Za-z]){currency}{rng}(?P<num>{raw})'
        rf'(?:\s(?P<scale>{scales})(?![A-Za-zÀ-ÿ])|\s?(?:{unit}))?'
    )


PATTERNS = {lang: _quantity_pattern(lang) for lang in LANGS}


def _plain_value(text, lang):
    if lang == 'Es':
        text = text.replace('.', '').replace(',', '.')
    else:
        text = text.replace(',', '')
    return float(text)


def _ja_value(text):
    total, rest = 0.0, text
    for match in re.finditer(rf'({EN_NUM})([兆億万])', text):
        total += _plain_value(match.group(1), 'Ja') * JA_SCALES[match.group(2)]
        rest = rest.replace(match.group(0), '', 1)
    return total + (_plain_value(rest, 'Ja') if rest else 0.0)


def _kind(unit):
    if unit in PERCENT:
        return 'pct'
    if unit in TIMES:
        return 'times'
    return 'q'


def quantities(text, lang):
    """Every number in [text] with its value, kind and verbatim span."""
    found = []
    for match in PATTERNS[lang].finditer(text):
        num, unit = match.group('num'), match.group('unit')
        groups = match.groupdict()
        scale = groups.get('scale')
        if lang == 'Ja':
            value = _ja_value(num)
            scaled = bool(re.search('[兆億万]', num))
        else:
            value = _plain_value(num, lang) * SCALES[lang].get(scale, 1.0)
            scaled = scale is not None
        is_year = (
            not scaled
            and value in YEAR_RANGE
            and num.isdigit()
            and (unit is None or (lang == 'Ja' and unit == '年'))
        )
        lo = groups.get('lo')
        found.append({
            'text': match.group(0).rstrip(),
            'value': value,
            'low': _plain_value(lo, lang) if lo else None,
            'kind': _kind(unit),
            'has_unit': bool(unit or scaled or groups.get('cur')),
            'is_year': is_year,
        })
    return found


def _same(a, b):
    return (
        a['kind'] == b['kind']
        and math.isclose(a['value'], b['value'], rel_tol=1e-9)
        and (a['low'] is None) == (b['low'] is None)
        and (a['low'] is None or math.isclose(a['low'], b['low']))
    )


def _inside_longer_number(figure, text):
    for match in re.finditer(re.escape(figure), text):
        before = text[match.start() - 1] if match.start() else ''
        tail = text[match.end():]
        if re.match(r'[\d.,]', before) or (
            figure[-1].isdigit() and re.match(r'[.,]?\d', tail)
        ):
            return True
    return False


def _flags(fact, figures, chosen):
    flags = []
    for lang in LANGS:
        for word in TITLE_WORDS[lang].findall(fact[f'name{lang}']):
            flags.append(f'title {lang} has "{word}"')
    for lang, figure in zip(LANGS, figures):
        text = fact[f'fact{lang}']
        if len(figure) > MAX_FIGURE_CHARS:
            flags.append(f'{lang} figure over {MAX_FIGURE_CHARS} chars')
        if _inside_longer_number(figure, text):
            flags.append(f'{lang} figure occurs inside a longer number')
        blanked = text.replace(figure, '')
        for other in quantities(blanked, lang):
            if _same(other, chosen):
                flags.append(f'{lang} restates as "{other["text"]}"')
        words = RESTATED_WORDS.get((chosen['kind'], chosen['value']))
        if words and re.search(words, blanked, re.IGNORECASE):
            flags.append(f'{lang} may restate the figure in words')
    return flags


def propose(fact):
    if any(re.search(r'\d', fact[f'name{lang}']) for lang in LANGS):
        return {'status': 'title_digit'}
    found = {lang: quantities(fact[f'fact{lang}'], lang) for lang in LANGS}
    candidates = [q for q in found['En'] if q['has_unit'] and not q['is_year']]
    for en in candidates:
        ja = next((q for q in found['Ja'] if _same(q, en)), None)
        es = next((q for q in found['Es'] if _same(q, en)), None)
        if ja and es:
            figures = [en['text'], ja['text'], es['text']]
            return {
                'status': 'proposed',
                'figures': figures,
                'flags': _flags(fact, figures, en),
                'other_en': [q['text'] for q in candidates if q is not en],
            }
    status = 'no_match' if candidates else 'no_quantity'
    return {
        'status': status,
        'candidates': {
            lang: [q['text'] for q in found[lang] if not q['is_year']]
            for lang in LANGS
        },
    }


def main():
    if len(sys.argv) != 2:
        sys.exit(f'usage: {sys.argv[0]} OUT.json')
    facts = json.loads(FACTS_PATH.read_text(encoding='utf-8'))
    report = []
    for fact in facts:
        entry = {'dayOfYear': fact['dayOfYear']} | propose(fact)
        report.append(entry)
    Path(sys.argv[1]).write_text(
        json.dumps(report, indent=2, ensure_ascii=False) + '\n',
        encoding='utf-8',
    )
    counts = {}
    for entry in report:
        counts[entry['status']] = counts.get(entry['status'], 0) + 1
    print(json.dumps(counts))


if __name__ == '__main__':
    main()
