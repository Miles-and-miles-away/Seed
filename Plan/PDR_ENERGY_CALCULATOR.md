# PDR: Phase 8 Home Energy Calculator -- Post-Design Review

**Created:** 2026-08-02
**Status:** Research complete and cleared to build from
([RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) v1.1, 33 behaviors,
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

Nothing exists in `lib/` or `data/` yet. To be built:

- `data/app/energy_behaviors.json` -- 33 behaviors, cited factors,
  `comparable_group` field, EN/JA/ES
- `lib/features/energy/` -- models, loader, calculator, routine
  builder, comparison, methodology screens
- `test/features/energy/` -- dataset validation, engine, sanity
  pins, cross-dataset grid-factor pin, widgets, l10n
- Five new action-library entries plus four corrections to
  existing ones (section 4), landing in the same PR as the E1
  rebase
- `data/app/impact_equivalencies.json` -- `phoneCharges` still
  needs reconciling (8 g shipped vs 7 g dataset-implied)

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

## 4. Action Library Additions

Owner decision, 2026-08-02: **the energy calculator ships with NO
logging bridge.** Transport and food comparison views get a "Log
greener choice" button; the energy comparison view does not. The
Tier-1 energy choices instead ship as **pre-programmed actions in
the action library**, scored like every other action.

This resolves the double-counting problem that made an energy
bridge unattractive (five existing actions already model the same
behaviors) and matches what the feature actually is: energy is a
teaching tool that occasionally informs a decision, not a
decision tool that teaches.

Values at the E1 factors (458 / 182 g/kWh). Points recomputed with
the shipped formula `max(1, round(co2^0.4 x effortMult x
rarityMult x impactMult))`, verified against `air_dry_clothes`
(1700 g, 2/3/2 -> 20 points, matching the seeder).

| Action | Status | co2_grams | Unit | e/f/i | Points |
|--------|--------|----------:|------|-------|-------:|
| `air_dry_clothes` | EXISTS, rebase | 2000 | per_load | 2/3/2 | 21 |
| `cold_water_laundry` | EXISTS, rebase | 430 | per_load | 1/3/2 | 10 |
| `skip_bath` | **NEW** | 770 | per_bath_skipped | 2/4/2 | 13 |
| `dishwasher_eco_cycle` | **NEW** | 120 | per_cycle | 1/4/1 | 5 |
| `aircon_setpoint_summer` | **NEW** | 120 | per_day (in season) | 2/5/2 | 5 |
| `aircon_setpoint_winter` | **NEW** | 140 | per_day (in season) | 2/5/2 | 6 |
| `heat_person_not_room` | **NEW** | 1900 | per_evening | 2/4/2 | 18 |

Derivations (each needs the inline calculation comment required
by [AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) section 2):

- `skip_bath`: the counterfactual differs by market, and the JP
  case is the LARGER saving:

  | Case | Arithmetic | Saving |
  |------|------------|-------:|
  | Western, gas | bath 1370 - 10-min shower 597 | 773 g |
  | Western, electric | bath 2607 - shower 1136 | 1471 g |
  | JP, gas | full bath (shower happens anyway) | 1370 g |
  | JP, electric | full bath | 2607 g |

  **Ships at 770 g** -- the Western gas figure rounded down,
  which is the floor across all four cases, so it is honestly
  conservative for every user rather than a compromise for one
  market.

  Why the two markets differ: **in Japan the bath is additive,
  not substitutive.** Washing and rinsing happen outside the tub
  (shower, hair, soap, rinse), and only then does the bather soak
  in clean water -- which is why one fill can be shared by the
  household. So the shower occurs on both sides of the
  comparison and cancels, and skipping the soak avoids the entire
  bath. An earlier draft of this section had the sequence
  backwards and wrongly concluded the action was inverted for a
  JP family; it is not, and the correction raises the JP saving
  from a supposed 959 g/person to the full 1370-2607 g per bath
  avoided.

  Unit is **one bath not drawn, logged once per household** --
  not per person. A shared fill that never happens is a single
  avoided bath; logging it per bather would multiply-count. The
  action name reflects that the shower is not the lever: EN
  "Showered only, skipped the bath", JA 湯船につからず
  シャワーだけにした, ES "Solo me duche, sin bano".

  Secondary and unquantified: 残り湯 (leftover bathwater) reused
  for laundry recovers some of a drawn bath's energy in the
  subsequent wash, which makes 770 g conservative by a further
  unmeasured margin in JP households that do it.
- `dishwasher_eco_cycle`: normal 1.12 - eco 0.85 = 0.27 kWh x
  458 = 124 -> 120 g.
- `aircon_setpoint_summer` / `aircon_setpoint_winter`: METI's
  own figures, 1 C at 9 h/day. Summer 30.24 kWh/yr over 112
  cooling days = 0.270 kWh/day = 124 -> **120 g**. Winter 53.08
  kWh/yr over 169 heating days = 0.314 kWh/day = 144 ->
  **140 g**.

  **These ship as TWO actions, not one** (corrected 2026-08-02;
  an earlier draft merged them at the summer figure and was
  wrong on both the rule and the physics):

  - The merge cited
    [AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) section 6
    "do not split what should be merged", which applies only
    when "two actions are both <15g CO2 and occur in the same
    context". At 124 and 144 g in different seasons, neither
    condition holds. The rule that does apply is the next one,
    "do not keep what should be split" -- the same reasoning
    that separated high- from medium-impact meat.
  - A degree is not one behavior. Envelope heat flow scales with
    the inside-outside gap, so METI's summer step (31 C out,
    27->28) cuts the load ~25% while its winter step (6 C out,
    21->20) cuts it ~7%. The absolute savings only look similar
    because winter's total load is much larger.
  - Japan already treats them as two named national campaigns
    with two different targets -- クールビズ (28 C summer) and
    ウォームビズ (20 C winter) -- and 環境省 publishes separate
    rules of thumb for each (約13% vs 約10% per 1 C). Merging
    them would be less legible than the primary market's own
    framing.

  Splitting costs nothing in points: the `co2^0.4` curve turns a
  +17% CO2 difference into 6 points either way.

  **Framing (decided 2026-08-02): both actions describe the
  SETPOINT STATE, not a per-degree delta.**

  | id | EN | JA | ES |
  |----|----|----|----|
  | `aircon_setpoint_summer` | Kept cooling at 28 C | 冷房を28℃に設定した | Mantuve la refrigeracion a 28 C |
  | `aircon_setpoint_winter` | Kept heating at 20 C | 暖房を20℃に設定した | Mantuve la calefaccion a 20 C |

  Why the state and not the delta: METI's figures are tied to
  specific stated conditions -- outdoor 31 C with a 27->28 step,
  outdoor 6 C with 21->20. A user setting 24->25 on a 30 C day is
  a -17% load change, not -25%, so a per-degree action would
  carry the same unverifiable-baseline defect that ruled out the
  logging bridge ("a degree from what?"). A setpoint is a state
  the user can read off the remote, and METI's 1 C step remains
  the documented counterfactual behind the number: the action
  credits keeping the recommended setpoint instead of the one
  degree more comfortable that METI assumes as the baseline.

  This also aligns the actions with the two national campaigns
  the primary market already knows: **クールビズ** (28 C cooling)
  and **ウォームビズ** (20 C heating). Per the house rule on
  source and publication names, the campaign names stay
  untranslated -- they appear as-is in the JA copy and are
  referenced, not translated, in the EN and ES descriptions.

  **Seasonal eligibility (recommended, needs a schema field).**
  METI publishes the exact windows its own arithmetic uses:
  冷房期間 6月2日-9月21日 (112 days) and 暖房期間
  10月28日-4月14日 (169 days). Gating each action to its window
  blocks the nonsense path (logging "kept heating at 20 C" in
  July), caps the annual total at what METI's derivation assumes
  (13.4 kg cooling, 23.7 kg heating), and is physically honest --
  the saving does not exist out of season. Cost is one date-range
  field on the action schema. Low urgency given there are no
  leaderboards and users are isolated, so nonsense logging only
  degrades the logger's own history.
- `heat_person_not_room`: portable electric heater 1.2 - kotatsu 0.15 =
  1.05 kWh/h x 458 = 481 g/h; an evening of 4 hours = 1924 ->
  1900 g. Covers kotatsu, electric blanket or heated carpet used
  **instead of** turning on a portable electric heater.

#### Not shipping: dishwasher vs hand washing

Proposed and rejected. The saving inverts with the sink's
carrier:

| | vs electric sink (1007 g) | vs gas sink (471 g) |
|---|---:|---:|
| Dishwasher, eco (389 g) | +617 g | +81 g |
| Dishwasher, normal (513 g) | +494 g | **-42 g** |

A fixed `co2_grams` cannot express that, and one of the four
cases is negative -- the app would award points for an action
that increased emissions. The honest floor across all carriers
is +81 g, which is so far below what users believe about
dishwashers that shipping it would read as a bug. **Stays a
calculator comparison only**; it is the feature's best
counterintuitive teaching moment and does not need to be an
action to do that job.

#### Caveats: two accepted residuals

1. **Rewarding existing lifestyle -- sharpened by the setpoint
   framing.** A state-based action ("kept cooling at 28 C") is
   loggable every day by someone who has never moved their
   thermostat, which is more exposed than a delta-based one would
   have been. Three mitigations, in order of preference:
   (a) the seasonal window above, which caps it at 112/169 days;
   (b) frequency scored at 5 (daily) rather than 4, which is both
   more accurate and trims the summer action to 5 points;
   (c) description copy that frames it as a choice held rather
   than a state owned. All three are applied in the spec above.
   Precedent for accepting the residual: `air_dry_clothes` is
   already loggable daily by a household with no dryer.
2. **`heat_person_not_room` existing lifestyle.** Same issue,
   milder -- most kotatsu households do own a portable heater, so
   the "instead of" counterfactual is usually real. Which
   [AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) section 6
   warns against. The same is already true of `air_dry_clothes`
   for a household with no dryer, so there is precedent for
   accepting it -- but both new actions are framed as "instead
   of" for exactly this reason, and the descriptions must carry
   that framing.

Consequences to land in the same PR:

- [ ] `cold_water_laundry` 600 -> 430 g, notes rewritten to the
      Bosch EN50229 same-machine derivation.
- [ ] `unplug_standby` 9 -> 5 g, notes citing LBNL verbatim.
- [ ] `air_dry_clothes` 1700 -> 2000 g.
- [ ] `led_vs_incandescent` 19 -> 23 g.
- [ ] Five new actions added per section 7.1
      (`skip_bath`, `dishwasher_eco_cycle`,
      `aircon_setpoint_summer`, `aircon_setpoint_winter`,
      `heat_person_not_room`) with EN/JA/ES copy and full
      `sources[]`.
- [ ] Energy comparison view ships WITHOUT a log button; transport
      and food keep theirs. Update
      [APP_PAGES.md](./APP_PAGES.md).
- [ ] `electric_vs_gasoline_car` and `transport_modes.json`
      `car_bev`: 73 -> 86 g/km (E1).
- [ ] `air_dry_clothes` notes: the 4.5 kWh figure is a
      vented/condenser full load, not a generic "tumble dryer".
- [ ] Three actions' notes move from "0.37 kg/kWh" to 458 g/kWh.
- [ ] `shorter_shower` notes gain flow rate, delta-T and the
      carrier range.
- [ ] Re-seed (`node scripts/seed/seed_action_library.js`) --
      bundles with the food pass's outstanding FR-22 re-seed.

---

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

## Appendix B: Where the Detail Went

This document was split out of
[RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) on 2026-08-02, matching
the transport pattern: the research doc is the evidence base, the
PDR carries the decisions and the product rules. Nothing was
discarded -- sections 3-6 here were sections 2.2, 7.1, 8 and 8.1
of the research doc.

