/**
 * Long descriptions for eco-actions:
 * RECYCLING, TRANSPORT, FOOD categories.
 *
 * Each description is 3-5 sentences with markdown
 * formatting, bold CO2 figures, and source links.
 *
 * This is a partial file merged into the final
 * descriptions module.
 */

const descriptions = {
  // -------------------------------------------------------
  // RECYCLING (10 actions)
  // -------------------------------------------------------
  recycle_aluminum_can: {
    en:
      'Recycling a single aluminum can saves '
      + 'roughly **99g of CO2** compared to '
      + 'smelting one from raw bauxite ore. '
      + 'The process requires just 5% of the '
      + 'energy needed for primary production '
      + '([International Aluminium Institute]'
      + '(https://international-aluminium.org'
      + '/landing/aluminium-recycling-saves-95'
      + '-of-the-energy-needed-for-primary-'
      + 'aluminium-production/)). '
      + 'Unlike most materials, aluminum can be '
      + 'recycled infinitely with no quality '
      + 'loss ([Aluminum Association]'
      + '(https://www.aluminum.org/Recycling)). '
      + 'A single can returns to store shelves '
      + 'as a new can in as little as 60 days.',
    ja:
      'アルミ缶1本のリサイクルで、原料の'
      + 'ボーキサイトから精錬する場合に比べ'
      + '約**99gのCO2**を削減できます。'
      + 'リサイクルに必要なエネルギーは一次'
      + '生産のわずか5%です'
      + '（[国際アルミニウム協会]'
      + '(https://international-aluminium.org'
      + '/landing/aluminium-recycling-saves-95'
      + '-of-the-energy-needed-for-primary-'
      + 'aluminium-production/)）。'
      + 'アルミニウムは品質を落とすことなく'
      + '無限にリサイクル可能で、回収から約'
      + '60日で新しい缶として店頭に並びます'
      + '（[Aluminum Association]'
      + '(https://www.aluminum.org/Recycling)）。',
    es:
      'Reciclar una sola lata de aluminio '
      + 'ahorra aproximadamente **99g de CO2** '
      + 'en comparacion con fundir una nueva '
      + 'desde bauxita. El proceso requiere '
      + 'solo el 5% de la energia necesaria '
      + 'para la produccion primaria '
      + '([International Aluminium Institute]'
      + '(https://international-aluminium.org'
      + '/landing/aluminium-recycling-saves-95'
      + '-of-the-energy-needed-for-primary-'
      + 'aluminium-production/)). '
      + 'El aluminio se puede reciclar '
      + 'infinitamente sin perder calidad '
      + '([Aluminum Association]'
      + '(https://www.aluminum.org/Recycling)). '
      + 'Una lata reciclada puede volver a los '
      + 'estantes en solo 60 dias.',
  },

  recycle_plastic_bottle: {
    en:
      'Recycling a standard 28g PET plastic '
      + 'bottle prevents roughly **47g of CO2** '
      + 'from entering the atmosphere. The '
      + '[EPA WARM model](https://www.epa.gov'
      + '/warm) calculates that recycled PET '
      + 'displaces virgin resin production, '
      + 'which is highly energy-intensive. '
      + 'Each bottle recycled also keeps '
      + 'persistent plastic out of landfills '
      + 'and oceans, where it can take over '
      + '450 years to decompose.',
    ja:
      '標準的な28gのPETボトルをリサイクル'
      + 'すると約**47gのCO2**排出を防げます。'
      + '[EPA WARMモデル](https://www.epa.gov'
      + '/warm)によると、リサイクルPETは'
      + 'エネルギー集約的なバージン樹脂の'
      + '生産を代替します。リサイクルにより'
      + '分解に450年以上かかるプラスチックが'
      + '埋立地や海洋に流出するのも防げます。',
    es:
      'Reciclar una botella estandar de PET '
      + 'de 28g evita que aproximadamente '
      + '**47g de CO2** lleguen a la atmosfera. '
      + 'El [modelo WARM de la EPA]'
      + '(https://www.epa.gov/warm) calcula que '
      + 'el PET reciclado desplaza la produccion '
      + 'de resina virgen, un proceso muy '
      + 'intensivo en energia. Cada botella '
      + 'reciclada tambien evita que plastico '
      + 'persistente termine en vertederos u '
      + 'oceanos, donde tarda mas de 450 anos '
      + 'en descomponerse.',
  },

  recycle_cardboard: {
    en:
      'Recycling cardboard saves about '
      + '**50g of CO2** per typical box. '
      + 'Cardboard recycling prevents roughly '
      + '2,160g of CO2 per kilogram by avoiding '
      + 'virgin pulp production '
      + '([EPA WARM](https://www.epa.gov'
      + '/warm)). The process also conserves '
      + 'trees that act as active carbon sinks. '
      + 'Corrugated cardboard is one of the '
      + 'most successfully recycled materials, '
      + 'with recovery rates exceeding 90% in '
      + 'many countries.',
    ja:
      '段ボールのリサイクルは1箱あたり約'
      + '**50gのCO2**を削減します。段ボール'
      + 'リサイクルは1kgあたり約2,160gの'
      + 'CO2を節約し、バージンパルプ生産を'
      + '回避します（[EPA WARM]'
      + '(https://www.epa.gov/warm)）。'
      + 'また炭素吸収源として機能する森林の'
      + '保全にも貢献します。段ボールは最も'
      + 'リサイクル率の高い素材の一つで、多く'
      + 'の国で回収率90%以上を達成しています。',
    es:
      'Reciclar carton ahorra '
      + 'aproximadamente **50g de CO2** por '
      + 'caja tipica. El reciclaje de carton '
      + 'evita unas 2.160g de CO2 por '
      + 'kilogramo al no necesitar produccion '
      + 'de pulpa virgen ([EPA WARM]'
      + '(https://www.epa.gov/warm)). '
      + 'El proceso tambien conserva arboles '
      + 'que actuan como sumideros de carbono. '
      + 'El carton corrugado es uno de los '
      + 'materiales con mayor tasa de '
      + 'reciclaje, superando el 90% en muchos '
      + 'paises.',
  },

  composting: {
    en:
      'Composting food scraps prevents about '
      + '**200g of CO2 equivalent** per session '
      + 'by diverting organic waste from '
      + 'landfills. The [EPA](https://www.epa'
      + '.gov/land-research/quantifying-methane'
      + '-emissions-landfilled-food-waste) '
      + 'reports that 58% of fugitive methane '
      + 'from landfills comes from food waste. '
      + 'Methane is 80x more potent than CO2 '
      + 'over 20 years, making composting a '
      + 'powerful climate action. The resulting '
      + 'compost also enriches soil and reduces '
      + 'the need for synthetic fertilizers.',
    ja:
      '生ごみのコンポスト化は1回あたり約'
      + '**200gのCO2相当**を削減します。'
      + '[EPA](https://www.epa.gov/land-research'
      + '/quantifying-methane-emissions-'
      + 'landfilled-food-waste)によると、'
      + '埋立地からの逸散メタンの58%は'
      + '食品廃棄物が原因です。メタンは20年'
      + 'スパンでCO2の80倍の温室効果があり、'
      + 'コンポストは強力な気候変動対策です。'
      + 'できた堆肥は土壌を豊かにし、合成'
      + '肥料の使用量も削減できます。',
    es:
      'Compostar restos de comida evita '
      + 'aproximadamente **200g de CO2 '
      + 'equivalente** por sesion al desviar '
      + 'residuos organicos de vertederos. La '
      + '[EPA](https://www.epa.gov/land-research'
      + '/quantifying-methane-emissions-'
      + 'landfilled-food-waste) informa que el '
      + '58% del metano fugitivo de vertederos '
      + 'proviene de residuos alimentarios. '
      + 'El metano es 80 veces mas potente que '
      + 'el CO2 en 20 anos, haciendo del '
      + 'compostaje una accion climatica '
      + 'poderosa. El compost resultante '
      + 'enriquece el suelo y reduce la '
      + 'necesidad de fertilizantes sinteticos.',
  },

  recycle_glass: {
    en:
      'Recycling a typical glass jar saves '
      + 'about **40g of CO2** by reducing the '
      + 'energy needed to melt raw materials. '
      + 'Glass recycling saves roughly 300g of '
      + 'CO2 per 450g wine bottle according to '
      + 'the [EPA WARM model]'
      + '(https://www.epa.gov/warm). '
      + 'Like aluminum, glass can be recycled '
      + 'endlessly without degradation. Every '
      + '10% increase in recycled cullet used '
      + 'in production cuts energy consumption '
      + 'by about 3%.',
    ja:
      'ガラス瓶1本のリサイクルで約**40gの'
      + 'CO2**を削減できます。原料を溶かす'
      + 'のに必要なエネルギーが減るためです。'
      + '[EPA WARMモデル](https://www.epa.gov'
      + '/warm)によると、450gのワインボトル'
      + '1本で約300gのCO2を節約できます。'
      + 'アルミニウム同様、ガラスは劣化なく'
      + '無限にリサイクル可能です。カレット'
      + '（リサイクルガラス）の使用率を10%'
      + '上げるとエネルギー消費が約3%削減'
      + 'されます。',
    es:
      'Reciclar un frasco de vidrio tipico '
      + 'ahorra unos **40g de CO2** al reducir '
      + 'la energia para fundir materias '
      + 'primas. El reciclaje de vidrio ahorra '
      + 'unos 300g de CO2 por botella de vino '
      + 'de 450g segun el [modelo WARM de la '
      + 'EPA](https://www.epa.gov/warm). '
      + 'Al igual que el aluminio, el vidrio se '
      + 'puede reciclar infinitamente sin '
      + 'degradarse. Cada 10% de aumento en el '
      + 'uso de casco reciclado reduce el '
      + 'consumo energetico un 3%.',
  },

  recycle_paper: {
    en:
      'Recycling a batch of paper saves '
      + 'approximately **50g of CO2** by '
      + 'displacing virgin pulp manufacturing. '
      + 'Paper recycling prevents about 2,590g '
      + 'of CO2 per kilogram according to '
      + 'the [EPA WARM model]'
      + '(https://www.epa.gov/warm). '
      + 'It also conserves water and reduces '
      + 'the pressure on forests that serve as '
      + 'critical carbon sinks. Paper fibers '
      + 'can typically be recycled 5-7 times '
      + 'before they become too short to use.',
    ja:
      '紙のリサイクルは1回あたり約**50gの'
      + 'CO2**を削減し、バージンパルプ製造を'
      + '代替します。[EPA WARMモデル]'
      + '(https://www.epa.gov/warm)によると、'
      + '紙のリサイクルは1kgあたり約2,590gの'
      + 'CO2を防ぎます。水資源の節約や、重要'
      + 'な炭素吸収源である森林への負荷軽減'
      + 'にもつながります。紙の繊維は通常'
      + '5〜7回リサイクル可能です。',
    es:
      'Reciclar un lote de papel ahorra '
      + 'aproximadamente **50g de CO2** al '
      + 'desplazar la fabricacion de pulpa '
      + 'virgen. El reciclaje de papel evita '
      + 'unas 2.590g de CO2 por kilogramo '
      + 'segun el [modelo WARM de la EPA]'
      + '(https://www.epa.gov/warm). '
      + 'Tambien conserva agua y reduce la '
      + 'presion sobre los bosques que sirven '
      + 'como sumideros criticos de carbono. '
      + 'Las fibras de papel se pueden reciclar '
      + 'de 5 a 7 veces antes de volverse '
      + 'demasiado cortas.',
  },

  recycle_ewaste: {
    en:
      'Recycling one kilogram of e-waste '
      + 'prevents roughly **2,350g of CO2** by '
      + 'recovering precious metals and rare '
      + 'earth elements. Electronic devices '
      + 'contain gold, copper, and palladium '
      + 'that are energy-intensive to mine from '
      + 'ore. The [EPA GHG Equivalencies '
      + 'Calculator](https://www.epa.gov/energy'
      + '/greenhouse-gas-equivalencies-'
      + 'calculator) helps quantify these '
      + 'savings. Proper e-waste recycling also '
      + 'prevents toxic lead and mercury from '
      + 'leaching into groundwater.',
    ja:
      '電子廃棄物1kgのリサイクルで約'
      + '**2,350gのCO2**を削減できます。'
      + '貴金属やレアアースの回収により、'
      + '鉱石からの採掘に必要な莫大な'
      + 'エネルギーを節約します。[EPA温室'
      + '効果ガス等価計算ツール]'
      + '(https://www.epa.gov/energy'
      + '/greenhouse-gas-equivalencies-'
      + 'calculator)でこれらの削減効果を'
      + '定量化できます。適切なリサイクルは'
      + '有害な鉛や水銀が地下水に浸出する'
      + 'のも防ぎます。',
    es:
      'Reciclar un kilogramo de residuos '
      + 'electronicos evita unas **2.350g de '
      + 'CO2** al recuperar metales preciosos '
      + 'y tierras raras. Los dispositivos '
      + 'electronicos contienen oro, cobre y '
      + 'paladio cuya extraccion minera es muy '
      + 'intensiva en energia. La [Calculadora '
      + 'de Equivalencias GEI de la EPA]'
      + '(https://www.epa.gov/energy'
      + '/greenhouse-gas-equivalencies-'
      + 'calculator) ayuda a cuantificar estos '
      + 'ahorros. El reciclaje adecuado tambien '
      + 'evita que plomo y mercurio toxicos se '
      + 'filtren a las aguas subterraneas.',
  },

  recycle_textiles: {
    en:
      'Recycling or donating clothing saves '
      + 'roughly **14,000g of CO2 per '
      + 'kilogram** by displacing new textile '
      + 'production. The fashion industry '
      + 'accounts for up to 10% of global '
      + 'carbon emissions. Reusing textiles '
      + 'avoids the water-intensive cotton '
      + 'farming and petroleum-based synthetic '
      + 'fiber manufacturing processes '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). Even worn-out fabrics can be '
      + 'downcycled into insulation or rags.',
    ja:
      '衣類のリサイクルや寄付は1kgあたり約'
      + '**14,000gのCO2**を削減し、新しい'
      + '繊維生産を代替します。ファッション'
      + '産業は世界のCO2排出量の最大10%を'
      + '占めます。繊維の再利用は、水資源を'
      + '大量に使う綿花栽培や石油由来の合成'
      + '繊維製造を回避します（[DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)）。'
      + '着古した布地も断熱材やウエスに'
      + 'ダウンサイクルできます。',
    es:
      'Reciclar o donar ropa ahorra '
      + 'aproximadamente **14.000g de CO2 por '
      + 'kilogramo** al desplazar la produccion '
      + 'textil nueva. La industria de la moda '
      + 'representa hasta el 10% de las '
      + 'emisiones globales de carbono. '
      + 'Reutilizar textiles evita el cultivo '
      + 'de algodon intensivo en agua y la '
      + 'fabricacion de fibras sinteticas '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). Incluso las telas gastadas '
      + 'se pueden reciclar como aislamiento '
      + 'o trapos.',
  },

  recycle_batteries: {
    en:
      'Recycling a single AA battery '
      + 'prevents roughly **95g of CO2** and '
      + 'keeps toxic heavy metals out of '
      + 'landfills. Battery recycling recovers '
      + 'valuable zinc, manganese, and steel '
      + 'that would otherwise require '
      + 'energy-intensive mining. The [EPA]'
      + '(https://www.epa.gov/warm) emphasizes '
      + 'that improper disposal risks toxic '
      + 'leaching into soil and groundwater. '
      + 'Many retailers and municipal centers '
      + 'offer free battery drop-off programs.',
    ja:
      '単三電池1本のリサイクルで約**95gの'
      + 'CO2**を防ぎ、有害な重金属の埋立地'
      + 'への流出を防止します。電池リサイクル'
      + 'では亜鉛、マンガン、鉄などの貴重な'
      + '金属を回収し、エネルギー集約的な'
      + '採掘を回避します。[EPA]'
      + '(https://www.epa.gov/warm)は不適切な'
      + '廃棄が土壌や地下水への有害物質浸出'
      + 'リスクを高めると警告しています。'
      + '多くの小売店や自治体が無料の電池'
      + '回収プログラムを提供しています。',
    es:
      'Reciclar una sola pila AA evita '
      + 'aproximadamente **95g de CO2** y '
      + 'mantiene metales pesados toxicos fuera '
      + 'de los vertederos. El reciclaje de '
      + 'pilas recupera zinc, manganeso y acero '
      + 'valiosos que de otro modo requeririan '
      + 'mineria intensiva en energia. La [EPA]'
      + '(https://www.epa.gov/warm) destaca que '
      + 'la eliminacion inadecuada puede '
      + 'provocar filtracion toxica al suelo y '
      + 'aguas subterraneas. Muchos comercios y '
      + 'centros municipales ofrecen puntos de '
      + 'recogida gratuita de pilas.',
  },

  recycle_cooking_oil: {
    en:
      'Recycling used cooking oil saves '
      + 'approximately **150g of CO2** per '
      + 'liter by converting it into biodiesel '
      + 'that displaces fossil fuels. Pouring '
      + 'oil down the drain clogs sewer systems '
      + 'and costs municipalities millions in '
      + 'repairs. Biodiesel from waste oil '
      + 'reduces lifecycle greenhouse gas '
      + 'emissions by up to 86% compared to '
      + 'petroleum diesel ([EPA WARM]'
      + '(https://www.epa.gov/warm)). '
      + 'Many restaurants and recycling centers '
      + 'accept used cooking oil for free.',
    ja:
      '使用済み食用油のリサイクルで1リットル'
      + 'あたり約**150gのCO2**を削減でき'
      + 'ます。廃油はバイオディーゼルに変換'
      + 'され化石燃料を代替します。油を排水口'
      + 'に流すと下水管の詰まりを引き起こし、'
      + '自治体に多額の修理費用が発生します。'
      + '廃油由来のバイオディーゼルは石油'
      + 'ディーゼルと比べライフサイクル温室'
      + '効果ガスを最大86%削減します'
      + '（[EPA WARM](https://www.epa.gov'
      + '/warm)）。多くの飲食店やリサイクル'
      + 'センターが無料で廃油を回収しています。',
    es:
      'Reciclar aceite de cocina usado ahorra '
      + 'aproximadamente **150g de CO2** por '
      + 'litro al convertirlo en biodiesel que '
      + 'desplaza combustibles fosiles. Verter '
      + 'aceite por el desague obstruye las '
      + 'alcantarillas y cuesta millones en '
      + 'reparaciones. El biodiesel de aceite '
      + 'residual reduce las emisiones de gases '
      + 'de efecto invernadero hasta un 86% '
      + 'comparado con el diesel de petroleo '
      + '([EPA WARM](https://www.epa.gov'
      + '/warm)). Muchos restaurantes y centros '
      + 'de reciclaje aceptan aceite usado '
      + 'gratuitamente.',
  },

  // -------------------------------------------------------
  // TRANSPORT (12 actions)
  // -------------------------------------------------------
  walk_instead_drive: {
    en:
      'Walking instead of driving a short '
      + 'trip saves about **250g of CO2** by '
      + 'replacing an average 1.5km car '
      + 'journey. A typical petrol car emits '
      + '164g of CO2 per kilometer '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). Walking produces zero '
      + 'tailpipe emissions and also improves '
      + 'cardiovascular health. Even replacing '
      + 'one short car trip per day adds up to '
      + 'over 90kg of CO2 saved per year.',
    ja:
      '短距離の車移動を徒歩に替えると約'
      + '**250gのCO2**を削減できます。平均'
      + '1.5kmの車移動を置き換える計算です。'
      + '一般的なガソリン車は1kmあたり164gの'
      + 'CO2を排出します（[DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)）。'
      + '徒歩は排気ガスゼロで心血管の健康にも'
      + '良い影響があります。1日1回の短距離'
      + '移動を徒歩に替えるだけで年間90kg以上'
      + 'のCO2削減になります。',
    es:
      'Caminar en vez de conducir un trayecto '
      + 'corto ahorra unos **250g de CO2** al '
      + 'reemplazar un viaje promedio de 1,5km '
      + 'en auto. Un coche de gasolina tipico '
      + 'emite 164g de CO2 por kilometro '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). Caminar no produce emisiones '
      + 'y ademas mejora la salud '
      + 'cardiovascular. Reemplazar un viaje '
      + 'corto en auto al dia suma mas de 90kg '
      + 'de CO2 ahorrados al ano.',
  },

  bike_short_trip: {
    en:
      'Cycling a short trip under 3km saves '
      + 'approximately **450g of CO2** compared '
      + 'to driving. Cars emit about 164g/km '
      + 'while cycling produces only ~16g/km '
      + 'from metabolic emissions '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). That is a saving of roughly '
      + '149g per kilometer. Cycling also '
      + 'reduces traffic congestion and '
      + 'improves air quality in urban areas '
      + '([Our World in Data]'
      + '(https://ourworldindata.org/travel'
      + '-carbon-footprint)).',
    ja:
      '3km未満の短距離を自転車で移動すると'
      + '車と比べ約**450gのCO2**を削減でき'
      + 'ます。車は1kmあたり約164gのCO2を'
      + '排出しますが、自転車は代謝由来の'
      + '約16g/kmのみです（[DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)）。'
      + '1kmあたり約149gの節約になります。'
      + '自転車は交通渋滞の緩和や都市部の'
      + '大気質改善にも貢献します'
      + '（[Our World in Data]'
      + '(https://ourworldindata.org/travel'
      + '-carbon-footprint)）。',
    es:
      'Ir en bicicleta en un trayecto corto '
      + 'de menos de 3km ahorra '
      + 'aproximadamente **450g de CO2** '
      + 'comparado con conducir. Los coches '
      + 'emiten unos 164g/km mientras que la '
      + 'bicicleta produce solo ~16g/km por '
      + 'emisiones metabolicas ([DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)). '
      + 'Eso supone un ahorro de unos 149g por '
      + 'kilometro. La bicicleta tambien reduce '
      + 'la congestion y mejora la calidad del '
      + 'aire urbano ([Our World in Data]'
      + '(https://ourworldindata.org/travel'
      + '-carbon-footprint)).',
  },

  bike_medium_trip: {
    en:
      'Cycling a medium trip of 3-10km saves '
      + 'roughly **1,000g of CO2** versus '
      + 'driving the same distance. At an '
      + 'average of 6.5km, the saving is about '
      + '149g per kilometer, totaling ~970g '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). Medium-distance cycling is '
      + 'feasible for most commutes and errands '
      + '([Our World in Data]'
      + '(https://ourworldindata.org/travel'
      + '-carbon-footprint)). E-bikes make '
      + 'these distances accessible to an even '
      + 'wider range of riders.',
    ja:
      '3〜10kmの中距離を自転車で移動すると'
      + '車と比べ約**1,000gのCO2**を削減'
      + 'できます。平均6.5kmで1kmあたり約'
      + '149gの節約、合計約970gです'
      + '（[DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)）。中距離の自転車移動は多くの'
      + '通勤や用事に実用的です（[Our World '
      + 'in Data](https://ourworldindata.org'
      + '/travel-carbon-footprint)）。'
      + '電動アシスト自転車ならより多くの人が'
      + 'この距離を快適に走れます。',
    es:
      'Ir en bicicleta en un trayecto medio '
      + 'de 3-10km ahorra aproximadamente '
      + '**1.000g de CO2** frente a conducir. '
      + 'Con un promedio de 6,5km, el ahorro es '
      + 'de unos 149g por kilometro, totalizando '
      + '~970g ([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). El ciclismo de media distancia '
      + 'es viable para la mayoria de trayectos '
      + '([Our World in Data]'
      + '(https://ourworldindata.org/travel'
      + '-carbon-footprint)). Las bicicletas '
      + 'electricas hacen estas distancias '
      + 'accesibles para mas personas.',
  },

  public_transport: {
    en:
      'Taking public transit instead of '
      + 'driving saves roughly **1,000g of '
      + 'CO2** on an average 10km commute. '
      + 'Buses and trains emit 60-104g/km less '
      + 'per passenger than a solo car trip '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). Public transit also reduces '
      + 'traffic congestion and urban air '
      + 'pollution ([Our World in Data]'
      + '(https://ourworldindata.org/travel'
      + '-carbon-footprint)). Ridership growth '
      + 'supports more frequent service, '
      + 'creating a positive feedback loop.',
    ja:
      '車の代わりに公共交通機関を利用すると'
      + '平均10kmの通勤で約**1,000gのCO2**を'
      + '削減できます。バスや電車は1人あたり'
      + 'の排出量が自家用車より60〜104g/km'
      + '少なくなります（[DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)）。'
      + '公共交通は渋滞緩和や都市の大気汚染'
      + '改善にも貢献します（[Our World in '
      + 'Data](https://ourworldindata.org/travel'
      + '-carbon-footprint)）。利用者が増える'
      + 'ほど運行頻度も上がり好循環が生まれ'
      + 'ます。',
    es:
      'Usar transporte publico en vez de '
      + 'conducir ahorra aproximadamente '
      + '**1.000g de CO2** en un trayecto '
      + 'promedio de 10km. Autobuses y trenes '
      + 'emiten 60-104g/km menos por pasajero '
      + 'que un auto individual ([DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)). '
      + 'El transporte publico tambien reduce '
      + 'la congestion y la contaminacion '
      + 'urbana ([Our World in Data]'
      + '(https://ourworldindata.org/travel'
      + '-carbon-footprint)). Mas usuarios '
      + 'permiten un servicio mas frecuente, '
      + 'creando un ciclo positivo.',
  },

  carpool: {
    en:
      'Carpooling halves per-person emissions '
      + 'to about 82g/km, saving roughly '
      + '**800g of CO2** on a 10km trip '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). Sharing rides reduces the '
      + 'total number of vehicles on the road, '
      + 'easing congestion and wear on '
      + 'infrastructure. Carpooling also cuts '
      + 'individual fuel and parking costs. '
      + 'With three or more passengers, the '
      + 'per-person footprint drops below that '
      + 'of most bus routes.',
    ja:
      '相乗りすると1人あたりの排出量が約'
      + '82g/kmに半減し、10kmの移動で約'
      + '**800gのCO2**を節約できます'
      + '（[DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)）。ライドシェアは道路上の'
      + '車両総数を減らし渋滞やインフラの'
      + '摩耗を軽減します。燃料費や駐車場代'
      + 'の個人負担も削減できます。3人以上で'
      + '乗ると1人あたりの排出量はほとんどの'
      + 'バス路線を下回ります。',
    es:
      'Compartir auto reduce las emisiones '
      + 'por persona a unos 82g/km, ahorrando '
      + 'aproximadamente **800g de CO2** en un '
      + 'viaje de 10km ([DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)). Compartir '
      + 'viajes reduce el numero total de '
      + 'vehiculos en la carretera, aliviando '
      + 'la congestion. Tambien reduce los '
      + 'costos de combustible y estacionamiento '
      + 'individuales. Con tres o mas pasajeros, '
      + 'la huella por persona cae por debajo de '
      + 'la mayoria de rutas de autobus.',
  },

  electric_car_commute: {
    en:
      'Commuting by electric vehicle instead '
      + 'of a petrol car saves roughly '
      + '**1,500g of CO2** on a 12km trip. '
      + 'EVs emit about 43g/km compared to '
      + '164g/km for a petrol car '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). As the electricity grid '
      + 'becomes greener, EV emissions drop '
      + 'further automatically. Over a '
      + 'vehicle\'s lifetime, an EV typically '
      + 'produces 50-70% fewer total emissions '
      + 'than a comparable petrol car.',
    ja:
      'ガソリン車の代わりに電気自動車で通勤'
      + 'すると12kmの移動で約**1,500gのCO2**'
      + 'を削減できます。EVは約43g/kmの排出'
      + 'に対しガソリン車は164g/kmです'
      + '（[DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)）。電力網がクリーンになる'
      + 'につれEVの排出量は自動的にさらに'
      + '減少します。車の生涯を通じてEVは'
      + '同等のガソリン車より50〜70%少ない'
      + '総排出量を実現します。',
    es:
      'Ir al trabajo en vehiculo electrico en '
      + 'vez de uno de gasolina ahorra '
      + 'aproximadamente **1.500g de CO2** en '
      + 'un trayecto de 12km. Los VE emiten '
      + 'unos 43g/km frente a 164g/km de un '
      + 'coche de gasolina ([DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)). '
      + 'A medida que la red electrica se '
      + 'vuelve mas limpia, las emisiones de '
      + 'los VE bajan automaticamente. Durante '
      + 'su vida util, un VE produce '
      + 'tipicamente 50-70% menos emisiones '
      + 'totales.',
  },

  train_vs_flight: {
    en:
      'Choosing a train over a domestic flight '
      + 'for a 500km journey saves roughly '
      + '**110,000g (110kg) of CO2**. Trains '
      + 'emit about 37g/km while domestic '
      + 'flights produce ~273g/km per passenger '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). This makes rail travel about '
      + '7 times cleaner than flying '
      + '([Our World in Data]'
      + '(https://ourworldindata.org/travel'
      + '-carbon-footprint)). A single trip '
      + 'swap equals removing a car from the '
      + 'road for nearly a month.',
    ja:
      '500kmの移動で国内線の代わりに鉄道を'
      + '選ぶと約**110,000g（110kg）のCO2**'
      + 'を削減できます。鉄道は約37g/km、'
      + '国内線は乗客1人あたり約273g/km排出'
      + 'します（[DEFRA 2024](https://www.gov'
      + '.uk/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)）。鉄道は飛行機より約7倍'
      + 'クリーンです（[Our World in Data]'
      + '(https://ourworldindata.org/travel'
      + '-carbon-footprint)）。1回の変更で'
      + '約1ヶ月間車を使わないのと同等の効果'
      + 'があります。',
    es:
      'Elegir tren en vez de vuelo domestico '
      + 'para un viaje de 500km ahorra '
      + 'aproximadamente **110.000g (110kg) de '
      + 'CO2**. Los trenes emiten unos 37g/km '
      + 'mientras que los vuelos domesticos '
      + 'producen ~273g/km por pasajero '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). Esto hace al tren unas 7 '
      + 'veces mas limpio que volar '
      + '([Our World in Data]'
      + '(https://ourworldindata.org/travel'
      + '-carbon-footprint)). Un solo cambio '
      + 'equivale a sacar un auto de la '
      + 'carretera por casi un mes.',
  },

  take_bus: {
    en:
      'Taking the bus instead of driving '
      + 'saves roughly **500g of CO2** on an '
      + '8km commute. Buses emit about 104g/km '
      + 'per passenger compared to 164g/km for '
      + 'a solo car ([DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)). '
      + 'Modern bus fleets are increasingly '
      + 'electrified, further reducing their '
      + 'carbon footprint. Regular bus ridership '
      + 'supports route expansion and service '
      + 'improvements for the whole community.',
    ja:
      '車の代わりにバスを利用すると8kmの'
      + '通勤で約**500gのCO2**を節約でき'
      + 'ます。バスは乗客1人あたり約104g/km、'
      + '自家用車は164g/kmの排出です'
      + '（[DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)）。最新のバス車両は電動化が'
      + '進みカーボンフットプリントがさらに'
      + '小さくなっています。バスの定期利用は'
      + '路線拡充やサービス改善を支えます。',
    es:
      'Tomar el autobus en vez de conducir '
      + 'ahorra aproximadamente **500g de CO2** '
      + 'en un trayecto de 8km. Los autobuses '
      + 'emiten unos 104g/km por pasajero '
      + 'frente a 164g/km de un auto individual '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). Las flotas modernas son cada '
      + 'vez mas electricas, reduciendo aun mas '
      + 'su huella de carbono. El uso regular '
      + 'del autobus apoya la expansion de '
      + 'rutas y mejoras de servicio para toda '
      + 'la comunidad.',
  },

  work_from_home: {
    en:
      'Working from home avoids a 16km '
      + 'roundtrip car commute, saving roughly '
      + '**2,640g of CO2** per day. At 164g/km '
      + 'for a petrol car, this is one of the '
      + 'highest-impact daily actions '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). Over a year of remote work '
      + '(~230 days), this adds up to over '
      + '600kg of CO2 avoided. Home office '
      + 'energy use is typically far less than '
      + 'commuting emissions '
      + '([Energy Saving Trust]'
      + '(https://energysavingtrust.org.uk/)).',
    ja:
      '在宅勤務で往復16kmの車通勤を避ける'
      + 'と1日あたり約**2,640gのCO2**を削減'
      + 'できます。ガソリン車の164g/km換算で'
      + '最も効果の高い日常行動の一つです'
      + '（[DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)）。年間約230日のリモートワーク'
      + 'で600kg以上のCO2を回避できます。'
      + '自宅オフィスのエネルギー消費は通常、'
      + '通勤の排出量よりはるかに少ないです'
      + '（[Energy Saving Trust]'
      + '(https://energysavingtrust.org.uk/)）。',
    es:
      'Trabajar desde casa evita un trayecto '
      + 'de ida y vuelta de 16km en auto, '
      + 'ahorrando aproximadamente **2.640g de '
      + 'CO2** por dia. A 164g/km para un coche '
      + 'de gasolina, esta es una de las '
      + 'acciones diarias de mayor impacto '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). En un ano de trabajo remoto '
      + '(~230 dias), se evitan mas de 600kg '
      + 'de CO2. El consumo energetico en casa '
      + 'es tipicamente mucho menor que las '
      + 'emisiones de desplazamiento '
      + '([Energy Saving Trust]'
      + '(https://energysavingtrust.org.uk/)).',
  },

  escooter_trip: {
    en:
      'Riding an e-scooter instead of '
      + 'driving saves roughly **375g of CO2** '
      + 'on a short urban trip. E-scooters emit '
      + 'about 27-40g/km compared to 164g/km '
      + 'for a petrol car ([DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)). '
      + 'They are ideal for last-mile '
      + 'transportation connecting transit stops '
      + 'to final destinations. Shared e-scooter '
      + 'programs have expanded rapidly in '
      + 'cities worldwide, making them easily '
      + 'accessible.',
    ja:
      '車の代わりに電動キックボードで移動'
      + 'すると短距離の都市移動で約**375gの'
      + 'CO2**を削減できます。電動キック'
      + 'ボードは約27〜40g/km、ガソリン車は'
      + '164g/kmの排出です（[DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)）。'
      + '公共交通の駅から目的地までのラスト'
      + 'マイル移動に最適です。シェアリング'
      + 'サービスが世界中の都市で急速に普及し'
      + '手軽に利用できるようになっています。',
    es:
      'Usar un patinete electrico en vez de '
      + 'conducir ahorra aproximadamente '
      + '**375g de CO2** en un viaje urbano '
      + 'corto. Los patinetes emiten unos '
      + '27-40g/km frente a 164g/km de un coche '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). Son ideales para el transporte '
      + 'de ultima milla conectando paradas de '
      + 'transito con destinos finales. Los '
      + 'programas compartidos se han expandido '
      + 'rapidamente en ciudades de todo el '
      + 'mundo.',
  },

  ev_charging_green: {
    en:
      'Charging your electric vehicle with '
      + 'renewable energy saves about **400g '
      + 'of CO2** per charge session by '
      + 'eliminating grid electricity '
      + 'emissions. Standard grid-charged EVs '
      + 'still emit ~43g/km from fossil fuel '
      + 'power generation ([DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)). '
      + 'Green energy charging makes your EV '
      + 'effectively zero-emission during '
      + 'operation. Solar panels, wind energy '
      + 'tariffs, or green-certified charging '
      + 'stations all qualify '
      + '([Energy Saving Trust]'
      + '(https://energysavingtrust.org.uk/)).',
    ja:
      '再生可能エネルギーでEVを充電すると'
      + '1回の充電あたり約**400gのCO2**を'
      + '削減でき、送電網の化石燃料由来の'
      + '排出を排除できます。通常のEVは'
      + '火力発電由来で約43g/kmを排出します'
      + '（[DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)）。グリーンエネルギー充電に'
      + 'より走行中の実質ゼロエミッションを'
      + '実現できます。太陽光パネルや風力'
      + 'エネルギー、グリーン認証済み充電'
      + 'ステーションが対象です（[Energy '
      + 'Saving Trust](https://energy'
      + 'savingtrust.org.uk/)）。',
    es:
      'Cargar tu vehiculo electrico con '
      + 'energia renovable ahorra unos **400g '
      + 'de CO2** por sesion de carga al '
      + 'eliminar emisiones de la red. Los VE '
      + 'cargados con red estandar aun emiten '
      + '~43g/km por generacion con '
      + 'combustibles fosiles ([DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)). '
      + 'La carga verde hace que tu VE sea '
      + 'efectivamente cero emisiones durante '
      + 'la operacion. Paneles solares, tarifas '
      + 'de energia eolica o estaciones '
      + 'certificadas verdes califican '
      + '([Energy Saving Trust]'
      + '(https://energysavingtrust.org.uk/)).',
  },

  combine_errands: {
    en:
      'Combining multiple errands into a '
      + 'single car trip saves about **300g '
      + 'of CO2** by eliminating cold-start '
      + 'emissions and reducing total mileage. '
      + 'A cold engine produces up to 2x more '
      + 'emissions per kilometer during the '
      + 'first few minutes of driving '
      + '([DEFRA 2024](https://www.gov.uk'
      + '/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)). Planning efficient routes '
      + 'also saves fuel and time. This simple '
      + 'habit is one of the easiest transport '
      + 'changes to adopt.',
    ja:
      '複数の用事を1回の車移動にまとめると'
      + 'コールドスタート時の排出削減と総走行'
      + '距離の短縮で約**300gのCO2**を節約'
      + 'できます。冷えたエンジンは走行開始'
      + '数分間、通常の最大2倍のCO2を排出'
      + 'します（[DEFRA 2024](https://www.gov'
      + '.uk/government/publications/greenhouse'
      + '-gas-reporting-conversion-factors'
      + '-2024)）。効率的なルート計画は燃料と'
      + '時間の節約にもなります。この簡単な'
      + '習慣は最も取り入れやすい交通手段の'
      + '改善の一つです。',
    es:
      'Combinar varias tareas en un solo '
      + 'viaje en auto ahorra unos **300g de '
      + 'CO2** al eliminar emisiones de '
      + 'arranque en frio y reducir el '
      + 'kilometraje total. Un motor frio '
      + 'produce hasta 2 veces mas emisiones '
      + 'por kilometro durante los primeros '
      + 'minutos ([DEFRA 2024]'
      + '(https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2024)). '
      + 'Planificar rutas eficientes tambien '
      + 'ahorra combustible y tiempo. Este '
      + 'simple habito es uno de los cambios '
      + 'de transporte mas faciles de adoptar.',
  },

  // -------------------------------------------------------
  // FOOD (15 actions)
  // -------------------------------------------------------
  meatless_meal_beef: {
    en:
      'Skipping a 100g beef serving avoids '
      + 'roughly **6,000g (6kg) of CO2 '
      + 'equivalent**. Beef has the highest '
      + 'carbon footprint of any common food at '
      + '60kg CO2e/kg across its lifecycle '
      + '([Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)). This includes '
      + 'methane from cattle, feed production, '
      + 'and land-use change. Replacing beef '
      + 'with plant protein even once a week '
      + 'saves over 300kg of CO2 per year '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)).',
    ja:
      '牛肉100gの1食分を避けると約'
      + '**6,000g（6kg）のCO2相当**を削減'
      + 'できます。牛肉はライフサイクル全体で'
      + '60kg CO2e/kgと一般的な食品で最大の'
      + 'カーボンフットプリントです'
      + '（[Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)）。牛のメタン排出、'
      + '飼料生産、土地利用変化が含まれます。'
      + '週1回牛肉を植物性タンパクに替えるだけ'
      + 'で年間300kg以上のCO2を削減できます'
      + '（[Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)）。',
    es:
      'Evitar una porcion de 100g de carne '
      + 'de res evita aproximadamente **6.000g '
      + '(6kg) de CO2 equivalente**. La carne '
      + 'de res tiene la mayor huella de '
      + 'carbono entre alimentos comunes: 60kg '
      + 'CO2e/kg en su ciclo de vida '
      + '([Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)). Esto incluye '
      + 'metano del ganado, produccion de '
      + 'pienso y cambio de uso del suelo. '
      + 'Reemplazar la res con proteina vegetal '
      + 'una vez por semana ahorra mas de 300kg '
      + 'de CO2 al ano ([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)).',
  },

  meatless_meal_chicken: {
    en:
      'Choosing a meatless meal instead of '
      + 'chicken saves about **600g of CO2 '
      + 'equivalent** per 100g serving. Chicken '
      + 'emits ~6kg CO2e/kg across its '
      + 'lifecycle, including feed crops, '
      + 'processing, and transport '
      + '([Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)). While lower-impact '
      + 'than beef, chicken still has 10-20x '
      + 'the footprint of most plant proteins '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)). '
      + 'Legumes, tofu, and tempeh are '
      + 'excellent protein alternatives.',
    ja:
      '鶏肉の代わりに肉なし料理を選ぶと'
      + '100gあたり約**600gのCO2相当**を'
      + '節約できます。鶏肉はライフサイクル'
      + '全体で約6kg CO2e/kgの排出で、飼料'
      + '作物、加工、輸送が含まれます'
      + '（[Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)）。牛肉より低い'
      + 'ものの植物性タンパク質の10〜20倍の'
      + 'フットプリントです（[Our World in '
      + 'Data](https://ourworldindata.org'
      + '/environmental-impacts-of-food)）。'
      + '豆類、豆腐、テンペが優れた代替品'
      + 'です。',
    es:
      'Elegir una comida sin carne en vez de '
      + 'pollo ahorra unos **600g de CO2 '
      + 'equivalente** por porcion de 100g. '
      + 'El pollo emite ~6kg CO2e/kg en su '
      + 'ciclo de vida, incluyendo cultivos '
      + 'para pienso, procesamiento y '
      + 'transporte ([Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)). Aunque menor que '
      + 'la res, el pollo tiene 10-20 veces la '
      + 'huella de la mayoria de proteinas '
      + 'vegetales ([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)). '
      + 'Legumbres, tofu y tempeh son '
      + 'excelentes alternativas.',
  },

  meatless_meal_pork: {
    en:
      'Replacing a 100g pork serving with '
      + 'a plant-based meal saves about '
      + '**700g of CO2 equivalent**. Pork '
      + 'emits approximately 7kg CO2e/kg '
      + 'across its lifecycle, driven by feed '
      + 'production and manure management '
      + '([Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)). Pork production '
      + 'also requires significant water and '
      + 'generates nitrate runoff that pollutes '
      + 'waterways. Mushrooms, lentils, and '
      + 'jackfruit offer satisfying texture '
      + 'alternatives.',
    ja:
      '豚肉100gを植物性の食事に替えると約'
      + '**700gのCO2相当**を削減できます。'
      + '豚肉はライフサイクル全体で約7kg '
      + 'CO2e/kgを排出し、飼料生産と糞尿'
      + '管理が主な要因です（[Poore & '
      + 'Nemecek 2018](https://ourworldindata'
      + '.org/food-choice-vs-eating-local)）。'
      + '豚肉生産は大量の水も必要とし、水路を'
      + '汚染する硝酸塩流出も発生させます。'
      + 'きのこ、レンズ豆、ジャックフルーツが'
      + '食感の良い代替食品です。',
    es:
      'Reemplazar una porcion de 100g de '
      + 'cerdo con una comida vegetal ahorra '
      + 'unos **700g de CO2 equivalente**. '
      + 'El cerdo emite aproximadamente 7kg '
      + 'CO2e/kg en su ciclo de vida, impulsado '
      + 'por la produccion de pienso y el '
      + 'manejo de estiercol ([Poore & '
      + 'Nemecek 2018](https://ourworldindata'
      + '.org/food-choice-vs-eating-local)). '
      + 'La produccion porcina tambien requiere '
      + 'mucha agua y genera escorrentia de '
      + 'nitratos. Hongos, lentejas y jackfruit '
      + 'ofrecen alternativas satisfactorias.',
  },

  no_food_waste: {
    en:
      'Preventing daily food waste avoids '
      + 'roughly **400g of CO2 equivalent** '
      + 'by keeping organic matter out of '
      + 'landfills. The [EPA](https://www.epa'
      + '.gov/land-research/quantifying-methane'
      + '-emissions-landfilled-food-waste) '
      + 'reports that 58% of fugitive methane '
      + 'from landfills originates from food '
      + 'waste. Planning meals, using shopping '
      + 'lists, and storing food properly are '
      + 'effective strategies. Globally, about '
      + 'one-third of all food produced is '
      + 'wasted, making this a critical area '
      + 'for climate action.',
    ja:
      '毎日の食品ロスを防ぐと約**400gの'
      + 'CO2相当**を回避できます。有機物を'
      + '埋立地から遠ざけるためです。[EPA]'
      + '(https://www.epa.gov/land-research'
      + '/quantifying-methane-emissions-'
      + 'landfilled-food-waste)によると埋立地'
      + 'からの逸散メタンの58%は食品廃棄物'
      + '由来です。献立計画、買い物リストの'
      + '活用、適切な食品保存が有効な対策です。'
      + '世界で生産される食料の約3分の1が廃棄'
      + 'されており、気候変動対策の重要な分野'
      + 'です。',
    es:
      'Evitar el desperdicio diario de '
      + 'alimentos previene aproximadamente '
      + '**400g de CO2 equivalente** al '
      + 'mantener materia organica fuera de '
      + 'vertederos. La [EPA](https://www.epa'
      + '.gov/land-research/quantifying-methane'
      + '-emissions-landfilled-food-waste) '
      + 'informa que el 58% del metano fugitivo '
      + 'de vertederos proviene de residuos '
      + 'alimentarios. Planificar comidas, usar '
      + 'listas de compras y almacenar '
      + 'correctamente son estrategias '
      + 'efectivas. Globalmente, un tercio de '
      + 'los alimentos producidos se desperdicia.',
  },

  local_produce: {
    en:
      'Buying local produce saves about '
      + '**200g of CO2** per shopping trip by '
      + 'cutting transportation emissions. '
      + '[Our World in Data]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local) shows that transport '
      + 'accounts for 5-6% of total food '
      + 'emissions. Local sourcing eliminates '
      + 'long-haul trucking and airfreight. '
      + 'Farmers markets and community-supported '
      + 'agriculture programs connect consumers '
      + 'directly with regional growers, also '
      + 'supporting the local economy.',
    ja:
      '地元の農産物を買うと1回の買い物で約'
      + '**200gのCO2**を削減でき、輸送時の'
      + '排出を抑えられます。[Our World in '
      + 'Data](https://ourworldindata.org'
      + '/food-choice-vs-eating-local)によると'
      + '輸送は食品排出量全体の5〜6%を占め'
      + 'ます。地元調達は長距離トラック輸送や'
      + '航空貨物をなくします。農産物直売所や'
      + '産直提携で消費者と地域の生産者が直接'
      + 'つながり、地域経済の活性化にも貢献'
      + 'します。',
    es:
      'Comprar productos locales ahorra '
      + 'unos **200g de CO2** por compra al '
      + 'reducir emisiones de transporte. '
      + '[Our World in Data]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local) muestra que el '
      + 'transporte representa el 5-6% de las '
      + 'emisiones totales de alimentos. '
      + 'El abastecimiento local elimina el '
      + 'transporte de larga distancia. Los '
      + 'mercados de agricultores y programas '
      + 'de agricultura comunitaria conectan '
      + 'directamente a consumidores con '
      + 'productores regionales.',
  },

  plant_milk: {
    en:
      'Choosing plant milk over dairy saves '
      + 'roughly **460g of CO2** per 250ml '
      + 'serving. Dairy milk emits about 3.2kg '
      + 'CO2 per liter versus 0.4-1.0kg for '
      + 'plant alternatives ([Poore & '
      + 'Nemecek 2018](https://ourworldindata'
      + '.org/food-choice-vs-eating-local)). '
      + 'Oat milk has the lowest footprint '
      + 'among plant milks, followed by soy '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)). '
      + 'Dairy also requires 10x more land and '
      + '2-3x more water per liter than most '
      + 'plant milks.',
    ja:
      '乳製品の代わりに植物性ミルクを選ぶと'
      + '250mlあたり約**460gのCO2**を削減'
      + 'できます。牛乳は1リットルあたり約'
      + '3.2kgのCO2を排出するのに対し、'
      + '植物性は0.4〜1.0kgです（[Poore & '
      + 'Nemecek 2018](https://ourworldindata'
      + '.org/food-choice-vs-eating-local)）。'
      + 'オーツミルクが植物性ミルクの中で最も'
      + '環境負荷が低く、次に豆乳です'
      + '（[Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)）。'
      + '乳製品は植物性に比べ土地は10倍、水は'
      + '2〜3倍必要です。',
    es:
      'Elegir leche vegetal en vez de lactea '
      + 'ahorra aproximadamente **460g de CO2** '
      + 'por porcion de 250ml. La leche lactea '
      + 'emite unos 3,2kg de CO2 por litro '
      + 'frente a 0,4-1,0kg para alternativas '
      + 'vegetales ([Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)). La leche de avena '
      + 'tiene la menor huella entre las '
      + 'vegetales, seguida por la de soja '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)). '
      + 'Los lacteos requieren 10 veces mas '
      + 'tierra y 2-3 veces mas agua por litro.',
  },

  seasonal_produce: {
    en:
      'Buying seasonal produce saves roughly '
      + '**500g of CO2** per purchase by '
      + 'avoiding energy-intensive greenhouse '
      + 'cultivation. Out-of-season fruits and '
      + 'vegetables grown in heated greenhouses '
      + 'use 5-10x more energy than seasonal '
      + 'outdoor farming ([Carbon Brief]'
      + '(https://interactive.carbonbrief.org'
      + '/what-is-the-climate-impact-of-eating'
      + '-meat-and-dairy/index.html)). '
      + 'Seasonal produce is also typically '
      + 'fresher and more nutritious. Eating '
      + 'with the seasons connects you to '
      + 'local agricultural rhythms.',
    ja:
      '旬の農産物を買うと1回の購入で約'
      + '**500gのCO2**を削減できます。'
      + 'エネルギー集約的なハウス栽培を避ける'
      + 'ためです。旬でない果物や野菜を加温'
      + 'ハウスで栽培すると、露地の季節栽培'
      + 'より5〜10倍のエネルギーを使います'
      + '（[Carbon Brief]'
      + '(https://interactive.carbonbrief.org'
      + '/what-is-the-climate-impact-of-eating'
      + '-meat-and-dairy/index.html)）。'
      + '旬の食材は鮮度も栄養価も高いのが'
      + '一般的です。旬を意識した食生活は地域'
      + 'の農業リズムとのつながりを生みます。',
    es:
      'Comprar productos de temporada ahorra '
      + 'aproximadamente **500g de CO2** por '
      + 'compra al evitar el cultivo intensivo '
      + 'en invernaderos. Las frutas y verduras '
      + 'fuera de temporada cultivadas en '
      + 'invernaderos calefactados usan 5-10 '
      + 'veces mas energia ([Carbon Brief]'
      + '(https://interactive.carbonbrief.org'
      + '/what-is-the-climate-impact-of-eating'
      + '-meat-and-dairy/index.html)). '
      + 'Los productos de temporada son '
      + 'tipicamente mas frescos y nutritivos. '
      + 'Comer con las estaciones te conecta '
      + 'con los ritmos agricolas locales.',
  },

  home_cooked_meal: {
    en:
      'Cooking at home instead of ordering '
      + 'out saves roughly **350g of CO2** by '
      + 'avoiding delivery transport, excess '
      + 'packaging, and restaurant energy '
      + 'overhead. Takeout meals generate 3-5x '
      + 'more packaging waste than home-cooked '
      + 'equivalents. Home cooking also gives '
      + 'you control over ingredient sourcing '
      + 'and portion sizes, further reducing '
      + 'food waste. Batch cooking multiplies '
      + 'these savings across several meals '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)).',
    ja:
      '外食やデリバリーの代わりに自炊すると'
      + '約**350gのCO2**を削減できます。'
      + '配達の輸送、過剰包装、飲食店の'
      + 'エネルギー消費を回避するためです。'
      + 'テイクアウトは自炊の3〜5倍の包装'
      + 'ゴミを出します。自炊は食材の選択や'
      + '量のコントロールが可能で食品ロス'
      + '削減にもつながります。作り置きなら'
      + '複数食分の効果を倍増できます'
      + '（[Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)）。',
    es:
      'Cocinar en casa en vez de pedir '
      + 'comida ahorra aproximadamente **350g '
      + 'de CO2** al evitar el transporte de '
      + 'entrega, exceso de empaques y el gasto '
      + 'energetico de restaurantes. Las '
      + 'comidas para llevar generan 3-5 veces '
      + 'mas residuos de empaque. Cocinar en '
      + 'casa tambien permite controlar la '
      + 'procedencia de ingredientes y las '
      + 'porciones, reduciendo el desperdicio '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)). '
      + 'Cocinar por lotes multiplica estos '
      + 'ahorros en varias comidas.',
  },

  skip_fish_meal: {
    en:
      'Skipping a 100g fish serving saves '
      + 'roughly **400g of CO2 equivalent**, '
      + 'depending on the species. Fish emits '
      + '4-6kg CO2e/kg when accounting for '
      + 'fuel-intensive trawling, refrigeration, '
      + 'and transport ([Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)). Wild-caught '
      + 'shrimp has among the highest footprints '
      + 'in seafood. Choosing plant-based '
      + 'alternatives also helps protect marine '
      + 'ecosystems from overfishing '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)).',
    ja:
      '魚料理100gを避けると種類により約'
      + '**400gのCO2相当**を削減できます。'
      + '魚介類は燃料集約的なトロール漁、冷蔵、'
      + '輸送を含めると4〜6kg CO2e/kgを排出'
      + 'します（[Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)）。天然エビは水産物'
      + 'の中で最大級のフットプリントです。'
      + '植物性の代替食品は海洋生態系の乱獲'
      + '防止にも貢献します（[Our World in '
      + 'Data](https://ourworldindata.org'
      + '/environmental-impacts-of-food)）。',
    es:
      'Evitar una porcion de 100g de pescado '
      + 'ahorra aproximadamente **400g de CO2 '
      + 'equivalente**, dependiendo de la '
      + 'especie. El pescado emite 4-6kg '
      + 'CO2e/kg considerando la pesca con '
      + 'arrastre, refrigeracion y transporte '
      + '([Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)). El camaron '
      + 'silvestre tiene una de las mayores '
      + 'huellas entre los mariscos. Elegir '
      + 'alternativas vegetales tambien ayuda a '
      + 'proteger los ecosistemas marinos '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)).',
  },

  vegan_day: {
    en:
      'Eating fully plant-based for a day '
      + 'saves roughly **7,000g (7kg) of CO2 '
      + 'equivalent** compared to a standard '
      + 'omnivore diet. This accounts for '
      + 'avoided emissions from meat, dairy, '
      + 'and eggs across all meals '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)). '
      + 'A vegan diet uses 75% less land and '
      + '50% less water than a meat-heavy diet '
      + '([Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)). Even one vegan day '
      + 'per week saves over 350kg of CO2 '
      + 'annually.',
    ja:
      '1日完全に植物性の食事にすると標準的な'
      + '雑食と比べ約**7,000g（7kg）のCO2'
      + '相当**を削減できます。全食事での肉、'
      + '乳製品、卵の回避分を含みます'
      + '（[Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)）。'
      + 'ビーガン食は肉食中心の食事より土地を'
      + '75%、水を50%少なく使います'
      + '（[Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)）。週1日でも年間'
      + '350kg以上のCO2を節約できます。',
    es:
      'Comer completamente vegetal por un dia '
      + 'ahorra aproximadamente **7.000g (7kg) '
      + 'de CO2 equivalente** comparado con una '
      + 'dieta omnivora estandar. Esto incluye '
      + 'las emisiones evitadas de carne, '
      + 'lacteos y huevos en todas las comidas '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)). '
      + 'Una dieta vegana usa 75% menos tierra '
      + 'y 50% menos agua ([Poore & '
      + 'Nemecek 2018](https://ourworldindata'
      + '.org/food-choice-vs-eating-local)). '
      + 'Incluso un dia vegano por semana ahorra '
      + 'mas de 350kg de CO2 al ano.',
  },

  bring_lunch: {
    en:
      'Bringing lunch from home saves '
      + 'roughly **300g of CO2** by avoiding '
      + 'takeout packaging and delivery '
      + 'emissions. Restaurant and delivery '
      + 'meals use single-use containers, '
      + 'plastic cutlery, and bags that each '
      + 'carry their own carbon footprint. '
      + 'A reusable lunch container eliminates '
      + 'this waste stream entirely. Over a '
      + 'year of workdays (~230), bringing '
      + 'lunch can save nearly 70kg of CO2 '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)).',
    ja:
      'お弁当を持参すると約**300gのCO2**を'
      + '削減でき、テイクアウトの包装や配達の'
      + '排出を回避できます。外食やデリバリー'
      + 'は使い捨て容器、プラスチック製カト'
      + 'ラリー、袋を使い各々にカーボンフット'
      + 'プリントがあります。再利用可能な弁当'
      + '箱でこの廃棄物を完全になくせます。'
      + '年間約230日のお弁当持参で約70kgの'
      + 'CO2を削減できます（[Our World in '
      + 'Data](https://ourworldindata.org'
      + '/environmental-impacts-of-food)）。',
    es:
      'Llevar almuerzo de casa ahorra '
      + 'aproximadamente **300g de CO2** al '
      + 'evitar empaques de comida para llevar '
      + 'y emisiones de entrega. Las comidas de '
      + 'restaurante usan envases desechables, '
      + 'cubiertos de plastico y bolsas, cada '
      + 'uno con su propia huella de carbono. '
      + 'Un recipiente reutilizable elimina '
      + 'estos residuos por completo. En un ano '
      + 'laboral (~230 dias), llevar almuerzo '
      + 'puede ahorrar casi 70kg de CO2 '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)).',
  },

  use_leftovers: {
    en:
      'Using leftovers instead of discarding '
      + 'them prevents roughly **400g of CO2 '
      + 'equivalent** by keeping food out of '
      + 'landfills. The [EPA](https://www.epa'
      + '.gov/land-research/quantifying-methane'
      + '-emissions-landfilled-food-waste) '
      + 'confirms that landfilled food waste is '
      + 'a major source of methane, a potent '
      + 'greenhouse gas. Repurposing leftovers '
      + 'into new meals also saves the embedded '
      + 'carbon from producing that food in the '
      + 'first place. Creative recipes can '
      + 'transform yesterday\'s dinner into '
      + 'today\'s lunch.',
    ja:
      '残り物を捨てずに活用すると約**400g'
      + 'のCO2相当**を防ぎ、食品を埋立地から'
      + '遠ざけられます。[EPA]'
      + '(https://www.epa.gov/land-research'
      + '/quantifying-methane-emissions-'
      + 'landfilled-food-waste)は埋立地の'
      + '食品廃棄物が強力な温室効果ガスである'
      + 'メタンの主要発生源であると報告して'
      + 'います。残り物を新しい料理にリメイク'
      + 'すれば食品生産に含まれる炭素も節約'
      + 'できます。工夫次第で昨日の夕食が今日'
      + 'のランチに生まれ変わります。',
    es:
      'Usar las sobras en vez de tirarlas '
      + 'evita aproximadamente **400g de CO2 '
      + 'equivalente** al mantener alimentos '
      + 'fuera de vertederos. La [EPA]'
      + '(https://www.epa.gov/land-research'
      + '/quantifying-methane-emissions-'
      + 'landfilled-food-waste) confirma que '
      + 'los residuos alimentarios en '
      + 'vertederos son una fuente importante '
      + 'de metano. Reutilizar sobras en nuevas '
      + 'comidas tambien ahorra el carbono '
      + 'incorporado en producir esos alimentos. '
      + 'Recetas creativas pueden transformar '
      + 'la cena de ayer en el almuerzo de hoy.',
  },

  no_single_use_cutlery: {
    en:
      'Refusing single-use plastic cutlery '
      + 'saves about **5g of CO2** per utensil '
      + 'set by avoiding petroleum-based '
      + 'manufacturing. While small per '
      + 'instance, disposable cutlery adds up '
      + 'quickly: a daily habit saves nearly '
      + '2kg of CO2 per year. Carrying reusable '
      + 'utensils also keeps plastic out of '
      + 'landfills where it persists for '
      + 'centuries ([Danish EPA]'
      + '(https://www2.mst.dk/udgiv'
      + '/publications/2018/02'
      + '/978-87-93614-73-4.pdf)). '
      + 'Bamboo and stainless steel sets are '
      + 'durable, portable alternatives.',
    ja:
      '使い捨てプラスチック製カトラリーを'
      + '断ると1セットあたり約**5gのCO2**を'
      + '削減でき、石油由来の製造を回避します。'
      + '1回あたりは小さくても毎日の習慣で'
      + '年間約2kgのCO2を節約できます。'
      + 'マイカトラリーの持参はプラスチックが'
      + '何百年も残る埋立地への流出も防ぎます'
      + '（[デンマーク環境庁](https://www2'
      + '.mst.dk/udgiv/publications/2018/02'
      + '/978-87-93614-73-4.pdf)）。'
      + '竹やステンレス製のセットが丈夫で'
      + '持ち運びやすい代替品です。',
    es:
      'Rechazar cubiertos de plastico de un '
      + 'solo uso ahorra unos **5g de CO2** por '
      + 'juego de utensilios al evitar la '
      + 'fabricacion con petroleo. Aunque '
      + 'pequeno por instancia, los cubiertos '
      + 'desechables se acumulan: un habito '
      + 'diario ahorra casi 2kg de CO2 al ano. '
      + 'Llevar cubiertos reutilizables tambien '
      + 'evita que el plastico llegue a '
      + 'vertederos donde persiste por siglos '
      + '([EPA Danesa](https://www2.mst.dk'
      + '/udgiv/publications/2018/02'
      + '/978-87-93614-73-4.pdf)). '
      + 'Sets de bambu y acero inoxidable son '
      + 'alternativas duraderas y portatiles.',
  },

  drink_tap_water: {
    en:
      'Drinking tap water instead of bottled '
      + 'saves roughly **80g of CO2** per '
      + '500ml bottle avoided. Bottled water '
      + 'has approximately 300 times the carbon '
      + 'footprint of tap water when accounting '
      + 'for plastic production, filling, and '
      + 'transport. A reusable bottle pays back '
      + 'its carbon cost after just a few uses '
      + '([EPA GHG Equivalencies]'
      + '(https://www.epa.gov/energy/greenhouse'
      + '-gas-equivalencies-calculator)). '
      + 'Tap water is also subject to stricter '
      + 'safety testing than bottled water in '
      + 'most countries.',
    ja:
      'ペットボトルの代わりに水道水を飲むと'
      + '500mlボトル1本あたり約**80gのCO2**'
      + 'を削減できます。ペットボトルの水は'
      + 'プラスチック製造、充填、輸送を含める'
      + 'と水道水の約300倍のカーボンフット'
      + 'プリントがあります。マイボトルは数回'
      + 'の使用で炭素コストを回収できます'
      + '（[EPA温室効果ガス等価計算ツール]'
      + '(https://www.epa.gov/energy/greenhouse'
      + '-gas-equivalencies-calculator)）。'
      + '多くの国で水道水はペットボトル水より'
      + '厳しい安全検査が義務付けられています。',
    es:
      'Beber agua del grifo en vez de '
      + 'embotellada ahorra aproximadamente '
      + '**80g de CO2** por botella de 500ml '
      + 'evitada. El agua embotellada tiene '
      + 'unas 300 veces la huella de carbono '
      + 'del agua del grifo considerando '
      + 'produccion de plastico, llenado y '
      + 'transporte. Una botella reutilizable '
      + 'recupera su costo de carbono en pocos '
      + 'usos ([Calculadora GEI EPA]'
      + '(https://www.epa.gov/energy/greenhouse'
      + '-gas-equivalencies-calculator)). '
      + 'En la mayoria de paises, el agua del '
      + 'grifo tiene controles de seguridad mas '
      + 'estrictos que la embotellada.',
  },

  reduce_dairy: {
    en:
      'Reducing dairy intake by swapping a '
      + '50g cheese serving saves roughly '
      + '**350g of CO2 equivalent**. Cheese '
      + 'emits about 21kg CO2e/kg due to '
      + 'methane from cattle, energy-intensive '
      + 'processing, and refrigeration '
      + '([Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)). Plant-based cheese '
      + 'alternatives emit a fraction of this '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)). '
      + 'Even small reductions in dairy '
      + 'consumption make a meaningful '
      + 'difference over time.',
    ja:
      'チーズ50gを植物性に替えると約**350g'
      + 'のCO2相当**を削減できます。チーズは'
      + '牛のメタン排出、エネルギー集約的な'
      + '加工、冷蔵により約21kg CO2e/kgを'
      + '排出します（[Poore & Nemecek 2018]'
      + '(https://ourworldindata.org/food-choice'
      + '-vs-eating-local)）。植物性チーズの'
      + '代替品はその何分の一かの排出量です'
      + '（[Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)）。'
      + '乳製品の消費を少し減らすだけでも長期'
      + '的には大きな違いを生みます。',
    es:
      'Reducir el consumo de lacteos '
      + 'sustituyendo una porcion de 50g de '
      + 'queso ahorra aproximadamente **350g '
      + 'de CO2 equivalente**. El queso emite '
      + 'unos 21kg CO2e/kg debido al metano '
      + 'del ganado, procesamiento intensivo '
      + 'y refrigeracion ([Poore & '
      + 'Nemecek 2018](https://ourworldindata'
      + '.org/food-choice-vs-eating-local)). '
      + 'Las alternativas vegetales emiten una '
      + 'fraccion de esto ([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)). '
      + 'Incluso pequenas reducciones en el '
      + 'consumo de lacteos marcan la '
      + 'diferencia con el tiempo.',
  },
};

module.exports = descriptions;
