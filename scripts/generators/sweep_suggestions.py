#!/usr/bin/env python3
"""Regeneration gate: exhaustive sweep of the suggestion logic.

Faithful Python replica of suggestedDistancesKm
(lib/features/transport/domain/services/journey_distance.dart)
run over every unordered city pair in data/app/cities.json.
Exits nonzero and prints offenders if any invariant breaks, so a
regenerated dataset cannot silently reintroduce fictional pairs.

Run after ANY change to cities.json (or the Dart gates):

    conda activate seed && python scripts/generators/sweep_suggestions.py

Includes the political screen (R7): grounded cross-country
pairs are diffed against data/reference/
reviewed_cc_ground_pairs.json; a new, unscreened corridor fails
the gate. After verifying the new border(s) open for ordinary
travelers (owner rules: active fighting = closed; in doubt,
remove -- block via build_water_blocklist.py mechanisms), rerun
with --update-reviewed to refresh the list.

Keep the constants below in lockstep with journey_distance.dart.
"""
import json
import math
import sys
from collections import Counter
from datetime import date
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
CITIES_JSON = REPO / "data" / "app" / "cities.json"
CITIES_DATA_DART = (
    REPO / "lib" / "features" / "transport" / "data" / "cities_data.dart"
)
# Political screen (R7): every cross-country pair that carries a
# ground suggestion must appear in this reviewed list (border
# verified open for ordinary travelers, dated). Regeneration that
# introduces a new grounded cc-pair fails the gate until the
# border is screened and the list refreshed with
# `--update-reviewed` (run it only AFTER the review).
REVIEWED_CC_PATH = (
    REPO / "data" / "reference" / "reviewed_cc_ground_pairs.json"
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


def _sides_allow(side_a, side_b, link):
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


def ports_allow(a, b, link):
    if link["a"] == link["b"]:
        # Self-links have no orientation; accept either assignment
        # so the result is order-independent (mirrors the Dart).
        return _sides_allow(a, b, link) or _sides_allow(b, a, link)
    side_a, side_b = (a, b) if a["mass"] == link["a"] else (b, a)
    return _sides_allow(side_a, side_b, link)


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
        # `or` (not dict.get default) mirrors Dart's `??`, which
        # also covers an explicit JSON null.
        and straight <= (ferry.get("max_km") or FERRY_MODE_MAX_KM)
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

    # The Dart resolves blocklist indices to cc/name keys, so the
    # gate's index-space checks only match app behavior while
    # (cc, name) uniquely identifies a city (R4-8).
    keys = [f'{c["cc"]}/{c["name"]}' for c in cities]
    if len(set(keys)) != n:
        dupes = {k for k in keys if keys.count(k) > 1}
        violations.append(f"duplicate cc/name keys: {sorted(dupes)}")

    masses = {c["mass"] for c in cities}
    labels = [lk["label"] for lk in links]
    if len(set(labels)) != len(labels):
        violations.append("duplicate link labels alias the dead-link check")
    port_fields = (
        "port_a_lat", "port_a_lon", "radius_a_km",
        "port_b_lat", "port_b_lon", "radius_b_km",
    )
    for link in links:
        if link["a"] not in masses or link["b"] not in masses:
            violations.append(f"link references missing mass: {link}")
        # A partial port set silently degrades the link to
        # distance-only gating in the Dart (R4-9).
        present = sum(link.get(f) is not None for f in port_fields)
        if present not in (0, len(port_fields)):
            violations.append(f"partial port fields: {link['label']}")

    tunnel_pairs = {
        frozenset((lk["a"], lk["b"]))
        for lk in links
        if lk["kind"] == "rail_tunnel"
    }
    raw_blocked = root["metadata"].get("water_blocked", [])
    if len(blocked) != len(raw_blocked):
        violations.append("water_blocked contains duplicate pairs")
    for entry in raw_blocked:
        if (
            not isinstance(entry, list)
            or len(entry) != 2
            or not all(isinstance(x, int) for x in entry)
            or not 0 <= entry[0] < entry[1] < n
        ):
            violations.append(f"malformed water_blocked entry: {entry}")
            continue
        ma = cities[entry[0]]["mass"]
        mb = cities[entry[1]]["mass"]
        if ma != mb and frozenset((ma, mb)) not in tunnel_pairs:
            violations.append(
                f"water_blocked pair can never ground: {entry}"
            )

    link_hits = Counter()
    kind_counts = Counter()
    cc_ground = set()
    fallback_min = None
    honored = 0
    for i in range(n):
        a = cities[i]
        for j in range(i + 1, n):
            b = cities[j]
            s, straight = suggest(a, b, links, blocked, (i, j))
            kind_counts.update(s.keys())
            if "ground" in s and a["cc"] != b["cc"]:
                cc_ground.add("-".join(sorted((a["cc"], b["cc"]))))
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
                if straight > (link.get("max_km") or FERRY_MODE_MAX_KM):
                    violations.append(f"ferry over cap: {name}")
                if not ports_allow(a, b, link):
                    violations.append(f"ferry outside ports: {name}")
            if (i, j) in blocked:
                if "ground" in s or "active" in s:
                    violations.append(
                        f"water-blocked pair got ground: {name}"
                    )
                elif straight <= GROUND_MODE_MAX_KM and (
                    a["mass"] == b["mass"]
                    or frozenset((a["mass"], b["mass"])) in tunnel_pairs
                ):
                    # The entry actually suppressed a ground offer.
                    honored += 1
            if s.keys() == {"air"} and straight < MIN_FLIGHT_KM:
                fallback_min = min(fallback_min or straight, straight)
                if straight < FALLBACK_AIR_MIN_KM:
                    violations.append(f"air fallback under floor: {name}")
    for link in links:
        kind = "ground" if link["kind"] == "rail_tunnel" else "ferry"
        if kind == "ferry" and link_hits[link["label"]] == 0:
            violations.append(f"dead link (zero pairs): {link['label']}")

    # Political screen: a regenerated dataset may backfill new
    # cities and ground a country pair nobody has screened
    # against closed borders or active conflicts (R6 found 12
    # such classes). Same-country front lines stay a manual
    # concern -- cc granularity cannot see them.
    update_reviewed = "--update-reviewed" in sys.argv
    if REVIEWED_CC_PATH.exists():
        reviewed = set(
            json.load(open(REVIEWED_CC_PATH, encoding="utf-8"))["pairs"]
        )
    else:
        reviewed = set()
        if not update_reviewed:
            violations.append(
                f"reviewed cc-pair list missing: {REVIEWED_CC_PATH}"
            )
    new_cc = sorted(cc_ground - reviewed)
    if new_cc and not update_reviewed:
        for p in new_cc:
            violations.append(
                f"unreviewed political corridor: {p} -- verify the "
                "border is open to ordinary travelers (owner rules: "
                "active fighting = closed; in doubt, remove), then "
                "rerun with --update-reviewed"
            )

    total = n * (n - 1) // 2
    print(f"pairs swept: {total}")
    print(f"kind counts: {dict(kind_counts)}")
    print(f"grounded cc-pairs: {len(cc_ground)} "
          f"(reviewed: {len(reviewed)}, new: {len(new_cc)}, "
          f"stale: {len(reviewed - cc_ground)})")
    print(f"water-blocked entries: {len(blocked)}; honored: {honored}")
    print(f"ferry pairs per link: {dict(link_hits)}")
    if fallback_min is not None:
        print(f"smallest air fallback: {fallback_min:.1f} km")
    if violations:
        print(f"\nFAIL: {len(violations)} violation(s)")
        for v in violations[:50]:
            print(f"  {v}")
        sys.exit(1)
    if update_reviewed:
        # Only reachable when the gate is otherwise clean, so a
        # broken dataset can never be baked into the review list.
        payload = {
            "reviewed": date.today().isoformat(),
            "note": (
                "cross-country pairs with a ground suggestion, each "
                "border screened open for ordinary travelers; "
                "refresh ONLY after screening via "
                "sweep_suggestions.py --update-reviewed"
            ),
            "pairs": sorted(cc_ground),
        }
        with open(REVIEWED_CC_PATH, "w", encoding="utf-8") as f:
            json.dump(payload, f, ensure_ascii=False, indent=1)
            f.write("\n")
        print(f"reviewed cc-pair list updated: {len(cc_ground)} pairs")
    print("\nPASS: sweep gate clean")


if __name__ == "__main__":
    main()
