# PDR Food Dataset -- Archive (executed detail)

**Archived:** 2026-08-08. Long-form content moved out of
[RESEARCH_FOOD.md](./RESEARCH_FOOD.md) so that document stays a
concise methodology-and-evidence reference. Everything here is
EXECUTED or CLOSED; nothing below is a live instruction. Live
rules, open items and the binding copy rules stay in
RESEARCH_FOOD.md (sections 6-9). The forward item spec for the v2
dataset is [FOOD_ITEMS_V2_LIST.md](./FOOD_ITEMS_V2_LIST.md).

---

## 0. State as of 2026-08-08

**Shipped:** `data/app/food_items.json` went 43 -> 166 items
(v2), plus the tree-nut/peanut split, the seafood source decision D8,
the comparison gate, and a four-part verification pass (section 9).

**The suite is RED, and not from the food work.** 81 food tests pass;
6 fail, all caused by the other session:

- 5 in `food_action_consistency_test.dart` -- the action ids
  `meatless_meal_beef`/`_chicken`/`_pork` and `plant_milk_vs_dairy`
  were removed when `co2_actions_database.json` was rewritten at
  ~15:05. If they were renamed, re-point the test; if deliberately
  removed, RESEARCH_FOOD section 7 needs rewriting.
- 1 in `transport_modes_data_test.dart` -- the grid factor moved
  386 -> 458 (energy decision E1) without the test or the transport
  invariant pins being re-derived.

**Needs a re-seed before the new values are live:**
`node scripts/seed/seed_action_library.js` (needs the Firebase service
account). `skip_fish` 1200 -> 560 g is the user-visible change.

**Open decisions for the owner** (none blocking, all recorded):

1. `plant_based_meat` 4.5 may be ~3x low on its own cited peer-reviewed
   source -- re-research or keep with the disclosure now in place.
2. Wire `comparable`/`tie_group` into the verdict gate or delete the
   fields; today they are read by no code, so the app ranks tree nuts
   87% better than peanuts against an explicit never-rank rule.
3. `shellfish`/`marisco` route to farmed prawns at 19.2x -- a one-line
   alias cut, but it is the third defect of that class.
4. `milk_chocolate` sits below the floor its own recipe implies.
5. Cream still has no row, by decision.

**Not verified at all:** the app has never been run. All confidence is
unit and widget tests -- the 166-item picker, the cooked-weight preset
labels, the no-verdict dialog and the methodology page have not been
looked at on a device.

**Dates:** everything stamped 2026-08-04 during the day came from a
misread clock; the real date was 2026-08-08. 223 stamps corrected,
including 194 source access dates.

That correction needed a second pass, worth recording because the
same trap will recur. Moving all 194 to "today" would have asserted a
freshness nothing supports: 91 of those quotes appear verbatim in the
2026-08-01 wave research, so they were copied at assembly, not
re-fetched. Those were set to 2026-08-01, their true provenance. Of
them, 80 were the OWID nut rows and the four FAO Wayback captures,
which WERE fetched and machine-verified in this pass (79 of 81 FAO
quotes matched), so those are legitimately dated 2026-08-08 and were
restored. Net effect: 11 sources stopped claiming a check that never
happened.

The rule this encodes: an access date is a claim that someone saw the
page on that date. When a quote is inherited from earlier research,
inherit its date too -- do not stamp it with the date of the
assembly run.

---

## 1. Action-Data Fixes (closed)

Follow-ups to the D1 means decision, beyond the correction table
kept in RESEARCH_FOOD.md section 7.

Additional fixes (all closed):

- [x] **Standardize the plant-alternative baselines** (closed
  2026-07-20). Every meatless action now deducts the SAME
  documented baseline: 200 g CO2e per 100 g serving
  (beans/lentils, OWID "Other Pulses" mean 1.79 kg/kg = 179 g,
  rounded up to 200 g -- rounding the baseline up rounds the
  saving down). Savings round DOWN to two significant figures:
  beef 9748 -> 9700 (unchanged), chicken 787 -> 780 (was 880),
  pork 1031 -> 1000 (was 1100). Database metadata bumped to
  v1.2; `food_action_consistency_test.dart` asserts the single
  baseline. Seeder impact: `skip_high_impact_food` (9700 g)
  unchanged; `skip_medium_impact_food` (1000 g) now matches the
  pork case exactly and stays inside the chicken-to-farmed-fish
  band (780-1163) -- BUT wild fish (~750 g implied) and small
  oily fish (~350 g) now sit below it; whether that action
  should split or lower is an owner points-economy call
  (flagged in the seeder comment).
- [x] **Swap the beef action's stale quote** -- verified shipped:
  the beef action's `sources[]` carry the mean CSV row, the
  MyCarbon 99.477404614 restatement and the OWID FAQ
  mean-vs-median explanation; no legacy "60 kg" prose quote
  remains.
- [x] **Statistic + losses basis in action notes** -- verified
  shipped: all four food-action notes record "global MEAN with
  supply-chain losses, cradle-to-retail" (FR-15 convention).
- [x] **skip_medium_impact_food vs the new fish items** (owner
      call 2026-07-23: **split fish out**). `skip_medium_impact_food`
      narrows to chicken/pork (1000 g unchanged; relatedSdgs drop
      14). New `skip_fish` ships at 1200 g -- average white/wild
      fish, `fish_wild` 9.5 x 150 g fillet = 1425 g minus the 200 g
      beans baseline (D4) = 1225 g, rounded down to two significant
      figures. In `seed_action_library.js` +
      `action_descriptions_recyc_trans_food.js`; pinned by a
      derivation guard in `food_action_consistency_test.dart`.
      Applied live by the re-seed (bundled with FR-22).

---

## 2. Research-Pass Closures

The per-pass record of what each research and audit pass resolved.
Kept for provenance; the resulting values, rules and pins live in
RESEARCH_FOOD.md sections 3-8.

Resolved 2026-07-18 (first pass): statistic decision (D1, means dataset-wide);
oats conflict (D3 average 1.84); beer basis (D2, 1.2); the
tomato-spread citation replaced with a live-verified Theurl et al.
2014 quote (QA-1); palm-oil tbsp weight closed with the direct
FDC 171015 quote (QA-8); PMC11743834 meat ranges re-verified
verbatim on the live page (QA-8); butter's un-URLed 12.1
candidate dropped with the factor unchanged (QA-3); all quote
hygiene fixes QA-2/4/5/7 applied in sections 3 and 5.

Resolved 2026-07-19 (second pass): the three review product calls
shipped as dataset items (fish_wild 9.50, plant_based_meat 4.5,
tea 9.0 -- sections 3.1, 3.3, 3.7, with pins in section 6 and UI
rules 14-16 in section 8); citrus independent corroboration
closed with two live-quotable sources, confidence raised to High
(Bell & Horvath 2020 + Clune 2017, section 3.6); the unsourced
tomato numeric range replaced with sourced Clune 2017 numbers
(field median 0.45 vs heated greenhouse 2.20, section 3.5);
olive-oil production-only corroboration closed (Ruiz-Carrasco
2023 + two CarbonCloud pages, section 3.9); butter tbsp closed
with the direct USDA FDC 173410 portion, preset updated to 14.2 g
(section 5); oats live input re-read (1.20 unchanged as of
2026-07-19; D3 average still 1.84, section 4 below).

Resolved 2026-07-20 (third pass, four research agents):
**canned beans** shipped as a separate drained-basis item
(beans_canned 1.7, section 3.3) after the dry-equivalent route
failed the honesty check; **small-fish split** shipped
(small_fish 5.5, section 3.1); **Japan sencha LCA** found and
verified (Masuda & Tomioka 2011, 6.28-8.51 per kg aracha --
consistent with the shipped 9.0, which holds; section 3.7);
**plant-based meat independent LCA** found (Detzel/ifeu 2021,
corroborates 4.5, confidence raised, uplift rationale re-based on
boundary; section 3.3); **oats re-read** 2026-07-20: 1.20
unchanged, D3 average holds.

Also resolved 2026-07-20 (same-day follow-up): **JP saba-can
drained weight** -- Sokensha publishes the standard can as
"190g（固形量140g）"; the mackerel-can preset now uses the 140 g
drained weight (section 5). **Whole-iwashi preset** -- shipped at
the 32 g edible portion (Slism "1尾 80gの可食部 32g", corroborated
by the MEXT refuse rate 60%); edible basis matches the factor,
whole weight would overstate 2.5x.

---

## 3. Implementation-PR Dependencies (recorded at research close)

Recorded, not blockers:

- The mean-vs-median methodology explainer and the UI/copy
  behaviors (section 8) must ship WITH the calculator UI; the
  9700 g `skip_high_impact_food` action is user-visible before
  then, so the explainer must not lag the corrected number.
- Schema flags for UI behaviors (preset-only entry, sublabels)
  are deliberately deferred -- additive JSON keys are
  non-breaking to add once the UI design is real.
- Residual preset-name polish (ES patty naming, JA/ES size
  wording) folds into the Part 2 l10n pass.

---

## 4. FOOD_LOGIC_CHECK

Arithmetic and provenance chain per chosen value, as required by
[PLAN_PHASE_8.md](./PLAN_PHASE_8.md) (Part 2). Every derivation
below is also stated with its sources in RESEARCH_FOOD.md
section 3; this is the independent recomputation record.

Arithmetic and provenance chain per chosen value. All OWID sums
recomputed independently by the check agent from freshly
downloaded CSVs (byte-identical to the research-phase copies;
152 automated checks). Access date 2026-07-18 throughout
(2026-07-19 for entries 38-40 and the second-pass closures;
2026-07-20 for entries 41-42 and the third-pass closures).

Conventions verified once for all items:

- Per-kg CSV header (verbatim, FR-17): `Entity,Year,Greenhouse
  gas emissions per kilogram`. (An earlier draft quoted the API
  indicator shortName `ghg_emissions_per_kilogram__poore__and__
  nemecek__2018` as the header -- wrong surface, corrected.)
- Supply-chain CSV columns: Land use change, Farm, Animal feed,
  Processing, Transport, Retail, Packaging, Losses; row year
  stamp 2018. The "2010" vs "2018" year stamps are two views of
  the same dataset, not two vintages.
- Prawns row mapping: per-kg CSV "Prawns (farmed)" = supply CSV
  "Shrimps (farmed)" (FR-17).

Per item (headline = per-kg CSV value; sum = 8-stage supply-chain
total at full precision):

1. **Beef (beef herd) = 99.48.** CSV literal "99.48". Stage sum
   at full precision = **99.4774** (rounds to 99.48; the
   two-decimal addends 23.24+56.23+2.68+1.81+0.49+0.23+0.35+14.44
   total 99.47, so always sum at full precision -- FR-16).
   MyCarbon literal "99.477404614". Three-way agreement. High.
2. *(retired 2026-08-01, D5 -- kept for provenance.)*
   **Beef (dairy herd) = 33.30.** CSV literal "33.3"; sum
   33.3014. Ratio 99.48/33.30 = 2.99 -- inside the 2.5-3.5 band
   pin, NOT "> 3x". High.
3. **Lamb = 39.72.** CSV "Lamb & Mutton"; sum 39.7223. High.
4. **Pork = 12.31.** CSV "Pig Meat"; sum 12.3057. Store 12.31
   exactly (12 display would flatter -2.5%, FR-18). High.
5. **Chicken = 9.87.** CSV "Poultry Meat"; sum 9.8658. High.
6. **Prawns (farmed) = 26.87.** CSV literal; sum 26.8659 via the
   "Shrimps (farmed)" row. Single OWID lineage (Gephart is a
   narrower boundary). Medium-High.
7. **Fish (farmed) = 13.63.** CSV literal; sum 13.6324. Single
   OWID lineage; coarse category (Gephart species range ~5-19 on
   the narrower basis). Medium-High.
8. **Cheese = 23.88.** CSV literal; sum 23.8776. Invariant
   23.88 > 9.87 (chicken) holds. High.
9. **Butter = 12.0 (non-P&N).** Post-QA-3 inputs: 12.2
   (foodfootprint/RIVM: 61 g CO2eq / 5 g = 12.2), 10.18
   (LiveLCA, 12 studies), 11.89 (CarbonCloud, as of 2026-07-18).
   (12.2 + 10.18 + 11.89) / 3 = 34.27 / 3 = **11.42** -> ships
   12.0, rounded UP (honest-not-generous). Original 4-input mean
   11.59 gave the same shipped value. Medium.
10. **Eggs = 4.67.** CSV literal; sum 4.6695. Per large egg:
    4.67 x 0.050 = 234 g CO2e (sane). High.
11. **Milk (dairy) = 3.15.** CSV literal; milks chart "Dairy
    milk ... 3.15" agrees; per L = per kg at density 1.0. High.
12. **Tofu = 3.16.** CSV literal; sum 3.1617. High.
13. **Beans / lentils = 1.79.** CSV "Other Pulses" literal; sum
    1.7864. Distinct from Peas -- the OWID peas quote must never
    be attached here. Medium.
14. **Peas = 0.98.** CSV literal; sum 0.9751. High.
15. **Nuts = 0.43.** CSV literal; sum incl. LUC credit
    -3.257812 + 3.3744068 + 0 + 0.051419526 + 0.10673449
    + 0.04263857 + 0.12374754 - 0.007999532 = 0.43314 -> 0.43.
    Excl. credit (LUC = 0): 0.43314 + 3.257812 = 3.69 (~3.7).
    Never publish a negative. Medium.
16. **Rice = 4.45.** CSV literal; sum 4.4516 (LUC -0.0219, farm
    3.5540 methane-dominated, losses 0.6115). Rice-cooker cup:
    150 g x 4.45 = 668 g CO2e. High.
17. **Bread (wheat) = 1.57 (derived).** No P&N "bread" product;
    map to "Wheat & Rye" = 1.57 (sum 1.5738). No baking energy
    added (outside the grain's farm-to-retail boundary). Slice:
    50 g x 1.57 = 79 g CO2e. Medium.
18. **Pasta = 1.57 (derived).** Same Wheat & Rye mapping (dried
    durum product, no leavening); milling/drying energy not
    added. Portion: 55 g x 1.57 = 86 g CO2e. Medium.
19. **Oats = 1.84 (D3).** Inputs as accessed 2026-07-18: P&N
    "Oatmeal" 2.48 (CSV literal; sum 2.4804) and CarbonCloud
    "Rolled oats" 1.20 (live value at the audit fetch; 1.25 at
    the research fetch -- the drift is why D3 fixes the inputs by
    access date). **(2.48 + 1.20) / 2 = 1.84.** Bowl: 40 g x
    1.84 = 74 g CO2e. Medium. Re-read 2026-07-19 and 2026-07-20:
    live value still 1.20; the average holds.
20. **Potatoes = 0.46.** CSV literal; sum 0.4601. Store 0.46
    exactly. Medium potato: 213 g x 0.46 = 98 g CO2e. High.
21. **Tomatoes = 2.09.** CSV literal; sum 2.0887 (LUC 0.373,
    losses 0.658). Global mean over field + greenhouse; numeric
    spread copy blocked (section 9). High for the mean.
22. **Root vegetables = 0.43.** CSV "Root Vegetables"; sum
    0.4263. High.
23. **Cabbage & broccoli = 0.51.** CSV "Brassicas"; sum 0.5146.
    Store 0.51 exactly (0.5 display would flatter -2.0%, FR-18).
    High.
24. **Onions & leeks = 0.50.** CSV literal "0.5"; sum 0.4968.
    High.
25. **Bananas = 0.86.** CSV literal; sum 0.8619. Per medium
    banana (peeled): 0.86 x 0.118 = 101 g CO2e. Svanes 1.37
    (fuller chain, higher -- consistent); FAO range 0.32-1.12
    brackets it. Peel factor if whole-fruit basis ever needed:
    1/(1-0.36) = 1.5625. High.
26. **Apples = 0.43.** CSV literal; sum 0.4284. Per medium apple:
    0.43 x 0.182 = 78 g CO2e. China farm-gate 0.23 + chain is
    consistent. High.
27. **Citrus = 0.39.** CSV "Citrus Fruit"; sum 0.3876 (LUC
    -0.146). Per orange: 0.39 x 0.131 = 51 g CO2e. Independent
    corroboration order-of-magnitude only (open item).
    Medium-High.
28. **Berries = 1.53.** CSV "Berries & Grapes"; sum 1.5319.
    Per cup strawberries: 1.53 x 0.144 = 220 g CO2e. Blend
    caveat. Medium.
29. **Dark chocolate = 46.65 (D1).** CSV literal; mean sum
    25.814833 + 6.687002 + 0 + 0.3337439 + 0.1108714
    + 0.037652217 + 0.7224336 + 12.940208 = **46.6467** -> 46.65.
    LUC share 25.81/46.65 = 55%. Fallback provenance (NOT
    shipped): median-without-losses stages 14.3 + 0 + 3.7 + 0.2
    + 0.1 + 0.4 + 0 = 18.7 (LUC 76%), reproduced live from the
    archived endpoint (section 1). Per 28 g shipped preset:
    46.65 x 0.028 = 1.31 kg CO2e; per 12.6 g square: 0.59 kg.
    Medium.
30. **Cane sugar = 3.20.** CSV literal "3.2"; sum 3.1989 (LUC
    39%). Per tsp: 3.20 x 0.0042 = 13.4 g CO2e. Medium-High.
31. **Olive oil = 5.42.** Not in the per-kg CSV (absence
    confirmed); factor = stage sum -0.3236843 + 3.672172 + 0
    + 0.5671888 + 0.41411418 + 0.039322365 + 0.7401167
    + 0.31564602 = **5.4249** -> 5.42. Net-negative LUC. Per
    tbsp: 5.42 x 0.0135 = 73 g CO2e. Medium.
32. **Palm oil = 7.32.** Not in the per-kg CSV; stage sum
    2.7555852 + 1.875132 + 0 + 1.1253257 + 0.18511687
    + 0.038737673 + 0.78810805 + 0.5487651 = **7.3168** -> 7.32.
    LUC 2.756/7.317 = 38%. Per tbsp (13.6 g, FDC 171015):
    7.32 x 0.0136 = 100 g CO2e. Medium.
33. **Coffee = 28.53.** CSV literal; sum 28.5279. Per-cup chain:
    10 g x 28.53 / 1000 = **0.2853 kg CO2e/cup** -- mid-range of
    the published 0.1-0.4 kg/cup band. At P&N's own 15 g
    functional unit: 0.4280 kg, reproducing P&N's 0.4/cup (and
    co2everything's 0.4) -- factor and dose internally
    consistent. Implied per-kg from the manuscript: 0.4/0.015 =
    ~26.7 (grapher 28.53 adds losses). Mistype guard: 250 g
    entered as "a 250 ml cup" computes 7.13 kg = **18-71x** the
    published per-cup band (25x the 10 g preset) -- preset-only
    entry required (FR-16 corrected the earlier "35-70x").
    High (anchor); per-cup Medium (dose-dominated).
34. **Beer = 1.2 /L (D2).** P&N manuscript: 0.24 kg CO2e per
    unit (mean); 1 unit = 10 ml alcohol; at 5% ABV volume per
    unit = 10/0.05 = 200 ml; 0.24/0.200 = **1.2 kg/L**. Per
    330 ml can: 0.396 kg. Spread context (science sheet only):
    A&A packaged formats (0.842 + 0.575 + 0.510)/3 = 0.642;
    averaged with co2everything 0.70 -> **0.671 (~0.67)**
    (FR-16 corrected the earlier "~0.68"); cross-study range
    0.400-1.475/L. Medium.
35. **Wine = 1.79 /L.** Manuscript: 0.14 kg/unit at 12.5% ABV;
    volume per unit = 10/0.125 = 80 ml; 0.14/0.080 = 1.75 /L;
    grapher 1.79 (losses included) adopted. Per 150 ml glass:
    0.269 kg; per bottle: 1.79 x 0.75 = 1.34 kg, inside Nature's
    0.06-3.0 kg/bottle range. High.
36. **Soy milk = 0.98 /L.** Per-kg grapher 0.98; milks chart
    0.98; manuscript mean ~1.0 -- triple agreement. Per 250 ml
    glass: 0.245 kg (co2everything 0.25). High.
37. **Oat milk = 0.9031262 /L.** Milks chart literal (store
    exact; displays 0.90). Per 250 ml glass: 0.226 kg
    (co2everything 0.22). "Oatmeal" 2.48 in the per-kg grapher is
    the GRAIN -- never use it for the drink. Medium.
38. **Fish (wild-caught) = 9.50 (assembled, added 2026-07-19).**
    Wild-mix construction: Gephart six-group farm-gate mean
    (7.6290536 + 6.8813386 + 3.8779404 + 5.1250386 + 9.6651745
    + 9.91465) / 6 = 7.182; + P&N fish post-farmgate stages excl.
    losses (0.04459863 + 0.24795863 + 0.08997562 + 0.13753739 =
    0.520) = 7.702; x 1.1747 losses uplift (P&N fish losses
    2.0271 / pre-loss 11.605 = 17.5%) = 9.048 -> 9.05.
    Canned-tuna construction: 7.629 + 1.38 (canning energy, high
    end) + 0.520 = 9.529 -> 9.53; no loss uplift (shelf-stable).
    Mean (9.05 + 9.53) / 2 = 9.29 -> ships 9.50 (rounded up,
    butter precedent). Per JP can: 70 g x 9.50 = 665 g CO2e; per
    fillet: 110 g x 9.50 = 1.05 kg. Store-shelf corroborators
    9.03-9.36 (CarbonCloud, as of 2026-07-19). Medium.
39. **Plant-based meat = 4.5 (assembled, added 2026-07-19).**
    (3.4 + 3.5) / 2 = 3.45; x 1.3 boundary/commissioner uplift =
    4.485 -> ships 4.5 (rounded up). Per 113 g patty: 0.51 kg
    CO2e vs beef patty 11.24 kg (~22x lower; the beans proxy
    overstated the gap at 56x). Medium.
40. **Tea = 9.0 (assembled, added 2026-07-19).** Leaves-only
    candidates: Doublet & Jungbluth retail-scenario mean
    ((46.9 - 33.0) + (51.6 - 33.0) + (44.9 - 33.0) +
    (49.5 - 33.0)) / 4 = 15.225 g/cup / 1.75 g = 8.70;
    Cichorowski base case 17.8 g / 2 g = 8.90; Xu five-product
    mean (19.2 + 19.9 + 11.9 + 6.6 + 4.5) / 5 = 12.42; Premalatha
    leaves-only stage sums 1.5 + 2.506 + 2.34 + 0.096 = 6.44
    (black) and 1.5 + 1.88 + 2.34 + 0.096 = 5.82 (green), mean
    6.13. (8.70 + 8.90 + 12.42 + 6.13) / 4 = 9.04 -> ships 9.0.
    Per tea bag: 2 g x 9.0 = 18 g CO2e; per loose-leaf cup: 3 g =
    27 g. Kenya (~2.0) and Sri Lanka (~21.6) bracket the range.
    Medium. JP check 2026-07-20: Masuda & Tomioka mean (6.28 +
    8.51) / 2 = 7.40; five-study mean (36.15 + 7.40) / 5 = 8.71
    (sensitivities 8.49-8.93) -- all round to 9, factor holds.
41. **Small oily fish = 5.5 (assembled, added 2026-07-20).**
    Fresh: (3.8779404 + 0.52007027) x 1.1747 = 5.166 -> 5.17.
    Canned: 3.8779404 + 0.52007027 + 1.38 = 5.778 -> 5.78. Mean
    (5.17 + 5.78) / 2 = 5.47 -> ships 5.5 (rounded up). Per
    mackerel can (drained 140 g): 770 g CO2e; per sardine can
    (drained 92 g): 506 g; per whole sardine (edible 32 g):
    176 g. Fuel corroboration: purse
    seine 71 L/tonne = 0.071 L/kg x ~2.7 kg CO2/L diesel = ~0.19
    kg CO2/kg landed from fuel, consistent with the low farm-gate
    anchor. Medium-High.
42. **Beans (canned) = 1.7 per kg DRAINED (assembled, added
    2026-07-20).** Candidate 1: 1.10 as-sold / (10.5 / 15.5 =
    0.677 drained fraction) = 1.62. Candidate 2: content 1.79 /
    2.5 = 0.716; canning-and-can share (0.19 + 0.42) x 1.10 =
    0.671 as-sold / 0.677 = 0.991; 0.716 + 0.991 = 1.71. Mean
    (1.62 + 1.71) / 2 = 1.665 -> ships 1.7 (rounded up). Tidaker
    0.8 = peer-reviewed lower bound (carton format, not
    averaged; averaging it in would give 1.38 -> 1.4, and the
    conservative rule keeps 1.7). Hydration cross-check: dry
    matter (100 - 11.0) / (100 - 65.7) = 2.60x; Bean Institute
    volume route 2.66x; conservative 2.5x -> 130 g drained = 52 g
    dry. Per serving: 130 g x 1.7 = 221 g CO2e (old inconsistent
    arithmetic gave 233 g -- near-right magnitude on a wrong
    basis). Medium.

Cross-checks on the action corrections (section 7; standardized
200 g baseline as of 2026-07-20): beef 9948 - 200 = 9748 ->
9700; chicken 987 - 200 = 787 -> 780; pork 1231 - 200 = 1031 ->
1000; milk delta (3.15 - 0.903) x 0.25 = 0.5618 kg (562 g),
shipped 460 g conservative; soy variant (3.15 - 0.98) x 0.25 =
543 g, still conservative.

Serving-preset sanity (grams x factor, spot values): beef patty
11.24 kg; steak 22.38 kg; chicken fillet (170 g) 1.68 kg; pork
chop 1.72 kg; prawn portion 2.96 kg; salmon fillet 2.70 kg;
egg 234 g; cheese portion 716 g; rice cup 668 g; banana 101 g;
chocolate 28 g 1.31 kg; coffee cup 285 g; beer can 396 g; wine
glass 269 g. All recomputed and consistent with the factors
above.

43. **Prawns (wild-caught) = 34.08** (added 2026-08-02). Not a
    P&N row; assembled by ratio, not by the additive fish_wild
    recipe. Inputs, all CSV literals re-downloaded 2026-08-02:
    Gephart `ghg-emissions-seafood.csv` "Shrimp (wild),2021,
    11.956739" and "Shrimp (farmed),2021,9.428016"; P&N
    `food-emissions-supply-chain.csv` "Shrimps (farmed),2018,
    0.33056307,13.453979,4.0299387,0,0.33085158,0.3523611,
    0.5361473,7.832022" (stage sum **26.8659**, matching the
    shipped farmed 26.87 -- FR-16 full precision).
    Arithmetic: 11.956739 / 9.428016 = **1.268215**; 26.8659 x
    1.268215 = **34.0717** -> ships **34.08** (rounded up,
    honest-not-generous).
    **Control that rejected the additive route:** post-farmgate
    excl. losses = 0 + 0.33085158 + 0.3523611 + 0.5361473 =
    **1.219360**; loss uplift = 7.832022 / (26.8659 - 7.832022) =
    **0.411479**. The recipe reproduces the documented fish
    figures exactly (post 0.520, uplift 17.5%), so it was applied
    correctly -- but run on Gephart's FARMED shrimp it returns
    (9.428016 + 1.219360) x 1.411479 = **15.03** where P&N gives
    26.87. The two sources disagree about prawns by ~1.8x, so the
    additive route lands on Gephart's scale, not this dataset's;
    it would have shipped 18.60 and told users wild prawns are
    31% better than farmed when the like-for-like evidence says
    27% worse. Medium confidence: the ordering is robust, the
    absolute value is bracketed 18.60-34.08. Known weakness,
    stated in `calculation_notes`: ratio-scaling implicitly
    scales land-use-change and feed stages a wild fishery does
    not have.

---

## 5. Tree-nut / peanut split (executed 2026-08-08)

A live defect, not a v2 addition: the shipped `nuts` item carried
peanut aliases on P&N's orchard-nut row, so every peanut query
resolved to 0.43 against the Groundnuts row's 3.23 -- **7.5x too
low** -- and peanut butter with it.

Applied:

- `nuts` -> `tree_nuts` (0.43 unchanged, Table S1 basis "1 kg of
  shell free, dry nut" declared, orchard LUC credit -3.257812
  disclosed in user-facing notes, all peanut aliases removed,
  chestnuts excluded as a wrong-basis product).
- New `peanuts` 3.23 (`Groundnuts,2010,3.23`, stage sum 3.23001357,
  Table S1 basis "1 kg of shell free, roasted nut"). Peanut butter
  rides this row via 21 CFR 164.150 alone.
- Wave 4's raw-to-roasted uplift of 1.050161 on top of 3.23 is
  **withdrawn** -- the P&N parent is already roasted, so it double
  counted (would have shipped 3.3920181818).
- Dataset 42 -> 43 items, `plant_protein` 5 -> 6; `FOOD_ITEM_COUNT`
  bumped. Pinned by `food_dataset_invariants_test.dart` 11b (both
  exact values plus the ordering) and an alias guard in
  `food_items_data_test.dart`.
- Never-pin additions: tree nuts vs peanuts (the 7.46x gap is the
  orchard credit; stripping it inverts the order), and peanuts into
  the ~3.2 cluster with tofu/milk/cane sugar.

No action or seeder value moves: none of them reference nuts.

---

## 6. v2 build record (executed 2026-08-08)

The dataset went from 43 to **166 items**. Ten research waves had
already run in an earlier session; their per-item output (about
750 KB, with quotes, URLs and arithmetic) survived only in that
session's scratchpad and was recovered and preserved before it was
consolidated. `FOOD_ITEMS_V2_LIST.md` sections 4 and 8 were both
stale when the work resumed: wave 9 had in fact completed a full
re-run, and the picker had already gained search, alias ranking, a
lazy list and group icons.

Consolidation, in order:

1. Six extraction agents converted the wave output into shippable
   rows, one per group family, plus one agent per open decision.
2. Merge precedence: corrections over extraction, one seafood route,
   wave 9 over the earlier dairy pass for `margarine`.
3. **Four shipped items would have been silently dropped** -- tofu,
   plant-based meat, beans/lentils and canned beans. The waves only
   researched new and changed items, so a straight merge lost the
   ones nobody had needed to revisit. Caught by diffing against the
   shipped dataset; carried forward unchanged.
4. Five umbrella rows retired into species rows (root_vegetables,
   cabbage_broccoli, onions_leeks, citrus, berries) and `fish_wild`
   retired by D8.
5. All 162 new/changed `calculation_notes` were rewritten for users.
   The research agents wrote them as internal memos -- ALL-CAPS
   directives to the copy engine, route codes, wave numbers, "does
   not ship" -- and that field renders verbatim in the science
   sheet. Mechanically re-checked afterwards for route codes, rule
   numbers, field names and internal dates.
6. Evidence gaps closed: 58 items cited FAO, FDA RACC, USDA FDC and
   MEXT by name with a verbatim quote but no URL. The FAO citations
   (79 of them) were `http://` Wayback captures; all four captures
   were re-fetched over https and **79 of 81 quotes matched
   verbatim**. The two misses were real errors: `melon` and
   `watermelon` were attributed to FAO Ch. 8 (Fruits) when those
   rows are in Ch. 7 -- FAO classes melons as vegetables -- and
   their citations were corrected.
7. Two rows had defects rather than gaps. `butter` had absorbed the
   cut `cream` item as a 15 g preset sourced from an FDA row for
   fluid cream, and carried cream, double cream, nata and 生クリーム
   as aliases -- routing cream to 12.0 when the agent's own source
   list measures it near 0.82. Cream is now uncovered and tracked as
   an open item (RESEARCH_FOOD.md section 9). `yogurt` lost an
   unsourced 400 g tub preset.
8. 18 aliases repeating their own item's display name were stripped
   (duck, tuna, salmon, sugar, tofu, bread, both oils and others);
   the pin now checks all three locales, not just English.
9. Field hygiene, all caught by a new guard that reads the JSON
   directly rather than through the model's defaults: 58 `"MISSING"`
   placeholder strings cleared to nulls or real defaults; 19 rows
   normalised from free-text `weight_basis` values to the five-value
   enum, with the qualifiers moved into user-facing notes; and three
   items (honey, jam, canned_soup) re-written for users after the
   gap-fill patch overwrote the notes pass on them.

Pins re-derived, per the standing rule that they are data pins and
not truth claims:

| Pin | v1 | v2 |
|-----|----|----|
| 1 beef is the maximum | +51% over chocolate | **+12.9%** over instant coffee 62.33 |
| 7 chicken > all plant food | all rows | **as-purchased rows only** -- dried shiitake 18.62 and tomato paste 11.14 clear it once the water is gone |
| 11/12 seafood ordering | farmed > wild > small | **tier-2 chain** crab_lobster > tuna > small_fish > bivalves > seaweed |
| 14 assembled values | incl. fish_wild 9.5, small_fish 5.5 | **v2 seafood set** incl. both prawn values |

---

## 7. D8: the seafood source decision (2026-08-08)

**Question:** the seafood group needs species resolution Poore &
Nemecek does not have (one global farmed-fish row), but the only
source that has it, Gephart et al. 2021, measures at a narrower
boundary and its own Supplementary Information states it excludes
methane and nitrous oxide from aquaculture ponds -- the dominant
term for pond-farmed shrimp specifically. Going Gephart-uniform
would drop `prawns_farmed` from 26.87 to 9.43, **-65% on a
user-visible number**.

**Decided: P&N anchors every row it resolves; Gephart fills only
the gaps, tagged tier 2.** `prawns_farmed` stays 26.87.

The decisive argument was not the pond mechanism. Completing
Gephart's farmed shrimp to this dataset's boundary gives
(9.428016 + 1.219360) x 1.411479 = 15.028545, so the two sources
jointly imply a cradle-to-retail band of **15.03-26.87**. 9.428016
sits 37% below its own floor because it is not a cradle-to-retail
number at all -- 52% of the 2.85x gap is boundary, 44.9 points of
it P&N's supply-chain losses stage. Shipping 9.43 swaps the
quantity rather than choosing between estimates of it, and 26.87 is
the only value in the band that is published rather than assembled.

Verification: every wave-2 quote re-checked live, nothing retracted.
Two new findings -- at a matched farm gate Gephart's chicken sits
**21% above** P&N's, so Gephart is not a systematically low model
and the shrimp gap is species-specific; and no source published
since 2021 gives a per-kg pond CH4/N2O term for shrimp at this
evidence bar, so that option is closed for a second time. IPCC 2019
Refinement Table 7.12 is citable but per-hectare, and converting it
spans 0.115 to 32.7 kg CO2e/kg -- two and a half orders of
magnitude around the residual.

Consequences: `fish_wild` 9.5 and `small_fish` 5.5 were assembled by
a harmonisation recipe the review found unsound; `fish_wild` splits
into `white_fish` 5.1250386 and `tuna` 7.6290536, `small_fish`
re-bases to 3.8779404. `skip_fish` falls 1200 g -> 560 g. Pin 15
(`prawns_wild > prawns_farmed`) survives under this route and would
have broken under Gephart-uniform.

---

## 8. Shipped-value corrections (verified 2026-08-08)

Five of six findings against the shipped dataset were **already
applied to the JSON** -- it was RESEARCH_FOOD.md section 4's value
table that had gone stale, not the data. Confirmed correct as
shipped: `pasta` 2.2904440789473684 (bread-moisture route, honest
band 2.02-2.29), `bread_wheat` 1.57 (value right, notes rewritten --
the old note wrongly claimed baking was outside the boundary when
the functional unit is bread at retail), `peas` 0.53 on the
vegetable anchor with the dry-pea quote removed, `sugar` 2.922 on
the 80/20 cane/beet split, and both oils on the D7 FDC densities.

The sixth was a live defect and is fixed separately: see section 5.

---

## 9. v2 verification pass (run 2026-08-08)

**Why it was needed.** The v2 build shipped 166 items without the
verification its own agents were meant to provide: both the gap-fill
and notes agents died on a session limit after writing their patches
but before writing their reports, so their flagged-contradiction
lists were lost. The dataset went out validated mechanically but not
reviewed. This pass closed that gap.

**Method.** Three parallel audits, report-only, with all fixes applied
centrally so the dataset had one writer:

| Audit | Coverage |
|---|---|
| Alias misrouting | ~2,000 search terms across 166 items, run through a reimplementation of the shipped ranking so each finding states what a term *actually* resolves to |
| Citation verification | 750 of 903 sources (83%), including all 574 non-P&N citations |
| Internal coherence | all 166 items: notes vs data, basis vs presets, physical floors, plausibility, flag coherence |

**The pass worked -- it found defects that mechanical validation could
not.** Headline findings:

- **A FABRICATED QUOTE.** `melon` and `watermelon` each carried, in
  quotation marks, a sentence that appears nowhere on the cited FAO
  page and nowhere in the wave research: "Although melons and
  watermelons are generally considered to be fruits, FAO groups them
  with vegetables because they are temporary crops." It is a
  paraphrase of the genuine sentence, invented at assembly time.
  **Removed from both** (each already carried the real sentence, so
  nothing was lost). This is the most serious category possible for
  this dataset, whose entire credibility rests on every quote being
  checkable, and no automated check would ever have caught it.
- **A mis-linked standard.** `tomatoes` cited "Codex CXS 13-1981,
  Preserved Tomatoes" but linked `CXS_057e.pdf`, which is CXS 57
  (Processed Tomato Concentrates); the quote is provably absent from
  the linked document, verified by retrieving and searching it. CXS 13
  could not be retrieved from that session, so the citation was
  removed and the claim it supported -- that tinned tomatoes log at
  the fresh factor -- was downgraded in the user-facing notes from a
  regulatory citation to a stated working assumption.
- **The app asserts things the research forbids.** `comparable` and
  `tie_group` are written on all 166 rows and read by **zero lines of
  app code**. The consequence: the comparison gate ranks tree nuts as
  87% better than peanuts, a pair section 6 says must never be ranked
  in either direction because the gap is entirely an accounting
  artefact. Still open.
- **`shellfish` and `marisco`** sit on `prawns_farmed` (26.87) ahead
  of `bivalves` (1.399), so the ordinary umbrella word for shellfish
  in two languages logs mussels and clams **19.2x too high**. The same
  class as the peanut and cream defects, and the third instance found.
  Still open.

**Also fixed in this pass:** dry-basis staples gained cooked-weight
presets (rice, pasta, beans/lentils), each converting a 100 g cooked
portion to its dry equivalent from that item's own documented
hydration ratio, with the conversion shown in the label rather than
hidden. This closes the alias finding that cooked-rice searches
(`ご飯`, `ライス`) landed on a dry-basis row with a grams field, a 2.2x
error path. FDA RACC's "140 g prepared; 45 g dry" was explicitly NOT
used as a yield -- those are independent serving conventions and give
3.11x against the MEXT mass balance's 2.13x.

**A fourth audit closed the 64 unverified sources** (the citation
agent delegated them rather than leave them at an HTTP-status check).
All 64 were reached: 62 quotes confirmed, 1 absent, 1 augmented. It
found the same *class* of defect as the fabrication, plus one finding
that is not a citation problem at all:

- **A selectively elided quote.** `plant_based_meat` cited Saget et al.
  2021 as "... including a 77% smaller climate change burden ...
  compared with Brazilian beef patties." The ellipsis removes exactly
  the clause that runs against the item: the real sentence continues
  "**but incur 8% more energy use**". Quote restored in full.
- **That same source contradicts the number it was cited to support.**
  Saget's Table 3 gives 1.5 kg CO2e for a 113 g plant patty, about
  13 kg/kg, against the shipped 4.5 -- roughly **3x**, on a scale
  where the study's beef patties (4.5-6.6 kg/patty) sit close to ours
  (7.95). The shipped figure averages two company-commissioned
  assessments and uplifts them by 1.3. The disagreement is now stated
  in the item's own user-facing notes, and **the value itself is an
  open owner question**: 4.5 may be too generous to plant-based meat.
- **Three headline numbers rest on live aggregator pages, not the
  study class their notes claim.** `butter`'s "three independent dairy
  LCAs" are a national-database portion figure, a meta-aggregator and
  a modelled benchmark -- one of which moved 15% (13.70 -> 11.89)
  between archive captures. Note corrected. `oats` takes half its
  value from a live CarbonCloud page; `beans_canned` and
  `chickpeas_canned` (1.7) have *both* legs of their mean depending on
  the same autogenerated aggregator value, so the triangulation is
  illusory, and the only peer-reviewed anchor cited (Tidaker, 0.8) is
  less than half the shipped figure.
- **A cited source that halves the shipped number, unmentioned in the
  notes.** `beer` carries a co2everything page implying 0.704 kg/L
  against the shipped 1.20. A user who taps it lands on 41% less.
- **Quotes swapped between hosts** on `cured_meat` (the wording
  belongs to the navarra.es PDF, not the mapa.gob.es page), and that
  navarra.es URL has been returning 502 since well before its claimed
  access date.
- **Synthesised quote text**: `baked_beans` quotes "Per 1/2 Can
  (207.5g)" as label text Heinz does not print (the derivation is
  right, the presentation is not); four Open Food Facts citations
  concatenate two JSON fields into a single quoted string; and
  `frozen_pizza`'s 170 g half-pizza preset is unsourced by the page
  cited for it.
- **A note contradicted by its own citation**: `asparagus` says the
  12.2 figure "is not theirs" of Stoessel et al., while the cited
  Schwarz paper explicitly attributes 12.2 to Stoessel.

Verified clean and worth recording: every EUR-Lex, NTA, Codex-reachable,
Shimadaya, Nissin, Lawson, McCain, One Stop and Crossref citation
checked reproduced verbatim with its arithmetic, as did all 176 OWID
rows re-fetched as a spot-check. Access dates are all plausible and in
the past. No dead URLs beyond the navarra.es case above.

**Open after the pass** -- recorded so the next reader is not misled
into thinking the dataset is clean:

- Wire `comparable`/`tie_group` into the verdict gate, or remove the
  fields. Read by nothing today, they mislead anyone who assumes the
  never-pin rules are enforced.
- `milk_chocolate` 14.9 sits below the floor its own published recipe
  implies (~23 priced on sibling rows) and the app ranks it 68%
  better than dark chocolate.
- `crisps`, `popcorn`, `instant_noodles` sit 3-4% below their own
  floors: their oil leg never received the density correction that
  `margarine` and `mayonnaise` did.
- `peanut_butter` still carries the double-counted roast uplift.
- Six items default to a prepared weight on an as-purchased factor
  (`sweetcorn` ~2.8x, `takenoko` 2-3.5x, `melon`/`pineapple` ~2x).
- `edamame` on a dry-pea anchor (~3x); `soy_tvp` declared dry on a
  wet-tofu factor with its rehydration ratio never applied.
- Duplicate user-visible rows: `bread`/`bread_wheat`,
  `palm_oil`/`palm_soy_oil`.
- **`plant_based_meat` 4.5 may be ~3x too low** on its own cited
  peer-reviewed source. Owner call: re-research, or keep and disclose
  (disclosure is in place today).
- `beer` carries a cited page implying 0.704 kg/L against the shipped
  1.20, unmentioned in the notes -- remove the source or address it.
- `beans_canned` / `chickpeas_canned` 1.7: both legs of the mean trace
  to one autogenerated aggregator value; the triangulation is not real.
- `oats` 1.84 takes half its value from a live aggregator page.
- `cured_meat`: two quotes attributed to the wrong host, and a cited
  "live" government URL that has been 502ing since before its access
  date.
- Synthesised quote text on `baked_beans` and four Open Food Facts
  citations; `frozen_pizza`'s 170 g preset unsourced by its citation.
- `asparagus` notes contradict the paper they cite about Stoessel.
- 153 josephpoore.com PDF/XLS citations were never reached. That is now
  the weakest remaining evidence class; the 64 retail/aggregator/EU-law
  sources have since been fully checked.

**Caveat on the pass itself.** It ran against a dataset being
concurrently modified by another session, which during the same window
changed the electricity grid factor in `transport_modes.json` and
rewrote `co2_actions_database.json`, deleting the four food action ids
that `food_action_consistency_test.dart` asserts on. Those five test
failures are not defects in this dataset. Any finding above should be
re-checked against the tree once both sessions have landed.
