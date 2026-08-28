# Home Energy Research -- Archive (executed detail)

**Archived:** 2026-08-08, extended 2026-08-29. Long-form content
moved out of [RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) (sections
1-8) and [PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md)
(section 9), so both stay concise. Everything here is EXECUTED or
CLOSED; nothing below is a live instruction. The shipped factor
tables, dataset values, sanity invariants and standing rules stay
in RESEARCH_ENERGY.md; the live decisions, product rules and
UI/copy requirements stay in the PDR.

Same split as
[PDR_TRANSPORT_ARCHIVE.md](./PDR_TRANSPORT_ARCHIVE.md) and
[PDR_FOOD_ARCHIVE.md](./PDR_FOOD_ARCHIVE.md).

Reading notes: "sec N" and bare section numbers refer to
RESEARCH_ENERGY.md, not to this file. The `9.x` item numbers are
the first research pass's own labels, kept because the working
notes use them; section 1 below is the definitive list.

---

## 1. Closed Research Items

Every item raised by either research pass, one line each. The
arithmetic and citations live in the section named.

| Item | Outcome | Where |
|------|---------|-------|
| Fetch-blocked sources | Worked around. `curl -A "Mozilla/5.0..." \| pdftotext` defeats energystar.gov and the Federal Register gateway; a real browser session loads enecho.meti.go.jp, ember-energy.org, iea.org, epa.gov, standby.lbl.gov. Still hard-blocked: energysavingtrust.org.uk, nrdc.org, downloads.regulations.gov, EUR-Lex (use the legislation.gov.uk mirror). No shipped value rests on a SEARCH-ONLY figure. | [ANNUAL_RESEARCH_UPDATE.json](./ANNUAL_RESEARCH_UPDATE.json) |
| Gas DHW efficiency | BRE STP09/B07 GASTEC lab tests: 81.7-85.9% net for an instantaneous condensing combi. Also fixed a calorific-basis mismatch -- shipped efficiency is **0.756353 gross**, gas entries rose 12.6%, crossover moved 214 -> 241 g/kWh. | sec 3.1 |
| Water temperatures | Delivered **40 C** (NHBC design standard via CIBSE; JP Rinnai survey agrees). Cold inlet **10 -> 12.8 C**, the twelve-month mean of SAP 10.1 Table J1. delta-T 30 -> 27.2 K, all seven hot-water entries -9.33%. | sec 3.1 |
| Fridge context | Three JIS-measured manufacturer specs put a modern JP fridge at **~0.7 kWh/day**, not the "roughly 1 kWh" previously stated. | sec 3.3 |
| Oven | Closed structurally -- no per-hour figure exists anywhere because DOE never adopted an active-mode oven standard and ENERGY STAR does not certify ovens. Unit changed `hour` -> `use` at **0.82 kWh per bake cycle**. | sec 3.4 |
| Incandescent phase-out | Changes the copy rule: **Japan never legally banned them**. US 45 lm/W since 2022-07-25; EU halogen exemptions closed 2023-09-01. A blanket "phased out" claim is false for a JP reader. | sec 3.5, PDR sec 5 |
| Bonn dishwashing | Closed via the authors' own open-access 2022 review, whose Table 1 collects the measured figures from all three underlying studies. Replaces the second-hand 33-440 L spread with **18.3-472.8 L**. | sec 3.1 |
| Berkholz et al. 2010 primary | Closed for practical purposes. *Int. J. Consum. Stud.* 34, 235-242 is paywalled with no OA copy; the 2022 review above carries its figures. | sec 3.1 |
| Kotatsu | Makers publish 標準（平均）消費電力量 in Wh -- already thermostat-averaged. Shipped 0.15 sits inside the 強 cluster (145-180 Wh/h); confidence LOW -> **MEDIUM-HIGH**, 8.0x ratio holds. Cross-checked from METI's 強->中 delta of 0.0579 kWh/h, implying 中 = 0.092, inside the enechange 中 band. | sec 3.3 |
| 電気カーペット | Closed 2026-08-08 as a deliberate non-entry. Panasonic's comparison table publishes per-setting 消費電力量 in Wh (3畳 DC-3NK **470/335**, DC-3HA 460/320; 2畳 335/230; 1畳 165/120), so 中 = **~0.33 kWh/h** -- 3.6x the kotatsu, a quarter of the portable heater. Stays folded into `heat_person_not_room`, whose arithmetic it does not touch. METI's 強->中 delta (0.2201) is ~60% above Panasonic's 0.135 and models higher-draw carpets: upper bound only. | https://panasonic.jp/danbo/comparison.html |
| UK gas central heating | Closed 2026-08-02 as a deliberate non-entry: no per-hour measurement exists, and at ~11.5x the aircon entry it would break the picker's implied comparability. Researched figures ship as methodology context. | sec 3.3 |
| `full_laundry_load` action | Closed 2026-08-29 with **no current definitive answer**, and archived out of the shipping action set into `research_only_records`. The retired 300 g rested on the bare note "avoids ~35% wasted energy/load": no factor, no arithmetic, no source, and the E1 rebase never touched it, so its basis is unknown and may predate 458. This document cannot replace it -- sec 3.2 holds no partial-load washing figure, because the Bosch WNA14400GR table behind all three wash temperatures is max-load (9.0 kg) only, and the dryer half-load figure is a different appliance from the one the action names. The one "35%" here is the **gas hob efficiency** in sec 3.4, unrelated: a coincidence, not a lineage. Restore only with a measured partial-load figure for the same programme; cheapest first check is whether the manufacturer documents already cited declare a half or quarter-load row. | sec 3.2, 3.4 |
| `phoneCharges` equivalency | Closed 2026-08-02, no change. EPA's 8 g is an independent US-grid figure, not a stale mirror of this dataset's 7 g (iPhone 15 12.98 Wh / 0.85 x 458). 13% apart, both defensible; unlike `burgers` it claims no match. | `impact_equivalencies.json` |

---

## 2. Grid Factor Survey (decision E1)

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

---

## 3. Hot Water

### 3.1 JP cold-water regional spread

Regional spread, disclosed: Tokyo Waterworks reports "最高水温は
7月の29.5℃で、最低水温は2月の8.3℃です。" (max 29.5 C in July, min
8.3 C in February). A SHASE conference paper fitting 2013-2019
treatment-plant records across 42 Japanese cities finds
river/snowmelt-fed Fukushima at "7℃～11℃程度" dropping to ~4 C in
February-March, while groundwater-fed Kumamoto holds "年間を通して
20℃前後" (~20 C year-round)
(https://www.jstage.jst.go.jp/article/shasetaikai/2021.1/0/2021.1_33/_pdf).
No JP national annual average was obtainable; 12.8 C sits inside
the JP city range and is the only tier-1 published annual mean
available. Open follow-up: average Tokyo's own monthly series if
a JP-weighted figure is ever wanted.

---

### 3.2 Why water heating splits into two electric entries, and the UK shower unit

Same carrier, same group, 4.3x delta -- so the E2 rule *permits*
the heat-pump verdict, which is the largest single lever in the
dataset. An averaged single entry would have said nothing.

**Not shipped, documented:** the self-contained electric shower
unit (UK-common) is power-capped at 7.5-10.5 kW, which physically
restricts flow to ~4-4.5 L/min at delta-T 30, giving ~0.15-0.17
kWh/min. It is a third hardware class; the science sheet names
it.

---

### 3.3 Bonn dishwashing lineage and litre-basis sensitivity

**Peer-reviewed cross-check and spread (item 9.10, closed
2026-08-02).** The Bonn lineage is now sourced properly. The
secondary retellings that disagreed with each other were all
garbled versions of three real studies, which a Schencking &
Stamminger review collects into one table:

Schencking, L. T. F. & Stamminger, R. (2022), "What science knows
about our daily dishwashing routine", *Tenside Surfactants
Detergents* 59(3), open access,
https://doi.org/10.1515/tsd-2022-2423 -- Table 1, verbatim
transcription (a data-table row transcription, not a page
sentence):

| Study | Consumer | Dishwasher |
|-------|---------|-----------|
| Stamminger et al. 2007 (113 participants, 7 countries) | 103 L / 2.5 kWh / 79 min | 15 L / 1.0 kWh / 100-150 min |
| Berkholz et al. 2010 (150 UK residents, representative) | 49.2 / 44.1 L, 1.7 / 1.4 kWh (mean/median) | 13.2 / 12.4 L, 1.3 kWh (ECO 50) |
| Berkholz et al. 2013 (29 countries) | 34.7-160.1 L, 0.9-4.6 kWh (median range) | 12.0-17.7 L, 0.7-1.6 kWh |

Method, verbatim: "The participants were asked to wash a full load
of 140 individual items in a laboratory environment. The dishes
were soiled according to EN 50242:2003 [23] and air-dried for 2 h
beforehand. A dishwasher was run in a programme recommended for
normally soiled dishes in parallel to the experiment."

Verdict, verbatim: "The participants required different amounts of
the resources time, energy and water, but on average performed
poorer than the dishwasher in all points".

Spread, verbatim (this **replaces** the previously cited 33-440 L
figure, which was a secondary retelling): "the individual water
consumption ranged from 18.3 L to 472.8 L for the same number of
soiled dishes". A **26x spread across real households** --
technique (bowl vs running tap) dominates everything else in this
entry.

Primary citations: Berkholz, P., Stamminger, R., Wnuk, G., Owens,
J., Bernarde, S., "Manual dishwashing habits. An empirical
analysis of UK consumers", *Int. J. Consum. Stud.* 2010, 34,
235-242, https://doi.org/10.1111/j.1470-6431.2009.00840.x
(paywalled, HTTP 402, no OA copy exists -- confirmed via OpenAlex
and Semantic Scholar); Berkholz, P., Kobersky, V., Stamminger, R.,
*Int. J. Consum. Stud.* 2013, 37, 46-58,
https://doi.org/10.1111/j.1470-6431.2011.01051.x; Stamminger, R.,
Elschenbroich, A., Rummler, B., Broil, G., "Dishwashing Under
Various Consumer-Relevant Conditions", *Hauswirtschaft und
Wissenschaft*, 2007, pp. 81-88.

**Litre-basis sensitivity -- shipped value UNCHANGED, but the
comparison is more carrier-dependent than it looked.** Berkholz
2010's UK laboratory measurement (49.2 L mean, 44.1 L median for a
140-item load) is *lower* than Which?'s 63 L, while the two agree
almost exactly on the dishwasher side (13.2 L vs ~13 L), so the
loads are comparable and the difference is real:

| Hand-wash basis | Electric | Gas | vs `dishwasher_normal` (513 g) |
|-----------------|---------:|----:|-------------------------------:|
| **Which? 63 L (shipped)** | 913 g | 479 g | gas sink loses by 7% |
| Berkholz 49.2 L | 713 g | 374 g | **gas sink WINS by 37%** |
| Berkholz 44.1 L | 639 g | 336 g | gas sink wins by 53% |
| Stamminger 103 L | 1492 g | 784 g | gas sink loses by 35% |

Which? 2026 stays shipped: it measures both sides on one current
14-place-setting basis, and 63 L is the conservative choice for
the entry's own footprint. But under the peer-reviewed UK figure a
gas-heated sink beats the dishwasher by 37%, which is far above
the 20% verdict threshold. **This is the strongest evidence yet
for the same-carrier rule in 2.2** -- the dishwasher's advantage
is not a fact about dishwashers, it is a fact about how the sink
water is heated and whose measurement you use.

---

## 4. Laundry: the retired 30 C entry

The plan's "30 C" entry is retired: no current manufacturer
publishes a full-load 30 C cottons figure (30 C appears only on
2 kg delicates programmes), and the 0.40 kWh figure circulating
for it traces to a 2006 Öko-Institut 5 kg study reached only via
a secondary citation. A "20-30 C" range label was rejected as
well -- it would be a 20 C measurement wearing a 30 C name, and
20 -> 40 is too non-linear to interpolate (the 20 C programme
barely heats). Shipping the three verbatim temperatures preserves
the low/warm/high framing with nothing invented.

---

## 5. Climate

### 5.1 Kotatsu: the pre-closure evidence

**Kotatsu -- the weakest number in the dataset.**

| Value | Basis | Source |
|-------|-------|--------|
| 300-600 W | "主なこたつの消費電力" (typical rating) | SoftBank でんき, https://www.softbank.jp/energy/saving/kotatsu/ |
| quartz 80-145 W, halogen 70-180 W, flat carbon 50-110 W | low-to-high setting, by heater type | https://enechange.jp/articles/kotatsu-cost |
| "実際の平均消費電力は表示より2〜3割低い" | average vs rating | unlabelled aggregator, **not re-verifiable** |

SoftBank でんき verbatim: "主なこたつの消費電力は300W～600W程度です。"

---

### 5.2 Whole-home gas central heating (researched, not shipped)

**Whole-home gas central heating -- context only, never a picker
item** (gap closed 2026-08-02; the honest answer was "do not ship
an entry"). UK space heating is ~60% of a household's energy and
the dataset had nothing for a gas boiler driving radiators. It
still ships nothing, for two reasons that matter more than the
coverage gap:

1. **No METI-equivalent measurement exists.** The aircon entries
   work because METI published an absolute delta on a fixed
   protocol. The best UK figure is a whole-stock annual model
   output, not a per-hour rate; producing `kWh/h` from it would
   require inventing a heating-hours denominator the source does
   not make.
2. **Scale breaks comparability.** Every other entry is a single
   appliance, single instance. Whole-home heating outweighs the
   aircon entry ~11.5x per degree and everything else by more.
   Putting it in the same picker implies a flatness that is false.

The figure, and it is worth stating loudly in the methodology:

> DECC / Cambridge Architectural Research (Nov 2012), verbatim:
> "Turn thermostat down by 1ºC from 19 to 18ºC. Our original
> estimate of the energy saving from this behaviour, based on
> modelling using the CHM, was a 'most likely' value of 1,530 kWh
> per household per year, or 13% of space heating energy."

https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/128720/6923-how-much-energy-could-be-saved-by-making-small-cha.pdf

Modelled with the Cambridge Housing Model over 16,150 English
Housing Survey dwellings; it is gas-meter kWh on a Gross CV basis
(the model applies real heating-system efficiency), so it pairs
directly with the 182 g/kWh factor with no conversion.
**1,530 kWh x 182 = 278.9 kg CO2e per year per 1 C**, against
**24.3 kg** for the shipped JP room-aircon setpoint effect --
**11.5x**. Independent cross-check: Energy Saving Trust's "turning
down your thermostat from 22°C to 21°C can save £90 a year in GB"
(Wayback snapshot 2026-04-17; the live site is hard-blocked)
implies ~1,624 kWh at Ofgem's 5.54p/kWh -- within 6%, 13 years
apart. Vintage caveat: 2012 housing stock.

**The 3%-vs-10%-per-degree puzzle is resolved, and one of our own
actions was wrong.** They measure different behaviours. US DOE,
verbatim: "You can save as much as 10% a year on heating and
cooling by simply turning your thermostat back 7°-10°F for 8 hours
a day from its normal setting" -- a large, partial-day *setback*
in Fahrenheit. 環境省's "約10%" is a small, continuous 1 C change.
**DOE never states "3% per degree"**, which is what the shipped
`lower_thermostat` and `raise_ac_thermostat` actions cited it for;
those now use METI's measured values instead (section 7).

**Gas boiler vs heat pump, and why the global factor hides it.**
SAP 10 Technical Paper S10TP-12 Table 3 gives condensing-boiler
**space-heating** efficiency as **87.1% gross** (modulating, no
weather compensation, 80/60 flow -- the realistic median UK
install), notably better than the 75.6% gross this dataset uses
for hot water. The Electrification of Heat demonstration project
measured **median ASHP SPFH4 = 2.78** across 428 real UK
installations
(https://esc-production-2021.s3.eu-west-2.amazonaws.com/wp-content/uploads/2024/12/18083511/EoH-Project-Summary-Report.pdf).
Chaining those (illustrative, not measured -- it applies a modern
efficiency to a 2012-stock demand figure): the same 1 C is ~479
kWh of electricity for a heat pump, so gas is **4.44x worse at the
UK's own 131 g/kWh grid but only 1.27x worse at our global 458**.
Any UK heat-pump copy must use the UK grid factor or it
understates the case by 3.5x. This is the sharpest argument yet in
[PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md).

---

### 5.3 Refrigerator context

**Refrigerator -- context line only, never a picker item** (item
9.6 closed 2026-08-02). You cannot fridge less. The previous
"roughly 1 kWh a day" was too high; three tier-1 JIS-measured
manufacturer specs put a modern JP fridge lower:

| Model | Capacity | kWh/year | kWh/day |
|-------|---------:|---------:|--------:|
| Panasonic NR-F454HPX | 450 L | 249 | 0.68 |
| Hitachi R-XG48K | 475 L | 258 | 0.71 |
| Hitachi R-XG43K | 430 L | 287 | 0.79 |

Panasonic verbatim: "年間消費電力量★1　50Hz　249kWh/年" measured
"新JIS測定・計算方式　（JIS C 9801-3: 2015）　に基づく表示"
(https://panasonic.jp/reizo/products/NR-F454HPX/spec.html).

**Ships as ~0.7 kWh/day** for the JP/modern case. Western
comparison, ENERGY STAR ProductFinder (tier-1, verbatim "Annual
Energy Use (kWh/yr) ... 452" for an 18.0 ft3 unit): modern
efficient US units run **1.1-1.25 kWh/day**, and the US installed
average is higher again (~1.8 kWh/day, derived from an EIA cost
figure -- SEARCH-ONLY, label it if used). Copy should give the
modern figure, not the installed average.

---

## 6. Cooking

### 6.1 NIST Shomate cross-check of the water constant

Specific heat cross-checked against NIST-JANAF Shomate
coefficients for liquid water (A = -203.6060, B = 1523.290,
C = -3196.413, D = 2474.455, E = 3.855326, valid "298. to 500."
K), https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&Type=JANAFL --
extrapolated to 288 K gives 4.194 kJ/(kg-K), within 0.2%.

---

### 6.2 Oven: why no per-hour figure exists anywhere

**Oven: 0.82 kWh per bake cycle, unit changed from `hour` to
`use` (item 9.8, closed 2026-08-02).** The research established
that no per-hour figure exists *anywhere*, and that this is
structural rather than a gap to fill: DOE's cooking-products test
procedure (10 CFR 430 Subpart B Appendix I1) covers only cooking
**tops** -- verbatim, "Perform the following test methods for
conventional cooking tops and the conventional cooking top
component of a combined cooking product" -- and 10 CFR 430.32
contains no active-mode oven consumption limit at all. DOE
proposed one in 2015 (80 FR 33030) and never finalised it, and in
May 2025 (90 FR 20885) proposed rescinding even the narrow design
requirements. ENERGY STAR does not certify residential ovens
either, for the same stated reason: use-pattern variability.

---

### 6.3 Oven: what the unit change bought

For a single ~50-minute bake the two framings converge (0.82 kWh
/ 1.0 kWh/h = 49 min), so the point estimate barely moves. The
gain is structural: the app stops asking users to estimate
oven-hours, which nobody tracks, and counts uses, which they
know.

---

## 7. Standby: framing confirmation

This is the authoritative statement of both the magnitude and the
mechanism, and it confirms the framing the first pass inferred
from Meier & Siderius 2017: **per-device draw collapsed, device
counts exploded, household total held roughly steady.**

---

## 8. ENERGY_LOGIC_CHECK (full 38-item recomputation)

Water constant: 4.186 / 3600 = 0.001162777 kWh/(L-K); x 30 K =
0.03162756 kWh/L (delta-T 27.2 K). CO2 at **458** (electricity) /
**182** (gas)
g/kWh, per decision E1.

1. **Shower (electric) = 0.248111/min.** Flow 7.844784 L/min
   (mean of 6.5 / 7.570824 / 9.463529) x 0.03162756 / 1.0. Per
   minute **113.6 g**; per 10-min shower 2.481 kWh = **1.14 kg**.
   Medium-High.
2. **Shower (heat pump) = 0.057700/min.** / COP 4.3. **26.4
   g/min**; a 10-minute shower is **0.26 kg** -- a quarter of the
   resistance case and the largest single lever in the dataset.
   Medium.
3. **Shower (gas) = 0.328036/min.** / 0.756353 (gross-CV DHW
   efficiency, 3.1). **59.7 g/min.** Uses **32% more energy** than
   resistance electric, emits **47% less carbon** -- at 458.
   Reverses below a 241 g/kWh grid (2.1). Medium-High.
4. **Bath (electric) = 5.692960/use.** 180 L x 0.03162756.
   **2.61 kg** -- the dataset's largest single use, and 373 phone
   charges. High.
5. **Bath (gas) = 7.526854/use.** **1.37 kg.** Medium-High.
6. **Bath vs shower.** 5.693 vs 2.481 for 10 minutes = the bath
   costs **2.29x a 10-minute shower**, breaking even at a
   23-minute shower. Both scale with delta-T, so this ratio is
   unchanged by the 9.3 correction -- and unchanged by any grid
   factor (PDR sec 6). Safe to state (same group, same carrier,
   >20%). The popular "a bath equals a 5-minute shower" claim is
   wrong at these flow rates.
7. **Washing up (electric) = 1.992536/use.** 63 L x 0.03162756.
   **913 g.** Medium.
8. **Washing up (gas) = 2.634399/use.** **480 g -- 7% below
   `dishwasher_normal` (513 g)**, so a gas-heated sink narrowly
   beats the dishwasher while an electric one loses badly (913 g).
   Blocked from copy by the same-carrier rule. Medium.
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
    rounded up. **68.7 g/h.** Ratio to the portable electric
    heater **8.0x**, not
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
29. **Oven = 0.82 per bake cycle** (unit changed from `hour`,
    item 9.8). EU Reg 65/2014 formula 0.0042 x V + 0.55 gives
    0.802 / 0.823 / 0.844 kWh for 60 / 65 / 70 L; ships the
    midpoint. **376 g per bake.** Cross-check: DOE's 2009 TSD
    baseline 274.9-370.0 kWh/year at 200-350 cycles/year implies
    0.8-1.85 kWh/cycle -- consistent. Medium (EU-to-US proxy).
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

---

## 9. PDR Review Record (executed)

Moved verbatim out of
[PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md) section 8
on 2026-08-29, under the standing rule that completed items get a
short mention in the PDR and their detail lives here. Everything
below is EXECUTED; nothing here is a live instruction. Three rules
that were embedded in this prose were promoted before the move and
now live in the PDR: the avoided-emissions caveat and the
lighting-copy rule are UI requirements 24 and 25, and the
dataset-wide sourcing gap is a live caveat in PDR section 1.

Covers two passes: the 2026-08-08/09 documentation and
data-consistency pass, and the 2026-08-29 sourcing backfill and
archivings. The 電気カーペット row from the original "What landed"
table is not repeated -- section 1 above already carries it.

### Seeding: both pending decisions closed (2026-08-29)

`ANNUAL_RESEARCH_UPDATE.json` carried a `pending_from_decisions`
block with two entries. Both are complete, verified by reading the
live `actionLibrary` collection, so the block was emptied.

- **E1 (grid factor 386 -> 458 g CO2e/kWh)** -- data files applied
  and committed 2026-08-02; actionLibrary re-seeded and verified
  2026-08-29.
- **Food FR-22 (corrected food values)** -- `skip_high_impact_food`
  3700, `skip_medium_impact_food` 780, `plant_milk` 460,
  `skip_fish` 560, all four live and matching the local dataset.
  [RESEARCH_FOOD.md](./RESEARCH_FOOD.md) section 7 remains the
  authority for those values; they are not restated here.

Both went in on **one seeding run**, as the entries intended.
Verification at the time: **92 live docs matching the 92 local
actions, nothing to prune and nothing to add**;
`heat_person_not_room` present, `use_natural_light` and
`full_laundry_load` absent (both archived that day),
`turn_off_lights` reading 15 g / 2 points.

That is the durable fact worth keeping from those entries: as of
2026-08-29 the live action library and
`data/seed/co2_actions_database.json` were in exact sync. A later
edit to the dataset makes it stale again -- re-run `npm run seed`.

### What landed

| Change | File |
|--------|------|
| Every closed item rewritten to one table row and moved out of the live doc. The last open follow-up is now closed, so section 8 is standing rules only. | RESEARCH sec 8, archive 1 |
| RESEARCH_ENERGY.md split 1604 -> 1215 lines; 525 lines of executed detail moved to [RESEARCH_ENERGY_ARCHIVE.md](./RESEARCH_ENERGY_ARCHIVE.md). Blocks were moved by script, not retyped, and every source line was verified present in one file or the other. | both |
| Stale `v1.1` reference to the research doc corrected to `v2.0`. | sec 1 here |

Nothing in the split changed a shipped number. The archive holds
closed items, the E1 grid survey, superseded values, rejected
alternatives, the two researched non-entries (UK gas central
heating, refrigerator) and the full 38-item recomputation.

### Fixes applied

Both test failures from the E1 grid change (386 -> 458) were
fixed, plus a points-economy correction they exposed. Full suite
passing, `flutter analyze` clean.

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

**Still open -- and the gap is dataset-wide, not just
`skip_fish`.** An earlier draft of this section said `skip_fish`
carried `sources: []` and `confidence: null` "while every sibling
action carries both". That was wrong. When this section was
corrected, **68 of the 94 shipping actions** carried both an empty
`sources[]` and a null `confidence`, **47 of them with a nonzero
`co2_grams`** -- a stated saving with no recorded provenance. The
two largest are not energy's (`fix_leak` 100000,
`recycle_textiles` 40000), but they show the scale.

Energy owned part of it and has now closed it. Of the 14 actions
in section 4's table, 13 still ship and **all 13 carry sources**;
the fourteenth was demoted rather than sourced. The backfill on 2026-08-29 added `sources[]` and
`confidence` to seven records -- `shorter_bath`,
`lower_thermostat`, `raise_ac_thermostat`, `eco_mode_appliance`,
`microwave_vs_oven`, `heat_person_not_room` and
`ev_charging_green` -- transcribed from the primaries already
live-verified in [RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md)
sections 1 and 3, each with the source name, its verbatim quote,
its full URL and the 2026-08-02 access date. No new research was
done and no value moved. Two disclosures went into
`calculation_notes` at the same time: `microwave_vs_oven`'s
microwave leg rests on an aggregator-sourced efficiency range and
is the weaker of its two terms, and `ev_charging_green`'s ~10 kWh
session size has no primary behind it, which is why it ships at
low confidence.

**The 40 W bulb problem, and how it was settled (owner call,
2026-08-29).** `turn_off_lights` and `use_natural_light` both
derived from a **40 W** bulb -- a wattage that appears nowhere in
the research, since section 3.5 ships an 8.5 W LED at 800 lm
(Philips) and a 60 W incandescent comparator with nothing between
them. The two also overlapped: both credit a bulb not running, so
shipping both let the same hour be counted twice. Resolution: keep
one, drop the other.

`use_natural_light` was **demoted** to `research_only_records`. It
was the weaker of the pair -- its 6 h/day of daylight substitution
depends on season, latitude and window orientation, none of which
the app knows. Its record carries the retired arithmetic and the
conditions for restoring it.

`turn_off_lights` was **re-based onto the 8.5 W LED: 70 -> 15 g**
(4 h x 8.5 W x 458, rounded down from 15.6), points 3 -> 2. The
LED is the honest basis rather than the incandescent because LEDs
are now the majority of installed household lamps, so crediting
60 W would overstate the saving for most users, against the
honest-not-generous rule. A user still on incandescents saves
~110 g for the same four hours, and the methodology sheet should
say so. The 4 h is the behaviour definition, not a measurement,
which is why it needs no citation. Recorded debt: the 8.5 W
primary is the Philips A19 spec quoted verbatim in
[RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) section 3.5, whose URL
that pass did not capture; the action cites two URL-bearing
corroborators of the wattage class instead.

Dataset-wide the gap is still large and now entirely outside
energy: **58 of the 92 shipping actions** carry both an empty
`sources[]` and a null `confidence`, **37 of them with a nonzero
`co2_grams`**.
`skip_fish` specifically remains the food workstream's call.

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

### Food action id renames (E1 follow-through)

The food actions were restructured; each kept a
`provenance_research_id` back to its old id:

| Old id | New id | g CO2e |
|--------|--------|-------:|
| `meatless_meal_beef` | `skip_high_impact_food` | 3700 |
| `meatless_meal_chicken` | `skip_medium_impact_food` | 780 |
| `plant_milk_vs_dairy` | `plant_milk` | 460 |
| `meatless_meal_pork` | none -- moved to `research_only_records` | -- |

Pork is a deliberate demotion: no longer a shipped action.
The two tier values above are the **corrected** ones -- 6800 and
1000 were the merge's first pass, cut to 3700 and 780 on
2026-08-08 under the minimum-of-covered-items rule (see "Fixes
applied" earlier in this section). Do not restore the higher
figures. Open decision, food's call: whether the beef/chicken
merge into high/medium impact tiers is the intended final shape.
