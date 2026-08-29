# PDR: Phase 8 Transport Calculator -- Post-Design Review

**Created:** 2026-07-17 | **Restructured:** 2026-07-19
**Status:** Feature shipped. Review rounds 1-7 complete and Fix
Backlogs 1-7 executed; every finding through Round 3 is fixed and
re-verified (or explicitly accepted, see R3-D1), and the Round 4-7
work landed as the water-crossing blocklist, the political
overlays and the political screen. Sweep gate PASS re-run
2026-08-29.
**Purpose:** Record of the adversarial review of the
transport-calculator work, the design decisions, and a brief
record of the completed work. Companion docs: [PLAN_PHASE_8.md](./PLAN_PHASE_8.md)
(feature plan), [RESEARCH_TRANSPORT.md](./RESEARCH_TRANSPORT.md)
(evidence base; sec 9 documents the distance-estimation design
and Appendix A the durable rules from all seven rounds).

**Scope warning:** the body below section 2 froze at the Round 3
restructure. Rounds 4-7 produced no per-round findings register in
any file; their durable output is the rule set in
RESEARCH_TRANSPORT.md section 9 and Appendix A, plus the constants
in `scripts/generators/build_water_blocklist.py`. Section 2 has
been brought forward from those sources; treat them, not this
document, as the regeneration authority.

---

## 1. Scope & Current State

Shipped. Measured 2026-08-29:

- `data/app/transport_modes.json` -- 27 modes, live-verified
  cited factors
- `data/app/cities.json` -- 969 cities; 10 fixed links (9 ferry,
  port-anchored, + the portless Channel Tunnel rail_tunnel);
  `metadata.water_blocked` holds 2,399 index pairs
- `lib/features/transport/` -- models, loaders, calculator,
  distance/suggestion service (generated files committed-style)
- `test/features/transport/` -- 156 tests
- `scripts/generators/build_cities.py` (city list),
  `scripts/generators/build_water_blocklist.py` (water-crossing
  and political blocklist),
  `scripts/generators/sweep_suggestions.py` (regeneration gate)
- `data/reference/natural_earth/` -- Natural Earth 1:50m land
  polygons plus the cached 0.1-degree land raster
- `data/reference/reviewed_cc_ground_pairs.json` -- 1,624
  border-screened cross-country ground pairs, the input to the
  R7 political screen
- Edits to PLAN_PHASE_8.md, RESEARCH_TRANSPORT.md,
  data/app/impact_equivalencies.json

Verification baseline: the full suite was green and the sweep
gate PASSed on 2026-08-29. Do not read counts out of this
document -- running `scripts/generators/sweep_suggestions.py`
prints the current ones (pairs swept, suggestion kinds, blocked
pairs honored, reviewed cross-country pairs, smallest air
fallback, and ferry pairs per link, which is also how a dead
link shows up). The 2026-08-29 figures are recorded in
[PDR_TRANSPORT_ARCHIVE.md](./PDR_TRANSPORT_ARCHIVE.md).

Review method (rounds 1-3, the rounds with a written record):
four parallel adversarial agents -- Dart bug hunt, independent
maths recomputation, design red-team with a full all-pairs sweep,
naive-user deception audit with live re-fetches of every cited
URL. RESEARCH_TRANSPORT.md Appendix A describes the same four
lenses running across all seven rounds, but rounds 4-7 have no
per-round write-up to cite.

---

## 2. Standing Decisions (live rules -- read before touching data)

Owner-approved. The warnings exist because earlier decisions
were superseded; do not "fix" data backwards from old text.

- **Active modes ship electricity-only**: walk 0 / cycle 0 /
  ebike 2 / escooter_private 7. Do NOT restore cycle 16 / ebike
  8 (a superseded Round 1 decision proposed them). Metabolic
  figures live in the methodology sheet with OWID's
  additionality caveat; never generate copy claiming walking
  beats cycling.
- **SUPERSEDED -- R2-24 (grid factor 386) no longer holds.**
  Decision **E1 (2026-08-02)** raised the house grid factor
  386 -> 458 g CO2e/kWh (Ember GER 2026) and rebased every
  electricity-derived mode: **car_bev 73 -> 86**,
  **escooter_private 6 -> 7**, ebike holds at 2. The three
  shipped values are 458 / 86 / 7 in
  `data/app/transport_modes.json` today. Do NOT restore 386, 73
  or 6 from the R2-24 ledger line or from any pre-August prose;
  regionalisation was explicitly spun out and is NOT part of E1
  ([PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md)).
- **Private jet ships 1,700** (1,000 derived base x 1.7 RF,
  DESNZ 2025 para 8.43); airline factors include RF; helicopter
  is combustion-only. In-chart jet footnote is a UI requirement.
- **Taxi ships per-vehicle 208.06**, per_vehicle true,
  max_occupants 4. Do NOT ship the 148.61 per-passenger variant
  (dated 1.4-occupancy embedded invisibly). Deadheading is
  excluded by DEFRA (para 5.42, quoted); note says so.
- **Zero fiction beats convenience**: when a suggestion cannot
  be scoped to a real corridor, kill it (Malta-Sicily link
  removed; Gibraltar cap history in the archive).
- **Ferry links are port-anchored** (R3-D4): port coordinate +
  catchment radius per side; `max_km` remains a backstop.
  rail_tunnel links stay portless.
- **Ireland-France reach ships as documented convention**
  (R3-D2): whole-distance foot-ferry pricing is a single-mode
  approximation, disclosed in research sec 9.
- **Ground suggestions capped at 2,000 km** straight-line
  (product rule); minFlight 250; ferry default cap 500; air
  fallback floor 100; active cap 150; walk cap 40 (applied at
  kind-to-mode mapping).
- **Cities-not-pairs; no points anywhere in v1 (No Fake
  Points); every prefilled distance stays user-editable.**
- **Never ship a self-derived number that contradicts the cited
  set** (PHEV precedent; taxi deadheading precedent).
- **Stop line (R3-D1)**: the Dart-code minors and maths-doc
  minors in the Round 3 register (Appendix B, R3-10/R3-11) are
  accepted as-is; do not fix without new owner direction.
- **After ANY regeneration of cities.json, run
  `scripts/generators/sweep_suggestions.py`**; regeneration is
  not done until the gate passes (R3-D6).

### 2.1 Blocklist rules (Backlogs 4-7)

Added by rounds 4-7 and load-bearing on every regeneration.
Source of truth: RESEARCH_TRANSPORT.md section 9 and Appendix A,
plus the constant block in `build_water_blocklist.py`. Rounds 4-7
left no findings register, so those two are the record.

- **Land-path honesty test (R3-D5/R4, made unconditional in
  R6).** A candidate pair blocks unless an honest land route
  exists. The route is the shortest path on a 0.1-degree
  rasterized land graph (`RASTER_DEG`, 8-connected, geodesic edge
  weights) and it must come in at or under `HONESTY_MAX` = **1.4x
  the estimate the app shows** (that estimate is
  `GROUND_CIRCUITY` 1.3 x straight-line), with grid
  underestimation compensated by `ROAD_OVER_GEODESIC` 1.15 and
  `PATH_SLACK_KM` 30 for short hops. Since Round 6 the test runs
  on **every** candidate pair, dry chords included, so walls and
  front lines block the corridors they cut without hand-curated
  pair lists. Wetness alone no longer decides:
  `WATER_SPAN_BLOCK_KM` (25 km of continuous water) only selects
  which chords are wet. This replaced Round 3's per-pair
  curation, which a Round 4 audit showed had a false-positive
  class in the hundreds.
- **FIXED_CROSSINGS + the crossing self-check.** Real bridges,
  tunnels and causeways are declared explicitly (16 entries
  today) and added to the land graph. The build runs a
  self-check that **warns loudly** when a crossing's snapped
  cells collapse or its edge stops being load-bearing on a
  crossings-free graph. This is not cosmetic: three entries were
  silently dead before Backlog 5 (R5-11). Never add a crossing
  without letting the self-check confirm it carries traffic.
- **CLOSED_BORDERS (R5, extended R6) blocks on politics, not
  geography.** Every pair between two countries whose shared
  border is closed is blocked regardless of water or detour
  honesty. **Owner rule: active fighting between two countries
  closes their border, and doubt resolves to blocked** --
  aid-only, trade-only and pilgrim-only crossings count as
  closed. 22 country pairs are listed today. Verdicts carry
  expiry risk; re-verify live against the border-status watchlist
  in RESEARCH_TRANSPORT.md Appendix A.5 before regenerating.
- **BORDER_WALLS cut edges before pathfinding.** They are
  polyline barriers, so a closed border also stops **third-country
  transit** (Warsaw-Helsinki must round the Gulf of Bothnia,
  measures dishonest, auto-blocks). They double as the repair for
  fake-land raster artifacts, restoring sub-resolution water to
  water (Amazon delta/Marajo, Oslofjord pinch, Dardanelles). 22
  walls today; **each names its basis and must cut at least one
  edge or the build aborts.**
- **DISHONEST_CC_PAIRS** blocks country pairs whose corridors
  measure dishonest as a class, where grid geodesics undercut the
  real detour (IR-AE/OM/QA around Hormuz, CD/CG x NG/TG/BJ around
  the Gulf of Guinea bight, PK-SA at 1.85). 10 entries.
- **MANUAL_BLOCK is the pair-level escape hatch** for what
  neither polygons nor the raster can see (unbridged Congo,
  Parana-delta raster gaps, Narva vehicle closure,
  measured-dishonest bridge chains such as Malmo-Arhus at 1.8x).
  25 entries. **MANUAL_ALLOW is deliberately empty** and is to
  stay that way: an allow entry overrides the honesty test, so
  reach for a FIXED_CROSSING or a threshold argument first.
- **Gaza cities are removed from the dataset outright (R6-1,
  owner ruling 2026-07-21).** All crossings are sealed, so no
  honest suggestion of any kind exists. It is a predicate in
  `build_cities.py` (`excluded()`, PS west of lon 34.9), not a
  name list; do not reintroduce the cities by widening the
  top-N cut.
- **Same-settlement dedup at 1.5 km** (`DEDUP_KM` in
  `build_cities.py`): within a country, a city closer than 1.5 km
  to a larger one is the same settlement and is dropped before
  the top-N cut (Majuro's twin listing, Macau/Conakry/Luanda
  district records). 1.5 km is calibrated to keep adjacent
  municipalities (Frederiksberg sits 2.0 km from Copenhagen);
  raise it only with a dataset diff.
- **Political screen (R7) gates the sweep.** Every grounded
  cross-country pair must appear in
  `data/reference/reviewed_cc_ground_pairs.json`; a new,
  unscreened corridor fails the gate. The flow is: screen the
  border for ordinary travelers, block it in
  `build_water_blocklist.py` if closed, and only then rerun the
  sweep with `--update-reviewed` to refresh the list. Refreshing
  first defeats the screen.
- **Regeneration order:** `build_cities.py` ->
  `enrich_city_names.py` -> `build_water_blocklist.py` ->
  `sweep_suggestions.py`. Only the first writes a fresh file; the
  rest enrich it in place, so skipping one silently drops what it
  adds. Regeneration is not done until the gate passes. Note that
  cities.json has been edited in place since the last full
  build, so the next full regeneration backfills freed top-N
  slots with new cities and the political screen will fail until
  each new corridor is screened (RESEARCH_TRANSPORT.md Appendix
  A.5, backfill note).

---

## 3. Fix Backlog 3 -- Structural Robustness (COMPLETE)

Owner-approved 2026-07-19 and fully executed; nothing remains
open. It delivered port-anchored ferry links (R3-D4), the
water-crossing blocklist (R3-D5), and
`scripts/generators/sweep_suggestions.py` as a committed
regeneration gate (R3-D6). Rounds 4-7 then extended the
blocklist into the honesty and political overlays, and section
2.1 carries the rules as they stand today. Port coordinates and
catchment radii ship in `data/app/cities.json`, which is their
authority, so no archived table can silently disagree with the
data. Full backlog text is in
[PDR_TRANSPORT_ARCHIVE.md](./PDR_TRANSPORT_ARCHIVE.md).

---

## 4. Verification (every pass)

- `flutter analyze` -- zero issues.
- `dart run build_runner build` after model changes (generated
  files are committed).
- `flutter test` -- full suite; read summaries with
  `... | tr '\r' '\n' | tail`.
- `conda activate seed && python
  scripts/generators/sweep_suggestions.py` -- must PASS.
- Every new or changed source quote re-verified LIVE before
  pasting (WebFetch or seed-env requests/trafilatura).

---

## 5. Completed Work (brief record)

Rounds 1-3 produced 65 findings: 20 in Round 1 (PDR-1..20), 26
in Round 2 (R2-1..26), 11 in Round 3 (R3-1..11). All are fixed
and re-verified except R3-10 and R3-11, the Dart and maths-doc
minors, which were accepted as-is rather than fixed under the
R3-D1 stop line. Per-finding detail, the round decisions, the
executed backlogs and the full one-line ledger are in
[PDR_TRANSPORT_ARCHIVE.md](./PDR_TRANSPORT_ARCHIVE.md), whose
ledger also carries the only rounds 4-7 identifiers that exist
anywhere (R4-9, R4-10, R5-11, R6-1, E1, and the round-level
R5/R6/R7 entries). Appendix A says why no register exists.

---

## Appendix A: Review History

- **Rounds 1-3.** The per-round narrative, the severity counts
  and the historical measured baselines are in
  [PDR_TRANSPORT_ARCHIVE.md](./PDR_TRANSPORT_ARCHIVE.md).
- **Rounds 4-7: no per-round narrative exists.**
  Unlike rounds 1-3, these rounds were not written up: there is
  no findings register, severity table or kickoff prompt for
  them in this repo, and the archive does not hold one either.
  Their durable output is the rule set in
  RESEARCH_TRANSPORT.md section 9 and Appendix A, restated in
  section 2.1 above; the only identifiers that exist are the
  ones listed in the archived ledger. Do not reconstruct a
  round-by-round story from them.

## Appendix B: Where the Detail Went

- **Rounds 1-3:**
  [PDR_TRANSPORT_ARCHIVE.md](./PDR_TRANSPORT_ARCHIVE.md) --
  registers with evidence columns, round decisions, executed
  backlogs 1-3, the completed fix ledger, the review history.
- **Rounds 4-7:**
  [RESEARCH_TRANSPORT.md](./RESEARCH_TRANSPORT.md) section 9 and
  Appendix A, plus the constant block in
  `scripts/generators/build_water_blocklist.py`; section 2.1
  mirrors them. No rounds 4-7 register exists in any file.
- The load-bearing survivors -- standing decisions, supersession
  warnings, the blocklist rules, and verification -- live in
  sections 2-4.
