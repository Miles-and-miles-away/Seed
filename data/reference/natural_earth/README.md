# Natural Earth 1:50m Land Polygons

- Source: https://naciscdn.org/naturalearth/50m/physical/ne_50m_land.zip
- Dataset: ne_50m_land, version 4.1.0
- License: public domain (Natural Earth)
- Downloaded: 2026-07-19

Used by `scripts/generators/build_water_blocklist.py` to detect
open-water spans along great-circle chords between same-landmass
city pairs. Kept in the repo so the blocklist can be regenerated
without a network dependency.
