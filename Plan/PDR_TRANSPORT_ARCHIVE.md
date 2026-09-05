# PDR Transport Calculator -- Archive (pre-restructure detail)

**Archived:** 2026-07-19. Verbatim long-form content moved out
of [PDR_TRANSPORT_CALCULATOR.md](./PDR_TRANSPORT_CALCULATOR.md)
when it was restructured. Everything here is EXECUTED or CLOSED
and re-verified; nothing below is a live instruction. The live
rules and the verification checklist are in the main PDR.

**Second pass 2026-08-29.** A further round of completed work
came across from the main PDR, which now keeps a short record of
each: Fix Backlog 3 in full (port-anchored links and the port
table, the water-crossing blocklist, the sweep gate), the
completed fix ledger, the rounds 1-3 review-history narrative,
and the historical measured baselines including the 2026-08-29
one. The sections added in this pass carry no number, so the
existing "section 9" reference from RESEARCH_TRANSPORT.md keeps
resolving.

**Scope: rounds 1-3 detail, plus the completed fix ledger.**
The ledger's tail carries the only rounds 4-7 identifiers that
exist anywhere (R4-9, R4-10, R5-11, R6-1, the round-level R5/R6/
R7 entries, and E1). There is still no rounds 4-7 findings
register in this or any other file and none should be invented.
The rounds 4-7 rules live in
[RESEARCH_TRANSPORT.md](./RESEARCH_TRANSPORT.md) section 9 and
Appendix A, mirrored in the main PDR's section 2.1.

---

## 1. Original Status & Scope (as of Round 2 completion)

Uncommitted on `development` (do NOT commit; owner reviews):

- `data/app/transport_modes.json` -- 24 modes, cited factors
- `data/app/cities.json` -- 977 cities + 7 landmass links
- `lib/features/transport/` -- models, loaders, calculator engine,
  distance/suggestion service (+ committed-style generated files)
- `test/features/transport/` -- 75 tests
- `scripts/generators/build_cities.py`
- Edits to PLAN_PHASE_8.md, RESEARCH_TRANSPORT.md

Baseline: `flutter analyze` clean; full suite 1534/1534 passing.

Review method: four parallel adversarial agents (Dart bug hunt,
independent maths recomputation, design red-team with a full
977-city pair sweep, naive-user deception audit with live source
re-fetches). Convergent findings below; the calculator arithmetic,
all 24 factors, all derivation chains, and the haversine
implementation were independently verified correct.

---

## 2. Round 1 Findings Register

Severity: B = commit blocker, M = major, m = minor.

| ID | Sev | Finding | Evidence / example | Fix |
|----|-----|---------|--------------------|-----|
| PDR-1 | B | Ferry links join whole landmasses, uncapped; ferry is the only suggestion kind with no distance gate (`journey_distance.dart` `_linked` + `kindFerry` branch) | 114,640 pairs get ferry, 95% over 2,000 km; "Tokyo->Madrid ferry 10,762 km, 201 kg, 84% greener than flying"; Dakar->Dili 15,935 km | Add `ferryModeMaxKm` (~500) now; port-anchored links later |
| PDR-2 | B | Landmass geography wrong at edges (`build_cities.py` ISLANDS set + region fallbacks) | TL/BN tagged Eurasia (ground across South China Sea); Malabo/Bioko tagged Africa (cycling 139 km of ocean); BM/GL/PM/FK/GS/SJ/IM/JE/YT/RE mainland-tagged (Bermuda->NYC "ground"; Aland->Stockholm "walking"); ID/PH/NZ single-mass (Jakarta->Medan ground); Naples->Palermo ground-but-never-ferry; Marigot<->Philipsburg (6 km, one island, two ccs) returns {}; Kosovo (XK) silently absent | Extend ISLANDS; special-case territories; per-island masses for ID/PH/NZ/GQ; XK->Eurasia; MF+SX shared mass; fail loudly on unmapped ccs; regenerate |
| PDR-3 | B | Six `quote` fields are researcher annotations, not page text (all `car_*` modes + `bus_city` share one "triple-corroborated..." sentence) | First source a reviewer checks is not on the cited page; other 18 modes verified verbatim by live fetch | Replace with real SustainMetrics row text; re-verify live before pasting |
| PDR-4 | B | Active-mode scope contradiction: metadata scope says operational-energy-only, yet cycle=16 (food) and walk=0 (food excluded); own source says walking ~56 | App teaches "walking beats cycling; e-scooter beats bicycle" -- scope artifacts | Resolved by decision D1 (disclosure, not value change) |
| PDR-5 | B | RESEARCH_TRANSPORT.md sec 6 claim "each survives the flagged 2026 revisions" is false: metro -44% -> ~15.4 breaks invariants 1 and 2; invariant 1 margin is only 2.25 g (full BEV 18.25 vs cycle 16) | Next DEFRA pass fails CI or invites data-fudging | Correct sentence; drop metro from invariant 2; mark invariants as data pins, not truth claims |
| PDR-6 | M | PLAN_PHASE_8.md 8.1 scope line still says "direct + well-to-tank"; dataset is tank-to-wheel and forbids mixing WTT | Methodology sheet would be drafted from the wrong sentence | Delete "well-to-tank" from the line |
| PDR-7 | M | `metadata.scope` says "Aviation factors include RF" but private_jet is no-RF; jet note and research doc say "mid-band" when 1,000 is the conservative lower third; jet-vs-airline gap understated ~1.7x | Scope statement contradicted within its own file | Amend scope sentence; reword to "conservative lower band"; see decision D2 |
| PDR-8 | M | No international-rail mode: London->Paris ground suggestion prices rail at 35.46 g/pkm (15.8 kg) vs honest ~2-5 kg -- 3-8x overstated on the corridor the tunnel link exists for | Undersells the flagship train-vs-plane story, pro-flying direction | Resolved by decision D3 (add mode) |
| PDR-9 | M | Phase 6 `data/app/impact_equivalencies.json` carKm uses 200 g/km (DEFRA 2023) vs dataset petrol avg 162.72 (2025) | Two contradictory petrol cars on one comparison screen | Update equivalency to 162.72 + source note; check Phase 6 tests pinning 200 |
| PDR-10 | M | "Rail saves 120 kg vs flying" mock copy: nothing was saved (hypothetical delta); mock totals also still use pre-2025 OWID factors (170/246) and a "Taxi" mode that did not exist | Unearned savings language; stale numbers in the plan doc | Copy rule "emits X kg less"; refresh mock numbers with shipped factors |
| PDR-11 | M | Coach ships 27.76, a figure DEFRA's 2026 release repudiates (+42-43% after fixing occupancy assumptions); today it undercuts rail, ordering flips next pass | "Honest, not generous" violation if silent | Science-sheet disclosure line; never generate coach-vs-rail superlatives |
| PDR-12 | M | Shinkansen 20 is Japan-rail-average CO2 (not CO2e, not Shinkansen-specific); Navitime corroboration is the 2018 edition, though the JSON note implies FY2023 for both sources | National-average CO2 relabeled as mode CO2e, next to UK CO2e rows | Fix note vintage; basis line "Japan rail average, CO2" in science sheet |
| PDR-13 | M | EV 73 presented as universal; grid-dependent ~6-150 worldwide (UK 40 falling to ~30; JP above 73); caveat lives only in calc note | "EVs emit 73 g/km" quoted as fact | UI sublabel "global-average grid; varies with your electricity" |
| PDR-14 | M | Gating edges: active cap 150 suggests walking 195 km road; minFlightKm 150 suggests flights on 150-260 km no-service corridors; groundModeMaxKm code comment says "long day of driving" (2,600 km road is not); high-impact modes have no suggestion caps; nothing maps leg length -> flight band (400 km leg on long-haul halves the honest rate) | Nonsense suggestions at boundaries | Split walk (<=40) vs cycle family (<=150) caps; raise minFlightKm to 250; fix comment; document per-mode `maxSuggestKm` + leg-length->flight-band as UI-PR items |
| PDR-15 | M | Missing modes actively mislead: taxi (mockup's own first leg; users self-label as drivers, deadheading omitted) and car ferry (drivers funneled to foot-passenger 18.71, 7x under) | -- | Resolved by decision D3 (add taxi, car ferry 129.33) |
| PDR-16 | m | `haversineKm` returns NaN for near-antipodal inputs (float pushes asin arg > 1); unreachable from shipped 977 cities (max a = 0.999979) but the function is exported API | NaN suppresses air suggestion silently if arbitrary coords ever flow in | `asin(sqrt(min(1.0, a)))` + antipodal test |
| PDR-17 | m | `legCo2eGrams` throws via `int.clamp(1, maxOccupants)` if a programmatic mode has maxOccupants < 1; and deleting motorbike's `per_vehicle` flag passes all 75 tests (silent semantics flip) | Crash instead of degrade; unpinned flag | `clamp(1, max(1, ...))`; add explicit motorbike perVehicle test |
| PDR-18 | m | build_cities.py: csv default quoting can corrupt GeoNames rows (needs QUOTE_NONE); dedup key (cc,name) merges genuinely distinct same-named cities (two Suzhous); US top-5 = NYC/LA/Brooklyn/Chicago/Queens (boroughs crowd out real cities) | Latent data corruption on rerun | QUOTE_NONE; add rounded coords to dedup key; note borough issue |
| PDR-19 | m | cities.json decoded per call and twice across the two loaders (87 KB, no cache) | Wasted work each open | Load once, return cities+links together or cache the decoded root |
| PDR-20 | m | 75 real island-neighbor pairs return an empty suggestion map (San Juan<->Charlotte Amalie 125 km; Mamoudzou->Moutsamoudou 113 km) | Picker shows nothing for real journeys | MF/SX shared mass fixes the worst; consider offering air below minFlightKm when map would be empty |

Round 1 verified sound: all 24 factors match RESEARCH_TRANSPORT.md
sec 5 digit-for-digit; every derivation chain reproduces; all 10
invariants hold on current data; haversine exact (R=6371.0088) and
tests catch radians/miles/swapped-arg mutations; generated JSON
mapping matches the data keys; quote fields on the other 18 modes
are verbatim on their cited pages; trees equivalency (21
kg/tree/yr) checks out.

---

## 3. Round 1 Decisions (owner-approved 2026-07-17)

- **D1 Active-mode scope: keep values, fix by disclosure.**
  **SUPERSEDED 2026-07-18** by the owner decision recorded in
  RESEARCH_TRANSPORT.md sec 3.3: active modes ship
  electricity-only (walk 0 / cycle 0 / ebike 2 / escooter 6).
  Do NOT restore cycle 16 / ebike 8. D1's disclosure mechanics
  (explicit scope statement, OWID additionality caveat, no
  walking-beats-cycling copy) still apply and are implemented.
  Original text: keep walk 0 / escooter 6 / ebike 8 / cycle 16
  (consistency with `bike_instead_of_car`). Rewrite
  `metadata.scope` to state the active-mode convention explicitly
  (cycling/e-bike include marginal food energy; walking's ~56 g
  metabolic excluded by convention, additionality debated -- cite
  OWID). Per-mode basis labels planned in UI ("incl. food energy"
  / "0 direct"). Never generate copy claiming walking beats
  cycling.
- **D2 Private jet RF: verify, then decide.** Fetch and read the
  DESNZ 2025/2026 methodology paper; confirm the current RF
  multiplier (evidence says 1.7, legacy 1.9). If confirmed, decide
  1,000 (no-RF, footnoted) vs ~1,700 (with-RF, chart-consistent)
  and document the choice in the jet's calc note + research doc
  sec 8.1. Until resolved: in-chart footnote requirement recorded
  in the phase doc. (Outcome: verified 1.7 at para 8.43; ships
  1,700 with-RF.)
- **D3 Add three shelved modes**: `rail_international` -- ship
  the verified DEFRA 2025 value 4.46 g/pkm with a loud calc note
  that the 2026 release raises it ~2.5x to ~11; `taxi` 148.61
  g/pkm (per PASSENGER-km, deadheading included, per_vehicle
  false); `ferry_car` 129.33 g/pkm (car passenger; calc note: one
  leg covers vehicle+passenger crossing).
  **D3 taxi CORRECTED 2026-07-18 by decision R2-D1:** the
  "deadheading included" premise is false -- DESNZ 2025
  methodology para 5.42 states empty running is excluded. Taxi
  ships per-vehicle at 208.06 instead.
- Standing decisions restated: ground suggestions capped at 2,000
  km straight-line (owner product rule); cities-not-pairs
  representation; no points anywhere in v1 (No Fake Points);
  distances always user-editable estimates.

---

## 4. Fix Backlog 1 (EXECUTED 2026-07-18)

1. **build_cities.py geography** (PDR-2, PDR-18): extend
   `ISLANDS` (+TL, BN); special-case territory ccs to isolated
   masses (BM, GL, PM, FK, GS, SJ, IM, JE, GG, AX, YT, RE, SH,
   TF, and GQ's Malabo/Bioko -- Bata is mainland); per-island
   masses for ID, PH, NZ (island-assignment table by city
   coordinates); XK -> Eurasia; MF and SX one shared mass; fail
   loudly (exit nonzero, print) on any cc that hits a fallback or
   is unmapped; csv QUOTE_NONE; dedup key gains rounded lat/lon.
   Regenerate cities.json; update `CITY_COUNT` and the
   exact-count test; expect Pristina/Prizren present.
2. **journey_distance.dart** (PDR-1, PDR-14, PDR-16): add
   `ferryModeMaxKm = 500` gate on `kindFerry`; `min(1.0, a)` in
   haversine; split active gating (`walkModeMaxKm = 40` constant,
   applied at kind->mode mapping time, keep cycle-family cap
   150); `minFlightKm` 150 -> 250; fix the groundModeMaxKm
   comment ("plausible long drive or one rail/coach journey").
3. **transport_calculator.dart** (PDR-17): occupants
   `clamp(1, max(1, mode.maxOccupants))`.
4. **transport_modes.json** (PDR-3, PDR-7, PDR-11, PDR-12, D1,
   D3): replace the six annotation quotes with live-verified
   SustainMetrics row text; rewrite `metadata.scope` per D1 + RF
   exception per PDR-7; jet note "mid-band" -> "conservative
   lower band"; coach note gains the 2026-revision disclosure;
   shinkansen note basis "Japan rail average, CO2" and Navitime
   vintage 2018; add the three D3 modes.
   `TRANSPORT_MODE_COUNT` 24 -> 27; new group `taxi`; ferry_car
   in `water`; rail_international in `rail`.
5. **Invariant tests + research doc sec 6** (PDR-5): correct the
   "survives 2026" sentence; invariant 2 becomes shinkansen <=
   tram/rail_national (drop metro, note why); note invariant 1's
   thin margin; add new-mode orderings only where stable.
6. **New regression tests** (PDR-1, PDR-2, PDR-16, PDR-17,
   PDR-20): Tokyo->Madrid NO ferry; Mariehamn->Stockholm NO
   ground/active; Bandar Seri Begawan->Singapore NO ground;
   Naples->Palermo NO ground; Marigot<->Philipsburg non-empty;
   antipodal haversine finite; motorbike perVehicle pinned true.
7. **Docs** (PDR-6, PDR-10): PLAN_PHASE_8.md -- delete
   "well-to-tank"; refresh mock totals; "saves" -> "emits less";
   record EV sublabel and jet footnote as UI requirements.
   RESEARCH_TRANSPORT.md sec 9 -- links are not chained; ferry
   cap; walk/cycle cap split; per-mode `maxSuggestKm` and
   leg-length->flight-band as UI-PR items.
8. **impact_equivalencies.json** (PDR-9): carKm 200 -> 162.72
   with DEFRA 2025 source note; update any pinned 200s.
9. **D2 verification task**: fetch the DESNZ methodology paper,
   confirm the RF multiplier with a verbatim quote + URL, set the
   jet factor per D2.
10. Optional polish: cities double-decode cache (PDR-19);
    empty-map air fallback (PDR-20); US borough filtering
    (PDR-18).

---

## 5. Round 2 Findings Register (2026-07-18)

Method: the four adversarial agents re-run against the post-fix
working tree (Dart bug hunt; independent maths recomputation;
design red-team with a full 982-city 481,671-pair sweep; naive-
user deception audit with live fetches of all 22 cited URLs plus
the DESNZ methodology PDF). Round 1 fixes all re-verified landed;
all 27 factors reproduce digit-for-digit; all 13 invariants hold
(including under the flagged 2026 revisions); zero ferry
suggestions over 500 km; zero empty maps; 19 of 22 citations
verbatim-clean.

| ID | Sev | Finding | Evidence / example | Fix |
|----|-----|---------|--------------------|-----|
| R2-1 | B | Zanzibar (TZ) tagged Africa | 60 cross-water ground pairs; Zanzibar->Dar es Salaam 74 km suggests ground + CYCLING across the Zanzibar Channel | TZ per-city split (GQ pattern) + Dar-Zanzibar ferry link |
| R2-2 | B | Torshavn (FO) tagged Eurasia -- FO missed when SJ/AX/IM/JE/GG were added | 68 ground pairs (Torshavn-Bergen 873 km over the Norwegian Sea) plus 5 rail_tunnel pairs: "London-Torshavn ground 1,605 km via Channel Tunnel" | FO -> ISLANDS |
| R2-3 | B | Seven archipelago ccs still single-mass: KM, PG, CV, FJ, BS, TC, VI | 22 cross-ocean ground pairs, 6 with cycling (Moroni-Moutsamoudou 135 km open Indian Ocean) | per-island anchors, same pattern as ID/PH/NZ |
| R2-4 | B | helicopter quote not on cited page (URL is the travelandclimate.org homepage) | quote exists verbatim on /climate-footprint-of-activities | swap URL |
| R2-5 | B | private_jet PJCC quote is a researcher annotation, not page text | page says "The Embraer Phenom 300 light jet gulps 183 gallons per hour" | paste real sentence |
| R2-6 | B | taxi note false + misleading: 148.61 does NOT exceed car 162.72; "deadheading included" contradicted by DESNZ para 5.42; solo riders told taxi beats driving | 148.61 = 208.06 / 1.4 assumed occupancy (L.E.K. 2002) | decision R2-D1 |
| R2-7 | M | Africa-Eurasia "Gibraltar" ferry link is a catch-all: 110 of 124 surviving pairs are Red Sea/Levant fiction; Port Said-Gaza's ONLY suggestion is a nonexistent ferry | mass-level links cannot scope regionally | decision R2-D2 |
| R2-8 | M | Ireland-France link permanently dead -- Round 1 regression: closest IE-Eurasia pair is Dublin-The Hague 723 km > 500 cap | Cork/Dublin->France lost their real ferry | decision R2-D2 |
| R2-9 | M | Suez land corridor unmodeled: Cairo-Jerusalem gets no ground, only the fictional ferry + air | mass-level ground link would leak (Sevilla-Tangier ground) | document convention (R2-D2) |
| R2-10 | M | Air-fallback +95 km pad dominates micro-hops: Marigot-The Valley 17 km -> "112 km flight" (~26 kg CO2e); 37 fallback pairs < 100 km; NaN coords yield {air: NaN} | decision R2-D3 + NaN guard |
| R2-11 | M | motorbike note claims DEFRA 2025 but sole citation is a 2024-vintage, deprecated Climatiq page | the 2025 row is on the already-cited SustainMetrics land page | re-cite |
| R2-12 | M | shinkansen Navitime quote is an unmarked English translation of a Japanese page (Ctrl-F fails) | page lists JP text; vintage claim itself accurate | quote the Japanese original, mark the translation |
| R2-13 | M | flight_longhaul "includes radiative forcing" unsupported by its only citation (myCarbon page never mentions RF) | RF support lives only on other rows | add an RF-stating source (verify live) |
| R2-14 | m | escooter 6 not reproducible from its attached quote: "1.4 kWh/100 km" = 14 Wh/km x 386 = 5.4 -> 5 | the ~15 Wh/km midpoint needs the study's aluminium variant (1.576 kWh/100 km) | add second quote, state range in note |
| R2-15 | m | memoized cities cache stores a rejected future forever (regression vs per-call decode) | first-load failure rethrows until restart | clear cache on error |
| R2-16 | m | Unpinned guards: occupant clamp, air fallback, ferry gate mid-range, link reachability -- reverting each leaves the suite green | e.g. Osaka-Busan ~590 km is a natural just-over-gate pin | add 4 test pins |
| R2-17 | m | walkModeMaxKm has zero consumers; nothing forces the future UI to honor it | 195 km walk reappears if kindActive maps straight to walk | keep constant; UI-PR item recorded |
| R2-18 | m | Same-mass circuity lies: all 25 BH-QA pairs suggest ~185 km cycling (bridge never built; real road ~400 km via SA); HK-Macau cycling 85 km (banned on bridge) | circuity 1.3 cannot see missing/banned crossings | known-limitations doc line |
| R2-19 | m | Latent generator trap: MY has no island anchors -- a Borneo city entering top-5 on regen silently becomes Eurasia | fail-loudly catches unmapped ccs only | add MY Borneo anchors + comment |
| R2-20 | m | Research doc typos: "+154 to -156%" (stray minus); "within 1%" is actually 1.2% | -- | fix |
| R2-21 | m | jet note credits CE Delft for a quote cited to T&E (T&E page never names CE Delft) | CE Delft URL lives only in research sec 8.1 | add CE Delft citation to sources |
| R2-22 | m | shinkansen: JR Central 1/8-energy / 1/12-CO2 claim uncited in sources[]; Planet Forward does not name JR East | citation is free to add | add JR Central source, reword attribution |
| R2-23 | m | PDR sec 3 D1 recorded superseded values -- a future session executing from it would fix the data backwards | -- | supersession notes added |
| R2-24 | m | House grid factor 386 g/kWh sits below current global ~470-480; EV 73 would be ~86-90 at those | app-wide house rule, out of scope | methodology-sheet context note only |
| R2-25 | m | DESNZ says the 1.7 RF multiplier applies to the CO2 component only; jet derivation applies it to the full CO2e base (immaterial: CH4/N2O < 1% of aviation CO2e) | para 8.44 | one-line acknowledgment in research sec 8.1 |
| R2-26 | m | Greencalculus and SCIF quotes on car_petrol_avg are row/header reconstructions | -- | optional; later fixed in R3-9 |

Round 2 verified sound: all 27 factors match research sec 5
digit-for-digit; every derivation chain reproduces (jet 1,000 x
1.7, helicopter per-type table, BEV, e-bike, occupancy clamps);
all 13 invariants hold now AND under the flagged 2026 revisions;
refreshed mock arithmetic exact; carKm equivalency consistent;
haversine exact; DESNZ 1.7 quote verbatim at para 8.43; every
SustainMetrics row and the OpenCO2 domestic-with-RF citation
airtight.

---

## 6. Round 2 Decisions (owner-approved 2026-07-18)

- **R2-D1 Taxi ships per-vehicle at 208.06 g/km** (R2-6),
  per_vehicle true, max_occupants 4 (stepper counts passengers,
  default 1), group `taxi`. Basis, disclosed in the calc note:
  DESNZ 2025 constructs regular-taxi factors from medium/
  large-car type-approval CO2 uplifted 40% for the real-world
  taxi duty cycle (TfL data, para 5.39); the passenger-km variant
  148.61 = 208.06 / 1.4 assumed passengers (L.E.K. 2002) is NOT
  shipped; deadheading is explicitly EXCLUDED by DEFRA (para
  5.42, quoted), so the true door-to-door footprint is higher
  than shown. Science-sheet context cites post-2020 evidence
  (CARB base-year deadhead miles; UCS 2020 non-pooled ride-hail
  ~47% more polluting, ~239 g/km applied to our car figure --
  shipped 208.06 is conservative). No self-derived deadheading
  factor (PHEV precedent).
- **R2-D2 Per-link max_km** (R2-7/8/9): `CityLink` gains an
  optional `max_km` (default = global `ferryModeMaxKm` 500).
  Gibraltar link capped 200 -- **amended in execution to 150**:
  the sweep found three fictional pairs at 152-191 km (Port
  Said-Khan Yunis, Ibb/Taiz-Assab), so the ">= 207" premise was
  wrong and no cap keeps Sevilla-Tangier (180) while killing
  them; zero fiction took precedence and only Gibraltar-Tangier
  (58) survived (Sevilla-Tangier later revived by port
  anchoring). Ireland-France raised to 900 (revives
  Dublin/Cork->France); new Dar es Salaam-Zanzibar ferry link.
  Suez ground stays unmodeled -- documented as the continental
  convention. Port-anchored links recorded as the eventual fix
  (delivered in Fix Backlog 3).
- **R2-D3 Air-fallback floor at 100 km** (R2-10):
  `fallbackAirMinKm = 100`; linkless cross-water pairs below it
  return an empty map (UI: manual entry; local boat hops we do
  not model). San Juan-Charlotte Amalie (125 km) keeps its
  flight. NaN-coordinate guard returns an empty map.

---

## 7. Fix Backlog 2 (EXECUTED 2026-07-18)

1. **build_cities.py geography round 2** (R2-1/2/3/19):
   FO -> ISLANDS; ISLAND_ANCHORS gains TZ, KM (3 islands), PG
   (+Bougainville), CV (Santiago/Sao Vicente), FJ (Viti/Vanua
   Levu), BS (New Providence/Grand Bahama), TC, VI (St Thomas/
   St Croix), MY (peninsular/Borneo, latent R2-19). Anchors
   verified against actual GeoNames coordinates. LINKS: Gibraltar
   "max_km" 200 (amended 150); Ireland-France "max_km" 900; new
   Dar es Salaam-Zanzibar link. Regenerated; CITY_COUNT 982.
2. **CityLink model + journey_distance.dart** (R2-D2, R2-D3,
   R2-15): `CityLink.maxKm`; ferry iff straight <= (link.maxKm ??
   ferryModeMaxKm); `fallbackAirMinKm = 100`; `straight.isNaN`
   -> {}; cities_data.dart clears `_rootFuture` on load error.
3. **transport_modes.json** (R2-D1, R2-4/5/11/12/13/14/21/22):
   taxi -> 208.06 per-vehicle; helicopter deep link; private_jet
   real PJCC sentence; motorbike -> SustainMetrics row;
   shinkansen Japanese original + marked translation + JR
   Central source, "JR East" dropped from JSON; flight_longhaul
   RF-stating source; escooter aluminium-variant quote +
   14-15.8 Wh/km range note; private_jet CE Delft source.
   Dataset tests updated.
4. **Tests round 2** (R2-16 + geography pins): occupant guard;
   fallback pins (San Juan-Charlotte Amalie HAS air;
   Marigot-The Valley {}); Osaka-Busan no ferry;
   link-reachability test; Zanzibar-Dar ferry-only;
   London-Torshavn; Moroni-Moutsamoudou; Port Said-Gaza NO
   ferry; Dublin-Paris HAS ferry; Gibraltar-Tangier HAS ferry.
5. **Docs**: research doc taxi basis rewrite, typo fixes, RF
   component acknowledgment, sec 9 fallback/max_km/Suez/known
   limitations; PLAN_PHASE_8 mock totals (taxi 208.06, total
   122.2 kg, "Rail emits 112 kg less CO2e (92%)", 5 trees);
   estimation-rules air row >= 100 km condition.
6. **Verification** + Python pair sweep re-run: zero cross-water
   ground, zero ferry beyond caps, Africa-Eurasia survivors
   West-Med only, fallbacks >= 100 km.

---

## 8. Round 3 Findings Register (2026-07-19)

Method: the same four adversarial agents re-run against the
post-Backlog-2 working tree. Zero commit blockers; every Round
1/2 fix re-verified landed (all 27 factors digit-for-digit; all
13 invariants incl. 2026 revisions; haversine to 3.6e-11 km vs
an independent implementation; 481,671-pair sweep replica passed
all 16 Dart test pins; all 23 cited URLs live, zero dead).

| ID | Sev | Finding | Fix |
|----|-----|---------|-----|
| R3-1 | M | Mombasa-Zanzibar fictional ferry is that pair's ONLY suggestion (240 km, inside the Zanzibar link's default 500 cap) -- the R2-7 failure mode reintroduced by the R2-1 fix | Zanzibar link capped (later port-anchored) + regression pin |
| R3-2 | M | Same-mass enclosed-sea ground fiction far broader than the documented BH-QA/HK-MO line: Helsinki-Tallinn 107 km cycling; Kinshasa-Brazzaville 10 km walk over the unbridged Congo; Stockholm-Helsinki 514 vs ~1,750 real; Buenos Aires-Montevideo 263 vs ~600 | Fix Backlog 3 water blocklist |
| R3-3 | M | Cook Strait ferry unmodeled: NZ split left Wellington-Christchurch air-only | ferry link + pin |
| R3-4 | M | Research doc credited shinkansen 20 g to "JR East"; Planet Forward page never names a JR company | attribution removed |
| R3-5 | M | ferry_foot's sole citation (Climatiq) now shows a Deprecated/Replaced banner | re-cited to SustainMetrics sea page, live-verified |
| R3-6 | M* | Ireland-France link: 28/32 surviving pairs non-French (Dublin-Groningen 851 km foot-ferry); Dover-Calais reaches Koln, Busan-Fukuoka reaches Daegu. Owner promoted to blocking | ports (R3-D4) + disclosure (R3-D2); Dublin-Amsterdam pinned NO ferry |
| R3-7 | M* | Malta-Sicily link only ever yields Palermo-Malta, a corridor with no direct ferry (Catania absent). Owner promoted to blocking | link removed; pin |
| R3-8 | M* | St Croix-St Thomas (71 km, real ferry corridor) returned an empty map under the 100 km floor. Owner promoted to blocking | real ferry link + pin |
| R3-9 | m | Citations: SustainMetrics pipe-rows undisclosed; car_petrol_avg "/" delimiter; Greencalculus/SCIF reconstructions; car_bev stray colon (live-updating page); T&E mid-sentence caps; shorthaul missing "A"; Navitime joined lines without ellipsis; longhaul RF indirect; taxi CARB/TRUE uncited; research 8.1 heading "SHIP at 1,000"; laundry mock "saves" | all fixed with live re-fetches 2026-07-19; metadata citation_note added; DESNZ para 8.45 source added; CARB kept WITH citation (SB 1014 PDF verbatim), TRUE trimmed; Navitime halfwidth punctuation verified faithful (audit partly wrong); headings/copy corrected |
| R3-10 | m | Dart minors: NaN/Infinity bypasses legCo2eGrams' `< 0` guard; transport_modes.json decoded per call; latent kindActive across rail_tunnel links; air-fallback doc comment misstates over-cap-link case; ~60 near-duplicate metro "cities" | ACCEPTED, no fix (R3-D1) |
| R3-11 | m | Maths-doc minors: stale sec 6 preamble ("break some" -- all 13 survive); invariant 2's 2026 survival assumes tram takes only -26%; illustrative "Drive 81 kg" not derivable (83.9); inv 1 rail_international skip goes vacuous after 2026 | ACCEPTED, no fix (R3-D1) |

Round 3 execution (2026-07-19): links (build_cities.py +
hand-synced cities.json), 4 regression pins (Mombasa-Zanzibar,
Wellington-Christchurch, Charlotte Amalie-Saint Croix,
Birkirkara-Palermo), citation fixes with every changed quote
live-re-fetched, doc updates. Verified: analyze clean; transport
suite green; full suite 1,563/1,563; sweep re-run clean.

---

## Fix Backlog 3 -- Structural Robustness (EXECUTED)

Moved here 2026-08-29 from the main PDR's section 3, which now
carries a summary only. Subsection numbers are kept as they read
in the PDR.

Owner-approved 2026-07-19: stop whack-a-moling per-pair; make
the method robust to regeneration. "It's okay to lose
links/pairs if the method becomes more robust." All three parts
shipped; rounds 4-7 then extended 3.2 into the political and
honesty overlays recorded in the main PDR's section 2.1. Kept as
a record of how the current mechanism came to be, not as work to
do.

### 3.1 Port-anchored ferry links (R3-D4) -- DONE

`CityLink` gained six optional flat fields (json snake_case):
`port_a_lat/port_a_lon/radius_a_km` + b-side trio. Ferry
offered iff each city is within its side's radius AND
straight-line <= (`max_km` ?? 500). Portless links keep legacy
behavior; rail_tunnel links stay portless. Distance semantics
unchanged (whole straight line at ferry rate; ports gate
eligibility only).

Port table (radii are catchment decisions, verified against
dataset coordinates). `data/app/cities.json` is the authority
for these coordinates and radii; the table records them as they
were set, not as values to restore from:

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

### 3.2 Water-crossing blocklist (R3-D5) -- DONE

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

**Superseded in part by Backlogs 4-7 -- read the main PDR's
section 2.1 before acting on the paragraph above.** The
water-span test is no longer the blocking criterion on its own:
the land-path honesty test decides, it runs on dry chords too,
and MANUAL_ALLOW is now deliberately empty rather than a
calibrated allow list.

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

### 3.4 Outcome

Nothing remains open from this backlog. `water_blocked` is live
in `data/app/cities.json` (2,399 index pairs, all honored by the
gate on the 2026-08-29 run); the research doc carries the
blocklist and gate documentation in section 9 with the lakes gap
recorded under its known limitations; and section 1 of the main
PDR is re-measured.

---

## Completed Fix Ledger (all verified)

Moved here 2026-08-29 from the main PDR's section 5, which now
carries a summary only. This is the one-line index of the
registers above.

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
      **SUPERSEDED by decision E1 (2026-08-02): the house factor
      is 458, not 386. See the main PDR's section 2.**
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
- [-] R3-10 Dart minors (NaN guard, modes double-decode, latent
      tunnel-active, fallback comment, near-duplicate metro
      cities) -- ACCEPTED, no fix (R3-D1)
- [-] R3-11 maths-doc minors (stale sec 6 preamble, unflagged
      tram assumption, illustrative 81 kg, vacuous 2026 skip)
      -- ACCEPTED, no fix (R3-D1)

Rounds 4-7 -- **no findings register exists.** RESEARCH_TRANSPORT.md
Appendix A dates the seven rounds 2026-07-17..21; the individual
round-4-and-later artifacts carry dates of their own (owner rules
2026-07-20 and 2026-07-21, reviewed cc-pair list 2026-07-22), and
no other dating survives. Rounds 4 through 7 were never written
up round by round in any
file: there are no R4-x/R5-x/R6-x severity tables, kickoff
prompts or per-round dates to recover, and none should be
invented here. What survives is the rule set in
RESEARCH_TRANSPORT.md section 9 and Appendix A, mirrored in the
main PDR's section 2.1 and enforced by the constants in
`build_water_blocklist.py`. The identifiers that do appear in
those sources, and nothing beyond them:

- [x] R3-D5/R4 water-crossing blocklist shipped; the land-path
      honesty test replaced Round 3's per-pair curation, whose
      false-positive class ran to the hundreds (Jakarta-Surabaya,
      Bangkok-KL, Lagos-Accra)
- [x] R4-9 Lake Victoria dishonesty (Kampala-Mwanza, real ~650 km
      vs est 412, ~1.6x) -> recorded as the one material lakes
      gap; ne_50m_land carries no lakes, accepted for v1
- [x] R4-10 UI threads `loadWaterBlockedPairs()` into
      `suggestedDistancesKm` -> pinned by a non-vacuous test;
      binding on all future callers
- [x] R5 political overlays added: CLOSED_BORDERS (owner rule
      2026-07-20, no honest-detour exception), BORDER_WALLS,
      DISHONEST_CC_PAIRS; MANUAL_ALLOW reduced to an empty
      escape hatch
- [x] R5-11 crossing self-check added after three FIXED_CROSSINGS
      were found silently dead
- [x] R6 honesty test made unconditional (dry chords too), so
      walls and front lines block their corridors without
      hand-curated lists; CLOSED_BORDERS extended on the owner
      rule that active fighting closes a border and doubt
      resolves to blocked (extended 2026-07-21, all
      live-verified)
- [x] R6-1 Gaza Strip cities removed from the dataset outright
      (owner ruling 2026-07-21): all crossings sealed, no honest
      suggestion of any kind exists
- [x] R7 political screen wired into the gate:
      `data/reference/reviewed_cc_ground_pairs.json` (reviewed
      2026-07-22) plus the `--update-reviewed` refresh flow; an
      unscreened grounded cross-country corridor now fails the
      sweep
- [x] E1 (2026-08-02) house grid factor 386 -> 458 g CO2e/kWh,
      rebasing car_bev to 86 and escooter_private to 7 (see the
      supersession warning in the main PDR's section 2)

Verified sound across rounds (for the record): all 27 factors
reproduce digit-for-digit from independent recomputation; all 13
invariants hold now and under flagged 2026 revisions; haversine
matches an independent implementation to 3.6e-11 km; occupancy
clamping exact; mock arithmetic exact; DESNZ paras 5.39/5.42/
8.43/8.44/8.45 verbatim; all cited URLs live.

---

## Review History (rounds 1-3) and measured baselines

Moved here 2026-08-29 from the main PDR's Appendix A. The main
PDR keeps only the rounds 4-7 block, which is a live warning
against reconstructing a register that was never written.

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
  Current state is in the main PDR's section 1; run the sweep
  gate for current numbers.
- **Measured 2026-08-29** (moved from the main PDR's section 1;
  re-run the gate for current numbers rather than reading them
  here): full suite 1,742 tests green, of which the 156
  transport tests; sweep gate PASS over 468,996 pairs --
  suggestion kinds 466,951 air / 29,476 ground / 1,136 active /
  21 ferry; all 2,399 water_blocked pairs honored; 1,624
  grounded cross-country pairs, all reviewed, zero new and zero
  stale; smallest air fallback 100.5 km; and all nine ferry
  links still produce ferry pairs (Dover-Calais 1, Irish Sea 6,
  Ireland-France 4, Busan-Fukuoka 4, Gibraltar 2,
  Messina/Naples-Palermo 1, Zanzibar 1, Cook Strait 1,
  St Thomas-St Croix 1), so no link is dead.

---

## 9. Research-Pass Closures (from RESEARCH_TRANSPORT.md sec 7)

Moved 2026-08-08 so the research doc tracks only what is still
open. Everything here is closed; the resulting factors, decisions
and rules are in RESEARCH_TRANSPORT.md sections 3-9 and Appendix A.

Resolved 2026-07-17 (initial pass): four research tracks merged (3.1-3.3, 4);
greencalculus vintage mixing confirmed and superseded by
per-track verification; aviation figures confirmed with-RF;
Shinkansen basis settled (20 g/pkm, per passenger-km; JR Central
1/12-vs-plane ratio as the quotable fact); e-scooter scope
settled (electricity-only + lifecycle caveat in methodology).

Also resolved 2026-07-17: high-impact modes researched and decided
(section 8: private jet -- 1,000 base, shipped at 1,700 with-RF
per decision D2 -- and helicopter 450 ship as a "high-impact"
group; yacht rejected as a mode, kept as an eco-fact candidate).

Resolved 2026-07-18: RF multiplier verified at 1.7 on the DESNZ
2025 methodology paper (sec 4); private jet gains the same uplift
(1,700, decision D2, sec 8.1); ferry_car shipped with the
one-leg-covers-both calc note (decision D3); JSON build step done
(`data/app/transport_modes.json`, 27 modes).



Moved 2026-08-29 (second pass), same reason: the research doc
tracks only what is still open. Every item below is closed. The
live rules they produced live on elsewhere -- grid factor E1 and
port anchoring in the main PDR's section 2, the city-name
sourcing rules in the header of
`scripts/generators/enrich_city_names.py` and its pins in
`test/features/transport/`, so nothing here is load-bearing.

- [x] Re-verify exact MLIT FY2023/FY2024 chart values --
      CLOSED 2026-08-29. Values and their publication form are
      in section 1 (Japan context): chart image only, no table
      and no dataset, so the re-verification was done by
      reading the PNGs. The pass turned up a live discrepancy
      in what ships, so the finding is recorded in full here.

      **1. What MLIT says.** Rail is **17** g-CO2/passenger-km
      in both 年度2023 and 年度2024. It was 20 in 年度2022 and
      25 in 年度2021 (COVID load factors). So MLIT's own
      FY2023 rail number is 17, not 20.

      **2. The shipped claim does not hold as written.**
      `rail_shinkansen` ships 20 g/km and its
      `calculation_notes` say "Primary figure is the FY2023
      value via Planet Forward" on a "Japan rail average"
      basis. Traced live 2026-08-29: Planet Forward
      (https://planetforward.org/story/japans-trains-climate/,
      essay by Emma Ward, Kent State University, published
      2026-02-24) says "data from the 2023 fiscal year show
      that rail travel emits just 20 grams of CO2 per
      passenger-kilometer, which is equal to about 16% of the
      emissions produced by privately owned cars, roughly 20%
      of those from aviation, and about 28% of bus emissions",
      and hyperlinks that sentence to JR East's integrated
      report. Those three ratios pin the comparator set, and
      the arithmetic is the whole proof, so it is written out
      here once: against the 年度2022 set 128/101/71 they come
      out 15.6, 19.8 and 28.2, which is what the article
      rounds to 16, 20 and 28; against the 年度2023 set
      127/94/63 they would come out 16, 21 and 32, which is
      not what the article says. Independently confirmed by
      the owner before approval. That set 128/101/71/20 is the
      JR East chart headed "CO2 Emissions per Transportation
      Volume (Passenger Transportation) (Fiscal 2023)" in JR
      East Group INTEGRATED REPORT 2024 (printed page 80),
      credited "Source: Adapted from the website of the
      Ministry of Land, Infrastructure, Transport and
      Tourism" -- and it is MLIT's 年度2022 chart, digit for
      digit. JR East is not misquoting: it uses the English
      year-ending convention, so its "Fiscal 2023" is the year
      ended March 2023, i.e. 年度2022. Planet Forward read
      that label as a Japanese 年度 and our notes inherited
      the slip. Net: the shipped 20 is MLIT's 年度2022
      national rail average, two vintages stale, described to
      users as an FY2023 figure. Both fields reach the user
      (`transport_science_sheet.dart` writes
      `calculationNotes` then iterates `sources`;
      `transport_methodology_screen.dart` iterates
      `mode.sources`), so the wording is user-facing.

      **3. The re-source that keeps the number.**
      The same page of the same report, under the heading
      "Calculation and Disclosure of CO2 emissions by
      Shinkansen Segments", states: "Based on fiscal
      2024 results, we calculated segment-by-segment CO2
      emissions per customer associated with travel on
      Shinkansen lines. In addition, CO2 emissions per
      transportation volume were 12g-CO2/person-km for JR East
      as a whole, and 20g-CO2/person-km for Shinkansen
      segments." JR East "fiscal 2024" = year ended March 2024
      = 年度2023. That is a Shinkansen-specific,
      operator-published 年度2023 figure of exactly 20 -- a
      better fit for a mode called `rail_shinkansen` than any
      all-rail national average.

      The year mapping is not inference: the report's own
      reporting-period statement (printed page 4) says "This
      report principally covers our activities for fiscal
      2024, from April 1, 2023 to March 31, 2024".

      **Outcome: option A applied 2026-08-29** (owner
      approved). `rail_shinkansen` keeps 20 g/km; Planet
      Forward is replaced by the JR East disclosure; the
      `calculation_notes` no longer claim a Japan rail average
      basis or an FY2023 vintage via Planet Forward, and now
      state the Shinkansen-specific basis and 年度2023. No
      factor change, so no collision with the standing
      decision in
      [PDR_TRANSPORT_CALCULATOR.md](./PDR_TRANSPORT_CALCULATOR.md)
      section 2. The two rejected alternatives, for the
      record: keeping Planet Forward and correcting only the
      vintage wording would ship a knowingly stale 年度2022
      national average on a Shinkansen mode; dropping the
      factor to 17 would match MLIT 年度2023 and 年度2024 but
      substitute an all-rail average that includes commuter
      and local lines for the operator's own Shinkansen
      figure, making the number less right for this mode, not
      more.

      **Verification caveat, carried into the dataset.**
      jreast.co.jp returns HTTP 403 to every automated request
      from this session, including its own landing page and
      re-confirmed at the time of the edit, so both JR East
      quotes were read from the Internet Archive capture of
      https://www.jreast.co.jp/e/environment/pdf_2024/all.pdf
      taken 2025-08-03. The shipped `sources[].url` is that
      archive URL rather than the bare jreast.co.jp one,
      because only the archive URL actually resolves for a
      reader today; the source NAME stays "JR East". The
      Shinkansen figures sit on printed page 80 and the
      reporting-period statement on printed page 4 (PDF pages
      41 and 3 of the capture). A live re-read is owed when
      the host becomes reachable; nothing else about the entry
      depends on it.

- [x] Yacht eco-fact -- DRAFTED 2026-08-29, parked in sec 8.3
      awaiting a calendar slot. Re-sourced to the peer-reviewed
      Barros & Wilk paper (the figure is 7,018 t CO2e, not the
      7,020 t CO2 this doc long carried) and pre-audited against
      [AUDIT_FACT_DATA.md](./AUDIT_FACT_DATA.md). Shipping it
      means displacing one of the 366 days, which is an owner
      call

- [x] **House grid factor** -- RESOLVED 2026-08-02 (decision E1):
  raised 386 -> 458 g CO2e/kWh (Ember GER 2026). car_bev 73 -> 86,
  escooter_private 6 -> 7, ebike holds at 2. Regional factors are
  now their own brief:
  [PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md).

- [x] Port-anchored ferry links -- DONE (Fix Backlog 3, R3-D4);
      Malta-Sicily can return with ports at Valletta/Pozzallo
      once Catania is force-included

- [x] JA/ES localization of city names -- DONE: `name_ja` on 925
      of 969 cities, `name_es` on 275, sourced by
      `scripts/generators/enrich_city_names.py` from GeoNames
      alternate names (CC BY 4.0) and, for JA only, Wikidata
      labels (CC0). JA splits 785 GeoNames + 107 Wikidata joined
      on P1566 (GeoNames ID) + 33 Wikidata matched on the item's
      primary English label. Matching on an alternate label was
      tried and dropped: it is how Cape Bojador answers to
      "Boujdour", and no coordinate check catches that. A name
      match ships only when the item's P625 coordinate falls
      inside a population-scaled band -- 25 km at 400k and above,
      10 km below it, because a same-named settlement 20 km from
      a small town is plausibly a different place. In the small
      band a P17 country claim that disagrees with the city's
      country code rejects the match only past 5 km: cities.json
      codes dependent territories by their own ISO code while P17
      names the sovereign state, so a closer mismatch is that
      modelling gap rather than a wrong entity. Nothing is
      transliterated, so the rest fall back to English: 44 have
      no JA entry in either source; of the 694 without `name_es`,
      486 are cities GeoNames spells identically in ES and 208
      have no ES entry. Search folds accents and matches all
      three names

- [x] Rail-specific circuity factor -- CLOSED 2026-08-29,
      FOUND. Two citable sources; neither is wired into code
      (that is a separate change), and the recommendation is
      still not to swap the shipped 1.3. Sources:

      1. Heinold, A. and Makowski, C. (2026), "Driving the
         Extra Mile: Comprehensive Analysis of Road and Rail
         Transportation Distances in Europe", *Networks and
         Spatial Economics* 26(2):633-662, published online
         2026-02-19, open access CC BY 4.0.
         https://doi.org/10.1007/s11067-026-09729-y
         (accessed 2026-08-29). Defines circuity exactly as we
         use it, "Circuity = Transportation Distance /
         Great-Circle Distance", great circle by Haversine.
         > "Circuity between countries ranges from 1.15 to
         > 1.76 (median 1.25) for road transportation and 1.13
         > to 2.07 (median 1.42) for rail transportation."
         > "Across all country connections, the median
         > circuity is 1.25 for road and 1.42 for rail.
         > Similarly, across all regions, the median circuity
         > is 1.23 for road and 1.38 for rail."
         > "While circuity decreases for longer road
         > distances, no such relationship is found for rail."
         Method: OpenStreetMap network (Geofabrik 2024),
         shortest path via SCGraph, 200 random point pairs per
         NUTS pair, outlier bounds from 1.5x the interquartile
         range and themselves clipped to [1, 3]. Per-country-
         pair means and standard deviations are in the paper's
         electronic appendix. Scope limits that matter to us:
         continental Europe only, and train type is explicitly
         out of scope --
         > "Otherwise, we would require specific knowledge
         > about the vehicle or train type, e.g., passenger vs.
         > freight trains or electric vs. diesel locomotives,
         > which is beyond the scope of this paper."
         So 1.42 is network topology, not a passenger-service
         route factor. The paper also restates Ballou et al.
         2002 (already cited above): "For Europe, the study
         reports an average circuity factor of 1.46, which
         lies between the lowest (1.12 for Belarus) and
         highest (2.1 for Egypt) value within the data set."
         That is road, and it is the same reason our
         US-derived 1.3 reads as a floor rather than a world
         average.
      2. UIC / ifeu EcoPassenger, "Environmental Methodology
         and Data Update 2016" (Knoerr, ifeu Heidelberg;
         Huettermann, HaCon Hannover; dated 2016-11-17).
         https://uic.hafas.cloud/hafas-res/download/Ecopassenger_Methodology_Data.pdf
         (accessed 2026-08-29). The rail industry's own
         passenger calculator:
         > "The length of the train routes is determined by
         > the polygon defined by all in-between stops of a
         > train. The length of the train route between two
         > connected stations is calculated by the line of
         > sight distance which is extended by 20%-30%
         > depending on cases."
         That is 1.20-1.30, but applied stop to stop along the
         timetable polygon, not endpoint to endpoint, so the
         effective origin-to-destination circuity under that
         method is higher than 1.2-1.3: the polygon has
         already deviated. Same report's car table is a
         distance-banded factor (1.35 up to 100 km, 1.25 to
         500, 1.15 to 1000, 1.1 beyond), a useful sanity check
         on our flat 1.3.

      **Recommendation: record, do not adopt.** The two
      sources bracket rather than settle it. EcoPassenger's
      leg-level rail factor is essentially our 1.3; Heinold's
      endpoint-to-endpoint rail median of 1.42 is the closer
      construct to what we compute, and would raise rail
      estimates about 9%. Three things make that a bigger
      change than one constant: (a) 1.42 is continental Europe
      only, and rail suggestions here are mostly domestic and
      heavily JP, where a dense purpose-built network is not
      the Baltic-detour case that lifts the European median;
      (b) there is no rail bucket to put it in --
      `suggestedDistancesKm` computes one `kindGround` value
      for car, bus and rail, so adopting it means splitting
      the bucket; (c) `GROUND_CIRCUITY` is shared with
      `build_water_blocklist.py`, where `PATH_LIMIT_FACTOR =
      HONESTY_MAX * GROUND_CIRCUITY / ROAD_OVER_GEODESIC`
      calibrates every open/blocked verdict, so a rail-only
      change would show rail distances the honesty bar never
      tested. Adopt only as part of a scoped change that does
      all three. Known direction of the current bias, now
      citable: rail estimates run short for European-style
      networks. Revisit if a future edition of the Heinold
      dataset covers Japan or splits passenger rail, or if
      DEFRA/DESNZ ever adds a rail distance uplift.

      Checked and negative, so the next person can skip them:
      DESNZ 2026 GHG conversion factors methodology paper
      (152 pp,
      https://assets.publishing.service.gov.uk/media/6a2940543b15d05a7ce3202e/2026-GHG-conversion-factors-methodology-report.pdf,
      accessed 2026-08-29) -- zero occurrences of "circuity"
      or "detour"; its only distance uplift is aviation's,
      > "An 8% uplift factor is used in the UK Greenhouse Gas
      > Inventory to scale up Great Circle distances (GCD) for
      > flights between airports"
      with nothing equivalent for rail or road. EcoTransIT
      World Methodology Report v4 (ISO 14083, 2025,
      https://www.ecotransit.org/wp-content/uploads/EcoTransIT_World_Methodology_Report_Version_4_ISO14083.pdf,
      accessed 2026-08-29) -- routes rail on its own network
      graph rather than uplifting a great circle, and its
      user-set Distance Adjustment Factor is "disabled by
      default" with the only built-in default (15%) applying
      to ocean shipments. Wikibooks Transportation Geography
      and Network Science / Circuity -- defines the term
      ("Circuity is the ratio of network to Euclidean
      distance"), carries no rail values. DG MOVE "EU
      transport in figures" Statistical Pocketbook 2025 -- its
      published sections are tonne-km and passenger-km
      performance, infrastructure, means of transport, safety,
      and energy/environment; nothing distance-ratio, so it
      was not opened section by section.

- [x] UI threads `loadWaterBlockedPairs()` into
      `suggestedDistancesKm` -- DONE, pinned by a non-vacuous test
      (R4-10); binding on all future callers

- [x] Per-mode `maxSuggestKm` -- CLOSED: satisfied by the
      kind-to-group mapping (micro/taxi/high-impact are never
      suggested; the distance caps gate the rest)

- [x] Leg-length -> flight-band mapping -- DONE: the comparison
      view auto-picks the honest band from leg distance
      (Appendix A.4)
