# Home Energy Emission Factor Research

**Version:** 1.0 (all owner decisions E1-E6 applied)
**Created:** 2026-08-02
**Status:** Assembled from five parallel research tracks, then
revised after a browser pass closed five of the seven
fetch-blocked tier-1 sources (Ember, IEA, EPA WaterSense, LBNL
standby, 資源エネルギー庁). The METI pass replaced the two
weakest climate entries with measured government figures and
closed the worst open item (9.7). 33 behaviors. **E1 resolved
2026-08-02 after a three-way adversarial review: the house grid
factor moves 386 -> 458 g CO2e/kWh (Ember GER 2026), and grid
regionalisation is spun out to
[PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md).**
No blockers remain; this document is cleared to build JSON from.
**Feeds:** `data/app/energy_behaviors.json` (Phase 8.13, see
[PLAN_PHASE_8.md](./PLAN_PHASE_8.md) Part 3)

Reference document for the home energy carbon calculator dataset.
Every factor that ships in the app must trace back to an entry
here with source, quote, URL, access date, and vintage. Follows
the sourcing rules in
[AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) (sections 2 and 8)
and [RESEARCH_STRATEGY.md](./RESEARCH_STRATEGY.md).

Unit for every factor: **kWh per stated unit** (`use`, `minute`,
`hour`, `day`), multiplied at runtime by a carrier factor. Access
date for every source below: **2026-08-02**.

---

## 1. Source Landscape (verified 2026-08-02)

### Primary: UK DEFRA/DESNZ GHG Conversion Factors

Same primary as the transport dataset. Both the 2025 and 2026
flat-format spreadsheets were downloaded and parsed directly (the
values are not rendered as page text anywhere on gov.uk):

- 2025: `ghg-conversion-factors-2025-flat-format.xlsx`,
  "Updated: 2025-06-10", Version 1.
  https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2025
- 2026: `ghg-conversion-factors-2026-flat-format-revised.xlsx`,
  "Updated: 2026-07-10", Version 1.2, "Next publication date:
  June 2027".
  https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2026

Natural gas rows extracted (kg CO2e/kWh):

| Vintage | Basis | Combustion (Scope 1) | WTT (Scope 3) | Total |
|---------|-------|---------------------:|--------------:|------:|
| 2025 | Gross CV | 0.18296 | 0.03021 | 0.21317 |
| 2025 | Net CV | 0.20270 | 0.03347 | 0.23617 |
| 2026 | Gross CV | 0.18231 | 0.03021 | 0.21252 |
| 2026 | Net CV | 0.20199 | 0.03347 | 0.23546 |

Two independent aggregator pages reproduce these digits exactly
(corroboration tier): https://carbonpass.co/guides/defra-emission-factors-2025-uk
("Natural gas (Scope 1, Gross CV): '0.18296' kgCO2e per kWh") and
https://carbonpass.co/guides/defra-emission-factors-2026-uk
("0.18231 kg CO2e/kWh (GCV basis)").

**Independent JP cross-check of the gas factor (new, 2026-08-02).**
資源エネルギー庁 publishes 都市ガス (13A) at
**2.244 kgCO2/m3** with a 45 MJ/m3 heat content (= 12.5 kWh/m3),
implying **179.5 g CO2/kWh**. DEFRA's 182.31 and METI's 179.5 sit
**1.4% apart** despite entirely separate methodologies. The gas
carrier factor is the best-corroborated number in the dataset.

Unlike electricity, the gas factor is essentially flat across
releases (0.18316 -> 0.18296 -> 0.18231 over three years): gas
composition does not change year to year. This is the single
biggest maintenance advantage of Part 3 over Part 1.

UK grid electricity from the same files, for scale: 0.17700
(2025) -> **0.13096** (2026) kg CO2e/kWh, a real ~26% drop in one
release. That number matters far more than it looks -- see 2.1.

### The grid factor problem (feeds decision E1)

The app shipped a house global-average grid factor of **386 g
CO2/kWh**, live in `data/app/transport_modes.json` and throughout
`co2_actions_database.json`. **Decision E1 (2026-08-02) replaces
it with Ember's 458 g CO2e/kWh.** All figures below were
**read on the live page in a browser on 2026-08-02** (they
previously refused automated fetch):

| Source | Year | Value | Basis |
|--------|------|------:|-------|
| Ember, *Global Electricity Review 2026* | 2025 | **458** g CO2e/kWh | CO2e |
| **IEA, *Electricity 2026*** | **2025** | **435 g CO2/kWh** | CO2 only |
| IEA, same page, forecast | 2030 | 360 g CO2/kWh | CO2 only |
| IEA, *Electricity 2025* (superseded) | 2024 | 445 g CO2/kWh | CO2 only |
| 資源エネルギー庁 (JP, official 代替値) | 令和6年提出用 | 429 g CO2/kWh | JP grid |
| 資源エネルギー庁 (JP, older 代替値) | 令和2年提出用 | 488 g CO2/kWh | JP grid |
| Japan, 61 major utilities (via Argus) | FY2024-25 | 416 g CO2/kWh | utility self-report |

Ember, verbatim: "The emissions intensity of electricity has
dropped 14% over the last decade, from 533 grams of CO2
equivalent per kWh (gCO2e/kWh) in 2015 to 458 gCO2e/kWh in 2025."
https://ember-energy.org/latest-insights/global-electricity-review-2026/electricity-demand-and-supply-trends/

IEA *Electricity 2026*, verbatim (read live 2026-08-02; this
report supersedes *Electricity 2025*, which the first pass cited):

> "We forecast CO2 intensity to fall even faster over our forecast
> period, at an annual average rate of 3.7%, down from 435 g
> CO2/kWh in 2025 to 360 g CO2/kWh in 2030."

https://www.iea.org/reports/electricity-2026/emissions

The same page gives a **free regional table for 2025** -- EU 170,
China 530, India 695, Southeast Asia 640, world 435 g CO2/kWh --
which materially lowers the cost of the regionalisation work
spun out to
[PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md).

資源エネルギー庁 calculation-basis page, verbatim:
"◎電気 0.488kgCO2/kWh [電気事業者別排出係数令和2年提出用「代替値」]
　※照明・テレビのみ 0.429kgCO2/kWh
[電気事業者別排出係数令和6年提出用「代替値」]"
https://www.enecho.meti.go.jp/category/saving_and_new/saving/general/howto/index.html#konkyo

**Do not average IEA and Ember.** They are different statistics:
IEA 435 is CO2-only, Ember 458 is CO2e (includes CH4 and N2O).
Averaging them produces a figure that is neither -- the same
defect D1 corrected in the food dataset. Because both now report
**2025 data**, the 23 g gap between them is cleanly attributable
to scope: **CO2e adds 5.3% over CO2-only.** Averaging is
correct only for independent estimates of the *same quantity on
the same basis* (the D3 oats / butter / tea precedent). **The
app is denominated in CO2e throughout, so the scope-correct
single anchor is Ember 458**, which is also the freshest vintage.

**Separate finding, needs fixing either way:**
[AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) §8 documents 386 as
"midpoint of US 370g and UK 210g, biased toward global average".
That midpoint is **290**. The house factor's stated derivation
does not reproduce the house factor. Whatever E1 decides, that
line is wrong and should be corrected or removed.

### Japan government sources (primary market)

資源エネルギー庁's 省エネポータルサイト turned out to be the single
most valuable source in this research once it was reachable in a
browser. It publishes per-behavior annual savings sourced to
**一般財団法人省エネルギーセンターの実測値** (measured values from
the Energy Conservation Center), with an explicit calculation
basis including season lengths. Verbatim:

> "※掲載データは、一般財団法人省エネルギーセンターの実測値を使用
> しています。"

> "暖房期間 5.5か月（10月28日〜4月14日）169日
> 冷房期間 3.6か月（6月2日〜9月21日）112日
> 中間期84日"

https://www.enecho.meti.go.jp/category/saving_and_new/saving/general/howto/index.html#konkyo

Those season lengths convert METI's annual savings into
**measured per-hour appliance consumption** -- which is exactly
what open item 9.7 said nobody published. Sections 3.3 and 3.5
now use METI measurements instead of manufacturer rated values
for the two entries where the two disagree most.

Other JP sources:

- 環境省 COOL CHOICE setpoint pages:
  https://ondankataisaku.env.go.jp/coolchoice/setsuden/home/saving03.html
- 環境省 GHG reference table PDF (kerosene):
  https://www.env.go.jp/earth/ondanka/gel/ghg-guideline/search/pdf/sankou.pdf
- 一般財団法人 家電製品協会 「ジャー炊飯器」 guide, sourced to
  省エネルギーセンター実測値:
  https://seihinjyoho.go.jp/frontguide/pdf/guide_rice_cooker_2022.pdf?update=22113
- 東京都水道局:
  https://www.waterworks.metro.tokyo.lg.jp/kurashi/shiyou/jouzu
- TOTO CSR shower page:
  https://jp.toto.com/company/csr/csractivity/usefulinformation/use_shower/
- Panasonic / Mitsubishi / Tiger manufacturer spec pages (per
  entry in section 3)

### Manufacturer consumption tables (tier-1 for appliances)

- Bosch WNA14400GR washer-dryer, 9 kg, **EN50229** (current):
  https://media3.bosch-home.com/Documents/9001533128_A.pdf
- Bosch 9 kg washer, **EN60456** ("valid until 1st March 2021"):
  https://media3.bosch-home.com/Documents/9001553321_B.pdf
- Bosch WQG24509GB heat-pump dryer, 9 kg:
  https://media3.bosch-home.com/Documents/specsheet/en-GB/WQG24509GB.pdf
- Bosch WTM8327SZA condenser dryer, 8 kg:
  https://media3.bosch-home.com/Documents/specsheet/en-ZA/WTM8327SZA.pdf
- Bosch SMS67MW00G dishwasher, 14 place settings:
  https://media3.bosch-home.com/Documents/specsheet/en-GB/SMS67MW00G.pdf

**Trap found and documented (feeds UI rule 7):** the same 9 kg
Bosch drum publishes THREE different "60 C" numbers -- 1.700 kWh
(user-selected Cottons 60 C, EN50229), 1.450 kWh (same programme,
older EN60456) and 0.900 kWh ("Cottons colour 60 C", the EU-label
programme). Bosch discloses why, verbatim: "The actual washing
temperature may differ from the stated programme temperature for
energy-saving reasons." A label-optimised "60 C" cycle does not
reach 60 C. Section 10 confirms this by physics.

### Aggregator discipline

Aggregator and blog pages are **corroboration with an access
date**, never a second verification, and every one carries its
URL. Values seen only in a search-engine summary are labelled
**SEARCH-ONLY** and may not enter `sources[]` until re-fetched.
The browser pass on 2026-08-02 cleared Ember, IEA, EPA
WaterSense, LBNL standby and 資源エネルギー庁 off that list;
section 9.1 tracks what remains.

---

## 2. Scope Decision

Factors represent **operational energy only**, identical in
boundary to the transport dataset (Part 1) and deliberately
DIFFERENT from the food dataset (Part 2, cradle-to-retail
lifecycle):

- Electricity entries: grid generation emissions for the energy
  the appliance draws.
- Gas entries: direct combustion of the gas burned.
- **Excluded everywhere:** appliance manufacturing, installation,
  water supply and treatment energy, building fabric, refrigerant
  leakage, and well-to-tank fuel supply.

Conventions:

- **Carrier factors live in dataset metadata once.**
  `grid_factor_g_per_kwh` is shared with `transport_modes.json`
  and pinned by a cross-dataset test. `gas_factor_g_per_kwh` is
  new.
- **Gas is combustion-only, Gross CV** (decision E2). Adding
  DEFRA's WTT term would put gas on a lifecycle boundary while
  electricity and transport stay operational -- gas would look
  ~17% worse purely from a boundary mismatch. The exclusion is a
  documented simplification (~14-16% understatement of gas's
  supply-chain footprint), not an oversight.
- **Gross CV, not Net CV.** Domestic gas bills are issued on a
  Gross CV basis; the Net CV factor against Gross CV consumption
  overstates by ~11%.
- **Water heating ships electric and gas as separate entries**,
  per the Part 3 plan, plus a heat-pump electric variant (E3).
- **Measured beats rated.** Where a government measured figure
  and a manufacturer rated figure disagree, the measured one
  ships and the rated one becomes context. This decides both
  aircon entries (3.3).
- **Physics-derived entries state every input.** Water heating
  uses c = 4.186 kJ/(kg-K), 1 L = 1 kg, so **0.001162777 kWh per
  litre per kelvin**. Cold inlet 10 C, delivered hot water 40 C,
  so **delta-T = 30 K** and **0.03488333 kWh/L** throughout 3.1.
  Neither temperature is tier-1 sourced (open item 9.3).
- **Average what changed with technology; keep regional variation
  as presets.** Showerheads modernised under flow regulation, so
  the shipped flow rate averages current products (E4). Bath
  volume is regional, not generational, so 180 L (JP) ships with
  the 150 L European case as a preset.
- **Nameplate is never the shipped value for a cycling
  appliance.** Kotatsu, electric blankets, ovens and inverter air
  conditioners all draw far less than their rating on average.
- **Dataset JSON stores exact unrounded values; the UI rounds for
  display.**
- **The methodology sheet must warn against summing across the
  three calculators.**

### 2.1 The electric-vs-gas crossover (binding on copy)

Gas burns **more energy** than resistance electric for the same
hot water (85% boiler efficiency vs ~100%) but emits **less
carbon**, because gas is 182 g/kWh against the grid's 458.
Efficiency and carbon intensity pull opposite ways and carbon
intensity wins -- **at today's global grid factor**.

The crossover is a grid factor of **214 g CO2/kWh**. Below that,
resistance electric beats gas. Applied to the shipped shower
entry (0.273652 kWh/min electric, 0.321944 kWh/min gas), across
candidate grids:

| Grid | Electric | Gas | Winner |
|------|---------:|----:|--------|
| UK, DEFRA 2026 (131) | 35.8 g/min | 58.6 | **electric, 1.6x** |
| **House factor (458, E1)** | **125.3** | **58.6** | **gas, 2.1x** |
| IEA 2030 forecast (360) | 98.5 | 58.6 | gas |
| JP 資源エネルギー庁 (429) | 117.4 | 58.6 | gas, 2.0x |
| Ember global 2025 (458) | 125.3 | 58.6 | gas, 2.1x (shipped) |

**The UK has already crossed over.** A gas shower in Britain is
now the higher-carbon option; in Japan it is half the carbon of
electric. Same two appliances, opposite answers, decided entirely
by grid.

Three consequences, all binding:

1. Cross-carrier comparisons must never auto-generate a verdict
   (enforced structurally by 2.2), because the verdict is a fact
   about the user's country, not their behavior.
2. This is the strongest argument for regional grid factors (the
   Part 3 plan's own open question) -- a single global factor
   gets the UK answer backwards.
3. The methodology paragraph must NOT say "gas looks better today
   and will flip eventually". It must say **the flip has already
   happened in some markets**, and state the 214 g/kWh crossover
   so a reader can check their own grid.

### 2.2 Comparison gating (decision E2)

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
heating fails #1; laptop vs incandescent fails #1; oven vs space
heater fails #1. All covered.

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

## 3. Verified Factors

> "Verified" means the number was read on a live page or in a
> downloaded primary file, quoted digit-for-digit, with at least
> one independent source corroborating magnitude. Derived entries
> additionally show reproducible arithmetic.

### 3.1 Hot water (verified 2026-08-02)

Constant: **0.03488333 kWh per litre** (1 kg x 4.186 kJ/kg-K x
30 K / 3600).

| Item | kWh/unit | Unit | Carrier | Confidence |
|------|---------:|------|---------|------------|
| Shower (electric, resistance) | 0.273652 | minute | electricity | Medium |
| Shower (electric, heat pump) | 0.063640 | minute | electricity | Medium |
| Shower (gas) | 0.321944 | minute | gas | Medium |
| Bath (electric) | 6.279000 | use | electricity | Medium-High |
| Bath (gas) | 7.387059 | use | gas | Medium |
| Washing up by hand (electric) | 2.197650 | use | electricity | Medium |
| Washing up by hand (gas) | 2.585471 | use | gas | Medium |

**Flow rate (decision E4): average of current products only.**
The 1990s-vintage 10 L/min head is excluded; the three
live-quotable modern figures are averaged:

| Head | L/min | Source |
|------|------:|--------|
| TOTO Comfort Wave (current JP product) | 6.5 | TOTO CSR |
| EPA WaterSense label cap, 2.0 gpm | 7.570824 | EPA (live) |
| US federal standard, 2.5 gpm | 9.463529 | EPA (live) |
| **Mean (shipped)** | **7.844784** | -- |

EPA WaterSense, verbatim (read live 2026-08-02; the page gives
gpm only, so the litre figures above are our own conversion at
1 US gal = 3.785411784 L):

> "Did you know that standard showerheads use 2.5 gallons of
> water per minute (gpm)? Water-saving showerheads that earn the
> WaterSense label must demonstrate that they use no more than
> 2.0 gpm."

https://www.epa.gov/watersense/showerheads

TOTO CSR page, verbatim:

> "1990年代に発売されたシャワーを1分間使った場合、約10Lのお湯を使用しています"
> (a head sold in the 1990s uses about 10 L per minute)

> "現在、TOTOが販売しているコンフォートウェーブシャワーの水量は1分間に6.5Ｌです"
> (TOTO's currently sold Comfort Wave head uses 6.5 L per minute)

Derivation: 7.844784 x 0.03488333 = **0.273652 kWh/min**
thermal. Resistance (efficiency 1.0) ships that value directly;
gas / 0.85 = **0.321944**; heat pump / 4.3 = **0.063640**.

**Electric water heating ships as two entries (decision E3), not
an average.** Resistance and heat pump are two appliances, not
two measurements of one, and weighting them needs installed-base
data nobody publishes. Unlike the beef-herd split that food
decision D5 rejected, this is a question users can answer -- an
Eco Cute owner knows they own one, because it is a branded
product. Heat-pump COP, Heat Pump & Thermal Storage Technology
Center of Japan, verbatim: "COP = 3.5 of the initial model" and
"Eco Cute has improved its efficiency to COP = 5.1 in the recent
model"; shipped COP is the mean, **4.3**.
https://www.hptcj.or.jp/e/learning/tabid/370/Default.aspx

Same carrier, same group, 4.3x delta -- so the E2 rule *permits*
the heat-pump verdict, which is the largest single lever in the
dataset. An averaged single entry would have said nothing.

**Not shipped, documented:** the self-contained electric shower
unit (UK-common) is power-capped at 7.5-10.5 kW, which physically
restricts flow to ~4-4.5 L/min at delta-T 30, giving ~0.15-0.17
kWh/min. It is a third hardware class; the science sheet names
it.

**Gas efficiency 0.85 is an ASSUMPTION, not a quote.** SEDBUK
seasonal efficiencies of 87.3-87.4% appear in a DEFRA in-situ
monitoring PDF that would not extract as text. Combi boilers run
measurably worse in domestic-hot-water mode than in space-heating
mode (DHW draw-off needs ~70 C flow temperatures that prevent
full condensing), so 92-98% nameplate figures do not apply. Open
item 9.2.

**Bath volume.** 東京都水道局, verbatim:

> "残り湯は、使用状態によって異なりますが、一般家庭では、約180
> リットルの量があります"
> (leftover bathwater varies with use, but in an ordinary
> household it amounts to about 180 litres)

Ships at **180 L** (JP unit bath, best-sourced, primary market).
European sources converge on 120-150 L (corroboration only); EPA
WaterSense archive's "a bath takes up to 70 gallons" (265 L) is a
rim-full tub, not a fill. 180 x 0.03488333 = **6.279 kWh**
electric; / 0.85 = **7.387059** gas. The 150 L European case is a
preset (0.83 units), not a second entry.

**Washing up by hand.** Ships on the **Which? 2026 basis: 63 L
for a 14-place-setting load**, chosen because the same article
measures the dishwasher on the identical load, making the two
entries like-for-like. Which? UK, page-dated 03 Jul 2026,
verbatim:

> "using a dishwasher for 14 place settings consumes just under
> 13 litres compared to approximately 63 litres when washing by
> hand"

https://www.which.co.uk/news/article/which-research-reveals-how-little-water-dishwashers-use-compared-to-hand-washing-aUDng9Y2iK8E

63 x 0.03488333 = **2.19765 kWh** electric; / 0.85 =
**2.585471 kWh** gas.

Spread must be disclosed. Stamminger / University of Bonn (13
place settings, 100+ European participants), via Choice AU,
verbatim: "Washing the same load by hand uses about 100 litres of
water on average, according to a study by the University of Bonn
in Germany" and "the researchers found actual usage ranged from
33 to a staggering 440 litres!" That is a **13x spread across
real households** -- technique (bowl vs running tap) dominates
everything else in this entry.

### 3.2 Laundry and dishes (verified 2026-08-02)

| Item | kWh/unit | Unit | Carrier | Confidence |
|------|---------:|------|---------|------------|
| Washing machine, cold (20 C) | 0.350 | use | electricity | High |
| Washing machine, warm (40 C) | 1.300 | use | electricity | High |
| Washing machine, hot (60 C) | 1.700 | use | electricity | High (provenance) / Medium (representativeness) |
| Tumble dryer, vented/condenser | 4.5 | use | electricity | High |
| Tumble dryer, heat pump | 2.05 | use | electricity | High |
| Line dry | 0 | use | none | High |
| Dishwasher, eco programme | 0.85 | use | electricity | High |
| Dishwasher, normal programme | 1.12 | use | electricity | High |

**Three wash temperatures, one machine, one standard, one
document (decision E6).** Bosch WNA14400GR, 9 kg, EN50229,
verbatim table rows:

> "Βαμβακερά (Cottons) 20 °C | 9,0 | 0,350 | 89,0 | 3:02"
> "Βαμβακερά (Cottons) 40 °C | 9,0 | 1,300 | 89,0 | 3:48"
> "Βαμβακερά (Cottons) 60 °C | 9,0 | 1,700 | 89,0 | 3:03"
> "Eco 40-60 ** | 9,0 | 1,120 | 58,0 | 3:45"
> "** EU energy label performance tests according to the valid
> version of EN50229 and Directive 96/60/EC for washing with max.
> load, cold water (15°C)"

The plan's "30 C" entry is retired: no current manufacturer
publishes a full-load 30 C cottons figure (30 C appears only on
2 kg delicates programmes), and the 0.40 kWh figure circulating
for it traces to a 2006 Öko-Institut 5 kg study reached only via
a secondary citation. A "20-30 C" range label was rejected as
well -- it would be a 20 C measurement wearing a 30 C name, and
20 -> 40 is too non-linear to interpolate (the 20 C programme
barely heats). Shipping the three verbatim temperatures preserves
the low/warm/high framing with nothing invented.

Spread for the science sheet: the same drum on the older EN60456
standard gives 0.370 / 1.450; its EU-label "Cottons colour 60 C"
programme gives 0.900; an independent single-machine measurement
gives 1.12 kWh at 60 C
(https://www.bentasker.co.uk/posts/blog/house-stuff/how-much-more-energy-efficient-is-eco-mode-on-a-washing-machine.html).
**A "60 C" wash is 0.90-1.70 kWh depending on which 60 C the
machine means.**

**Tumble dryers -- the 2.2x split is the point.** Verbatim:

> "Energy consumption electric dryer, full load - NEW
> (2010/30/EC): 2.05 kWh" (Bosch WQG24509GB, heat pump, 9 kg)

> "Energy consumption of the standard cotton programme at full
> load 4.63 kWh and energy consumption of the standard cotton
> programme at half load 2.61 kWh" (Bosch WTM8327SZA, condenser,
> 8 kg)

Condenser ships at **4.5**, rounded down from the verified 4.63
because that is one energy-class-B model and independent
aggregator figures with a stated 7 kg basis give 3.5-4.5. Heat
pump ships at the verified **2.05** exactly.

**Line dry = 0, with a caveat that must ship.** Indoor winter
drying assisted by a dehumidifier (typically 300-700 W) is not
free and can add 1-4 kWh.

**Dishwasher.** Bosch SMS67MW00G, verbatim:

> "Energy Consumption for 100 cycles Eco Programme: 85 kWh"
> "Maximum number of place settings: 14"
> "The water consumption of the eco programme in liters per
> cycle: 9.5 l"
> "Programme duration: 3:15 h"

-> 0.85 kWh/cycle eco. Which? 2026 on the main wash: "around
1.12kWh of energy per wash, which costs roughly 29.2p". Both on a
14-place-setting basis. Eco is ~24% lower and takes 3h15 -- a real
behavior choice, so both ship.

### 3.3 Climate (verified 2026-08-02, revised to measured values)

| Item | kWh/unit | Unit | Carrier | Confidence |
|------|---------:|------|---------|------------|
| Air conditioner, cooling (28 C) | 0.167679 | hour | electricity | High |
| Air conditioner, heating (20 C) | 0.241006 | hour | electricity | High |
| Electric space heater | 1.2 | hour | electricity | Medium |
| Kotatsu | 0.15 | hour | electricity | **Low** |
| Electric blanket | 0.025 | hour | electricity | Medium |

**Air conditioner: measured, not rated (this replaces the
first-pass values and closes open item 9.7).** 資源エネルギー庁
publishes annual savings from shortening runtime by one hour a
day, sourced to 省エネルギーセンター実測値, together with the
season lengths needed to convert them. Verbatim:

> "冷房を1日1時間短縮した場合（設定温度：28℃）年間で電気18.78kWhの省エネ"
> (shortening cooling by 1 hour/day at a 28 C setpoint saves
> 18.78 kWh a year)

> "暖房を1日1時間短縮した場合（設定温度：20℃）年間で電気40.73kWhの省エネ"
> (shortening heating by 1 hour/day at a 20 C setpoint saves
> 40.73 kWh a year)

https://www.enecho.meti.go.jp/category/saving_and_new/saving/general/howto/airconditioning/index.html

With 冷房期間 112 days and 暖房期間 169 days from the
calculation-basis page:

- cooling: 18.78 / 112 = **0.167679 kWh/h**
- heating: 40.73 / 169 = **0.241006 kWh/h**

These are **2.6x and 1.9x LOWER** than the Panasonic CS-227VB JIS
rated figures the first pass used (定格消費電力 435 W cooling /
455 W heating,
https://panasonic.jp/aircon/housing/p-db/CS-227VBS_spec.html).
The rated values are measured at fixed JIS C 9612 conditions with
the unit working at capacity; the METI values are seasonal
measured averages of a real operating hour, which is what the app
actually asks. **Measured ships; rated becomes science-sheet
context.** Mitsubishi Electric states the catalog caveat
verbatim: "実際には地域、気象条件、ご使用条件等により電力量が変わります".

**Setpoint effect.** METI publishes absolute deltas from the same
measurement basis, which the presets use directly rather than
percentages (avoiding a rounding discrepancy -- see below):

> "外気温度31℃の時、エアコン（2.2kW）の冷房設定温度を27℃から1℃
> 上げた場合（使用時間：9時間／日）年間で電気30.24kWhの省エネ"

> "外気温度6℃の時、エアコン（2.2kW）の暖房設定温度を21℃から20℃に
> した場合（使用時間：9時間／日）年間で電気53.08kWhの省エネ"

- cooling: 30.24 / (112 x 9) = **0.030000 kWh/h per 1 C**
- heating: 53.08 / (169 x 9) = **0.034898 kWh/h per 1 C**

**Discrepancy worth recording:** METI's own arithmetic implies
**15.2%** per 1 C cooling and **12.6%** heating, while 環境省
COOL CHOICE states the rule of thumb as "約13%" and "約10%"
(https://ondankataisaku.env.go.jp/coolchoice/setsuden/home/saving03.html).
Same government, different rounding and baseline. The dataset
uses METI's absolute deltas so the presets are internally
consistent with the shipped per-hour values; the science sheet
quotes 環境省's 13%/10% as the public rule of thumb and notes it
is a rounded approximation.

**Electric space heater.** Office of Congressional Workplace
Rights (.gov), verbatim: "Average electric space heaters range
from 400-1,500 watts."
https://www.ocwr.gov/publications/fast-facts/portable-space-heaters/
JP ceramic fan heaters run 600-1,200 W in three steps. Ships at
**1.2 kWh/h** (JP high setting); the US nameplate standard is
1,500 W because a 120 V / 15 A circuit caps it there. Basis:
nameplate on high, with thermostatic cycling reducing the true
average once the room is warm.

**Kotatsu -- the weakest number in the dataset.**

| Value | Basis | Source |
|-------|-------|--------|
| 300-600 W | "主なこたつの消費電力" (typical rating) | SoftBank でんき, https://www.softbank.jp/energy/saving/kotatsu/ |
| quartz 80-145 W, halogen 70-180 W, flat carbon 50-110 W | low-to-high setting, by heater type | https://enechange.jp/articles/kotatsu-cost |
| "実際の平均消費電力は表示より2〜3割低い" | average vs rating | unlabelled aggregator, **not re-verifiable** |

SoftBank でんき verbatim: "主なこたつの消費電力は300W～600W程度です。"

**Ships at 0.15 kWh/h** -- a mid setting on the enechange
per-heater-type ranges, rounded up. Shipping the 300-600 W rating
would overstate real use by 3-5x and destroy the comparison the
entry exists for. Confidence LOW. Resulting space-heater-to-
kotatsu ratio is **8x, not the 10x the Part 3 plan assumed**.

**Electric blanket.** Nameplate: Panasonic DB-R31M "定格75W".
Per-setting measured figures (Yamazen single size, via enechange
-- already duty-cycle-averaged, because blanket "settings" ARE
duty cycling), verbatim: "強（約53度）約35Wh、適温（約33度）約22Wh、
弱（約21度）約13Wh". https://enechange.jp/articles/cost-electric-blanket
Ships at **0.025 kWh/h**, the 適温 22 Wh/h rounded up.

**The JP heating hierarchy (methodology context, one source).**
METI publishes gas and kerosene fan heaters on the identical
1-hour-per-day basis, so all four heating options are directly
comparable and every figure reproduces METI's own stated CO2:

| Option | Per hour | g CO2/h (our factors) | METI's own |
|--------|----------|----------------------:|-----------:|
| Aircon (heat pump), 20 C | 0.241006 kWh | **110** | -- |
| Gas fan heater | 0.075030 m3 + 0.022012 kWh | 181 | 179 |
| Kerosene fan heater | 0.094142 L + 0.023018 kWh | 245 | 246 |
| Electric resistance heater | 1.2 kWh | 550 | -- |

(METI: "年間でガス12.68m3の省エネ ... 年間で電気3.72kWhの省エネ
... CO2削減量30.3kg" and "年間で灯油15.91Lの省エネ ... 年間で電気
3.89kWhの省エネ ... CO2削減量41.5kg", both over 169 days.)

**A heat-pump air conditioner is 5.0x lower carbon than a
resistance heater, 1.6x lower than gas and 2.2x lower than
kerosene.** That is the flagship heating lesson and it is now
fully sourced from one government page. It also resolves the
kerosene framing worry: kerosene beats resistance electric
(243 vs 463) but loses badly to the heat pump, so the comparison
must always show all four.

**Kerosene is researched but NOT shipped (decision E5).**
環境省 gives 灯油 CO2排出係数 **2.50 t-CO2/kL**
(https://www.env.go.jp/earth/ondanka/gel/ghg-guideline/search/pdf/sankou.pdf);
資源エネルギー庁 gives 2.489 kgCO2/L. The data is now strong
enough to ship whenever wanted.

**Refrigerator -- context line only, never a picker item.** You
cannot fridge less. JP: 280-400 kWh/year for a modern 400-500 L
class (memorva.jp compiling manufacturer catalog data,
corroboration tier) = ~0.85-0.96 kWh/day. Western: ~400-500
kWh/year (SEARCH-ONLY, open item 9.6).

### 3.4 Cooking (verified 2026-08-02)

| Item | kWh/unit | Unit | Carrier | Confidence |
|------|---------:|------|---------|------------|
| Kettle, boil 1 L | 0.116278 | use | electricity | Medium-High |
| IH hob, boil 1 L | 0.116598 | use | electricity | Medium-High |
| Gas hob, boil 1 L | 0.282389 | use | gas | Medium |
| Oven | 1.0 | hour | electricity | **Low-Medium** |
| Microwave | 0.019 | minute | electricity | Medium |
| Rice cooker, cook cycle | 0.16 | use | electricity | High |
| Rice cooker, keep warm (保温) | 0.0165 | hour | electricity | High |

**Physics floor, boiling 1 L from 15 C:** 1.000 kg x 4.186
kJ/(kg-K) x 85 K = 355.81 kJ / 3600 = **0.09883611 kWh**. Every
boil entry is this floor divided by a sourced efficiency.

Specific heat cross-checked against NIST-JANAF Shomate
coefficients for liquid water (A = -203.6060, B = 1523.290,
C = -3196.413, D = 2474.455, E = 3.855326, valid "298. to 500."
K), https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&Type=JANAFL --
extrapolated to 288 K gives 4.194 kJ/(kg-K), within 0.2%.

**Kettle, efficiency 0.85.** Murray, Liao, Stankovic &
Stankovic (Strathclyde), EEDAL 2015, verbatim:

> "Heating efficiency of the element itself is 100% as the energy
> supplied is completely converted to heat. However, most kettles
> are around 80-90% efficient (efficiency is decreased due to
> heat dissipation and transference to the body of the kettle)."

https://strathprints.strath.ac.uk/55059/1/Murray_etal_EEDAL2015_How_make_efficient_use_kettles_understanding_usage_patterns.pdf
Metered cross-check, same paper: 1.50 L from 18 C consumed
0.17 kWh = 0.113 kWh/L. 0.09883611 / 0.85 = **0.116278**.

**IH hob, efficiency 0.847667.** Frontier Energy, "Residential
Cooktop Performance and Energy Comparison Study", Report
#501318071-R0, July 2019, for SMUD, ASTM F1521. Three induction
cooktops measured 85.20%, 86.10%, 83.00% (mean 84.7667%).
https://cao-94612.s3.amazonaws.com/documents/Induction-Range-Final-Report-July-2019.pdf
0.09883611 / 0.847667 = **0.116598**.

**Gas hob, efficiency 0.35.** The spread is physical
(burner-to-pot matching), not measurement noise:

| Efficiency | Basis | Source |
|-----------:|-------|--------|
| 31.9% | ASTM F1521 lab, oversized 17,000 Btu/h US burner | Frontier Energy 2019: "The efficiency of the gas burner for the 12 pounds of water heat-up test was just 32%" |
| 38-39% | home measurement, lidded pan | Protons for Breakfast (NPL physicist), https://protonsforbreakfast.wordpress.com/2022/01/18/a-watched-pan/ |
| 42% | home measurement, 363 g water, 8 trials | https://www.cambridgeclarion.org/108.html |
| **35% (chosen)** | midpoint of the oversized-burner lab test and the two right-sized home measurements | -- |

0.09883611 / 0.35 = **0.282389 kWh/L gas input**. The Protons for
Breakfast page independently corroborates the whole group: kettle
"close to 100% efficient" (as an element), induction
"approximately 86% efficient", microwave "approximately 65%
efficient".

**Oven, 1.0 kWh/hour -- the weakest cooking entry.** The tier-1
anchor is per-CYCLE: Commission Delegated Regulation (EU) No
65/2014, Annex II, verbatim:

> "SEC_electric cavity = 0,0042 × V + 0,55 (in kWh)"

https://webgate.ec.europa.eu/reqs2/public/v2/requirement/auxi/eu/32014R0066_energcook_annex_2.pdf
-> 60 L: 0.802 kWh, 65 L: 0.823, 70 L: 0.844 per standardised
EN 60350-1 bake cycle. Aggregator estimates for continuous
running give 1.5-2.1 kWh/h, but no source states a duty-cycle
percentage. 1.0 bridges the two. Open item 9.8.

**Microwave, 0.019 kWh/minute.** The advertised wattage is
OUTPUT. Wikipedia "Microwave oven": "microwave ovens can be as
low as 50% efficient at converting electricity into microwaves,
but energy-efficient models can exceed 64% efficiency". A 700 W
-output unit at 60% draws 1,167 W -> 0.1944 kWh per 10 minutes ->
**0.019 kWh/min**. Shipped per MINUTE rather than the plan's
"10 min" unit so it fits the `EnergyUnit` enum.

**Rice cooker -- best-sourced entry in the dataset.**
一般財団法人 家電製品協会, sourced to 省エネルギーセンター実測値,
verbatim:

> "炊飯ジャー：IH5.5合以上8合未満平均消費電力量（炊飯時158Wh/回
> 保温時16.5Wh/h）"

> "ご飯の保温は4時間が目安　ご飯を炊飯器で保温するには、4時間まで
> が目安です。保温のためのエネルギーより、電子レンジで温め直す
> エネルギーの方が少なくなります。約7～8時間以上保温するなら、2回に
> 分けて炊いた方がお得になります。"

Corroborated by Tiger: "炊飯時は163Wh、保温時は16.52Whです。"
Two independent JP sources within 3%. Ships **0.16** and
**0.0165**.

### 3.5 Small loads (verified 2026-08-02)

These are **scale anchors, not targets**. Their honest smallness
is why they ship.

| Item | kWh/unit | Unit | Carrier | Confidence |
|------|---------:|------|---------|------------|
| Phone charge | 0.015271 | use | electricity | Medium |
| Laptop charge | 0.063294 | use | electricity | Medium |
| Television | 0.079096 | hour | electricity | **High** (was Low-Medium) |
| LED bulb (800 lm) | 0.0085 | hour | electricity | High |
| Incandescent bulb (60 W) | 0.06 | hour | electricity | High |
| Household standby | 0.8 | day | electricity | Low |

**Television -- now tier-1 (closes open item 9.6 for TV).**
資源エネルギー庁, sourced to 省エネルギーセンター実測値, verbatim:

> "1日1時間テレビ（50V型）を見る時間を減らした場合 年間で電気
> 28.87kWhの省エネ、原油換算6.44L、CO2削減量12.4kg"

https://www.enecho.meti.go.jp/category/saving_and_new/saving/general/howto/entertainment/index.html

TVs run year-round, so 28.87 / 365 = **0.079096 kWh/h** (79.1 W
for a 50V型 set). Internal check: METI's own 12.4 kg / 28.87 kWh
= 429.5 g/kWh, matching their stated ※照明・テレビのみ 0.429
kgCO2/kWh exactly -- confirming the 365-day basis. The first
pass's aggregator-derived 0.08 was within 1.1%; the sourced value
now ships.

Same page also gives, on the same basis: desktop PC 31.57
kWh/year (0.0865 kWh/h) and laptop **5.48 kWh/year (0.015
kWh/h)** for one hour a day -- useful context that a laptop
*running* draws about 15 W, distinct from the 0.063 kWh to
*charge* one.

**Phone.** iFixit iPhone 15 battery page, verbatim: "12.98 Wh" /
"3349 mAh". https://www.ifixit.com/products/iphone-15-battery
At 85% charge efficiency (Battery University BU-808c): 12.98 /
0.85 = **0.015271 kWh**. At 458 g/kWh that is **7.0 g CO2 per
charge**. Charger no-load draw, independently metered: How-To
Geek measured "between 0.05W to 0.1W or less of power in standby
mode", with five chargers left plugged in year-round costing
"approximately $0.37".

**Laptop.** Apple MacBook Air specs, verbatim: "Built-in
53.8-watt-hour lithium-polymer battery". 53.8 / 0.85 =
**0.063294 kWh**.

**Lighting.** Philips 8.5 W A19 spec, verbatim: "Wattage: '8.5
Watts'" / "Lumen Output: '800 Lumens'". The 60 W incandescent at
~800 lm is the definitional comparator. Ratio **7.06x**. US DOE
phase-out context: "LED lamps represent a significant majority of
the current light bulb market and will represent the vast
majority (98%) by the compliance year", under the "Energy
Independence and Security Act of 2007 (EISA)". (That page carries
two different dates -- open item 9.9.)

**Household standby -- now tier-1 for the claim, still Low for
the number.** Lawrence Berkeley National Laboratory, read live
2026-08-02, verbatim:

> "Most products draw relatively little standby power – less than
> 0.5 watts – but they still add up. A typical American home has
> many products constantly drawing power. Together these amount
> to 5-10% of residential electricity use."

> "Twenty years ago standby in typical products was typically
> 1 - 3 W, but now they are probably near 0.5. That's a huge
> improvement; unfortunately, the number of products with standby
> have increased by even more, leaving us with approximately the
> same amount of standby energy but now dispersed over many more
> products."

https://standby.lbl.gov/

This is the authoritative statement of both the magnitude and the
mechanism, and it confirms the framing the first pass inferred
from Meier & Siderius 2017: **per-device draw collapsed, device
counts exploded, household total held roughly steady.**

**Ships at 0.8 kWh/day** (25-40 always-on devices at ~1 W).
Against a US home's ~29 kWh/day that is ~2.8%, i.e. **below**
LBNL's 5-10% band, so the shipped value is conservative and the
science sheet says so. Deliberately excludes the 650 kWh/year of
builder-installed always-on load LBNL reports separately (smoke
alarms, thermostats, security) because a user cannot unplug it.

**Not shipped:** Wi-Fi router (0.24 kWh/day at 10 W) and game
consoles -- aggregator-only sourcing.

---

## 4. Chosen Dataset Values

Final proposed table for `energy_behaviors.json`. **Store exact
values unrounded; the UI rounds for display.** Decisions E2-E6
are applied. **E1 is open and scales every electricity row.**

| id | Behavior | kWh/unit | Unit | Carrier | Group | Conf. |
|----|----------|---------:|------|---------|-------|-------|
| shower_electric | Shower (electric water) | 0.273652 | minute | electricity | hot_water | Med |
| shower_heatpump | Shower (heat-pump water) | 0.063640 | minute | electricity | hot_water | Med |
| shower_gas | Shower (gas water) | 0.321944 | minute | gas | hot_water | Med |
| bath_electric | Bath (electric water) | 6.279000 | use | electricity | hot_water | Med-High |
| bath_gas | Bath (gas water) | 7.387059 | use | gas | hot_water | Med |
| washup_electric | Washing up by hand (electric) | 2.197650 | use | electricity | dishes | Med |
| washup_gas | Washing up by hand (gas) | 2.585471 | use | gas | dishes | Med |
| dishwasher_eco | Dishwasher, eco | 0.85 | use | electricity | dishes | High |
| dishwasher_normal | Dishwasher, normal | 1.12 | use | electricity | dishes | High |
| wash_cold | Washing machine, cold (20 C) | 0.350 | use | electricity | laundry_wash | High |
| wash_warm | Washing machine, warm (40 C) | 1.300 | use | electricity | laundry_wash | High |
| wash_hot | Washing machine, hot (60 C) | 1.700 | use | electricity | laundry_wash | High |
| dryer_vented | Tumble dryer (vented/condenser) | 4.5 | use | electricity | laundry_dry | High |
| dryer_heatpump | Tumble dryer (heat pump) | 2.05 | use | electricity | laundry_dry | High |
| line_dry | Line drying | 0 | use | none | laundry_dry | High |
| aircon_heating | Air conditioner, heating | 0.241006 | hour | electricity | space_heat | High |
| space_heater | Electric space heater | 1.2 | hour | electricity | space_heat | Med |
| kotatsu | Kotatsu | 0.15 | hour | electricity | space_heat | Low |
| electric_blanket | Electric blanket | 0.025 | hour | electricity | space_heat | Med |
| aircon_cooling | Air conditioner, cooling | 0.167679 | hour | electricity | space_cool | High |
| kettle | Electric kettle, 1 L | 0.116278 | use | electricity | boil | Med-High |
| ih_hob | IH hob, boil 1 L | 0.116598 | use | electricity | boil | Med-High |
| gas_hob | Gas hob, boil 1 L | 0.282389 | use | gas | boil | Med |
| oven | Electric oven | 1.0 | hour | electricity | cook | Low-Med |
| microwave | Microwave | 0.019 | minute | electricity | cook | Med |
| rice_cooker | Rice cooker, one cycle | 0.16 | use | electricity | cook | High |
| rice_keepwarm | Rice cooker, keep warm | 0.0165 | hour | electricity | cook | High |
| led_bulb | LED bulb (800 lm) | 0.0085 | hour | electricity | lighting | High |
| incandescent_bulb | Incandescent bulb (60 W) | 0.06 | hour | electricity | lighting | High |
| phone_charge | Phone charge | 0.015271 | use | electricity | device | Med |
| laptop_charge | Laptop charge | 0.063294 | use | electricity | device | Med |
| tv | Television (50 inch) | 0.079096 | hour | electricity | device | High |
| standby | Household standby | 0.8 | day | electricity | device | Low |

33 behaviors against the plan's "~25". The overshoot is the
water-heating carrier/hardware split (5 entries where the plan
counted 2), plus three genuine behavior choices the research
turned up: heat-pump vs vented dryer, eco vs normal dishwasher,
and the third wash temperature.

### Metadata carrier factors

```
grid_factor_g_per_kwh : 458   (Ember GER 2026, 2025 data, CO2e;
                               shared with transport_modes.json,
                               pinned by a cross-dataset test;
                               decision E1, 2026-08-02)
gas_factor_g_per_kwh  : 182   (DEFRA 2026 natural gas, Scope 1
                               combustion, Gross CV, 0.18231
                               rounded down; independently
                               corroborated by METI at 179.5)
```

### Decisions

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

## 5. Usage Presets

Presets fill the `units` field, exactly like Part 2 servings.

| Behavior | Preset | units | Basis |
|----------|--------|------:|-------|
| shower_* | A quick shower (5 min) | 5 | -- |
| shower_* | A typical shower (10 min) | 10 | -- |
| shower_* | A long shower (20 min) | 20 | -- |
| bath_* | A full bath (~180 L) | 1.0 | 東京都水道局 180 L |
| bath_* | A shallow bath (~150 L) | 0.83 | 150/180, European fill |
| washup_* | A full load (14 place settings) | 1.0 | Which? 2026, 63 L |
| washup_* | A few dishes | 0.25 | quarter load |
| wash_*, dryer_*, line_dry | 1 load | 1 | 8-9 kg drum |
| dishwasher_* | 1 cycle (14 place settings) | 1 | Bosch / Which? basis |
| aircon_cooling | 1 hour at 28 C | 1.0 | METI measured baseline |
| aircon_cooling | 1 hour at 27 C | 1.17891 | +0.030 kWh/h per 1 C, METI |
| aircon_cooling | 1 hour at 26 C | 1.35783 | +2 C, capped |
| aircon_cooling | An evening (4 h at 26 C) | 5.43132 | 4 x 1.35783 |
| aircon_heating | 1 hour at 20 C | 1.0 | METI measured baseline |
| aircon_heating | 1 hour at 21 C | 1.14480 | +0.034898 kWh/h per 1 C |
| aircon_heating | 1 hour at 22 C | 1.28960 | +2 C, capped |
| space_heater, kotatsu, electric_blanket | An evening (4 h) | 4 | -- |
| kettle, ih_hob, gas_hob | 1 litre | 1 | -- |
| kettle, ih_hob, gas_hob | A mug (0.3 L) | 0.3 | -- |
| oven | 30 minutes | 0.5 | -- |
| oven | 1 hour | 1 | EU EN 60350-1 cycle is ~0.82 kWh |
| microwave | 2 minutes | 2 | -- |
| microwave | 10 minutes | 10 | -- |
| rice_cooker | 1 cycle (5.5 go) | 1 | 家電製品協会 IH 5.5-8合 |
| rice_keepwarm | 4 hours (the guideline) | 4 | 家電製品協会 「4時間が目安」 |
| rice_keepwarm | Overnight (10 h) | 10 | source's own worked example |
| phone_charge, laptop_charge | 1 full charge | 1 | -- |
| tv, led_bulb, incandescent_bulb | 1 hour | 1 | -- |
| tv | An evening (3 h) | 3 | -- |
| led_bulb, incandescent_bulb | An evening (5 h) | 5 | -- |
| standby | 1 day | 1 | -- |

**Setpoint presets are capped at +/-2 C from the METI baseline on
purpose**, and use METI's absolute per-degree deltas rather than
環境省's rounded percentages so they stay consistent with the
shipped per-hour values. Neither source supports extrapolating
across a wider span.

---

## 6. Sanity Invariants (for the test suite)

**DATA PINS for the values in section 4, not truth claims** --
several would flip under E1 or a different appliance choice, so
re-derive at every data pass.

### Safe pins

1. `bath_electric` is the dataset maximum per single use (6.279;
   margin vs #2 `dryer_vented` 4.5 = +40%).
2. Hot-water chain: `bath_electric > 10 x shower_electric >
   kettle > phone_charge` (6.279 > 2.737 > 0.116 > 0.0153).
   Thinnest link bath vs 10-min shower at **+129%** (improved
   from +80% by decision E4).
3. `shower_electric > 4 x shower_heatpump` (0.273652 > 0.254560,
   +7.5%) -- thin; the COP-4.3 mean is the fragile input.
   Annotate.
4. `dryer_vented > 2 x dryer_heatpump` (4.5 > 4.10, +10%) --
   thin but source-backed. Most likely pin to move.
5. Wash chain: `wash_hot > wash_warm > 2 x wash_cold`
   (1.700 > 1.300 > 0.700). Thinnest link hot vs warm at +31%.
6. `space_heater > 5 x kotatsu` (1.2 > 0.75, +60%). Actual ratio
   8.0x. **The plan's "~10x" does not survive the research.**
7. `space_heater > 4 x aircon_heating` (1.2 > 0.964, +24%).
   Actual ratio 4.98x -- the flagship heating lesson.
8. `incandescent_bulb > 4 x led_bulb` (0.06 > 0.034, +76%).
   Actual ratio 7.06x.
9. `dishwasher_normal < washup_electric` (1.12 < 2.198, -49%) --
   true for electric water only; see never-pin.
10. Heat-vs-light: `dryer_vented > 50 x tv` (4.5 > 3.955, +14%)
    -- thin, prefer `dryer_vented > 10 x tv` (+469%).
11. `rice_keepwarm x 10 > rice_cooker` (0.165 > 0.16) -- the
    4-hour lesson's foundation.
12. **Cross-dataset:** `grid_factor_g_per_kwh` identical in
    `transport_modes.json` and `energy_behaviors.json`.
13. **Zero-carrier rule:** `line_dry` is the only entry with
    carrier `none` and the only entry allowed kWh = 0.
14. **Group integrity:** every entry has a non-empty
    `comparable_group`; every group has >= 1 member; no group
    spans more than one `unit` type except `hot_water` (minute +
    use) and `laundry_dry`.
15. **Assembled-value pins** (RV-1 pattern -- judgment-call
    values unreachable by any ordering pin, so a silent revert
    would otherwise pass the suite): `kotatsu` 0.15 (not the
    0.3-0.6 nameplate), `space_heater` 1.2 (not 1.5), `oven` 1.0
    (not the 0.802 EU cycle or 2.0 nameplate), `standby` 0.8 (not
    1.78), `gas_hob` 0.282389 (efficiency 0.35, not 0.32 or
    0.42), `dryer_vented` 4.5 (not the model-specific 4.63),
    **`aircon_cooling` 0.167679 and `aircon_heating` 0.241006
    (METI measured -- NOT the Panasonic JIS rated 0.435 / 0.455,
    which a well-meaning future edit would "correct" them to)**.

### Never pin / never generate superlative copy

All of these are blocked structurally by the section 2.2 rule;
the list records why.

- **kettle vs IH hob** (0.116278 vs 0.116598, **0.3%**) -- an
  exact tie, deliberately. 44.9 g vs 45.0 g. The dataset's
  flagship "this choice does not matter" pair. Fails rule #3.
- **gas hob vs kettle/IH in CO2** (51.4 g vs 44.9/45.0, +14%) --
  2.4x the kWh, 14% the CO2. Flips under E1. Fails rule #2.
- **washup_gas vs dishwasher_normal** (471 g vs 432 g, +9%) --
  the dishwasher wins clearly against an electric sink (848 g)
  and ties against a gas one. Fails rule #2.
- **shower_gas vs shower_electric** (58.6 vs 105.6 g/min) -- a
  real 1.8x gap that reverses in the UK (section 2.1). Fails
  rule #2.
- **bath_gas vs bath_electric** -- same reason.
- **aircon_cooling vs aircon_heating** (0.167679 vs 0.241006,
  +44%) -- above the delta threshold but different groups
  (`space_cool` vs `space_heat`); comparing them is meaningless.
  Fails rule #1.
- **laptop_charge vs incandescent_bulb per hour** (0.063294 vs
  0.06, +5.5%) -- fails #1 and #3.
- **oven vs space_heater per hour** (1.0 vs 1.2, +20%) -- exactly
  at the threshold, both the least-certain entries in their
  groups. Fails #1.
- **wash_hot vs dishwasher_normal** (1.700 vs 1.12) -- different
  loads entirely. Fails #1.
- **tv vs anything outside `device`** -- fine within group, but
  the entry is a scale anchor, not a target; no superlatives.
- **dishwasher_eco vs dishwasher_normal** (0.85 vs 1.12, +32%) --
  PASSES all three rules and may be compared, but the copy must
  note eco takes 3h15 so it does not read as a free win.

---

## 7. Action-Data Consistency (`co2_actions_database.json`)

Five existing actions must be reproducible from this dataset or
get corrected in the SAME PR. All arithmetic at the E1 factors,
**458 / 182 g/kWh**.

| Action | Shipped | Dataset-implied | Verdict |
|--------|--------:|-----------------|---------|
| `air_dry_clothes` (per load) | 1700 g | `dryer_vented` 4.5 x 458 = 2061 -> **2000 g** | **CORRECT 1700 -> 2000.** Notes must say vented/condenser: a heat-pump dryer is 939 g, less than half |
| `cold_water_laundry` (per load) | 600 g | (`wash_warm` 1.300 - `wash_cold` 0.350) x 458 = 435 -> **430 g** | **CORRECT 600 -> 430.** See note below |
| `shorter_shower` (per minute) | 115 g | electric 125.3 / gas 58.6 / heat pump 29.1 | **STANDS** -- 115 sits between the gas and electric figures, honestly carrier-agnostic. Notes must state the 7.84 L/min basis and the carrier range |
| `unplug_standby` (per device/day) | 9 g | LBNL "less than 0.5 watts" -> 0.5 W x 24 h x 458 = 5.50 -> **5 g** | **CORRECT 9 -> 5.** The shipped 1 W is 2x LBNL's tier-1 typical |
| `led_vs_incandescent` (per hour) | 19 g | (0.06 - 0.0085) x 458 = 23.59 -> **23 g** | **CORRECT 19 -> 23.** Notes: correct 0.37 kg/kWh -> 458 g/kWh, disclose the 8.5 W sourced LED |

Two notes on the corrections:

**`cold_water_laundry` baseline.** The first pass proposed 500 g
off a 60 -> 20 C swap. With 40 C now in the dataset, the honest
baseline is **40 C** -- most households' default is warm, not
hot -- giving 0.950 kWh x 458 = 435 -> 430 g. Honest-not-generous takes
the smaller saving. If the action is meant to read "instead of a
hot wash" rather than "instead of your usual", (1.700 - 0.350) x
458 = 618 -> 610 g is the alternative. Owner call, flagged in the action's notes either way.

**`unplug_standby`.** LBNL states typical modern standby is
"less than 0.5 watts"; the action assumes 1 W. Halving it halves
the saving (9 -> 5.50, rounded down to 5 g). This is a 55% cut to
a live user-visible number, so it should ship with the
methodology explainer, not ahead of it.

### 7.1 New energy actions (decided 2026-08-02)

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
| `shower_instead_of_bath` | **NEW** | 750 | per_bath_skipped | 2/4/2 | 13 |
| `dishwasher_eco_cycle` | **NEW** | 120 | per_cycle | 1/4/1 | 5 |
| `aircon_setpoint_summer` | **NEW** | 120 | per_day | 2/4/2 | 6 |
| `aircon_setpoint_winter` | **NEW** | 140 | per_day | 2/4/2 | 6 |
| `heat_person_not_room` | **NEW** | 1900 | per_evening | 2/4/2 | 18 |

Derivations (each needs the inline calculation comment required
by [AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) section 2):

- `shower_instead_of_bath`: bath 6.279 kWh - 10-min shower
  2.737 kWh. Electric saves 1622 g, gas saves 759 g. **Ships the
  GAS figure (759 -> 750 g)** because the carrier is unknown and
  honest-not-generous takes the smaller saving. See the JP
  caveat below -- the unit is load-bearing.
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

  **Residual caveat (open):** METI's figures are tied to specific
  stated conditions -- outdoor 31 C with a 27->28 step, outdoor
  6 C with 21->20. A user setting 24->25 on a 30 C day is a -17%
  change, not -25%. The shipped values are therefore "a
  representative degree at the recommended setpoint", not a
  universal per-degree constant, and the action descriptions must
  name the setpoint rather than promising a generic degree. See
  caveat 2 below.
- `heat_person_not_room`: space heater 1.2 - kotatsu 0.15 =
  1.05 kWh/h x 458 = 481 g/h; an evening of 4 hours = 1924 ->
  1900 g. Covers kotatsu, electric blanket or heated carpet used
  **instead of** turning on a space heater.

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

#### Two caveats requiring an owner call

1. **`shower_instead_of_bath` and Japanese bathing culture.** The
   750 g assumes a bath drawn for one person. Japanese households
   commonly share one fill: at three people the bath is 959 g per
   person, which is **less** than a 10-minute electric shower each
   (1253 g) -- the action is inverted for a JP family, in the
   primary market. Mitigations: the unit must read "instead of
   running a bath just for yourself" in all three locales, and
   the JA copy should say so explicitly rather than being a
   translation of the EN. (Secondary, unquantified: 残り湯 reuse
   for laundry recovers some of the bath's energy in the wash.)
   Alternative if this feels too sharp: drop the action and keep
   bath-vs-shower as a calculator comparison, like the dishwasher
   case.
2. **Setpoint framing: "moved it a degree" vs "kept it at the
   recommended setpoint".** Because the per-degree saving is
   condition-dependent (above), "I turned it up 1 C" has the
   same unverifiable-baseline problem that killed the logging
   bridge -- a degree from what? The alternative is to frame
   both actions as the state METI actually campaigns for --
   "kept cooling at 28 C" / "kept heating at 20 C" -- which is
   checkable by the user, matches クールビズ / ウォームビズ, and
   keeps METI's own 1 C step as the documented counterfactual.
   Recommended, but it sharpens caveat 3 below. Owner call.
3. **Rewarding existing lifestyle.** Both setpoint actions and
   `heat_person_not_room` can be logged daily by someone who
   already lives that way, which
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
      (`shower_instead_of_bath`, `dishwasher_eco_cycle`,
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

## 8. UI / Copy Requirements (for the implementation PR)

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
   (section 2.1), including the 214 g/kWh figure and the fact
   that the UK has already crossed it. Never imply gas is
   universally cleaner.
5. **Measured-vs-rated disclosure on the aircon entries:** "a
   measured average hour of use (Energy Conservation Center via
   METI); the catalog rating is about 2.5x higher because it is
   measured at full load."
6. **Kotatsu vs space heater ships as "roughly 8x", never
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
19. **Grid-factor vintage disclosure** (binding until E1 is
    resolved): state the figure, its basis, and that current
    trackers publish higher values, so a user cross-checking
    against IEA or Ember finds the gap explained rather than
    hidden.
20. **Gas boundary disclosure:** combustion only; DEFRA's WTT
    term (~+17%) excluded for parity with transport.
21. **Oven carries a low-confidence sublabel** -- now the only
    shipped entry with no tier-1 primary figure.
22. **Tie-cluster sort rule:** stable secondary sort
    (alphabetical) so tie-cluster items do not jitter.

---

## 9. Open Items

Resolved in the first pass: gas carrier factor extracted from the
DESNZ primary spreadsheets; the JP setpoint rule sourced to
環境省; the rice cooker sourced to 省エネルギーセンター and
corroborated by Tiger; the washing-machine "which 60 C?" trap
identified and confirmed by physics; the dishwasher and
hand-washing entries put on one shared basis; the kettle/IH tie
established from two measured efficiencies.

Resolved in the 2026-08-02 browser pass:

- **Ember 458 and IEA read live** -- E1's evidence base is now
  citable. A later adversarial pass found *Electricity 2026* had
  superseded *Electricity 2025*; the newer report is now cited
  and puts IEA and Ember on the same 2025 vintage.
- **EPA WaterSense read live** (gpm verbatim; litre figures are
  our own stated conversion) -- E4's flow average is citable.
- **LBNL standby read live** -- the 5-10% claim and the
  "same total, more devices" mechanism are now tier-1 quotes, not
  inferences.
- **資源エネルギー庁 read live** -- this closed the most: the TV
  entry gained a tier-1 measured figure (9.6 for TV), the aircon
  entries were replaced with measured seasonal values (**closing
  9.7**, the worst open item), the gas carrier factor gained an
  independent JP cross-check at 1.4%, and the four-way heating
  hierarchy became sourceable from one page.
- **`AUDIT_ACTION_DATA.md` §8 arithmetic error found** -- the
  documented derivation of 386 ("midpoint of US 370g and UK
  210g") computes to 290. Needs correcting regardless of E1.

Open:

- [x] **E1 (grid factor)** -- RESOLVED 2026-08-02, ship Ember
      458 g CO2e/kWh. See section 4. Regionalisation spun out to
      [PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md).
      Two follow-ups land with the rebase PR: correct the
      `AUDIT_ACTION_DATA.md` §8 derivation line, and re-seed.
- [ ] **9.1 Remaining fetch-blocked sources.**
      energysavingtrust.org.uk, energystar.gov and nrdc.org still
      refuse automated fetch. Affected figures are corroboration
      for entries that now have better primaries, except the
      Western fridge range (methodology copy only). No shipped
      value depends on a SEARCH-ONLY figure any more.
- [ ] **9.2 Gas DHW efficiency (0.85) is unsourced.** Needs SAP
      Table 4a or a SEDBUK DHW figure. Three shipped gas entries
      move if it changes.
- [ ] **9.3 Cold inlet 10 C and delivered 40 C are unsourced
      assumptions.** They set delta-T = 30 K and scale all seven
      hot-water entries linearly. A 5 K error is a 17% error in
      the dataset's largest entries. Needs SAP Appendix G3 or
      CIBSE.
- [ ] **9.6 Fridge context figure** has no tier-1 primary
      (methodology copy only; TV is now closed).
- [ ] **9.8 Oven has no metered per-hour source** -- now the
      weakest shipped entry. DOE's residential cooking TSD
      (10 CFR 430 App. I1) is the likely fix.
- [ ] **9.9 Incandescent phase-out dates** -- DOE's page carries
      both a 2022 backstop and a 2028 standard. Reconcile before
      in-app copy states a date.
- [ ] **9.10 Stamminger / Bonn full text** -- repository errored.
      Used only for the behavioral spread; Which? 2026 carries
      both shipped entries.
- [ ] **9.12 Kotatsu average-vs-nameplate ratio** (renumbered
      from the first pass) -- still no tier-1 source. The
      dataset's weakest number.

Standing rules -- permanent by design:

- **Yearly DEFRA refresh:** re-read the natural-gas Gross CV
  combustion row at each release, alongside Part 1's transport
  refresh.
- **Measured-over-rated guard** (prohibition): the aircon entries
  must never be "corrected" to their JIS catalog ratings. Pin 15
  catches it.
- **Nameplate guard** (prohibition): no climate or small-loads
  entry may be raised to its nameplate rating.
- **SEARCH-ONLY guard** (prohibition): a figure seen only in a
  search-engine summary may not enter `sources[]`.
- **Physics entries never need refreshing.** Only the assumptions
  around them (flow rate, delta-T, efficiency) can age.

Verification gate: dataset value changes must keep the section-6
pins green in a scoped `flutter test test/features/energy` run.
Any new or changed source quote is re-verified LIVE before
pasting.

---

## 10. ENERGY_LOGIC_CHECK

Water constant: 4.186 / 3600 = 0.001162777 kWh/(L-K); x 30 K =
0.03488333 kWh/L. CO2 at **458** (electricity) / **182** (gas)
g/kWh, per decision E1.

1. **Shower (electric) = 0.273652/min.** Flow 7.844784 L/min
   (mean of 6.5 / 7.570824 / 9.463529) x 0.03488333 / 1.0. Per
   minute **125.3 g**; per 10-min shower 2.737 kWh = **1.25 kg**.
   Medium.
2. **Shower (heat pump) = 0.063640/min.** / COP 4.3. **29.1
   g/min**; a 10-minute shower is **0.29 kg** -- a quarter of the
   resistance case and the largest single lever in the dataset.
   Medium.
3. **Shower (gas) = 0.321944/min.** / 0.85. **58.6 g/min.** Uses
   18% more energy than resistance electric, emits **53% less
   carbon** -- at 458. Reverses below a 214 g/kWh grid (2.1).
   Medium.
4. **Bath (electric) = 6.279/use.** 180 L x 0.03488333.
   **2.88 kg** -- the dataset's largest single use, and 410 phone
   charges. Medium-High.
5. **Bath (gas) = 7.387059/use.** 1.34 kg (unchanged -- gas). Medium.
6. **Bath vs shower.** 6.279 vs 2.737 for 10 minutes = the bath
   costs **2.3x a 10-minute shower**, breaking even at a
   23-minute shower. Safe to state (same group, same carrier,
   >20%). The popular "a bath equals a 5-minute shower" claim is
   wrong at these flow rates.
7. **Washing up (electric) = 2.19765/use.** 63 L x 0.03488333.
   **1.01 kg.** Medium.
8. **Washing up (gas) = 2.585471/use.** **471 g -- and now 8% BELOW
   `dishwasher_normal` (513 g), a flip caused by E1.** Blocked from copy by the
   same-carrier rule. Medium.
9. **Wash, cold 20 C = 0.350.** Bosch EN50229 verbatim, 9 kg.
   160 g. High.
10. **Wash, warm 40 C = 1.300.** Same document. 595 g. High.
11. **Wash, hot 60 C = 1.700.** Same document. 656 g. 779 g. Spread
    0.90-1.70 kWh depending on which 60 C. High provenance.
12. **Dryer, vented = 4.5.** Bosch condenser verified 4.63 /
    2.61 half load; ships 4.5. **2.06 kg.** High.
13. **Dryer, heat pump = 2.05.** Bosch verbatim, 9 kg full load.
    **939 g.** High.
14. **Line dry = 0.** Carrier `none`, the only zero. High.
15. **Laundry day** (the plan's illustration, real numbers):
    60 C + vented = 6.2 kWh = **2.39 kg**; 40 C + vented = 5.8
    kWh = 2.24 kg; cold + vented = 4.85 kWh = 1.87 kg; cold +
    line = 0.350 kWh = **135 g**. Line drying saves **2.26 kg**
    vs hot-wash-plus-dryer = **383 phone charges.** The plan's
    illustrative 1.3 / 1.1 / 0.15 kg were roughly half these.
16. **Dishwasher, eco = 0.85.** Bosch verbatim. 389 g. High.
17. **Dishwasher, normal = 1.12.** Which? 2026 verbatim. 513 g.
    Eco is 24% lower. High.
18. **Aircon cooling = 0.167679/h.** METI 18.78 kWh/yr / 112 days
    (冷房期間). **76.8 g/h** at a 28 C setpoint. Presets add
    METI's own 0.030 kWh/h per 1 C: 27 C = 90.5 g, 26 C = 104.2 g.
    High.
19. **Aircon heating = 0.241006/h.** METI 40.73 kWh/yr / 169 days
    (暖房期間). **110.4 g/h** at 20 C. Presets add 0.034898 kWh/h
    per 1 C: 21 C = 126.4 g, 22 C = 142.4 g. High.
20. **Rated-vs-measured gap.** Panasonic JIS rated 0.435 / 0.455
    are **2.6x / 1.9x** the METI measured values. Both are
    correct for their own question; the app asks "an hour of
    use", which is METI's. Pin 15 protects this.
21. **Space heater = 1.2/h.** JP ceramic high setting. **549.6 g/h**
    -- **5.0x an hour of heat-pump heating.** Medium.
22. **Kotatsu = 0.15/h.** Mid setting across enechange's ranges,
    rounded up. **68.7 g/h.** Ratio to space heater **8.0x**, not
    10x. Nameplate 300-600 W would be 3-5x wrong. Low.
23. **Electric blanket = 0.025/h.** Yamazen 適温 22 Wh/h rounded
    up. **11.5 g/h**; an evening (4 h) is 46 g -- less than half
    an hour of TV, and 1/48th of the same evening on a space
    heater. Medium.
24. **Heating hierarchy cross-check.** Kerosene 0.094142 L/h x
    2489 g/L + 0.023018 kWh x 458 = **245 g/h** vs METI's own
    246. Gas 0.075030 m3/h x 12.5 kWh/m3 x 182 + 0.022012 kWh x
    458 = **181 g/h** vs METI's own 179. Both reproduce METI to
    within 1%, which independently validates the DEFRA gas factor
    (182 vs METI's implied 179.5, 1.4% apart).
25. **Boil floor = 0.09883611 kWh/L.** 1.000 kg x 4.186 x 85 /
    3600. Not shipped; the anchor every boil entry divides into.
26. **Kettle = 0.116278/L.** Floor / 0.85. Metered cross-check
    0.113 kWh/L at an 18 C start. **53.3 g.** Medium-High.
27. **IH hob = 0.116598/L.** Floor / 0.847667 (Frontier: 85.20 /
    86.10 / 83.00%). **53.4 g. 0.3% from the kettle -- an exact
    tie, the dataset's flagship "this does not matter" pair.**
    Medium-High.
28. **Gas hob = 0.282389/L.** Floor / 0.35. 2.43x the kettle's
    kWh but **51.4 g -- and at E1's 458 the kettle (53.3 g) is now
    3.6% ABOVE the gas hob, a flip from the 386 ordering.**
    Blocked from copy by the same-carrier rule, which is exactly
    why that rule exists.
    Medium.
29. **Oven = 1.0/h.** Between the EU per-cycle formula (0.0042 x
    65 + 0.55 = 0.823) and unsourced 1.5-2.1 kWh/h duty-cycle
    estimates. **458 g/h** -- an hour of oven costs about 83% of
    an hour of space heater. Low-Medium; open item 9.8.
30. **Microwave = 0.019/min.** 700 W output / 0.60 = 1167 W
    input x (1/60) h. **8.7 g/min**; 10 minutes = 87 g, **1/5 of
    an hour of oven.** Medium.
31. **Rice cooker = 0.16/use.** 家電製品協会 158 Wh/回, Tiger
    163 Wh; ships 0.16 rounded up. **73.3 g.** High.
32. **Rice cooker keep warm = 0.0165/h.** 16.5 Wh/h verbatim.
    **7.6 g/h.** The 4-hour rule checks out: 4 h keep-warm =
    0.066 kWh vs a 2-minute microwave reheat at 0.038 kWh --
    keep-warm loses at 4 hours, exactly as the source says. 10 h
    (0.165 kWh) exceeds the cook cycle. High.
33. **Phone charge = 0.015271/use.** iFixit 12.98 Wh / 0.85.
    **7.0 g** -- 1/18th of a single minute in the shower,
    1/410th of a bath. A charger left plugged in with no phone
    (0.05-0.1 W) costs **0.4-0.8 g CO2 per year.** Medium.
34. **Laptop charge = 0.063294/use.** Apple 53.8 Wh / 0.85.
    **29.0 g.** Medium.
35. **TV = 0.079096/h.** METI 28.87 kWh/yr / 365 days.
    **36.2 g/h**; an evening (3 h) = 109 g. METI's own CO2 check:
    12.4 kg / 28.87 kWh = 429.5 g/kWh, matching their stated
    0.429 exactly. High.
36. **LED bulb = 0.0085/h.** Philips verbatim 8.5 W / 800 lm.
    **3.9 g/h.** High.
37. **Incandescent = 0.06/h.** The definitional 60 W / ~800 lm
    comparator. **27.5 g/h.** Ratio **7.06x**. One bulb swapped
    for 5 hours a night saves 0.258 kWh/day = **118 g/day**, about
    43 kg/year -- roughly 15 baths. High.
38. **Household standby = 0.8/day.** 25-40 devices x ~1 W x 24 h.
    **366 g/day**, ~134 kg/year. Against a US home's ~29 kWh/day
    this is 2.8%, below LBNL's 5-10% band -- deliberately
    conservative, and excluding the 650 kWh/year of
    builder-installed load a user cannot unplug. Low.

**Heat-vs-light hierarchy, the number that justifies Part 3:**

| Behavior | kWh | g CO2 | vs one LED-hour |
|----------|----:|------:|----------------:|
| Bath | 6.279 | 2876 | 739x |
| Tumble dryer (vented) | 4.5 | 2061 | 529x |
| Shower, 10 min (resistance) | 2.737 | 1253 | 322x |
| Wash 60 C | 1.700 | 779 | 200x |
| Space heater, 1 h | 1.2 | 550 | 141x |
| Oven, 1 h | 1.0 | 458 | 118x |
| Shower, 10 min (heat pump) | 0.636 | 291 | 75x |
| Aircon heating, 1 h | 0.241 | 110 | 28x |
| Aircon cooling, 1 h | 0.168 | 77 | 20x |
| Rice cooker, 1 cycle | 0.16 | 73 | 19x |
| Kettle, 1 L | 0.116 | 53 | 14x |
| TV, 1 h | 0.079 | 36 | 9x |
| Laptop charge | 0.063 | 29 | 7x |
| Incandescent bulb, 1 h | 0.06 | 28 | 7x |
| Electric blanket, 1 h | 0.025 | 11 | 3x |
| Phone charge | 0.0153 | 7.0 | 1.8x |
| LED bulb, 1 h | 0.0085 | 3.9 | 1x |

**Anything that makes or moves heat costs 20-700x anything that
makes light or computation.** The plan predicted 10-100x. A bath
is 410 phone charges -- and a heat pump moves the same heat for a
quarter of the carbon, which is the second lesson the dataset now
teaches by itself.
