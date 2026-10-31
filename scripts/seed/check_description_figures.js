#!/usr/bin/env node
// Each CO2 action's long description bolds co2_grams once, as displayed.
const path = require('path');

const descriptions = require('./action_long_descriptions.js');
const { actions } = require(
  path.join(__dirname, '..', '..', 'data', 'seed', 'co2_actions_database.json'),
);

const LANGS = ['en', 'ja', 'es'];
const GRAMS_PER_UNIT = {
  g: 1, kg: 1e3, tonne: 1e6, tonnes: 1e6, トン: 1e6, tonelada: 1e6, toneladas: 1e6,
};
const NUMBER = {
  en: /^(\d{1,3}(?:,\d{3})*)(?:\.(\d+))?$/,
  ja: /^(\d{1,3}(?:,\d{3})*)(?:\.(\d+))?$/,
  es: /^(\d{1,3}(?:\.\d{3})*)(?:,(\d+))?$/,
};
const UNIT = {
  en: '(g|kg|tonnes?)',
  ja: '(g|kg|トン)',
  es: '(g|kg|toneladas?)',
};
const BOLD = /\*\*(.+?)\*\*/g;
const MASS_UNIT = '(?:g|kg|t|tonnes?|トン|toneladas?)';
const MASS = new RegExp(`\\d ?${MASS_UNIT}(?![\\p{L}\\p{N}])`, 'u');
const BRACKET_RESTATEMENT = new RegExp(
  `${MASS.source}(?:\\*\\*)?\\s*[(（]\\s*[\\d.,]+ ?${MASS_UNIT}[)）]`,
  'u',
);
const LINK_TARGET = /\]\([^)]*\)/g;
const SENTENCE_END = { en: /[.!?](?=\s|$)/, ja: /。/, es: /[.!?](?=\s|$)/ };

// co2_grams as formatCO2Compact shows it: one decimal in t or kg, whole g.
function displayedGrams(co2) {
  const tenthsOfKg = Math.round(co2 / 100);
  if (tenthsOfKg >= 10000) return Math.round(co2 / 1e5) * 1e5;
  if (co2 >= 1000) return tenthsOfKg * 100;
  return co2;
}

// The bold must equal co2_grams at the precision the app displays it.
function boldError(lang, bold, co2) {
  const match = bold.match(new RegExp(`^([\\d.,]+) ?${UNIT[lang]}$`));
  const number = match && match[1].match(NUMBER[lang]);
  if (!number) return 'malformed figure';
  const value = Number(`${number[1].replace(/[.,]/g, '')}.${number[2] || 0}`);
  const grams = Math.round(value * GRAMS_PER_UNIT[match[2]]);
  const expected = displayedGrams(co2);
  return grams === expected ? null : `is ${grams} g, the app displays ${expected} g`;
}

function firstSentenceEnd(lang, text) {
  const plain = text.replace(LINK_TARGET, ']');
  const end = plain.search(SENTENCE_END[lang]);
  return end < 0 ? plain.length : end;
}

const failures = [];
for (const { action_id: id, co2_grams: co2 } of actions) {
  if (!Number.isInteger(co2) || co2 < 0) {
    failures.push(`${id}: co2_grams ${co2}`);
    continue;
  }
  for (const lang of LANGS) {
    const text = (descriptions[id] && descriptions[id][lang]) || '';
    const fail = (why) => failures.push(`${id}.${lang}: ${why}`);
    if (BRACKET_RESTATEMENT.test(text)) fail('bracket restatement');
    const bolds = [...text.matchAll(BOLD)];
    if (!co2) {
      if (bolds.some((bold) => MASS.test(bold[1]))) fail('CO2 figure, no co2_grams');
      continue;
    }
    if (bolds.length !== 1) {
      fail(`${bolds.length} bold runs`);
      continue;
    }
    const [run, bold] = bolds[0];
    const plainIndex = text.slice(0, bolds[0].index).replace(LINK_TARGET, ']').length;
    if (plainIndex >= firstSentenceEnd(lang, text)) fail('bold after first sentence');
    const error = boldError(lang, bold, co2);
    if (error) fail(`${run} ${error}, co2_grams ${co2}`);
  }
}

for (const failure of failures) console.log(failure);
console.log(failures.length ? `${failures.length} problems` : 'OK');
process.exit(failures.length ? 1 : 0);
