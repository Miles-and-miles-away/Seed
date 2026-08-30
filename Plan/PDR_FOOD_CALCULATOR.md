# PDR: Phase 8 Food Carbon Calculator -- Post-Design Review

**Created:** 2026-08-29, retrospectively. The feature shipped in
July 2026 without a PDR; food was the only calculator workstream
without one, which is why its decisions and product rules had
accumulated inside the evidence base.
**Status:** Feature shipped (Phase 8.7-8.12, 167 items). Decisions
D1-D11 settled. The comparison gate enforces the never-rank rules
as of 2026-08-29. `cream` shipped 2026-08-29 and nothing in
section 6 now blocks the feature.
**Purpose:** The working record for the food calculator -- standing
decisions and why, the comparison gating, the action-library
additions, the binding copy and UI rules, and the live open list.
The evidence base (source landscape, scope, verified factors,
chosen values, serving presets, sanity invariants) lives in
[RESEARCH_FOOD.md](./RESEARCH_FOOD.md).

**Where the two documents share a number** (audited 2026-08-30).
The split was clean for prose but not for figures: at least
fourteen appear in both files, among them the four gate bars, the
palm-versus-olive gap, and the item factors behind the action
derivations (`white_fish`, `cream`, `milk_chocolate`, peanut
butter, milk, peas, chicken, and the high-impact tier value). That
is a live rule-3 defect under
[DOCUMENT_TYPES.md](./DOCUMENT_TYPES.md), tracked in section 6.
Until it is closed, **RESEARCH_FOOD.md is the authority for any
item factor** and this document is the authority for any bar,
copy rule or action value; where the two disagree, fix the copy
here rather than editing the evidence to match.
**Companion docs:**
[RESEARCH_FOOD.md](./RESEARCH_FOOD.md) (evidence base),
[RESEARCH_FOOD_ARCHIVE.md](./RESEARCH_FOOD_ARCHIVE.md) (executed
and closed detail, serving both live documents),
[PLAN_PHASE_8.md](./PLAN_PHASE_8.md) Part 2 (feature plan),
[AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) (sourcing and points
rules), [DOCUMENT_TYPES.md](./DOCUMENT_TYPES.md) (what belongs
where).

---

## 1. Scope & Current State

**Shipped:** `data/app/food_items.json` (167 items, 916 source
objects with no empty field), `lib/features/food/` and
`test/features/food/` (94 tests). The calculator compares exactly
two meals side by side, states a verdict only when the gate allows
it, and banks the avoided difference as a `customActions` entry.

**Verified 2026-08-29:** `flutter analyze` clean, food suite 94
passing (was 91 before the `cream` row and its pin).

**Known not done**, all tracked in section 6: a verification pass
over the 123 v2 additions is still owed, and the app has never
been run on a device -- every claim about the picker, the preset
labels, the no-verdict dialog and the methodology page rests on
unit and widget tests alone.

**This document was assembled from RESEARCH_FOOD.md**, which had
carried both document types since July. The section mapping is in
Appendix A. Cite the rules here by name rather than by number.

---

## 2. Standing Decisions

Owner-approved. Each is evidenced in RESEARCH_FOOD.md at the
section named; the reasoning summary is here so the decisions can
be read without the evidence.

| Id | Date | Decision | Evidence |
|---|---|---|---|
| D1 | 2026-07-18 | Ship Poore & Nemecek **means**, not the famous median set. The medians were retired by OWID in 2022; the means are live-quotable digit for digit. The median set stays an approved fallback, disclosed whenever used | RESEARCH sec 1 |
| D2 | 2026-07-18 | Beer ships 1.2 kg/L. The 0.51-0.84 packaged-LCA range is science-sheet spread context only | RESEARCH sec 3.7 |
| D3 | 2026-07-20 | Oats 1.84 = (2.48 + 1.20)/2, both inputs access-dated. The live CarbonCloud input drifts; re-read it at every data pass | RESEARCH sec 3.4 |
| D4 | 2026-07-20 | One documented plant-alternative baseline for every meatless action: 200 g CO2e per 100 g serving, rounded **up** so the saving rounds down | sec 4 here |
| D5 | 2026-08-01 | Drop the dairy-herd beef item. A single `Beef` ships, because no label, menu or receipt tells a shopper which herd their beef came from | RESEARCH sec 3.1 |
| D6 | 2026-08-01 | Beef ships 70.3608, the production-weighted mean of the two P&N rows, using OWID's own published weights | RESEARCH sec 4 |
| D7 | 2026-08-01 | Oils were shipped as per-litre values in a per-kg field. Corrected: olive 5.42 -> 5.941953, palm 7.32 -> 7.955247 | RESEARCH sec 3.9 |
| D8 | 2026-08-02 | `cane_sugar` 3.20 -> `sugar` 2.922. Same defect class as D5: a split nobody can answer at the point of eating | RESEARCH sec 4 |
| D9 | 2026-08-02 | Pasta 1.57 -> 2.290444. P&N's "Wheat & Rye" unit is 1 kg of **bread**, not grain | RESEARCH sec 4 |
| D10 | 2026-08-02 | Peas 0.98 -> 0.53 and the item moved to `vegetables`. P&N's "Peas" row is dry peas without pod | RESEARCH sec 4 |
| D11 | 2026-08-08 | The seafood source decision: P&N-anchored with Gephart filling species gaps, mixed sources allowed but **ranking across them is not** | RESEARCH sec 2, archive sec 7 |

**D11 was numbered D8 when it was taken**, colliding with the sugar
decision. It was renumbered on 2026-08-29: the sugar decision is
the rightful member of the dated D1-D10 run, and the seafood
decision postdates all of them. Anything written before that date
calling the seafood decision D8 means D11. A decision id is a
permanent handle, so neither number will be reused.

---

## 3. Comparison Gating

The calculator states a verdict only when the reduction clears
every applicable bar. The bars are product rules and live here; the
numeric pins that test them are data pins and live in
RESEARCH_FOOD.md section 6.

Implemented in `FoodCalculator.checkVerdict`.

| Bar | Value | Applies when |
|---|---|---|
| `verdictMinPercent` | 20% | Always, as the floor |
| `crossTierMinPercent` | 50% | The two meals draw on more than one `source_tier` |
| Statistic threshold | `(1 - 1/statistic_ratio) x 100` | Any ingredient carries a `statistic_ratio`; the widest present wins |
| Tie-group flattening | verdict must survive | A `tie_group` appears on both sides |

**Why each exists.**

The 20% floor is verified rather than assumed: with the three
statistic-sensitive items excluded, every pair separated by 20% or
more keeps its ordering under either statistic, and
`food_statistic_threshold_test.dart` re-derives that claim on every
run rather than asserting it.

The cross-tier bar exists because a tier-2 row is measured to a
narrower boundary than a P&N tier-1 row and so reads
systematically low against it. Only a gap far wider than that
offset survives the mismatch.

The statistic threshold is **a threshold, not a ban**. A first pass
blocked the statistic-sensitive items outright, which was too
blunt: a beef portion beats a chocolate serving six times over per
realistic serving, and no statistic choice reverses that. Blocking
it was wrong; blocking cheese versus chocolate at 48.8%, under the
59.9% bar, is right.

The tie-group rule flattens every tie group that spans both options
to its lowest member factor and re-runs the comparison. A verdict
that does not survive that was reading an artefact of the
derivation rather than a measured difference. It is what finally
enforced copy rules 3 and 13: tree nuts versus peanuts cleared both
the 20% floor and tree nuts' own 53.5% statistic bar at 86.7%, so
nothing else in the gate caught it, and palm versus olive at 25.3%
was rankable against an explicit prohibition. A tie group confined
to one option is ignored, because it adds the same mass either way
and cannot manufacture a delta.

**When the gate declines, the user is owed the reason.** A "why is
there no result?" action names which of the four cases applies --
meals genuinely close, sources incompatible, one ingredient's
evidence too wide, or the gap resting on a shared derivation -- and
what gap would have been needed. Marking a column "best" and
offering the banking action are verdicts too, and answer to the
same gate.

---

## 4. Action-Data Consistency (`co2_actions_database.json`)

Consequences of decision D1 (means) for the existing actions --
corrections land in the SAME PR as the dataset (never two numbers
for one swap in the app):

**Restructured 2026-08-08.** The four per-item swap actions are
retired. `meatless_meal_beef` and `meatless_meal_chicken` merged
into two tier actions, `plant_milk_vs_dairy` was renamed, and
`meatless_meal_pork` moved to `research_only_records` (which the
seeder does not read). Each retired id that has a successor
survives on it as `provenance_research_id`. All three successors
now live in `co2_actions_database.json` -- they used to be
seeder-only -- alongside `skip_fish`, which was never one of the
four.

| Action | Covers | Shipped | Binding derivation |
|--------|--------|--------:|--------------------|
| `skip_high_impact_food` (per 100 g) | beef, lamb | **3700 g** | lamb 3972 - 200 = 3772 -> 3700. Beef implies 6836 on the same basis |
| `skip_medium_impact_food` (per 100 g) | chicken, pork | **780 g** | chicken 987 - 200 = 787 -> 780. Pork implies 1031 |
| `plant_milk` (per 250 ml) | oat, soy | **460 g** | soy (3.15 - 0.98) x 0.25 = 543 g binds, not oat 562. 460 stays deliberately below it |
| `skip_fish` (per 150 g) | white fish | **560 g** | `white_fish` 5.1250386 x 150 g = 768.76 - 200 = 568.76 -> 560 |

The two tier values fell on 2026-08-08 (6800 -> 3700, 1000 ->
780). The merge had left each action crediting its tier's
*highest* item, so a lamb skip paid 1.8x its real saving and a
chicken skip 1.27x. That contradicts the conservative rule
`plant_milk` already followed, so both were re-based on the
tier minimum. **This is a points-economy change**: a -46% and a
-22% cut to shipped rewards.

Standing rules the table encodes (D4, 2026-07-20):

- **A multi-item action binds to the SMALLEST implied saving
  among the items it names**, never the largest and never a mean
  -- the reward must be honest whichever item the user actually
  skipped. Asserted by `food_action_consistency_test.dart`.

- **One documented plant-alternative baseline**, 200 g CO2e per
  100 g serving (beans/lentils, OWID "Other Pulses" mean
  1.79 kg/kg = 179 g, rounded UP -- rounding the baseline up
  rounds the saving down). Savings round DOWN to two significant
  figures. Asserted by `food_action_consistency_test.dart`.
- **Every food action records statistic + losses basis** in its
  notes ("global MEAN with supply-chain losses, cradle-to-retail")
  and cites the mean, never the legacy median.

`skip_fish` was also re-derived 2026-08-08 with D11, **a -53% cut**
(1200 -> 560 g): it previously read the assembled `fish_wild` 9.5
that D11 retired. The test asserts `fish_wild` is gone so the old
value cannot silently return.

The seeder (`scripts/seed/seed_action_library.js`) hardcodes none
of these -- it reads `actions` from the JSON, so a value change
here needs a re-seed, not a code edit.

The closed fix log for these is in
[RESEARCH_FOOD_ARCHIVE.md](./RESEARCH_FOOD_ARCHIVE.md) section 1.

---

## 5. Copy & UI Rules (binding)

Derived from the coherence audit. Every one is a requirement on
the calculator UI and the science sheets, not a suggestion:

1. **Coffee entry defaults to the per-cup preset**, never the raw
   grams field; any per-kg bar for coffee carries the sublabel
   "per kg of dry grounds -- one cup uses ~10 g (~0.29 kg CO2e)";
   coffee is excluded from auto-generated "worst item" copy.
   (Coffee is the #2 per-kg bar for a food consumed 10 g at a
   time; a user typing 250 "ml" into the grams field computes
   7.13 kg CO2e -- an 18-71x overcount vs the published per-cup
   band, 25x vs the 10 g preset.)
2. **Dark chocolate sublabel**: "mostly land-use change
   (deforestation-linked cocoa); sourcing moves this from
   near-zero to 46+". At 46.65 it is the #3 bar and will be
   disbelieved without it. The science sheet states the statistic
   (mean) explicitly.
3. **Tree-nut credit note** on the science sheet (orchard LUC credit;
   ~3.7 without it); suppress "lowest footprint" copy; never
   display negative values.
4. **Comparative-copy rule**, as shipped in
   `FoodCalculator.checkVerdict`: "X emits less than Y" sentences
   only when the reduction clears every applicable bar. **The bars
   and the reasoning behind each are section 3 of this document
   and are not restated here.** What this rule adds is the copy
   consequence: below the bar, present both totals without a
   verdict, and without the "best" marker or the banking action,
   since both are verdicts too.

   The reasoning is stated in the in-app methodology page, not
   just in this document: users are told that a minority of
   high-impact producers pulls each average above the typical
   farm, that the study also publishes a midpoint, that close
   pairs can swap between the two, and that a few foods need a
   much wider gap before they can be ranked because their own two
   published figures disagree by more than a factor of two. When
   the app declines, the reason is one tap away -- see the "why is
   there no result?" requirement in section 3.
5. **Beer vs wine copy names the serving, not the liquid**: per
   litre wine > beer, but per serving a 330 ml can (0.40 kg) > a
   150 ml glass (0.27 kg).
6. **Rice raw-weight helper in the quantity editor** (not only the
   methodology page): "We count the dry weight you buy -- a
   rice-cooker cup is 150 g raw, ~330 g once cooked; enter the
   raw amount." This is a silent 2.2x error path.
7. **Bread/pasta basis note** (corrected with D9 -- the v1 wording
   "grain factor (Wheat & Rye); baking/drying energy not counted"
   was wrong for bread): P&N's "Wheat & Rye" functional unit IS
   1 kg of bread at retail, so milling and baking are already
   inside `bread` 1.57 and only post-shelf steps are excluded.
   `pasta` 2.290444 is that same anchor re-based for moisture
   (bread 39% water, dry pasta 11%); what stays uncounted there is
   the difference between baking a loaf and drying pasta, and home
   boiling. The shipped `calculation_notes` on both rows already
   say this.
8. **Prawns spread caveat** on the science sheet ("single global
   farmed-prawn category, large spread"); never pin or copy the
   prawns-vs-cheese ordering.
9. **Butter non-P&N note**: "not in Poore & Nemecek; mean of three
   independent published figures (10.18-12.2)". Not "dairy LCAs"
   -- the v2 verification pass established that none of the three
   is a primary dairy study (a national-database portion figure, a
   meta-aggregator, a modelled benchmark, all live pages that
   drift), and the shipped notes say so.
10. **Mean-vs-median methodology explainer** on the methodology
    page: "you may have seen beef = 60 -- that is the median of
    the same study; we show the production-weighted mean." Users
    WILL cross-check against the famous chart.
11. **Tie-cluster sort rule**: stable secondary sort
    (alphabetical) in ranked views so tie-cluster items don't
    jitter.
12. **Berries "includes grapes" note** on the science sheet; no
    berries-vs-bread comparative copy.
13. **Palm-vs-olive: no superlatives or ordering copy**;
    methodology note per section 3.9.
14. **Tea inherits the coffee rule**:
    preset-only entry, per-kg sublabel ("per kg of dry leaves --
    one tea bag uses ~2 g (~18 g CO2e)"), excluded from
    auto-generated "worst item" copy. The methodology sheet states
    prominently that home boiling is excluded and that published
    per-cup tea figures are mostly kettle energy.
15. **Plant-based meat disclosure**: science
    sheet states the category breadth (soy mince to formulated
    patties), that the underlying LCAs are company-commissioned
    with narrower boundaries, and that the value was uplifted and
    rounded up to compensate; never rank it against eggs or rice
    (ties).
16. **Wild fish notes** (re-based with D11 -- the single
    `fish_wild` row this rule was written for is retired): `tuna`
    covers tinned tuna as well as the steak and carries both
    presets; `small_fish` takes sardines, herring, mackerel and
    anchovies; `white_fish` takes cod, haddock and hake. All three
    are tier 2 on an edible-weight basis, so the flatfish and
    species-spread caveats stay on the science sheet, and none of
    them may be ranked against a tier-1 row like chicken under the
    cross-tier bar.
17. **Small fish / canned beans copy rules**:
    small oily fish sits in the same low-impact neighbourhood as
    eggs and plant-based meat -- no ranked-step copy; fish
    presets are drained / edible weights and the quantity editor
    says so (whole-fish grams typed raw would overstate ~2.5x).
    Canned vs dry beans are different weight bases -- the
    quantity editor says "drained weight" on the canned item and
    "dry weight" on the dry item, and no per-kg comparison copy
    is generated between them.
18. **No chocolate-vs-chocolate verdict** (added 2026-08-29). The
    app must never name a winner between `milk_chocolate` and
    `dark_chocolate`, and must never quote the percentage gap
    between them, whatever the arithmetic happens to allow on the
    day. Milk chocolate genuinely is lower per kg, so the ORDERING
    may be stated in prose; the SIZE of the gap may not, because it
    is set by a 2-3x disagreement between the two sources about
    cocoa rather than by anything measured about the two bars. The
    2026-08-29 re-derivation (14.9 -> 19.35) puts the pair below
    dark chocolate's statistic bar by 1.4 percentage points, so the
    gate refuses it today; this rule is what keeps the refusal when
    either number next moves. Same shape as rule 13 (palm vs olive):
    direction sayable, magnitude not.
19. **`peanut_butter` and `peanuts` are one number** (added
    2026-08-29). Both ship 3.23 -- peanut butter is ground peanuts
    and the dataset now says so. An exact tie is the honest answer:
    no verdict, no "best" marker, no banking action between them.
    Any future divergence needs new evidence for grinding energy or
    packaging, not a re-imported roast-yield uplift, which is a
    double count against the P&N groundnut basis (section 2.1).
20. **No cream-vs-butter verdict, and no lighter cream aliased
    onto the `cream` row** (added 2026-08-29 with the row). The two
    rows sit 6.5% apart while the physics says butter is about
    twice cream, because butter's number is measured on a European
    milk supply and cream's is built from Poore & Nemecek's global
    milk. They share `derived_strained_dairy`, so the gate already
    refuses it; this rule keeps the refusal if either number moves.
    Separately, `cream` is heavy cream at 36% milkfat: single
    cream, table cream and half-and-half work out near 5 to 7 on
    the same arithmetic, so aliasing them here would repeat the
    tree-nut/peanut error at about 2x. The science sheet states
    the fat basis and that the number is the total-solids end of a
    range whose fat-weighted end is 19.16.

Also required by section 4 of this document: the food actions and the dataset must
ship in the same PR (never two numbers for one swap in the app),
and the beans/lentils item must never carry the OWID peas quote.

---

## 6. Open Items

Closures from the 2026-07-18/19/20 research passes are logged in
[RESEARCH_FOOD_ARCHIVE.md](./RESEARCH_FOOD_ARCHIVE.md) section 2.

Standing rules -- permanent by design, never "done", re-checked
or enforced at every data pass (moved out of the open list
2026-07-20 so they stop reading as pending tasks):

- **Oats live input re-read** (recurring): D3's CarbonCloud input
  drifts (1.25 -> 1.20); re-read at each data pass and recompute
  the average. Last re-read 2026-07-20: 1.20 unchanged, average
  holds at 1.84.
- **Median fallback provenance** (conditional rule, currently
  unused): if any item ever falls back to the median set, cite
  the archived grapher endpoint (section 1) and disclose
  statistic + losses basis in calculation_notes and the science
  sheet. No item uses the fallback today.
- **CarbonCloud no-URL guard** (prohibition, permanently in
  force): the rows dropped as unverifiable (assorted cheese
  variants, chickpeas, potato starch/chips, NL tomato, red
  cabbage, dry onion, oats-UK farm benchmark) must not be
  resurrected into `sources[]` without full product URLs and
  fresh values.

**This list is the single live record for the food dataset.** The
entries marked "moved here" were previously kept in
[RESEARCH_FOOD_ARCHIVE.md](./RESEARCH_FOOD_ARCHIVE.md) section 0
or section 12.4, both of which are closed and carry no live
instructions.

Closed on the 2026-08-29 pass, one line each. The full closure
records are in
[RESEARCH_FOOD_ARCHIVE.md](./RESEARCH_FOOD_ARCHIVE.md) section 13,
with the longer write-ups in its sections 10 to 12.

| Closed | Outcome |
|---|---|
| `comparable` / `tie_group` read by no code | `tie_group` wired and curated to one meaning; `comparable` deleted |
| `shellfish` / `marisco` 19.2x fork | Closed by completing the category across all five rows, not by cutting the term |
| `plant_based_meat` may be ~3x low | Kept at 4.5; the 3x was a cradle-to-fork boundary artefact |
| `milk_chocolate` below its recipe floor | Re-derived 14.9 -> 19.35 |
| `peanut_butter` withdrawn roast uplift | Withdrawal applied, 3.39202 -> 3.23 |
| actionLibrary re-seed (FR-22) | Re-seeded and verified live, bundled with E1 |
| RESEARCH_FOOD.md carried two types | Split; sections 7-10 became this document |
| The v2 item spec had no sibling type | Folded into the archive, file retired |
| Umbrella-word and homonym forks | Two homonyms fixed; six category words were never defects |
| Cream has no row | Ships at 11.222704, total-solids allocation from milk |
| Two verification reports were lost | Not recoverable; see below |

**On the two lost reports** (closed 2026-08-29, owner decision). The
gap-fill and notes agents died on a session limit after writing their
patches but before writing their reports, so their
flagged-contradiction lists never existed and cannot be reconstructed.
Closing it as unrecoverable rather than carrying a task nobody can do.
The ground they would have covered has since been swept twice: the v2
verification pass produced the concrete defect list that is still open
below, and the 2026-08-29 retrospective re-swept the dataset and found
the derived-row class. What remains owed is that open defect list, not
a report.

Live:

- [ ] **Dataset defects the v2 verification pass left open**, as
      that pass recorded them (detail in RESEARCH_FOOD_ARCHIVE.md
      section 9; not re-verified in this doc pass beyond confirming
      each id still ships): `crisps`, `popcorn` and
      `instant_noodles` 3-4% below their own floors because their
      oil leg never got the D7 density correction; six items
      defaulting to a prepared weight on an as-purchased factor
      (`sweetcorn`, `takenoko`, `melon`, `pineapple`); `edamame` on
      a dry-pea anchor and `soy_tvp` declared dry on a wet-tofu
      factor; duplicate user-visible rows `bread` / `bread_wheat`
      and `palm_oil` / `palm_soy_oil`; `beer` citing a page that
      implies 0.704 kg/L against the shipped 1.20; `beans_canned` /
      `chickpeas_canned` 1.7 with both legs of the mean tracing to
      one autogenerated aggregator value; `oats` 1.84 taking half
      its value from a live aggregator page; `cured_meat`'s two
      mis-attributed quotes and its 502ing government URL;
      synthesised quote text on `baked_beans` and four Open Food
      Facts citations; `frozen_pizza`'s unsourced 170 g preset;
      `asparagus` notes contradicting the paper they cite; and 153
      josephpoore.com PDF/XLS citations never reached, now the
      weakest evidence class in the dataset.
- [ ] **`skip_fish` ships with no sources** (moved here from
      PDR_ENERGY_CALCULATOR.md section 8, 2026-08-30, where it was
      recorded as food's call). Its `sources[]` is empty and it
      carries no `confidence`, the only food action in that state:
      every other one was backfilled on the 2026-08-29 sourcing
      pass. The 560 g derivation in section 4 is sound and its
      inputs (Gephart via OWID `white_fish` 5.1250386, the 200 g
      plant baseline) are already live-verified in RESEARCH_FOOD.md
      section 3.1, so this is a transcription job, not new
      research: copy those source objects onto the action and set
      the confidence.
- [ ] **`skip_food_delivery` ships at 0 g** (moved here from
      PDR_ENERGY_CALCULATOR.md section 8, 2026-08-30). Shipped at
      zero on 2026-08-09 because the only peer-reviewed comparison
      runs the other way (meal kits beat grocery-store meals,
      last-mile emissions are lower for a van route than for a car
      trip), so the previous 600 g had no basis. It survives as a
      habit prompt worth 0 g. Decide whether an action that can
      never claim a saving belongs in the library at all, or
      retire it to `research_only_records` the way
      `use_natural_light` was. Restoring a non-zero value needs a
      restaurant-delivery LCA, which does not exist today.
- [ ] **The 50% `crossTierMinPercent` boundary is not pinned**
      (new 2026-08-30). `food_calculator_test.dart` pins the 20%
      floor exactly ("20% exactly is enough") and exercises the
      cross-tier bar at 48.1%, under it. Nothing asserts the
      behaviour at exactly 50, so the bar could move to 45 or 55
      and the suite would stay green. Add the boundary case the
      20% floor already has.
- [ ] **This document and RESEARCH_FOOD.md state at least
      fourteen of the same numbers** (new 2026-08-30), which is a
      rule-3 defect under
      [DOCUMENT_TYPES.md](./DOCUMENT_TYPES.md): the four gate bars,
      the palm-versus-olive gap, and the item factors behind the
      action derivations all appear in both files, several as
      near-verbatim sentence pairs. The header records the interim
      authority split. Closing it means one home per value and a
      pointer from the other, most likely by cutting the factors
      out of this document's prose and citing the RESEARCH section
      instead. Do it as its own pass, not folded into a value
      change.
- [ ] **Shared dataset-assertion helper** -- tracked in
      [PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md)
      section 9, because it spans all three calculators.
      `food_items_data_test.dart` is one of the three files that
      hand-writes the same seven structural checks.
- [ ] **Never run on a device** (moved here 2026-08-08). All food
      confidence is unit and widget tests. The 167-item picker, the
      cooked-weight preset labels, the no-verdict dialog and the
      methodology page have not been looked at on hardware.
- [ ] **Tidaker et al. 2021 full text** (new 2026-07-20):
      ScienceDirect blocks automated fetch (re-attempted
      2026-07-20 via Unpaywall, CORE and the SLU research portal
      -- all blocked or missing); the per-stage
      packaging/processing split and the steel-tin chickpea
      figure exist only as unverified snippets. If the full text
      becomes readable, consider refining beans_canned's
      candidate table with it.
- [ ] **`butter` 12.0 cannot be reconciled with `milk_dairy` 3.15**
      (new 2026-08-29, surfaced by the cream work). Butter's three
      source pages measure a European milk supply at roughly a
      third of Poore & Nemecek's global mean with land-use change,
      so no allocation rule bridges them: total solids puts butter
      at 21.58 and a fat-and-protein split higher still. The
      dataset therefore carries a dairy row that is internally
      inconsistent with its own milk anchor by about 1.8x, which
      is why `cream` had to be tie-grouped with it rather than
      ranked against it. Not urgent and not a regression -- butter
      has been tier 2 with this provenance since v1 -- but the
      next dairy pass should either find a butter figure on the
      P&N boundary or derive butter from milk the way cream and
      milk powder now are, and re-derive the tie group afterwards.

Implementation-PR dependencies recorded at research close are in
[RESEARCH_FOOD_ARCHIVE.md](./RESEARCH_FOOD_ARCHIVE.md) section 3.

Verification gate (food-specific): dataset value changes must
keep the section-6 invariant pins green in a scoped
`flutter test test/features/food` run before moving on -- the
pins are the food equivalent of the transport sweep gate. Any
new or changed source quote is re-verified LIVE before pasting.

---

## 7. FOOD_LOGIC_CHECK

The per-value arithmetic and provenance recomputation record lives
in [RESEARCH_FOOD_ARCHIVE.md](./RESEARCH_FOOD_ARCHIVE.md) section 4. Every
derivation it checks is also stated with its sources in section 3
above; the archive is the independent recomputation, kept out of
this document to keep it readable.

---

## 8. Retrospective review (2026-08-29)

The feature shipped without a review pass; transport had seven.
This is the first, run while the corpus was being restructured. It
looked at four things: rules asserted as binding that nothing
enforces, derived values that do not reproduce, dangling
references, and decisions recorded in only one place.

**All six confirmed findings were fixed the same day**, and each is
closed in section 6 with what changed. They are recorded here
because the shape of the mistake is the durable part: every one was
a field or a rule that looked enforced and was not.

### 8.1 Confirmed

**The `parent` / `mass_ratio` pair carries three incompatible
shapes.** This is the same pathology as the retired `comparable`
field: one name, several meanings, no consumer to keep it honest.

| Shape | Rows | Example |
|---|---|---|
| String parent id, float ratio | 12 | `greek_yogurt` <- `yogurt` x 3.278689 |
| **List** of two parents, list of two ratios | 3 | `crisps` <- `['potatoes','sunflower oil']` x `[4.0, 0.342]` |
| A P&N **category name**, not an item id | 1 | `baked_beans` <- `'Other Pulses'` |

Any code reading `parent` as a string would crash on the three
list-valued rows and silently fail to resolve `baked_beans`.

**`peanut_butter`'s stated derivation no longer reproduces.** It
ships 3.23, while its own `parent` (`peanuts` 3.23) times its own
`mass_ratio` (1.050161) gives 3.39202. The roast-uplift withdrawal
on 2026-08-29 was applied to the value and not to the ratio, so the
row now documents a derivation it does not follow. It is the only
mismatch of the 15 derived rows; every other one reproduces exactly.

**`salsa.composite_of` points at a retired row.** It names
`onions_leeks`, one of the five umbrella rows the v2 work retired
into species rows. The reference has dangled since 2026-08-08.

**The test the v2 spec promised was never written.** That spec
listed a "concentration check (`child ~= parent x mass_ratio x
uplift`)" among the tests the schema additions would unlock. It did
not exist, which is precisely why the findings above were silent.
Writing it (invariants 21 and 22) surfaced three further defects
within minutes: `instant_noodles` carried a fourth `parent` shape,
two names joined by a comma, and `mayonnaise` and `salsa` used
`parent` as a loose "principal ingredient" hint on rows that are
really recipes, so their arithmetic could never close. That is the
root cause of the whole class: one field pair meaning both an exact
derivation and a rough annotation.

**Copy rule 11 (stable secondary sort) is not enforced.** The
ranked ingredient list in `food_display.dart` sorts on CO2 alone,
with no secondary key, and Dart's `List.sort` is not stable. With
21 items sharing 0.53 and seven sharing 0.51, a meal of several
vegetables can reorder its own ingredient summary between rebuilds
-- the jitter the rule exists to prevent.

**Copy rule 19 (peanuts and peanut butter never ranked) holds only
by accident.** The two now carry the identical value 3.23, so the
delta is zero and the gate refuses on `tooClose`. They share no
`tie_group`. If `peanut_butter` is ever re-derived -- and its own
notes say grinding energy and the jar are excluded, so it arguably
should rise -- the accidental tie breaks and the pair becomes
rankable against a rule written the same week.

### 8.2 Checked and clean

- **The other 14 derived rows reproduce exactly** against their
  stated parent and ratio, including the four-stage
  `milk_powder` and the strained-dairy chain.
- **Copy rules 1 and 14** (coffee and tea preset-only entry) are
  enforced in data: all four rows carry
  `entry_mode: preset_only`.
- **Rule 10** (the mean-versus-median explainer) is present in the
  localised strings.
- **Every item has a complete source**, enforced by a test.

### 8.3 Not examined

The per-item evidence for the 123 v2 additions. That verification
pass is still owed (section 6) and is a research task, not a review
one. This pass checked internal consistency, not whether each
figure matches its cited source.

---

## Appendix A: Where this document came from

Assembled 2026-08-29 out of RESEARCH_FOOD.md, which had carried
both an evidence base and a set of product rules since July. The
split follows the energy pattern: the evidence doc keeps the
factor tables, chosen values and sanity invariants, and the PDR
takes the decisions, product rules, action-library additions and
UI/copy requirements.

| Was | Is now |
|---|---|
| RESEARCH_FOOD.md section 7, "Action-Data Consistency" | Section 4 here |
| RESEARCH_FOOD.md section 8, "Copy & UI Rules (binding)" | Section 5 here |
| RESEARCH_FOOD.md section 9, "Open Items" | Section 6 here |
| RESEARCH_FOOD.md section 10, "FOOD_LOGIC_CHECK" | Section 7 here |
| Decisions D1-D11, scattered in RESEARCH_FOOD.md sections 2 and 4 | Indexed in section 2 here, evidence left in place |
| The gate rules, inside RESEARCH_FOOD.md sections 6 and 8 | Section 3 here; the pins stayed in RESEARCH_FOOD.md section 6 |
| `FOOD_ITEMS_V2_LIST.md`, the delivered v2 build spec | Retired as a file; what survives is RESEARCH_FOOD_ARCHIVE.md section 12 |

Section numbers in RESEARCH_FOOD.md were **not** renumbered by the
split: its sections 1-6 kept their numbers and sections 7-10 moved
here as 4-7. Old references of the form "RESEARCH_FOOD.md section
8" therefore mean section 5 of this document.

Cite the rules in this document **by name**, not by section
number. Section numbers rot; "the comparative-copy rule" does not.
