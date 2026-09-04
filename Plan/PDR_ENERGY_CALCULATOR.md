# PDR: Phase 8 Home Energy Calculator -- Post-Design Review

**Created:** 2026-08-02
**Status:** Built and routed. The dataset, `lib/features/energy/`
and `test/features/energy/` shipped in commit 823f984
(2026-08-29); the 2026-08-30 pass finished the rest: the E7
ratio-led result rework, the methodology screen with the ranked
"Where your energy goes" table (8.16), the `fan` entry (section
3), and 8.17's route and entry points (chooser tile enabled,
energy category card, `energy_calculator_opened`), so
**deliverables 8.13-8.17 are done**. **E8 is RESOLVED
2026-09-01** (section 8): the ranked view was promoted out of the
methodology screen to its own route `/energy-explore`, with
baseline switching and a per-row what-if sheet; a higher-or-lower
quiz was added at `/quiz` as a second teaching surface;
and the comparator stays the routed primary. The residual test
debt in section 9 is the remaining open work.
Evidence base
([RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) v2.0, 34 behaviors)
is complete. Owner decisions E1-E7 are settled, as are two
product decisions (no logging bridge; comparison gating).
**Purpose:** The working record for building the feature -- standing decisions and why, the product rules, the
action-library additions, the UI/copy requirements, and the
methodology screen copy. The evidence base (sources, verbatim
quotes, verified factors, presets, sanity invariants, arithmetic)
lives in [RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) and is not
repeated here.
**Companion docs:** [PLAN_PHASE_8.md](./PLAN_PHASE_8.md) Part 3
(feature plan), [RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md)
(evidence base),
[PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md)
(spun-out grid work),
[ANNUAL_RESEARCH_UPDATE.json](./ANNUAL_RESEARCH_UPDATE.json)
(maintenance ledger),
[AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) (sourcing and
points rules).

---

## 1. Scope & Current State

**Landed and committed:**

- `data/app/transport_modes.json` -- E1 rebase: grid factor
  386 -> 458, `car_bev` 73 -> 86, `escooter_private` 6 -> 7
  (`ebike` holds at 2). No `386` remains in the file.
- `data/seed/co2_actions_database.json` -- rebuilt as the single
  source of truth: 92 shipping actions, 13 energy/transport values
  rebased, 1 new action, 13 research-only records preserved
  (section 4).
- `scripts/seed/seed_action_library.js` -- rewritten to read that
  JSON; 2,471 -> 252 lines.
- `data/app/impact_equivalencies.json` -- `burgers` 11000 -> 7951.
- `Plan/AUDIT_ACTION_DATA.md` section 8 -- grid factor and the
  retired derivation.

**Re-seed: done** (`npm run seed`). Verified 2026-08-29 against
the live `actionLibrary`: 92 docs matching the 92 local actions,
nothing to prune or add. `heat_person_not_room` is live,
`use_natural_light` and `full_laundry_load` are gone, and
`turn_off_lights` reads 15 g / 2 points. The food FR-22 values
went in on the same run.

**Built in commit 823f984 (2026-08-29):**

- `data/app/energy_behaviors.json` -- 33 behaviors, cited factors,
  `comparable_group` field, EN/JA/ES
- `lib/features/energy/` -- models, loader, calculator, routine
  builder, comparison, science sheet
- `test/features/energy/` -- dataset validation, engine, sanity
  pins, cross-dataset grid-factor pin, widgets
- `scripts/generators/build_energy_behaviors.py` -- the dataset
  generator

**Built in the 2026-08-30 pass (working tree):**

- **The `fan` entry** (owner call, section 3): dataset regenerated
  to 34 behaviors, count moved in its four homes, tests extended
  (exact values, unit map, citation tuple + access date, gating
  must-allow pair, sanity pin 16), RESEARCH_ENERGY updated.
- **The E7 result rework.** The result card now leads with the
  kWh-computed multiple (`energyComparisonRatio`), follows with
  the gram saving and the phone-charge equivalency anchored on
  the dataset's own `phone_charge` row, and closes with the
  grid-vintage and no-points basis notes. `routineKwh` returned
  as live code with the shared `_requireFiniteUnits` guard. Rule
  26's two honest fallbacks and rule 27's electricity-only anchor
  are implemented and widget-tested.
- **The methodology screen (8.16 remainder):**
  `energy_methodology_screen.dart`, the section 6 copy written
  natively in EN/JA/ES, the four-way heating hierarchy, the
  measured-vs-rated / standby / lighting / avoided-emissions
  notes, a data-derived source list, and the ranked **"Where your
  energy goes"** table as the standalone reusable
  `energy_ranked_table.dart` (electricity rows as LED-hour
  multiples, every carrier in one energy ranking per rule 28).
- **Entry points and routing (8.17):** `/energy-calculator` in
  `lib/app/router.dart`, the chooser tile enabled (the
  coming-soon affordance deleted with its three `.arb` strings),
  the "Compare home energy use" card on the Action Log's energy
  tab (badged "Calculator", not "Custom" -- energy banks nothing),
  `logEnergyCalculatorOpened()`, and APP_PAGES updated in the
  same pass.

**Still open:** the residual test debt in section 9. E8 is
resolved (section 8).

**What this feature is for**, settled, and it is not what Parts 1
and 2 are for: transport and food are decision tools that teach.
**Energy is a teaching tool that occasionally informs a
decision.** Its unit is the behavior, never the product.
Entry-point weighting follows, within the entry points that
actually exist: the calculator chooser sheet and the Action Log
category card. (8.17's original "Impact-segment card" was
withdrawn from 8.5 on 2026-07-23 and shipped for no calculator;
the weighting sentence that leaned on it is retired.)

---

## 2. Standing Decisions (live rules -- read before touching data)

Owner-approved. The warnings exist because earlier drafts said
otherwise; do not "fix" values backwards from superseded text.

- **E1 (grid factor) -- RESOLVED 2026-08-02: ship Ember 458 g
  CO2e/kWh.** The app is denominated in CO2e throughout, so a
  CO2-only anchor is a scope mismatch: IEA's 435 and Ember's 458
  are the same vintage, the 5.3% gap between them is purely
  CO2e-vs-CO2, and 458 is the scope-correct half. **Do NOT average
  the two**, and do not restore the retired 386 -- it was 16% low
  and its own documented derivation did not reproduce it. Applied
  to `transport_modes.json`, `co2_actions_database.json` and this
  dataset together. **Regionalisation is NOT part of E1** -- it is
  spun out, see
  [PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md).
  Candidate survey, blast radius and the points arithmetic:
  [RESEARCH_ENERGY_ARCHIVE.md](./RESEARCH_ENERGY_ARCHIVE.md)
  sections 2 and 9.
- **E2 (gas boundary + comparison gating) -- APPLIED.** Gas ships
  combustion-only Gross CV at 182 g/kWh. Comparison gating ships
  as `comparable_group` + same-carrier + 20% delta (section 3).
- **E3 (electric water heating) -- APPLIED.** Two entries,
  resistance and heat pump, rather than an unweighted average.
- **E4 (shower flow) -- APPLIED.** 7.844784 L/min, the mean of
  three current-product figures; the 1990s 10 L/min head is
  excluded.
- **E5 (kerosene) -- APPLIED (skip).** Not a picker item; ships
  as one row of the methodology's four-way heating hierarchy,
  which is now fully sourced from METI.
- **E6 (wash temperatures) -- APPLIED.** Three verbatim Bosch
  entries (20 / 40 / 60 C) instead of a 30 C entry or a
  "20-30 C" range label.
- **E7 (headline unit) -- DECIDED 2026-08-30: the ratio leads,
  grams are subordinate.** A ratio between two entries on the same
  carrier is identical on every grid on Earth; a gram figure is
  only true for a user on a 458 g/kWh grid and is 3.5x wrong for
  the UK. The absolute figure still ships, because the app is
  denominated in CO2e throughout, but it carries the vintage label
  (rule 19) and never carries the comparison. This was the
  original intent, not a new idea: PLAN_PHASE_8 8.15's own mockup
  reads "= 190 phone charges". The 823f984 screen dropped it --
  energy was the only one of the three calculators that passed no
  `equivalencyText` to `ComparisonDeltaCard`. **Implemented
  2026-08-30** in the result card, with the two honest fallbacks
  rule 26 records.

---
Derived rules, equally binding:

- **Measured beats rated.** Where a government measured figure and
  a manufacturer rated figure disagree, measured ships. This
  decides both aircon entries (0.167679 / 0.241006 from METI, NOT
  the Panasonic JIS ratings 0.435 / 0.455) and the kotatsu (0.15
  on the makers' own thermostat-averaged Wh basis, NOT the
  300-600 W nameplate). A sanity pin guards each.
- **Nameplate is never the shipped value for a cycling
  appliance.** Kotatsu, electric blankets, ovens and inverter air
  conditioners all draw far less than their rating on average.
- **Calorific-basis discipline.** The gas factor is Gross CV, so
  the hot-water efficiency must also be Gross CV (0.756353).
  Published boiler efficiencies are usually Net CV; pairing them
  directly understated gas by 12.6% and was fixed 2026-08-02. If
  the factor ever moves to a net basis, the efficiency moves with
  it.
- **"Space heater" is banned as a term.** It is US usage and reads
  in British English as the whole category of space heating,
  including a gas-boiler-fed radiator. The entry is
  `portable_electric_heater` -- a portable plug-in electric
  resistance heater, JP 電気ストーブ／セラミックファンヒーター.
- **The oven ships per bake cycle, not per hour.** DOE has never
  adopted an active-mode oven standard and ENERGY STAR does not
  certify ovens, both citing use-pattern variability, so no
  per-hour figure exists anywhere. Do not "fix" it to an hourly
  unit.
- **No points or CO2 credited inside the calculator** in v1. The
  action library is the only place energy behavior earns points.
- **The dataset stores exact unrounded values; the UI rounds for
  display.**
- **Never sum across the three calculators.** Part 2 counts a
  food's whole lifecycle, Part 3 counts the electricity to cook
  it, Part 1 counts tailpipe energy.
- **One action store.** `data/seed/co2_actions_database.json` is
  the single source of truth; the seeder reads it and holds no
  action data. Never reintroduce an inline action array -- the two
  stores silently diverged once and shared only 9 of 112 ids.
- **Carrier floor convention.** For hot-water actions whose
  carrier the app cannot know (`shorter_shower`, `shorter_bath`),
  ship the **gas** figure, not the absolute heat-pump floor. Gas
  and resistance electric are the two dominant configurations
  globally, gas is the lower of that pair, and heat-pump owners
  are a minority the methodology names.
- **Whole-home gas central heating ships as methodology context,
  never a picker item or an action** -- same treatment as the
  fridge. It is ~11.5x the aircon entry per degree and has no
  per-hour measurement; putting it in the picker would imply a
  comparability that does not exist. Figure and sourcing in
  RESEARCH sec 3.3.
- **Physics entries never need refreshing.** Only the assumptions
  around them (flow rate, delta-T, efficiency) can age. Everything
  that does age is on a cadence in
  [ANNUAL_RESEARCH_UPDATE.json](./ANNUAL_RESEARCH_UPDATE.json)
  (`grid_factor`, `gas_factor`, `energy_*`), which is the only
  place that cadence is recorded.
- **Never rank gas and electricity entries in one list.** The
  carrier gate (E2) governs the comparator; the same constraint
  binds any ranked view, because a gas row's position moves with
  the grid factor while an electric row's does not. Ranked on the
  UK's 131 g/kWh the gas bath is the **worst** row on the board;
  at 458 it is fourth; at India's 695 it is sixth. The 28
  electricity entries plus `line_dry` (carrier `none`, zero on
  every grid) order identically everywhere and are the only rows
  that may share a ranking. A gas entry attaches to the electric
  row it substitutes for, as an alternative carrying no ordering
  claim, with the 241 g/kWh crossover copy from section 6.
- **Ratios are computed in kWh, never from the equivalency
  helpers.** `phoneCharges` in `impact_equivalencies.json` is a
  fixed 8 g/unit EPA constant, so `grams / 8` scales with the
  grid: the electric bath reads 326x at 458 g/kWh but 93x on the
  UK grid. Dividing `kwh_per_unit x units` by the dataset's own
  `phone_charge` entry (0.015271 kWh) gives **373x on every
  grid**. Same sentence on screen, opposite property. The Phase 6
  helpers stay correct for transport and food, which have no
  carrier factor to cancel.

---

## 3. Comparison Gating (decision E2)

Transport ships no comparison matrix -- it has a `group` field and
a "deliberate non-invariants" list enforced by copy discipline.
Energy needs more, because transport modes are substitutable by
construction (every one gets you from A to B) while energy
behaviors are not: comparing a wash load to a dishwasher load is
a **category error**, and no percentage-delta rule catches a
category error.

An N x N matrix would be 1,089 cells for ~10 real constraints.
Instead, one new field, `comparable_group`, and three conditions.
**Emit a comparative verdict only when all three hold:**

1. same `comparable_group`
2. same `carrier`
3. delta >= 20%

Allowlist semantics: a new behavior compares with nothing until
someone deliberately groups it. A blocklist would rot the first
time an entry is added.

Groups (32 entries): `hot_water` (5) · `dishes` (2) ·
`laundry_wash` (3) · `laundry_dry` (3) · `space_heat` (4) ·
`space_cool` (2, `fan` added 2026-08-30) · `boil` (3) ·
`cook` (4) · `lighting` (2) · `device` (4).

Checked against the never-pin list in section 6: kettle vs gas
hob fails #2; kettle vs IH
fails #3; wash load vs dishwasher fails #1; aircon cooling vs
heating fails #1; laptop vs incandescent fails #1; oven vs
portable electric heater fails #1. All covered.

**This gating earned its keep at E1:** two cross-carrier
orderings flipped when the factor moved, and rule #2 blocked both
from generating copy, so the rebase changed no user-facing claim.
Figures in [archive](./RESEARCH_ENERGY_ARCHIVE.md) 9.

**Cross-unit comparisons inside one group are allowed** (owner
call, 2026-08-29). `cook` spans a bake cycle, a minute and an
hour, and `device` spans an hour, a use and a day, so the gate
permits "ten hours of keep-warm against one bake". Both sides are
quantities the user chose deliberately and the arithmetic is
true, so there is nothing to refuse; the retired unit-level rule
in the old pin 14 was guarding this only by accident. The
category errors that matter are cross-group, and those still
fail condition 1.

Users may still build and compare any two routines they like --
the gating governs what the **app asserts**, not what the user
may look at.

**What the gate actually passes, measured 2026-08-30** (re-run
after the `fan` addition the same day). Of the 561 two-entry pairs
the 34-entry dataset admits, 45 share a `comparable_group` (8.0%),
34 of those also pass the carrier condition (6.1%, counting the
`none`-carrier exemption the engine applies to `line_dry`), and 32
clear the 20% bar at default presets (**5.7%**; on the 33-entry
build the figures were 528 / 44 / 33 / 31, 5.9%). Every one of
those refusals is correct. But a builder that lets the user
assemble any pair
will refuse roughly nineteen times in twenty, and the first
question a curious user asks ("what costs more, my shower or my
TV?") is one of them. That measurement is the evidence behind decision
**E8** (section 8, provisionally resolved 2026-08-30): the gate
is not the problem, the free-form builder in front of it is.

**Two former holes, both closed 2026-08-30 (owner calls):**

- **Self-comparison is intended, not a hole.** The same behaviour
  in both columns at different quantities passes all three
  conditions, and it must: the setpoint lesson only ships through
  it. `aircon_cooling` is one entry whose presets encode
  28/27/26 C as unit multipliers (1.0 / 1.17891 / 1.35783), so
  "1 hour at 26 C" against "1 hour at 28 C" is a same-entry
  comparison that clears the 20% bar at a 26% delta. Gating
  self-comparison would have killed the only buildable cooling
  comparison. The trivially proportional case (a 5-minute shower
  against a 10-minute one) is the `shorter_shower` lesson with
  real grams attached. The gate polices category errors, not
  quantity choices the user made deliberately.
- **`space_cool` gains a second entry: `fan`.** 0.022 kWh/h on
  the electricity carrier, the Panasonic F-CV339 top-notch figure
  already cited by `use_fan_instead_of_ac` (section 4). That makes
  cross-entry cooling comparisons buildable (a fan hour vs an
  aircon hour, 7.6x) and pairs the singleton. PLAN_PHASE_8's
  "aircon at 22 vs 26" example is still not buildable and never
  will be: 22 C is a heating preset and 26 C a cooling one, so it
  is cross-group by design; the plan text is corrected rather
  than the gate.

---

---

## 4. Action Library (single source of truth)

**Restructured 2026-08-02** to end a silent divergence between two
action stores that shared only 9 ids (detail in
[archive](./RESEARCH_ENERGY_ARCHIVE.md) 9; the standing rule is in
section 2).

- **`data/seed/co2_actions_database.json` is the single source of
  truth** -- 92 shipping actions, each with its CO2 value,
  calculation notes, research `sources[]`, confidence, localised
  strings and effort/frequency/impact scores.
- **`seed_action_library.js` reads it** and computes points at
  seed time via `computePoints()`. It no longer carries action
  data; the file went from 2,471 lines to 252.
- 13 records with no shipping action -- 6 transport-mode swaps now
  handled by the transport calculator, 5 never shipped, and the 2
  archived on 2026-08-29 -- are preserved under
  `research_only_records` and are explicitly **not seeded**.
- A `provenance_research_id` field links a shipping action back to
  its research record where the ids differ (`cold_water_laundry`
  -> `cold_wash`, `led_vs_incandescent` -> `install_led_bulb`,
  `unplug_standby` -> `unplug_devices`, `meatless_meal_*` ->
  `skip_*_impact_food`).

### Energy actions rebased to the research values

Owner decision: replace the US-basis values rather than merely
rescaling them, so the action library and the calculator cannot
quote different numbers for the same behaviour. All at 458 / 182
g CO2e/kWh.

**This table is the only home for these derivations** (moved here
from RESEARCH_ENERGY.md section 7 on 2026-08-30, which had carried
a second copy). Each `backtick`ed term is a behaviour id in
`energy_behaviors.json`, whose kWh value and sourcing are in
[RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) section 3. Every value
rounds **down** to two significant figures -- honest-not-generous,
since each is a claimed saving. Points are computed at seed time by
`computePoints()`; they are recorded here so a value change shows
its points consequence.

| Action | Was | Now | Points | Derivation |
|--------|----:|----:|-------:|------------|
| `air_dry_clothes` | 1700 | **2000** | 21 | `dryer_vented` 4.5 kWh x 458 = 2061, down |
| `cold_wash` | 600 | **430** | 10 | `wash_warm` 1.300 - `wash_cold` 0.350 = 0.950 x 458 = 435, down |
| `shorter_shower` | 230 | **110** | 5 | 2 min x 59 g/min (gas carrier floor) = 118, down |
| `shorter_bath` | 450 | **770** | 11 | `bath_gas` 7.526854 - 10-min `shower_gas` 3.28036 = 4.2465 x 182 = 773, down |
| `unplug_devices` | 45 | **25** | 2 | 5 devices x 0.5 W x 24 h = 0.06 kWh x 458 = 27.5, down (LBNL) |
| `install_led_bulb` | 28000 | **25000** | 63 | (`incandescent_bulb` 0.06 - `led_bulb` 0.0085) x 3 h/day x 365 = 56.4 kWh x 458 = 25820, down |
| `lower_thermostat` | 450 | **140** | 6 | METI 53.08 kWh/yr / 169 d = 0.3141 kWh/day x 458 = 144, down |
| `raise_ac_thermostat` | 350 | **120** | 6 | METI 30.24 kWh/yr / 112 d = 0.2700 kWh/day x 458 = 124, down |
| `turn_off_lights` | 60 | **15** | 2 | 4 h x 8.5 W LED = 0.034 kWh x 458 = 15.6, down; re-based 2026-08-29 off an unsourced 40 W bulb |
| `use_natural_light` | 90 | -- | -- | **DEMOTED 2026-08-29** to `research_only_records` |
| `eco_mode_appliance` | 200 | **120** | 6 | `dishwasher_normal` 1.12 - `dishwasher_eco` 0.85 = 0.27 x 458 = 124, down |
| `microwave_vs_oven` | 300 | **280** | 7 | `oven` 0.82 kWh per bake cycle - `microwave` 0.19 kWh (0.019 kWh/min x 10 min) = 0.63 x 458 = 289, down. The microwave figure is PER MINUTE in the dataset; 0.19 is its ten-minute preset |
| `ev_charging_green` | 3500 | **4500** | 31 | grid rebase only |
| `heat_person_not_room` | -- | **1900** | 18 | **NEW**; (`portable_electric_heater` 1.2 - `kotatsu` 0.15) x 4 h = 4.2 kWh x 458 = 1924, down |
| `use_fan_instead_of_ac` | 1200 | **600** | 12 | (`aircon_cooling` 0.167679 - fan 0.022) x 9 h = 1.311111 kWh x 458 = 600.5, down. Fan is the Panasonic F-CV339 DC living fan at its highest notch (22 W, https://panasonic.jp/fan/products/F-CV339/spec.html); 9 h/day is METI's own basis on the aircon page. Added 2026-08-09, replacing an unsourced 1200 |

**Coverage.** The table derives 13 actions across three categories
(`energy`, `water`, `transport`). `turn_off_lights` also carries its
derivation in its own `calculation_notes`. `full_laundry_load` was
**archived 2026-08-29** for having no derivation anywhere: no
partial-load washing measurement exists in the evidence base, and
the Bosch WNA14400GR table that supplies all three wash
temperatures is a max-load (9.0 kg) table only. Both archivings are
recorded in section 8 and in
[archive](./RESEARCH_ENERGY_ARCHIVE.md) 1.

**A citation error was corrected in passing.** `lower_thermostat`
and `raise_ac_thermostat` both cited "US DOE: 3% savings per
degree". DOE does not state that. Its actual figure is *"as much
as 10% a year ... by turning your thermostat back 7°-10°F for 8
hours a day"* -- a large, partial-day setback in Fahrenheit, not a
1 C continuous change. Both actions now use METI's measured
per-degree values, and the notes say so.

**Four proposed actions were dropped as duplicates** of behaviours
already shipping: `skip_bath` (= `shorter_bath`),
`aircon_setpoint_summer` (= `raise_ac_thermostat`),
`aircon_setpoint_winter` (= `lower_thermostat`), and
`dishwasher_eco_cycle` (= `eco_mode_appliance`). Their researched
values were folded into the existing actions instead. The
setpoint-state framing (クールビズ / ウォームビズ) and the seasonal
window remain the right copy treatment for the two thermostat
actions and should be applied to their descriptions.

**Seeded.** The live library matches this file exactly as of
2026-08-29; section 1 records the verification.

---

## 5. UI / Copy Requirements

Requirements, not suggestions.

1. **Comparison gating (section 3) is implemented in code, not
   in copy discipline:** same `comparable_group`, same `carrier`,
   delta >= 20%. Everything below assumes it.
2. **The kettle-vs-IH tie is a feature.** When a comparison
   resolves to a tie, say so plainly ("these are the same -- here
   is what actually moves the needle") and surface the nearest
   heat entry.
3. **Every carrier is named in the UI.** Entry names carry
   "(electric water)" / "(gas water)" / "(heat-pump water)".
4. **The electric-vs-gas crossover ships in the methodology**
   ([RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) section 2.1),
   including the 241 g/kWh figure and the fact that the UK has
   already crossed it. Never imply gas is universally cleaner.
5. **Measured-vs-rated disclosure on the aircon entries:** "a
   measured average hour of use (Energy Conservation Center via
   METI); the catalog rating is about 2.5x higher because it is
   measured at full load."
6. **Kotatsu vs portable electric heater ships as "roughly 8x", never
   "10x"**, and kotatsu carries "least certain figure in this
   dataset".
7. **Washing machine "60 C" sublabel:** "a user-selected 60 C
   programme; a label-optimised 'Eco 60' uses about half that and
   does not actually reach 60 C."
8. **Dryer type is a picker choice, not a footnote** (2.2x).
9. **Line drying is 0 with a winter caveat:** "outdoors or on a
   rack; running a dehumidifier to dry indoors is not free."
10. **Shower entry states its assumptions inline:** "7.8 L/min
    (average of current showerheads), water heated 10 C to 40 C".
    This is the largest driver in the dataset and the number a
    user can most easily check.
11. **Heat-pump water heating and heat-pump heating are the two
    headline levers.** Shower: 4.3x. Space heating: 5x vs
    resistance. Both are now pickable entries, so the app can
    show them rather than only describe them.
12. **The four-way heating hierarchy ships in the methodology**
    (aircon 110 / gas 181 / kerosene 245 / resistance 550 g per
    hour), because showing kerosene alone would read as an
    endorsement. Figures corrected 2026-08-29: the previous
    93 / 463 pair for the two electric rows was on the retired
    386 g/kWh basis, and mixing it with METI's own gas and
    kerosene CO2 made the table internally inconsistent. The
    458-basis table is RESEARCH_ENERGY section 3.3.
13. **Rice-cooker keep-warm carries the 4-hour rule** verbatim
    from 家電製品協会.
14. **Standby copy must debunk correctly**, quoting LBNL: per
    -device draw collapsed from 1-3 W to ~0.5 W while device
    counts rose faster, leaving "approximately the same amount of
    standby energy but now dispersed over many more products".
    Not "standby is trivial", not "standby is 10% of your bill".
15. **Small loads are never rounded up.** A phone charge is
    **7.0 g** (0.015271 kWh x 458). Corrected 2026-08-29 from
    5.9 g, which was the retired 386 basis.
16. **The fridge is a context line, never an item.**
17. **Setpoint presets state the linearity caveat** and are
    capped at +/-2 C. The science sheet may quote 環境省's
    13%/10% rule of thumb but must note METI's own measurements
    imply 15.2%/12.6%.
18. **Cross-calculator warning on the methodology page.**
19. **Grid-factor vintage disclosure:** state the figure (458 g
    CO2e/kWh), its basis (Ember, 2025 world average, CO2e) and its
    vintage on the methodology screen, so a user cross-checking
    against IEA or their own supplier finds the number explained
    rather than hidden. Superset of this requirement is rule 23 /
    section 6.
20. **Gas boundary disclosure:** combustion only; DEFRA's WTT
    term (~+17%) excluded for parity with transport.
21. **Confidence sublabels are for `low` entries only**, which
    today means `standby` alone. **The oven does not carry one**
    (owner call, 2026-08-29). The earlier version of this rule
    called it "the only shipped entry with no tier-1 primary
    figure", and that premise was wrong: the oven ships at
    `medium` on Commission Regulation (EU) No 66/2014 Annex II,
    which is tier-1. Its EU-to-US proxy caveat lives in its
    `calculation_notes` and its science sheet, not in a sublabel
    the data does not support.
22. **Tie-cluster sort rule:** stable secondary sort
    (alphabetical) so tie-cluster items do not jitter.
23. **Regionalisation disclosure -- full draft copy in section 6.**
    The methodology must state that per-country grid factors were
    considered and not shipped, show the size of the regional
    spread with real numbers, and name the three things done
    instead. Do not let this read as an apology; the
    within-carrier invariance is a genuinely strong answer.
24. **Avoided-emissions caveat must appear on the methodology
    screen.** The secondhand actions (`used_car_purchase`,
    `secondhand_clothing`, `use_library`) score counterfactual
    decisions, not inventory shares of a physical object, so two
    people crediting the same avoided manufacture is coherent --
    but **summing** those credits is not, because the
    manufacturing happened once. The screen must say so. Stored as
    `notes.avoided_emissions_caveat` in the actions database;
    reasoning in
    [RESEARCH_ENERGY_ARCHIVE.md](./RESEARCH_ENERGY_ARCHIVE.md)
    section 9.
25. **Lighting copy must name the bulb.** `turn_off_lights` ships
    on the 8.5 W LED (15 g for 4 h). A user still on incandescents
    saves about **110 g** for the same four hours, and the
    methodology sheet must say so rather than letting the LED
    figure read as universal.
26. **The ratio leads, the gram figure follows** (E7). Every
    comparison headline and every ranked row states a multiple
    first. The gram figure sits smaller on the row, with its basis
    stated once at the foot of the screen: "world-average grid,
    458 g CO2e/kWh, Ember 2025 data". Two honest fallbacks keep
    the gram-delta sentence instead (2026-08-30): a zero-kWh
    winner (line drying has no multiple), and a mixed-carrier
    routine pair (gas and electricity present on both sides) --
    its kWh multiple is invariant but is not a CO2e multiple, and
    its CO2e multiple moves with the grid, so there is no
    invariant multiple to state. In both fallbacks the basis note
    states the grid vintage alone: the "holds on any grid" clause
    ships only where a multiple is on screen, and in the
    mixed-carrier case it would be false.
27. **The ratio anchor is a dataset entry, never an equivalency
    constant** -- see the kWh rule in section 2. If the anchor ever
    moves off `phone_charge`, it moves to another row of
    `energy_behaviors.json`, never to `impact_equivalencies.json`.
    The anchor applies to electricity deltas only: a gas kWh is
    fuel input (RESEARCH sec 6 pin 1), so a gas delta is never
    converted to phone charges.
28. **A ranked view ranks ENERGY, and every carrier is in it**
    (revised 2026-09-02; was "single-carrier, gas never ranked").
    What a ranked list orders is the kWh one typical use costs,
    because that is the part a habit decides and the part that
    barely moves over a decade; how clean a kWh is belongs to the
    grid, differs by country and improves every year. Two things
    follow, and both are mandatory. The list carries **no gram
    figures at all** -- a grid-dependent number beside an
    energy-ranked row contradicts the order it sits in, so grams
    live in the row's own sheet, priced on that row's carrier.
    And the gas note ships under every copy of the list, and again
    in each gas row's sheet, because a gas water heater uses more
    energy than an electric one for the same bath yet emits less
    on today's world-average grid -- below about 241 g CO2e/kWh
    that flips. Rule 27's anchor is unchanged: the multiple is an
    energy ratio against a dataset row, so it holds for gas rows
    too. The **quiz** keeps gas out (section 8): it asks which has
    the bigger footprint, which is the emissions question this
    rule declines to rank on.

---

## 6. Methodology Screen Copy

Draft EN copy for the home-energy methodology screen, implementing
rule 23. **JA and ES must be written natively, not translated** --
the JP version should reference クールビズ-era energy-saving
framing and Japan's own 429 g/kWh figure directly, because a JP
reader will already know their grid is dirtier than the EU's.

All figures below are live-verified: the regional grid values come
from the E1 survey in
[RESEARCH_ENERGY_ARCHIVE.md](./RESEARCH_ENERGY_ARCHIVE.md)
section 2, and the dataset arithmetic they scale is recomputed in
that document's section 8 (`ENERGY_LOGIC_CHECK`). If the
[PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md) work
later recommends shipping regional factors, this screen is the
first thing that must change.

---

**Why one number for the whole world?**

Electricity is not equally clean everywhere. The same tumble-dryer
load costs about **0.6 kg** of CO2e on the UK grid, **1.9 kg** in
Japan and **3.1 kg** in India -- a five-fold spread for an
identical action. Charging an electric car for 100 km ranges from
about **2.5 kg** to **13 kg** the same way. Where your electricity
comes from -- solar, wind and nuclear, or coal -- can matter as
much as what you do with it.

We considered shipping a separate factor for every country. We
decided not to, and it is worth being straight about why.

To be genuinely accurate we would need to know your country, your
region or utility within it (a single US average hides a
26-subregion spread), and ideally the time of day you used the
power, because a grid running on midday solar is far cleaner than
the same grid at evening peak. All of those numbers move: the UK's
official factor fell **26% in one annual release**. Maintaining a
hundred figures that each go stale on their own schedule is a good
way to be confidently wrong in a hundred places instead of
honestly approximate in one.

So we did three things instead.

**One clearly-dated global figure.** We use 458 g CO2e per kWh,
the 2025 world average published by Ember. You can see its
vintage right here, and we will say plainly that it is too high
for the UK or France and too low for India or Poland.

**Comparisons that are right for everyone.** Nearly every
comparison in this calculator is between two things that run on
the same kind of energy -- a bath against a shower, a tumble dryer
against a washing line, a hot wash against a cold one. In those
cases the grid factor cancels out entirely. A bath costs
**2.3 times** a ten-minute shower whether you are in Glasgow,
Tokyo or Delhi. The absolute numbers shift with your grid; the
comparison does not.

**No verdict where your grid decides the answer.** Gas against
electricity is the one comparison that genuinely flips. Below
about **241 g CO2e per kWh**, electric water heating beats gas;
above it, gas wins. The UK is already below that line. Japan is
well above it. So we show you both numbers and refuse to declare a
winner, because the honest answer depends on where you live, not
on what you did.

If you want to check your own grid, your electricity supplier or
your government's energy statistics publish it -- compare it with
the 458 above and you will know which way our numbers lean for
you.

---

Supporting arithmetic (for the implementation PR; do not print all
of this on the screen):

| Grid | g CO2e/kWh | Dryer load (4.5 kWh) | EV 100 km (18.8 kWh) | Bath:shower ratio |
|------|----------:|---------------------:|---------------------:|------------------:|
| UK, DEFRA 2026 | 131 | 0.59 kg | 2.46 kg | 2.29x |
| EU average, IEA 2025 | 170 | 0.77 kg | 3.20 kg | 2.29x |
| Japan, METI | 429 | 1.93 kg | 8.07 kg | 2.29x |
| **World, Ember 2025 (shipped)** | **458** | **2.06 kg** | **8.61 kg** | **2.29x** |
| China, IEA 2025 | 530 | 2.38 kg | 9.96 kg | 2.29x |
| India, IEA 2025 | 695 | 3.13 kg | 13.07 kg | 2.29x |

The constant ratio column is the whole argument: a 5.3x spread in
absolute terms, zero spread in the comparison the feature exists
to make.

Two copy cautions:

- **Do not quote time-of-day or marginal-intensity numbers.** The
  qualitative point (midday solar is cleaner than evening peak) is
  uncontroversial and safe; the specific figures found during
  research were search-only, never confirmed against a primary,
  and so may not be printed. Recorded in
  [RESEARCH_ENERGY_ARCHIVE.md](./RESEARCH_ENERGY_ARCHIVE.md)
  section 1.
- **The EV example belongs to the transport dataset**, which does
  not currently gate cross-carrier comparisons the way this one
  does. Using it here is fine as an illustration of grid spread,
  but do not imply the transport calculator applies the same
  no-verdict rule -- it does not yet. Flagged in
  [PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md)
  section 1.2.

---
---

## 7. Verification (every pass)

- `flutter analyze` -- zero issues.
- `dart run build_runner build` after model changes (generated
  files are committed).
- `flutter test` -- full suite; read summaries with
  `... | tr '\r' '\n' | tail`.
- Scoped gate before moving on after any dataset value change:
  `flutter test test/features/energy`, with the
  [RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) section 6 pins green.
  Those pins are data pins, not truth claims -- several are thin
  by design and must be re-derived, never assumed.
- Cross-dataset pin: `grid_factor_g_per_kwh` identical in
  `transport_modes.json` and `energy_behaviors.json`.
- Every new or changed source quote re-verified LIVE before
  pasting. A figure seen only in a search-engine summary may not
  enter `sources[]`.
- [APP_PAGES.md](./APP_PAGES.md) updated in the same PR as any
  route or screen change (standing rule).
- Do NOT commit or push -- owner reviews the working tree.

---

## 8. Review Record -- 2026-08-08 to 2026-08-30

Documentation, data-consistency and product passes; shipped values
changed only where recorded below.

Three passes, all executed. Detail for the first two in
[RESEARCH_ENERGY_ARCHIVE.md](./RESEARCH_ENERGY_ARCHIVE.md)
section 9; only the outcomes are recorded here.

**2026-08-08/09 -- documentation and data consistency.** Closed
電気カーペット as a deliberate non-entry; split 525 lines of executed
detail out of RESEARCH_ENERGY.md into the archive; fixed both test
failures from the E1 grid rebase; corrected the food tier actions
to bind to the *minimum* covered item (`skip_high_impact_food`
6800 -> 3700, `skip_medium_impact_food` 1000 -> 780, owner call --
**do not restore the higher figures**); and swept
`calculation_notes` across all 94 actions then shipping, repairing
eight notes that described a different action and re-deriving
seven values from live-fetched primaries. Nothing in the split
changed a shipped number.

**2026-08-29 -- sourcing and archivings.** Backfilled `sources[]`
and `confidence` for seven rebased actions, transcribed from
primaries already live-verified in
[RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) sections 1 and 3; no
value moved. Settled the unsourced 40 W bulb by archiving
`use_natural_light` (it overlapped `turn_off_lights`, and its
daylight basis is unknowable to the app) and re-basing
`turn_off_lights` onto the researched 8.5 W LED, 70 -> 15 g,
points 3 -> 2. Archived `full_laundry_load` for having no
definitive answer. **Every energy action now carries sources and a
confidence.**

Two food-side items surfaced by that sweep were **moved
2026-08-30** to
[PDR_FOOD_CALCULATOR.md](./PDR_FOOD_CALCULATOR.md) section 6, the
single live open list for the food dataset: `skip_fish` shipping
without sources, and `skip_food_delivery` shipping at 0 g.

**2026-08-30 -- product review of the built feature.** First
review since the code landed; **no shipped value moved**.

- **Maintenance cost was overstated and is withdrawn.** The
  dataset carries no precomputed CO2 field -- only `kwh_per_unit`,
  which is physics and does not move with the grid, and 0 of 33
  behaviours mention 458 in their text. A grid refresh edits 2
  metadata values, ~4 test assertions, and the 12 grid-derived
  actions in `co2_actions_database.json` plus a re-seed. Every one
  of those is already enumerated in
  [ANNUAL_RESEARCH_UPDATE.json](./ANNUAL_RESEARCH_UPDATE.json)
  `grid_factor`, which also names the re-seed command, the EN/JA/ES
  methodology-copy refresh and `next_check: 2027-04`. Vintage is
  stated in the ledger, in the dataset metadata
  `grid_factor_source`, and on screen by rule 19. Priced work on a
  dated pass, not a risk.
- **E7 decided** (section 2), with two derived rules: single-carrier
  ranking, and ratios computed in kWh rather than from the
  equivalency helpers.
- **The gate's real pass rate was measured at 5.9%** of admissible
  pairs (section 3), which opens E8 below. Two dataset holes
  recorded there.
- **Five ledger rows were stale, not one:** `grid_factor`,
  `gas_factor`, `energy_appliance_averages`, `energy_meti_measured`
  and `energy_standby` all still annotated
  `data/app/energy_behaviors.json` as `(pending build)` after it
  shipped in 823f984. All five annotations cleared 2026-08-30.

**2026-08-30 -- build pass.** Executed the decisions above in one
working-tree pass: the `fan` entry (dataset regenerated to 34),
the E7 ratio-led result rework (with rule 26's two fallbacks and
rule 27's electricity-only anchor), the 8.16 methodology screen
with the reusable ranked table, 8.17's route and entry points,
and the section 9 closures recorded there. Section 1 carries the
item-by-item record; `flutter analyze` clean and the full suite
green at the end of the pass. Manually verified on the iOS
simulator 2026-08-31 (both screens driven against the shipped
dataset via a throwaway entrypoint, no Firebase): the E7 ratio
card, the fan-vs-aircon verdict (7.6x, 10 phone charges), the
category-error and crossover refusal dialogs, the ranked table's
ordering and unranked gas section, and the data-derived source
list including the fan's Panasonic citation. One defect found and
fixed in the same pass: hour/minute/day quantity labels read
"1 hours" at exactly one unit -- singular keys added in all three
locales, pinned by a test.

### Open decisions

**E8 (primary surface) -- RESOLVED 2026-09-01. History first,
then the call.**

**Provisionally resolved 2026-08-30: ship both surfaces, then
compare them in the app.** The comparator
is built and its gating is correct, and it refuses 94% of the
pairs a user can assemble in it (section 3). The question was
whether the free-form two-column builder should be the primary
surface at all, or whether **"Where your energy goes"** -- the
ranked, single-carrier, ratio-led view sketched as a methodology
bullet in PLAN_PHASE_8 8.16 ("Where the heat is") -- should lead,
with the comparator demoted to a secondary view seeded from a
tapped row. (Seeding from a row confines it to within-group by
construction, which makes condition 1 unreachable and removes the
modal refusal.)

Owner call: build both now. The comparator is the routed primary;
the ranked table ships inside the methodology screen, built as a
standalone reusable widget so promoting it later is cheap. The
final surface decision stays with E8 and is made by a thorough
in-app comparison once both have landed, judged on: first-contact
experience (how often realistic free-form pairs refuse a verdict,
against how the ranked table reads on first open),
discoverability of the teaching content two taps deep, whether
row-seeding the comparator is worth building, and the cost of
promotion if the ranked view wins. Nothing is deleted either way:
the dataset, the engine, the carrier gate and the 20% bar all
survive both outcomes. **8.17 is unblocked and routes to the
comparator.**

**RESOLVED 2026-09-01: promote the ranked view to its own
surface, and add a quiz beside it.** The in-app comparison was
run. The ranked table won on first contact and lost badly on
discoverability: two taps deep behind the methodology screen's
science icon and then a scroll, it was hard to find, and as 34
flat unadorned rows spanning an 885x range it was hard to read.
Neither finding argues for demoting the comparator, which teaches
a different thing (substitution) and refuses honestly when it
cannot. So the ranked table is promoted to `/energy-explore`,
with `anchorId` / `showBars` / `showHeading` / `onRowTap` added to
the same widget rather than a fork, so rules 26-28 stay enforced
in one place and the methodology screen keeps its defaults. It
gains the two things a static table could not do: switching the
measuring baseline between four dataset rows (LED hour, phone
charge, kettle litre, fan hour -- all rule 27 anchors), and a
per-row slider whose live figures fill an animated wall of
baseline icons. A second surface, `/quiz`, plays
higher-or-lower over the same rows on the comparator's own 20%
bar (`verdictMinPercent`), with gas never dealt (rule 28) and
line drying's zero dealable because it holds on any grid.
Row-seeding the comparator was not built: the explore sheet
answers the what-if question in place. Both surfaces are entered from
AppBar icons on the Log Action screen beside the calculator chooser,
visible in every category rather than as energy-category tiles: neither
is an action to log, and burying them was the problem being fixed
(owner call 2026-09-02, after a first pass shipped them as three
category tiles). The same reasoning then took the comparator's own
"Compare home energy use" card out of that grid: the Action Log grid is
for actions that can be logged, and nothing in this feature can be
(8.18), so all three energy surfaces are now AppBar-only -- the
calculator inside the chooser sheet, the two teaching surfaces beside
it (owner call 2026-09-02). The what-if wall draws one icon per baseline and the
whole count, letting the sheet scroll, with the icons shrinking by
order of magnitude; a first pass scaled icons-per-glyph to the current
slider value, which held the icon count near constant so the wall never
appeared to move (owner call 2026-09-02). Bars use a square-root
scale, which is a deliberate distortion and so carries a
mandatory footnote. Both new surfaces award nothing, log nothing
and persist nothing beyond the session best streak (decision
8.18).

**Cross-domain multiples are ruled out, permanently.** A food or
transport figure is never stated as a multiple of an electricity
row (never "a burger in phone charges"), and quiz decks are never
mixed across domains. Two reasons, in order of weight. Food
counts a lifecycle where this dataset counts operational use, so
mixing them is a one-way scope bias rather than symmetric noise,
and both datasets' metadata already says figures from different
calculators must never be summed. And a food-to-electricity ratio
inherits grid variance linearly (about a 16x swing between a
low-carbon and a coal-heavy grid) where a within-electricity
ratio is exactly grid-invariant. A multiple is shown only where
it holds. Cross-domain contact stays at the grams level, where
`data/app/impact_equivalencies.json` already lives with a
surfaced caveat. The quiz deck model
(`lib/shared/domain/quiz_deck.dart`) is domain-generic so food
and transport decks can be added later, each self-consistent
within itself.

E1-E7 are settled (Appendix A). `full_laundry_load`'s record and
[archive](./RESEARCH_ENERGY_ARCHIVE.md) 1 carry the retired
arithmetic and the condition for restoring it.

**11 actions carry `category: "energy"`** after the two archivings
and every one carries `sources[]` and a confidence. Phase 8.13
research and the decisions here are complete; the feature is
built, and what remains is the section 1 build list (8.16
remainder, the E7 rework, `fan`, 8.17) and the E8 in-app
comparison after it lands.

---

## 9. Open Items -- test debt

**This is the live open list for the energy workstream**, opened
2026-08-30 after a coverage pass over the suite that shipped in
823f984. Nothing below changes a value. Section 8 carries the open
*decisions* (E8); this carries the open *work*. Eleven items were
closed in the 2026-08-30/31 build pass and moved to
[archive](./RESEARCH_ENERGY_ARCHIVE.md) section 10 (standing
rule: closed items move to the archive); one remains:

- [ ] `ENERGY_BEHAVIOR_COUNT` is asserted in three files
      (`energy_behaviors_data_test.dart`,
      `energy_exact_values_test.dart`,
      `energy_behaviors_loader_test.dart`). One is the loader's
      job. Related fourth copy: the generator's
      `EXPECTED_BEHAVIORS` must move in lockstep (its own error
      message says so), and no test ties the two constants
      together.

---

## Appendix A: Decision History

| Date | Decision | Detail |
|------|----------|--------|
| 2026-08-02 | E1 grid factor 386 -> 458 g CO2e/kWh (Ember GER 2026, CO2e) after a three-way adversarial review; regionalisation spun out | RESEARCH sec 1; [PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md) |
| 2026-08-02 | E2 gas combustion-only Gross CV 182 g/kWh; comparison gating adopted | sec 3 here |
| 2026-08-02 | E3 electric water heating ships resistance AND heat pump, not an average | RESEARCH sec 3.1 |
| 2026-08-02 | E4 shower flow 7.844784 L/min, mean of current products only | RESEARCH sec 3.1 |
| 2026-08-02 | E5 kerosene researched, not shipped; appears as one row of the methodology heating hierarchy | RESEARCH sec 3.3 |
| 2026-08-02 | E6 three verbatim Bosch wash temperatures (20/40/60 C) instead of a 30 C entry | RESEARCH sec 3.2 |
| 2026-08-02 | No energy logging bridge, permanently -- not deferred | sec 4 here; [PLAN_PHASE_8.md](./PLAN_PHASE_8.md) 8.18 |
| 2026-08-02 | Setpoint actions are state-based (クールビズ / ウォームビズ) and split summer/winter | sec 4 here |
| 2026-08-02 | Hot-water delta-T 30 -> 27.2 K; gas efficiency restated on a Gross-CV basis | RESEARCH sec 3.1; the calorific-basis rule is sec 2 here |
| 2026-08-02 | Action stores merged into one source of truth; seeder reads the JSON | sec 4 here |
| 2026-08-02 | Energy actions rebased to research values rather than rescaled (owner call) | sec 4 here |
| 2026-08-02 | 'US DOE 3% per degree' citation corrected -- DOE does not state it | sec 4 here |
| 2026-08-02 | UK gas central heating researched; ships as methodology context, not an entry | RESEARCH sec 3.3 |
| 2026-08-02 | `phoneCharges` 8 g stands (EPA basis, not drift) | ledger `known_drift` |
| 2026-08-29 | `sources[]` and `confidence` backfilled for seven rebased actions, transcribed from primaries already live-verified in RESEARCH sec 1 and 3; no value moved | sec 8 here |
| 2026-08-29 | `use_natural_light` demoted to `research_only_records` -- overlapped `turn_off_lights` and its daylight basis is unknowable to the app (owner call) | sec 8 here |
| 2026-08-29 | `turn_off_lights` re-based off the unsourced 40 W bulb onto the researched 8.5 W LED: 70 -> 15 g, points 3 -> 2 | sec 8 here |
| 2026-08-29 | `full_laundry_load` archived to `research_only_records` -- no current definitive answer, and the evidence base cannot supply one (owner call) | archive sec 1 |
| 2026-08-30 | E7 headline unit: the grid-invariant ratio leads, grams are subordinate and vintage-labelled | sec 2 here; sec 5 rules 26-28 |
| 2026-08-30 | Ranked views are single-carrier -- a gas row's position moves with the grid, an electric row's does not | sec 2 here |
| 2026-08-30 | Ratios computed in kWh against a dataset entry, never from `impact_equivalencies.json` | sec 2 here |
| 2026-08-30 | Maintenance-cost critique withdrawn: the fan-out is fully enumerated in the ledger and the dataset stores no precomputed CO2 | sec 8 here |
| 2026-08-30 | E8 OPENED: comparator vs ranked view as the primary surface; 8.17 blocked on it | sec 8 here |
| 2026-08-30 | E8 PROVISIONALLY RESOLVED: ship both surfaces -- comparator primary, ranked table in the methodology screen as a reusable widget; final surface decided by an in-app comparison once both land | sec 8 here |
| 2026-08-30 | `fan` added to `space_cool` (0.022 kWh/h, Panasonic F-CV339, the `use_fan_instead_of_ac` source); pairs the singleton | sec 3 here |
| 2026-08-30 | Self-comparison documented as intended -- preset-driven same-entry comparison carries the setpoint and shower-length lessons | sec 3 here |
| 2026-08-30 | Shared dataset-assertion helper rejected -- only food and transport are twins; energy's source rule is the inverse of theirs | sec 9 here |
| 2026-09-01 | E8 RESOLVED: ranked view promoted to `/energy-explore` (baseline switching, sqrt bars, per-row what-if sheet), higher-or-lower quiz added at `/quiz`, comparator stays the routed primary | sec 8 here |
| 2026-09-01 | Cross-domain multiples and mixed quiz decks ruled out permanently -- lifecycle-vs-operational scope bias plus linear grid dependence; cross-domain contact stays at the grams level | sec 8 here |
| 2026-09-02 | E8 entry points: AppBar icons beside the calculator chooser, visible in every category, not energy-category tiles -- neither surface is an action to log | sec 8 here |
| 2026-09-02 | What-if wall draws one icon per baseline and the full count (sheet scrolls, icons shrink by order of magnitude); per-value step scaling rejected -- it held the icon count constant so the wall never moved | sec 8 here |
| 2026-09-02 | "Compare home energy use" card removed from the Action Log grid -- that grid is for loggable actions and this calculator banks nothing (8.18); reached from the AppBar chooser only | sec 8 here |
| 2026-09-02 | Quiz rounds rotate between energy, food and transport; a PAIR is still never cross-domain, so the E8 rule stands unchanged. Each deck drops what it cannot rank: gas rows, food tier-2 rows, per-vehicle transport modes | sec 8 here |
| 2026-09-02 | Quiz shows no figures until the answer is in, and is answered by dragging one of two tokens on a shared wheel rather than Higher/Lower buttons | sec 8 here |
| 2026-09-02 | Verdict refusal states its reason inline under a heading-sized title; the "Why not?" dialog is gone | sec 5 rule 26 here |
| 2026-09-02 | Category colours carry through the calculator chooser tiles, the comparison bars and the quiz tokens | sec 5 here |
| 2026-09-02 | Quiz moved out of the energy feature to `lib/features/quiz/` and routed at `/quiz` -- it draws on all three datasets, not just energy | sec 8 here |
| 2026-09-02 | Every calculator accent is its own category colour, not the mascot-seeded primary; fills use it raw, body text a 4.5:1 tone of the same hue, and large text plus graphics a more vivid 3:1 tone (all pinned by tests) | sec 5 here |
| 2026-09-02 | Rule 28 REVISED: the ranked list orders energy and includes gas; habits decide kWh, grids decide gram-per-kWh and are cleaning up fast, so the list ranks what the user controls | sec 5 rule 28 here |
| 2026-09-02 | Gram figures removed from ranked rows entirely -- a grid-dependent number beside an energy-ranked row contradicts its own order; grams stay in the row's sheet on that row's carrier | sec 5 rule 28 here |
| 2026-09-02 | `washup_electric` and `washup_gas` withdrawn: one figure cannot stand for technique that ranges from a cold bucket to a running hot tap (owner call). The dishwasher pair keeps its own eco-vs-normal comparison | sec 3 here |
| 2026-09-02 | `rice_keepwarm` rebased as `rice_cook_keepwarm`, one cycle + 4 h holding = 0.226 kWh: holding never happens without a cycle, and alone it ranked below the cycle and read as the cheaper option | sec 3 here |
| 2026-09-02 | Dryer entries renamed to name the same axis (conventional vs heat pump); both are electric, so "(electric)" would have been the wrong contrast. Water entries read "(electric/gas/heat-pump hot water)" | sec 3 here |
| 2026-09-02 | Quiz tokens stay upright and settle as a non-overlapping vertical stack: the wheel is an ellipse whose vertical radius is a measured token height, and a quarter turn is the whole travel | sec 8 here |

## Appendix B: Where the Detail Went

Split out of [RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) on
2026-08-02: the research doc is the evidence base, this PDR carries
the decisions and product rules, and
[RESEARCH_ENERGY_ARCHIVE.md](./RESEARCH_ENERGY_ARCHIVE.md) holds
everything executed. Nothing was discarded.

