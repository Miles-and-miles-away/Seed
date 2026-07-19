#!/usr/bin/env python3
"""Regeneration gate: exhaustive sweep of the suggestion logic.

Faithful Python replica of suggestedDistancesKm
(lib/features/transport/domain/services/journey_distance.dart)
run over every unordered city pair in data/app/cities.json.
Exits nonzero and prints offenders if any invariant breaks, so a
regenerated dataset cannot silently reintroduce fictional pairs.

Run after ANY change to cities.json (or the Dart gates):

    conda activate seed && python scripts/generators/sweep_suggestions.py

Keep the constants below in lockstep with journey_distance.dart.
"""
import json
import math
import sys
from collections import Counter
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
CITIES_JSON = REPO / "data" / "app" / "cities.json"
CITIES_DATA_DART = (
    REPO / "lib" / "features" / "transport" / "data" / "cities_data.dart"
)

EARTH_RADIUS_KM = 6371.0088
GROUND_CIRCUITY = 1.3
FLIGHT_DETOUR_KM = 95.0
GROUND_MODE_MAX_KM = 2000.0
MIN_FLIGHT_KM = 250.0
FERRY_MODE_MAX_KM = 500.0
FALLBACK_AIR_MIN_KM = 100.0
ACTIVE_MODE_MAX_KM = 150.0


def haversine_km(lat1, lon1, lat2, lon2):
    p1 = math.radians(lat1)
    p2 = math.radians(lat2)
    sdp = math.sin(math.radians(lat2 - lat1) / 2)
    sdl = math.sin(math.radians(lon2 - lon1) / 2)
    a = sdp * sdp + math.cos(p1) * math.cos(p2) * sdl * sdl
    return 2 * EARTH_RADIUS_KM * math.asin(math.sqrt(min(1.0, a)))


def find_link(a, b, links, kind):
    for link in links:
        if link["kind"] != kind:
            continue
        if (link["a"] == a["mass"] and link["b"] == b["mass"]) or (
            link["b"] == a["mass"] and link["a"] == b["mass"]
        ):
            return link
    return None


def within_port(city, lat, lon, radius):
    if lat is None or lon is None or radius is None:
        return True
    return haversine_km(city["lat"], city["lon"], lat, lon) <= radius


def ports_allow(a, b, link):
    side_a, side_b = (a, b) if a["mass"] == link["a"] else (b, a)
    return within_port(
        side_a,
        link.get("port_a_lat"),
        link.get("port_a_lon"),
        link.get("radius_a_km"),
    ) and within_port(
        side_b,
        link.get("port_b_lat"),
        link.get("port_b_lon"),
        link.get("radius_b_km"),
    )


def suggest(a, b, links, blocked, pair_index):
    straight = haversine_km(a["lat"], a["lon"], b["lat"], b["lon"])
    if math.isnan(straight):
        return {}, straight
    grounded = a["mass"] == b["mass"] or find_link(
        a, b, links, "rail_tunnel"
    )
    result = {}
    if (
        grounded
        and straight <= GROUND_MODE_MAX_KM
        and pair_index not in blocked
    ):
        result["ground"] = straight * GROUND_CIRCUITY
        if straight <= ACTIVE_MODE_MAX_KM:
            result["active"] = straight * GROUND_CIRCUITY
    if straight >= MIN_FLIGHT_KM:
        result["air"] = straight + FLIGHT_DETOUR_KM
    ferry = find_link(a, b, links, "ferry")
    if (
        ferry
        and straight <= ferry.get("max_km", FERRY_MODE_MAX_KM)
        and ports_allow(a, b, ferry)
    ):
        result["ferry"] = straight
    if not result and straight >= FALLBACK_AIR_MIN_KM:
        result["air"] = straight + FLIGHT_DETOUR_KM
    return result, straight


def main():
    root = json.load(open(CITIES_JSON, encoding="utf-8"))
    cities = root["cities"]
    links = root["metadata"]["links"]
    blocked = {tuple(p) for p in root["metadata"].get("water_blocked", [])}
    n = len(cities)
    violations = []

    dart = CITIES_DATA_DART.read_text(encoding="utf-8")
    pin = f"const CITY_COUNT = {n};"
    if pin not in dart:
        violations.append(f"CITY_COUNT pin mismatch: expected '{pin}'")

    masses = {c["mass"] for c in cities}
    for link in links:
        if link["a"] not in masses or link["b"] not in masses:
            violations.append(f"link references missing mass: {link}")

    tunnel_pairs = {
        frozenset((lk["a"], lk["b"]))
        for lk in links
        if lk["kind"] == "rail_tunnel"
    }
    link_hits = Counter()
    kind_counts = Counter()
    fallback_min = None
    for i in range(n):
        a = cities[i]
        for j in range(i + 1, n):
            b = cities[j]
            s, straight = suggest(a, b, links, blocked, (i, j))
            kind_counts.update(s.keys())
            cross = a["mass"] != b["mass"]
            name = (
                f'{a["name"]},{a["cc"]} - {b["name"]},{b["cc"]}'
                f" ({straight:.0f} km)"
            )
            if cross and "active" in s:
                violations.append(f"cross-mass active: {name}")
            if cross and "ground" in s:
                if frozenset((a["mass"], b["mass"])) not in tunnel_pairs:
                    violations.append(f"cross-mass ground, no tunnel: {name}")
            if "ferry" in s:
                link = find_link(a, b, links, "ferry")
                link_hits[link["label"]] += 1
                if straight > link.get("max_km", FERRY_MODE_MAX_KM):
                    violations.append(f"ferry over cap: {name}")
                if not ports_allow(a, b, link):
                    violations.append(f"ferry outside ports: {name}")
            if (i, j) in blocked and (
                "ground" in s or "active" in s
            ):
                violations.append(f"water-blocked pair got ground: {name}")
            if s.keys() == {"air"} and straight < MIN_FLIGHT_KM:
                fallback_min = min(fallback_min or straight, straight)
                if straight < FALLBACK_AIR_MIN_KM:
                    violations.append(f"air fallback under floor: {name}")
    for link in links:
        kind = "ground" if link["kind"] == "rail_tunnel" else "ferry"
        if kind == "ferry" and link_hits[link["label"]] == 0:
            violations.append(f"dead link (zero pairs): {link['label']}")

    total = n * (n - 1) // 2
    print(f"pairs swept: {total}")
    print(f"kind counts: {dict(kind_counts)}")
    print(f"water-blocked pairs honored: {len(blocked)}")
    print(f"ferry pairs per link: {dict(link_hits)}")
    if fallback_min is not None:
        print(f"smallest air fallback: {fallback_min:.1f} km")
    if violations:
        print(f"\nFAIL: {len(violations)} violation(s)")
        for v in violations[:50]:
            print(f"  {v}")
        sys.exit(1)
    print("\nPASS: sweep gate clean")


if __name__ == "__main__":
    main()
