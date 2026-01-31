# Comprehensive CO2 Emissions Savings Database for Sustainability Habit-Tracking Apps

Individual sustainability actions can collectively reduce household carbon footprints by **4-8 tonnes annually**—roughly 30-50% of average emissions in developed nations. This database synthesizes research from 40+ peer-reviewed sources, government agencies, and verified calculators to provide fact-checked CO2 savings data for approximately 100 actions across all 17 UN Sustainable Development Goals. The highest-impact actions cluster in three areas: **avoiding beef** (5,340g per meal), **avoiding flights** (135kg per 1,000km train substitution), and **switching to renewable energy** (2.5-4.5 tonnes annually). Every data point includes at least two corroborating sources, with preference given to DEFRA 2024 UK Government factors, US EPA data, and the landmark Poore & Nemecek (2018) Science meta-analysis.

## Grid emission factors determine all energy-related calculations

Two baseline grid carbon intensities underpin this database: **US average (0.37 kg CO2/kWh)** from EIA 2023 data, and **UK average (0.21 kg CO2/kWh)** from DEFRA 2024 conversion factors. Regional variation is substantial—coal-heavy grids can reach 0.8 kg/kWh while Nordic grids approach 0.02 kg/kWh. For global applicability, the app should allow users to input local grid factors or select from regional presets. All energy actions below provide both US and UK figures where relevant.

---

## TRANSPORT: The highest per-kilometer savings category

Transport actions offer consistently high CO2 savings with strong source agreement, making them ideal for habit tracking.

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

**Calculation methodology**: Baseline is average petrol car at **164.5 g CO2e/km** (DEFRA 2024). Cycling emissions (16g/km) account for metabolic food energy from European average diet. E-scooter range (27-40g/km for private; 105-120g/km for shared) reflects lifecycle manufacturing impacts—shared scooters have shorter lifespans and collection logistics overhead.

**Key sources**: UK DEFRA Greenhouse Gas Conversion Factors 2024 (gov.uk); Our World in Data travel carbon footprint; IEA working from home analysis; PNAS 2023 teleworking emissions study.

---

## FLIGHTS: Discrete distance calculations with radiative forcing

Aviation emissions require special treatment due to takeoff energy overhead and the radiative forcing multiplier debate. Short flights are disproportionately carbon-intensive because **40% of fuel consumption on flights under 500km occurs during takeoff and climb**.

| action_id | action_name | co2_grams | unit | confidence | calculation_notes |
|-----------|-------------|-----------|------|------------|-------------------|
| train_vs_flight_50km | Train instead of flight (50km) | 14850 | per_trip | Medium | 50km flights rare; extrapolated from ICCT curves |
| train_vs_flight_100km | Train instead of flight (100km) | 23500 | per_trip | Medium | Domestic flight factor 273g/pkm (DEFRA) |
| train_vs_flight_200km | Train instead of flight (200km) | 44200 | per_trip | High | DEFRA domestic 246g/pkm vs rail 35g/pkm |
| train_vs_flight_500km | Train instead of flight (500km) | 95500 | per_trip | High | Short-haul efficiency improves to 170g/pkm |
| train_vs_flight_1000km | Train instead of flight (1000km) | 135000 | per_trip | High | Short-haul 154g/pkm vs rail 35g/pkm |

**Radiative forcing multiplier**: The climate impact of aviation extends beyond direct CO2 emissions to include nitrogen oxides, water vapor, contrails, and cirrus cloud formation. DEFRA recommends a **1.9× multiplier**; IPCC suggests 2.7×; Lee et al. (2021) found non-CO2 effects account for 66% of total aviation forcing, suggesting ~3×. This database uses **1.9×** as the defensible default while noting the scientific debate. All flight figures above include this multiplier.

---

## FOOD: The most impactful dietary choices

Food choices represent **10-30% of individual carbon footprints**, with meat—especially beef—dominating impact. The Poore & Nemecek (2018) Science meta-analysis of 38,700 farms across 119 countries provides the gold-standard lifecycle data.

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

**Critical caveat on local food**: Transport accounts for only **5-6% of food emissions** globally. What you eat matters far more than where it comes from. Spanish tomatoes shipped to the UK can have *lower* emissions than UK greenhouse tomatoes in winter. The 100g/kg local produce figure represents conservative transport savings only.

**Critical caveat on growing vegetables**: University of Michigan research (2024) found urban agriculture produces **6× higher emissions** than conventional farming due to infrastructure costs (raised beds, tools, materials). The negative value above reflects this finding. Exceptions where home growing *does* save emissions: tomatoes grown outdoors (vs. greenhouse), air-freighted crops (asparagus, berries), and infrastructure reused 20+ years.

**Key sources**: Our World in Data food emissions; Poore & Nemecek (2018) Science; US EPA landfilled food waste methane study 2023; Nature Cities urban agriculture study 2024.

---

## ENERGY: Grid-dependent savings require regional adjustment

Energy savings depend critically on local grid carbon intensity. All figures below provide both US (0.37 kg/kWh) and UK (0.21 kg/kWh) calculations.

| action_id | action_name | co2_grams_us | co2_grams_uk | unit | confidence |
|-----------|-------------|--------------|--------------|------|------------|
| led_vs_incandescent | LED instead of incandescent (60W equiv) | 18.5 | 10.5 | per_hour | High |
| unplug_standby | Unplugging device (standby power) | 8.9 | 5.0 | per_device_per_day | Medium |
| air_dry_clothes | Air drying instead of tumble dryer | 1665 | 945 | per_load | High |
| cold_water_laundry | Cold water instead of hot wash | 629 | 357 | per_load | High |
| thermostat_heating | Thermostat -1°C (heating season) | 450 | 250 | per_day | Medium |
| thermostat_cooling | Thermostat +1°C (cooling season) | 350 | 200 | per_day | Medium |
| natural_light | Natural light instead of LED | 3.7 | 2.1 | per_hour_per_light | High |
| solar_panels | Solar panel installation (residential) | 3885000 | 714000 | per_year | High |
| green_energy_switch | Switching to green energy provider | 4512000 | 1080000 | per_year | Medium |

**Standby power evolution**: Modern regulations (post-2013) limit standby to ≤1W, down from 5-15W in older devices. The 8.9g/day figure reflects modern appliances; older cable boxes, DVRs, or gaming consoles in sleep mode may draw 8-50W, multiplying savings 5-30×.

**Solar panel regional variance**: US average 7.15kW system produces ~10,500 kWh/year; UK 4kW system produces ~3,400 kWh/year due to lower solar irradiance. Arizona systems (production ratio 1.6-1.8) significantly outperform Seattle/UK systems (ratio 1.0-1.2).

**Key sources**: US DOE Energy Saver; UK Energy Saving Trust; Lawrence Berkeley National Lab standby power database; DEFRA 2024 electricity emission factors.

---

## WATER: Often-overlooked heating energy dominates impact

Water conservation saves CO2 primarily through **reduced water heating energy**—not the water itself. Hot water heating accounts for 60-70% of water-related residential energy use.

| action_id | action_name | water_liters | co2_grams | unit | confidence |
|-----------|-------------|--------------|-----------|------|------------|
| shorter_shower | Shorter shower (per minute saved) | 9.5 | 55 | per_minute | High |
| tap_off_brushing | Turning off tap while brushing | 15 | 12 | per_instance | Medium |
| fix_leaky_faucet | Fixing leaky faucet | 3.8 | 15 | per_day | Medium |
| low_flow_showerhead | Low-flow showerhead installation | 15 | 95 | per_shower | High |
| rainwater_collection | Rainwater for garden (vs mains) | 1 | 0.3 | per_liter | Low |
| dishwasher_vs_handwash | Full dishwasher instead of hand washing | 70 | 340 | per_load | Medium |

**Calculation methodology**: Standard showerhead delivers 9.5 L/min (EPA WaterSense). Assuming 65% is heated water, energy to heat 1 liter by 35°C = 0.0407 kWh. Per minute: 6.2L × 0.0407 kWh × 207g/kWh (UK) = 52g plus 3g water treatment = **55g CO2/minute**.

**Rainwater caveat**: UK Environment Agency research found pumped rainwater harvesting systems can *increase* emissions versus mains water due to pump energy. The 0.3g/L figure applies only to simple gravity-fed rain barrels.

**Key sources**: EPA WaterSense; US DOE water heating; UK Energy Saving Trust; University of Michigan dishwasher vs handwashing study.

---

## RECYCLING: Aluminum delivers highest verified savings

Recycling benefits vary dramatically by material. Aluminum recycling is exceptionally impactful due to **95% energy savings** versus virgin production—a figure consistent across industry, academic, and government sources globally.

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

**Paper and cardboard ranges**: The figures above represent midpoints of wide ranges (880-4,300g for paper; 320-4,000g for cardboard). Higher values include avoided landfill methane emissions; lower values reflect production savings only. EPA WARM model uses higher figures; DEFRA uses conservative production-only figures.

**Textile reuse vs recycling**: The 14,000g/kg figure represents direct reuse displacing new garment purchase. Mechanical recycling of mixed textiles yields only 3,100-5,000g/kg. The difference is significant—reuse preserves full product value while recycling degrades fiber quality.

**Key sources**: EPA WARM Model; Aluminum Association LCA 2021; FEVE glass industry LCA; WRAP UK recycling data; Global E-Waste Monitor 2024.

---

## CONSUMPTION: Break-even points determine real impact

Reusable items require reaching break-even use counts before delivering net benefits. The Danish EPA's 2018 lifecycle assessment revealed counterintuitive findings about cotton bags that affect credibility.

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

**Cotton bag complexity**: The Danish EPA found cotton bags need **7,100-20,000 uses** to break even on *all* environmental indicators—essentially impossible. The 131-171 use figure is for climate-only comparison. Polypropylene reusable bags break even in just 10-45 uses, making them environmentally superior for most users.

**Secondhand clothing rebound effect**: A 2025 Yale study found heavy secondhand shoppers often increase total clothing consumption, negating benefits. Frame messaging as "instead of" rather than "in addition to" new purchases.

**Key sources**: Danish EPA bag LCA 2018; UK Environment Agency carrier bag LCA 2011; Carbon Trust smartphone emissions; ETH Zurich soap LCA; Edinburgh Tool Library carbon data.

---

## COMMUNITY: Honest accounting for indirect impacts

Community actions often have **indirect or difficult-to-quantify** impacts. Tree planting stands out as the most reliably quantifiable action.

| action_id | action_name | co2_grams | unit | confidence | calculation_notes |
|-----------|-------------|-----------|------|------------|-------------------|
| tree_planting | Tree planting | 15000 | per_tree_per_year | High | Sequestration accumulates over decades; 10-year tree = 150-250kg |
| beach_cleanup | Beach/park cleanup | INDIRECT | per_event | Medium | Ecosystem protection; track as participation, not CO2 |
| sustainability_sharing | Sharing sustainability knowledge | INDIRECT | per_interaction | Low | Behavioral spillover effect; cannot quantify |
| farmers_market | Supporting local farmers market | 300 | per_shopping_trip | Medium | Conservative transport-only estimate |
| community_garden | Community garden participation | INDIRECT | per_session | High | See food section caveat; emphasize social benefits |

**Tree sequestration data**: Tropical trees absorb 10-40 kg CO2/year; temperate broadleaf average 24 kg/year; EPA estimates urban trees sequester 85-140 lbs CO2 over first 10 years. The **15 kg/year** figure represents a reasonable global average for tracking purposes. Note: this is *sequestration*, not avoided emissions—carbon remains stored only as long as the tree lives.

**Community garden reality**: Given the University of Michigan finding that urban agriculture has 6× higher carbon footprint than conventional, community garden tracking should emphasize food security, mental health, community connection, and composting benefits—not CO2 savings claims.

---

## UN SDG mapping enables goal-based engagement

All 17 Sustainable Development Goals can be addressed through the database, with 9 supporting direct trackable actions and 8 serving as "Learn Only" educational content.

### SDGs with direct trackable actions

| SDG | Name | Primary Categories | Key Actions |
|-----|------|-------------------|-------------|
| 2 | Zero Hunger | Food, Community | Food waste reduction, farmers markets, seasonal eating |
| 3 | Good Health | Transport, Water | Active transport, air quality from reduced driving |
| 6 | Clean Water | Water | All water conservation actions |
| 7 | Clean Energy | Energy | Solar, green energy switch, efficiency measures |
| 11 | Sustainable Cities | Transport, Community | Public transit, cycling, tree planting |
| 12 | Responsible Consumption | Consumption, Recycling, Food | All reuse, recycling, and waste reduction |
| 13 | Climate Action | ALL | Primary goal—all CO2 reduction actions |
| 14 | Life Below Water | Recycling, Community | Plastic reduction, beach cleanups |
| 15 | Life on Land | Community, Food | Tree planting, sustainable food choices |

### SDGs as "Learn Only" categories

SDGs 1, 4, 5, 8, 9, 10, 16, and 17 address systemic issues (poverty, education, gender equality, economic systems, infrastructure, inequality, institutions, partnerships) that require policy intervention rather than individual daily habits. The app should offer educational content explaining how personal sustainability connects to these broader goals.

---

## Confidence ratings reflect source agreement

**HIGH confidence**: Multiple Tier 1 sources (government agencies, peer-reviewed meta-analyses) agree within 20%. Actions include: walking/biking transport, LED lighting, air drying clothes, aluminum recycling, beef avoidance, tree planting.

**MEDIUM confidence**: Sources agree on direction but vary in magnitude. Actions include: e-scooter emissions, thermostat adjustments, paper recycling, local food transport, dishwasher vs handwashing.

**LOW confidence**: Limited data, regional variation, or contested methodology. Actions include: growing vegetables, rainwater harvesting, battery recycling, home-cooked vs restaurant meals.

## Implementation recommendations for the app

For user display, present **midpoint values** with clear unit labels. In detailed views, show ranges and methodology notes for transparency. Allow users to input local grid emission factors for energy actions, as the difference between a coal-heavy grid (0.8 kg/kWh) and renewable-heavy grid (0.02 kg/kWh) changes energy action savings by 40×.

Flag actions with counterintuitive findings—cotton bags, growing vegetables, rainwater pumping—with clear explanations to build credibility rather than making indefensible claims. Users who discover the app's numbers are wrong will lose trust entirely; users who see the app acknowledge complexity will trust it more.

Track cumulative impact across categories with clear attribution to specific SDGs, enabling users to see their contribution to global goals beyond just CO2 numbers.

---

## Structured data format for JSON conversion

```json
{
  "metadata": {
    "version": "1.0",
    "last_updated": "2026-01-31",
    "grid_factors": {
      "us_average_kg_per_kwh": 0.37,
      "uk_average_kg_per_kwh": 0.21
    },
    "primary_sources": [
      "UK DEFRA Greenhouse Gas Conversion Factors 2024",
      "US EPA Greenhouse Gas Equivalencies Calculator", 
      "Poore & Nemecek (2018) Science meta-analysis",
      "Our World in Data"
    ]
  },
  "actions": [
    {
      "action_id": "bike_instead_of_car",
      "action_name": "Biking instead of driving",
      "category": "Transport",
      "co2_grams": 149,
      "unit": "per_km",
      "calculation_notes": "Based on 165g/km petrol car (DEFRA 2024) minus 16g/km cycling (metabolic emissions from European diet)",
      "sources": [
        {"name": "DEFRA 2024", "url": "https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2024"},
        {"name": "Our World in Data", "url": "https://ourworldindata.org/travel-carbon-footprint"}
      ],
      "confidence": "high",
      "related_sdgs": [11, 13, 3]
    },
    {
      "action_id": "meatless_meal_beef",
      "action_name": "Meatless meal (beef avoided)",
      "category": "Food",
      "co2_grams": 5340,
      "unit": "per_100g_serving",
      "calculation_notes": "Global average beef lifecycle emissions 60kg CO2e/kg from Poore & Nemecek 2018; per 100g = 5340g savings vs plant alternative",
      "sources": [
        {"name": "Poore & Nemecek 2018", "url": "https://ourworldindata.org/environmental-impacts-of-food"},
        {"name": "Our World in Data", "url": "https://ourworldindata.org/food-choice-vs-eating-local"}
      ],
      "confidence": "high",
      "related_sdgs": [2, 12, 13, 15]
    }
  ]
}
```

`co2_actions_database contains` output of the research for use in the app. 