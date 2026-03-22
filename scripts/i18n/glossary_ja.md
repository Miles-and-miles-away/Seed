# Japanese Translation Glossary for Eco Facts

## Files with Japanese Content

| File | Content |
|---|---|
| `lib/core/l10n/app_ja.arb` | UI strings (~530 keys) |
| `data/app/eco_facts.json` | factJa / sourceJa (365 entries) |
| `data/app/sdg_targets.json` | descriptionJa (169 SDG targets) |

## Style Rules
- **Register**: ます form (polite conversational), matching app_ja.arb
- **Numbers**: Arabic numerals; use 億/万 for large Japanese-style groupings
- **Units**: Keep Latin units (kg, km, GW, kWh, m2, etc.)
- **CO2**: Use "CO2" inline; spell out 二酸化炭素 when used as a noun
- **Source names**: Copy sourceEn verbatim -- NEVER translate
- **Double dashes**: Preserve `--` in the exact same position as English
- **Sentence endings**: Always end with ます/です/ません (polite form). Never use である/だ/casual forms

## Locked Terminology (~60 terms)

| English | Japanese | Notes |
|---|---|---|
| carbon dioxide / CO2 | 二酸化炭素 / CO2 | Spell out in noun phrases, keep CO2 inline |
| greenhouse gas | 温室効果ガス | |
| carbon footprint | カーボンフットプリント | Katakana |
| carbon emissions | 炭素排出量 | |
| climate change | 気候変動 | |
| global warming | 地球温暖化 | |
| sustainability | サステナビリティ / 持続可能性 | Use katakana for adjective, kanji for noun |
| sustainable | サステナブルな / 持続可能な | |
| renewable energy | 再生可能エネルギー | |
| solar energy/power | 太陽光エネルギー / 太陽光発電 | |
| wind energy/power | 風力エネルギー / 風力発電 | |
| fossil fuels | 化石燃料 | |
| deforestation | 森林伐採 | |
| reforestation | 植林 | |
| biodiversity | 生物多様性 | |
| ecosystem | 生態系 | |
| recycling | リサイクル | Katakana |
| compost/composting | コンポスト / 堆肥化 | |
| landfill | 埋立地 | |
| ocean/sea | 海洋 | Formal context |
| freshwater | 淡水 | |
| drought | 干ばつ | |
| flood/flooding | 洪水 | |
| endangered species | 絶滅危惧種 | |
| habitat | 生息地 | |
| pollution | 汚染 | |
| air pollution | 大気汚染 | |
| water pollution | 水質汚染 | |
| plastic waste | プラスチックごみ | |
| food waste | 食品ロス / 食品廃棄物 | 食品ロス for consumer context |
| e-waste / electronic waste | 電子廃棄物 | |
| single-use plastic | 使い捨てプラスチック | |
| plant-based diet | 植物性の食事 / プラントベースの食事 | |
| organic | オーガニック / 有機 | |
| electric vehicle (EV) | 電気自動車（EV） | |
| public transport | 公共交通機関 | |
| energy efficiency | エネルギー効率 | |
| insulation | 断熱 | |
| LED lighting | LED照明 | |
| fast fashion | ファストファッション | Katakana |
| textile waste | 繊維廃棄物 | |
| microplastics | マイクロプラスチック | Katakana |
| coral reef | サンゴ礁 | |
| rainforest | 熱帯雨林 | |
| wetland | 湿地 | |
| soil | 土壌 | |
| pesticide | 農薬 | |
| fertilizer | 肥料 | |
| nitrogen | 窒素 | |
| methane | メタン | Katakana |
| ozone layer | オゾン層 | |
| ice cap / glacier | 氷床 / 氷河 | |
| sea level rise | 海面上昇 | |
| carbon capture | 炭素回収 | |
| net zero | ネットゼロ | Katakana |
| Paris Agreement | パリ協定 | |
| SDGs | SDGs | Keep as-is |
| United Nations | 国連 | |
| per capita | 一人当たり | |
| equivalent to | に相当します | Use with ます form |
| compared to | と比べて | |
| approximately | 約 | Prefix |
| according to | によると | |
| reduce / reduction | 削減する / 削減 | |
| save (resources) | 節約する | |
| emit / emissions | 排出する / 排出量 | |
| generate (energy) | 発電する | |
| consume / consumption | 消費する / 消費量 | |

## Example Translations

### Example 1 (comparison category)
**English**: If you went fully plant-based for just one month, you would save roughly 124 kg of CO2 -- equivalent to driving 750 km in a petrol car.
**Japanese**: 1か月間完全に植物性の食事に切り替えるだけで、約124 kgのCO2を節約できます -- ガソリン車で750 km走行するのに相当します。

### Example 2 (positiveNews category)
**English**: The global tree-planting movement has planted over 16 billion trees since 2020. Ethiopia set a world record by planting 350 million trees in a single day in 2019.
**Japanese**: 世界的な植林運動により、2020年以降160億本以上の木が植えられました。エチオピアは2019年に1日で3億5000万本の木を植え、世界記録を樹立しました。

### Example 3 (mythBuster category)
**English**: Bottled water is not safer than tap water in most developed countries. Tap water is tested far more frequently, and bottled water generates hundreds of times more CO2 per litre.
**Japanese**: 先進国のほとんどでは、ボトル入りの水は水道水より安全ではありません。水道水の方がはるかに頻繁に検査されており、ボトル入りの水は1リットル当たり数百倍のCO2を排出します。
