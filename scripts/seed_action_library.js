#!/usr/bin/env node

/**
 * Seeds the Firestore actionLibrary collection with sample eco-actions.
 *
 * Usage:
 *   1. Set up Firebase Admin SDK credentials:
 *      - Go to Firebase Console > Project Settings > Service Accounts
 *      - Click "Generate New Private Key" and save as serviceAccountKey.json in the scripts folder
 *   2. Run: node scripts/seed_action_library.js
 */

const admin = require('firebase-admin');
const path = require('path');

// Initialize Firebase Admin
const serviceAccountPath = path.join(__dirname, 'serviceAccountKey.json');

try {
  const serviceAccount = require(serviceAccountPath);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
} catch (error) {
  console.error('Error: Could not find serviceAccountKey.json');
  console.error('Please download it from Firebase Console > Project Settings > Service Accounts');
  console.error(`Expected location: ${serviceAccountPath}`);
  process.exit(1);
}

const db = admin.firestore();

// Action library seed data
const actions = [
  // Recycling category
  {
    id: 'recycle_aluminum_can',
    nameEn: 'Recycle Aluminum Can',
    nameJa: 'アルミ缶をリサイクル',
    descriptionEn: 'Recycle an aluminum can instead of throwing it away',
    descriptionJa: 'アルミ缶をゴミ箱に捨てずにリサイクル',
    category: 'recycling',
    points: 5,
    co2Grams: 150,
    iconName: 'recycling',
    relatedSdgs: ['12', '13'],
    isActive: true,
    sortOrder: 1,
  },
  {
    id: 'recycle_plastic_bottle',
    nameEn: 'Recycle Plastic Bottle',
    nameJa: 'ペットボトルをリサイクル',
    descriptionEn: 'Recycle a plastic bottle properly',
    descriptionJa: 'ペットボトルを正しくリサイクル',
    category: 'recycling',
    points: 3,
    co2Grams: 80,
    iconName: 'recycling',
    relatedSdgs: ['12', '14'],
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
    points: 2,
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
    descriptionEn: 'Compost food scraps instead of throwing them away',
    descriptionJa: '生ゴミを捨てずにコンポストへ',
    category: 'recycling',
    points: 15,
    co2Grams: 200,
    iconName: 'compost',
    relatedSdgs: ['12', '13', '15'],
    isActive: true,
    sortOrder: 4,
  },

  // Transport category
  {
    id: 'bike_short_trip',
    nameEn: 'Bike Short Trip',
    nameJa: '近距離を自転車で移動',
    descriptionEn: 'Use a bike instead of a car for a short trip (under 3km)',
    descriptionJa: '短距離（3km未満）の移動に車の代わりに自転車を使用',
    category: 'transport',
    points: 20,
    co2Grams: 500,
    iconName: 'pedal_bike',
    relatedSdgs: ['3', '11', '13'],
    isActive: true,
    sortOrder: 10,
  },
  {
    id: 'bike_medium_trip',
    nameEn: 'Bike Medium Trip',
    nameJa: '中距離を自転車で移動',
    descriptionEn: 'Use a bike instead of a car for a medium trip (3-10km)',
    descriptionJa: '中距離（3-10km）の移動に車の代わりに自転車を使用',
    category: 'transport',
    points: 50,
    co2Grams: 1500,
    iconName: 'pedal_bike',
    relatedSdgs: ['3', '11', '13'],
    isActive: true,
    sortOrder: 11,
  },
  {
    id: 'public_transit',
    nameEn: 'Take Public Transit',
    nameJa: '公共交通機関を利用',
    descriptionEn: 'Use public transit instead of driving',
    descriptionJa: '車の代わりに公共交通機関を利用',
    category: 'transport',
    points: 30,
    co2Grams: 800,
    iconName: 'train',
    relatedSdgs: ['11', '13'],
    isActive: true,
    sortOrder: 12,
  },
  {
    id: 'walk_instead_drive',
    nameEn: 'Walk Instead of Drive',
    nameJa: '車の代わりに徒歩',
    descriptionEn: 'Walk to your destination instead of driving',
    descriptionJa: '車を使わずに目的地まで歩く',
    category: 'transport',
    points: 15,
    co2Grams: 400,
    iconName: 'directions_walk',
    relatedSdgs: ['3', '11', '13'],
    isActive: true,
    sortOrder: 13,
  },

  // Food category
  {
    id: 'meatless_meal',
    nameEn: 'Meatless Meal',
    nameJa: '肉なしの食事',
    descriptionEn: 'Choose a vegetarian or vegan meal',
    descriptionJa: 'ベジタリアンまたはビーガンの食事を選択',
    category: 'food',
    points: 20,
    co2Grams: 2500,
    iconName: 'eco',
    relatedSdgs: ['2', '12', '13'],
    isActive: true,
    sortOrder: 20,
  },
  {
    id: 'local_produce',
    nameEn: 'Buy Local Produce',
    nameJa: '地元の農産物を購入',
    descriptionEn: 'Buy locally grown fruits or vegetables',
    descriptionJa: '地元で栽培された野菜や果物を購入',
    category: 'food',
    points: 10,
    co2Grams: 300,
    iconName: 'storefront',
    relatedSdgs: ['2', '12'],
    isActive: true,
    sortOrder: 21,
  },
  {
    id: 'no_food_waste',
    nameEn: 'Zero Food Waste Day',
    nameJa: '食品ロスゼロの日',
    descriptionEn: 'Finish all food with no waste today',
    descriptionJa: '今日は食べ残しゼロを達成',
    category: 'food',
    points: 25,
    co2Grams: 1000,
    iconName: 'food_bank',
    relatedSdgs: ['2', '12'],
    isActive: true,
    sortOrder: 22,
  },

  // Energy category
  {
    id: 'air_dry_clothes',
    nameEn: 'Air Dry Clothes',
    nameJa: '洗濯物を自然乾燥',
    descriptionEn: 'Air dry clothes instead of using a dryer',
    descriptionJa: '乾燥機を使わずに洗濯物を自然乾燥',
    category: 'energy',
    points: 10,
    co2Grams: 400,
    iconName: 'dry_cleaning',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 30,
  },
  {
    id: 'unplug_devices',
    nameEn: 'Unplug Unused Devices',
    nameJa: '未使用機器のプラグを抜く',
    descriptionEn: 'Unplug electronic devices when not in use',
    descriptionJa: '使用していない電子機器のコンセントを抜く',
    category: 'energy',
    points: 3,
    co2Grams: 50,
    iconName: 'power_off',
    relatedSdgs: ['7', '12', '13'],
    isActive: true,
    sortOrder: 31,
  },
  {
    id: 'turn_off_lights',
    nameEn: 'Turn Off Lights',
    nameJa: '電気を消す',
    descriptionEn: 'Turn off lights when leaving a room',
    descriptionJa: '部屋を出る時に電気を消す',
    category: 'energy',
    points: 2,
    co2Grams: 30,
    iconName: 'lightbulb',
    relatedSdgs: ['7', '13'],
    isActive: true,
    sortOrder: 32,
  },
  {
    id: 'cold_wash',
    nameEn: 'Cold Water Laundry',
    nameJa: '冷水で洗濯',
    descriptionEn: 'Wash clothes in cold water instead of hot',
    descriptionJa: 'お湯ではなく冷水で洗濯',
    category: 'energy',
    points: 8,
    co2Grams: 200,
    iconName: 'local_laundry_service',
    relatedSdgs: ['6', '7', '13'],
    isActive: true,
    sortOrder: 33,
  },

  // Consumption category
  {
    id: 'reusable_bag',
    nameEn: 'Use Reusable Bag',
    nameJa: 'エコバッグを使用',
    descriptionEn: 'Use a reusable shopping bag instead of plastic',
    descriptionJa: 'レジ袋の代わりにエコバッグを使用',
    category: 'consumption',
    points: 2,
    co2Grams: 20,
    iconName: 'shopping_bag',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 40,
  },
  {
    id: 'reusable_cup',
    nameEn: 'Use Reusable Cup',
    nameJa: 'マイカップを使用',
    descriptionEn: 'Bring your own reusable cup for coffee or drinks',
    descriptionJa: 'コーヒーや飲み物にマイカップを持参',
    category: 'consumption',
    points: 5,
    co2Grams: 60,
    iconName: 'coffee',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 41,
  },
  {
    id: 'bring_own_container',
    nameEn: 'Bring Own Container',
    nameJa: 'マイ容器を持参',
    descriptionEn: 'Use your own container for takeout food',
    descriptionJa: 'テイクアウト用にマイ容器を持参',
    category: 'consumption',
    points: 10,
    co2Grams: 100,
    iconName: 'takeout_dining',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 42,
  },
  {
    id: 'refuse_straw',
    nameEn: 'Refuse Plastic Straw',
    nameJa: 'プラスチックストローを断る',
    descriptionEn: 'Say no to plastic straws',
    descriptionJa: 'プラスチックストローを断る',
    category: 'consumption',
    points: 2,
    co2Grams: 5,
    iconName: 'no_drinks',
    relatedSdgs: ['12', '14'],
    isActive: true,
    sortOrder: 43,
  },
  {
    id: 'buy_secondhand',
    nameEn: 'Buy Secondhand',
    nameJa: '中古品を購入',
    descriptionEn: 'Buy a secondhand item instead of new',
    descriptionJa: '新品ではなく中古品を購入',
    category: 'consumption',
    points: 30,
    co2Grams: 3000,
    iconName: 'autorenew',
    relatedSdgs: ['12'],
    isActive: true,
    sortOrder: 44,
  },

  // Water category
  {
    id: 'shorter_shower',
    nameEn: 'Take Shorter Shower',
    nameJa: 'シャワーを短く',
    descriptionEn: 'Reduce shower time by 2+ minutes',
    descriptionJa: 'シャワーの時間を2分以上短縮',
    category: 'water',
    points: 5,
    co2Grams: 100,
    iconName: 'shower',
    relatedSdgs: ['6', '13'],
    isActive: true,
    sortOrder: 50,
  },
  {
    id: 'turn_off_tap',
    nameEn: 'Turn Off Tap While Brushing',
    nameJa: '歯磨き中に水を止める',
    descriptionEn: 'Turn off the tap while brushing teeth',
    descriptionJa: '歯を磨いている間は水を止める',
    category: 'water',
    points: 3,
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
    descriptionEn: 'Only run dishwasher when full',
    descriptionJa: '食洗機は満杯になってから回す',
    category: 'water',
    points: 5,
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
    descriptionEn: 'Fix a dripping tap or water leak',
    descriptionJa: '水漏れや蛇口のポタポタを修理',
    category: 'water',
    points: 50,
    co2Grams: 500,
    iconName: 'plumbing',
    relatedSdgs: ['6'],
    isActive: true,
    sortOrder: 53,
  },
];

async function seedActionLibrary() {
  console.log('Seeding actionLibrary collection...\n');

  const batch = db.batch();

  for (const action of actions) {
    const { id, ...data } = action;
    const docRef = db.collection('actionLibrary').doc(id);
    batch.set(docRef, data);
    console.log(`  + ${action.nameEn} (${action.points} pts)`);
  }

  await batch.commit();
  console.log(`\n✅ Successfully seeded ${actions.length} actions!`);
}

seedActionLibrary()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Error seeding data:', error);
    process.exit(1);
  });
