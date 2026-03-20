#!/usr/bin/env python3
"""Merge Spanish batch translations into eco_facts.json.

Reads batch files from scripts/translations_es/batch_*.json,
applies diacritics fixes, forces sourceEs = sourceEn, reorders
keys, and writes back to data/app/eco_facts.json.

Batch format: {"1": {"factEs": "..."}, "2": {"factEs": "..."}}
"""
import json
import glob
import os
import re

BASE = os.path.dirname(os.path.abspath(__file__))
BATCH_DIR = os.path.join(BASE, 'translations_es')
JSON_PATH = os.path.join(
    BASE, '..', 'data', 'app', 'eco_facts.json'
)

KEY_ORDER = [
    'dayOfYear', 'category',
    'factEn', 'factEs', 'factJa',
    'sourceEn', 'sourceEs', 'sourceJa',
    'sourceUrl', 'relatedSdgs', 'unWorldDay',
]

# Common Spanish words that lose diacritics in LLM output.
# Catch-all -ion -> -ión rule at the end handles most nouns.
DIACRITICS = [
    (r'\bano\b', 'año'), (r'\banos\b', 'años'),
    (r'\bbano\b', 'baño'), (r'\bbanos\b', 'baños'),
    (r'\bmanana\b', 'mañana'),
    (r'\bpequeno\b', 'pequeño'),
    (r'\bpequenos\b', 'pequeños'),
    (r'\bpequena\b', 'pequeña'),
    (r'\bnino\b', 'niño'), (r'\bninos\b', 'niños'),
    (r'\bdano\b', 'daño'), (r'\bdanos\b', 'daños'),
    (r'\bdanan\b', 'dañan'), (r'\btamano\b', 'tamaño'),
    (r'\bcampanas\b', 'campañas'),
    (r'\bmas\b', 'más'), (r'\bMas\b', 'Más'),
    (r'\bademas\b', 'además'), (r'\bAdemas\b', 'Además'),
    (r'\bestan\b', 'están'), (r'\bestaras\b', 'estarás'),
    (r'\bhabito\b', 'hábito'),
    (r'\bhabitos\b', 'hábitos'),
    (r'\bhabitat\b', 'hábitat'),
    (r'\bbasico\b', 'básico'), (r'\bbasica\b', 'básica'),
    (r'\brapido\b', 'rápido'), (r'\brapida\b', 'rápida'),
    (r'\brapidamente\b', 'rápidamente'),
    (r'\barbol\b', 'árbol'), (r'\barboles\b', 'árboles'),
    (r'\bcarton\b', 'cartón'),
    (r'\batmosfera\b', 'atmósfera'),
    (r'\bplastico\b', 'plástico'),
    (r'\bplasticos\b', 'plásticos'),
    (r'\bdia\b', 'día'), (r'\bdias\b', 'días'),
    (r'\bDia\b', 'Día'),
    (r'\btraves\b', 'través'),
    (r'\banalisis\b', 'análisis'),
    (r'\borganica\b', 'orgánica'),
    (r'\borganicos\b', 'orgánicos'),
    (r'\bdecada\b', 'década'), (r'\bdecadas\b', 'décadas'),
    (r'\boceano\b', 'océano'), (r'\boceanos\b', 'océanos'),
    (r'\benergia\b', 'energía'),
    (r'\btambien\b', 'también'),
    (r'\bTambien\b', 'También'),
    (r'\bcafe\b', 'café'),
    (r'\belectrico\b', 'eléctrico'),
    (r'\belectrica\b', 'eléctrica'),
    (r'\belectricos\b', 'eléctricos'),
    (r'\belectronicos\b', 'electrónicos'),
    (r'\belectrodomesticos\b', 'electrodomésticos'),
    (r'\benergetico\b', 'energético'),
    (r'\bpetroleo\b', 'petróleo'),
    (r'\bmetodos\b', 'métodos'),
    (r'\bgenero\b', 'género'),
    (r'\btipica\b', 'típica'), (r'\btipico\b', 'típico'),
    (r'\barticulos\b', 'artículos'),
    (r'\barticulo\b', 'artículo'),
    (r'\butil\b', 'útil'), (r'\butiles\b', 'útiles'),
    (r'\bminimo\b', 'mínimo'), (r'\bminima\b', 'mínima'),
    (r'\bfria\b', 'fría'), (r'\bfrio\b', 'frío'),
    (r'\bvehiculo\b', 'vehículo'),
    (r'\bvehiculos\b', 'vehículos'),
    (r'\bclimaticas\b', 'climáticas'),
    (r'\bclimatico\b', 'climático'),
    (r'\bbiologico\b', 'biológico'),
    (r'\bbiologica\b', 'biológica'),
    (r'\becologico\b', 'ecológico'),
    (r'\becologica\b', 'ecológica'),
    (r'\becologicos\b', 'ecológicos'),
    (r'\beconomico\b', 'económico'),
    (r'\beconomica\b', 'económica'),
    (r'\beconomia\b', 'economía'),
    (r'\bmayoria\b', 'mayoría'),
    (r'\bkilometro\b', 'kilómetro'),
    (r'\bkilometros\b', 'kilómetros'),
    (r'\bcientifica\b', 'científica'),
    (r'\bcientifico\b', 'científico'),
    (r'\bhistorica\b', 'histórica'),
    (r'\bestadistica\b', 'estadística'),
    (r'\bproteina\b', 'proteína'),
    (r'\bproteinas\b', 'proteínas'),
    (r'\bpaises\b', 'países'),
    (r'\bsinteticos\b', 'sintéticos'),
    (r'\bmicroplasticos\b', 'microplásticos'),
    (r'\bdomestico\b', 'doméstico'),
    (r'\bmultiples\b', 'múltiples'),
    (r'\basi\b', 'así'),
    (r'\bfotosintesis\b', 'fotosíntesis'),
    (r'\bpolitica\b', 'política'),
    (r'\bpoliticas\b', 'políticas'),
    (r'\btoxicos\b', 'tóxicos'), (r'\btoxica\b', 'tóxica'),
    (r'\bParis\b', 'París'),
    (r'\bsegun\b', 'según'), (r'\bSegun\b', 'Según'),
    (r'\bpublico\b', 'público'),
    (r'\bpublica\b', 'pública'),
    (r'\bnumero\b', 'número'),
    (r'\bautobus\b', 'autobús'),
    (r'\bjardin\b', 'jardín'),
    (r'\bjardines\b', 'jardines'),
    (r'\bfosiles\b', 'fósiles'),
    (r'\beolica\b', 'eólica'),
    (r'\baun\b', 'aún'),
    (r'\bpodria\b', 'podría'), (r'\bpodrian\b', 'podrían'),
    (r'\benvio\b', 'envío'),
    (r'\bmineria\b', 'minería'),
    (r'\bmembresia\b', 'membresía'),
    (r'\bportatil\b', 'portátil'),
    (r'\bcodigo\b', 'código'),
    (r'\bunico\b', 'único'), (r'\bunica\b', 'única'),
    (r'([a-záéíóúüñ])ion\b', r'\1ión'),
]


def fix_diacritics(text):
    """Restore accented characters that LLMs often drop."""
    for pattern, replacement in DIACRITICS:
        text = re.sub(pattern, replacement, text)
    return text


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


def validate(fact_es, day, fact_en):
    """Return list of warning strings for this entry."""
    warnings = []
    if not fact_es:
        warnings.append(f'Day {day}: empty factEs')
    if '--' in fact_en and '--' not in fact_es:
        warnings.append(
            f'Day {day}: English has "--" but factEs '
            f'does not'
        )
    ascii_chars = sum(1 for c in fact_es if c.isascii())
    if len(fact_es) > 0 and ascii_chars / len(fact_es) > 0.5:
        warnings.append(
            f'Day {day}: >50% ASCII (likely untranslated)'
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

            fact_es = fix_diacritics(
                trans.get('factEs', '')
            )
            fact_en = lookup[day].get('factEn', '')
            warnings.extend(
                validate(fact_es, day, fact_en)
            )

            if fact_es:
                lookup[day]['factEs'] = fact_es
                lookup[day]['sourceEs'] = (
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
        if 'factEs' not in item or not item['factEs']
    ]
    if missing:
        print(
            f'\nMissing factEs: {missing[:20]}... '
            f'({len(missing)} total)'
        )
    else:
        print('All 365 facts translated!')


if __name__ == '__main__':
    main()
