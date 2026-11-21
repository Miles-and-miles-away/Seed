# PDR: Fact games -- Fact pairs and Fact recall

**Created:** 2026-10-30
**Status:** Live. Both games deal eco-facts, SDG goals, action info and
discovered Eco-Dex entries; Fact recall also asks curated calculator
comparisons. Both open by Eco-Dex discoveries.
**Purpose:** Post-design review (DOCUMENT_TYPES 4a): the standing
decisions behind the fact games and their product rules. It holds the
sources, the lock, the rotation, the decoy rules and the calculator
comparisons.
**Not held here:** the bar each fact's text and key figure clear, which
is [AUDIT_FACT_DATA.md](./AUDIT_FACT_DATA.md) (Key Figures); the
screens' layout and interaction, which is
[APP_PAGES.md](./APP_PAGES.md) (Fact Pairs, Fact Recall); the action
figures' sourcing, which is [AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md);
the calculator values, which live in `data/app/` and their `RESEARCH_`
documents. Comparison multiples are computed at runtime and stated
nowhere else.
**Companion docs:** [PDR_FOOD_CALCULATOR.md](./PDR_FOOD_CALCULATOR.md),
[PDR_TRANSPORT_CALCULATOR.md](./PDR_TRANSPORT_CALCULATOR.md),
[PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md) (the deck
membership the comparisons reuse).

---

## 1. Scope

Two games in `lib/features/fact_games/`, reached from the Explore tab:

- **Fact pairs** turns two cards at a time to match a fact's clue to
  its key figure.
- **Fact recall** blanks a fact's key figure and offers it with two
  decoys.

Both deal a `GameFact` (`game_fact.dart`): a fact from any source,
resolved for one locale, with an id unique across sources, a title, a
clue, a text that states the figure once, the figure, and `figureEn`, the
canonical value key. Nothing is awarded, logged or persisted.

## 2. Sources

**FG-D1 -- One source-neutral fact.** Each source has an adapter in
`game_fact.dart` or `calculator_facts.dart` that returns `GameFact`s.
Boards, rounds and decoys see only `GameFact`, so a new source is one
adapter, one `GameFactKind` mapped to its `FactDealGroup`, and one line
in the pool provider.

**FG-D2 -- What each source gives, and when the user has it.**

| Kind | Text | Figure | In the pool when |
|---|---|---|---|
| `ecoFact` | the fact | `keyFigureEn/Ja/Es` | unlocked or viewed (the inbox's rule) |
| `sdg` | the description's sentence that carries the figure | `keyFigureEn/Ja/Es` in `sdg_goals.json` | always: the SDG pages are open to everyone |
| `action` | the info text's first sentence, links and bold removed | its one bold run | always, for library actions with a CO2 value |
| `ecoDex` | the entry's fact | `keyFigureEn/Ja/Es` | discovered |
| `food`, `transport`, `energy` | a curated comparison (section 4) | the computed multiple | always; Fact recall only |

- The pool is what the user could in theory have seen. The screens
  behind SDG, action and calculator facts are open to every user, so
  those facts are not gated. The Eco-Dex is, because an undiscovered
  entry is hidden.
- Each source is loaded on its own. A source that fails gives no facts
  rather than an error for the whole pool.
- Action text comes from Firestore, not the bundle. An action whose
  first sentence lacks exactly one bold run, standing once, is skipped
  rather than dealt, so a stale document cannot break a deal. The seed
  text is held to the rule by `scripts/seed/check_description_figures.js`.
- Decoy candidates are every text fact of every source, met or not: a
  decoy is a bare figure with no title, so it reveals nothing.

**FG-D3 -- Not used.** SDG targets (official UN wording, mostly years,
and "per cent" breaks the format rule), calculation notes
(derivations, not facts), impact equivalencies (computed values with EN
only sources), and Eco-Dex entries that fail the accuracy audit (they
carry no key figure).

## 3. Lock and rotation

**FG-D4 -- Unlock by Eco-Dex discoveries.** Fact pairs opens at
`factPairsMinEcoDex` discovered entries and Fact recall at
`factRecallMinEcoDex` (`fact_games_pool.dart`). Being locked for weeks
is intended: the locked screen and the Explore tile say that the game
opens once enough Eco-Dex entries are discovered, show the progress,
and link to the Eco-Dex. Nothing else counts towards a lock, calculator
comparisons included.

**FG-D4a -- Higher or Lower stays open.** It is the one game every user
can play from the start. "Play Higher or lower" is a walkthrough step,
and new users discover Eco-Dex entries slowly, so an Eco-Dex gate would
lock a step of the walkthrough for days.

**FG-D5 -- Sources take turns; the three calculators count as one
source.** `dealInTurn` shuffles the deal groups present and takes one
fact per group in rotation. No two questions or cards in a row come
from one source while another source has facts left. Within a group,
facts outside the last round's ids come first. It reads only
`GameFact.dealGroup`, which maps food, transport and energy to one
`calculator` group: keyed on the kind, the calculators would take three
turns to every other source's one. The kind still picks the title and
where the fact opens. A deal never repeats a `figureEn`.

**FG-D6 -- Calculator facts are Fact recall only.** A Pairs face shows
a bare title or figure, and a multiple with no basis would teach
nothing. `GameFact.recallOnly` keeps them off every board, and the
recall sentence states the basis.

## 4. Calculator comparisons

**FG-D7 -- Curated, on one basis, computed at runtime.**
`calculatorComparisons` in `calculator_facts.dart` lists a handful per
calculator, each two items compared on the same basis:

- food: kg CO2e per kg, written per 100 g, or per 100 ml for drinks
  (liquids are at density 1);
- transport: g CO2e per passenger-km. A car is stored per vehicle, so a
  car comparison takes it at one occupant and its sentence says the car
  is driven alone (`_drivenAlone`);
- energy: kWh per unit, electricity only and the same `unit` on both
  sides, so the grid factor cancels and the ratio holds on any grid.

Both items must be in Higher or Lower's decks (`isQuizFood`,
`isQuizTransport`, `isQuizEnergy` in `quiz_cards.dart`). Standing rules
for choosing a pair:

- Items whose mean and median the food methodology says are too far
  apart to rank are not used.
- An item whose calculation note flags its figure as order-of-magnitude
  only is not used: the quiz would reward one multiple and mark a
  plausible one wrong.
- Both sides of an energy comparison are the same kind of figure, both
  measured or both rated. A nameplate against a measured seasonal
  average inflates the gap by an amount the data cannot state.
- The pair's own notes must not advise against the basis. A drink
  whose note says to compare by the glass rather than the litre is not
  compared per 100 ml.

**FG-D8 -- How a multiple is written.** Below 2x it is a whole
percentage more ("57%" in "about 57% more CO2e than"). From 2x it is
"N times", with one decimal below 10x and a whole number above, and a
trailing ".0" dropped. The sentence is fixed per comparison, so a
comparison whose ratio crosses 2x after a data change drops out until
its sentence is rewritten; `calculator_facts_test.dart` pins every
figure in every language.

**FG-D9 -- Copy rules per language.** Each comparison has its own ARB
sentence, so the grammar is right in each language. Only the figure is
filled in.

- EN says "about N times as much CO2e as", never "N times more".
- JA uses 倍 for a multiple, never 回.
- ES (es-ES) writes «cerca de N veces más CO2e que» and «cerca de un N%
  más CO2e que». It uses a decimal comma, «CO2e» with no «de», and
  number agreement in `factRecallTimes` («1 vez», «2 veces»,
  «1,5 veces»).
- The title is the calculator's name.

## 5. Decoys

**FG-D10 -- Text facts.** Two other facts' real figures in the answer's
exact format where there are any. Otherwise the answer's own numbers
scaled (FG-D11). Otherwise real figures in its unit, then its unit
family. A decoy never appears whole in the blanked text: `fair()` in
`decoyPairs` compares the whole decoy string, so "20 °C" in the text
rules out "20 °C" but not "20 times". The answer is never the only
option written differently.

**FG-D11 -- Multiples of the answer.** A decoy pair may be the answer
scaled: a quarter and a half, a half and double, or double and four
times. It is rounded to two significant figures and kept at least 1.8x
from the answer and from the other decoy, so the answer sits low, in
the middle or high. A range scales as a range. Scaling never:

- drops a multiple to 1x or below;
- takes a share past 100% ("85% of" cannot become "170% of"). A
  comparison's percentage more can pass it ("160% more"), so a
  comparison above 50% can still sit low or in the middle;
- drops a comparison's multiple below 2x: its answer is never written
  "1.1 times" (FG-D8), so a decoy that is would give itself away. To
  keep the answer's position open, a comparison also scales by 1.5x and
  2.25x (two-thirds and 1.5x, or 1.5x and 2.25x), and those pairs need
  only be 1.4x apart. From 3x an answer can then sit in the middle; one
  just above 2x still sits lowest;
- puts a number below 1 before a scale word («0,9 billones» is written
  «900.000 millones», so it is never made);
- touches a Japanese scale compound (`1億6,000万`) or a lone 1.

In English a number before a scale word carries up at 1,000: "1,800
million" is written "1.8 billion", and billion carries to trillion. Two
carried decoys never pair against an uncarried answer, which would leave
the answer the only figure in millions. Spanish keeps «X.000 millones»
(`scripts/i18n/glossary_es.md`).

**FG-D12 -- Calculator comparisons take only scaled decoys.** Another
fact's "4 times" beside an answer of "4.3 times" would be unfair, and
scaling guarantees the spacing.

## 6. Exploring from the games

**FG-D13 -- A wrong answer shows the fact in full.** After a wrong
answer, Fact recall offers "Explore this fact". A text fact opens in
the same sheet a Fact pairs match shows (FG-D14), over the round, so
closing it returns to the same question; a calculator comparison opens
its calculator, a root-level route, and Back returns to the question. A
miss becomes a reason to read further. A right answer offers nothing,
so the round keeps its pace. `GameFact.source` carries the record the
fact came from, so no screen looks it up again.

- Pushing the eco-fact or SDG page instead is not possible: those are
  Home-branch routes inside the tab shell, and a push from Fact recall,
  a root-level route, fails on a duplicate page key. Moving them to the
  root navigator would cost every Home-tab visit its bottom bar, and
  `go` would discard the round.
- An action opens its info sheet, not the action log: the question came
  from that text, and the log is a logging flow.

**FG-D14 -- A match shows the fact in full.** `showFactSheet`, the
same in both games: an eco-fact's text with its source, an SDG goal's
whole description and an action's own info sheet (the game text is one
sentence of each), and an Eco-Dex entry's own sheet.
A matched card opens it again. The last match opens nothing: the win
celebration is its reward, and a sheet would cover it.

**FG-D15 -- A pairs card shows a clue, not the title.** Titles are
names ("Getting Started"), so a title card gave no hint which figure
it pairs with. The clue (`clueEn/Ja/Es`, 3 to 10 English words) says
what the figure measures and never contains it. An action's clue is
its name, which already says what was done. A fact whose figure makes
no guessable clue (a hypothetical, a bare target) has empty clues and
stays out of Fact pairs; Fact recall still asks it, since the blank
sits in the fact's own sentence.

## 7. Copy

The rules lines and subtitles say "fact" (ファクト, «dato»), not
"eco-fact", since every source plays. The locked copy names the
Eco-Dex and the number of entries needed.

## 8. Verification

`flutter test test/features/fact_games test/features/explore
test/core/l10n`. The data tests run every bundled text fact and every
comparison in EN, JA and ES: a figure once in its text, a decoy pair
for every figure, no decoy below 1 before a scale word, and the
comparison figures pinned.

## 9. Open items

None. Decoy steps stay at a quarter, a half, double and four times by
owner decision; a tenth, ten times and shifted ranges were considered and
not taken. Comparisons add the 1.5x steps of FG-D11, also by owner
decision, so that ruling out multiples under 2x does not pin answers
under 4x to the lowest place.
