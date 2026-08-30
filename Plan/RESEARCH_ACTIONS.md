# Action Library Research Methodology

**Created:** 2026-01-31 | **Rewritten:** 2026-08-29
**Status:** Live. The value tables this document used to carry were
moved to
[RESEARCH_ACTIONS_ARCHIVE.md](./RESEARCH_ACTIONS_ARCHIVE.md) on
2026-08-29, because only 1 of their 62 rows still matched what
ships. What remains here is the method, which does not go stale the
way a table does.
**Purpose:** How action CO2 figures are arrived at, and the findings
that shape how they are counted. Read it before researching a new
action, and read
[AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) before writing one.
**Feeds:** `data/seed/co2_actions_database.json`, which is the
single authority for every shipped action value. No value is
restated here.
**Companion docs:**
[AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md) (the bar an action
must clear: logging unit, schema, points, checklist),
[RESEARCH_TRANSPORT.md](./RESEARCH_TRANSPORT.md),
[RESEARCH_FOOD.md](./RESEARCH_FOOD.md) and
[RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) (per-domain evidence),
[DOCUMENT_TYPES.md](./DOCUMENT_TYPES.md) (what belongs here).

---

## 1. Method in brief

An action's figure is the **difference between two realistic
behaviours**, not the footprint of one of them: biking instead of
driving is the car's emissions minus the cyclist's, and the second
term is not zero.

Every figure is built the same way:

1. **Define the logging unit first.** What the user taps has to mean
   one determinate thing. "Recycle textiles" could be a sock or a
   bin bag. AUDIT_ACTION_DATA.md section 1 owns this, and it is the
   most common source of a wrong number.
2. **Take the baseline from a tier-1 source**, in preference order:
   UK DEFRA/DESNZ conversion factors, US EPA, then a peer-reviewed
   meta-analysis (Poore & Nemecek 2018 for food). Aggregator sites
   are corroboration, never an anchor.
3. **Corroborate against a second independent source.** A figure
   with one source does not ship.
4. **Subtract the honest counterfactual.** The alternative behaviour
   has emissions too, and the plant-based baseline, the cyclist's
   food energy and the bus's occupancy all belong in the sum.
5. **Round the saving down.** Where a range is defensible, ship its
   conservative end. Rounding toward a smaller reward is the only
   direction that cannot mislead.
6. **Record the vintage.** Every factor carries the year of the
   source it came from, so the annual pass can find it
   (`ANNUAL_RESEARCH_UPDATE.json`).

Shared carrier constants -- the electricity grid factor above all --
are defined once in AUDIT_ACTION_DATA.md section 8 and used
everywhere. Never re-derive one locally.

## 2. Confidence ratings

The rating is about **source agreement**, not about how much we like
the number.

| Rating | Meaning |
|---|---|
| High | Two or more tier-1 sources agree within 20% |
| Medium | Sources agree on direction, differ in magnitude |
| Low | Limited data, heavy regional variation, or contested methodology |

A Low rating is a reason to state the caveat in user-facing copy,
not a reason to omit the action. It is also a reason to be
especially conservative in step 5.

## 3. Findings that change how an action is counted

These are the results that a naive calculation gets wrong. They are
the durable output of the research pass, and each has cost someone a
wrong number at least once.

**Transport is a small share of food emissions.** Roughly 5-6%
globally. What is eaten dominates where it came from, to the point
that produce shipped from a warm country can beat a heated local
greenhouse in winter. "Local" actions may only claim transport
savings, and must not imply more.

**Growing your own food is usually worse, not better.** Urban
agriculture measures around 6x conventional farming per unit of
food, because raised beds, tools and infrastructure are amortised
over a small yield. It saves emissions only where the infrastructure
lasts decades, or where it displaces air-freighted or greenhouse
produce. Community gardening is worth tracking for food security,
health and social connection, and should not carry a CO2 claim.

**Reusables owe a debt before they save anything.** A cotton bag
needs on the order of 150 uses to beat single-use plastic on
climate, and vastly more to beat it on every environmental
indicator. Polypropylene breaks even in tens of uses. An action that
credits a reusable on every use is crediting a debt that may never
be repaid: credit the switch, or set the unit past the break-even.

**Reuse and recycling are different magnitudes.** Textile reuse
displacing a new garment saves several times what mechanical
recycling of the same kilogram saves, because recycling degrades
fibre quality. Do not average them into one figure.

**Recycling ranges hinge on one accounting choice**: whether avoided
landfill methane is counted alongside avoided virgin production.
Paper and cardboard figures swing several-fold on that alone. State
which basis is used. Aluminium is the exception where sources
converge, at about 95% energy saved against virgin production.

**Secondhand buying rebounds.** Heavy secondhand shoppers tend to
buy more in total, which erodes the saving. Frame the action as
"instead of", never "in addition to".

**Sequestration is not avoided emission.** A planted tree stores
carbon only while it lives, and accumulates over decades rather than
in the year it is logged. Keep it in its own category and never sum
it with avoided emissions as though the two were interchangeable.

**Standby power has largely been regulated away.** Post-2013 devices
are capped near 1 W, so figures from older studies overstate the
saving by an order of magnitude. Old set-top boxes and consoles are
the real exception.

**Pumped rainwater harvesting can increase emissions**, because the
pump costs more than the mains supply it replaces. Only gravity-fed
collection is a saving.

**Short flights are disproportionately intensive**, because a large
share of the fuel goes on takeoff and climb, so per-km figures
understate them. The aviation **radiative forcing multiplier** is a
live methodology decision owned by
[RESEARCH_TRANSPORT.md](./RESEARCH_TRANSPORT.md), which also carries
a binding rule about which figure may appear in app copy. This
document deliberately states no multiplier: the one the original
pass used is superseded.

## 4. What is honest to claim

Some worthwhile actions have no defensible number. Beach cleanups,
sharing knowledge and community organising act through ecosystem
protection and behavioural spillover, neither of which can be
attributed to one person's afternoon.

Track those as **participation, not CO2**. Inventing a figure to
make an action fit the schema is the one failure that costs the app
its credibility, and a user who finds one wrong number stops
believing the right ones. Flagging a counterintuitive finding openly
buys more trust than a clean number does.

The same logic governs display: show midpoints with the unit stated,
put ranges and methodology one tap away, and let the app say when it
does not know.

## 5. SDG coverage

Ten goals carry directly trackable actions: 2, 3, 6, 7, 9, 11, 12,
13, 14 and 15. Goal 13 maps to everything, being the point of the
exercise. Goal 9 (industry, innovation and infrastructure) is the
least obvious of the ten and carries only the two public-transit
swaps, `bus_instead_of_car` and `train_instead_of_car`.

The other seven (1, 4, 5, 8, 10, 16, 17) address systemic
questions -- poverty, education, gender equality, economic systems,
inequality, institutions, partnerships -- that individual daily
habits do not move. They ship as educational content explaining how
personal action connects to them, rather than as actions with
invented footprints.

The live mapping is `sdg_coverage` in
`data/seed/co2_actions_database.json` and the per-action
`related_sdgs` field.
