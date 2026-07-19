# PDR: Phase 8 Food Calculator -- Data Review

**Created:** 2026-07-18 | **Restructured:** 2026-07-19
**Status:** All findings resolved and verified (suite 1586/1586,
analyze clean) except FR-22. Adversarial working-tree review in
progress; findings will be appended to section 1.
**Purpose:** Record of the adversarial review of the food-dataset
work (Phase 8 Part 2, feature 8.7): open items, owner decisions,
and the one-line log of resolved findings. Companions:
[PLAN_PHASE_8.md](./PLAN_PHASE_8.md) Part 2 (feature plan),
[RESEARCH_FOOD.md](./RESEARCH_FOOD.md) (evidence base and source
of truth for the dataset),
[PDR_TRANSPORT_CALCULATOR.md](./PDR_TRANSPORT_CALCULATOR.md)
(sibling review whose lessons set the method).

---

## 1. Open Items

### FR-22 -- stale seeder values (code fixed; RE-SEED PENDING)

Owner decision 2026-07-19: sync `seed_action_library.js` to the
corrected database. Applied: `skip_high_impact_food` 6000 -> 9700
(beef case, matches `meatless_meal_beef`; points 37 -> 45);
`skip_medium_impact_food` kept at 1000 with the derivation now
documented (sits between chicken 890 and pork 1100, conservative
for fish); `plant_milk` 550 -> 460 (matches
`plant_milk_vs_dairy`; stale oat 0.45/L note fixed; points
11 -> 10). Syntax-checked. **Remaining operational step: re-seed
`actionLibrary`** (`node scripts/seed/seed_action_library.js`,
needs the Firebase service account) -- points for those actions
change from the next seed onward.

### Adversarial working-tree review (running 2026-07-19)

Four read-only agents against the uncommitted work: Dart bug
hunt, independent maths recomputation, design red-team,
naive-user deception audit. Findings land here when they report.

### Data open items

Tracked in RESEARCH_FOOD.md section 9: citrus and olive-oil
independent corroboration (paywalled), oats live-input re-read at
next data pass, canned-beans factor, butter tbsp weight, median
fallback provenance rule, dropped un-URLed CarbonCloud rows.

---

## 2. Decisions (owner-approved 2026-07-18)

- **D1 Statistic: P&N MEANS, dataset-wide.** Live-quotable from
  OWID; chocolate ships 46.65 (not the median 18.7). Wayback-cited
  medians are the approved fallback if a mean disappears -- any
  fallback item discloses its statistic in calculation_notes and
  the science sheet. Binds: action corrections (9700/890/1100),
  milk note at 3.15, and a mandatory "you may have seen beef = 60"
  methodology explainer.
- **D2 Beer: 1.2 kg CO2e/L** (P&N anchor); packaged-beer LCA range
  (0.51-0.84) recorded as spread context only.
- **D3 Oats: average of P&N anchor and CarbonCloud live value**,
  recomputed from access-dated inputs: (2.48 + 1.20)/2 = **1.84**.
  Arithmetic shown in calculation_notes; confidence Medium;
  re-read the drifting input at each data pass.

Standing rules: no points anywhere in v1 (No Fake Points); global
category means with spread disclosed; no organic/local modifier;
JSON stores exact values, UI rounds; comparative copy only at
>= 20% delta; never-pin ordering list in RESEARCH_FOOD.md sec 6.

---

## 3. Resolved Findings (one line each; B/M/m severity)

All verified in the shipped files 2026-07-19.

Research/coherence findings:

- [x] FR-1 (B) Corpus mixed statistics (chocolate median vs means
      elsewhere) -> D1: means everywhere, chocolate 46.65.
- [x] FR-2 (B) ">3x herd ratio" invariant false (actual 2.99x) ->
      pinned as 2.5-3.5 band in tests and plan.
- [x] FR-3 (B) meatless actions matched neither statistic ->
      corrected 9700/890/1100 g, plant-alt baselines standardized.
- [x] FR-4 (M) Plan gotcha mislabelled medians as means -> block
      rewritten to resolved-decisions form.
- [x] FR-5 (M) Plan Part 2 prose/mocks/schema stale under means ->
      regenerated (2.0 kg intro, 2.2 kg mock, 11.2/1.1/0.2 burger,
      68 km equivalency, 9.87 / 170 g schema, 10 g coffee).
- [x] FR-6 (M) "Medians not verifiable" claim false (Wayback
      reproduces them) -> rationale corrected in RESEARCH_FOOD.md.
- [x] FR-7 (M) "Article rounds 99.48 to 60" annotation false (60
      is the median) -> removed.
- [x] FR-8 (M) Beans/lentils is 1.79 not ~1; peas quote must never
      attach to it -> shipped 1.79 with note; rule recorded.
- [x] FR-9 (M) Oats anchor conflict (2.48 vs CarbonCloud) -> D3.
- [x] FR-10 (M) Beer basis conflict -> D2.
- [x] FR-11 (M) Coffee per-kg bar misleads -> preset-default +
      sublabel + no-superlatives (RESEARCH_FOOD.md sec 8).
- [x] FR-12 (M) Chocolate LUC-dominated -> mandatory sublabel +
      statistic note (sec 8).
- [x] FR-13 (M) Nuts LUC credit -> science-sheet note, no
      "lowest-impact" copy, never display negatives (sec 8).
- [x] FR-14 (M) Disclosed corroboration gaps -> open items (sec 9);
      partially closed by QA-8.
- [x] FR-15 (M) "Single vintage" over-claim -> statistic + losses
      recorded per item; plan research rule upgraded.
- [x] FR-16 (m) Six prose arithmetic slips -> fixed in assembly.
- [x] FR-17 (m) "Shrimps (farmed)" CSV row mapping undocumented ->
      calculation_notes line; CSV header quote fixed.
- [x] FR-18 (m) Flattering display roundings -> JSON stores exact
      values (12.31, 0.51...), UI rounds.
- [x] FR-19 (m) Track disagreement on plant_milk flag -> 460 g
      unchanged (conservative), note aligned to 3.15.
- [x] FR-20 (m) Tie clusters invite false-precision copy -> >=20%
      delta rule + stable alpha sort (sec 8); never-pin list held
      out of tests.
- [x] FR-21 (m) Preset weights unpinned -> researched sourced
      weights shipped (breast 170 g; palm tbsp 13.6 g via FDC).

Quote audit (live re-fetch of ~88 pairs, 2026-07-18; no factor
rested on a failed quote):

- [x] QA-1 (B) Fabricated tomato-spread citation (wrong paper,
      unfindable quotes) -> replaced with live-verified Theurl
      2014 quotes (qualitative only); numeric range blocked as
      unsourced (open item, sec 9).
- [x] QA-2 (M) Spliced OWID quote -> two separate verbatim quotes.
- [x] QA-3 (M) Un-URLed butter candidate -> dropped; 12.0 stands.
- [x] QA-4 (m) NIAAA wording; unfindable SCA clause -> exact page
      wording; only the verifiable 55 g/L clause kept.
- [x] QA-5 (m) CFR row name inexact -> "Breads (excluding sweet
      quick type), rolls".
- [x] QA-6 (M) CarbonCloud values drift; URLs missing -> demoted
      to corroboration-with-access-date (metadata.citation_note);
      D3 uses the live 1.20.
- [x] QA-7 (m) Verified-but-un-URLed quotes -> URLs added.
- [x] QA-8 (--) Closures: PMC ranges verbatim on live page; FDC
      palm "1 tbsp = 13.6 g"; Wayback chocolate median (moot
      under D1).

---

## 4. Executed Backlog

1. [x] 2026-07-18 Owner decisions D1-D3 (section 2).
2. [x] 2026-07-18 Quote audit, ~88 pairs live-fetched.
3. [x] 2026-07-19 `Plan/RESEARCH_FOOD.md` assembled -- the
       dataset's source of truth; all FR/QA corrections applied.
4. [x] 2026-07-18 `PLAN_PHASE_8.md` Part 2 corrected and
       research-complete note added.
5. [x] 2026-07-19 `data/app/food_items.json` built: 37 items,
       exact unrounded factors, sourced presets, audit-cleared
       quotes (pubspec already covers `data/app/`).
6. [x] 2026-07-19 `data/seed/co2_actions_database.json` + CSV
       corrected (9700/890/1100; 460 note aligned; metadata 1.1).
       Surfaced FR-22.
7. [x] 2026-07-19 Dataset tests in `test/features/food/data/`:
       schema validation, 10 safe pins (band, coffee guardrail),
       action-consistency; dart:io-loaded until the food module
       lands.
8. [x] UI/copy requirements recorded as RESEARCH_FOOD.md sec 8.

Verification: `flutter analyze` clean; full suite 1586/1586.

---

## Appendix A: Review Method & Verified-Sound Record

Method: five parallel research agents (one per food-group
cluster) under the RESEARCH_TRANSPORT.md contract (OWID/P&N
anchor + independent source per factor, verbatim live-fetched
quotes, statistic/vintage recorded, presets sourced, conservative
rounding, averaging permitted with arithmetic shown). Then three
adversarial check agents: live quote re-fetch (~88 pairs),
independent recomputation (152 checks: 150 pass, 2 cosmetic),
merged-corpus coherence (both-statistics master table, invariant
margins under both statistics, action-data consistency, plan-doc
delta sweep). The statistic decision (D1) was found independently
by three of the eight agents. Raw agent reports lived in the
session scratchpad (ephemeral); all durable content was merged
into RESEARCH_FOOD.md.

Verified sound at review time: every OWID supply-chain sum
reproduces digit-for-digit; all derivation chains (bread/pasta,
coffee per-cup, beer per-unit to per-litre, eggs, presets)
recompute; zero OWID CSV drift; the retired median set reproduced
from Wayback (beef 59.6, pork 7.2, chicken 6.1...), confirming
the plan's illustrative table is the median set; safe-pin margins
as listed in RESEARCH_FOOD.md sec 6; `plant_milk_vs_dairy`
conservative under both statistics.
