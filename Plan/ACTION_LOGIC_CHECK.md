# Action Logic Check

Systematic review of seed_action_library.js for unclear
time-scope, confusing logging semantics, and inconsistent
CO2 estimation. Each section identifies problems and ends
with a concrete plan.


## Guiding Principle: Logging Units

Every action must have an unambiguous "logging unit."
Three types:

1. **Per instance** - Discrete, countable events.
   User logs each occurrence. (recycle a can, choose
   plant milk for one coffee)
2. **Per day** - Continuous daily habits.
   User logs once per day. Description should say "today."
   CO2 reflects a typical full-day estimate.
3. **One-time** - Rare or milestone actions.
   User logs once when the event happens. CO2 should
   reflect the expected long-term return, not just one
   day's savings.

Each action description must make the logging unit
obvious to the user.

---

## 1. One-Time Actions

### led_bulb -> install_led_bulb
**Decision:** Reframe as installing LEDs, not using them.
CO2 should reflect expected first-year savings.
- Calculation: 50W saved x 4hrs/day x 365 days = 73kWh
  x 386g/kWh = ~28,000g (28kg) first-year savings
- Name: "Install LED Lighting"
- Description: "Replace an incandescent or halogen bulb
  with an LED bulb"
- co2Grams: 28000
- effort: 2 (buy bulb, swap it)
- frequency: 1 (rare: one-time per bulb)
- impact: 3 (permanent daily savings for years)
- Comment: "first-year savings; 50W diff x 4hrs/day x
  365 x 386g/kWh"

### fix_leak
**Decision:** Keep action, update CO2 to reflect expected
lifetime return of the fix.
- A dripping tap wastes ~22L/day of hot water
- Energy to heat 22L: ~0.77 kWh/day x 386g/kWh = ~300g
  CO2/day
- Conservative 1-year expected benefit: 300 x 365 =
  ~109,000g. Round to 100,000g (100kg)
- Name: "Fix a Water Leak"
- Description: "Fix a dripping tap or leaking pipe"
- co2Grams: 100000
- effort: 3 (requires tools or plumber)
- frequency: 1 (rare: when leaks occur)
- impact: 4 (prevents ongoing waste for years)
- Comment: "~300g CO2/day from heating wasted water;
  conservative 1-year projected savings"

### join_eco_group -> attend_eco_meeting
**Decision:** Change from "join" (one-time) to "attend a
meeting/event" (repeatable).
- Name: "Attend Eco Group Meeting"
- Description: "Attend a meeting or event with a local or
  online environmental group"
- co2Grams: 0 (indirect: collective action)
- effort: 2 (attend, participate)
- frequency: 2 (monthly meetings)
- impact: 4 (amplifies voice, enables action)

### collect_rainwater -> install_rain_collector
**Decision:** Reframe as installing a rainwater collection
system. CO2 reflects first-year savings.
- A typical rain barrel collects ~1000-2000L/year
- Displaces mains water (treatment + pumping ~0.5g
  CO2/L): ~500-1000g/year
- Also avoids garden irrigation energy
- co2Grams: 750 (first-year mains displacement)
- Name: "Install Rain Collector"
- Description: "Set up a rain barrel or water collection
  system for garden use"
- effort: 3 (purchase, set up, maintain)
- frequency: 1 (rare: one-time installation)
- impact: 3 (water independence, ongoing savings)
- Note: CO2 is modest but water conservation value is
  high; impact score reflects ecological importance
  beyond just CO2

---

## 2. Unclear Unit Per Log

These are good habits worth reinforcing. The solution is
to define each as either "per day" or "per instance" and
adjust CO2 to match that unit.

### use_natural_light
**Decision:** Frame as per-day habit.
- Description: "Use natural light instead of electric
  lighting today"
- Estimate: avoided ~3hrs of lighting x 2 rooms avg x
  40W = 240Wh x 0.386g/Wh = ~93g
- co2Grams: 90 (up from 20)
- Comment: "daily est: 3hrs x 2 rooms x 40W x 386g/kWh"

### turn_off_lights
**Decision:** Frame as per-day habit.
- Description: "Turn off lights in empty rooms today"
- Estimate: typical household wastes ~2hrs of unnecessary
  lighting across rooms per day. 2hrs x 80W (2 rooms) =
  160Wh x 0.386 = ~62g
- co2Grams: 60 (up from 30)
- Comment: "daily est: ~2hrs wasted lighting x 80W avg"

### unplug_devices
**Decision:** Frame as per-day habit.
- Description: "Unplug standby devices when not in use
  today"
- Estimate: ~5 devices x 3W avg standby x 8hrs = 120Wh
  x 0.386 = ~46g
- co2Grams: 45 (up from 40)
- Comment: "daily est: 5 devices x 3W x 8hrs standby"

### reusable_water_bottle (keeping; removing drink_tap_water)
**Decision:** Frame as per-day habit.
- Description: "Use your reusable bottle instead of
  buying disposable bottles today"
- Estimate: avoids ~2 plastic bottles per day = ~160g
- co2Grams: 160 (up from 80)
- Comment: "daily est: ~2 PET bottles avoided x 83g each"

### plant_milk
**Decision:** Keep as per-instance (per serving).
Description should clarify this.
- Description: "Choose plant-based milk instead of dairy
  for a drink or meal"
- co2Grams: 550 (unchanged, per 250ml serving)
- Comment clarified: "per serving (250ml); dairy 3.2 vs
  oat 0.45 kg CO2/L (Poore 2018)"
- Users log each conscious switch (coffee, cereal, etc.)

### bar_soap
**Decision:** Frame as per-day habit. Expand scope to
cover all plastic-free personal care.
- Rename: plastic_free_hygiene
- Name: "Plastic-Free Personal Care"
- Description: "Use bar soap, shampoo bars, or refillable
  products instead of plastic-bottled ones today"
- Estimate: ~3-4 uses/day, avoiding ~1/100 of a plastic
  bottle per use = ~6 bottles/year avoided. 6 bottles x
  100g CO2 / 365 = ~2g/day. Very small.
- co2Grams: 15 (accounting for full lifecycle of
  refillable vs disposable including transport)
- Comment: "daily est; modest CO2 but meaningful plastic
  reduction habit"
- Note: Small CO2 is honest. The habit value is in
  plastic waste reduction, not carbon. Impact score
  compensates.

### refuse_straw + no_single_use_cutlery + use_cloth_napkin
**Decision:** Merge into one daily action. Individually
these are 1-5g and not worth separate logging friction.
- Rename: refuse_disposables
- Name: "Refuse Single-Use Disposables"
- Description: "Refuse disposable straws, cutlery,
  napkins, or other single-use items today"
- Estimate: straw (1g) + cutlery (5g) + napkin (5g) +
  misc (4g) = ~15g per day of conscious refusal
- co2Grams: 15
- effort: 1
- frequency: 5 (daily: meals and drinks)
- impact: 2 (plastic pollution awareness)
- Comment: "daily est: combined straw + cutlery + napkin
  + misc disposable avoidance"
- REMOVES: refuse_straw, no_single_use_cutlery,
  use_cloth_napkin (3 actions -> 1)

### digital_receipt
**Decision:** Keep as per-instance. It is a quick one-tap
decision at checkout and doesn't need merging. CO2 is
tiny (3g) but the action is clearly scoped already.
No changes needed.

---

## 3. Wildly Variable Scope

### recycle_textiles
**Decision:** Define as "per bag" (standard garbage bag).
This normalizes the variance: 10 small shirts and 1
winter coat both fill roughly similar bag volume.

Scenarios for a standard bag (~4-5kg of textiles):
- A: 10 lightweight (t-shirts, underwear) ~0.4kg each =
  4kg; saves 4 x 20 = 80kg CO2
- B: 5 medium (jeans, sweaters) ~0.8kg each = 4kg;
  saves 4 x 20 = 80kg CO2
- C: 3 heavy (coats, jackets) ~1.5kg each = 4.5kg;
  saves 4.5 x 20 = 90kg CO2
- D: Mixed 7 items ~0.6kg avg = 4.2kg;
  saves 4.2 x 20 = 84kg CO2
- Applying ~50% effective reuse rate (not all donations
  get reused): 84kg x 0.5 = 42kg

Average across scenarios with reuse adjustment: ~40,000g

- Name: "Recycle or Donate a Bag of Textiles"
- Description: "Donate or recycle a bag of old clothing
  and textiles"
- co2Grams: 40000
- Comment: "per bag (~4-5kg); scenarios: 10 tees=80kg,
  5 jeans=80kg, 3 coats=90kg, mixed=84kg raw;
  x50% effective reuse rate -> ~40kg; 20kg CO2/kg
  textile (Poore 2018)"

### recycle_ewaste
**Decision:** Base on recycling one smartphone (most
common e-waste item). Keep description open for other
electronics.

Phone recycling CO2 analysis:
- Recoverable metals per phone: ~0.034g gold, 0.34g
  silver, 15g copper, plus rare earths
- Gold mining CO2: ~20,000 kg/kg. 0.034g saves ~680g
- Silver: ~100 kg/kg. 0.34g saves ~34g
- Copper: ~5 kg/kg. 15g saves ~75g
- Rare earths + avoided toxic landfill: ~500g
- Avoided manufacturing energy for recovered materials:
  ~700g
- Total per phone: ~2,000g (conservative)

- Name: "Recycle E-Waste"
- Description: "Take old electronics to an e-waste
  recycling drop-off point"
- co2Grams: 2000
- Comment: "est. per smartphone: ~680g gold recovery +
  ~34g silver + ~75g copper + ~500g rare earth/toxicity
  + ~700g manufacturing energy; conservative est.
  Actual item may vary but rewards the habit"

### secondhand_clothing
**Decision:** This one is inherently per-item and the
variance is real. Use a median garment weight.

Scenarios:
- T-shirt (0.2kg): new = ~8kg CO2; savings = ~8,000g
- Jeans (0.8kg): new = ~33kg CO2; savings = ~33,000g
- Sweater (0.4kg): new = ~15kg CO2; savings = ~15,000g
- Winter coat (1.2kg): new = ~35kg CO2; savings = ~35,000g
- Dress (0.3kg): new = ~12kg CO2; savings = ~12,000g

Median common purchase (jeans/sweater/shirt): ~15,000g

- co2Grams: 15000 (up slightly from 13000)
- Description: "Buy a secondhand clothing item instead of
  new (est. based on avg garment)"
- Comment: "per item, median garment; tee=8kg,
  jeans=33kg, sweater=15kg, coat=35kg, dress=12kg;
  median ~15kg"

### repair_item
**Decision:** Complete review. Keep as one action with
scenario-based average.

Scenarios for "repair instead of replace":
- Sew button / patch clothing: avoids new garment
  purchase. Savings: ~3,000g
- Fix zipper on bag/jacket: avoids replacement.
  Savings: ~5,000g
- Repair small appliance (lamp, iron, toaster):
  Savings: ~7,000g
- Fix furniture (chair leg, shelf): Savings: ~15,000g
- Replace phone screen: avoids new device.
  Savings: ~20,000g

Weighted toward common repairs (clothing + small items):
(3000 + 5000 + 7000 + 15000 + 20000) / 5 = 10,000g
But most repairs are small: clothing/zipper/small items.
Weighted avg (50% small, 30% medium, 20% large):
0.5*4000 + 0.3*7000 + 0.2*17500 = 2000+2100+3500 = 7600

- co2Grams: 7500 (up from 5000)
- Description: "Repair a broken item instead of buying
  new (clothing, appliance, furniture, etc.)"
- Comment: "weighted avg: 50% small repairs (clothing/
  zipper ~4kg), 30% medium (small appliance ~7kg), 20%
  large (furniture/electronics ~17.5kg) = ~7.5kg"

### borrow_instead_buy
**Decision:** Complete review. Most common borrowing is
tools, equipment, and occasion-specific items.

Scenarios:
- Library book: avoids ~1,000g manufacturing
- Power tool from neighbor: avoids ~10,000g
- Camping/sports gear: avoids ~15,000g
- Formal/occasion clothing: avoids ~10,000g
- Kitchen appliance (bread maker, etc.): avoids ~7,000g

Books are the most common borrow-instead-buy but also
the lowest impact. Tools/equipment are the target use
case for this action.
Weighted avg (30% book, 30% tool, 20% gear, 20% other):
0.3*1000 + 0.3*10000 + 0.2*15000 + 0.2*8500 =
300 + 3000 + 3000 + 1700 = 8000

But the description says "tool or item," suggesting
non-book items. If we exclude books:
(10000 + 15000 + 10000 + 7000) / 4 = 10,500g

Split the difference: ~8,000g

- co2Grams: 8000 (up from 2000)
- Description: "Borrow or rent a tool, appliance, or item
  instead of buying new"
- Comment: "per item; tool ~10kg, camping gear ~15kg,
  formal wear ~10kg, appliance ~7kg; weighted avg ~8kg"
- Note: Reframed away from books (library usage could be
  its own action if needed)

### donate_items
**Decision:** Complete review. This is for non-clothing
household items (textiles covered separately). Define as
"a donation run" (a box/bag of items).

Scenarios for a typical donation box:
- 5 books + 3 kitchen items: ~5 x 1kg + 3 x 3kg =
  ~14,000g saved
- Box of toys/games: ~8 items x 1,500g = ~12,000g
- Small appliances + misc: ~3 x 5,000g = ~15,000g
- Mixed bag (books, kitchenware, decor): ~10,000g

Average: ~12,000g

- co2Grams: 12000 (up from 500 which was way too low)
- Name: "Donate Unused Items"
- Description: "Donate a box or bag of unused household
  items instead of trashing them"
- Comment: "per donation run; books+kitchen ~14kg,
  toys ~12kg, appliances ~15kg, mixed ~10kg; avg ~12kg;
  excludes textiles (separate action)"

### buy_bulk
**Decision:** Complete review. Reframe as per shopping
trip rather than per item.

Scenarios for a bulk shopping trip:
- 3 dry staples in own containers (rice, pasta, nuts):
  saves 3 plastic bags x 30g = ~90g
- 1 cleaning product refill: saves ~80g (bottle)
- 1-2 large-format items vs small: saves ~50g packaging

Per trip total: ~150-250g

- co2Grams: 200 (up from 85)
- Description: "Buy groceries or supplies in bulk or
  using refill containers"
- Comment: "per shopping trip; 3 bulk staples ~90g +
  cleaning refill ~80g + misc ~30g = ~200g packaging
  CO2 avoided"
- Note: CO2 is modest, but the action rewards the
  habit of low-waste shopping. Impact score should
  reflect the waste reduction.

---

## 4. Logging Existing Habits / Lifestyle

### work_from_home
**Decision:** REMOVE entirely.
- Rewards privilege, not behavioral change
- Not all users have this option
- Gameable: permanent remote workers log 4.5kg daily
  for doing nothing different

### close_windows_ac
**Decision:** REPLACE with a better action.
- Current action is "don't do something dumb" which most
  people already do.

Proposed replacement: use_fan_instead_of_ac
- Name: "Use Fan Instead of AC"
- Description: "Use a fan or natural ventilation instead
  of air conditioning today"
- co2Grams: 1200
  (avg AC unit: ~1.5kW x 4hrs = 6kWh x 386g = ~2300g;
  fan: ~50W x 4hrs = 0.2kWh x 386g = ~77g;
  savings: ~2200g. Conservative at 1200g to account
  for partial use / not fully replacing AC)
- effort: 2 (comfort trade-off on hot days)
- frequency: 3 (cooling season, not every day)
- impact: 2 (individual behavior change)
- Comment: "daily est; AC 6kWh vs fan 0.2kWh;
  conservative assuming partial AC replacement"

### share_domestic_work
**Decision:** Keep but reframe with a concrete, loggable
metric. The SDG 5 (Gender Equality) value is important.

Problem: "share equally" is vague and unverifiable.
Better framing: focus on taking initiative on a specific
task.

- Name: "Take On a Household Task"
- Description: "Take initiative on a household task
  (cooking, cleaning, laundry, childcare) to support
  fair division of domestic labor"
- Logging metric: each time you deliberately take on a
  task your partner usually handles
- co2Grams: 0 (social equity action)
- effort: 2 (sustained awareness + action)
- frequency: 4 (several times per week)
- impact: 4 (generational family dynamics)
- relatedSdgs: ['5', '3', '8', '10']
- Note: frequency changed from 5 to 4 since it's about
  deliberate extra effort, not daily routine

### electric_car_commute -> electric_car_purchase
**Decision:** Reframe as a one-time purchase milestone.
This is one of the biggest environmental decisions a
person can make.

CO2 analysis:
- Average annual driving: ~15,000 km
- Gas car: 164g/km (DEFRA 2024)
- EV: ~50g/km (including grid average)
- Annual savings: 15,000 x 114g = ~1,710,000g (1.7 tons)
- Using first-year savings: ~1,700,000g

- Name: "Purchase an Electric Vehicle"
- co2Grams: 1700000
- effort: 5 (major financial + research decision)
- frequency: 1 (rare: once every 5-10 years)
- impact: 5 (systemic: drives EV market, permanent
  shift from fossil fuels)
- Comment: "first-year savings; 15,000km x (164-50)g/km
  = ~1.7 tons; DEFRA 2024 petrol vs avg grid EV"
- Note: The points formula's 0.4 exponent compresses
  this (1700000^0.4 = ~238 base), so it won't break
  the point economy.

### NEW: used_car_purchase
**Decision:** Add new action. Buying used instead of new
avoids manufacturing emissions entirely.

CO2 analysis:
- Manufacturing a new car: ~6,000-17,000 kg CO2
  (varies by size/type; mid-size ~8,000 kg)
- Buying used extends existing vehicle's life, avoiding
  100% of new manufacturing CO2
- Conservative estimate (avg car, partial credit since
  the car was already manufactured for someone):
  ~6,000,000g (6 tons)
- This is the CO2 embedded in manufacturing that would
  have been emitted for a new car purchase

- id: used_car_purchase
- Name: "Buy a Used Car Instead of New"
- Description: "Purchase a used vehicle instead of a
  brand new one"
- co2Grams: 6000000
- effort: 3 (research, inspect, negotiate)
- frequency: 1 (rare: major purchase)
- impact: 4 (reduces manufacturing demand)
- category: consumption
- relatedSdgs: ['12', '13']
- Comment: "avoids ~6 tons new car manufacturing CO2;
  conservative mid-size est (range 6-17 tons)"

---

## 5. Transport Distance Assumptions

**Decision:** Not a critical issue. Distances are
reasonable averages. Plan: update each description to
state the assumed distance so users understand what
they're logging. The CO2 is an estimate, and for a
habit-tracking app, this level of precision is fine.

Changes to descriptions:
- walk_instead_drive: "Walk instead of driving for a
  short trip (~1.5km)"
- bike_short_trip: already says "under 3km" - OK
- bike_medium_trip: already says "3-10km" - OK
- public_transport: "Take public transport instead of
  driving (~10km trip)"
- carpool: "Share a ride instead of driving alone
  (~10km trip)"
- take_bus: "Take the bus instead of driving (~7km trip)"
- Note: electric_car_commute is being replaced by
  electric_car_purchase (see section 4)

---

## 6. Overlap / Double-Counting

### drink_tap_water + reusable_water_bottle
**Decision:** REMOVE drink_tap_water. Keep only
reusable_water_bottle (reframed as per-day; see
section 2).

### local_produce + farmers_market
**Decision:** MERGE into one action.
- id: buy_local_produce
- Name: "Buy Local Produce"
- Description: "Buy locally grown food from a farmers
  market, farm stand, or local supplier"
- co2Grams: 300 (using the higher farmers_market
  estimate since it accounts for the full local food
  system benefit beyond just transport miles)
- category: community (supports local agriculture)
- effort: 2
- frequency: 3 (weekly)
- impact: 3 (supports local agriculture ecosystem)
- relatedSdgs: ['2', '11', '12', '13']
- Comment: "per shopping trip; reduced food miles +
  less refrigerated supply chain vs supermarket"
- REMOVES: local_produce, farmers_market (2 -> 1)

### Meat/Fish Actions -> Impact Tiers
**Decision:** Replace 4 individual meat actions
(meatless_meal_beef, meatless_meal_chicken,
meatless_meal_pork, skip_fish_meal) + reduce_dairy
with a clearer tiered system:

#### skip_high_impact_food (replaces meatless_meal_beef)
- Name: "Skip High-Impact Food"
- Description: "Choose a plant-based alternative instead
  of high-impact animal products (beef, lamb, cheese,
  farmed shrimp) or destructively sourced seafood
  (bottom-trawled fish, overfished species)"
- co2Grams: 6000 (based on beef/lamb meal, the primary
  target; cheese and shrimp are similar per serving)
- effort: 2
- frequency: 3 (weekly)
- impact: 4 (deforestation, methane, ocean destruction)
- relatedSdgs: ['2', '12', '13', '14', '15']
- Comment: "per meal; beef ~60kg/kg, lamb ~24kg/kg,
  cheese ~21kg/kg, shrimp ~18kg/kg (Poore 2018);
  also covers destructively fished species (bottom
  trawling, overfishing) due to ecosystem damage"

Why combine CO2 + ecological destruction: Beef and lamb
are the clear CO2 leaders. But farmed shrimp destroys
mangroves, bottom trawling devastates ocean floors, and
overfished species (bluefin tuna, Atlantic cod) threaten
ecosystem collapse. These may have "lower" CO2 per kg
but their ecological harm is comparable. Grouping them
as "high impact" gives users a simple mental model:
these are the foods that do the most total damage.

The long description should list specific examples:
- CO2 giants: beef, lamb, goat
- Ecosystem destroyers: farmed shrimp (mangroves),
  bottom-trawled fish (seafloor), overfished species
- High land-use: cheese (methane + land)

#### skip_medium_impact_food (replaces chicken/pork/fish)
- Name: "Skip Medium-Impact Food"
- Description: "Choose a plant-based alternative instead
  of medium-impact animal products (chicken, pork, eggs,
  farmed salmon, dairy)"
- co2Grams: 1000 (avg of chicken ~6.9, pork ~7.6,
  eggs ~4.7, salmon ~5-8 kg CO2/kg; per ~150g serving)
- effort: 2
- frequency: 3 (weekly)
- impact: 2 (lower land/methane than high-impact)
- relatedSdgs: ['2', '12', '13']
- Comment: "per meal; chicken ~6.9, pork ~7.6, eggs ~4.7,
  farmed fish ~5-8 kg CO2/kg (Poore 2018); ~150g
  serving"

#### vegan_day (keep as-is)
- No changes needed. Already well-scoped as a full day.
- co2Grams: 3000 (omnivore ~5.6 vs vegan ~2.9 kg/day)
- Good synergy: users can log skip_high_impact or
  skip_medium_impact for individual meals, OR vegan_day
  for a full commitment. These should not be logged
  together for the same day.

#### veganuary (new? or defer?)
**Decision:** DEFER to a future "challenges" feature.
- A month-long commitment doesn't fit the daily logging
  model well. When do you log it? Day 30?
- Better as a streak-based challenge: "Log vegan_day for
  30 consecutive days" with a bonus reward.
- Note for Phase 5+: implement challenge system with
  streak bonuses.

#### reduce_dairy -> REMOVE
- Absorbed into skip_medium_impact_food (dairy is listed)
- Also partially covered by plant_milk (specific dairy
  swap)

**Net change:** 5 actions (beef, chicken, pork, fish,
dairy) -> 2 actions (high_impact, medium_impact) +
vegan_day stays. Cleaner, less overlap.

### home_cooked_meal + bring_lunch + use_leftovers
**Decision:**
- REMOVE use_leftovers (absorbed into general food waste
  avoidance / no_food_waste action)
- Keep bring_lunch as-is (well-scoped: per day at work)
- Reframe home_cooked_meal -> skip_food_delivery

#### skip_food_delivery (replaces home_cooked_meal)
- Name: "Skip Food Delivery"
- Description: "Cook at home instead of ordering food
  delivery"
- co2Grams: 600 (up from 350)
  Breakdown:
  - Delivery vehicle: ~1-3km urban trip = ~250g
  - Disposable packaging (containers, bags, cutlery,
    napkins): ~200g
  - Restaurant food waste overhead: ~150g
- effort: 3 (time to cook and plan)
- frequency: 4 (near-daily temptation)
- impact: 2 (reduces delivery emissions + packaging)
- Comment: "per meal; delivery vehicle ~250g + packaging
  ~200g + restaurant waste ~150g vs home cooking"

The reframe matters: the original "cook at home" was
vague about WHY it was better. The real comparison is
specifically vs. delivery apps (Uber Eats, DoorDash),
where the delivery trip + excessive packaging is the
main environmental cost. Cooking at home vs. eating at
a restaurant in person is a much smaller difference.

---

## Summary of All Changes

### Actions to REMOVE (7):
- work_from_home (privilege, not behavioral change)
- drink_tap_water (overlap with reusable_water_bottle)
- local_produce (merged into buy_local_produce)
- farmers_market (merged into buy_local_produce)
- use_leftovers (absorbed by no_food_waste)
- reduce_dairy (absorbed by skip_medium_impact_food)
- digital_receipt (3g too small; not worth the action)

### Actions to MERGE (6 -> 2):
- refuse_straw + no_single_use_cutlery + use_cloth_napkin
  -> refuse_disposables
- local_produce + farmers_market -> buy_local_produce

### Actions to RENAME/REFRAME (10):
- led_bulb -> install_led_bulb (one-time install)
- fix_leak (updated CO2 to lifetime return)
- join_eco_group -> attend_eco_meeting (repeatable)
- collect_rainwater -> install_rain_collector (one-time)
- close_windows_ac -> use_fan_instead_of_ac
- share_domestic_work -> take_on_household_task
- electric_car_commute -> electric_car_purchase
- bar_soap -> plastic_free_hygiene (daily scope)
- home_cooked_meal -> skip_food_delivery
- meatless_meal_beef -> skip_high_impact_food
- meatless_meal_chicken/pork/fish -> skip_medium_impact

### Actions to ADD (2):
- used_car_purchase
- use_library (see below)

### NEW: use_library
- id: use_library
- Name: "Borrow From the Library"
- Description: "Borrow a book, audiobook, or media from
  your local library instead of buying new"
- co2Grams: 1000
  (avg book: ~1kg CO2 manufacturing + shipping;
  library copy serves ~20-50 borrowers over its life,
  so each borrow avoids ~1kg of new production)
- effort: 2 (visit library or use app)
- frequency: 3 (weekly or biweekly visits)
- impact: 3 (supports public infrastructure, reduces
  consumption, promotes knowledge access)
- category: community
- relatedSdgs: ['4', '12', '13']
- iconName: 'menu_book'
- Comment: "per visit/borrow; avg book ~1kg CO2 to
  produce; library copy shared by 20-50 readers"

### Actions with CO2 Updates Only (8):
- use_natural_light: 20 -> 90g (per-day reframe)
- turn_off_lights: 30 -> 60g (per-day reframe)
- unplug_devices: 40 -> 45g (per-day reframe)
- reusable_water_bottle: 80 -> 160g (per-day reframe)
- recycle_textiles: 14000 -> 40000g (per-bag reframe)
- recycle_ewaste: 5000 -> 2000g (per-phone reframe)
- donate_items: 500 -> 12000g (per-donation-run reframe)
- buy_bulk: 85 -> 200g (per-trip reframe)

### Actions with Scenario-Based Review (3):
- secondhand_clothing: 13000 -> 15000g
- repair_item: 5000 -> 7500g
- borrow_instead_buy: 2000 -> 8000g

### Transport Descriptions (5):
- walk_instead_drive: add "~1.5km" to description
- public_transport: add "~10km" to description
- carpool: add "~10km" to description
- take_bus: add "~7km" to description
- (electric_car_commute removed; see purchase reframe)

### EV vs Used Car Points Rebalancing

The raw CO2 values give used_car (6M) more points than
electric_car (1.7M), which feels backwards. EV purchase
has a systemic adoption multiplier -- the more people
buy EVs, the faster prices drop and infrastructure
builds for everyone. This network effect deserves
recognition.

The core issue: these measure different things.
- EV: ongoing operational savings (1.7M = first year)
- Used car: one-time manufacturing avoidance (6M total)

Also, used car CO2 of 6M assumes you would have bought
brand new otherwise, and that your purchase fully
prevents one new car from being made. In reality, market
elasticity means buying one used car prevents ~0.3-0.5
new cars at the margin.

**Revised used_car_purchase:**
- co2Grams: 3000000 (down from 6M; adjusted for ~50%
  demand elasticity -- buying used doesn't prevent a
  full new car from being made)
- Comment updated: "avoids ~3 tons manufacturing CO2;
  adjusted for demand elasticity (~50% of full 6-ton
  mid-size manufacturing footprint)"

**Revised electric_car_purchase:**
- co2Grams: 3400000 (up from 1.7M; 2-year projected
  savings better reflects the ongoing nature of the
  benefit vs the one-time used car avoidance)
- Comment updated: "2-year projected savings;
  15,000km/yr x (164-50)g/km x 2 = ~3.4 tons;
  DEFRA 2024 petrol vs avg grid EV"

**Revised points comparison:**
- electric_car_purchase: 3400000^0.4 * 1.45 * 1.2 *
  1.225 = ~410 * 2.13 = ~874 pts
- used_car_purchase: 3000000^0.4 * 1.15 * 1.2 *
  1.15 = ~390 * 1.587 = ~619 pts
- EV now appropriately higher (~40% more) reflecting
  the ongoing + systemic adoption value
- Both still large but these are once-in-a-decade
  purchases; daily habits accumulate far more over time

### Net Action Count Change:
- Current: 85 actions
- Removed: 7
- Merged: 6 -> 2 (net -4)
- Added: 2
- New total: 76 actions

### Resolved Questions:
1. plant_milk: KEEP separate from skip_medium_impact.
   Different lifestyle context (coffee shop / drinks vs
   meals). Both stay.
2. Library action: ADDED as use_library (see above).
3. digital_receipt: REMOVED. Too small at 3g to be
   worth a standalone action.
4. Veganuary: DEFERRED to Phase 5 challenge system.
   Added as a multi-day challenge template in
   PHASE_5_PLAN.md.
5. EV vs used car: REBALANCED. See analysis above.
   EV boosted to 2-year projection, used car adjusted
   for demand elasticity. EV now correctly scores
   higher.
