# Food Emission Factor Research

**Version:** 1.0
**Created:** 2026-07-18
**Status:** Assembled from the five research tracks and three
adversarial check reports (math, quotes, coherence). All corrections
from [PDR_FOOD_CALCULATOR.md](./PDR_FOOD_CALCULATOR.md) applied;
owner decisions D1-D3 (2026-07-18) applied. 37 items decided; open
items tracked in section 9.
**Feeds:** `data/app/food_items.json` (Phase 8.7, see
[PLAN_PHASE_8.md](./PLAN_PHASE_8.md) Part 2)

Reference document for the food carbon calculator dataset. Every
factor that ships in the app must trace back to an entry here with
source, quote, URL, access date, statistic (mean/median), and
losses basis. Follows the sourcing rules in
[AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) (sections 2 and 8).
This document is self-contained: the JSON build step reads only
this file.

Unit for every factor: **kg CO2e per kg of food as-purchased**
(raw / dry weight; liquids at density 1.0 so per-litre = per-kg).

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
  (verified across all 37 sums, section 10).
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

The two coherent value sets, stated precisely (per PDR FR-6 and
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
Rule (PDR QA-6): CarbonCloud values are corroboration with an
access date, never a digit-for-digit second verification. Every
CarbonCloud number in this document carries its full product URL
and a value-as-of date; values without recorded URLs were dropped
from the corpus as unverifiable (PDR/check_quotes F-6, F-7) and
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
  2026-07-18). Every factor is the OWID/P&N mean-with-losses
  value, live-quotable digit-for-digit. The Wayback-cited MEDIAN
  set (section 1) is the approved fallback if a mean is ever
  unavailable or retired; any fallback item must disclose its
  statistic in `calculation_notes` and the science sheet.
- **Per item, record statistic AND losses basis** (PDR FR-15).
  All 37 items below are mean-with-losses except where the
  chosen-values table says otherwise (butter, oats, beer,
  bread/pasta -- each with its derivation documented).
- **Weights are as-purchased raw / dry.** Cooking changes mass
  (rice 150 g raw -> ~330 g cooked, ~2.2x by weight); presets
  encode raw portions and the quantity editor must say so.
- **Liquids at density 1.0**: per-litre = per-kg (real densities
  0.99-1.04; error < 1.5%, disclosed).
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
  for display** (PDR FR-18 -- storing pre-rounded values produced
  two flattering roundings, pork -2.5% and brassicas -2.0%).
- Transport-is-small context (OWID FAQ, verbatim): "No, transport
  accounts for just 5% of greenhouse gas emissions from food."

---

## 3. Verified Factors

> "Verified" means: the factor is the OWID/P&N anchor value seen
> digit-for-digit on the live grapher CSV AND reproduced from the
> supply-chain stage sum (section 10), with at least one
> independent source corroborating magnitude/ordering. Exact
> LCA digits cannot match across different meta-analyses, so
> independent sources corroborate magnitude and ordering, never
> overwrite the anchor.

### 3.1 Meat & seafood (verified 2026-07-18)

| Item | kg CO2e/kg | Statistic | Confidence |
|------|-----------:|-----------|------------|
| Beef (beef herd) | 99.48 | mean w/ losses | High |
| Beef (dairy herd) | 33.30 | mean w/ losses | High |
| Lamb | 39.72 | mean w/ losses | High |
| Pork | 12.31 | mean w/ losses | High |
| Chicken | 9.87 | mean w/ losses | High |
| Prawns (farmed) | 26.87 | mean w/ losses | Medium-High |
| Fish (farmed) | 13.63 | mean w/ losses | Medium-High |

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

**Row-name mapping (PDR FR-17):** the supply-chain CSV names the
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
across all 37 items). The P&N farmed prawn/fish categories are
single coarse global averages with large spread -- Medium-High
confidence, spread caveat required on the science sheet (sec 8).

### 3.2 Dairy & eggs (verified 2026-07-18)

| Item | kg CO2e/kg | Statistic | Confidence |
|------|-----------:|-----------|------------|
| Cheese | 23.88 | mean w/ losses | High |
| Butter | 12.0 | non-P&N, 3-LCA mean | Medium |
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

Chosen: **12.0**. Recompute with the dropped candidate removed:
(12.2 + 10.18 + 11.89) / 3 = 34.27 / 3 = 11.42 -> rounds UP to
12.0 (honest-not-generous; rounding down would understate). The
original 4-candidate mean was 11.59 -> 12.0, so the chosen value
is unchanged by the QA-3 drop. Producer spread is wide and
allocation-driven (CarbonCloud country pages span ~11.4-19.6;
un-URLed, illustrative only). Sits sensibly between milk (3.15)
and cheese (23.88); butter (12.0) > chicken (9.87). Confidence
Medium -- no single authoritative global mean. Science sheet must
carry the "not in Poore & Nemecek" note (section 8).

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
| Tofu | 3.16 | mean w/ losses | High |
| Beans / lentils | 1.79 | mean w/ losses ("Other Pulses") | Medium |
| Peas | 0.98 | mean w/ losses | High |
| Nuts | 0.43 | mean w/ losses (incl. LUC credit) | Medium |

Anchor rows, verbatim: `Tofu,2010,3.16`,
`Other Pulses,2010,1.79`, `Peas,2010,0.98`, `Nuts,2010,0.43`.

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
- **Nuts nets a large orchard land-use-change carbon CREDIT.**
  Supply-chain row, verbatim:
  > "Nuts,2018,-3.257812,3.3744068,0,0.051419526,0.10673449,0.04263857,0.12374754,-0.007999532"
  Sum = 0.43314 -> 0.43. With LUC set to 0 the figure is ~3.69
  (~3.7). Ship 0.43 (consistent incl-LUC boundary) but the
  `calculation_notes` MUST disclose the credit; never publish a
  negative value; never emit "nuts are the lowest-impact protein"
  copy (section 8).
- Tofu corroboration (CarbonCloud, value-as-of 2026-07-18): 1.34
  (https://apps.carboncloud.com/climatehub/product-reports/id/224275434558)
  -- regional deforestation-free soy; corroborates the
  low-single-digit magnitude.

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
  (grain-factor note, section 8). Store the exact 1.57 for both
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
  data pass (section 9).
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

The 2.09 factor was never affected (OWID-anchored). The specific
numeric range "field 0.1-0.5 vs heated greenhouse 0.4-10.1
kg CO2e/kg" and the ">20x swing" phrasing remain **UNSOURCED**
and must not appear in app copy until a verifiable source lands
(open item, section 9). The real Payen, Basset-Mens & Perret
tomato paper is "LCA of local and imported tomato: an energy and
water trade-off", J. Cleaner Production 87:139-148 (2015) --
located but paywalled, no quotable text (section 9).

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
| Citrus | 0.39 | Citrus Fruit | Medium-High |
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
must say "includes grapes" (section 8). Citrus has no
verbatim-verified independent source (order-of-magnitude
corroboration only -- open item, section 9).

### 3.7 Drinks (verified 2026-07-18)

| Item | kg CO2e/kg (= /L) | Statistic / basis | Confidence |
|------|------------------:|-------------------|------------|
| Coffee (dry grounds) | 28.53 | mean w/ losses, per kg roasted | High (anchor); per-cup Medium |
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
  a time -- hard UI requirements in section 8. Independent LCA
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
  (P&N anchor, per-alcohol-unit basis; derivation in section 10).
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
- **Wine.** Manuscript-derived 1.75/L (section 10) vs grapher
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
the #3 bar in the dataset -- the sublabel requirement in section 8
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
the retail chain.) Olive oil's ~2.4 production-only figure is
directional only (paywalled -- open item, section 9).

---

## 4. Chosen Dataset Values

Final v1 table for `food_items.json`. **Store the exact values
below unrounded; the UI rounds for display** (PDR FR-18). Basis:
kg CO2e per kg as-purchased (liquids: per L = per kg at density
1.0). Statistic column records mean/median and losses basis per
item (PDR FR-15). Full quotes/URLs live in section 3; the JSON
carries per-item `sources[]` built from those.

| id | Item | kg CO2e/kg | Statistic / basis | Confidence |
|----|------|-----------:|-------------------|------------|
| beef_herd | Beef (beef herd) | 99.48 | P&N mean w/ losses | High |
| beef_dairy | Beef (dairy herd) | 33.30 | P&N mean w/ losses | High |
| lamb | Lamb | 39.72 | P&N mean w/ losses ("Lamb & Mutton") | High |
| pork | Pork | 12.31 | P&N mean w/ losses ("Pig Meat") | High |
| chicken | Chicken | 9.87 | P&N mean w/ losses ("Poultry Meat") | High |
| prawns_farmed | Prawns (farmed) | 26.87 | P&N mean w/ losses (supply CSV row "Shrimps (farmed)") | Medium-High |
| fish_farmed | Fish (farmed) | 13.63 | P&N mean w/ losses | High -> Medium-High (coarse category) |
| cheese | Cheese | 23.88 | P&N mean w/ losses | High |
| butter | Butter | 12.0 | non-P&N; mean of 3 independent dairy LCAs (11.42 -> 12.0 up) | Medium |
| eggs | Eggs | 4.67 | P&N mean w/ losses | High |
| milk_dairy | Milk (dairy) | 3.15 | P&N mean w/ losses; per L = per kg | High |
| tofu | Tofu | 3.16 | P&N mean w/ losses | High |
| beans_lentils | Beans / lentils | 1.79 | P&N mean w/ losses ("Other Pulses"); dry basis | Medium |
| peas | Peas | 0.98 | P&N mean w/ losses | High |
| nuts | Nuts | 0.43 | P&N mean w/ losses (incl. orchard LUC credit -3.26) | Medium |
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
| citrus | Citrus | 0.39 | P&N mean w/ losses ("Citrus Fruit") | Medium-High |
| berries | Berries | 1.53 | P&N mean w/ losses ("Berries & Grapes" blend) | Medium |
| dark_chocolate | Dark chocolate | 46.65 | P&N mean w/ losses (D1; median 18.7 = fallback provenance only) | Medium |
| cane_sugar | Cane sugar | 3.20 | P&N mean w/ losses | Medium-High |
| olive_oil | Olive oil | 5.42 | P&N mean w/ losses (supply-chain sum; net-negative LUC) | Medium |
| palm_oil | Palm oil | 7.32 | P&N mean w/ losses (supply-chain sum; LUC 38%) | Medium |
| coffee | Coffee (dry grounds) | 28.53 | P&N mean w/ losses, per kg roasted; per-cup preset is the entry path | High (anchor) / Medium (per cup) |
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

---

## 5. Serving Presets (sourced raw as-purchased weights)

Grams from FDA RACC (21 CFR 101.12 Table 2) or USDA FoodData
Central portion data unless noted; all accessed 2026-07-18. All
weights are raw / dry / as-purchased (liquids: ml = grams at
density 1.0). Every preset's arithmetic recomputed by the check
agent.

| Item | Preset | Grams | Source basis |
|------|--------|------:|--------------|
| Beef (both) | 1 quarter-pound patty | 113 | definitional 4 oz = 113.4 g |
| Beef (both) | 1 steak (medium) | 225 | ~8 oz culinary standard (226.8 g) |
| Lamb | 1 loin chop | 85 | ~3 oz raw chop (RACC neighbourhood) |
| Lamb | 1 serving | 110 | FDA RACC uncooked entree, quote below |
| Pork | 1 pork chop (boneless) | 140 | USDA FDC 167907 "200 calorie serving (139g)" |
| Chicken | 1 breast fillet | 170 | between USDA FDC 171077 half-piece (272/2 = 136 g) and a typical large retail fillet (~200 g); plan's 120/150 g undershoot |
| Chicken | 3 oz serving | 85 | USDA FDC 171077 "3 oz (85g)" |
| Prawns (farmed) | 1 portion | 110 | FDA RACC uncooked fish/shellfish |
| Prawns (farmed) | small portion | 85 | USDA/FDA 3 oz serving equivalent |
| Fish (farmed) | 1 fillet | 110 | FDA RACC uncooked |
| Fish (farmed) | 1 salmon fillet (large) | 198 | USDA FDC 175167 "1/2 fillet (198g)" |
| Cheese | 1 slice | 22 | typical pre-sliced cheddar slice |
| Cheese | 1 portion (1 oz) | 30 | FDA RACC "Cheese, all others" 30 g |
| Butter | 1 tbsp | 14 | RACC gives volume (1 tbsp / 15 mL); density 0.911 x 15 = 13.665 g; USDA lists 14.2 g -- derived, Medium confidence, derivation stays in calculation_notes |
| Butter | 1 pat | 5 | standard restaurant pat (USDA ~5 g) |
| Eggs | 1 large egg | 50 | FDA RACC "Eggs (all sizes) 50 g", label "1 large" |
| Milk | 1 glass | 200 | common 200 ml glass |
| Milk | 1 cup | 240 | FDA RACC "Milk ... 240 mL" |
| Tofu | 1 serving (3 oz) | 85 | FDA RACC "Tofu, tempeh 85 g" |
| Tofu | 1/2 block | 175 | half a typical ~350 g retail block |
| Beans/lentils | 1 serving (dry) | 35 | FDA RACC "35 g dry" -- physically consistent with the dry-basis factor |
| Beans/lentils | 1/2 can (drained) | 130 | FDA RACC "130 g ... canned in liquid" (canned factor = open item) |
| Peas | 1 serving | 85 | FDA RACC vegetables "85 g fresh or frozen" |
| Nuts | 1 handful (1 oz) | 30 | FDA RACC "Nuts, seeds ... 30 g" |
| Rice | 1 rice-cooker cup (dry) | 150 | Just One Cookbook, quote below (JP primary market) |
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
| Root vegetables | 1 cup chopped | 128 | USDA carrot "1 cup chopped (128g)" |
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
| Berries | 1 cup strawberries | 144 | USDA FDC 167762 "1 cup, whole = 144.0 g" |
| Berries | 1 medium strawberry | 12 | USDA FDC 167762 "1 medium = 12.0 g" |
| Dark chocolate | 1 oz / small bar | 28 | USDA FDC 170273 "1 oz = 28.35 g" |
| Dark chocolate | 1 square | 12.6 | derived: FDC 170273 "1 bar = 101.0 g" / 8 = 12.625 g (FR-16: earlier draft wrote 12 g, flattering -5%) |
| Cane sugar | 1 tsp | 4.2 | USDA FDC 169655 "1 tsp = 4.2 g" |
| Cane sugar | 1 cube | 2.3 | USDA FDC 169655 "1 serving 1 cube = 2.3 g" |
| Olive oil | 1 tbsp | 13.5 | USDA FDC 171413 "1 tablespoon = 13.5 g" |
| Olive oil | 1 tsp | 4.5 | USDA FDC 171413 "1 tsp = 4.5 g" |
| Palm oil | 1 tbsp | 13.6 | USDA FDC 171015 "1 tbsp = 13.6 g" -- direct FDC portion (QA-8; replaces the earlier density derivation) |
| Coffee | 1 cup (grounds) | 10 | SCA Golden Cup ratio, quote below; standard-mug midpoint (filter ~7-11 g, espresso ~18 g, P&N unit 15 g) |
| Beer | 1 can (EU) | 330 | Wikipedia Drink can, quotes below |
| Beer | 1 can (JP / US) | 350 / 355 | JP most common 350 ml; US 12 oz = 355 ml |
| Beer | 1 pint (US) | 473 | US pint (UK pint = 568 ml -- note if targeting UK) |
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
  (section 8).
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

---

## 6. Sanity Invariants (for the test suite)

Pin these as dataset regression tests. They are **DATA PINS for
the shipped mean-with-losses values in section 4, not truth
claims** (transport PDR-5 lesson): several orderings flip under
the median statistic or a boundary change, so every pin must be
re-derived at the next data pass rather than assumed to survive
it.

### Safe pins (margins for the shipped values)

1. `beef_herd` is the dataset maximum (99.48; margin vs #2
   chocolate 46.65 = +113%, vs lamb +150%).
2. Meat chain: `beef_herd > lamb > pork > chicken > tofu >
   potatoes` (99.48 > 39.72 > 12.31 > 9.87 > 3.16 > 0.46).
   Thinnest link pork > chicken at **+24.7%** -- annotate in the
   test that this link thins to +18% (fragile) under a median
   revintage.
3. **Herd-ratio band, never a strict "> 3x":**
   `2.5 < beef_herd / beef_dairy < 3.5` (actual 2.99). The plan's
   original "beef-herd > 3x dairy-herd" is FALSE under both
   statistics (2.99 mean / 2.86 median) -- a knife-edge failure
   by 0.4% if pinned as written.
4. `cheese > chicken` (23.88 > 9.87, +142%).
5. `max(soy_milk, oat_milk) * 2 < milk_dairy`
   (0.98 x 2 = 1.96 < 3.15, +61% margin) -- stronger than the
   plain ordering, safe under both statistics.
6. `rice >` every other staple (4.45 vs oats 1.84, **+142%** --
   margin improved from +79% by decision D3; bread/pasta 1.57,
   potatoes 0.46).
7. `chicken >` every staple, vegetable, fruit, and plant protein
   (cheapest meat 9.87 vs rice 4.45, +122%).
8. `beer < wine` per litre (1.2 < 1.79, +49%).
9. `prawns_farmed > fish_farmed` (26.87 > 13.63, +97%; medians
   11.8 > 5.1, +131% -- stable across statistics).
10. **Coffee per-cup guardrail** (pins the 100x-error protection,
    not an ordering): `coffee 10 g preset result < 0.5 kg CO2e`
    (actual 0.2853 kg).

### Never pin / never generate superlative copy

Orderings that flip between statistics, sit inside rounding, or
depend on boundary choices. Record these as comments in the test
file; the copy engine must not emit "X beats Y" for any of them
(>= 20%-delta rule, section 8):

- **palm vs olive** (7.32 vs 5.42) -- flips when LUC is excluded.
- **fish (farmed) vs pork** (13.63 vs 12.31, +10.7%) -- FLIPS
  under medians (5.1 < 7.2).
- **prawns vs cheese** (26.87 vs 23.88, +12.5%) -- FLIPS under
  medians (11.8 < 21.1).
- **coffee vs cheese / prawns** (28.53 vs 23.88 / 26.87) -- FLIPS
  under medians, and per-kg coffee copy is misleading anyway.
- **dark chocolate vs lamb / cheese** (46.65 vs 39.72 / 23.88) --
  FLIPS under medians (18.7 < 24.5 / 21.1).
- **oats vs tomatoes** (1.84 vs 2.09 after D3; tomatoes now
  higher by ~14%) -- the ordering already flipped once when D3
  landed; inherently unstable.
- **oats vs beans/lentils vs wine** -- the ~1.8 cluster created
  by D3 (1.84 / 1.79 / 1.79; deltas <= 2.8%).
- **berries vs bread/pasta** (1.53 vs 1.57, 2.6%) -- rounding tie.
- **eggs vs rice** (4.67 vs 4.45, 4.9%).
- **butter vs pork** (12.0 vs 12.31, 2.6%) -- and butter is the
  one non-P&N assembled value.
- **soy milk vs oat milk** (0.98 vs 0.90, 8.5%) -- oat has the
  0.43-0.64 commercial-LCA drift.
- **soy milk vs peas** (0.98 vs 0.98) -- exact tie.
- **milk vs tofu vs cane sugar** (3.15 / 3.16 / 3.20 cluster).
- **nuts vs root veg vs apples vs potatoes** (0.43 / 0.43 / 0.43 /
  0.46 cluster) -- nuts additionally hinges on the orchard LUC
  credit (~3.7 without it).
- **brassicas vs onions & leeks vs potatoes vs root veg** (0.51 /
  0.50 / 0.46 / 0.43) -- all display as ~0.5 after rounding.

---

## 7. Action-Data Consistency (`co2_actions_database.json`)

Consequences of decision D1 (means) for the existing actions --
corrections land in the SAME PR as the dataset (never two numbers
for one swap in the app):

| Action | Shipped | Means-implied | Verdict |
|--------|--------:|---------------|---------|
| `meatless_meal_beef` (per 100 g) | 6000 g | 9948 - 200 = 9748 -> **~9700 g** | NEEDS CORRECTION (shipped is 39% low; it encodes the median 60) |
| `meatless_meal_chicken` (per 100 g) | 600 g | 987 - 100 = 887 -> **~890 g** | NEEDS CORRECTION (current 6.9 kg/kg is a PMC-range midpoint matching neither statistic) |
| `meatless_meal_pork` (per 100 g) | 700 g | 1231 - 100 = 1131 -> **~1100 g** | NEEDS CORRECTION (current 7.6 kg/kg matches neither statistic) |
| `plant_milk_vs_dairy` (per 250 ml) | 460 g | delta (3.15 - 0.903) x 0.25 = 562 g | NO co2_grams change -- 460 g stays honestly conservative. Align the note's "3.2 kg/L" to **3.15** so the app never shows two dairy-milk numbers |

Additional required fixes while correcting:

- **Standardize the plant-alternative baselines.** The beef
  action's note assumes ~200 g CO2e per 100 g plant alternative;
  chicken/pork assume ~100 g. Those are themselves inconsistent
  (beans/lentils 1.79 kg/kg implies ~180 g; peas 0.98 implies
  ~100 g). Pick one documented baseline (per swap ingredient) and
  apply it to all three actions.
- **Swap the beef action's stale quote.** Its current 60 kg/kg
  rests on OWID article prose that is legacy median text inside a
  page whose embedded chart serves 99.48; under means the action's
  `sources[].quote` must move to the mean citation (section 3.1).
- The action notes must record statistic + losses basis, matching
  this document's convention (FR-15).

---

## 8. UI / Copy Requirements (for the implementation PR)

Carried from the coherence audit; all thirteen are requirements,
not suggestions:

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
3. **Nuts credit note** on the science sheet (orchard LUC credit;
   ~3.7 without it); suppress "lowest footprint" copy; never
   display negative values.
4. **Comparative-copy rule**: "X emits less than Y" sentences only
   when the delta >= 20%; below that, present bars without a
   verdict. (Protects every never-pin cluster in section 6.)
5. **Beer vs wine copy names the serving, not the liquid**: per
   litre wine > beer, but per serving a 330 ml can (0.40 kg) > a
   150 ml glass (0.27 kg).
6. **Rice raw-weight helper in the quantity editor** (not only the
   methodology page): "We count the dry weight you buy -- a
   rice-cooker cup is 150 g raw, ~330 g once cooked; enter the
   raw amount." This is a silent 2.2x error path.
7. **Bread/pasta grain note**: "grain factor (Wheat & Rye);
   baking/drying energy not counted".
8. **Prawns spread caveat** on the science sheet ("single global
   farmed-prawn category, large spread"); never pin or copy the
   prawns-vs-cheese ordering.
9. **Butter non-P&N note**: "not in Poore & Nemecek; mean of
   independent dairy LCAs (10.2-12.2)".
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

Also required by section 7: `meatless_meal_*` and the dataset must
ship in the same PR, and the beans/lentils item must never carry
the OWID peas quote.

---

## 9. Open Items

Resolved this pass: statistic decision (D1, means dataset-wide);
oats conflict (D3 average 1.84); beer basis (D2, 1.2); the
tomato-spread citation replaced with a live-verified Theurl et al.
2014 quote (QA-1); palm-oil tbsp weight closed with the direct
FDC 171015 quote (QA-8); PMC11743834 meat ranges re-verified
verbatim on the live page (QA-8); butter's un-URLed 12.1
candidate dropped with the factor unchanged (QA-3); all quote
hygiene fixes QA-2/4/5/7 applied in sections 3 and 5.

Remaining:

- [ ] **Citrus independent corroboration** is order-of-magnitude
      only: the Oregon DEQ citrus PEF report 404s and the
      Springer/IOP Valencia studies are paywalled. OWID 0.39 is
      fully anchored; confidence stays Medium-High until an
      independent page is quotable.
- [ ] **Olive-oil production-only corroboration** (~2.4 kg/kg) is
      directional only (ScienceDirect paywalled). OWID 5.42 is
      anchored; the production-only comparison in the methodology
      note should avoid exact digits until a quotable source
      lands.
- [ ] **Tomato field-vs-heated-greenhouse numeric range**
      ("0.1-0.5 vs 0.4-10.1", ">20x swing") is UNSOURCED -- the
      original citation was fabricated (wrong paper, quotes
      unfindable). The verified Theurl and Naked Scientists quotes
      (section 3.5) support only the qualitative "heated
      greenhouses dominate" point and a "two times lower"
      comparison. Any methodology copy stating a numeric spread
      for tomatoes is blocked until the real Payen 2015 paper
      (J. Cleaner Production 87:139-148, paywalled) or another
      tier-1 source is quotable.
- [ ] **Oats live input re-read**: D3's CarbonCloud input (1.20,
      2026-07-18) drifts; re-read at the next data pass and
      recompute the average.
- [ ] **Canned beans/lentils**: the 1.79 factor is dry-basis; the
      half-can preset is physically inconsistent with it. A
      separate canned factor is a schema follow-up.
- [ ] **Median fallback provenance**: if any item ever falls back
      to the median set, cite the archived grapher endpoint
      (section 1) and disclose statistic + losses basis in
      calculation_notes and the science sheet.
- [ ] **CarbonCloud rows without recorded URLs** (assorted cheese
      variants, chickpeas, potato starch/chips, NL tomato, red
      cabbage, dry onion, oats-UK farm benchmark) were dropped
      from this document as unverifiable; do not resurrect them
      into `sources[]` without full product URLs and fresh
      values.
- [ ] **Butter tbsp gram weight** (14 g) is density-derived (RACC
      gives volume only); replace with a direct FDC quote if one
      is located.

---

## 10. FOOD_LOGIC_CHECK

Arithmetic and provenance chain per chosen value. All OWID sums
recomputed independently by the check agent from freshly
downloaded CSVs (byte-identical to the research-phase copies;
152 automated checks). Access date 2026-07-18 throughout.

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
2. **Beef (dairy herd) = 33.30.** CSV literal "33.3"; sum
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
    1.84 = 74 g CO2e. Medium.
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
27. **Citrus = 0.39.** CSV "Citrus Fruit"; sum 0.3877 (LUC
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
    archived endpoint (section 1). Per oz: 46.65 x 0.02835 =
    1.32 kg CO2e; per 12.6 g square: 0.59 kg. Medium.
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

Cross-checks on the action corrections (section 7): beef
9948 - 200 = 9748; chicken 987 - 100 = 887; pork 1231 - 100 =
1131; milk delta (3.15 - 0.903) x 0.25 = 0.5618 kg (562 g),
shipped 460 g conservative; soy variant (3.15 - 0.98) x 0.25 =
543 g, still conservative.

Serving-preset sanity (grams x factor, spot values): beef patty
11.24 kg; steak 22.38 kg; chicken fillet (170 g) 1.68 kg; pork
chop 1.72 kg; prawn portion 2.96 kg; salmon fillet 2.70 kg;
egg 234 g; cheese portion 716 g; rice cup 668 g; banana 101 g;
chocolate oz 1.32 kg; coffee cup 285 g; beer can 396 g; wine
glass 269 g. All recomputed and consistent with the factors
above.
