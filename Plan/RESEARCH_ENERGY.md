# Home Energy Emission Factor Research

**Version:** 2.0
**Created:** 2026-08-02
**Status:** Evidence base complete. 33 behaviors, every factor
live-verified, no open items. Restructured 2026-08-02
to match the transport pattern: this document is the **evidence
base only**. Decisions, product rules, action-library additions,
UI/copy requirements and the methodology screen copy moved to
[PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md).
**Feeds:** `data/app/energy_behaviors.json` (Phase 8.13, see
[PLAN_PHASE_8.md](./PLAN_PHASE_8.md) Part 3)
**Archive:** executed detail -- closed items, superseded values,
rejected alternatives, non-entries and the full recomputation --
moved to
[RESEARCH_ENERGY_ARCHIVE.md](./RESEARCH_ENERGY_ARCHIVE.md)
2026-08-08 so this document stays a working reference.

Every factor that ships must trace back to an entry here with
source, verbatim quote, URL, access date and vintage. Follows the
sourcing rules in [AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md)
(sections 2 and 8) and
[RESEARCH_STRATEGY.md](./RESEARCH_STRATEGY.md).

Unit for every factor: **kWh per stated unit** (`use`, `minute`,
`hour`, `day`), multiplied at runtime by **458 g CO2e/kWh**
(electricity) or **182 g CO2e/kWh** (gas). Access date for every
source below: **2026-08-02**.

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

### Grid electricity: Ember 458 (decision E1)

The house factor of **386 g CO2/kWh** is replaced by **Ember
*Global Electricity Review 2026*, 458 g CO2e/kWh (2025 data)**,
shared with `transport_modes.json` and pinned by a cross-dataset
test. Ember verbatim: "from 533 grams of CO2 equivalent per kWh
(gCO2e/kWh) in 2015 to 458 gCO2e/kWh in 2025."
https://ember-energy.org/latest-insights/global-electricity-review-2026/electricity-demand-and-supply-trends/

**Do not average IEA and Ember.** IEA's 435 is CO2-only, Ember's
458 is CO2e; averaging produces a figure that is neither. The app
is denominated in CO2e throughout, so Ember is the scope-correct
anchor and also the freshest vintage. The full candidate survey
(IEA, JP 代替値, utility self-reports, regional 2025 table) and the
386 provenance error are in
[archive](./RESEARCH_ENERGY_ARCHIVE.md) 2.

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
what the first pass said nobody published. Sections 3.3 and 3.5
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

**Trap found and documented (feeds PDR UI rule 7):** the same 9 kg
Bosch drum publishes THREE different "60 C" numbers -- 1.700 kWh
(user-selected Cottons 60 C, EN50229), 1.450 kWh (same programme,
older EN60456) and 0.900 kWh ("Cottons colour 60 C", the EU-label
programme). Bosch discloses why, verbatim: "The actual washing
temperature may differ from the stated programme temperature for
energy-saving reasons." A label-optimised "60 C" cycle does not
reach 60 C.

### Aggregator discipline

Aggregator and blog pages are **corroboration with an access
date**, never a second verification, and every one carries its
URL. Values seen only in a search-engine summary are labelled
**SEARCH-ONLY** and may not enter `sources[]` until re-fetched.
The browser pass on 2026-08-02 cleared Ember, IEA, EPA
WaterSense, LBNL standby and 資源エネルギー庁 off that list;
[archive](./RESEARCH_ENERGY_ARCHIVE.md) 1 tracks what remains.

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
  litre per kelvin**. Cold inlet **12.8 C** (UK SAP 10.1 Table J1
  mains-fed annual average), delivered hot water **40 C** (NHBC
  design standard), so **delta-T = 27.2 K** and **0.03162756
  kWh/L** throughout 3.1. Both are now tier-1 sourced; the
  earlier 10 C / 30 K pair was a
  winter-conservative guess and cut all seven hot-water entries
  by 9.33% when corrected.
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
carbon**, because gas is 182 g/kWh against the grid's 458 -- and
because a real combi boiler is only ~75.6% efficient in hot-water
mode on a gross-CV basis (3.1), not the ~85% first assumed.
Efficiency and carbon intensity pull opposite ways and carbon
intensity wins -- **at today's global grid factor**.

The crossover is a grid factor of **241 g CO2e/kWh**. Below that,
resistance electric beats gas. Applied to the shipped shower
entry (0.248111 kWh/min electric, 0.328036 kWh/min gas), across
candidate grids:

| Grid | Electric | Gas | Winner |
|------|---------:|----:|--------|
| UK, DEFRA 2026 (131) | 32.5 g/min | 59.7 | **electric, 1.8x** |
| **House factor (458, E1)** | **113.6** | **59.7** | **gas, 1.9x** |
| IEA 2030 forecast (360) | 89.3 | 59.7 | gas, 1.5x |
| JP 資源エネルギー庁 (429) | 106.4 | 59.7 | gas, 1.8x |
| Crossover point (241) | 59.8 | 59.7 | tie, by construction |

**The UK has already crossed over.** A gas shower in Britain is
now the higher-carbon option; in Japan it is half the carbon of
electric. Same two appliances, opposite answers, decided entirely
by grid.

Three consequences, all binding:

1. Cross-carrier comparisons must never auto-generate a verdict
   (enforced structurally by the comparison gating,
   [PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md)
   section 3), because the verdict is a fact about the user's
   country, not their behavior.
2. This is the strongest argument for regional grid factors,
   which are no longer a Part 3 open question but their own
   scoped brief
   ([PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md)),
   because a single global factor gets the UK answer backwards.
3. The methodology paragraph must NOT say "gas looks better today
   and will flip eventually". It must say **the flip has already
   happened in some markets**, and state the 241 g/kWh crossover
   so a reader can check their own grid.

---

## 3. Verified Factors

> "Verified" means the number was read on a live page or in a
> downloaded primary file, quoted digit-for-digit, with at least
> one independent source corroborating magnitude. Derived entries
> additionally show reproducible arithmetic.

### 3.1 Hot water (verified 2026-08-02)

Constant: **0.03162756 kWh per litre** (1 kg x 4.186 kJ/kg-K x
27.2 K / 3600).

**Temperature basis.** Both ends of
delta-T are now tier-1 sourced.

*Delivered 40 C.* UK SAP 10.1 Appendix J, verbatim:

> "where fhot,shower = (41.0 - Tcold,m) / (52.0 - Tcold,m)"
> "fhot,bath = (42.0 - Tcold,m) / (52.0 - Tcold,m)"

https://www.cibse.org/media/jmomfdzb/sap-10-1-specification.pdf

CIBSE-hosted TMV2/NHBC review, verbatim: "This aligns with NHBC
temperatures for baths, showers and wash basin taps that are all
stated with a 40oC requirement"
(https://www.cibse.org/media/0lpif3b1/the-heat-is-on-hot-water-part-2.pdf).
Building Regs Part G3(4)'s 48 C is a scalding **cap**, not a
design value. JP corroboration -- Rinnai 47-prefecture survey via
nippon.com, verbatim: "冬の時期の湯舟の温度は、「40度」31％が最も多く"
(40 C was the most common winter bath temperature at 31%).
Ships **40 C**.

*Cold inlet 12.8 C.* UK SAP 10.1 Table J1, verbatim:

> "Table J1: Cold water temperatures (°C)"
> "From mains: 7.1 8.2 9.4 13.4 15.3 17.6 18.2 17.3 16.1 13.5 10.3 6.8"

Twelve-month mean of the mains-fed row = **12.8 C** (our
arithmetic, not a stated SAP figure). Ships that, as an **annual
average** -- the app applies no seasonal adjustment anywhere else,
so a single constant should be an annual mean, and the retired
10 C was a winter figure that overstated every hot-water cost by
9.33%. JP city cold-water temperatures span ~4-20 C by source
(river vs groundwater); 12.8 C sits inside that range and is the
only tier-1 published annual mean available -- spread in
[archive](./RESEARCH_ENERGY_ARCHIVE.md) 3.1.

| Item | kWh/unit | Unit | Carrier | Confidence |
|------|---------:|------|---------|------------|
| Shower (electric, resistance) | 0.248111 | minute | electricity | Medium-High |
| Shower (electric, heat pump) | 0.057700 | minute | electricity | Medium |
| Shower (gas) | 0.328036 | minute | gas | Medium-High |
| Bath (electric) | 5.692960 | use | electricity | High |
| Bath (gas) | 7.526854 | use | gas | Medium-High |
| Washing up by hand (electric) | 1.992536 | use | electricity | Medium |
| Washing up by hand (gas) | 2.634399 | use | gas | Medium |

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

Derivation: 7.844784 x 0.03162756 = **0.248111 kWh/min**
thermal. Resistance (efficiency 1.0) ships that value directly;
gas / 0.756353 = **0.328036**; heat pump / 4.3 = **0.057700**.

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

**Not shipped, documented:** the self-contained UK electric shower
unit is a third hardware class (~0.15-0.17 kWh/min); the science
sheet names it. Detail in [archive](./RESEARCH_ENERGY_ARCHIVE.md)
3.2.

**Gas hot-water efficiency: 0.756353 on a gross-CV basis.** The
earlier 0.85 was an unsourced
assumption AND was on the wrong calorific basis. Both are now
fixed.

BRE Technical Paper STP09/B07, reporting GASTEC-at-CRE laboratory
tests commissioned by DECC, is the primary. It defines the metric
explicitly:

> "ηDHW = heat content of the useful hot water drawn / heat in
> fuel consumption (net basis)"

and warns against the figure most sources quote:

> "it is vital to realise that measured DHW efficiency (in Table
> 1) is not the same as the water heating efficiency needed for
> SAP (in Table 2)... DWH efficiency is considerably lower because
> it discounts any heat emitted from stored hot water or that used
> by a keep-hot facility"

https://bregroup.com/documents/d/bre-group/stp09-b07_dhw_boiler_tests_2009

Table 1, test A -- instantaneous condensing combi, keep-hot off,
no cylinder, the arrangement this dataset models -- measures
**81.7% (Schedule 2, ~100 L/day) and 85.9% (Schedule 3, ~200
L/day) net**, mean **83.8% net**. Independently corroborated by
BRE CALCM:02 Table 7, which gives instantaneous combis a summer
(DHW-mode) offset of **-11.3 percentage points** against their
rated space-heating efficiency -- confirming the 92-98% ErP
nameplate figures do not apply to hot water.

**The calorific-basis correction.** BRE's efficiencies are
**net CV**; our gas carrier factor (182 g/kWh, decision E2) is
**gross CV**. Pairing them directly understated every gas entry.
Restating the efficiency on a gross basis:

```
eta_gross = eta_net x GCV/NCV = 0.838 x (0.18231 / 0.20199)
          = 0.756353
```

Cross-check, both routes must agree:

| Route | Arithmetic | g CO2e per thermal kWh |
|-------|------------|-----------------------:|
| Gross (shipped) | 1 / 0.756353 x 182 | 240.6 |
| Net | 1 / 0.838 x 202 | 240.6 |
| **Retired (mismatched)** | 1 / 0.85 x 182 | **214.1** |

The three gas entries were therefore **12.6% too low**, and the
published electric-vs-gas crossover moves **214 -> 241 g
CO2e/kWh** (section 2.1). Gross CV stays the shipped convention
because domestic gas bills are issued on it and because METI's
independent cross-check (2.244 kgCO2/m3 at 45 MJ/m3 gross) is on
the same basis.

**Bath volume.** 東京都水道局, verbatim:

> "残り湯は、使用状態によって異なりますが、一般家庭では、約180
> リットルの量があります"
> (leftover bathwater varies with use, but in an ordinary
> household it amounts to about 180 litres)

Ships at **180 L** (JP unit bath, best-sourced, primary market).
European sources converge on 120-150 L (corroboration only); EPA
WaterSense archive's "a bath takes up to 70 gallons" (265 L) is a
rim-full tub, not a fill. 180 x 0.03162756 = **5.692960 kWh**
electric; / 0.756353 = **7.526854** gas. The 150 L European case is a
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

63 x 0.03162756 = **1.992536 kWh** electric; / 0.756353 =
**2.634399 kWh** gas.

**Spread, peer-reviewed:** hand-washing the same load ranges
**18.3-472.8 L** across real households (Schencking & Stamminger
2022, *Tenside Surfactants Detergents* 59(3), Table 1, open
access). A 26x spread -- technique dominates this entry. The
lineage, the litre-basis sensitivity table and what it implies for
the same-carrier rule are in
[archive](./RESEARCH_ENERGY_ARCHIVE.md) 3.3.

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

The plan's "30 C" entry is retired -- no current manufacturer
publishes a full-load 30 C cottons figure
([archive](./RESEARCH_ENERGY_ARCHIVE.md) 4).

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
| Portable electric heater | 1.2 | hour | electricity | Medium |
| Kotatsu | 0.15 | hour | electricity | Medium-High |
| Electric blanket | 0.025 | hour | electricity | Medium |

**Air conditioner: measured, not rated** (this replaces the
first-pass rated values). 資源エネルギー庁
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

**Portable electric heater** (renamed 2026-08-02; "space heater"
is US usage and reads in British English as the whole category of
space heating, which would include a gas-boiler-fed radiator. This
entry is unambiguously a **portable plug-in electric resistance
heater** -- JP 電気ストーブ／セラミックファンヒーター, ES calefactor
electrico portatil. It is not gas and not hydronic.) Office of
Congressional Workplace
Rights (.gov), verbatim: "Average electric space heaters range
from 400-1,500 watts."
https://www.ocwr.gov/publications/fast-facts/portable-space-heaters/
JP ceramic fan heaters run 600-1,200 W in three steps. Ships at
**1.2 kWh/h** (JP high setting); the US nameplate standard is
1,500 W because a 120 V / 15 A circuit caps it there. Basis:
nameplate on high, with thermostatic cycling reducing the true
average once the room is warm.

**Kotatsu ships at 0.15 kWh/h, MEDIUM-HIGH confidence.** The
deadlock (nameplate 300-600 W against an unlabelled "2-3割 lower"
aggregator claim -- [archive](./RESEARCH_ENERGY_ARCHIVE.md) 5.1)
broke on a terminology discovery: kotatsu makers publish 標準（平均）消費電力量 in **Wh**,
which is an already-thermostat-averaged per-hour figure, entirely
separate from the 消費電力 nameplate in W.

メトロ電気工業 (Metro Denki Kogyo, kotatsu heater units since 1963,
whose test method the industry uses) states the method verbatim:

> "こたつ：電気代及び標準平均消費電力量は、室温20℃で厚さ約５cmの綿の
> ふとんを使用し、人が入らない状態で５時間運転した時の１時間あたりの
> 平均値です。"

(per-hour average over a continuous 5-hour run, 20 C room, ~5 cm
cotton futon, nobody inside) --
https://www.kotatsu.metro-co.com/our-kotatsu/

Measured averages across four independent manufacturer-grade
sources (Metro spec, Nitori own site, EDION retail spec,
Yamazen-sourced enechange table): **強 145-180 Wh/h**, **弱 70-90
Wh/h**. EDION verbatim: "●消費電力:510W ●消費電力量/電気代目安
(1時間あたり):[強]約170Wh/約5.3円、[弱]約80Wh/約2.5円" -- note the
510 W nameplate against a 170 Wh/h measured average, a 3x gap.

0.15 kWh/h sits inside the 強 cluster and ships as **the
strong-setting, thermostat-averaged figure**. Resulting ratio to
the portable electric heater: **8.0x** -- unchanged, and now
source-backed rather than resting on an unlabelled aggregator.

**Disclosed judgment call:** a *mixed*-setting average would land
at 0.10-0.12 kWh/h and push the ratio to 10-12x -- the range the
Part 3 plan claimed and this research previously rejected as
unsupported. Not adopted: the 強 framing is better sourced and is
the fairer comparison against a heater run for genuine warmth.
Re-examine if usage data ever shows most users run 中.

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
(245 vs 550, the table's own 458-basis figures) but loses badly
to the heat pump, so the comparison
must always show all four.

**Kerosene is researched but NOT shipped (decision E5).**
環境省 gives 灯油 CO2排出係数 **2.50 t-CO2/kL**
(https://www.env.go.jp/earth/ondanka/gel/ghg-guideline/search/pdf/sankou.pdf);
資源エネルギー庁 gives 2.489 kgCO2/L. The data is now strong
enough to ship whenever wanted.

**Two researched non-entries.** Whole-home gas central heating
(1,530 kWh/yr per 1 C, DECC/CAR) is ~11.5x the aircon entry and
has no per-hour measurement, so it ships as methodology context
only. A refrigerator is **~0.7 kWh/day** (three JIS-measured JP
specs) but you cannot fridge less, so it is a context line, never
a picker item. Both, plus the resolved 3%-vs-10%-per-degree puzzle
and the gas-boiler-vs-heat-pump grid argument, are in
[archive](./RESEARCH_ENERGY_ARCHIVE.md) 5.2-5.3.

### 3.4 Cooking (verified 2026-08-02)

| Item | kWh/unit | Unit | Carrier | Confidence |
|------|---------:|------|---------|------------|
| Kettle, boil 1 L | 0.116278 | use | electricity | Medium-High |
| IH hob, boil 1 L | 0.116598 | use | electricity | Medium-High |
| Gas hob, boil 1 L | 0.282389 | use | gas | Medium |
| Oven | 0.82 | use (bake cycle) | electricity | Medium |
| Microwave | 0.019 | minute | electricity | Medium |
| Rice cooker, cook cycle | 0.16 | use | electricity | High |
| Rice cooker, keep warm (保温) | 0.0165 | hour | electricity | High |

**Physics floor, boiling 1 L from 15 C:** 1.000 kg x 4.186
kJ/(kg-K) x 85 K = 355.81 kJ / 3600 = **0.09883611 kWh**. Every
boil entry is this floor divided by a sourced efficiency.
(Specific heat cross-checked against NIST-JANAF, within 0.2% --
[archive](./RESEARCH_ENERGY_ARCHIVE.md) 6.1.)

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

**Oven: 0.82 kWh per bake cycle, unit `use` not `hour`.** No
per-hour oven figure exists anywhere, and that is structural, not
a gap to fill: DOE never adopted an active-mode oven standard and
ENERGY STAR does not certify ovens
([archive](./RESEARCH_ENERGY_ARCHIVE.md) 6.2). **Nobody publishes
an oven duty cycle because ovens are not operated by the hour.**
So the entry ships per bake cycle on the
tier-1 EU anchor: **Commission Regulation (EU) No 66/2014**
(ecodesign requirements for domestic ovens, hobs and range
hoods), Annex II, verbatim -- number corrected 2026-08-29, when
the linked PDF was re-fetched and read: it is OJ L 29/42-44 of
31.1.2014, its Annex II is "Measurements and calculations", and
it covers hobs, which 65/2014 (labelling) does not. The URL was
right all along; only the name was wrong:

> "SEC_electric cavity = 0,0042 × V + 0,55 (in kWh)"

https://webgate.ec.europa.eu/reqs2/public/v2/requirement/auxi/eu/32014R0066_energcook_annex_2.pdf
-> 60 L: 0.802 kWh, 65 L: 0.823, 70 L: 0.844 per standardised
EN 60350-1 bake cycle. **Ships 0.82**, the midpoint of the 60-70 L
range that covers most built-in and freestanding ovens.

Cross-validated against DOE's own abandoned rulemaking: the 2009
TSD baseline for a freestanding standard electric oven is
**274.9-370.0 kWh/year** (via 2015 NOPR Table IV-9), which at a
plausible 200-350 cycles/year implies ~0.8-1.85 kWh/cycle --
consistent with the EU figure, especially given larger US
cavities. Confidence Medium, not High: it is a cross-jurisdiction
EU-to-US proxy, and `calculation_notes` must say so.

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

**Television -- now tier-1.**
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
Independence and Security Act of 2007 (EISA)". **Japan never
legally banned incandescents** -- a blanket "phased out" claim is
false for a JP reader (archive 1).

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

Per-device draw collapsed, device counts exploded, household total
held roughly steady.

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
values unrounded; the UI rounds for display.** Decisions E1-E6
are all applied: E1 resolved on 2026-08-02, so every electricity
row below already sits on the 458 g CO2e/kWh basis.

| id | Behavior | kWh/unit | Unit | Carrier | Group | Conf. |
|----|----------|---------:|------|---------|-------|-------|
| shower_electric | Shower (electric water) | 0.248111 | minute | electricity | hot_water | Med-High |
| shower_heatpump | Shower (heat-pump water) | 0.057700 | minute | electricity | hot_water | Med |
| shower_gas | Shower (gas water) | 0.328036 | minute | gas | hot_water | Med-High |
| bath_electric | Bath (electric water) | 5.692960 | use | electricity | hot_water | High |
| bath_gas | Bath (gas water) | 7.526854 | use | gas | hot_water | Med-High |
| washup_electric | Washing up by hand (electric) | 1.992536 | use | electricity | dishes | Med |
| washup_gas | Washing up by hand (gas) | 2.634399 | use | gas | dishes | Med |
| dishwasher_eco | Dishwasher, eco | 0.85 | use | electricity | dishes | High |
| dishwasher_normal | Dishwasher, normal | 1.12 | use | electricity | dishes | High |
| wash_cold | Washing machine, cold (20 C) | 0.350 | use | electricity | laundry_wash | High |
| wash_warm | Washing machine, warm (40 C) | 1.300 | use | electricity | laundry_wash | High |
| wash_hot | Washing machine, hot (60 C) | 1.700 | use | electricity | laundry_wash | High |
| dryer_vented | Tumble dryer (vented/condenser) | 4.5 | use | electricity | laundry_dry | High |
| dryer_heatpump | Tumble dryer (heat pump) | 2.05 | use | electricity | laundry_dry | High |
| line_dry | Line drying | 0 | use | none | laundry_dry | High |
| aircon_heating | Air conditioner, heating | 0.241006 | hour | electricity | space_heat | High |
| portable_electric_heater | Portable electric heater | 1.2 | hour | electricity | space_heat | Med |
| kotatsu | Kotatsu | 0.15 | hour | electricity | space_heat | Med-High |
| electric_blanket | Electric blanket | 0.025 | hour | electricity | space_heat | Med |
| aircon_cooling | Air conditioner, cooling | 0.167679 | hour | electricity | space_cool | High |
| kettle | Electric kettle, 1 L | 0.116278 | use | electricity | boil | Med-High |
| ih_hob | IH hob, boil 1 L | 0.116598 | use | electricity | boil | Med-High |
| gas_hob | Gas hob, boil 1 L | 0.282389 | use | gas | boil | Med |
| oven | Electric oven | 0.82 | use (bake cycle) | electricity | cook | Med |
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

Owner decisions **E1-E6 all resolved 2026-08-02**. The values they
produced are in the table above; the decisions themselves, their
rationale and the derived standing rules live in
[PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md) section 2.


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
| portable_electric_heater, kotatsu, electric_blanket | An evening (4 h) | 4 | -- |
| kettle, ih_hob, gas_hob | 1 litre | 1 | -- |
| kettle, ih_hob, gas_hob | A mug (0.3 L) | 0.3 | -- |
| oven | 1 bake | 1 | EU EN 60350-1 standard cycle, 0.82 kWh |
| oven | 2 bakes | 2 | -- |
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

1. `bath_electric` is the maximum per single use **among the
   electricity entries** (5.693; margin vs #2 `dryer_vented` 4.5 =
   +26%). Margin narrowed by the 9.3 delta-T correction --
   re-derive before adding any entry above 4.5. Scope clarified
   2026-08-29: `bath_gas` carries a larger *kWh* (7.527) for the
   same delivered hot water, because a gas figure is fuel input
   divided by the 0.756353 efficiency. Never rank a gas kWh
   against an electric one; the carbon comparison is what the two
   carrier factors are for.
2. Hot-water chain: `bath_electric > 10 x shower_electric >
   kettle > phone_charge` (5.693 > 2.481 > 0.116 > 0.0153).
   Thinnest link bath vs 10-min shower at **+129%** -- a ratio,
   so unaffected by the delta-T correction.
3. `shower_electric > 4 x shower_heatpump` (0.248111 > 0.230801,
   +7.5%) -- thin; the COP-4.3 mean is the fragile input.
   Annotate.
4. `dryer_vented > 2 x dryer_heatpump` (4.5 > 4.10, +10%) --
   thin but source-backed. Most likely pin to move.
5. Wash chain: `wash_hot > wash_warm > 2 x wash_cold`
   (1.700 > 1.300 > 0.700). Thinnest link hot vs warm at +31%.
6. `portable_electric_heater > 5 x kotatsu` (1.2 > 0.75, +60%).
   Actual ratio
   8.0x. **The plan's "~10x" does not survive the research.**
7. `portable_electric_heater > 4 x aircon_heating`
   (1.2 > 0.964, +24%).
   Actual ratio 4.98x -- the flagship heating lesson.
8. `incandescent_bulb > 4 x led_bulb` (0.06 > 0.034, +76%).
   Actual ratio 7.06x.
9. `dishwasher_normal < washup_electric` (1.12 < 1.993, -44%) --
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
    `comparable_group`; every group has >= 1 member; the shipped
    group distribution is hot_water 5, dishes 4, laundry_wash 3,
    laundry_dry 3, space_heat 4, space_cool 1, boil 3, cook 4,
    lighting 2, device 4. **Units are pinned per behavior, not per
    group** -- corrected 2026-08-29, when the build found the
    earlier "no group spans more than one unit" rule does not hold
    and cannot: the unit follows each behavior's physics, so
    `hot_water` mixes minute with use, `cook` mixes use, minute and
    hour, and `device` mixes hour, use and day, while `laundry_dry`
    (named as an exception in the old wording) does not mix at all.
    The per-behavior pin is the stronger guard anyway, and it is
    what catches the oven being "corrected" back to an hourly
    unit.
15. **Assembled-value pins** (RV-1 pattern -- judgment-call
    values unreachable by any ordering pin, so a silent revert
    would otherwise pass the suite): `kotatsu` 0.15 (not the
    0.3-0.6 nameplate), `portable_electric_heater` 1.2 (not 1.5),
    `standby` 0.8 (not
    1.78), `gas_hob` 0.282389 (efficiency 0.35, not 0.32 or
    0.42), `dryer_vented` 4.5 (not the model-specific 4.63),
    `oven` 0.82 (the EU 60-70 L midpoint, not 1.0/hour and not the
    2.0 nameplate),
    **`aircon_cooling` 0.167679 and `aircon_heating` 0.241006
    (METI measured -- NOT the Panasonic JIS rated 0.435 / 0.455,
    which a well-meaning future edit would "correct" them to)**.

### Never pin / never generate superlative copy

All of these are blocked structurally by the PDR sec 3 rule;
the list records why.

- **kettle vs IH hob** (0.116278 vs 0.116598, **0.3%**) -- an
  exact tie, deliberately. 44.9 g vs 45.0 g. The dataset's
  flagship "this choice does not matter" pair. Fails rule #3.
- **gas hob vs kettle/IH in CO2** (51.4 g vs 44.9/45.0, +14%) --
  2.4x the kWh, 14% the CO2. Flips under E1. Fails rule #2.
- **washup_gas vs dishwasher_normal** (480 g vs 513 g, +7%) --
  the dishwasher wins clearly against an electric sink (913 g) and
  loses narrowly to a gas one on the shipped Which? basis. Under
  the peer-reviewed Berkholz 2010 UK litre figure the gas sink wins
  by 37% (3.1). Fails rule #2 twice over: wrong carrier AND
  source-dependent direction.
- **shower_gas vs shower_electric** (59.7 vs 113.6 g/min) -- a
  real 1.9x gap that reverses in the UK (section 2.1). Fails
  rule #2.
- **bath_gas vs bath_electric** -- same reason.
- **aircon_cooling vs aircon_heating** (0.167679 vs 0.241006,
  +44%) -- above the delta threshold but different groups
  (`space_cool` vs `space_heat`); comparing them is meaningless.
  Fails rule #1.
- **laptop_charge vs incandescent_bulb per hour** (0.063294 vs
  0.06, +5.5%) -- fails #1 and #3.
- **oven vs portable_electric_heater** (0.82/use vs 1.2/hour) --
  different units as well as different groups; no longer
  comparable at all. Fails #1.
- **wash_hot vs dishwasher_normal** (1.700 vs 1.12) -- different
  loads entirely. Fails #1.
- **tv vs anything outside `device`** -- fine within group, but
  the entry is a scale anchor, not a target; no superlatives.
- **dishwasher_eco vs dishwasher_normal** (0.85 vs 1.12, +32%) --
  PASSES all three rules and may be compared, but the copy must
  note eco takes 3h15 so it does not read as a free win.

---

## 7. Action-Data Consistency

The action library and this dataset must never quote different
numbers for the same behaviour. As of 2026-08-02 they do not:
`data/seed/co2_actions_database.json` is the single source of
truth for actions, the seeder reads it, and every energy action is
derived from an entry in section 3.

Coverage note: the table below derives 12 actions across two
categories (`energy` and `water`). Two energy actions sit outside
it. `turn_off_lights` carries its derivation in its own
`calculation_notes`, re-based 2026-08-29 onto this document's
8.5 W / 800 lm LED after the 40 W bulb it previously used was
found to appear nowhere here (section 3.5 ships that LED and a
60 W incandescent comparator, nothing between); its former
sibling `use_natural_light` was demoted over the same gap.
`full_laundry_load` was **archived 2026-08-29** for having no
derivation anywhere: no partial-load washing measurement exists in
this document, and the Bosch WNA14400GR table that supplies all
three wash temperatures is a max-load (9.0 kg) table only. Both
archivings are recorded in
[PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md) section 8
and in [archive](./RESEARCH_ENERGY_ARCHIVE.md) 1. Nothing on the
energy side is open.

The reconciliation table, the citation error it uncovered, and the
four duplicate proposals it killed are recorded in
[PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md) section 4 --
that is product record, not evidence, so it lives there.

What belongs here is the derivation of each shipped action value
from a dataset entry:

| Action | g CO2e | Derived from |
|--------|-------:|--------------|
| `air_dry_clothes` | 2000 | `dryer_vented` 4.5 kWh x 458 = 2061, down |
| `cold_wash` | 430 | `wash_warm` 1.300 - `wash_cold` 0.350 = 0.950 x 458 = 435, down |
| `shorter_shower` | 110 | 2 min x 59 g/min (gas carrier floor) = 118, down |
| `shorter_bath` | 770 | `bath_gas` 7.526854 - 10-min `shower_gas` 3.28036 = 4.2465 x 182 = 773, down |
| `unplug_devices` | 25 | 5 devices x 0.5 W x 24 h = 0.06 kWh x 458 = 27.5, down |
| `install_led_bulb` | 25000 | (`incandescent_bulb` 0.06 - `led_bulb` 0.0085) x 3 h/day x 365 = 56.4 kWh x 458 = 25820, down |
| `lower_thermostat` | 140 | METI 53.08 kWh/yr / 169 d = 0.3141 kWh/day x 458 = 144, down |
| `raise_ac_thermostat` | 120 | METI 30.24 kWh/yr / 112 d = 0.2700 kWh/day x 458 = 124, down |
| `eco_mode_appliance` | 120 | `dishwasher_normal` 1.12 - `dishwasher_eco` 0.85 = 0.27 x 458 = 124, down |
| `microwave_vs_oven` | 280 | `oven` 0.82 - `microwave` 0.19 = 0.63 x 458 = 289, down |
| `heat_person_not_room` | 1900 | (`portable_electric_heater` 1.2 - `kotatsu` 0.15) x 4 h = 4.2 kWh x 458 = 1924, down |
| `use_fan_instead_of_ac` | 600 | (`aircon_cooling` 0.167679 - fan 0.022) x 9 h = 1.311111 kWh x 458 = 600.5, down. Fan is the Panasonic F-CV339 DC living fan at its highest notch (22 W, https://panasonic.jp/fan/products/F-CV339/spec.html); 9 h/day is METI's own basis on the aircon page (sec 3.3). Added 2026-08-09, replacing an unsourced 1200 |

Every value rounds **down** to two significant figures --
honest-not-generous, since each is a claimed saving.

### Carrier floor convention

`shorter_shower` and `shorter_bath` cover hot water whose carrier
the app cannot know. Three configurations exist -- resistance
electric, gas, heat pump -- spanning ~4x. Both ship the **gas**
figure, not the absolute heat-pump floor: gas and resistance
electric are the two dominant configurations globally, gas is the
lower of that pair at the current grid factor, and heat-pump
owners are a documented minority the methodology names. Using the
heat-pump floor would make every hot-water action look trivial for
the majority who do not have one.

---

## 8. Standing Rules

Nothing is open. Every item raised by either research pass is
closed and recorded in
[archive](./RESEARCH_ENERGY_ARCHIVE.md) 1. What remains here is
permanent by design, never "done".

- **Yearly DEFRA refresh:** re-read the natural-gas Gross CV
  combustion row at each release, alongside Part 1's transport
  refresh.
- **Measured-over-rated guard** (prohibition): the aircon entries
  must never be "corrected" to their JIS catalog ratings, nor the
  kotatsu to its nameplate. Sanity pins catch both.
- **Calorific-basis guard:** the gas factor and the hot-water
  efficiency must always be on the same CV basis.
- **SEARCH-ONLY guard** (prohibition): a figure seen only in a
  search-engine summary may not enter `sources[]`.
- **Physics entries never need refreshing.** Only the assumptions
  around them (flow rate, delta-T, efficiency) can age.

---

## 9. The Headline Number

The full 38-item recomputation of every shipped value, with its
CO2 and its confidence, is in
[archive](./RESEARCH_ENERGY_ARCHIVE.md) 8. Its conclusion:

**Heat-vs-light hierarchy, the number that justifies Part 3:**

| Behavior | kWh | g CO2 | vs one LED-hour |
|----------|----:|------:|----------------:|
| Bath | 5.693 | 2607 | 670x |
| Tumble dryer (vented) | 4.5 | 2061 | 529x |
| Shower, 10 min (resistance) | 2.481 | 1136 | 292x |
| Wash 60 C | 1.700 | 779 | 200x |
| Portable electric heater, 1 h | 1.2 | 550 | 141x |
| Oven, 1 bake cycle | 0.82 | 376 | 96x |
| Shower, 10 min (heat pump) | 0.577 | 264 | 68x |
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

**Anything that makes or moves heat costs 20-670x anything that
makes light or computation.** The plan predicted 10-100x. A bath
is 373 phone charges -- and a heat pump moves the same heat for a
quarter of the carbon, which is the second lesson the dataset now
teaches by itself.

