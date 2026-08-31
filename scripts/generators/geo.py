#!/usr/bin/env python3
"""Geometry and GeoNames I/O shared by the city generators.

Imported by sibling scripts in this directory, which Python puts on
sys.path when they are run directly.
"""
import csv
import math

# IUGG mean Earth radius.
EARTH_RADIUS_KM = 6371.0088


def haversine_km(lat1, lon1, lat2, lon2):
    # build_water_blocklist.py's exact expression, kept because the
    # water_blocked index it generates ships in cities.json: the three
    # former copies agreed to ~4e-11 km but not bit-for-bit.
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dp = p2 - p1
    dl = math.radians(lon2 - lon1)
    a = (
        math.sin(dp / 2) ** 2
        + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
    )
    return 2 * EARTH_RADIUS_KM * math.asin(math.sqrt(min(1.0, a)))


def geonames_rows(path):
    """Yield the rows of a GeoNames tab-separated dump."""
    with open(path, encoding="utf-8") as f:
        # GeoNames is raw tab-separated text; default quoting would
        # corrupt rows containing quote characters.
        yield from csv.reader(f, delimiter="\t", quoting=csv.QUOTE_NONE)


def _self_check():
    km_per_deg = 111.195
    assert abs(haversine_km(0, 0, 0, 1) - km_per_deg) < 0.5
    assert haversine_km(35.68, 139.69, 35.68, 139.69) == 0
    # Antipodal points are half the circumference apart.
    assert abs(haversine_km(0, 0, 0, 180) - math.pi * EARTH_RADIUS_KM) < 1e-6
    print("geo.py self-check passed")


if __name__ == "__main__":
    _self_check()
