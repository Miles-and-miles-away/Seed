# PDR: Grid Factor Regionalisation -- Research Brief

**Created:** 2026-08-02
**Status:** NOT STARTED. Scoped out of decision E1
(see [PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md)
section 2) so the
Part 3 energy dataset could ship against a single global constant.
This document is the brief a future research agent works from.
**Purpose:** Decide whether, and how, Seed should use
region-specific electricity grid emission factors instead of the
single global constant it ships today.
**Owner decision required before any code is written.** This is a
research-and-recommend brief, not an approved feature.
**Companion docs:** [RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md)
(E1 and the crossover evidence),
[RESEARCH_TRANSPORT.md](./RESEARCH_TRANSPORT.md) (EV factor),
[ANNUAL_RESEARCH_UPDATE.json](./ANNUAL_RESEARCH_UPDATE.json)
(maintenance ledger this feature would add to),
[AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) (sourcing rules).

---

## 1. Why this exists

Seed ships **one** electricity grid factor for every user on
Earth. As of decision E1 (2026-08-02) that is **458 g CO2e/kWh**
(Ember Global Electricity Review 2026, 2025 data). National grids
diverge by more than an order of magnitude, so a single constant
is wrong for essentially every individual user -- the only
question is by how much, and whether it ever changes an answer
rather than just a magnitude.

Four concrete harms are on record. The ranking matters: **the
first two are correctness failures -- the app states or implies
something untrue for the user -- the rest are accuracy failures.**

### 1.1 The carrier crossover reverses a real-world answer

Gas water heating emits less carbon than resistance-electric
water heating **only above a grid factor of 241 g CO2e/kWh**.
Below that, electric wins. Applied to Seed's shipped shower entry
(0.248111 kWh/min electric, 0.328036 kWh/min gas -- values as
corrected 2026-08-02 for delta-T and calorific basis):

| Grid | Electric | Gas | Winner |
|------|---------:|----:|--------|
| UK, DEFRA 2026 (131) | 32.5 g/min | 59.7 | **electric, 1.8x** |
| Shipped global (458) | 113.6 | 59.7 | gas, 1.9x |
| IEA 2030 forecast (360) | 89.3 | 59.7 | gas, 1.5x |
| Japan (429) | 106.4 | 59.7 | gas, 1.8x |
| India (695, IEA 2025) | 172.4 | 59.7 | gas, 2.9x |

**The UK has already crossed over.** A British user is told the
opposite of the truth about their own home. France, Sweden,
Norway and much of the Nordic/nuclear-hydro bloc are further past
the crossover than the UK -- and the global grid is forecast to
reach 360 g by 2030, closing on the 241 threshold.

Mitigation specified but not yet shipped, since the feature is
unbuilt: the comparison gating
([PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md) sec 3)
(same `comparable_group` + same `carrier` + >=20% delta) is
binding on the build, and it will stop the app *asserting* any
cross-carrier verdict, so the app will never print the wrong
sentence. **But it will still display both numbers**, and a user
does not need the app's sentence to read 59.7 < 113.6.
Regionalisation is the only fix that makes the displayed numbers
right.

### 1.2 UK heat pumps: the global factor hides a 3.5x argument

Added 2026-08-02 from the gas-central-heating research. A 1 C
thermostat setback in a UK gas-heated home is 1,530 kWh/year
(DECC/CAR) = **279 kg CO2e**. The same heat from an air-source
heat pump, at the median measured SPFH4 of 2.78 from the
Electrification of Heat project (n=428 real UK installs), is ~479
kWh of electricity:

| Grid used | ASHP | Gas boiler | Gas is worse by |
|-----------|-----:|-----------:|----------------:|
| UK, DEFRA 2026 (131) | 62.8 kg | 278.9 kg | **4.44x** |
| App global default (458) | 219.5 kg | 278.9 kg | 1.27x |

**Using the global factor understates the UK heat-pump case by
3.5x.** The app's flagship heating lesson -- heat pumps crush
resistance heating -- is real for UK gas-vs-heat-pump too, but
only at the UK's own decarbonised grid. This is the clearest
example so far of a single global factor not merely being
imprecise but muting a true and important claim.

### 1.3 The EV factor is ungated and highly visible

`transport_modes.json` ships `car_bev` at 0.188 kWh/km x the
house factor. At E1's 458 that is **86 g/km**. A UK user's real
figure is 0.188 x 131 = **25 g/km** -- the app overstates their
EV by ~3.4x, on the single most emotionally loaded number a
sustainability app displays, and in a cross-modal comparison
(EV vs petrol car) that has no gating equivalent to the energy
dataset's carrier rule.

**This is arguably a bigger problem than the energy dataset**,
and it is already shipped. Any regionalisation work must cover
transport, not just Part 3.

### 1.4 Absolute values are wrong for everyone

Points, cumulative "CO2 saved", and every per-action gram figure
scale linearly with the factor. No comparison breaks, but the
absolute numbers a user reads, screenshots and repeats are off by
whatever their grid differs from the global mean. Severity is
lower (no leaderboards, users are isolated, so nothing is
*unfair*) but it is the harm that touches every screen.

---

## 2. Standing decisions this work must respect

Read these before proposing anything. They are settled and are
not open for re-litigation in this brief.

1. **CO2e, not CO2.** The whole app is denominated in CO2e (food
   is CO2e; transport is CO2e including the 1.7x aviation RF
   uplift). Any regional factor must be CO2e or be explicitly
   scope-converted with the conversion documented. The observed
   CO2e-over-CO2 uplift at global scale is **+5.3%** (Ember 458
   vs IEA 435, both 2025 data) -- do not assume that ratio holds
   per country without checking.
2. **One factor, one meaning.** `grid_factor_g_per_kwh` is shared
   between `transport_modes.json` and `energy_behaviors.json` and
   pinned by a cross-dataset test. Whatever replaces it must
   preserve a single source of truth -- two datasets must never
   be able to disagree about the same user's grid.
3. **Operational boundary.** Generation-basis, no well-to-tank,
   consistent with the transport dataset and the gas factor
   (182 g/kWh combustion-only). Do not mix in a lifecycle grid
   factor.
4. **D1 discipline.** Never average two figures computed on
   different statistics or boundaries. This killed the
   "average IEA and Ember" proposal in E1 and it will recur
   per-country, where sources are far more heterogeneous.
5. **Honest, not generous.** Where a country's sources disagree,
   pick conservatively and disclose the spread.
6. **Comparison gating stays.** Regionalisation does not replace
   the gating rule ([PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md)
   sec 3); the two are complementary. If anything,
   regional factors make *more* comparisons safe to assert, which
   is a benefit to quantify.
7. **No new user obligation.** The app must remain fully usable
   by someone who never opens settings and never tells us where
   they are.

---

## 3. What is already sourced (do not re-research)

The E1 pass and the browser session on 2026-08-02 already
established these, live-verified. Start here.

| Scope | Value | Source | Status |
|-------|------:|--------|--------|
| Global | 458 g CO2e/kWh (2025) | Ember GER 2026 | live-verified |
| Global | 435 g CO2/kWh (2025), 360 by 2030 | IEA *Electricity 2026* | live-verified |
| EU | 170 g CO2/kWh (2025), 90 by 2030 | IEA *Electricity 2026* | live-verified |
| China | 530 (2025), 415 by 2030 | IEA *Electricity 2026* | live-verified |
| India | 695 (2025), 585 by 2030 | IEA *Electricity 2026* | live-verified |
| Southeast Asia | 640 (2025), 615 by 2030 | IEA *Electricity 2026* | live-verified |
| Japan | 429 g CO2/kWh (令和6年提出用代替値) | 資源エネルギー庁 | live-verified |
| Japan | 416 g CO2/kWh (FY2024-25, 61 utilities) | Argus | live-verified |
| Japan | 423 g CO2/kWh (令和5年度全国平均) | 環境省 家庭CO2統計 | reported, re-verify |
| UK | 131 g CO2e/kWh (2026 release) | DEFRA/DESNZ flat file | extracted from primary |
| UK | 154 g/kWh (2024 generation) | DESNZ Fuel Mix Disclosure | reported, re-verify |

**Key finding that lowers the cost of this work:** IEA's
*Electricity 2026* emissions page publishes a regional table for
free, with 2030 forecasts, from one tier-1 source on one page.
Ember publishes per-country data for 215 countries (detailed 2025
data for 91 countries, ~93% of global demand) under an open
licence. The sourcing burden for a coarse scheme is close to
already paid.

Note also: `co2_actions_database.json` metadata, created
2026-01-31, already contains the project's own earlier
recommendation --
`"note": "Energy savings vary significantly by region. Allow user
input for local grid factor."` That recommendation was dropped
without being argued down, and the two reference points it cited
(US 370, UK 210) were later mis-averaged into the 386 that E1
retired.

---

## 4. Research questions

Answer these in order. Stop and report if 4.1 comes back "no".

### 4.1 Is regionalisation worth doing at all?

Quantify the benefit rather than assuming it. Specifically:

- How many of Seed's likely users live in a country where the
  shipped global factor is wrong by more than, say, 30%?
  (Requires a defensible assumption about market distribution --
  Japan primary, then EN- and ES-speaking markets.)
- How many **displayed answers** actually change, not just
  magnitudes? The crossover list is the place to start: every
  gas-vs-electric pair in `energy_behaviors.json`, plus the EV
  comparison in `transport_modes.json`.
- Does the comparison gating already neutralise enough of the
  harm that the remaining benefit is cosmetic?

A credible "no, not worth it" answer is a valid deliverable.

### 4.2 What granularity?

Cost and rank at least these, do not assume the finest is best:

| Option | Sketch |
|--------|--------|
| A. Status quo | One global CO2e constant, disclosed vintage and direction of error |
| B. Coarse buckets | 4-6 buckets (e.g. Japan / low-carbon / US / high-carbon / global fallback) |
| C. Per-country | ~90 countries from Ember's open dataset |
| D. Sub-national | US eGRID subregions, JP per-utility (電気事業者別排出係数) |

For each: initial sourcing effort, annual maintenance effort,
number of values that can silently go stale, and what it buys in
terms of 4.1's metrics. Note that the US and Japan both publish
sub-national data, so option D is genuinely available for the two
largest anglophone/JP markets even if it is rejected.

### 4.3 How does a user get the right factor?

The hard part, and the reason this is not a data-only change.

- What signal is available? Device locale is a **weak** proxy --
  `es` does not distinguish Spain (~150-200) from Mexico (~400);
  `en` distinguishes nothing at all. Assess honestly.
- Is there an existing country/region signal in the user model or
  the auth flow? (The transport module already ships ISO-3166
  codes for `cities.json`, so country plumbing exists somewhere
  in the repo -- find it before building new.)
- Should the default be the global fallback, or Japan (primary
  market), or locale-derived? What is the failure mode of each
  when wrong?
- Onboarding question vs settings-only vs silent default with a
  correction prompt. Weigh against standing decision 7.
- **Explicitly consider not asking at all**: display the global
  figure with a "your grid may differ -- see methodology" link.

### 4.4 What is the maintenance contract?

This is the strongest argument against regionalisation and must
be answered, not waved at. The UK factor moved **26% in a single
annual release** (0.17700 -> 0.13096). Multiply that volatility
by N regions.

- Which source can supply all regions from one place, so the
  annual refresh is one fetch and not N? (Ember is the obvious
  candidate; verify licence, format stability, and whether it
  publishes CO2e per country or only CO2.)
- Can the refresh be scripted and diff-checked, with a test that
  fails when any value drifts more than a threshold?
- What is the rollback story if a refresh ships a bad table?
- Add whatever is decided to
  [ANNUAL_RESEARCH_UPDATE.json](./ANNUAL_RESEARCH_UPDATE.json).

### 4.5 Marginal vs average (raised in the E1 review, unresolved)

Seed's claims are **consequential** -- "you avoided X grams by
taking a shorter shower." The literature holds that avoided
emissions from a demand change are properly measured with a
*marginal* emission factor, not an average one. Marginal
intensity swings from roughly 60 to 900 g CO2e/kWh depending on
grid and time of day, so no static constant represents it.

Research whether this changes the recommendation, and note that
it may argue *against* fine-grained regional averages: chasing
spatial precision while ignoring a larger temporal/marginal error
is false precision. At minimum, produce the methodology paragraph
the app should carry. This applies to every consumer carbon app,
so "everyone does it this way" is a legitimate partial defence --
but it should be stated, not assumed.

### 4.6 Transmission and distribution losses

Global T&D losses are ~8%. If the app models socket kWh but cites
generation-basis intensity, every electricity figure is
understated by roughly that much. Establish whether the shipped
sources are generation- or delivery-basis, and whether a
correction is warranted. This is orthogonal to regionalisation
but was surfaced in the same review and should be settled once.

---

## 5. Deliverables

1. `Plan/RESEARCH_GRID_REGIONS.md` (not yet written), following the
   house research format (source landscape, scope decision, verified
   values with verbatim quotes + URLs + access dates, chosen values,
   sanity invariants, open items, a `GRID_LOGIC_CHECK` arithmetic
   section).
2. A ranked recommendation across the options in 4.2, with the
   4.1 benefit quantified, and an explicit owner decision to make.
3. If the recommendation is to regionalise: the proposed data
   file and schema, the UX for factor selection, the maintenance
   contract from 4.4, and the migration note for existing
   `transport_modes.json` / `energy_behaviors.json` metadata.
4. Additions to
   [ANNUAL_RESEARCH_UPDATE.json](./ANNUAL_RESEARCH_UPDATE.json)
   for anything new that will need yearly review.
5. A methodology paragraph on marginal-vs-average (4.5) and a
   ruling on T&D losses (4.6), regardless of the main
   recommendation.

---

## 5.1 What the app is set to tell users

Nothing is live yet: the home-energy methodology screen has not
been built, and `lib/features/energy/` does not exist. What
exists is the approved draft copy for it, in
[PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md) section 6.
That draft carries a full disclosure that regionalisation was
considered and not shipped, with the regional spread in real
numbers and the three mitigations named, and it ships with the
screen when the screen is built.

**If this work recommends shipping regional factors, that draft
copy is the first thing that must change** -- it makes a positive
claim ("we use one global figure, here is why") that would become
false. Treat rewriting it as part of the deliverable, in all
three locales.

The strongest line in that copy is worth carrying into this
research as a benchmark to beat: within-carrier comparisons are
already grid-independent. A bath costs 2.29x a ten-minute shower
on every grid from the UK's 131 to India's 695 g CO2e/kWh. Any
regionalisation proposal has to justify itself against how much is
*already* correct for every user without it.

---

## 6. Constraints and non-goals

- **Non-goal: real-time or time-of-day carbon intensity.** APIs
  exist (Electricity Maps, WattTime, UK NESO) but they add a
  network dependency, a key, a cost and an offline-failure mode
  to an app whose datasets are deliberately bundled and static.
  Out of scope unless 4.5 produces an overwhelming argument.
- **Non-goal: user-entered custom factors.** A free-text g/kWh
  field is a support burden and an invitation to nonsense values.
  A picker from a curated list is the ceiling.
- **Non-goal: re-opening E1.** 458 is the global default. This
  work decides whether anything sits alongside it.
- **Budget the maintenance honestly.** The team has already
  produced one undetected arithmetic error on a *single* global
  constant (the retired 386, whose documented derivation computed
  to 290). More values is more surface area for exactly that
  failure. A scheme that cannot be verified by a test is not an
  acceptable scheme.
- **Pre-launch.** `pubspec.yaml` is at `0.1.0+1`; no production
  users, no migration, no historical data to preserve. Logged
  actions snapshot `co2Grams` and `points` at write time
  (`ActionLogModel`), so nothing is retroactive even after
  launch. Do not inflate change-cost estimates on the assumption
  of a live user base.

---

## 7. Verification

Whatever ships must satisfy:

- Every regional value has source name, verbatim quote, full URL,
  access date, and vintage year, per
  [AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) sections 2 and 8.
- A test asserts the transport and energy datasets resolve the
  same factor for the same user.
- A test asserts every regional value is within a sane band
  (e.g. 0 < x < 1200 g CO2e/kWh) and that no two regions share an
  id.
- A drift test flags any value that moves more than a set
  threshold at refresh, so a bad table fails loudly.
- `flutter analyze` clean; `flutter test` green.
- [APP_PAGES.md](./APP_PAGES.md) updated if any screen or setting
  is added (standing rule).
