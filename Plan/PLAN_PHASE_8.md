# Phase 8: Transport Carbon Calculator

**Version:** 1.0
**Created:** July 2026
**Status:** Planning

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
| Transport mode dataset | `data/app/transport_modes.json`: ~24 modes, gCO2e/km factors, EN/JA/ES names, full source citations |
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
- **Cycling keeps the 16 g/km metabolic figure** already used by
  `bike_instead_of_car` in `co2_actions_database.json` for
  consistency across the app.
- **Shinkansen needs a non-DEFRA source** (JR Central environmental
  report and/or IEA rail study; Eurostar's ~6 g/km is
  French-nuclear-specific and must not be presented as generic
  high-speed rail).
- **Scope:** direct + well-to-tank energy emissions, consistent with
  DEFRA conversion-factor conventions. Vehicle manufacturing and
  infrastructure are excluded and the methodology sheet says so
  (with a note that this understates EV vs petrol manufacturing
  differences).

#### Schema

```json
{
  "metadata": {
    "version": 1,
    "scope": "direct + well-to-tank; excludes vehicle manufacture",
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
|  | 1. Taxi (medium petrol, 1p)   20 km  |
|  | 2. Domestic flight           515 km  |
|  | [+ Add leg]                          |
|  +--------------------------------------+
|  Total: 130.1 kg CO2e                    |
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
|  Fly        ############------  130 kg   |
|  Drive (1p) ##########--------   85 kg   |
|  Rail       #-----------------   10 kg   |
|                                          |
|  Rail saves 120 kg CO2e vs flying (92%)  |
|  = 6 trees growing for a year            |
+------------------------------------------+
```

- Horizontal bars scaled to the worst option; best option
  highlighted.
- Delta line compares best vs worst; equivalencies reuse the Phase
  6 impact-equivalency helpers (trees, phone charges, car-km) --
  no new equivalency code.
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
