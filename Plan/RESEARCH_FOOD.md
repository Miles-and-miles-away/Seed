# Food Emission Factor Research

**Version:** 1.0
**Created:** 2026-07-18
**Status:** Assembled from the five research tracks and three
adversarial check reports (math, quotes, coherence). All corrections
from the 2026-07-18 adversarial data review applied;
owner decisions D1-D3 (2026-07-18) applied. 42 items decided (37 at
the first pass; fish (wild-caught), plant-based meat and tea added
2026-07-19 closing the review product calls; small oily fish and
canned beans added 2026-07-20 closing the follow-up open items);
open items tracked in section 9.
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
  2026-07-18). Every factor is the OWID/P&N mean-with-losses
  value, live-quotable digit-for-digit. The Wayback-cited MEDIAN
  set (section 1) is the approved fallback if a mean is ever
  unavailable or retired; any fallback item must disclose its
  statistic in `calculation_notes` and the science sheet.
- **Per item, record statistic AND losses basis** (data-review rule).
  All 42 items below are mean-with-losses except where the
  chosen-values table says otherwise (butter, oats, beer,
  bread/pasta, and the 2026-07 additions fish (wild-caught),
  plant-based meat, tea, small oily fish and canned beans -- each
  with its derivation documented).
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
  for display** (data-review rule -- storing pre-rounded values produced
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
| Fish (wild-caught) | 9.50 | non-P&N, assembled (added 2026-07-19) | Medium |
| Small oily fish (sardines, mackerel) | 5.5 | non-P&N, assembled (added 2026-07-20) | Medium-High |

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
sheet (sec 8).

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
| Plant-based meat | 4.5 | non-P&N, assembled (added 2026-07-19) | Medium-High (raised 2026-07-20) |
| Tofu | 3.16 | mean w/ losses | High |
| Beans / lentils | 1.79 | mean w/ losses ("Other Pulses"); dry basis | Medium |
| Beans (canned) | 1.7 | non-P&N, assembled; DRAINED basis (added 2026-07-20) | Medium |
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
uplift (section 8).

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
this dataset's rules: independent mean (2.35 + 2.40 + 2.72 + 3.90
+ 3.81 + 2.38) / 6 = 3.26 cradle-to-gate, x 1.3 boundary uplift =
4.24 -> rounds up to the shipped 4.5. KEY REVISION: the
commissioned anchors (3.4 / 3.5) sit mid-range of the independent
values, so the "commissioner-low bias" premise behind the uplift
is retired -- the 1.3x is justified on boundary grounds alone
(gate -> retail + supply-chain losses). Smetana et al. 2015 is
independent but cradle-to-plate per cooked meal (no per-kg
numbers, unusable); "Bryant 2022 = 2.4" re-checked 2026-07-20 and
still unverifiable on any live page -- still not used.

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
Tidaker per-stage snippets ("packaging 0.14 / processing 0.02",
"0.97 steel tin chickpeas") appeared only in search snippets,
were never fetched verbatim, and are NOT used.

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
must say "includes grapes" (section 8). Citrus corroboration
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
| Tea (dry leaves) | 9.0 | non-P&N, assembled (added 2026-07-19) | Medium |
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
UI rule: preset-only entry, per-kg sublabel (section 8).
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

Final v1 table for `food_items.json`. **Store the exact values
below unrounded; the UI rounds for display** (data-review rule). Basis:
kg CO2e per kg as-purchased (liquids: per L = per kg at density
1.0). Statistic column records mean/median and losses basis per
item (data-review rule). Full quotes/URLs live in section 3; the JSON
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
| fish_wild | Fish (wild-caught) | 9.50 | non-P&N; Gephart 2021 wild fisheries completed with P&N post-farmgate stages; mean of wild-mix 9.05 and canned-tuna 9.53, rounded up (added 2026-07-19) | Medium |
| small_fish | Small oily fish (sardines, mackerel) | 5.5 | non-P&N; Gephart herring/sardines row completed as fish_wild; mean of fresh 5.17 and canned 5.78, rounded up (added 2026-07-20) | Medium-High |
| cheese | Cheese | 23.88 | P&N mean w/ losses | High |
| butter | Butter | 12.0 | non-P&N; mean of 3 independent dairy LCAs (11.42 -> 12.0 up) | Medium |
| eggs | Eggs | 4.67 | P&N mean w/ losses | High |
| milk_dairy | Milk (dairy) | 3.15 | P&N mean w/ losses; per L = per kg | High |
| tofu | Tofu | 3.16 | P&N mean w/ losses | High |
| beans_lentils | Beans / lentils | 1.79 | P&N mean w/ losses ("Other Pulses"); dry basis | Medium |
| peas | Peas | 0.98 | P&N mean w/ losses | High |
| nuts | Nuts | 0.43 | P&N mean w/ losses (incl. orchard LUC credit -3.26) | Medium |
| plant_based_meat | Plant-based meat | 4.5 | non-P&N; mean of Beyond 3.4 and Impossible 3.5 LCAs x ~1.3 boundary uplift, rounded up (added 2026-07-19; independent ifeu corroboration 2026-07-20 reproduces ~4.5) | Medium-High (raised 2026-07-20) |
| beans_canned | Beans (canned) | 1.7 | non-P&N; DRAINED basis; mean of CarbonCloud/USDA-FBG 1.62 and P&N bottom-up 1.71, rounded up (added 2026-07-20) | Medium |
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
| olive_oil | Olive oil | 5.42 | P&N mean w/ losses (supply-chain sum; net-negative LUC) | Medium |
| palm_oil | Palm oil | 7.32 | P&N mean w/ losses (supply-chain sum; LUC 38%) | Medium |
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
| Fish (wild-caught) | 1 small tuna can | 70 | Hagoromo Sea Chicken L Flake net content 70 g (JP standard can), quote below |
| Fish (wild-caught) | 1 fillet | 110 | FDA RACC uncooked fish (canned-fish RACC is 85 g; USDA FDC 171986 lists 3 oz = 85 g, 1 can = 165 g as US alternates) |
| Small oily fish | 1 mackerel can (drained) | 140 | Sokensha さば水煮 "190g（固形量140g）", quote below (closed 2026-07-20; replaces the net-weight interim) |
| Small oily fish | 1 sardine can (drained) | 92 | USDA FDC 175139 "1 can (3.75 oz) = 92 g" drained solids; FDA canned-fish RACC 85 g is the US-serving alternate |
| Small oily fish | 1 sardine (edible portion) | 32 | Slism "マイワシ 1尾 80gの可食部 32g"; MEXT food composition DB まいわし/生 refuse rate 60% corroborates (closed 2026-07-20) |
| Cheese | 1 slice | 22 | typical pre-sliced cheddar slice |
| Cheese | 1 portion (1 oz) | 30 | FDA RACC "Cheese, all others" 30 g |
| Butter | 1 tbsp | 14.2 | USDA FDC 173410 direct portion, quote below (closed 2026-07-19; replaces the earlier density derivation) |
| Butter | 1 pat | 5 | standard restaurant pat (USDA ~5 g) |
| Eggs | 1 large egg | 50 | FDA RACC "Eggs (all sizes) 50 g", label "1 large" |
| Milk | 1 glass | 200 | common 200 ml glass |
| Milk | 1 cup | 240 | FDA RACC "Milk ... 240 mL" |
| Tofu | 1 serving (3 oz) | 85 | FDA RACC "Tofu, tempeh 85 g" |
| Tofu | 1/2 block | 175 | half a typical ~350 g retail block |
| Beans/lentils | 1 serving (dry) | 35 | FDA RACC "35 g dry" -- physically consistent with the dry-basis factor |
| Beans (canned) | 1 serving (drained) | 130 | FDA RACC "130 g ... canned in liquid" (drained-basis item added 2026-07-20; the old half-can preset on the dry item is retired) |
| Beans (canned) | 1/2 can (drained) | 150 | USDA Food Buying Guide "1 No. 300 can = about 10.5 oz (1-3/8 cups) heated, drained beans" -> 298 g/can, half rounded up |
| Beans (canned) | 1 can (drained) | 300 | same USDA FBG yield, 298 g rounded up |
| Peas | 1 serving | 85 | FDA RACC vegetables "85 g fresh or frozen" |
| Nuts | 1 handful (1 oz) | 30 | FDA RACC "Nuts, seeds ... 30 g" |
| Plant-based meat | 1 quarter-pound patty | 113 | definitional 4 oz = 113.4 g; matches the beef patty preset so the burger swap is like for like; the flagship LCAs use the same functional unit ("¼ pound Beyond Burger") |
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
| Tea | 1 tea bag | 2 | most common bag weight + ISO 3103's 2 g per 100 ml, quotes below |
| Tea | 1 cup, loose leaf | 3 | ITO EN sencha/gyokuro guidance (2-3 g per serving), quote below; conservative upper of the JP range |
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
11. `fish_farmed > fish_wild > small_fish` (13.63 > 9.50 > 5.5;
    +43% / +73%) -- direction source-supported (wild fisheries
    carry no feed or LUC stages; small pelagics are the most
    fuel-efficient fisheries).
12. `tofu < plant_based_meat < chicken` (3.16 < 4.5 < 9.87;
    margins +42% / +119%).
13. `tea < coffee` per kg (9.0 < 28.53, +217%); **tea per-cup
    guardrail**: every tea preset result < 0.05 kg CO2e (actual
    18 / 27 g).
14. **Assembled-value pins** (RV-1 pattern): fish_wild 9.5,
    plant_based_meat 4.5, tea 9.0, small_fish 5.5 and
    beans_canned 1.7 ship exactly -- none is reachable by the
    ordering pins above, so a silent revert to a
    narrower-boundary source value (Gephart 7.63 or 3.88, Heller
    & Keoleian 3.4, Kenya tea 2.0, Tidaker 0.8) would otherwise
    pass the suite.

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
- **fish_wild vs chicken** (9.50 vs 9.87, 3.9%) -- and the sources
  disagree at this resolution (Gephart's farm-gate chicken 8.335
  sits ABOVE their tuna 7.629).
- **plant_based_meat vs eggs** (4.5 vs 4.67, 3.8%) **and vs rice**
  (4.5 vs 4.45, 1.1%) -- statistical ties.
- **tea vs chicken / fish_wild** (9.0 vs 9.87 / 9.50, <10%) --
  per-kg dry-leaf ties, and per-kg tea copy misleads anyway (tea
  is consumed 2-3 g at a time; coffee rule applies).
- **small_fish vs eggs** (5.5 vs 4.67, 17.8%) -- and vs
  plant_based_meat (5.5 vs 4.5, 22%, adjacent): frame as one
  low-impact neighbourhood, never a ranked step.
- **beans_canned vs beans_lentils** (1.7 drained vs 1.79 dry) --
  DIFFERENT BASES; comparing them per kg is meaningless and the
  numbers read as a 5% tie. Copy compares per serving or not at
  all.

---

## 7. Action-Data Consistency (`co2_actions_database.json`)

Consequences of decision D1 (means) for the existing actions --
corrections land in the SAME PR as the dataset (never two numbers
for one swap in the app):

| Action | Shipped | Means-implied | Verdict |
|--------|--------:|---------------|---------|
| `meatless_meal_beef` (per 100 g) | 6000 g | 9948 - 200 = 9748 -> **9700 g** | CORRECTED (the old value encoded the median 60) |
| `meatless_meal_chicken` (per 100 g) | 600 g | 987 - 200 = 787 -> **780 g** (standardized beans baseline 2026-07-20; the D1 pass briefly shipped 880 g against a 100 g peas baseline) | CORRECTED |
| `meatless_meal_pork` (per 100 g) | 700 g | 1231 - 200 = 1031 -> **1000 g** (standardized beans baseline 2026-07-20; the D1 pass briefly shipped 1100 g) | CORRECTED |
| `plant_milk_vs_dairy` (per 250 ml) | 460 g | delta (3.15 - 0.903) x 0.25 = 562 g | NO co2_grams change -- 460 g stays honestly conservative; note aligned to 3.15 |

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
14. **Tea inherits the coffee rule** (added 2026-07-19):
    preset-only entry, per-kg sublabel ("per kg of dry leaves --
    one tea bag uses ~2 g (~18 g CO2e)"), excluded from
    auto-generated "worst item" copy. The methodology sheet states
    prominently that home boiling is excluded and that published
    per-cup tea figures are mostly kettle energy.
15. **Plant-based meat disclosure** (added 2026-07-19): science
    sheet states the category breadth (soy mince to formulated
    patties), that the underlying LCAs are company-commissioned
    with narrower boundaries, and that the value was uplifted and
    rounded up to compensate; never rank it against eggs or rice
    (ties).
16. **Wild fish notes** (added 2026-07-19, updated 2026-07-20):
    item copy says "includes canned tuna"; science sheet points
    sardines/mackerel/saury to the dedicated Small oily fish item
    and keeps the flatfish caveat; never compare wild fish vs
    chicken (tie).
17. **Small fish / canned beans copy rules** (added 2026-07-20):
    small oily fish sits in the same low-impact neighbourhood as
    eggs and plant-based meat -- no ranked-step copy; fish
    presets are drained / edible weights and the quantity editor
    says so (whole-fish grams typed raw would overstate ~2.5x).
    Canned vs dry beans are different weight bases -- the
    quantity editor says "drained weight" on the canned item and
    "dry weight" on the dry item, and no per-kg comparison copy
    is generated between them.

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
2026-07-19; D3 average still 1.84, section 10).

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

Also resolved 2026-07-20 (same-day follow-up): **JP saba-can
drained weight** -- Sokensha publishes the standard can as
"190g（固形量140g）"; the mackerel-can preset now uses the 140 g
drained weight (section 5). **Whole-iwashi preset** -- shipped at
the 32 g edible portion (Slism "1尾 80gの可食部 32g", corroborated
by the MEXT refuse rate 60%); edible basis matches the factor,
whole weight would overstate 2.5x.

Open:

- [ ] **Tidaker et al. 2021 full text** (new 2026-07-20):
      ScienceDirect blocks automated fetch (re-attempted
      2026-07-20 via Unpaywall, CORE and the SLU research portal
      -- all blocked or missing); the per-stage
      packaging/processing split and the steel-tin chickpea
      figure exist only as unverified snippets. If the full text
      becomes readable, consider refining beans_canned's
      candidate table with it.
- [ ] **skip_medium_impact_food vs the new fish items** (new
      2026-07-20, owner points-economy call): the live library
      action (1000 g, "chicken, pork, or fish") now overstates a
      wild-fish skipper (~750 g implied) and a small-oily-fish
      skipper (~350 g). Options: lower to the chicken floor
      (780), split fish out, or accept the mid-band value.
      Flagged in the seeder comment.

---

## 10. FOOD_LOGIC_CHECK

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
