# Eco-Fact Deduplication Plan

**Created:** 2026-03-14
**Status:** Planning (analysis complete, no changes made yet)
**File:** `data/app/eco_facts.json`

---

## 1. Internal Near-Duplicates in eco_facts.json

These facts within eco_facts.json cover the same topic with overlapping claims:

| Day A | Day B | Topic | Notes |
|-------|-------|-------|-------|
| 57 | 126 | Composting diverts 150kg waste, methane 80x potent | Nearly identical fact, different sources (WRAP UK vs EPA) |
| 1 | 83 | Plant-based / beef CO2 (Poore & Nemecek) | Same source, related beef/plant claims |
| 12 | 172 | Oat milk vs dairy (Poore & Nemecek) | Day 12 has specific numbers, day 172 is a myth-buster |
| 85 | 153 | Reusable bag breakeven (UK Environment Agency) | Paper bags (day 85) vs cotton tote (day 153), same source |
| 153 | 184 | Bag reuse breakeven | Cotton tote 131 uses (day 153) vs reusable 50 uses (day 184) |
| 46 | 134 | Flight CO2 emissions | Long-haul (day 46) vs short-haul vs train (day 134) |
| 154 | 347 | Cycling vs driving CO2 | Day 154: saves 1.5kg/10km. Day 347: lifecycle 21g vs 271g/km |

**Recommendation:** Days 57/126 are the only true duplicate -- one should be replaced. The others are thematically related but provide distinct angles.

---

## 2. Overlaps Between eco_facts.json and co2_actions_database.json

These eco_facts restate claims that already appear in the actions database. Not necessarily a problem (facts are user-facing, actions are for logging), but worth noting for consistency.

### HIGH severity (same source, same statistic)

| Day | Topic | Action ID | Issue |
|-----|-------|-----------|-------|
| 1, 83 | Beef CO2 / Poore & Nemecek | `meatless_meal_beef` | Same source cited in both |
| 12 | Dairy 3.2kg vs oat 0.9kg CO2/L | `plant_milk_vs_dairy` | Identical numbers in both files |
| 71 | Transport = 6% of food emissions | `local_produce` | Nearly verbatim claim |

### MEDIUM severity (same topic, different framing or numbers)

| Day | Topic | Action ID | Issue |
|-----|-------|-----------|-------|
| 92 | Air drying saves 2.4kg CO2/load | `air_dry_clothes` | Action says 1.7kg -- inconsistent |
| 188 | LEDs use 75% less energy | `led_vs_incandescent` | Action source says "up to 90%" |
| 129 | Extend garment life 9 months = 20-30% savings | `secondhand_clothing` | Nearly verbatim from same WRAP UK source |
| 77 | Aluminum can recycling energy | `recycle_aluminum_can` | Same source (Aluminum Association) |
| 99 | Carpooling halves emissions | `carpool_passenger` | Same claim |
| 153 | Cotton tote 131 uses breakeven | `reusable_bag` | Action says 7,100-20,000 (different metric scope) |
| 108 | Reusable bottle breakeven ~50 uses | `reusable_water_bottle` | Action says 10-30 uses |
| 124 | Cold water laundry 90% energy | `cold_water_laundry` | Same topic |
| 154 | Cycling saves 1.5kg/10km | `bike_instead_of_car` | eco_fact uses 271g/km lifecycle, action uses 164g/km DEFRA |

### Data Inconsistencies to Resolve

| Topic | eco_facts value | co2_actions value | Which is correct? |
|-------|----------------|-------------------|-------------------|
| Air drying CO2/load | 2.4 kg (day 92) | 1.7 kg | Different grid factors (UK vs US) |
| LED energy savings | 75% less (day 188) | up to 90% less | Both valid (incandescent vs halogen baseline) |
| Cotton bag breakeven | 131 uses (day 153) | 7,100-20,000 uses | Different scope (climate-only vs all indicators) |
| Chicken CO2/kg | ~6 kg (day 261) | 2.6-3.3 kg | eco_fact likely wrong -- Poore & Nemecek says ~6 for pork, ~3 for chicken |
| Reusable bottle breakeven | ~50 uses (day 108) | 10-30 uses | Need to verify source |
| Cycling g/km | 271 g/km (day 347) | 164 g/km | Different methodology (full lifecycle vs tailpipe) |

---

## 3. Category Balance (Current)

| Category | Current | Target (365) | Delta |
|----------|---------|--------------|-------|
| comparison | 72 | 73 | -1 |
| individual | 75 | 73 | +2 |
| mythBuster | 72 | 73 | -1 |
| natureWonder | 73 | 73 | 0 |
| positiveNews | 73 | 73 | 0 |

Categories are well-balanced. If replacing day 57 or 126 (the composting duplicate), use the freed slot for a comparison or mythBuster.

---

## 4. UN World Day Alignment Audit

Cross-referenced `data/reference/un_world_days.json` (52 official UN days)
against `data/app/eco_facts.json` (58 facts tagged with unWorldDay).

### Coverage: 51 of 52 UN days are correctly aligned

### Missing UN Day (1)

| UN Day | Date | dayOfYear | Issue |
|--------|------|-----------|-------|
| International Day of Peace | Sep 21 | 264 | Slot taken by Zero Emissions Day (also Sep 21) |

**Note:** Sep 21 has two UN observances. Zero Emissions Day currently occupies day 264. International Day of Peace (SDG 16) has no representation. This could be addressed by giving day 264 a dual tag or adding a Peace-related fact on a nearby day.

### Name Mismatches (2)

| dayOfYear | eco_facts says | un_world_days.json says |
|-----------|---------------|------------------------|
| 112 | "Earth Day" | "International Mother Earth Day" |
| 168 | "World Day to Combat Desertification" | "World Day to Combat Desertification and Drought" |

### Spurious Duplicate Tag (1)

| dayOfYear | unWorldDay | Issue |
|-----------|-----------|-------|
| 280 | "World Habitat Day" | Incorrect -- World Habitat Day is Oct 1 (day 274). Day 280 (Oct 7) should have unWorldDay set to null |

### Non-UN Observances in eco_facts (kept, no issue)

| dayOfYear | unWorldDay | Type |
|-----------|-----------|------|
| 1 | Veganuary | Campaign |
| 87 | Earth Hour | WWF event |
| 182 | Plastic Free July | Campaign |
| 305 | World Vegan Day | Non-UN observance |

---

## 5. Overlaps Between eco_facts.json and sdg_targets.json

**No content overlap.** sdg_targets.json contains only policy-level UN SDG target descriptions (e.g., "By 2030, eradicate extreme poverty..."). It has no educational facts, statistics, or impact numbers. These files serve completely different purposes.

---

## 6. co2_actions_database.csv vs co2_actions_database.json

**Identical data.** The CSV is a flattened export of the JSON (29 actions, same fields). The CSV omits the metadata section, SDG coverage mapping, and caveats/notes. No unique content in either format.

---

## 7. Theme and SDG Gap Analysis

### Overrepresented Themes (no new facts needed)
- food/diet: 89 facts (24%)
- energy: 83 facts (23%)

### Underrepresented Themes (candidates for new facts)
- policy/governance: 2 facts
- buildings/housing: 3 facts
- climate science: 3 facts
- technology: 4 facts
- fashion/textiles: 4 facts
- consumer/lifestyle: 5 facts
- social justice: 8 facts

### Underrepresented SDGs (fewer than 15 references)
- SDG 5 (Gender Equality): 5 facts
- SDG 4 (Quality Education): 7 facts
- SDG 16 (Peace/Justice): 8 facts
- SDG 1 (No Poverty): 9 facts
- SDG 8 (Decent Work): 9 facts
- SDG 10 (Reduced Inequalities): 9 facts

---

## 8. Fix Plan

### Phase 1: Tag and Name Fixes (no content changes)

These are mechanical edits -- change a field value, nothing else.

| # | Day | Field | Current | Fix To |
|---|-----|-------|---------|--------|
| 1 | 280 | unWorldDay | "World Habitat Day" | null |
| 2 | 112 | unWorldDay | "Earth Day" | "International Mother Earth Day" |
| 3 | 168 | unWorldDay | "World Day to Combat Desertification" | "World Day to Combat Desertification and Drought" |

### Phase 2: Data Correction

| # | Day | Field | Current | Fix To | Rationale |
|---|-----|-------|---------|--------|-----------|
| 4 | 261 | factEn | "...roughly 7 kg for pork and 6 kg for chicken" | "...roughly 7 kg for pork and 3 kg for chicken" | Poore & Nemecek 2018 reports chicken at 2.6-3.3 kg CO2e/kg, not 6. The 6 figure is pork-range |

### Phase 3: Replace Composting Duplicate (day 126)

**Remove:** Day 126 -- "Composting food scraps at home can divert 150+ kg..."
(Keep day 57 which has the same content but was first)

**Replacement fact -- must NOT duplicate existing content.**

Existing content already covers:
- Climate inequality / richest 10% (day with Oxfam source)
- Indigenous peoples + biodiversity (day 221, World Bank source)
- Renewable energy jobs 13.7M (day with IRENA source)
- Gender + climate vulnerability (day with UN Women source)
- Education + climate (day with UNESCO source)
- Armed conflict + natural resources (day with UNEP source, 70% stat)
- Gulf War environmental damage (day 310)

**Candidate: Military carbon footprint (NEW topic, not in database)**
- Category: comparison (balance: currently 72, needs +1)
- Fact: "If the world's militaries were a single country, they would be the 4th largest emitter of greenhouse gases -- producing roughly 5.5% of global emissions. Yet military emissions are not required to be reported under the Paris Agreement."
- Source: Scientists for Global Responsibility / Conflict and Environment Observatory, 2022
- URL: https://ceobs.org/estimating-the-militarys-global-greenhouse-gas-emissions/
- SDGs: [13, 16]
- unWorldDay: null
- Why this topic: "military" does not appear anywhere in eco_facts.json. Hits underrepresented SDG 16 and underrepresented policy/governance theme. Comparison category restores balance.

**Backup candidate: Carbon pricing effectiveness (NEW topic)**
- Category: mythBuster
- Fact: "Carbon pricing is often dismissed as ineffective, but the EU Emissions Trading System has cut covered emissions by 47% since 2005 while GDP grew 65% -- proving that economic growth and emission cuts are not mutually exclusive."
- Source: European Environment Agency
- URL: https://www.eea.europa.eu/en/analysis/indicators/greenhouse-gas-emission-trends
- SDGs: [8, 13]
- unWorldDay: null
- Why: "carbon pricing" and "carbon tax" do not appear in eco_facts. Hits underrepresented SDG 8 and policy/governance theme.

### Phase 4: International Day of Peace

Sep 21 (day 264) is occupied by Zero Emissions Day. Two options:

**Option A (recommended): Dual-tag day 264**
- Change unWorldDay from "Zero Emissions Day" to "Zero Emissions Day / International Day of Peace"
- Current fact about highest-impact personal actions (SDGs 12, 13) is broadly relevant to both days
- Simplest fix, no content change needed

**Option B: Swap a nearby fact**
- Day 263 (axolotl regeneration, natureWonder) and day 265 (heat pump, comparison) are both untagged and unrelated to peace
- Could replace day 263's fact with a peace-environment fact and tag it "International Day of Peace"
- This is more disruptive and the axolotl fact is a good natureWonder

**Recommendation:** Go with Option A. The dual-tag approach keeps all existing facts and simply acknowledges both observances on Sep 21.

### Phase 5: Data Inconsistencies (research needed)

These eco_facts vs co2_actions discrepancies need source verification before fixing. No changes until confirmed.

| # | Topic | eco_facts | co2_actions | Action |
|---|-------|-----------|-------------|--------|
| 5 | Air drying CO2/load | 2.4 kg (day 92, UK DEFRA) | 1.7 kg (US grid) | OK as-is -- different grids. Add "(UK grid)" qualifier to eco_fact |
| 6 | LED savings | 75% (day 188, IEA) | up to 90% (US DOE) | OK as-is -- different baselines (incandescent vs halogen) |
| 7 | Cotton bag breakeven | 131 uses (day 153) | 7,100-20,000 uses | OK as-is -- different scope (climate-only vs all indicators). eco_fact already implies climate-only |
| 8 | Reusable bottle | ~50 uses (day 108) | 10-30 uses | Verify day 108 source. If wrong, update to match |
| 9 | Cycling g/km | 271 g/km lifecycle (day 347) | 164 g/km tailpipe | OK as-is -- different methodologies, both stated in context |

---

## 9. Implementation Checklist

- [ ] Phase 1: Fix 3 unWorldDay tags (days 280, 112, 168)
- [ ] Phase 2: Fix chicken CO2 on day 261
- [ ] Phase 3: Replace day 126 with military carbon footprint fact
- [ ] Phase 4: Dual-tag day 264 for Peace Day
- [ ] Phase 5: Verify day 108 reusable bottle source, fix if needed
- [ ] Run `flutter test` after changes
- [ ] Verify JSON validity after edits
