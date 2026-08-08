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
// ===========================================================
// Action library data
//
// SINGLE SOURCE OF TRUTH: data/seed/co2_actions_database.json
//
// This script no longer carries an inline action array. The JSON
// holds every shipping action with its CO2 value, calculation
// notes, research sources and the effort/frequency/impact scores;
// points are computed here at seed time by computePoints().
//
// Grid factor 458 g CO2e/kWh (Ember GER 2026), gas 182 g CO2e/kWh
// (DEFRA 2026, Gross CV). See Plan/AUDIT_ACTION_DATA.md section 8.
// ===========================================================
const ACTION_DATA_PATH = path.join(
  __dirname,
  '..',
  '..',
  'data',
  'seed',
  'co2_actions_database.json',
);

/** Maps a snake_case record from the JSON to the camelCase shape
 * seeded into Firestore. Research-only fields (calculation_notes,
 * sources, confidence, provenance_research_id) are deliberately
 * not seeded -- they document the value, they are not app data. */
function toActionDoc(r) {
  return {
    id: r.action_id,
    nameEn: r.name_en,
    nameJa: r.name_ja,
    nameEs: r.name_es,
    descriptionEn: r.description_en,
    descriptionJa: r.description_ja,
    descriptionEs: r.description_es,
    category: r.category,
    co2Grams: r.co2_grams,
    effort: r.effort,
    frequency: r.frequency,
    impact: r.impact,
    iconName: r.icon_name,
    relatedSdgs: r.related_sdgs,
    isActive: r.is_active,
    sortOrder: r.sort_order,
  };
}

const actionDatabase = require(ACTION_DATA_PATH);
const actions = actionDatabase.actions.map(toActionDoc);

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
