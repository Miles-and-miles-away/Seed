# Action Research -- Archive (the 2026-01-31 research pass)

**Archived:** 2026-08-29. The value tables moved out of
[RESEARCH_ACTIONS.md](./RESEARCH_ACTIONS.md) when that document was
rewritten as methodology. Everything here is a **dated snapshot of
what one research pass proposed**; nothing below is a live
instruction and nothing below is the current value of anything.

**The authority for every shipped action value is
`data/seed/co2_actions_database.json`**, which the seeder reads
directly. The bar a new action must clear is
[AUDIT_ACTION_DATA.md](./AUDIT_ACTION_DATA.md). The durable findings
from this pass -- the caveats, the confidence definitions, the
source hierarchy -- stayed in RESEARCH_ACTIONS.md, because those are
method rather than data.

---

## 0. Why this is a snapshot and not a table to maintain

These tables were reconciled against the live library on
2026-08-29. Of **62 proposed action rows**:

| Outcome | Count |
|---|---|
| Ships under the same id, same value | **1** (`tree_planting`) |
| Ships under the same id, value since revised | **13** |
| No live counterpart under this id | **48** |

Updating the tables to current values was considered and is not
possible: 48 of the 62 rows have nothing to update *to*. The
transport and flight rows were superseded wholesale by the Phase 8
transport calculator's logging bridge, which banks a measured
difference rather than a fixed per-km action. The four food swap
rows became tier actions. Most of the rest were researched and never
shipped.

So the tables stay exactly as the pass produced them, dated, with
the reconciliation below. A half-updated table would be worse than
an openly historical one: it would read as current and be wrong in
48 places.

### The 13 rows that ship at a revised value

| action_id | this pass proposed | ships today |
|---|---:|---:|
| `seasonal_produce` | 2350 | 500 |
| `composting` | 700 | 200 |
| `air_dry_clothes` | 1665 (US) | 2000 |
| `shorter_shower` | 55 | 110 |
| `recycle_aluminum_can` | 99 | 100 |
| `recycle_paper` | 2590 | 50 |
| `recycle_cardboard` | 2160 | 500 |
| `recycle_ewaste` | 2350 | 2000 |
| `recycle_textiles` | 14000 | 40000 |
| `reusable_water_bottle` | 75 | 160 |
| `secondhand_clothing` | 13000 | 15000 |
| `beach_cleanup` | INDIRECT | 0 |
| `community_garden` | INDIRECT | 200 |

The recycling rows moved most, because this pass quoted per-kg
figures while the shipped library defines a standard logging unit
per action (AUDIT_ACTION_DATA.md section 2). They are not
corrections of the same quantity.

### The food rows, as a worked example of the drift

The four food swap ids in the FOOD table below
(`meatless_meal_beef`, `meatless_meal_chicken`,
`meatless_meal_pork`, `plant_milk_vs_dairy`) were retired into tier
actions during the Phase 8 food work. The beef figure passed through
9700 and 6800 before landing at 3700 under
`skip_high_impact_food`, and 5340 here was never a shipped value at
all. PDR_FOOD_CALCULATOR.md section 4 holds the current table and the
binding derivation for each.

### Superseded assumptions in the prose below

- **Grid factors.** The US 0.37 / UK 0.21 kg per kWh split was
  replaced by a single global **458 g CO2e/kWh** (decision E1,
  Ember Global Electricity Review 2026). See
  AUDIT_ACTION_DATA.md section 8. Every US/UK pair in the ENERGY
  table is computed off the retired figures.
- **Beef at 60 kg CO2e/kg.** That is the Poore & Nemecek *median*
  set, retired by Our World in Data in 2022. The dataset ships the
  production-weighted means (food decision D1).
- **"approximately 100 actions".** The library ships 92.

---

## 1. Original opening (verbatim, 2026-01-31)

Individual sustainability actions can collectively reduce household
carbon footprints by **4-8 tonnes annually**, roughly 30-50% of
average emissions in developed nations. This database synthesizes
research from 40+ peer-reviewed sources, government agencies, and
verified calculators to provide fact-checked CO2 savings data for
approximately 100 actions across all 17 UN Sustainable Development
Goals. The highest-impact actions cluster in three areas: avoiding
beef, avoiding flights, and switching to renewable energy. Every
data point includes at least two corroborating sources, with
preference given to DEFRA 2024 UK Government factors, US EPA data,
and the Poore & Nemecek (2018) Science meta-analysis.

Two baseline grid carbon intensities underpinned it: US average
0.37 kg CO2/kWh (EIA 2023) and UK average 0.21 kg CO2/kWh (DEFRA
2024). Both are superseded; see section 0.

---

## 2. TRANSPORT (proposed 2026-01-31, superseded)

| action_id | action_name | co2_grams | unit | confidence | related_sdgs |
|-----------|-------------|-----------|------|------------|--------------|
| bike_instead_of_car | Biking instead of driving | 149 | per_km | High | [11, 13, 3] |
| walk_instead_of_car | Walking instead of driving | 165 | per_km | High | [11, 13, 3] |
| escooter_instead_of_car | E-scooter instead of driving | 125 | per_km | Medium | [11, 13] |
| bus_instead_of_car | Public bus instead of driving | 138 | per_km | High | [11, 13, 9] |
| train_instead_of_car | Train/metro instead of driving | 130 | per_km | High | [11, 13, 9] |
| carpooling_passenger | Carpooling per additional passenger | 82 | per_km | High | [11, 13] |
| work_from_home | Working from home (avoiding car commute) | 2640 | per_day | Medium | [11, 13, 8] |
| electric_vs_gasoline_car | Electric car instead of gasoline | 121 | per_km | High | [7, 11, 13] |

Baseline was an average petrol car at 164.5 g CO2e/km (DEFRA 2024),
cycling at 16 g/km for metabolic food energy, e-scooters 27-40 g/km
private and 105-120 g/km shared.

**Status:** none of these ship. Phase 8 replaced the whole category
with the transport calculator, which banks a measured difference
between two journeys rather than a fixed per-km action.
`RESEARCH_TRANSPORT.md` is the live evidence base.

## 3. FLIGHTS (proposed 2026-01-31, superseded)

| action_id | action_name | co2_grams | unit | confidence | calculation_notes |
|-----------|-------------|-----------|------|------------|-------------------|
| train_vs_flight_50km | Train instead of flight (50km) | 14850 | per_trip | Medium | 50km flights rare; extrapolated from ICCT curves |
| train_vs_flight_100km | Train instead of flight (100km) | 23500 | per_trip | Medium | Domestic flight factor 273g/pkm (DEFRA) |
| train_vs_flight_200km | Train instead of flight (200km) | 44200 | per_trip | High | DEFRA domestic 246g/pkm vs rail 35g/pkm |
| train_vs_flight_500km | Train instead of flight (500km) | 95500 | per_trip | High | Short-haul efficiency improves to 170g/pkm |
| train_vs_flight_1000km | Train instead of flight (1000km) | 135000 | per_trip | High | Short-haul 154g/pkm vs rail 35g/pkm |

All figures include a 1.9x radiative forcing multiplier. The choice
of multiplier is a standing methodology decision and stayed in
RESEARCH_ACTIONS.md.

**Status:** none ship as discrete actions; the transport calculator
covers flights, with the flight band auto-picked from leg distance.

## 4. FOOD (proposed 2026-01-31, superseded)

| action_id | action_name | co2_grams | unit | confidence | related_sdgs |
|-----------|-------------|-----------|------|------------|--------------|
| meatless_meal_beef | Meatless meal (beef avoided) | 5340 | per_100g_serving | High | [2, 12, 13, 15] |
| meatless_meal_chicken | Meatless meal (chicken avoided) | 540 | per_100g_serving | High | [2, 12, 13] |
| meatless_meal_pork | Meatless meal (pork avoided) | 610 | per_100g_serving | High | [2, 12, 13] |
| plant_milk_vs_dairy | Plant-based milk instead of dairy | 460 | per_250ml_serving | High | [12, 13, 15] |
| local_produce | Local instead of imported produce | 100 | per_kg | Low | [12, 13] |
| seasonal_produce | Seasonal instead of out-of-season | 2350 | per_kg | Medium | [12, 13] |
| food_waste_avoided | Food waste avoided | 1680 | per_kg | High | [2, 12, 13] |
| home_cooked_meal | Home-cooked instead of restaurant | 350 | per_meal | Low | [12, 13] |
| composting | Composting instead of landfill | 700 | per_kg | High | [12, 13, 15] |
| growing_vegetables | Growing own vegetables | -2100 | per_kg | High | [2, 12] |

**Status:** see section 0. PDR_FOOD_CALCULATOR.md section 4 is the
authority for the food actions that ship.

## 5. ENERGY (proposed 2026-01-31, superseded grid factors)

| action_id | action_name | co2_grams_us | co2_grams_uk | unit | confidence |
|-----------|-------------|--------------|--------------|------|------------|
| led_vs_incandescent | LED instead of incandescent (60W equiv) | 18.5 | 10.5 | per_hour | High |
| unplug_standby | Unplugging device (standby power) | 8.9 | 5.0 | per_device_per_day | Medium |
| air_dry_clothes | Air drying instead of tumble dryer | 1665 | 945 | per_load | High |
| cold_water_laundry | Cold water instead of hot wash | 629 | 357 | per_load | High |
| thermostat_heating | Thermostat -1C (heating season) | 450 | 250 | per_day | Medium |
| thermostat_cooling | Thermostat +1C (cooling season) | 350 | 200 | per_day | Medium |
| natural_light | Natural light instead of LED | 3.7 | 2.1 | per_hour_per_light | High |
| solar_panels | Solar panel installation (residential) | 3885000 | 714000 | per_year | High |
| green_energy_switch | Switching to green energy provider | 4512000 | 1080000 | per_year | Medium |

Every figure is computed off the retired US/UK grid split. The live
energy values were rebased to 458 g CO2e/kWh under decision E1;
`RESEARCH_ENERGY.md` is the live evidence base.

## 6. WATER (proposed 2026-01-31)

| action_id | action_name | water_liters | co2_grams | unit | confidence |
|-----------|-------------|--------------|-----------|------|------------|
| shorter_shower | Shorter shower (per minute saved) | 9.5 | 55 | per_minute | High |
| tap_off_brushing | Turning off tap while brushing | 15 | 12 | per_instance | Medium |
| fix_leaky_faucet | Fixing leaky faucet | 3.8 | 15 | per_day | Medium |
| low_flow_showerhead | Low-flow showerhead installation | 15 | 95 | per_shower | High |
| rainwater_collection | Rainwater for garden (vs mains) | 1 | 0.3 | per_liter | Low |
| dishwasher_vs_handwash | Full dishwasher instead of hand washing | 70 | 340 | per_load | Medium |

Original derivation for the shower figure: 9.5 L/min showerhead
(EPA WaterSense), 65% heated, 0.0407 kWh to heat 1 L by 35C, so
6.2 L x 0.0407 kWh x 207 g/kWh (UK) = 52 g plus 3 g water treatment
= 55 g per minute. The 207 g/kWh input is retired.

## 7. RECYCLING (proposed 2026-01-31)

| action_id | action_name | co2_grams | unit | item_weight | confidence |
|-----------|-------------|-----------|------|-------------|------------|
| recycle_aluminum_can | Aluminum can recycling | 99 | per_can | 15g | High |
| recycle_pet_bottle | PET plastic bottle recycling | 47 | per_bottle | 28g | Medium-High |
| recycle_glass_bottle | Glass bottle recycling | 300 | per_wine_bottle | 450g | Medium-High |
| recycle_paper | Paper recycling | 2590 | per_kg | - | Medium |
| recycle_cardboard | Cardboard recycling | 2160 | per_kg | - | Medium |
| recycle_ewaste | E-waste recycling | 2350 | per_kg | - | Medium |
| recycle_textiles | Textile recycling/reuse | 14000 | per_kg | - | Medium |
| recycle_battery_aa | AA battery recycling | 95 | per_battery | 23g | Low-Medium |

Paper and cardboard were midpoints of wide ranges (880-4,300 g for
paper; 320-4,000 g for cardboard); the spread is whether avoided
landfill methane is counted. These are per-kg figures, whereas the
shipped library defines a standard logging unit per action.

## 8. CONSUMPTION (proposed 2026-01-31)

| action_id | action_name | co2_grams | unit | break_even_uses | confidence |
|-----------|-------------|-----------|------|-----------------|------------|
| reusable_bag_cotton | Reusable cotton shopping bag | 10 | per_use_after_breakeven | 131-171 | High |
| reusable_bag_pp | Reusable polypropylene bag | 10 | per_use_after_breakeven | 10-45 | High |
| reusable_water_bottle | Reusable water bottle | 75 | per_use_after_breakeven | 10-30 | High |
| reusable_coffee_cup | Reusable coffee cup | 40 | per_use_after_breakeven | 20-100 | Medium-High |
| secondhand_clothing | Buying secondhand clothing | 13000 | per_item | Instant | Medium-High |
| repair_smartphone | Repairing instead of replacing smartphone | 55000 | per_device | Instant | High |
| borrow_tools | Borrowing tools instead of buying | 15000 | per_tool | Instant | Medium |
| refuse_plastic_straw | Refusing single-use plastic straw | 1.4 | per_straw | Instant | High |
| bar_soap_vs_liquid | Bar soap instead of liquid soap | 1.5 | per_wash | Instant | High |
| bulk_buying | Bulk buying (reduced packaging) | 85 | per_kg | Instant | Medium |

## 9. COMMUNITY (proposed 2026-01-31)

| action_id | action_name | co2_grams | unit | confidence | calculation_notes |
|-----------|-------------|-----------|------|------------|-------------------|
| tree_planting | Tree planting | 15000 | per_tree_per_year | High | Sequestration accumulates over decades; 10-year tree = 150-250kg |
| beach_cleanup | Beach/park cleanup | INDIRECT | per_event | Medium | Ecosystem protection; track as participation, not CO2 |
| sustainability_sharing | Sharing sustainability knowledge | INDIRECT | per_interaction | Low | Behavioral spillover effect; cannot quantify |
| farmers_market | Supporting local farmers market | 300 | per_shopping_trip | Medium | Conservative transport-only estimate |
| community_garden | Community garden participation | INDIRECT | per_session | High | See food caveat; emphasize social benefits |

`tree_planting` at 15000 is the one row that survived this pass
unchanged.

## 10. SDG mapping (proposed 2026-01-31)

Nine SDGs were mapped to direct trackable actions and eight to
"Learn Only" educational content. The live mapping is
`sdg_coverage` in `co2_actions_database.json` and the per-action
`related_sdgs` field.

| SDG | Name | Primary Categories |
|-----|------|-------------------|
| 2 | Zero Hunger | Food, Community |
| 3 | Good Health | Transport, Water |
| 6 | Clean Water | Water |
| 7 | Clean Energy | Energy |
| 11 | Sustainable Cities | Transport, Community |
| 12 | Responsible Consumption | Consumption, Recycling, Food |
| 13 | Climate Action | ALL |
| 14 | Life Below Water | Recycling, Community |
| 15 | Life on Land | Community, Food |

SDGs 1, 4, 5, 8, 9, 10, 16 and 17 were classed Learn Only: systemic
issues needing policy rather than individual daily habits.

## 11. Proposed JSON shape (superseded by the shipped schema)

The pass proposed a record shape that the shipped file has since
outgrown. The live schema is documented in AUDIT_ACTION_DATA.md
section 3, and the file itself is the reference.

```json
{
  "action_id": "bike_instead_of_car",
  "action_name": "Biking instead of driving",
  "category": "Transport",
  "co2_grams": 149,
  "unit": "per_km",
  "calculation_notes": "165g/km petrol car (DEFRA 2024) minus 16g/km cycling",
  "sources": [{"name": "DEFRA 2024", "url": "https://www.gov.uk/..."}],
  "confidence": "high",
  "related_sdgs": [11, 13, 3]
}
```
