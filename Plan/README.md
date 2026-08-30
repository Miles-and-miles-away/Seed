# Plan directory guide

Where to start, and what each document is.

## Start here

- [DOCUMENT_TYPES.md](./DOCUMENT_TYPES.md) -- what belongs in a
  `PLAN_`, `RESEARCH_`, `PDR_`, `AUDIT_` or `*_ARCHIVE` document.
  Read it before creating one, or before moving content between
  two. This README says which document; that one says what goes in.
- [PLAN_MASTER.md](./PLAN_MASTER.md) -- architecture, data models,
  security posture, and the phase-by-phase development history.
- [APP_PAGES.md](./APP_PAGES.md) -- every screen and navigation
  route, kept in sync with `lib/app/router.dart`.

## Research (the evidence base)

Every emission factor in the app traces to a named source, verbatim
quote, URL and vintage. These documents are the app's data
integrity story:

- [RESEARCH_FOOD.md](./RESEARCH_FOOD.md),
  [RESEARCH_TRANSPORT.md](./RESEARCH_TRANSPORT.md),
  [RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) -- per-domain factors
  and methodology (archives hold closed items).
- [RESEARCH_ACTIONS.md](./RESEARCH_ACTIONS.md) -- how an action's
  CO2 figure is arrived at. Method only: the values live in
  `data/seed/co2_actions_database.json`, and the retired tables are
  in [RESEARCH_ACTIONS_ARCHIVE.md](./RESEARCH_ACTIONS_ARCHIVE.md).
- [RESEARCH_FACTS.md](./RESEARCH_FACTS.md) and
  [RESEARCH_STRATEGY.md](./RESEARCH_STRATEGY.md) -- eco-fact
  sourcing and the overall research method.
- [ANNUAL_RESEARCH_UPDATE.json](./ANNUAL_RESEARCH_UPDATE.json) --
  maintenance ledger: every value that can go stale, ordered by
  dependency.
- [AUDIT_FACT_DATA.md](./AUDIT_FACT_DATA.md) and
  [AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) -- the bar a fact
  or action has to clear before it ships.

## Design reviews (PDRs)

Adversarial review records for the calculators: findings, owner
decisions, and fix ledgers. Historical but load-bearing; standing
data rules live here.

- [PDR_TRANSPORT_CALCULATOR.md](./PDR_TRANSPORT_CALCULATOR.md)
  (+ [archive](./PDR_TRANSPORT_ARCHIVE.md))
- [PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md)
- [PDR_FOOD_CALCULATOR.md](./PDR_FOOD_CALCULATOR.md)
  (+ [archive](./RESEARCH_FOOD_ARCHIVE.md)) -- written
  retrospectively in August 2026; the archive also absorbed the
  delivered v2 item spec.
- [PDR_GRID_REGIONALISATION.md](./PDR_GRID_REGIONALISATION.md)

## Design and operations

- [STYLE_GUIDE.md](./STYLE_GUIDE.md),
  [DESIGN_TOKENS.md](./DESIGN_TOKENS.md),
  [PLAN_FOR_DESIGNER.md](./PLAN_FOR_DESIGNER.md) -- visual language.
- [SECURITY_REPORT.md](./SECURITY_REPORT.md) -- security audit and
  status of findings.
- [DEPLOYMENT_STRATEGY.md](./DEPLOYMENT_STRATEGY.md),
  [SETUP_ANDROID.md](./SETUP_ANDROID.md),
  [SETUP_IOS.md](./SETUP_IOS.md) -- environments and platform setup.
- [TEST_COVERAGE.md](./TEST_COVERAGE.md),
  [GLOSSARY.md](./GLOSSARY.md)

## Phase plans (historical)

[PLAN_PHASE_1.md](./PLAN_PHASE_1.md) through
[PLAN_PHASE_9.md](./PLAN_PHASE_9.md) are point-in-time planning
artifacts, kept for the decision history. File paths and names in
them are as-planned; the code is the as-built reference.
