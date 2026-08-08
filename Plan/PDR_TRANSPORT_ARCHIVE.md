# PDR Transport Calculator -- Archive (pre-restructure detail)

**Archived:** 2026-07-19. Verbatim long-form content moved out
of [PDR_TRANSPORT_CALCULATOR.md](./PDR_TRANSPORT_CALCULATOR.md)
when it was restructured. Everything here is EXECUTED and
re-verified; nothing below is a live instruction. Live rules,
the active backlog, and the fix ledger are in the main PDR.

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

## 9. Original Round Kickoff Prompts (historical)

Round 1 (executed 2026-07-18):

> Read Plan/PDR_TRANSPORT_CALCULATOR.md and CLAUDE.md, then
> execute the PDR's Fix Backlog (section 4) top to bottom on the
> `development` branch. The uncommitted transport-calculator work
> it refers to is already in the working tree. Honor the owner
> decisions in section 3 exactly. Python runs need `conda
> activate seed`; regenerating cities.json needs the GeoNames/ISO
> inputs re-downloaded per the header of
> scripts/generators/build_cities.py (ask before downloading).
> Verify per section 5. Do not commit. Finish with a summary.

Round 2 (executed 2026-07-18):

> Read Plan/PDR_TRANSPORT_CALCULATOR.md and CLAUDE.md, then
> execute Fix Backlog 2 (section 9) top to bottom on the
> `development` branch. Round 1 (section 4) is done -- do not
> redo it. Honor the decisions in sections 3 and 8 exactly,
> including the supersession notes on D1 and D3. Re-verify every
> new or changed source quote live before pasting. Verify per
> section 10. Do not commit. Finish with a summary.

---

## 10. Research-Pass Closures (from RESEARCH_TRANSPORT.md sec 7)

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

