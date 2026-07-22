#!/usr/bin/env python3
"""Build data/app/cities.json for the transport calculator prefill.

Emits a city list (name, country, lat, lon, landmass) -- NOT city
pairs. Distances are computed at runtime via haversine in Dart
(lib/features/transport/domain/services/journey_distance.dart),
so this file stays O(N) and any city pair on Earth is supported.

Inputs (open data, re-download to rerun; not committed):
  cities15000.txt      GeoNames places with population > 15,000
                       https://download.geonames.org/export/dump/cities15000.zip
                       (CC BY 4.0)
  countries_regions.json  ISO-3166 with region/sub-region fields
                       https://raw.githubusercontent.com/lukes/
                       ISO-3166-Countries-with-Regional-Codes/master/all/all.json

Usage:
  python3 build_cities.py <input_dir> <output_json>

Landmass model (adapted from the original city_pairs prototype):
road-connected continental masses with islands isolated. Countries
spanning several islands (see ISLAND_ANCHORS) are split per island
by nearest-anchor city coordinates. Fixed links (tunnels, major
ferry corridors) are declared separately in LINKS rather than
merging landmasses, so geography stays pure and connectivity stays
explicit. Any country code that cannot be mapped fails the build.
"""
import csv
import json
import sys
from datetime import date

TOP_N = 5
TOP_N_JP = 15  # primary market: denser coverage

# Same-settlement duplicates: GeoNames carries separate records
# for districts/twin listings of one town (Majuro + its urban
# core "Dalap-Uliga-Dorrit"; Macau's Se/Zhuojiacun districts).
# Within a country, a city closer than this to a larger one is
# the same settlement and is dropped before the top-N cut.
# ponytail: 1.5 km keeps adjacent municipalities (Frederiksberg
# sits 2.0 km from Copenhagen); raise only with a dataset diff.
DEDUP_KM = 1.5

# Cities excluded by owner rule (R6-1, 2026-07-21): the Gaza
# Strip is sealed (Rafah quota-only, Erez closed, no land route
# to the West Bank), so its cities cannot honestly appear in a
# travel picker at all. Predicate, not a name list: any PS city
# west of the strip/West Bank gap. West Bank cities sit at
# lon >= 35.0; the strip spans 34.2-34.6.
def excluded(cc, lat, lon):
    return cc == "PS" and lon < 34.9
# ponytail: PPL lets US boroughs (Brooklyn, Queens) crowd out real
# cities in the top-5; prefer PPLA*/PPLC for US if that ever matters.
KEEP_CODES = {"PPL", "PPLA", "PPLA2", "PPLA3", "PPLA4", "PPLA5", "PPLC", "PPLG"}

# Whole-country islands that must be isolated from the continental
# bases (including island territories whose ISO region would
# otherwise glue them to a mainland, e.g. Bermuda -> NorthAmerica).
# Caribbean and non-Australia Oceania are auto-isolated per-country.
ISLANDS = {
    "GB", "IE", "IS", "MT", "CY",
    "JP", "TW", "LK", "MV", "TL", "BN",
    "MG", "MU", "SC", "ST",
    "BM", "GL", "PM", "FK", "GS", "SJ", "FO",
    "IM", "JE", "GG", "AX", "YT", "RE", "SH", "TF",
}

# Countries split into per-island masses. Each city is assigned to
# the nearest anchor (squared degree distance -- fine at city
# scale); "MAINLAND" falls through to the regional mapping.
# ponytail: anchors cover cities near the TOP_N cut; raising TOP_N
# needs new anchors for the extra cities (e.g. Nelson NZ, Batam ID,
# Reggio Calabria IT already covered).
ISLAND_ANCHORS = {
    "ID": [
        ("JAVA", -6.9, 107.0), ("JAVA", -7.25, 112.75),
        ("SUMATRA", 3.58, 98.67), ("SUMATRA", 0.52, 101.44),
        ("SUMATRA", -2.92, 104.75), ("SUMATRA", -5.43, 105.26),
        ("KALIMANTAN", -0.02, 109.34), ("KALIMANTAN", -1.27, 116.83),
        ("SULAWESI", -5.15, 119.43), ("SULAWESI", 1.49, 124.84),
        ("BALI", -8.65, 115.22), ("LOMBOK", -8.58, 116.12),
        ("PAPUA", -2.53, 140.72),
    ],
    "PH": [
        ("LUZON", 14.6, 121.0), ("LUZON", 16.4, 120.6),
        ("MINDANAO", 7.07, 125.61), ("MINDANAO", 8.48, 124.65),
        ("MINDANAO", 6.91, 122.07), ("MINDANAO", 6.11, 125.17),
        ("CEBU", 10.32, 123.89), ("NEGROS", 10.68, 122.95),
        ("PANAY", 10.70, 122.56), ("PALAWAN", 9.74, 118.74),
        ("LEYTE", 11.24, 125.00),
    ],
    "NZ": [
        ("NORTH", -36.85, 174.76), ("NORTH", -37.78, 175.28),
        ("NORTH", -41.29, 174.78),
        ("SOUTH", -43.53, 172.63), ("SOUTH", -45.87, 170.50),
        ("SOUTH", -46.4, 168.35),
    ],
    "IT": [
        ("SICILY", 38.12, 13.36), ("SICILY", 37.49, 15.07),
        ("SICILY", 38.19, 15.55),
        ("SARDINIA", 39.22, 9.11), ("SARDINIA", 40.73, 8.56),
        ("MAINLAND", 41.89, 12.51), ("MAINLAND", 45.46, 9.19),
        ("MAINLAND", 40.85, 14.27), ("MAINLAND", 41.12, 16.87),
        ("MAINLAND", 38.11, 15.65),
    ],
    "GQ": [
        ("BIOKO", 3.76, 8.78),
        ("MAINLAND", 1.86, 9.77), ("MAINLAND", 2.15, 11.33),
    ],
    # Anchors below use exact GeoNames coordinates (verified
    # 2026-07-18 against cities15000.txt) so top-5 cities snap to
    # their own anchor. Extra MAINLAND anchors exist where a
    # mainland city would otherwise sit nearer an island anchor
    # in degree space (TZ: Dodoma/Mwanza vs Zanzibar).
    "TZ": [
        ("ZANZIBAR", -6.1639, 39.1979),
        ("MAINLAND", -6.8235, 39.2695), ("MAINLAND", -2.5167, 32.90),
        ("MAINLAND", -6.1722, 35.7395), ("MAINLAND", -5.0689, 39.0988),
    ],
    "KM": [
        ("GRANDE_COMORE", -11.7022, 43.2551),
        ("ANJOUAN", -12.1667, 44.3994),
        ("MOHELI", -12.2876, 43.7434),
    ],
    "PG": [
        ("MAINLAND", -9.4772, 147.1509), ("MAINLAND", -6.7233, 146.9961),
        ("BOUGAINVILLE", -6.2298, 155.566),
    ],
    "CV": [
        ("SANTIAGO", 14.9315, -23.5125),
        ("SAO_VICENTE", 16.8901, -24.9804),
        ("SAL", 16.7552, -22.9446),
    ],
    "FJ": [
        ("VITI_LEVU", -18.1368, 178.4253), ("VITI_LEVU", -17.8031, 177.4162),
        ("VANUA_LEVU", -16.4332, 179.3645),
    ],
    "BS": [
        ("NEW_PROVIDENCE", 25.0582, -77.3431),
        ("GRAND_BAHAMA", 26.5333, -78.70),
    ],
    "TC": [
        ("PROVIDENCIALES", 21.7825, -72.2521),
        ("GRAND_TURK", 21.4612, -71.1419),
    ],
    # Latent guard: no MY Borneo city is in the top 5 today, but
    # Kuching sits near the cut; without anchors a regen would
    # silently tag it Eurasia.
    "MY": [
        ("MAINLAND", 3.1412, 101.6865), ("MAINLAND", 1.4655, 103.7578),
        ("BORNEO", 1.55, 110.3333), ("BORNEO", 5.9749, 116.0724),
    ],
    "VI": [
        ("ST_THOMAS", 18.3419, -64.9307),
        ("ST_CROIX", 17.7275, -64.747),
    ],
    # San Pedro sits on Ambergris Caye (R4-7); the rest of the
    # top 5 are mainland.
    "BZ": [
        ("AMBERGRIS", 17.916, -87.9659),
        ("MAINLAND", 17.4995, -88.1976), ("MAINLAND", 17.1588, -89.0696),
        ("MAINLAND", 18.0812, -88.5633), ("MAINLAND", 17.2538, -88.764),
    ],
}

# Fixed connections between masses. kind: "rail_tunnel" enables
# ground modes across the link; "ferry" enables ferry legs only.
# Links are NOT chained: each connects exactly the two masses it
# names (Sicily-Eurasia plus a hypothetical Malta-Sicily does not
# imply Malta-Eurasia).
#
# Ferry links are PORT-ANCHORED (Fix Backlog 3, R3-D4): each side
# carries a representative port coordinate and a catchment radius,
# and a ferry is only suggested when each city lies within its
# side's radius. This scopes a mass-level link to the corridor it
# names by construction (no Red Sea fiction from a Gibraltar link;
# no Dublin-Groningen foot-ferry from the Ireland-France link) and
# revives Sevilla-Tangier, which the old distance-cap approach had
# to kill. Radii are catchment decisions, verified against dataset
# coordinates -- rationale in the per-link comments below. The
# optional "max_km" still caps total straight-line distance
# (default: the Dart ferryModeMaxKm, 500); it remains only where
# it must exceed the default (Ireland-France 900, Paris pairs at
# 779-838 km). rail_tunnel links stay portless: through-rail reach
# is real. Malta-Sicily remains removed (R3): Palermo, the only
# Sicilian city in the dataset, has no direct Malta ferry; restore
# with ports at Valletta/Pozzallo if Catania is force-included.
#
# After ANY regeneration, run sweep_suggestions.py (same dir);
# regeneration is not done until the sweep gate passes.
LINKS = [
    {"a": "ISL_GB", "b": "Eurasia", "kind": "rail_tunnel",
     "label": "Channel Tunnel"},
    {"a": "ISL_GB", "b": "Eurasia", "kind": "ferry",
     "label": "Dover-Calais ferries",
     "port_a_lat": 51.127, "port_a_lon": 1.324, "radius_a_km": 150,
     "port_b_lat": 50.966, "port_b_lon": 1.862, "radius_b_km": 150},
    {"a": "ISL_IE", "b": "ISL_GB", "kind": "ferry",
     "label": "Irish Sea ferries",
     "port_a_lat": 53.345, "port_a_lon": -6.194, "radius_a_km": 150,
     # Holyhead's nearest dataset city is Manchester at 160 km;
     # 250 covers the NW-England/Midlands catchment.
     "port_b_lat": 53.309, "port_b_lon": -4.633, "radius_b_km": 250},
    {"a": "ISL_IE", "b": "Eurasia", "kind": "ferry",
     "label": "Ireland-France ferries", "max_km": 900,
     # Rosslare 180 covers Dublin (120) and Cork (151);
     # Cherbourg 350 covers Paris (301) but not Brussels (445).
     "port_a_lat": 52.251, "port_a_lon": -6.335, "radius_a_km": 180,
     "port_b_lat": 49.646, "port_b_lon": -1.622, "radius_b_km": 350},
    {"a": "ISL_JP", "b": "Eurasia", "kind": "ferry",
     "label": "Busan-Fukuoka ferry",
     "port_a_lat": 33.606, "port_a_lon": 130.410, "radius_a_km": 150,
     "port_b_lat": 35.098, "port_b_lon": 129.040, "radius_b_km": 150},
    {"a": "Africa", "b": "Eurasia", "kind": "ferry",
     "label": "Strait of Gibraltar ferries",
     "port_a_lat": 35.789, "port_a_lon": -5.813, "radius_a_km": 150,
     "port_b_lat": 36.127, "port_b_lon": -5.444, "radius_b_km": 150},
    {"a": "ISL_IT_SICILY", "b": "Eurasia", "kind": "ferry",
     "label": "Messina Strait and Naples-Palermo ferries",
     "port_a_lat": 38.13, "port_a_lon": 13.37, "radius_a_km": 150,
     "port_b_lat": 40.842, "port_b_lon": 14.252, "radius_b_km": 150},
    {"a": "ISL_TZ_ZANZIBAR", "b": "Africa", "kind": "ferry",
     "label": "Dar es Salaam-Zanzibar ferries",
     "port_a_lat": -6.162, "port_a_lon": 39.19, "radius_a_km": 50,
     "port_b_lat": -6.82, "port_b_lon": 39.29, "radius_b_km": 50},
    {"a": "ISL_NZ_NORTH", "b": "ISL_NZ_SOUTH", "kind": "ferry",
     "label": "Cook Strait ferries",
     "port_a_lat": -41.28, "port_a_lon": 174.78, "radius_a_km": 50,
     # Picton 300 covers Christchurch (274).
     "port_b_lat": -41.29, "port_b_lon": 174.00, "radius_b_km": 300},
    {"a": "ISL_VI_ST_THOMAS", "b": "ISL_VI_ST_CROIX", "kind": "ferry",
     "label": "St Thomas-St Croix ferry",
     "port_a_lat": 18.34, "port_a_lon": -64.93, "radius_a_km": 50,
     "port_b_lat": 17.75, "port_b_lon": -64.70, "radius_b_km": 50},
]


def load_cities(path):
    cities = []
    with open(path, encoding="utf-8") as f:
        # GeoNames is raw tab-separated text; default quoting would
        # corrupt rows containing quote characters.
        for row in csv.reader(f, delimiter="\t", quoting=csv.QUOTE_NONE):
            try:
                name, lat, lon, fcode, cc, pop = (
                    row[1], float(row[4]), float(row[5]),
                    row[7], row[8], int(row[14]),
                )
            except (IndexError, ValueError):
                continue
            # Capitals bypass the 15k-population floor in GeoNames
            # and can carry pop 0 (Ngerulmud PW, Plymouth MS).
            if fcode in KEEP_CODES and pop > 0:
                cities.append((cc, name, lat, lon, pop))
    # GeoNames occasionally carries two records for one place
    # (e.g. La Ceiba HN); keep the highest-population record.
    # Known upstream mislabel kept as-is: ER/Himora is actually
    # Humera, ET (14.30N 36.61E sits in Tigray, Ethiopia); fixing
    # it here would desync from the GeoNames source of truth.
    # Rounded coords keep genuinely distinct same-named cities
    # (the two Suzhous, CN) from being merged.
    best = {}
    for cc, name, lat, lon, pop in cities:
        key = (cc, name, round(lat, 1), round(lon, 1))
        if key not in best or best[key][4] < pop:
            best[key] = (cc, name, lat, lon, pop)
    return list(best.values())


def _same_settlement(lat1, lon1, lat2, lon2):
    # Equirectangular km: exact enough at settlement scale.
    from math import cos, radians
    dy = (lat1 - lat2) * 111.32
    dx = (lon1 - lon2) * 111.32 * cos(radians((lat1 + lat2) / 2))
    return dx * dx + dy * dy < DEDUP_KM * DEDUP_KM


def top_per_country(cities):
    by_country = {}
    for cc, name, lat, lon, pop in cities:
        if excluded(cc, lat, lon):
            continue
        by_country.setdefault(cc, []).append((pop, name, lat, lon))
    pool = []
    for cc, lst in by_country.items():
        lst.sort(reverse=True)
        # Population-descending pass: a city is dropped when a
        # larger same-country city already sits within DEDUP_KM.
        kept = []
        for row in lst:
            if not any(
                _same_settlement(row[2], row[3], k[2], k[3]) for k in kept
            ):
                kept.append(row)
        limit = TOP_N_JP if cc == "JP" else TOP_N
        for pop, name, lat, lon in kept[:limit]:
            pool.append(
                {"cc": cc, "name": name, "lat": lat, "lon": lon, "pop": pop},
            )
    return pool


def island_mass(cc, lat, lon):
    anchors = ISLAND_ANCHORS.get(cc)
    if not anchors:
        return None
    island = min(
        anchors,
        key=lambda a: (lat - a[1]) ** 2 + (lon - a[2]) ** 2,
    )[0]
    if island == "MAINLAND":
        return None
    return f"ISL_{cc}_{island}"


def landmass_fn(countries_path):
    with open(countries_path, encoding="utf-8") as f:
        info = {c["alpha-2"]: c for c in json.load(f)}

    def landmass(cc, lat, lon):
        if cc == "XK":
            # Kosovo is absent from the ISO dataset.
            return "Eurasia"
        if cc in ("MF", "SX"):
            # One island (Saint Martin), two country codes.
            return "ISL_MF_SX"
        mass = island_mass(cc, lat, lon)
        if mass:
            return mass
        if cc in ISLANDS:
            return f"ISL_{cc}"
        if cc in ("HT", "DO"):
            return "Hispaniola"
        rec = info.get(cc)
        if not rec:
            return None
        region, sub = rec.get("region"), rec.get("sub-region")
        if region in ("Asia", "Europe"):
            return "Eurasia"
        if region == "Africa":
            return "Africa"
        if region == "Americas":
            if sub == "Northern America":
                return "NorthAmerica"
            # lukes dataset nests the rest under one sub-region;
            # the road-connectivity split lives in intermediate-region.
            inter = rec.get("intermediate-region")
            if inter == "Central America":
                return "NorthAmerica"
            if inter == "South America":
                return "SouthAmerica"
            if inter == "Caribbean":
                return f"ISL_{cc}"
            return None
        if region == "Oceania":
            return "Australia" if cc == "AU" else f"ISL_{cc}"
        return None

    return landmass


def main():
    in_dir, out_path = sys.argv[1], sys.argv[2]
    pool = top_per_country(load_cities(f"{in_dir}/cities15000.txt"))
    landmass = landmass_fn(f"{in_dir}/countries_regions.json")

    out_cities = []
    unmapped = {}
    for c in pool:
        mass = landmass(c["cc"], c["lat"], c["lon"])
        if mass is None:
            unmapped.setdefault(c["cc"], []).append(c["name"])
            continue
        out_cities.append({
            "name": c["name"],
            "cc": c["cc"],
            "lat": round(c["lat"], 4),
            "lon": round(c["lon"], 4),
            "mass": mass,
            "pop": c["pop"],
        })
    if unmapped:
        for cc, names in sorted(unmapped.items()):
            print(f"UNMAPPED {cc}: {', '.join(names)}", file=sys.stderr)
        sys.exit(1)
    out_cities.sort(key=lambda c: -c["pop"])

    masses = {c["mass"] for c in out_cities}
    for link in LINKS:
        assert link["a"] in masses and link["b"] in masses, link

    payload = {
        "metadata": {
            "version": 1,
            "generated": date.today().isoformat(),
            "source": (
                "GeoNames cities15000 (CC BY 4.0); "
                "ISO-3166 regional codes (lukes, public domain)"
            ),
            "selection": (
                f"top {TOP_N} cities by population per country "
                f"(top {TOP_N_JP} for JP)"
            ),
            "links": LINKS,
        },
        "cities": out_cities,
    }
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(payload, f, ensure_ascii=False, separators=(",", ":"))
        f.write("\n")

    print(f"cities: {len(out_cities)}")
    print(f"masses: {len(masses)}")
    print(f"JP cities: {sum(1 for c in out_cities if c['cc'] == 'JP')}")


if __name__ == "__main__":
    main()
