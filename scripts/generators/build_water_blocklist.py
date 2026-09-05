#!/usr/bin/env python3
"""Inject metadata.water_blocked into data/app/cities.json.

City pairs the picker would ground can still face open water the
landmass model cannot see: same-mass pairs across enclosed seas
(Helsinki-Tallinn share Eurasia) and rail_tunnel-linked cross-mass
pairs (the Channel Tunnel grounds every GB-Eurasia pair, including
Glasgow-Stavanger across the North Sea).

Blocking criterion (Fix Backlog 4, R4; honesty test made
unconditional in R6): a candidate pair is blocked iff no honest
land route exists -- for wet chords (more than
WATER_SPAN_BLOCK_KM of continuous water against Natural Earth
1:50m land polygons) AND, since Round 6, equally for dry chords,
so border walls and front lines block the corridors they cut
without hand-curated pair lists. The
honesty test runs on a rasterized land graph (RASTER_DEG cells,
8-connected, geodesic edge weights) augmented with FIXED_CROSSINGS
(real bridges/tunnels/causeways): the pair stays open when the
shortest land path is at most DETOUR_MAX x straight-line (+
PATH_SLACK_KM for grid discretization on short hops). This
replaces the Round 3 pair-by-pair MANUAL_ALLOW curation, which a
Round 4 audit showed had a false-positive class in the hundreds
(Jakarta-Surabaya, Bangkok-KL, Lagos-Accra...).

Honesty bar (calibrated 2026-07-19): the
app shows estimate = GROUND_CIRCUITY x straight, so a corridor is
honest when real-road <= HONESTY_MAX x that estimate. Grid paths
underestimate real roads by ~ROAD_OVER_GEODESIC, giving
  block iff grid_path > (HONESTY_MAX x GROUND_CIRCUITY /
  ROAD_OVER_GEODESIC) x straight + PATH_SLACK_KM  (~1.58x).
Verified verdicts at this bar: open -- Copenhagen-Hamburg (1.39),
Istanbul-Bursa (1.30 via Osman Gazi), London-Madrid/Copenhagen/
Stockholm (via tunnel), Bangkok-KL (1.26), Jakarta-Surabaya,
Lagos-Accra, Auckland-Wellington, Dubai-Muscat, Colombo-Jaffna;
blocked -- Malmo-Arhus (1.78), Buenos Aires-Montevideo (~2.7),
Bahrain-Qatar (~2.4), Stockholm-Helsinki (~6), Helsinki-Tallinn,
Glasgow-Stavanger (~3).

Political closures are water-independent (Fix Backlog 5, R5):
CLOSED_BORDERS blocks every candidate pair between two countries
whose shared border is closed (owner rule 2026-07-20, no
honest-detour exception); BORDER_WALLS are polylines that cut
land-graph edges before pathfinding, so closed borders and
fake-land raster artifacts also stop third-country TRANSIT;
DISHONEST_CC_PAIRS blocks country pairs whose corridors measure
dishonest as a class; MANUAL_BLOCK holds pair-level cases (front
lines, closed crossings, sub-resolution rivers). MANUAL_ALLOW
remains only as a rare escape hatch.

Known gaps (documented in RESEARCH_TRANSPORT.md sec 9): lakes are
not in ne_50m_land (Kampala-Mwanza keeps ground across Lake
Victoria); blocked pairs may still receive the >= 100 km air
fallback even where no flight exists (Seoul-Pyongyang).

Usage (from repo root, seed conda env):
  python scripts/generators/build_water_blocklist.py

Rewrites data/app/cities.json in place, touching only
metadata.water_blocked. Run sweep_suggestions.py afterwards.
"""
import json
import math
import sys
import time
from datetime import date
from pathlib import Path

import numpy as np
import shapefile
import shapely
from scipy.sparse import csr_matrix
from scipy.sparse.csgraph import connected_components, dijkstra
from shapely.geometry import shape

from geo import EARTH_RADIUS_KM, haversine_km

REPO_ROOT = Path(__file__).resolve().parents[2]
CITIES_PATH = REPO_ROOT / "data" / "app" / "cities.json"
NE_DIR = REPO_ROOT / "data" / "reference" / "natural_earth"
LAND_SHP = NE_DIR / "ne_50m_land.shp"
RASTER_CACHE = NE_DIR / "land_raster_0p1.npz"

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

# Land raster resolution and coverage. Cities outside the band
# (SJ/Longyearbyen, 78.2N) cannot snap; their candidate pairs
# auto-block, and main() prints a note per out-of-band city
# (R6-14).
RASTER_DEG = 0.1
LAT_MIN, LAT_MAX = -60.0, 75.0
# Cities/crossing endpoints may fall in a sea cell at 0.1 deg;
# snap to the nearest land cell within this Chebyshev radius.
SNAP_CELLS = 5

# Honesty bar for the land-path detour (see module docstring).
# GROUND_CIRCUITY mirrors groundCircuityFactor in the Dart.
GROUND_CIRCUITY = 1.3
HONESTY_MAX = 1.4
ROAD_OVER_GEODESIC = 1.15
PATH_LIMIT_FACTOR = HONESTY_MAX * GROUND_CIRCUITY / ROAD_OVER_GEODESIC
PATH_SLACK_KM = 30.0

# Real fixed crossings injected as graph edges. Rail-only links
# count: the ground suggestion kind covers rail modes (Seikan and
# the Channel Tunnel carry passengers without a road). Verified
# needed 2026-07-19: removing any entry below flips at least one
# must-open corridor to blocked. Not included: Rodby-Puttgarden
# (ferry until the Fehmarnbelt tunnel opens ~2029).
FIXED_CROSSINGS = [
    ("Channel Tunnel", 51.097, 1.121, 50.923, 1.781),
    ("Oresund bridge", 55.61, 12.68, 55.57, 12.98),
    ("Great Belt fixed link", 55.341, 11.136, 55.295, 10.828),
    # Endpoints sit well inland of the ~1 km strait: closer
    # points collapse into one raster cell, making the edge a
    # useless self-loop (Fredericia/Jutland - Middelfart/Funen).
    ("Little Belt bridge", 55.57, 9.53, 55.49, 9.79),
    ("Bosphorus bridges", 41.09, 29.03, 41.09, 29.06),
    # Gelibolu (European) - Lapseki (Asian); earlier endpoints
    # snapped to the same shore and the edge did nothing (R5-11).
    ("1915 Canakkale bridge", 40.41, 26.67, 40.34, 26.69),
    ("Kanmon tunnels", 33.96, 130.94, 33.93, 130.96),
    ("Seikan tunnel", 41.45, 140.12, 41.20, 140.32),
    # Kawasaki shore - Kisarazu; the old west endpoint was the
    # mid-bay Umihotaru island and self-looped (R5-11).
    ("Tokyo Bay Aqua-Line", 35.51, 139.79, 35.39, 139.92),
    ("HK-Zhuhai-Macau bridge", 22.30, 113.94, 22.22, 113.55),
    ("Shenzhen-Zhongshan link", 22.59, 113.78, 22.51, 113.55),
    ("King Fahd Causeway", 26.20, 50.45, 26.24, 50.32),
    ("Osman Gazi bridge", 40.757, 29.513, 40.646, 29.516),
    ("Johor-Singapore Causeway", 1.45, 103.77, 1.44, 103.77),
    # Patras side vs Antirrio inland; the old endpoints collapsed
    # into one raster cell and self-looped (R5-11).
    ("Rio-Antirrio bridge", 38.28, 21.79, 38.37, 21.75),
    # Crosses the Lake Maracaibo outlet (Route 3); found by the
    # R7 diff audit when the unconditional path test falsely
    # blocked Maracaibo-Valencia/Barquisimeto (~1.8x around the
    # lake vs an honest bridge road).
    ("General Rafael Urdaneta Bridge", 10.60, -71.62, 10.52, -71.51),
]

# Weight slack for the crossing self-check: a crossing is
# load-bearing when the crossings-free grid path between its
# snapped cells exceeds the edge weight by at least this margin.
CROSSING_CHECK_SLACK_KM = 20.0
CROSSING_CHECK_LIMIT_KM = 100.0

# Border verdicts carry expiry risk: a closed border reopens and a
# stale verdict silently blocks honest corridors. Re-verify live,
# then move this date. Watchlist in PDR_TRANSPORT_CALCULATOR.md 2.4.
BORDER_VERDICTS_VERIFIED = date(2026, 7, 21)
BORDER_VERDICT_MAX_AGE_DAYS = 180


# Country pairs whose shared border is closed to travel; every
# candidate pair between the two countries is blocked regardless
# of water or detour honesty (owner rule 2026-07-20; extended
# 2026-07-21: active fighting between two countries closes the
# border, and doubt resolves to blocked). Verified
# 2026-07-21: KP-KR (DMZ, no civilian transit since 1953); IL-LB
# and IL-SY (state of war, lines closed); AM-AZ (closed since
# 1991); RU-FI (crossings closed 2023-12-15, extended "until
# further notice" 2026-06-04); DZ-MA (sealed since 1994); RU-UA
# and BY-UA (war, closed since 2022-02); IN-PK (Attari-Wagah
# shut 2025-04); ER-DJ (Ras Doumeira standoff, closed since
# 2008).
# Round 6 additions, all live-verified 2026-07-21: AM-TR (shut
# since 1993, reopening still conditional on an AM-AZ treaty);
# DO-HT (closed 2023-09, wall + deportations through 2026);
# AF-PK (Torkham one-way repatriation only since 2026-03,
# Chaman trade-only); BD-MM (no crossing open to travelers,
# Rakhine); IN-MM (FMR scrapped 2024, 10 km border passes
# only); KE-SO (closed since 2011; Ruto 2026-05 "not open");
# SA-YE (Al Wadiah pilgrim/aid convoys only); BJ-NE (Niger side
# shut since the 2023 coup; 2026-06 reopening accord is
# prospective -- WATCHLIST, likely to genuinely reopen); SD-TD
# (Adre aid-only); SD-SS (refugee flow, no regular crossing);
# SD-EG (refugee corridor, not regular travel; owner call
# 2026-07-21); DZ-LY (sources conflict on the 2023 Debdeb
# reopening; blocked per the owner in-doubt rule).
CLOSED_BORDERS = [
    ("KP", "KR"),
    ("IL", "LB"),
    ("IL", "SY"),
    ("AM", "AZ"),
    ("RU", "FI"),
    ("DZ", "MA"),
    ("RU", "UA"),
    ("BY", "UA"),
    ("IN", "PK"),
    ("ER", "DJ"),
    ("AM", "TR"),
    ("DO", "HT"),
    ("AF", "PK"),
    ("BD", "MM"),
    ("IN", "MM"),
    ("KE", "SO"),
    ("SA", "YE"),
    ("BJ", "NE"),
    ("SD", "TD"),
    ("SD", "SS"),
    ("SD", "EG"),
    ("DZ", "LY"),
]

# Country pairs whose every candidate corridor measures dishonest
# (real road vs the shown 1.3x estimate) because the grid's
# geodesics undercut the real detour (R5-7/8/9). Measured ratios
# in comments; pairs sharing one country but NOT listed stay on
# the automated test (Tehran-Kuwait/Manama and Kinshasa-Luanda
# verified honest).
DISHONEST_CC_PAIRS = [
    # Strait of Hormuz: no land link; the Kuwait-Saudi loop
    # measures ~1.6-2.3 across the class.
    ("IR", "AE"),
    # Tehran-Muscat ~2.0.
    ("IR", "OM"),
    # Tehran-Doha ~2.2.
    ("IR", "QA"),
    # Gulf of Guinea bight: the coastal loop via Cameroon-Nigeria
    # measures 1.4-1.65 for the Kinshasa/Brazzaville - Lagos/
    # Lome/Cotonou families.
    ("CD", "NG"),
    ("CD", "TG"),
    ("CD", "BJ"),
    ("CG", "NG"),
    ("CG", "TG"),
    ("CG", "BJ"),
    # Karachi-Dammam 1.85 around the Gulf.
    ("PK", "SA"),
]

# Polyline walls cut land-graph edges before pathfinding, so a
# closed border or fake-land artifact also stops third-country
# TRANSIT (a closed pair alone only blocks endpoints). Rough
# polylines are fine: a wall a few cells off the true line moves
# the barrier, not the connectivity. Each wall must cut at least
# one edge or the build aborts. Entries: (name, basis + verified
# date, [(lat, lon), ...]).
BORDER_WALLS = [
    ("KP-KR DMZ",
     "Military Demarcation Line, sealed since 1953; verified 2026-07-21",
     [(37.75, 124.9), (37.7, 125.7), (37.95, 126.67), (38.3, 127.5),
      (38.6, 128.35), (38.75, 128.7)]),
    ("RU-FI border",
     "closed 2023-12-15, extended until further notice 2026-06-04",
     [(60.15, 27.5), (60.55, 27.8), (61.15, 28.85), (61.6, 29.6),
      (62.2, 30.65), (62.9, 31.5), (63.8, 30.6), (64.7, 30.0),
      (65.7, 29.9), (66.6, 30.1), (67.3, 29.3), (68.1, 28.4),
      (69.05, 28.93)]),
    ("DZ-MA border",
     "sealed since 1994; verified 2026-07-21",
     [(35.5, -2.1), (34.85, -1.75), (33.0, -1.55), (32.1, -1.25),
      (30.5, -4.0), (28.8, -7.0), (27.66, -8.67)]),
    ("RU-UA border",
     "closed since 2022-02 invasion; verified 2026-07-21",
     [(46.6, 38.1), (47.1, 38.3), (47.85, 39.75), (48.9, 40.05),
      (49.3, 40.2), (50.0, 39.0), (50.4, 37.7), (50.45, 36.2),
      (50.35, 35.4), (51.25, 34.25), (52.0, 33.2), (52.12, 31.79)]),
    ("BY-UA border",
     "closed since 2022-02; verified 2026-07-21",
     [(52.12, 31.79), (51.55, 30.5), (51.5, 29.0), (51.6, 27.7),
      (51.9, 26.0), (51.85, 24.5), (51.55, 23.6)]),
    ("UA front line",
     "rough Donetsk arc, Dnipro mouth to the RU border; 2026-07-21",
     [(46.35, 32.35), (46.6, 33.2), (47.0, 34.2), (47.3, 35.3),
      (47.6, 36.6), (48.1, 37.5), (48.7, 38.0), (49.4, 38.3),
      (50.3, 38.3)]),
    ("IN-PK border",
     "Attari-Wagah shut 2025-04, LoC closed; verified 2026-07-21",
     [(23.3, 67.8), (23.9, 68.2), (24.3, 68.9), (25.5, 70.1),
      (27.0, 70.4), (28.2, 71.2), (29.6, 73.0), (30.5, 73.9),
      (31.6, 74.55), (32.5, 74.95), (33.2, 74.0), (34.0, 73.8),
      (34.6, 74.3), (34.8, 75.7), (35.0, 76.8), (35.6, 77.6)]),
    ("IL-SY line",
     "Golan ceasefire line, closed; verified 2026-07-21",
     [(33.55, 35.75), (33.2, 35.85), (32.85, 35.85), (32.68, 35.95)]),
    ("IL-LB Blue Line",
     "closed, state of war; verified 2026-07-21",
     [(33.05, 35.05), (33.09, 35.31), (33.28, 35.57), (33.33, 35.77),
      (33.55, 35.75)]),
    ("AM-AZ border",
     "closed since 1991 war; verified 2026-07-21",
     [(41.1, 45.05), (40.6, 45.55), (40.0, 45.9), (39.4, 45.75),
      (39.0, 46.4), (38.85, 46.6)]),
    ("AM-AZ Nakhchivan border",
     "closed since 1991 war; verified 2026-07-21",
     [(39.8, 44.95), (39.4, 45.15), (39.05, 45.4), (38.85, 45.62)]),
    ("GE-Abkhazia line + Greater Caucasus crest",
     "Enguri administrative line closed; the crest extension kills "
     "the raster's roadless over-the-ridge shortcut (no crossing "
     "exists between Psou and Verkhny Lars; Roki leads into the "
     "equally closed South Ossetia line); ends west of the open "
     "Dariali gorge; 2026-07-21",
     [(42.32, 41.5), (42.5, 41.87), (42.72, 42.2), (43.0, 42.5),
      (43.35, 42.7), (43.25, 43.2), (43.05, 43.7), (42.85, 44.15),
      (42.72, 44.42)]),
    ("RU-EE Narva segment",
     "Narva crossing closed to vehicles; wall follows the river and "
     "extends into Narva Bay (coastal cells leaked around a shorter "
     "wall); Luhamaa/Koidula south of the wall stay usable; verified "
     "2026-07-21",
     [(60.0, 27.7), (59.7, 27.95), (59.5, 28.02), (59.44, 28.08),
      (59.38, 28.20), (59.2, 28.12), (59.05, 27.85), (58.5, 27.5),
      (57.9, 27.6)]),
    ("VE-GY border",
     "no border road exists (R5-6); verified 2026-07-21",
     [(9.0, -59.8), (8.5, -60.0), (7.5, -60.35), (6.8, -61.05),
      (5.9, -61.35), (5.22, -60.73)]),
    ("ER-DJ border",
     "closed since the 2008 Ras Doumeira standoff; verified 2026-07-21",
     [(12.8, 43.2), (12.65, 43.0), (12.5, 42.65), (12.4, 42.35)]),
    ("SD front line (Kordofan)",
     "SAF-RSF de facto partition; RSF holds Darfur, front through "
     "central Kordofan (El Obeid flashpoint); rough line, verified "
     "2026-07-21 (R6-10)",
     [(22.0, 28.5), (20.0, 28.8), (18.0, 29.2), (16.0, 29.2),
      (14.5, 29.0), (13.2, 29.3), (12.0, 29.6), (10.8, 29.4),
      # south end crosses the SD-SS wall line; ending short left
      # a ~29 km gap the Nyala-Khartoum path slipped through
      (9.5, 29.2)]),
    ("SD-EG border",
     "refugee corridor only, no regular travel (owner call "
     "2026-07-21); also stops the western-desert transit that let "
     "Nyala-Port Sudan round the Kordofan wall's north end, and "
     "ER/ET-EG transit that would cross this line",
     [(22.0, 25.0), (22.0, 28.0), (22.0, 31.0), (22.0, 34.0),
      (21.95, 36.0), (21.9, 37.2)]),
    ("SD-SS border",
     "no regular crossing (refugee flow only); also stops transit "
     "around the Kordofan wall's south end; verified 2026-07-21",
     [(9.9, 24.8), (9.3, 25.8), (9.7, 27.0), (9.6, 28.0),
      (10.3, 29.0), (10.0, 30.5), (11.0, 31.8), (12.3, 32.3),
      (11.3, 33.2), (10.0, 33.9), (8.6, 34.1)]),
    # Fake-land raster artifacts (R5-5, R5-13): the 0.1 deg grid
    # reads these waters as land, so walls restore them.
    ("Amazon north channel + main stem fake land",
     "no road crossing of the lower Amazon exists; Amapa+GF sever "
     "from southern Brazil; 2026-07-21",
     [(1.0, -49.3), (0.3, -50.4), (-0.1, -50.9), (-0.9, -51.9),
      (-1.5, -52.7), (-2.0, -54.0), (-2.3, -54.9), (-1.95, -55.6),
      (-2.4, -56.5), (-2.8, -57.5), (-3.1, -58.6), (-3.3, -59.8)]),
    ("Para river channel (Marajo south) fake land",
     "Belem side of the delta; joins the main-stem wall; 2026-07-21",
     [(-0.4, -48.0), (-1.1, -48.65), (-1.6, -49.4), (-1.8, -50.4),
      (-1.6, -51.2), (-0.9, -51.9)]),
    ("Oslofjord fake land",
     "the raster pinches the fjord shut from Drobak (59.65N) north, "
     "letting paths jump it (R5-13); the real Drobak-tunnel corridor "
     "measures dishonest, so routing via Oslo is the honest model; "
     "2026-07-21",
     [(58.8, 10.45), (59.3, 10.55), (59.6, 10.60), (59.82, 10.60)]),
    ("Dardanelles fake land",
     "sub-resolution strait fuses Europe-Asia below the 1915 bridge; "
     "the explicit bridge edge carries the real link; 2026-07-21",
     [(39.95, 26.05), (40.05, 26.25), (40.15, 26.40), (40.23, 26.52),
      (40.33, 26.63), (40.43, 26.73)]),
]

# Pair-level blocks the raster cannot see. Keys are "CC/Name" as
# stored in the cities array.
MANUAL_BLOCK = [
    # Unbridged Congo river; Kinshasa-Brazzaville is ferry-only.
    ("CD/Kinshasa", "CG/Brazzaville"),
    # Front line crosses the corridor (R4-3).
    ("UA/Odesa", "UA/Donetsk"),
    # Narva closed to vehicles until the war ends; the open
    # detour via Luhamaa makes the estimate ~1.45x dishonest
    # (R4-4). SPb-Narva (R5-10) is worse (~3.6x); since the R6
    # unconditional path test it auto-blocks too -- these
    # entries stay as belt-and-braces.
    ("RU/Saint Petersburg", "EE/Tallinn"),
    ("RU/Saint Petersburg", "EE/Kohtla-Järve"),
    ("RU/Saint Petersburg", "EE/Narva"),
    # Abkhazia line, closed (Batumi-Sokhumi precedent).
    ("AM/Yerevan", "GE/Sokhumi"),
    ("AM/Gyumri", "GE/Sokhumi"),
    # GE-side Sokhumi pairs (R5-10): the real route runs via
    # Verkhny Lars (~1,400 km, ~4x), but grid geodesics through
    # the Caucasus undercut it below the automated bar even with
    # the crest wall, so these follow the Malmo-Arhus precedent.
    ("GE/Tbilisi", "GE/Sokhumi"),
    ("GE/Kutaisi", "GE/Sokhumi"),
    ("GE/Rustavi", "GE/Sokhumi"),
    # The 0.1 deg raster reads the Parana delta's channels as
    # land, faking a short path across the Rio de la Plata; the
    # real route runs ~700 km via the Zarate bridges.
    ("AR/Buenos Aires", "UY/Montevideo"),
    ("AR/Buenos Aires", "UY/Maldonado"),
    # Grid geodesics undercut real bridge-chain roads, so these
    # measured-dishonest corridors (R4-5; real road vs the shown
    # 1.3x estimate) slip the automated bar: Malmo-Arhus 1.8,
    # Malmo-Aalborg 1.6, Copenhagen-Aalborg 1.42 (+ twin),
    # Trondheim-Stavanger ~1.4-1.5 ferry-free (Boknafjord ferry
    # until Rogfast ~2033), Yangon-Mawlamyine 1.44 (+ twin).
    ("SE/Malmö", "DK/Århus"),
    ("SE/Malmö", "DK/Aalborg"),
    ("DK/Copenhagen", "DK/Aalborg"),
    ("DK/Frederiksberg", "DK/Aalborg"),
    ("NO/Trondheim", "NO/Stavanger"),
    ("MM/Yangon", "MM/Mawlamyine"),
    ("MM/Hlaingthaya", "MM/Mawlamyine"),
    # Istanbul-Greece corridors measure ~1.5x real vs estimate
    # (R5-8); the Izmir/Bursa siblings are already water-blocked.
    ("TR/Istanbul", "GR/Athens"),
    ("TR/Istanbul", "GR/Piraeus"),
    ("TR/Istanbul", "GR/Pátra"),
    # Skagerrak: the real route via Oslo measures 1.66x (R5-13).
    ("NO/Stavanger", "SE/Gothenburg"),
    # Around the Caspian via Iran/Azerbaijan measures ~1.6x.
    ("TM/Daşoguz", "GE/Kutaisi"),
    # Transnistrian-segment crossings shut since 2022; the real
    # route detours via Palanca (~2x the shown estimate). Blocked
    # per the owner in-doubt rule (R6-12, 2026-07-21); the other
    # MD-UA corridors via Palanca stay on the automated test.
    ("MD/Tiraspol", "UA/Odesa"),
]

# Escape hatch for pairs the land-graph test gets wrong. Empty by
# design after Fix Backlog 4: prefer fixing FIXED_CROSSINGS or the
# calibration over re-growing a curation list.
MANUAL_ALLOW = []

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
            # First-to-last wet sample understates the true span
            # by up to one step per side (R4-9); pad to keep the
            # error on the blocking (honest) side.
            best = max(best, span + SAMPLE_STEP_KM)
            run_start = None
    return best


def build_raster(land):
    """Boolean land raster at RASTER_DEG cell centers (cached)."""
    if RASTER_CACHE.exists():
        return np.load(RASTER_CACHE)["land"]
    n_lat = int(round((LAT_MAX - LAT_MIN) / RASTER_DEG))
    n_lon = int(round(360.0 / RASTER_DEG))
    lats = LAT_MIN + (np.arange(n_lat) + 0.5) * RASTER_DEG
    lons = -180.0 + (np.arange(n_lon) + 0.5) * RASTER_DEG
    grid = np.zeros((n_lat, n_lon), dtype=bool)
    for r in range(n_lat):
        grid[r] = shapely.contains_xy(land, lons, np.full(n_lon, lats[r]))
    np.savez_compressed(RASTER_CACHE, land=grid)
    return grid


def cell_of(lat, lon):
    r = int((lat - LAT_MIN) / RASTER_DEG)
    c = int((lon + 180.0) / RASTER_DEG)
    return r, c


def cell_center(r, c):
    return (
        LAT_MIN + (r + 0.5) * RASTER_DEG,
        -180.0 + (c + 0.5) * RASTER_DEG,
    )


def snap_to_land(grid, lat, lon):
    """Nearest land cell within SNAP_CELLS (coastal cities can
    fall in a sea cell at this resolution)."""
    r0, c0 = cell_of(lat, lon)
    n_lat, n_lon = grid.shape
    best, best_d = None, None
    for dr in range(-SNAP_CELLS, SNAP_CELLS + 1):
        r = r0 + dr
        if not 0 <= r < n_lat:
            continue
        for dc in range(-SNAP_CELLS, SNAP_CELLS + 1):
            c = (c0 + dc) % n_lon
            if not grid[r, c]:
                continue
            clat, clon = cell_center(r, c)
            d = haversine_km(lat, lon, clat, clon)
            if best_d is None or d < best_d:
                best, best_d = (r, c), d
    return best


def cut_wall_edges(rows, cols, node_lat, node_lon, walls):
    """Keep-mask over directed edges after removing every edge
    whose cell-center segment crosses a wall polyline. Prints a
    per-wall cut count; a wall that cuts nothing aborts the build
    (it is either mislocated or obsolete)."""
    keep = np.ones(len(rows), dtype=bool)
    la1, lo1 = node_lat[rows], node_lon[rows]
    la2, lo2 = node_lat[cols], node_lon[cols]
    # Longitude-wrap edges span the map in lon/lat space; no wall
    # sits near the antimeridian, so they are never candidates.
    no_wrap = np.abs(lo1 - lo2) < 180.0
    margin = 3 * RASTER_DEG
    for name, _basis, pts in walls:
        wall = shapely.linestrings([(lon, lat) for lat, lon in pts])
        lat_lo = min(p[0] for p in pts) - margin
        lat_hi = max(p[0] for p in pts) + margin
        lon_lo = min(p[1] for p in pts) - margin
        lon_hi = max(p[1] for p in pts) + margin
        cand = np.nonzero(
            keep & no_wrap
            & (np.minimum(la1, la2) <= lat_hi)
            & (np.maximum(la1, la2) >= lat_lo)
            & (np.minimum(lo1, lo2) <= lon_hi)
            & (np.maximum(lo1, lo2) >= lon_lo)
        )[0]
        cut = 0
        if len(cand):
            coords = np.empty((len(cand), 2, 2))
            coords[:, 0, 0] = lo1[cand]
            coords[:, 0, 1] = la1[cand]
            coords[:, 1, 0] = lo2[cand]
            coords[:, 1, 1] = la2[cand]
            hit = shapely.intersects(shapely.linestrings(coords), wall)
            keep[cand[hit]] = False
            cut = int(hit.sum())
        print(f"wall '{name}': {cut} edges cut")
        if cut == 0:
            sys.exit(f"BORDER_WALLS: '{name}' cut no edges")
    return keep


def check_crossings(grid_graph, snapped):
    """Every crossing's snapped cells must differ AND the edge
    must be load-bearing on the crossings-free graph (the grid
    path between its cells is meaningfully longer than the edge).
    Backlog 5 self-check: three entries were silently dead
    (R5-11)."""
    for name, a, b, w in snapped:
        if a == b:
            print(f"WARNING: dead crossing '{name}': endpoints "
                  "snap to the same raster cell (self-loop)")
            continue
        free = dijkstra(
            grid_graph, directed=False, indices=a,
            limit=w + CROSSING_CHECK_LIMIT_KM,
        )[b]
        if not free > w + CROSSING_CHECK_SLACK_KM:
            print(f"WARNING: dead crossing '{name}': crossings-free "
                  f"path {free:.0f} km vs edge {w:.0f} km -- the "
                  "edge is not load-bearing")


def build_land_graph(grid, crossings, walls):
    """8-connected CSR graph over land cells with geodesic edge
    weights, longitude-wrapped, minus wall-cut edges, plus
    fixed-crossing edges."""
    n_lat, n_lon = grid.shape
    node = np.full(grid.shape, -1, dtype=np.int32)
    land_idx = np.argwhere(grid)
    node[grid] = np.arange(len(land_idx), dtype=np.int32)

    lat_step = RASTER_DEG * math.pi / 180.0 * EARTH_RADIUS_KM
    row_lats = np.radians(LAT_MIN + (np.arange(n_lat) + 0.5) * RASTER_DEG)
    lon_step = lat_step * np.cos(row_lats)

    rows, cols, data = [], [], []

    def add_edges(dr, dc, weight_by_row):
        src_r = np.arange(max(0, -dr), min(n_lat, n_lat - dr))
        for r in src_r:
            r2 = r + dr
            a = node[r]
            b = np.roll(node[r2], -dc)
            ok = (a >= 0) & (b >= 0)
            if not ok.any():
                continue
            rows.append(a[ok])
            cols.append(b[ok])
            data.append(np.full(ok.sum(), weight_by_row(r), dtype=np.float32))

    for dr, dc in ((0, 1), (1, 0), (1, 1), (1, -1)):
        if dr == 0:
            add_edges(0, 1, lambda r: lon_step[r])
        elif dc == 0:
            add_edges(1, 0, lambda r: lat_step)
        else:
            add_edges(
                dr,
                dc,
                lambda r: math.hypot(
                    lat_step, (lon_step[r] + lon_step[r + 1]) / 2
                ),
            )

    n = len(land_idx)
    rows = np.concatenate(rows)
    cols = np.concatenate(cols)
    data = np.concatenate(data)

    node_lat = LAT_MIN + (land_idx[:, 0] + 0.5) * RASTER_DEG
    node_lon = -180.0 + (land_idx[:, 1] + 0.5) * RASTER_DEG
    keep = cut_wall_edges(rows, cols, node_lat, node_lon, walls)
    grid_graph = csr_matrix(
        (data[keep], (rows[keep], cols[keep])), shape=(n, n)
    )
    grid_graph = grid_graph + grid_graph.T

    xr, xc, xd, snapped = [], [], [], []
    for name, lat1, lon1, lat2, lon2 in crossings:
        s1 = snap_to_land(grid, lat1, lon1)
        s2 = snap_to_land(grid, lat2, lon2)
        if s1 is None or s2 is None:
            sys.exit(f"FIXED_CROSSINGS: no land near endpoint of {name}")
        a, b = int(node[s1]), int(node[s2])
        w = max(haversine_km(lat1, lon1, lat2, lon2), 1.0)
        xr.append(a)
        xc.append(b)
        xd.append(w)
        snapped.append((name, a, b, w))
    cross = csr_matrix(
        (np.array(xd, dtype=np.float32),
         (np.array(xr, dtype=np.int32), np.array(xc, dtype=np.int32))),
        shape=(n, n),
    )
    check_crossings(grid_graph, snapped)
    return node, grid_graph + cross + cross.T


def candidate_pairs(cities, links):
    """Unordered index pairs the picker could ground: same-mass,
    plus cross-mass pairs joined by a rail_tunnel link (R4-1)."""
    tunnel = {
        frozenset((lk["a"], lk["b"]))
        for lk in links
        if lk["kind"] == "rail_tunnel"
    }
    groups = {}
    for i, c in enumerate(cities):
        groups.setdefault(c["mass"], []).append(i)
    mass_pairs = [(m, m) for m in groups]
    mass_pairs += [tuple(sorted(t)) for t in tunnel]
    pairs = []
    seen = set()
    for ma, mb in mass_pairs:
        if (ma, mb) in seen:
            continue
        seen.add((ma, mb))
        idx_a = groups.get(ma, [])
        idx_b = groups.get(mb, [])
        for ai, i in enumerate(idx_a):
            ci = cities[i]
            others = idx_a[ai + 1:] if ma == mb else idx_b
            for j in others:
                cj = cities[j]
                d = haversine_km(ci["lat"], ci["lon"], cj["lat"], cj["lon"])
                if d <= GROUND_MODE_MAX_KM:
                    pairs.append((min(i, j), max(i, j), d))
    return pairs


def resolve_manual(cities, entries, label, allowed_masses):
    index = {city_key(c): i for i, c in enumerate(cities)}
    resolved = set()
    for a, b in entries:
        if a not in index or b not in index:
            sys.exit(f"{label}: unknown city in ({a}, {b})")
        i, j = sorted((index[a], index[b]))
        masses = frozenset(
            (cities[i]["mass"], cities[j]["mass"])
        )
        if len(masses) > 1 and masses not in allowed_masses:
            sys.exit(f"{label}: ({a}, {b}) pair can never ground")
        resolved.add((i, j))
    return resolved


def check_border_verdicts():
    """Abort when the border verdicts are too old to gate a build."""
    age = (date.today() - BORDER_VERDICTS_VERIFIED).days
    if age > BORDER_VERDICT_MAX_AGE_DAYS:
        sys.exit(
            f"BORDER_VERDICTS_VERIFIED is {age} days old (max "
            f"{BORDER_VERDICT_MAX_AGE_DAYS}). CLOSED_BORDERS and "
            "BORDER_WALLS gate this build, so re-verify them live "
            "(watchlist: PDR_TRANSPORT_CALCULATOR.md section 2.4), then "
            "move the date."
        )
    print(f"border verdicts: {age} days old, within "
          f"{BORDER_VERDICT_MAX_AGE_DAYS}")


def main():
    start = time.time()
    check_border_verdicts()
    with open(CITIES_PATH, encoding="utf-8") as f:
        payload = json.load(f)
    cities = payload["cities"]
    links = payload["metadata"]["links"]
    links_before = json.dumps(links)
    cities_before = json.dumps(cities)
    previous = {
        tuple(p) for p in payload["metadata"].get("water_blocked", [])
    }

    land = load_land()
    grid = build_raster(land)
    node, graph = build_land_graph(grid, FIXED_CROSSINGS, BORDER_WALLS)
    n_comp, comp = connected_components(graph, directed=False)

    tunnel_masses = {
        frozenset((lk["a"], lk["b"]))
        for lk in links
        if lk["kind"] == "rail_tunnel"
    }
    overlap = set(MANUAL_BLOCK) & set(MANUAL_ALLOW)
    assert not overlap, f"MANUAL_BLOCK/ALLOW overlap: {overlap}"
    manual_block = resolve_manual(
        cities, MANUAL_BLOCK, "MANUAL_BLOCK", tunnel_masses
    )
    manual_allow = resolve_manual(
        cities, MANUAL_ALLOW, "MANUAL_ALLOW", tunnel_masses
    )
    # Both cc-level mechanisms block identically; they differ only
    # in rationale (politics vs measured dishonesty).
    cc_blocked = {frozenset(p) for p in CLOSED_BORDERS}
    cc_blocked |= {frozenset(p) for p in DISHONEST_CC_PAIRS}

    pairs = candidate_pairs(cities, links)

    city_node = {}
    for i, c in enumerate(cities):
        if not LAT_MIN <= c["lat"] <= LAT_MAX:
            print(f"note: {city_key(c)} outside the raster band; "
                  "its candidate pairs auto-block")
        s = snap_to_land(grid, c["lat"], c["lon"])
        city_node[i] = None if s is None else int(node[s])

    # Pass 1: politics and chord spans; collect pairs that need
    # the land-path honesty test.
    blocked = {}
    need_path = {}
    vecs = {}
    for i, j, dist in pairs:
        key = (i, j)
        if frozenset((cities[i]["cc"], cities[j]["cc"])) in cc_blocked:
            blocked[key] = -1.0
            continue
        if key in manual_block:
            blocked[key] = 0.0
            continue
        for k in (i, j):
            if k not in vecs:
                vecs[k] = unit_vector(cities[k]["lat"], cities[k]["lon"])
        span = longest_water_span_km(land, vecs[i], vecs[j], dist)
        if key in manual_allow:
            continue
        a, b = city_node[i], city_node[j]
        if a is None or b is None or comp[a] != comp[b]:
            # Unsnappable or raster-disconnected endpoints: block
            # on real water; a dry or sub-threshold gap here is a
            # raster artifact, not geography.
            if span > WATER_SPAN_BLOCK_KM:
                blocked[key] = span
            continue
        # The honesty path test is unconditional (R6-10): gating
        # it on a wet chord made dry-land corridors invisible to
        # walls and closures (SPb-Narva R5-10, Nyala-Khartoum),
        # so every wall needed a hand-curated pair list.
        need_path.setdefault(i, []).append((j, dist, span))

    # Pass 2: single-source Dijkstra per remaining source with a
    # cutoff at its largest partner budget.
    for i, partners in need_path.items():
        budget = max(
            PATH_LIMIT_FACTOR * d + PATH_SLACK_KM for _, d, _ in partners
        )
        dists = dijkstra(
            graph, directed=False, indices=city_node[i], limit=budget
        )
        for j, d, span in partners:
            path = dists[city_node[j]]
            if not (path <= PATH_LIMIT_FACTOR * d + PATH_SLACK_KM):
                blocked[(i, j)] = span

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

    added = set(result) - previous
    removed = previous - set(result)
    print(f"pairs scanned: {len(pairs)}")
    print(f"blocked: {len(result)} (was {len(previous)}; "
          f"+{len(added)} / -{len(removed)})")

    def top_by_pop(pair_set, n):
        return sorted(
            pair_set,
            key=lambda p: -(cities[p[0]]["pop"] + cities[p[1]]["pop"]),
        )[:n]

    for title, group in (
        ("top blocked", top_by_pop(set(result), TOP_BLOCKED_REPORT)),
        ("top newly blocked", top_by_pop(added, TOP_BLOCKED_REPORT)),
        ("top newly unblocked", top_by_pop(removed, TOP_BLOCKED_REPORT)),
    ):
        print(f"{title}:")
        for i, j in group:
            print(f"  {city_key(cities[i])} - {city_key(cities[j])}")
    print(f"runtime: {time.time() - start:.1f}s")


if __name__ == "__main__":
    main()
