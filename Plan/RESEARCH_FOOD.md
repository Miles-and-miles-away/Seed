# Food Emission Factor Research

**Version:** 3.0
**Created:** 2026-07-18
**Status:** **167 items shipped** (v2 dataset 2026-08-08 plus
`cream`, 2026-08-29); owner
decisions D1-D11 applied. **Restructured 2026-08-29 to match the
transport and energy pattern: this document is the evidence base
only.** The standing decisions, the comparison gating, the
action-library additions, the binding copy and UI rules and the
live open list moved to
[PDR_FOOD_CALCULATOR.md](./PDR_FOOD_CALCULATOR.md), which is now
the only live open list for this workstream. v2 widened the dataset
from 43 items via ten research waves, retired five umbrella rows
into species rows, and settled the seafood source question (D11).
The per-pass closure log, the closed action-data fixes, the v2
build record and the FOOD_LOGIC_CHECK recomputation live in
[RESEARCH_FOOD_ARCHIVE.md](./RESEARCH_FOOD_ARCHIVE.md), which is
closed history and carries no live instructions.
**Feeds:** `data/app/food_items.json` (Phase 8.7, see
[PLAN_PHASE_8.md](./PLAN_PHASE_8.md) Part 2).

Reference document for the food carbon calculator dataset: the
methodology, the source landscape, the verified factors, the
chosen values, the serving presets and the sanity invariants,
plus the full derivations for the v1 core. The owner decisions
and the binding copy rules are **not** here; they are in
[PDR_FOOD_CALCULATOR.md](./PDR_FOOD_CALCULATOR.md). Follows the
sourcing rules in
[AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) (sections 2 and 8).

**Per-item provenance for the v2 additions lives in the JSON, not
here.** 58 of the 166 v2 item ids appear in this document; the
other 108 arrived through the ten v2 research waves, whose
per-item output (~750 KB of quotes, URLs and arithmetic) never
reached the repo and is gone (RESEARCH_FOOD_ARCHIVE.md section 6). What
survives is complete and test-enforced: all 167 items carry
`sources[]` with `{name, url, quote, accessed}` -- 916 source
objects, no empty field on any of them -- plus `calculation_notes`,
and `test/features/food/data/food_items_data_test.dart` ("every
item has at least one complete source") asserts every field on
every row. So `data/app/food_items.json` is the authority on what
an item cites; this document is the authority on why the number is
what it is, and the two must not be assumed to overlap.

Unit for every factor: **kg CO2e per kg of food as-purchased**
(raw / dry weight; liquids at density 1.0 so per-litre = per-kg).

**How section references read below.** "PDR section N" means
[PDR_FOOD_CALCULATOR.md](./PDR_FOOD_CALCULATOR.md): its section 4
is the action-data consistency rules, section 5 the binding copy
and UI rules (cited here as "copy rule N"), section 6 the single
live open list. "Archive section N" means
[RESEARCH_FOOD_ARCHIVE.md](./RESEARCH_FOOD_ARCHIVE.md): its
section 4 is the FOOD_LOGIC_CHECK recomputation record. A bare
"section N" is a section of this document.

---

## 0. Method in brief

Required by [DOCUMENT_TYPES.md](./DOCUMENT_TYPES.md) section 3:
how these numbers were arrived at, in rules rather than figures.
It is numbered 0 so the existing section numbers, which the
dataset's `calculation_notes` and the PDR cite by number, keep
resolving. **No value appears in this section**, deliberately --
a summary that restates a figure becomes a second home for it and
drifts.

**Primary source, and why.** Poore & Nemecek 2018, read through
Our World in Data's live graphers. It is chosen for one property
above all: it covers the whole food list on **one boundary and
one statistic**. Every alternative database sits on a different
boundary, a different statistic, or different land-use
accounting, and bolting one onto this anchor produces orderings
that are artefacts of the sources -- cured meat beating its own
raw parent, nut butter below its only input, yogurt below milk.
Mixed sources are allowed where the anchor has no row; **ranking
across them is not**.

**Statistic.** The production-weighted mean including
supply-chain losses, as the grapher publishes it today. Not the
famous median set, which the publisher retired: the median is
still an approved fallback, but any item using it must say so in
its notes and on the science sheet. The methodology page tells
users the mean-versus-median story unprompted, because they will
cross-check against the well-known chart.

**Boundary.** Cradle-to-retail, land-use change included. Home
cooking, home refrigeration and the trip to the shop are outside
it, and the science sheets say so rather than leaving a reader to
assume the number covers a meal end to end.

**Functional unit: per kg of food as purchased** -- raw or dry
weight, with liquids taken at density 1.0. Serving presets exist
to convert what a person eats into that as-purchased weight, and
they are where the largest silent user errors live: a cooked
weight typed as a raw one, a whole-fish weight typed as an edible
one, a volume typed into a grams field.

**Precision and rounding.** The dataset stores exact unrounded
values and the UI rounds for display, so a rounded figure never
becomes the stored one. Savings claimed by an action round down,
and a baseline subtracted from a saving rounds up; both push the
reward toward the smaller, honest end.

**What "verified" means here.** The factor was seen
digit-for-digit on the live grapher CSV, reproduced independently
from its supply-chain stage sum, and corroborated by at least one
independent source for magnitude and ordering -- never for exact
digits, which do not match across meta-analyses and are not
expected to.

**Two things a reader would otherwise trip over.**

1. **Many items deliberately share one number.** The anchor
   resolves to a category, not a species, and there are far more
   findable foods than researched values. A shared value is
   recorded as a tie group so the app cannot rank inside it; that
   is a statement about the resolution of the evidence, not an
   oversight to be fixed by inventing precision.
2. **The app refuses comparisons it cannot defend.** A gap has to
   clear a floor, a wider bar when the two sides draw on
   different source tiers, and a wider one still when an
   ingredient's own two published statistics disagree by more
   than a factor. The bars themselves are product rules and live
   in PDR section 5; what belongs here is why they exist, which
   is that a minority of high-impact producers pulls each average
   above the typical farm and close pairs swap places between
   statistics.

---

## 1. Source Landscape (verified 2026-07-18)

### Primary anchor: Poore & Nemecek 2018 via Our World in Data

Poore, J., & Nemecek, T. (2018), "Reducing food's environmental
impacts through producers and consumers", Science 360(6392),
987-992 -- ~38,700 farms, 119 countries, 40 products -- as
processed and published by Our World in Data (OWID, CC BY). Three
OWID surfaces carry the data:

- **Per-kg headline grapher** `ghg-per-kg-poore`
  (https://ourworldindata.org/grapher/ghg-per-kg-poore.csv,
  accessed 2026-07-18). CSV header (verbatim):
  `Entity,Year,Greenhouse gas emissions per kilogram`.
  Indicator metadata (variable 1206176,
  https://api.ourworldindata.org/v1/indicators/1206176.metadata.json):
  `"lastUpdated": "2019-10-08"`, and verbatim:
  > "Global average greenhouse gas emissions (GHG) per kilogram
  > of food product. This is measured in kilograms of
  > CO2-equivalents per kilogram of product (kgCO2eq per kg)."
  > "All comparisons here are based on the global mean value per
  > food product across all studies."
  > "The data set covers ~38,700 commercially viable farms in 119
  > countries and 40 products representing ~90% of global protein
  > and calorie consumption'."
  (The odd trailing apostrophe in "consumption'." is in OWID's
  JSON. The "2010" year stamp on every row is the study's
  reference-year label, not a data vintage.)
- **Supply-chain breakdown grapher** `food-emissions-supply-chain`
  (https://ourworldindata.org/grapher/food-emissions-supply-chain.csv,
  accessed 2026-07-18). Eight stages (land-use change, farm,
  animal feed, processing, transport, retail, packaging, losses)
  that sum digit-for-digit to the per-kg headline for every item
  (verified across all 37 sums, archive section 4).
- **Plant-milk comparison grapher** `environmental-footprint-milks`
  (https://ourworldindata.org/grapher/environmental-footprint-milks.csv,
  accessed 2026-07-18) -- per-litre figures; the only OWID source
  for oat milk (the per-kg grapher's "Oatmeal" is the grain, not
  the drink -- a trap).

### The mean-vs-median finding (decides every skewed item)

P&N publishes, for each product, **both a mean and a median**, and
OWID has exposed both over time. They differ a lot for skewed
products (beef 99.48 mean vs 60 median; dark chocolate 46.65 vs
18.7). OWID's FAQ states it directly (verbatim, accessed
2026-07-18, https://ourworldindata.org/faqs-environmental-impacts-food):

> "On one chart you previously showed a value of 99.5 kilograms
> CO2eq per kilogram of beef from beef herds. On another, it was
> shown as 60 kgCO2eq per kilogram. Why were these values
> different? ... The former showed the mean, and the latter the
> median. This is how the data is made available in the underlying
> study from Poore and Nemecek (2018). ... We updated the data on
> the breakdown of emissions on 15th June 2022 based on
> supplementary data provided by the author, with supply chain
> losses included, and given as the mean. This means these two
> charts are now consistent."

The two coherent value sets, stated precisely (per the data review -- FR-6 and
FR-15 -- earlier track drafts over-claimed here and are corrected
by this section):

- **MEANS, with supply-chain losses** -- the live OWID grapher
  default since 15 June 2022. Every value quotable
  digit-for-digit from live pages today.
- **MEDIANS, without supply-chain losses** -- the retired
  pre-June-2022 OWID chart statistic (a slightly narrower basis,
  not just a different average). These ARE source-verifiable: the
  archived grapher variables endpoint reproduces all of them
  digit-for-digit (Wayback snapshot 2021-12-20, re-fetched live
  2026-07-18):
  `http://web.archive.org/web/20211220103825/https://ourworldindata.org/grapher/data/variables/146794+146796+146795+146797+146798+146800+146799.json?v=1`
  Reproduced median set: beef herd 59.6 (~60), dairy herd 21.1,
  lamb 24.5, pork 7.2, chicken 6.1, shrimp 11.8, fish 5.1, dark
  chocolate 18.7. The true asymmetry between the sets is
  **live pages (means) vs archived pages (medians)** -- not
  verifiable vs unverifiable. Beef = 60 additionally survives in
  live OWID article prose.

Note: 60 is NOT a rounding of 99.48; it is a different statistic
on the same 38,700-farm distribution, inside the same
cradle-to-retail boundary (plus the losses-basis difference
above). Both sets are honest; a dataset must pick ONE (section 2).

### Independent corroboration sources

- **MyCarbon Food Emissions Database** -- second live page carrying
  the P&N mean digit-for-digit (beef entry quoted in 3.1).
- **P&N accepted manuscript** (josephpoore.com PDF) -- functional
  -unit figure used for the beer/wine/coffee/soy-milk derivations
  (quoted in 3.7); all panel rows verified verbatim in the PDF
  text by the quote audit.
- **Gephart et al. 2021** seafood grapher -- a NARROWER boundary
  (no post-farmgate stages); recorded for seafood spread only,
  never mixed into the dataset (3.1).
- **Clune, Crossin & Verghese 2017**, J. Cleaner Production
  140:766-783 -- 369-study fresh-food meta-analysis; abstract-only
  scope confirmation (paywalled), used for vegetable magnitude and
  ordering only.
- **Peer-reviewed single-product LCAs**: Amienyo & Azapagic 2016
  (beer), Nab & Maslin 2020 (coffee), Svanes & Aronsson 2013
  (bananas), Theurl et al. 2014 (tomatoes), Nature Comms E&E 2024
  (wine), Scientific Reports 2025 (apples), and others -- quoted
  per item in section 3.
- **Secondary compilations** (quote-audited, full URLs per QA-7):
  The Conversation
  (https://theconversation.com/coffee-heres-the-carbon-cost-of-your-daily-cup-and-how-to-make-it-climate-friendly-152629),
  GreenQueen
  (https://greenqueen.com.hk/oatly-calls-for-mandatory-carbon-labelling-offers-big-dairy-free-ad-space-to-publish-climate-footprint/),
  co2everything (https://co2everything.com/co2e-of/coffee,
  /co2e-of/beer, /co2e-of/wine, /co2e-of/oat-milk,
  /co2e-of/soy-milk).

### CarbonCloud ClimateHub: corroboration-with-access-date ONLY

CarbonCloud publishes "live footprints" that **drift over time**
(observed during the quote audit: cheddar 18.11 -> 15.09 between
research fetch and audit fetch, -17%; rolled oats 1.25 -> 1.20).
Rule (data review, 2026-07-18): CarbonCloud values are corroboration with an
access date, never a digit-for-digit second verification. Every
CarbonCloud number in this document carries its full product URL
and a value-as-of date; values without recorded URLs were dropped
from the corpus as unverifiable (quote audit, 2026-07-18) and
are not carried here.

---

## 2. Scope Decision

Factors represent the **Poore & Nemecek cradle-to-retail
lifecycle, including land-use change and supply-chain losses**.
OWID FAQ, verbatim (accessed 2026-07-18):

> "All of the included studies quantify impacts from
> 'cradle-to-gate'. This means they include: Land use change;
> On-farm impacts ...; Animal feed production; Food processing ...;
> Transport: this includes transport from the farm up to retail.
> Transport of food from retail to consumers' homes is not
> included. Packaging[.] Impacts from food after they have been
> sold in retail are not included. For example, home cooking,
> refrigeration or household food waste is not included."

> "global warming potential over a 100-year timescale (GWP100) --
> a timeframe which represents a mid-to-long term period for
> climate policy."

Conventions:

- **Statistic = MEAN, dataset-wide** (owner decision D1,
  2026-07-18; **reaffirmed 2026-08-08** after the question was
  reopened -- the median is the better summary of a skewed
  distribution, but the wrong statistic for attributing impact to a
  purchase: total emissions = mean intensity x total production, an
  identity the median does not have, and P&N's right tail is real
  producer heterogeneity rather than contamination to be suppressed.
  Three further blockers: the archived median set has **no losses
  stage**, so switching would silently narrow the boundary too; only
  120 of the 166 v2 items cite a P&N row that has a median at all;
  and every value would fall (beef -40%, chicken -38%, farmed fish
  -63%), which is the wrong direction for the honesty ethic. The
  median's role is as a stress test and as disclosure, not as the
  shipped value.) Every factor is the OWID/P&N mean-with-losses
  value, live-quotable digit-for-digit. The Wayback-cited MEDIAN
  set (section 1) is the approved fallback if a mean is ever
  unavailable or retired; any fallback item must disclose its
  statistic in `calculation_notes` and the science sheet.
- **Per item, record statistic AND losses basis** (data-review rule).
  Every row in the section-4 v1-core table is mean-with-losses
  except where that table says otherwise (butter, oats, beer,
  bread/pasta, and the 2026-07 additions fish (wild-caught),
  plant-based meat, tea, small oily fish and canned beans -- each
  with its derivation documented).
- **Weights are as-purchased raw / dry.** Cooking changes mass
  (rice 150 g raw -> ~330 g cooked, ~2.2x by weight); presets
  encode raw portions and the quantity editor must say so.
- **Liquids at density 1.0**: per-litre = per-kg (real densities
  0.99-1.04; error < 1.5%, disclosed). **EXCEPTION -- OILS (D7,
  2026-08-01):** P&N's functional unit for oils is ONE LITRE
  (Supplementary Materials Table S1, verbatim: "Oil crops
  1 liter of refined/filtered oil"), and OWID publishes the value
  unconverted. Oils are ~0.90-0.92 kg/L, so the density-1.0
  convention understates every oil by 9-11%. Each oil is now
  divided by the density implied by its own USDA FDC serving
  portion, so the factor and the preset in a row cannot disagree.
  Table S1 also declares Milk, soy milk, beer and wine per litre
  (these are near 1.0 and stay as-is, but the fat/alcohol specs
  matter for derivations) -- and it declares MEAT as "1 kg of fat
  and bone-free meat and edible offal", FISH as "1 kg of edible
  fish" and CRUSTACEANS as "1 kg of head-free meat (shell-free
  for large shrimp)", which the dataset-wide "as-purchased"
  wording contradicts. Full verified table in 2.1 below.
- **Excluded everywhere:** retail-to-home transport, home cooking
  and refrigeration energy, household waste. Home energy belongs
  to Part 3.
- **Different boundary from the transport calculator**
  (operational-only). The methodology sheet must warn against
  summing across the two calculators.
- **Global category means, no organic/local modifier.** Producer
  spread is large and disclosed per item; OWID's own producer
  -spread example (verbatim, environmental-impacts-of-food):
  > "Producing 100 grams of protein from beef emits 25 kilograms
  > of carbon dioxide-equivalents (CO2eq), on average. But this
  > ranges from 9 kilograms to 105 kilograms of CO2eq."
- **Dataset JSON stores exact unrounded values; the UI rounds
  for display** (data-review rule -- storing pre-rounded values produced
  two flattering roundings, pork -2.5% and brassicas -2.0%).
- Transport-is-small context (OWID FAQ, verbatim): "No, transport
  accounts for just 5% of greenhouse gas emissions from food."
- **Mixed sources are allowed, ranking across them is not (D11,
  2026-08-08).** The seafood group needed species resolution that
  Poore & Nemecek does not have, so eight seafood rows ship from
  Gephart et al. 2021 at that source's own farm-gate, edible-weight
  boundary, tagged `source_tier: 2`. They sit 20-30% below this
  dataset's cradle-to-retail boundary through boundary alone, so
  every tier-2 row carries a boundary sublabel in the UI and the
  comparison engine holds a cross-tier pair to its stricter
  cross-tier bar (the bars live in PDR_FOOD_CALCULATOR.md
  section 3) before it will call a winner across tiers. `prawns_farmed` stays on the
  P&N value 26.87: completing Gephart's 9.428016 to this dataset's
  boundary gives 15.03, so the joint band is 15.03-26.87 and 9.43
  sits 37% below its own floor. Full reasoning in
  [RESEARCH_FOOD_ARCHIVE.md](./RESEARCH_FOOD_ARCHIVE.md) section 7.

### 2.1 P&N functional units (Table S1, verified 2026-08-01)

Extracted from the Supplementary Materials PDF
(https://josephpoore.com/Science%20360%206392%20987%20-%20SUPPLEMENTARY%20MATERIALS.pdf)
with `pdftotext -layout`. Table S1 "Functional units (FUs) used",
verbatim rows:

```
Wheat & Rye      1 kg of bread (variable protein wheat)
Maize            1 kg of meal (for polenta)
Oats             1 kg of rolled oats
Rice             1 kg of full grain white or brown rice
Potatoes         1 kg of soil free tuber
Cassava          1 kg of soil free tuber
Peas             1 kg of dry pea without pod
Other Pulses     1 kg of dry pulse without pod
Nuts             1 kg of shell free, dry nut
Groundnuts       1 kg of shell free, roasted nut
Soybeans         1 kg of tofu (~16% protein)
Cheese           1 kg of cheese
Eggs             1 kg of eggs
Poultry Meat / Pig Meat / Lamb & Mutton / Beef
                 1 kg of fat and bone-free meat and edible offal
Fish             1 kg of edible fish
Crustaceans      1 kg of head-free meat (shell-free for large shrimp)
Barley           1 liter of beer
Wine grapes      1 liter of wine
Milk             1 liter of pasteurized milk (4% fat, 3.3% protein)
Soybeans         1 liter of soymilk (~3.3% protein)
Root Vegetables  1 kg of soil free tuber
Fruit & Veg.     1 kg of fresh fruit or vegetable
Cocoa            1 kg of dark chocolate
Coffee           1 kg of ground, roasted beans
Oil crops        1 liter of refined/filtered oil
Sugar crops      1 kg of raw/refined sugar
```

**This is the authority on every item's `weight_basis`, and it
contradicts the blanket "as-purchased raw" convention above in
five places** -- each item's declared basis wins over the blanket
wording.

| Finding | Consequence |
|---|---|
| Meat is **fat and bone-free** | "as-purchased" is wrong for meat. A bone-in chop weighed whole overstates. Wave 1's 9 CFR presets are already edible-portion, so they match -- the convention text does not |
| Fish is **edible**, crustaceans **head-free/shell-free meat** | shipped `fish_farmed` and `prawns_farmed` are on an edible basis today, undeclared. Also removes basis as an explanation for the P&N-vs-Gephart prawn gap |
| Oils are **per litre** | all five oil values need dividing by density (~0.91-0.92 kg/L) for a per-kg dataset -- roughly +9%. Affects shipped `olive_oil` and `palm_oil` |
| Wheat & Rye is **bread**; Maize is **meal** | confirms wave 5. Shipped `pasta` 1.57 is on the wrong mass basis; `bread` 1.57 is correct but its notes are wrong |
| Barley is **1 litre of beer** | not a grain row at all. Confirms it must not ship as a staple |
| Groundnuts is **shell free, ROASTED** | wave 4's peanut-butter derivation applied a raw-to-roasted mass-loss uplift of 1.050161 on top of 3.23. The parent is already roasted, so that uplift **double counts** and must be removed: peanut_butter reverts to the 21 CFR 164.150 route alone. **Applied 2026-08-29** -- `peanut_butter` now ships 3.23 |
| Coffee is **ground, roasted beans** | confirms the basis wave 7's instant-coffee derivation assumed; 62.3344537815126 stands |
| Peas / Other Pulses are **dry, without pod** | confirms shipped `peas` 0.98 is the dry row and is mismatched to its frozen-pea preset |
| Fruit & Veg is **1 kg of fresh** | produce is genuinely as-purchased fresh; wave 6's CAT mappings are on the right basis |
| Milk is **1 litre pasteurized, 4% fat** | the density-1.0 convention is fine here, but the fat spec matters for every dairy derivation |

### 2.2 Item selection rules

Which foods get to be items, and how each one gets its number.
Binding on every dataset pass, including the v2 expansion
([RESEARCH_FOOD_ARCHIVE.md](./RESEARCH_FOOD_ARCHIVE.md) section 12 holds the item
list itself).

**R1 -- The fridge test.** Identifiable from the packet, plate or
menu. No production-system forks in a user-facing name.

**R2 -- A split needs >= 20% AND a source that resolves it.**
Two items may only carry different numbers if a single source
separates them by >= 20%. Same-anchor siblings are not splits --
they are one number with several names (`category_anchor` +
`aliases`).

**R3 -- One weight basis per item, declared in the schema, shown
in the picker label.** Not prose in `calculation_notes`.

**R4 -- The number comes from the food, never the food from the
number.** No item exists to re-home an orphaned value.

**R5 -- Eaten often enough to matter in EN, JA or ES.**

**R6 -- Never rank across sources.** Comparative copy requires
both items to share `source_tier` and `tie_group == null`, and
the gap to clear the verdict gate's floor -- the bars themselves
are product rules and live in PDR_FOOD_CALCULATOR.md section 3.

**R7 -- Physical floor.** A processed or derived item may never
fall below the sum of its inputs' factors x mass fractions. Runs
as a test over the whole dataset.

#### Factor routes

| Route | Meaning |
|-------|---------|
| `P&N` | a Poore & Nemecek/OWID row, mean with losses, quoted verbatim |
| `CAT` | a P&N category anchor applied to a member food, disclosed as a category average |
| `T2` | a peer-reviewed or public-database value, used only within its own comparison group |
| `T3` | derived from a parent by a **citable** ratio (standard, regulation or named product's declared composition) |
| `G` | Gephart 2021 seafood, harmonised by the documented recipe (section 3.1), edible-weight basis declared |

---

## 3. Verified Factors

At 167 items the per-item evidence no longer fits here, and it does
not need to: **`data/app/food_items.json` is the per-item audit
trail.** Every shipped row carries its source name, URL, verbatim
quote and access date, plus its statistic, weight basis, confidence
and spread, and the dataset tests assert those fields are present
and well-formed on every row. This section documents the
**anchors** -- the Poore & Nemecek rows and the non-P&N derivations
every item routes through -- and the contested cases where sources
disagreed. Read it for why a number is what it is; read the JSON
for what each item cites.

> "Verified" means: the factor is the OWID/P&N anchor value seen
> digit-for-digit on the live grapher CSV AND reproduced from the
> supply-chain stage sum (archive section 4), with at least one
> independent source corroborating magnitude/ordering. Exact
> LCA digits cannot match across different meta-analyses, so
> independent sources corroborate magnitude and ordering, never
> overwrite the anchor.

### 3.1 Meat & seafood (verified 2026-07-18)

**Two rows below no longer ship.** D11 (2026-08-08) retired the
assembled `fish_wild` 9.50 into `white_fish` 5.1250386 and `tuna`
7.6290536, and re-based `small_fish` 5.5 to 3.8779404 on Gephart's
own boundary. Their derivations stay here because the recipe and
the reasons it was abandoned are the evidence for D11; the shipped
seafood set is eleven rows, eight of them tier 2.

| Item | kg CO2e/kg | Statistic | Confidence |
|------|-----------:|-----------|------------|
| Beef | 70.3608 | production-weighted mean of the two P&N beef rows (D6) | High |
| Lamb | 39.72 | mean w/ losses | High |
| Pork | 12.31 | mean w/ losses | High |
| Chicken | 9.87 | mean w/ losses | High |
| Prawns (farmed) | 26.87 | mean w/ losses | Medium-High |
| Fish (farmed) | 13.63 | mean w/ losses | Medium-High |
| Fish (wild-caught) | 9.50 | non-P&N, assembled | Medium |
| Small oily fish (sardines, mackerel) | 5.5 | non-P&N, assembled | Medium-High |

Anchor rows, verbatim from `ghg-per-kg-poore.csv` (accessed
2026-07-18):

> "Beef (beef herd),2010,99.48"
> "Beef (dairy herd),2010,33.3"
> "Lamb & Mutton,2010,39.72"
> "Pig Meat,2010,12.31"
> "Poultry Meat,2010,9.87"
> "Prawns (farmed),2010,26.87"
> "Fish (farmed),2010,13.63"

Supply-chain rows, verbatim from
`food-emissions-supply-chain.csv` (columns: Land use change, Farm,
Animal feed, Processing, Transport, Retail, Packaging, Losses):

> "Beef (beef herd),2018,23.237535,56.22806,2.6809785,1.811083,0.4941246,0.23353784,0.35208446,14.439998"
> "Beef (dairy herd),2018,1.2660223,21.91553,3.5036733,1.5476644,0.5924098,0.2540323,0.3745491,3.8475146"
> "Fish (farmed),2018,1.1947172,8.056115,1.8344203,0.04459863,0.24795863,0.08997562,0.13753739,2.0271227"
> "Lamb & Mutton,2018,0.648247,27.02575,3.2831702,1.5395962,0.6788543,0.30081406,0.34760362,5.8982344"

**Row-name mapping (data-review finding):** the supply-chain CSV names the
prawn row **"Shrimps (farmed)"** while the per-kg CSV uses
**"Prawns (farmed)"**. Same product, one dataset; the sum verifies
(26.8659). The dataset item is "Prawns (farmed)" and its
`calculation_notes` must state this cross-CSV mapping so the
citation is reproducible.

Key sources (accessed 2026-07-18):

- MyCarbon Food Emissions Database (independent live page with the
  mean digit-for-digit):
  https://www.mycarbon.co.uk/knowledge-hub/food-emissions-database/food-emissions-database-beef-beef-herd-global-average-2018-reducing-foods-environmental-impacts-through-producers-and-consumers-poore-nemecek-science-2018/
  > "The greenhouse gas emissions of Beef (beef herd) (Global
  > Average) are 99.477404614 kg CO2e per kilogram of food
  > product."
- OWID article (the median 60 in still-live prose; the same page's
  embedded chart serves the 99.48 mean):
  https://ourworldindata.org/environmental-impacts-of-food
  > "Producing a kilogram of beef, for example, emits 60 kilograms
  > of greenhouse gasses (CO2-equivalents)."
  ("gasses" is the page's own spelling.)
- OWID food-choice-vs-eating-local (two separate verbatim
  sentences per QA-2 -- never splice them):
  https://ourworldindata.org/food-choice-vs-eating-local
  > "Producing a kilogram of beef emits 60 kilograms of greenhouse
  > gases; peas emit just 1 kilogram" (headline)
  > "producing a kilogram of beef emits 60 kilograms of greenhouse
  > gases (CO2-equivalents). In contrast, peas emit just 1
  > kilogram per kg." (body)
- PMC11743834 (live full text; ranges verbatim -- closes the
  track's re-verification flag, QA-8). These ranges EXCLUDE
  land-use change, which is why they sit below the P&N means:
  https://pmc.ncbi.nlm.nih.gov/articles/PMC11743834/
  > "16-68 kg CO2-eq/kg for beef, 6.08-12.3 kg CO2-eq/kg for
  > pork, and 2.6-3.3 kg CO2-eq/kg for chicken"
  (page renders en dashes and CO2 subscript)
- Gephart et al. 2021 seafood grapher (NARROWER boundary -- do not
  mix into the dataset):
  https://ourworldindata.org/grapher/ghg-emissions-seafood.csv
  > "Shrimp (farmed),2021,9.428016"
  > "Salmon (farmed),2021,5.100986"
  Metadata note, verbatim: "Includes on-farm and off-farm, but
  does not include post-farmgate emissions. This means it does not
  include impacts such as transport to retail, packaging,
  processing or cooking." Citation: "Gephart et al. (2021)."

Candidate tables (where sources disagree):

Prawns (farmed) -- widest disagreement in the dataset:

| Value | Statistic / boundary | Source |
|------:|----------------------|--------|
| **26.87** (chosen) | P&N mean w/ losses, cradle-to-retail | OWID grapher |
| 11.8 | P&N median w/o losses | Wayback archive |
| 9.43 | Gephart 2021 farmed shrimp, on+off-farm only | seafood grapher |

Fish (farmed):

| Value | Statistic / boundary | Source |
|------:|----------------------|--------|
| **13.63** (chosen) | P&N mean w/ losses | OWID grapher |
| 5.1 | P&N median w/o losses | Wayback archive |
| 5.10 / 5.4 / 10.7 | Gephart salmon / trout / tilapia, narrower | seafood grapher |

Both chosen at the P&N mean for scope consistency (one boundary
across all 37 first-pass items). The P&N farmed prawn/fish
categories are single coarse global averages with large spread --
Medium-High confidence, spread caveat required on the science
sheet (PDR section 5).

**Fish (wild-caught) -- added 2026-07-19 (owner product call), not
in P&N.** The per-kg grapher has no wild-fish row (re-verified
2026-07-19: the only fish rows are the farmed two above), so
tuna/wild eaters had a wrong-by-its-own-label proxy. Assembled
butter-style from Gephart et al. 2021 wild-fishery data completed
to the P&N cradle-to-retail boundary. Gephart boundary and unit,
verbatim from the grapher metadata (accessed 2026-07-19,
https://ourworldindata.org/grapher/ghg-emissions-seafood.metadata.json):

> "Includes on-farm and off-farm, but does not include
> post-farmgate emissions. This means it does not include impacts
> such as transport to retail, packaging, processing or cooking."
> "Impacts are given in kilograms of carbon dioxide-equivalents
> per kilogram of edible weight."

Wild-capture rows, verbatim from `ghg-emissions-seafood.csv`
(accessed 2026-07-19):

> "Tuna (wild),2021,7.6290536"
> ""Cod, haddock (wild)",2021,5.1250386"
> ""Herring, sardines (wild)",2021,3.8779404"
> ""Salmon, trout (wild)",2021,6.8813386"
> "Jack fish (wild),2021,9.6651745"
> ""Redfish, bass (wild)",2021,9.91465"
> "Flounder (wild),2021,20.313314"

Candidate table:

| Value | Construction / boundary | Source |
|------:|-------------------------|--------|
| **9.05** | wild finfish mix: mean of the 6 species groups above excl. the flounder outlier (farm-gate 7.182) + P&N farmed-fish post-farmgate stages excl. losses (0.520) x losses uplift (17.5%, the P&N fish loss share) | Gephart 2021 + P&N supply-chain CSV |
| **9.53** | canned tuna: Gephart tuna 7.629 + high-end canning energy 1.38 (Hospido et al. 2006 as quoted in the WWF report; excludes can material) + P&N packaging/transport/retail 0.520; no loss uplift (shelf-stable) | Gephart 2021 + Tan & Culaba 2009 + P&N |
| 9.36 / 9.03 / 14.11 | CarbonCloud canned-tuna store-shelf values (benchmark Sweden / Thailand / one branded US product), values as of 2026-07-19, corroboration only | https://apps.carboncloud.com/climatehub/product-reports/id/153769684173, .../120259468117, .../1080864344791 |

Chosen: **9.50** = mean(9.05, 9.53) = 9.29, rounded UP
(honest-not-generous, butter precedent). ONE item covers wild fish
AND canned tuna: the two constructions converge within 5%, so a
tuna-can logger and a wild-sashimi logger are both served without
either being misled. Confidence Medium (mixed boundaries: Gephart
farm-gate edible weight completed with P&N stages). Key quotes
(Tan & Culaba 2009, WWF-commissioned, live PDF accessed
2026-07-19,
https://wwfeu.awsassets.panda.org/downloads/estimating_the_carbon_footprint_of_tuna_fisheries_9may2009.pdf):

> "Based on these assumptions, the partial carbon footprint is
> estimated at 0.63 – 1.38 kg CO2 per kg of product, if all of the
> energy consumption is allocated to the canned tuna."
> "Note that these estimates exclude the footprint contributed by
> the packaging material."
> "this study estimates on carbon dioxide emissions, and does not
> include the contributions of other greenhouse gases generated
> within the supply chain."

(Hospido & Tyedmers 2005 / Hospido et al. 2006 publisher pages
returned HTTP 403 on 2026-07-19; their figures are cited
second-hand via this live PDF only.) Parker et al. 2018, Nature
Climate Change (https://www.nature.com/articles/s41558-018-0117-x,
abstract, magnitude corroboration only), verbatim: "fisheries
consumed 40 billion litres of fuel in 2011 and generated a total
of 179 million tonnes of CO2-equivalent GHGs (4% of global food
production)".

**Prawns (wild-caught) -- added 2026-08-02 (owner research pass),
not in P&N.** The per-kg P&N grapher has only a farmed prawn row, so
wild-prawn eaters had no item and the farmed factor was the nearest
(wrong-direction) proxy.

Unlike fish (wild-caught), Gephart et al. 2021 publishes **both**
prawn variants at one boundary, which makes the like-for-like
comparison directly observable. Verbatim from
`ghg-emissions-seafood.csv` (accessed 2026-08-02):

> "Shrimp (wild),2021,11.956739"
> "Shrimp (farmed),2021,9.428016"

**Wild is 1.2682x farmed** -- wild prawns are worse, not better.
Trawling for prawns is among the most fuel-intensive fishing there
is (Parker et al. 2018: crustacean fisheries top the fuel-use
table). This is the counterintuitive finding of the pass and the
thing the item exists to communicate.

Candidate table:

| Value | Construction / boundary | Verdict |
|------:|-------------------------|---------|
| 18.60 | fish_wild recipe: Gephart wild 11.9567 + P&N prawn post-farmgate excl. losses (1.21936) x prawn loss uplift (41.1%) | **rejected** |
| **34.08** | ratio-scaled onto the dataset's P&N anchor: 26.8659 x (11.956739 / 9.428016) = 34.0717, rounded up | **chosen** |

The additive recipe is the one fish_wild uses, and it was still
rejected, because here we can test it. Run it on Gephart's *farmed*
shrimp and it returns **15.03** where P&N gives **26.87** -- the two
sources disagree about prawns by ~1.8x, so the additive route lands
on Gephart's scale, not this dataset's. Shipping 18.60 next to the
farmed 26.87 would have told users wild prawns are 31% BETTER than
farmed when the only like-for-like evidence says 27% worse. An
inverted ordering is a wrong answer, not an imprecise one.

Ratio-scaling keeps the ordering honest on the P&N scale. Its own
weakness, stated plainly: it implicitly scales land-use-change and
feed stages that a wild fishery does not have. Treat the absolute
value as bracketed by 18.60 (Gephart scale) and 34.08 (P&N scale);
**the ordering wild > farmed is the robust part, the absolute value
is Medium confidence.** P&N stage row used for the anchor, verbatim
from `food-emissions-supply-chain.csv` (accessed 2026-08-02):

> "Shrimps (farmed),2018,0.33056307,13.453979,4.0299387,0,0.33085158,0.3523611,0.5361473,7.832022"

(sum 26.8659, matching the shipped 26.87.)

Pinned by invariants 18 and 19: wild > farmed, the ratio tracks
Gephart within 1%, the value is 34.08, and beef stays the dataset
maximum (34.08 lands 4th, above coffee, below lamb).

Caveats for the science sheet: assembled value with mixed
boundaries; the edible-weight basis coincides with as-purchased
for fillets and drained cans but overstates whole fish
(conservative direction); species spread is large (some
trawl-caught flatfish ~double) -- sardines, mackerel and saury
have their own item since 2026-07-20 (Small oily fish, 5.5,
below); gear matters (longline ~3-6x purse seine per kg landed)
and one factor cannot distinguish it.
NEAR-TIE: 9.50 vs chicken 9.87 (3.9%) -- never-pin (section 6),
and the sources disagree at this resolution (Gephart's own
farm-gate chicken 8.335 sits ABOVE their tuna 7.629). Wild <
farmed IS source-supported: wild fisheries burn fuel but carry no
feed or land-use-change stages, the two largest farmed-fish
components (8.06 farm + 1.83 feed + 1.19 LUC).

**Small oily fish (sardines, mackerel) -- added 2026-07-20,
closing the small-fish split flagged when fish (wild-caught)
shipped.** JP-first justification: iwashi, saba and sanma are
everyday fish and the tuna-centred fish_wild overstates them ~2x.
Construction is arithmetically identical to fish_wild, anchored
to Gephart's only small-pelagic row, verbatim from
`ghg-emissions-seafood.csv` (accessed 2026-07-20):

> ""Herring, sardines (wild)",2021,3.8779404"

(Mackerel/saury are not broken out; the herring/sardine row is
the best proxy and, per the fuel-use literature below, if
anything conservative for saba.) Constructions:

- Fresh: (3.8779404 + 0.52007027 post-farmgate) x 1.1747 losses
  uplift = **5.17**.
- Canned: 3.8779404 + 0.52007027 + 1.38 high-end canning
  (Hospido et al. 2006 via the WWF PDF, quote in the fish_wild
  block) = **5.78**; no loss uplift (shelf-stable).
- Chosen: mean (5.17 + 5.78) / 2 = 5.47 -> **5.5** (rounded up).
  Fresh and canned differ by only ~12%, so one item covers both.

Confidence Medium-High: same recipe as the shipped fish_wild,
single authoritative anchor row, and the ~half-of-tuna magnitude
is independently corroborated by fuel-use data (purse-seined
small pelagics are the most fuel-efficient fisheries) and by
CarbonCloud canned tuna (~9.4, roughly double). Parker et al.
2015 fuel-use summary (Univ. of Miami Shark Research,
https://sharkresearch.earth.miami.edu/fuel-consumption-of-global-fishing-fleets/,
accessed 2026-07-20; the Wiley original is paywalled, magnitude
only), verbatim:

> "Catches like the Peruvian Anchovy, Atlantic Mackerel, and
> Australian Sardine are some of the most efficient fisheries"
> "The use of purse seine gear or other surrounding nets average
> an FUI of 71 liters per ton"
> "Trawling for small pelagic fish has an FUI of 169 liters per
> ton"

Caveats: represents purse-seine fisheries (the dominant method;
trawl-caught runs higher). Presets use the weights the factor
applies to: mackerel can drained 140 g (Sokensha publishes
190g/固形量140g -- closed 2026-07-20; the interim net-weight
preset is retired) and whole sardine edible 32 g (80 g fish,
refuse 60% per MEXT -- using whole weight would overstate 2.5x).
NEAR-TIE: 5.5 vs eggs 4.67 (17.8%) -- never-pin; 5.5 sits just
above the eggs / plant-based-meat cluster and copy must frame it
as "the same low-impact neighbourhood", never a ranked step.
Distinct from fish_wild (-42%): the "small fish are ~half" claim
IS safe to make.

### 3.2 Dairy & eggs (verified 2026-07-18)

| Item | kg CO2e/kg | Statistic | Confidence |
|------|-----------:|-----------|------------|
| Cheese | 23.88 | mean w/ losses | High |
| Butter | 12.0 | non-P&N, 3-LCA mean | Medium |
| Cream (whipping) | 11.222704 | milk x total-solids allocation | Medium |
| Eggs | 4.67 | mean w/ losses | High |
| Milk (dairy) | 3.15 | mean w/ losses | High |

Anchor rows, verbatim: `Cheese,2010,23.88`, `Eggs,2010,4.67`,
`Milk,2010,3.15`. Milks-chart cross-check, verbatim from
`environmental-footprint-milks.csv`:
`Dairy milk,2013,8.95,3.15,628.2,10.65` (GHG column = 3.15/L).

**Butter -- not in P&N; assembled from independent dairy LCAs.**
Candidate table after the QA-3 correction (the un-URLed
"12.1 kg" candidate could not be located anywhere and is dropped
-- it does not ship in any `sources[]` field):

| Source | kg CO2e/kg | Quote / basis | URL |
|--------|-----------:|---------------|-----|
| foodfootprint.nl (RIVM, avg Dutch market) | 12.2 | "61 g CO2eq" per 5 g portion -> 12.2/kg; "RIVM (average Dutch market)" | https://foodfootprint.nl/en/foodprintfinder/butter/ |
| LiveLCA (analysis of 12 studies) | 10.18 | table row "Butter 10.179 12" (rendered page; plain requests intermittently 422) | https://livelca.com/products/butter_273d0577-1c3b-4e5e-94fb-4084b0eebe78 |
| CarbonCloud "Butter, 80% fat, unsalted" | 11.89 | live value as of 2026-07-18 (research fetch and audit fetch agree) | https://apps.carboncloud.com/climatehub/product-reports/id/116838100638 |

Chosen at the time: **12.0** = mean(12.2, 10.18, 11.89) rounded
UP. **Superseded 2026-09-01 (the dairy pass this section's cream
finding called for): butter now ships 21.574980, derived from
milk on the same total-solids allocation as cream and milk
powder.** AH697 Table 16 puts commercial butter at 80.30% milkfat
plus 1.00% MSNF = 81.30% milk solids (verbatim: "Milkfat products:
Butter 80.0 80.30 1.00"; salt excluded, which is why the
composition-table by-difference ~83.8% is not used), so
81.30 / 11.87 x 3.15 = 21.574980 -- the 21.58 this document
computed when the cream work exposed the irreconcilability. The
three aggregator figures above stay in `sources[]` as the honest
lower end of the spread (they measure a European milk supply at
roughly a third of the P&N global mean with land-use change) and
`spread_low` is 10.179. A milkfat-only allocation (~78) is
rejected for charging butter with skim solids sold in their own
right. Confidence Medium. Science sheet must carry the "not in
Poore & Nemecek" note (PDR section 5).

**Cream -- derived from milk on a total-solids allocation (added
2026-08-29).** Cream was the last uncovered common food. The v2
merge had routed it onto `butter` as an alias with a 15 g preset;
that was removed on 2026-08-08 because the two routes then on the
table disagreed by roughly 40x and neither could ship. All three
routes below were re-fetched live on 2026-08-29.

*Route 1, a measured cream LCA, is dead.* Ferronato et al. 2025
(Animals 15(6):811) does report cream, but the boundary and the
allocation both disqualify it. MDPI returns 403 to automated
fetch; the full text is open at
https://europepmc.org/articles/PMC11939476. Verbatim on boundary:

> "The environmental impact assessment was conducted according to
> the principles of a cradle-to-cheese factory gate approach ...
> The life stages of distribution, consumption, and disposal were
> excluded."

and on the result:

> "Meanwhile, the CF of skimmed milk was 2.27 kg CO2 eq/kg,
> caciotta was 17.37 kg CO2 eq/kg, cream was 0.82 kg CO2 eq/kg,
> whey was 0.26 kg CO2 eq/kg, and ricotta was 0.26 kg CO2 eq/kg
> of product."

**That pair of numbers is what settled the item.** 0.82 is not a
narrow-boundary cream figure that could ship at tier 2 with the
offset disclosed, the way the seafood rows do under D11. It is a
by-product allocation inside a Grana Padano plant, where cream is
what gets skimmed off the evening milk rather than what the plant
makes, and it lands BELOW the skimmed milk from the same vat
(0.82 against 2.27). D11's treatment corrects a boundary; no
boundary correction rescues a cream number that sits under skim
milk. Ferronato's own milk is 1.38 kg CO2eq/kg FPCM, so the
0.82 is not low because the study is low either.

*Route 2, milkfat allocation from butter, stays dead.* Assigning
the whole milk footprint to fat needs about 11.26 kg of milk per
kg of 36% cream and puts cream above 30, higher than cheese.

*Route 3, shipped: total solids from `milk_dairy`.* Split the milk
between the cream and the skimmed milk that leaves the separator
with it, in proportion to the milk solids each carries. This is
the rule `milk_powder` already uses, and it is the rule Verge et
al. 2013 apply across the whole Canadian dairy sector (J. Dairy
Sci. 96(9):6091-6104; open PDF at
https://publications.polymtl.ca/3424/1/2013_Verge_Carbon_footprint_Canadian_dairy_products_ensemble.pdf).
Verbatim, de-hyphenated across the column break:

> "For raw milk, the allocation criterion was based on the degree
> of milk solids (fat, protein, lactose, and minerals)
> concentration in the final products."

Arithmetic, both compositions from USDA FoodData Central SR
Legacy via the FDC API:

```
Cream, fluid, heavy whipping (170859)  Water 57.71 g -> TS 42.29%
Milk, whole, 3.25% milkfat (171265)    Water 88.13 g -> TS 11.87%
mass_ratio = 42.29 / 11.87 = 3.562763
value      = 3.15 x 3.562763 = 11.222704
```

A kg of cream carries the solids of 3.56 kg of milk; the skimmed
milk keeps the rest of the footprint of the 11.26 kg the fat
balance actually draws. `parent` is `milk_dairy` and the pair
reproduces under invariant 21 to 4.5e-7.

**Corroboration.** Verge's Table 5 (kg CO2e/kg of product, by
region, nonpackaged) puts the Canadian cream category at 2.1
against fluid milk 1.0 on the same page:

```
Creams      1.7  1.9  1.9  2.0  2.0  1.9  2.2  2.2  2.3  2.2  2.1
Fluid milk  0.8  0.9  0.9  0.9  0.9  0.9  1.0  1.0  1.1  1.0  1.0
```

Their cream category is dominated by 10-18% coffee and table
creams and their fluid milk is "mostly 2% fat milk", so a 2.1x
ratio there is consistent with 3.56x for a 36% cream. CarbonCloud
(corroboration with access date only, per section 1) reads 8.39
for "40% HEAVY CREAM" at US store shelves
(https://apps.carboncloud.com/climatehub/product-reports/id/1079361501132,
value as of 2026-08-29), below 11.22 as expected from a US milk
supply carrying no global land-use change. Its Spain page "Cream
40% fat at separator"
(https://apps.carboncloud.com/climatehub/product-reports/id/193738930423)
read 9.63 in a search index and 8.19 live on the same day --
another instance of the drift that makes CarbonCloud
corroboration-only.

**What the figure is NOT: it is not reconcilable with `butter`
12.0, and that is a finding about butter.** Under this same rule
butter would be 21.58 (AH697 Table 16 commercial butter, milkfat
80.30 + MSNF 1.00 = 81.30% solids; 81.30 / 11.87 x 3.15), so the
shipped butter sits 44% below its own milk-derived value --
butter's three source pages measure a European milk supply at
roughly a third of P&N's global mean with land-use change. Cream
at 11.22 therefore lands only 6.5% under butter where the physics
says about half (21.58 / 11.22 = 1.92). That near-tie is an
artefact of two source families, so `cream` joins `butter` and
`greek_yogurt` in `tie_group: derived_strained_dairy` and the gate
refuses any verdict between them. No allocation reconciles butter
12.0 with milk 3.15; the butter row was the one that had to move,
and it did on 2026-09-01 (section 3.2 above): butter now ships
21.574980 on this same rule, and the tie group keeps refusing the
pair because the ~2x gap is the shared derivation.

**Allocation is the uncertainty, and it is disclosed.** Weighting
the split by fat and protein rather than total solids, which the
IDF guidance and Ferronato both do, gives
(36.08 + 2.84) / (3.25 + 3.15) = 6.08125 and 19.155938. That ships
as `spread_high`; `spread_low` is the shipped value, so 11.22 is
the CONSERVATIVE end of a real range, which cuts against the
honest-not-generous habit elsewhere in this document. It ships
anyway for two reasons: total solids is the rule already used for
the only comparable row in the dataset, and the fat-weighted
figure would put cream above butter and at 80% of cheese, an
ordering the dataset's own butter row contradicts and no shopper
would believe.

**Fat basis: heavy cream only.** 21 CFR 131.150, verbatim from the
govinfo XML: "Heavy cream is cream which contains not less than 36
percent milkfat." USDA 170859 measures 36.08%, so the standard and
the composition agree. Lighter creams are NOT covered and must
never be aliased onto this row: on the same arithmetic, light
whipping cream (30.91% fat) gives 9.69, light/table cream (19.1%)
6.97 and half and half (11.5%) 5.16. AH697 Table 19 gives 36%
cream at 1 003 g/L, so the density-1.0 convention holds within
0.3% and the FDA's 15 mL reference amount for "Cream or cream
substitutes, fluid" is 15 g.

Eggs and cheese corroboration (CarbonCloud, value-as-of
2026-07-18, corroboration only): Eggs 2.15
(https://apps.carboncloud.com/climatehub/product-reports/id/15412141354)
-- a regional (EU/Nordic) lower bound; the ~2x gap to 4.67 is
global feed LUC vs European feed, not an error. Cheddar cheese
aged 12 months
(https://apps.carboncloud.com/climatehub/product-reports/id/116166617301)
read 18.11 at research fetch and 15.09 at audit fetch -- the
drift example that motivates the QA-6 rule.

### 3.3 Plant protein (verified 2026-07-18)

| Item | kg CO2e/kg | Statistic | Confidence |
|------|-----------:|-----------|------------|
| Plant-based meat | 4.5 | non-P&N, assembled | Medium-High (raised 2026-07-20) |
| Tofu | 3.16 | mean w/ losses | High |
| Beans / lentils | 1.79 | mean w/ losses ("Other Pulses"); dry basis | Medium |
| Beans (canned) | 1.7 | non-P&N, assembled; DRAINED basis | Medium |
| Peas | 0.98 | mean w/ losses | High |
| Peanuts | 3.23 | mean w/ losses ("Groundnuts"); roasted, shelled | Medium-High |
| Tree nuts | 0.43 | mean w/ losses (incl. LUC credit); shelled, dry | Medium-High |

Anchor rows, verbatim: `Tofu,2010,3.16`,
`Other Pulses,2010,1.79`, `Peas,2010,0.98`, `Nuts,2010,0.43`,
`Groundnuts,2010,3.23`.

- **Beans/lentils = OWID "Other Pulses"** (the P&N category
  containing beans, lentils, chickpeas -- NOT peas). It ships at
  1.79: ABOVE bread (1.57) and an exact tie with wine (1.79).
  OWID's famous "peas emit just 1 kilogram" sentence belongs to
  Peas (0.98) and must never be attached to this item.
  Independent lentil values (CarbonCloud, value-as-of 2026-07-18,
  corroboration only): Lentils 0.72
  (https://apps.carboncloud.com/climatehub/product-reports/id/179797657331),
  Lentils dry 1.48
  (https://apps.carboncloud.com/climatehub/product-reports/id/90010742555)
  -- P&N's category mean sits at the top of the credible range but
  is the authoritative global figure. Confidence Medium (basket
  category). The factor is on the DRY pulse basis.
- **Tree nuts net a large orchard land-use-change carbon CREDIT.**
  Supply-chain row, verbatim:
  > "Nuts,2018,-3.257812,3.3744068,0,0.051419526,0.10673449,0.04263857,0.12374754,-0.007999532"
  Sum = 0.433135394 -> 0.43. With LUC set to 0 the figure is
  0.433135394 + 3.257812 = 3.690947394 (~3.69). Ship 0.43
  (consistent incl-LUC boundary) but the `calculation_notes` MUST
  disclose the credit; never publish a negative value; never emit
  "nuts are the lowest-impact protein" copy (PDR section 5). Table S1
  basis (2.1): "1 kg of shell free, dry nut" -- kernels, not
  in-shell weight.
- **Peanuts are a SEPARATE P&N row and must never ride the
  tree-nut number** (split 2026-08-08). `Groundnuts,2010,3.23`;
  stage sum 0.4851524 + 1.5759542 + 0 + 0.41091752 + 0.13259722 +
  0.046872605 + 0.109439865 + 0.46907976 = 3.23001357. Peanuts are
  a legume; P&N measure them apart from orchard nuts, and the row
  carries no LUC credit. **This was a live defect:** the shipped
  `nuts` item at 0.43 carried "peanut", "peanut butter", 落花生 and
  cacahuete as search aliases, routing every peanut query to a
  value **7.5x too low**. Fixed by splitting into `tree_nuts` (0.43)
  and `peanuts` (3.23), pinned by `food_dataset_invariants_test`
  11b and an alias guard in `food_items_data_test`.
  Table S1 basis (2.1): "1 kg of shell free, roasted nut" -- the
  parent is ALREADY roasted, so a raw-to-roasted mass uplift on top
  of 3.23 double counts. Wave 4's 1.050161 uplift was withdrawn on
  that reasoning, and **the withdrawal reached the data 2026-08-29**:
  `peanut_butter` shipped 3.39202 = 3.23 x 1.050161 for three weeks
  after the decision and now ships the 21 CFR 164.150 route alone --
  non-peanut ingredients capped at "10 percent of the weight of the
  finished food", inside the 20% bar -- which is the plain peanut
  **3.23**. Three separate lines of evidence agree on the direction
  and none supports an uplift: (a) the Table S1 basis above, which
  makes the roast a double count; (b) Agribalyse, an independent
  database, prices peanut butter at 4.06 against its own peanuts
  4.18, a ratio of 0.971 -- butter fractionally BELOW the nut, not
  above it; (c) the composition route's own bounds, 0.90 x 3.23 =
  2.907 at the legal floor with nothing added, and 0.90 x 3.23 +
  0.10 x 7.955247 (palm) = 3.70 at the legal ceiling with the
  balance all stabiliser oil. 3.23 sits inside those bounds and is
  where a 100%-peanut jar lands exactly. What stays excluded, and
  is disclosed in the item's notes, is grinding energy and the glass
  jar, which push the true figure up, against the added-oil bound
  which pushes a specific commercial jar up further still. The 5%
  the withdrawn uplift added was never evidence for either.
  **Never generate comparative copy between the two rows**: the
  7.46x gap (3.23 / 0.433135394) is entirely the orchard credit,
  and stripping it inverts the ordering (tree nuts 3.69, +14.3%
  above peanuts). Species cannot be resolved inside the tree-nut
  row either -- the only two databases covering almond, cashew,
  walnut, hazelnut and pistachio rank them in near-opposite order
  (Spearman rho -0.3) and fail the 20% bar internally, so all five
  ship as search names on one number (decision recorded in
  [RESEARCH_FOOD_ARCHIVE.md](./RESEARCH_FOOD_ARCHIVE.md) section 12.3).
- Tofu corroboration (CarbonCloud, value-as-of 2026-07-18): 1.34
  (https://apps.carboncloud.com/climatehub/product-reports/id/224275434558)
  -- regional deforestation-free soy; corroborates the
  low-single-digit magnitude.

**Plant-based meat -- added 2026-07-19 (owner product call), not in
P&N** (per-kg grapher re-inspected 2026-07-19: no meat-substitute
row exists; the category postdates the study). Without it, the
flagship burger-swap comparison flattered the swap 2-4x when users
proxied with beans or tofu. Candidate table:

| Value | Boundary | Commissioner | Source |
|------:|----------|--------------|--------|
| 3.4 | cradle-to-distribution (incl. retail transport; no losses) | Beyond Meat | Heller & Keoleian 2018, Univ. of Michigan CSS report CSS18-10 |
| 3.5 (95% CI 3.1-4.0) | cradle-to-gate (no distribution/retail/losses) | Impossible Foods | Quantis 2019 |
| ~0.98 | cradle-to-mfg gate, pre-packaging, hypothetical recipes | GFI (advocacy) | EarthShift Global 2024 -- EXCLUDED as a flattering low outlier |
| 2.62 | cradle-to-shelf, autogenerated proxy data | independent DB | CarbonCloud, value as of 2026-07-19 |

Chosen: **4.5** = mean(3.4, 3.5) = 3.45, times a conservative
~1.3x uplift compensating the narrower-than-P&N boundaries (no
retail for Quantis, no supply-chain losses for either -- a
processed chilled/frozen product typically gains ~1.2-1.3x to a
loss-inclusive retail boundary) and the commissioner-low bias:
3.45 x 1.3 = 4.49, rounded UP to 4.5. Confidence Medium: the
magnitude (single digits, an order below beef) is robust across
5+ studies, but no independent P&N-boundary per-kg LCA exists and
the per-kg anchors are commissioner-biased low.

Key quotes (accessed 2026-07-19):

- Heller & Keoleian 2018
  (https://css.umich.edu/sites/default/files/publication/CSS18-10.pdf):
  > "The GHGE associated with producing and delivering a ¼ pound
  > Beyond Burger to retail are 0.384 kg CO2eq/quarter pound BB
  > (or 3.4 kg CO2eq. /kg BB)."
  > "Beyond Meat commissioned the Center for Sustainable Systems
  > at University of Michigan to conduct a
  > 'cradle-to-distribution' life cycle assessment of the Beyond
  > Burger, a plant-based patty designed to look, cook and taste
  > like fresh ground beef."
- Quantis 2019
  (https://assets.ctfassets.net/hhv516v5f7sj/4exF7Ex74UoYku640WSF3t/cc213b148ee80fa2d8062e430012ec56/Impossible_foods_comparative_LCA.pdf):
  > "The functional unit for this study is cradle-to-gate
  > assessment of 1 kg of Impossible Burger®, which will be
  > benchmarked against 1 kg of boneless retail-ready U.S.
  > conventional ground beef burger."
  (Table 1: Impossible Burger GWP 3.5 kg CO2-eq, 95% CI 3.1-4.0,
  vs beef burger 30.6.)
- Independent peer-reviewed per-patty corroboration (both
  cradle-to-grave INCLUDING cooking, so directional only, never
  divisible to per-kg): Saget et al. 2021, Sustainable Production
  and Consumption 28:936-952
  (https://researchrepository.ul.ie/bitstreams/7edd3652-290b-4944-b878-cb3b2074a91d/download):
  > "Plant-based patties have a smaller environmental footprint
  > across most categories, including a 77% smaller climate change
  > burden ... compared with Brazilian beef patties."
  Tsakiridis et al. 2024, Sustainability 16(11):4417
  (https://pure-oai.bham.ac.uk/ws/files/229139412/sustainability-16-04417.pdf):
  > "The results demonstrated that the plant-based burger had
  > significantly lower environmental impacts across several
  > categories, including a 65% reduction in global warming
  > potential."

Fabrication guard: the widely restated "Bryant 2022 average 2.4
kg CO2e/kg" could NOT be verified on any live page (only
percentage reductions are quotable) and is not used anywhere.

Consequences: 113 g plant patty = 0.51 kg CO2e vs beef patty
11.24 kg (~22x lower) -- the honest correction roughly halves the
over-flattering beans-proxy headline (56x). NEAR-TIES: 4.5 vs
eggs 4.67 (3.8%) and vs rice 4.45 (1.1%) -- never-pin (section
6). Science sheet must disclose category breadth (soy mince to
formulated patties), the narrower source boundaries, and the
uplift (PDR section 5).

**Independent corroboration added 2026-07-20 (closes the
independent-LCA open item; confidence raised Medium ->
Medium-High).** Detzel et al. 2021, "Life cycle assessment of
animal-based foods and plant-based protein-rich alternatives", J.
Sci. Food Agric., DOI 10.1002/jsfa.11417 -- authored at ifeu
(Institut fuer Energie- und Umweltforschung, an independent
non-profit), funded by EU Horizon 2020 Protein2Food, commissioned
by no plant-meat brand or advocacy body. Open full text fetched
via the IITA repository
(https://biblio.iita.org/documents/S21ArtDetzelLifeInthomNodev.pdf-8c60b1ab6f64641c2b6e66577fb8da59.pdf,
accessed 2026-07-20), verbatim:

> "Comparisons that were conducted on a mass basis show values of
> 235 g CO2 equivalents and 240 g CO2 equivalents for VMA
> extrudates from lupin protein combined with amaranth or
> buckwheat flour, respectively."
> "The LCA was designed as a 'cradle-to-gate' LCA comprising all
> the life cycle steps from biotic and abiotic raw material
> sourcing up to the final food products at the factory gate."

Independent per-kg cradle-to-gate values (own prototypes 2.35 /
2.40; collated independent commercial replacers: soy meal 2.72,
minced soy 3.90, wheat gluten 3.81, pea isolate 2.38 -- Detzel's
"potato+soy 3.47" citation is the Quantis Impossible study
restated and is NOT counted as independent). Re-derivation under
this dataset's rules, **corrected 2026-08-29**: the mean written
here was 3.26 and the sum does not give it. (2.35 + 2.40 + 2.72 +
3.90 + 3.81 + 2.38) = 17.56, / 6 = **2.93**, x 1.3 boundary uplift
= **3.80**, not 4.24. The 3.26 belongs to a different set -- the
five commercial replacers Detzel collates INCLUDING the excluded
potato+soy 3.47, (2.72 + 3.90 + 2.38 + 3.47 + 3.81) / 5 = 3.256,
x 1.3 = 4.23. Dropping 3.47 as the doc intends leaves the four
genuinely independent commercial values, mean 3.2025, x 1.3 =
4.16. So the independent route lands between **3.80 and 4.23**
depending on whether Detzel's own research prototypes are counted
as market products, and it does NOT reproduce 4.5. Shipped 4.5
stands anyway (see the 2026-08-29 resolution below) but on a
narrower claim: it is the TOP of the in-scope band, not its
centre. KEY REVISION: the
commissioned anchors (3.4 / 3.5) sit mid-range of the independent
values, so the "commissioner-low bias" premise behind the uplift
is retired -- the 1.3x is justified on boundary grounds alone
(gate -> retail + supply-chain losses). Smetana et al. 2015 is
independent but cradle-to-plate per cooked meal (no per-kg
numbers, unusable); "Bryant 2022 = 2.4" re-checked 2026-07-20 and
still unverifiable on any live page -- still not used.

**"4.5 may be ~3x low" -- RESOLVED 2026-08-29, value KEPT at 4.5.**
The concern traced to one source, Saget et al. 2021, whose Table 3
gives 1.5 kg CO2e for a 113 g plant patty (~13.3 per kg). Full text
fetched live 2026-08-29 -- note the citation URL in the item's
`sources[]` was dead: `researchrepository.ul.ie/bitstreams/<uuid>/
download` now returns the DSpace single-page-app shell to any
automated client, and the PDF only comes back from
`researchrepository.ul.ie/server/api/core/bitstreams/<uuid>/content`
(persistent handle `hdl.handle.net/10344/10473`). The item's URL is
updated to the working one. Four findings, each verified in the
fetched text, and together they close it:

1. **Boundary.** "Fig. 1 illustrates the system boundaries for the
   cradle to fork assessment"; the consumption stage is modelled
   with "a cooking time of 3 minutes each side for the VB, using
   0.55 kWh", plus 0.099 kWh of fridge storage and 0.159 km of
   consumer car transport. This dataset's declared scope excludes
   home cooking, home refrigeration and retail-to-home transport,
   so those legs are out of scope by construction, not by oversight.
2. **The paper contradicts itself on the single biggest processing
   row.** Table 2 charges every patty "Burger production | Energy
   for grinding/mixing electricity | MJ | 4.20 | 4.20 | 4.20
   (Kamdem and Hardy, 1995)" while the methods text for the same
   step and the same citation reads "To grind the meat into a burger,
   4.2 kJ of electricity were used, based on Kamdem & Hardy (1995)."
   4.20 MJ is 1.17 kWh per 113 g patty, of order 0.5 kg CO2e on a UK
   grid -- roughly a third of the whole 1.5. A thousandfold internal
   discrepancy on a third of the number is not a figure to re-base a
   dataset on.
3. **Product breadth.** Their VB "is made of 16 different crops",
   ingredients "shipped to a first factory where they are processed,
   then shipped to the UK". That is the formulated end of a category
   this dataset defines as spanning plain soy mince to formulated
   patties.
4. **Their beef reads low too, so the scales cannot be mixed one
   number at a time.** Table 3 per 113 g: BB (IE) 4.5 and BB (BR)
   6.6, i.e. 39.8 and 58.4 per kg against this dataset's beef
   70.3608; under their (bio)physical allocation (Table 5) the same
   patties are 1.7 and 2.3, i.e. 15.0 and 20.4 per kg. **The open
   item's claim that "that study's beef patties sit close to ours"
   was wrong** -- it is true only for the Brazilian economic-
   allocation case (-17%) and false for every other cell.

Where that leaves 4.5: the in-scope evidence spans 3.80 (independent
literature incl. prototypes, uplifted) to 4.49 (commissioned mean,
uplifted). 4.5 is the top of that band. For a number the app uses to
praise a swap away from meat, the top of the band is the correct
side to sit on, and moving it down would flatter the swap on
evidence that does not support the move. **Kept, with the PDR section 5
rule 15 disclosure, and the notes rewritten to state the resolution
instead of the worry.** Invariants 12 and 14 are untouched.
Residual, moved to PDR section 6: the beef-to-plant RATIO the app shows
(15.6x per kg) is far above the 3.0-4.4x Saget finds within one
consistent accounting system, and that is a difference in the beef
number as much as the plant one.

**Beans (canned) -- added 2026-07-20, closing the canned-beans
open item.** The dry-basis 1.79 factor and a drained-can preset
were physically inconsistent (canned beans are ~2.5x hydrated,
plus canning energy and a steel can). A dry-equivalent preset
alone fails the honesty check: the CarbonCloud US canned-bean
model attributes processing 19% + packaging 42% = 61% of the
footprint to the canning chain (~129 g CO2e per 130 g drained
serving -- more than the ~93 g the dry content alone counts), and
the packaging-dominance structure is peer-review-corroborated
(Foods 13(5):655 via PMC10930983, accessed 2026-07-20, citing
Tidaker et al., verbatim: "For canned pulses, the energy use
associated with retorting was almost negligible compared to the
energy expended in the production and subsequent management of
packaging waste."). So a separate DRAINED-basis item ships.

Hydration ratio (for the dry item's guidance note), triangulated:
Bean Institute
(https://beaninstitute.com/resources/cook-with-beans/dry-vs-canned/,
verbatim: "One cup of dry beans" produces "3 cups cooked beans,
drained" -> ~2.66x by weight via USDA cup weights); USDA FDC
dry-matter method (water 11.0% raw vs 65.7% boiled black beans,
FDC 173734 / 173735 live API -> 89.0 / 34.3 = 2.60x); USDA Food
Buying Guide yields (~2.0-2.1x incl. service losses).
Conservative 2.5x -> a drained 130 g half-can is ~52 g dry.

Candidate table (per kg DRAINED):

| Value | Construction | Source |
|------:|--------------|--------|
| **1.62** | CarbonCloud US canned plain beans 1.10 as-sold / 0.677 USDA-FBG drained fraction (10.5 oz / 15.5 oz can) | CarbonCloud + USDA FBG |
| **1.71** | bottom-up: P&N Other Pulses 1.79 dry / 2.5 hydration = 0.716 content + canning-and-can share (61% x 1.10 / 0.677 = 0.99) | P&N + CarbonCloud model shares |
| 0.8 | Tidaker et al. 2021, per kg cooked canned beans, Tetra Recart carton, Sweden -- peer-reviewed LOWER BOUND, not averaged (packaging format mismatch) | https://doi.org/10.1016/j.spc.2021.01.017 (abstract via the Semantic Scholar record), verbatim: "Emissions of greenhouse gases per kg cooked product ranged from 0.1 kg CO2e for Swedish pulses purchased dry to 0.8 kg CO2e for canned beans." |

Chosen: **1.7** = mean(1.62, 1.71) = 1.665 rounded UP. CarbonCloud
inputs (all accessed 2026-07-20, autogenerated proxy models):
BLACK BEANS, Iberia Foods 1.10
(https://apps.carboncloud.com/climatehub/product-reports/id/1067146899478,
agriculture 29% / transport 10% / processing 19% / packaging 42%);
DARK RED KIDNEY BEANS, Supervalu 1.10
(https://apps.carboncloud.com/climatehub/product-reports/id/1195624044624);
ORGANIC BLACK BEANS, Alanric 1.10
(https://apps.carboncloud.com/climatehub/product-reports/id/945064833732).
A branded "Bush's" cluster at 3.88 covers sugary baked beans and
is excluded. Confidence Medium (proxy-model-dependent; the two
constructions agree within 6%; peer-reviewed datum is a
lower-bound carton format). Result: 130 g drained = 221 g CO2e vs
233 g under the old inconsistent arithmetic (-5%) -- the old
output was accidentally near-right on a wrong basis. NEVER
compare beans_canned (1.7, drained) with beans_lentils (1.79,
dry): different bases, and the numbers are a 5% apparent tie.
Tidaker full text read 2026-09-01 (journal pre-proof PDF,
doi 10.1016/j.spc.2021.01.017), closing the fetch-blocked open
item. Verified verbatim: "Emissions of greenhouse gases per kg
cooked product ranged from 0.1 kg CO2e for Swedish pulses
purchased dry to 0.8 kg CO2e for canned beans." and "For canned
pulses, the contribution of packaging and processing was 0.14 and
0.02 kg CO2e, respectively." (Tetra Recart packs; the 0.8 is
beans from China/USA processed in Italy, so it includes
intercontinental transport). The paper carries NO steel-tin
figure -- the "0.97 steel tin chickpeas" search snippet is not in
it; steel tins appear only qualitatively: "Packaging the product
in glass bottles or steel tins, instead of Tetra Recart packs,
would give an even larger impact (Del Borghi et al., 2018;
Markwardt and Wellenreuther, 2017)." That direction confirms the
0.8 as a lower bound for this steel-tin drained-basis item, and
the shipped 1.7 stays: honest-high against the peer-reviewed
carton figure, with the CarbonCloud proxy dependence of both
constructed legs still disclosed in the item's notes.

### 3.4 Staples (verified 2026-07-18)

| Item | kg CO2e/kg | Statistic / basis | Confidence |
|------|-----------:|-------------------|------------|
| Rice | 4.45 | mean w/ losses | High |
| Bread (wheat) | 1.57 | mean w/ losses, derived (Wheat & Rye) | Medium |
| Pasta | 1.57 | mean w/ losses, derived (Wheat & Rye) | Medium |
| Oats | 1.84 | D3 average: (P&N mean 2.48 + CarbonCloud 1.20)/2 | Medium |
| Potatoes | 0.46 | mean w/ losses | High |

Anchor rows, verbatim: `Rice,2010,4.45`, `Wheat & Rye,2010,1.57`,
`Oatmeal,2010,2.48`, `Potatoes,2010,0.46`.

- **Rice is the methane-driven top staple** (farm stage 3.55 of
  4.45). OWID methane article, verbatim (accessed 2026-07-18,
  https://ourworldindata.org/carbon-footprint-food-methane):
  > "This is not the case for plant-based foods, with the
  > exception of rice. Paddy rice is typically grown in flooded
  > fields: the microbes in these waterlogged soils produce
  > methane."
  CarbonCloud corroboration (value-as-of 2026-07-18,
  corroboration only): World rice benchmark 1.59
  (https://apps.carboncloud.com/climatehub/agricultural-reports/benchmarks/bb874b00-81be-47e5-b3a4-e2203c57492f);
  husked dry 1.74
  (https://apps.carboncloud.com/climatehub/product-reports/id/2241667182082);
  milled dry 2.17
  (https://apps.carboncloud.com/climatehub/product-reports/id/78371698047).
  The ~2.8x gap to the anchor is boundary/methane-assumption
  difference; record in the methodology spread discussion.
- **Bread and pasta are DERIVED**: P&N publishes neither product;
  both map to the "Wheat & Rye" grain (1.57). No baking or drying
  energy is added (outside the P&N farm-to-retail boundary of the
  grain product) -- `calculation_notes` must state this
  (grain-factor note, PDR section 5). Store the exact 1.57 for both
  (FR-18); UI rounding may show 1.6. Corroboration lower bounds
  (CarbonCloud, value-as-of 2026-07-18): Soft bread wheat 0.87
  (https://apps.carboncloud.com/climatehub/product-reports/id/99955091022),
  Pasta dry 1.16
  (https://apps.carboncloud.com/climatehub/product-reports/id/116454395874),
  Wheat flour 0.79
  (https://apps.carboncloud.com/climatehub/product-reports/id/9017061954).
- **Oats -- owner decision D3 (2026-07-18).** The one genuine
  staples conflict: P&N "Oatmeal" 2.48 is ~2x CarbonCloud rolled
  oats with no boundary explanation as clean as rice's methane
  story. D3 ships the average of the two credible candidates,
  recomputed from the values as accessed:

  | Input | Value | Access date | Source |
  |-------|------:|-------------|--------|
  | P&N "Oatmeal" mean w/ losses | 2.48 | 2026-07-18 | OWID grapher CSV |
  | CarbonCloud "Rolled oats" live value | 1.20 | 2026-07-18 (audit fetch; was 1.25 at research fetch -- drifted) | https://apps.carboncloud.com/climatehub/product-reports/id/61296836049 |

  **(2.48 + 1.20) / 2 = 1.84.** Confidence Medium.
  `calculation_notes` must show this averaging arithmetic and
  both access-dated inputs. Consequences: oats drops below
  tomatoes (2.09) -- ordering already on the never-pin list --
  and joins the ~1.8 cluster with beans/lentils (1.79) and wine
  (1.79); the rice-top-staple pin margin improves to +142%
  (section 6). Re-read the live CarbonCloud value at the next
  data pass (PDR section 6).
- Potatoes: lowest staple (farm 0.19, near-zero LUC).

### 3.5 Vegetables (verified 2026-07-18)

| Item | kg CO2e/kg | OWID category | Confidence |
|------|-----------:|---------------|------------|
| Tomatoes | 2.09 | Tomatoes | High (mean) |
| Root vegetables | 0.43 | Root Vegetables | High |
| Cabbage & broccoli | 0.51 | Brassicas | High |
| Onions & leeks | 0.50 | Onions & Leeks | High |

Anchor rows, verbatim: `Tomatoes,2010,2.09`,
`Root Vegetables,2010,0.43`, `Brassicas,2010,0.51`,
`Onions & Leeks,2010,0.5`.

OWID-to-app name mapping (deliberate everyday-words choice):
"Brassicas" -> "Cabbage & broccoli"; "Root Vegetables" ->
"Root vegetables"; "Onions & Leeks" -> "Onions & leeks".

**Tomatoes -- field vs heated-greenhouse spread (QA-1
correction).** The corpus's original citation for the spread
("Payen, Basset-Mens & Perret", Springer DOI
10.1007/s13593-013-0171-8, quotes "0.1-0.5 / 0.4-10.1" and
"2.75 times") was WRONG: that DOI resolves to a different paper
and neither quote exists in it or anywhere findable. Corrected
sourcing, both live-verified:

- **Theurl, Haberl, Erb & Lindenthal (2014)**, "Contrasted
  greenhouse gas emissions from local versus long-range tomato
  production", Agronomy for Sustainable Development 34, 593-602,
  https://link.springer.com/article/10.1007/s13593-013-0171-8
  (abstract sentence verified verbatim on the live page,
  re-verified at assembly 2026-07-19):
  > "Imported tomatoes from Spain and Italy have two times lower
  > greenhouse gas emissions than those produced in Austria in
  > capital-intensive heated systems."
- Naked Scientists Q&A (Dr Samarthia Thankappan, Univ. of York),
  https://www.thenakedscientists.com/articles/questions/qotw-do-home-grown-tomatoes-produce-less-co2
  (verbatim, accessed 2026-07-18):
  > "Out-of-season tomatoes grown under heated greenhouses add
  > significantly to greenhouse gas emissions, and this
  > contribution typically overshadows the carbon footprint of
  > tomatoes imported from long distances from warmer production
  > regions."

The 2.09 factor was never affected (OWID-anchored). The old
numeric range "field 0.1-0.5 vs heated greenhouse 0.4-10.1
kg CO2e/kg" and the ">20x swing" phrasing are NOT reproduced by
any verifiable source and stay banned from app copy. SOURCED
replacement numbers (closed 2026-07-19): Clune, Crossin &
Verghese 2017, accepted manuscript openly hosted by Lancaster
University (CC BY-NC-ND,
https://eprints.lancs.ac.uk/id/eprint/79432/; PDF
https://eprints.lancs.ac.uk/id/eprint/79432/4/1_s2.0_S0959652616303584_main.pdf).
Table 5 row transcriptions (median, mean, stdev, deviation, min,
max, Q1, Q3, studies, values; single spaces):

> "Tomatoes 0.45 0.46 0.18 39% 0.08 1.00 0.35 0.55 19 56"
> "Tomatoes: passive greenhouse 0.51 0.67 0.34 51% 0.32 1.28 0.44 0.86 5 8"
> "Tomatoes: heated greenhouse 2.20 2.69 1.36 51% 0.92 6.12 1.86 3.65 13 33"

Supporting prose, verbatim from the same PDF:

> "Greenhouse fruit and vegetables from heated greenhouses were
> notably higher than fieldgrown equivalents, with a median of
> 2.13 kg CO2-eq/kg. Passive greenhouses with no auxillary heating
> had GWP figures comparable with the upper quartile of some field
> grown fruit and vegetables (1.10 kg CO2-eq/kg)."

App copy may now state: field-grown median 0.45 (range 0.08-1.00)
vs heated-greenhouse median 2.20 (range 0.92-6.12) kg CO2e/kg --
a ~5x median gap, consistent with the qualitative Theurl point
above. The real Payen, Basset-Mens & Perret 2015 paper remains
unreadable (Agritrop refused connections 2026-07-19; abstract
publisher-elided) but is no longer needed.

Meta-analysis corroboration: Clune et al. 2017
(https://www.sciencedirect.com/science/article/abs/pii/S0959652616303584)
-- fresh root-veg and brassica category medians sub-0.5, agreeing
with 0.43/0.51 in magnitude and ordering (abstract-only scope
confirmation; paywalled). CarbonCloud broccoli 0.34 (value-as-of
2026-07-18,
https://apps.carboncloud.com/climatehub/product-reports/id/89051480645).

### 3.6 Fruit (verified 2026-07-18)

| Item | kg CO2e/kg | OWID category | Confidence |
|------|-----------:|---------------|------------|
| Bananas | 0.86 | Bananas | High |
| Apples | 0.43 | Apples | High |
| Citrus | 0.39 | Citrus Fruit | High (raised 2026-07-19) |
| Berries | 1.53 | Berries & Grapes | Medium |

Anchor rows, verbatim: `Bananas,2010,0.86`, `Apples,2010,0.43`,
`Citrus Fruit,2010,0.39`, `Berries & Grapes,2010,1.53`.

Perennial orchards give fruit slightly NEGATIVE land-use-change
terms (small carbon sinks): citrus -0.146, bananas -0.026,
apples -0.029.

Key sources (accessed 2026-07-18):

- Svanes & Aronsson 2013 (banana cradle-to-retail LCA, Costa Rica
  to Norway),
  https://link.springer.com/article/10.1007/s11367-013-0602-4:
  > "The carbon footprint of bananas from cradle to retail was
  > 1.37 kg CO2 per kilogram banana."
  > "Including the consumer stage resulted in a 34 % rise in CF,
  > mainly due to high wastage."
- FAO World Banana Forum,
  https://www.fao.org/world-banana-forum/projects/good-practices/carbon-footprint/en/:
  > "The results vary widely based on the methodology and data
  > used: from 324g to 1124g CO2e/kg of bananas."
  (brackets OWID's 0.86)
- Apple orchards, China (Scientific Reports 2025),
  https://www.nature.com/articles/s41598-025-88885-6:
  > "In 2021, the average CEY for apple orchards in China was
  > 0.23 kg CO2 eq kg-1"
  (cradle-to-farm-gate; consistent with 0.43 once packaging,
  transport, losses are added)
- Strawberries, EU CAP Breeding Value project,
  https://eu-cap-network.ec.europa.eu/projects/practice-abstracts/how-improve-environmental-sustainability-strawberry-production_en:
  > "the carbon footprint of 1 kg strawberry ranged from 0.21 to
  > 3.80 kg CO2 eq/kg strawberry with an average of 0.58."

Caveats: the OWID "Berries & Grapes" category is a
berries-plus-grapes BLEND -- pure soft berries air-freighted out
of season sit well above 1.53, table grapes below; science sheet
must say "includes grapes" (PDR section 5). Citrus corroboration
CLOSED 2026-07-19 (was order-of-magnitude only) with two
independent live-quotable sources; confidence raised to High:

- Bell & Horvath 2020, Environ. Res. Lett. 15 034040 (open
  access,
  https://iopscience.iop.org/article/10.1088/1748-9326/ab6c2f),
  verbatim:
  > "Unique life-cycle production footprints for five of the
  > seven regions were calculated, ranging from 0.20 kgCO2e/kg
  > (California, Texas) to 0.33 kgCO2e/kg (South Africa)."
  > "the cradle-to-market carbon footprint of oranges delivered
  > to US cities can vary by more than a factor of two, depending
  > on the production origin (e.g. 0.3 kgCO2e/kg for Californian
  > oranges delivered to New York City versus 0.7 kgCO2e/kg for
  > Mexican oranges delivered to New York City)."
- Clune et al. 2017, Table 5 (Lancaster OA copy, URLs in 3.5),
  row transcription: "Orange 0.33 0.35 0.12 34% 0.18 0.59 0.25
  0.45 9 20" -- median 0.33, range 0.18-0.59 (9 studies, 20
  values), bracketing the shipped 0.39.

### 3.7 Drinks (verified 2026-07-18)

| Item | kg CO2e/kg (= /L) | Statistic / basis | Confidence |
|------|------------------:|-------------------|------------|
| Coffee (dry grounds) | 28.53 | mean w/ losses, per kg roasted | High (anchor); per-cup Medium |
| Tea (dry leaves) | 9.0 | non-P&N, assembled | Medium |
| Beer | 1.2 | P&N mean, per-alcohol-unit derived (D2) | Medium |
| Wine | 1.79 | mean w/ losses | High |
| Soy milk | 0.98 | mean w/ losses | High |
| Oat milk | 0.9031262 | mean (milks chart, per L) | Medium |

Anchor rows, verbatim: `Coffee,2010,28.53`, `Wine,2010,1.79`,
`Soy milk,2010,0.98`; and from
`environmental-footprint-milks.csv` (GHG column, kg CO2eq per
liter): `Oat milk,2013,0.76,0.9031262,48.24,1.622563`,
`Soy milk,2013,0.66,0.98,27.8,1.06`. Milks chart subtitle,
verbatim:
> "Impacts are measured per liter of milk. These are based on a
> meta-analysis of food system impact studies across the supply
> chain which includes land use change, on-farm production,
> processing, transport, and packaging."

P&N accepted manuscript (accessed 2026-07-18,
https://josephpoore.com/Science%20360%206392%20987%20-%20Accepted%20Manuscript.pdf),
functional-unit figure rows (10th percentile / mean), verbatim in
the PDF text:
```
Soymilk 354            0.6   1.0        [per 1 liter]
Beer (5% ABV) 695      0.14  0.24       [per 1 unit = 10ml alcohol]
Wine (12.5% ABV) 154   0.07  0.14       [per 1 unit = 10ml alcohol]
Coffee (15g, 1 cup) 346  0.08  0.4      [per 1 serving]
```
Figure caption, verbatim: "(H) Alcoholic beverages (1 unit = 10ml
alcohol)."

- **Coffee.** Per-kg dry roasted product incl. losses. The #2
  tallest per-kg bar in the dataset for a food consumed ~10 g at
  a time -- hard UI requirements in PDR section 5. Independent LCA
  (Nab & Maslin 2020, Geo: Geography and Environment,
  https://rgs-ibg.onlinelibrary.wiley.com/doi/full/10.1002/geo2.96,
  verbatim):
  > "The average carbon footprint of Arabica coffee from both
  > countries was calculated as 15.33 (+/-0.72) kg CO2
  > [equivalent per 1 kg of green coffee] for conventional coffee
  > production and 3.51 (+/-0.13) kg CO2 [for sustainable
  > production]."
  > "each kg of green coffee makes approximately 56 espresso
  > beverages. Thus, the carbon footprint found in the LCA is on
  > average 0.28 and 0.06 kg CO2 [per espresso, conventional and
  > sustainable]."
  The green-bean vs roasted-with-losses gap explains ~15 vs
  ~28.5. Popular restatement: The Conversation,
  https://theconversation.com/coffee-heres-the-carbon-cost-of-your-daily-cup-and-how-to-make-it-climate-friendly-152629
  > "Growing a single kilogram of Arabica coffee ... produces
  > greenhouse gas emissions equivalent to 15.33 kg of carbon
  > dioxide on average. That's raw, pre-roasted beans (otherwise
  > known as 'green coffee')".
- **Beer -- owner decision D2 (2026-07-18): ships 1.2 kg/L**
  (P&N anchor, per-alcohol-unit basis; derivation in archive section 4).
  The dedicated packaged-beer LCA range is recorded as spread
  context in the science sheet, NOT as the factor. Amienyo &
  Azapagic 2016, Int. J. Life Cycle Assess. 21:492
  (https://link.springer.com/article/10.1007/s11367-016-1028-6),
  verbatim:
  > "the GWP of 1 l of beer in glass bottles is estimated at 842
  > g CO [2 eq.] The impact from beer in aluminium and steel cans
  > is lower: 575 and 510 g CO [2 eq.], respectively. As can also
  > be observed ... packaging is the major hotspot, contributing
  > between 35 % (for steel cans) and 55 % (glass bottles)."
  > "the results range widely across the studies, from 400-1475 g
  > CO [2 eq.]/l of beer."
  > "around 90 % is sold as draft and the remaining 10 % as
  > bottled and canned beer ... The casks or kegs used for the
  > draft beer are not considered as they are reused many times."
  Context figures for the science sheet: packaged-format mean
  (0.842 + 0.575 + 0.510)/3 = 0.642; averaged with the
  co2everything compilation 0.70 -> 0.671 (~0.67/L). (Corrected
  per FR-16; an earlier draft wrote "~0.68".)
- **Wine.** Manuscript-derived 1.75/L (archive section 4) vs grapher
  1.79 (losses included) -- adopt 1.79. Nature Comms Earth & Env
  2024 (https://www.nature.com/articles/s43247-024-01766-0),
  verbatim:
  > "the conventional farming exhibits higher values of 0.06-3.0
  > kg CO [2-eq] bottle [-1] of 750 mL wine as compared to mixed
  > and organic farming."
  1.79 x 0.75 = 1.34 kg/bottle, comfortably inside that range.
- **Soy milk.** Triple-corroborated: per-kg grapher 0.98, milks
  chart 0.98, manuscript mean ~1.0/L.
- **Oat milk.** Milks chart 0.9031262 (store exact; displays
  0.90). Commercial LCAs run lower -- Oatly climate-footprint page
  (https://www.oatly.com/oatly-who/sustainability-plan/climate-footprint-product-label),
  verbatim: "we ... declar[e] the product climate impact as kg
  CO2e per kg on the packaging ... from cradle to gate, or as we
  like to call it, 'grower to grocer.'" GreenQueen
  (https://greenqueen.com.hk/oatly-calls-for-mandatory-carbon-labelling-offers-big-dairy-free-ad-space-to-publish-climate-footprint/),
  verbatim: "claims its products emit as little as 0.43kg of CO2e
  per litre ... the highest amount ... the half-litre Barista
  version ... amounts to 0.64kg of CO2e per litre". And the
  independent OWID restatement on the same page: "soy milk emits
  0.98kg, oat milk amounts to 0.9kg, and almond milk 0.7kg per
  litre." Confidence Medium (2018 meta-analysis vs improved
  modern recipes).
- co2everything magnitude cross-checks (OWID/P&N-derived
  secondary; URLs per QA-7), verbatim:
  > "One cup of Coffee (15g) is equivalent to 0.4kg CO2e"
  (https://co2everything.com/co2e-of/coffee)
  > "One bottle of Beer (355ml) is equivalent to 0.25kg CO2e"
  (https://co2everything.com/co2e-of/beer)
  > "One glass of Wine (150ml)" -- "0.13kg CO2e"
  (https://co2everything.com/co2e-of/wine)
  Oat milk 0.22 kg / soy milk 0.25 kg per 250 ml glass
  (https://co2everything.com/co2e-of/oat-milk, /co2e-of/soy-milk).

**Tea -- added 2026-07-19 (owner product call), not in P&N** (per-kg
grapher re-inspected 2026-07-19: 37 entities, no Tea row). Coffee
without tea in a JP-first app meant a 5-10x per-cup overstatement
for anyone proxying. The factor is per kg of DRY LEAVES,
cradle-to-retail, with the water-boiling stage stripped from every
candidate (home preparation energy is excluded for every item in
this dataset).

Candidate table (leaves-only kg CO2e/kg dry):

| Value | Source (origin) | In mean? |
|------:|-----------------|----------|
| 8.70 | Doublet & Jungbluth 2010 (Darjeeling; mean of 4 retail scenarios, boiling 33.0 g/cup removed, FU 1.75 g/cup) | Yes |
| 8.90 | Cichorowski et al. 2015 (Darjeeling; base case via Xu 2019 Fig. 6, 17.8 g per 2 g cup) | Yes |
| 12.42 | Xu et al. 2019 (5 Chinese organic teas: 19.2 / 19.9 green, 11.9 black, 6.6 oolong, 4.5 export) | Yes |
| 6.13 | Premalatha et al. 2024 (S. India; Table 4 cultivation + processing + packaging + transport) | Yes |
| ~2.00 | Azapagic et al. 2016 (Kenya; paywalled -- figures via Xu 2019 Fig. 6 and Premalatha 2024, wood-fuelled CTC at exceptional yields) | Sensitivity only |
| ~21.6 | Munasinghe et al. 2017 (Sri Lanka; packaging-dominated outlier, secondary) | Sensitivity only |
| 3.33 / 4.34 | CarbonCloud Kenya product / Europe farm benchmark, values as of 2026-07-19 (https://apps.carboncloud.com/climatehub/product-reports/id/49306062174; .../agricultural-reports/benchmarks/b417814e-f264-4fc4-bce4-05e5333ffef6) | Corroboration only |

Chosen: **9.0** = (8.70 + 8.90 + 12.42 + 6.13) / 4 = 9.04. The
all-candidate mean including Kenya is 7.63; 9.0 (the JP-relevant
subset mean) sits 18% ABOVE it -- the conservative direction,
justified because Japan drinks mostly domestic green tea and
Japanese cultivation tops the global N-fertilizer intensity range.
Premalatha et al., verbatim: "Nitrogen fertilizers, used
extensively, are a primary driver, with application rates
exceeding 800 kg N/ha/yr globally and reaching 2000 kg N/ha/yr in
Japan (29, 30)." Confidence Medium. No land-use-change term (none
of the candidate LCAs model LUC, unlike P&N coffee).

Key quotes (accessed 2026-07-19):

- Doublet & Jungbluth 2010, LCA of drinking Darjeeling tea
  (ESU-services, full PDF,
  https://esu-services.ch/fileadmin/download/doublet-2010-LCA-Darjeeling-tea-1.0.pdf):
  > "the processing of the fresh tea leaves amounts to 13-15% of
  > the total carbon footprint and the boiling of water in an
  > electric kettle at home causes 64-73% of the total carbon
  > footprint."
  > "The GWP of a cup of tea is around 48 g CO2-eq whereas it
  > reaches 114 g CO2-eq per cup of coffee."
  > "In conclusion, the assumption of using the coffee life cycle
  > for tea for the environmental product information wasn't
  > appropriate and led to a slight overestimation of the
  > environmental impacts."
- Cichorowski et al. 2015, Int. J. LCA 20:426-439
  (https://link.springer.com/article/10.1007/s11367-014-0840-0):
  > "The cradle-to-gate PCF of 1 kg Darjeeling tea is between 7.1
  > and 25.3 kg CO2e"
  > "The largest share, 51 %, makes up the use phase, which is
  > clearly dominated by the boiling of water."
- Xu et al. 2019, J. Cleaner Production 233:782-792 (full PDF via
  the China Agricultural University mirror,
  https://clst.cau.edu.cn/module/download/downfile.jsp?classid=0&filename=e528392575be4ac0b98b18aa71148c75.pdf;
  publisher record https://doi.org/10.1016/j.jclepro.2019.06.136):
  > "The carbon footprint of the two domestic green teas,
  > Wuyangchunyu and Longjing, were highest with 19.2 and 19.9 kg
  > CO2 eq. kg-1 dry tea. The only black tea Wuyangkungfu had a
  > carbon footprint of 11.9 kg CO2 eq. kg-1 dry tea, whereas the
  > oolong tea Jinkengoolong had a carbon footprint of 6.6 kg CO2
  > eq. kg-1 dry tea. The export teabag tea, Green tablets, had a
  > footprint of 4.5 kg CO2 eq. kg-1 dry tea."
- Premalatha et al. 2024, Plant Science Today 11(sp4):01-09
  (https://horizonepublishing.com/journals/index.php/PST/article/download/5374/4828/37914):
  > "The findings revealed that the consumption stage contributed
  > the highest CO2 emissions, accounting for 45%-56% to overall
  > CF."
- Boiling-dominance context (Circular Ecology,
  https://circularecology.com/news/the-carbon-footprint-of-a-cup-of-tea):
  > "The total footprint is 31.5 kg CO2e per kg of tea"
  (base case INCLUDING consumption -- vs the leaves-only 9.0; the
  science sheet must state the exclusion prominently.)

Dropped sources: co2everything tea page returned HTTP 404
(2026-07-19); Berners-Lee cup figures are not verifiable on a
live page.

Per-cup arithmetic: 2 g tea bag x 9.0 = 18 g CO2e (~6% of
coffee's 285 g cup -- the proxy overstatement was ~16x); 3 g
loose leaf = 27 g. One item covers green and black tea (study
ranges overlap almost completely: black 6.4-11.9, green
4.5-19.9); matcha is OUT of scope (whole-leaf powder, shaded
cultivation -- research separately if demanded). Milk in tea is
logged as dairy, not part of this factor. Tea inherits the coffee
UI rule: preset-only entry, per-kg sublabel (PDR section 5).
NEAR-TIES: tea 9.0 vs chicken 9.87 and vs fish (wild-caught) 9.50
-- never-pin (section 6).

**Japanese sencha LCA verified 2026-07-20 (closes the open
item; 9.0 holds).** Masuda & Tomioka 2011, "Evaluation of
Greenhouse Gas Emissions from Tea Cultivation Systems Using the
Life Cycle Assessment Method", Journal of Farm Management
(農業経営研究) 49(3):97-102, DOI 10.11300/fmsj.49.3_97 -- Shiga
Prefecture, Yabukita cultivar (the dominant sencha cultivar);
free access on J-STAGE
(https://www.jstage.jst.go.jp/article/fmsj/49/3/49_97/_article/-char/ja/;
note the article id is `49_97` -- the `49_3_97` form the DOI page
implies returns HTTP 500). Verbatim (JA):

> 「荒茶収量 1kg 当たり温室効果ガス排出量は，平坦地体系
> 6.28kgCO2eq/kg，山間地体系 8.51kgCO2eq/kg であり，平坦地体系の
> 方が少なかった。」

("GHG emissions per 1 kg of aracha yield were 6.28 kgCO2eq/kg for
the flat-land system and 8.51 kgCO2eq/kg for the mountainous
system.") Aracha (荒茶, dried crude tea) is already a per-kg-dry
functional unit -- no dose conversion needed. Boundary:
cradle-to-processing-gate incl. tea-processing energy and
shipping materials, boiling excluded (slightly narrower than
to-retail; extending it would nudge the value UP toward 9.0).
Corroborated by MAFF's 2021 tea report, which reproduces the same
6.28 / 8.51 figures as its case study 3
(https://www.maff.go.jp/j/kanbo/kankyo/seisaku/s_kanri/pdf/dai1bu.pdf).
Fertilizer-driven N2O is the largest single contributor
(36.4-37.7%) -- the high-N hypothesis is confirmed at source
level, yet the Japanese total (mean ~7.4) lands mid-range, just
BELOW the four-study mean. Recomputed five-study mean: (8.70 +
8.90 + 12.42 + 6.13 + 7.40) / 5 = 8.71; flat-only / mtn-only
sensitivities span 8.49-8.93 -- all round to 9. The factor stays
9.0 (the four-study mean, conservative side of the five-study
recomputation); Masuda & Tomioka ships in `sources[]` as the JP
anchor. Also documented: SuMPO/METI CFP certified green-tea pages
no longer serve numeric values; ITO EN publishes per-bottle
beverage footprints only (wrong functional unit); MAFF's producer
interviews state Japanese makers do not maintain per-lifecycle
leaf-tea CFP data -- explaining the scarcity.

### 3.8 Treats (verified 2026-07-18)

| Item | kg CO2e/kg | Statistic | Confidence |
|------|-----------:|-----------|------------|
| Dark chocolate | 46.65 | mean w/ losses (D1) | Medium |
| Cane sugar | 3.20 | mean w/ losses | Medium-High |

Anchor rows, verbatim: `Dark Chocolate,2010,46.65`,
`Cane Sugar,2010,3.2`. Supply-chain rows, verbatim:

> "Dark Chocolate,2018,25.814833,6.687002,0,0.3337439,0.1108714,0.037652217,0.7224336,12.940208"
> "Cane Sugar,2018,1.2630405,0.49126986,0,0.037380975,0.7945103,0.036723007,0.08427718,0.4917223"

**Dark chocolate ships at the MEAN 46.65 (owner decision D1).**
The research track originally recommended the median 18.7 for
consistency with an assumed beef-at-60 dataset; D1 settled the
whole dataset on means, so chocolate flips to 46.65 -- a means
dataset with one median item would be exactly the mixed-statistic
outcome the track itself called indefensible. Provenance of the
famous "19": the pre-2022 median-without-losses stage sum
(14.3 + 0 + 3.7 + 0.2 + 0.1 + 0.4 + 0 = 18.7, LUC share 76%),
reproduced digit-for-digit from the archived grapher endpoint
(URL in section 1) -- recorded as the approved fallback
provenance, not the shipped value.

Chocolate is LUC-dominated (mean basis: 25.81/46.65 = 55%) and
the #3 bar in the dataset -- the sublabel requirement in PDR section 5
is mandatory. Key sources (accessed 2026-07-18):

- Project Drawdown,
  https://drawdown.org/insights/what-type-of-chocolate-is-best-for-climate
  (verbatim; page renders a non-breaking hyphen in "CO2-eq"):
  > "Globally, cocoa beans account for an average of 46 kilograms
  > of CO2-eq emissions per kilogram - about half from
  > deforestation. Poore notes that the distribution of emissions
  > associated with this crop is hugely different depending on
  > where it is sourced. "If cacao trees are planted on former
  > cropland, cacao can even sequester carbon.""
- The Earthbound Report,
  https://earthbound.report/2022/09/21/why-does-chocolate-have-a-high-carbon-footprint/:
  > "Until you add land use change, and then the impact of
  > chocolate turns out to be four times greater than thought -
  > and it's down to the cocoa!"
- CarbonBrief interactive (protein-basis caveat),
  https://interactive.carbonbrief.org/what-is-the-climate-impact-of-eating-meat-and-dairy/:
  > "This chart shows that, when protein is considered rather
  > than mass, dark chocolate has the highest footprint. (However,
  > it is worth noting that chocolate typically contains a very
  > small amount of protein in comparison to animal products such
  > as beef and lamb - and therefore a consumer would need to eat
  > much more of it to derive the same amount.)"

**Cane sugar**: LUC 39% of the total. Independent: Belize raw
cane sugar PCF (Martinez,
https://marianne-martinez.squarespace.com/s/The-Carbon-Footprint-of-Raw-Cane-Sugar-Final.pdf),
verbatim:
> "The raw cane sugar PCF from cradle to factory gate amounts to
> 0.474 kg CO2e per kg raw sugar when using remote sensing data,
> 0.760 kg CO2e per kg when using national average LUC rates and
> 1.036 kg CO2..."
(factory-gate, below OWID's 3.20 which adds transport, retail,
losses; demonstrates the dominant LUC sensitivity)

**Milk chocolate -- re-derived 2026-08-29, 14.9 -> 19.35 (v2 item,
no earlier entry in this section).** The shipped value was the
single published figure for the product, and it sat at the bottom
of the item's own declared 14.9-23.8 spread while the item's own
notes told the reader to "treat 14.9 as the low end ... rather than
a central estimate". Value and notes cannot both be right.

Konstantas, Jeswani, Stamford & Azapagic (2018), *Environmental
impacts of chocolate production and consumption in the UK*, Food
Research International 106:1012-1025, accepted manuscript re-fetched
live 2026-08-29 from
https://pure.manchester.ac.uk/ws/files/65560111/Environmental_impacts_of_chocolates.pdf.
Everything the item cites it for checks out verbatim:

- The product identification is correct. The three products are
  "chocolate coated wafers (chocolate countlines), milk chocolate
  (moulded chocolate) and malty chocolates (chocolates in bag)", so
  MCH in Fig. 5 IS milk chocolate, not a format the item has
  mis-labelled.
- Fig. 5, verbatim: "MCH with LUC 14.9, MCH no LUC 3.4, CHC with LUC
  10.5, CHC no LUC 2.9, CHB with LUC 14.2, CHB no LUC 4.1". The
  abstract's base-case band is "2.91-4.15 kg CO2 eq. ... per
  kilogram of chocolate", and LUC multiplies it: "a 3-4 fold
  increase in GWP in comparison to the base case".
- Table 1 recipe, verbatim: sugar 45, milk powder 24.5, cocoa butter
  17, vegetable fat 5, cocoa liquor 8, emulsifiers 0.5. Cocoa
  derivatives = 17 + 8 = **25%**.
- Boundary: functional unit "1 kg of packaged chocolate consumed at
  home", "the system boundary is from cradle to grave", including
  "consumption at home" and post-consumer waste. Wider than this
  dataset in the consumption direction, narrower in the
  supply-chain-losses direction.
- The authors' own warning stands: "the data for cocoa LUC should be
  treated with caution due to a high uncertainty".

**The rebuild.** Price the paper's own recipe on this dataset's own
rows. Milk powder uses the paper's yield, "7.69 kg raw milk was
required to produce 1 kg of milk powder", against `milk_dairy` 3.15
(`Milk,2010,3.15`, re-fetched live 2026-08-29), so 24.2235 per kg of
powder. Non-cocoa legs: 0.45 x 2.922 (`sugar`) + 0.245 x 24.2235 +
0.055 x 7.955247 (`palm_oil`, covering vegetable fat and
emulsifiers) = 1.3149 + 5.9348 + 0.4375 = **7.6872**. Cocoa leg:
P&N publish no cocoa-ingredient row -- their Table S1 unit is "Cocoa
1 kg of dark chocolate" -- so the cocoa price has to be backed out
of `dark_chocolate` 46.65 (`Dark Chocolate,2010,46.65`, re-fetched
live 2026-08-29) under an assumed dark recipe:

| assumed dark bar | implied cocoa /kg | milk chocolate |
|---|---:|---:|
| 100% cocoa (the extreme floor) | 46.65 | **19.35** |
| 90% cocoa | 51.51 | 20.56 |
| ~71% cocoa | ~63.7 | **23.8** |
| 65% cocoa | 70.20 | 25.24 |

**Ship 19.35.** It is simultaneously (a) the midpoint of the item's
already-declared 14.9-23.8 spread, (b) the absolute FLOOR of the
dataset-consistent rebuild, since charging cocoa the entire
dark-chocolate figure is the cheapest cocoa P&N can possibly imply,
and every real dark recipe contains sugar and so makes cocoa dearer.
Any assumption more realistic than "a dark bar is pure cocoa" pushes
this number UP. That 19.35 and the spread midpoint agree to 0.0003
is a coincidence, but a load-bearing one: the value is a derivation,
not a number chosen to move the UI. `statistic` becomes
`case_study_range_midpoint` (the `honey` precedent), tier stays 2,
spread stays 14.9-23.8 so the published figure remains visible as
the low end.

**What it does to the comparison, and the honest caveat.** The
milk-vs-dark delta drops from 68.06% to (46.65 - 19.35) / 46.65 =
**58.52%**, under dark chocolate's own statistic bar of
(1 - 1/2.4947) x 100 = **59.92%**, so `checkVerdict` now refuses the
pair with `VerdictBlock.uncertainItem` naming dark chocolate. That
is the outcome the item's notes have described all along. **The
margin is 1.4 percentage points and that is thin**: if either 19.35
or dark chocolate's 2.4947 is ever re-derived, the block can flip.
The durable protection is copy rule 18 (PDR section 5) and the never-pin
entry (section 6), not the arithmetic.

**Rejected alternatives.** (i) *Keep 14.9 plus a copy rule*: a copy
rule is a doc rule, the gate is code, and nothing in
`lib/features/food/` reads a chocolate-vs-chocolate exception, so
the app would have gone on publishing the 68.1% gap. (ii) *Widen the
declared uncertainty via `statistic_ratio`*: this cannot work here.
`checkVerdict` takes only the WIDEST ratio in the comparison, dark
chocolate already carries 2.4947, and blocking a 68.1% gap would
need a ratio above 3.135 on milk chocolate -- a spread wider than
any evidence, on a field the metadata defines as an item's own
published mean/median ratio, which milk chocolate does not have. It
would be inventing a number to force a UI outcome.

### 3.9 Oils (verified 2026-07-18)

| Item | kg CO2e/kg | Statistic | Confidence |
|------|-----------:|-----------|------------|
| Olive oil | 5.42 | mean w/ losses | Medium |
| Palm oil | 7.32 | mean w/ losses | Medium |

Neither oil appears in the per-kg grapher CSV (absence confirmed
by the recomputation agent); both factors are the supply-chain
stage sums. Rows, verbatim:

> "Olive Oil,2018,-0.3236843,3.672172,0,0.5671888,0.41411418,0.039322365,0.7401167,0.31564602"
> "Palm Oil,2018,2.7555852,1.875132,0,1.1253257,0.18511687,0.038737673,0.78810805,0.5487651"

Olive oil has NET-NEGATIVE land-use change (-0.324; groves
sequester); palm oil's LUC (+2.756) is ~38% of its total.

**Palm-vs-olive ordering is boundary-dependent -- never pin, no
superlatives** (section 6). Within the shipped LUC-inclusive
boundary palm (7.32) > olive (5.42), and the without-losses
vintage agrees (palm 7.60 > olive 6.00, Wayback-verified). But on
a production-only basis the two are close and can reverse (palm
~2.2, olive ~2.4). Methodology note: "Palm oil ranks above olive
oil only because our boundary counts land-use change
(deforestation). On a production-only basis the two are close and
can reverse."

Independent palm-oil source (oaepublish,
https://www.oaepublish.com/articles/cf.2025.90, verbatim; page
renders subscripts as "CO 2eq t -1"):
> "investigated refined palm oil, defined kernel as by-product
> and used mass allocation in order to allocate GHG emissions,
> they calculated a CF for refined palm oil of 2.2 t CO2eq t"
(= ~2.2 kg/kg production excl. most LUC; OWID's 7.32 adds LUC and
the retail chain.) Olive-oil production-only corroboration CLOSED
2026-07-19: Ruiz-Carrasco et al. 2023, "Life Cycle Assessment of
Olive Oil Production in Turkey", Agriculture 13(6):1192 (Gold OA
CC BY, https://doi.org/10.3390/agriculture13061192; abstract
verbatim via the Semantic Scholar record for the DOI -- MDPI
blocked automated fetch):

> "In the climate change category, analysis results gave a value
> of 3.04 kg of CO2 equivalent for 1 kg of unpackaged virgin
> olive oil. The phase that contributes the most in all impact
> categories is the farming phase (2.53 kg of CO2 equivalent),
> whereas the most impactful activities are fertilization and
> irrigation (69.5% of impact in this stage)."

Plus two live CarbonCloud pages (values as of 2026-07-19,
corroboration only): "Olive oil" UK 1.77
(https://apps.carboncloud.com/climatehub/product-reports/id/177975059702,
agriculture 79% of total) and "Olive oil, origin: ESP" 1.74
(https://apps.carboncloud.com/climatehub/product-reports/id/177559379541)
-- both drifted down from the 1.92/1.89 seen in search-index
snapshots, reconfirming the QA-6 re-read rule. The methodology
note's "palm ~2.2 vs olive ~2.4 are close on a production-only
basis" now rests on a sourced ~1.7-3.0 production-phase band.

---

## 4. Chosen Dataset Values

The table below is the **v1 core** (the 43 rows shipped before the
v2 expansion), kept because these are the anchors most other items
derive from or tie to. Group counts: vegetables 43, fruit 21,
drinks 18, staples 15, plant protein 12, seafood 11, dairy & eggs
10, condiments 9, meat 8, treats 8, oils 6, prepared 4, nuts &
seeds 2. Roughly 70 distinct researched numbers carry those 167
items: many rows are deliberately the same category value under
different names, grouped by `tie_group` so no copy can rank them.
Dairy & eggs went 9 to 10 on 2026-08-29 when `cream` shipped
(section 3.2); everything else is the v2 count.

**Ten of the 43 rows below no longer ship as written**, and the
JSON wins wherever they disagree: three carry superseded values
(`pasta` 2.290444 per D9, `peas` 0.53 per D10, `small_fish`
3.8779404 per the seafood D11), and seven ids are retired --
`fish_wild` by the seafood D11, `cane_sugar` renamed to `sugar`
2.922 by the sugar D8, and the five umbrella produce rows
(`root_vegetables`, `cabbage_broccoli`, `onions_leeks`, `citrus`,
`berries`) split into species rows on the same anchors. The
decision notes after the table and RESEARCH_FOOD_ARCHIVE.md section 6
record each move.

Basis: kg CO2e per kg as-purchased (liquids: per L = per kg at
density 1.0). Statistic column records mean/median and losses
basis per item (data-review rule); the JSON stores exact unrounded
values and the UI rounds for display, so a few entries below are
shown to fewer digits than they ship at (the two oils). Quotes and
URLs for these v1 rows are in section 3; for every shipped row,
v1 and v2 alike, the citation of record is the item's own
`sources[]` in `data/app/food_items.json`.

| id | Item | kg CO2e/kg | Statistic / basis | Confidence |
|----|------|-----------:|-------------------|------------|
| beef | Beef | 70.3608 | 0.56 x 99.48 + 0.44 x 33.30, OWID production weights (D6) | High |
| lamb | Lamb | 39.72 | P&N mean w/ losses ("Lamb & Mutton") | High |
| pork | Pork | 12.31 | P&N mean w/ losses ("Pig Meat") | High |
| chicken | Chicken | 9.87 | P&N mean w/ losses ("Poultry Meat") | High |
| prawns_farmed | Prawns (farmed) | 26.87 | P&N mean w/ losses (supply CSV row "Shrimps (farmed)") | Medium-High |
| prawns_wild | Prawns (wild-caught) | 34.08 | non-P&N; Gephart 2021 wild/farmed ratio (1.2682) scaled onto the P&N farmed anchor; wild is WORSE than farmed (added 2026-08-02) | Medium |
| fish_farmed | Fish (farmed) | 13.63 | P&N mean w/ losses | High -> Medium-High (coarse category) |
| fish_wild | Fish (wild-caught) | 9.50 | non-P&N; Gephart 2021 wild fisheries completed with P&N post-farmgate stages; mean of wild-mix 9.05 and canned-tuna 9.53, rounded up | Medium |
| small_fish | Small oily fish (sardines, mackerel) | 5.5 | non-P&N; Gephart herring/sardines row completed as fish_wild; mean of fresh 5.17 and canned 5.78, rounded up | Medium-High |
| cheese | Cheese | 23.88 | P&N mean w/ losses | High |
| butter | Butter | 21.574980 | derived 2026-09-01: milk 3.15 x 6.8492 (AH697 81.30% solids / milk 11.87%); previously 12.0, the 3-LCA European mean, kept as spread_low context | Medium |
| eggs | Eggs | 4.67 | P&N mean w/ losses | High |
| milk_dairy | Milk (dairy) | 3.15 | P&N mean w/ losses; per L = per kg | High |
| tofu | Tofu | 3.16 | P&N mean w/ losses | High |
| beans_lentils | Beans / lentils | 1.79 | P&N mean w/ losses ("Other Pulses"); dry basis | Medium |
| peas | Peas | 0.98 | P&N mean w/ losses | High |
| tree_nuts | Tree nuts (shelled) | 0.43 | P&N mean w/ losses (incl. orchard LUC credit -3.257812); shelled dry kernels | Medium-High |
| peanuts | Peanuts (roasted, shelled) | 3.23 | P&N "Groundnuts" mean w/ losses; roasted shelled basis (split off tree_nuts 2026-08-08) | Medium-High |
| plant_based_meat | Plant-based meat | 4.5 | non-P&N; mean of Beyond 3.4 and Impossible 3.5 LCAs x ~1.3 boundary uplift, rounded up (added 2026-07-19). Corrected 2026-08-29: the independent ifeu route gives 3.80-4.23, not "~4.5" -- 4.5 is the TOP of the in-scope band, kept deliberately (section 3.3) | Medium-High (raised 2026-07-20) |
| beans_canned | Beans (canned) | 1.7 | non-P&N; DRAINED basis; mean of CarbonCloud/USDA-FBG 1.62 and P&N bottom-up 1.71, rounded up | Medium |
| rice | Rice | 4.45 | P&N mean w/ losses; dry basis | High |
| bread_wheat | Bread (wheat) | 1.57 | derived: P&N "Wheat & Rye" mean w/ losses | Medium |
| pasta | Pasta | 1.57 | derived: P&N "Wheat & Rye" mean w/ losses; dry basis | Medium |
| oats | Oats | 1.84 | D3 average: (P&N 2.48 + CarbonCloud 1.20 as of 2026-07-18) / 2 | Medium |
| potatoes | Potatoes | 0.46 | P&N mean w/ losses | High |
| tomatoes | Tomatoes | 2.09 | P&N mean w/ losses (field + greenhouse mean) | High |
| root_vegetables | Root vegetables | 0.43 | P&N mean w/ losses ("Root Vegetables") | High |
| cabbage_broccoli | Cabbage & broccoli | 0.51 | P&N mean w/ losses ("Brassicas") | High |
| onions_leeks | Onions & leeks | 0.50 | P&N mean w/ losses ("Onions & Leeks") | High |
| bananas | Bananas | 0.86 | P&N mean w/ losses; edible (peeled) preset basis | High |
| apples | Apples | 0.43 | P&N mean w/ losses | High |
| citrus | Citrus | 0.39 | P&N mean w/ losses ("Citrus Fruit") | High (raised 2026-07-19) |
| berries | Berries | 1.53 | P&N mean w/ losses ("Berries & Grapes" blend) | Medium |
| dark_chocolate | Dark chocolate | 46.65 | P&N mean w/ losses (D1; median 18.7 = fallback provenance only) | Medium |
| cane_sugar | Cane sugar | 3.20 | P&N mean w/ losses | Medium-High |
| olive_oil | Olive oil | 5.941953 | P&N supply-chain sum 5.424876 per LITRE / 0.912979 kg/L (D7) | Medium |
| palm_oil | Palm oil | 7.955247 | P&N supply-chain sum 7.316771 per LITRE / 0.919741 kg/L (D7) | Medium |
| coffee | Coffee (dry grounds) | 28.53 | P&N mean w/ losses, per kg roasted; per-cup preset is the entry path | High (anchor) / Medium (per cup) |
| tea | Tea (green or black) | 9.0 | non-P&N; mean of 4 boiling-stripped tea LCAs (8.70 / 8.90 / 12.42 / 6.13), per kg dry leaves (added 2026-07-19; JP sencha LCA verified 2026-07-20 at 6.28-8.51, consistent) | Medium |
| beer | Beer | 1.2 | D2: P&N mean, per-alcohol-unit derived to per L | Medium |
| wine | Wine | 1.79 | P&N mean w/ losses; per L = per kg | High |
| soy_milk | Soy milk | 0.98 | P&N mean w/ losses; per L = per kg | High |
| oat_milk | Oat milk | 0.9031262 | P&N mean (milks chart), per L; displays 0.90 | Medium |

Notes bound to owner decisions (all 2026-07-18):

- **D1 (statistic):** MEANS dataset-wide; dark chocolate 46.65
  (flipped from the track's median recommendation). Median set =
  approved fallback with mandatory statistic disclosure.
- **D2 (beer):** 1.2 kg/L ships; the 0.51-0.84/L packaged-LCA
  range is science-sheet spread context only.
- **D3 (oats):** 1.84 = (2.48 + 1.20)/2, both inputs access-dated
  2026-07-18; arithmetic in calculation_notes; re-read the live
  input at the next data pass.
The seafood source decision was also numbered D8 when it was taken
on 2026-08-08, colliding with the sugar decision below. It is
**D11** everywhere as of 2026-08-29: the sugar decision is the
rightful member of the dated D1-D10 run, and the seafood decision
postdates all of them. Anything written before that date calling
the seafood decision D8 means D11.

- **D8 (sugar, 2026-08-02):** `cane_sugar` 3.20 -> `sugar`
  2.922. Same defect as D5: OWID ships "Cane Sugar" 3.20 and
  "Beet Sugar" 1.81 as separate rows (77% apart), and the bag
  does not say which. Weighted by the European Commission's
  published split -- "beet sugar represents only 20% of the
  world's sugar production, with the other 80% produced from
  sugar cane" -- 0.80 x 3.20 + 0.20 x 1.81 = 2.922. The id
  changed, so stored logs need a migration.
- **D9 (pasta, 2026-08-02):** 1.57 -> 2.290444. P&N's
  "Wheat & Rye" functional unit is "1 kg of bread (variable
  protein wheat)" (Table S1), not grain. Bread is 39.2% water and
  dry pasta 11.3% (MEXT 01026, 01063), so the shipped value
  understated dry pasta by 46%. 1.57 / 0.608 x 0.887 = 2.290444.
  Moisture correction only -- baking and drying energy remain
  uncounted. `bread` 1.57 is unchanged and correct: it IS the
  functional unit, so its notes calling it a derived grain mean
  were wrong and have been fixed.
- **D10 (peas, 2026-08-02):** 0.98 -> 0.53, and the item moved
  from `plant_protein` to `vegetables`. P&N's "Peas" row is
  "1 kg of dry pea without pod" -- split peas, not the frozen
  bag the item's own preset describes. P&N files green peas under
  Vegetables in its own figure caption, so the item is now on the
  "Other Vegetables" category anchor with that disclosed. The old
  value overstated frozen peas by 85%.
- **D7 (oil units, 2026-08-01):** oils were shipped as per-litre
  values in a per-kg field. Corrected: olive 5.42 -> 5.941953,
  palm 7.32 -> 7.955247. The row's own FDC tablespoon portion
  supplies the density, because the previous state used ~0.91
  g/mL for the preset and 1.00 g/mL for the factor -- two
  densities for one substance in one row.
- **D6 (beef value, 2026-08-01):** the single beef item ships at
  **70.3608**, the production-weighted mean of the two P&N rows.
  The weights are OWID's own, published with their arithmetic:
  "Around 56% of global beef production comes from dedicated beef
  herds; and 44% from dairy herds"
  (https://ourworldindata.org/less-meat-or-sustainable-meat,
  verified live 2026-08-01), corroborated by FAO/GLEAM (Opio et
  al. 2013 p.21, 56%/44% of 61.4 Mt in 2005). OWID applies the
  same operator to its per-100g-protein means (0.56 x 50 + 0.44 x
  17 = 35). Keeping 99.48 for a merged item would have shipped a
  sub-population value under a category label -- the only such
  case in the dataset -- and overstated the global product by 41%.
  Known residual: production shares are not consumption shares.
  EU/UK beef is majority dairy-herd (~53); Japanese *consumed*
  beef is ~80% beef-herd via US/AU imports (~86). 70.36 is the
  least-wrong single global value and the science sheet says so.
  The beef action moved 9700 -> 6800 g with it, and again to
  3700 g when it merged into `skip_high_impact_food` (PDR section 4).
- **D5 (beef item, owner call 2026-08-01):** the dairy-herd item is
  **dropped**; a single `Beef` ships at the beef-herd 99.48. No
  label, menu or receipt tells a shopper which herd their beef
  came from, so the split asked users a question they cannot
  answer and put a 3x fork on the dataset's largest value. The
  dairy-herd row stays in section 3.1's provenance and in the
  science-sheet copy as *context*, never as a pickable item.
  Retires safe pin 3.

---

## 5. Serving Presets (sourced raw as-purchased weights)

**Display names are metric only** (2026-08-02): grams, or
millilitres for drinks. No preset name uses oz, cups, pints or
quarter-pounds; pinned by invariant 17. The Derivation column
below still cites oz and tbsp where the SOURCE defines the portion
that way (USDA RACC/FDC, USDA Food Buying Guide) -- that is
provenance and must stay, or the weights cannot be checked against
the source. "Cup" was also dropped from the coffee and tea presets
in favour of "mug": a cup of coffee is a vessel, but the word
collides with the US cup measure.

Grams from FDA RACC (21 CFR 101.12 Table 2) or USDA FoodData
Central portion data unless noted; all accessed 2026-07-18. All
weights are raw / dry / as-purchased (liquids: ml = grams at
density 1.0). Every preset's arithmetic recomputed by the check
agent.

**This is the v1 preset set, and it is not the shipped one.** Wave
10 presetted all 123 v2 additions, the v2 verification pass added
cooked-weight presets to the dry-basis staples (rice, pasta,
beans/lentils, each converting a 100 g cooked portion to its dry
equivalent in the label), and the presets for the rows retired
since (section 4) went with those rows. The table below is kept
for its sourcing: it is where each of these weights comes from and
how it was checked. `data/app/food_items.json` is what ships.

| Item | Preset | Grams | Source basis |
|------|--------|------:|--------------|
| Beef | 1 patty (113 g) | 113 | definitional 4 oz = 113.4 g |
| Beef | 1 steak (medium) | 225 | ~8 oz culinary standard (226.8 g) |
| Lamb | 1 loin chop | 85 | ~3 oz raw chop (RACC neighbourhood) |
| Lamb | 1 serving | 110 | FDA RACC uncooked entree, quote below |
| Pork | 1 pork chop (boneless) | 140 | USDA FDC 167907 "200 calorie serving (139g)" |
| Chicken | 1 breast fillet | 170 | between USDA FDC 171077 half-piece (272/2 = 136 g) and a typical large retail fillet (~200 g); plan's 120/150 g undershoot |
| Chicken | 1 serving (85 g) | 85 | USDA FDC 171077 "3 oz (85g)" |
| Prawns (farmed) | 1 portion | 110 | FDA RACC uncooked fish/shellfish |
| Prawns (farmed) | small portion | 85 | USDA/FDA 3 oz serving equivalent |
| Fish (farmed) | 1 fillet | 110 | FDA RACC uncooked |
| Fish (farmed) | 1 salmon fillet (large) | 198 | USDA FDC 175167 "1/2 fillet (198g)" |
| Fish (wild-caught) | 1 small tuna can | 70 | Hagoromo Sea Chicken L Flake net content 70 g (JP standard can), quote below |
| Fish (wild-caught) | 1 fillet | 110 | FDA RACC uncooked fish (canned-fish RACC is 85 g; USDA FDC 171986 lists 3 oz = 85 g, 1 can = 165 g as US alternates) |
| Small oily fish | 1 mackerel can (drained) | 140 | Sokensha さば水煮 "190g（固形量140g）", quote below (closed 2026-07-20; replaces the net-weight interim) |
| Small oily fish | 1 sardine can (drained) | 92 | USDA FDC 175139 "1 can (3.75 oz) = 92 g" drained solids; FDA canned-fish RACC 85 g is the US-serving alternate |
| Small oily fish | 1 sardine (edible portion) | 32 | Slism "マイワシ 1尾 80gの可食部 32g"; MEXT food composition DB まいわし/生 refuse rate 60% corroborates (closed 2026-07-20) |
| Cheese | 1 slice | 22 | typical pre-sliced cheddar slice |
| Cheese | 1 portion (30 g) | 30 | FDA RACC "Cheese, all others" 30 g |
| Butter | 1 tbsp | 14.2 | USDA FDC 173410 direct portion, quote below (closed 2026-07-19; replaces the earlier density derivation) |
| Butter | 1 pat | 5 | standard restaurant pat (USDA ~5 g) |
| Eggs | 1 large egg | 50 | FDA RACC "Eggs (all sizes) 50 g", label "1 large" |
| Milk | 1 glass | 200 | common 200 ml glass |
| Milk | 1 glass (240 ml) | 240 | FDA RACC "Milk ... 240 mL" |
| Tofu | 1 serving (85 g) | 85 | FDA RACC "Tofu, tempeh 85 g" |
| Tofu | 1/2 block | 175 | half a typical ~350 g retail block |
| Beans/lentils | 1 serving (dry) | 35 | FDA RACC "35 g dry" -- physically consistent with the dry-basis factor |
| Beans (canned) | 1 serving (drained) | 130 | FDA RACC "130 g ... canned in liquid" (drained-basis item added 2026-07-20; the old half-can preset on the dry item is retired) |
| Beans (canned) | 1/2 can (drained) | 150 | USDA Food Buying Guide "1 No. 300 can = about 10.5 oz (1-3/8 cups) heated, drained beans" -> 298 g/can, half rounded up |
| Beans (canned) | 1 can (drained) | 300 | same USDA FBG yield, 298 g rounded up |
| Peas | 1 serving | 85 | FDA RACC vegetables "85 g fresh or frozen" |
| Tree nuts | 1 handful (30 g) | 30 | FDA RACC "Nuts, seeds ... 30 g" |
| Tree nuts | 1 baking portion (143 g) | 143 | USDA FDC 170567 almonds, "1 cup, whole 143" |
| Peanuts | 1 handful (30 g) | 30 | FDA RACC "Nuts, seeds ... 30 g" |
| Peanuts | 1 large portion (146 g) | 146 | USDA FDC 173806 dry-roasted, "1 cup 146" |
| Plant-based meat | 1 patty (113 g) | 113 | definitional 4 oz = 113.4 g; matches the beef patty preset so the burger swap is like for like; the flagship LCAs use the same functional unit ("¼ pound Beyond Burger") |
| Rice | 1 rice-cooker measure (150 g, dry) | 150 | Just One Cookbook, quote below (JP primary market) |
| Rice | 1 serving (dry) | 45 | FDA RACC "Grains ... 140 g prepared; 45 g dry" |
| Bread (wheat) | 1 slice | 50 | FDA RACC row quoted below (QA-5 exact name) |
| Bread (wheat) | 2 slices / sandwich | 100 | 2 x RACC slice |
| Pasta | 1 portion (dry) | 55 | FDA RACC "Pastas, plain: 140 g prepared; 55 g dry" |
| Pasta | 1 large portion (dry) | 100 | ~2 x RACC, labelled generous |
| Oats | 1 bowl (dry) | 40 | FDA RACC hot cereal "40 g plain dry cereal" |
| Potatoes | 1 medium potato | 213 | USDA "1 potato medium (2-1/4 inch to 3-1/4 inch dia) (213g)" |
| Potatoes | 1 small potato | 170 | USDA "1 potato small (170g)" |
| Tomatoes | 1 medium tomato | 123 | USDA "1 medium whole (2-3/5 inch dia) (123g)" |
| Tomatoes | 1 cherry tomato | 17 | USDA "1 cherry (17g)" |
| Root vegetables | 1 medium carrot | 61 | USDA carrot "1 medium (61g)" |
| Root vegetables | 1 portion, chopped (128 g) | 128 | USDA carrot "1 cup chopped (128g)" |
| Cabbage & broccoli | 1 cup broccoli, chopped | 91 | USDA broccoli "1 cup chopped (91g)" |
| Cabbage & broccoli | 1 broccoli stalk | 151 | USDA broccoli "1 stalk (151g)" |
| Onions & leeks | 1 medium onion | 110 | USDA onion "1 medium (2-1/2 inch dia) (110g)" |
| Onions & leeks | 1 large onion | 150 | USDA onion "1 large (150g)" |
| Bananas | 1 medium banana | 118 | USDA FDC 173944 "1 medium (7" to 7-7/8" long) = 118.0 g" (peeled/edible) |
| Bananas | 1 large banana | 136 | USDA FDC 173944 "1 large = 136.0 g" |
| Apples | 1 medium apple | 182 | USDA FDC 171688 "1 medium (3" dia) = 182.0 g" |
| Apples | 1 small apple | 149 | USDA FDC 171688 "1 small = 149.0 g" |
| Citrus | 1 orange | 131 | USDA FDC 169097 "1 fruit (2-5/8" dia) = 131.0 g" |
| Citrus | 1 large orange | 184 | USDA FDC 169097 "1 large = 184.0 g" |
| Berries | 1 portion strawberries (144 g) | 144 | USDA FDC 167762 "1 cup, whole = 144.0 g" |
| Berries | 1 medium strawberry | 12 | USDA FDC 167762 "1 medium = 12.0 g" |
| Dark chocolate | 1 small bar (28 g) | 28 | USDA FDC 170273 "1 oz = 28.35 g" |
| Dark chocolate | 1 square | 12.6 | derived: FDC 170273 "1 bar = 101.0 g" / 8 = 12.625 g (FR-16: earlier draft wrote 12 g, flattering -5%) |
| Cane sugar | 1 tsp | 4.2 | USDA FDC 169655 "1 tsp = 4.2 g" |
| Cane sugar | 1 cube | 2.3 | USDA FDC 169655 "1 serving 1 cube = 2.3 g" |
| Olive oil | 1 tbsp | 13.5 | USDA FDC 171413 "1 tablespoon = 13.5 g" |
| Olive oil | 1 tsp | 4.5 | USDA FDC 171413 "1 tsp = 4.5 g" |
| Palm oil | 1 tbsp | 13.6 | USDA FDC 171015 "1 tbsp = 13.6 g" -- direct FDC portion (QA-8; replaces the earlier density derivation) |
| Coffee | 1 mug (10 g grounds) | 10 | SCA Golden Cup ratio, quote below; standard-mug midpoint (filter ~7-11 g, espresso ~18 g, P&N unit 15 g) |
| Tea | 1 tea bag | 2 | most common bag weight + ISO 3103's 2 g per 100 ml, quotes below |
| Tea | 1 mug, loose leaf (3 g) | 3 | ITO EN sencha/gyokuro guidance (2-3 g per serving), quote below; conservative upper of the JP range |
| Beer | 1 can (EU) | 330 | Wikipedia Drink can, quotes below |
| Beer | 1 can (JP / US) | 350 / 355 | JP most common 350 ml; US 12 oz = 355 ml |
| Beer | 1 large glass (473 ml) | 473 | US pint (UK pint = 568 ml -- note if targeting UK) |
| Wine | 1 glass | 150 | NIAAA standard pour, quote below |
| Wine | 1 bottle | 750 | standard wine bottle |
| Soy milk | 1 glass | 250 | typical glass 200-250 ml |
| Oat milk | 1 glass | 250 | typical glass 200-250 ml |

Preset source quotes, verbatim (accessed 2026-07-18):

- FDA RACC, 21 CFR 101.12 Table 2 (via Cornell LII,
  https://www.law.cornell.edu/cfr/text/21/101.12):
  > "Entrees without sauce, e.g., plain or fried fish and
  > shellfish, fish and shellfish cake 85 g cooked; 110 g
  > uncooked"
  > "Breads (excluding sweet quick type), rolls" -- 50 g
  (exact row name per QA-5 -- the row is "Breads", plural)
  Other RACC rows used (via the official FDA PDF,
  https://fda.report/media/99078/Reference-Amounts-Customarily-Consumed-(RACCs)-in-the-new-NFL.pdf):
  cheese 30 g; butter 1 tbsp (15 mL); eggs 50 g ("1 large,
  medium, etc."); milk 240 mL; tofu/tempeh 85 g; beans "130 g
  for beans in sauce or canned in liquid ...; 90 g for others
  prepared; 35 g dry"; vegetables "85 g for fresh or frozen"
  (label names "green peas"); nuts/seeds 30 g; grains "140 g
  prepared; 45 g dry"; pastas "140 g prepared; 55 g dry"; hot
  cereal "40 g plain dry cereal".
- USDA FoodData Central portions (FDC IDs in the table; primary
  https://fdc.nal.usda.gov/ by ID; retrieved via the FDC API and
  the myfooddata mirror, e.g.
  https://tools.myfooddata.com/nutrition-facts/171077/wt1). The
  quoted "1 medium (...) = 118.0 g" form is a rendering of the
  FDC amount + modifier + gramWeight fields.
- Rice-cooker cup and cooked ratio (Just One Cookbook,
  https://www.justonecookbook.com/how-to-make-rice/):
  > "1 rice cooker cup (180 ml) of uncooked white rice weighs
  > 5.3 oz (150 g)."
  > "1 rice cooker cup yields 2 rice bowls or 2 1/4 cups / 330 g
  > cooked rice."
  So 150 g raw -> ~330 g cooked (~2.2x by weight). The factor
  multiplies the RAW grams -- quantity-editor helper required
  (PDR section 5).
- SCA Golden Cup ratio
  (https://www.genuinebluemountaincoffee.com/blogs/news/what-is-the-golden-ratio-for-specialty-coffee):
  > "55 grams of coffee per liter of water"
  55 g/L x 0.18 L (standard mug) = 9.9 g -> 10 g preset. (QA-4:
  the previously cited "+/-10% (49.5-60.5 g/L)" clause could not
  be found on any reachable page and is dropped; any tolerance
  note is a derived calculation, not a quote.)
- NIAAA, What Is A Standard Drink?
  (https://www.niaaa.nih.gov/alcohols-effects-health/what-standard-drink),
  exact page wording per QA-4:
  > "A 12-ounce can of regular beer at 5% alcohol by volume"
  > "A 5-ounce glass of wine at 12% alcohol by volume"
  (5 fl oz = ~148 ml -> 150 ml preset)
- Wikipedia, Drink can (https://en.wikipedia.org/wiki/Drink_can):
  > "In Japan, the most common sizes are 350 ml and 500 ml"
  > "In China, the most common size is 330 ml."
  (330 ml is also the common EU size; the verbatim sentence on
  the live page is in the China section -- attribution per the
  quote audit.)
- Banana basis: presets use PEELED / edible weight (118 g medium),
  matching how per-kg banana figures are popularly communicated.
  Whole-fruit conversion if ever needed: USDA banana refuse ~36%
  -> factor 1/(1 - 0.36) = 1.5625 (~1.56; FR-16 -- an earlier
  draft wrote ~1.55).

Preset quotes added 2026-07-19 (all accessed 2026-07-19):

- JP tuna can (Hagoromo Foods, Sea Chicken L Flake product page,
  https://www.hagoromofoods.co.jp/products/detail/265.html):
  net content (内容量) "70g" -- the standard JP single-can size
  from Japan's dominant canned-tuna brand.
- Butter tbsp (USDA FDC 173410, Butter, salted, SR Legacy; live
  API
  https://api.nal.usda.gov/fdc/v1/food/173410?api_key=DEMO_KEY),
  verbatim foodPortions JSON:
  > {"amount": 1.0, "modifier": "tbsp", "gramWeight": 14.2, "sequenceNumber": 2}
  (The same record lists pat 5.0 g -- confirming the pat preset --
  cup 227 g, stick 113 g.)
- Tea bag weight (Chen Sheng Hao,
  https://cspuerh.com/blogs/tea-101/how-much-tea-is-in-a-tea-bag):
  > "A single tea bag usually contains between 1.5 to 3 grams of
  > tea, with 2 grams being the most common weight."
  ISO 3103 (via Wikipedia,
  https://en.wikipedia.org/wiki/ISO_3103):
  > "2 grams of tea (measured to ±2% accuracy) per 100 ml boiling
  > water is placed into the pot."
- JP loose-leaf serving (ITO EN Global,
  https://www.itoen-global.com/allabout_greentea/how_to_prepare/):
  preparation table lists sencha "4.0g" per 2 servings (2 g per
  cup) and gyokuro "6.0g" per 2 servings (3 g). 3 g is the
  conservative upper of the 2-3 g range; JP practice re-steeps
  the same leaves, so per cup drunk this over- rather than
  under-counts.

Preset quotes added 2026-07-20 (accessed 2026-07-20):

- JP saba can drained weight (Sokensha 創健社 さば水煮,
  https://sokensha.co.jp/products/product_detail/121407):
  product name verbatim "創健社 さば水煮 190g（固形量140g）" --
  the standard 190 g can with a published drained weight
  (固形量) of 140 g. (The Maruha Nichiro / Umios page for the
  same format, JAN 4901901145714, publishes 内容量 "190g" only;
  it remains the net-content citation.)
- Whole sardine edible portion (Slism nutrition DB,
  https://calorie.slism.jp/110047/):
  > "マイワシ 1尾 80gの可食部 32g"
  Corroborated by the MEXT Standard Tables of Food Composition
  entry まいわし/生
  (https://fooddb.mext.go.jp/details/details.pl?ITEM_NO=10_10047_7):
  refuse rate (廃棄率) "60%" -- 80 g x 0.4 = 32 g edible. The
  factor's basis is edible weight (Gephart), so the preset uses
  the 32 g edible portion, not the whole-fish weight.
- US sardine can (USDA FDC 175139, "Fish, sardine, Atlantic,
  canned in oil, drained solids with bone"): portion "1.0 can
  (3.75 oz) = 92.0 g".
- Canned beans drained yield (USDA Food Buying Guide, Section 1
  yield table,
  https://foodbuyingguide.fns.usda.gov/files/Reports/USDA_FBG_Section1_MeatsAndMeatAlternatesYieldTable.pdf):
  > "1 No. 300 can = about 10.5 oz (1-3/8 cups) heated, drained
  > beans"
  (10.5 oz = 298 g drained per can; also gives the 0.677 drained
  fraction used in the beans_canned factor.)

---

## 6. Sanity Invariants (for the test suite)

Pin these as dataset regression tests. They are **DATA PINS for
the shipped mean-with-losses values in section 4, not truth
claims** (lesson from the transport data review): several orderings flip under
the median statistic or a boundary change, so every pin must be
re-derived at the next data pass rather than assumed to survive
it.

### Safe pins (margins for the shipped values)

1. `beef` is the dataset maximum (70.3608). **Re-derived for v2:**
   #2 is `coffee_instant` 62.3344537815126, so the margin is
   **+12.9%** -- dark chocolate 46.65 is now only #3, and lamb and
   goat (39.72, joint 4th) sit +77% below beef. The margin halved
   with D6 and narrowed again when v2 added instant coffee, a
   per-kg figure for a powder used 1.8 g at a time. Re-derive
   before adding any item above 60.
2. Meat chain: `beef > lamb > pork > chicken > tofu >
   potatoes` (70.36 > 39.72 > 12.31 > 9.87 > 3.16 > 0.46).
   Thinnest link pork > chicken at **+24.7%** -- annotate in the
   test that this link thins to +18% (fragile) under a median
   revintage.
3. *(retired 2026-08-01 with the dairy-herd item -- see D5.)*
4. `cheese > chicken` (23.88 > 9.87, +142%).
5. `max(soy_milk, oat_milk) * 2 < milk_dairy`
   (0.98 x 2 = 1.96 < 3.15, +61% margin) -- stronger than the
   plain ordering, safe under both statistics.
6. `rice >` every other staple (4.45). **Re-derived for v2, and
   again 2026-09-01 when the D7 oil correction moved the snacks:**
   the runner-up is now `instant_noodles` 3.437716962
   (`breakfast_cereal` 3.3322 behind it), so the margin is
   **+29.4%**, not the +142% the oats comparison gave in v1.
   Below them: `pasta` 2.290444 (D9), `oats` 1.84 (D3), `bread`
   1.57, `potatoes` 0.46.
7. `chicken >` every **as-purchased** staple, vegetable, fruit and
   plant protein (cheapest meat 9.87 vs the highest as-purchased
   row in those groups, `plant_based_meat` 4.5, +119%; rice 4.45
   is a dry-basis row and no longer binds this margin).
   **Restricted in v2:** dried and concentrated plant products
   legitimately clear chicken per kg once the water is gone --
   dried shiitake 18.62, tomato paste 11.14 -- so the pin skips any
   row whose `weight_basis` is not `as_purchased`. Comparing those
   against a fresh-weight meat per kg is the canned-vs-dry-beans
   error, not a broken ordering.
8. `beer < wine` per litre (1.2 < 1.79, +49%).
9. `prawns_farmed > fish_farmed` (26.87 > 13.63, +97%; medians
   11.8 > 5.1, +131% -- stable across statistics).
10. **Coffee per-cup guardrail** (pins the 100x-error protection,
    not an ordering): `coffee 10 g preset result < 0.5 kg CO2e`
    (actual 0.2853 kg).
11. **Tier-2 seafood ordering** (replaces the retired
    `fish_farmed > fish_wild > small_fish` pin): `crab_lobster
    19.444952 > tuna 7.6290536 > small_fish 3.8779404 > bivalves
    1.3991262 > seaweed 1.0867226`. All five are tier 2 and outside
    each other's tie groups, so this is a like-for-like claim within
    one source. `squid` (ties tuna) and `salmon` (ties white_fish)
    are deliberately excluded. `fish_wild` 9.5 no longer exists --
    D11 retired the assembled value; a test asserts its absence.
12. `tofu < plant_based_meat < chicken` (3.16 < 4.5 < 9.87;
    margins +42% / +119%).
13. `tea < coffee` per kg (9.0 < 28.53, +217%); **tea per-cup
    guardrail**: every tea preset result < 0.05 kg CO2e (actual
    18 / 27 g).
14. **Assembled- and decision-value pins** (RV-1 pattern):
    plant_based_meat 4.5, tea 9.0 and beans_canned 1.7 ship
    exactly, plus the v2 seafood set -- white_fish 5.1250386,
    tuna 7.6290536, small_fish 3.8779404, prawns_farmed 26.87 and
    prawns_wild 34.08. None is reachable by the ordering pins, so a
    silent revert to a narrower-boundary value (Gephart's bare
    farmed shrimp 9.43, the retired recipe's 9.5 / 5.5, Heller &
    Keoleian 3.4, Kenya tea 2.0, Tidaker 0.8) would otherwise pass
    the suite.
15. **`prawns_wild > prawns_farmed`** (34.08 > 26.87) and the
    ratio tracks Gephart's like-for-like wild/farmed (1.2682)
    within 1%. This is the one ordering in the dataset that most
    users will assume runs the other way, and the rejected
    additive construction (18.60) would have inverted it -- pin
    it, and pin the 34.08 assembled value with it. Beef stays the
    dataset maximum; **re-derived for v2, 34.08 lands 6th**, below
    instant coffee 62.33, dark chocolate 46.65 and lamb/goat 39.72,
    and above ground coffee 28.53. (The v1 note read "4th, above
    coffee, below lamb" -- true only before instant coffee and goat
    shipped.)
16. **Every item ships English search aliases** and no alias
    repeats its own item name in ANY of the three locales (the name
    already matches, and ahead of aliases). Umbrella items are
    unreachable in the picker without them -- nobody searches "Root
    vegetables". The v2 merge shipped 18 such repeats (duck, tuna,
    salmon, sugar, tofu, bread, both oils and others); they are
    stripped and the pin now checks JA and ES too.
17. **Tree nuts 0.43 and peanuts 3.23 both ship exactly, and
    peanuts > tree nuts.** Two P&N rows, neither reachable by any
    ordering pin above: peanuts shipped aliased onto the tree-nut
    row until 2026-08-08, 7.5x low. An alias guard in
    `food_items_data_test.dart` additionally asserts the tree-nut
    row answers to no peanut name in any of the three locales.
18. **Every row carries the v2 metadata keys, and `weight_basis` is
    one of five enum values** (`as_purchased`, `dry`, `drained`,
    `edible`, `concentrate`). Two defects this pin caught on the way
    in: the four v1 rows carried through the v2 merge arrived without
    the keys at all -- including the dry-basis beans/lentils and the
    drained-basis canned beans, whose whole point is the basis label
    -- and 19 rows carried free-text bases ("dry (roasted grounds)",
    "as_purchased (liquid, density 1.0 ...)") that no `switch` would
    ever match, so the UI would have shown nothing. Model defaults
    hide both failures, which is why the pin reads the JSON directly.
    Qualifiers stripped by the enum fix were appended to the item's
    user-facing notes rather than dropped.
19. **No imperial units in any serving-preset display name**
    (oz, cups, pints, tbsp, quarter-pound), in any of the three
    locales. Source-defined imperial survives only in
    `calculation_notes` provenance, never in display copy.
20. **Exactly five tie-group pairs are refusable** (added
    2026-08-29, with the tie-group gate): `tree_nuts`/`peanuts`,
    `tree_nuts`/`peanut_butter`, `olive_oil`/`palm_oil`,
    `mushrooms`/`dried_shiitake`, `pasta_sauce_tomato`/`salsa` --
    the same-group pairs whose values differ by 20% or more. The pin exists because the gate
    is only as good as the curation behind it: a group that
    re-acquires a same-source meaning starts silently refusing
    honest comparisons, which is the failure the four retirements
    below were fixing.

21. **Every derived row reproduces from its parent**, and every
    `composite_of` id resolves (added 2026-08-29). A row is either an
    exact single-parent derivation (`parent` x `mass_ratio`) or a
    recipe (`composite_of`), never half of each. The v2 spec promised
    this check and it was never written, so `parent` had drifted into
    four shapes -- an item id, a two-element list, a P&N category
    name, and two names joined by a comma -- and `peanut_butter`
    shipped a value its own ratio contradicted. Both are fixed and
    pinned.

22. *(the `composite_of` half of 21, numbered separately in the
    test file.)*

23. **`cream` ships 11.222704, above `milk_dairy` and below
    `butter`, and shares butter's tie group** (added 2026-08-29
    with the row). Invariant 21 only checks that the value agrees
    with its own `mass_ratio`, so reverting both together -- to a
    butter-derived ~5.4, or to Ferronato's 0.82 cheese-plant
    by-product figure -- passes the rest of the suite silently. The
    ordering is the sanity check the whole decision turned on:
    cream is 36% fat against butter's 80%, so it cannot sit above
    butter, and it concentrates milk, so it cannot sit at or below
    it. Since 2026-09-01 butter is derived on the same rule
    (21.574980) and the tie-group assertion stops the app ranking
    cream against butter across a ~2x gap that is derivation, not
    measurement (section 3.2).

### Tie groups mean one thing (curated 2026-08-29)

`tie_group` marks items that **share a derivation**, so a
difference between two of them is an artefact of how the number
was built rather than something measured. It does NOT mean "came
from the same database", and the two readings had been mixed.
Wiring the gate exposed it: 29 pairs were refused, 19 of them
wrongly. Four groups were retired to null:

| Retired group | Why it was not a tie |
|---|---|
| `agribalyse_31_drinks` | Provenance, not derivation. Grouped cocoa powder 29.1 with soft drink 0.493, a real 59x difference |
| `agribalyse_v32` | Same. Grouped sunflower seeds 2.91 with mango 0.728 |
| `owid_plant_milks` | The four plant milks are separately published OWID rows. `almond_milk`'s own notes say they "can be read against each other" |
| `pn_wheat_bread_cluster` | Four distinct P&N rows (maize, cassava, oats, wheat and rye), not one |

The four survivors that refuse a pair each have a stated reason:
rule 3 (the orchard land-use credit) for the nuts, rule 13 for the
oils, a weight-basis mismatch for fresh vs dried mushrooms on rule
17's canned-vs-dry logic, and shared recipe construction for the
two composites.

**`comparable` was deleted (2026-08-29).** It carried three
meanings at once -- tie-cluster member (~97 rows), copy-rule
exclusion (~10), and wide own-spread (~10) -- which is why nothing
could gate on it. Splitting it into three booleans was considered
and rejected: two of the three meanings already had a home, so the
answer was fewer fields, not more.

| Meaning it carried | Where it lives now |
|---|---|
| Tie-cluster member | `tie_group`, wired into the gate |
| Copy-rule exclusion | `tie_group` too -- every such case is pairwise |
| Wide own spread | Nowhere, deliberately. See below |

**A wide spread is disclosure, not a gate**, and that is the
distinction the old field blurred. `statistic_ratio` says "we do
not know which number is right for this product", which undermines
a ranking. `spread_low`/`spread_high` says "this product genuinely
varies and we ship the mean", which is what an average is -- every
row has it to some degree. Gating on it would demand a 97% gap for
any meal containing a tomato (0.37-12.62, field vs heated
greenhouse). All ten rows spreading 3x or wider already disclose
the range in their user-facing notes, which is the honest
treatment. The 48 `spread_*` pairs stay as science-sheet
provenance and no code reads them.

### The statistic-sensitivity rule (added 2026-08-08)

The never-pin list above is hand-maintained and cannot scale: at 166
items the pairwise space is ~13,700 pairs. The reversals it exists to
catch have a single generating cause, which **can** be computed --
**an item whose own published mean and median differ by 2x or more**
carries that ambiguity into every comparison it joins, and no delta
threshold clears it. Cheese and dark chocolate are 48.8% apart on
means and still swap places on medians.

Measured across the 35 live P&N products for which both statistics
are published (means from the live per-kg grapher, medians summed
from the archived endpoint in section 1, Beef (dairy herd) excluded
per D5):

The ratio ships as `statistic_ratio` on the item itself -- a
number, not a boolean flag -- and is absent on every other row.

| own mean/median ratio | item | shipped `statistic_ratio` |
|---|---|---|
| 2.67x | Fish (farmed) 13.63 / 5.1 | 2.6725 |
| 2.49x | Dark Chocolate 46.65 / 18.7 | 2.4947 |
| 2.15x | Nuts (tree) 0.43 / 0.2 | 2.15 |
| 1.73x | Coffee 28.53 / 16.5 | absent -- safe at >= 20% |

**The rule is a threshold, not a ban (refined 2026-08-08).** A first
pass blocked these items from verdicts outright; that was too blunt.
A ratio of R means the statistic choice can move the value by at most
R, so a gap that outruns R survives it: the better meal must emit less
than 1/R of the other. Chocolate needs a 59.9% reduction, farmed fish
62.6%, tree nuts 53.5%. This keeps the honest refusals and restores
the honest verdicts -- **per kg** a beef portion is only 1.51x dark
chocolate, but **per realistic serving** (114 g beef 8.02 kg vs 30 g
chocolate 1.40 kg) it is 6x, an 83% reduction that no statistic choice
reverses. Blocking that was wrong. Blocking cheese vs chocolate
(48.8%, under the 59.9% bar) is right.

**Verified claim, and it is the one the in-app methodology page
makes:** with those three excluded, **every** pair separated by 20%
or more on means keeps the same ordering under either statistic --
zero reversals. Without the exclusion there are two (cheese vs dark
chocolate 48.8%, farmed fish vs chicken 27.6%). The 20% threshold is
therefore sufficient *conditionally*, not absolutely, and the
condition is the flag. Pinned by
`food_statistic_threshold_test.dart`, which embeds both statistics
and re-derives the whole claim on every run, so a future data change
cannot quietly invalidate the copy.

Note this is a bound, not a proof of safety for items with no
published median: 46 of the 166 v2 items come from sources that
publish only one statistic, and for those the cross-tier 2x rule is
what protects the comparison instead.

### Never pin / never generate superlative copy

Orderings that flip between statistics, sit inside rounding, or
depend on boundary choices. Record these as comments in the test
file; the copy engine must not emit "X beats Y" for any of them
(>= 20%-delta rule, PDR section 5 rule 4):

- **palm vs olive** (shipped 7.955247 vs 5.941953 after D7; 7.32
  vs 5.42 on the pre-D7 per-litre stage sums) -- flips when LUC is
  excluded.
- **fish (farmed) vs pork** (13.63 vs 12.31, +10.7%) -- FLIPS
  under medians (5.1 < 7.2).
- **prawns vs cheese** (26.87 vs 23.88, +12.5%) -- FLIPS under
  medians (11.8 < **21.2**). Corrected 2026-08-08: this entry cited
  21.1, which is the Beef (dairy herd) median, not cheese's. Cheese's
  archived median is 21.2 (stage sum, re-derived from the endpoint in
  section 1). The conclusion is unaffected.
- **prawns_wild vs prawns_farmed** (34.08 vs 26.87, +27%) --
  the DIRECTION is robust (Gephart measures both at one boundary
  and puts wild above farmed) but the MAGNITUDE is not: the
  absolute value is bracketed 18.60-34.08 depending on which
  source's scale you anchor to. Copy may say wild prawns are not
  the greener choice; it must not quote the percentage gap.
- **coffee vs cheese / prawns** (28.53 vs 23.88 / 26.87) -- FLIPS
  under medians, and per-kg coffee copy is misleading anyway.
- **dark chocolate vs lamb / cheese** (46.65 vs 39.72 / 23.88) --
  FLIPS under medians (18.7 < 24.5 / 21.1).
- **milk chocolate vs dark chocolate** (19.35 vs 46.65 after the
  2026-08-29 re-derivation; was 14.9) -- added 2026-08-29. The
  ordering is real (less cocoa per kg) but the MAGNITUDE is a
  cross-source artefact: the two figures rest on sources that
  disagree by 2-3x on cocoa itself, the ingredient that dominates
  both, and P&N publish no cocoa row at all, so the dark side of the
  comparison depends on an assumed dark recipe P&N never state. The
  gate now blocks the pair at 58.52% against dark chocolate's 59.92%
  bar, **by 1.4 percentage points**. That margin is too thin to be
  the only protection: copy rule 18 (PDR section 5) is the durable one,
  and both numbers must be re-derived together if either moves.
- **oats vs tomatoes** (1.84 vs 2.09 after D3; tomatoes now
  higher by ~14%) -- the ordering already flipped once when D3
  landed; inherently unstable.
- **oats vs beans/lentils vs wine** -- the ~1.8 cluster created
  by D3 (1.84 / 1.79 / 1.79; deltas <= 2.8%).
- **berries vs bread** (1.53 vs 1.57, 2.6%) -- rounding tie. The
  `berries` umbrella retired into species rows that still carry
  1.53 (strawberries, blueberries, grapes); `pasta` left this
  cluster at D9 (2.290444).
- **eggs vs rice** (4.67 vs 4.45, 4.9%).
- **butter vs pork** -- retired 2026-09-01: butter moved to the
  milk-derived 21.574980, so the 2.6% near-tie with pork is gone
  (the gap is now real, but cross-derivation, so still not copy
  material).
- **soy milk vs oat milk** (0.98 vs 0.90, 8.5%) -- oat has the
  0.43-0.64 commercial-LCA drift.
- **soy milk vs peas** -- retired: D10 moved `peas` to the
  vegetable anchor 0.53, so the 0.98 exact tie is gone. `peas` now
  sits inside the 21-item `pn_other_vegetables` cluster instead.
- **milk vs tofu vs sugar** (3.15 / 3.16 / 2.922 cluster after the
  sugar D8 replaced `cane_sugar` 3.20; deltas <= 8.1%).
- **tree nuts vs root vegetables vs apples vs potatoes** (0.43 /
  0.43 / 0.43 / 0.46 cluster; the `root_vegetables` umbrella is now
  its species rows, `carrots` and siblings, on the same 0.43
  anchor) -- tree nuts additionally hinge on the orchard LUC credit
  (3.69 without it).
- **tree nuts vs peanuts** (0.43 vs 3.23) -- a 7.46x gap that is
  entirely an accounting choice: strip the orchard credit and the
  ordering INVERTS (tree nuts 3.69, +14.3% above peanuts). Never
  rank them, in either direction.
- **peanuts vs tofu vs milk vs sugar** (3.23 / 3.16 / 3.15 /
  2.922) -- peanuts join the ~3.2 cluster; deltas <= 10.5% once
  the sugar D8 moved that leg from 3.20 to 2.922.
- **brassicas vs onions & leeks vs potatoes vs root vegetables**
  (0.51 / 0.50 / 0.46 / 0.43) -- all display as ~0.5 after
  rounding. The three umbrella rows are now species rows on those
  same anchors (`cabbage`, `onions`, `carrots` and siblings), so
  the cluster grew rather than moved.
- **fish (farmed) vs chicken** (13.63 vs 9.87, 27.6%) -- **added
  2026-08-08.** FLIPS under medians (5.1 < 6.1). This is the pair that
  disproved the assumption that a 20% gap is self-securing: it clears
  20% comfortably and still reverses, because farmed fish's own
  mean/median ratio is 2.67x. Handled structurally rather than by
  listing -- `fish_farmed` ships `statistic_ratio: 2.6725` (there is
  no `statistic_sensitive` boolean in the dataset), and the gate
  derives a 62.6% bar from it, which this 27.6% gap cannot clear.
  (The former `fish_wild vs chicken` entry retires with the item; the
  Gephart observation it recorded -- their farm-gate chicken 8.335
  sits ABOVE their tuna 7.629 -- still holds and is why tier-2 rows
  are never ranked against tier-1 ones under 2x.)
- **plant_based_meat vs eggs** (4.5 vs 4.67, 3.8%) **and vs rice**
  (4.5 vs 4.45, 1.1%) -- statistical ties.
- **tea vs chicken** (9.0 vs 9.87, 8.8%) -- a per-kg dry-leaf tie,
  and per-kg tea copy misleads anyway (tea is consumed 2-3 g at a
  time; coffee rule applies). The `fish_wild` 9.50 leg retires with
  the item (seafood D11).
- **small_fish vs eggs** (3.8779404 vs 4.67, 17.0%, after the
  seafood D11 re-based it from 5.5) -- and vs plant_based_meat
  (3.8779404 vs 4.5, 13.8%): frame as one low-impact
  neighbourhood, never a ranked step. `small_fish` is tier 2, so
  both pairs face the cross-tier bar as well.
- **beans_canned vs beans_lentils** (1.7 drained vs 1.79 dry) --
  DIFFERENT BASES; comparing them per kg is meaningless and the
  numbers read as a 5% tie. Copy compares per serving or not at
  all.
