#!/usr/bin/env node
// Fixes missing Spanish diacritics in action
// description files. Only modifies es: string blocks.
const fs = require('fs');
const path = require('path');

// NOTE: merge_translations_es.py keeps a sibling table tuned for the
// eco-fact corpus. When adding a word here, consider whether it
// belongs there too.
const REPLACEMENTS = [
  // --- n-tilde words ---
  [/\bano\b/g, 'año'],
  [/\banos\b/g, 'años'],
  [/\bbano\b/g, 'baño'],
  [/\bbanos\b/g, 'baños'],
  [/\bmanana\b/g, 'mañana'],
  [/\bpequeno\b/g, 'pequeño'],
  [/\bpequenos\b/g, 'pequeños'],
  [/\bPequenos\b/g, 'Pequeños'],
  [/\bpequena\b/g, 'pequeña'],
  [/\bpequenas\b/g, 'pequeñas'],
  [/\bnino\b/g, 'niño'],
  [/\bninos\b/g, 'niños'],
  [/\bsenor\b/g, 'señor'],
  [/\bsenal\b/g, 'señal'],
  [/\bresena\b/g, 'reseña'],
  [/\bresenas\b/g, 'reseñas'],
  [/\bEnsenar\b/g, 'Enseñar'],
  [/\bensenar\b/g, 'enseñar'],
  [/\bensenanza\b/g, 'enseñanza'],
  [/\bcompaneros\b/g, 'compañeros'],
  [/\bcompaneras\b/g, 'compañeras'],
  [/\bdano\b/g, 'daño'],
  [/\bdanos\b/g, 'daños'],
  [/\bdanan\b/g, 'dañan'],
  [/\btamano\b/g, 'tamaño'],
  [/\bespanol\b/g, 'español'],
  [/\bespanola\b/g, 'española'],
  [/\bempeno\b/g, 'empeño'],
  [/\bDiseno\b/g, 'Diseño'],
  [/\bdiseno\b/g, 'diseño'],
  [/\bdueno\b/g, 'dueño'],
  [/\bcampanas\b/g, 'campañas'],
  [/\bCampanas\b/g, 'Campañas'],
  // --- a-acute words ---
  [/\bmas\b/g, 'más'],
  [/\bMas\b/g, 'Más'],
  [/\bademas\b/g, 'además'],
  [/\bAdemas\b/g, 'Además'],
  [/\bestan\b/g, 'están'],
  [/\bestaras\b/g, 'estarás'],
  [/\bhabito\b/g, 'hábito'],
  [/\bhabitos\b/g, 'hábitos'],
  [/\bhabitat\b/g, 'hábitat'],
  [/\bbasicos\b/g, 'básicos'],
  [/\bbasica\b/g, 'básica'],
  [/\bbasico\b/g, 'básico'],
  [/\bpractico\b/g, 'práctico'],
  [/\bpractica\b/g, 'práctica'],
  [/\bpracticas\b/g, 'prácticas'],
  [/\brapido\b/g, 'rápido'],
  [/\brapida\b/g, 'rápida'],
  [/\brapidamente\b/g, 'rápidamente'],
  [/\barbol\b/g, 'árbol'],
  [/\barboles\b/g, 'árboles'],
  [/\bcarton\b/g, 'cartón'],
  [/\bmaquina\b/g, 'máquina'],
  [/\bmaquinas\b/g, 'máquinas'],
  [/\batmosfera\b/g, 'atmósfera'],
  [/\bplastico\b/g, 'plástico'],
  [/\bplasticos\b/g, 'plásticos'],
  [/\bplastica\b/g, 'plástica'],
  [/\blactea\b/g, 'láctea'],
  [/\blacteos\b/g, 'lácteos'],
  [/\bdia\b/g, 'día'],
  [/\bdias\b/g, 'días'],
  [/\bDia\b/g, 'Día'],
  [/\balla\b/g, 'allá'],
  [/\btraves\b/g, 'través'],
  [/\banalisis\b/g, 'análisis'],
  [/\bmetaanalisis\b/g, 'metaanálisis'],
  [/\bdemocratica\b/g, 'democrática'],
  [/\borganica\b/g, 'orgánica'],
  [/\borganicos\b/g, 'orgánicos'],
  [/\bmetabolicas\b/g, 'metabólicas'],
  [/\bagricolas\b/g, 'agrícolas'],
  [/\bdecada\b/g, 'década'],
  [/\bdecadas\b/g, 'décadas'],
  [/\boceanos\b/g, 'océanos'],
  [/\bsubterraneas\b/g, 'subterráneas'],
  [/\bsistematicamente\b/g, 'sistemáticamente'],
  [/\bcategoria\b/g, 'categoría'],
  [/\bArticulos\b/g, 'Artículos'],
  [/\bjabon\b/g, 'jabón'],
  [/\balgodon\b/g, 'algodón'],
  [/\bfaciles\b/g, 'fáciles'],
  [/\bformulas\b/g, 'fórmulas'],
  [/\bultima\b/g, 'última'],
  [/\btransito\b/g, 'tránsito'],
  // --- e-acute words ---
  [/\benergia\b/g, 'energía'],
  [/\bEnergias\b/g, 'Energías'],
  [/\btambien\b/g, 'también'],
  [/\bTambien\b/g, 'También'],
  [/\bcafe\b/g, 'café'],
  [/\belectrico\b/g, 'eléctrico'],
  [/\belectrica\b/g, 'eléctrica'],
  [/\belectricos\b/g, 'eléctricos'],
  [/\belectricas\b/g, 'eléctricas'],
  [/\belectronicos\b/g, 'electrónicos'],
  [/\belectronico\b/g, 'electrónico'],
  [/\belectronica\b/g, 'electrónica'],
  [/\belectrodomestico\b/g, 'electrodoméstico'],
  [/\belectrodomesticos\b/g, 'electrodomésticos'],
  [/\benergetico\b/g, 'energético'],
  [/\benergetica\b/g, 'energética'],
  [/\bpetroleo\b/g, 'petróleo'],
  [/\bidentico\b/g, 'idéntico'],
  [/\bmetodos\b/g, 'métodos'],
  [/\bprestamos\b/g, 'préstamos'],
  [/\bmicroprestamos\b/g, 'micropréstamos'],
  [/\bgenero\b/g, 'género'],
  [/\bGenero\b/g, 'Género'],
  [/\bsistemico\b/g, 'sistémico'],
  // --- i-acute words ---
  [/\btipica\b/g, 'típica'],
  [/\btipico\b/g, 'típico'],
  [/\btipicos\b/g, 'típicos'],
  [/\btipicamente\b/g, 'típicamente'],
  [/\barticulos\b/g, 'artículos'],
  [/\barticulo\b/g, 'artículo'],
  [/\butil\b/g, 'útil'],
  [/\butiles\b/g, 'útiles'],
  [/\bminimo\b/g, 'mínimo'],
  [/\bminima\b/g, 'mínima'],
  [/\bfria\b/g, 'fría'],
  [/\bfrio\b/g, 'frío'],
  [/\bvehiculo\b/g, 'vehículo'],
  [/\bvehiculos\b/g, 'vehículos'],
  [/\bclimaticas\b/g, 'climáticas'],
  [/\bclimatica\b/g, 'climática'],
  [/\bclimatico\b/g, 'climático'],
  [/\bclimaticos\b/g, 'climáticos'],
  [/\bbiologico\b/g, 'biológico'],
  [/\bbiologica\b/g, 'biológica'],
  [/\becologico\b/g, 'ecológico'],
  [/\becologica\b/g, 'ecológica'],
  [/\becologicos\b/g, 'ecológicos'],
  [/\becologicas\b/g, 'ecológicas'],
  [/\beconomico\b/g, 'económico'],
  [/\beconomica\b/g, 'económica'],
  [/\beconomia\b/g, 'economía'],
  [/\bmineria\b/g, 'minería'],
  [/\btuberia\b/g, 'tubería'],
  [/\bmayoria\b/g, 'mayoría'],
  [/\bdiario\b/g, 'diario'],
  [/\bkilometro\b/g, 'kilómetro'],
  [/\bkilometros\b/g, 'kilómetros'],
  [/\boceanico\b/g, 'oceánico'],
  [/\boceanicos\b/g, 'oceánicos'],
  [/\boceano\b/g, 'océano'],
  [/\bcientifica\b/g, 'científica'],
  [/\bcientifico\b/g, 'científico'],
  [/\bcientificas\b/g, 'científicas'],
  [/\bcientificos\b/g, 'científicos'],
  [/\bhistorica\b/g, 'histórica'],
  [/\bhistorico\b/g, 'histórico'],
  [/\bestadistica\b/g, 'estadística'],
  [/\bestadisticas\b/g, 'estadísticas'],
  [/\bproteina\b/g, 'proteína'],
  [/\bproteinas\b/g, 'proteínas'],
  [/\bpaises\b/g, 'países'],
  [/\bsinteticos\b/g, 'sintéticos'],
  [/\bsinteticas\b/g, 'sintéticas'],
  [/\bcriticos\b/g, 'críticos'],
  [/\bcritica\b/g, 'crítica'],
  [/\bpelicula\b/g, 'película'],
  [/\bvias\b/g, 'vías'],
  [/\bcivica\b/g, 'cívica'],
  [/\bminorias\b/g, 'minorías'],
  [/\benvio\b/g, 'envío'],
  [/\benvian\b/g, 'envían'],
  [/\bmicroplasticos\b/g, 'microplásticos'],
  [/\bdomestico\b/g, 'doméstico'],
  [/\bdomesticos\b/g, 'domésticos'],
  [/\bmultiples\b/g, 'múltiples'],
  [/\bextraida\b/g, 'extraída'],
  [/\bextraidos\b/g, 'extraídos'],
  [/\braices\b/g, 'raíces'],
  [/\basi\b/g, 'así'],
  [/\bmembresia\b/g, 'membresía'],
  [/\bescorrentia\b/g, 'escorrentía'],
  [/\bomnivora\b/g, 'omnívora'],
  [/\bproxima\b/g, 'próxima'],
  [/\bcompartiendolo\b/g, 'compartiéndolo'],
  // --- o-acute words (specific) ---
  [/\bfotosintesis\b/g, 'fotosíntesis'],
  [/\bpolitica\b/g, 'política'],
  [/\bpoliticas\b/g, 'políticas'],
  [/\bpolitico\b/g, 'político'],
  [/\bpoliticos\b/g, 'políticos'],
  [/\btoxicos\b/g, 'tóxicos'],
  [/\btoxica\b/g, 'tóxica'],
  [/\bportatil\b/g, 'portátil'],
  [/\bcodigo\b/g, 'código'],
  [/\bParis\b/g, 'París'],
  // Preterite verbs (3rd person -o -> -o accent)
  [/\bencontro\b/g, 'encontró'],
  [/\brevelo\b/g, 'reveló'],
  [/\bdemostro\b/g, 'demostró'],
  [/\bmovilizo\b/g, 'movilizó'],
  [/\bduplico\b/g, 'duplicó'],
  // --- u-acute words ---
  [/\bunico\b/g, 'único'],
  [/\bunica\b/g, 'única'],
  [/\bsegun\b/g, 'según'],
  [/\bSegun\b/g, 'Según'],
  [/\bpublico\b/g, 'público'],
  [/\bpublica\b/g, 'pública'],
  [/\bnumero\b/g, 'número'],
  [/\bautobus\b/g, 'autobús'],
  [/\bautomaticamente\b/g, 'automáticamente'],
  [/\bestandar\b/g, 'estándar'],
  [/\bmediodia\b/g, 'mediodía'],
  [/\bjardin\b/g, 'jardín'],
  [/\bvacio\b/g, 'vacío'],
  [/\bvacia\b/g, 'vacía'],
  [/\bvacias\b/g, 'vacías'],
  [/\banimo\b/g, 'ánimo'],
  [/\bfosiles\b/g, 'fósiles'],
  [/\beolica\b/g, 'eólica'],
  [/\baun\b/g, 'aún'],
  [/\bactuan\b/g, 'actúan'],
  [/\bactuen\b/g, 'actúen'],
  [/\bmenus\b/g, 'menús'],
  // Conditional/subjunctive verbs
  [/\bhabrian\b/g, 'habrían'],
  [/\bpodria\b/g, 'podría'],
  [/\bpodrian\b/g, 'podrían'],
  [/\brequeririan\b/g, 'requerirían'],
  // --- u-dieresis ---
  [/\bdesague\b/g, 'desagüe'],
  // --- Generic catch-all: -ion -> -ion ---
  // All Spanish words ending in -ion need accent
  [/([a-záéíóúüñ])ion\b/g, '$1ión'],
];

function fixDiacritics(text) {
  let result = text;
  for (const [pattern, replacement] of REPLACEMENTS) {
    result = result.replace(pattern, replacement);
  }
  return result;
}

function processFile(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  const lines = content.split('\n');
  let inEs = false;
  let braceDepth = 0;
  let modified = [];
  let changeCount = 0;

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const trimmed = line.trim();

    // Detect start of es: block
    if (trimmed.startsWith('es:')) {
      inEs = true;
    }

    // Detect end of es: block (next key or closing)
    if (inEs && i > 0) {
      if (trimmed.startsWith('ja:') ||
          trimmed.startsWith('en:') ||
          trimmed === '},') {
        inEs = false;
      }
    }

    if (inEs) {
      const fixed = fixDiacritics(line);
      if (fixed !== line) {
        changeCount++;
      }
      modified.push(fixed);
    } else {
      modified.push(line);
    }
  }

  const result = modified.join('\n');
  if (result !== content) {
    fs.writeFileSync(filePath, result, 'utf8');
    console.log(
      `Fixed ${filePath.split('/').pop()}: `
      + `${changeCount} lines changed`
    );
  } else {
    console.log(
      `No changes needed: ${filePath.split('/').pop()}`
    );
  }
}

const BASE = path.join(__dirname, '..', 'seed');
const FILES = [
  'action_descriptions_energy_water.js',
  'action_descriptions_consumption.js',
  'action_descriptions_recyc_trans_food.js',
  'action_descriptions_comm_advo_learn.js',
];

for (const file of FILES) {
  processFile(path.join(BASE, file));
}

console.log('Done.');
