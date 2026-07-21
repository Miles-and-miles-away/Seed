# Phase 8: Carbon Calculators (Transport, Food & Home Energy)

**Version:** 1.2
**Created:** July 2026
**Status:** Planning

Part 1 (8.1-8.6) is the transport calculator; Part 2 (8.7-8.12) is
its food sibling; Part 3 (8.13-8.18) covers home energy behaviors.
All three reuse the same architecture. Together they cover the "big
three" of personal footprints: move, eat, power.

---

## Table of Contents

1. [Phase Overview](#phase-overview)
2. [Goals & Deliverables](#goals--deliverables)
3. [Feature Breakdown](#feature-breakdown)
4. [Transport Mode Dataset](#transport-mode-dataset)
5. [Journey Builder & Calculator Engine](#journey-builder--calculator-engine)
6. [Journey Comparison](#journey-comparison)
7. [Methodology & Sources UI](#methodology--sources-ui)
8. [Entry Points & Navigation](#entry-points--navigation)
9. [Logging Bridge (Deferred)](#logging-bridge-deferred)
10. [Data Models](#data-models)
11. [Implementation Order](#implementation-order)
12. [Testing Strategy](#testing-strategy)
13. [Acceptance Criteria](#acceptance-criteria)
14. [Open Questions](#open-questions)
15. [Part 2: Food Carbon Calculator](#part-2-food-carbon-calculator)
16. [Part 3: Home Energy Calculator](#part-3-home-energy-calculator)

---

## Phase Overview

Phase 8 adds a **transport carbon calculator**: users build a journey
from legs (mode + distance), see its CO2e footprint, and compare
alternative ways of making the same trip side by side (e.g., fly vs
take the shinkansen, drive alone vs carpool vs coach).

The insight this feature teaches -- mode choice dominates transport
emissions, and the best mode flips with distance and occupancy -- is
one of the highest-leverage facts in personal carbon literacy. Today
the action library only offers fixed-distance approximations
("Biked instead of driving (~6km)"). The calculator makes the real
numbers explorable.

Like Phase 6, this phase is **code + data only, no art bottleneck**,
and has no dependency on Phase 7 (mascot art/shop) or Phase 9
(premium). It can be scheduled before or in parallel with either.

### Design Principles

- **Evidence first.** Every emission factor carries sources in the
  same `{name, url, quote, accessed}` format as
  `data/seed/co2_actions_database.json`, drawn from the tier-1 list
  in [AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) section 8
  (DEFRA, Our World in Data, IEA, peer-reviewed papers). The
  methodology is shown in-app, not hidden.
- **Honest, not generous** (audit doc section 2). Occupancy
  assumptions, radiative forcing, and scope exclusions are stated
  plainly. Users who see the app acknowledge complexity trust it
  more.
- **No Fake Points** (Phase 5 principle). The calculator itself
  awards nothing. It is an educational tool. A bridge into action
  logging is deferred to 8.6 and gated on anti-gaming design.
- **Category comparisons, not route lookups.** No maps API, no
  routing, no live data. The user supplies distances; we supply
  per-km science. This keeps the feature offline-capable, free to
  run, and honest about precision.

---

## Goals & Deliverables

### Primary Deliverables

| Deliverable | Description |
|-------------|-------------|
| Transport mode dataset | `data/app/transport_modes.json`: ~27 modes, gCO2e/km factors, EN/JA/ES names, full source citations |
| Calculator engine | Pure Dart: legs -> per-leg and total CO2e, occupancy handling |
| Journey builder UI | Add/edit/remove legs (mode, distance, car occupancy) |
| Comparison UI | 2-3 journey options side by side with delta and equivalencies |
| Methodology sheet | In-app explanation of scope, sources, and assumptions |
| Localization | Full EN/JA/ES strings |

---

## Feature Breakdown

### Summary Table

| Feature | Priority | Complexity | Status |
|---------|----------|------------|--------|
| 8.1 Transport mode dataset | P0 | Medium (research-heavy) | Planned |
| 8.2 Journey builder + engine | P0 | Medium | Planned |
| 8.3 Journey comparison | P0 | Medium | Planned |
| 8.4 Methodology & sources UI | P0 | Low | Planned |
| 8.5 Entry points & analytics | P1 | Low | Planned |
| 8.6 Logging bridge | P2 | Medium | Deferred |
| 8.7 Food item dataset (Part 2) | P0 | Medium (research-heavy) | Planned |
| 8.8 Meal builder + engine (Part 2) | P0 | Medium | Planned |
| 8.9 Meal comparison (Part 2) | P0 | Medium | Planned |
| 8.10 Food methodology & sources UI (Part 2) | P0 | Low | Planned |
| 8.11 Food entry points & analytics (Part 2) | P1 | Low | Planned |
| 8.12 Food logging bridge (Part 2) | P2 | Medium | Deferred |
| 8.13 Energy behavior dataset (Part 3) | P0 | Medium (research-heavy) | Planned |
| 8.14 Routine builder + engine (Part 3) | P0 | Low-Medium | Planned |
| 8.15 Routine comparison (Part 3) | P0 | Low | Planned |
| 8.16 Energy methodology & sources UI (Part 3) | P0 | Low | Planned |
| 8.17 Energy entry points & analytics (Part 3) | P1 | Low | Planned |
| 8.18 Energy logging bridge (Part 3) | P2 | Medium | Deferred |

---

## Transport Mode Dataset

### 8.1 `data/app/transport_modes.json`

**Priority:** P0 | **Complexity:** Medium (research-heavy)

Bundled static JSON, same pattern as `eco_facts.json` /
`challenge_templates.json` (declared in `pubspec.yaml`, loaded via
rootBundle, localized inline). No Firestore collection -- this is
read-only reference data shipped with the app.

#### Mode list (initial)

Grouped for the picker UI. Factors below are **illustrative
magnitudes only** -- the research task fixes exact values against
current DEFRA / Our World in Data releases before anything ships.

| Group | Mode | Basis | Illustrative gCO2e |
|-------|------|-------|--------------------|
| Active | Walking | per passenger-km | 0 |
| Active | Cycling | per passenger-km | 16 (metabolic) |
| Active | E-bike | per passenger-km | ~5 |
| Micro | E-scooter | per passenger-km | ~25 |
| Car | Small petrol car | per **vehicle**-km | ~140 |
| Car | Medium petrol car | per **vehicle**-km | ~165 |
| Car | Large petrol car / SUV | per **vehicle**-km | ~210 |
| Car | Diesel car (average) | per **vehicle**-km | ~170 |
| Car | Hybrid car | per **vehicle**-km | ~110 |
| Car | Electric car | per **vehicle**-km | ~66 |
| Car | Motorbike (average) | per vehicle-km | ~114 |
| Bus | City bus | per passenger-km | ~100 |
| Bus | Coach (long distance) | per passenger-km | ~27 |
| Rail | Local / national rail | per passenger-km | ~35 |
| Rail | High-speed rail (shinkansen) | per passenger-km | ~20 |
| Rail | Metro / underground | per passenger-km | ~28 |
| Rail | Tram / light rail | per passenger-km | ~29 |
| Air | Domestic flight | per passenger-km | ~246 |
| Air | Short-haul international | per passenger-km | ~180 |
| Air | Long-haul international | per passenger-km | ~150 |
| Water | Ferry (foot passenger) | per passenger-km | ~19 |
| High-impact | Private jet | per passenger-km | ~1,000 |
| High-impact | Helicopter | per passenger-km | ~450 |

The High-impact group exists for comparison education (it makes
every other bar legible); yacht was evaluated and rejected as a
journey mode (no defensible per-passenger-km basis -- see the
research doc), earmarked as an eco-fact instead.

Notes locked in now (they shape the schema):

- **Cars are stored per vehicle-km** and divided by an occupancy
  selector (1-4 people). This answers "large car, percentage full"
  more concretely than a percentage: occupants are what users know.
  Electric car uses the house grid factor (386 g/kWh, audit doc
  section 2) times a cited kWh/km figure, with the deviation from
  DEFRA's UK-grid EV factor documented.
- **Public transport factors are per passenger-km at average
  occupancy** (that is what DEFRA publishes). The methodology sheet
  states this asymmetry: an extra passenger on a scheduled bus is
  near-marginal-zero, but the average is the honest planning number.
- **Aviation factors include radiative forcing.** DEFRA publishes
  with-RF factors; cite Lee et al. 2021 (Atmospheric Environment)
  for the science behind the ~1.7x non-CO2 multiplier. Long-haul
  per-km is *lower* than domestic (cruise efficiency), which is
  exactly the counterintuitive fact the comparison view surfaces --
  total flight impact still dwarfs rail because of distance.
- **Active modes ship electricity-only (owner decision
  2026-07-18):** walking and cycling are 0; metabolic food energy
  is excluded by convention for all human-powered modes and
  documented in the methodology sheet with OWID's additionality
  caveat. The 16 g/km figure stays inside `bike_instead_of_car`'s
  savings delta -- different role, deliberately not synced.
- **Shinkansen needs a non-DEFRA source** (JR Central environmental
  report and/or IEA rail study; Eurostar's ~6 g/km is
  French-nuclear-specific and must not be presented as generic
  high-speed rail).
- **Scope:** direct (tank-to-wheel) operational energy emissions,
  consistent with DEFRA conversion-factor conventions; well-to-tank
  uplifts are a separate DEFRA factor set and must never be mixed
  in. Vehicle manufacturing and infrastructure are excluded and the
  methodology sheet says so (with a note that this understates EV
  vs petrol manufacturing differences).

#### Schema

```json
{
  "metadata": {
    "version": 1,
    "scope": "operational energy only; excludes vehicle manufacture",
    "primary_source": "UK DEFRA GHG Conversion Factors",
    "grid_factor_g_per_kwh": 386
  },
  "modes": [
    {
      "id": "car_petrol_medium",
      "group": "car",
      "name_en": "Medium petrol car",
      "name_ja": "...",
      "name_es": "...",
      "g_co2e_per_km": 165,
      "per_vehicle": true,
      "max_occupants": 4,
      "calculation_notes": "DEFRA 2024 average petrol car ...",
      "sources": [
        {
          "name": "UK DEFRA 2024",
          "url": "https://www.gov.uk/...",
          "quote": "...",
          "accessed": "2026-07-17"
        }
      ]
    }
  ]
}
```

`per_vehicle: false` modes omit `max_occupants` and are computed
per passenger directly.

#### Research process

Follow [RESEARCH_STRATEGY.md](./RESEARCH_STRATEGY.md) and the
sourcing rules in [AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md)
(sections 2 and 8): tier-1 sources, direct quotes, access dates,
conservative rounding, every factor's arithmetic reproducible from
its `calculation_notes`. Add a `TRANSPORT_LOGIC_CHECK` section to
the research notes mirroring the action audit.

**Research complete (2026-07-17):** verified factors, sources,
quotes, chosen dataset values, and sanity invariants live in
[RESEARCH_TRANSPORT.md](./RESEARCH_TRANSPORT.md). That document
is the source of truth for the JSON build step; the table above
remains illustrative.

---

## Journey Builder & Calculator Engine

### 8.2 Multi-leg journeys

**Priority:** P0 | **Complexity:** Medium

New feature module `lib/features/transport/` (standard
data/domain/presentation layout, barrel file).

The engine is pure Dart, fully unit-testable, no Firebase:

```
legCo2e(leg) = mode.perVehicle
    ? mode.gPerKm * leg.km / leg.occupants
    : mode.gPerKm * leg.km
journeyCo2e = sum(legCo2e for legs)
```

#### UI

```
+------------------------------------------+
|  Journey A                        [name] |
|  +--------------------------------------+
|  | 1. Taxi                       20 km  |
|  | 2. Domestic flight           515 km  |
|  | [+ Add leg]                          |
|  +--------------------------------------+
|  Total: 122.2 kg CO2e                    |
+------------------------------------------+
```

- Leg editor: mode picker (grouped list with icons), distance field
  (km, numeric), occupancy stepper shown only for `per_vehicle`
  modes (default 1).
- Distance entry is km-only in v1. A miles toggle for UK/US users
  is a fast follow (single formatting concern, P2).
- Totals use the existing CO2 formatting helpers
  (`lib/core/utils/`) so g/kg/t rendering matches the rest of the
  app.
- Nothing is persisted in v1; journeys are ephemeral screen state.
  Saved journeys (Firestore subcollection) are P2 -- see Open
  Questions.

#### City distance prefill (implemented alongside 8.2)

Users rarely know km distances, so the leg editor offers an
optional city-pair picker that prefills an editable estimate. No
maps API and no pairs matrix -- `data/app/cities.json` ships ~982
cities (GeoNames top-5 per country, top-15 for JP; name, country,
lat/lon, landmass tag) plus a curated list of fixed crossings
(Channel Tunnel, Busan-Fukuoka ferry, Gibraltar ferries, etc.).
Distance is haversine computed at runtime, O(N) data instead of
O(N^2) pairs. Generator: `scripts/generators/build_cities.py`
(documents input URLs; inputs not committed).

Estimation and availability rules
(`lib/features/transport/domain/services/journey_distance.dart`,
all constants citable, every prefill user-editable):

| Kind | Offered when | Estimate |
|------|--------------|----------|
| ground (car/bus/rail) | same landmass or rail_tunnel link, straight-line <= 2,000 km | haversine x 1.3 circuity |
| air | straight-line >= 250 km, or >= 100 km when no other kind is available (below 100 km: no suggestions, manual entry) | haversine + 95 km (EN 16258) |
| ferry | ferry link between masses, straight-line <= the link's max_km (default 500) | haversine |
| active | ground rules and <= 150 km (cycle family); walking only <= 40 km, applied when mapping the kind to modes | haversine x 1.3 |

The 2,000 km ground cap is a product rule ("a plausible long
drive or one rail/coach journey"); beyond it or across unlinked
water the comparison degrades gracefully to air-only (airline vs
private jet). City names ship EN-only in v1 (JA/ES localization
of ~982 proper nouns is an open item).

---

## Journey Comparison

### 8.3 Side-by-side options

**Priority:** P0 | **Complexity:** Medium

A comparison holds 2-3 journey options ("Fly" vs "Shinkansen" vs
"Drive"), each a full multi-leg journey from 8.2, so door-to-door
comparisons are honest (the flight option includes its airport
legs).

```
+------------------------------------------+
|  Tokyo -> Osaka                           |
|                                          |
|  Fly        ############------  122 kg   |
|  Drive (1p) ##########--------   81 kg   |
|  Rail       #-----------------   10 kg   |
|                                          |
|  Rail emits 112 kg less CO2e (92%)       |
|  = 5 trees growing for a year            |
+------------------------------------------+
```

- Horizontal bars scaled to the worst option; best option
  highlighted.
- Delta line compares best vs worst; equivalencies reuse the Phase
  6 impact-equivalency helpers (trees, phone charges, car-km) --
  no new equivalency code.
- **Copy rule (data review 2026-07-17):** deltas are hypothetical
  comparisons, so say "emits X kg less CO2e", never "saves" --
  nothing was saved. Never generate copy claiming walking beats
  cycling (scope-convention artifact) or coach-beats-rail
  superlatives (ordering flips in the 2026 DEFRA revision).
- **UI requirements from the data review (2026-07-17):**
  - Electric car rows/bars carry the sublabel "global-average
    grid; varies with your electricity" (the 73 g/km figure is
    grid-dependent, ~6-150 worldwide).
  - The private-jet bar carries a footnote that it includes the
    same high-altitude (radiative forcing) uplift as the airline
    bars (D2, resolved 2026-07-18 at 1,700 g/pkm).
  - Active modes show their basis ("0 direct emissions";
    e-bike/e-scooter "electricity only").
- Optional educational presets (P2): 2-3 bundled example
  comparisons ("500 km: plane vs train vs car") to demonstrate the
  distance crossover without the user entering anything.

---

## Methodology & Sources UI

### 8.4 Showing the science

**Priority:** P0 | **Complexity:** Low

The user-facing credibility layer -- this is why the dataset carries
quotes.

- **Per-mode detail:** tapping an info icon on any mode opens the
  existing science-bottom-sheet pattern
  (`ActionScienceBottomSheet` is the reference implementation):
  factor, basis (per vehicle / per passenger), calculation notes,
  and tappable source links.
- **Methodology page:** one static, localized screen linked from
  the calculator: scope (what is and is not counted), occupancy
  assumptions, radiative forcing, why category averages rather than
  real routes, and the full source list. Markdown-rendered like the
  privacy policy / terms screens.
- Every factor shown in UI is traceable to a source the user can
  open. No uncited numbers anywhere in the feature.

---

## Entry Points & Navigation

### 8.5 Routes, discovery, analytics

**Priority:** P1 | **Complexity:** Low

- New route (proposal): `/transport-calculator`, pushed full-screen
  like `/log-action`. Comparison and methodology are internal
  navigation within the feature.
- Entry points:
  1. Card on the Progress screen's Impact segment ("Compare
     transport options") -- the impact-curious user is already
     there.
  2. Banner row in the Action Log screen when the transport
     category tab is active.
- **Update [APP_PAGES.md](./APP_PAGES.md)** in the same PR as the
  route change (standing rule).
- Analytics: add `transport_comparison_run` (params: mode ids, leg
  counts, winning mode) and `transport_calculator_opened` to
  `AnalyticsService`.

---

## Logging Bridge (Deferred)

### 8.6 "I took the greener option" (P2, not in v1)

The obvious follow-up: after comparing, the user logs that they
chose rail over flying and banks the CO2e difference as a real
action. Deferred because it breaks two current invariants:

1. **Points are precomputed per library action** (audit doc section
   4); a variable-CO2 log needs a client-side points formula plus
   hardened Firestore rule caps (`pointsEarned <= 10000` exists,
   but a per-log `co2Saved` ceiling would also be needed).
2. **Self-reported large savings are the biggest gaming surface in
   the app** (a fabricated long-haul comparison is worth ~500 kg).
   Acceptable risk profile only while users are isolated (no
   leaderboards -- see scoring design decisions), but it deserves
   deliberate caps, e.g. max one transport-comparison log per day
   and a co2 ceiling per log.

Interim: the comparison result screen cross-links to the existing
fixed transport actions (`train_vs_flight`, `public_transport`,
`carpool`) so honest users still have a logging path today.

---

## Data Models

```dart
@freezed
abstract class TransportMode with _$TransportMode {
  const factory TransportMode({
    required String id,
    required String group,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required double gCo2ePerKm,
    required bool perVehicle,
    @Default(1) int maxOccupants,
    @Default('') String calculationNotes,
    @Default([]) List<EmissionSource> sources,
  }) = _TransportMode;
}

@freezed
abstract class EmissionSource with _$EmissionSource {
  const factory EmissionSource({
    required String name,
    required String url,
    @Default('') String quote,
    @Default('') String accessed,
  }) = _EmissionSource;
}

@freezed
abstract class JourneyLeg with _$JourneyLeg {
  const factory JourneyLeg({
    required String modeId,
    required double distanceKm,
    @Default(1) int occupants,
  }) = _JourneyLeg;
}
```

Journeys/comparisons are presentation-layer state (Riverpod
notifier holding `List<Journey>`); no Firestore models in v1.

---

## Implementation Order

1. **Dataset research** (8.1) -- factors + sources into
   `transport_modes.json`; the slow, careful step. Everything else
   can proceed against provisional values in parallel.
2. Models + codegen + JSON loader (mirror the eco-facts loader).
3. Calculator engine + unit tests (pure Dart, no UI).
4. Journey builder UI (8.2).
5. Comparison UI (8.3), reusing Phase 6 equivalencies.
6. Methodology sheet + per-mode science sheets (8.4).
7. Entry points, route, analytics events (8.5); update
   APP_PAGES.md.
8. Localization pass (EN/JA/ES) + `flutter gen-l10n`.

---

## Testing Strategy

| Area | Tests |
|------|-------|
| Dataset validation | Every mode has all three locales, a positive factor, at least one source with url+quote+accessed; `per_vehicle` implies `max_occupants >= 1`; ids unique |
| Engine | Per-passenger vs per-vehicle math, occupancy division, multi-leg sums, zero-distance legs, rounding at display boundaries (g -> kg -> t) |
| Sanity checks | Cross-mode invariants pinned as tests: coach < petrol car (solo); full car (4p) < domestic flight per km; long-haul per-km < domestic per-km |
| Widgets | Leg add/edit/remove, occupancy stepper only on car modes, comparison bar ordering and delta copy |
| Localization | Mode names and methodology strings resolve in EN/JA/ES |

The sanity-check tests double as regression protection when the
dataset is updated to a new DEFRA release.

---

## Acceptance Criteria

- [ ] ~20 modes shipped with fully cited factors (quote + URL +
      access date per source), passing dataset validation tests
- [ ] User can build a multi-leg journey and see total CO2e
- [ ] Car modes expose an occupancy selector that divides
      per-vehicle emissions
- [ ] User can compare 2-3 journey options side by side with delta
      and at least one equivalency
- [ ] Every factor is inspectable in-app down to its sources
- [ ] Methodology screen explains scope, occupancy, and radiative
      forcing in plain language, localized EN/JA/ES
- [ ] No points or CO2 credited anywhere in the feature (v1)
- [ ] APP_PAGES.md updated with the new route(s)
- [ ] `flutter analyze` clean; all new logic unit-tested

---

## Open Questions

| Question | Current lean |
|----------|--------------|
| Miles toggle for UK/US users? | P2 fast follow; km-only v1 |
| Region-specific factors (JP grid EV, Tokyo Metro)? | Single global dataset v1; regional overlays only if users ask |
| Saved journeys / favorites? | P2; needs a Firestore subcollection + rules, skip until demand |
| Cabin class multiplier for flights? | Fold into methodology text v1; selector later if wanted |
| Logging bridge (8.6) | Deferred until anti-gaming caps designed |

---

## Part 2: Food Carbon Calculator

Part 2 adds a **food carbon calculator**: users build a meal from
ingredients (food item + quantity), see its CO2e footprint, and
compare alternative meals side by side (beef burger vs chicken
burger vs bean burger).

Example: chicken 150 g + potatoes 200 g + 1 can of beer
= ~1.5 + ~0.1 + ~0.4 = **~2.0 kg CO2e**.

The insight this part teaches -- *what* you eat matters far more
than how far it travelled or how it is packaged, and the gap
between foods spans two orders of magnitude (beef is >100x
potatoes per kg) -- is the food-side twin of Part 1's "mode choice
dominates" lesson. Our World in Data's per-food charts (Poore & Nemecek 2018)
make it vivid; this part turns that chart into an explorable tool.

It deliberately reuses the Part 1 architecture wholesale: bundled
cited dataset, pure-Dart engine, builder UI, comparison UI,
methodology sheet. Where Part 1 says "leg (mode x distance /
occupancy)", Part 2 says "ingredient (food x grams)" -- and the
food engine is *simpler* (no occupancy, no per-vehicle split).
Part 2 depends on Part 1's shared widgets and models but not on
its dataset; it can start once 8.2-8.4 have landed.

### Design Principles (deltas from Part 1)

- **Evidence first.** Anchor dataset is Poore & Nemecek 2018
  (Science) as published by Our World in Data -- the largest
  food-LCA meta-analysis (~38,700 farms) and the source behind the
  OWID charts that motivated this feature.
- **Honest, not generous.** Factors are global means with huge
  producer-to-producer spread; the methodology sheet says so.
  "Organic" and "local" get an honest evidence-based treatment
  (see 8.10) rather than a feel-good discount.
- **No Fake Points.** Logging bridge deferred (8.12), same
  anti-gaming reasoning as 8.6.
- **Lookup, not barcode-scanning.** No product databases, no APIs,
  no photos. ~42 generic food categories with cited factors. Same
  trade as Part 1's "category comparisons, not route lookups".

### Part 2 Deliverables

| Deliverable | Description |
|-------------|-------------|
| Food item dataset | `data/app/food_items.json`: 42 items, kgCO2e/kg factors, serving presets, EN/JA/ES names, full source citations |
| Calculator engine | Pure Dart: ingredients -> per-ingredient and total CO2e |
| Meal builder UI | Add/edit/remove ingredients (item, quantity via grams or serving presets) |
| Comparison UI | 2-3 meals side by side with delta and equivalencies |
| Methodology sheet | Scope, sources, spread, organic/local honesty |
| Localization | Full EN/JA/ES strings |

### 8.7 Food Item Dataset: `data/app/food_items.json`

**Priority:** P0 | **Complexity:** Medium (research-heavy)

Bundled static JSON, same pattern as `transport_modes.json`
(declared in `pubspec.yaml`, loaded via rootBundle, localized
inline). Read-only reference data; no Firestore collection.

#### Item list (initial)

Grouped for the picker UI. Factors below are **illustrative
magnitudes only** (OWID / Poore & Nemecek order-of-magnitude
values) -- the research task fixes exact values, quotes, and access
dates before anything ships, exactly as RESEARCH_TRANSPORT.md did
for Part 1. Output goes to `Plan/RESEARCH_FOOD.md`.

**Research complete (2026-07-18):** verified factors, sources,
quotes, chosen dataset values (P&N means per decision D1),
serving presets, sanity invariants, and UI/copy requirements live
in [RESEARCH_FOOD.md](./RESEARCH_FOOD.md) (adversarially
reviewed 2026-07-18/19). That document
is the source of truth for the JSON build step; the table above
remains illustrative (and is the retired median set -- shipped
means are higher).

| Group | Item | Illustrative kgCO2e/kg |
|-------|------|------------------------|
| Meat | Beef (beef herd) | ~60 |
| Meat | Beef (dairy herd) | ~21 |
| Meat | Lamb | ~24 |
| Meat | Pork | ~7 |
| Meat | Chicken | ~6 |
| Seafood | Prawns (farmed) | ~12 |
| Seafood | Fish (farmed) | ~5 |
| Dairy & eggs | Cheese | ~21 |
| Dairy & eggs | Butter | ~9 |
| Dairy & eggs | Eggs | ~4.5 |
| Dairy & eggs | Milk (dairy) | ~3 /L |
| Plant protein | Tofu | ~3 |
| Plant protein | Beans / lentils | ~1 |
| Plant protein | Peas | ~1 |
| Plant protein | Nuts | ~0.4 |
| Staples | Rice | ~4 |
| Staples | Bread (wheat) | ~1.6 |
| Staples | Pasta | ~1.5 |
| Staples | Oats | ~1.6 |
| Staples | Potatoes | ~0.5 |
| Vegetables | Tomatoes | ~2 |
| Vegetables | Root vegetables | ~0.4 |
| Vegetables | Cabbage & broccoli | ~0.5 |
| Vegetables | Onions & leeks | ~0.5 |
| Fruit | Bananas | ~0.9 |
| Fruit | Apples | ~0.4 |
| Fruit | Citrus | ~0.4 |
| Fruit | Berries | ~1.5 |
| Drinks | Coffee (per cup, ~10 g grounds) | ~17 /kg dry |
| Drinks | Beer | ~1.2 /L |
| Drinks | Wine | ~1.4 /L |
| Drinks | Soy milk | ~1 /L |
| Drinks | Oat milk | ~0.9 /L |
| Treats | Dark chocolate | ~19 |
| Treats | Cane sugar | ~3 |
| Oils | Olive oil | ~6 |
| Oils | Palm oil | ~7.6 |

Beef (beef herd) plays the role Part 1's private jet plays: the
scale anchor that makes every other bar legible.

Notes locked in now (they shape the schema):

- **Everything is stored per kilogram.** Liquids are entered in ml
  and computed with density 1.0 (water-like drinks; the error is
  noise next to LCA spread). No separate per-liter code path.
- **Serving presets are the core UX addition over Part 1.** Users
  know "1 can", "1 egg", "1 chicken breast" -- not grams. Each
  item ships 1-3 presets (`{name, grams}`); a raw grams field
  remains for everything else. Distance in km was already a
  natural unit; grams of cheese is not.
- **Factors are cradle-to-retail lifecycle means** including
  land-use change, on-farm, feed, processing, transport, retail,
  and packaging (Poore & Nemecek system boundary). This is a
  *different scope* than the transport dataset (operational-only)
  -- deliberate, because each follows the authoritative convention
  of its domain. The methodology sheet states this plainly and
  warns against summing across the two calculators.
- **Weights are as-purchased (raw) weights.** Presets encode
  typical raw portions; the methodology notes cooked weight
  differs (rice ~2.2x). Home cooking energy is excluded, and the
  sheet says so.
- **Coffee needs care:** the headline per-kg figure (~28.5 under
  the chosen means) applies to dry grounds, so the preset
  ("1 cup, ~10 g grounds", SCA-based) is the only sane entry
  path. Same pattern for any item where per-kg invites a 100x
  user error.
- **Beef is split beef-herd vs dairy-herd** (~3x apart); picker
  defaults to beef herd with dairy herd one tap away. Collapsing
  them would hide the single most interesting fact in the dataset.
- **JA/ES coverage:** item names must be everyday grocery words,
  not LCA category names ("Brassicas" -> "Cabbage & broccoli").

#### Schema

```json
{
  "metadata": {
    "version": 1,
    "scope": "cradle-to-retail lifecycle incl. land-use change; excludes home cooking and waste",
    "primary_source": "Poore & Nemecek 2018 via Our World in Data",
    "basis": "kg CO2e per kg as-purchased; liquids assume 1 g/ml"
  },
  "items": [
    {
      "id": "chicken",
      "group": "meat",
      "name_en": "Chicken",
      "name_ja": "...",
      "name_es": "...",
      "kg_co2e_per_kg": 9.87,
      "servings": [
        { "id": "breast", "name_en": "1 breast", "name_ja": "...", "name_es": "...", "grams": 170 }
      ],
      "calculation_notes": "Global mean, Poore & Nemecek 2018 ...",
      "sources": [
        {
          "name": "Our World in Data",
          "url": "https://ourworldindata.org/environmental-impacts-of-food",
          "quote": "...",
          "accessed": "2026-XX-XX"
        }
      ]
    }
  ]
}
```

`servings` may be empty; the grams field always works. Source
objects reuse the existing `EmissionSource` model from Part 1
(promote it from `lib/features/transport/` to `lib/shared/` --
one-file move, both features import it).

#### Research process

Same rules as Part 1: [RESEARCH_STRATEGY.md](./RESEARCH_STRATEGY.md)
and [AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) sections 2 and
8. Tier-1 sources (OWID, Poore & Nemecek 2018, FAO), direct quotes,
access dates, arithmetic reproducible from `calculation_notes`.
Include a `FOOD_LOGIC_CHECK` section. One extra rule: record per
item which *statistic* (mean vs median) and whether supply-chain
losses are included, plus the OWID vintage used and why -- the
mean/median distinction, not the vintage, turned out to be the
real fork (food data-review finding, 2026-07-19).

**Consistency check with existing data:** `meatless_meal_beef`,
`meatless_meal_chicken`, `meatless_meal_pork`, and
`plant_milk_vs_dairy` in `co2_actions_database.json` already encode
per-meal deltas derived from these same per-kg factors. The
research step must verify the new dataset reproduces those deltas
(or flag the action data for correction) so the app never shows two
numbers for the same swap.

**Resolved gotchas (research + owner decisions, 2026-07-18):**

- Poore & Nemecek publish both MEANS and MEDIANS per food. The
  famous "beef = 60" chart -- and this section's illustrative
  table -- is the median set, retired from OWID in 2022. Owner
  decision D1: the dataset ships the **means** (live-quotable
  digit-for-digit from OWID; the Wayback-cited median set is the
  documented fallback if a mean becomes unavailable). Under
  means: beef (beef herd) 99.48, pork 12.31, chicken 9.87.
- The action data's chicken (6.9 kg/kg) and pork (7.6 kg/kg) came
  from a PMC study range and match neither statistic. Corrected
  under means with a standardized 200 g beans/lentils baseline
  (2026-07-20): `meatless_meal_beef` 9700 g,
  `meatless_meal_chicken` 780 g, `meatless_meal_pork` 1000 g --
  same PR as the dataset (never two numbers for one swap).
- Serving presets ship researched sourced weights (e.g. chicken
  breast 170 g raw, USDA), replacing the schema example's 120 g
  and the old mock's 150 g; presets encode raw as-purchased
  portions.

### 8.8 Meal Builder & Calculator Engine

**Priority:** P0 | **Complexity:** Medium

New feature module `lib/features/food/` (standard
data/domain/presentation layout, barrel file), mirroring
`lib/features/transport/` file-for-file where applicable.

The engine is pure Dart, fully unit-testable, no Firebase --
simpler than Part 1 (no occupancy branch):

```
ingredientCo2e(i) = item.kgCo2ePerKg * i.grams        // result in g
mealCo2e = sum(ingredientCo2e for ingredients)
```

#### UI

```
+------------------------------------------+
|  Meal A                           [name] |
|  +--------------------------------------+
|  | 1. Chicken (1 breast)         170 g  |
|  | 2. Potatoes                   200 g  |
|  | 3. Beer (1 can)               330 ml |
|  | [+ Add ingredient]                   |
|  +--------------------------------------+
|  Total: 2.2 kg CO2e                      |
+------------------------------------------+
```

- Ingredient editor: item picker (grouped list with icons, same
  widget pattern as the Part 1 mode picker), then quantity via
  serving-preset chips or a grams/ml field. Picking a preset fills
  the grams field; the user can still edit it.
- Totals use the existing CO2 formatting helpers
  (`lib/core/utils/`).
- Nothing persisted in v1; meals are ephemeral screen state, same
  as Part 1 journeys. Saved meals are P2.

### 8.9 Meal Comparison

**Priority:** P0 | **Complexity:** Medium

Identical mechanics to 8.3: 2-3 full meals side by side, bars
scaled to the worst option, best highlighted, delta line plus
equivalencies from the Phase 6 helpers
(`lib/features/progress/domain/services/impact_equivalencies.dart`)
-- no new equivalency code. Share the Part 1 comparison widget;
do not write a second bar-comparison widget.

```
+------------------------------------------+
|  Burger night                             |
|                                          |
|  Beef       ################--  11.2 kg  |
|  Chicken    ##----------------   1.1 kg  |
|  Bean       #-----------------   0.2 kg  |
|                                          |
|  Bean emits 11.0 kg less CO2e (98%)      |
|  = 68 km not driven in a petrol car      |
+------------------------------------------+
```

- Same copy rule as 8.3: deltas are hypothetical comparisons, so
  say "emits X kg less CO2e", never "saves".
- Optional educational presets (P2): 2-3 bundled comparisons
  ("Burger night: beef vs chicken vs bean") to demonstrate the
  protein gap without any data entry.

### 8.10 Food Methodology & Sources UI

**Priority:** P0 | **Complexity:** Low

Same two layers as 8.4:

- **Per-item detail:** info icon opens the science bottom sheet
  (`ActionScienceBottomSheet` pattern): factor, basis (per kg
  as-purchased), calculation notes, tappable sources.
- **Methodology page:** static localized screen covering:
  - Scope: cradle-to-retail lifecycle incl. land-use change;
    excludes home cooking and food waste; not summable with the
    transport calculator's operational-only scope.
  - **Spread:** factors are global means; the same food varies
    ~10-50x between producers. Show one example range in text
    (beef: 9-105 kg CO2e per 100 g of protein, OWID -- note the
    per-protein basis; the tomato field-vs-heated-greenhouse
    range is now sourced via Clune et al. 2017: field median
    0.45 vs heated greenhouse 2.20 kg CO2e/kg, see
    RESEARCH_FOOD.md section 3.5).
  - **"Organic" and "local" honesty:** transport is typically
    <10% of food footprint, so "local beef" beats "imported
    beans" on zero metrics; organic often has similar or higher
    CO2e per kg. The calculator therefore has no organic/local
    modifier -- this is a feature, and the methodology explains
    why with citations.
  - Full source list.
- Every factor traceable to a source the user can open. No uncited
  numbers anywhere in the feature.

### 8.11 Food Entry Points & Navigation

**Priority:** P1 | **Complexity:** Low

- New route: `/food-calculator`, pushed full-screen like
  `/transport-calculator`. Comparison and methodology are internal
  navigation.
- Entry points (mirror 8.5):
  1. Card on the Progress screen's Impact segment ("What does a
     meal cost the planet?").
  2. Banner row in the Action Log screen when the food category
     tab is active.
- Cross-link the two calculators from each methodology screen;
  consider a shared "Calculators" entry card (see Open Questions).
- **Update [APP_PAGES.md](./APP_PAGES.md)** in the same PR as the
  route change (standing rule).
- Analytics: `food_calculator_opened`, `food_comparison_run`
  (params: item ids, ingredient counts, winning meal) in
  `AnalyticsService`, same shape as the 8.5 events.

### 8.12 Food Logging Bridge (Deferred)

"I ate the greener meal" -- P2, not in v1. Deferred for exactly
the 8.6 reasons: variable-CO2 logs break the precomputed-points
invariant and are the app's biggest self-report gaming surface.
Food is lower-stakes than transport (a fabricated beef-vs-bean
meal is ~3 kg, not ~500 kg), so this bridge may ship before 8.6 --
but it still needs per-log CO2 ceilings and a daily cap first.

Interim: the comparison result cross-links the existing food
actions in the LIVE action library (`skip_high_impact_food`,
`skip_medium_impact_food`, `plant_milk`) so honest users have a
logging path today. The `meatless_meal_*` ids exist only in the
research database (`data/seed/`), not in the seeded library --
do not cross-link them (design review DR-2, 2026-07-19).

### Part 2 Data Models

```dart
@freezed
abstract class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String id,
    required String group,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required double kgCo2ePerKg,
    @Default([]) List<ServingPreset> servings,
    @Default('') String calculationNotes,
    @Default([]) List<EmissionSource> sources,
  }) = _FoodItem;
}

@freezed
abstract class ServingPreset with _$ServingPreset {
  const factory ServingPreset({
    required String id,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required double grams,
  }) = _ServingPreset;
}

@freezed
abstract class MealIngredient with _$MealIngredient {
  const factory MealIngredient({
    required String itemId,
    required double grams,
  }) = _MealIngredient;
}
```

`EmissionSource` is the existing Part 1 model, promoted to
`lib/shared/`. Meals/comparisons are presentation-layer state
(Riverpod notifier), no Firestore models in v1.

### Part 2 Implementation Order

1. **Dataset research** (8.7) -> `RESEARCH_FOOD.md` -> build
   `food_items.json` (the slow, careful step; everything else can
   proceed against provisional values).
2. Promote `EmissionSource` to shared; models + codegen + JSON
   loader (mirror the transport loader).
3. Calculator engine + unit tests (pure Dart, no UI).
4. Meal builder UI (8.8).
5. Comparison UI (8.9), sharing the Part 1 comparison widget and
   Phase 6 equivalencies.
6. Methodology sheet + per-item science sheets (8.10).
7. Entry points, route, analytics (8.11); update APP_PAGES.md.
8. Localization pass (EN/JA/ES) + `flutter gen-l10n`.

### Part 2 Testing Strategy

| Area | Tests |
|------|-------|
| Dataset validation | Every item has all three locales, a positive factor, at least one source with url+quote+accessed; serving presets have positive grams and all locales; ids unique (mirror `transport_dataset_invariants_test.dart`) |
| Engine | Grams x factor math, multi-ingredient sums, zero-gram ingredients, display rounding (g -> kg -> t) |
| Sanity checks | Cross-item invariants pinned as tests (data pins with margins; full safe-pin and never-pin lists in RESEARCH_FOOD.md): beef (beef herd) > lamb > pork > chicken > tofu > potatoes per kg; 2.5 < beef-herd/dairy-herd < 3.5 (band -- ratio is ~3.0, a strict >3x fails); cheese > chicken; max(plant milk) x 2 < dairy milk |
| Consistency | Dataset-derived meal deltas match the cited deltas in `meatless_meal_*` action data within tolerance |
| Widgets | Ingredient add/edit/remove, preset chip fills grams field, comparison bar ordering and delta copy |
| Localization | Item and preset names resolve in EN/JA/ES |

### Part 2 Acceptance Criteria

- [ ] 42 items shipped with fully cited factors (quote + URL +
      access date per source), passing dataset validation tests
- [ ] User can build a multi-ingredient meal and see total CO2e
- [ ] Quantities enterable via serving presets or raw grams/ml
- [ ] User can compare 2-3 meals side by side with delta and at
      least one equivalency
- [ ] Every factor inspectable in-app down to its sources
- [ ] Methodology screen covers scope, spread, and organic/local
      honesty in plain language, localized EN/JA/ES
- [ ] Dataset deltas consistent with existing `meatless_meal_*`
      actions
- [ ] No points or CO2 credited anywhere in the feature (v1)
- [ ] APP_PAGES.md updated with the new route(s)
- [ ] `flutter analyze` clean; all new logic unit-tested

### Part 2 Open Questions

| Question | Current lean |
|----------|--------------|
| Merge transport + food into one "Calculators" hub screen? | Separate routes v1; shared entry card if both ship |
| Recipe presets ("cheeseburger", "curry rice")? | P2; presets are just saved ingredient lists, easy later |
| Per-serving vs per-100g display toggle? | Total per meal only in v1; per-item view shows per kg |
| Protein-normalized comparison (gCO2e per 100 g protein)? | P2 educational view; the OWID chart exists, powerful but adds a data column |
| Regional factors (JP rice, ES olive oil)? | Global means v1, same call as Part 1 |
| Saved meals? | P2, same as saved journeys |

---

## Part 3: Home Energy Calculator

Part 3 adds a **home energy calculator**: users build a routine
from energy behaviors (behavior + quantity), see its CO2e, and
compare alternatives side by side (bath vs 10-min shower, tumble
dry vs line dry, aircon at 22 vs 26).

The insight this part teaches: **anything that makes or moves heat
(showers, baths, drying, space heating/cooling) costs 10-100x
anything that makes light or computation.** People agonize over
kettle-vs-IH (~40 g either way) and phone chargers (~6 g) while
the shower behind them costs ~500-900 g and the dryer ~1 kg. A
calculator whose honest answer is sometimes "this choice barely
matters -- here is the one that does" is the point.

### What Part 3 is NOT

**Not an appliance database.** The unit is the *behavior/choice*,
never the product: no makes, models, or A-H efficiency classes
(those inform purchases, not habits, and would rot with every tech
cycle). A fridge has no behavior attached -- you cannot fridge
less -- so it appears only as a scale-context line in the
methodology, not as a dataset item. Efficiency-class advice ("when
you do replace, the label matters") is one methodology paragraph,
not a feature.

### Why maintenance stays small (design constraint, not hope)

- **Most entries are physics.** Heating 1 L of water 15->100 C is
  ~0.1 kWh in any decade; shower energy is flow x minutes x
  delta-T x heat capacity; drying is latent heat. These entries
  are derived, with the arithmetic reproducible from
  `calculation_notes`, and never need refreshing.
- **Everything multiplies through two carrier factors** --
  electricity (grid, 386 g/kWh) and gas (~184 g/kWh, DEFRA). The
  grid factor is already shipped and maintained for Part 1's EV
  entries; **promote it to a single shared constant** so the two
  datasets cannot drift (pinned by a cross-dataset test).
- **Only a handful of appliance-average entries** (dryer cycle,
  dishwasher cycle, aircon per hour) need checking on the yearly
  DEFRA refresh already scheduled for Part 1, protected by the
  same sanity-invariant tests.

### Part 3 Deliverables

| Deliverable | Description |
|-------------|-------------|
| Energy behavior dataset | `data/app/energy_behaviors.json`: ~25 behaviors, kWh-per-unit + carrier, usage presets, EN/JA/ES, full source citations |
| Calculator engine | Pure Dart: usages -> per-usage and total CO2e via carrier factors |
| Routine builder UI | Add/edit/remove usages (behavior, quantity via presets or number) |
| Comparison UI | 2-3 routines side by side with delta and equivalencies |
| Methodology sheet | Scope, carrier factors, physics assumptions, "where the heat is" |
| Localization | Full EN/JA/ES strings |

### 8.13 Energy Behavior Dataset: `data/app/energy_behaviors.json`

**Priority:** P0 | **Complexity:** Medium (research-heavy)

Bundled static JSON, same pattern as the Part 1/2 datasets.
Research output goes to `Plan/RESEARCH_ENERGY.md`, same rules
([RESEARCH_STRATEGY.md](./RESEARCH_STRATEGY.md),
[AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) sections 2 and 8),
including an `ENERGY_LOGIC_CHECK` section.

#### Behavior list (initial)

Illustrative magnitudes only, research fixes exact values. Water
heating ships electric and gas variants as **separate entries**
(no carrier-toggle code); kWh below are per stated unit.

| Group | Behavior | Unit | Illustrative kWh | Carrier |
|-------|----------|------|------------------|---------|
| Hot water | Shower | minute | ~0.23 | elec or gas |
| Hot water | Bath (~150 L at 40 C) | use | ~4.5 | elec or gas |
| Hot water | Washing-up by hand (hot tap, 5 min) | use | ~0.7 | elec or gas |
| Laundry | Washing machine, 30 C cycle | use | ~0.4 | elec |
| Laundry | Washing machine, 60 C cycle | use | ~1.0 | elec |
| Laundry | Tumble dryer cycle | use | ~2.4 | elec |
| Laundry | Line dry | use | 0 | - |
| Climate | Aircon cooling | hour | ~0.5 | elec |
| Climate | Electric space heater | hour | ~1.8 | elec |
| Climate | Kotatsu | hour | ~0.15 | elec |
| Climate | Electric blanket | hour | ~0.05 | elec |
| Cooking | Kettle, boil 1 L | use | ~0.11 | elec |
| Cooking | IH hob, boil 1 L | use | ~0.13 | elec |
| Cooking | Gas hob, boil 1 L | use | ~0.25 | gas |
| Cooking | Oven | hour | ~1.5 | elec |
| Cooking | Microwave | 10 min | ~0.2 | elec |
| Cooking | Rice cooker cycle | use | ~0.15 | elec |
| Cooking | Dishwasher cycle | use | ~1.0 | elec |
| Small stuff | Phone charge | use | ~0.015 | elec |
| Small stuff | Laptop charge | use | ~0.06 | elec |
| Small stuff | TV | hour | ~0.1 | elec |
| Small stuff | LED bulb | hour | ~0.01 | elec |
| Small stuff | Incandescent bulb | hour | ~0.06 | elec |
| Small stuff | Standby devices (household) | day | ~0.3 | elec |

The "Small stuff" group is deliberate and load-bearing: those
entries are the scale anchors that make the heat entries legible
(the role beef and the private jet play in Parts 1-2), and they
debunk the most common misallocated worries (standby, chargers).
Kotatsu vs space heater (~10x) is the flagship JP-relevant
comparison.

Notes locked in now:

- **Internal quantity is `kwhPerUnit x units`;** unit is an enum
  (`use`, `minute`, `hour`, `day`). Presets ("10-min shower",
  "1 load") fill the units field, same UX as Part 2 servings.
- **Carrier factors live in metadata once:**
  `grid_factor_g_per_kwh` (shared with Part 1 -- a test asserts
  the two dataset files match) and `gas_factor_g_per_kwh` (DEFRA
  natural gas, incl. well-to-tank for scope consistency with
  Part 1).
- **Climate entries are honest approximations:** aircon/heater
  per-hour figures are typical-unit averages with spread stated;
  the setpoint lesson ("1 C ~= 5-10% of heating/cooling energy")
  ships as presets on the aircon entries (e.g. "1 hour at 26 C"
  vs "1 hour at 22 C") plus a methodology paragraph, not as a
  thermal model.
- **Physics-derived entries cite assumptions, not products:** flow
  rate (L/min), delta-T, appliance efficiency, each sourced
  (DEFRA, IEA, Energy Saving Trust tier-1 list).

#### Schema

Same shape as Part 2 with `kwh_per_unit`, `unit`, `carrier`
replacing `kg_co2e_per_kg`; `servings` becomes `presets`
(`{id, names, units}`). Sources and `calculation_notes` identical.
Metadata carries both carrier factors and the scope string
("operational energy only; matches Part 1 scope, not Part 2's
lifecycle scope").

**Consistency check with existing data:** the dataset must
reproduce the cited deltas of `air_dry_clothes`,
`cold_water_laundry`, `shorter_shower`, `unplug_standby`, and
`led_vs_incandescent` in `co2_actions_database.json` (or flag the
action data for correction) -- same rule as Part 2's
`meatless_meal_*` check.

### 8.14 Routine Builder & Calculator Engine

**Priority:** P0 | **Complexity:** Low-Medium

New feature module `lib/features/energy/`, mirroring
`lib/features/food/`. Engine, pure Dart:

```
usageCo2e(u) = behavior.kwhPerUnit * u.units
             * carrierFactor(behavior.carrier)
routineCo2e = sum(usageCo2e for usages)
```

UI is the Part 2 meal builder with nouns swapped: behavior picker
(grouped, icons), preset chips or a numeric units field, running
total via the shared CO2 formatters. Ephemeral state, nothing
persisted in v1.

### 8.15 Routine Comparison

**Priority:** P0 | **Complexity:** Low

Identical mechanics to 8.3/8.9, sharing the comparison widget and
Phase 6 equivalencies. Educational presets (P2) are unusually
strong here: "Bath vs shower", "Dryer vs line", "Space heater vs
kotatsu evening".

```
+------------------------------------------+
|  Laundry day                              |
|                                          |
|  60 C + dryer ################  1.3 kg   |
|  30 C + dryer ###########-----  1.1 kg   |
|  30 C + line  ##---------------  0.15 kg |
|                                          |
|  Line drying emits 1.15 kg less CO2e     |
|  than 60C+dryer = 190 phone charges      |
+------------------------------------------+
```

(Delta copy uses the Phase 6 equivalency helpers; numbers above
illustrative.)

### 8.16 Energy Methodology & Sources UI

**Priority:** P0 | **Complexity:** Low

Same two layers as 8.4/8.10. Methodology page covers:

- Scope: operational energy only, same convention as Part 1;
  carrier factors and their vintage; why gas heating shows lower
  CO2e than electric today and how that flips as grids decarbonize
  (the one paragraph that ages, flagged for the yearly refresh).
- Physics assumptions per entry (flow rates, temperatures,
  efficiencies) and the spread on appliance averages.
- "Where the heat is": the heat-vs-light 10-100x hierarchy, with
  the fridge/always-on context line ("a fridge runs ~1 kWh/day --
  you can't shower-length your fridge, so it isn't in the picker;
  efficiency class matters when you replace it").
- Full source list.

### 8.17 Energy Entry Points & Navigation

**Priority:** P1 | **Complexity:** Low

- New route: `/energy-calculator`, same push pattern; internal
  navigation for comparison and methodology.
- Entry points mirror 8.5/8.11: Impact-segment card ("What does a
  bath actually cost?") and Action Log banner on the energy
  category tab. Cross-link all three calculators from each
  methodology screen.
- **Update [APP_PAGES.md](./APP_PAGES.md)** in the same PR
  (standing rule).
- Analytics: `energy_calculator_opened`, `energy_comparison_run`
  (params: behavior ids, usage counts, winning routine).

### 8.18 Energy Logging Bridge (Deferred)

Same deferral and reasoning as 8.6/8.12. Energy is the
lowest-stakes of the three (deltas are grams-to-~2 kg), so if the
bridge design lands anywhere first, it lands here. Interim
cross-links: `air_dry_clothes`, `cold_water_laundry`,
`shorter_shower`, `unplug_standby`, `led_vs_incandescent`.

### Part 3 Data Models

```dart
@freezed
abstract class EnergyBehavior with _$EnergyBehavior {
  const factory EnergyBehavior({
    required String id,
    required String group,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required double kwhPerUnit,
    required EnergyUnit unit,      // use | minute | hour | day
    required EnergyCarrier carrier, // electricity | gas | none
    @Default([]) List<UsagePreset> presets,
    @Default('') String calculationNotes,
    @Default([]) List<EmissionSource> sources,
  }) = _EnergyBehavior;
}

@freezed
abstract class UsagePreset with _$UsagePreset {
  const factory UsagePreset({
    required String id,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required double units,
  }) = _UsagePreset;
}

@freezed
abstract class RoutineUsage with _$RoutineUsage {
  const factory RoutineUsage({
    required String behaviorId,
    required double units,
  }) = _RoutineUsage;
}
```

`EmissionSource` shared (from Part 2's promotion). If Part 2
implementation shows `ServingPreset`/`UsagePreset` are identical
shapes, collapse to one shared `QuantityPreset` -- decide at
implementation time, not now.

### Part 3 Implementation Order

Same as Part 2's order with nouns swapped: research (8.13) ->
models/loader -> engine + tests -> builder UI (8.14) -> comparison
(8.15) -> methodology (8.16) -> entry points (8.17) -> l10n pass.
Part 3 should follow Part 2 so it inherits the shared widgets and
the preset UX already proven there.

### Part 3 Testing Strategy

| Area | Tests |
|------|-------|
| Dataset validation | Locales, positive kWh (zero allowed only for `none` carrier), valid unit/carrier enums, presets positive, ids unique, sources complete |
| Cross-dataset | `grid_factor_g_per_kwh` identical in `transport_modes.json` and `energy_behaviors.json` |
| Engine | kWh x units x carrier-factor math, gas vs electric factors, multi-usage sums, zero-unit usages, display rounding |
| Sanity checks | Bath > 10-min shower > kettle > phone charge; dryer cycle > 30 C wash; 60 C wash > 2x 30 C wash; space heater hour > 5x kotatsu hour; incandescent > 4x LED per hour |
| Consistency | Dataset-derived deltas match `air_dry_clothes`, `cold_water_laundry`, `shorter_shower`, `unplug_standby`, `led_vs_incandescent` within tolerance |
| Widgets | Usage add/edit/remove, preset chip fills units, comparison ordering and delta copy |
| Localization | Behavior, group, and preset names resolve in EN/JA/ES |

### Part 3 Acceptance Criteria

- [ ] ~25 behaviors shipped with fully cited factors/assumptions,
      passing dataset validation tests
- [ ] User can build a routine and see total CO2e
- [ ] Quantities enterable via presets or raw units
- [ ] User can compare 2-3 routines with delta and equivalency
- [ ] Grid factor is a single source of truth across datasets,
      pinned by a test
- [ ] Methodology covers scope, carrier factors, physics
      assumptions, and the heat-vs-light hierarchy, EN/JA/ES
- [ ] Dataset deltas consistent with existing energy actions
- [ ] No points or CO2 credited anywhere in the feature (v1)
- [ ] APP_PAGES.md updated; `flutter analyze` clean; new logic
      unit-tested

### Part 3 Open Questions

| Question | Current lean |
|----------|--------------|
| Regional grid factors (JP ~440 g/kWh vs global 386)? | Global factor v1 for cross-app consistency; revisit with Part 1's regional question as one decision |
| Heating fuel types beyond gas (kerosene, heat pump)? | Gas + electric v1; kerosene is JP-relevant, add in first refresh if requested |
| Season-aware presets (aircon summer/winter)? | No; presets are named plainly, users pick what they do |
| Whole-day "routine" templates? | P2, same as recipe presets in Part 2 |
| Cost display (yen/euro) alongside CO2e? | Tempting (money persuades more than grams) but new maintenance surface (tariffs); methodology mentions cost correlation instead, v1 |
