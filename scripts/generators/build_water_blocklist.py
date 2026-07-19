#!/usr/bin/env python3
"""Inject metadata.water_blocked into data/app/cities.json.

Same-landmass city pairs within ground range can still face open
water the landmass model cannot see (Helsinki-Tallinn share
Eurasia; Buenos Aires-Montevideo share SouthAmerica). For every
unordered same-mass pair within GROUND_MODE_MAX_KM this script
densifies the great-circle chord and measures the longest
continuous water span against Natural Earth 1:50m land polygons
(public domain, data/reference/natural_earth/). Pairs whose
longest span exceeds WATER_SPAN_BLOCK_KM are emitted as sorted
[i, j] index pairs (i < j, indices into the stored cities array)
so the Dart side can suppress ground/active suggestions.

Cross-mass pairs are already handled by the landmass model and
never appear here. Rivers and lakes are not in ne_50m_land, so
MANUAL_BLOCK covers water the polygons cannot see and
MANUAL_ALLOW exempts real bridged/tunneled corridors the raw
span test would wrongly block.

Usage (from repo root, seed conda env):
  python scripts/generators/build_water_blocklist.py

Rewrites data/app/cities.json in place, touching only
metadata.water_blocked. See PDR_TRANSPORT_CALCULATOR.md sec 13.2.
"""
import json
import math
import sys
import time
from pathlib import Path

import numpy as np
import shapefile
import shapely
from shapely.geometry import shape

REPO_ROOT = Path(__file__).resolve().parents[2]
CITIES_PATH = REPO_ROOT / "data" / "app" / "cities.json"
LAND_SHP = (
    REPO_ROOT / "data" / "reference" / "natural_earth" / "ne_50m_land.shp"
)

EARTH_RADIUS_KM = 6371.0088
# Mirrors groundModeMaxKm in the Dart journey_distance service.
GROUND_MODE_MAX_KM = 2000.0
SAMPLE_STEP_KM = 2.0
# A pair with no wet sample at this spacing cannot contain a wet
# span >= COARSE_STEP_KM, which is below the block threshold, so
# the expensive fine pass runs only on pairs that touch water.
COARSE_STEP_KM = 12.0
# Calibrated so the bridged Oresund (~15 km wet) survives while
# genuine open-water crossings (Gulf of Finland ~60 km) block.
WATER_SPAN_BLOCK_KM = 25.0

# Water invisible to ne_50m_land (rivers, sub-resolution
# channels). Keys are "CC/Name" as stored in the cities array.
MANUAL_BLOCK = [
    # Unbridged Congo river; Kinshasa-Brazzaville is ferry-only.
    ("CD/Kinshasa", "CG/Brazzaville"),
]

# Real corridors the raw span test wrongly blocks: either a
# fixed crossing (bridge/tunnel/causeway) carries the pair, or a
# continuous land route with a modest detour exists and the chord
# merely grazes offshore water (coastal-clip artifact). Every
# entry was verified against a full exploration run on
# 2026-07-19; comments name the physical crossing or corridor.
# Conservative: unbridged straits stay blocked (Helsinki-Tallinn,
# Bahrain-Qatar, Bonifacio...), as do land detours over ~1.5x or
# politically impassable routes (Seoul-DPRK, Batumi-Sokhumi).
MANUAL_ALLOW = [
    # -- Denmark/Sweden/Norway: Great Belt + Little Belt fixed
    # links (road+rail) join Zealand-Funen-Jutland; the Oresund
    # bridge joins Copenhagen-Sweden. Chords also graze Kattegat/
    # Baltic coastal water on all-land E4/E6 corridors.
    ("DK/Copenhagen", "DK/Odense"),  # Great Belt fixed link
    ("DK/Frederiksberg", "DK/Odense"),  # Great Belt fixed link
    ("DK/Copenhagen", "DK/Århus"),  # Great Belt + Little Belt
    ("DK/Frederiksberg", "DK/Århus"),  # Great Belt + Little Belt
    ("DK/Copenhagen", "DK/Aalborg"),  # Great Belt + Little Belt
    ("DK/Odense", "DK/Århus"),  # Little Belt bridge
    ("DK/Odense", "DK/Aalborg"),  # Little Belt bridge
    ("SE/Malmö", "DK/Odense"),  # Oresund + Great Belt
    ("SE/Malmö", "DK/Århus"),  # Oresund + Great Belt
    ("SE/Malmö", "DK/Aalborg"),  # Oresund + Great Belt
    ("SE/Gothenburg", "DK/Copenhagen"),  # Oresund bridge trains
    ("SE/Gothenburg", "DK/Frederiksberg"),  # Oresund bridge
    ("SE/Stockholm", "DK/Copenhagen"),  # Oresund bridge trains
    ("SE/Uppsala", "DK/Copenhagen"),  # Oresund bridge
    ("SE/Linköping", "DK/Copenhagen"),  # Oresund bridge
    ("SE/Stockholm", "SE/Malmö"),  # all-land E4; Baltic graze
    ("SE/Gothenburg", "SE/Malmö"),  # all-land E6; Kattegat graze
    ("NO/Oslo", "SE/Malmö"),  # all-land E6 via Svinesund bridge
    ("NO/Oslo", "DK/Copenhagen"),  # E6 + Oresund, direct trains
    ("NO/Oslo", "DK/Frederiksberg"),  # E6 + Oresund
    ("NO/Trondheim", "NO/Stavanger"),  # all-land E6/E134 inland
    # -- Baltic rim: continuous land corridors whose chords cross
    # the Gulfs of Finland/Riga. Finland-Baltics pairs stay
    # blocked (real route is the Tallinn ferry).
    ("EE/Tallinn", "LV/Riga"),  # Via Baltica E67, all land
    ("RU/Saint Petersburg", "FI/Helsinki"),  # E18 via Vyborg
    ("RU/Saint Petersburg", "FI/Espoo"),  # E18 via Vyborg
    ("RU/Saint Petersburg", "FI/Vantaa"),  # E18 via Vyborg
    ("RU/Saint Petersburg", "FI/Tampere"),  # E18 via Vyborg
    ("RU/Saint Petersburg", "EE/Tallinn"),  # E20 via Narva
    ("RU/Saint Petersburg", "EE/Kohtla-Järve"),  # E20 via Narva
    # -- Mediterranean coastal corridors, all land end to end;
    # chords graze offshore water along concave coastlines.
    ("TR/Istanbul", "TR/Bursa"),  # Osman Gazi bridge (O-5)
    ("TR/Istanbul", "TR/İzmir"),  # Osman Gazi bridge + O-5
    ("GR/Athens", "GR/Lárisa"),  # A1 motorway, all land
    ("GR/Thessaloníki", "GR/Lárisa"),  # A1 motorway, all land
    ("GR/Athens", "GR/Pátra"),  # A8 over the Corinth Canal
    ("GR/Pátra", "GR/Piraeus"),  # A8 over the Corinth Canal
    ("GR/Thessaloníki", "GR/Pátra"),  # Rio-Antirrio bridge route
    ("IT/Rome", "IT/Naples"),  # A1 autostrada; Gaeta gulf graze
    ("HR/Split", "HR/Rijeka"),  # A1 motorway; Adriatic graze
    ("AL/Vlorë", "AL/Shkodër"),  # SH2/A1 corridor, all land
    ("AL/Durrës", "AL/Shkodër"),  # SH2 corridor, all land
    ("ES/Barcelona", "ES/Valencia"),  # AP-7 + Euromed rail
    ("ES/Barcelona", "ES/Sevilla"),  # AVE rail, all land
    ("FR/Marseille", "FR/Toulouse"),  # A61/A9; Gulf of Lion graze
    ("PT/Porto", "PT/Amadora"),  # A1 Porto-Lisbon, all land
    # -- North Africa coastal corridors, all land.
    ("MA/Casablanca", "MA/Rabat"),  # A1 + Al Boraq high-speed rail
    ("MA/Rabat", "MA/Tangier"),  # A1 + Al Boraq high-speed rail
    ("MA/Casablanca", "MA/Tangier"),  # A1 + Al Boraq rail
    ("TN/Tunis", "TN/Sousse"),  # A1 motorway, all land
    ("TN/Sousse", "TN/Sukrah"),  # A1 motorway, all land
    ("DZ/Algiers", "DZ/Annaba"),  # East-West motorway, all land
    ("DZ/Annaba", "DZ/Blida"),  # East-West motorway, all land
    ("LY/Tripoli", "LY/Misratah"),  # coastal highway, all land
    ("LY/Misratah", "LY/Al Khums"),  # coastal highway, all land
    ("EG/Alexandria", "EG/Port Said"),  # International Coastal Rd
    # -- Gulf fixed links and land borders.
    ("BH/Manama", "SA/Dammam"),  # King Fahd Causeway
    ("BH/Al Muharraq", "SA/Dammam"),  # King Fahd Causeway
    ("BH/Ar Rifā‘", "SA/Dammam"),  # King Fahd Causeway
    ("BH/Sitrah", "SA/Dammam"),  # King Fahd Causeway
    ("BH/Madīnat Ḩamad", "SA/Dammam"),  # King Fahd Causeway
    ("BH/Manama", "SA/Riyadh"),  # King Fahd Causeway
    ("BH/Al Muharraq", "SA/Riyadh"),  # King Fahd Causeway
    ("BH/Ar Rifā‘", "SA/Riyadh"),  # King Fahd Causeway
    ("BH/Sitrah", "SA/Riyadh"),  # King Fahd Causeway
    ("BH/Madīnat Ḩamad", "SA/Riyadh"),  # King Fahd Causeway
    ("IQ/Basrah", "KW/Ḩawallī"),  # Highway 80 via Safwan border
    ("IQ/Basrah", "KW/Şabāḩ as Sālim"),  # Highway 80 via Safwan
    ("IQ/Basrah", "KW/Al Aḩmadī"),  # Highway 80 via Safwan
    ("IQ/Basrah", "KW/Al Faḩāḩīl"),  # Highway 80 via Safwan
    ("AE/Abu Dhabi", "AE/Sharjah"),  # E11 highway, all land
    ("AE/Abu Dhabi", "AE/Ajman"),  # E11 highway, all land
    ("IR/Mashhad", "IR/Tabriz"),  # all-land via Tehran; chord
    # crosses the Caspian cutout
    ("TM/Ashgabat", "TM/Türkmenbaşy"),  # M37; Caspian gulf graze
    ("TM/Mary", "TM/Türkmenbaşy"),  # M37; Caspian gulf graze
    ("UA/Odesa", "UA/Donetsk"),  # M14; Dnieper estuary graze
    # -- Japan (primary market). Honshu-Kyushu pairs ride the
    # Kanmon tunnels (San'yo Shinkansen + Kanmon expressway);
    # Sapporo-eastern-Honshu pairs ride the Seikan tunnel
    # (Hokkaido Shinkansen); Tokyo Bay is crossed by the
    # Aqua-Line and ringed by land via Tokyo; Inland Sea grazes
    # follow the all-land San'yo corridor along Honshu.
    # Sapporo x western Japan stays blocked: those chords run
    # hundreds of km over the open Pacific and straight-line
    # ground distance would be badly wrong.
    ("JP/Chiba", "JP/Kawasaki"),  # Tokyo Bay Aqua-Line
    ("JP/Chiba", "JP/Yokohama"),  # Tokyo Bay Aqua-Line
    ("JP/Chiba", "JP/Nagoya"),  # land ring via Tokyo (Tokaido)
    ("JP/Chiba", "JP/Kyoto"),  # land ring via Tokyo (Tokaido)
    ("JP/Chiba", "JP/Osaka"),  # land ring via Tokyo (Tokaido)
    ("JP/Chiba", "JP/Kobe"),  # land ring via Tokyo (Tokaido)
    ("JP/Chiba", "JP/Sakai"),  # land ring via Tokyo (Tokaido)
    ("JP/Chiba", "JP/Hiroshima"),  # Tokaido + San'yo corridor
    ("JP/Chiba", "JP/Kitakyushu"),  # San'yo + Kanmon tunnels
    ("JP/Chiba", "JP/Fukuoka"),  # San'yo + Kanmon tunnels
    ("JP/Chiba", "JP/Sapporo"),  # Tohoku + Seikan tunnel
    ("JP/Hiroshima", "JP/Yokohama"),  # all-land San'yo corridor
    ("JP/Hiroshima", "JP/Kobe"),  # all-land San'yo corridor
    ("JP/Hiroshima", "JP/Osaka"),  # all-land San'yo corridor
    ("JP/Hiroshima", "JP/Sakai"),  # all-land San'yo corridor
    ("JP/Hiroshima", "JP/Sendai"),  # all-land Tohoku + San'yo
    ("JP/Fukuoka", "JP/Hiroshima"),  # Kanmon tunnels
    ("JP/Fukuoka", "JP/Kyoto"),  # Kanmon + San'yo Shinkansen
    ("JP/Fukuoka", "JP/Kobe"),  # Kanmon + San'yo Shinkansen
    ("JP/Fukuoka", "JP/Osaka"),  # Kanmon + San'yo Shinkansen
    ("JP/Fukuoka", "JP/Sakai"),  # Kanmon + San'yo Shinkansen
    ("JP/Fukuoka", "JP/Nagoya"),  # Kanmon + San'yo Shinkansen
    ("JP/Fukuoka", "JP/Saitama"),  # Kanmon + San'yo Shinkansen
    ("JP/Fukuoka", "JP/Tokyo"),  # Kanmon + San'yo Shinkansen
    ("JP/Fukuoka", "JP/Kawasaki"),  # Kanmon + San'yo Shinkansen
    ("JP/Fukuoka", "JP/Yokohama"),  # Kanmon + San'yo Shinkansen
    ("JP/Fukuoka", "JP/Sendai"),  # Kanmon + San'yo Shinkansen
    ("JP/Kitakyushu", "JP/Kyoto"),  # Kanmon tunnels
    ("JP/Kitakyushu", "JP/Tokyo"),  # Kanmon tunnels
    ("JP/Kitakyushu", "JP/Nagoya"),  # Kanmon tunnels
    ("JP/Kitakyushu", "JP/Kobe"),  # Kanmon tunnels
    ("JP/Kitakyushu", "JP/Osaka"),  # Kanmon tunnels
    ("JP/Kitakyushu", "JP/Sakai"),  # Kanmon tunnels
    ("JP/Kitakyushu", "JP/Yokohama"),  # Kanmon tunnels
    ("JP/Kitakyushu", "JP/Kawasaki"),  # Kanmon tunnels
    ("JP/Kitakyushu", "JP/Sendai"),  # Kanmon tunnels
    ("JP/Sapporo", "JP/Tokyo"),  # Seikan tunnel (Shinkansen)
    ("JP/Sapporo", "JP/Saitama"),  # Seikan tunnel
    ("JP/Sapporo", "JP/Kawasaki"),  # Seikan tunnel
    ("JP/Sapporo", "JP/Yokohama"),  # Seikan tunnel
    ("JP/Sapporo", "JP/Sendai"),  # Seikan tunnel
    # -- Pearl River Delta and Chinese trunk corridors.
    ("HK/Hong Kong", "MO/Macau"),  # HK-Zhuhai-Macau bridge
    ("HK/Hong Kong", "MO/Sé"),  # HK-Zhuhai-Macau bridge
    ("HK/Hong Kong", "MO/Taipa"),  # HK-Zhuhai-Macau bridge
    ("HK/Hong Kong", "MO/Zhuojiacun"),  # HK-Zhuhai-Macau bridge
    ("HK/Hong Kong", "MO/Luhuan"),  # HK-Zhuhai-Macau bridge
    ("HK/Victoria", "MO/Macau"),  # HK-Zhuhai-Macau bridge
    ("HK/Victoria", "MO/Sé"),  # HK-Zhuhai-Macau bridge
    ("HK/Victoria", "MO/Taipa"),  # HK-Zhuhai-Macau bridge
    ("HK/Victoria", "MO/Zhuojiacun"),  # HK-Zhuhai-Macau bridge
    ("HK/Victoria", "MO/Luhuan"),  # HK-Zhuhai-Macau bridge
    ("HK/Sham Shui Po", "MO/Macau"),  # HK-Zhuhai-Macau bridge
    ("HK/Sham Shui Po", "MO/Sé"),  # HK-Zhuhai-Macau bridge
    ("HK/Sham Shui Po", "MO/Taipa"),  # HK-Zhuhai-Macau bridge
    ("HK/Sham Shui Po", "MO/Zhuojiacun"),  # HZM bridge
    ("HK/Sham Shui Po", "MO/Luhuan"),  # HK-Zhuhai-Macau bridge
    ("HK/Sha Tin", "MO/Macau"),  # HK-Zhuhai-Macau bridge
    ("HK/Sha Tin", "MO/Sé"),  # HK-Zhuhai-Macau bridge
    ("HK/Sha Tin", "MO/Taipa"),  # HK-Zhuhai-Macau bridge
    ("HK/Sha Tin", "MO/Zhuojiacun"),  # HK-Zhuhai-Macau bridge
    ("HK/Sha Tin", "MO/Luhuan"),  # HK-Zhuhai-Macau bridge
    ("HK/Tuen Mun", "MO/Macau"),  # HK-Zhuhai-Macau bridge
    ("HK/Tuen Mun", "MO/Sé"),  # HK-Zhuhai-Macau bridge
    ("HK/Tuen Mun", "MO/Taipa"),  # HK-Zhuhai-Macau bridge
    ("HK/Tuen Mun", "MO/Zhuojiacun"),  # HK-Zhuhai-Macau bridge
    ("HK/Tuen Mun", "MO/Luhuan"),  # HK-Zhuhai-Macau bridge
    ("CN/Guangzhou", "HK/Hong Kong"),  # XRL rail via Shenzhen
    ("CN/Guangzhou", "HK/Victoria"),  # XRL rail via Shenzhen
    ("CN/Guangzhou", "HK/Sham Shui Po"),  # XRL rail via Shenzhen
    ("CN/Guangzhou", "HK/Sha Tin"),  # XRL rail via Shenzhen
    ("CN/Guangzhou", "HK/Tuen Mun"),  # XRL rail via Shenzhen
    ("CN/Chengdu", "HK/Hong Kong"),  # all-land HSR via Shenzhen
    ("CN/Chengdu", "HK/Victoria"),  # all-land HSR via Shenzhen
    ("CN/Chengdu", "HK/Sham Shui Po"),  # all-land HSR
    ("CN/Chengdu", "HK/Tuen Mun"),  # all-land HSR via Shenzhen
    ("CN/Shenzhen", "MO/Macau"),  # Shenzhen-Zhongshan link (2024)
    ("CN/Shenzhen", "MO/Sé"),  # Shenzhen-Zhongshan link
    ("CN/Shenzhen", "MO/Taipa"),  # Shenzhen-Zhongshan link
    ("CN/Shenzhen", "MO/Zhuojiacun"),  # Shenzhen-Zhongshan link
    ("CN/Shenzhen", "MO/Luhuan"),  # Shenzhen-Zhongshan link
    ("CN/Beijing", "MO/Macau"),  # all-land rail via Zhuhai
    ("CN/Beijing", "MO/Sé"),  # all-land rail via Zhuhai
    ("CN/Beijing", "MO/Taipa"),  # all-land rail via Zhuhai
    ("CN/Beijing", "MO/Zhuojiacun"),  # all-land rail via Zhuhai
    ("CN/Beijing", "MO/Luhuan"),  # all-land rail via Zhuhai
    ("CN/Shanghai", "MO/Macau"),  # all-land rail via Zhuhai
    ("CN/Shanghai", "MO/Sé"),  # all-land rail via Zhuhai
    ("CN/Shanghai", "MO/Taipa"),  # all-land rail via Zhuhai
    ("CN/Shanghai", "MO/Zhuojiacun"),  # all-land rail via Zhuhai
    ("CN/Shanghai", "MO/Luhuan"),  # all-land rail via Zhuhai
    ("CN/Shanghai", "CN/Beijing"),  # Jinghu HSR; Bohai graze
    # -- South and Southeast Asia land corridors.
    ("IN/Mumbai", "IN/Ahmedabad"),  # NH48/Western Railway; chord
    # crosses the Gulf of Khambhat
    ("BD/Dhaka", "BD/Chattogram"),  # N1 + Meghna bridges
    ("BD/Chattogram", "BD/Gazipur"),  # N1 + Meghna bridges
    ("BD/Chattogram", "BD/Khulna"),  # Padma bridge + N1
    ("MM/Yangon", "MM/Mawlamyine"),  # AH1 + Thanlwin bridge
    ("MM/Hlaingthaya", "MM/Mawlamyine"),  # AH1 + Thanlwin bridge
    # -- Americas coastal corridors, all land.
    ("BR/São Paulo", "BR/Rio de Janeiro"),  # BR-116 Via Dutra
    ("UY/Montevideo", "UY/Maldonado"),  # Ruta IB, all land
    ("PE/Callao", "PE/Trujillo"),  # Pan-American Highway
    ("PE/Lima", "PE/Piura"),  # Pan-American Highway
    ("PE/Callao", "PE/Piura"),  # Pan-American Highway
    ("VE/Caracas", "VE/Maracaibo"),  # Rafael Urdaneta bridge
    ("CU/Havana", "CU/Santiago de Cuba"),  # Carretera Central
    ("PA/David", "PA/Colón"),  # Pan-American Highway via Panama
    # -- Sub-Saharan coastal corridors, all land.
    ("GH/Accra", "GH/Sekondi"),  # N1 coastal highway
    ("GH/Accra", "GH/Takoradi"),  # N1 coastal highway
    ("NG/Lagos", "NG/Port Harcourt"),  # A2/E1 land route; chord
    # crosses the Gulf of Guinea
    ("MZ/Maputo", "MZ/Beira"),  # EN1, all land
    ("MZ/Matola", "MZ/Beira"),  # EN1, all land
]

TOP_BLOCKED_REPORT = 15


def city_key(city):
    return f"{city['cc']}/{city['name']}"


def load_land():
    polys = []
    for rec in shapefile.Reader(str(LAND_SHP)).shapes():
        polys.append(shape(rec.__geo_interface__))
    land = shapely.union_all(polys)
    shapely.prepare(land)
    return land


def haversine_km(lat1, lon1, lat2, lon2):
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dp = p2 - p1
    dl = math.radians(lon2 - lon1)
    a = (
        math.sin(dp / 2) ** 2
        + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
    )
    return 2 * EARTH_RADIUS_KM * math.asin(math.sqrt(a))


def unit_vector(lat, lon):
    p, l = math.radians(lat), math.radians(lon)
    return np.array(
        [math.cos(p) * math.cos(l), math.cos(p) * math.sin(l), math.sin(p)]
    )


def sample_chord(v1, v2, dist_km, step_km):
    """Great-circle samples between two unit vectors (slerp).

    Linear lat/lon interpolation shears long chords at high
    latitude, so sampling stays on the sphere.
    """
    omega = math.acos(max(-1.0, min(1.0, float(np.dot(v1, v2)))))
    n = max(2, int(math.ceil(dist_km / step_km)) + 1)
    t = np.linspace(0.0, 1.0, n)
    if omega < 1e-12:
        pts = np.outer(np.ones(n), v1)
    else:
        s = math.sin(omega)
        pts = (
            np.outer(np.sin((1 - t) * omega) / s, v1)
            + np.outer(np.sin(t * omega) / s, v2)
        )
    lats = np.degrees(np.arcsin(np.clip(pts[:, 2], -1.0, 1.0)))
    lons = np.degrees(np.arctan2(pts[:, 1], pts[:, 0]))
    return lats, lons


def longest_water_span_km(land, v1, v2, dist_km):
    lats, lons = sample_chord(v1, v2, dist_km, COARSE_STEP_KM)
    if bool(np.all(shapely.contains_xy(land, lons, lats))):
        # No wet coarse sample bounds every wet span below
        # COARSE_STEP_KM, which is under the block threshold.
        return 0.0
    lats, lons = sample_chord(v1, v2, dist_km, SAMPLE_STEP_KM)
    wet = ~shapely.contains_xy(land, lons, lats)
    best = 0.0
    run_start = None
    for i, w in enumerate(np.append(wet, False)):
        if w and run_start is None:
            run_start = i
        elif not w and run_start is not None:
            span = haversine_km(
                lats[run_start], lons[run_start], lats[i - 1], lons[i - 1]
            )
            best = max(best, span)
            run_start = None
    return best


def candidate_pairs(cities):
    """Unordered same-mass index pairs within ground range."""
    by_mass = {}
    for i, c in enumerate(cities):
        by_mass.setdefault(c["mass"], []).append(i)
    pairs = []
    for idxs in by_mass.values():
        lats = np.radians([cities[i]["lat"] for i in idxs])
        lons = np.radians([cities[i]["lon"] for i in idxs])
        for a, i in enumerate(idxs):
            dp = lats[a + 1:] - lats[a]
            dl = lons[a + 1:] - lons[a]
            h = (
                np.sin(dp / 2) ** 2
                + math.cos(lats[a]) * np.cos(lats[a + 1:]) * np.sin(dl / 2) ** 2
            )
            d = 2 * EARTH_RADIUS_KM * np.arcsin(np.sqrt(h))
            for b in np.nonzero(d <= GROUND_MODE_MAX_KM)[0]:
                j = idxs[a + 1 + b]
                pairs.append((min(i, j), max(i, j), float(d[b])))
    return pairs


def resolve_manual(cities, entries, label):
    index = {city_key(c): i for i, c in enumerate(cities)}
    resolved = set()
    for a, b in entries:
        if a not in index or b not in index:
            sys.exit(f"{label}: unknown city in ({a}, {b})")
        i, j = sorted((index[a], index[b]))
        if cities[i]["mass"] != cities[j]["mass"]:
            sys.exit(f"{label}: ({a}, {b}) is cross-mass; not applicable")
        resolved.add((i, j))
    return resolved


def main():
    start = time.time()
    with open(CITIES_PATH, encoding="utf-8") as f:
        payload = json.load(f)
    cities = payload["cities"]
    links_before = json.dumps(payload["metadata"]["links"])
    cities_before = json.dumps(cities)

    land = load_land()
    manual_block = resolve_manual(cities, MANUAL_BLOCK, "MANUAL_BLOCK")
    manual_allow = resolve_manual(cities, MANUAL_ALLOW, "MANUAL_ALLOW")

    pairs = candidate_pairs(cities)
    blocked = {}
    allowed = []
    for i, j, dist in pairs:
        v1 = unit_vector(cities[i]["lat"], cities[i]["lon"])
        v2 = unit_vector(cities[j]["lat"], cities[j]["lon"])
        span = longest_water_span_km(land, v1, v2, dist)
        if span <= WATER_SPAN_BLOCK_KM:
            continue
        if (i, j) in manual_allow:
            allowed.append((i, j, span))
            continue
        blocked[(i, j)] = span
    stale_allow = manual_allow - {(i, j) for i, j, _ in allowed}
    for i, j in sorted(stale_allow):
        print(
            "WARNING stale MANUAL_ALLOW (not blocked): "
            f"{city_key(cities[i])} - {city_key(cities[j])}"
        )
    for pair in manual_block:
        blocked.setdefault(pair, 0.0)

    result = sorted(blocked)
    payload["metadata"]["water_blocked"] = [list(p) for p in result]

    # The blocklist is the only thing this script may change.
    assert json.dumps(payload["metadata"]["links"]) == links_before
    assert json.dumps(payload["cities"]) == cities_before
    with open(CITIES_PATH, "w", encoding="utf-8") as f:
        json.dump(payload, f, ensure_ascii=False, separators=(",", ":"))
        f.write("\n")

    print(f"pairs scanned: {len(pairs)}")
    print(f"blocked: {len(result)} (manual: {len(manual_block)})")
    print(f"allowed by MANUAL_ALLOW: {len(allowed)}")
    top = sorted(
        blocked,
        key=lambda p: -(cities[p[0]]["pop"] + cities[p[1]]["pop"]),
    )[:TOP_BLOCKED_REPORT]
    print("top blocked pairs by combined population:")
    for i, j in top:
        print(
            f"  {city_key(cities[i])} - {city_key(cities[j])}"
            f" (span {blocked[(i, j)]:.0f} km)"
        )
    print(f"runtime: {time.time() - start:.1f}s")


if __name__ == "__main__":
    main()
