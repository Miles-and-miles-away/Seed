# Spanish Translation Glossary for Eco Facts

## Files with Spanish Content

| File | Content |
|---|---|
| `lib/core/l10n/app_es.arb` | UI strings (~530 keys) |
| `data/app/eco_facts.json` | factEs / sourceEs (365 entries) |
| `data/app/sdg_targets.json` | descriptionEs (169 SDG targets) |

## Style Rules
- **Register**: Neutral Latin American Spanish (not Spain-specific)
- **Numbers**: Arabic numerals; use comma for thousands, period for decimals (1,300 / 3.2)
- **Units**: Keep Latin units (kg, km, GW, kWh, m2, etc.)
- **CO2**: Use "CO2" inline (no subscript)
- **Source names**: Copy sourceEn verbatim -- NEVER translate
- **Double dashes**: Preserve `--` in the exact same position as English
- **Billions/trillions**: Use "mil millones" (not "billon"); "billon" = trillion in Spanish

## Locked Terminology

Terms with drift detected in the existing 365 facts are marked with (!) and the locked choice.

| English | Spanish | Notes |
|---|---|---|
| carbon dioxide / CO2 | dioxido de carbono / CO2 | |
| greenhouse gas(es) | gas(es) de efecto invernadero | |
| carbon footprint | huella de carbono | |
| carbon emissions | emisiones de carbono | |
| climate change | cambio climatico | (!) Not "calentamiento global" unless literally "global warming" |
| global warming | calentamiento global | Only when English says "global warming" |
| sustainability | sostenibilidad | |
| sustainable | sostenible | Not "sustentable" |
| renewable energy | energia renovable | (!) Not "energia limpia" -- use that only for "clean energy" |
| clean energy | energia limpia | Distinct from "renewable" |
| solar energy/power | energia solar | |
| wind energy/power | energia eolica | |
| fossil fuels | combustibles fosiles | |
| deforestation | deforestacion | |
| reforestation | reforestacion | |
| biodiversity | biodiversidad | |
| ecosystem | ecosistema | |
| recycling (noun) | reciclaje | (!) Not "reciclado" for the concept; use "reciclado" only as adjective (material reciclado) |
| recycled (adj) | reciclado/a | |
| compost/composting | compostaje | |
| landfill | vertedero | (!) Not "relleno sanitario" or "basurero" |
| ocean/sea | oceano | |
| freshwater | agua dulce | |
| drought | sequia | |
| flood/flooding | inundacion | |
| endangered species | especies en peligro de extincion | |
| habitat | habitat | |
| pollution | contaminacion | |
| air pollution | contaminacion del aire | |
| water pollution | contaminacion del agua | |
| plastic waste | residuos plasticos | |
| food waste | desperdicio de alimentos | (!) Not "residuos alimentarios" or "desperdicio alimentario" |
| e-waste / electronic waste | residuos electronicos | |
| single-use plastic | plastico de un solo uso | (!) Not "plastico desechable" |
| plant-based diet | dieta basada en plantas / dieta vegetal | |
| organic | organico | |
| electric vehicle (EV) | vehiculo electrico (VE) | (!) Not "auto electrico" or "coche electrico" |
| car / automobile | auto | (!) Not "coche" or "carro" |
| gasoline / petrol | gasolina | Not "nafta" |
| public transport | transporte publico | |
| energy efficiency | eficiencia energetica | |
| insulation | aislamiento termico | |
| LED lighting | iluminacion LED | |
| fast fashion | moda rapida | |
| textile waste | residuos textiles | |
| microplastics | microplasticos | |
| coral reef | arrecife de coral | |
| rainforest | selva tropical | |
| wetland | humedal | |
| soil | suelo | |
| pesticide | pesticida | |
| fertilizer | fertilizante | |
| nitrogen | nitrogeno | |
| methane | metano | |
| ozone layer | capa de ozono | |
| ice cap / glacier | capa de hielo / glaciar | |
| sea level rise | aumento del nivel del mar | |
| carbon capture | captura de carbono | |
| net zero | cero neto | (!) Not "neto cero" |
| Paris Agreement | Acuerdo de Paris | |
| SDGs | ODS | Objetivos de Desarrollo Sostenible |
| United Nations | Naciones Unidas / ONU | |
| per capita | per capita | |
| equivalent to | equivalente a | |
| compared to | en comparacion con | |
| approximately | aproximadamente | (!) Not "alrededor de" or "cerca de" for numerical approximations |
| according to | segun | |
| reduce / reduction | reducir / reduccion | |
| save (resources) | ahorrar | |
| emit / emissions | emitir / emisiones | |
| generate (energy) | generar | |
| consume / consumption | consumir / consumo | |
| cost (noun) | costo | (!) Not "coste" (Spain usage) |

## Example Translations

### Example 1 (comparison category)
**English**: If you went fully plant-based for just one month, you would save roughly 124 kg of CO2 -- equivalent to driving 750 km in a petrol car.
**Spanish**: Si adoptaras una dieta 100% vegetal durante solo un mes, ahorrarias aproximadamente 124 kg de CO2 -- equivalente a conducir 750 km en un auto de gasolina.

### Example 2 (positiveNews category)
**English**: The global tree-planting movement has planted over 16 billion trees since 2020. Ethiopia set a world record by planting 350 million trees in a single day in 2019.
**Spanish**: El movimiento global de plantacion de arboles ha plantado mas de 16 mil millones de arboles desde 2020. Etiopia establecio un record mundial al plantar 350 millones de arboles en un solo dia en 2019.

### Example 3 (mythBuster category)
**English**: Bottled water is not safer than tap water in most developed countries. Tap water is tested far more frequently, and bottled water generates hundreds of times more CO2 per litre.
**Spanish**: El agua embotellada no es mas segura que el agua del grifo en la mayoria de los paises desarrollados. El agua del grifo se analiza con mucha mas frecuencia, y el agua embotellada genera cientos de veces mas CO2 por litro.
