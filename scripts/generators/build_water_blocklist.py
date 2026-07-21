#!/usr/bin/env python3
"""Inject metadata.water_blocked into data/app/cities.json.

City pairs the picker would ground can still face open water the
landmass model cannot see: same-mass pairs across enclosed seas
(Helsinki-Tallinn share Eurasia) and rail_tunnel-linked cross-mass
pairs (the Channel Tunnel grounds every GB-Eurasia pair, including
Glasgow-Stavanger across the North Sea).

Blocking criterion (Fix Backlog 4, R4): a candidate pair is
blocked iff its great-circle chord crosses more than
WATER_SPAN_BLOCK_KM of continuous water (measured against Natural
Earth 1:50m land polygons) AND no honest land route exists. The
honesty test runs on a rasterized land graph (RASTER_DEG cells,
8-connected, geodesic edge weights) augmented with FIXED_CROSSINGS
(real bridges/tunnels/causeways): the pair stays open when the
shortest land path is at most DETOUR_MAX x straight-line (+
PATH_SLACK_KM for grid discretization on short hops). This
replaces the Round 3 pair-by-pair MANUAL_ALLOW curation, which a
Round 4 audit showed had a false-positive class in the hundreds
(Jakarta-Surabaya, Bangkok-KL, Lagos-Accra...).

Honesty bar (calibrated 2026-07-19, see PDR sec 6.2 item 3): the
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

Political closures are water-independent: CLOSED_BORDERS blocks
every candidate pair across a closed border; MANUAL_BLOCK holds
pair-level cases (front lines, closed crossings, sub-resolution
rivers). MANUAL_ALLOW remains only as a rare escape hatch.

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
from pathlib import Path

import numpy as np
import shapefile
import shapely
from scipy.sparse import csr_matrix
from scipy.sparse.csgraph import connected_components, dijkstra
from shapely.geometry import shape

REPO_ROOT = Path(__file__).resolve().parents[2]
CITIES_PATH = REPO_ROOT / "data" / "app" / "cities.json"
NE_DIR = REPO_ROOT / "data" / "reference" / "natural_earth"
LAND_SHP = NE_DIR / "ne_50m_land.shp"
RASTER_CACHE = NE_DIR / "land_raster_0p1.npz"

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

# Land raster resolution and coverage (all dataset cities lie
# within these latitudes).
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
    ("1915 Canakkale bridge", 40.31, 26.65, 40.35, 26.72),
    ("Kanmon tunnels", 33.96, 130.94, 33.93, 130.96),
    ("Seikan tunnel", 41.45, 140.12, 41.20, 140.32),
    ("Tokyo Bay Aqua-Line", 35.46, 139.87, 35.42, 139.92),
    ("HK-Zhuhai-Macau bridge", 22.30, 113.94, 22.22, 113.55),
    ("Shenzhen-Zhongshan link", 22.59, 113.78, 22.51, 113.55),
    ("King Fahd Causeway", 26.20, 50.45, 26.24, 50.32),
    ("Osman Gazi bridge", 40.757, 29.513, 40.646, 29.516),
    ("Johor-Singapore Causeway", 1.45, 103.77, 1.44, 103.77),
    ("Rio-Antirrio bridge", 38.32, 21.77, 38.34, 21.77),
]

# Country pairs whose shared border is closed to travel; every
# candidate pair across one is blocked regardless of water.
# Verified 2026-07-19 (R4-3/R4-6): FI-RU crossings closed since
# 2023-12-15, extended "until further notice" 2026-06-04; the
# others are long-standing closed borders.
CLOSED_BORDERS = [
    ("KP", "KR"),
    ("IL", "LB"),
    ("AM", "AZ"),
    ("RU", "FI"),
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
    # (R4-4).
    ("RU/Saint Petersburg", "EE/Tallinn"),
    ("RU/Saint Petersburg", "EE/Kohtla-Järve"),
    # Abkhazia line, closed (Batumi-Sokhumi precedent).
    ("AM/Yerevan", "GE/Sokhumi"),
    ("AM/Gyumri", "GE/Sokhumi"),
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


def haversine_km(lat1, lon1, lat2, lon2):
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dp = p2 - p1
    dl = math.radians(lon2 - lon1)
    a = (
        math.sin(dp / 2) ** 2
        + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
    )
    return 2 * EARTH_RADIUS_KM * math.asin(math.sqrt(min(1.0, a)))


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


def build_land_graph(grid, crossings):
    """8-connected CSR graph over land cells with geodesic edge
    weights, longitude-wrapped, plus fixed-crossing edges."""
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
    for name, lat1, lon1, lat2, lon2 in crossings:
        s1 = snap_to_land(grid, lat1, lon1)
        s2 = snap_to_land(grid, lat2, lon2)
        if s1 is None or s2 is None:
            sys.exit(f"FIXED_CROSSINGS: no land near endpoint of {name}")
        a, b = node[s1], node[s2]
        w = max(haversine_km(lat1, lon1, lat2, lon2), 1.0)
        rows.append(np.array([a], dtype=np.int32))
        cols.append(np.array([b], dtype=np.int32))
        data.append(np.array([w], dtype=np.float32))

    rows = np.concatenate(rows)
    cols = np.concatenate(cols)
    data = np.concatenate(data)
    graph = csr_matrix((data, (rows, cols)), shape=(n, n))
    return node, graph + graph.T


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


def main():
    start = time.time()
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
    node, graph = build_land_graph(grid, FIXED_CROSSINGS)
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
    closed = {frozenset(p) for p in CLOSED_BORDERS}

    pairs = candidate_pairs(cities, links)

    city_node = {}
    for i, c in enumerate(cities):
        s = snap_to_land(grid, c["lat"], c["lon"])
        city_node[i] = None if s is None else int(node[s])

    # Pass 1: politics and chord spans; collect pairs that need
    # the land-path honesty test.
    blocked = {}
    need_path = {}
    vecs = {}
    for i, j, dist in pairs:
        key = (i, j)
        if frozenset((cities[i]["cc"], cities[j]["cc"])) in closed:
            blocked[key] = -1.0
            continue
        if key in manual_block:
            blocked[key] = 0.0
            continue
        for k in (i, j):
            if k not in vecs:
                vecs[k] = unit_vector(cities[k]["lat"], cities[k]["lon"])
        span = longest_water_span_km(land, vecs[i], vecs[j], dist)
        if span <= WATER_SPAN_BLOCK_KM:
            continue
        if key in manual_allow:
            continue
        a, b = city_node[i], city_node[j]
        if a is None or b is None or comp[a] != comp[b]:
            blocked[key] = span
            continue
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
