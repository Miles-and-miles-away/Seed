# Spanish Translation Glossary

The app's Spanish is **Spain Spanish (es-ES)**. This file is the authority
for every Spanish string: UI copy, eco facts, Eco-Dex entries, SDG text and
the calculators' notes.

## Files with Spanish Content

| File | Content |
|---|---|
| `lib/core/l10n/app_es.arb` | UI strings |
| `data/app/eco_facts.json` | factEs / sourceEs (365 entries) |
| `data/app/eco_dex_entries.json` | nameEs / factEs / hintEs |
| `data/app/sdg_targets.json` | descriptionEs (169 SDG targets) |
| `data/seed/co2_actions_database.json` | name_es / description_es |

## Style Rules
- **Register**: Spain Spanish, informal *tú* (as in `app_es.arb`). Use
  Spain vocabulary: *móvil*, *coche*, *ordenador*, *Ajustes*.
- **Spelling**: full accents and ñ everywhere (*energía*, *eléctrico*,
  *año*). Text without accents is a defect, not a style.
- **Punctuation**: open every question and exclamation with ¿ and ¡,
  including short UI strings (*¡Completado!*, *¿Iniciar este desafío?*).
  Quote feature and button names inside a sentence with « »
  (*Toca «Añadir tramo»*).
- **Numbers**: decimal comma, period for thousands (1.300 / 3,2). This is
  what `NumberFormat('es')` produces, so numbers the app formats at runtime
  match hand-written ones.
- **Units**: keep SI units (kg, km, GW, kWh, m2) with a space between the
  value and the unit (*15 ml*, *0,45 kg*).
- **CO2**: use "CO2" inline (no subscript).
- **CO2e quantities**: «7 g CO2e», «2,3 kg CO2e», «{amount} CO2e», never
  «kg de CO2e». «huella de CO2e» (a footprint, not a quantity) keeps «de».
- **Source names**: copy sourceEn verbatim -- NEVER translate.
- **No dash joins**: never join clauses with ` -- ` (English keeps it);
  use a comma or a full stop instead (a semicolon where natural).
- **Billions/trillions**: use "mil millones" (not "billón"); "billón" =
  trillion in Spanish.

Older eco-fact and Eco-Dex text predates this file and still contains Latin
American vocabulary (*auto*, *costo*, *computadora*). Its numbers already
follow the es-ES marks, and `test/core/l10n/spanish_fact_numbers_test.dart`
keeps them that way.

## Locked Terminology

Terms with drift detected in the existing facts are marked with (!) and the
locked choice.

| English | Spanish | Notes |
|---|---|---|
| carbon dioxide / CO2 | dióxido de carbono / CO2 | |
| greenhouse gas(es) | gas(es) de efecto invernadero | |
| carbon footprint | huella de carbono | |
| carbon emissions | emisiones de carbono | |
| climate change | cambio climático | (!) Not "calentamiento global" unless literally "global warming" |
| global warming | calentamiento global | Only when English says "global warming" |
| sustainability | sostenibilidad | |
| sustainable | sostenible | Not "sustentable" |
| renewable energy | energía renovable | (!) Not "energía limpia" -- use that only for "clean energy" |
| clean energy | energía limpia | Distinct from "renewable" |
| solar energy/power | energía solar | |
| wind energy/power | energía eólica | |
| fossil fuels | combustibles fósiles | |
| deforestation | deforestación | |
| reforestation | reforestación | |
| biodiversity | biodiversidad | |
| ecosystem | ecosistema | |
| recycling (noun) | reciclaje | (!) Not "reciclado" for the concept; use "reciclado" only as adjective (material reciclado) |
| recycled (adj) | reciclado/a | |
| compost/composting | compostaje | |
| landfill | vertedero | (!) Not "relleno sanitario" or "basurero" |
| ocean/sea | océano | |
| freshwater | agua dulce | |
| drought | sequía | |
| flood/flooding | inundación | |
| endangered species | especies en peligro de extinción | |
| habitat | hábitat | |
| pollution | contaminación | |
| air pollution | contaminación del aire | |
| water pollution | contaminación del agua | |
| plastic waste | residuos plásticos | |
| food waste | desperdicio de alimentos | (!) Not "residuos alimentarios" or "desperdicio alimentario" |
| e-waste / electronic waste | residuos electrónicos | |
| single-use plastic | plástico de un solo uso | (!) Not "plástico desechable" |
| plant-based diet | dieta basada en plantas / dieta vegetal | |
| organic | ecológico | (!) Spain labels organic food "ecológico"; "orgánico" only for chemistry |
| electric vehicle (EV) | vehículo eléctrico (VE) | Use "coche eléctrico" for a car specifically |
| car / automobile | coche | (!) Not "auto" or "carro" |
| mobile phone | móvil | Not "celular" |
| computer | ordenador | Not "computadora" |
| gasoline / petrol | gasolina | Not "nafta" |
| public transport | transporte público | |
| energy efficiency | eficiencia energética | |
| insulation | aislamiento térmico | |
| LED lighting | iluminación LED | |
| fast fashion | moda rápida | |
| textile waste | residuos textiles | |
| microplastics | microplásticos | |
| coral reef | arrecife de coral | |
| rainforest | selva tropical | |
| wetland | humedal | |
| soil | suelo | |
| pesticide | pesticida | |
| fertilizer | fertilizante | |
| nitrogen | nitrógeno | |
| methane | metano | |
| ozone layer | capa de ozono | |
| ice cap / glacier | capa de hielo / glaciar | |
| sea level rise | aumento del nivel del mar | |
| carbon capture | captura de carbono | |
| net zero | cero neto | (!) Not "neto cero" |
| Paris Agreement | Acuerdo de París | |
| SDGs | ODS | Objetivos de Desarrollo Sostenible; do not write "Objetivos ODS" |
| United Nations | Naciones Unidas / ONU | |
| per capita | per cápita | |
| equivalent to | equivalente a | |
| compared to | en comparación con | |
| approximately | aproximadamente | (!) Not "alrededor de" or "cerca de" for numerical approximations |
| according to | según | |
| reduce / reduction | reducir / reducción | |
| save (resources) | ahorrar | |
| emit / emissions | emitir / emisiones | |
| generate (energy) | generar | |
| consume / consumption | consumir / consumo | |
| cost (noun) | coste | (!) Spain usage; not "costo" |
| journey leg | tramo | As in "Añadir tramo", "Editar tramo" |

## Example Translations

### Example 1 (comparison category)
**English**: If you went fully plant-based for just one month, you would save roughly 80 kg of CO2 -- equivalent to driving 500 km in a petrol car.
**Spanish**: Si adoptaras una dieta 100% vegetal durante solo un mes, ahorrarías aproximadamente 80 kg de CO2, equivalente a conducir 500 km en un coche de gasolina.

### Example 2 (positiveNews category)
**English**: The global tree-planting movement has planted over 16 billion trees since 2020. Ethiopia set a world record by planting 350 million trees in a single day in 2019.
**Spanish**: El movimiento mundial de plantación de árboles ha plantado más de 16.000 millones de árboles desde 2020. Etiopía estableció un récord mundial al plantar 350 millones de árboles en un solo día en 2019.

### Example 3 (mythBuster category)
**English**: Bottled water is not safer than tap water in most developed countries. Tap water is tested far more frequently, and bottled water generates hundreds of times more CO2 per litre.
**Spanish**: El agua embotellada no es más segura que el agua del grifo en la mayoría de los países desarrollados. El agua del grifo se analiza con mucha más frecuencia, y el agua embotellada genera cientos de veces más CO2 por litro.
