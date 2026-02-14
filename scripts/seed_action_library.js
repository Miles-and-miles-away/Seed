#!/usr/bin/env node

/**
 * Seeds the Firestore actionLibrary collection with
 * researched eco-actions.
 *
 * CO2 values based on peer-reviewed research and
 * government data.
 * See Plan/co2_actions_database.json for sources.
 *
 * Usage:
 *   1. Set up Firebase Admin SDK credentials:
 *      - Go to Firebase Console > Project Settings
 *        > Service Accounts
 *      - Click "Generate New Private Key" and save as
 *        serviceAccountKey.json in the scripts folder
 *   2. Run: node scripts/seed_action_library.js
 */

const admin = require('firebase-admin');
const path = require('path');

const serviceAccountPath = path.join(
  __dirname,
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
    points: 5,
    co2Grams: 100,
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
    points: 3,
    co2Grams: 50,
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
    points: 3,
    co2Grams: 50,
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
    points: 8,
    co2Grams: 200,
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
    points: 3,
    co2Grams: 40,
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
    points: 3,
    co2Grams: 50,
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
    points: 20,
    co2Grams: 2350,
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
    points: 50,
    co2Grams: 14000,
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
    points: 5,
    co2Grams: 95,
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
    points: 5,
    co2Grams: 150,
    iconName: 'kitchen',
    relatedSdgs: ['6', '12', '14'],
    isActive: true,
    sortOrder: 10,
  },

  // ---------------------------------------------------------
  // TRANSPORT (12 actions)
  // Research: DEFRA 2024 petrol car avg 164g CO2/km
  // ---------------------------------------------------------
  {
    id: 'walk_instead_drive',
    nameEn: 'Walk Instead of Drive',
    nameJa: '車の代わりに徒歩',
    nameEs: 'Caminar en vez de conducir',
    descriptionEn:
      'Walk to your destination instead '
      + 'of driving',
    descriptionJa:
      '車を使わずに目的地まで歩く',
    descriptionEs:
      'Caminar hasta tu destino en vez '
      + 'de conducir',
    category: 'transport',
    points: 10,
    co2Grams: 250,
    iconName: 'directions_walk',
    relatedSdgs: ['3', '11', '13'],
    isActive: true,
    sortOrder: 10,
  },
  {
    id: 'bike_short_trip',
    nameEn: 'Bike Short Trip',
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
    points: 15,
    co2Grams: 450,
    iconName: 'pedal_bike',
    relatedSdgs: ['3', '11', '13'],
    isActive: true,
    sortOrder: 11,
  },
  {
    id: 'bike_medium_trip',
    nameEn: 'Bike Medium Trip',
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
    points: 25,
    co2Grams: 1000,
    iconName: 'pedal_bike',
    relatedSdgs: ['3', '11', '13'],
    isActive: true,
    sortOrder: 12,
  },
  {
    id: 'public_transit',
    nameEn: 'Take Public Transit',
    nameJa: '公共交通機関を利用',
    nameEs: 'Usar transporte publico',
    descriptionEn:
      'Take bus or train instead of driving',
    descriptionJa:
      '車の代わりにバスや電車を利用',
    descriptionEs:
      'Tomar autobus o tren en vez de '
      + 'conducir',
    category: 'transport',
    points: 20,
    co2Grams: 1000,
    iconName: 'train',
    relatedSdgs: ['9', '11', '13'],
    isActive: true,
    sortOrder: 13,
  },
  {
    id: 'carpool',
    nameEn: 'Carpool',
    nameJa: '相乗りで移動',
    nameEs: 'Compartir auto',
    descriptionEn:
      'Share a ride instead of driving alone',
    descriptionJa:
      '一人で運転する代わりに相乗りする',
    descriptionEs:
      'Compartir viaje en vez de conducir '
      + 'solo',
    category: 'transport',
    points: 15,
    co2Grams: 800,
    iconName: 'people',
    relatedSdgs: ['11', '13'],
    isActive: true,
    sortOrder: 14,
  },
  {
    id: 'electric_car_commute',
    nameEn: 'Electric Car Commute',
    nameJa: '電気自動車で通勤',
    nameEs: 'Ir al trabajo en auto electrico',
    descriptionEn:
      'Drive an EV instead of a gasoline car',
    descriptionJa:
      'ガソリン車の代わりに電気自動車を使用',
    descriptionEs:
      'Conducir un auto electrico en vez de '
      + 'uno de gasolina',
    category: 'transport',
    points: 20,
    co2Grams: 1500,
    iconName: 'electric_car',
    relatedSdgs: ['7', '11', '13'],
    isActive: true,
    sortOrder: 15,
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
    points: 100,
    co2Grams: 110000,
    iconName: 'train',
    relatedSdgs: ['13'],
    isActive: true,
    sortOrder: 16,
  },
  {
    id: 'take_bus',
    nameEn: 'Take the Bus',
    nameJa: 'バスを利用',
    nameEs: 'Tomar el autobus',
    descriptionEn:
      'Take a bus instead of driving '
      + 'for your commute',
    descriptionJa:
      '通勤に車の代わりにバスを利用',
    descriptionEs:
      'Tomar el autobus en vez de conducir '
      + 'para ir al trabajo',
    category: 'transport',
    points: 10,
    co2Grams: 500,
    iconName: 'bus',
    relatedSdgs: ['9', '11', '13'],
    isActive: true,
    sortOrder: 17,
  },
  {
    id: 'work_from_home',
    nameEn: 'Work From Home',
    nameJa: '在宅勤務',
    nameEs: 'Trabajar desde casa',
    descriptionEn:
      'Work from home to avoid commute '
      + 'emissions',
    descriptionJa:
      '通勤による排出を避けるため在宅勤務',
    descriptionEs:
      'Trabajar desde casa para evitar '
      + 'emisiones del traslado',
    category: 'transport',
    points: 30,
    co2Grams: 2640,
    iconName: 'bolt',
    relatedSdgs: ['8', '11', '13'],
    isActive: true,
    sortOrder: 18,
  },
  {
    id: 'escooter_trip',
    nameEn: 'E-Scooter Instead of Drive',
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
    points: 8,
    co2Grams: 375,
    iconName: 'electric_bolt',
    relatedSdgs: ['11', '13'],
    isActive: true,
    sortOrder: 19,
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
    points: 10,
    co2Grams: 400,
    iconName: 'ev_station',
    relatedSdgs: ['7', '11', '13'],
    isActive: true,
    sortOrder: 20,
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
    points: 8,
    co2Grams: 300,
    iconName: 'local_shipping',
    relatedSdgs: ['11', '13'],
    isActive: true,
    sortOrder: 21,
  },

  // ---------------------------------------------------------
  // FOOD (15 actions)
  // Research: Poore & Nemecek 2018, Our World in Data, EPA
  // ---------------------------------------------------------
  {
    id: 'meatless_meal_beef',
    nameEn: 'Skip Beef Meal',
    nameJa: '牛肉なしの食事',
    nameEs: 'Evitar comida con carne de res',
    descriptionEn:
      'Choose a plant-based meal instead '
      + 'of beef',
    descriptionJa:
      '牛肉の代わりに植物性の食事を選択',
    descriptionEs:
      'Elegir una comida vegetal en vez '
      + 'de carne de res',
    category: 'food',
    points: 25,
    co2Grams: 6000,
    iconName: 'eco',
    relatedSdgs: ['2', '12', '13', '15'],
    isActive: true,
    sortOrder: 20,
  },
  {
    id: 'meatless_meal_chicken',
    nameEn: 'Skip Chicken Meal',
    nameJa: '鶏肉なしの食事',
    nameEs: 'Evitar comida con pollo',
    descriptionEn:
      'Choose a plant-based meal instead '
      + 'of chicken',
    descriptionJa:
      '鶏肉の代わりに植物性の食事を選択',
    descriptionEs:
      'Elegir una comida vegetal en vez '
      + 'de pollo',
    category: 'food',
    points: 10,
    co2Grams: 600,
    iconName: 'eco',
    relatedSdgs: ['2', '12', '13'],
    isActive: true,
    sortOrder: 21,
  },
  {
    id: 'meatless_meal_pork',
    nameEn: 'Skip Pork Meal',
    nameJa: '豚肉なしの食事',
    nameEs: 'Evitar comida con cerdo',
    descriptionEn:
      'Choose a plant-based meal instead '
      + 'of pork',
    descriptionJa:
      '豚肉の代わりに植物性の食事を選択',
    descriptionEs:
      'Elegir una comida vegetal en vez '
      + 'de cerdo',
    category: 'food',
    points: 10,
    co2Grams: 700,
    iconName: 'eco',
    relatedSdgs: ['2', '12', '13'],
    isActive: true,
    sortOrder: 22,
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
    points: 10,
    co2Grams: 400,
    iconName: 'food_bank',
    relatedSdgs: ['2', '12', '13'],
    isActive: true,
    sortOrder: 23,
  },
  {
    id: 'local_produce',
    nameEn: 'Buy Local Produce',
    nameJa: '地元の農産物を購入',
    nameEs: 'Comprar productos locales',
    descriptionEn:
      'Buy locally grown fruits or '
      + 'vegetables',
    descriptionJa:
      '地元で栽培された野菜や果物を購入',
    descriptionEs:
      'Comprar frutas o verduras cultivadas '
      + 'localmente',
    category: 'food',
    points: 5,
    co2Grams: 200,
    iconName: 'storefront',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 24,
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
    points: 10,
    co2Grams: 460,
    iconName: 'local_cafe',
    relatedSdgs: ['12', '13', '15'],
    isActive: true,
    sortOrder: 25,
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
    points: 15,
    co2Grams: 500,
    iconName: 'grass',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 26,
  },
  {
    id: 'home_cooked_meal',
    nameEn: 'Cook at Home',
    nameJa: '自炊する',
    nameEs: 'Cocinar en casa',
    descriptionEn:
      'Cook a meal at home instead of '
      + 'ordering takeout',
    descriptionJa:
      'テイクアウトの代わりに自炊する',
    descriptionEs:
      'Cocinar en casa en vez de pedir '
      + 'comida a domicilio',
    category: 'food',
    points: 5,
    co2Grams: 350,
    iconName: 'kitchen',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 27,
  },
  {
    id: 'skip_fish_meal',
    nameEn: 'Skip Fish Meal',
    nameJa: '魚なしの食事',
    nameEs: 'Evitar comida con pescado',
    descriptionEn:
      'Choose a plant-based meal instead '
      + 'of fish',
    descriptionJa:
      '魚の代わりに植物性の食事を選択',
    descriptionEs:
      'Elegir una comida vegetal en vez '
      + 'de pescado',
    category: 'food',
    points: 8,
    co2Grams: 400,
    iconName: 'eco',
    relatedSdgs: ['2', '12', '13', '14'],
    isActive: true,
    sortOrder: 28,
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
    points: 40,
    co2Grams: 7000,
    iconName: 'restaurant',
    relatedSdgs: ['2', '12', '13', '15'],
    isActive: true,
    sortOrder: 29,
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
    points: 5,
    co2Grams: 300,
    iconName: 'takeout',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 30,
  },
  {
    id: 'use_leftovers',
    nameEn: 'Use Leftovers',
    nameJa: '残り物を活用',
    nameEs: 'Aprovechar las sobras',
    descriptionEn:
      'Make a meal from leftovers instead '
      + 'of throwing them out',
    descriptionJa:
      '残り物を捨てずに新しい料理にする',
    descriptionEs:
      'Preparar una comida con sobras en '
      + 'vez de tirarlas',
    category: 'food',
    points: 8,
    co2Grams: 400,
    iconName: 'food_bank',
    relatedSdgs: ['2', '12', '13'],
    isActive: true,
    sortOrder: 31,
  },
  {
    id: 'no_single_use_cutlery',
    nameEn: 'Refuse Disposable Cutlery',
    nameJa: '使い捨てカトラリーを断る',
    nameEs: 'Rechazar cubiertos desechables',
    descriptionEn:
      'Refuse single-use plastic cutlery '
      + 'when ordering food',
    descriptionJa:
      '注文時に使い捨てカトラリーを断る',
    descriptionEs:
      'Rechazar cubiertos de plastico al '
      + 'pedir comida',
    category: 'food',
    points: 1,
    co2Grams: 5,
    iconName: 'restaurant',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 32,
  },
  {
    id: 'drink_tap_water',
    nameEn: 'Drink Tap Water',
    nameJa: '水道水を飲む',
    nameEs: 'Beber agua del grifo',
    descriptionEn:
      'Drink tap water instead of bottled '
      + 'water',
    descriptionJa:
      'ペットボトルの水の代わりに水道水を飲む',
    descriptionEs:
      'Beber agua del grifo en vez de agua '
      + 'embotellada',
    category: 'food',
    points: 3,
    co2Grams: 80,
    iconName: 'local_drink',
    relatedSdgs: ['6', '12', '14'],
    isActive: true,
    sortOrder: 33,
  },
  {
    id: 'reduce_dairy',
    nameEn: 'Skip Dairy Product',
    nameJa: '乳製品なしの食事',
    nameEs: 'Evitar producto lacteo',
    descriptionEn:
      'Choose a plant-based alternative '
      + 'instead of dairy',
    descriptionJa:
      '乳製品の代わりに植物性の代替品を選択',
    descriptionEs:
      'Elegir una alternativa vegetal '
      + 'en vez de lacteos',
    category: 'food',
    points: 8,
    co2Grams: 350,
    iconName: 'eco',
    relatedSdgs: ['12', '13', '15'],
    isActive: true,
    sortOrder: 34,
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
    points: 20,
    co2Grams: 1700,
    iconName: 'dry_cleaning',
    relatedSdgs: ['7', '12', '13'],
    isActive: true,
    sortOrder: 30,
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
    points: 10,
    co2Grams: 600,
    iconName: 'local_laundry_service',
    relatedSdgs: ['6', '7', '12', '13'],
    isActive: true,
    sortOrder: 31,
  },
  {
    id: 'led_bulb',
    nameEn: 'Use LED Lighting',
    nameJa: 'LED照明を使用',
    nameEs: 'Usar iluminacion LED',
    descriptionEn:
      'Use LED bulbs instead of '
      + 'incandescent',
    descriptionJa:
      '白熱電球の代わりにLED照明を使用',
    descriptionEs:
      'Usar bombillas LED en vez de '
      + 'incandescentes',
    category: 'energy',
    points: 3,
    co2Grams: 75,
    iconName: 'lightbulb',
    relatedSdgs: ['7', '12', '13'],
    isActive: true,
    sortOrder: 32,
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
    points: 2,
    co2Grams: 10,
    iconName: 'power',
    relatedSdgs: ['7', '12', '13'],
    isActive: true,
    sortOrder: 33,
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
    points: 2,
    co2Grams: 30,
    iconName: 'lightbulb',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 34,
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
    points: 10,
    co2Grams: 450,
    iconName: 'thermostat',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 35,
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
    points: 8,
    co2Grams: 350,
    iconName: 'thermostat',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 36,
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
    points: 2,
    co2Grams: 20,
    iconName: 'wb_sunny',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 37,
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
    points: 5,
    co2Grams: 300,
    iconName: 'local_laundry_service',
    relatedSdgs: ['6', '7', '12'],
    isActive: true,
    sortOrder: 38,
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
    points: 5,
    co2Grams: 200,
    iconName: 'dishwasher',
    relatedSdgs: ['7', '12', '13'],
    isActive: true,
    sortOrder: 39,
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
    points: 3,
    co2Grams: 150,
    iconName: 'microwave',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 40,
  },
  {
    id: 'close_windows_ac',
    nameEn: 'Close Windows While Using AC',
    nameJa: '冷房使用時に窓を閉める',
    nameEs: 'Cerrar ventanas al usar el aire',
    descriptionEn:
      'Keep windows and doors closed while '
      + 'AC is running',
    descriptionJa:
      '冷暖房使用中は窓やドアを閉める',
    descriptionEs:
      'Mantener ventanas y puertas cerradas '
      + 'con el aire encendido',
    category: 'energy',
    points: 3,
    co2Grams: 100,
    iconName: 'air',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 41,
  },

  // ---------------------------------------------------------
  // CONSUMPTION (15 actions)
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
    points: 2,
    co2Grams: 10,
    iconName: 'shopping_bag',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 40,
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
    points: 3,
    co2Grams: 60,
    iconName: 'coffee',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 41,
  },
  {
    id: 'reusable_water_bottle',
    nameEn: 'Reusable Water Bottle',
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
    points: 5,
    co2Grams: 80,
    iconName: 'water_drop',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 42,
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
    points: 5,
    co2Grams: 100,
    iconName: 'takeout',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 43,
  },
  {
    id: 'refuse_straw',
    nameEn: 'Refuse Plastic Straw',
    nameJa: 'ストローを断る',
    nameEs: 'Rechazar pajita de plastico',
    descriptionEn:
      'Say no to single-use plastic straws',
    descriptionJa:
      '使い捨てプラスチックストローを断る',
    descriptionEs:
      'Decir no a las pajitas de plastico '
      + 'desechables',
    category: 'consumption',
    points: 1,
    co2Grams: 1,
    iconName: 'no_drinks',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 44,
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
    points: 30,
    co2Grams: 13000,
    iconName: 'autorenew',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 45,
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
    points: 20,
    co2Grams: 5000,
    iconName: 'build',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 46,
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
    points: 15,
    co2Grams: 2000,
    iconName: 'handshake',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 47,
  },
  {
    id: 'bar_soap',
    nameEn: 'Use Bar Soap',
    nameJa: '固形石鹸を使用',
    nameEs: 'Usar jabon en barra',
    descriptionEn:
      'Use bar soap instead of liquid soap '
      + 'in a plastic bottle',
    descriptionJa:
      'プラスチック容器の液体石鹸の代わりに'
      + '固形石鹸を使用',
    descriptionEs:
      'Usar jabon en barra en vez de jabon '
      + 'liquido en botella plastica',
    category: 'consumption',
    points: 1,
    co2Grams: 2,
    iconName: 'soap',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 48,
  },
  {
    id: 'digital_receipt',
    nameEn: 'Choose Digital Receipt',
    nameJa: '電子レシートを選択',
    nameEs: 'Elegir recibo digital',
    descriptionEn:
      'Opt for a digital receipt instead of '
      + 'a paper one',
    descriptionJa:
      '紙のレシートの代わりに電子レシートを選択',
    descriptionEs:
      'Optar por recibo digital en vez de '
      + 'uno de papel',
    category: 'consumption',
    points: 1,
    co2Grams: 3,
    iconName: 'smartphone',
    relatedSdgs: ['12', '15'],
    isActive: true,
    sortOrder: 49,
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
    points: 5,
    co2Grams: 85,
    iconName: 'shopping',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 50,
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
    points: 10,
    co2Grams: 500,
    iconName: 'volunteer_activism',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 51,
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
    points: 5,
    co2Grams: 200,
    iconName: 'shopping',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 52,
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
    points: 3,
    co2Grams: 50,
    iconName: 'inventory_2',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 53,
  },
  {
    id: 'use_cloth_napkin',
    nameEn: 'Use Cloth Napkin',
    nameJa: '布ナプキンを使用',
    nameEs: 'Usar servilleta de tela',
    descriptionEn:
      'Use a cloth napkin instead of paper '
      + 'ones',
    descriptionJa:
      '紙ナプキンの代わりに布ナプキンを使用',
    descriptionEs:
      'Usar una servilleta de tela en vez '
      + 'de papel',
    category: 'consumption',
    points: 1,
    co2Grams: 5,
    iconName: 'cleaning_services',
    relatedSdgs: ['12', '15'],
    isActive: true,
    sortOrder: 54,
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
    points: 5,
    co2Grams: 230,
    iconName: 'shower',
    relatedSdgs: ['6', '7', '13'],
    isActive: true,
    sortOrder: 50,
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
    points: 2,
    co2Grams: 30,
    iconName: 'water_drop',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 51,
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
    points: 3,
    co2Grams: 80,
    iconName: 'dishwasher',
    relatedSdgs: ['6', '7'],
    isActive: true,
    sortOrder: 52,
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
    points: 15,
    co2Grams: 500,
    iconName: 'plumbing',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 53,
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
    points: 2,
    co2Grams: 30,
    iconName: 'water_drop',
    relatedSdgs: ['6', '7'],
    isActive: true,
    sortOrder: 54,
  },
  {
    id: 'collect_rainwater',
    nameEn: 'Collect Rainwater',
    nameJa: '雨水を集める',
    nameEs: 'Recolectar agua de lluvia',
    descriptionEn:
      'Use collected rainwater for '
      + 'watering plants',
    descriptionJa:
      '集めた雨水を植物の水やりに使用',
    descriptionEs:
      'Usar agua de lluvia recolectada '
      + 'para regar plantas',
    category: 'water',
    points: 2,
    co2Grams: 15,
    iconName: 'water_drop',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 55,
  },
  {
    id: 'water_plants_morning',
    nameEn: 'Water Plants in Morning',
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
    points: 2,
    co2Grams: 10,
    iconName: 'yard',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 56,
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
    points: 1,
    co2Grams: 5,
    iconName: 'kitchen',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 57,
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
    points: 2,
    co2Grams: 25,
    iconName: 'water_drop',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 58,
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
    points: 8,
    co2Grams: 300,
    iconName: 'shower',
    relatedSdgs: ['6', '7', '13'],
    isActive: true,
    sortOrder: 59,
  },

  // ---------------------------------------------------------
  // COMMUNITY (10 actions)
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
    points: 50,
    co2Grams: 15000,
    iconName: 'forest',
    relatedSdgs: ['13', '15'],
    isActive: true,
    sortOrder: 60,
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
    points: 15,
    co2Grams: 100,
    iconName: 'park',
    relatedSdgs: ['14', '15'],
    isActive: true,
    sortOrder: 61,
  },
  {
    id: 'farmers_market',
    nameEn: 'Visit Farmers Market',
    nameJa: 'ファーマーズマーケットに行く',
    nameEs: 'Visitar mercado de agricultores',
    descriptionEn:
      'Shop at a local farmers market '
      + 'instead of a supermarket',
    descriptionJa:
      'スーパーの代わりに地元のファーマーズ'
      + 'マーケットで買い物',
    descriptionEs:
      'Comprar en un mercado de '
      + 'agricultores local en vez de '
      + 'un supermercado',
    category: 'community',
    points: 5,
    co2Grams: 300,
    iconName: 'storefront',
    relatedSdgs: ['2', '11', '12'],
    isActive: true,
    sortOrder: 62,
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
    points: 3,
    co2Grams: 0,
    iconName: 'share',
    relatedSdgs: ['13'],
    isActive: true,
    sortOrder: 63,
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
    points: 10,
    co2Grams: 200,
    iconName: 'grass',
    relatedSdgs: ['2', '11', '15'],
    isActive: true,
    sortOrder: 64,
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
    points: 15,
    co2Grams: 100,
    iconName: 'volunteer_activism',
    relatedSdgs: ['13', '15'],
    isActive: true,
    sortOrder: 65,
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
    points: 5,
    co2Grams: 0,
    iconName: 'school',
    relatedSdgs: ['4', '13'],
    isActive: true,
    sortOrder: 66,
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
    points: 5,
    co2Grams: 200,
    iconName: 'storefront',
    relatedSdgs: ['8', '12'],
    isActive: true,
    sortOrder: 67,
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
    points: 15,
    co2Grams: 1000,
    iconName: 'groups',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 68,
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
    points: 5,
    co2Grams: 0,
    iconName: 'cleaning_services',
    relatedSdgs: ['11', '14', '15'],
    isActive: true,
    sortOrder: 69,
  },

  // ---------------------------------------------------------
  // ADVOCACY (8 actions) - all NEW
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
    points: 3,
    co2Grams: 0,
    iconName: 'edit_note',
    relatedSdgs: ['13', '16'],
    isActive: true,
    sortOrder: 70,
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
    points: 10,
    co2Grams: 0,
    iconName: 'campaign',
    relatedSdgs: ['13', '16'],
    isActive: true,
    sortOrder: 71,
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
    points: 3,
    co2Grams: 0,
    iconName: 'share',
    relatedSdgs: ['13', '17'],
    isActive: true,
    sortOrder: 72,
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
    points: 15,
    co2Grams: 0,
    iconName: 'campaign',
    relatedSdgs: ['13', '16'],
    isActive: true,
    sortOrder: 73,
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
    points: 10,
    co2Grams: 0,
    iconName: 'balance',
    relatedSdgs: ['7', '13', '16'],
    isActive: true,
    sortOrder: 74,
  },
  {
    id: 'write_eco_review',
    nameEn: 'Write Eco-Friendly Review',
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
    points: 3,
    co2Grams: 0,
    iconName: 'edit_note',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 75,
  },
  {
    id: 'join_eco_group',
    nameEn: 'Join an Eco Group',
    nameJa: '環境団体に加入',
    nameEs: 'Unirse a un grupo ecologico',
    descriptionEn:
      'Join a local or online '
      + 'environmental group',
    descriptionJa:
      '地域またはオンラインの環境団体に加入',
    descriptionEs:
      'Unirse a un grupo ambiental local '
      + 'o en linea',
    category: 'advocacy',
    points: 5,
    co2Grams: 0,
    iconName: 'groups',
    relatedSdgs: ['13', '17'],
    isActive: true,
    sortOrder: 76,
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
    points: 5,
    co2Grams: 0,
    iconName: 'campaign',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 77,
  },

  // ---------------------------------------------------------
  // LEARNING (8 actions) - all NEW, isLearnOnly: true
  // One per missing SDG: 1, 4, 5, 8, 9, 10, 16, 17
  // ---------------------------------------------------------
  {
    id: 'learn_sdg1_no_poverty',
    nameEn: 'Learn: No Poverty (SDG 1)',
    nameJa: '学ぶ：貧困をなくそう（SDG 1）',
    nameEs: 'Aprender: Fin de la pobreza '
      + '(ODS 1)',
    descriptionEn:
      'Learn how sustainability connects '
      + 'to ending poverty worldwide',
    descriptionJa:
      '持続可能性と世界の貧困撲滅の関連を学ぶ',
    descriptionEs:
      'Aprender como la sostenibilidad se '
      + 'relaciona con acabar la pobreza',
    category: 'learning',
    points: 0,
    co2Grams: 0,
    isLearnOnly: true,
    iconName: 'public',
    relatedSdgs: ['1'],
    isActive: true,
    sortOrder: 80,
  },
  {
    id: 'learn_sdg4_education',
    nameEn: 'Learn: Quality Education (SDG 4)',
    nameJa: '学ぶ：質の高い教育（SDG 4）',
    nameEs: 'Aprender: Educacion de calidad '
      + '(ODS 4)',
    descriptionEn:
      'Learn how environmental education '
      + 'improves sustainability outcomes',
    descriptionJa:
      '環境教育が持続可能性に与える影響を学ぶ',
    descriptionEs:
      'Aprender como la educacion ambiental '
      + 'mejora la sostenibilidad',
    category: 'learning',
    points: 0,
    co2Grams: 0,
    isLearnOnly: true,
    iconName: 'school',
    relatedSdgs: ['4'],
    isActive: true,
    sortOrder: 81,
  },
  {
    id: 'learn_sdg5_gender',
    nameEn: 'Learn: Gender Equality (SDG 5)',
    nameJa: '学ぶ：ジェンダー平等（SDG 5）',
    nameEs: 'Aprender: Igualdad de genero '
      + '(ODS 5)',
    descriptionEn:
      'Learn how gender equality is key '
      + 'to climate resilience',
    descriptionJa:
      'ジェンダー平等が気候変動対策に重要な'
      + '理由を学ぶ',
    descriptionEs:
      'Aprender como la igualdad de genero '
      + 'es clave para la resiliencia '
      + 'climatica',
    category: 'learning',
    points: 0,
    co2Grams: 0,
    isLearnOnly: true,
    iconName: 'diversity_3',
    relatedSdgs: ['5'],
    isActive: true,
    sortOrder: 82,
  },
  {
    id: 'learn_sdg8_decent_work',
    nameEn: 'Learn: Decent Work (SDG 8)',
    nameJa: '学ぶ：働きがいと経済成長（SDG 8）',
    nameEs: 'Aprender: Trabajo decente '
      + '(ODS 8)',
    descriptionEn:
      'Learn how green jobs drive '
      + 'sustainable economic growth',
    descriptionJa:
      'グリーン雇用が持続可能な経済成長を'
      + '推進する仕組みを学ぶ',
    descriptionEs:
      'Aprender como los empleos verdes '
      + 'impulsan el crecimiento sostenible',
    category: 'learning',
    points: 0,
    co2Grams: 0,
    isLearnOnly: true,
    iconName: 'work',
    relatedSdgs: ['8'],
    isActive: true,
    sortOrder: 83,
  },
  {
    id: 'learn_sdg9_infrastructure',
    nameEn: 'Learn: Innovation (SDG 9)',
    nameJa: '学ぶ：産業と技術革新（SDG 9）',
    nameEs: 'Aprender: Innovacion (ODS 9)',
    descriptionEn:
      'Learn how sustainable infrastructure '
      + 'reduces emissions',
    descriptionJa:
      '持続可能なインフラが排出削減に繋がる'
      + '仕組みを学ぶ',
    descriptionEs:
      'Aprender como la infraestructura '
      + 'sostenible reduce emisiones',
    category: 'learning',
    points: 0,
    co2Grams: 0,
    isLearnOnly: true,
    iconName: 'engineering',
    relatedSdgs: ['9'],
    isActive: true,
    sortOrder: 84,
  },
  {
    id: 'learn_sdg10_inequality',
    nameEn: 'Learn: Reduced Inequality '
      + '(SDG 10)',
    nameJa: '学ぶ：人や国の不平等を'
      + 'なくそう（SDG 10）',
    nameEs: 'Aprender: Reducir desigualdades '
      + '(ODS 10)',
    descriptionEn:
      'Learn how climate change '
      + 'disproportionately affects '
      + 'vulnerable communities',
    descriptionJa:
      '気候変動が脆弱なコミュニティに与える'
      + '不均等な影響を学ぶ',
    descriptionEs:
      'Aprender como el cambio climatico '
      + 'afecta desproporcionadamente a '
      + 'comunidades vulnerables',
    category: 'learning',
    points: 0,
    co2Grams: 0,
    isLearnOnly: true,
    iconName: 'balance',
    relatedSdgs: ['10'],
    isActive: true,
    sortOrder: 85,
  },
  {
    id: 'learn_sdg16_peace_justice',
    nameEn: 'Learn: Peace & Justice (SDG 16)',
    nameJa: '学ぶ：平和と公正（SDG 16）',
    nameEs: 'Aprender: Paz y justicia '
      + '(ODS 16)',
    descriptionEn:
      'Learn how strong institutions '
      + 'support climate action',
    descriptionJa:
      '強固な制度が気候変動対策を支える仕組み'
      + 'を学ぶ',
    descriptionEs:
      'Aprender como instituciones fuertes '
      + 'apoyan la accion climatica',
    category: 'learning',
    points: 0,
    co2Grams: 0,
    isLearnOnly: true,
    iconName: 'balance',
    relatedSdgs: ['16'],
    isActive: true,
    sortOrder: 86,
  },
  {
    id: 'learn_sdg17_partnerships',
    nameEn: 'Learn: Partnerships (SDG 17)',
    nameJa: '学ぶ：パートナーシップ（SDG 17）',
    nameEs: 'Aprender: Alianzas (ODS 17)',
    descriptionEn:
      'Learn how global partnerships '
      + 'accelerate sustainability goals',
    descriptionJa:
      'グローバルなパートナーシップが持続可能な'
      + '目標を加速させる仕組みを学ぶ',
    descriptionEs:
      'Aprender como las alianzas globales '
      + 'aceleran los objetivos de '
      + 'sostenibilidad',
    category: 'learning',
    points: 0,
    co2Grams: 0,
    isLearnOnly: true,
    iconName: 'handshake',
    relatedSdgs: ['17'],
    isActive: true,
    sortOrder: 87,
  },
];

async function seedActionLibrary() {
  console.log('Seeding actionLibrary collection...\n');
  console.log(`Total actions: ${actions.length}\n`);

  const batch = db.batch();

  for (const action of actions) {
    const { id, ...data } = action;
    const docRef = db
      .collection('actionLibrary')
      .doc(id);
    batch.set(docRef, {
      isLearnOnly: false,
      ...data,
    });
    const co2Display = action.co2Grams >= 1000
      ? `${(action.co2Grams / 1000).toFixed(1)}kg`
      : `${action.co2Grams}g`;
    console.log(
      `  + ${action.nameEn} `
      + `(${action.points} pts, `
      + `${co2Display} CO2)`,
    );
  }

  await batch.commit();
  console.log(
    `\nSuccessfully seeded ${actions.length} actions!`,
  );
}

seedActionLibrary()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Error seeding data:', error);
    process.exit(1);
  });
