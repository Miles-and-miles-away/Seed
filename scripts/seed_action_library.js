#!/usr/bin/env node

/**
 * Seeds the Firestore actionLibrary collection with researched eco-actions.
 *
 * CO2 values are based on peer-reviewed research and government data.
 * See Plan/co2_actions_database.json for sources and methodology.
 *
 * Usage:
 *   1. Set up Firebase Admin SDK credentials:
 *      - Go to Firebase Console > Project Settings > Service Accounts
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
  console.error(`Expected location: ${serviceAccountPath}`);
  process.exit(1);
}

const db = admin.firestore();

// =================================================================
// Action library seed data
// CO2 values sourced from DEFRA 2024, EPA, Poore & Nemecek (2018),
// Our World in Data, and other tier-1 sources.
// Per-action values derived from per-unit research data with
// practical usage assumptions noted in descriptions.
// =================================================================
const actions = [
  // ---------------------------------------------------------------
  // RECYCLING (5 actions)
  // ---------------------------------------------------------------
  {
    id: 'recycle_aluminum_can',
    nameEn: 'Recycle Aluminum Can',
    nameJa: 'アルミ缶をリサイクル',
    descriptionEn:
      'Recycle an aluminum can instead of throwing it away',
    descriptionJa:
      'アルミ缶をゴミ箱に捨てずにリサイクル',
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
    descriptionEn: 'Recycle a PET plastic bottle properly',
    descriptionJa: 'ペットボトルを正しくリサイクル',
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
    descriptionEn: 'Flatten and recycle cardboard boxes',
    descriptionJa: '段ボール箱を潰してリサイクル',
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
    descriptionEn:
      'Compost food scraps instead of sending to landfill',
    descriptionJa:
      '生ゴミをゴミ箱ではなくコンポストへ',
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
    descriptionEn:
      'Recycle glass jars and bottles instead of trashing',
    descriptionJa:
      'ガラス瓶をゴミ箱ではなくリサイクルへ',
    category: 'recycling',
    points: 3,
    co2Grams: 40,
    iconName: 'recycling',
    relatedSdgs: ['12'],
    isActive: true,
    sortOrder: 5,
  },

  // ---------------------------------------------------------------
  // TRANSPORT (7 actions)
  // Research: DEFRA 2024 petrol car avg 164g CO2/km
  // ---------------------------------------------------------------
  {
    id: 'walk_instead_drive',
    nameEn: 'Walk Instead of Drive',
    nameJa: '車の代わりに徒歩',
    descriptionEn:
      'Walk to your destination instead of driving',
    descriptionJa:
      '車を使わずに目的地まで歩く',
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
    descriptionEn:
      'Bike instead of drive for a short trip (under 3km)',
    descriptionJa:
      '短距離（3km未満）の移動に車の代わりに自転車を使用',
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
    descriptionEn:
      'Bike instead of drive for a medium trip (3-10km)',
    descriptionJa:
      '中距離（3-10km）の移動に車の代わりに自転車を使用',
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
    descriptionEn:
      'Take bus or train instead of driving',
    descriptionJa:
      '車の代わりにバスや電車を利用',
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
    descriptionEn:
      'Share a ride instead of driving alone',
    descriptionJa:
      '一人で運転する代わりに相乗りする',
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
    descriptionEn:
      'Drive an EV instead of a gasoline car',
    descriptionJa:
      'ガソリン車の代わりに電気自動車を使用',
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
    descriptionEn:
      'Take a train instead of a short-haul flight',
    descriptionJa:
      '短距離フライトの代わりに電車を利用',
    category: 'transport',
    points: 100,
    co2Grams: 110000,
    iconName: 'train',
    relatedSdgs: ['13'],
    isActive: true,
    sortOrder: 16,
  },

  // ---------------------------------------------------------------
  // FOOD (6 actions)
  // Research: Poore & Nemecek 2018, Our World in Data, EPA
  // ---------------------------------------------------------------
  {
    id: 'meatless_meal_beef',
    nameEn: 'Skip Beef Meal',
    nameJa: '牛肉なしの食事',
    descriptionEn:
      'Choose a plant-based meal instead of beef',
    descriptionJa:
      '牛肉の代わりに植物性の食事を選択',
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
    descriptionEn:
      'Choose a plant-based meal instead of chicken',
    descriptionJa:
      '鶏肉の代わりに植物性の食事を選択',
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
    descriptionEn:
      'Choose a plant-based meal instead of pork',
    descriptionJa:
      '豚肉の代わりに植物性の食事を選択',
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
    descriptionEn:
      'Finish all food today with no waste',
    descriptionJa:
      '今日は食べ残しゼロを達成',
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
    descriptionEn:
      'Buy locally grown fruits or vegetables',
    descriptionJa:
      '地元で栽培された野菜や果物を購入',
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
    descriptionEn:
      'Choose plant-based milk instead of dairy',
    descriptionJa:
      '乳製品の代わりに植物性ミルクを選択',
    category: 'food',
    points: 10,
    co2Grams: 460,
    iconName: 'local_cafe',
    relatedSdgs: ['12', '13', '15'],
    isActive: true,
    sortOrder: 25,
  },

  // ---------------------------------------------------------------
  // ENERGY (5 actions)
  // Research: DEFRA, US DOE, Energy Saving Trust
  // ---------------------------------------------------------------
  {
    id: 'air_dry_clothes',
    nameEn: 'Air Dry Clothes',
    nameJa: '洗濯物を自然乾燥',
    descriptionEn:
      'Air dry clothes instead of using a tumble dryer',
    descriptionJa:
      '乾燥機を使わずに洗濯物を自然乾燥',
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
    descriptionEn:
      'Wash clothes in cold water instead of hot',
    descriptionJa:
      'お湯ではなく冷水で洗濯',
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
    descriptionEn:
      'Use LED bulbs instead of incandescent',
    descriptionJa:
      '白熱電球の代わりにLED照明を使用',
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
    descriptionEn:
      'Unplug electronic devices when not in use',
    descriptionJa:
      '使用していない電子機器のコンセントを抜く',
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
    descriptionEn:
      'Turn off lights when leaving a room',
    descriptionJa:
      '部屋を出る時に電気を消す',
    category: 'energy',
    points: 2,
    co2Grams: 30,
    iconName: 'lightbulb',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 34,
  },

  // ---------------------------------------------------------------
  // CONSUMPTION (6 actions)
  // Research: Danish EPA LCA, WRAP UK, Carbon Trust
  // ---------------------------------------------------------------
  {
    id: 'reusable_bag',
    nameEn: 'Use Reusable Bag',
    nameJa: 'エコバッグを使用',
    descriptionEn:
      'Use a reusable shopping bag instead of plastic',
    descriptionJa:
      'レジ袋の代わりにエコバッグを使用',
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
    descriptionEn:
      'Bring your own reusable cup for drinks',
    descriptionJa:
      '飲み物にマイカップを持参',
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
    descriptionEn:
      'Use a reusable bottle instead of single-use plastic',
    descriptionJa:
      '使い捨てペットボトルの代わりにマイボトルを使用',
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
    descriptionEn:
      'Use your own container for takeout food',
    descriptionJa:
      'テイクアウト用にマイ容器を持参',
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
    descriptionEn:
      'Say no to single-use plastic straws',
    descriptionJa:
      '使い捨てプラスチックストローを断る',
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
    descriptionEn:
      'Buy secondhand clothing instead of new',
    descriptionJa:
      '新品ではなく中古の衣類を購入',
    category: 'consumption',
    points: 30,
    co2Grams: 13000,
    iconName: 'autorenew',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 45,
  },

  // ---------------------------------------------------------------
  // WATER (4 actions)
  // Research: co2data.org, Yarra Valley Water
  // ---------------------------------------------------------------
  {
    id: 'shorter_shower',
    nameEn: 'Take Shorter Shower',
    nameJa: 'シャワーを短く',
    descriptionEn:
      'Reduce shower time by 2+ minutes',
    descriptionJa:
      'シャワーの時間を2分以上短縮',
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
    descriptionEn:
      'Turn off the tap while brushing teeth',
    descriptionJa:
      '歯を磨いている間は水を止める',
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
    descriptionEn:
      'Only run the dishwasher when full',
    descriptionJa:
      '食洗機は満杯になってから回す',
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
    descriptionEn:
      'Fix a dripping tap or water leak',
    descriptionJa:
      '水漏れや蛇口のポタポタを修理',
    category: 'water',
    points: 15,
    co2Grams: 500,
    iconName: 'plumbing',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 53,
  },

  // ---------------------------------------------------------------
  // COMMUNITY (1 action)
  // Research: EPA greenhouse gas equivalencies
  // ---------------------------------------------------------------
  {
    id: 'tree_planting',
    nameEn: 'Plant a Tree',
    nameJa: '木を植える',
    descriptionEn:
      'Plant a tree to absorb CO2 for years to come',
    descriptionJa:
      'CO2を吸収する木を植える',
    category: 'community',
    points: 50,
    co2Grams: 15000,
    iconName: 'forest',
    relatedSdgs: ['13', '15'],
    isActive: true,
    sortOrder: 60,
  },
];

async function seedActionLibrary() {
  console.log('Seeding actionLibrary collection...\n');
  console.log(`Total actions: ${actions.length}\n`);

  const batch = db.batch();

  for (const action of actions) {
    const { id, ...data } = action;
    const docRef = db.collection('actionLibrary').doc(id);
    batch.set(docRef, {
      isLearnOnly: false,
      ...data,
    });
    const co2Display = action.co2Grams >= 1000
      ? `${(action.co2Grams / 1000).toFixed(1)}kg`
      : `${action.co2Grams}g`;
    console.log(
      `  + ${action.nameEn} `
      + `(${action.points} pts, ${co2Display} CO2)`,
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
