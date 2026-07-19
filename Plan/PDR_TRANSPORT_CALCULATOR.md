# PDR: Phase 8 Transport Calculator -- Post-Design Review

**Created:** 2026-07-17 | **Restructured:** 2026-07-19
**Status:** Rounds 1-3 of adversarial review complete; every
finding through Round 3 fixed and re-verified (or explicitly
accepted, see R3-D1). Fix Backlog 3 (section 3) IN PROGRESS:
port-anchored links and the sweep gate are done; the
water-crossing blocklist generator is executing. Nothing
committed; owner reviews the working tree.
**Purpose:** Record of the adversarial review of the uncommitted
transport-calculator work, the owner decisions, and the fix
ledger. A fresh session must be able to continue from sections
2-4 alone. Companion docs: [PLAN_PHASE_8.md](./PLAN_PHASE_8.md)
(feature plan), [RESEARCH_TRANSPORT.md](./RESEARCH_TRANSPORT.md)
(evidence base; sec 9 documents the distance-estimation design).

---

## 1. Scope & Current State

Uncommitted on `development` (do NOT commit; owner reviews):

- `data/app/transport_modes.json` -- 27 modes, live-verified
  cited factors
- `data/app/cities.json` -- 982 cities, 10 port-anchored links
  (+ `water_blocked` pair list once Backlog 3 lands)
- `lib/features/transport/` -- models, loaders, calculator,
  distance/suggestion service (generated files committed-style)
- `test/features/transport/` -- 93 tests
- `scripts/generators/build_cities.py`,
  `sweep_suggestions.py` (regeneration gate),
  `build_water_blocklist.py` (Backlog 3)
- `data/reference/natural_earth/` -- land polygons (Backlog 3)
- Edits to PLAN_PHASE_8.md, RESEARCH_TRANSPORT.md,
  data/app/impact_equivalencies.json

Verification baseline: `flutter analyze` clean; full suite
green (1,563 at last full run); sweep gate PASS (481,671 pairs:
zero fictional ferries, zero cross-water ground/active, all air
fallbacks >= 100 km, every link produces >= 1 pair).

Review method (each round): four parallel adversarial agents --
Dart bug hunt, independent maths recomputation, design red-team
with a full all-pairs sweep, naive-user deception audit with
live re-fetches of every cited URL.

---

## 2. Standing Decisions (live rules -- read before touching data)

Owner-approved. The warnings exist because earlier decisions
were superseded; do not "fix" data backwards from old text.

- **Active modes ship electricity-only**: walk 0 / cycle 0 /
  ebike 2 / escooter 6. Do NOT restore cycle 16 / ebike 8 (a
  superseded Round 1 decision proposed them). Metabolic figures
  live in the methodology sheet with OWID's additionality
  caveat; never generate copy claiming walking beats cycling.
- **Private jet ships 1,700** (1,000 derived base x 1.7 RF,
  DESNZ 2025 para 8.43); airline factors include RF; helicopter
  is combustion-only. In-chart jet footnote is a UI requirement.
- **Taxi ships per-vehicle 208.06**, per_vehicle true,
  max_occupants 4. Do NOT ship the 148.61 per-passenger variant
  (dated 1.4-occupancy embedded invisibly). Deadheading is
  excluded by DEFRA (para 5.42, quoted); note says so.
- **Zero fiction beats convenience**: when a suggestion cannot
  be scoped to a real corridor, kill it (Malta-Sicily link
  removed; Gibraltar cap history in Appendix A).
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

---

## 3. Active Work: Fix Backlog 3 -- Structural Robustness

Owner-approved 2026-07-19: stop whack-a-moling per-pair; make
the method robust to regeneration. "It's okay to lose
links/pairs if the method becomes more robust."

### 3.1 Port-anchored ferry links (R3-D4) -- DONE

`CityLink` gained six optional flat fields (json snake_case):
`port_a_lat/port_a_lon/radius_a_km` + b-side trio. Ferry
offered iff each city is within its side's radius AND
straight-line <= (`max_km` ?? 500). Portless links keep legacy
behavior; rail_tunnel links stay portless. Distance semantics
unchanged (whole straight line at ferry rate; ports gate
eligibility only).

Port table (radii are catchment decisions, verified against
dataset coordinates):

| Link | a-side port (r km) | b-side port (r km) |
|---|---|---|
| Dover-Calais | Dover 51.127,1.324 (150) | Calais 50.966,1.862 (150) |
| Irish Sea | Dublin Port 53.345,-6.194 (150) | Holyhead 53.309,-4.633 (250; nearest GB city Manchester 160) |
| Ireland-France (max_km 900) | Rosslare 52.251,-6.335 (180; Cork 151) | Cherbourg 49.646,-1.622 (350; Paris 301, Brussels 445 out) |
| Busan-Fukuoka | Hakata 33.606,130.410 (150) | Busan 35.098,129.040 (150) |
| Gibraltar | Tanger 35.789,-5.813 (150) | Algeciras 36.127,-5.444 (150) |
| Naples-Palermo/Messina | Palermo 38.13,13.37 (150) | Naples 40.842,14.252 (150) |
| Zanzibar | Zanzibar -6.162,39.19 (50) | Dar port -6.82,39.29 (50) |
| Cook Strait | Wellington -41.28,174.78 (50) | Picton -41.29,174.00 (300; Christchurch 274) |
| St Thomas-St Croix | Charlotte Amalie 18.34,-64.93 (50) | Christiansted 17.75,-64.70 (50) |

Result: ferry pairs 100 -> 21, every one on its named corridor;
Sevilla-Tangier revived; Dublin-Groningen/Koln/Daejeon inland
foot-ferries gone; pins updated (Sevilla-Tangier HAS,
Hiroshima-Busan NO, Dublin-Amsterdam NO, London-Paris keeps
ground loses ferry, synthetic port-gating unit test).

### 3.2 Water-crossing blocklist (R3-D5) -- IN PROGRESS

`scripts/generators/build_water_blocklist.py`: reads
cities.json + Natural Earth 1:50m land polygons
(`data/reference/natural_earth/`, public domain), densifies the
great-circle chord of every same-mass pair within 2,000 km, and
computes the longest continuous water span crossed. Span >
WATER_SPAN_BLOCK_KM (25; bridged Oresund ~15 survives) => pair
enters `metadata.water_blocked` as `[i, j]` index pairs (i < j,
indices into the stored cities array -- regenerate together).
MANUAL_BLOCK for water polygons cannot see (Kinshasa-
Brazzaville, unbridged Congo). MANUAL_ALLOW for real bridged
corridors the threshold would wrongly block (calibrated from
output; each entry names its real crossing).

Runtime: `suggestedDistancesKm` gained optional `waterBlocked`
set (keys from `cityPairKey`; loader `loadWaterBlockedPairs`
resolves indices). Ground/active suppressed for blocked pairs;
ferry/air unaffected.

Accepted gaps: lakes not included (ne_50m_land only); distances
suppressed, not corrected (no routing in an offline app);
same-mass ferry corridors (Helsinki-Tallinn) cannot be
expressed by mass-to-mass links -- blocked pairs >= 100 km fall
back to air, below that manual entry.

Pins: Helsinki-Tallinn NO ground/active; Kinshasa-Brazzaville
NO ground/active; Copenhagen-Malmo KEEPS ground; unit test for
suppression + air fallback.

### 3.3 Sweep as committed regeneration gate (R3-D6) -- DONE

`scripts/generators/sweep_suggestions.py` (replaces the
scratchpad artifact): faithful replica of suggestedDistancesKm
incl. ports and blocklist, all pairs; exits nonzero printing
offenders on: cross-mass ground outside rail_tunnel links; any
cross-mass active; ferry violating ports or max_km; air
fallback < 100 km; ground/active on a water_blocked pair; any
dead link; CITY_COUNT pin mismatch. Wired into the
build_cities.py header ("regeneration is not done until it
passes").

### 3.4 Remaining before done

- Water agent lands `water_blocked` + MANUAL_ALLOW report;
  eyeball surprising blocks; re-run sweep gate + full suite.
- Research sec 9: blocklist + gate documentation, enclosed-sea
  limitation bullet updated to "resolved by blocklist" with the
  lakes gap noted.
- Update section 1 baseline numbers and this section's status.

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
- Do NOT commit or push -- owner reviews the working tree.

---

## 5. Completed Fix Ledger (all verified; details in Appendix B)

Round 1 (2026-07-18, all [x], re-verified Rounds 2-3):

- [x] PDR-1 uncapped landmass ferries (Tokyo-Madrid) -> ferry
      cap + per-link max_km (since superseded by ports)
- [x] PDR-2 island/territory landmass errors (TL, BN, GQ, BM,
      GL, AX, IM, JE, YT, RE, ID/PH/NZ splits, XK, MF+SX) ->
      ISLANDS/anchors extended, fail-loud generator
- [x] PDR-3 six annotation "quotes" -> live-verified row text
- [x] PDR-4 active-mode scope contradiction -> electricity-only
      convention + disclosure (see Standing Decisions)
- [x] PDR-5 false "survives 2026 revisions" claim -> invariants
      reframed as data pins; metro dropped from invariant 2
- [x] PDR-6 stale "well-to-tank" scope line deleted
- [x] PDR-7 RF scope contradictions -> scope sentence amended;
      jet note "conservative lower band"
- [x] PDR-8 no international rail -> rail_international 4.46
      added with loud 2026 caveat
- [x] PDR-9 equivalency carKm 200 -> 162.72 (DEFRA 2025)
- [x] PDR-10 "saves" copy + stale mock numbers -> "emits less",
      refreshed totals
- [x] PDR-11 coach 2026-repudiation disclosure line
- [x] PDR-12 shinkansen basis "Japan rail average, CO2" +
      Navitime 2018 vintage corrected
- [x] PDR-13 EV grid-dependence sublabel recorded as UI req
- [x] PDR-14 gating edges -> walk 40 split, minFlight 250,
      comment fixes; per-mode maxSuggestKm stays a UI-PR item
- [x] PDR-15 taxi + car ferry modes added (see Standing
      Decisions for the taxi correction)
- [x] PDR-16 haversine antipodal NaN -> min(1.0, a) clamp
- [x] PDR-17 occupant clamp crash -> clamp(1, max(1, ...));
      motorbike perVehicle pinned
- [x] PDR-18 generator csv QUOTE_NONE + coord-aware dedup
- [x] PDR-19 cities.json decoded once (memoized, error-safe)
- [x] PDR-20 island empty maps -> air fallback + MF/SX mass

Round 2 (2026-07-18, all [x], re-verified Round 3):

- [x] R2-1 Zanzibar tagged Africa -> TZ split + ferry link
- [x] R2-2 Faroes tagged Eurasia -> FO isolated
- [x] R2-3 seven archipelagos single-mass -> KM/PG/CV/FJ/BS/TC/
      VI per-island anchors
- [x] R2-4 helicopter quote on homepage URL -> deep link
- [x] R2-5 private_jet PJCC annotation -> real sentence
- [x] R2-6 taxi 148.61 misleading -> per-vehicle 208.06 (R2-D1)
- [x] R2-7 Gibraltar catch-all Red Sea ferries -> capped (now
      port-anchored)
- [x] R2-8 Ireland-France link dead -> max_km 900 revival
- [x] R2-9 Suez corridor -> documented continental convention
- [x] R2-10 +95 km pad on micro-hops -> 100 km fallback floor +
      NaN guard (R2-D3)
- [x] R2-11 motorbike cited to deprecated Climatiq -> re-cited
- [x] R2-12 Navitime quote unmarked translation -> Japanese
      original + marked translation
- [x] R2-13 longhaul RF unsupported -> RF-stating source added
- [x] R2-14 escooter 6 not reproducible -> aluminium-variant
      quote + range note
- [x] R2-15 rejected future memoized forever -> cache cleared
      on error
- [x] R2-16 unpinned guards -> 4 test pins added
- [x] R2-17 walkModeMaxKm has no consumers -> UI-PR item
- [x] R2-18 BH-QA / HK-Macau circuity lies -> known-limitations
      doc line (class now handled by Backlog 3 blocklist)
- [x] R2-19 MY Borneo latent trap -> anchors added
- [x] R2-20 research doc typos fixed
- [x] R2-21 CE Delft quote misattribution -> citation added
- [x] R2-22 JR Central claim uncited -> source added, JR East
      attribution dropped (JSON; doc fixed in R3-4)
- [x] R2-23 PDR recorded superseded D1 values -> supersession
      notes (now Standing Decisions warnings)
- [x] R2-24 grid factor 386 below current global -> methodology
      context note (app-wide house rule, out of scope)
- [x] R2-25 RF applies to CO2 component only -> one-line
      acknowledgment in research sec 8.1
- [x] R2-26 Greencalculus/SCIF reconstructions -> fixed in R3-9
      with live-verified page text

Round 3 (2026-07-19, all [x] except the accepted R3-10/11):

- [x] R3-1 Mombasa-Zanzibar fictional ferry (only suggestion)
      -> link capped, then port-anchored; pinned
- [x] R3-2 enclosed-sea ground fiction (Helsinki-Tallinn,
      Kinshasa-Brazzaville, ...) -> Backlog 3 water blocklist
- [x] R3-3 Cook Strait unmodeled -> ferry link + pin
- [x] R3-4 "JR East" attribution invented -> removed from
      research doc
- [x] R3-5 ferry_foot cited to deprecated page -> SustainMetrics
      sea row, live-verified
- [x] R3-6 Ireland-France inland reach -> ports + disclosure
      (R3-D2); Dublin-Amsterdam pinned NO ferry
- [x] R3-7 Malta-Sicily corridor fiction -> link removed; pin
- [x] R3-8 St Croix-St Thomas empty map -> real ferry link; pin
- [x] R3-9 citation nits (delimiters, stray colon, mid-sentence
      caps, missing "A", Navitime ellipsis, indirect RF, CARB/
      TRUE uncited, stale 8.1 heading, laundry "saves") -> all
      fixed with live re-fetches; CARB kept WITH citation
      (SB 1014 PDF verified verbatim), TRUE trimmed as
      unverifiable; metadata citation_note discloses the
      row-transcription convention
- [ ] R3-10 Dart minors (NaN guard, modes double-decode, latent
      tunnel-active, fallback comment, near-duplicate metro
      cities) -- ACCEPTED, no fix (R3-D1)
- [ ] R3-11 maths-doc minors (stale sec 6 preamble, unflagged
      tram assumption, illustrative 81 kg, vacuous 2026 skip)
      -- ACCEPTED, no fix (R3-D1)

Verified sound across rounds (for the record): all 27 factors
reproduce digit-for-digit from independent recomputation; all 13
invariants hold now and under flagged 2026 revisions; haversine
matches an independent implementation to 3.6e-11 km; occupancy
clamping exact; mock arithmetic exact; DESNZ paras 5.39/5.42/
8.43/8.44/8.45 verbatim; all cited URLs live.

---

## Appendix A: Review History

- **Round 1 (reviewed 2026-07-17, fixed 2026-07-18).** First
  adversarial pass on the working tree: 5 blockers, 10 majors,
  5 minors (PDR-1..20). Headline classes: uncapped mass-level
  ferry links, island/territory landmass errors, annotation
  text shipped as quotes, active-mode scope contradiction.
  Key superseded decision: D1 originally kept cycle 16 / ebike
  8 "for consistency"; the owner later switched active modes to
  electricity-only -- hence the Standing Decisions warning. D3
  originally shipped taxi at 148.61 per-passenger-km
  "deadheading included"; Round 2 proved the premise false
  (DESNZ 5.42 excludes deadheading) and taxi shipped per-vehicle
  at 208.06 instead.
- **Round 2 (2026-07-18).** Re-run of the four agents plus a
  full-pair sweep and live fetches of all cited URLs: 6
  blockers, 8 majors, 12 minors (R2-1..26), largely archipelago
  geography and citation integrity. Decision R2-D2 introduced
  per-link max_km; its Gibraltar cap was amended 200 -> 150
  mid-execution when the sweep falsified the ">= 207 km"
  premise -- zero fiction took precedence and Sevilla-Tangier
  (180 km) was knowingly sacrificed, a regret later resolved by
  port anchoring (Backlog 3), which revived it.
- **Round 3 (2026-07-19).** Re-run against the post-Backlog-2
  tree: zero blockers; all prior fixes re-verified (factors
  digit-for-digit, sweep replica passing all Dart pins, 23/23
  URLs live). Findings R3-1..11; owner promoted three
  data/design minors to blocking, accepted the Dart/maths-doc
  minors (R3-D1), and approved the structural Backlog 3.
- **Historical baselines:** R1 review 1,534 tests; post-R1
  1,559; post-R2 sweep: 106 ferry pairs, 40 empty-map pairs,
  248 air fallbacks; post-R3+ports sweep: 21 ferry pairs.

## Appendix B: Where the Detail Went

The full findings registers (evidence columns, per-fix
instructions), the executed backlogs 1-2, and the round kickoff
prompts were moved verbatim to
[PDR_TRANSPORT_ARCHIVE.md](./PDR_TRANSPORT_ARCHIVE.md) in the
2026-07-19 restructure -- every item is executed and
independently re-verified, so the one-line ledger (section 5)
carries the working record. The load-bearing survivors --
standing decisions, supersession warnings, the active backlog,
and verification -- live in sections 2-4.
