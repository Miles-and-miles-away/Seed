# Transport Emission Factor Research

**Version:** 1.3
**Created:** 2026-07-17 | **Last research pass:** 2026-08-29
**Status:** Research complete -- 27 shipped modes decided; open
items tracked in section 7. The 2026-08-29 pass closed the MLIT
re-verification (section 7; it found a live sourcing error in
`rail_shinkansen`, since fixed in the dataset by re-sourcing to
JR East at an unchanged 20 g/km) and the rail-circuity question
(section 9, found but not adopted). Section 9 holds the
distance-estimation conventions for the city prefill; the durable
rules from the seven review rounds are consolidated in Appendix A.
Per-round detail exists for rounds 1-3 only, in
[PDR_TRANSPORT_ARCHIVE.md](./PDR_TRANSPORT_ARCHIVE.md); rounds
4-7 were never written up round by round, so section 9 and
Appendix A here are their record.
**Feeds:** `data/app/transport_modes.json` (Phase 8.1, see
[PLAN_PHASE_8.md](./PLAN_PHASE_8.md))

Reference document for the transport carbon calculator dataset.
Every factor that ships in the app must trace back to an entry
here with source, quote, URL, access date, and vintage. Follows
the sourcing rules in [AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md)
(sections 2 and 8) and [RESEARCH_STRATEGY.md](./RESEARCH_STRATEGY.md).

---

## 1. Source Landscape (verified 2026-07-17)

### Primary: UK DEFRA/DESNZ GHG Conversion Factors

- **Current release: 2026** (published June 2026).
  https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2026
  Collection page:
  https://www.gov.uk/government/collections/government-conversion-factors-for-company-reporting
- The factors are published as spreadsheets; quotable HTML
  statements of individual numbers mostly come from secondary
  pages. **Record the release vintage per figure** -- aggregator
  sites routinely mix vintages (observed during this research).

**Major changes in the 2026 release** (Acclaro Advisory summary,
https://www.acclaro-advisory.com/news-events/2026-ghg-conversion-factors-whats-changed-and-why-it-matters/,
accessed 2026-07-17):

| Change | Size | Consequence for our dataset |
|--------|------|------------------------------|
| UK electricity factor | -26% | All UK-grid electric modes drop |
| London Underground | -44 to -45% | "amended to reflect the changes to electricity grid emissions" |
| National rail | -13% | "following updates to fleet composition and passenger usage since the last revision in 2021" |
| International rail (Eurostar) | +154 to +156% | "significant changes in service patterns and rolling stock utilisation" -- the famous 4 g/pkm figure is obsolete |
| Coaches | +42 to 43% | "replacing outdated data that implied unrealistically high occupancy rates" |

Implication: several widely-quoted numbers (rail 35, Eurostar 4,
coach 27) are pre-2026 vintages. Where only pre-2026 numbers are
quotable, ship them with vintage noted and revisit at the next
data pass.

### Secondary anchor: Our World in Data

https://ourworldindata.org/travel-carbon-footprint
(accessed 2026-07-17, CC BY; data attributed to DESNZ factors,
article last updated with pre-2026 vintage):

> "This data comes from the UK Government's Department for
> Energy Security and Net Zero."

> "Greenhouse gases are measured in carbon dioxide equivalents
> (CO2eq), accounting for non-CO2 greenhouse gases and the
> increased warming effects of aviation emissions at high
> altitudes."

Figures stated on the page (pre-2026 vintage): national rail 35,
petrol car 170, domestic flight 246 (with RF), short-haul flight
154, Eurostar 4, cycling 16-50 (diet-dependent metabolic) --
all g CO2e per passenger-km except car (per vehicle-km).
EV note: "The chart above only considers emissions of EVs during
their use phase -- when you're driving. It doesn't include
emissions from car manufacturing."

### Cross-check: aggregated 2026 tables (tertiary, use with care)

greencalculus.com tabulates factors labelled "GHG Conversion
Factors 2026 (June 2026)"
(https://greencalculus.com/standards/uk-defra-emission-factors/,
accessed 2026-07-17). Values seen there:

| Mode | g CO2e/km | Basis |
|------|-----------|-------|
| Petrol car, small (<1.4L) | 142.6 | vehicle-km |
| Petrol car, medium (1.4-2.0L) | 174.1 | vehicle-km |
| Petrol car, average | 161.5 | vehicle-km |
| Diesel car, medium | 172.1 | vehicle-km |
| Petrol hybrid | 116.8 | vehicle-km |
| Battery electric | 30 | vehicle-km (UK 2026 grid) |
| National rail | 35 | passenger-km |
| Eurostar | 4 | passenger-km |
| Flight, domestic | 229 | passenger-km |
| Flight, short-haul economy | 123 | passenger-km |
| Flight, short-haul business | 185 | passenger-km |
| Flight, long-haul economy | 120 | passenger-km |
| Flight, long-haul premium economy | 192 | passenger-km |
| Flight, long-haul business | 348 | passenger-km |
| Flight, long-haul first | 480 | passenger-km |

**Caution:** the rail 35 / Eurostar 4 rows contradict the 2026
major-changes report (rail -13%, Eurostar +154%), so this page
mixes vintages. Its aviation rows do not state whether radiative
forcing is included -- pending verification (section 4). Treat
every row here as unconfirmed until matched to a second source.

### Japan context (primary market)

Official Japanese per-passenger-km figures, MLIT
(https://www.mlit.go.jp/sogoseisaku/environment/sosei_environment_tk_000007.html,
page updated 2026-04-23; figures published as a chart image
only -- no table, no CSV, no downloadable dataset):

- Chart values, read directly off the PNGs 2026-08-29 (chart
  title "輸送量当たりの二酸化炭素の排出量（旅客）", axis
  "CO2排出原単位[g-CO2/人km]", compiled by MLIT 環境政策課
  from the GHG Inventory Office emissions data plus MLIT's
  own 自動車/航空/鉄道輸送統計):

  | FY (年度) | private car | aviation | bus | rail |
  |-----------|-------------|----------|-----|------|
  | 2021 | 132 | 124 | 90 | 25 |
  | 2022 | 128 | 101 | 71 | 20 |
  | 2023 | 127 |  94 | 63 | 17 |
  | 2024 | 125 |  91 | 57 | 17 |

  FY2024 is what the live page serves now. MLIT overwrites the
  chart in place at each annual update and has kept the same
  content id since FY2022 (`content/001740968`, .jpg then
  .png), so prior years survive only in the Internet Archive:
  FY2023 at
  https://web.archive.org/web/20251023072401im_/https://www.mlit.go.jp/sogoseisaku/environment/content/001740968.png
  and FY2022 at
  https://web.archive.org/web/20240927143019im_/https://www.mlit.go.jp/sogoseisaku/environment/content/001740968.jpg
- Historical anchor (Ministry of the Environment deck,
  https://www.env.go.jp/content/900445318.pdf, FY2007 chart,
  read directly): private car 147, aviation 109, bus 51,
  rail 19 g-CO2/passenger-km. Confirms magnitude and the
  long-run trend (car and aviation falling, rail flat-low).
- JCCCA chart page (chart image only, and it lags MLIT by a
  year): https://www.jccca.org/download/13315 -- page updated
  2026-08-17, still the FY2023 set (rail 17, bus 63, aviation
  94, car 127), captioned "出典）国土交通省ホームページ運輸部門に
  おける二酸化炭素排出量（2023年度）". Useful as a live citation
  for FY2023 now that MLIT's own page has moved on to FY2024.
- Only machine-readable restatement found (2026-08-29): Tokyo
  Metropolitan Government環境局 publishes the FY2024 set inside
  a small .xls trip calculator, sheet 交通手段別のＣＯ２排出量,
  block "１人を１ｋｍ運ぶのに排出されるＣＯ２" -> rail 17, bus 57,
  private car 125, walking/cycling 0, credited
  "（国土交通省ホームページデータを元に作成）".
  https://www.kankyo.metro.tokyo.lg.jp/vehicle/management/tokyo/transportation
  (page updated 2026-05-01; the sheet is linked from it as
  "CO2排出量の計算シート"). Secondary, but it is the only place
  the numbers exist as data rather than pixels.
- MLIT itself publishes no machine-readable version. The
  compendium that used to carry derived tables,
  交通関連統計資料集, was discontinued
  (廃刊, 令和2年12月末日 = 2020-12) and its replacement,
  交通関係基本データ (https://www.mlit.go.jp/k-toukei/), carries
  the transport-volume surveys but not the CO2 原単位 ratio.
  The two inputs are machine-readable separately (NIES GHG
  Inventory Office; MLIT 輸送統計 via e-Stat), so the ratio is
  reproducible but not published as data.

Notes for methodology:
- Japan's domestic aviation (91 in 年度2024, 109 back in
  年度2007) is CO2-only (no RF) and reflects high-load trunk
  routes; DEFRA domestic ~229-246 includes RF and CH4/N2O. Not
  contradictory -- different scopes. The app ships
  DEFRA-with-RF and the methodology sheet says so.
- Japan's private-car per-passenger-km (125 in 年度2024)
  embeds average occupancy ~1.3; our dataset stores
  per-vehicle-km and divides by user-selected occupants
  instead.
- The bus and aviation rows move most between years because
  they are load-factor driven: both spiked in 年度2021 and are
  still settling back. Rail barely moves. Anything read off
  this chart needs its 年度 stated, which is exactly where the
  `rail_shinkansen` sourcing went wrong (section 7).

### Car occupancy (for the occupancy-selector design)

UK National Travel Survey (Department for Transport,
https://www.gov.uk/government/statistical-data-sets/nts09-vehicle-mileage-and-occupancy,
accessed 2026-07-17): average car/van occupancy ~1.55; commuting
~1.16; 62% of car driver stages are single-occupancy.
Justifies: default occupancy = 1 in the UI (honest for the
dominant commuting case), stepper 1-4.

---

## 2. Scope Decision

Factors represent **operational energy emissions**:

- Combustion modes: direct tailpipe CO2e (CO2 + CH4 + N2O).
- Electric modes (EV, rail, metro, tram): electricity
  generation emissions for the traction energy.
- Aviation: includes the radiative-forcing uplift (section 4).
- **Excluded everywhere:** vehicle manufacturing, infrastructure
  construction, well-to-tank fuel refining unless a mode's entry
  says otherwise (micro-mobility lifecycle figures are labelled
  explicitly where used).

This matches the DEFRA passenger-transport convention and the
OWID presentation, and is stated verbatim in the in-app
methodology sheet. Where a mode's honest story needs the
lifecycle caveat (EV manufacturing, shared e-scooters), the
per-mode notes carry it.

**EV grid-factor deviation (house rule):** DEFRA UK BEV is 40.47
g/km (2025) and ~30 g/km (2026, after the -26% electricity
revision; unverified digits). The app's audience is global (Japan
primary). Per [AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md),
energy calculations use the house global-average grid factor
**458 g CO2e/kWh** (raised from 386 by decision E1, 2026-08-02 --
see [PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md) sec 2).
EV factor = verified real-world consumption 0.188 kWh/km
(EV Database, "Average: 188 Wh/km") x 458 =
**86.1 -> ship 86 g/km**. Anchor points to document in the
methodology sheet: UK 2025 40.5 / UK 2026 ~30 / house-global 73;
Japan's more carbon-intensive grid sits above the house figure.
Deviation from DEFRA documented here per the audit rule. Same
house-grid treatment applies to the e-bike and e-scooter
electricity components (section 3.3).

---

## 3. Verified Mode Factors

> Detailed source tables from the four research tracks. "Verified"
> means the number was seen digit-for-digit on at least two
> independent live pages (or one primary page for
> operator-specific figures), with quotes and URLs recorded.

### 3.1 Road vehicles (verified 2026-07-17)

Primary vintage: **DEFRA/DESNZ 2025** (triple-corroborated across
SustainMetrics, Greencalculus, and SCIF factor pages, which agree
digit-for-digit). 2026 workbook exists but road numbers are not
yet quotable from second sources -- ship 2025, tag vintage,
revisit.

| Mode | g CO2e/km | Basis | Confidence |
|------|-----------|-------|------------|
| Petrol car, small (<1.4L) | 143.08 | vehicle-km | High |
| Petrol car, medium (1.4-2.0L) | 174.74 | vehicle-km | High |
| Petrol car, large (>2.0L) | 268.28 | vehicle-km | High |
| Petrol car, average | 162.72 | vehicle-km | High |
| Diesel car, average | 173.04 | vehicle-km | High |
| Hybrid car (full), average | 128.25 | vehicle-km | High |
| Plug-in hybrid, average | 91.67 | vehicle-km | Medium (single source; real-world ~135 per T&E/EEA -- see note) |
| Battery EV (UK 2025 grid) | 40.47 | vehicle-km | Medium-high |
| Battery EV consumption | 0.188 kWh/km | vehicle-km | High (EV Database, "Average: 188 Wh/km", real-world) |
| Motorbike, average | 113.67 | vehicle-km | High |
| Local bus, average | 103.85 | passenger-km | High |
| London bus | 68.75 | passenger-km | Medium (single source) |
| Coach | 27.76 | passenger-km | High for 2025; 2026 raises coach 42-43% (~39.5 computed, unverified) |
| Taxi (regular) | 208.06 | vehicle-km | Medium-high (SustainMetrics row + DESNZ methodology construction) |

Key sources (accessed 2026-07-17):
- SustainMetrics DEFRA 2025 factor tables:
  https://www.sustainmetrics.net/factors/defra/2025/passenger-vehicles
  (e.g. "Average car > Petrol / 0.16272 / km",
  "Bus > Coach | Scope 3 | 0.02776 | passenger.km")
- Greencalculus DEFRA 2025 business-travel tables:
  https://greencalculus.com/data/business-travel-freight-logistics-emission-factors/
  ("Average petrol: 0.16272 kg CO2e/km")
- SCIF methodology page: https://scif.org.uk/news/how-we-calculate-travel-emissions/
  ("Petrol Car: 0.16272 kgCO2e/km", "Electric Car: 0.04047 kgCO2e/km")
- EV consumption: https://ev-database.org/cheatsheet/energy-consumption-electric-car
  ("Average: 188 Wh/km", "Data is based on real-world values.")
- Motorbike corroboration (BEIS-based):
  https://www.climatiq.io/data/emission-factor/4ae79b15-5033-4ab9-8c3b-3b293262d44f
  ("0.11367 kgCO2e/km")
- 2026 deltas in prose: https://circularecology.com/news/desnz-2026-uk-ghg-conversion-factors
  ("the UK electricity conversion factor has decreased by around
  26%"; PHEV "decreased by around 5-6%")
- PHEV real-world caveat:
  https://www.transportenvironment.org/articles/plug-in-hybrids-pollute-almost-as-much-as-petrol-cars-eu-data
  ("In the real world, plug-in hybrids emit 135g of CO2 per km on
  average")

Scope notes (verified in prose): DEFRA passenger-vehicle factors
are CO2e incl. CH4 and N2O, tank-to-wheel, AR5 GWP-100; WTT is a
separate factor set. Bus/coach are per passenger-km at average
occupancy; car/motorbike per vehicle-km. DEFRA's PHEV km factor
covers the fuel side only (charging electricity is a separate
line) -- combined with the T&E real-world finding, present PHEV
conservatively or drop the mode from v1.

**Taxi basis (corrected by decision R2-D1, 2026-07-18):** ships
per VEHICLE-km at 208.06 ("Taxis > Regular taxi | Scope 3 |
0.20806 | km", SustainMetrics land page, verified 2026-07-18).
DESNZ 2025 methodology para 5.39: regular-taxi factors are the
average medium/large-car type-approval CO2 uplifted 40% for the
real-world taxi duty cycle (TfL data); the per-passenger-km
variant 148.61 divides by an assumed 1.4 passengers (L.E.K.
Consulting, 2002) and is NOT shipped (dated occupancy embedded
invisibly). Deadheading is explicitly excluded -- para 5.42: "It
should be noted that the current conversion factors for taxis do
not take into account emissions spent from 'cruising' for fares."
Post-2020 context for the science sheet: CARB SB 1014 2018
Base-year Emissions Inventory Report (Dec 2019,
https://ww2.arb.ca.gov/sites/default/files/2019-12/SB%201014%20-%20Base%20year%20Emissions%20Inventory_December_2019.pdf
-- "it is estimated that in 2018, almost 38.5 percent of total
TNC VMT in California was deadhead miles"; note the PDF is
bot-blocked for plain HTTP clients but opens in a browser); UCS
2020 ("Ride-Hailing's Climate Risks",
https://www.ucs.org/resources/ride-hailing-climate-risks --
"ride-hailing trips today result in an estimated 69 percent more
climate pollution on average than the trips they displace"; the
report's non-pooled case is ~47% above a comparable private-car
trip, ~239 g/km applied to our car figure). The shipped
208.06 is therefore conservative. Dropped (R3): the TRUE
Initiative 2024 Scotland corroboration carried no citation
anywhere in the repo and could not be live-verified, so it was
trimmed from the calc note; restore only with a verified URL +
quote. No self-derived deadheading
factor ships (PHEV precedent: never ship a derived number that
contradicts the cited set).

Cross-checks: US EPA "The average passenger vehicle emits about
400 grams of CO2 per mile" (~249 g/km CO2-only, US fleet,
https://www.epa.gov/greenvehicles/greenhouse-gas-emissions-typical-passenger-vehicle);
OWID "The average petrol car emits 170 grams." Magnitudes agree.

2026 indications (single-source, greencalculus standards page,
low-medium confidence): petrol small 142.57 / medium 174.11 /
average 161.52; diesel medium 172.09; hybrid medium 116.78;
BEV 30 (arithmetically consistent with the -26% electricity cut:
40.47 x 0.74 = 29.9). Not adopted until second-source verified.

### 3.2 Rail and ferry (verified 2026-07-17)

Primary vintage: **DEFRA/DESNZ 2025** (Climatiq + SustainMetrics
factor pages agree digit-for-digit; OWID corroborates rail and
Eurostar). Where the 2026 major-changes report says a factor moves
sharply, the flag is on the row.

| Mode | g CO2e/pkm | Confidence | 2026 flag |
|------|------------|------------|-----------|
| National rail (UK) | 35.46 | High | 2026: -13% (~30.8, unverified) |
| London Underground | 27.8 | High | 2026: -44 to -45% (~15.4, unverified) |
| Light rail and tram | 28.6 | High | drops with electricity factor |
| International rail (Eurostar-weighted) | 4.46 | High | 2026: +154-156% (~11.3, unverified) |
| Shinkansen (chosen) | 20 | Medium-high | JP grid basis, not DEFRA |
| Ferry, foot passenger | 18.71 | High | -- |
| Ferry, car passenger | 129.33 | High | -- |
| Ferry, average | 112.7 | High | -- |

Key sources (accessed 2026-07-17):
- SustainMetrics DEFRA 2025 land/sea tables:
  https://www.sustainmetrics.net/factors/defra/2025/business-travel-land
  ("Rail > National rail | Scope 3 | 0.03546 | passenger.km",
  "Rail > London Underground | Scope 3 | 0.0278 | passenger.km",
  "Rail > Light rail and tram | Scope 3 | 0.0286 | passenger.km",
  "Rail > International rail | Scope 3 | 0.00446 | passenger.km")
  and https://www.sustainmetrics.net/factors/defra/2025/business-travel-sea
  (ferry rows)
- Climatiq factor pages (BEIS/DEFRA-sourced), e.g. national rail
  https://www.climatiq.io/data/emission-factor/27c06236-480c-4497-baf3-887937f5d52e
  ("Emission intensity for UK national rail passenger train
  including fuel consumption"); ferry foot passenger
  https://www.climatiq.io/data/emission-factor/d823f3e6-67ce-4fd0-9c70-b17ce8c4e4f5
  ("Emission intensity per passenger without a vehicle on a ferry
  (fuel combustion only)")
- OWID: "National rail emits around 35 grams per kilometer";
  "Taking the Eurostar emits around 4 grams of CO2 per passenger
  kilometer"
- Eurostar operator claim (independent study, EcoRes SCRL, Nov
  2024): London-Paris train 2.0 kg vs plane 61.5 kg per passenger
  (https://www.eurostar.com/uk-en/sustainability) -- consistent
  with ~4 g/pkm. Eurostar is French-nuclear-specific; NOT generic
  high-speed rail.

**Shinkansen (the key research item):**

- Official JR Central, triple-verified on their pages
  (https://global.jr-central.co.jp/en/company/about_shinkansen/,
  .../company/environment/contribution.html,
  .../onlinebooking/contents/shinkansen/): Tokyo-Osaka per SEAT,
  N700 vs Boeing 777-200 -- energy "approximately 1/8th", CO2
  "around 1/12th" of the aircraft. Use as the quotable in-app
  fact.
- Absolute per-passenger-km: **20 g CO2/pkm** shipped. Primary
  source since 2026-08-29 is JR East's own Shinkansen-segment
  disclosure, JR East Group INTEGRATED REPORT 2024, printed
  page 80, under "Calculation and Disclosure of CO2 emissions
  by Shinkansen Segments": "Based on fiscal 2024 results, we
  calculated segment-by-segment CO2 emissions per customer
  associated with travel on Shinkansen lines. In addition, CO2
  emissions per transportation volume were 12g-CO2/person-km
  for JR East as a whole, and 20g-CO2/person-km for Shinkansen
  segments." The report's own reporting-period statement
  (printed page 4) fixes the vintage without inference: "This
  report principally covers our activities for fiscal 2024,
  from April 1, 2023 to March 31, 2024". So JR East's fiscal
  2024 is 年度2023, and the shipped 20 is a 年度2023
  Shinkansen-specific figure, not an all-rail average -- the
  same disclosure puts all of JR East at 12. Read from the
  Internet Archive capture of 2025-08-03,
  https://web.archive.org/web/20250803141325/https://www.jreast.co.jp/e/environment/pdf_2024/all.pdf,
  because jreast.co.jp returns HTTP 403 to every automated
  request including its own landing page; that archive URL is
  what ships as the source url, and a live re-read is owed
  when the host becomes reachable.
- Corroboration, same number, weaker vintage: the
  MLIT-supervised Navitime reference page
  (https://www.navitime.co.jp/pcstorage/html/co2info.html:
  airplane 96, train 20, bus 66, car 145 g/km; source line
  "運輸・交通と環境2018年版", MLIT environment policy division;
  re-verified live 2026-08-29). All-rail, 2018 edition, so it
  agrees on the figure by a different route rather than
  confirming the vintage.
- Planet Forward was the primary source from 2026-07-17 until
  2026-08-29 and is now removed. Its "20 grams" traced back to
  MLIT's 年度2022 chart through a fiscal-year label mismatch;
  the full trace is in section 7.
- Candidate refinement, NOT verified (search snippets only, pages
  403): ~9.3 g/seat-km "according to JR"; ~4.2-4.65 kg/passenger
  Tokyo-Osaka. Mutually coherent with the verified ratios
  (9.3 g/seat-km x ~515 km = ~4.8 kg). Revisit if a quotable
  primary page appears.
- Wikipedia (JRTR/Okada ref): Tokaido Shinkansen Tokyo-Osaka
  produces "only around 16% of the carbon dioxide of the
  equivalent journey by car".
- Generic high-speed rail context: UIC "Travelling by rail is
  between three and ten times less CO2-intensive compared with
  road or air transport"
  (https://uic.org/sustainability/energy-efficiency-and-co2-emissions/);
  blog-grade 15-25 g/pkm range (solartechonline.com, low-medium
  confidence). v1 ships Shinkansen as the named high-speed mode
  rather than a generic HSR mode -- Japan-primary audience, and
  the generic figure is weakly sourced.

### 3.3 Active and micro-mobility (verified 2026-07-17)

Scope discipline matters most here: lifecycle and operational
figures differ up to ~8x. The dataset's scope rule (manufacture
excluded, section 2) is applied consistently; the
manufacture-inclusive variants are documented for the methodology
sheet.

| Mode | Chosen g CO2e/km | Scope of chosen value | Confidence |
|------|------------------|-----------------------|------------|
| Walking | 0 | operational (metabolic excluded) | High |
| Cycling | 0 | operational (metabolic excluded) | High |
| E-bike | 2 (derived) | electricity only: 5.3 Wh/km x 458 g/kWh house grid = 2.43 | Medium |
| E-scooter (private) | 7 (derived) | electricity only: 14-15.8 Wh/km x 458 g/kWh house grid = 6.4-7.2, ships the upper end | Medium |

> **Owner decision 2026-07-18 (supersedes the 2026-07-17 draft
> values cycle 16 / ebike 8):** active modes ship
> electricity-only, making the dataset's operational-energy scope
> statement true for every row. Metabolic food energy is excluded
> for ALL human-powered modes and documented in the calc notes and
> methodology sheet: OWID's cycling 16-50 g/km (diet-dependent)
> and walking ~56 g/km remain quotable context, with OWID's
> additionality caveat. `bike_instead_of_car` in
> co2_actions_database.json deliberately KEEPS the 16 g rider
> footprint inside its savings delta -- different role; do not
> sync these numbers.

Verified underlying figures and quotes (accessed 2026-07-17):

- **Cycling 16-50 g/km (food-only):** OWID
  (https://ourworldindata.org/travel-carbon-footprint): "the
  carbon footprint of cycling one kilometer is usually in the
  range of 16 to 50 grams CO2eq per km" -- 16 g = average
  European diet. Matches the 16 g already used by
  `bike_instead_of_car`. Additionality caveat for the methodology
  sheet: OWID questions "whether those calories are actually
  'additional' to your normal diet."
- **Cycling 21 g/km (ECF lifecycle: food 16 + manufacture 5):**
  ECF's site blocks fetches; verified via Cycling UK
  (https://www.cyclinguk.org/article/how-much-carbon-can-you-save-cycling-work,
  "Riding a conventional bike accounts for just 21g of CO2
  emissions per kilometre.") and BikeRadar
  (https://www.bikeradar.com/features/long-reads/cycling-environmental-impact,
  "Adding the 16g per kilometre for food production to 5g per
  kilometre for bike manufacturing gives a total of 21g CO2e").
  Not used as the shipped value (scope rule), documented for
  methodology.
- **E-bike 14.8 g/km (ECF lifecycle):** Cycling UK ("just 14.8g
  for e-cycles") + BikeRadar ("we arrive at 14.8g CO2e per
  kilometre travelled by ebike"; components 7 manufacture + 6.3
  food + 1.5 electricity). Shipped value strips the manufacture
  component to match scope: 6.3 + ~1.5-2 = ~8 g/km (derived --
  calc note must show the component arithmetic). Electricity
  basis: BikeRadar "Travelling 94km on 500Wh works out to 5.3Wh
  per km"; US DOE AFDC cites e-bikes "as high as 3,800 mpg
  equivalent" (https://afdc.energy.gov/conserve/active-transportation).
- **E-scooter (private):** Springer Environmental Sciences Europe
  2024 LCA
  (https://link.springer.com/article/10.1186/s12302-024-00920-x):
  electricity "1.4 kWh/100 km" (plastic) to "1.576 kWh/100 km"
  (aluminium) = 14-15.8 Wh/km; full lifecycle (private commuting,
  plastic) "0.0321 kg CO2eq/km" (~32 g/km). Shipped value =
  electricity only at house grid: 14-15.8 Wh/km x 458 g/kWh = 6.4-7.2 g/km
  (derived). Lifecycle ~32 goes in the mode's science note.
- **E-scooter (shared fleets) -- NOT shipped as a v1 mode:**
  Hollingsworth et al. 2019 (Environ. Res. Lett. 14 084031;
  canonical page blocks fetches, verbatim text verified on a
  mirror reproducing the article): "the average global warming
  impact is 202 g CO2-eq/passenger-mile" (~125 g/km), split
  materials/manufacturing ~50%, collection driving ~43%, charging
  ~4.7%; "our Base Case shows a 65% chance that the life cycle
  e-scooter emissions will be higher" than displaced modes.
  Modern-fleet LCAs (Springer 2024) land at 28.1-38.2 g/pkm with
  12-month lifetimes. Because the honest shared-fleet number is
  dominated by non-operational components our scope excludes,
  a shared-scooter mode would need a lifecycle exception; deferred
  (open item) and covered in the methodology sheet instead.
- **Walking 56 g/km metabolic (not used):** Cycling UK ("56g for
  walking") + BikeRadar ("39 calories per kilometre gives us 56g
  CO2e per kilometre... 2.7 times the emissions of cycling").
  App ships walking = 0 direct, methodology notes the debate and
  the additionality caveat.

---

## 4. Aviation (verified 2026-07-17)

Primary vintage: **DEFRA/DESNZ 2025 with-RF factors** (aviation
reportedly unchanged in the 2026 release -- single source,
greencalculus: "Aviation factors were stable in DEFRA 2026").
The 2025 release cut flight factors sharply vs 2024 (myCarbon:
long-haul "decreased by 41.51%", short-haul "decreased by
31.23%", attributed to "increases in load factors following the
COVID-19 pandemic") -- do not mix 2024-vintage flight numbers
(e.g. OWID's 246 domestic) into this series.

| Item | kg CO2e/pkm | RF | Confidence |
|------|-------------|----|------------|
| Domestic, average passenger | 0.22928 | Yes | High (3 pages) |
| Short-haul intl, economy | 0.12576 | Yes | High (2 pages) |
| Short-haul intl, business | 0.18863 | Yes | Medium-high |
| Long-haul intl, economy | 0.11704 | Yes | High (3 pages) |
| Long-haul premium economy | 0.18726 | Yes | Medium-high |
| Long-haul business | 0.33940 | Yes | Medium-high |
| Long-haul first | 0.468 | Yes | Medium (= 4.0 x economy) |

Key sources (accessed 2026-07-17):
- OpenCO2.net factor entry "Flight, Domestic, average passenger,
  to/from UK (with RF)" = "229,28 g/hkm", source field "Defra
  Conversion Factors 2025"
  (https://www.openco2.net/en/emission-factor/2171/); adds "it is
  important to use an emission factor that includes radiative
  forcing (RF)".
- CarbonPass: "Short-haul economy flight produces 0.12576 kgCO2e
  per passenger-km (including radiative forcing)"
  (https://carbonpass.co/guides/defra-emission-factors-2025-uk)
- myCarbon: long-haul economy "0.11704 kgCO2e per passenger km"
  (https://www.mycarbon.co.uk/2025/06/17/2025-defra-emissions-factor-update-what-it-reveals-about-uk-carbon-reductions/)
- SCIF factor list corroborates 0.12576 / 0.18863 / 0.11704 /
  0.18726 / 0.33940
  (https://scif.org.uk/news/how-we-calculate-travel-emissions/);
  boundary labels "UK Domestic/Short-haul (<=3,700 km)",
  "UK Long-haul (>3,700 km)".

**Cabin-class multipliers (verified, arithmetic-exact):** Thrust
Carbon (https://thrustcarbon.com/resources/calculate-air-travel-emissions):
"Premium Economy: 1.6x", "Business class: 2.9x (long haul)/1.5x
(short haul)", "First class: 4.0x". Checks against SCIF values:
0.18863/0.12576 = 1.50; 0.18726/0.11704 = 1.600;
0.33940/0.11704 = 2.900. v1 ships economy factors; multipliers go
in the methodology sheet (no cabin selector yet).

**WTT trap:** Thrust Carbon elsewhere uses long-haul business
"0.41077 kg CO2e per passenger km" -- that bundles the
well-to-tank uplift on top of with-RF. Never mix WTT-inclusive
rows into this series.

**Radiative forcing multiplier -- it changed:**
- Historical 1.9, verified on gov.uk HTML (DfT journey-emissions
  methodology, based on DESNZ 2023 factors): "DESNZ's multiplier
  of 1.9 is used as an estimate, based on the best available
  scientific evidence", covering "contrail cirrus and emissions
  of nitrogen oxides (NOx)"; uncertainty "between 1 and 4 times"
  (https://www.gov.uk/government/publications/transport-energy-and-environment-statistics-notes-and-definitions/journey-emissions-comparisons-methodology-and-guidance).
- Current 2025 release: **1.7, VERIFIED on the DESNZ 2025
  methodology paper itself** (sec 8.43, read 2026-07-18,
  https://assets.publishing.service.gov.uk/media/6846b0870392ed9b784c0187/2025-GHG-CF-methodology-paper.pdf):
  "A multiplier of 1.7 is recommended as a central estimate,
  based on the best available scientific evidence". Sec 8.44
  adds the caveat that the value "is subject to significant
  uncertainty and should only be applied to the CO2 component of
  direct emissions"; sec 8.45 recommends applying it "equally to
  all flights irrespective of distance or altitude".
  **Do not print "1.9x" in app copy** -- that is the legacy
  value; 1.7 is now quotable with the citation above.
- Science citation for the why -- Lee et al. 2021, "The
  contribution of global aviation to anthropogenic climate
  forcing for 2000 to 2018", Atmospheric Environment. Verified on
  the open-access full text
  (https://pmc.ncbi.nlm.nih.gov/articles/PMC7468346/): "Non-CO2
  terms sum to yield a net positive (warming) ERF that accounts
  for more than half (66%) of the aviation net ERF in 2018."
  Canonical DOI page for the citation:
  https://www.sciencedirect.com/science/article/pii/S1352231020305689

**Takeoff/climb penalty (for education copy):** OWID: "This is
because take-off requires much more energy input than a flight's
'cruise' phase." CarbonPass: "short-haul flights spend a
proportionally larger share of their journey in fuel-intensive
take-off and climb phases".

**Noted crossover (feature copy will surface it):** with 2025
factors, a short-haul economy flight (125.76 g/pkm) sits BELOW a
solo average petrol car (162.72 g/km) per km -- the car only wins
with 2+ occupants. Domestic flying (229.28) still loses to the
solo car. This is exactly the honest nuance the occupancy
selector exists for; do not "fix" it in the data.

---

## 5. Chosen Dataset Values

Final v1 table for `transport_modes.json`. Basis: `pkm` =
per passenger-km (used as-is); `vkm` = per vehicle-km (divided by
the occupancy selector, 1-4). Full quotes/URLs live in sections
3-4; the JSON carries per-mode `sources[]` built from those.

| id | Mode | g CO2e/km | Basis | Vintage / source | Confidence |
|----|------|-----------|-------|------------------|------------|
| walk | Walking | 0 | pkm | convention (sec 3.3) | High |
| cycle | Cycling | 0 | pkm | convention (sec 3.3, owner decision 2026-07-18) | High |
| ebike | E-bike | 2 | pkm | derived: electricity only, 5.3 Wh/km x 458 house grid = 2.43 (sec 3.3) | Medium |
| escooter_private | E-scooter (private) | 7 | pkm | derived: 14-15.8 Wh/km x 458 (Springer 2024 consumption) = 6.4-7.2 | Medium |
| car_petrol_small | Small petrol car | 143.08 | vkm | DEFRA 2025 | High |
| car_petrol_medium | Medium petrol car | 174.74 | vkm | DEFRA 2025 | High |
| car_petrol_large | Large petrol car / SUV | 268.28 | vkm | DEFRA 2025 | High |
| car_petrol_avg | Petrol car (average) | 162.72 | vkm | DEFRA 2025 | High |
| car_diesel_avg | Diesel car (average) | 173.04 | vkm | DEFRA 2025 | High |
| car_hybrid | Hybrid car | 128.25 | vkm | DEFRA 2025 | High |
| car_bev | Electric car | 86 | vkm | derived: 0.188 kWh/km x 458 house grid | Medium-high |
| motorbike | Motorbike (average) | 113.67 | vkm | DEFRA 2025 | High |
| bus_city | City bus | 103.85 | pkm | DEFRA 2025 (avg local bus) | High |
| coach | Coach (long distance) | 27.76 | pkm | DEFRA 2025; 2026 raises ~42% -- re-verify at next pass | High (2025) |
| taxi | Taxi | 208.06 | vkm | DEFRA 2025 regular taxi (R2-D1): duty-cycle uplift, deadheading excluded per DESNZ 5.42 | Medium-high |
| rail_national | Local / national rail | 35.46 | pkm | DEFRA 2025; 2026 -13% flagged | High (2025) |
| rail_international | International rail (Eurostar) | 4.46 | pkm | DEFRA 2025; 2026 raises ~2.5x -- order-of-magnitude only (D3) | High (2025) |
| rail_shinkansen | Shinkansen (bullet train) | 20 | pkm | JR East 年度2023 Shinkansen-segment disclosure + MLIT-supervised Navitime | Medium-high |
| metro | Metro / underground | 27.8 | pkm | DEFRA 2025 (London Underground); 2026 -44% flagged | High (2025) |
| tram | Tram / light rail | 28.6 | pkm | DEFRA 2025 | High |
| ferry_foot | Ferry (foot passenger) | 18.71 | pkm | DEFRA 2025 | High |
| ferry_car | Ferry (car passenger) | 129.33 | pkm | DEFRA 2025; one leg covers vehicle + passenger (D3) | High |
| flight_domestic | Domestic flight | 229.28 | pkm | DEFRA 2025, avg passenger, with RF | High |
| flight_shorthaul | Short-haul flight (economy) | 125.76 | pkm | DEFRA 2025, with RF | High |
| flight_longhaul | Long-haul flight (economy) | 117.04 | pkm | DEFRA 2025, with RF | High |
| private_jet | Private jet | 1700 | pkm | derived (sec 8.1); 1,000 combustion base x 1.7 verified RF (D2) | Medium |
| helicopter | Helicopter | 450 | pkm | derived (sec 8.2); turbine class, 4-5 pax | Medium |

**Dropped from v1 (documented decisions):**
- Plug-in hybrid: DEFRA 91.67 assumes charging discipline;
  real-world ~135 (T&E/EEA). Shipping the optimistic number
  violates "honest, not generous"; shipping the real-world one
  contradicts the cited factor set. Revisit with a
  dual-sourced note if users ask.
- E-scooter (shared): honest number is lifecycle-dominated
  (Hollingsworth 202 g/mile; modern fleets 28-40 g/pkm) --
  incompatible with the operational scope rule. Methodology
  sheet covers it.
- Yacht: not defensible as a per-km mode (section 8.3); ships as
  an eco-fact candidate instead.

**Un-dropped by owner decision (2026-07-17):**
international rail (4.46, loud order-of-magnitude caveat), taxi
(per-vehicle 208.06 -- the originally proposed 148.61
passenger-km basis was corrected on 2026-07-18: deadheading is
excluded per DESNZ 5.42 and the 1.4 assumed occupancy is dated),
and ferry_car (129.33, one leg covers the vehicle-plus-passenger
crossing) now ship with the caveats recorded in their calc notes.

**Cabin class:** economy factors shipped; multipliers (premium
1.6x, business 1.5x SH / 2.9x LH, first 4.0x) documented in the
methodology sheet, selector deferred.

---

## 6. Sanity Invariants (for the test suite)

Pin these orderings as dataset regression tests. They are **data
pins for the shipped DEFRA-2025-vintage values** (section 5), not
truth claims: the flagged 2026 revisions break some of them
(noted inline), so every pin must be re-derived at the next data
pass rather than assumed to survive it.

1. walking (0) <= cycling-family (cycle 0, ebike 2,
   escooter_private 6) < every motorized mode's per-passenger
   figure. Documented exception: rail_international (4.46) sits
   below the e-scooter until the ~2.5x 2026 revision (~11) lands.
   Thinnest remaining margin: full BEV 73/4 = 18.25 vs e-scooter 6.
2. shinkansen <= tram/national-rail (20 <= 28.6-35.46). Metro is
   deliberately excluded: the 2026 revision cuts London
   Underground ~44% to ~15.4, below shinkansen's 20.
3. rail band < city bus < solo average petrol car
   (35.46 < 103.85 < 162.72)
4. coach < solo average petrol car (27.76 < 162.72; still holds
   at the 2026 ~39.5)
5. electric car < every combustion car variant (86 < 128.25+)
6. long-haul < short-haul < domestic flight per km
   (117.04 < 125.76 < 229.28)
7. full car (4 occupants) < any commercial flight per
   passenger-km (268.28/4 = 67.1 < 117.04 -- holds even for the
   large car)
8. ferry_foot < city bus (18.71 < 103.85)
9. helicopter > every ground mode's solo per-passenger figure
   (450 > 268.28)
10. private jet > every other mode (1700 > 450)
11. rail_international < shinkansen (4.46 < 20; 2026 ~11 < 20,
    stable)
12. taxi > city bus (208.06 > 103.85; duty-cycle uplift,
    deadheading excluded per DESNZ 5.42)
13. ferry_car > ferry_foot (129.33 > 18.71)

**Deliberate non-invariants** (do NOT pin; they are the honest
surprises the feature exists to surface):
- coach vs national rail ordering flips between DEFRA 2025 and
  2026 (27.76 vs 35.46 becomes ~39.5 vs ~30.8).
- short-haul economy flight (125.76) is LOWER per km than a solo
  average petrol car (162.72) -- the car needs 2+ occupants to
  win. Distance still decides total impact.

---

## 7. Open Items

Closures from the 2026-07-17/18 research passes are logged in
[PDR_TRANSPORT_ARCHIVE.md](./PDR_TRANSPORT_ARCHIVE.md) section 9.

Remaining:

- [ ] Next DEFRA pass (when 2026 numbers become quotable):
      coach (+42%), national rail (-13%), LU (-44%), BEV UK
      anchor (~30), international rail (~2.5x to ~11);
      re-derive all invariant pins (sec 6)
- [ ] Ship the yacht fact when a calendar slot frees. The
      draft is written, translated and pre-audited (sec 8.3);
      what remains is an owner call on which of the 366 days
      it displaces. Closure detail in
      [PDR_TRANSPORT_ARCHIVE.md](./PDR_TRANSPORT_ARCHIVE.md)
      section 9.

---

## 8. High-Impact Modes (verified 2026-07-17)

Requested addition for comparison-view education value. Verdict:
**ship private jet and helicopter (derived factors, fully
citable inputs); do not ship yacht as a journey mode.**

### 8.1 Private jet -- SHIP at 1,700 g CO2e/pkm (1,000 derived base x 1.7 RF, decision D2)

No government per-pkm factor exists; the shipped value is derived
from citable inputs, cross-checked three ways, and deliberately
mid-band:

- Derivation (light jet, Embraer Phenom 300): 183 gal/h fuel burn
  (PrivateJetCardComparisons,
  https://privatejetcardcomparisons.com/the-basics/private-jet-fuel-cost-per-hour-in-gallons/)
  = 692.7 L/h x 2.54514 kg CO2e/L aviation turbine fuel (BEIS via
  Climatiq,
  https://www.climatiq.io/data/emission-factor/a98b3d88-1ae0-439a-b346-424c4a82489f)
  = 1,763 kg/h; / 839 km/h cruise (Wikipedia Phenom 300) / 4
  occupants = **0.53 kg CO2e/pkm**. Midsize (Citation XLS, 250
  gal/h, 816 km/h): **0.74 kg/pkm** at 4 pax.
- Occupancy: "the average party size is approximately 4.1
  passengers per flight" (venturajet.com, industry stat,
  low-medium confidence).
- Cross-checks: US EIA jet fuel "9.75 kg CO2/gallon" reproduces
  the same within 1.2%
  (https://www.eia.gov/environment/emissions/co2_vol_mass.php);
  T&E's "Two tonnes of CO2 Emitted by a private jet in one hour"
  at ~800 km/h and 4 pax = 0.63 kg/pkm.
- The multiplier framing, quotable: T&E "Private jets are 5 to 14
  times more polluting than commercial planes (per passenger)"
  (https://www.transportenvironment.org/articles/private-jets-can-the-super-rich-supercharge-zero-emission-aviation,
  2021); CE Delft states the same "five to 14 times" explicitly
  per passenger-km
  (https://cedelft.eu/publications/co2-emissions-of-private-aviation-in-europe/,
  2023). Against commercial 117-229 g/pkm (section 4), 5-14x
  spans ~0.6-3.2 kg/pkm -- real-world short hops at 2-3 pax sit
  well above the cruise-phase floor.
- Scale context: Gossling & Humpe 2024 (Nature Comms Earth & Env,
  https://www.nature.com/articles/s43247-024-01775-z): "Private
  aviation contributed at least 15.6 Mt CO2 in direct emissions
  in 2023, or about 3.6 t CO2 per flight." Fuel burns "182-2180 L
  per hour". CO2-only, "does not consider non-CO2 warming."

**Chosen: 1,700 g CO2e/pkm (decision D2, resolved 2026-07-18).**
The combustion-only base is 1,000 g/pkm -- the conservative lower
band of the CE Delft-implied 0.6-3.2 kg/pkm real-world range
(cruise-phase floor 0.53-0.74 at 4 pax; real hops at 2-3 pax sit
well above it). The DESNZ RF multiplier was then verified at 1.7
directly on the 2025 methodology paper (sec 4 above) and applied
for chart consistency with the airline rows, which all embed the
same uplift: 1,000 x 1.7 = **1,700 g/pkm**. Shipping the no-RF
1,000 next to with-RF airline bars understated the jet-vs-airline
gap ~1.7x in the pro-jet direction, which failed the "honest,
not generous" rule. The in-chart footnote should say the jet bar
includes the same high-altitude uplift as the airline bars.
One acknowledged simplification: DESNZ (para 8.44) says the 1.7
multiplier should be applied only to the CO2 component of direct
emissions, while this derivation applies it to the full CO2e
base -- immaterial, as CH4/N2O are under 1% of aviation CO2e.

### 8.2 Helicopter -- SHIP at 450 g CO2e/pkm (derived)

No government per-pkm factor exists (3AF confirms publishers
withhold absolutes; "1 kg of jet fuel emits 3.16 kg of CO2 during
combustion", https://www.3af.fr/en/news/comparison-of-co2-emissions-from-helicopters-2504).
Derived per-type from citable burn/speed/seats:

| Type | Inputs | kg CO2e/pkm |
|------|--------|-------------|
| Robinson R44 (piston, avgas 2.1994 kg CO2/L) | 57 L/h, 202 km/h, 3 pax | 0.21 (full) - 0.31 (2 pax) |
| Airbus H125 (turbine) | 227 L/h, 252 km/h, 5 pax | 0.46 (0.57 at 4 pax) |
| Bell 407 (turbine) | 190 L/h, 241 km/h, 6 pax | 0.33 |

Independent anchor (Chalmers/KTH-backed travelandclimate.org):
AS350B3 "180 litres of aviation fuel per hour" emitting "approximately
700 kg of CO2" per hour incl. WTT -> ~0.69 kg/pkm at 4 guests.
Brackets the derivations.

**Chosen: 450 g CO2e/pkm**, calc note "derived: turbine
helicopter (H125/Bell 407 class) at typical 4-5 pax; range
210-690 by type and load". No RF uplift (low altitude; published
methods do not apply one).

### 8.3 Yacht -- DO NOT ship as a journey mode

Per-passenger-km is not defensible: no reputable source publishes
one; occupancy is undefined (guests vs 20+ crew); yachts are
leisure platforms, not A-to-B transport. Illustrative derivation
shows why it breaks the comparison frame anyway: a 70 m motor
yacht at "1000 litres per hour" (West Nautical,
https://westnautical.com/yachts-and-fuel-how-much-do-they-really-consume/)
x 2.69 kg CO2/L diesel (EIA) = ~2.7 t CO2/h; at ~12 kn that is
~10 kg CO2/pkm even with 12 guests -- 40x a domestic flight seat,
with error bars wider than every other mode combined.

**Use instead as an eco-fact / methodology comparison stat.**
Re-sourced 2026-08-29 to the peer-reviewed original, which
`AUDIT_FACT_DATA.md` requires (The Conversation is not tier-1):
Barros & Wilk, "The outsized carbon footprints of the
super-rich", Sustainability: Science, Practice and Policy 17(1)
316-322, 2021, open access,
https://doi.org/10.1080/15487733.2021.1949847. Verbatim: "Three-
quarters of the billionaires in our sample owned a yacht with an
average length of 276 feet (84 meters), and their average carbon
equivalent emissions were 7,018 tons per year."

Three corrections to the figure as this section previously
stated it, all confirmed against the paper's Table 1 (the 15
non-empty yacht rows average 7,017.6):

- It is **7,018 tonnes CO2e**, not 7,020 tonnes CO2. The string
  "7,020" appears nowhere in the paper.
- It is an **average across 15 yachts** averaging 84 m, not one
  specced vessel.
- The "helicopter pad, submarines and pools" wording belonged to
  a different sentence, about why yacht emissions are growing.

Destination is `eco_facts.json`, not the Eco-Dex: a Dex entry
would need new artwork (owner call 2026-08-29). The calendar is
full at 366, so the drafted fact is parked here until a slot
frees. Category `comparison`, SDGs [10, 12] (13 is already
over-assigned), and do not place it adjacent to day 51 or day
296, which cover related wealth-and-emissions ground.

- EN: "The superyachts in a study of twenty billionaires
  averaged 84 metres and 7,018 tonnes of CO2 equivalent a year
  -- as much as about 1,400 people living at the global average
  of 5 tonnes each. Yachting accounted for 64% of the group's
  measured emissions."
- JA: 「20人の億万長者を対象とした研究では、スーパーヨットの平均は全長84
  メートル、CO2換算で年間7,018トンでした -- 世界平均である1人あたり5トン
  で暮らす約1,400人分に相当します。ヨットは、この20人の排出量全体の64%を
  占めていました。」
- ES: "Los superyates de un estudio de veinte multimillonarios
  promediaban 84 metros y 7,018 toneladas de CO2 equivalente al
  año -- tanto como unas 1,400 personas que viven con el
  promedio mundial de 5 toneladas cada una. Los yates
  representaban el 64% de las emisiones medidas del grupo."

Source name ships untranslated in all three locales.

---

## 9. Distance Estimation for the City Prefill (verified 2026-07-17)

The journey builder prefills editable distance estimates from a
bundled city list (`data/app/cities.json`, generated by
`scripts/generators/build_cities.py`). Conventions and sources:

- **Straight-line base:** haversine over city coordinates.
  City data: GeoNames cities15000 (CC BY 4.0,
  https://download.geonames.org/export/dump/cities15000.zip),
  top 5 per country by population (top 15 for JP), capitals with
  zero recorded population excluded, duplicate records deduped.
  Region mapping: ISO-3166 regional codes (lukes GitHub dataset).
- **Ground circuity x1.3:** road-network distance exceeds
  straight-line; US-average driving circuity is ~1.3 (range
  1.2-1.42 across the literature). Sources:
  https://circuity.org/method/ ;
  US nationwide driving-vs-straight-line study
  https://pmc.ncbi.nlm.nih.gov/articles/PMC3835347/ ;
  canonical country-circuity paper (Ballou et al. 2002)
  https://www.sciencedirect.com/science/article/abs/pii/S0965856401000441
  Applied to ground and active estimates. Rail rides the same
  factor: `suggestedDistancesKm` has one `kindGround` bucket for
  car, bus and rail. A rail-specific figure is now sourced (see
  the closed circuity item below) but deliberately not adopted.
- **Flight = great-circle + 95 km:** the EN 16258 (2012)
  distance correction used by myclimate and EU monitoring
  conventions
  (https://www.myclimate.org/en/information/about-myclimate/downloads/flight-emission-calculator/).
- **Ferry = straight line** (no detour factor; conservative).
- **Port-anchored ferry links (Fix Backlog 3, R3-D4):** every
  ferry link carries a representative port coordinate and a
  catchment radius per side; a ferry is suggested only when each
  city lies within its side's radius. This scopes a mass-level
  link to the corridor it names by construction: the Gibraltar
  link cannot manufacture Red Sea ferries, the Ireland-France
  link cannot reach Groningen, and Sevilla-Tangier (killed by
  the old cap approach) is revived. Radii are catchment
  decisions verified against dataset coordinates (documented
  per link in build_cities.py's LINKS table). A `max_km`
  straight-line cap (default 500) remains as a backstop and
  where a real crossing needs more (Ireland-France 900,
  Dublin/Cork-Paris at 779-838 km). Portless links (the
  synthetic ones in unit tests) gate on distance alone;
  rail_tunnel links stay portless because through-rail reach is
  real. The full-dataset sweep after anchoring: 21 ferry
  pairs total, every one on the corridor its link names.
- **Continental convention (Suez):** Africa-Eurasia ground stays
  unmodeled even where a real land corridor exists
  (Cairo-Jerusalem drives via Suez) -- a mass-level ground link
  cannot scope regionally and would leak ground suggestions
  across the Strait of Gibraltar (Sevilla-Tangier). Users can
  still build the journey manually.
- **2,000 km ground cap (product rule, not science):** ground
  modes are only *suggested* up to 2,000 km straight-line -- "a
  plausible long drive or single rail/coach journey" (owner
  decision, 2026-07-17, relocating the city_pairs prototype's
  build-time filter to a runtime rule). Users can always build
  any journey manually.
- **250 km minimum flight distance:** below it, no scheduled
  service is plausible enough to suggest -- except as the
  fallback when a cross-water pair has no other kind at all
  (real short island hops, e.g. San Juan-Charlotte Amalie,
  125 km).
- **100 km air-fallback floor (`fallbackAirMinKm`, decision
  R2-D3):** linkless cross-water pairs below 100 km straight-line
  return an empty suggestion map instead of a padded
  "17 km hop -> 112 km flight" fiction (Marigot-The Valley).
  These are local boat hops the model does not cover; the UI
  falls back to manual distance entry. NaN coordinates likewise
  return an empty map.
- **Active cap split:** the active suggestion kind is offered up
  to 150 km straight-line (cycle family); walking is only mapped
  in up to 40 km (`walkModeMaxKm`, applied at kind-to-mode
  mapping time -- a 195 km road walk is not a suggestion).
- **Landmass model + fixed links:** road-connected masses with
  islands isolated (from the city_pairs prototype; multi-island
  countries ID/PH/NZ/IT/GQ/TZ/KM/PG/CV/FJ/BS/TC/VI -- plus a
  latent MY Borneo guard -- are split per island by city
  coordinates); fixed crossings declared explicitly: Channel
  Tunnel (rail), Dover-Calais, Irish Sea, Ireland-France,
  Busan-Fukuoka, Gibraltar Strait, Messina
  Strait/Naples-Palermo, Dar es Salaam-Zanzibar, Cook Strait,
  St Thomas-St Croix (ferries). The Malta-Sicily link was
  removed (R3): the only Sicilian city in the dataset is
  Palermo, a corridor with no direct Malta ferry (the real
  service runs to Pozzallo/Catania); Malta keeps its air
  suggestion, and the link returns if Catania is ever
  force-included.
  Ferry links enable ferry legs only; rail_tunnel links enable
  ground modes. **Links are not chained:** each link connects
  exactly the two masses it names (Malta-Sicily plus
  Sicily-Eurasia does not imply Malta-Eurasia).

- **Water-crossing blocklist (Fix Backlogs 3+4, R3-D5/R4):**
  `scripts/generators/build_water_blocklist.py` emits
  `metadata.water_blocked` in cities.json (2,399 index pairs as
  shipped on 2026-08-29; the count moves with every regeneration,
  so read it from the file rather than quoting it);
  the picker suppresses ground/active for them (ferry/air
  unaffected; blocked pairs under 100 km fall back to manual
  entry). Candidates are same-mass pairs PLUS rail_tunnel-linked
  cross-mass pairs (the Channel Tunnel grounds GB-Eurasia, so
  Glasgow-Stavanger needed blocking too). A pair blocks iff its
  chord crosses > 25 km of continuous water (Natural Earth 1:50m
  land polygons) AND no honest land route exists: shortest path
  on a 0.1-deg rasterized land graph -- augmented with the
  verified FIXED_CROSSINGS declared in the script (Channel
  Tunnel, Oresund, Great/Little Belt, Bosphorus, 1915 Canakkale,
  Osman Gazi, Kanmon, Seikan, Tokyo Aqua-Line, HZMB,
  Shenzhen-Zhongshan, King Fahd, Johor Causeway, Rio-Antirrio,
  and the General Rafael Urdaneta Bridge over the Lake Maracaibo
  outlet, added in R7) -- must be within
  1.4 x the shown estimate (grid-underestimation compensated;
  constants in the script header). This kills the fiction class
  (Helsinki-Tallinn cycling, Bahrain-Qatar, Sapporo-Osaka) while
  keeping honest coastal corridors the Round 3 curation wrongly
  blocked (Jakarta-Surabaya, Bangkok-KL, Lagos-Accra,
  Copenhagen-Hamburg, Auckland-Wellington, London-Madrid).
  Political and honesty overlays (Fix Backlog 5, R5; extended
  Backlog 6, R6): CLOSED_BORDERS blocks every pair between two
  countries whose shared border is closed, regardless of water
  or detour honesty (owner rule 2026-07-20, extended 2026-07-21:
  active fighting between countries closes the border, and
  doubt resolves to blocked): KP-KR, IL-LB, IL-SY, AM-AZ,
  RU-FI, DZ-MA, RU-UA, BY-UA, IN-PK, ER-DJ, and from Round 6
  AM-TR, DO-HT, AF-PK, BD-MM, IN-MM, KE-SO, SA-YE, BJ-NE,
  SD-TD, SD-SS, SD-EG, DZ-LY (all live-verified 2026-07-21).
  Since Round 6 the land-path honesty test runs on EVERY
  candidate pair, not just wet chords: dry-land corridors that
  walls or front lines force into a dishonest detour now block
  automatically (SPb-Narva, Khartoum-Nyala) instead of needing
  hand-curated pair lists. The Gaza Strip cities were removed
  from the dataset outright (owner ruling R6-1: all crossings
  sealed, no honest suggestion of ANY kind exists), and
  build_cities.py drops same-settlement GeoNames duplicates
  within 1.5 km (Majuro's twin listing, Macau/Conakry/Luanda
  district records).
  BORDER_WALLS are polyline barriers that cut land-graph edges
  before pathfinding, so closed borders also stop third-country
  TRANSIT (Warsaw-Helsinki must round the Gulf of Bothnia, which
  measures dishonest and auto-blocks) and fake-land raster
  artifacts are restored to water (Amazon delta/Marajo,
  Oslofjord pinch, sub-resolution Dardanelles); each wall names
  its basis and must cut at least one edge or the build aborts.
  DISHONEST_CC_PAIRS blocks country pairs whose corridors
  measure dishonest as a class where grid geodesics undercut the
  real detour (IR-AE/OM/QA around Hormuz, CD/CG x NG/TG/BJ
  around the Gulf of Guinea bight, PK-SA at 1.85).
  MANUAL_BLOCK holds pair-level cases neither polygons nor the
  raster can see (unbridged Congo, Parana-delta raster gaps,
  Narva vehicle closure, measured-dishonest bridge-chain
  corridors like Malmo-Arhus at 1.8x, Istanbul-Athens/Piraeus/
  Patra at ~1.5x, Stavanger-Gothenburg at 1.66x). MANUAL_ALLOW
  is an empty escape hatch by design. A crossing self-check
  warns loudly when any FIXED_CROSSING's snapped cells collapse
  or the edge stops being load-bearing on a crossings-free graph
  (three entries were silently dead before Backlog 5, R5-11).

Known limitations (documented, accepted for v1):
- The blocklist suppresses, it does not correct: pairs with a
  real but circuitous land route around water (Stockholm-
  Helsinki ~1,750 km real vs 514 straight) get no ground
  suggestion rather than an honest detour distance -- computing
  one needs routing, which the offline no-maps design excludes.
  Same-mass ferry corridors (Helsinki-Tallinn) also cannot be
  expressed by mass-to-mass links; blocked pairs >= 100 km fall
  back to air, below that to manual entry.
- Lakes are not in ne_50m_land, so lake chords keep ground
  suggestions; the one materially dishonest dataset case is
  Lake Victoria (Kampala x Mwanza, real ~650 km vs est 412,
  ~1.6x -- R4-9; Great Lakes pairs are honest, worst
  NYC-Toronto 1.10). Rivers likewise need MANUAL_BLOCK entries.
- Politically blocked pairs in the 100-250 km band still get
  the air fallback even where no flight exists
  (Seoul-Pyongyang "290 km flight"); the block mechanism only
  withholds ground/active.
- Hong Kong-Macau grounds via the HZMB FIXED_CROSSING, but
  bicycles are banned on the bridge, so the pair's active
  suggestion remains optimistic. Distances stay user-editable.
- Ferry estimates price the whole straight-line distance at the
  foot-ferry rate even when the sea leg is a fraction of it
  (Dublin-Paris: ~350 km crossing inside a 779 km estimate).
  Port anchoring bounds who gets the suggestion (a city can be
  at most one catchment radius from its port); the estimate
  itself stays a single-mode approximation, and distances stay
  user-editable.
- (Historical, resolved by port anchoring:) the Gibraltar link
  briefly shipped with a 150 km cap because no distance cap
  could both kill the Red Sea/Levant fiction (152-191 km) and
  keep Sevilla-Tangier (180 km). Ports resolve the conflict by
  construction: the link now yields Gibraltar-Tangier and
  Sevilla-Tangier only.
-- the political screen (R7) -- any grounded cross-country pair
absent from data/reference/reviewed_cc_ground_pairs.json (new
corridors must be border-screened, closed ones blocked in
build_water_blocklist.py, then the list refreshed with
--update-reviewed). Regeneration order: build_cities.py ->
enrich_city_names.py -> build_water_blocklist.py ->
sweep_suggestions.py; not done until the gate passes.

---

## Appendix A: Review-Derived Design Principles (Rounds 1-7)

Seven adversarial review rounds (bug hunt, maths recomputation,
design red-team with full-pair sweeps, deception audits with live
source fetches) ran over the dataset and the distance-estimation
engine, 2026-07-17..21. The durable rules they produced are
consolidated here so this document stays self-sufficient. Most are
already applied in sections 2-9 -- this appendix names them as
principles and records the few that live nowhere else.

### A.1 Honesty ethic (the rule every data decision serves)

- **Honest, not generous.** Where a factor, ordering, or
  suggestion could flatter the eco-choice, ship the conservative
  reading and disclose the caveat; never present an unearned
  saving.
- **Zero fiction beats convenience.** A suggestion that cannot be
  scoped to a real corridor is removed, not approximated
  (Malta-Sicily link deleted; Gibraltar fiction killed; Gaza
  cities removed). When sources conflict or a corridor cannot be
  confirmed open to ordinary travelers, **doubt resolves to
  removal** -- aid/trade/pilgrim-only crossings count as closed
  (owner rules, section 9).
- **Never ship a self-derived number that contradicts the cited
  set.** A derivation is a cross-check, not a license to invent
  (PHEV: DEFRA's optimistic 91.67 vs real-world ~135, ship neither
  silently -- section 3.1; taxi: no self-derived deadheading
  factor though deadheading is real and DEFRA excludes it --
  section 3.1).

### A.2 Vintage discipline

- Every factor records its DEFRA/DESNZ release vintage; aggregator
  pages routinely mix vintages (section 1).
- The sanity invariants (section 6) are **pins for the shipped
  2025-vintage values, not truth claims** -- the flagged 2026
  revisions break several (noted inline), so re-derive every pin
  at the next data pass rather than assuming it survives.

### A.3 Copy rules (binding on the comparison view / science sheets)

- "emits X kg less", **never "saves"** -- the delta is
  hypothetical until the trip is actually swapped.
- Comparative superlatives only at a meaningful delta; **never**
  generate copy claiming walking beats cycling, or coach beats
  rail -- both orderings are vintage-fragile (section 6
  non-invariants).
- Binding in-UI disclosures: the private-jet bar carries an
  in-chart RF footnote (its bar includes the same high-altitude
  uplift as the airline bars, section 8.1); the EV row carries a
  global-average-grid sublabel (section 2); active/micro rows
  carry their electricity-only / lifecycle-excluded basis labels
  (section 3.3).

### A.4 Flight-band auto-pick (binding methodology, shipped)

The comparison view picks the honest flight band from leg distance
rather than letting a short leg be overstated at the long-haul
rate: **> 3,700 km = long-haul**; otherwise **same country =
domestic**, **different countries = short-haul** (the DEFRA
<= 3,700 km boundary, section 4). No invented medium-haul cutoff --
DEFRA publishes no medium-haul factor, so the three bands stand
(owner Q&A, 2026-07-22). The picker offers only the band a city
pair resolves to.

### A.5 Border-status watchlist (enforced by the build guard)

Border verdicts (section 9 CLOSED_BORDERS / walls) carry expiry
risk: a closed border reopens, and a stale verdict then blocks
honest corridors silently. The reminder is no longer a matter
of memory: `build_water_blocklist.py` calls
`check_border_verdicts()` as the first statement of `main()`,
and the build aborts when `BORDER_VERDICTS_VERIFIED` (currently
2026-07-21) is older than `BORDER_VERDICT_MAX_AGE_DAYS` (180).
A run inside the window prints the age and continues. The
guard's abort message points at this section instead of
restating the entries, so the list below stays the single
authoritative statement of what re-verifying covers.

Re-verifying means: check every entry below live, then move
`BORDER_VERDICTS_VERIFIED` to the date you did it. Moving the
date without doing the checks is the one failure mode the guard
cannot see. The verdicts themselves live in the script
(CLOSED_BORDERS, BORDER_WALLS, MANUAL_BLOCK); this is the
rationale and the watch reason for each:

- **BJ-NE** -- the 2026-06 reopening accord was prospective;
  likely to genuinely reopen (currently blocked).
- **DZ-LY** -- conflicting sources; blocked under the in-doubt rule.
- **AM-TR** -- reopening conditional on an unsigned AM-AZ treaty.
- **ER-ET** -- owner "fragile-ok" watchlist (kept open).
- **Rafah / Gaza** -- the strip ships no cities; revisit only if
  crossings genuinely reopen to travelers.
- **Sudan front line** (Kordofan; El Obeid the current flashpoint)
  -- a manual wall; recheck as the front shifts.
- **Backfill note** -- cities.json was edited in place (the
  GeoNames inputs are off-disk), so the next full regeneration
  backfills the freed top-5 slots with new cities; the gate's
  political screen (R7, section 9) fails any new grounded cc-pair
  until it is border-screened and added via `--update-reviewed`.
- **Cities can leave the GeoNames input** -- a shipping city can
  disappear from cities15000 upstream: Seria BN was in the export
  at the 2026-07-18 build and gone by 2026-08-29. build_cities.py
  re-selects from that export, so a full regeneration drops the
  vanished city silently and a backfill city takes its top-N
  slot, compounding the note above. enrich_city_names.py joins
  every shipping city against cities15000 and is the only place
  that sees it go: its `KNOWN_UNJOINED` constant pins the
  known-absent set, and the run aborts when the observed set
  differs in either direction (a new absence, or a listed city
  that has returned and left the constant stale).
