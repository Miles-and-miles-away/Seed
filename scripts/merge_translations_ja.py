#!/usr/bin/env python3
"""Merge Japanese batch translations into eco_facts.json.

Reads batch files from scripts/translations_ja/batch_*.json,
validates CJK content, forces sourceJa = sourceEn, reorders
keys, and writes back to data/app/eco_facts.json.

Batch format: {"1": {"factJa": "..."}, "2": {"factJa": "..."}}

Terminology glossary: scripts/glossary_ja.md
"""
import json
import glob
import os
import re

BASE = os.path.dirname(os.path.abspath(__file__))
BATCH_DIR = os.path.join(BASE, 'translations_ja')
JSON_PATH = os.path.join(
    BASE, '..', 'data', 'app', 'eco_facts.json'
)

KEY_ORDER = [
    'dayOfYear', 'category',
    'factEn', 'factEs', 'factJa',
    'sourceEn', 'sourceEs', 'sourceJa',
    'sourceUrl', 'relatedSdgs', 'unWorldDay',
]

# Hiragana, katakana, CJK unified ideographs
CJK_RE = re.compile(
    r'[\u3000-\u9fff\uf900-\ufaff]'
)


def reorder_keys(item):
    """Return item with keys in canonical order."""
    ordered = {}
    for key in KEY_ORDER:
        if key in item:
            ordered[key] = item[key]
    for key in item:
        if key not in ordered:
            ordered[key] = item[key]
    return ordered


def validate(fact_ja, day, fact_en):
    """Return list of warning strings for this entry."""
    warnings = []
    if not fact_ja:
        warnings.append(f'Day {day}: empty factJa')
        return warnings
    if not CJK_RE.search(fact_ja):
        warnings.append(
            f'Day {day}: factJa has no CJK characters: '
            f'{fact_ja[:50]}...'
        )
    if '--' in fact_en and '--' not in fact_ja:
        warnings.append(
            f'Day {day}: English has "--" but factJa '
            f'does not'
        )
    ascii_alpha = sum(
        1 for c in fact_ja if c.isascii() and c.isalpha()
    )
    if len(fact_ja) > 0 and ascii_alpha / len(fact_ja) > 0.3:
        warnings.append(
            f'Day {day}: >30% ASCII alpha '
            f'(likely untranslated)'
        )
    return warnings


def main():
    with open(JSON_PATH, 'r', encoding='utf-8') as f:
        data = json.load(f)

    lookup = {item['dayOfYear']: item for item in data}

    batch_files = sorted(
        glob.glob(
            os.path.join(BATCH_DIR, 'batch_*.json')
        )
    )
    print(f'Found {len(batch_files)} batch files')

    total = 0
    warnings = []
    for bf in batch_files:
        with open(bf, 'r', encoding='utf-8') as f:
            batch = json.load(f)
        for day_str, trans in batch.items():
            day = int(day_str)
            if day not in lookup:
                warnings.append(
                    f'Day {day} not found in data'
                )
                continue

            fact_ja = trans.get('factJa', '')
            fact_en = lookup[day].get('factEn', '')
            warnings.extend(
                validate(fact_ja, day, fact_en)
            )

            if fact_ja:
                lookup[day]['factJa'] = fact_ja
                lookup[day]['sourceJa'] = (
                    lookup[day]['sourceEn']
                )
                total += 1

    ordered_data = [reorder_keys(item) for item in data]

    with open(JSON_PATH, 'w', encoding='utf-8') as f:
        json.dump(
            ordered_data, f, ensure_ascii=False, indent=2
        )
        f.write('\n')

    print(f'Merged {total}/365 translations')

    if warnings:
        print(f'\n{len(warnings)} warnings:')
        for w in warnings:
            print(f'  - {w}')

    missing = [
        item['dayOfYear'] for item in ordered_data
        if 'factJa' not in item or not item['factJa']
    ]
    if missing:
        print(
            f'\nMissing factJa: {missing[:20]}... '
            f'({len(missing)} total)'
        )
    else:
        print('All 365 facts translated!')


if __name__ == '__main__':
    main()
