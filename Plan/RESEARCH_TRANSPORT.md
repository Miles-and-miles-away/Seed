# Transport Emission Factor Research

**Version:** 1.1
**Created:** 2026-07-17
**Status:** Initial research pass complete (27 shipped modes
decided; open items tracked in section 7). Section 9 adds the
distance-estimation conventions for the city prefill.
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
page updated 2026-04-23; figures published as a chart image):

- FY2023 figures reported from the MLIT chart via search
  summaries (exact values to re-verify when building the JSON):
  private car ~127, domestic aviation ~94, bus ~58-63,
  rail ~17 g-CO2/passenger-km.
- Historical anchor (Ministry of the Environment deck,
  https://www.env.go.jp/content/900445318.pdf, FY2007 chart,
  read directly): private car 147, aviation 109, bus 51,
  rail 19 g-CO2/passenger-km. Confirms magnitude and the
  long-run trend (car and aviation falling, rail flat-low).
- JCCCA chart page (chart image only):
  https://www.jccca.org/download/13315

Notes for methodology:
- Japan's domestic aviation ~94-109 g/pkm is CO2-only (no RF)
  and reflects high-load trunk routes; DEFRA domestic ~229-246
  includes RF and CH4/N2O. Not contradictory -- different scopes.
  The app ships DEFRA-with-RF and the methodology sheet says so.
- Japan's private-car per-passenger-km (~127) embeds average
  occupancy ~1.3; our dataset stores per-vehicle-km and divides
  by user-selected occupants instead.

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
**386 g CO2/kWh**. EV factor = verified real-world consumption
0.188 kWh/km (EV Database, "Average: 188 Wh/km") x 386 =
**72.6 -> ship 73 g/km**. Anchor points to document in the
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
- Absolute per-passenger-km: **20 g CO2/pkm** adopted. Two
  agreeing sources: the FY2023 figure reported by Planet Forward
  (https://planetforward.org/story/japans-trains-climate/, "rail
  travel emits just 20 grams of CO2 per passenger-kilometer" --
  the page does not name the underlying reporter; do not
  attribute it to a specific JR company) and
  the MLIT-supervised Navitime reference page
  (https://www.navitime.co.jp/pcstorage/html/co2info.html:
  airplane 96, train 20, bus 66, car 145 g/km; source line
  "運輸・交通と環境2018年版", MLIT environment policy division).
  Note this is Japan rail average (Shinkansen-specific would be
  similar or better at typical load factors); basis matches our
  per-passenger-km convention.
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
| E-bike | 2 (derived) | electricity only: 5.3 Wh/km x 386 g/kWh house grid | Medium |
| E-scooter (private) | 6 (derived) | electricity only: ~15 Wh/km x 386 g/kWh house grid | Medium |

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
  electricity only at house grid: ~15 Wh/km x 386 g/kWh = ~6 g/km
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
| ebike | E-bike | 2 | pkm | derived: electricity only, 5.3 Wh/km x 386 house grid (sec 3.3) | Medium |
| escooter_private | E-scooter (private) | 6 | pkm | derived: 15 Wh/km x 386 (Springer 2024 consumption) | Medium |
| car_petrol_small | Small petrol car | 143.08 | vkm | DEFRA 2025 | High |
| car_petrol_medium | Medium petrol car | 174.74 | vkm | DEFRA 2025 | High |
| car_petrol_large | Large petrol car / SUV | 268.28 | vkm | DEFRA 2025 | High |
| car_petrol_avg | Petrol car (average) | 162.72 | vkm | DEFRA 2025 | High |
| car_diesel_avg | Diesel car (average) | 173.04 | vkm | DEFRA 2025 | High |
| car_hybrid | Hybrid car | 128.25 | vkm | DEFRA 2025 | High |
| car_bev | Electric car | 73 | vkm | derived: 0.188 kWh/km x 386 house grid | Medium-high |
| motorbike | Motorbike (average) | 113.67 | vkm | DEFRA 2025 | High |
| bus_city | City bus | 103.85 | pkm | DEFRA 2025 (avg local bus) | High |
| coach | Coach (long distance) | 27.76 | pkm | DEFRA 2025; 2026 raises ~42% -- re-verify at next pass | High (2025) |
| taxi | Taxi | 208.06 | vkm | DEFRA 2025 regular taxi (R2-D1): duty-cycle uplift, deadheading excluded per DESNZ 5.42 | Medium-high |
| rail_national | Local / national rail | 35.46 | pkm | DEFRA 2025; 2026 -13% flagged | High (2025) |
| rail_international | International rail (Eurostar) | 4.46 | pkm | DEFRA 2025; 2026 raises ~2.5x -- order-of-magnitude only (D3) | High (2025) |
| rail_shinkansen | Shinkansen (bullet train) | 20 | pkm | FY2023 figure via Planet Forward + MLIT-supervised Navitime | Medium-high |
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
5. electric car < every combustion car variant (73 < 128.25+)
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

Resolved this pass: four research tracks merged (3.1-3.3, 4);
greencalculus vintage mixing confirmed and superseded by
per-track verification; aviation figures confirmed with-RF;
Shinkansen basis settled (20 g/pkm, per passenger-km; JR Central
1/12-vs-plane ratio as the quotable fact); e-scooter scope
settled (electricity-only + lifecycle caveat in methodology).

Also resolved: high-impact modes researched and decided
(section 8: private jet -- 1,000 base, shipped at 1,700 with-RF
per decision D2 -- and helicopter 450 ship as a "high-impact"
group; yacht rejected as a mode, kept as an eco-fact candidate).

Resolved 2026-07-18: RF multiplier verified at 1.7 on the DESNZ
2025 methodology paper (sec 4); private jet gains the same uplift
(1,700, decision D2, sec 8.1); ferry_car shipped with the
one-leg-covers-both calc note (decision D3); JSON build step done
(`data/app/transport_modes.json`, 27 modes).

Remaining:

- [ ] Re-verify exact MLIT FY2023/FY2024 chart values before the
      Japan-context numbers appear anywhere user-facing
- [ ] Next DEFRA pass (when 2026 numbers become quotable):
      coach (+42%), national rail (-13%), LU (-44%), BEV UK
      anchor (~30), international rail (~2.5x to ~11);
      re-derive all invariant pins (sec 6)
- [ ] Yacht eco-fact: draft `eco_facts.json` candidate from the
      Barros & Wilk 7,020 t/yr figure (run through
      [AUDIT_FACT_DATA.md](./AUDIT_FACT_DATA.md) criteria)

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

**Use instead as an eco-fact / methodology comparison stat**, the
citable form: "a superyacht with a permanent crew, helicopter
pad, submarines and pools emits about 7,020 tons of CO2 a year"
(Barros & Wilk, Indiana University, via The Conversation,
https://theconversation.com/private-planes-mansions-and-superyachts-what-gives-billionaires-like-musk-and-abramovich-such-a-massive-carbon-footprint-152514,
2021). Candidate for `eco_facts.json` / an Eco-Dex entry rather
than `transport_modes.json`.

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
  Applied to ground and active estimates. Rail-specific circuity
  not separately sourced; ground factor applied (open item).
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
  real. The full 481,671-pair sweep after anchoring: 21 ferry
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
  `metadata.water_blocked` in cities.json (1,248 index pairs);
  the picker suppresses ground/active for them (ferry/air
  unaffected; blocked pairs under 100 km fall back to manual
  entry). Candidates are same-mass pairs PLUS rail_tunnel-linked
  cross-mass pairs (the Channel Tunnel grounds GB-Eurasia, so
  Glasgow-Stavanger needed blocking too). A pair blocks iff its
  chord crosses > 25 km of continuous water (Natural Earth 1:50m
  land polygons) AND no honest land route exists: shortest path
  on a 0.1-deg rasterized land graph -- augmented with 15
  verified FIXED_CROSSINGS (Channel Tunnel, Oresund, Great/
  Little Belt, Bosphorus, 1915 Canakkale, Osman Gazi, Kanmon,
  Seikan, Tokyo Aqua-Line, HZMB, Shenzhen-Zhongshan, King Fahd,
  Johor Causeway, Rio-Antirrio) -- must be within
  1.4 x the shown estimate (grid-underestimation compensated;
  constants in the script header). This kills the fiction class
  (Helsinki-Tallinn cycling, Bahrain-Qatar, Sapporo-Osaka) while
  keeping honest coastal corridors the Round 3 curation wrongly
  blocked (Jakarta-Surabaya, Bangkok-KL, Lagos-Accra,
  Copenhagen-Hamburg, Auckland-Wellington, London-Madrid).
  CLOSED_BORDERS blocks pairs across non-functioning borders
  regardless of water (KP-KR, IL-LB, AM-AZ, RU-FI, verified
  2026-07-19); MANUAL_BLOCK holds what neither polygons nor the
  raster can see (unbridged Congo, Parana-delta raster gaps,
  Narva vehicle closure, measured-dishonest bridge-chain
  corridors like Malmo-Arhus at 1.8x). MANUAL_ALLOW is an empty
  escape hatch by design.

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
- The house grid factor 386 g/kWh sits below current
  global-average estimates (~470-480 g/kWh) and below Japan's
  grid, so the EV/e-bike/e-scooter rows are correspondingly
  generous (EV 73 would be ~86-90 at those factors). App-wide
  house rule per AUDIT_ACTION_DATA.md, out of scope for this
  feature; the planned EV sublabel and the methodology sheet
  carry the context.

Regeneration gate: after ANY change to cities.json or the Dart
gates, run `scripts/generators/sweep_suggestions.py` (seed env).
It replicates the suggestion logic over all 481,671 pairs and
fails on fictional ferries, cross-water ground/active,
port/cap/floor violations, water_blocked leaks, or dead links.
Regeneration order: build_cities.py -> build_water_blocklist.py
-> sweep_suggestions.py; not done until the gate passes.

Open items added by this section:
- [x] Port-anchored ferry links -- DONE (Fix Backlog 3, R3-D4);
      Malta-Sicily can return with ports at Valletta/Pozzallo
      once Catania is force-included
- [ ] JA/ES localization of city names (ship EN-only v1)
- [ ] Rail-specific circuity factor if a citable source lands
- [ ] UI MUST thread `loadWaterBlockedPairs()` into
      `suggestedDistancesKm` (the param defaults to empty with
      no compile-time signal -- forgetting it silently revives
      Helsinki-Tallinn cycling; R4-10) -- belongs in the UI PR
- [ ] Per-mode `maxSuggestKm` (high-impact modes currently have
      no suggestion caps) -- belongs in the UI PR
- [ ] Leg-length -> flight-band mapping (a 400 km leg priced at
      the long-haul rate halves the honest figure) -- belongs in
      the UI PR
