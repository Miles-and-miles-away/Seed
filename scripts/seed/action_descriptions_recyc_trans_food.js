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
  // RECYCLING (11 actions)
  // -------------------------------------------------------
  recycle_aluminum_can: {
    en:
      'Recycling a single aluminium can saves '
      + 'roughly **100g** of CO2 compared to '
      + 'smelting one from raw bauxite ore. '
      + 'The process requires just 5% of the '
      + 'energy needed for primary production '
      + '([International Aluminium Institute]'
      + '(https://international-aluminium.org'
      + '/landing/aluminium-recycling-saves-95'
      + '-of-the-energy-needed-for-primary-'
      + 'aluminium-production/)). '
      + 'Unlike most materials, aluminium can be '
      + 'recycled infinitely with no quality '
      + 'loss ([Aluminum Association]'
      + '(https://www.aluminum.org/Recycling)). '
      + 'A single can returns to store shelves '
      + 'as a new can in as little as 60 days.',
    ja:
      'アルミ缶1本のリサイクルで、原料の'
      + 'ボーキサイトから精錬する場合に比べ'
      + '約**100g**のCO2を削減できます'
      + '。'
      + 'リサイクルに必要なエネルギーは一次'
      + '生産のわずか5%です'
      + '（[International Aluminium Institute]'
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
      + 'ahorra aproximadamente **100g** de '
      + 'CO2 '
      + 'en comparación con fundir una nueva '
      + 'desde bauxita. El proceso requiere '
      + 'solo el 5% de la energía necesaria '
      + 'para la producción primaria '
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
      + 'estantes en solo 60 días.',
  },

  recycle_plastic_bottle: {
    en:
      'Recycling a standard 28g PET plastic '
      + 'bottle prevents roughly **50g** of CO2 '
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
      + 'すると約**50g**のCO2排出を防げます。'
      + '[EPA WARM model](https://www.epa.gov'
      + '/warm)によると、リサイクルPETは'
      + 'エネルギー集約的なバージン樹脂の'
      + '生産を代替します。リサイクルにより'
      + '分解に450年以上かかるプラスチックが'
      + '埋立地や海洋に流出するのも防げます。',
    es:
      'Reciclar una botella estándar de PET '
      + 'de 28g evita que aproximadamente '
      + '**50g** de CO2 lleguen a la atmósfera. '
      + 'El [EPA WARM model]'
      + '(https://www.epa.gov/warm) calcula que '
      + 'el PET reciclado desplaza la producción '
      + 'de resina virgen, un proceso muy '
      + 'intensivo en energía. Cada botella '
      + 'reciclada también evita que plástico '
      + 'persistente termine en vertederos u '
      + 'océanos, donde tarda más de 450 años '
      + 'en descomponerse.',
  },

  recycle_cardboard: {
    en:
      'Recycling one cardboard box of '
      + 'about 230g saves about **840g** of '
      + 'CO2 compared with landfill. '
      + 'Recycling corrugated cardboard '
      + 'saves about 3.66kg of CO2 per '
      + 'kilogram ([EPA WARM]'
      + '(https://www.epa.gov/system/files/documents/2023-12/warm_con'
      + 'tainers_packaging_and_non-durable_goods_materials_v16_dec.pd'
      + 'f)'
      + '). The figure comes from US data. '
      + 'Flatten the box and keep it dry so '
      + 'that it can be recycled.',
    ja:
      '約230gの段ボール箱を1つリサイク'
      + 'ルすると、埋め立てに比べて約**84'
      + '0g**のCO2を削減できます。段ボ'
      + 'ールのリサイクルは、1kgあたり約3'
      + '.66kgのCO2を削減します（[E'
      + 'PA WARM]'
      + '(https://www.epa.gov/system/files/documents/2023-12/warm_con'
      + 'tainers_packaging_and_non-durable_goods_materials_v16_dec.pd'
      + 'f)'
      + '）。この数値は米国のデータに基づいて'
      + 'います。リサイクルできるように、箱は'
      + '潰して乾いた状態で出しましょう。',
    es:
      'Reciclar una caja de cartón de unos '
      + '230g ahorra unos **840g** de CO2 '
      + 'frente al vertedero. Reciclar '
      + 'cartón ondulado ahorra unos 3,66kg '
      + 'de CO2 por kilogramo ([EPA WARM]'
      + '(https://www.epa.gov/system/files/documents/2023-12/warm_con'
      + 'tainers_packaging_and_non-durable_goods_materials_v16_dec.pd'
      + 'f)'
      + '). La cifra procede de datos de '
      + 'Estados Unidos. Aplana la caja y '
      + 'mantenla seca para que se pueda '
      + 'reciclar.',
  },

  composting: {
    en:
      'Composting food scraps prevents about '
      + '**200g** of CO2 equivalent per session '
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
      + '**200g**のCO2相当を削減します。'
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
      + 'aproximadamente **200g** de CO2 '
      + 'equivalente por sesión al desviar '
      + 'residuos orgánicos de vertederos. La '
      + '[EPA](https://www.epa.gov/land-research'
      + '/quantifying-methane-emissions-'
      + 'landfilled-food-waste) informa que el '
      + '58% del metano fugitivo de vertederos '
      + 'proviene de residuos alimentarios. '
      + 'El metano es 80 veces más potente que '
      + 'el CO2 en 20 años, haciendo del '
      + 'compostaje una acción climática '
      + 'poderosa. El compost resultante '
      + 'enriquece el suelo y reduce la '
      + 'necesidad de fertilizantes sintéticos.',
  },

  recycle_glass: {
    en:
      'Recycling a typical ~250g glass jar instead of sending it to landf'
      + 'ill saves about **80g** of CO2, mostly by reducing the energy need'
      + 'ed to melt raw materials. The US EPA puts the saving at about 0.33'
      + 'kg of CO2 per kg of glass ([EPA WARM v16](https://www.epa.gov/warm'
      + '/documentation-chapters-greenhouse-gas-emission-and-energy-factors'
      + '-used-waste-reduction-model)). Like aluminium, glass can be recycl'
      + 'ed again and again.',
    ja:
      '標準的な約250gのガラス瓶1本を埋め立てずにリサイクルすると、約**80g**のCO2を削減できます。主に原料を溶かすエネルギーが'
      + '減るためです。米国EPAはガラス1kgあたり約0.33kgのCO2削減としています（[EPA WARM v16](https://w'
      + 'ww.epa.gov/warm/documentation-chapters-greenhouse-gas-emission-and'
      + '-energy-factors-used-waste-reduction-model)）。アルミニウムと同じく、ガラスは何度でもリサ'
      + 'イクルできます。',
    es:
      'Reciclar un frasco de vidrio típico de ~250g en vez de llevarlo al'
      + ' vertedero ahorra unos **80g** de CO2, sobre todo porque se necesi'
      + 'ta menos energía para fundir las materias primas. La EPA de EE. UU'
      + '. calcula un ahorro de unos 0,33kg de CO2 por kg de vidrio ([EPA W'
      + 'ARM v16](https://www.epa.gov/warm/documentation-chapters-greenhous'
      + 'e-gas-emission-and-energy-factors-used-waste-reduction-model)). Co'
      + 'mo el aluminio, el vidrio se puede reciclar una y otra vez.',
  },


  recycle_paper: {
    en:
      'Recycling about 100g of paper, '
      + 'around 20 sheets of office paper, '
      + 'saves about **390g** of CO2 '
      + 'compared with landfill. Recycling '
      + 'mixed household paper saves about '
      + '3.9kg of CO2 per kilogram ([EPA '
      + 'WARM]'
      + '(https://www.epa.gov/system/files/documents/2023-12/warm_con'
      + 'tainers_packaging_and_non-durable_goods_materials_v16_dec.pd'
      + 'f)'
      + '). The figure comes from US data. '
      + 'Keep paper clean and dry so that it '
      + 'can be recycled.',
    ja:
      '約100gの紙（コピー用紙およそ20'
      + '枚）をリサイクルすると、埋め立てに比'
      + 'べて約**390g**のCO2を削減'
      + 'できます。家庭から出る雑紙のリサイク'
      + 'ルは、1kgあたり約3.9kgのCO'
      + '2を削減します（[EPA WARM]'
      + '(https://www.epa.gov/system/files/documents/2023-12/warm_con'
      + 'tainers_packaging_and_non-durable_goods_materials_v16_dec.pd'
      + 'f)'
      + '）。この数値は米国のデータに基づいて'
      + 'います。リサイクルできるように、紙は'
      + '汚さず乾いた状態で出しましょう。',
    es:
      'Reciclar unos 100g de papel, unas '
      + '20 hojas de papel de oficina, '
      + 'ahorra unos **390g** de CO2 frente '
      + 'al vertedero. Reciclar papel '
      + 'doméstico mezclado ahorra unos '
      + '3,9kg de CO2 por kilogramo ([EPA '
      + 'WARM]'
      + '(https://www.epa.gov/system/files/documents/2023-12/warm_con'
      + 'tainers_packaging_and_non-durable_goods_materials_v16_dec.pd'
      + 'f)'
      + '). La cifra procede de datos de '
      + 'Estados Unidos. Mantén el papel '
      + 'limpio y seco para que se pueda '
      + 'reciclar.',
  },

  recycle_ewaste: {
    en:
      'Recycling one old phone saves about '
      + '**210g** of CO2. The figure is per '
      + 'phone: recycling portable '
      + 'electronics saves about 1.2kg of '
      + 'CO2 per kilogram compared with '
      + 'landfill ([EPA WARM]'
      + '(https://www.epa.gov/system/files/documents/2023-12/warm_ele'
      + 'ctronics_v16_dec.pdf)'
      + '), and a current smartphone such as '
      + 'the iPhone 17 weighs 177g. A '
      + 'heavier device such as a laptop '
      + 'saves more. The same EPA data puts '
      + 'the saving from not making a device '
      + 'more than 25 times higher, so use a '
      + 'phone for as long as you can and '
      + 'recycle it when it can no longer be '
      + 'used or passed on.',
    ja:
      '古い携帯電話を1台リサイクルすると、'
      + '約**210g**のCO2を削減でき'
      + 'ます。この数値は1台あたりのものです'
      + '。携帯型電子機器のリサイクルは、埋め'
      + '立てに比べて1kgあたり約1.2kg'
      + 'のCO2を削減でき（[EPA WAR'
      + 'M]'
      + '(https://www.epa.gov/system/files/documents/2023-12/warm_ele'
      + 'ctronics_v16_dec.pdf)'
      + '）、iPhone 17のような現行の'
      + 'スマートフォンの重さは177gです。'
      + 'ノートパソコンのような重い機器なら、'
      + '削減量はさらに大きくなります。同じE'
      + 'PAのデータでは、機器を新たに作らな'
      + 'いことによる削減量はその25倍以上に'
      + 'なるため、携帯電話はできるだけ長く使'
      + 'い、使うことも譲ることもできなくなっ'
      + 'たときにリサイクルしましょう。',
    es:
      'Reciclar un móvil viejo ahorra unos '
      + '**210g** de CO2. La cifra es por '
      + 'móvil: reciclar dispositivos '
      + 'electrónicos portátiles ahorra unos '
      + '1,2kg de CO2 por kilogramo frente '
      + 'al vertedero ([EPA WARM]'
      + '(https://www.epa.gov/system/files/documents/2023-12/warm_ele'
      + 'ctronics_v16_dec.pdf)'
      + '), y un smartphone actual como el '
      + 'iPhone 17 pesa 177g. Un dispositivo '
      + 'más pesado, como un portátil, '
      + 'ahorra más. Los mismos datos de la '
      + 'EPA sitúan el ahorro de no fabricar '
      + 'un dispositivo más de 25 veces por '
      + 'encima, así que usa el móvil todo '
      + 'el tiempo que puedas y recíclalo '
      + 'cuando ya no se pueda usar ni dar a '
      + 'otra persona.',
  },

  recycle_textiles: {
    en:
      'Putting one worn-out T-shirt in a textile bank instead of th'
      + 'e bin saves about **120g** of CO2. A cotton T-shirt weighs a'
      + 'bout 0.25kg ([WRAP](https://web.archive.org/web/2020/https:/'
      + '/www.truevaluemetrics.org/DBpdfs/Issues/SupplyChain/Textiles'
      + '/WRAP-REPORT-10.7.12%20VOC-%20FINAL.pdf)). In the UK, a tonn'
      + 'e of clothing in landfill causes about 497kg of CO2, but sen'
      + 'ding it for recycling causes about 5kg ([DESNZ 2026](https:/'
      + '/assets.publishing.service.gov.uk/media/6a6c9748862aaf18d9c6'
      + '2ac9/ghg-conversion-factors-2026-flat-format-revised.xlsx)).'
      + ' This figure counts only the landfill emissions you avoid. I'
      + 'f the garment can still be worn, donating it saves much more'
      + '.',
    ja:
      '着られなくなったTシャツ1枚をごみではなく回収ボックスに出すと、約**120g**のCO2を削減できます。綿のTシャツは'
      + '1枚約0.25kgです（[WRAP](https://web.archive.org/web/2020/https://'
      + 'www.truevaluemetrics.org/DBpdfs/Issues/SupplyChain/Textiles/'
      + 'WRAP-REPORT-10.7.12%20VOC-%20FINAL.pdf)）。イギリスでは、服1トンを埋め立てると約'
      + '497kgのCO2が出ますが、リサイクルに回すと約5kgです（[DESNZ 2026](https://assets.p'
      + 'ublishing.service.gov.uk/media/6a6c9748862aaf18d9c62ac9/ghg-'
      + 'conversion-factors-2026-flat-format-revised.xlsx)）。この数字は、埋め立'
      + 'てで出るはずだったCO2だけを数えています。まだ着られる服なら、寄付するほうがずっと多く削減できます。',
    es:
      'Llevar una camiseta gastada al contenedor textil en lugar de'
      + ' a la basura ahorra unos **120g** de CO2. Una camiseta de al'
      + 'godón pesa unos 0,25kg ([WRAP](https://web.archive.org/web/2'
      + '020/https://www.truevaluemetrics.org/DBpdfs/Issues/SupplyCha'
      + 'in/Textiles/WRAP-REPORT-10.7.12%20VOC-%20FINAL.pdf)). En el '
      + 'Reino Unido, una tonelada de ropa en el vertedero genera uno'
      + 's 497kg de CO2, pero enviarla a reciclar genera unos 5kg ([D'
      + 'ESNZ 2026](https://assets.publishing.service.gov.uk/media/6a'
      + '6c9748862aaf18d9c62ac9/ghg-conversion-factors-2026-flat-form'
      + 'at-revised.xlsx)). Esta cifra solo cuenta las emisiones del '
      + 'vertedero que evitas. Si la prenda aún se puede usar, donarl'
      + 'a ahorra mucho más.',
  },

  donate_clothes: {
    en:
      'Giving one wearable T-shirt to a charity shop or resale inst'
      + 'ead of throwing it away saves about **1.7kg** of CO2. Making'
      + ' a new cotton T-shirt causes about 4.2kg of CO2 ([WRAP](http'
      + 's://www.wrap.ngo/sites/default/files/2025-02/WRAP-Textiles-2'
      + '030-Displacement-rate-report-REV1.pdf)). Not every second-ha'
      + 'nd purchase replaces a new one: WRAP found that about 65% do'
      + ' for UK peer-to-peer resale, and this figure uses a lower 50'
      + '%, minus 0.4kg for transport and packaging. Heavier clothes '
      + 'such as jeans save more.',
    ja:
      'まだ着られるTシャツ1枚を捨てずに寄付や再販売に回すと、約**1.7kg**のCO2を削減できます。新しい綿のTシャツを'
      + '作ると、約4.2kgのCO2が出ます（[WRAP](https://www.wrap.ngo/sites/default'
      + '/files/2025-02/WRAP-Textiles-2030-Displacement-rate-report-R'
      + 'EV1.pdf)）。古着を買っても、いつも新品を買うのをやめるわけではありません。WRAPによると、イギリスの個人間の売'
      + 'り買いでは約65%が新品の代わりになっています。この数字はそれより低い50%を使い、運送と包装の0.4kgを引いています'
      + '。ジーンズのような重い服なら、もっと多く削減できます。',
    es:
      'Dar una camiseta que aún se puede usar a una tienda solidari'
      + 'a o de reventa en lugar de tirarla ahorra unos **1,7kg** de '
      + 'CO2. Fabricar una camiseta de algodón nueva genera unos 4,2k'
      + 'g de CO2 ([WRAP](https://www.wrap.ngo/sites/default/files/20'
      + '25-02/WRAP-Textiles-2030-Displacement-rate-report-REV1.pdf))'
      + '. No todas las compras de segunda mano sustituyen a una nuev'
      + 'a: WRAP calculó que lo hacen un 65% en la reventa entre part'
      + 'iculares en el Reino Unido, y esta cifra usa un 50%, más baj'
      + 'o, y resta 0,4kg de transporte y embalaje. La ropa más pesad'
      + 'a, como los vaqueros, ahorra más.',
  },

  recycle_batteries: {
    en:
      'The app claims no CO2 saving for '
      + 'recycling batteries. UK emission '
      + 'factors put battery recycling only '
      + 'about 4kg of CO2 per tonne below '
      + 'landfill, which is less than one '
      + 'gram for a household batch ([DESNZ '
      + '2026]'
      + '(https://www.gov.uk/government/publications/greenhouse-gas-r'
      + 'eporting-conversion-factors-2026)'
      + '). The value of this action is not '
      + 'carbon: it keeps batteries out of '
      + 'general waste and lets their '
      + 'materials be recovered. The action '
      + 'still earns points for the effort.',
    ja:
      'アプリは電池のリサイクルによるCO2'
      + '削減量を計上していません。英国の排出'
      + '係数では、電池のリサイクルと埋め立て'
      + 'の差は1トンあたり約4kgのCO2し'
      + 'かなく、家庭から出る量では1gに満た'
      + 'ないためです（[DESNZ 2026'
      + ']'
      + '(https://www.gov.uk/government/publications/greenhouse-gas-r'
      + 'eporting-conversion-factors-2026)'
      + '）。この行動の価値は炭素ではありませ'
      + 'ん。電池を一般ごみに混ぜず、素材を回'
      + '収できるようにすることにあります。こ'
      + 'の行動にはポイントが付きます。',
    es:
      'La app no atribuye ningún ahorro de '
      + 'CO2 a reciclar pilas. Según los '
      + 'factores de emisión británicos, '
      + 'reciclar pilas emite solo unos 4kg '
      + 'de CO2 por tonelada menos que '
      + 'llevarlas al vertedero, lo que '
      + 'supone menos de un gramo para la '
      + 'cantidad de un hogar ([DESNZ 2026]'
      + '(https://www.gov.uk/government/publications/greenhouse-gas-r'
      + 'eporting-conversion-factors-2026)'
      + '). El valor de esta acción no está '
      + 'en el carbono: mantiene las pilas '
      + 'fuera de la basura general y '
      + 'permite recuperar sus materiales. '
      + 'La acción sigue sumando puntos por '
      + 'el esfuerzo.',
  },

  recycle_cooking_oil: {
    en:
      'Taking about 250ml of used cooking '
      + 'oil to a collection point saves '
      + 'about **620g** of CO2 when the oil '
      + 'becomes biodiesel that replaces '
      + 'fossil diesel. Biodiesel from used '
      + 'cooking oil emits about 0.52kg of '
      + 'CO2 per litre, against about 3.29kg '
      + 'for a litre of fossil diesel, both '
      + 'including fuel supply ([DESNZ 2026]'
      + '(https://www.gov.uk/government/publications/greenhouse-gas-r'
      + 'eporting-conversion-factors-2026)'
      + '). A litre of biodiesel holds less '
      + 'energy and replaces about 0.92 '
      + 'litres of diesel ([EU Renewable '
      + 'Energy Directive]'
      + '(https://www.legislation.gov.uk/eudr/2018/2001/annex/III)'
      + '), so each litre saves about '
      + '2.49kg. The app assumes that one '
      + 'litre of oil makes one litre of '
      + 'biodiesel. Collect the oil in a '
      + 'sealed bottle and never pour it '
      + 'down the drain.',
    ja:
      '約250mlの使用済み食用油を回収場'
      + '所に持っていくと、その油が化石燃料の'
      + '軽油に代わるバイオディーゼルになるこ'
      + 'とで、約**620g**のCO2を削'
      + '減できます。使用済み食用油から作るバ'
      + 'イオディーゼルの排出量は1リットルあ'
      + 'たり約0.52kgのCO2で、化石燃'
      + '料の軽油は1リットルあたり約3.29'
      + 'kgです（どちらも燃料供給を含む、['
      + 'DESNZ 2026]'
      + '(https://www.gov.uk/government/publications/greenhouse-gas-r'
      + 'eporting-conversion-factors-2026)'
      + '）。バイオディーゼルは1リットルあた'
      + 'りのエネルギーが少なく、1リットルで'
      + '代替できる軽油は約0.92リットルの'
      + 'ため（[EU Renewable E'
      + 'nergy Directive]'
      + '(https://www.legislation.gov.uk/eudr/2018/2001/annex/III)'
      + '）、1リットルあたりの削減量は約2.'
      + '49kgです。アプリは、1リットルの'
      + '油から1リットルのバイオディーゼルが'
      + 'できると仮定しています。油は密閉でき'
      + 'るボトルにためて、排水口には決して流'
      + 'さないでください。',
    es:
      'Llevar unos 250ml de aceite de '
      + 'cocina usado a un punto de recogida '
      + 'ahorra unos **620g** de CO2 cuando '
      + 'el aceite se convierte en biodiésel '
      + 'que sustituye al gasóleo fósil. El '
      + 'biodiésel de aceite de cocina usado '
      + 'emite unos 0,52kg de CO2 por litro, '
      + 'frente a unos 3,29kg de un litro de '
      + 'gasóleo fósil, en ambos casos '
      + 'incluido el suministro de '
      + 'combustible ([DESNZ 2026]'
      + '(https://www.gov.uk/government/publications/greenhouse-gas-r'
      + 'eporting-conversion-factors-2026)'
      + '). Un litro de biodiésel contiene '
      + 'menos energía y sustituye unos 0,92 '
      + 'litros de gasóleo ([EU Renewable '
      + 'Energy Directive]'
      + '(https://www.legislation.gov.uk/eudr/2018/2001/annex/III)'
      + '), así que cada litro ahorra unos '
      + '2,49kg. La app supone que un litro '
      + 'de aceite produce un litro de '
      + 'biodiésel. Guarda el aceite en una '
      + 'botella cerrada y nunca lo viertas '
      + 'por el desagüe.',
  },

  // -------------------------------------------------------
  // TRANSPORT (12 actions)
  // -------------------------------------------------------
  walk_instead_drive: {
    en:
      'Walking instead of driving a short trip saves about **310g** of CO2 '
      + 'by replacing an average 1.5km car journey. An average petrol car '
      + 'emits about 208g of CO2 per kilometre, including fuel supply ([DESNZ '
      + '2026](https://www.gov.uk/government/publications/g'
      + 'reenhouse-gas-reporting-conversion-factors-2026)). Walking produces '
      + 'zero tailpipe emissions and also improves cardiovascular health. Even '
      + 'replacing one short car trip per day adds up to about 110kg of CO2 '
      + 'saved per year.',
    ja:
      '短距離の車移動を徒歩に替えると約**310g**のCO2を削減できます。平均1.5km'
      + 'の車移動を置き換える計算です。平均的なガソリン車は燃料供給を含めて1km'
      + 'あたり約208gのCO2を排出します（[DESNZ 2026](https://www.gov.uk/governm'
      + 'ent/publications/greenhouse-gas-reporting-conversion-factors-2026)）。'
      + '徒歩は排気ガスゼロで心血管の健康にも良い影響があります。1日1回の短距離'
      + '移動を徒歩に替えるだけで年間約110kgのCO2削減になります。',
    es:
      'Caminar en vez de conducir un trayecto corto ahorra unos **310g** de '
      + 'CO2 al reemplazar un viaje promedio de 1,5km en coche. Un coche de '
      + 'gasolina medio emite unos 208g de CO2 por kilómetro, incluido el '
      + 'suministro de combustible ([DESNZ '
      + '2026](https://www.gov.uk/government/publications/g'
      + 'reenhouse-gas-reporting-conversion-factors-2026)). Caminar no produce '
      + 'emisiones y además mejora la salud cardiovascular. Reemplazar un '
      + 'viaje corto en coche al día suma unos 110kg de CO2 ahorrados al año.',
  },

  bike_short_trip: {
    en:
      'Cycling instead of driving on a short trip of up to 3km saves up to '
      + '**620g** of CO2. An average petrol car emits about 208g/km, including '
      + 'fuel supply ([DESNZ 2026](https://www.gov.uk/government/publications/g'
      + 'reenhouse-gas-reporting-conversion-factors-2026)). This counts the '
      + 'car\'s emissions only, not the small extra emissions from the food a '
      + 'cyclist burns. Cycling also reduces traffic congestion and improves '
      + 'air quality in urban areas ([Our World in '
      + 'Data](https://ourworldindata.org/travel-carbon-footprint)).',
    ja:
      '3km以内の短距離を車ではなく自転車で移動すると、最大で**620g**のCO2を削'
      + '減できます。平均的なガソリン車は燃料供給を含めて1kmあたり約208gのCO2を'
      + '排出します（[DESNZ 2026](https://www.gov.uk/government/publications/gr'
      + 'eenhouse-gas-reporting-conversion-factors-2026)）。この数値は車の排出'
      + 'だけを数えたもので、自転車をこぐためのエネルギー源となる食事由来のわず'
      + 'かな排出は差し引いていません。自転車は交通渋滞の緩和や都市部の大気質改'
      + '善にも貢献します（[Our World in Data](https://ourworldindata.org/trave'
      + 'l-carbon-footprint)）。',
    es:
      'Ir en bicicleta en lugar de en coche en un trayecto corto de hasta '
      + '3km ahorra como máximo **620g** de CO2. Un coche de gasolina medio '
      + 'emite unos 208g/km, incluido el suministro de combustible ([DESNZ '
      + '2026](https://www.gov.uk/government/publications/g'
      + 'reenhouse-gas-reporting-conversion-factors-2026)). La cifra solo '
      + 'cuenta las emisiones del coche, no las pequeñas emisiones extra de la '
      + 'comida que necesita el ciclista para pedalear. La bicicleta también '
      + 'reduce la congestión y mejora la calidad del aire urbano ([Our World '
      + 'in Data](https://ourworldindata.org/travel-carbon-footprint)).',
  },

  bike_medium_trip: {
    en:
      'Cycling a medium trip of about 6km instead of driving saves roughly '
      + '**1,200g** of CO2. An average petrol car emits about 208g per '
      + 'kilometre, including fuel supply, so 6km comes to about 1,245g, which '
      + 'the app rounds down ([DESNZ '
      + '2026](https://www.gov.uk/government/publications/g'
      + 'reenhouse-gas-reporting-conversion-factors-2026)). Longer trips save '
      + 'more and shorter ones less. Medium-distance cycling is feasible for '
      + 'most commutes and errands ([Our World in '
      + 'Data](https://ourworldindata.org/travel-carbon-footprint)). E-bikes '
      + 'make these distances accessible to an even wider range of riders.',
    ja:
      '約6kmの中距離を車の代わりに自転車で移動すると、約**1,200g**のCO2を削減'
      + 'できます。平均的なガソリン車は燃料供給を含めて1kmあたり約208gを排出す'
      + 'るため、6kmでは約1,245gとなり、アプリでは切り捨てています（[DESNZ 2026'
      + '](https://www.gov.uk/government/publications/greenhouse-gas-reporting-'
      + 'conversion-factors-2026)）。距離が長ければ削減量は増え、短ければ減りま'
      + 'す。中距離の自転車移動は多くの通勤や用事に実用的です（[Our World in Da'
      + 'ta](https://ourworldindata.org/travel-carbon-footprint)）。電動アシス'
      + 'ト自転車なら、より多くの人がこの距離を快適に走れます。',
    es:
      'Ir en bicicleta en vez de en coche en un trayecto medio de unos 6km '
      + 'ahorra aproximadamente **1.200g** de CO2. Un coche de gasolina medio '
      + 'emite unos 208g por kilómetro, incluido el suministro de combustible, '
      + 'así que 6km suman unos 1.245g, que la app redondea a la baja ([DESNZ '
      + '2026](https://www.gov.uk/government/publications/g'
      + 'reenhouse-gas-reporting-conversion-factors-2026)). Los trayectos más '
      + 'largos ahorran más y los más cortos, menos. Ir en bicicleta en '
      + 'trayectos medios es viable para la mayoría de desplazamientos y '
      + 'recados ([Our World in '
      + 'Data](https://ourworldindata.org/travel-carbon-footprint)). Las '
      + 'bicicletas eléctricas hacen estas distancias accesibles para más '
      + 'personas.',
  },

  public_transport: {
    en:
      'Taking public transport instead of driving saves roughly **790g** of '
      + 'CO2 on a 10km trip by bus. A city bus emits about 128g/km per '
      + 'passenger and an average petrol car about 208g/km, both including '
      + 'fuel supply ([DESNZ 2026](https://www.gov.uk/government/publications/g'
      + 'reenhouse-gas-reporting-conversion-factors-2026)), the factors the '
      + 'Transport Calculator uses. National rail emits less, about 51g/km. '
      + 'Public transport also reduces traffic congestion and urban air '
      + 'pollution ([Our World in '
      + 'Data](https://ourworldindata.org/travel-carbon-footprint)). Ridership '
      + 'growth supports more frequent service, creating a positive feedback '
      + 'loop.',
    ja:
      '車の代わりに公共交通機関を利用すると10kmのバス移動で約**790g**のCO2を'
      + '削減できます。路線バスは乗客1人あたり約128g/km、平均的なガソリン車は約'
      + '208g/km排出します。どちらも燃料供給を含む値です（[DESNZ 2026](https://'
      + 'www.gov.uk/government/publications/greenhouse-gas-reporting-conversion'
      + '-factors-2026)）。これは「移動のCO2計算」と同じ係数です。国内の鉄道は'
      + 'さらに少なく、約51g/kmです。公共交通は渋滞緩和や都市の大気汚染改善にも'
      + '貢献します（[Our World in Data](https://ourworldindata.org/travel-carb'
      + 'on-footprint)）。利用者が増えるほど運行頻度も上がり好循環が生まれます'
      + '。',
    es:
      'Usar transporte público en vez de conducir ahorra aproximadamente '
      + '**790g** de CO2 en un trayecto de 10km en autobús. Un autobús urbano '
      + 'emite unos 128g/km por pasajero y un coche de gasolina medio, unos '
      + '208g/km, ambos con el suministro de combustible incluido ([DESNZ '
      + '2026](https://www.gov.uk/government/publications/g'
      + 'reenhouse-gas-reporting-conversion-factors-2026)), los factores que '
      + 'usa la calculadora «Transporte». El tren nacional emite menos, unos '
      + '51g/km. El transporte público también reduce la congestión y la '
      + 'contaminación urbana ([Our World in '
      + 'Data](https://ourworldindata.org/travel-carbon-footprint)). Más '
      + 'usuarios permiten un servicio más frecuente, creando un ciclo '
      + 'positivo.',
  },

  carpool: {
    en:
      'Carpooling saves about **1,000g** '
      + 'of CO2 on a 10km trip by sharing '
      + 'one car between two people. An '
      + 'average petrol car emits about 208g '
      + 'of CO2 per kilometre, including '
      + 'fuel supply, so two people who '
      + 'share it halve their emissions to '
      + 'about 104g each per kilometre '
      + '([DESNZ 2026]'
      + '(https://www.gov.uk/government/publications/greenhouse-gas-r'
      + 'eporting-conversion-factors-2026)'
      + '). Sharing rides also puts fewer '
      + 'vehicles on the road, which eases '
      + 'congestion. It cuts fuel and '
      + 'parking costs for everyone in the '
      + 'car.',
    ja:
      '相乗りすると、2人で1台の車を使うこ'
      + 'とで10kmの移動につき約**1,0'
      + '00g**のCO2を削減できます。平'
      + '均的なガソリン車は燃料供給を含めて1'
      + 'kmあたり約208gのCO2を排出す'
      + 'るため、2人で乗れば1人あたりの排出'
      + '量は1kmあたり約104gに半減しま'
      + 'す（[DESNZ 2026]'
      + '(https://www.gov.uk/government/publications/greenhouse-gas-r'
      + 'eporting-conversion-factors-2026)'
      + '）。相乗りは道路を走る車の数を減らし'
      + '、渋滞の緩和にもつながります。燃料費'
      + 'や駐車場代も全員で分け合えます。',
    es:
      'Compartir coche ahorra unos '
      + '**1.000g** de CO2 en un viaje de '
      + '10km al usar un solo coche entre '
      + 'dos personas. Un coche de gasolina '
      + 'medio emite unos 208g de CO2 por '
      + 'kilómetro, incluido el suministro '
      + 'de combustible, así que dos '
      + 'personas que lo comparten reducen '
      + 'sus emisiones a la mitad, unos 104g '
      + 'por kilómetro cada una ([DESNZ 2026]'
      + '(https://www.gov.uk/government/publications/greenhouse-gas-r'
      + 'eporting-conversion-factors-2026)'
      + '). Compartir viajes también reduce '
      + 'el número de vehículos en la '
      + 'carretera, lo que alivia la '
      + 'congestión. Además, reparte los '
      + 'costes de combustible y '
      + 'aparcamiento entre todos los '
      + 'ocupantes.',
  },

  electric_car_purchase: {
    en:
      'Choosing an electric car over a petrol car avoids about **1.3 tonnes** '
      + 'of CO2 equivalent in the first year. The average car in England '
      + 'covers 7,100 miles (about 11,400km) a year ([DfT NTS0901]'
      + '(https://www.gov.uk/government/statistical-data-sets'
      + '/nts09-vehicle-mileage-and-occupancy)). An average petrol car emits '
      + 'about 208g/km including fuel supply ([DESNZ 2026](https://www.gov.uk'
      + '/government/publications/greenhouse-gas-reporting-conversion-factor'
      + 's-2026)), and an electric car about 86g/km at the app\'s grid factor '
      + 'of 458g/kWh. The figure leaves out manufacturing. An EV has a higher '
      + 'upfront carbon cost, but Carbon Brief estimates that in the UK it '
      + 'pays this back after less than two years of driving ([Carbon Brief]'
      + '(https://www.carbonbrief.org/factcheck-how-electric-vehicles-help-to'
      + '-tackle-climate-change/)). '
      + 'Pairing an EV with renewable-energy charging maximises the climate '
      + 'benefit.',
    ja:
      'ガソリン車の代わりに電気自動車を選ぶと、最初の1年でCO2相当で約**1.3トン**'
      + 'の排出を回避できます。イングランドの自動車の平均走行距離は年間7,100マイル'
      + '（約11,400km）です（[DfT NTS0901](https://www.gov.uk/government'
      + '/statistical-data-sets/nts09-vehicle-mileage-and-occupancy)）。平均的な'
      + 'ガソリン車は燃料供給分を含めて約208g/km排出し（[DESNZ 2026]'
      + '(https://www.gov.uk/government/publications/greenhouse-gas-reporting'
      + '-conversion-factors-2026)）、電気自動車は本アプリの電力係数458g/kWhで'
      + '約86g/kmです。この値に製造時の排出は含みません。EVは製造時の炭素コストが'
      + '高いものの、Carbon Briefの試算では、英国では2年未満の走行でその分を'
      + '取り戻せます（[Carbon Brief](https://www.carbonbrief.org/factcheck-how'
      + '-electric-vehicles-help-to-tackle-climate-change/)）。再生可能エネルギーでの'
      + '充電を組み合わせると気候面の効果を最大化できます。',
    es:
      'Elegir un coche eléctrico en vez de uno de gasolina evita unas '
      + '**1,3 toneladas** de CO2 equivalente en el primer año. El coche medio '
      + 'en Inglaterra recorre 7.100 millas (unos 11.400km) al año ([DfT '
      + 'NTS0901](https://www.gov.uk/government/statistical-data-sets'
      + '/nts09-vehicle-mileage-and-occupancy)). Un coche de gasolina medio '
      + 'emite unos 208g/km con el suministro de combustible incluido ([DESNZ '
      + '2026](https://www.gov.uk/government/publications/greenhouse-gas-repor'
      + 'ting-conversion-factors-2026)), y un coche eléctrico unos 86g/km con '
      + 'el factor de red de la app, 458g/kWh. La cifra no incluye la '
      + 'fabricación. Un VE tiene un coste de carbono inicial mayor, pero '
      + 'según Carbon Brief, en el Reino Unido lo compensa en menos de dos años '
      + 'de uso ([Carbon Brief](https://www.carbonbrief.org/factcheck-how'
      + '-electric-vehicles-help-to-tackle-climate-change/)). Combinar un VE con '
      + 'carga de energía renovable maximiza el beneficio climático.',
  },

  train_vs_flight: {
    en:
      'Choosing a train over a domestic flight for a 500km journey saves '
      + 'roughly **100,000g** of CO2 equivalent. A domestic flight emits about '
      + '263g/km per passenger, including the warming effect of emissions at '
      + 'altitude ([DESNZ 2026](https://www.gov.uk/government/publications/g'
      + 'reenhouse-gas-reporting-conversion-factors-2026)). National rail '
      + 'emits about 51g/km on the global-average electricity grid ([ORR]('
      + 'https://dataportal.orr.gov.uk/media/xw4f0ohl/rail-environment-2024-25'
      + '.pdf)). Both include fuel supply and match the Transport Calculator. '
      + 'Per kilometre, that makes the train more than 5 times cleaner.',
    ja:
      '500kmの移動で国内線の代わりに鉄道を選ぶと約**100,000g**のCO2相当を削減'
      + 'できます。国内線は高高度での排出による温暖化効果を含めて乗客1人あたり'
      + '約263g/km排出します（[DESNZ 2026](https://www.gov.uk/government/publi'
      + 'cations/greenhouse-gas-reporting-conversion-factors-2026)）。国内の鉄道'
      + 'は世界平均の電力で約51g/km排出します（[ORR](https://dataportal.orr.go'
      + 'v.uk/media/xw4f0ohl/rail-environment-2024-25.pdf)）。どちらも燃料供給を'
      + '含み、「移動のCO2計算」と同じ係数です。kmあたりでは、鉄道は5倍以上クリ'
      + 'ーンです。',
    es:
      'Elegir el tren en vez de un vuelo nacional para un viaje de 500km '
      + 'ahorra aproximadamente **100.000g** de CO2 equivalente. Un vuelo '
      + 'nacional emite unos 263g/km por pasajero, incluido el efecto de '
      + 'calentamiento de las emisiones en altitud ([DESNZ 2026](https://www.'
      + 'gov.uk/government/publications/greenhouse-gas-reporting-conversion-'
      + 'factors-2026)). El tren nacional emite unos 51g/km con la red '
      + 'eléctrica media mundial ([ORR](https://dataportal.orr.gov.uk/media/'
      + 'xw4f0ohl/rail-environment-2024-25.pdf)). Ambos incluyen el suministro '
      + 'de combustible y coinciden con la calculadora «Transporte». Por '
      + 'kilómetro, el tren es más de 5 veces más limpio.',
  },

  take_bus: {
    en:
      'Taking the bus instead of driving saves roughly **550g** of CO2 on a '
      + '7km trip. A city bus emits about 128g/km per passenger compared to '
      + '208g/km for an average petrol car, both including fuel supply ([DESNZ '
      + '2026](https://www.gov.uk/government/publications/g'
      + 'reenhouse-gas-reporting-conversion-factors-2026)), the factors the '
      + 'Transport Calculator uses. Modern bus fleets are increasingly '
      + 'electrified, further reducing their carbon footprint. Regular bus '
      + 'ridership supports route expansion and service improvements for the '
      + 'whole community.',
    ja:
      '車の代わりにバスを利用すると7kmの移動で約**550g**のCO2を節約できます。'
      + '路線バスは乗客1人あたり約128g/km、平均的なガソリン車は約208g/kmの排出'
      + 'です。どちらも燃料供給を含む値です（[DESNZ 2026](https://www.gov.uk/go'
      + 'vernment/publications/greenhouse-gas-reporting-conversion-factors-2026'
      + ')）。これは「移動のCO2計算」と同じ係数です。最新のバス車両は電動化が進'
      + 'みカーボンフットプリントがさらに小さくなっています。バスの定期利用は路'
      + '線拡充やサービス改善を支えます。',
    es:
      'Tomar el autobús en vez de conducir ahorra aproximadamente **550g** '
      + 'de CO2 en un trayecto de 7km. Un autobús urbano emite unos 128g/km '
      + 'por pasajero frente a unos 208g/km de un coche de gasolina medio, '
      + 'ambos con el suministro de combustible incluido ([DESNZ '
      + '2026](https://www.gov.uk/government/publications/g'
      + 'reenhouse-gas-reporting-conversion-factors-2026)), los factores que '
      + 'usa la calculadora «Transporte». Las flotas modernas son cada vez más '
      + 'eléctricas, reduciendo aún más su huella de carbono. El uso regular '
      + 'del autobús apoya la expansión de rutas y mejoras de servicio para '
      + 'toda la comunidad.',
  },

  escooter_trip: {
    en:
      'Riding your own e-scooter instead of driving on a 2.5km trip saves'
      + ' about **500g** of CO2. An average petrol car emits about 208g/km,'
      + ' including fuel supply ([DESNZ 2026](https://www.gov.uk/government'
      + '/publications/greenhouse-gas-reporting-conversion-factors-2026)). '
      + 'A private e-scooter uses about 7g/km of electricity ([Springer 202'
      + '4](https://link.springer.com/article/10.1186/s12302-024-00920-x)).'
      + ' This counts electricity only, not the scooter\'s manufacture. E-sc'
      + 'ooters suit the last mile from a transit stop to your destination.',
    ja:
      '2.5kmの移動で車の代わりに自分の電動キックボードを使うと、約**500g**のCO2を削減できます。平均的なガソリン車は燃料供給'
      + 'を含めて1kmあたり約208gを排出します（[DESNZ 2026](https://www.gov.uk/government/p'
      + 'ublications/greenhouse-gas-reporting-conversion-factors-2026)）。個人所'
      + '有の電動キックボードの電力由来の排出は1kmあたり約7gです（[Springer 2024](https://link.spring'
      + 'er.com/article/10.1186/s12302-024-00920-x)）。この数値は電力だけを数えたもので、キックボー'
      + 'ドの製造分は含みません。駅から目的地までのラストマイル移動に向いています。',
    es:
      'Usar tu propio patinete eléctrico en vez del coche en un trayecto '
      + 'de 2,5km ahorra unos **500g** de CO2. Un coche de gasolina medio e'
      + 'mite unos 208g/km, incluido el suministro de combustible ([DESNZ 2'
      + '026](https://www.gov.uk/government/publications/greenhouse-gas-rep'
      + 'orting-conversion-factors-2026)). Un patinete eléctrico privado ga'
      + 'sta unos 7g/km de electricidad ([Springer 2024](https://link.sprin'
      + 'ger.com/article/10.1186/s12302-024-00920-x)). Solo cuenta la elect'
      + 'ricidad, no la fabricación del patinete. Es ideal para la última m'
      + 'illa, desde una parada de transporte público hasta tu destino.',
  },

  ev_charging_green: {
    en:
      'Charging your electric vehicle with '
      + 'renewable energy saves about '
      + '**4,100g** of CO2 per charge, '
      + 'compared with electricity at the '
      + 'global grid average of 458g of CO2 '
      + 'per kWh ([Ember 2026]'
      + '(https://ember-energy.org/latest-insights/global-electricity'
      + '-review-2026/electricity-demand-and-supply-trends/)'
      + '). The figure uses a mean home '
      + 'charge of 9.1 kWh, from UK '
      + 'government data for 2017 ([DfT]'
      + '(https://assets.publishing.service.gov.uk/media/5c114a0fe527'
      + '4a0bad85ade0/electric-chargepoint-analysis-2017-domestics.pd'
      + 'f)'
      + '). The app counts the renewable '
      + 'electricity as zero-emission, so '
      + 'the action fits a charge from your '
      + 'own solar panels or on a renewable '
      + 'tariff.',
    ja:
      '電気自動車を再生可能エネルギーで充電'
      + 'すると、世界平均の電力排出係数（1k'
      + 'Whあたり458gのCO2、[Emb'
      + 'er 2026]'
      + '(https://ember-energy.org/latest-insights/global-electricity'
      + '-review-2026/electricity-demand-and-supply-trends/)'
      + '）の電力に比べて、1回の充電で約**'
      + '4,100g**のCO2を削減できま'
      + 'す。この数値は、英国政府の2017年'
      + 'のデータによる家庭での平均充電量9.'
      + '1kWhを使っています（[DfT]'
      + '(https://assets.publishing.service.gov.uk/media/5c114a0fe527'
      + '4a0bad85ade0/electric-chargepoint-analysis-2017-domestics.pd'
      + 'f)'
      + '）。アプリは再生可能エネルギーの電力'
      + 'を排出ゼロとして数えるため、この行動'
      + 'は自宅の太陽光パネルや再生可能エネル'
      + 'ギーの料金プランでの充電に当てはまり'
      + 'ます。',
    es:
      'Cargar tu coche eléctrico con '
      + 'energía renovable ahorra unos '
      + '**4.100g** de CO2 por carga, frente '
      + 'a la electricidad con la media '
      + 'mundial de la red, 458g de CO2 por '
      + 'kWh ([Ember 2026]'
      + '(https://ember-energy.org/latest-insights/global-electricity'
      + '-review-2026/electricity-demand-and-supply-trends/)'
      + '). La cifra usa una carga doméstica '
      + 'media de 9,1 kWh, según datos del '
      + 'Gobierno británico de 2017 ([DfT]'
      + '(https://assets.publishing.service.gov.uk/media/5c114a0fe527'
      + '4a0bad85ade0/electric-chargepoint-analysis-2017-domestics.pd'
      + 'f)'
      + '). La app cuenta la electricidad '
      + 'renovable como de cero emisiones, '
      + 'así que la acción corresponde a una '
      + 'carga con tus propios paneles '
      + 'solares o con una tarifa renovable.',
  },

  combine_errands: {
    en:
      'Combining several errands into one '
      + 'car trip saves about **830g** of '
      + 'CO2 by cutting around 4km of '
      + 'driving. An average petrol car '
      + 'emits about 208g of CO2 per '
      + 'kilometre, including fuel supply '
      + '([DESNZ 2026]'
      + '(https://www.gov.uk/government/publications/greenhouse-gas-r'
      + 'eporting-conversion-factors-2026)'
      + '). The app counts only the distance '
      + 'that you no longer drive. Planning '
      + 'one efficient route saves fuel and '
      + 'time as well.',
    ja:
      '複数の用事を1回の車移動にまとめると'
      + '、約4kmの走行を減らせるため約**'
      + '830g**のCO2を削減できます。'
      + '平均的なガソリン車は燃料供給を含めて'
      + '1kmあたり約208gのCO2を排出'
      + 'します（[DESNZ 2026]'
      + '(https://www.gov.uk/government/publications/greenhouse-gas-r'
      + 'eporting-conversion-factors-2026)'
      + '）。アプリが数えるのは、走らずに済ん'
      + 'だ距離の分だけです。効率的なルートを'
      + '計画すれば、燃料と時間の節約にもなり'
      + 'ます。',
    es:
      'Combinar varios recados en un solo '
      + 'viaje en coche ahorra unos **830g** '
      + 'de CO2 al evitar unos 4km de '
      + 'conducción. Un coche de gasolina '
      + 'medio emite unos 208g de CO2 por '
      + 'kilómetro, incluido el suministro '
      + 'de combustible ([DESNZ 2026]'
      + '(https://www.gov.uk/government/publications/greenhouse-gas-r'
      + 'eporting-conversion-factors-2026)'
      + '). La app cuenta solo la distancia '
      + 'que dejas de conducir. Planificar '
      + 'una ruta eficiente también ahorra '
      + 'combustible y tiempo.',
  },

  // -------------------------------------------------------
  // FOOD (15 actions)
  // -------------------------------------------------------
  skip_high_impact_food: {
    en:
      'Choosing a plant-based meal instead of a '
      + '100g serving of beef avoids roughly '
      + '**6,800g** of CO2 equivalent. Beef '
      + 'averages about 70kg CO2e per kilogram '
      + 'when beef-herd beef at 99.5kg and '
      + 'dairy-herd beef at 33.3kg are weighted by '
      + 'their 56% and 44% shares of global '
      + 'production ([Poore & Nemecek '
      + '2018](https://ourworldindata.org/grapher/'
      + 'ghg-per-kg-poore); [Our World in '
      + 'Data](https://ourworldindata.org/'
      + 'less-meat-or-sustainable-meat)), so a '
      + '100g serving carries about 7kg. The '
      + 'plant-based swap, such as beans or '
      + 'lentils, is counted at about 0.2kg, '
      + 'leaving 6.8kg saved. These are means that '
      + 'include supply-chain losses; the 60kg per '
      + 'kilogram you may see elsewhere is a '
      + 'median ([Our World in '
      + 'Data](https://ourworldindata.org/'
      + 'faqs-environmental-impacts-food)). '
      + 'Skipping beef once a week adds up to '
      + 'about 350kg a year.',
    ja:
      '100gの牛肉の代わりに植物性の食事を選ぶと、約'
      + '**6,800g**のCO2相当を回避できます。牛肉は1kg'
      + 'あたり平均約70kg CO2eです。これは肉用牛群の'
      + '牛肉99.5kgと乳用牛群の牛肉33.3kgを、世界の生'
      + '産量に占める56%と44%の割合で加重した値です（'
      + '[Poore & Nemecek 2018](https://'
      + 'ourworldindata.org/grapher/ghg-per-kg-poore)'
      + '、[Our World in Data](https://'
      + 'ourworldindata.org/'
      + 'less-meat-or-sustainable-meat)）。そのため'
      + '100gでは約7kgになります。豆やレンズ豆などの'
      + '植物性の代替食を約0.2kgとして差し引き、6.8kg'
      + 'の削減です。これらはサプライチェーンでのロス'
      + 'を含む平均値で、ほかで見かける1kgあたり60kg'
      + 'という値は中央値です（[Our World in '
      + 'Data](https://ourworldindata.org/'
      + 'faqs-environmental-impacts-food)）。週1回牛'
      + '肉を控えると、年間約350kgになります。',
    es:
      'Elegir una comida vegetal en lugar de una '
      + 'ración de 100g de carne de vacuno evita '
      + 'aproximadamente **6.800g** de CO2 '
      + 'equivalente. La carne de vacuno emite de '
      + 'media unos 70kg CO2e por kilogramo al '
      + 'ponderar la de rebaños de carne, con '
      + '99,5kg, y la de rebaños lecheros, con '
      + '33,3kg, por sus cuotas del 56% y el 44% '
      + 'de la producción mundial ([Poore & '
      + 'Nemecek '
      + '2018](https://ourworldindata.org/grapher/'
      + 'ghg-per-kg-poore); [Our World in '
      + 'Data](https://ourworldindata.org/'
      + 'less-meat-or-sustainable-meat)), así que '
      + 'una ración de 100g supone unos 7kg. La '
      + 'alternativa vegetal, como las alubias o '
      + 'las lentejas, se cuenta con unos 0,2kg, '
      + 'lo que deja 6,8kg de ahorro. Son medias '
      + 'que incluyen las pérdidas en la cadena de '
      + 'suministro; los 60kg por kilogramo que '
      + 'puedes ver en otros sitios son una '
      + 'mediana ([Our World in '
      + 'Data](https://ourworldindata.org/'
      + 'faqs-environmental-impacts-food)). Evitar '
      + 'la carne de vacuno una vez por semana '
      + 'suma unos 350kg al año.',
  },

  skip_medium_impact_food: {
    en:
      'Replacing a meal of chicken or pork '
      + 'with a plant-based option saves '
      + 'roughly **780g** of CO2 '
      + 'equivalent. While these proteins '
      + 'carry a lighter footprint than beef, '
      + 'they still require significant land, '
      + 'water, and feed resources '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/food-choice-vs-eating-local)). '
      + 'Chicken produces about 10kg CO2eq per '
      + 'kilogram and pork about 12kg, versus '
      + '1-3kg for most plant proteins '
      + '([Poore & Nemecek, Science 2018]'
      + '(https://www.science.org/doi/10.1126'
      + '/science.aaq0216)). Swapping a few '
      + 'medium-impact meals per week is a '
      + 'practical way to lower your dietary '
      + 'carbon footprint without going fully '
      + 'vegetarian.',
    ja:
      '鶏肉や豚肉の1食分を植物性の'
      + '選択肢に替えると約**780g**のCO2'
      + '相当を削減できます。牛肉ほどでは'
      + 'ないものの相当な土地、水、飼料資源'
      + 'を必要とします（[Our World in Data]'
      + '(https://ourworldindata.org'
      + '/food-choice-vs-eating-local)）。'
      + '鶏肉は約10kg CO2eq/kg、豚肉は'
      + '約'
      + '12kgで植物性タンパクの1〜3kgと'
      + '比較されます'
      + '（[Poore & Nemecek, Science 2018]'
      + '(https://www.science.org/doi/10.1126'
      + '/science.aaq0216)）。週に数食を'
      + '中程度インパクトの食品から替えるのは'
      + '完全菜食にならずとも食事のカーボン'
      + 'フットプリントを下げる実用的な'
      + '方法です。',
    es:
      'Reemplazar una comida de pollo o '
      + 'cerdo por una opción vegetal '
      + 'ahorra aproximadamente **780g** de '
      + 'CO2 equivalente. Aunque estas '
      + 'proteínas tienen menor huella que la '
      + 'carne de vacuno, aún requieren '
      + 'importantes recursos de tierra, agua '
      + 'y pienso ([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/food-choice-vs-eating-local)). '
      + 'El pollo produce unos 10kg CO2eq/kg '
      + 'y el cerdo 12kg, frente a 1-3kg '
      + 'de la mayoría de proteínas vegetales '
      + '([Poore & Nemecek, Science 2018]'
      + '(https://www.science.org/doi/10.1126'
      + '/science.aaq0216)). Sustituir '
      + 'algunas comidas de impacto medio por '
      + 'semana es una forma práctica de '
      + 'reducir la huella de carbono '
      + 'alimentaria sin ser completamente '
      + 'vegetariano.',
  },

  skip_fish: {
    en:
      'Replacing a fish meal with a '
      + 'plant-based option saves roughly '
      + '**460g** of CO2 equivalent. '
      + 'Wild-caught white fish such as cod '
      + 'and haddock average '
      + 'about 5kg CO2eq per kilogram be'
      + 'fore processing and transport, versus '
      + '1-3kg for most plant '
      + 'proteins ([Gephart et al. '
      + '2021](https://ourworldindata.org'
      + '/grapher/ghg-emissions-seafood); '
      + '[Poore & Nemecek, Science '
      + '2018](https://www.science.org/doi'
      + '/10.1126/science.aaq0216)). '
      + 'Herring and sardines are lower, so '
      + 'the saving is smaller for them.',
    ja:
      '魚の1食分を植物性の選択肢に替えると'
      + '約**460g**のCO2相当を削減'
      + 'できます。タラなどの'
      + '天然の白身魚は加工と輸送を除いて約5kg '
      + 'CO2eq/kg'
      + 'で、植物性タンパクの1〜3kgと'
      + '比較されます（[Gephart et al. '
      + '2021](https://ourworldind'
      + 'ata.org/grapher/ghg-emiss'
      + 'ions-seafood)、[Poore & '
      + 'Nemecek, '
      + 'Science 2018](https://www.science.org'
      + '/doi/10.1126/science.aaq0216)）。'
      + 'ニシンやイワシはさらに低いため、'
      + 'その場合の削減量は小さくなります。',
    es:
      'Reemplazar una comida de pescado por '
      + 'una opción vegetal ahorra '
      + 'aproximadamente **460g** de CO2 '
      + 'equivalente. El pescado blanco '
      + 'salvaje, como el '
      + 'bacalao y el eglefino, promedia unos '
      + '5kg CO2eq/kg '
      + 'sin contar el procesado ni el '
      + 'transporte, frente a 1-3kg de la '
      + 'mayoría de proteínas vegetales '
      + '([Gephart et al. '
      + '2021](https://ourworldindata.org'
      + '/grapher/ghg-emissions-seafood); '
      + '[Poore & Nemecek, Science 2018]'
      + '(https://www.science.org/doi/10.1126'
      + '/science.aaq0216)). '
      + 'El arenque y la sardina emiten menos, '
      + 'así que con ellos el ahorro es menor.',
  },

  no_food_waste: {
    en:
      'Finishing all your food for a day with '
      + 'nothing thrown away avoids roughly '
      + '**450g** of CO2 equivalent, mostly the '
      + 'emissions from producing food that would '
      + 'otherwise be wasted. The '
      + '[EPA](https://www.epa.gov/land-research/'
      + 'quantifying-methane-emissions-landfilled-food-waste) '
      + 'reports that 58% of fugitive methane from '
      + 'landfills originates from food waste. '
      + 'Planning meals, using shopping lists, and '
      + 'storing food properly are effective '
      + 'strategies. In 2022 the world wasted '
      + '1.05 billion tonnes of food in homes, '
      + 'shops and restaurants, almost a fifth of '
      + 'all food available to consumers '
      + '([UNEP](https://www.unep.org/en/news-and'
      + '-stories/press-release/world-squanders'
      + '-over-1-billion-meals-day-un-report)).',
    ja:
      '1日の食べ残しをゼロにすると、約**450g**のCO2'
      + '相当を回避できます。その大半は、捨てられるは'
      + 'ずだった食品の生産にかかる排出です。'
      + '[EPA](https://www.epa.gov/land-research/'
      + 'quantifying-methane-emissions-landfilled-food-waste)'
      + 'によると、埋立地からの逸散メタンの58%は食品'
      + '廃棄物由来です。献立計画、買い物リストの活用'
      + '、適切な食品保存が有効な対策です。2022年、世界'
      + 'では家庭、小売店、飲食店で10億5,000万トンの食品'
      + 'が廃棄されました。これは消費者が入手できる食品'
      + '全体のほぼ5分の1にあたります（[UNEP](https://'
      + 'www.unep.org/en/news-and-stories/press-release/'
      + 'world-squanders-over-1-billion-meals-day-un-report)'
      + '）。',
    es:
      'Terminar toda la comida durante un día '
      + 'sin tirar nada evita aproximadamente '
      + '**450g** de CO2 equivalente, sobre todo '
      + 'las emisiones de producir alimentos que '
      + 'acabarían en la basura. La '
      + '[EPA](https://www.epa.gov/land-research/'
      + 'quantifying-methane-emissions-landfilled-food-waste) '
      + 'informa de que el 58% del metano fugitivo '
      + 'de los vertederos procede del desperdicio '
      + 'de alimentos. Planificar las comidas, '
      + 'usar listas de la compra y conservar bien '
      + 'los alimentos son estrategias eficaces. '
      + 'En 2022, el mundo desperdició 1.050 '
      + 'millones de toneladas de alimentos en '
      + 'hogares, comercios y restaurantes, casi '
      + 'una quinta parte de todos los alimentos '
      + 'disponibles para los consumidores '
      + '([UNEP](https://www.unep.org/en/news-and'
      + '-stories/press-release/world-squanders'
      + '-over-1-billion-meals-day-un-report)).',
  },

  plant_milk: {
    en:
      'Choosing plant milk over dairy saves '
      + 'roughly **460g** of CO2 per 250ml '
      + 'serving. Dairy milk emits about 3.2kg '
      + 'CO2 per litre versus 0.4-1.0kg for '
      + 'plant alternatives ([Poore & '
      + 'Nemecek 2018](https://ourworldindata'
      + '.org/food-choice-vs-eating-local)). '
      + 'Oat milk has the lowest footprint '
      + 'among plant milks, followed by soy '
      + '([Our World in Data]'
      + '(https://ourworldindata.org'
      + '/environmental-impacts-of-food)). '
      + 'Dairy also requires 10x more land and '
      + '2-3x more water per litre than most '
      + 'plant milks.',
    ja:
      '乳製品の代わりに植物性ミルクを選ぶと'
      + '250mlあたり約**460g**のCO2を削減'
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
      'Elegir leche vegetal en vez de láctea '
      + 'ahorra aproximadamente **460g** de CO2 '
      + 'por porción de 250ml. La leche láctea '
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
      + 'Los lácteos requieren 10 veces más '
      + 'tierra y 2-3 veces más agua por litro.',
  },

  seasonal_produce: {
    en:
      'The app claims no CO2 saving for '
      + 'buying seasonal produce. The saving '
      + 'depends on what the produce '
      + 'replaces and how much you buy, and '
      + 'seasonal local produce is not '
      + 'always the lower-carbon choice. A '
      + 'UK study found that air-freighted '
      + 'fresh vegetables have around five '
      + 'times the impact of domestic ones, '
      + 'but that imports from unheated '
      + 'greenhouses in Europe beat UK '
      + 'vegetables from heated greenhouses '
      + '([Frankowska et al. 2019]'
      + '(https://pubmed.ncbi.nlm.nih.gov/31108271/)'
      + '). Produce that grows outdoors in '
      + 'season near you avoids both air '
      + 'freight and greenhouse heating. The '
      + 'action still earns points for the '
      + 'effort.',
    ja:
      'アプリは旬の食材を買うことによるCO'
      + '2削減量を計上していません。削減量は'
      + '、代わりに何を買うはずだったかや買う'
      + '量によって変わり、地元の旬の食材がい'
      + 'つも低炭素とは限らないためです。英国'
      + 'の研究によると、空輸された生鮮野菜の'
      + '環境負荷は国産の約5倍ですが、ヨーロ'
      + 'ッパの無加温温室で育てた輸入野菜は、'
      + '加温温室で育てた英国産の野菜より負荷'
      + 'が低くなります（[Frankowsk'
      + 'a et al. 2019]'
      + '(https://pubmed.ncbi.nlm.nih.gov/31108271/)'
      + '）。近くの露地で旬に育つ食材なら、空'
      + '輸も温室の加温も避けられます。この行'
      + '動にはポイントが付きます。',
    es:
      'La app no atribuye ningún ahorro de '
      + 'CO2 a comprar productos de '
      + 'temporada. El ahorro depende de qué '
      + 'productos sustituyen y de cuánto '
      + 'compras, y el producto local de '
      + 'temporada no siempre es la opción '
      + 'con menos carbono. Un estudio '
      + 'británico concluyó que las verduras '
      + 'frescas transportadas en avión '
      + 'tienen un impacto unas cinco veces '
      + 'mayor que las nacionales, pero que '
      + 'las importadas de invernaderos sin '
      + 'calefacción de Europa superan a las '
      + 'verduras británicas de invernaderos '
      + 'con calefacción ([Frankowska et al. '
      + '2019]'
      + '(https://pubmed.ncbi.nlm.nih.gov/31108271/)'
      + '). Los productos que crecen al aire '
      + 'libre en temporada cerca de ti '
      + 'evitan tanto el transporte aéreo '
      + 'como la calefacción de '
      + 'invernaderos. La acción sigue '
      + 'sumando puntos por el esfuerzo.',
  },


  vegan_day: {
    en:
      'Eating only plant-based foods for a day '
      + 'saves roughly **2,700g** of CO2 '
      + 'equivalent compared with a medium '
      + 'meat-eater\'s day. A study of over 55,000 '
      + 'UK adults found that diets with 50-99g of '
      + 'meat a day produced about 5.6kg CO2e a '
      + 'day and vegan diets about 2.9kg, both for '
      + 'a standard 2,000 kcal diet ([Scarborough '
      + 'et al., Climatic Change '
      + '2014](https://pmc.ncbi.nlm.nih.gov/'
      + 'articles/PMC4372775/)). That gap of about '
      + '2.7kg covers the meat, dairy and eggs '
      + 'replaced across every meal. The baseline '
      + 'is a whole day with 50-99g of meat of any '
      + 'kind, less than one 100g serving of beef, '
      + 'which is why a vegan day can be worth '
      + 'less than skipping one beef meal. Heavier '
      + 'meat-eaters averaged about 7.2kg a day, '
      + 'so for them a vegan day saves even more. '
      + 'One vegan day a week adds up to about '
      + '140kg a year.',
    ja:
      '1日を植物性食品だけで過ごすと、肉を中程度に'
      + '食べる人の1日と比べて約**2,700g**のCO2相当を'
      + '削減できます。英国の成人5万5,000人以上を対象'
      + 'にした研究では、肉を1日50〜99g食べる人の食事'
      + 'は1日約5.6kg CO2e、ヴィーガンの食事は約2.9kg'
      + 'でした。どちらも2,000 kcalの標準的な食事に換'
      + '算した値です（[Scarborough et al., Climatic '
      + 'Change 2014](https://pmc.ncbi.nlm.nih.gov/'
      + 'articles/PMC4372775/)）。この約2.7kgの差は、'
      + 'すべての食事で置き換えた肉、乳製品、卵の分で'
      + 'す。比較の基準は肉の種類を問わず1日50〜99gを'
      + '食べる日全体で、牛肉100g1食分より少ないため'
      + '、ヴィーガンの1日は牛肉1食を控えるより小さな'
      + '値になることがあります。肉を多く食べる人は1'
      + '日約7.2kgだったため、ヴィーガンの日の削減量'
      + 'はさらに大きくなります。週1日ヴィーガンで過'
      + 'ごすと、年間約140kgになります。',
    es:
      'Comer solo alimentos vegetales durante un '
      + 'día ahorra aproximadamente **2.700g** de '
      + 'CO2 equivalente frente al día de alguien '
      + 'que come una cantidad media de carne. Un '
      + 'estudio con más de 55.000 adultos del '
      + 'Reino Unido halló que las dietas con '
      + '50-99g de carne al día generaban unos '
      + '5,6kg CO2e diarios y las veganas unos '
      + '2,9kg, ambas para una dieta estándar de '
      + '2.000 kcal ([Scarborough et al., Climatic '
      + 'Change '
      + '2014](https://pmc.ncbi.nlm.nih.gov/'
      + 'articles/PMC4372775/)). Esa diferencia de '
      + 'unos 2,7kg corresponde a la carne, los '
      + 'lácteos y los huevos sustituidos en todas '
      + 'las comidas. La referencia es un día '
      + 'entero con 50-99g de carne de cualquier '
      + 'tipo, menos que una ración de 100g de '
      + 'vacuno, por eso un día vegano puede valer '
      + 'menos que evitar una comida de vacuno. '
      + 'Quienes comían mucha carne rondaban los '
      + '7,2kg diarios, así que para ellos un día '
      + 'vegano ahorra aún más. Un día vegano a la '
      + 'semana suma unos 140kg al año.',
  },

  bring_lunch: {
    en:
      'The app claims no CO2 saving for '
      + 'bringing lunch from home. The '
      + 'saving depends on what the bought '
      + 'meal would have been and how it was '
      + 'packed, and no source gives a '
      + 'figure for one lunch. A homemade '
      + 'lunch in a reusable container still '
      + 'avoids single-use containers, '
      + 'cutlery and bags. The action still '
      + 'earns points for the effort.',
    ja:
      'アプリはお弁当の持参によるCO2削減'
      + '量を計上していません。削減量は、買う'
      + 'はずだった食事の内容や包装によって変'
      + 'わり、昼食1回分の数値を示す出典がな'
      + 'いためです。それでも、繰り返し使える'
      + '容器に入れた手作りの昼食なら、使い捨'
      + 'ての容器やカトラリー、袋を使わずに済'
      + 'みます。この行動にはポイントが付きま'
      + 'す。',
    es:
      'La app no atribuye ningún ahorro de '
      + 'CO2 a llevar la comida de casa. El '
      + 'ahorro depende de qué comida '
      + 'habrías comprado y de cómo venía '
      + 'envasada, y ninguna fuente da una '
      + 'cifra para un almuerzo. Aun así, '
      + 'una comida casera en un recipiente '
      + 'reutilizable evita envases, '
      + 'cubiertos y bolsas de un solo uso. '
      + 'La acción sigue sumando puntos por '
      + 'el esfuerzo.',
  },

};

module.exports = descriptions;
