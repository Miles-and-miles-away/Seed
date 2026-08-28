# Action Design Guide

Reference for adding, modifying, or reviewing actions in
the Seed action library. Covers the principles refined
during the initial action audit so future additions are
consistent, honest, and well-calibrated.

---

## 1. The Logging Unit

Every action must have one unambiguous "logging unit" so
the user knows exactly what one tap of the log button
represents. Three types exist:

| Type | User logs... | CO2 represents... |
|------|-------------|-------------------|
| **Per instance** | Each occurrence | One discrete event |
| **Per day** | Once per day | A full day of the habit |
| **One-time** | Once ever | Long-term projected return |

### Rules

- The **description must make the unit obvious** to the
  user without requiring them to guess.
- Per-day actions should include "today" in the
  description (e.g., "...instead of electric lighting
  today").
- Per-instance actions should name the countable thing
  (e.g., "Recycle an aluminum can", "Choose plant-based
  milk for a drink or meal").
- One-time actions should describe the milestone event
  (e.g., "Install an LED bulb", "Purchase an electric
  vehicle").
- One-time CO2 values reflect **projected first-year (or
  multi-year) savings**, not a single day's benefit. The
  inline comment must state the projection window.

### Why this matters

If the unit is ambiguous, users either over-log (inflating
their impact) or under-log (feeling unrewarded). Both
erode trust. The unit also determines how CO2 is
calculated -- a "per day" action must use a full-day
estimate, not a per-instance one.

---

## 2. CO2 Estimation Principles

### Be honest, not generous

Round conservatively. Users who discover inflated numbers
lose trust permanently. Users who see the app acknowledge
complexity trust it more.

### Be specific in the inline comment

Every `co2Grams` value MUST have an inline comment in the
JSON that shows the calculation chain. Format:

```javascript
co2Grams: 90, // daily: 3hrs x 2 rooms x 40W x 458g/kWh
```

The comment should contain:
1. **The unit** (daily, per can, per bag, first-year, etc.)
2. **The arithmetic** (show the multiplication chain)
3. **The source assumption** (grid factor, Poore 2018,
   DEFRA 2024, etc.)

### Use a standard grid emission factor

All energy calculations use **458 g CO2e/kWh** as the
global average baseline (Ember, *Global Electricity Review
2026*, 2025 world average, CO2e). Document any deviation.
Full sourcing and the retired 386 figure: section 8.

### Handle variable-scope actions with a defined unit

When what a user logs could vary wildly (e.g., "recycle
textiles" could be one sock or a bin bag of coats),
**define a standard unit** in the description:

- "Donate a bag of old clothing" (per bag, ~4-5kg)
- "Take old electronics to recycling" (per smartphone)
- "Donate a box of unused household items" (per box)

Then calculate CO2 for that standard unit with
**scenario-based averaging**: list 3-5 realistic scenarios,
calculate each, and take a weighted average biased toward
the most common case. Document all scenarios in the
ACTION_LOGIC_CHECK or in longer comments.

### Zero-CO2 actions are valid

Actions like "attend eco group meeting" or "take on a
household task" have co2Grams: 0. They earn points through
the zero-CO2 formula (see section 4). Their value is in
behavior change, community, or social equity -- not carbon.
The `impact` score should reflect this broader value.

---

## 3. The Action JSON Schema

> **Single source of truth (2026-08-02):**
> `data/seed/co2_actions_database.json` holds every shipping
> action -- CO2 value, calculation notes, `sources[]`, confidence,
> localised strings and the effort/frequency/impact scores.
> `scripts/seed/seed_action_library.js` reads it and computes
> points at seed time; it carries no action data. Never
> reintroduce an inline action array: the two stores diverged once
> and ended up sharing only 9 of 112 ids. Records researched but
> not shipped live under `research_only_records` and are not
> seeded.

> **Compliance state (2026-08-29):** the dataset does not yet meet
> the rule above. **58 of the 92 shipping actions carry both an
> empty `sources[]` and a null `confidence`**, 37 of them with a
> nonzero `co2_grams` -- a stated saving with no recorded
> provenance. The largest are `fix_leak` 100000 and
> `recycle_textiles` 40000. Energy is clear: all 11
> `category: "energy"` actions were backfilled on 2026-08-29 from
> primaries already live-verified in
> [RESEARCH_ENERGY.md](./RESEARCH_ENERGY.md) sections 1 and 3.
> Backfilling the rest needs each primary re-fetched and quoted
> live per section 2, so it is its own pass per category. Update
> this count when that happens.

```javascript
{
  id: 'snake_case_id',        // unique, descriptive
  nameEn: 'Short Title',      // max ~30 chars
  nameJa: '...',
  nameEs: '...',
  descriptionEn:              // 1-2 sentences
    'Verb phrase that makes the logging unit '
    + 'obvious to the user',
  descriptionJa: '...',
  descriptionEs: '...',
  category: 'recycling',      // see category list
  co2Grams: 100,              // inline comment REQUIRED
  effort: 2,                  // 1-5, see scale below
  frequency: 4,               // 1-5, see scale below
  impact: 3,                  // 1-5, see scale below
  iconName: 'recycling',      // Material Icons name
  relatedSdgs: ['12', '13'],  // string array of SDG #s
  isActive: true,
  sortOrder: 1,               // within category
}
```

### Categories (9)

`recycling`, `transport`, `food`, `energy`,
`consumption`, `water`, `community`, `advocacy`,
`learning`

### Localization

All three languages (EN, JA, ES) are required for name
and description. Long descriptions go in separate files
under `scripts/action_descriptions_*.js`.

---

## 4. Point Calculation

Points are pre-computed by `seed_action_library.js` and
stored in Firestore. The app does NOT recalculate them.

### Formula (CO2 > 0)

```
points = max(1, round(
  co2Grams^0.4
    * effortMultiplier
    * rarityMultiplier
    * impactMultiplier
))
```

### Formula (CO2 = 0)

```
points = max(1, round(
  effort * 3
    * rarityMultiplier
    * impactMultiplier
))
```

### Constants

```
CO2_EXPONENT     = 0.4
EFFORT_BASE      = 0.7     EFFORT_SCALE  = 0.15
RARITY_BASE      = 1.3     RARITY_SCALE  = 0.1
IMPACT_BASE      = 0.85    IMPACT_SCALE  = 0.075
ZERO_CO2_SCALE   = 3
```

### Multiplier Ranges

| Factor | Input | Multiplier formula | Range |
|--------|-------|--------------------|-------|
| Effort | 1-5 | 0.7 + (effort * 0.15) | 0.85x - 1.45x |
| Rarity | 1-5 | 1.3 - (frequency * 0.1) | 0.8x - 1.2x |
| Impact | 1-5 | 0.85 + (impact * 0.075) | 0.925x - 1.225x |

### Why the 0.4 exponent?

Linear CO2-to-points would make "purchase an EV"
(3,400,000g) worth 34,000x more than "recycle a can"
(100g). The 0.4 power compresses this:
- 100^0.4 = 6.3
- 3,400,000^0.4 = 410

So the EV is ~65x the can in points, not 34,000x. This
keeps daily habits competitive with rare big actions --
logging recycling every day for a year accumulates far
more than one EV purchase.

### Worked Examples

**Recycle Aluminum Can** (co2:100, eff:1, freq:5, imp:2)
```
effortMult = 0.7 + (1 * 0.15) = 0.85
rarityMult = 1.3 - (5 * 0.1) = 0.80
impactMult = 0.85 + (2 * 0.075) = 1.00
points = round(100^0.4 * 0.85 * 0.8 * 1.0)
       = round(6.31 * 0.68)
       = round(4.29) = 4 pts
```

**Shorter Shower** (co2:110, eff:2, freq:5, imp:2)
```
effortMult = 0.7 + (2 * 0.15) = 1.00
rarityMult = 1.3 - (5 * 0.1) = 0.80
impactMult = 0.85 + (2 * 0.075) = 1.00
points = round(110^0.4 * 1.0 * 0.8 * 1.0)
       = round(6.55 * 0.8)
       = round(5.24) = 5 pts
```

**Install LED Bulb** (co2:25000, eff:1, freq:1, imp:3)
```
effortMult = 0.7 + (1 * 0.15) = 0.85
rarityMult = 1.3 - (1 * 0.1) = 1.20
impactMult = 0.85 + (3 * 0.075) = 1.075
points = round(25000^0.4 * 0.85 * 1.2 * 1.075)
       = round(56.98 * 1.0965)
       = round(62.5) = 63 pts
```

**Attend Eco Meeting** (co2:0, eff:2, freq:2, imp:4)
```
effortMult = (not used directly for zero-CO2)
rarityMult = 1.3 - (2 * 0.1) = 1.10
impactMult = 0.85 + (4 * 0.075) = 1.15
points = round(2 * 3 * 1.1 * 1.15)
       = round(7.59) = 8 pts
```

**Purchase EV** (co2:3400000, eff:5, freq:1, imp:5)
```
effortMult = 0.7 + (5 * 0.15) = 1.45
rarityMult = 1.3 - (1 * 0.1) = 1.20
impactMult = 0.85 + (5 * 0.075) = 1.225
points = round(3400000^0.4 * 1.45 * 1.2 * 1.225)
       = round(410 * 2.13)
       = round(873) = 873 pts
```

### Point Sanity Check Table

Use this table to gut-check new actions. Points should
fall in a believable range relative to existing actions.

| Action | CO2 (g) | E | F | I | Pts | Type |
|--------|---------|---|---|---|-----|------|
| Recycle can | 100 | 1 | 5 | 2 | ~4 | instance |
| Turn off lights | 60 | 1 | 5 | 2 | ~3 | daily |
| Shorter shower | 275 | 2 | 5 | 2 | ~7 | daily |
| Reusable bottle | 160 | 1 | 5 | 2 | ~5 | daily |
| Plant milk | 550 | 2 | 3 | 3 | ~16 | instance |
| Compost scraps | 200 | 2 | 5 | 3 | ~6 | daily |
| Skip delivery | 600 | 3 | 4 | 2 | ~17 | instance |
| Bike medium trip | 900 | 3 | 3 | 3 | ~25 | instance |
| Skip high-impact food | 6000 | 2 | 3 | 4 | ~57 | instance |
| Air dry laundry | 1500 | 2 | 3 | 2 | ~26 | instance |
| Secondhand clothing | 15000 | 2 | 3 | 3 | ~78 | instance |
| Install LED | 25000 | 1 | 1 | 3 | ~63 | one-time |
| Fix water leak | 100000 | 3 | 1 | 4 | ~153 | one-time |
| Donate textiles | 40000 | 2 | 2 | 3 | ~101 | instance |
| Install solar | 2500000 | 5 | 1 | 5 | ~735 | one-time |
| Purchase EV | 3400000 | 5 | 1 | 5 | ~873 | one-time |
| Eco meeting (0 CO2) | 0 | 2 | 2 | 4 | ~8 | instance |
| Household task (0 CO2) | 0 | 2 | 4 | 4 | ~5 | instance |

---

## 5. Scoring the Three Multiplier Axes

Each axis is 1-5. The scores must be **discrete,
comparable, and consistent** across all actions.

### Effort (how hard is this for the user?)

| Score | Label | Definition | Examples |
|-------|-------|------------|----------|
| 1 | Trivial | Single gesture, no planning | Toss can in bin |
| 2 | Easy | Minor inconvenience or habit | Bring reusable bag, turn off lights |
| 3 | Moderate | Requires time, planning, or discomfort | Cook instead of ordering, bike 5km |
| 4 | Notable | Significant time/money/lifestyle change | Install solar, fix plumbing |
| 5 | Major | Life-altering financial or logistical decision | Buy EV, major home renovation |

### Frequency (how often can a user realistically do this?)

| Score | Label | Definition | Examples |
|-------|-------|------------|----------|
| 1 | Rare | Once ever or once in years | Install solar, buy EV |
| 2 | Monthly | Monthly or a few times a year | Donate textiles, attend meeting |
| 3 | Weekly | Once or twice per week | Farmers market, secondhand shop |
| 4 | Frequent | Several times per week | Skip delivery, bike commute |
| 5 | Daily | Every day or nearly so | Recycle can, turn off lights |

Note: frequency is **inverted** in the formula (rarity
multiplier). Rare actions get a 1.2x bonus; daily actions
get a 0.8x penalty. This prevents daily micro-actions
from dominating the leaderboard per-log while still
rewarding consistency through volume.

### Impact (broader environmental ripple effect)

| Score | Label | Definition | Examples |
|-------|-------|------------|----------|
| 1 | Immediate | Benefit ends when action ends | Turn off a light |
| 2 | Short-term | Prevents waste in the near term | Recycle, refuse disposables |
| 3 | Medium-term | Shifts consumption patterns | Secondhand buying, composting |
| 4 | Long-lasting | Years of ongoing benefit or systemic signal | Fix leak, install solar, attend advocacy |
| 5 | Systemic | Generational or market-shifting | Buy EV (drives adoption), plant trees |

Impact is NOT the same as CO2 magnitude. A zero-CO2
action like "attend eco meeting" can have impact 4 because
collective action enables policy change. Impact captures
what CO2 grams alone cannot.

---

## 6. Avoiding Common Pitfalls

### Do not reward existing lifestyle

Actions must represent a **deliberate behavioral change**,
not logging what someone already does. "Work from home"
was removed because permanent remote workers would earn
4.5kg/day for doing nothing different. Ask: "Would a user
need to change their behavior to log this?"

### Do not split what should be merged

If two actions are both <15g CO2 and occur in the same
context, merge them. Individual actions like "refuse
straw" (1g), "refuse cutlery" (5g), and "use cloth
napkin" (5g) were merged into "refuse single-use
disposables" (15g). The friction of finding and logging
three separate 1-5g actions is not worth the
granularity.

### Do not keep what should be split

If one action description could mean vastly different
things, either:
1. Define a standard unit (per bag, per smartphone)
2. Split into tiers (high-impact food vs medium-impact)

The meat actions were split into high-impact (beef, lamb,
shrimp: ~6000g) and medium-impact (chicken, pork, eggs:
~1000g) because lumping them together would either
overvalue chicken or undervalue beef.

### Do not double-count

Check for overlap with existing actions before adding.
"Drink tap water" overlapped with "use reusable bottle"
-- both reward avoiding plastic bottles. "Local produce"
and "farmers market" described the same shopping trip.
Merge or remove the weaker one.

### Beware of one-time vs ongoing framing

If an action is logged once but produces ongoing savings,
the CO2 value must reflect the **projected benefit over
a stated period** (typically first year), not a single
day's savings. Conversely, do not give a daily action
a lifetime CO2 value.

Examples:
- Install LED: 25,000g = first-year savings (51.5W diff
  x 3hrs/day x 365 x 458g/kWh = 25,820, rounded down)
- Fix leak: 100,000g = conservative 1-year savings
  (~300g/day x 365)
- EV purchase: 3,400,000g = 2-year projected savings

Always state the projection window in the comment.

---

## 7. Adding a New Action: Checklist

1. **Define the logging unit.** Is it per instance, per
   day, or one-time? Write the description so a user
   cannot misinterpret it.

2. **Research the CO2.** Use tier-1 sources (DEFRA 2024,
   EPA, Poore & Nemecek 2018, Our World in Data). Show
   the full calculation chain. If the scope varies,
   use scenario-based averaging and document scenarios.

3. **Write the inline comment.** Format:
   `co2Grams: 200, // per trip; 3 bulk x 30g + refill 80g + misc 30g`

4. **Score effort, frequency, impact.** Use the tables
   in section 5. Compare against similar existing actions
   to ensure consistency.

5. **Compute points.** Run the formula manually or use
   the script. Check the result against the sanity table
   in section 4. Does it feel right relative to nearby
   actions?

6. **Check for overlap.** Search existing actions for
   similar descriptions, same category, or shared SDGs.
   Would a user reasonably log both this and an existing
   action for the same real-world event?

7. **Check the "lifestyle test".** Would a user need to
   deliberately change behavior to log this? If not,
   reconsider.

8. **Write all three languages.** EN, JA, ES for both
   name and short description.

9. **Write the long description.** 3-5 sentences with
   markdown bold for CO2 figures and source links. Add
   to the appropriate `action_descriptions_*.js` file.

10. **Assign relatedSdgs.** Every action should map to
    at least one SDG. SDG 13 (Climate Action) applies to
    nearly all CO2-based actions. Add others where the
    action directly supports that goal's targets.

---

## 8. Key Sources

These are the tier-1 sources used for CO2 estimation.
New actions should cite from this list where possible.

- **DEFRA 2024** - UK Government Greenhouse Gas
  Conversion Factors (transport, energy, waste)
- **Poore & Nemecek 2018** - Science meta-analysis of
  38,700 farms (food lifecycle emissions)
- **US EPA** - Greenhouse Gas Equivalencies Calculator,
  WARM Model (recycling, waste)
- **Our World in Data** - Compiled visualizations of
  peer-reviewed data (transport, food, energy)
- **IEA** - International Energy Agency (energy, grid
  factors)
- **Carbon Trust** - Product lifecycle assessments
  (reusables, packaging)
- **Aluminum Association LCA 2021** - Recycling savings
- **Danish EPA 2018** - Bag lifecycle assessment

### Grid Factor

Global average baseline: **458 g CO2e/kWh**
(Ember, *Global Electricity Review 2026*, 2025 world
average, CO2e). Actions using a different factor must
document the deviation.

Note the unit is **CO2e**, not CO2, matching the rest
of the app (food is CO2e; transport is CO2e including
the 1.7x aviation RF uplift). IEA's *Electricity 2026*
publishes 435 g CO2/kWh for the same year on a
CO2-only basis -- the 5.3% gap is scope. Do not
average the two.

Superseded 2026-08-02 (decision E1): the previous
baseline was 386 g CO2/kWh, documented here as the
"midpoint of US 370g and UK 210g". That midpoint is
290, so the stated derivation never reproduced the
shipped number, and 386 was ~16% below every current
tier-1 global figure. Rationale and blast radius:
[PDR_ENERGY_CALCULATOR.md](./PDR_ENERGY_CALCULATOR.md)
section 2; annual refresh tracked in
[ANNUAL_RESEARCH_UPDATE.json](./ANNUAL_RESEARCH_UPDATE.json).

---

## 9. Reference: Full Formula in Code

Located in `scripts/seed/seed_action_library.js`:

```javascript
const EFFORT_BASE = 0.7;
const EFFORT_SCALE = 0.15;
const RARITY_BASE = 1.3;
const RARITY_SCALE = 0.1;
const IMPACT_BASE = 0.85;
const IMPACT_SCALE = 0.075;
const CO2_EXPONENT = 0.4;
const ZERO_CO2_EFFORT_SCALE = 3;

function computePoints(action) {
  if (action.isLearnOnly) return 0;
  const effortMult =
    EFFORT_BASE + (action.effort * EFFORT_SCALE);
  const rarityMult =
    RARITY_BASE
      - (action.frequency * RARITY_SCALE);
  const impactMult =
    IMPACT_BASE + (action.impact * IMPACT_SCALE);

  if (action.co2Grams > 0) {
    return Math.max(1, Math.round(
      Math.pow(action.co2Grams, CO2_EXPONENT)
        * effortMult * rarityMult * impactMult,
    ));
  }
  return Math.max(1, Math.round(
    action.effort * ZERO_CO2_EFFORT_SCALE
      * rarityMult * impactMult,
  ));
}
```

### Streak Bonus (applied at log time in Dart)

Points earned per log are multiplied by a streak bonus:
- Formula: `bonus = 1.0 + (streakDays * 0.033)`
- Capped at 2.0x (reached at 30-day streak)
- This means a 30-day streak doubles all points earned

### Level Curve

- Base: 100 points per level
- Scaling factor: 1.5x per level (geometric)
- Level N requires: sum of 100 * 1.5^(i-1) for i=1..N-1
