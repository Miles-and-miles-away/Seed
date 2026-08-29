# Document Types

**Created:** 2026-08-29
**Purpose:** What belongs in each kind of document under `Plan/`, so
a new document lands in the right place and an existing one can be
told when it has drifted. Derived from the conventions the documents
already follow, not invented: where they disagree, the rule below
names which one is the model and why.
**Companion docs:** [README.md](./README.md) is the index of *which*
document to open; this is the definition of *what goes in* each type.

Read this before creating a `Plan/` document, before moving content
between two of them, and before deciding that something is "done"
and can be trimmed.

---

## 1. The families

| Prefix | Holds | Time sense |
|---|---|---|
| `PLAN_` | What we intend to build, and why | Forward |
| `RESEARCH_` | The evidence a value rests on | Standing |
| `PDR_` | Decisions, product rules, review record | Standing |
| `AUDIT_` | The bar new data must clear | Standing |
| `*_ARCHIVE` | Executed and closed detail | Past |
| `SETUP_` | How to get a machine working | Standing |

Anything that fits none of these is a standalone reference
(`APP_PAGES`, `STYLE_GUIDE`, `DESIGN_TOKENS`, `GLOSSARY`,
`TEST_COVERAGE`, `SECURITY_REPORT`, `DEPLOYMENT_STRATEGY`,
`EMULATOR_TESTING`). Standalone is a fallback, not a first choice.

---

## 2. `PLAN_`

The feature plan: goals, deliverables, feature breakdown with
per-item status, data models, implementation order, testing
strategy, acceptance criteria, open questions.

- `PLAN_MASTER.md` is the architecture and the phase history.
- `PLAN_PHASE_N.md` is one phase.
- A plan may go stale about *what shipped*; that is a defect, not a
  licence. The status table is the contract, and prose that
  contradicts it is a bug.

**Not here:** emission factors, source quotes, or the reasoning
behind a value. A plan cites the research document.

## 3. `RESEARCH_`

**The evidence base, and only that.** Source landscape, scope
decision, per-item verified factors with `{name, url, quote,
accessed}`, chosen dataset values, serving presets, the arithmetic
that derives one value from another.

`RESEARCH_ENERGY.md` states the rule best, after it was restructured
to match transport: "this document is the **evidence base only**.
Decisions, product rules, action-library additions, UI/copy
requirements and the methodology screen copy moved to
`PDR_ENERGY_CALCULATOR.md`."

**An evidence base is allowed to be long.** `RESEARCH_TRANSPORT.md`
is ~1,100 lines and `RESEARCH_ENERGY.md` ~1,240, because verbatim
quotes for every shipped factor do not compress. Length is only a
defect when it comes from content that belongs in another type.

**Open with "Method in brief".** Every `RESEARCH_` document starts
with a section of roughly a page answering "how did we arrive at
these numbers": the primary source and why it was chosen, the
statistic, the boundary, the functional unit, the rounding rule, and
the two or three decisions a reader would otherwise trip over. It
gives a reader the method in five minutes without opening the
evidence.

**That section states no values.** Rules, not numbers. The moment a
summary restates a figure it becomes a second place for that figure
to live, and it will drift (section 10). The method is safe to
summarise precisely because it is not written down numerically
anywhere else.

**A methodology document is the other legitimate shape.**
`RESEARCH_ACTIONS.md` is the model: it holds the method and the
findings that change how a figure is counted, states no values, and
points at `data/seed/co2_actions_database.json` for those. Use it
where the evidence for individual values lives in the data file
rather than in prose. It is the right shape when there is no single
source landscape to document, because the actions are drawn from
many domains.

**Two documents carry the `RESEARCH_` prefix without being either
type.** `RESEARCH_FACTS.md` and `RESEARCH_STRATEGY.md` are strategy
for *how to research*, which is closer to `AUDIT_`. Treat them as
legacy and do not copy their shape.

For a new evidence base, copy `RESEARCH_TRANSPORT.md` or
`RESEARCH_ENERGY.md`.

**Not here:** product rules, UI copy requirements, open task lists,
review findings, or fix ledgers.

## 4. `PDR_`

Two documents wear this prefix and they are different jobs. Both are
legitimate; say which one you are writing in the `Purpose` line.

**4a. Post-design review (the common case).** The working record for
building a feature: standing decisions and the reasoning behind
them, product rules, action-library additions, UI and copy
requirements, methodology screen copy, the review-round history, and
a **brief** record of completed work. `PDR_TRANSPORT_CALCULATOR.md`
and `PDR_ENERGY_CALCULATOR.md` are the models.

**4b. Research brief.** A scoped question awaiting an owner
decision, with the evidence needed to answer it and an explicit
"owner decision required before any code is written".
`PDR_GRID_REGIONALISATION.md` is the model.

**Not here:** the evidence base. A PDR cites `RESEARCH_X` and does
not restate its numbers.

## 5. `AUDIT_`

The standing bar a piece of data must clear before it ships:
principles, quality criteria, file inventories, verification
checklists. Written to be read *before* doing the work.

`AUDIT_ACTION_DATA.md` and `AUDIT_FACT_DATA.md` are the models. Note
that neither is named for an audit that happened; both are guides
distilled *from* one. A one-off audit result is a report
(`SECURITY_REPORT.md`), not an `AUDIT_`.

## 6. `*_ARCHIVE`

Executed and closed detail moved out of a live document so it stays
readable.

**One archive per workstream, serving every live document in it.**
`RESEARCH_ENERGY_ARCHIVE.md` holds content from both
`RESEARCH_ENERGY.md` and `PDR_ENERGY_CALCULATOR.md`; that is the
model, and it is why the prefix does not have to match every parent.

Every archive opens by saying so, in these words or close to them:
"Everything here is EXECUTED or CLOSED; nothing below is a live
instruction", followed by where the live rules and the open list
actually are.

**The migration rule.** When work completes, the live document keeps
a one-line record of it and the detail moves here. A closed item
sitting in a live open list is the most common drift in this repo:
check for it whenever you close something.

**Not here:** anything still true and still actionable. If a reader
would need to *do* something because of it, it is not archive
material.

## 7. `SETUP_`

Runbooks for getting a machine or an emulator working. Ordered
steps, prerequisites, and the errors people actually hit.

---

## 8. Rules that cross every type

1. **Header block.** Open with `**Created:**`, `**Status:**` and
   `**Purpose:**`; add `**Version:**`, `**Feeds:**` and
   `**Companion docs:**` where they apply. `Status` says where the
   work stands *now*, not where it stood when the file was made.
2. **Say what you do not hold.** The best headers here name the
   content that lives elsewhere and link to it. That sentence is
   what stops the next person duplicating a number.
3. **One authority per fact.** A value is stated in exactly one
   document; everything else links. `RESEARCH_ENERGY_ARCHIVE.md`
   puts it plainly: the values "are not restated here", so there is
   one place to change.
4. **One live open list per workstream.** Every other document
   points at it and carries none of its own.
5. **Grep-able anchors, not line numbers.** Reference an id, a
   function, a test name, or a short verbatim snippet.
   `foo.dart:142` rots on the next edit above it.
6. **Never link an uncommitted file.** Check `git ls-files` first.
   A scratch `PLAN_2.md` will not exist for anyone else.
7. **No em dash and no arrow glyph**, in any document. Use `--` and
   `->`. `GLOSSARY.md` predates this rule and still violates it.
8. **Numbers carry their derivation or a link to it.** A figure with
   no traceable source does not ship, in a document or in the app.
9. **Dates are absolute.** "Last month" is unreadable a year on.
10. **A decision keeps its number forever.** Decision ids
    (`D1`, `E1`, `R3-D4`, `FR-22`) are permanent handles; never
    reuse one, and if a collision happens, renumber the later
    decision and leave a note saying so.

---

## 9. Where each workstream stands

| Workstream | Evidence | Decisions and rules | Archive |
|---|---|---|---|
| Transport | `RESEARCH_TRANSPORT.md` | `PDR_TRANSPORT_CALCULATOR.md` | `PDR_TRANSPORT_ARCHIVE.md` |
| Energy | `RESEARCH_ENERGY.md` | `PDR_ENERGY_CALCULATOR.md` | `RESEARCH_ENERGY_ARCHIVE.md` |
| Food | `RESEARCH_FOOD.md` | **missing** | `RESEARCH_FOOD_ARCHIVE.md` |

Food is the outlier: `RESEARCH_FOOD.md` carries both the evidence
and the decisions, which is why it is roughly twice the size of its
peers. Splitting out `PDR_FOOD_CALCULATOR.md` is the open structural
task, tracked in PDR_FOOD_CALCULATOR.md section 6.

The two archive prefixes disagree (`PDR_TRANSPORT_ARCHIVE` against
`RESEARCH_ENERGY_ARCHIVE`) because each took the prefix of the
document it was first split from. Under rule 6 an archive serves the
whole workstream, so the prefix is not load-bearing; leave both
alone rather than churning links for symmetry.

---

## 10. Types deliberately not created

### `REPORT_` (proposed and rejected, 2026-08-29)

A per-workstream digest of the evidence -- `REPORT_FOOD.md`,
`REPORT_ENERGY.md` and so on -- summarising the values in a few
readable pages.

**Rejected, because the one document already in that shape has
failed in exactly the way the type invites.** `RESEARCH_ACTIONS.md`
is a synthesised digest of the action library. It currently lists
`meatless_meal_beef` 5340, `meatless_meal_chicken` 540,
`meatless_meal_pork` 610 and `plant_milk_vs_dairy` 460, each marked
`High` confidence. All four ids were retired into tier actions; the
live values are `skip_high_impact_food` 3700 and
`skip_medium_impact_food` 780, and the beef figure passed through
9700 and 6800 on the way. Nothing announced the drift, because a
digest has no test and no reader who depends on it being right.

The failure is structural, not a lapse. A digest that restates
values breaks rule 3 by construction: it is a second home for every
number in it, and second homes go stale silently. The repair effort
across this repo has overwhelmingly been reconciling figures that
lived in two places.

**What to do instead.** The need behind the proposal is real -- an
evidence base runs to a thousand lines and there is no five-minute
way in. That is answered by the "Method in brief" section required
at the top of every `RESEARCH_` document (section 3), which
summarises the *rules* and states no values. Rules compress safely.
Numbers do not.

If a genuine one-off report is needed for an audience outside the
repo, write it as a standalone (`SECURITY_REPORT.md` is the
precedent), date it, and say in its header that it is a snapshot
rather than an authority.

**Resolved 2026-08-29.** `RESEARCH_ACTIONS.md` was rewritten as
method-only and its tables moved to `RESEARCH_ACTIONS_ARCHIVE.md`,
dated and reconciled rather than updated: 48 of the 62 rows had no
live counterpart to update *to*, so a half-current table would have
been worse than an openly historical one.
