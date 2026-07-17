# Transport Emission Factor Research

**Version:** 1.0
**Created:** 2026-07-17
**Status:** Initial research pass complete (24 shipped modes
decided; open items tracked in section 7)
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
| International rail (Eurostar) | +154 to -156% | "significant changes in service patterns and rolling stock utilisation" -- the famous 4 g/pkm figure is obsolete |
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
| Taxi (regular) | 148.61 | passenger-km | Medium (single source) |

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
  agreeing sources: JR East FY2023 environmental-report figure as
  restated by Planet Forward
  (https://planetforward.org/story/japans-trains-climate/, "rail
  travel emits just 20 grams of CO2 per passenger-kilometer") and
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
| Walking | 0 | direct emissions (metabolic excluded by convention) | High |
| Cycling | 16 | marginal food, average European diet (OWID) | High |
| E-bike | 8 (derived) | food 6.3 + electricity ~1.5-2; manufacture excluded | Medium |
| E-scooter (private) | 6 (derived) | electricity only: ~15 Wh/km x 386 g/kWh house grid | Medium |

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
- Current 2025/2026 releases: strong secondary evidence the
  multiplier is now **1.7** (Thrust Carbon: "DEFRA factors
  include radiative forcing at 1.7x"; greencalculus data page:
  "High-altitude non-CO2 effects add roughly 1.7x"). Not yet
  verified against the DESNZ methodology paper itself (PDF).
  **Do not print "1.9x" in app copy**; say "includes the
  high-altitude uplift" and verify 1.7 before quoting a number.
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
| cycle | Cycling | 16 | pkm | OWID, food-only | High |
| ebike | E-bike | 8 | pkm | derived: ECF components minus manufacture, house grid | Medium |
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
| rail_national | Local / national rail | 35.46 | pkm | DEFRA 2025; 2026 -13% flagged | High (2025) |
| rail_shinkansen | Shinkansen (bullet train) | 20 | pkm | JR East FY2023 via Planet Forward + MLIT-supervised Navitime | Medium-high |
| metro | Metro / underground | 27.8 | pkm | DEFRA 2025 (London Underground); 2026 -44% flagged | High (2025) |
| tram | Tram / light rail | 28.6 | pkm | DEFRA 2025 | High |
| ferry_foot | Ferry (foot passenger) | 18.71 | pkm | DEFRA 2025 | High |
| flight_domestic | Domestic flight | 229.28 | pkm | DEFRA 2025, avg passenger, with RF | High |
| flight_shorthaul | Short-haul flight (economy) | 125.76 | pkm | DEFRA 2025, with RF | High |
| flight_longhaul | Long-haul flight (economy) | 117.04 | pkm | DEFRA 2025, with RF | High |
| private_jet | Private jet | 1000 | pkm | derived (sec 8.1); CE Delft 5-14x band; no RF | Medium |
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
- Eurostar/international rail (4.46): Europe-specific and about
  to more than double in the 2026 set; kept as methodology
  context, not a mode.
- Ferry with car (129.33): v1 ships foot passenger; car-ferry
  needs journey-builder UX thought (it is a car leg AND a ferry
  leg). Open item.
- Yacht: not defensible as a per-km mode (section 8.3); ships as
  an eco-fact candidate instead.

**Cabin class:** economy factors shipped; multipliers (premium
1.6x, business 1.5x SH / 2.9x LH, first 4.0x) documented in the
methodology sheet, selector deferred.

---

## 6. Sanity Invariants (for the test suite)

Pin these orderings as dataset regression tests (all hold for the
section 5 values; each survives the flagged 2026 revisions):

1. walking < cycling-family (cycle, ebike, escooter_private) <
   every motorized mode's per-passenger figure
2. shinkansen <= metro/tram/national-rail band (20 <= 27.8-35.46)
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
10. private jet > every other mode (1000 > 450)

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
(section 8: private jet 1000 and helicopter 450 ship as a
"high-impact" group; yacht rejected as a mode, kept as an
eco-fact candidate).

Remaining:

- [ ] Verify the DESNZ 2025/2026 RF multiplier (1.7 vs legacy
      1.9) against the methodology paper before any in-app copy
      quotes a number (factors shipped are with-RF either way)
- [ ] Re-verify exact MLIT FY2023/FY2024 chart values before the
      Japan-context numbers appear anywhere user-facing
- [ ] Next DEFRA pass (when 2026 numbers become quotable):
      coach (+42%), national rail (-13%), LU (-44%), BEV UK
      anchor (~30); re-run invariant checks
- [ ] Car-ferry UX question (car leg + ferry leg) before adding
      ferry_car (129.33, verified, on the shelf)
- [ ] When the RF multiplier is verified, decide whether the
      private-jet factor gains the same uplift as airline rows
      (currently combustion-only, i.e. conservative; ~1,700 with
      a 1.7x uplift)
- [ ] Yacht eco-fact: draft `eco_facts.json` candidate from the
      Barros & Wilk 7,020 t/yr figure (run through
      [AUDIT_FACT_DATA.md](./AUDIT_FACT_DATA.md) criteria)
- [ ] JSON build step: convert section 5 + per-mode sources into
      `data/app/transport_modes.json` with EN/JA/ES names
      (Phase 8.1 implementation order step 2)

---

## 8. High-Impact Modes (verified 2026-07-17)

Requested addition for comparison-view education value. Verdict:
**ship private jet and helicopter (derived factors, fully
citable inputs); do not ship yacht as a journey mode.**

### 8.1 Private jet -- SHIP at 1,000 g CO2e/pkm (derived)

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
  the same within 1%
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

**Chosen: 1,000 g CO2e/pkm**, calc note "derived: light-midsize
jet cruise 0.53-0.74 at 4 pax; CE Delft 5-14x commercial supports
0.6-3.2 band for real-world hops; mid-band chosen, combustion
CO2e only". **No RF uplift applied** (inputs are combustion-only;
the airline factors embed DEFRA's uplift, this one does not --
the private-jet bar is therefore CONSERVATIVE, and still ~4-9x
the airline bars). Revisit with the RF multiplier open item.

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
