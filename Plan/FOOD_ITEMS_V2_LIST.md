# Food Items v2 -- Item Spec (post-review)

Status: **DELIVERED 2026-08-04 -- 166 items shipped.** This file was
the build spec; it is now history. The dataset lives in
`data/app/food_items.json`, the durable methodology in
[RESEARCH_FOOD.md](./RESEARCH_FOOD.md) (selection rules in 2.2,
functional units in 2.1), and the build record -- what shipped, what
was cut, what nearly went wrong -- in
[PDR_FOOD_ARCHIVE.md](./PDR_FOOD_ARCHIVE.md) section 6.

**What shipped differs from the plan below**, and the archive is the
authority where they disagree. The headline differences: 166 items
against a planned 175, because roughly 30 candidates were correctly
CUT for want of a citable ratio; the seafood group went P&N-anchored
with Gephart filling gaps (D8), not Gephart-uniform as section 1's
finding F9 proposed; and sections 4 and 8 below were already stale
when the work resumed -- wave 9 had completed a full re-run, and the
picker already had search, alias ranking, a lazy list and group
icons.

Baseline at the time of writing: 41 shipped items,
`beef_dairy_herd` retired (D5).

---

## 1. What the review changed

**F1 -- P&N is 37 rows deep and nothing else can be bolted onto
it.** Verified live 2026-08-01. Agribalyse 3.2 publishes per-stage
data (agriculture / transformation / packaging / transport /
distribution / consumption) under Licence Ouverte, so its stages
*are* strippable -- and stripping is pointless: consumption is
0.26% of its braised-beef value while the gap to P&N is 3.4x
(28.9 vs 99.48). The gap is French/EU production systems and
dLUC-only accounting, not boundary. SU-EATABLE LIFE has the
closest boundary ("distribution centre to consumers ... excludes
post market phase") but publishes **medians**, never mentions
land-use change, and applies no supply-chain losses -- its beef is
25.75 against P&N's 99.48. Gephart 2021 stops "at the farmgate ...
or at landing" on an **edible-weight** functional unit.

Consequence: **no second source can be ranked against a P&N
value.** Left unguarded this dataset would have shipped: bacon,
ham, sausage and salami all at 5.99 (SEL) against P&N pork 12.31,
i.e. cured meat beating its own raw parent -- physically
impossible, since curing removes water; peanut butter 1.84 below
its only input, peanuts 3.23; yogurt 1.69 below milk 3.15;
mayonnaise 1.46 below the 2.45 floor of its own 65% oil;
mozzarella looking 66% better than cheddar when published yields
put it 23-28% better. Every one of those is a plausible number
pointing the wrong way, which is the failure mode this dataset
cannot survive.

**F2 -- The honest resolution limit is ~70 distinct numbers, not
200.** P&N genuinely does not resolve carrots from beetroot: both
are the "Root Vegetables" row, 0.43. Fifteen of the draft's
vegetables would have shared "Other Vegetables" 0.53; eleven
fruits would have shared "Other Fruit" 1.05.

**F3 -- But item count and number count are different problems,
and conflating them was draft 1's real error.** A user needs to
*find* aubergine. They do not need aubergine to have its own
number -- P&N's answer for aubergine genuinely is the vegetable
category mean, and saying so is more honest than inventing
species precision. So v2 ships **many findable foods over fewer
honest numbers**, via two mechanisms the draft lacked:
`category_anchor` (this number is a category average, labelled as
one in the UI) and `aliases` (many names resolve to one item).
Chorizo, serrano and prosciutto become aliases of one cured-meat
item instead of three fake splits; hake and pollock find white
fish; manchego and gouda find cheese.

**F4 -- Residual buckets must never be presented as species
values.** "Other Vegetables 0.53" is P&N's remainder, not a
measurement of asparagus. Items on a residual anchor ship with
`category_anchor` set and are never described as "the mean for X".

**F5 -- ~25 composite items had no citable recipe ratio and are
cut** (below). A composite ships only against a named standard, a
regulation, or a specific product's declared QUID composition --
quoted, with the brand named in the notes.

**F6 -- Nine live instances of the retired beef-herd pattern were
found and fixed.** `salmon (farmed)`, `prawns (farmed)`,
`scallops`, `tuna (fresh)`, `feta`'s sheep-milk premise, white
fish "wild by default", `wasabi` (the tube is horseradish), and
the two beef items' replacement `veal`. Production-system
qualifiers are gone from every user-facing name: the app ships
the honest global mean and puts the system spread in the science
sheet.

**F7 -- `veal` is cut.** It was invented to re-home the retired
33.30 dairy-herd value. A number choosing an item is R4 backwards,
and P&N's dairy-herd row is cull cows and dairy-bred steers, not
milk-fed calves.

**F8 -- The nut fallback was inverted.** P&N "Nuts" 0.43 carries a
land-use credit of **-3.257812** (verified in the stage CSV);
"Groundnuts" is a separate row at 3.23. Shipping 0.43 as the "not
sure which nut" default would have made the fallback 7.5x lower
than the commonest nut in the bag. v2 ships `tree_nuts` (0.43,
credit disclosed) and `peanuts` (3.23) and has no generic nut
fallback unless a citable mix ratio is found.

**F9 -- The seafood group moves to one source.** Ranking Gephart
against P&N put the same animal 2.3x apart: shipped
`prawns_farmed` 26.87 (P&N) vs Gephart farmed shrimp harmonised
by this doc's own section-10 recipe to 11.69. Seafood is
Gephart-uniform in v2, which **changes the shipped prawns value**
-- flagged for the owner, not decided here.

**F10 -- Three section-8 copy rules are unimplemented in shipped
code**, verified today: comparative copy fires on any positive
delta with no 20% gate (`food_calculator_screen.dart:248`); the
quantity editor autofocuses the grams field instead of defaulting
to a preset (`ingredient_editor_sheet.dart:193`); tie-break sort
is insertion order. Prose rules are not being honoured at 41
items, so v2 encodes them as schema flags and tests instead.

---

## 2. Selection rules

Moved to [RESEARCH_FOOD.md](./RESEARCH_FOOD.md) section 2.2 (rules
R1-R7 and the factor-route table) -- they outlive this spec, so
they live in the research doc. Read them before adding, cutting or
re-sourcing any item below.

---

## 3. Schema additions

Required before any v2 item ships. Every one replaces prose that
no code currently reads.

```jsonc
{
  "aliases": {"en": ["chorizo", "serrano"], "ja": [...], "es": [...]},
  "search_terms": {"ja": ["ぎゅうにく", "gyuniku"]},
  "category_anchor": "Other Vegetables",  // null when species-specific
  "source_tier": 1,
  "statistic": "mean_with_losses",
  "weight_basis": "as_purchased",  // dry|drained|edible|concentrate
  "entry_mode": "grams",           // preset_only
  "default_serving_id": "cup_10g",
  "comparable": true,              // may appear in generated comparisons
  "tie_group": "pn_root_vegetables",
  "confidence": "high",
  "spread_low": 0.45, "spread_high": 2.20,
  "parent": "pork", "mass_ratio": 1.35,   // for T3, drives the R7 test
  "composite_of": ["chickpeas", "tahini", "olive_oil"]
}
```

Tests these unlock: physical floor (R7); concentration check
(`child ~= parent x mass_ratio x uplift`); generated tie-cluster
and never-pin lists (the hand-written pairwise list is ~21,500
pairs at this size and will never be maintained); every
`preset_only` item has a default serving; every non-tier-1 value
is snapshot-pinned in `pinned_factors.json` so a change shows as
a diff.

---

## 4. Blocking UI dependencies

The dataset does not ship without these. `FoodItemPicker` builds
every tile in a plain `Column` inside a `SingleChildScrollView`
and the drag pool builds every chip eagerly -- at ~185 items that
is roughly 20 screens of scroll and a drag source nobody can
reach.

1. Search field + lazy list, matching on `aliases`/`search_terms`
   with diacritic folding (JA and ES cannot be searched by
   display-name substring).
2. Recents replacing the item pool.
3. Group icons and l10n for the new groups.
4. `entry_mode: preset_only` honoured in the editor.
5. The >= 20% comparative gate actually enforced.
6. `weight_basis` rendered in the picker label and the editor.

Out of scope here but recorded: the calculator compares whole
meals with no serves-N divisor, so a family-sized pot banks ~4x
the avoided CO2e it should.

---

## 5. Items

Counts are pickable items. Aliases are additional findable names
resolving to the same item, listed inline.

### 5.1 meat (11)

| id | Name | Route | Aliases / note |
|----|------|-------|----------------|
| beef | Beef | P&N | mince, steak, burger, roast, brisket. **Value under research** (single-item blend vs beef-herd row) |
| lamb | Lamb | P&N Lamb & Mutton | mutton, chops |
| pork | Pork | P&N Pig Meat | chops, loin, belly |
| chicken | Chicken | P&N Poultry | breast, thigh, wings |
| turkey | Turkey | CAT Poultry | R2 fails on the only source (SEL +5-11%); ships as a poultry-category name |
| duck | Duck | CAT Poultry | same |
| goat | Goat | CAT Lamb & Mutton | cabrito, chivo |
| bacon | Bacon | T3 from pork | needs a citable cure/cook yield; floor-checked >= pork |
| ham | Ham (cooked) | T3 from pork | must not absorb dry-cured ham |
| sausage_pork | Pork sausages | T3 from pork | needs a citable meat % |
| cured_meat | Cured meat (dry) | T3 from pork | salami, chorizo, serrano, prosciutto, pepperoni |

Cut: `veal` (F7), `liver` (no published offal allocation factor),
`salami` as a separate row (folded into `cured_meat`).

### 5.2 seafood (10, Gephart-uniform)

| id | Name | Route | Aliases / note |
|----|------|-------|----------------|
| salmon | Salmon | G | trout, sea trout -- Gephart separates them by 5.5%, under R2 |
| white_fish | White fish | G | cod, haddock, pollock, hake, merluza, tilapia, basa |
| tuna_raw | Tuna (raw) | G | sashimi, poke, steak. Species spread disclosed |
| tuna_canned | Tuna (tinned, drained) | T3 from tuna_raw | drained basis |
| small_fish | Oily fish (sardines, mackerel) | v1 | tinned and fresh presets, both bases declared |
| prawns | Prawns / shrimp | G | gambas, ebi. **Replaces P&N 26.87 -- owner call flagged** |
| squid | Squid & octopus | G | calamari, pulpo, ika, tako. One Gephart row covers both |
| bivalves | Mussels, clams & oysters | G | mejillones, almejas, asari. Edible-meat basis |
| crab_lobster | Crab & lobster | G | one Gephart row covers both |
| seaweed | Seaweed (dried) | G / T2 | nori, wakame, kombu. `comparable: false`; cut if no nori-specific LCA is found -- the processed range is 12.6-78.4 |

Cut: `scallops` (no farmed row exists; farmed 1.40 vs wild 11.40
with no published blend), `fish_fingers` and `surimi` (per-brand
QUID, no anchor for Alaska pollock).

### 5.3 dairy_eggs (11)

| id | Name | Route | Aliases / note |
|----|------|-------|----------------|
| milk_dairy | Milk | P&N | whole, semi, skimmed |
| flavoured_milk | Flavoured milk | T3 from milk | milkshake |
| cream | Cream | T3 from milk | needs a citable fat-allocation basis |
| yogurt | Yogurt | T3 from milk | ~1:1; R2 borderline, ships as a name on a derived number |
| greek_yogurt | Greek yogurt (strained) | T3 from milk | needs a citable strain ratio or it merges into `yogurt` |
| cheese | Cheese | P&N | cheddar, gouda, mozzarella, parmesan, manchego, feta, brie, edam. **One number**: P&N publishes a single global cheese mean, and its implied yield (23.88/3.15 = 7.58 L/kg) sits *below* every published cheddar yield, so milk-derived cheese splits come out inverted |
| cottage_cheese | Cottage cheese & ricotta | CAT Cheese | disclosed as the cheese category value |
| butter | Butter | v1 T2 | |
| ice_cream | Ice cream | T3 | mass not volume (overrun to 85%); ships as a floor if the recipe ratio is only partial |
| milk_powder | Milk powder | T3 from milk | ~8x; `preset_only` |
| eggs | Eggs | P&N | |

Cut: `ghee`, `sour_cream`, `feta`/`parmesan`/`mozzarella` as
separate rows (F1), `whey_protein` (no anchor).

### 5.4 plant_protein (14)

| id | Name | Route | Aliases / note |
|----|------|-------|----------------|
| tofu | Tofu | P&N | |
| natto | Natto | T2 or CAT Tofu | JA daily staple; disclosed if category |
| tempeh | Tempeh | T2 or CAT Tofu | |
| edamame | Edamame | T2 | podded vs shelled basis, 2x |
| soy_tvp | Soy protein granules (dry) | T3 from tofu/soy | dry basis, 2.5-3x rehydrated |
| plant_mince | Plant-based mince | v1 T2 | |
| plant_burger | Plant-based burger | v1 T2 | patty functional unit |
| lentils | Lentils (dried) | P&N Other Pulses | |
| beans_dry | Beans (dried) | CAT Other Pulses | black, kidney, pinto, borlotti |
| chickpeas_dry | Chickpeas (dried) | CAT Other Pulses | garbanzos |
| beans_canned | Beans (tinned, drained) | v1 T3 | |
| chickpeas_canned | Chickpeas (tinned, drained) | CAT beans_canned | |
| baked_beans | Baked beans (tin) | T3 | **total** weight basis -- opposite to its neighbours, flagged |
| peas | Peas | P&N | moves to `vegetables` per UX review |

Cut: `seitan` (wheat-starch co-product allocation swings it
1.6-16), `falafel`, `hummus` unless a named brand's QUID can be
quoted.

### 5.5 nuts_seeds (6)

| id | Name | Route | Aliases / note |
|----|------|-------|----------------|
| tree_nuts | Tree nuts | P&N Nuts | almonds, cashews, walnuts, hazelnuts, pistachios. Orchard LUC credit -3.26 disclosed; without it ~3.7 |
| peanuts | Peanuts | P&N Groundnuts | 3.23 -- 7.5x the tree-nut row |
| peanut_butter | Peanut butter | T3 from peanuts | floor >= 3.23 |
| tahini | Tahini (sesame paste) | T2/T3 | seeds and paste cannot share a row |
| sunflower_seeds | Sunflower & pumpkin seeds | T2 | one row |
| mixed_nuts | Mixed nuts | T3 | **conditional**: ships only with a citable mix ratio, never at the tree-nut value (F8) |

### 5.6 staples (16)

| id | Name | Route | Aliases / note |
|----|------|-------|----------------|
| rice | Rice (dry) | P&N | white, brown, basmati, sushi rice |
| pasta | Pasta (dry) | CAT Wheat & Rye | spaghetti, penne, macaroni, couscous |
| bread | Bread | CAT Wheat & Rye | white, wholemeal, sourdough, rolls, pita, naan, bagel |
| wrap_wheat | Wheat wrap / flour tortilla | CAT Wheat & Rye | **never localised as bare "tortilla"** -- in Spain that word means omelette |
| tortilla_corn | Corn tortilla | CAT Maize | the ES/MX daily staple |
| masa_flour | Maize flour / masa | CAT Maize | |
| flour_wheat | Flour | CAT Wheat & Rye | |
| noodles_udon | Udon (fresh) | T3 | MEXT moisture ratio; wet basis, 2.66x vs dry |
| noodles_ramen | Ramen noodles (fresh) | T3 | JA; same derivation |
| soba | Soba | T3 | buckwheat/wheat blend must be cited |
| instant_noodles | Instant noodles | T2 | palm-fried; `prepared`-like but shelved with staples |
| breakfast_cereal | Breakfast cereal | T2/T3 | corn flakes, granola as alias only if the ratio is citable |
| oats | Oats | v1 D3 | porridge, oatmeal |
| quinoa | Quinoa | T2 | |
| potatoes | Potatoes | P&N | |
| sweet_potato | Sweet potato | CAT Root Vegetables | satsumaimo, camote |

Also: `cassava` (P&N 1.32, yuca) and `barley` (P&N 1.18) ship as
rows -- both are real P&N entries the v1 dataset never used.
Cut: `crackers` (moves to treats), `granola` as its own row.

### 5.7 vegetables (26)

`tomatoes` is P&N. Everything marked CAT carries
`category_anchor` and is never described as a species mean (F4).

| Anchor | Items |
|--------|-------|
| P&N Tomatoes 2.09 | tomatoes |
| T3 from tomatoes | tomatoes_canned, tomato_paste (paste only, >=24% TSS; passata is a separate ~1.1x product and does **not** share this row) |
| CAT Brassicas 0.51 | cabbage, broccoli, cauliflower, kale |
| CAT Root Vegetables 0.43 | carrots, beetroot, daikon (turnip, radish) |
| CAT Onions & Leeks 0.50 | onions, leeks, garlic (spring onion) |
| CAT Other Vegetables 0.53 | cucumber, lettuce, spinach, bell_pepper, chilli, courgette, aubergine, green_beans, celery, pumpkin_squash, sweetcorn, bean_sprouts, peas (P&N has its own peas row -- keep it) |
| T2 (species-specific, worth resolving) | mushrooms (substrate + climate control, not a field crop), asparagus (air freight), avocado is filed under fruit |

Cut: `frozen_mixed_veg` (its stated benefit -- less household
waste -- is explicitly outside the boundary), `pickles_kimchi`
(kimchi contains salted seafood; no citable ratio for either
half), `olives` (moves to condiments).

### 5.8 fruit (18)

| Anchor | Items |
|--------|-------|
| P&N | apples, bananas (plantain as CAT), grapes (P&N Berries & Grapes) |
| CAT Citrus 0.39 | oranges, lemons_limes, mandarin (mikan, satsuma, clementine) |
| CAT Berries & Grapes 1.53 | strawberries, blueberries, cherries |
| CAT Other Fruit 1.05 | melon, watermelon, pineapple, kiwi, peaches, pears, plums, dates, persimmon (kaki) |
| T2 | avocado (high salience, worth a species value), mango (air vs sea freight is the whole spread) |
| T3 | raisins (81% -> 15% moisture = 4.47x, reproducible from composition tables) -- raisins only, not "dried fruit" |

### 5.9 drinks (16)

| id | Route | Note |
|----|-------|------|
| coffee | P&N | `preset_only`; preset label carries the gram weight |
| coffee_instant | T3 from coffee | `preset_only`; ~2 g/cup vs ~10 g -- the presets must differ visibly |
| tea | v1 T2 | black, green, sencha, oolong. `preset_only` |
| matcha | T2/T3 | JA; `preset_only` |
| cocoa_powder | T2 | `preset_only`; moves the chocolate LUC lesson |
| soy_milk | P&N | |
| oat_milk | P&N chart | |
| almond_milk | T2 | water, not carbon, is its story |
| beer | v1 D2 | |
| wine | P&N | red, white, rosé, sparkling (packaging delta ~10%, under R2) |
| cider | T2 | |
| sake | T2 | JA |
| spirits | T2 | ships only with a real source; per-serving copy only |
| soft_drink | T2 | cola, lemonade, energy drink |
| orange_juice | T2 | apple juice as alias unless a source separates them |
| coconut_drink | T2 | carton; **distinct row and label from the cooking tin** |

Cut: `bottled_water` (nothing to compare it against -- tap water
is not loggable), `rice_milk`, `herbal_tea`, `sparkling_wine`.

### 5.10 treats (11)

| id | Route | Note |
|----|-------|------|
| dark_chocolate | P&N | sublabel required |
| milk_chocolate | T2 | conditional on a published chocolate LCA that separates milk from dark; **must not alias to dark** (~2x overstatement) |
| biscuits | T2 | cookies, galletas |
| cake | T2 | conditional |
| pastry | T3 | croissant, doughnut, churros -- one row, butter/oil dominated, conditional on a citable ratio |
| crisps | T2 | bag of potato chips; frying oil dominates |
| popcorn | T3 from maize | |
| sweets | T2 | gummies, candy |
| honey | T2 | |
| jam | T3 | Council Directive 2001/113/EC gives a citable fruit ratio (note EU 2024/1438 revised it -- the ratio has a version) |
| cane_sugar | P&N | beet sugar is a separate P&N row at 1.81 vs cane 3.20 -- a real 77% split, and European sugar is mostly beet. Ship both or rename the item honestly |

Cut: `chocolate_spread` (two of five inputs have no anchor),
`cereal_bar`/`protein_bar` (no ratio), `maple_syrup`,
`crackers` folded into `biscuits`.

### 5.11 oils_fats (6)

P&N stage CSV: sunflower 3.5995, rapeseed 3.7677, olive 5.4249,
soybean 6.3245, palm 7.3168. No adjacent gap clears 20% except
rapeseed->olive, so the group is three rows, not five.

| id | Route | Aliases |
|----|-------|---------|
| seed_oil | P&N (sunflower/rapeseed) | sunflower, rapeseed, canola, vegetable oil |
| olive_oil | P&N | |
| palm_soy_oil | P&N | palm, soybean -- 15.7% apart, one row; the palm story lives in the science sheet and in `crisps` |
| coconut_oil | T2 | |
| sesame_oil | T2 | JA; `preset_only` |
| margarine | T3 from seed oil | 21 CFR 166.110 "not less than 80 percent fat" gives a citable ratio; floor-checked against its own oil. Belongs here, not in dairy -- it is an oil product (owner correction 2026-08-01) |

### 5.12 condiments (10)

All `preset_only` with tsp/tbsp defaults.

| id | Route | Note |
|----|-------|------|
| soy_sauce | T2 | JA |
| miso | T2 | JA |
| salt | T2 | near-zero, one row makes the point |
| vinegar | T2 | |
| ketchup | T3 | a named brand's declared "148 g tomatoes per 100 g" is quotable; brand named in the notes |
| mayonnaise | T3 | 21 CFR 169.140 >= 65% oil gives a citable floor; the oil identity forks it by market, so state which. Filed here, not oils_fats -- it is 65% oil by composition but a condiment by use, and nobody hunts for mayo in an oils list (owner correction 2026-08-01) |
| pasta_sauce_tomato | T3 | **Tomato** pasta sauce, named explicitly. "Pasta sauce" alone fails R1: tomato, pesto and cream-based sauces are far apart and the jar tells you which (owner correction 2026-08-01). Pesto and cream sauces ship only if separately sourced |
| salsa | T3 | ES/MX |
| olives | CAT Other Vegetables | drained, pitted basis |
| coconut_milk_tin | T2 | **"Coconut milk for cooking (tin)"** -- label must not collide with the carton |

Cut: `mustard` (mustard seed has no parent anywhere),
`black_pepper`, `dried_herbs`, `hot_sauce`, `wasabi` (the tube is
horseradish -- fails R1 and R4), `stock_cube`, `curry_roux`,
`dashi`, `mirin` -- all fail R4, and all are sub-gram or
sub-2-gram portions.

### 5.13 prepared (4)

| id | Route | Note |
|----|-------|------|
| frozen_pizza | T2 | conditional on a published pizza LCA |
| frozen_chips | T2 | fries; oven or fryer |
| onigiri | T3 | JA; rice + nori + filling, ratio citable from pack |
| canned_soup | T2 | conditional |

Cut: `ready_meal`, `sandwich_prepacked` (the one real source is
cradle-to-grave with 25-49% of its total in refrigeration and
preparation, unstrippable), `sushi_pack`, `chicken_nuggets`,
`bento`, `gazpacho`, `croquetas`.

---

## 6. Totals

| Group | Items |
|-------|------:|
| meat | 11 |
| seafood | 10 |
| dairy_eggs | 11 |
| plant_protein | 13 |
| nuts_seeds | 6 |
| staples | 18 |
| vegetables | 41 |
| fruit | 18 |
| drinks | 16 |
| treats | 11 |
| oils_fats | 6 |
| condiments | 10 |
| prepared | 4 |
| **Total pickable** | **175** |

Plus ~95 aliases resolving into those rows, so roughly **255
names a user can search for**, on **~70 distinct researched
numbers**.

That is the honest shape of the request. Two hundred separately
*numbered* items cannot be sourced: P&N stops at 37 rows, and
every alternative database sits at a quarter to a half of it on a
different statistic with different land-use accounting. What can
be delivered is 160 findable foods, ~95 more names that resolve
to them, every number traceable, and the resolution limit stated
in the UI rather than papered over with invented precision.

---

## 7. Research waves

Each wave gets the shared brief (boundary, tiers, evidence rules,
per-item output shape) and returns items in the schema of
section 3. An item that cannot meet the bar comes back CUT.

| Wave | Scope | Hardest question |
|-----:|-------|------------------|
| 0 | beef single-value decision | in progress |
| 1 | meat: the four T3 cured/processed items | citable cure and cook yields; floor >= pork |
| 2 | seafood: all 10, Gephart-uniform | edible->as-purchased yields per item; the prawns 2.3x owner call |
| 3 | dairy: cream, yogurt, greek, ice cream, milk powder, flavoured milk | citable concentration ratios; every one floor-checked against milk |
| 4 | plant protein + nuts/seeds | natto/tempeh/edamame sources; the mixed-nuts ratio; tahini |
| 5 | staples | noodle moisture ratios (MEXT), instant-noodle frying uplift, cereal |
| 6 | vegetables + fruit | only mushrooms, asparagus, avocado, mango need species values; the rest is anchor mapping and presets |
| 7 | drinks | instant-coffee ratio, matcha, cocoa, almond milk, juices, sake, cider, spirits |
| 8 | treats | the milk-vs-dark chocolate separation; biscuits, crisps, sweets, honey, jam ratio; beet vs cane sugar |
| 9 | oils (incl. margarine), condiments, prepared | mayonnaise floor, ketchup QUID, soy sauce, miso, pizza/chips/soup |
| 10 | serving presets for every new item | FDA RACC / USDA FDC / quotable pack sizes, matched to each item's declared basis |

---

## 8. Research status (2026-08-01)

Seven of nine waves returned. Raw per-item output with quotes and
URLs is in the session scratchpad (`wave1_meat.md`,
`wave2_seafood.md`, `wave3_dairy.md`, `wave4_plant.md`,
`wave5_staples.md`, `wave6_produce.md`, `wave7_drinks.md`,
`wave8_treats.md`).

**Blocked, not finished:**

- **Wave 9 (oils, condiments, prepared)** -- terminated by an API
  session limit before returning anything. Must be re-run.
- **Seafood decision** -- the Gephart-uniform recommendation
  (prawns 26.87 -> 9.43, -65%) was challenged on the grounds that
  Gephart's SI states it excludes pond CH4/N2O, which is the
  dominant term for pond-farmed shrimp specifically. The follow-up
  agent was mid-reconciliation when the session limit hit. **Do
  not apply the seafood group until this is answered.**
- **P&N Table S1 functional units** -- wave 5's central claim
  (that "Wheat & Rye" 1.57 is per kg of BREAD, and "Barley" 1.18
  is per LITRE OF BEER) could not be verified at source before the
  limit. It invalidates shipped values if true, so it is the first
  thing to re-check.

**Findings against SHIPPED data, pending verification:**

| Item | Shipped | Finding |
|------|--------:|---------|
| pasta | 1.57 | wheat row is per kg of bread (39% water); dry pasta should be ~2.29 |
| bread | 1.57 | value right, `calculation_notes` wrong -- it is the P&N functional unit, not a derived grain mean |
| peas | 0.98 | P&N "Peas" FU is "1 kg of dry pea without pod"; the shipped preset is frozen garden peas. Green peas belong on Other Vegetables 0.53 |
| cane_sugar | 3.20 | same defect D5 fixed in beef: a sub-population value under a global name. Should be `sugar` 2.922 on the 80/20 cane/beet production split |
| nuts | 0.43 | is the tree-nut row; peanuts are a separate P&N row at 3.23 |
| fish_wild, small_fish | 9.50, 5.5 | both built on the section-10 harmonisation recipe that wave 2 argues is unsound |

**Convention error found:** section 2's "liquids at density 1.0,
error < 1.5%" does not hold for the oils. P&N's oil functional
unit is 1 LITRE; palm olein is ~0.915 kg/L, a 9.3% error. Affects
palm and olive oil directly.

**Owner corrections applied:** margarine moved from `dairy_eggs`
to `oils_fats` (2026-08-01) -- it is an oil product, and the
earlier placement came from a UX review suggestion to shelve it
next to butter, which was wrong on substance.

---

## 9. P&N Table S1 functional units

Moved to [RESEARCH_FOOD.md](./RESEARCH_FOOD.md) section 2.1
(verbatim Table S1 rows, verified 2026-08-01, plus the
weight-basis consequences per row).

---

## 10. Owner-raised gaps -- resolved 2026-08-02

### Nuts: NO species split. Single `tree_nuts` row stands.

The owner is right that almond, cashew and walnut differ in
reality. No source can show it to this standard:

- The two databases that resolve all five disagree on **rank
  order**. Agribalyse v3.2: almond 2.63 < cashew 3.56 < walnut
  4.11 < hazelnut 4.81 < pistachio 7.22. SU-EATABLE LIFE:
  hazelnut 1.112 < cashew 1.382 < pistachio 1.60 < almond 1.88 <
  walnut 2.06. Spearman rho = **-0.3**.
- SEL's hazelnut is partly almond data: two of its five hazelnut
  observations are bit-identical to two almond observations
  (same paper, country and flag), and the hazelnut median lands
  on one of them.
- R2 fails inside each candidate anyway -- SEL puts almond and
  walnut 9.6% apart, i.e. the same food.
- Four sources, four incompatible orchard-LUC treatments (P&N
  -3.257812 credit; Agribalyse zero credit and a +4.54 charge on
  pistachio; SEL silent; Volpe 2015 substitutes two others).

**The finding that matters most, and it is uncomfortable:** the
7.5x gap between `tree_nuts` 0.43 and `peanuts` 3.23 **is** the
orchard credit. Strip it and tree nuts sit **12.5% below**
peanuts -- close enough that under R2 the two rows would have to
merge. The dataset's most striking nut contrast rests entirely on
one accounting choice. The science sheet must say so, and
comparative copy between the two rows should be suppressed.

Six sourced direction-and-magnitude statements are in the wave
output for the science sheet, since the numbers cannot ship.

### Vegetables: 26 -> 41 rows

15 new rows on existing P&N anchors -- no new numbers. Evidence
corrected two of my assumptions:

- **Bamboo shoot ships** -- FAO commodity 0463 names it
  explicitly, so the "may not fit any category" worry was wrong.
- **Lotus root is CUT**, for a better reason than "no anchor":
  renkon grows in permanently flooded anaerobic paddy, the same
  soil condition that separates P&N's Rice 4.45 from dry cereals
  at 1.18-1.70. The category 0.53 is not an average with unknown
  error, it is a lower bound biased downward by a nameable
  mechanism.
- **Japanese mushrooms merge into `mushrooms`** -- a
  shiitake-specific LCA exists (Tongpool & Pongpat 2013, 1.87)
  and sits 12.2% from the 2.13 species value, under R2.
- Four items need the as-purchased basis made prominent:
  artichoke (75% refuse), takenoko (50%), negi (40%), rocket.

### Bars: both stay cut

- `protein_bar` -- blocker identified precisely: the protein
  blend is first-listed with no QUID, so it is >= 19% by FIC
  Art. 18(1), and whey has no anchor and cannot get one (it is a
  cheesemaking co-product needing an allocation rule, not a
  concentration ratio). Only 26% of the bar is QUID-declared.
- `cereal_bar` -- **the earlier "no citable ratio" reason was
  wrong** and should be corrected in this plan: the mechanism
  works fine. It fails R2 against itself. Two bars with nearly
  the same name cost out 3.86x apart. One archetype does close
  (2.261702) but lands within 20% of jam, popcorn and tomato
  pasta sauce -- a fourth name for a number already shipped.

### Vegetable enumeration detail (wave 10B)

Final breakdown, 26 -> 41 rows (42 with the optional dried
shiitake), all on existing anchors:

| anchor | before | after |
|---|---:|---:|
| P&N Tomatoes 2.09 | 1 | 1 |
| T3 from tomatoes | 2 | 2 |
| CAT Brassicas 0.51 | 4 | 7 (+hakusai, pak_choi, brussels_sprouts) |
| CAT Root Vegetables 0.43 | 3 | 6 (+gobo, satoimo, nagaimo) |
| CAT Onions & Leeks 0.50 | 3 | 4 (+spring_onion) |
| CAT Other Vegetables 0.53 | 13 | 21 (+takenoko, okra, artichoke, fennel, chayote, nopal, goya, tomatillo) |
| T2 species | 2 | 2 |

Three things this forces:

1. **`pn_other_vegetables` now holds 21 items on one number** --
   210 never-pin pairs from this group alone. This is the
   argument for generating the tie-cluster list rather than
   hand-maintaining it (section 3), not an argument against the
   items.
2. **A `category_membership: named | inferred` flag is needed.**
   Six of the new rows (chayote, nopal, goya, tomatillo, rocket,
   shungiku) rest only on a residual commodity's "not identified
   separately" wording -- FAO never names them. That is weaker
   evidence than hakusai or brussels sprouts, where FAO 0358
   names the food verbatim, and the difference should be visible
   in the data rather than buried in notes.
3. **`spread_low`/`spread_high` are load-bearing for satoimo and
   nagaimo** (0.43-1.32). FAO files taro and yam in the same
   chapter as cassava, whose P&N row is 3.07x Root Vegetables on
   tropical land-use change. Japanese-grown satoimo sits at the
   0.43 end and a tropical taro plausibly at the 1.32 end -- and
   the ES aliases (malanga, ñame, yautia) are exactly the
   tropical end. If the science sheet does not render the spread,
   those two rows are less honest than the file implies.

**Traps recorded:** `tomatillo` must never inherit P&N Tomatoes
2.09 (that row is high because of heated greenhouses; tomatillo
is field-grown -- 3.94x too high). `yuca` is cassava; `yucca` is
an ornamental and must stay out of the alias list. US-English
"yam" usually means sweet potato, a different shipped row.
Artichoke has the worst refuse in the produce set (75% MEXT / 60%
USDA), so a hearts-basis entry would run 2.5-4x low.

**Optional row:** `dried_shiitake` 18.617019, T3 from mushrooms
2.13 x 8.740384615 (MEXT moisture 89.6% fresh -> 9.1% dried,
refuse cancels). A pure moisture-concentration floor with no
drying energy. Ships or cuts on the owner's preference.
