# PDR: Phase 8 Home Energy Calculator -- Post-Design Review

**Created:** 2026-08-02
**Status:** Research complete and cleared to build from
([RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) v2.0, 33 behaviors,
every open item closed). No code written yet. Owner decisions
E1-E6 are settled, as are two product decisions (no logging
bridge; comparison gating). Nothing committed.
**Purpose:** The working record a fresh session reads to build the
feature -- standing decisions and why, the product rules, the
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

**Already applied to the working tree (uncommitted):**

- `data/app/transport_modes.json` -- E1 rebase: grid factor
  386 -> 458, `car_bev` 73 -> 86, `escooter_private` 6 -> 7
  (`ebike` holds at 2). No `386` remains in the file.
- `data/seed/co2_actions_database.json` -- rebuilt as the single
  source of truth: 94 shipping actions, 13 energy/transport values
  rebased, 1 new action, 11 research-only records preserved
  (section 4).
- `scripts/seed/seed_action_library.js` -- rewritten to read that
  JSON; 2,471 -> 253 lines.
- `data/app/impact_equivalencies.json` -- `burgers` 11000 -> 7951.
- `Plan/AUDIT_ACTION_DATA.md` section 8 -- grid factor and the
  retired derivation.

**Not yet done -- re-seed.** `npm run seed` writes the 94 actions
to Firestore and prunes orphans. The change adds one id
(`heat_person_not_room`) and removes none, so nothing existing is
deleted. Bundle with the outstanding food FR-22 re-seed; needs
`scripts/serviceAccountKey.json`.

**Still to be built (nothing exists in `lib/`):**

- `data/app/energy_behaviors.json` -- 33 behaviors, cited factors,
  `comparable_group` field, EN/JA/ES
- `lib/features/energy/` -- models, loader, calculator, routine
  builder, comparison, methodology screens
- `test/features/energy/` -- dataset validation, engine, sanity
  pins, cross-dataset grid-factor pin, widgets, l10n

**What this feature is for**, settled, and it is not what Parts 1
and 2 are for: transport and food are decision tools that teach.
**Energy is a teaching tool that occasionally informs a
decision.** Its unit is the behavior, never the product.
Entry-point weighting follows -- the Impact-segment card matters
more than the Action Log banner.

---

## 2. Standing Decisions (live rules -- read before touching data)

Owner-approved. The warnings exist because earlier drafts said
otherwise; do not "fix" values backwards from superseded text.

- **E1 (grid factor) -- RESOLVED 2026-08-02: ship Ember 458 g
  CO2e/kWh.** Rationale: the app is denominated in CO2e
  throughout (food is CO2e, transport is CO2e-with-RF), so a
  CO2-only anchor would be a scope mismatch -- the D1 defect.
  IEA's 435 (Electricity 2026, 2025 data) and Ember's 458 are now
  the *same vintage*, so the 5.3% gap between them is purely
  CO2e-vs-CO2 scope, and 458 is the scope-correct half of the
  pair. Do NOT average the two. Applies across
  `transport_modes.json`, `co2_actions_database.json` and this
  dataset in one PR; the old 386 was 16% low and its documented
  derivation did not reproduce it. Blast radius: transport EV
  0.188 kWh/km x 458 = **86 g/km** (was 73); five actions in
  `co2_actions_database.json` (section 7); points move **+7.08%
  uniformly** and often 0 after integer rounding, because the
  seeder uses `co2Grams^0.4` (CO2_EXPONENT = 0.4), not a log --
  and `(co2 x r)^0.4 = co2^0.4 x r^0.4`, so the ratio is
  size-independent. Food is untouched. Re-seed required. Two
  cross-carrier orderings flipped as predicted (kettle vs gas
  hob; hand-wash-gas vs dishwasher); **both are blocked from copy
  by the section 2.2 gating**, which is what that rule is for.
  **Regionalisation is NOT part of E1** -- it is spun out as its
  own scoped work item, see
  [PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md).
- **E2 (gas boundary + comparison gating) -- APPLIED.** Gas ships
  combustion-only Gross CV at 182 g/kWh. Comparison gating ships
  as `comparable_group` + same-carrier + 20% delta (section 2.2).
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

Groups (33 entries): `hot_water` (5) · `dishes` (4) ·
`laundry_wash` (3) · `laundry_dry` (3) · `space_heat` (4) ·
`space_cool` (1) · `boil` (3) · `cook` (4) · `lighting` (2) ·
`device` (4).

Checked against the never-pin list in section 6: kettle vs gas
hob fails #2; hand-wash-gas vs dishwasher fails #2; kettle vs IH
fails #3; wash load vs dishwasher fails #1; aircon cooling vs
heating fails #1; laptop vs incandescent fails #1; oven vs
portable electric heater fails #1. All covered.

**This gating earned its keep at E1.** Both cross-carrier
orderings did flip when the factor moved 386 -> 458 -- the kettle
went from 12.6% below the gas hob to 3.6% above it, and the
dishwasher went from 9% below a gas-heated sink to 8% above it.
Rule #2 blocked both from generating copy, so the rebase changed
no user-facing claim. This is the concrete case for keeping the
gating even though it looks like belt-and-braces.

Users may still build and compare any two routines they like --
the gating governs what the **app asserts**, not what the user
may look at.

---

---

## 4. Action Library (single source of truth)

**Restructured 2026-08-02.** There were two action stores that had
silently diverged: `data/seed/co2_actions_database.json` (28
research records) and an inline 93-action array inside
`scripts/seed/seed_action_library.js` (what actually shipped).
They shared only **9 ids**. The energy spec drafted from the
research file would have double-counted four behaviours that
already shipped under different names.

Now:

- **`data/seed/co2_actions_database.json` is the single source of
  truth** -- 94 shipping actions, each with its CO2 value,
  calculation notes, research `sources[]`, confidence, localised
  strings and effort/frequency/impact scores.
- **`seed_action_library.js` reads it** and computes points at
  seed time via `computePoints()`. It no longer carries action
  data; the file went from 2,471 lines to 253.
- Research-only records with no shipping action (the
  transport-mode swaps now handled by the transport calculator's
  logging bridge, plus three never-shipped items) are preserved
  under `research_only_records` and are explicitly **not seeded**.
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

| Action | Was | Now | Points | Basis |
|--------|----:|----:|-------:|-------|
| `air_dry_clothes` | 1700 | **2000** | 21 | `dryer_vented` 4.5 kWh |
| `cold_wash` | 600 | **430** | 10 | Bosch 40 C - 20 C = 0.950 kWh |
| `shorter_shower` | 230 | **110** | 5 | 2 min x 59 g/min gas floor |
| `shorter_bath` | 450 | **770** | 11 | bath_gas - 10-min shower_gas |
| `unplug_devices` | 45 | **25** | 2 | 5 devices x 0.5 W (LBNL) |
| `install_led_bulb` | 28000 | **25000** | 63 | 51.5 W x 3 h/day x 365 |
| `lower_thermostat` | 450 | **140** | 6 | METI 53.08 kWh/yr per 1 C |
| `raise_ac_thermostat` | 350 | **120** | 6 | METI 30.24 kWh/yr per 1 C |
| `turn_off_lights` | 60 | **70** | 3 | grid rebase only |
| `use_natural_light` | 90 | **100** | 4 | grid rebase only |
| `eco_mode_appliance` | 200 | **120** | 6 | dishwasher normal - eco |
| `microwave_vs_oven` | 300 | **280** | 7 | oven 0.82 - microwave 0.19 |
| `ev_charging_green` | 3500 | **4500** | 31 | grid rebase only |
| `heat_person_not_room` | -- | **1900** | 18 | **NEW**; heater 1.2 - kotatsu 0.15, 4 h |

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

**Still to do:** re-seed
(`node scripts/seed/seed_action_library.js`, needs the Firebase
service account), bundled with the outstanding food FR-22 re-seed.

---

## 5. UI / Copy Requirements

Requirements, not suggestions.

1. **Comparison gating (section 2.2) is implemented in code, not
   in copy discipline:** same `comparable_group`, same `carrier`,
   delta >= 20%. Everything below assumes it.
2. **The kettle-vs-IH tie is a feature.** When a comparison
   resolves to a tie, say so plainly ("these are the same -- here
   is what actually moves the needle") and surface the nearest
   heat entry.
3. **Every carrier is named in the UI.** Entry names carry
   "(electric water)" / "(gas water)" / "(heat-pump water)".
4. **The electric-vs-gas crossover ships in the methodology**
   (section 2.1), including the 241 g/kWh figure and the fact
   that the UK has already crossed it. Never imply gas is
   universally cleaner.
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
    (aircon 93 / gas 179 / kerosene 243 / resistance 463 g per
    hour), because showing kerosene alone would read as an
    endorsement.
13. **Rice-cooker keep-warm carries the 4-hour rule** verbatim
    from 家電製品協会.
14. **Standby copy must debunk correctly**, quoting LBNL: per
    -device draw collapsed from 1-3 W to ~0.5 W while device
    counts rose faster, leaving "approximately the same amount of
    standby energy but now dispersed over many more products".
    Not "standby is trivial", not "standby is 10% of your bill".
15. **Small loads are never rounded up.** A phone charge is 5.9 g.
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
    section 8.1.
20. **Gas boundary disclosure:** combustion only; DEFRA's WTT
    term (~+17%) excluded for parity with transport.
21. **Oven carries a low-confidence sublabel** -- now the only
    shipped entry with no tier-1 primary figure.
22. **Tie-cluster sort rule:** stable secondary sort
    (alphabetical) so tie-cluster items do not jitter.
23. **Regionalisation disclosure -- full draft copy in 8.1.** The
    methodology must state that per-country grid factors were
    considered and not shipped, show the size of the regional
    spread with real numbers, and name the three things done
    instead. Do not let this read as an apology; the
    within-carrier invariance is a genuinely strong answer.

---

## 6. Methodology Screen Copy

Draft EN copy for the home-energy methodology screen, implementing
rule 23. **JA and ES must be written natively, not translated** --
the JP version should reference クールビズ-era energy-saving
framing and Japan's own 429 g/kWh figure directly, because a JP
reader will already know their grid is dirtier than the EU's.

All figures below are live-verified (section 1) and recomputed in
section 10. If the
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
  research were search-only and are not citable (open item 9.1).
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

## 8. Session Handover -- 2026-08-08

Documentation-only session. No code, no dataset values, no
committed changes. Working tree left dirty for owner review.

### What landed

| Change | File |
|--------|------|
| 電気カーペット closed as a deliberate non-entry. Panasonic's comparison table publishes per-setting 消費電力量 in Wh (3畳 DC-3NK 470/335, DC-3HA 460/320; 2畳 335/230; 1畳 165/120), cross-checked against the DC-3NK spec page's 14.6/10.4 yen at 31 yen/kWh. 中 = ~0.33 kWh/h. Stays folded into `heat_person_not_room`; its arithmetic is unchanged. METI's 強->中 delta (0.2201) is ~60% above Panasonic's 0.135, so METI models higher-draw carpets: upper bound only. | RESEARCH archive 1 |
| Every closed item rewritten to one table row and moved out of the live doc. The last open follow-up is now closed, so section 8 is standing rules only. | RESEARCH sec 8, archive 1 |
| RESEARCH_ENERGY.md split 1604 -> 1214 lines; 525 lines of executed detail moved to [RESEARCH_ENERGY_ARCHIVE.md](./RESEARCH_ENERGY_ARCHIVE.md) (new, untracked). Blocks were moved by script, not retyped, and every source line was verified present in one file or the other. | both |
| Stale `v1.1` reference to the research doc corrected to `v2.0`. | sec 1 here |

Nothing in the split changed a shipped number. The archive holds
closed items, the E1 grid survey, superseded values, rejected
alternatives, the two researched non-entries (UK gas central
heating, refrigerator) and the full 38-item recomputation.

### Resolved after the handover was written

Both test failures below were fixed in this session, plus a
points-economy correction they exposed. Full suite: 1731 passing,
`flutter analyze` clean. Nothing committed.

- Transport metadata pin re-based 386 -> 458, with the three
  cosmetic stragglers (fixture string, UI fallback, sec 6 pin 5
  quoting the retired `car_bev` 73).
- Food actions re-pointed to their new ids. The merge had left
  each tier action crediting its tier's *highest* item, so
  `skip_high_impact_food` 6800 -> **3700** (binds to lamb 3772,
  not beef 6836) and `skip_medium_impact_food` 1000 -> **780**
  (binds to chicken 787, not pork 1031). Owner call 2026-08-08;
  -46% and -22% to shipped rewards, so the actionLibrary re-seed
  now carries these too.
- `skip_fish` `calculation_notes` replaced -- it carried the
  dryer action's `"4.5kWh dryer x 386g/kWh (US)"`.
- RESEARCH_FOOD sec 7 rewritten around the new action set, with
  the minimum-of-covered-items rule stated as a standing rule.

**Still open, food-side:** `skip_fish` has `sources: []` and
`confidence: null` while every sibling action carries both. Not
filled in here -- the values need live re-verification and the
food session owns that file.

### `calculation_notes` sweep, all 94 actions (2026-08-08)

The `skip_fish` note carrying the dryer's text was not isolated.
Seven more records hold a note that describes a different action,
found by matching notes shared across actions. These are
research-only fields (`seed_action_library.js` does not seed
them), so nothing user-facing was wrong -- but a false rationale
sitting next to a value is how a wrong number gets "confirmed" at
the next pass.

Repaired from committed research:

| Action | Was | Now |
|--------|-----|-----|
| `plant_milk` | `seasonal_produce`'s "avoids heated greenhouse produce" | full soy-binds-not-oat derivation (RESEARCH_FOOD sec 7) |
| `heat_person_not_room` | empty | (heater 1.2 - kotatsu 0.15) x 4 h x 458 = 1924 -> 1900 (RESEARCH_ENERGY sec 7) |
| `citizen_science_project`, `volunteer_nature_walk` | empty | sibling-style "indirect; not CO2-measurable" (both 0 g, no numeric claim) |

Seven more were marked `UNVERIFIED` and then **all re-derived
from live-fetched primaries on 2026-08-09**, each with source,
verbatim quote and URL now in its `sources[]`. No `UNVERIFIED`
marker remains. Deliberately shared notes were left alone: the
0 g advocacy and community actions share rationale text
legitimately ("ecological; not CO2-measurable").

| Action | Was | Now | Anchor |
|--------|----:|----:|--------|
| `use_fan_instead_of_ac` | 1200 | **600** | (aircon 0.167679 - Panasonic F-CV339 fan 0.022) x METI's own 9 h/day x 458 |
| `skip_food_delivery` | 600 | **0** | see below |
| `buy_local_produce` | 300 | **200** | OWID: 1 kg avocados Mexico -> UK = 0.21 kg CO2e of transport |
| `refuse_disposables` | 15 | **1** | binds to the smallest item it names: PP straw 0.0017 kg (Sustainability 14:14170) |
| `used_car_purchase` | 3000000 | **3000000** | ICCT 2025 Table 1, gasoline ICEV production 7.2 t; ships ~40% of it |
| `use_library` | 1000 | **1000** | BISG/Green Press 2008, 8.85 lb per average book |
| `secondhand_clothing` | 15000 | **15000** | Levi's 501 LCA: the 49% of 33.4 kg a buyer actually avoids = 16.3 kg |
| `walk_instead_drive` | 250 | **240** | 1.5 km x `car_petrol_avg` 162.72 = 244.08 |
| `bike_short_trip` | 490 | **480** | 3 km x 162.72 = 488.16 |
| `bike_medium_trip` | 1000 | **970** | 6 km x 162.72 = 976.32 |

The three transport actions cited a stale "164 g/km (DEFRA 2024)"
and all three rounded UP. They now use the 162.72 shipped in
`transport_modes.json` and round down.

**`skip_food_delivery` went to 0 g because the evidence runs the
other way.** Heard et al. 2019 (*Resources, Conservation and
Recycling*, peer-reviewed, fetched) finds delivered meal kits
beat grocery-store meals by 2.0 kg CO2e/meal, with last-mile
emissions **lower** for delivery (-0.45 kg CO2e/meal) -- a van
route amortizes across many drops, a store trip is one car.
Restaurant delivery is not the same system, but no primary
supports a saving for cooking at home, so the 600 g had no basis.
It ships as a 0 g habit prompt until a restaurant-delivery LCA
exists. **Candidate for removal -- owner call.**

### Avoided-manufacturing actions: the accounting rule

Owner question 2026-08-09: if A buys new and counts the
manufacturing, then sells to B and B counts it too, is that not
double counting?

**Not in this app's frame, but the question exposed a real bug.**
These are counterfactual claims -- each scores one decision
against what would otherwise have been produced -- not inventory
shares of a physical object's embodied carbon. A and B faced
separate buy-new decisions, so crediting both is coherent. What
is *not* coherent is summing them: the manufacturing happened
once, so the total is not a physical quantity of CO2 not emitted.
Recorded as `notes.avoided_emissions_caveat` in the actions
database, and the methodology screen must say it.

The bug: `used_car_purchase` had an arbitrary ~40% haircut on the
sourced 7.2 t while `secondhand_clothing` credited the full
avoided production. Same logic, two treatments, and the 40% had
no source. Both now credit the full figure on a stated
one-for-one displacement assumption, which is an **upper bound**
-- real markets displace less than one new unit per secondhand
purchase and no published rate exists to correct with.

| Action | Was | Now | Why |
|--------|----:|----:|-----|
| `used_car_purchase` | 3000000 | **7200000** | full ICCT 7.2 t; the 40% haircut is gone |
| `refuse_disposables` | 1 | **51** | re-scoped to cutlery (owner call); PS fork/spoon 0.0514 kg at 100% incineration |
| `secondhand_clothing` | 15000 | 15000 | unchanged; notes now lead with **DENIM BASIS** |
| `use_library` | 1000 | 1000 | unchanged, see below |

`refuse_disposables` also gets new user-facing copy in all three
locales ("Refuse Disposable Cutlery"). End-of-life sensitivity is
disclosed: incineration 51 g ships because Japan incinerates most
plastic waste, but the same paper gives 12 g under recycling.

**`use_library` stays at 1000 g** -- deliberately *not* full
avoided production, unlike the two above. The difference is
displacement, not caution: acquiring a used car or garment is
necessarily an acquisition that would otherwise have been made
new, whereas most library borrowings would never have been
purchases at all, and a library copy amortizes its production
across many borrowers. Its anchor is also weak -- 2008 vintage,
and the report's own two figures imply 4.01 vs 2.99 kg per book
(sold vs produced denominators). 1.0 kg sits below both.
Re-source before raising.

### Original handover: two red tests from the E1 grid change

Both predate this session -- they came from the earlier energy
pass that applied decision E1 (386 -> 458 g CO2e/kWh) and rewrote
the action database; both files were already modified in the
working tree when this session opened. Confirmed red by running
them, not inferred:

**1. Transport metadata pin -- one line, ready to apply.**
`transport_modes_data_test.dart:139` still expects 386; the
dataset now carries 458. The re-derivation the fix appears to
need is **already done**: `car_bev` is 86 (0.188 kWh/km x 458),
e-bike 2 and e-scooter 7 both cite 458, and RESEARCH_TRANSPORT
records the change at "raised 386 -> 458 ... car_bev 73 -> 86".
So the remaining work is the assertion itself, plus three
cosmetic stragglers that do not fail anything:

- `transport_mode_model_test.dart:16` fixture string
  `'0.188 kWh/km x 386 g/kWh'`
- `transport_methodology_screen.dart:69` fallback default `386`
- RESEARCH_TRANSPORT sec 6 pin 5 still reads `(73 < 128.25+)`;
  the invariant holds at 86, only the quoted number is stale

**2. Food action ids -- renamed, not removed.** Five tests in
`food_action_consistency_test.dart` throw on null lookups. The
actions were restructured, and each kept a
`provenance_research_id` back to its old id:

| Old id | New id | g CO2e |
|--------|--------|-------:|
| `meatless_meal_beef` | `skip_high_impact_food` | 6800 |
| `meatless_meal_chicken` | `skip_medium_impact_food` | 1000 |
| `plant_milk_vs_dairy` | `plant_milk` | 460 |
| `meatless_meal_pork` | none -- moved to `research_only_records` | -- |

Three can be re-pointed by id. The fourth is a deliberate
demotion: pork is no longer a shipped action, which contradicts
RESEARCH_FOOD.md section 7's shipped food-action set. That doc
needs updating either way, and the pork assertion needs deleting
rather than re-pointing. **Owner call, not made:** whether the
beef/chicken merge into high/medium impact tiers is the intended
final shape.

Not fixed here on purpose: food is mid-flight in a parallel
session, and the ask tonight was a written handover.

**Also spotted, food-side:** `skip_fish` carries
`co2_grams` 560 with `calculation_notes` reading
`"4.5kWh dryer x 386g/kWh (US)"` -- a copy-paste from the dryer
action. Wrong note, wrong grid factor, unrelated behaviour.

### Open decisions

None owned by energy. E1-E6 are settled and Appendix A records
them. The two items above are the food session's calls, not
this workstream's.

### Resuming

The energy dataset itself is untouched and consistent: all 11
energy actions carry the values RESEARCH_ENERGY section 7
derives. Nothing in Phase 8.13 is half-built, because no code
exists yet -- the research and the PDR are complete and the
feature is still cleared to build.

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
| 2026-08-02 | Hot-water delta-T 30 -> 27.2 K; gas efficiency restated on a Gross-CV basis | RESEARCH sec 3.1, 8 |
| 2026-08-02 | Action stores merged into one source of truth; seeder reads the JSON | sec 4 here |
| 2026-08-02 | Energy actions rebased to research values rather than rescaled (owner call) | sec 4 here |
| 2026-08-02 | 'US DOE 3% per degree' citation corrected -- DOE does not state it | sec 4 here |
| 2026-08-02 | UK gas central heating researched; ships as methodology context, not an entry | RESEARCH sec 3.3 |
| 2026-08-02 | `phoneCharges` 8 g stands (EPA basis, not drift) | ledger `known_drift` |

## Appendix B: Where the Detail Went

This document was split out of
[RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) on 2026-08-02, matching
the transport pattern: the research doc is the evidence base, the
PDR carries the decisions and the product rules. Nothing was
discarded -- sections 3-6 here were sections 2.2, 7.1, 8 and 8.1
of the research doc.

