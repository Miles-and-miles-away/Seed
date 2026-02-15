#!/usr/bin/env node

/**
 * Extracts SDG target codes and short descriptions
 * from the full indicator metadata JSONs into a
 * compact asset file for the app.
 *
 * Input:  Plan/sdg_indicator_metadata/sdg_goal_*.json
 * Output: assets/data/sdg_targets.json (~15-20KB)
 *
 * Usage: node scripts/extract_sdg_targets.js
 */

const fs = require('fs');
const path = require('path');

const INPUT_DIR = path.join(
  __dirname,
  '..',
  'Plan',
  'sdg_indicator_metadata',
);
const OUTPUT_FILE = path.join(
  __dirname,
  '..',
  'assets',
  'data',
  'sdg_targets.json',
);
const GOAL_COUNT = 17;

function extractDescription(targetText) {
  // Strip "Target X.X: " prefix
  const match = targetText.match(
    /^Target \d+\.\w+:\s*(.+)$/,
  );
  return match ? match[1] : targetText;
}

function main() {
  const result = {};

  for (let i = 1; i <= GOAL_COUNT; i++) {
    const padded = String(i).padStart(2, '0');
    const filePath = path.join(
      INPUT_DIR,
      `sdg_goal_${padded}.json`,
    );

    if (!fs.existsSync(filePath)) {
      console.error(`Missing: ${filePath}`);
      continue;
    }

    const raw = fs.readFileSync(filePath, 'utf8');
    const data = JSON.parse(raw);
    const targets = [];

    for (const t of data.targets || []) {
      targets.push({
        code: t.target_code,
        description: extractDescription(t.target),
      });
    }

    result[String(i)] = targets;
    console.log(
      `  Goal ${i}: ${targets.length} targets`,
    );
  }

  // Ensure output directory exists
  const outputDir = path.dirname(OUTPUT_FILE);
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  fs.writeFileSync(
    OUTPUT_FILE,
    JSON.stringify(result, null, 2),
  );

  const size = fs.statSync(OUTPUT_FILE).size;
  const kb = (size / 1024).toFixed(1);
  console.log(
    `\nWrote ${OUTPUT_FILE} (${kb} KB)`,
  );
}

main();
