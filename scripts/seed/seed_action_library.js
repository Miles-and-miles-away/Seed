#!/usr/bin/env node

/**
 * Seeds the Firestore actionLibrary collection with
 * researched eco-actions.
 *
 * CO2 values based on peer-reviewed research and
 * government data.
 * See data/seed/co2_actions_database.json for sources.
 *
 * Usage:
 *   1. Set up Firebase Admin SDK credentials:
 *      - Go to Firebase Console > Project Settings
 *        > Service Accounts
 *      - Click "Generate New Private Key" and save as
 *        serviceAccountKey.json in the scripts folder
 *   2. Run: node scripts/seed/seed_action_library.js
 */

const admin = require('firebase-admin');
const path = require('path');
const longDescs =
  require('./action_long_descriptions.js');

const serviceAccountPath = path.join(
  __dirname,
  '..',
  'serviceAccountKey.json',
);

try {
  const serviceAccount = require(serviceAccountPath);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
} catch (error) {
  console.error(
    'Error: Could not find serviceAccountKey.json',
  );
  console.error(
    'Please download it from Firebase Console > '
    + 'Project Settings > Service Accounts',
  );
  console.error(
    `Expected location: ${serviceAccountPath}`,
  );
  process.exit(1);
}

const db = admin.firestore();

// ===========================================================
// Points formula
//
// CO2 actions:
//   points = max(1, round(
//     co2Grams^0.4 * effortMult * rarityMult * impactMult
//   ))
//
// Zero-CO2 actions (advocacy, community):
//   points = max(1, round(
//     effort * 3 * rarityMult * impactMult
//   ))
//
// Effort (1-5): How hard/inconvenient is the action?
//   1=trivial  2=easy  3=moderate  4=notable  5=major
//   mult = 0.7 + (effort * 0.15) -> 0.85x to 1.45x
//
// Frequency (1-5): How often can you do this?
//   1=rare  2=monthly  3=weekly  4=frequent  5=daily
//   Inverted to reward rarity:
//   mult = 1.3 - (frequency * 0.1) -> 1.2x to 0.8x
//
// Impact (1-5): Broader long-term environmental ripple
//   1=immediate-only  2=short-term  3=medium-term
//   4=long-lasting  5=systemic/generational
//   mult = 0.85 + (impact * 0.075) -> 0.925x to 1.225x
// ===========================================================
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
    RARITY_BASE - (action.frequency * RARITY_SCALE);
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

// ===========================================================
// Action library seed data
// CO2 values sourced from DEFRA 2024, EPA,
// Poore & Nemecek (2018), Our World in Data, and other
// tier-1 sources.
// Per-action values derived from per-unit research data
// with practical usage assumptions noted in descriptions.
// ===========================================================
const actions = [
  // ---------------------------------------------------------
  // RECYCLING (10 actions)
  // ---------------------------------------------------------
  {
    id: 'recycle_aluminum_can',
    nameEn: 'Recycle Aluminum Can',
    nameJa: 'アルミ缶をリサイクル',
    nameEs: 'Reciclar lata de aluminio',
    descriptionEn:
      'Recycle an aluminum can instead of '
      + 'throwing it away',
    descriptionJa:
      'アルミ缶をゴミ箱に捨てずにリサイクル',
    descriptionEs:
      'Reciclar una lata de aluminio en vez '
      + 'de tirarla a la basura',
    category: 'recycling',
    co2Grams: 100, // ~99g/can (Aluminum Assoc LCA)
    effort: 1, // trivial: toss in bin
    frequency: 5, // daily: common beverage
    impact: 2, // mature closed-loop stream
    iconName: 'recycling',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 1,
  },
  {
    id: 'recycle_plastic_bottle',
    nameEn: 'Recycle Plastic Bottle',
    nameJa: 'ペットボトルをリサイクル',
    nameEs: 'Reciclar botella de plastico',
    descriptionEn:
      'Recycle a PET plastic bottle properly',
    descriptionJa:
      'ペットボトルを正しくリサイクル',
    descriptionEs:
      'Reciclar correctamente una botella '
      + 'de plastico PET',
    category: 'recycling',
    co2Grams: 50, // ~35-50g PET bottle (rPET LCA)
    effort: 1, // trivial: toss in bin
    frequency: 5, // daily: common beverage
    impact: 2, // low recycle rate, downcycling
    iconName: 'recycling',
    relatedSdgs: ['12', '13', '14'],
    isActive: true,
    sortOrder: 2,
  },
  {
    id: 'recycle_cardboard',
    nameEn: 'Recycle Cardboard',
    nameJa: '段ボールをリサイクル',
    nameEs: 'Reciclar carton',
    descriptionEn:
      'Flatten and recycle cardboard boxes',
    descriptionJa:
      '段ボール箱を潰してリサイクル',
    descriptionEs:
      'Aplanar y reciclar cajas de carton',
    category: 'recycling',
    co2Grams: 500, // typical ~230g box; EPA WARM 2160g/kg = ~500g
    effort: 1, // flatten and recycle
    frequency: 4, // frequent: deliveries
    impact: 2, // mature recycling stream
    iconName: 'inventory_2',
    relatedSdgs: ['12', '15'],
    isActive: true,
    sortOrder: 3,
  },
  {
    id: 'composting',
    nameEn: 'Compost Food Scraps',
    nameJa: '生ゴミをコンポスト',
    nameEs: 'Compostar restos de comida',
    descriptionEn:
      'Compost food scraps instead of '
      + 'sending to landfill',
    descriptionJa:
      '生ゴミをゴミ箱ではなくコンポストへ',
    descriptionEs:
      'Compostar restos de comida en vez '
      + 'de enviarlos al vertedero',
    category: 'recycling',
    co2Grams: 200, // daily scraps; avoids landfill CH4
    effort: 2, // collect scraps, maintain bin
    frequency: 5, // daily kitchen waste
    impact: 3, // avoids methane, builds soil
    iconName: 'compost',
    relatedSdgs: ['12', '13', '15'],
    isActive: true,
    sortOrder: 4,
  },
  {
    id: 'recycle_glass',
    nameEn: 'Recycle Glass',
    nameJa: 'ガラス瓶をリサイクル',
    nameEs: 'Reciclar vidrio',
    descriptionEn:
      'Recycle glass jars and bottles '
      + 'instead of trashing',
    descriptionJa:
      'ガラス瓶をゴミ箱ではなくリサイクルへ',
    descriptionEs:
      'Reciclar frascos y botellas de vidrio '
      + 'en vez de tirarlos',
    category: 'recycling',
    co2Grams: 167, // avg 250g jar; EPA WARM 667g/kg (~300g per 450g bottle) = ~167g
    effort: 1, // trivial: sort into bin
    frequency: 4, // regular but not daily
    impact: 2, // mature recycling stream
    iconName: 'recycling',
    relatedSdgs: ['12'],
    isActive: true,
    sortOrder: 5,
  },
  {
    id: 'recycle_paper',
    nameEn: 'Recycle Paper',
    nameJa: '紙をリサイクル',
    nameEs: 'Reciclar papel',
    descriptionEn:
      'Recycle paper instead of throwing '
      + 'it in the trash',
    descriptionJa:
      '紙をゴミ箱ではなくリサイクルへ',
    descriptionEs:
      'Reciclar papel en vez de tirarlo '
      + 'a la basura',
    category: 'recycling',
    co2Grams: 50, // ~100g paper; 0.5kg CO2/kg saved
    effort: 1, // trivial: toss in bin
    frequency: 5, // daily: mail and paper
    impact: 2, // mature recycling stream
    iconName: 'recycling',
    relatedSdgs: ['12', '15'],
    isActive: true,
    sortOrder: 6,
  },
  {
    id: 'recycle_ewaste',
    nameEn: 'Recycle E-Waste',
    nameJa: '電子機器をリサイクル',
    nameEs: 'Reciclar residuos electronicos',
    descriptionEn:
      'Take old electronics to an e-waste '
      + 'recycling center',
    descriptionJa:
      '古い電子機器をリサイクルセンターへ持参',
    descriptionEs:
      'Llevar electronica vieja a un centro '
      + 'de reciclaje',
    category: 'recycling',
    co2Grams: 2000, // per-phone: one device
    effort: 3, // collect, transport to center
    frequency: 1, // rare: few times per year
    impact: 4, // prevents toxic contamination
    iconName: 'smartphone',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 7,
  },
  {
    id: 'recycle_textiles',
    nameEn: 'Recycle Textiles',
    nameJa: '衣類をリサイクル',
    nameEs: 'Reciclar textiles',
    descriptionEn:
      'Donate or recycle old clothing '
      + 'and textiles',
    descriptionJa:
      '古い衣類を寄付またはリサイクル',
    descriptionEs:
      'Donar o reciclar ropa y textiles '
      + 'viejos',
    category: 'recycling',
    co2Grams: 40000, // per-bag: ~3kg x 13kg/kg
    effort: 2, // sort, bag, donate/drop off
    frequency: 2, // seasonal decluttering
    impact: 3, // high-impact industry
    iconName: 'dry_cleaning',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 8,
  },
  {
    id: 'recycle_batteries',
    nameEn: 'Recycle Batteries',
    nameJa: '電池をリサイクル',
    nameEs: 'Reciclar pilas',
    descriptionEn:
      'Take used batteries to a proper '
      + 'recycling drop-off',
    descriptionJa:
      '使用済み電池をリサイクル回収場所へ',
    descriptionEs:
      'Llevar pilas usadas a un punto de '
      + 'reciclaje adecuado',
    category: 'recycling',
    co2Grams: 95, // batch ~4 AA; 1-2kg CO2/kg
    effort: 2, // collect, find drop-off
    frequency: 2, // accumulate over months
    impact: 2, // modest CO2; toxicity benefit
    iconName: 'electric_bolt',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 9,
  },
  {
    id: 'recycle_cooking_oil',
    nameEn: 'Recycle Cooking Oil',
    nameJa: '廃油をリサイクル',
    nameEs: 'Reciclar aceite de cocina',
    descriptionEn:
      'Take used cooking oil to a recycling '
      + 'collection point',
    descriptionJa:
      '使用済み食用油をリサイクル回収場所へ',
    descriptionEs:
      'Llevar aceite usado a un punto de '
      + 'recogida para reciclaje',
    category: 'recycling',
    co2Grams: 1500, // per ~0.6L drop-off; waste-oil biodiesel saves ~2,460g/L vs fossil diesel (EPA 86% lifecycle reduction)
    effort: 2, // store, transport to collection
    frequency: 2, // accumulates slowly
    impact: 3, // water pollution + biodiesel
    iconName: 'kitchen',
    relatedSdgs: ['6', '12', '14'],
    isActive: true,
    sortOrder: 10,
  },

  // ---------------------------------------------------------
  // TRANSPORT (11 actions)
  // Research: DEFRA 2024 petrol car avg 164g CO2/km
  // ---------------------------------------------------------
  {
    id: 'walk_instead_drive',
    nameEn: 'Walk Instead of Drive',
    nameJa: '車の代わりに徒歩',
    nameEs: 'Caminar en vez de conducir',
    descriptionEn:
      'Walk to your destination (~1.5 km) '
      + 'instead of driving',
    descriptionJa:
      '車を使わずに目的地まで歩く',
    descriptionEs:
      'Caminar hasta tu destino en vez '
      + 'de conducir',
    category: 'transport',
    co2Grams: 250, // 1.5km x 164g/km (DEFRA 2024)
    effort: 2, // takes more time than driving
    frequency: 4, // many short trips walkable
    impact: 2, // individual behavior change
    iconName: 'directions_walk',
    relatedSdgs: ['3', '11', '13'],
    isActive: true,
    sortOrder: 1,
  },
  {
    id: 'bike_short_trip',
    nameEn: 'Short Bike Trip',
    nameJa: '近距離を自転車で移動',
    nameEs: 'Bicicleta para viaje corto',
    descriptionEn:
      'Bike instead of drive for a short '
      + 'trip (under 3km)',
    descriptionJa:
      '短距離（3km未満）の移動に車の代わりに'
      + '自転車を使用',
    descriptionEs:
      'Usar bicicleta en vez de auto para '
      + 'un viaje corto (menos de 3km)',
    category: 'transport',
    co2Grams: 490, // 3km x 164g/km (DEFRA 2024)
    effort: 2, // easy for most people
    frequency: 4, // many short trips bikeable
    impact: 2, // individual behavior change
    iconName: 'pedal_bike',
    relatedSdgs: ['3', '11', '13'],
    isActive: true,
    sortOrder: 2,
  },
  {
    id: 'bike_medium_trip',
    nameEn: 'Medium Bike Trip',
    nameJa: '中距離を自転車で移動',
    nameEs: 'Bicicleta para viaje medio',
    descriptionEn:
      'Bike instead of drive for a medium '
      + 'trip (3-10km)',
    descriptionJa:
      '中距離（3-10km）の移動に車の代わりに'
      + '自転車を使用',
    descriptionEs:
      'Usar bicicleta en vez de auto para '
      + 'un viaje medio (3-10km)',
    category: 'transport',
    co2Grams: 1000, // ~6km x 164g/km (DEFRA 2024)
    effort: 3, // moderate effort and time
    frequency: 3, // weekly: less than short trips
    impact: 2, // individual behavior change
    iconName: 'pedal_bike',
    relatedSdgs: ['3', '11', '13'],
    isActive: true,
    sortOrder: 3,
  },
  {
    id: 'public_transport',
    nameEn: 'Take Public Transport',
    nameJa: '公共交通機関を利用',
    nameEs: 'Usar transporte publico',
    descriptionEn:
      'Take bus or train instead of driving '
      + '(~10 km trip)',
    descriptionJa:
      '車の代わりにバスや電車を利用',
    descriptionEs:
      'Tomar autobus o tren en vez de '
      + 'conducir',
    category: 'transport',
    co2Grams: 1000, // 10km; car-bus net ~1040g saved
    effort: 2, // minimal: wait, walk to stop
    frequency: 4, // daily commuters
    impact: 3, // supports transit infrastructure
    iconName: 'train',
    relatedSdgs: ['9', '11', '13'],
    isActive: true,
    sortOrder: 4,
  },
  {
    id: 'carpool',
    nameEn: 'Carpool',
    nameJa: '相乗りで移動',
    nameEs: 'Compartir auto',
    descriptionEn:
      'Share a ride instead of driving '
      + 'alone (~10 km trip)',
    descriptionJa:
      '一人で運転する代わりに相乗りする',
    descriptionEs:
      'Compartir viaje en vez de conducir '
      + 'solo',
    category: 'transport',
    co2Grams: 800, // ~10km; halve per-person emissions
    effort: 2, // coordinate with one person
    frequency: 4, // regular commuters
    impact: 2, // individual behavior change
    iconName: 'people',
    relatedSdgs: ['11', '13'],
    isActive: true,
    sortOrder: 5,
  },
  {
    id: 'electric_car_purchase',
    nameEn: 'Purchase Electric Vehicle',
    nameJa: '電気自動車を購入',
    nameEs: 'Comprar vehiculo electrico',
    descriptionEn:
      'Purchase an electric vehicle '
      + 'instead of a gasoline car',
    descriptionJa:
      'ガソリン車の代わりに電気自動車を'
      + '購入する',
    descriptionEs:
      'Comprar un vehiculo electrico en '
      + 'vez de uno de gasolina',
    category: 'transport',
    co2Grams: 3400000, // one-time milestone
    effort: 5,
    frequency: 1,
    impact: 4,
    iconName: 'electric_car',
    relatedSdgs: ['7', '11', '13'],
    isActive: true,
    sortOrder: 6,
  },
  {
    id: 'train_vs_flight',
    nameEn: 'Train Instead of Flight',
    nameJa: '飛行機の代わりに電車',
    nameEs: 'Tren en vez de avion',
    descriptionEn:
      'Take a train instead of a '
      + 'short-haul flight',
    descriptionJa:
      '短距離フライトの代わりに電車を利用',
    descriptionEs:
      'Tomar un tren en vez de un vuelo '
      + 'de corta distancia',
    category: 'transport',
    co2Grams: 110000, // 500km; ~200g/km flight vs 40g rail
    effort: 3, // longer travel, advance booking
    frequency: 1, // rare: few times per year
    impact: 4, // shifts demand from aviation
    iconName: 'train',
    relatedSdgs: ['13'],
    isActive: true,
    sortOrder: 7,
  },
  {
    id: 'take_bus',
    nameEn: 'Take the Bus',
    nameJa: 'バスを利用',
    nameEs: 'Tomar el autobus',
    descriptionEn:
      'Take a bus instead of driving '
      + '(~7 km trip)',
    descriptionJa:
      '通勤に車の代わりにバスを利用',
    descriptionEs:
      'Tomar el autobus en vez de conducir '
      + 'para ir al trabajo',
    category: 'transport',
    co2Grams: 500, // ~7km; bus 89g/pkm vs car 164g/km
    effort: 2, // minimal: wait, ride
    frequency: 4, // daily commuters
    impact: 2, // individual behavior change
    iconName: 'bus',
    relatedSdgs: ['9', '11', '13'],
    isActive: true,
    sortOrder: 8,
  },
  {
    id: 'escooter_trip',
    nameEn: 'E-Scooter Instead of Driving',
    nameJa: '電動キックボードで移動',
    nameEs: 'Patinete electrico en vez de auto',
    descriptionEn:
      'Use an e-scooter instead of driving '
      + 'for a short trip',
    descriptionJa:
      '短距離移動に車の代わりに電動キックボード'
      + 'を使用',
    descriptionEs:
      'Usar un patinete electrico en vez de '
      + 'conducir para un viaje corto',
    category: 'transport',
    co2Grams: 375, // ~2.5km; car-scooter net ~322g
    effort: 2, // easy for short distances
    frequency: 4, // daily: short urban trips
    impact: 2, // individual behavior change
    iconName: 'electric_bolt',
    relatedSdgs: ['11', '13'],
    isActive: true,
    sortOrder: 9,
  },
  {
    id: 'ev_charging_green',
    nameEn: 'Charge EV with Green Energy',
    nameJa: 'グリーン電力でEV充電',
    nameEs: 'Cargar auto electrico con '
      + 'energia verde',
    descriptionEn:
      'Charge your EV using renewable '
      + 'energy sources',
    descriptionJa:
      '再生可能エネルギーで電気自動車を充電',
    descriptionEs:
      'Cargar tu auto electrico con fuentes '
      + 'de energia renovable',
    category: 'transport',
    co2Grams: 3500, // ~10kWh charge; grid ~386g/kWh
    effort: 2, // green tariff or home solar
    frequency: 3, // weekly: few charges per week
    impact: 3, // drives renewable deployment
    iconName: 'ev_station',
    relatedSdgs: ['7', '11', '13'],
    isActive: true,
    sortOrder: 10,
  },
  {
    id: 'combine_errands',
    nameEn: 'Combine Errands',
    nameJa: '用事をまとめる',
    nameEs: 'Combinar diligencias',
    descriptionEn:
      'Combine multiple errands into one '
      + 'trip to reduce driving',
    descriptionJa:
      '複数の用事を1回の外出にまとめて車の'
      + '使用を減らす',
    descriptionEs:
      'Combinar varias diligencias en un '
      + 'solo viaje para conducir menos',
    category: 'transport',
    co2Grams: 600, // save ~4km + cold-start penalty
    effort: 2, // requires some planning
    frequency: 3, // weekly errands
    impact: 2, // individual behavior change
    iconName: 'local_shipping',
    relatedSdgs: ['11', '13'],
    isActive: true,
    sortOrder: 11,
  },

  // ---------------------------------------------------------
  // FOOD (10 actions)
  // Research: Poore & Nemecek 2018, Our World in Data, EPA
  // ---------------------------------------------------------
  {
    id: 'skip_high_impact_food',
    nameEn: 'Skip High-Impact Meal',
    nameJa: '高インパクトの食事をスキップ',
    nameEs: 'Evitar comida de alto impacto',
    descriptionEn:
      'Choose a plant-based meal instead '
      + 'of beef or lamb today',
    descriptionJa:
      '今日は牛肉やラム肉の代わりに'
      + '植物性の食事を選択する',
    descriptionEs:
      'Elegir una comida vegetal en vez '
      + 'de carne de res o cordero hoy',
    category: 'food',
    // Beef case, matches meatless_meal_beef in
    // co2_actions_database v1.2 (P&N 2018 mean incl. LUC:
    // 9948g/100g serving - 200g standardized beans baseline,
    // rounded down). Lamb case implies ~3.8kg.
    co2Grams: 9700,
    effort: 2,
    frequency: 3,
    impact: 4,
    iconName: 'eco',
    relatedSdgs: ['2', '12', '13', '15'],
    isActive: true,
    sortOrder: 1,
  },
  {
    id: 'skip_medium_impact_food',
    nameEn: 'Skip Medium-Impact Meal',
    nameJa: '中程度インパクトの食事をスキップ',
    nameEs: 'Evitar comida de impacto medio',
    descriptionEn:
      'Choose a plant-based meal instead '
      + 'of chicken, pork, or fish today',
    descriptionJa:
      '今日は鶏肉、豚肉、魚の代わりに'
      + '植物性の食事を選択する',
    descriptionEs:
      'Elegir una comida vegetal en vez '
      + 'de pollo, cerdo o pescado hoy',
    category: 'food',
    // Chicken (780) to pork (1000) band of co2_actions_database
    // v1.2 (P&N 2018 means, standardized 200g beans baseline);
    // matches the pork case, farmed fish implies ~1.2kg. NOTE:
    // wild fish (~750g) and small oily fish (~350g) now sit
    // below 1000 -- whether "fish" here should split or lower
    // is an owner points-economy call, not yet made.
    co2Grams: 1000,
    effort: 2,
    frequency: 3,
    impact: 2,
    iconName: 'eco',
    relatedSdgs: ['2', '12', '13', '14'],
    isActive: true,
    sortOrder: 2,
  },
  {
    id: 'no_food_waste',
    nameEn: 'Zero Food Waste',
    nameJa: '食品ロスゼロ',
    nameEs: 'Cero desperdicio de comida',
    descriptionEn:
      'Finish all food today with no waste',
    descriptionJa:
      '今日は食べ残しゼロを達成',
    descriptionEs:
      'Terminar toda la comida hoy sin '
      + 'desperdiciar nada',
    category: 'food',
    co2Grams: 500, // avoidable daily waste ~150g x 3/kg
    effort: 2, // requires meal planning
    frequency: 5, // daily goal
    impact: 3, // avoids methane, upstream waste
    iconName: 'food_bank',
    relatedSdgs: ['2', '12', '13'],
    isActive: true,
    sortOrder: 3,
  },
  {
    id: 'plant_milk',
    nameEn: 'Choose Plant Milk',
    nameJa: '植物性ミルクを選択',
    nameEs: 'Elegir leche vegetal',
    descriptionEn:
      'Choose plant-based milk instead '
      + 'of dairy',
    descriptionJa:
      '乳製品の代わりに植物性ミルクを選択',
    descriptionEs:
      'Elegir leche vegetal en vez de '
      + 'leche de vaca',
    category: 'food',
    // Matches plant_milk_vs_dairy in co2_actions_database
    // v1.1: 250ml, dairy 3.15 vs oat 0.903 kg/L implies 562g;
    // 460 stays conservative (soy case implies 543g).
    co2Grams: 460,
    effort: 2, // widely available alternative
    frequency: 5, // daily: coffee, cereal
    impact: 3, // dairy: methane, land, water
    iconName: 'local_cafe',
    relatedSdgs: ['12', '13', '15'],
    isActive: true,
    sortOrder: 4,
  },
  {
    id: 'seasonal_produce',
    nameEn: 'Buy Seasonal Produce',
    nameJa: '旬の農産物を購入',
    nameEs: 'Comprar productos de temporada',
    descriptionEn:
      'Buy fruits and vegetables that are '
      + 'in season locally',
    descriptionJa:
      '地元で旬の野菜や果物を購入',
    descriptionEs:
      'Comprar frutas y verduras de '
      + 'temporada local',
    category: 'food',
    co2Grams: 500, // avoids heated greenhouse produce
    effort: 2, // know what is in season
    frequency: 3, // weekly grocery trips
    impact: 3, // reduces energy-intensive growing
    iconName: 'grass',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 5,
  },
  {
    id: 'skip_food_delivery',
    nameEn: 'Skip Food Delivery',
    nameJa: 'フードデリバリーをスキップ',
    nameEs: 'Evitar delivery de comida',
    descriptionEn:
      'Cook at home instead of ordering '
      + 'food delivery today',
    descriptionJa:
      '今日はフードデリバリーの代わりに'
      + '自炊する',
    descriptionEs:
      'Cocinar en casa en vez de pedir '
      + 'delivery de comida hoy',
    category: 'food',
    co2Grams: 600,
    effort: 3,
    frequency: 4,
    impact: 2,
    iconName: 'kitchen',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 6,
  },
  {
    id: 'vegan_day',
    nameEn: 'Full Vegan Day',
    nameJa: '完全菜食の一日',
    nameEs: 'Dia completamente vegano',
    descriptionEn:
      'Eat only plant-based foods for '
      + 'an entire day',
    descriptionJa:
      '一日中植物性食品だけを食べる',
    descriptionEs:
      'Comer solo alimentos vegetales '
      + 'durante todo el dia',
    category: 'food',
    co2Grams: 3000, // omnivore ~5.6 vs vegan ~2.9kg/day
    effort: 3, // plan all-plant meals for a day
    frequency: 3, // weekly: e.g. Meatless Monday
    impact: 4, // systemic food system impact
    iconName: 'restaurant',
    relatedSdgs: ['2', '12', '13', '15'],
    isActive: true,
    sortOrder: 7,
  },
  {
    id: 'bring_lunch',
    nameEn: 'Bring Lunch to Work',
    nameJa: 'お弁当を持参',
    nameEs: 'Llevar almuerzo al trabajo',
    descriptionEn:
      'Bring a homemade lunch instead of '
      + 'buying packaged food',
    descriptionJa:
      '市販の弁当の代わりに手作り弁当を持参',
    descriptionEs:
      'Llevar almuerzo casero en vez de '
      + 'comprar comida empaquetada',
    category: 'food',
    co2Grams: 300, // saves packaging + transport CO2
    effort: 2, // prep lunch in advance
    frequency: 4, // most work days
    impact: 2, // modest: less packaging
    iconName: 'takeout',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 8,
  },

  // ---------------------------------------------------------
  // ENERGY (12 actions)
  // Research: DEFRA, US DOE, Energy Saving Trust
  // ---------------------------------------------------------
  {
    id: 'air_dry_clothes',
    nameEn: 'Air Dry Clothes',
    nameJa: '洗濯物を自然乾燥',
    nameEs: 'Secar ropa al aire',
    descriptionEn:
      'Air dry clothes instead of using '
      + 'a tumble dryer',
    descriptionJa:
      '乾燥機を使わずに洗濯物を自然乾燥',
    descriptionEs:
      'Secar la ropa al aire en vez de '
      + 'usar la secadora',
    category: 'energy',
    co2Grams: 1700, // 4.5kWh dryer x 386g/kWh (US)
    effort: 2, // hang clothes, takes more time
    frequency: 3, // few loads per week
    impact: 2, // individual behavior change
    iconName: 'dry_cleaning',
    relatedSdgs: ['7', '12', '13'],
    isActive: true,
    sortOrder: 1,
  },
  {
    id: 'cold_wash',
    nameEn: 'Cold Water Laundry',
    nameJa: '冷水で洗濯',
    nameEs: 'Lavar ropa con agua fria',
    descriptionEn:
      'Wash clothes in cold water instead '
      + 'of hot',
    descriptionJa:
      'お湯ではなく冷水で洗濯',
    descriptionEs:
      'Lavar la ropa con agua fria en vez '
      + 'de caliente',
    category: 'energy',
    co2Grams: 600, // warm-to-cold saves ~1.5kWh/load
    effort: 1, // trivial: turn dial
    frequency: 3, // few loads per week
    impact: 2, // individual behavior change
    iconName: 'local_laundry_service',
    relatedSdgs: ['6', '7', '12', '13'],
    isActive: true,
    sortOrder: 2,
  },
  {
    id: 'install_led_bulb',
    nameEn: 'Install LED Bulb',
    nameJa: 'LED電球を設置',
    nameEs: 'Instalar bombilla LED',
    descriptionEn:
      'Replace an incandescent or halogen '
      + 'bulb with an LED',
    descriptionJa:
      '白熱電球やハロゲン電球をLEDに交換',
    descriptionEs:
      'Reemplazar una bombilla '
      + 'incandescente o halogena por LED',
    category: 'energy',
    co2Grams: 28000, // first-year savings
    effort: 1,
    frequency: 1,
    impact: 3,
    iconName: 'lightbulb',
    relatedSdgs: ['7', '12', '13'],
    isActive: true,
    sortOrder: 3,
  },
  {
    id: 'unplug_devices',
    nameEn: 'Unplug Unused Devices',
    nameJa: '未使用機器のプラグを抜く',
    nameEs: 'Desenchufar dispositivos sin uso',
    descriptionEn:
      'Unplug electronic devices when not '
      + 'in use',
    descriptionJa:
      '使用していない電子機器のコンセントを抜く',
    descriptionEs:
      'Desenchufar dispositivos electronicos '
      + 'cuando no se usen',
    category: 'energy',
    co2Grams: 45, // per-day: avg standby draw
    effort: 1, // trivial: pull plug
    frequency: 5, // daily habit
    impact: 1, // immediate, small scale
    iconName: 'power',
    relatedSdgs: ['7', '12', '13'],
    isActive: true,
    sortOrder: 4,
  },
  {
    id: 'turn_off_lights',
    nameEn: 'Turn Off Lights',
    nameJa: '電気を消す',
    nameEs: 'Apagar las luces',
    descriptionEn:
      'Turn off lights when leaving a room',
    descriptionJa:
      '部屋を出る時に電気を消す',
    descriptionEs:
      'Apagar las luces al salir de '
      + 'una habitacion',
    category: 'energy',
    co2Grams: 60, // per-day: ~4hrs x 40W x 386g/kWh
    effort: 1, // trivial: flip switch
    frequency: 5, // multiple times daily
    impact: 1, // immediate, small scale
    iconName: 'lightbulb',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 5,
  },
  {
    id: 'lower_thermostat',
    nameEn: 'Lower Thermostat 1 Degree',
    nameJa: '暖房を1度下げる',
    nameEs: 'Bajar el termostato 1 grado',
    descriptionEn:
      'Lower your heating thermostat by '
      + '1 degree today',
    descriptionJa:
      '今日は暖房の設定温度を1度下げる',
    descriptionEs:
      'Bajar el termostato de calefaccion '
      + '1 grado hoy',
    category: 'energy',
    co2Grams: 450, // US DOE: 3% savings per degree
    effort: 2, // slight comfort trade-off
    frequency: 4, // most heating season days
    impact: 2, // individual behavior change
    iconName: 'thermostat',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 6,
  },
  {
    id: 'raise_ac_thermostat',
    nameEn: 'Raise AC 1 Degree',
    nameJa: '冷房を1度上げる',
    nameEs: 'Subir el aire acondicionado '
      + '1 grado',
    descriptionEn:
      'Raise your AC thermostat by 1 degree '
      + 'today',
    descriptionJa:
      '今日は冷房の設定温度を1度上げる',
    descriptionEs:
      'Subir la temperatura del aire '
      + 'acondicionado 1 grado hoy',
    category: 'energy',
    co2Grams: 350, // US DOE: 3%/degree (cooling)
    effort: 2, // slight comfort trade-off
    frequency: 4, // most cooling season days
    impact: 2, // individual behavior change
    iconName: 'thermostat',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 7,
  },
  {
    id: 'use_natural_light',
    nameEn: 'Use Natural Light',
    nameJa: '自然光を活用',
    nameEs: 'Usar luz natural',
    descriptionEn:
      'Open curtains and use natural light '
      + 'instead of electric',
    descriptionJa:
      'カーテンを開けて電気の代わりに自然光を'
      + '活用',
    descriptionEs:
      'Abrir cortinas y usar luz natural '
      + 'en vez de electrica',
    category: 'energy',
    co2Grams: 90, // per-day: ~6hrs x 40W x 386g/kWh
    effort: 1, // trivial: open curtains
    frequency: 5, // daily during daylight
    impact: 1, // immediate, small scale
    iconName: 'wb_sunny',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 8,
  },
  {
    id: 'full_laundry_load',
    nameEn: 'Run Full Laundry Load',
    nameJa: '洗濯機を満杯で回す',
    nameEs: 'Lavar con carga completa',
    descriptionEn:
      'Wait until you have a full load '
      + 'before running laundry',
    descriptionJa:
      '洗濯物が満杯になってから洗濯機を回す',
    descriptionEs:
      'Esperar hasta tener carga completa '
      + 'antes de lavar',
    category: 'energy',
    co2Grams: 300, // avoids ~35% wasted energy/load
    effort: 1, // wait for enough clothes
    frequency: 3, // few loads per week
    impact: 2, // individual behavior change
    iconName: 'local_laundry_service',
    relatedSdgs: ['6', '7', '12'],
    isActive: true,
    sortOrder: 9,
  },
  {
    id: 'eco_mode_appliance',
    nameEn: 'Use Eco Mode',
    nameJa: 'エコモードを使用',
    nameEs: 'Usar modo ecologico',
    descriptionEn:
      'Use eco mode on dishwasher or '
      + 'washing machine',
    descriptionJa:
      '食洗機や洗濯機のエコモードを使用',
    descriptionEs:
      'Usar modo ecologico en el '
      + 'lavavajillas o lavadora',
    category: 'energy',
    co2Grams: 200, // saves ~0.5kWh/cycle (Bosch/Miele)
    effort: 1, // trivial: press different button
    frequency: 3, // few cycles per week
    impact: 2, // individual behavior change
    iconName: 'dishwasher',
    relatedSdgs: ['7', '12', '13'],
    isActive: true,
    sortOrder: 10,
  },
  {
    id: 'microwave_vs_oven',
    nameEn: 'Microwave Instead of Oven',
    nameJa: 'オーブンの代わりに電子レンジ',
    nameEs: 'Microondas en vez de horno',
    descriptionEn:
      'Use a microwave instead of a '
      + 'full-size oven to reheat food',
    descriptionJa:
      '温め直しにオーブンの代わりに電子レンジを'
      + '使用',
    descriptionEs:
      'Usar el microondas en vez del horno '
      + 'para recalentar comida',
    category: 'energy',
    co2Grams: 300, // oven ~1kWh vs microwave ~0.1kWh
    effort: 1, // trivial: choose appliance
    frequency: 4, // near-daily reheating
    impact: 1, // immediate, small scale
    iconName: 'microwave',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 11,
  },
  {
    id: 'use_fan_instead_of_ac',
    nameEn: 'Use Fan Instead of AC',
    nameJa: 'エアコンの代わりに扇風機を使用',
    nameEs: 'Usar ventilador en vez de aire '
      + 'acondicionado',
    descriptionEn:
      'Use a fan instead of air '
      + 'conditioning today',
    descriptionJa:
      '今日はエアコンの代わりに扇風機を'
      + '使用する',
    descriptionEs:
      'Usar un ventilador en vez del aire '
      + 'acondicionado hoy',
    category: 'energy',
    co2Grams: 1200,
    effort: 2,
    frequency: 4,
    impact: 2,
    iconName: 'air',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 12,
  },

  // ---------------------------------------------------------
  // CONSUMPTION (14 actions)
  // Research: Danish EPA LCA, WRAP UK, Carbon Trust
  // ---------------------------------------------------------
  {
    id: 'reusable_bag',
    nameEn: 'Use Reusable Bag',
    nameJa: 'エコバッグを使用',
    nameEs: 'Usar bolsa reutilizable',
    descriptionEn:
      'Use a reusable shopping bag instead '
      + 'of plastic',
    descriptionJa:
      'レジ袋の代わりにエコバッグを使用',
    descriptionEs:
      'Usar una bolsa reutilizable en vez '
      + 'de plastica',
    category: 'consumption',
    co2Grams: 10, // one plastic bag ~10g CO2
    effort: 1, // trivial: remember to bring
    frequency: 4, // each shopping trip
    impact: 2, // reduces plastic pollution
    iconName: 'shopping_bag',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 1,
  },
  {
    id: 'reusable_cup',
    nameEn: 'Use Reusable Cup',
    nameJa: 'マイカップを使用',
    nameEs: 'Usar vaso reutilizable',
    descriptionEn:
      'Bring your own reusable cup for '
      + 'drinks',
    descriptionJa:
      '飲み物にマイカップを持参',
    descriptionEs:
      'Llevar tu propio vaso reutilizable '
      + 'para bebidas',
    category: 'consumption',
    co2Grams: 60, // disposable cup ~60g CO2
    effort: 2, // remember and carry cup
    frequency: 5, // daily coffee/drinks
    impact: 2, // reduces disposable waste
    iconName: 'coffee',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 2,
  },
  {
    id: 'reusable_water_bottle',
    nameEn: 'Use Reusable Water Bottle',
    nameJa: 'マイボトルを使用',
    nameEs: 'Botella de agua reutilizable',
    descriptionEn:
      'Use a reusable bottle instead of '
      + 'single-use plastic',
    descriptionJa:
      '使い捨てペットボトルの代わりにマイボトル'
      + 'を使用',
    descriptionEs:
      'Usar una botella reutilizable en vez '
      + 'de plastico desechable',
    category: 'consumption',
    co2Grams: 160, // per-day: ~2 bottles avoided
    effort: 1, // trivial: carry bottle
    frequency: 5, // daily hydration
    impact: 3, // long-term plastic reduction
    iconName: 'water_drop',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 3,
  },
  {
    id: 'bring_own_container',
    nameEn: 'Bring Own Container',
    nameJa: 'マイ容器を持参',
    nameEs: 'Llevar tu propio recipiente',
    descriptionEn:
      'Use your own container for takeout '
      + 'food',
    descriptionJa:
      'テイクアウト用にマイ容器を持参',
    descriptionEs:
      'Usar tu propio recipiente para '
      + 'comida para llevar',
    category: 'consumption',
    co2Grams: 100, // takeout container ~100g CO2
    effort: 2, // remember and carry container
    frequency: 3, // weekly takeout orders
    impact: 2, // reduces disposable waste
    iconName: 'takeout',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 4,
  },
  {
    id: 'refuse_disposables',
    nameEn: 'Refuse Disposables',
    nameJa: '使い捨てを断る',
    nameEs: 'Rechazar desechables',
    descriptionEn:
      'Refuse disposable straws, cutlery, '
      + 'napkins, or other single-use items '
      + 'today',
    descriptionJa:
      '今日はストロー、カトラリー、ナプキン'
      + 'などの使い捨て品を断る',
    descriptionEs:
      'Rechazar pajitas, cubiertos, '
      + 'servilletas u otros articulos '
      + 'desechables hoy',
    category: 'consumption',
    co2Grams: 15,
    effort: 1,
    frequency: 5,
    impact: 2,
    iconName: 'no_drinks',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 5,
  },
  {
    id: 'secondhand_clothing',
    nameEn: 'Buy Secondhand',
    nameJa: '中古の衣類を購入',
    nameEs: 'Comprar ropa de segunda mano',
    descriptionEn:
      'Buy secondhand clothing instead '
      + 'of new',
    descriptionJa:
      '新品ではなく中古の衣類を購入',
    descriptionEs:
      'Comprar ropa de segunda mano en vez '
      + 'de nueva',
    category: 'consumption',
    co2Grams: 15000, // scenario review
    effort: 3, // find, browse, select items
    frequency: 2, // monthly shopping
    impact: 4, // reduces fast fashion demand
    iconName: 'autorenew',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 6,
  },
  {
    id: 'repair_item',
    nameEn: 'Repair Instead of Replace',
    nameJa: '買い替えずに修理',
    nameEs: 'Reparar en vez de reemplazar',
    descriptionEn:
      'Repair a broken item instead of '
      + 'buying a new one',
    descriptionJa:
      '壊れた物を新品を買う代わりに修理する',
    descriptionEs:
      'Reparar un objeto roto en vez de '
      + 'comprar uno nuevo',
    category: 'consumption',
    co2Grams: 7500, // weighted avg across item types
    effort: 3, // requires skill/time/parts
    frequency: 2, // when items break
    impact: 4, // circular economy mindset
    iconName: 'build',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 7,
  },
  {
    id: 'borrow_instead_buy',
    nameEn: 'Borrow Instead of Buy',
    nameJa: '買わずに借りる',
    nameEs: 'Pedir prestado en vez de comprar',
    descriptionEn:
      'Borrow a tool or item instead of '
      + 'buying new',
    descriptionJa:
      '新品を買う代わりに道具を借りる',
    descriptionEs:
      'Pedir prestada una herramienta en '
      + 'vez de comprar una nueva',
    category: 'consumption',
    co2Grams: 8000, // excl. books
    effort: 2, // arrange loan, return item
    frequency: 2, // occasional tool/item needs
    impact: 3, // sharing economy, less waste
    iconName: 'handshake',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 8,
  },
  {
    id: 'plastic_free_hygiene',
    nameEn: 'Plastic-Free Hygiene',
    nameJa: 'プラスチックフリーの衛生用品',
    nameEs: 'Higiene sin plastico',
    descriptionEn:
      'Use bar soap, shampoo bars, or '
      + 'other plastic-free hygiene '
      + 'products today',
    descriptionJa:
      '今日は固形石鹸やシャンプーバーなど'
      + 'プラスチックフリーの衛生用品を使用',
    descriptionEs:
      'Usar jabon en barra, champu '
      + 'solido u otros productos de '
      + 'higiene sin plastico hoy',
    category: 'consumption',
    co2Grams: 15,
    effort: 1,
    frequency: 5,
    impact: 2,
    iconName: 'soap',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 9,
  },
  {
    id: 'buy_bulk',
    nameEn: 'Buy in Bulk',
    nameJa: 'まとめ買いする',
    nameEs: 'Comprar a granel',
    descriptionEn:
      'Buy items in bulk to reduce '
      + 'packaging waste',
    descriptionJa:
      '包装ゴミを減らすためにまとめ買いする',
    descriptionEs:
      'Comprar a granel para reducir '
      + 'residuos de embalaje',
    category: 'consumption',
    co2Grams: 200, // per-trip: multiple items reframe
    effort: 2, // plan larger purchases
    frequency: 3, // weekly shopping
    impact: 2, // less packaging waste
    iconName: 'shopping',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 10,
  },
  {
    id: 'donate_items',
    nameEn: 'Donate Unused Items',
    nameJa: '不要品を寄付',
    nameEs: 'Donar articulos sin uso',
    descriptionEn:
      'Donate items you no longer need '
      + 'instead of trashing them',
    descriptionJa:
      '不要品をゴミに捨てずに寄付する',
    descriptionEs:
      'Donar cosas que ya no necesitas en '
      + 'vez de tirarlas',
    category: 'consumption',
    co2Grams: 12000, // per-donation-run: multiple items
    effort: 2, // sort, bag, find drop-off
    frequency: 2, // seasonal decluttering
    impact: 3, // extends product lifecycle
    iconName: 'volunteer_activism',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 11,
  },
  {
    id: 'no_impulse_buy',
    nameEn: 'Skip Impulse Purchase',
    nameJa: '衝動買いをしない',
    nameEs: 'Evitar compra impulsiva',
    descriptionEn:
      'Avoid an unnecessary impulse '
      + 'purchase today',
    descriptionJa:
      '今日は不要な衝動買いを避ける',
    descriptionEs:
      'Evitar una compra impulsiva '
      + 'innecesaria hoy',
    category: 'consumption',
    co2Grams: 200, // avg product ~200g embedded CO2
    effort: 2, // self-discipline required
    frequency: 4, // frequent temptation
    impact: 2, // reduces consumption cycle
    iconName: 'shopping',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 12,
  },
  {
    id: 'choose_minimal_packaging',
    nameEn: 'Choose Less Packaging',
    nameJa: '包装の少ない商品を選択',
    nameEs: 'Elegir menos embalaje',
    descriptionEn:
      'Choose products with minimal or no '
      + 'packaging',
    descriptionJa:
      '包装が少ないまたは無い商品を選択',
    descriptionEs:
      'Elegir productos con poco o ningun '
      + 'embalaje',
    category: 'consumption',
    co2Grams: 50, // ~50g packaging CO2 avoided
    effort: 1, // trivial: choose less wrapped
    frequency: 4, // each shopping trip
    impact: 2, // reduces waste stream
    iconName: 'inventory_2',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 13,
  },
  {
    id: 'used_car_purchase',
    nameEn: 'Purchase Used Car',
    nameJa: '中古車を購入',
    nameEs: 'Comprar auto usado',
    descriptionEn:
      'Buy a used car instead of a new '
      + 'one to avoid manufacturing '
      + 'emissions',
    descriptionJa:
      '製造時の排出を避けるため新車ではなく'
      + '中古車を購入する',
    descriptionEs:
      'Comprar un auto usado en vez de '
      + 'nuevo para evitar emisiones de '
      + 'fabricacion',
    category: 'consumption',
    co2Grams: 3000000,
    effort: 3,
    frequency: 1,
    impact: 4,
    iconName: 'directions_car',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 14,
  },

  // ---------------------------------------------------------
  // WATER (10 actions)
  // Research: co2data.org, Yarra Valley Water
  // ---------------------------------------------------------
  {
    id: 'shorter_shower',
    nameEn: 'Take Shorter Shower',
    nameJa: 'シャワーを短く',
    nameEs: 'Tomar ducha mas corta',
    descriptionEn:
      'Reduce shower time by 2+ minutes',
    descriptionJa:
      'シャワーの時間を2分以上短縮',
    descriptionEs:
      'Reducir el tiempo de ducha en mas '
      + 'de 2 minutos',
    category: 'water',
    co2Grams: 230, // 2min x 115g/min (co2data.org)
    effort: 2, // mild discipline needed
    frequency: 5, // daily showers
    impact: 2, // individual behavior change
    iconName: 'shower',
    relatedSdgs: ['6', '7', '13'],
    isActive: true,
    sortOrder: 1,
  },
  {
    id: 'turn_off_tap',
    nameEn: 'Turn Off Tap While Brushing',
    nameJa: '歯磨き中に水を止める',
    nameEs: 'Cerrar el grifo al cepillarse',
    descriptionEn:
      'Turn off the tap while brushing '
      + 'teeth',
    descriptionJa:
      '歯を磨いている間は水を止める',
    descriptionEs:
      'Cerrar el grifo mientras te cepillas '
      + 'los dientes',
    category: 'water',
    co2Grams: 20, // mostly cold; pump/treat CO2 only
    effort: 1, // trivial: turn tap off
    frequency: 5, // twice daily brushing
    impact: 1, // immediate, small scale
    iconName: 'water_drop',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 2,
  },
  {
    id: 'full_dishwasher',
    nameEn: 'Run Full Dishwasher',
    nameJa: '食洗機を満杯で回す',
    nameEs: 'Usar lavavajillas lleno',
    descriptionEn:
      'Only run the dishwasher when full',
    descriptionJa:
      '食洗機は満杯になってから回す',
    descriptionEs:
      'Usar el lavavajillas solo cuando '
      + 'este lleno',
    category: 'water',
    co2Grams: 80, // avoids partial load waste
    effort: 1, // wait for full load
    frequency: 4, // several times per week
    impact: 2, // water + energy savings
    iconName: 'dishwasher',
    relatedSdgs: ['6', '7'],
    isActive: true,
    sortOrder: 3,
  },
  {
    id: 'fix_leak',
    nameEn: 'Fix a Water Leak',
    nameJa: '水漏れを修理',
    nameEs: 'Reparar una fuga de agua',
    descriptionEn:
      'Fix a dripping tap or water leak',
    descriptionJa:
      '水漏れや蛇口のポタポタを修理',
    descriptionEs:
      'Reparar un grifo que gotea o una '
      + 'fuga de agua',
    category: 'water',
    co2Grams: 100000, // lifetime water + energy return
    effort: 3, // requires tools or plumber
    frequency: 1, // rare: when leaks occur
    impact: 4, // prevents waste for years
    iconName: 'plumbing',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 4,
  },
  {
    id: 'cold_water_rinse',
    nameEn: 'Rinse with Cold Water',
    nameJa: '冷水ですすぐ',
    nameEs: 'Enjuagar con agua fria',
    descriptionEn:
      'Rinse dishes with cold water '
      + 'instead of hot',
    descriptionJa:
      '食器を温水ではなく冷水ですすぐ',
    descriptionEs:
      'Enjuagar los platos con agua fria '
      + 'en vez de caliente',
    category: 'water',
    co2Grams: 30, // avoids heating 6-18L rinse water
    effort: 1, // trivial: choose cold tap
    frequency: 5, // daily dish rinsing
    impact: 1, // immediate, small scale
    iconName: 'water_drop',
    relatedSdgs: ['6', '7'],
    isActive: true,
    sortOrder: 5,
  },
  {
    id: 'install_rain_collector',
    nameEn: 'Install Rain Collector',
    nameJa: '雨水タンクを設置',
    nameEs: 'Instalar recolector de lluvia',
    descriptionEn:
      'Set up a rain barrel or collection '
      + 'system for garden watering',
    descriptionJa:
      '庭の水やり用に雨水タンクや集水'
      + 'システムを設置する',
    descriptionEs:
      'Instalar un barril de lluvia o '
      + 'sistema de recoleccion para '
      + 'regar el jardin',
    category: 'water',
    co2Grams: 750, // one-time install
    effort: 3,
    frequency: 1,
    impact: 3,
    iconName: 'water_drop',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 6,
  },
  {
    id: 'water_plants_morning',
    nameEn: 'Water Plants in the Morning',
    nameJa: '朝に植物に水やり',
    nameEs: 'Regar plantas por la manana',
    descriptionEn:
      'Water garden in the morning to '
      + 'reduce evaporation',
    descriptionJa:
      '蒸発を減らすため朝に水やりをする',
    descriptionEs:
      'Regar el jardin por la manana para '
      + 'reducir la evaporacion',
    category: 'water',
    co2Grams: 5, // reduces evaporation loss ~25%
    effort: 1, // trivial: adjust timing
    frequency: 4, // growing season days
    impact: 1, // immediate, small scale
    iconName: 'yard',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 7,
  },
  {
    id: 'reuse_cooking_water',
    nameEn: 'Reuse Cooking Water',
    nameJa: '料理の水を再利用',
    nameEs: 'Reutilizar agua de cocina',
    descriptionEn:
      'Reuse pasta or vegetable cooking '
      + 'water for plants',
    descriptionJa:
      'パスタや野菜の茹で汁を植物に再利用',
    descriptionEs:
      'Reutilizar agua de coccion de pasta '
      + 'o verduras para regar',
    category: 'water',
    co2Grams: 5, // displaces ~3L mains for plants
    effort: 1, // trivial: pour on plants
    frequency: 4, // each time you boil water
    impact: 2, // reuse mindset, nutrients
    iconName: 'kitchen',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 8,
  },
  {
    id: 'turn_off_tap_dishes',
    nameEn: 'Turn Off Tap While Scrubbing',
    nameJa: '食器洗い中に水を止める',
    nameEs: 'Cerrar el grifo al fregar',
    descriptionEn:
      'Turn off the tap while scrubbing '
      + 'dishes',
    descriptionJa:
      '食器をこすっている間は水を止める',
    descriptionEs:
      'Cerrar el grifo mientras frotas '
      + 'los platos',
    category: 'water',
    co2Grams: 25, // ~12L hot water, partial heating share; EPA WaterSense ~25g per wash
    effort: 1, // trivial: turn tap off
    frequency: 5, // daily dish washing
    impact: 1, // immediate, small scale
    iconName: 'water_drop',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 9,
  },
  {
    id: 'shorter_bath',
    nameEn: 'Shower Instead of Bath',
    nameJa: 'お風呂の代わりにシャワー',
    nameEs: 'Ducha en vez de bano',
    descriptionEn:
      'Take a short shower instead of '
      + 'a full bath',
    descriptionJa:
      '満杯のお風呂の代わりに短いシャワーを'
      + '浴びる',
    descriptionEs:
      'Tomar una ducha corta en vez de '
      + 'un bano completo',
    category: 'water',
    co2Grams: 450, // bath ~800g vs 5min shower ~300g
    effort: 2, // comfort habit change
    frequency: 5, // daily bathing
    impact: 2, // individual behavior change
    iconName: 'shower',
    relatedSdgs: ['6', '7', '13'],
    isActive: true,
    sortOrder: 10,
  },

  // ---------------------------------------------------------
  // COMMUNITY (13 actions)
  // Research: EPA greenhouse gas equivalencies
  // ---------------------------------------------------------
  {
    id: 'tree_planting',
    nameEn: 'Plant a Tree',
    nameJa: '木を植える',
    nameEs: 'Plantar un arbol',
    descriptionEn:
      'Plant a tree to absorb CO2 for '
      + 'years to come',
    descriptionJa:
      'CO2を吸収する木を植える',
    descriptionEs:
      'Plantar un arbol para absorber CO2 '
      + 'en los anos venideros',
    category: 'community',
    co2Grams: 15000, // ~15kg first-year absorption
    effort: 4, // source tree, dig, plant, water
    frequency: 1, // rare: once or twice per year
    impact: 5, // generational: decades of CO2
    iconName: 'forest',
    relatedSdgs: ['13', '15'],
    isActive: true,
    sortOrder: 1,
  },
  {
    id: 'beach_cleanup',
    nameEn: 'Beach or Park Cleanup',
    nameJa: 'ビーチや公園の清掃',
    nameEs: 'Limpieza de playa o parque',
    descriptionEn:
      'Participate in a beach or park '
      + 'cleanup event',
    descriptionJa:
      'ビーチや公園の清掃活動に参加',
    descriptionEs:
      'Participar en una jornada de '
      + 'limpieza de playa o parque',
    category: 'community',
    co2Grams: 0, // ecological; not CO2-measurable
    effort: 3, // travel, collect waste, hours
    frequency: 2, // monthly: organized events
    impact: 4, // marine/ecosystem protection
    iconName: 'park',
    relatedSdgs: ['14', '15'],
    isActive: true,
    sortOrder: 2,
  },
  {
    id: 'buy_local_produce',
    nameEn: 'Buy Local Produce',
    nameJa: '地元の農産物を購入',
    nameEs: 'Comprar productos locales',
    descriptionEn:
      'Buy locally grown food from a '
      + 'farmers market, farm stand, or '
      + 'local supplier',
    descriptionJa:
      'ファーマーズマーケット、直売所、'
      + '地元の業者から地産食材を購入する',
    descriptionEs:
      'Comprar alimentos cultivados '
      + 'localmente en un mercado de '
      + 'agricultores o proveedor local',
    category: 'community',
    co2Grams: 300,
    effort: 2,
    frequency: 3,
    impact: 3,
    iconName: 'storefront',
    relatedSdgs: ['2', '11', '12'],
    isActive: true,
    sortOrder: 3,
  },
  {
    id: 'share_sustainability_tip',
    nameEn: 'Share a Sustainability Tip',
    nameJa: 'サステナビリティの知識を共有',
    nameEs: 'Compartir consejo de '
      + 'sostenibilidad',
    descriptionEn:
      'Share an eco-friendly tip with '
      + 'a friend or family member',
    descriptionJa:
      'エコのコツを友人や家族と共有',
    descriptionEs:
      'Compartir un consejo ecologico con '
      + 'un amigo o familiar',
    category: 'community',
    co2Grams: 0, // indirect: knowledge cascades
    effort: 1, // trivial: quick conversation
    frequency: 4, // frequent social interactions
    impact: 3, // spreads awareness over time
    iconName: 'share',
    relatedSdgs: ['13'],
    isActive: true,
    sortOrder: 4,
  },
  {
    id: 'community_garden',
    nameEn: 'Community Garden Session',
    nameJa: 'コミュニティ農園に参加',
    nameEs: 'Sesion en huerto comunitario',
    descriptionEn:
      'Participate in a community garden '
      + 'session',
    descriptionJa:
      'コミュニティ農園の活動に参加',
    descriptionEs:
      'Participar en una sesion de huerto '
      + 'comunitario',
    category: 'community',
    co2Grams: 200, // sequestration + local food miles
    effort: 3, // physical gardening work
    frequency: 3, // weekly during growing season
    impact: 4, // food resilience, community
    iconName: 'grass',
    relatedSdgs: ['2', '11', '15'],
    isActive: true,
    sortOrder: 5,
  },
  {
    id: 'volunteer_environment',
    nameEn: 'Volunteer for the Environment',
    nameJa: '環境ボランティアに参加',
    nameEs: 'Voluntariado ambiental',
    descriptionEn:
      'Volunteer for an environmental '
      + 'organization or event',
    descriptionJa:
      '環境団体やイベントでボランティア活動',
    descriptionEs:
      'Hacer voluntariado para una '
      + 'organizacion o evento ambiental',
    category: 'community',
    co2Grams: 0, // systemic; not CO2-measurable
    effort: 4, // significant time + travel
    frequency: 2, // monthly or less
    impact: 4, // lasting ecological benefits
    iconName: 'volunteer_activism',
    relatedSdgs: ['13', '15'],
    isActive: true,
    sortOrder: 6,
  },
  {
    id: 'teach_child_eco',
    nameEn: 'Teach a Child About Ecology',
    nameJa: '子供にエコロジーを教える',
    nameEs: 'Ensenar ecologia a un nino',
    descriptionEn:
      'Spend time teaching a child about '
      + 'the environment',
    descriptionJa:
      '子供に環境について教える時間を取る',
    descriptionEs:
      'Dedicar tiempo a ensenar a un nino '
      + 'sobre el medio ambiente',
    category: 'community',
    co2Grams: 0, // indirect: generational change
    effort: 2, // prepare and engage
    frequency: 3, // weekly interactions
    impact: 5, // generational behavior change
    iconName: 'school',
    relatedSdgs: ['4', '13'],
    isActive: true,
    sortOrder: 7,
  },
  {
    id: 'support_eco_business',
    nameEn: 'Support Eco-Friendly Business',
    nameJa: 'エコ企業を支援',
    nameEs: 'Apoyar negocio ecologico',
    descriptionEn:
      'Buy from a business with strong '
      + 'sustainability practices',
    descriptionJa:
      '持続可能な取り組みをする企業から購入',
    descriptionEs:
      'Comprar en un negocio con buenas '
      + 'practicas de sostenibilidad',
    category: 'community',
    co2Grams: 200, // eco biz ~20-50% lower footprint
    effort: 2, // research, find businesses
    frequency: 3, // weekly purchases
    impact: 3, // market signals for change
    iconName: 'storefront',
    relatedSdgs: ['8', '12'],
    isActive: true,
    sortOrder: 8,
  },
  {
    id: 'organize_swap',
    nameEn: 'Organize a Swap Event',
    nameJa: '交換イベントを企画',
    nameEs: 'Organizar evento de intercambio',
    descriptionEn:
      'Organize or join a clothing or '
      + 'item swap event',
    descriptionJa:
      '衣類や物品の交換イベントを企画・参加',
    descriptionEs:
      'Organizar o asistir a un evento de '
      + 'intercambio de ropa o articulos',
    category: 'community',
    co2Grams: 1000, // multiple items reused; conserv.
    effort: 4, // plan, coordinate, host
    frequency: 1, // rare: few times per year
    impact: 4, // builds reuse culture
    iconName: 'groups',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 9,
  },
  {
    id: 'pick_up_litter',
    nameEn: 'Pick Up Litter',
    nameJa: 'ゴミ拾い',
    nameEs: 'Recoger basura',
    descriptionEn:
      'Pick up litter in your neighborhood '
      + 'or on a walk',
    descriptionJa:
      '近所や散歩中にゴミを拾う',
    descriptionEs:
      'Recoger basura en tu vecindario o '
      + 'durante un paseo',
    category: 'community',
    co2Grams: 0, // ecological; not CO2-measurable
    effort: 2, // simple physical task
    frequency: 4, // on walks, in neighborhood
    impact: 3, // local aesthetic + awareness
    iconName: 'cleaning_services',
    relatedSdgs: ['11', '14', '15'],
    isActive: true,
    sortOrder: 10,
  },
  {
    id: 'take_on_household_task',
    nameEn: 'Take On a Household Task',
    nameJa: '家事を一つ引き受ける',
    nameEs: 'Asumir una tarea del hogar',
    descriptionEn:
      'Take on a household chore to '
      + 'support a fair division of '
      + 'domestic labor today',
    descriptionJa:
      '今日は家事を一つ引き受けて家庭内'
      + 'の公平な分担を実践する',
    descriptionEs:
      'Asumir una tarea del hogar para '
      + 'apoyar una division justa del '
      + 'trabajo domestico hoy',
    category: 'community',
    co2Grams: 0,
    effort: 3,
    frequency: 5,
    impact: 4,
    iconName: 'home',
    relatedSdgs: ['5', '3', '8', '10'],
    isActive: true,
    sortOrder: 11,
  },
  {
    id: 'use_library',
    nameEn: 'Use the Library',
    nameJa: '図書館を利用する',
    nameEs: 'Usar la biblioteca',
    descriptionEn:
      'Borrow books, media, or resources '
      + 'from the library instead of buying '
      + 'new',
    descriptionJa:
      '新品を買う代わりに図書館で本やメディア'
      + 'を借りる',
    descriptionEs:
      'Tomar prestados libros, medios '
      + 'o recursos de la biblioteca en '
      + 'vez de comprar nuevos',
    category: 'community',
    co2Grams: 1000,
    effort: 2,
    frequency: 3,
    impact: 3,
    iconName: 'local_library',
    relatedSdgs: ['4', '12'],
    isActive: true,
    sortOrder: 12,
  },
  {
    id: 'support_community_business',
    nameEn: 'Support a Community Business',
    nameJa: 'コミュニティのお店を利用',
    nameEs: 'Apoyar negocio comunitario',
    descriptionEn:
      'Buy from a local minority-owned or '
      + 'underrepresented community business',
    descriptionJa:
      '地域のマイノリティ経営や地元密着の'
      + 'ビジネスを利用する',
    descriptionEs:
      'Comprar en un negocio local de '
      + 'minorias o comunidades '
      + 'subrepresentadas',
    category: 'community',
    co2Grams: 0, // economic equity action
    effort: 2, // research and choose
    frequency: 3, // weekly purchases
    impact: 4, // community economic resilience
    iconName: 'diversity_3',
    relatedSdgs: ['10', '1', '8', '11'],
    isActive: true,
    sortOrder: 13,
  },

  // ---------------------------------------------------------
  // ADVOCACY (9 actions)
  // ---------------------------------------------------------
  {
    id: 'sign_petition',
    nameEn: 'Sign an Environmental Petition',
    nameJa: '環境に関する署名をする',
    nameEs: 'Firmar una peticion ambiental',
    descriptionEn:
      'Sign a petition supporting '
      + 'environmental policy',
    descriptionJa:
      '環境政策を支持する署名に参加',
    descriptionEs:
      'Firmar una peticion que apoye '
      + 'politicas ambientales',
    category: 'advocacy',
    co2Grams: 0, // indirect: collective policy push
    effort: 1, // trivial: sign online
    frequency: 2, // monthly: as petitions arise
    impact: 4, // collective policy pressure
    iconName: 'edit_note',
    relatedSdgs: ['13', '16'],
    isActive: true,
    sortOrder: 1,
  },
  {
    id: 'contact_representative',
    nameEn: 'Contact Your Representative',
    nameJa: '議員に連絡する',
    nameEs: 'Contactar a tu representante',
    descriptionEn:
      'Contact your elected official about '
      + 'climate policy',
    descriptionJa:
      '気候政策について議員に連絡する',
    descriptionEs:
      'Contactar a tu representante electo '
      + 'sobre politica climatica',
    category: 'advocacy',
    co2Grams: 0, // indirect: highest leverage action
    effort: 3, // compose message, research
    frequency: 2, // monthly or less
    impact: 5, // highest-leverage for climate
    iconName: 'campaign',
    relatedSdgs: ['13', '16'],
    isActive: true,
    sortOrder: 2,
  },
  {
    id: 'share_eco_content',
    nameEn: 'Share Eco Content Online',
    nameJa: 'エコ情報をSNSでシェア',
    nameEs: 'Compartir contenido ecologico '
      + 'en linea',
    descriptionEn:
      'Share environmental content on '
      + 'social media',
    descriptionJa:
      '環境に関する情報をSNSでシェア',
    descriptionEs:
      'Compartir contenido ambiental en '
      + 'redes sociales',
    category: 'advocacy',
    co2Grams: 0, // indirect: awareness multiplier
    effort: 1, // trivial: share/repost
    frequency: 4, // multiple times per week
    impact: 3, // normalizes sustainability
    iconName: 'share',
    relatedSdgs: ['13', '17'],
    isActive: true,
    sortOrder: 3,
  },
  {
    id: 'attend_climate_event',
    nameEn: 'Attend a Climate Event',
    nameJa: '気候変動イベントに参加',
    nameEs: 'Asistir a un evento climatico',
    descriptionEn:
      'Attend a climate rally, march, or '
      + 'awareness event',
    descriptionJa:
      '気候変動に関する集会やイベントに参加',
    descriptionEs:
      'Asistir a una marcha, evento o '
      + 'reunion sobre el clima',
    category: 'advocacy',
    co2Grams: 0, // indirect: media + policy pressure
    effort: 4, // significant time + travel
    frequency: 1, // rare: once or twice per year
    impact: 5, // drives policy + cultural shift
    iconName: 'campaign',
    relatedSdgs: ['13', '16'],
    isActive: true,
    sortOrder: 4,
  },
  {
    id: 'support_green_policy',
    nameEn: 'Support Green Policy',
    nameJa: '環境政策を支持',
    nameEs: 'Apoyar politica verde',
    descriptionEn:
      'Vote for or advocate for green '
      + 'energy and climate policies',
    descriptionJa:
      'グリーンエネルギーや気候政策を支持・'
      + '投票',
    descriptionEs:
      'Votar o abogar por politicas de '
      + 'energia verde y clima',
    category: 'advocacy',
    co2Grams: 0, // indirect: systemic policy change
    effort: 3, // research + advocacy effort
    frequency: 1, // rare: elections, campaigns
    impact: 5, // policy is highest leverage
    iconName: 'balance',
    relatedSdgs: ['7', '13', '16'],
    isActive: true,
    sortOrder: 5,
  },
  {
    id: 'write_eco_review',
    nameEn: 'Write an Eco-Friendly Review',
    nameJa: 'エコ商品のレビューを書く',
    nameEs: 'Escribir resena ecologica',
    descriptionEn:
      'Write a positive review for a '
      + 'sustainable product or business',
    descriptionJa:
      'サステナブルな商品や企業にレビューを書く',
    descriptionEs:
      'Escribir una resena positiva para un '
      + 'producto o negocio sostenible',
    category: 'advocacy',
    co2Grams: 0, // indirect: influences purchases
    effort: 2, // write thoughtful review
    frequency: 2, // monthly
    impact: 3, // influences consumer choices
    iconName: 'edit_note',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 6,
  },
  {
    id: 'attend_eco_meeting',
    nameEn: 'Attend Eco Group Meeting',
    nameJa: '環境グループの会合に参加',
    nameEs: 'Asistir a reunion de grupo '
      + 'ecologico',
    descriptionEn:
      'Attend a meeting or event with '
      + 'your environmental group',
    descriptionJa:
      '環境グループの会合やイベントに参加',
    descriptionEs:
      'Asistir a una reunion o evento '
      + 'con tu grupo ambiental',
    category: 'advocacy',
    co2Grams: 0,
    effort: 2,
    frequency: 2,
    impact: 4,
    iconName: 'groups',
    relatedSdgs: ['13', '17'],
    isActive: true,
    sortOrder: 7,
  },
  {
    id: 'request_green_option',
    nameEn: 'Request a Green Option',
    nameJa: 'エコな選択肢をリクエスト',
    nameEs: 'Solicitar una opcion verde',
    descriptionEn:
      'Ask a business or restaurant to '
      + 'offer a greener option',
    descriptionJa:
      '店舗や飲食店にエコな選択肢を提案する',
    descriptionEs:
      'Pedir a un negocio o restaurante '
      + 'que ofrezca una opcion mas verde',
    category: 'advocacy',
    co2Grams: 0, // indirect: demand signal
    effort: 2, // conversation or email
    frequency: 3, // weekly: at businesses
    impact: 3, // aggregate demand drives change
    iconName: 'campaign',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 8,
  },
  {
    id: 'donate_women_climate_org',
    nameEn: 'Donate to a Women-Led Climate '
      + 'Organization',
    nameJa: '女性主導の気候団体に寄付',
    nameEs: 'Donar a organizacion climatica '
      + 'liderada por mujeres',
    descriptionEn:
      'Donate to an organization led by '
      + 'women working on climate justice',
    descriptionJa:
      '気候正義に取り組む女性主導の団体に'
      + '寄付する',
    descriptionEs:
      'Donar a una organizacion liderada '
      + 'por mujeres que trabaja en '
      + 'justicia climatica',
    category: 'advocacy',
    co2Grams: 0,
    effort: 2,
    frequency: 1,
    impact: 5,
    iconName: 'volunteer_activism',
    relatedSdgs: ['5', '10', '13', '17'],
    isActive: true,
    sortOrder: 9,
  },

  // ---------------------------------------------------------
  // SDG-TARGETED (4 actions)
  // Actions for SDGs previously without coverage
  // ---------------------------------------------------------
  {
    id: 'buy_fair_trade',
    nameEn: 'Buy Fair Trade Product',
    nameJa: 'フェアトレード商品を購入',
    nameEs: 'Comprar producto de comercio justo',
    descriptionEn:
      'Choose a Fair Trade certified product '
      + 'to support fair wages for producers',
    descriptionJa:
      'フェアトレード認証商品を選んで生産者の'
      + '公正な賃金を支援する',
    descriptionEs:
      'Elegir un producto certificado de '
      + 'comercio justo para apoyar '
      + 'salarios justos',
    category: 'consumption',
    co2Grams: 0, // social equity + env co-benefits
    effort: 2, // find fair trade products
    frequency: 3, // weekly shopping
    impact: 4, // systemic supply chain change
    iconName: 'handshake',
    relatedSdgs: ['1', '2', '8', '10', '12'],
    isActive: true,
    sortOrder: 15,
  },
  {
    id: 'fund_micro_loan',
    nameEn: 'Fund a Micro-Loan',
    nameJa: 'マイクロローンに出資',
    nameEs: 'Financiar un microprestamo',
    descriptionEn:
      'Lend to an entrepreneur in a '
      + 'developing country through a '
      + 'micro-lending platform',
    descriptionJa:
      'マイクロレンディングを通じて途上国の'
      + '起業家に融資する',
    descriptionEs:
      'Prestar a un emprendedor en un pais '
      + 'en desarrollo a traves de una '
      + 'plataforma de microprestamos',
    category: 'community',
    co2Grams: 0, // economic dev + env co-benefits
    effort: 3, // research platforms, select
    frequency: 2, // monthly or less
    impact: 5, // generational poverty reduction
    iconName: 'currency_exchange',
    relatedSdgs: ['1', '8', '10', '17'],
    isActive: true,
    sortOrder: 14,
  },
  {
    id: 'support_women_owned_business',
    nameEn: 'Support a Women-Owned Business',
    nameJa: '女性経営の店舗を利用',
    nameEs: 'Apoyar negocio de mujeres',
    descriptionEn:
      'Purchase from a women-owned or '
      + 'women-led business',
    descriptionJa:
      '女性が経営するビジネスの商品や'
      + 'サービスを利用する',
    descriptionEs:
      'Comprar en un negocio propiedad '
      + 'de mujeres o liderado por mujeres',
    category: 'consumption',
    co2Grams: 0, // gender equity action
    effort: 2, // research and choose
    frequency: 3, // weekly purchases
    impact: 4, // economic empowerment
    iconName: 'storefront',
    relatedSdgs: ['5', '8', '10', '12'],
    isActive: true,
    sortOrder: 16,
  },

  // ---------------------------------------------------------
  // SDG-TARGETED PART 2 (2 actions)
  // Filling coverage gaps for Goals 4 and 5
  // ---------------------------------------------------------
  {
    id: 'citizen_science_project',
    nameEn: 'Participate in a Citizen Science '
      + 'Project',
    nameJa: '市民科学プロジェクトに参加',
    nameEs: 'Participar en un proyecto de '
      + 'ciencia ciudadana',
    descriptionEn:
      'Join a community biodiversity survey '
      + 'or citizen science project like '
      + 'iNaturalist',
    descriptionJa:
      'iNaturalistなどの市民科学プロジェクト'
      + 'や生物多様性調査に参加する',
    descriptionEs:
      'Participar en un proyecto de ciencia '
      + 'ciudadana o estudio de biodiversidad '
      + 'como iNaturalist',
    category: 'community',
    co2Grams: 0,
    effort: 3,
    frequency: 1,
    impact: 4,
    iconName: 'biotech',
    relatedSdgs: ['4', '13', '15'],
    isActive: true,
    sortOrder: 15,
  },
  {
    id: 'volunteer_nature_walk',
    nameEn: 'Volunteer for a Nature Walk',
    nameJa: '自然散策ボランティアに参加',
    nameEs: 'Voluntariado en caminata por '
      + 'la naturaleza',
    descriptionEn:
      'Volunteer to help with a guided '
      + 'nature walk for your community',
    descriptionJa:
      '地域のガイド付き自然散策の'
      + 'ボランティアに参加する',
    descriptionEs:
      'Ser voluntario en una caminata '
      + 'guiada por la naturaleza para '
      + 'tu comunidad',
    category: 'community',
    co2Grams: 0,
    effort: 3,
    frequency: 1,
    impact: 5,
    iconName: 'forest',
    relatedSdgs: ['4', '11', '13', '15'],
    isActive: true,
    sortOrder: 16,
  },
];

async function seedActionLibrary() {
  console.log('Seeding actionLibrary collection...\n');
  console.log(`Total actions: ${actions.length}\n`);

  const batch = db.batch();
  const categoryStats = {};

  for (const action of actions) {
    const { id, ...data } = action;
    const points = computePoints(action);
    const desc = longDescs[id] || {};
    const docRef = db
      .collection('actionLibrary')
      .doc(id);
    batch.set(docRef, {
      isLearnOnly: false,
      ...data,
      points,
      descriptionLongEn: desc.en || '',
      descriptionLongJa: desc.ja || '',
      descriptionLongEs: desc.es || '',
    });
    const co2Display = action.co2Grams >= 1000
      ? `${(action.co2Grams / 1000).toFixed(1)}kg`
      : `${action.co2Grams}g`;
    console.log(
      `  + ${action.nameEn} `
      + `(${points} pts, `
      + `${co2Display} CO2, `
      + `e${action.effort}/f${action.frequency}`
      + `/i${action.impact})`,
    );

    if (!categoryStats[action.category]) {
      categoryStats[action.category] = {
        count: 0, totalPts: 0,
        minPts: Infinity, maxPts: 0,
      };
    }
    const cat = categoryStats[action.category];
    cat.count++;
    cat.totalPts += points;
    cat.minPts = Math.min(cat.minPts, points);
    cat.maxPts = Math.max(cat.maxPts, points);
  }

  await batch.commit();
  console.log(
    `\nSuccessfully seeded ${actions.length} actions!`,
  );

  // Clean up orphaned action documents
  const validIds = new Set(actions.map((a) => a.id));
  const snapshot = await db
    .collection('actionLibrary')
    .get();
  const orphanBatch = db.batch();
  let orphanCount = 0;
  for (const doc of snapshot.docs) {
    if (!validIds.has(doc.id)) {
      orphanBatch.delete(doc.ref);
      orphanCount++;
      console.log(`  - Removing orphan: ${doc.id}`);
    }
  }
  if (orphanCount > 0) {
    await orphanBatch.commit();
    console.log(
      `\nRemoved ${orphanCount} orphaned actions.`,
    );
  } else {
    console.log('\nNo orphaned actions found.');
  }

  console.log('\n--- Points by category ---');
  for (const [cat, stats] of
    Object.entries(categoryStats)) {
    const avg = (stats.totalPts / stats.count)
      .toFixed(1);
    console.log(
      `  ${cat}: ${stats.count} actions, `
      + `${stats.minPts}-${stats.maxPts} pts `
      + `(avg ${avg})`,
    );
  }
}

seedActionLibrary()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Error seeding data:', error);
    process.exit(1);
  });
