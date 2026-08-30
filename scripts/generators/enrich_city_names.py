#!/usr/bin/env python3
"""Inject name_ja / name_es into data/app/cities.json.

The city list ships GeoNames' endonym-or-English name. JA and ES
users see and search that name unless the record carries a
localized one, so this pass adds the localized names two open
sources publish, and only those: nothing here transliterates,
translates or guesses. Cities neither source localizes keep no
extra field and fall back to English in the UI.

Pass 1 (JA + ES) -- GeoNames alternate names, joined on geonameid.
data/app/cities.json stores no geonameid, so ids are recovered by
joining (country, name, 4-dp coordinates) back onto cities15000 --
the same input build_cities.py selected from. A city that has
since left cities15000 does not join, so it stays English here and
would be dropped outright by the next full regeneration; that is
what KNOWN_UNJOINED guards.

Pass 2 (JA only, network) -- Wikidata labels for the cities
GeoNames leaves unlocalized, joined on property P1566 (GeoNames
ID), an exact key rather than a name match.

Pass 3 (JA only, network) -- pass 2 misses cities whose Wikidata
item carries no P1566 (Victoria HK) or points at a different
GeoNames record for the same place (Puente Alto). Those are looked
up by their primary English label, and a candidate is accepted
only when its coordinate (P625) lies within the population-scaled
gate of the cities.json coordinate, plus a country check on the
small band. A name alone is never enough: without the coordinate
gate this pass would ship the wrong Springfield.

Pass 3 is not redundant with pass 2 and must not be deleted as an
optimization. GeoNames keeps duplicate records for one place and
Wikidata's P1566 routinely cites the other one: New Taipei City is
1665148 on Wikidata against the 12908892 shipped here, Sha Tin
1818919 against 1818920. Those duplicates cluster in exactly the
small-territory cases, so the exact-id join misses them by
construction and only the name-plus-coordinate pass recovers them.
It currently supplies 33 of the 925 Japanese names, and
NAME_JA_FLOOR is the guard that keeps it honest: the run aborts
rather than writing a thinner file, so deleting this pass fails
loudly instead of quietly costing 33 names.

Island labels are a reviewed keep, not a bug. Four accepted names
carry the 島 suffix because Wikidata models the place as an
island: Taipa MO タイパ島, Saipan MP サイパン島, Providenciales
TC プロビデンシアレス島, West Island CC ウェスト島. 島 is the
ordinary Japanese rendering for these places, and each item's
primary English label is the city name exactly, so the entity is
right and only the conventional Japanese name differs. That is
categorically unlike an alternate-label match, which is a
different entity that merely answers to the same string (Cape
Bojador for "Boujdour"). Pinned in
test/features/transport/data/cities_data_test.dart.

Inputs (open data, re-download to rerun; not committed):
  cities15000.txt        GeoNames places with population > 15,000
                         https://download.geonames.org/export/dump/
                         cities15000.zip (CC BY 4.0)
  alternateNamesV2.txt   GeoNames alternate names, all languages
                         https://download.geonames.org/export/dump/
                         alternateNamesV2.zip (CC BY 4.0)
  Wikidata Query Service https://query.wikidata.org/sparql (CC0)

Usage (from repo root):
  python scripts/generators/enrich_city_names.py <input_dir>

Rewrites data/app/cities.json in place, touching only the two name
fields and the metadata provenance note. Run sweep_suggestions.py
afterwards.
"""
import json
import re
import sys
import time
import urllib.parse
import urllib.request
from collections import defaultdict
from pathlib import Path

from geo import geonames_rows, haversine_km

REPO_ROOT = Path(__file__).resolve().parents[2]
CITIES_PATH = REPO_ROOT / "data" / "app" / "cities.json"

LANGS = ("ja", "es")
# alternateNamesV2 columns.
COL_ID, COL_GEONAMEID, COL_LANG, COL_NAME = 0, 1, 2, 3
COL_PREFERRED, COL_SHORT, COL_COLLOQUIAL, COL_HISTORIC = 4, 5, 6, 7

NAME_SOURCES = (
    "name_ja, name_es: GeoNames alternate names (CC BY 4.0); "
    "name_ja fallback: Wikidata labels (CC0)"
)

# Shipping cities that no longer appear in cities15000, as (name,
# cc). Basis: Seria BN was in the export at the 2026-07-18 build
# and had left it by 2026-08-29; the rest still join.
KNOWN_UNJOINED = {("Seria", "BN")}

WIKIDATA_ENDPOINT = "https://query.wikidata.org/sparql"
WIKIDATA_UA = (
    "SeedApp-city-name-enrichment/1.0 "
    "(https://github.com/Miles-and-miles-away/Seed)"
)
WIKIDATA_BATCH = 40
REQUEST_TIMEOUT_S = 120
RETRY_ATTEMPTS = 6
RETRY_BASE_S = 10
RETRY_MAX_S = 300
POLITE_PAUSE_S = 1.0

# Floors on TOTAL shipped coverage, never on one pass's share of
# it: the Wikidata passes exist to backfill what GeoNames misses,
# so a pass that yields less because an earlier one yielded more is
# a better run, not a regression. Adding these two fields is the
# only reason this script exists, and the endpoint 502s and
# throttles under load while a degraded run answers "no label"
# rather than failing, so a result under these numbers is a
# transport fault and must not overwrite the file. Shipped
# 2026-08-29: 925 name_ja and 275 name_es of 969 cities; the margin
# absorbs ordinary upstream churn and nothing more.
NAME_JA_FLOOR = 900
NAME_ES_FLOOR = 265

LARGE_RESIDUAL_POP = 400_000
# A name match is only trusted when the item sits on the city.
COORD_MATCH_LARGE_KM = 25.0
# Tighter for small towns: a same-named settlement 20 km from a
# 30k town is plausibly a different place, while 20 km from a 4M
# city is still inside it.
COORD_MATCH_SMALL_KM = 10.0
# Below this the country check is not applied at all; past it a
# same-named place across a border is the real risk.
COUNTRY_CHECK_MIN_KM = 5.0
# Candidates are gathered from a wider ring than they can pass so
# a reject is reported with the distance that sank it.
NAME_SEARCH_RADIUS_KM = 300

GEONAMEID_QUERY = (
    "SELECT ?gid ?ja WHERE { VALUES ?gid { %s } "
    "?item wdt:P1566 ?gid . "
    '?item rdfs:label ?ja . FILTER(lang(?ja) = "ja") }'
)
# Spatially indexed: matching the name first makes the service
# scan every Carrefour and Victoria on earth and time out.
NAME_QUERY = (
    "SELECT ?item ?ja ?coord ?cc WHERE { "
    "SERVICE wikibase:around { ?item wdt:P625 ?coord . "
    'bd:serviceParam wikibase:center "Point(%(lon)s %(lat)s)"'
    "^^geo:wktLiteral . "
    'bd:serviceParam wikibase:radius "%(radius)s" . } '
    # Primary label only: an altLabel is a name an item is also
    # known by, which is how Cape Bojador answers to "Boujdour".
    '?item rdfs:label "%(name)s"@en . '
    '?item rdfs:label ?ja . FILTER(lang(?ja) = "ja") '
    "OPTIONAL { ?item wdt:P17/wdt:P297 ?cc } }"
)

PAREN_SUFFIX = re.compile(r"\s*[(（][^()（）]*[)）]\s*$")
POINT = re.compile(r"^Point\(\s*(-?[\d.eE+-]+)\s+(-?[\d.eE+-]+)\s*\)$")


def flag(row, index):
    return len(row) > index and row[index] == "1"


def is_ascii(value):
    return all(ord(c) < 128 for c in value)


def load_geonameids(path):
    """Map (cc, name, lat, lon) as cities.json stores it -> geonameid."""
    ids = {}
    for row in geonames_rows(path):
        try:
            key = (row[8], row[1], round(float(row[4]), 4),
                   round(float(row[5]), 4))
            pop = int(row[14])
        except (IndexError, ValueError):
            continue
        # Highest population wins, as in build_cities.py, which
        # picked the record that shipped. Last-wins would hand a
        # city the other record's localized names.
        if key not in ids or ids[key][0] < pop:
            ids[key] = (pop, row[0])
    return {key: gid for key, (_, gid) in ids.items()}


def load_alternates(path, wanted):
    groups = defaultdict(list)
    for row in geonames_rows(path):
        if len(row) <= COL_NAME:
            continue
        if row[COL_GEONAMEID] in wanted and row[COL_LANG] in LANGS:
            groups[(row[COL_GEONAMEID], row[COL_LANG])].append(row)
    return groups


def pick(rows, lang):
    """The one name to ship, or None.

    Colloquial and historic rows are excluded outright; of the rest
    GeoNames' preferred name wins, then a full name over a short
    form, then the oldest id so reruns are stable. JA additionally
    demotes romaji rows (GeoNames files "Amusuterudamu" as ja
    alongside the kana), which no Japanese user reads as a name.
    """
    usable = [
        r for r in rows
        if r[COL_NAME].strip()
        and not flag(r, COL_COLLOQUIAL)
        and not flag(r, COL_HISTORIC)
    ]
    if not usable:
        return None
    usable.sort(key=lambda r: (
        lang == "ja" and is_ascii(r[COL_NAME]),
        not flag(r, COL_PREFERRED),
        flag(r, COL_SHORT),
        int(r[COL_ID]),
    ))
    return usable[0][COL_NAME].strip()


def gate_ja_label(label, english):
    """Clean a Wikidata label, or explain why it cannot ship."""
    name = PAREN_SUFFIX.sub("", label).strip()
    if not name:
        return None, "empty once the disambiguator is stripped"
    if is_ascii(name):
        return None, f"ASCII-only ({label!r}): romaji or a Latin name"
    if name == english:
        return None, "identical to the English name"
    return name, None


def retry_delay(exc, fallback):
    header = getattr(exc, "headers", None)
    try:
        return min(float(header.get("Retry-After")), RETRY_MAX_S)
    except (AttributeError, TypeError, ValueError):
        return fallback


def sparql(query):
    """Run one SPARQL query, or abort the whole regeneration.

    Exhausted retries exit rather than return empty: an endpoint
    fault must never read as "this city has no Japanese name".
    """
    url = "%s?%s" % (
        WIKIDATA_ENDPOINT,
        urllib.parse.urlencode({"query": query, "format": "json"}),
    )
    request = urllib.request.Request(url, headers={
        "User-Agent": WIKIDATA_UA,
        "Accept": "application/sparql-results+json",
    })
    delay = RETRY_BASE_S
    for attempt in range(RETRY_ATTEMPTS):
        try:
            with urllib.request.urlopen(
                request, timeout=REQUEST_TIMEOUT_S
            ) as response:
                body = json.loads(response.read().decode("utf-8"))
            return body["results"]["bindings"]
        # OSError covers URLError, TimeoutError and a mid-read
        # ConnectionResetError, which escaped a narrower tuple.
        except (OSError, ValueError, KeyError) as exc:
            if attempt == RETRY_ATTEMPTS - 1:
                sys.exit(f"Wikidata query failed {RETRY_ATTEMPTS}x: {exc}")
            wait = retry_delay(exc, delay)
            print(f"  wikidata: {exc}; retrying in {wait:.0f}s")
            time.sleep(wait)
            delay = min(delay * 2, RETRY_MAX_S)


def ja_labels_by_geonameid(gids):
    """geonameid -> Japanese label, for the ids Wikidata carries."""
    found = defaultdict(set)
    for start in range(0, len(gids), WIKIDATA_BATCH):
        chunk = gids[start:start + WIKIDATA_BATCH]
        values = " ".join('"%s"' % g for g in chunk)
        for row in sparql(GEONAMEID_QUERY % values):
            found[row["gid"]["value"]].add(row["ja"]["value"])
        time.sleep(POLITE_PAUSE_S)
    # Two items can claim one geonameid; sort so reruns agree.
    return {gid: sorted(labels)[0] for gid, labels in found.items()}


def parse_point(value):
    match = POINT.match(value)
    if not match:
        return None
    return float(match.group(2)), float(match.group(1))


def ja_label_by_name(city):
    """Japanese label for a city matched by name, plus an audit line."""
    query = NAME_QUERY % {
        "name": city["name"].replace("\\", "\\\\").replace('"', '\\"'),
        "lat": city["lat"],
        "lon": city["lon"],
        "radius": NAME_SEARCH_RADIUS_KM,
    }
    large = city["pop"] >= LARGE_RESIDUAL_POP
    gate = COORD_MATCH_LARGE_KM if large else COORD_MATCH_SMALL_KM
    best = None
    for row in sparql(query):
        point = parse_point(row["coord"]["value"])
        if point is None:
            continue
        km = haversine_km(city["lat"], city["lon"], point[0], point[1])
        item = row["item"]["value"].rsplit("/", 1)[-1]
        cand = (km, item, row["ja"]["value"], row.get("cc", {}).get("value"))
        if best is None or cand[:2] < best[:2]:
            best = cand
    time.sleep(POLITE_PAUSE_S)
    band = f"gate {gate:.0f} km"
    if best is None:
        return None, (f"{band}, no name match with a JA label within "
                      f"{NAME_SEARCH_RADIUS_KM} km")
    km, item, label, cc = best
    where = f"{band}, {item} cc={cc or '?'} {km:.1f} km"
    if km > gate:
        return None, f"{where}, beyond the gate"
    # cities.json codes dependent territories by their own ISO
    # code while P17 names the sovereign state, so a mismatch this
    # close is that modelling gap, not a wrong entity.
    if (not large and km > COUNTRY_CHECK_MIN_KM
            and cc is not None and cc != city["cc"]):
        return None, f"{where}, country {cc} is not {city['cc']}"
    name, reason = gate_ja_label(label, city["name"])
    if name is None:
        return None, f"{where}, {reason}"
    return name, f"{where} -> {name}"


def check_unjoined(observed):
    """Abort when the cities15000 join drifts from KNOWN_UNJOINED.

    build_cities.py re-selects the shipped list from cities15000, so
    a city that has left the export is dropped on the next full
    regeneration and a backfill city takes its top-N slot. This join
    is the only place that sees it go, and a stale constant hides
    the next one, so drift in either direction stops the run.
    """
    left = sorted(observed - KNOWN_UNJOINED)
    returned = sorted(KNOWN_UNJOINED - observed)
    for name, cc in left:
        print(f"unjoined: {name} ({cc}) has left cities15000")
    for name, cc in returned:
        print(f"unjoined: {name} ({cc}) is back in cities15000")
    if left or returned:
        sys.exit(
            f"KNOWN_UNJOINED: cities15000 join drifted ({len(left)} "
            f"newly absent, {len(returned)} returned). A full "
            "regeneration would silently drop the absent cities and "
            "backfill their slots; review each, then update the "
            "constant."
        )


def check_coverage(names):
    """Abort when total name coverage drops below the floor.

    Guards the output, not any one pass: GeoNames localizing more
    cities and Wikidata backfilling fewer is the same file.
    """
    for lang, floor in (("ja", NAME_JA_FLOOR), ("es", NAME_ES_FLOOR)):
        got = sum(1 for n in names if lang in n)
        if got < floor:
            sys.exit(f"name_{lang}: {got} names, floor is {floor}: "
                     f"refusing to write a thinner file")


def core_signature(cities):
    return json.dumps([
        [c["name"], c["cc"], c["lat"], c["lon"], c["mass"], c["pop"]]
        for c in cities
    ])


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    in_dir = Path(sys.argv[1])

    with open(CITIES_PATH, encoding="utf-8") as f:
        payload = json.load(f)
    cities = payload["cities"]
    metadata = payload["metadata"]
    links_before = json.dumps(metadata["links"])
    blocked_before = json.dumps(metadata.get("water_blocked"))
    core_before = core_signature(cities)

    ids = load_geonameids(in_dir / "cities15000.txt")
    by_index = {}
    for i, c in enumerate(cities):
        gid = ids.get((c["cc"], c["name"], c["lat"], c["lon"]))
        if gid is not None:
            by_index[i] = gid
    unjoined = {(c["name"], c["cc"])
                for i, c in enumerate(cities) if i not in by_index}
    check_unjoined(unjoined)

    groups = load_alternates(
        in_dir / "alternateNamesV2.txt", set(by_index.values())
    )
    names = [{} for _ in cities]
    for i, city in enumerate(cities):
        gid = by_index.get(i)
        for lang in LANGS:
            name = pick(groups.get((gid, lang), []), lang) if gid else None
            # An alternate name identical to the English one is noise:
            # the UI already falls back to it.
            if name is not None and name != city["name"]:
                names[i][lang] = name
    geonames_ja = sum(1 for n in names if "ja" in n)

    missing = [i for i in range(len(cities))
               if "ja" not in names[i] and i in by_index]
    print(f"wikidata P1566 pass: {len(missing)} ids")
    labels = ja_labels_by_geonameid([by_index[i] for i in missing])
    p1566_ja, rejects = 0, []
    for i in missing:
        label = labels.get(by_index[i])
        if label is None:
            continue
        name, reason = gate_ja_label(label, cities[i]["name"])
        if name is None:
            rejects.append(f"{cities[i]['name']}: {reason}")
            continue
        names[i]["ja"] = name
        p1566_ja += 1

    residual = [i for i in range(len(cities)) if "ja" not in names[i]]
    print(f"wikidata name pass: {len(residual)} cities")
    name_ja = 0
    for i in residual:
        name, note = ja_label_by_name(cities[i])
        verdict = "accept" if name else "reject"
        print(f"  {verdict} {cities[i]['name']} ({cities[i]['cc']}, "
              f"pop {cities[i]['pop']:,}): {note}")
        if name:
            names[i]["ja"] = name
            name_ja += 1

    total = len(cities)
    print(f"cities: {total}")
    print(f"joined to GeoNames: {len(by_index)}")
    if unjoined:
        print("unjoined (left cities15000): " + ", ".join(
            f"{name} ({cc})" for name, cc in sorted(unjoined)
        ))
    if rejects:
        print(f"wikidata labels rejected: {'; '.join(rejects)}")
    print(f"name_ja: {geonames_ja} GeoNames + {p1566_ja} Wikidata P1566 "
          f"+ {name_ja} Wikidata name match")
    for lang in LANGS:
        got = sum(1 for n in names if lang in n)
        print(f"name_{lang}: {got} ({total - got} fall back to English)")
    check_coverage(names)

    for i, city in enumerate(cities):
        for lang in LANGS:
            city.pop(f"name_{lang}", None)
        for lang in LANGS:
            if lang in names[i]:
                city[f"name_{lang}"] = names[i][lang]
    metadata["name_sources"] = NAME_SOURCES

    # The name fields are the only thing this script may change.
    assert json.dumps(metadata["links"]) == links_before
    assert json.dumps(metadata.get("water_blocked")) == blocked_before
    assert core_signature(cities) == core_before
    with open(CITIES_PATH, "w", encoding="utf-8") as f:
        json.dump(payload, f, ensure_ascii=False, separators=(",", ":"))
        f.write("\n")


if __name__ == "__main__":
    main()
