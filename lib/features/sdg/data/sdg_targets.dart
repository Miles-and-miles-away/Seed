/// UN SDG target data for all 17 goals.
class SdgTarget {
  const SdgTarget({
    required this.code,
    required this.description,
    this.descriptionJa = '',
    this.descriptionEs = '',
  });

  final String code;
  final String description;
  final String descriptionJa;
  final String descriptionEs;

  String getDescription(String locale) => switch (locale) {
        'ja' when descriptionJa.isNotEmpty => descriptionJa,
        'es' when descriptionEs.isNotEmpty => descriptionEs,
        _ => description,
      };
}

/// All 169 UN SDG targets keyed by goal number.
const Map<int, List<SdgTarget>> sdgTargets = {
  1: [
    SdgTarget(
      code: '1.1',
      description: 'By 2030, eradicate extreme '
          'poverty for all people '
          'everywhere, currently measured '
          'as people living on less than '
          r'$1.25 a day',
      descriptionJa: '2030年までに、現在1日1.25ドル未満で生活する人々と定義されている極度の貧困をあらゆる場所で終わらせる',
      descriptionEs: 'De aqui a 2030, erradicar para '
          'todas las personas y en todo el '
          'mundo la pobreza extrema, '
          'actualmente medida por un '
          'ingreso por persona inferior a '
          '1,25 dolares de los Estados '
          'Unidos al dia',
    ),
    SdgTarget(
      code: '1.2',
      description: 'By 2030, reduce at least by half '
          'the proportion of men, women and '
          'children of all ages living in '
          'poverty in all its dimensions '
          'according to national '
          'definitions',
      descriptionJa: '2030年までに、各国定義によるあらゆる次元の貧困状態にある、すべての年齢の男性、女性、子どもの割合を半減させる',
      descriptionEs: 'De aqui a 2030, reducir al menos '
          'a la mitad la proporcion de '
          'hombres, mujeres y ninos de '
          'todas las edades que viven en la '
          'pobreza en todas sus dimensiones '
          'con arreglo a las definiciones '
          'nacionales',
    ),
    SdgTarget(
      code: '1.3',
      description: 'Implement nationally appropriate '
          'social protection systems and '
          'measures for all, including '
          'floors, and by 2030 achieve '
          'substantial coverage of the poor '
          'and the vulnerable',
      descriptionJa:
          '各国において最低限の基準を含む適切な社会保護制度及び対策を実施し、2030年までに貧困層及び脆弱層に対し十分な保護を達成する',
      descriptionEs: 'Implementar a nivel nacional '
          'sistemas y medidas apropiados de '
          'proteccion social para todos, '
          'incluidos niveles minimos, y, de '
          'aqui a 2030, lograr una amplia '
          'cobertura de las personas pobres '
          'y vulnerables',
    ),
    SdgTarget(
      code: '1.4',
      description: 'By 2030, ensure that all men and '
          'women, in particular the poor '
          'and the vulnerable, have equal '
          'rights to economic resources, as '
          'well as access to basic '
          'services, ownership and control '
          'over land and other forms of '
          'property, inheritance, natural '
          'resources, appropriate new '
          'technology and financial '
          'services, including microfinance',
      descriptionJa:
          '2030年までに、貧困層及び脆弱層をはじめ、すべての男性及び女性が、経済的資源に対する同等の権利を持つとともに、基礎的サービス、オーナーシップ及び土地その他の財産、相続財産、天然資源、適切な新技術、マイクロファイナンスを含む金融サービスへのアクセスを確保する',
      descriptionEs: 'De aqui a 2030, garantizar que '
          'todos los hombres y mujeres, en '
          'particular los pobres y los '
          'vulnerables, tengan los mismos '
          'derechos a los recursos '
          'economicos y acceso a los '
          'servicios basicos, la propiedad '
          'y el control de la tierra y '
          'otros bienes, la herencia, los '
          'recursos naturales, las nuevas '
          'tecnologias apropiadas y los '
          'servicios financieros, incluida '
          'la microfinanciacion',
    ),
    SdgTarget(
      code: '1.5',
      description: 'By 2030, build the resilience of '
          'the poor and those in vulnerable '
          'situations and reduce their '
          'exposure and vulnerability to '
          'climate-related extreme events '
          'and other economic, social and '
          'environmental shocks and '
          'disasters',
      descriptionJa:
          '2030年までに、貧困層や脆弱な状況にある人々の強靱性を構築し、気候変動に関連する極端な気象現象やその他の経済、社会、環境的ショック及び災害に対する暴露や脆弱性を軽減する',
      descriptionEs: 'De aqui a 2030, fomentar la '
          'resiliencia de los pobres y las '
          'personas que se encuentran en '
          'situaciones de vulnerabilidad y '
          'reducir su exposicion y '
          'vulnerabilidad a los fenomenos '
          'extremos relacionados con el '
          'clima y otras perturbaciones y '
          'desastres economicos, sociales y '
          'ambientales',
    ),
    SdgTarget(
      code: '1.a',
      description: 'Ensure significant mobilization '
          'of resources from a variety of '
          'sources, including through '
          'enhanced development '
          'cooperation, in order to provide '
          'adequate and predictable means '
          'for developing countries, in '
          'particular least developed '
          'countries, to implement '
          'programmes and policies to end '
          'poverty in all its dimensions',
      descriptionJa:
          'あらゆる次元での貧困を終わらせるための計画や政策を実施するべく、後発開発途上国をはじめとする開発途上国に対して適切かつ予測可能な手段を講じるため、開発協力の強化などを通じて、さまざまな供給源からの相当量の資源の動員を確保する',
      descriptionEs: 'Garantizar una movilizacion '
          'significativa de recursos '
          'procedentes de diversas fuentes, '
          'incluso mediante la mejora de la '
          'cooperacion para el desarrollo, '
          'a fin de proporcionar medios '
          'suficientes y previsibles a los '
          'paises en desarrollo, en '
          'particular los paises menos '
          'adelantados, para que '
          'implementen programas y '
          'politicas encaminados a poner '
          'fin a la pobreza en todas sus '
          'dimensiones',
    ),
    SdgTarget(
      code: '1.b',
      description: 'Create sound policy frameworks '
          'at the national, regional and '
          'international levels, based on '
          'pro-poor and gender-sensitive '
          'development strategies, to '
          'support accelerated investment '
          'in poverty eradication actions',
      descriptionJa:
          '貧困撲滅のための行動への投資拡大を支援するため、国、地域及び国際レベルで、貧困層やジェンダーに配慮した開発戦略に基づいた適正な政策的枠組みを構築する',
      descriptionEs: 'Crear marcos normativos solidos '
          'en los planos nacional, regional '
          'e internacional, sobre la base '
          'de estrategias de desarrollo en '
          'favor de los pobres que tengan '
          'en cuenta las cuestiones de '
          'genero, a fin de apoyar la '
          'inversion acelerada en medidas '
          'para erradicar la pobreza',
    ),
  ],
  2: [
    SdgTarget(
      code: '2.1',
      description: 'By 2030, end hunger and ensure '
          'access by all people, in '
          'particular the poor and people '
          'in vulnerable situations, '
          'including infants, to safe, '
          'nutritious and sufficient food '
          'all year round',
      descriptionJa:
          '2030年までに、飢餓を撲滅し、すべての人々、特に貧困層及び幼児を含む脆弱な立場にある人々が一年中安全かつ栄養のある食料を十分得られるようにする',
      descriptionEs: 'De aqui a 2030, poner fin al '
          'hambre y asegurar el acceso de '
          'todas las personas, en '
          'particular los pobres y las '
          'personas en situaciones de '
          'vulnerabilidad, incluidos los '
          'ninos menores de 1 ano, a una '
          'alimentacion sana, nutritiva y '
          'suficiente durante todo el ano',
    ),
    SdgTarget(
      code: '2.2',
      description: 'By 2030, end all forms of '
          'malnutrition, including '
          'achieving by 2025 the '
          'internationally agreed targets '
          'on stunting and wasting in '
          'children under five years of '
          'age, and address the nutritional '
          'needs of adolescent girls, '
          'pregnant and lactating women, '
          'and older persons',
      descriptionJa:
          '5歳未満の子どもの発育阻害や消耗性疾患について国際的に合意されたターゲットを2025年までに達成するなど、2030年までにあらゆる形態の栄養不良を解消し、若年女子、妊婦・授乳婦及び高齢者の栄養ニーズへの対処を行う',
      descriptionEs: 'De aqui a 2030, poner fin a '
          'todas las formas de '
          'malnutricion, incluso logrando, '
          'a mas tardar en 2025, las metas '
          'convenidas internacionalmente '
          'sobre el retraso del crecimiento '
          'y la emaciacion de los ninos '
          'menores de 5 anos, y abordar las '
          'necesidades de nutricion de las '
          'adolescentes, las mujeres '
          'embarazadas y lactantes y las '
          'personas de edad',
    ),
    SdgTarget(
      code: '2.3',
      description: 'By 2030, double the agricultural '
          'productivity and incomes of '
          'small-scale food producers, in '
          'particular women, indigenous '
          'peoples, family farmers, '
          'pastoralists and fishers, '
          'including through secure and '
          'equal access to land, other '
          'productive resources and inputs, '
          'knowledge, financial services, '
          'markets and opportunities for '
          'value addition and non-farm '
          'employment',
      descriptionJa:
          '2030年までに、土地、その他の生産資源や、投入財、知識、金融サービス、市場及び高付加価値化や非農業雇用の機会への確実かつ平等なアクセスの確保などを通じて、女性、先住民、家族農家、牧畜民及び漁業者をはじめとする小規模食料生産者の農業生産性及び所得を倍増させる',
      descriptionEs: 'De aqui a 2030, duplicar la '
          'productividad agricola y los '
          'ingresos de los productores de '
          'alimentos en pequena escala, en '
          'particular las mujeres, los '
          'pueblos indigenas, los '
          'agricultores familiares, los '
          'ganaderos y los pescadores, '
          'entre otras cosas mediante un '
          'acceso seguro y equitativo a las '
          'tierras, a otros recursos e '
          'insumos de produccion y a los '
          'conocimientos, los servicios '
          'financieros, los mercados y las '
          'oportunidades para anadir valor '
          'y obtener empleos no agricolas',
    ),
    SdgTarget(
      code: '2.4',
      description: 'By 2030, ensure sustainable food '
          'production systems and implement '
          'resilient agricultural practices '
          'that increase productivity and '
          'production, that help maintain '
          'ecosystems, that strengthen '
          'capacity for adaptation to '
          'climate change, extreme weather, '
          'drought, flooding and other '
          'disasters and that progressively '
          'improve land and soil quality',
      descriptionJa:
          '2030年までに、生産性を向上させ、生産量を増やし、生態系を維持し、気候変動や極端な気象現象、干ばつ、洪水及びその他の災害に対する適応能力を向上させ、漸進的に土地と土壌の質を改善させるような、持続可能な食料生産システムを確保し、強靱な農業を実践する',
      descriptionEs: 'De aqui a 2030, asegurar la '
          'sostenibilidad de los sistemas '
          'de produccion de alimentos y '
          'aplicar practicas agricolas '
          'resilientes que aumenten la '
          'productividad y la produccion, '
          'contribuyan al mantenimiento de '
          'los ecosistemas, fortalezcan la '
          'capacidad de adaptacion al '
          'cambio climatico, los fenomenos '
          'meteorologicos extremos, las '
          'sequias, las inundaciones y '
          'otros desastres, y mejoren '
          'progresivamente la calidad de la '
          'tierra y el suelo',
    ),
    SdgTarget(
      code: '2.5',
      description: 'By 2020, maintain the genetic '
          'diversity of seeds, cultivated '
          'plants and farmed and '
          'domesticated animals and their '
          'related wild species, including '
          'through soundly managed and '
          'diversified seed and plant banks '
          'at the national, regional and '
          'international levels, and '
          'promote access to and fair and '
          'equitable sharing of benefits '
          'arising from the utilization of '
          'genetic resources and associated '
          'traditional knowledge, as '
          'internationally agreed',
      descriptionJa:
          '2020年までに、国、地域及び国際レベルで適正に管理及び多様化された種子・植物バンクなども通じて、種子、栽培植物、飼育・家畜化された動物及びこれらの近縁野生種の遺伝的多様性を維持し、国際的合意に基づき、遺伝資源及びこれに関連する伝統的な知識へのアクセス及びその利用から生じる利益の公正かつ衡平な配分を促進する',
      descriptionEs: 'De aqui a 2020, mantener la '
          'diversidad genetica de las '
          'semillas, las plantas cultivadas '
          'y los animales de granja y '
          'domesticados y sus '
          'correspondientes especies '
          'silvestres, entre otras cosas '
          'mediante una buena gestion y '
          'diversificacion de los bancos de '
          'semillas y plantas a nivel '
          'nacional, regional e '
          'internacional, y promover el '
          'acceso a los beneficios que se '
          'deriven de la utilizacion de los '
          'recursos geneticos y los '
          'conocimientos tradicionales '
          'conexos y su distribucion justa '
          'y equitativa, segun lo convenido '
          'internacionalmente',
    ),
    SdgTarget(
      code: '2.a',
      description: 'Increase investment, including '
          'through enhanced international '
          'cooperation, in rural '
          'infrastructure, agricultural '
          'research and extension services, '
          'technology development and plant '
          'and livestock gene banks in '
          'order to enhance agricultural '
          'productive capacity in '
          'developing countries, in '
          'particular least developed '
          'countries',
      descriptionJa:
          '開発途上国、特に後発開発途上国における農業生産能力向上のために、国際協力の強化などを通じて、農村インフラ、農業研究・普及サービス、技術開発及び植物・家畜のジーン・バンクへの投資の拡大を図る',
      descriptionEs: 'Aumentar, incluso mediante una '
          'mayor cooperacion internacional, '
          'las inversiones en '
          'infraestructura rural, '
          'investigacion y servicios de '
          'extension agricola, desarrollo '
          'tecnologico y bancos de genes de '
          'plantas y ganado a fin de '
          'mejorar la capacidad de '
          'produccion agropecuaria en los '
          'paises en desarrollo, '
          'particularmente en los paises '
          'menos adelantados',
    ),
    SdgTarget(
      code: '2.b',
      description: 'Correct and prevent trade '
          'restrictions and distortions in '
          'world agricultural markets, '
          'including through the parallel '
          'elimination of all forms of '
          'agricultural export subsidies '
          'and all export measures with '
          'equivalent effect, in accordance '
          'with the mandate of the Doha '
          'Development Round',
      descriptionJa:
          'ドーハ開発ラウンドの決議に従い、すべての形態の農産物輸出補助金及び同等の効果を持つすべての輸出措置の並行的撤廃などを通じて、世界の農産物市場における貿易制限や歪みを是正及び防止する',
      descriptionEs: 'Corregir y prevenir las '
          'restricciones y distorsiones '
          'comerciales en los mercados '
          'agropecuarios mundiales, incluso '
          'mediante la eliminacion paralela '
          'de todas las formas de '
          'subvencion a las exportaciones '
          'agricolas y todas las medidas de '
          'exportacion con efectos '
          'equivalentes, de conformidad con '
          'el mandato de la Ronda de Doha '
          'para el Desarrollo',
    ),
    SdgTarget(
      code: '2.c',
      description: 'Adopt measures to ensure the '
          'proper functioning of food '
          'commodity markets and their '
          'derivatives and facilitate '
          'timely access to market '
          'information, including on food '
          'reserves, in order to help limit '
          'extreme food price volatility',
      descriptionJa:
          '食料価格の極端な変動に歯止めをかけるため、食料市場及びデリバティブ市場の適正な機能を確保するための措置を講じ、食料備蓄などの市場情報への適時のアクセスを容易にする',
      descriptionEs: 'Adoptar medidas para asegurar el '
          'buen funcionamiento de los '
          'mercados de productos basicos '
          'alimentarios y sus derivados y '
          'facilitar el acceso oportuno a '
          'la informacion sobre los '
          'mercados, incluso sobre las '
          'reservas de alimentos, a fin de '
          'ayudar a limitar la extrema '
          'volatilidad de los precios de '
          'los alimentos',
    ),
  ],
  3: [
    SdgTarget(
      code: '3.1',
      description: 'By 2030, reduce the global '
          'maternal mortality ratio to less '
          'than 70 per 100,000 live births',
      descriptionJa: '2030年までに、世界の妊産婦の死亡率を出生10万人当たり70人未満に削減する',
      descriptionEs: 'De aqui a 2030, reducir la tasa '
          'mundial de mortalidad materna a '
          'menos de 70 por cada 100.000 '
          'nacidos vivos',
    ),
    SdgTarget(
      code: '3.2',
      description: 'By 2030, end preventable deaths '
          'of newborns and children under 5 '
          'years of age, with all countries '
          'aiming to reduce neonatal '
          'mortality to at least as low as '
          '12 per 1,000 live births and '
          'under-5 mortality to at least as '
          'low as 25 per 1,000 live births',
      descriptionJa:
          'すべての国が新生児死亡率を少なくとも出生1,000件中12件以下まで減らし、5歳以下死亡率を少なくとも出生1,000件中25件以下まで減らすことを目指し、2030年までに、新生児及び5歳未満児の予防可能な死亡を根絶する',
      descriptionEs: 'De aqui a 2030, poner fin a las '
          'muertes evitables de recien '
          'nacidos y de ninos menores de 5 '
          'anos, logrando que todos los '
          'paises intenten reducir la '
          'mortalidad neonatal al menos a '
          '12 por cada 1.000 nacidos vivos '
          'y la mortalidad de los ninos '
          'menores de 5 anos al menos a 25 '
          'por cada 1.000 nacidos vivos',
    ),
    SdgTarget(
      code: '3.3',
      description: 'By 2030, end the epidemics of '
          'AIDS, tuberculosis, malaria and '
          'neglected tropical diseases and '
          'combat hepatitis, water-borne '
          'diseases and other communicable '
          'diseases',
      descriptionJa:
          '2030年までに、エイズ、結核、マラリア及び顧みられない熱帯病といった伝染病を根絶するとともに肝炎、水系感染症及びその他の感染症に対処する',
      descriptionEs: 'De aqui a 2030, poner fin a las '
          'epidemias del SIDA, la '
          'tuberculosis, la malaria y las '
          'enfermedades tropicales '
          'desatendidas y combatir la '
          'hepatitis, las enfermedades '
          'transmitidas por el agua y otras '
          'enfermedades transmisibles',
    ),
    SdgTarget(
      code: '3.4',
      description: 'By 2030, reduce by one third '
          'premature mortality from '
          'non-communicable diseases '
          'through prevention and treatment '
          'and promote mental health and '
          'well-being',
      descriptionJa: '2030年までに、非感染性疾患による若年死亡率を、予防や治療を通じて3分の1減少させ、精神保健及び福祉を促進する',
      descriptionEs: 'De aqui a 2030, reducir en un '
          'tercio la mortalidad prematura '
          'por enfermedades no '
          'transmisibles mediante su '
          'prevencion y tratamiento, y '
          'promover la salud mental y el '
          'bienestar',
    ),
    SdgTarget(
      code: '3.5',
      description: 'Strengthen the prevention and '
          'treatment of substance abuse, '
          'including narcotic drug abuse '
          'and harmful use of alcohol',
      descriptionJa: '薬物乱用やアルコールの有害な摂取を含む、物質乱用の防止・治療を強化する',
      descriptionEs: 'Fortalecer la prevencion y el '
          'tratamiento del abuso de '
          'sustancias adictivas, incluido '
          'el uso indebido de '
          'estupefacientes y el consumo '
          'nocivo de alcohol',
    ),
    SdgTarget(
      code: '3.6',
      description: 'By 2020, halve the number of '
          'global deaths and injuries from '
          'road traffic accidents',
      descriptionJa: '2020年までに、世界の道路交通事故による死傷者を半減させる',
      descriptionEs: 'De aqui a 2020, reducir a la '
          'mitad el numero de muertes y '
          'lesiones causadas por accidentes '
          'de trafico en el mundo',
    ),
    SdgTarget(
      code: '3.7',
      description: 'By 2030, ensure universal access '
          'to sexual and reproductive '
          'health-care services, including '
          'for family planning, information '
          'and education, and the '
          'integration of reproductive '
          'health into national strategies '
          'and programmes',
      descriptionJa:
          '2030年までに、家族計画、情報・教育及びリプロダクティブ・ヘルスの国家戦略・計画への組み入れを含む、性と生殖に関する保健サービスをすべての人々が利用できるようにする',
      descriptionEs: 'De aqui a 2030, garantizar el '
          'acceso universal a los servicios '
          'de salud sexual y reproductiva, '
          'incluidos los de planificacion '
          'familiar, informacion y '
          'educacion, y la integracion de '
          'la salud reproductiva en las '
          'estrategias y los programas '
          'nacionales',
    ),
    SdgTarget(
      code: '3.8',
      description: 'Achieve universal health '
          'coverage, including financial '
          'risk protection, access to '
          'quality essential health-care '
          'services and access to safe, '
          'effective, quality and '
          'affordable essential medicines '
          'and vaccines for all',
      descriptionJa:
          'すべての人々に対する財政リスクからの保護、質の高い基礎的な保健サービスへのアクセス及び安全で効果的かつ質が高く安価な必須医薬品とワクチンへのアクセスを含む、ユニバーサル・ヘルス・カバレッジを達成する',
      descriptionEs: 'Lograr la cobertura sanitaria '
          'universal, incluida la '
          'proteccion contra los riesgos '
          'financieros, el acceso a '
          'servicios de salud esenciales de '
          'calidad y el acceso a '
          'medicamentos y vacunas inocuos, '
          'eficaces, asequibles y de '
          'calidad para todos',
    ),
    SdgTarget(
      code: '3.9',
      description: 'By 2030, substantially reduce '
          'the number of deaths and '
          'illnesses from hazardous '
          'chemicals and air, water and '
          'soil pollution and contamination',
      descriptionJa: '2030年までに、有害化学物質、ならびに大気、水質及び土壌の汚染による死亡及び疾病の件数を大幅に減少させる',
      descriptionEs: 'De aqui a 2030, reducir '
          'considerablemente el numero de '
          'muertes y enfermedades causadas '
          'por productos quimicos '
          'peligrosos y por la polucion y '
          'contaminacion del aire, el agua '
          'y el suelo',
    ),
    SdgTarget(
      code: '3.a',
      description: 'Strengthen the implementation of '
          'the World Health Organization '
          'Framework Convention on Tobacco '
          'Control in all countries, as '
          'appropriate',
      descriptionJa: 'すべての国々において、たばこの規制に関する世界保健機関枠組条約の実施を適宜強化する',
      descriptionEs: 'Fortalecer la aplicacion del '
          'Convenio Marco de la '
          'Organizacion Mundial de la Salud '
          'para el Control del Tabaco en '
          'todos los paises, segun proceda',
    ),
    SdgTarget(
      code: '3.b',
      description: 'Support the research and '
          'development of vaccines and '
          'medicines for the communicable '
          'and non-communicable diseases '
          'that primarily affect developing '
          'countries, provide access to '
          'affordable essential medicines '
          'and vaccines for all',
      descriptionJa:
          '主に開発途上国に影響を及ぼす感染性及び非感染性疾患のワクチン及び医薬品の研究開発を支援するとともに、すべての人々に安価な必須医薬品及びワクチンへのアクセスを提供する',
      descriptionEs: 'Apoyar las actividades de '
          'investigacion y desarrollo de '
          'vacunas y medicamentos contra '
          'las enfermedades transmisibles y '
          'no transmisibles que afectan '
          'primordialmente a los paises en '
          'desarrollo y facilitar el acceso '
          'a medicamentos y vacunas '
          'esenciales asequibles',
    ),
    SdgTarget(
      code: '3.c',
      description: 'Substantially increase health '
          'financing and the recruitment, '
          'development, training and '
          'retention of the health '
          'workforce in developing '
          'countries, especially in least '
          'developed countries and small '
          'island developing States',
      descriptionJa:
          '開発途上国、特に後発開発途上国及び小島嶼開発途上国において保健財政及び保健人材の採用、能力開発・訓練及び定着を大幅に拡大させる',
      descriptionEs: 'Aumentar considerablemente la '
          'financiacion de la salud y la '
          'contratacion, el '
          'perfeccionamiento, la '
          'capacitacion y la retencion del '
          'personal sanitario en los paises '
          'en desarrollo, especialmente en '
          'los paises menos adelantados y '
          'los pequenos Estados insulares '
          'en desarrollo',
    ),
    SdgTarget(
      code: '3.d',
      description: 'Strengthen the capacity of all '
          'countries, in particular '
          'developing countries, for early '
          'warning, risk reduction and '
          'management of national and '
          'global health risks',
      descriptionJa:
          'すべての国々、特に開発途上国の国家・世界規模な健康危険因子の早期警告、危険因子緩和及び危険因子管理のための能力を強化する',
      descriptionEs: 'Reforzar la capacidad de todos '
          'los paises, en particular los '
          'paises en desarrollo, en materia '
          'de alerta temprana, reduccion de '
          'riesgos y gestion de los riesgos '
          'para la salud nacional y mundial',
    ),
  ],
  4: [
    SdgTarget(
      code: '4.1',
      description: 'By 2030, ensure that all girls '
          'and boys complete free, '
          'equitable and quality primary '
          'and secondary education leading '
          'to relevant and effective '
          'learning outcomes',
      descriptionJa:
          '2030年までに、すべての子どもが男女の区別なく、適切かつ効果的な学習成果をもたらす、無償かつ公正で質の高い初等教育及び中等教育を修了できるようにする',
      descriptionEs: 'De aqui a 2030, asegurar que '
          'todas las ninas y todos los '
          'ninos terminen la ensenanza '
          'primaria y secundaria, que ha de '
          'ser gratuita, equitativa y de '
          'calidad y producir resultados de '
          'aprendizaje pertinentes y '
          'efectivos',
    ),
    SdgTarget(
      code: '4.2',
      description: 'By 2030, ensure that all girls '
          'and boys have access to quality '
          'early childhood development, '
          'care and pre-primary education '
          'so that they are ready for '
          'primary education',
      descriptionJa:
          '2030年までに、すべての子どもが男女の区別なく、質の高い乳幼児の発達・ケア及び就学前教育にアクセスすることにより、初等教育を受ける準備が整うようにする',
      descriptionEs: 'De aqui a 2030, asegurar que '
          'todas las ninas y todos los '
          'ninos tengan acceso a servicios '
          'de atencion y desarrollo en la '
          'primera infancia y educacion '
          'preescolar de calidad, a fin de '
          'que esten preparados para la '
          'ensenanza primaria',
    ),
    SdgTarget(
      code: '4.3',
      description: 'By 2030, ensure equal access for '
          'all women and men to affordable '
          'and quality technical, '
          'vocational and tertiary '
          'education, including university',
      descriptionJa:
          '2030年までに、すべての女性及び男性が、手の届く質の高い技術教育・職業教育及び大学を含む高等教育への平等なアクセスを得られるようにする',
      descriptionEs: 'De aqui a 2030, asegurar el '
          'acceso igualitario de todos los '
          'hombres y las mujeres a una '
          'formacion tecnica, profesional y '
          'superior de calidad, incluida la '
          'ensenanza universitaria',
    ),
    SdgTarget(
      code: '4.4',
      description: 'By 2030, substantially increase '
          'the number of youth and adults '
          'who have relevant skills, '
          'including technical and '
          'vocational skills, for '
          'employment, decent jobs and '
          'entrepreneurship',
      descriptionJa:
          '2030年までに、技術的・職業的スキルなど、雇用、働きがいのある人間らしい仕事及び起業に必要な技能を備えた若者と成人の割合を大幅に増加させる',
      descriptionEs: 'De aqui a 2030, aumentar '
          'considerablemente el numero de '
          'jovenes y adultos que tienen las '
          'competencias necesarias, en '
          'particular tecnicas y '
          'profesionales, para acceder al '
          'empleo, el trabajo decente y el '
          'emprendimiento',
    ),
    SdgTarget(
      code: '4.5',
      description: 'By 2030, eliminate gender '
          'disparities in education and '
          'ensure equal access to all '
          'levels of education and '
          'vocational training for the '
          'vulnerable, including persons '
          'with disabilities, indigenous '
          'peoples and children in '
          'vulnerable situations',
      descriptionJa:
          '2030年までに、教育におけるジェンダー格差を無くし、障害者、先住民及び脆弱な立場にある子どもなど、脆弱層があらゆるレベルの教育や職業訓練に平等にアクセスできるようにする',
      descriptionEs: 'De aqui a 2030, eliminar las '
          'disparidades de genero en la '
          'educacion y asegurar el acceso '
          'igualitario a todos los niveles '
          'de la ensenanza y la formacion '
          'profesional para las personas '
          'vulnerables, incluidas las '
          'personas con discapacidad, los '
          'pueblos indigenas y los ninos en '
          'situaciones de vulnerabilidad',
    ),
    SdgTarget(
      code: '4.6',
      description: 'By 2030, ensure that all youth '
          'and a substantial proportion of '
          'adults, both men and women, '
          'achieve literacy and numeracy',
      descriptionJa:
          '2030年までに、すべての若者及び大多数の成人が、男女ともに、読み書き能力及び基本的計算能力を身に付けられるようにする',
      descriptionEs: 'De aqui a 2030, asegurar que '
          'todos los jovenes y una '
          'proporcion considerable de los '
          'adultos, tanto hombres como '
          'mujeres, esten alfabetizados y '
          'tengan nociones elementales de '
          'aritmetica',
    ),
    SdgTarget(
      code: '4.7',
      description: 'By 2030, ensure that all '
          'learners acquire the knowledge '
          'and skills needed to promote '
          'sustainable development, '
          'including through education for '
          'sustainable development and '
          'sustainable lifestyles, human '
          'rights, gender equality, '
          'promotion of a culture of peace '
          'and non-violence, global '
          'citizenship and appreciation of '
          'cultural diversity',
      descriptionJa:
          '2030年までに、持続可能な開発のための教育及び持続可能なライフスタイル、人権、男女の平等、平和及び非暴力的文化の推進、グローバル・シチズンシップ、文化多様性と文化の持続可能な開発への貢献の理解の教育を通して、すべての学習者が、持続可能な開発を促進するために必要な知識及び技能を習得できるようにする',
      descriptionEs: 'De aqui a 2030, asegurar que '
          'todos los alumnos adquieran los '
          'conocimientos teoricos y '
          'practicos necesarios para '
          'promover el desarrollo '
          'sostenible, entre otras cosas '
          'mediante la educacion para el '
          'desarrollo sostenible y los '
          'estilos de vida sostenibles, los '
          'derechos humanos, la igualdad de '
          'genero, la promocion de una '
          'cultura de paz y no violencia, '
          'la ciudadania mundial y la '
          'valoracion de la diversidad '
          'cultural',
    ),
    SdgTarget(
      code: '4.a',
      description: 'Build and upgrade education '
          'facilities that are child, '
          'disability and gender sensitive '
          'and provide safe, non-violent, '
          'inclusive and effective learning '
          'environments for all',
      descriptionJa:
          '子ども、障害及びジェンダーに配慮した教育施設を構築・改良し、すべての人々に安全で非暴力的、包摂的、効果的な学習環境を提供できるようにする',
      descriptionEs: 'Construir y adecuar '
          'instalaciones educativas que '
          'tengan en cuenta las necesidades '
          'de los ninos y las personas con '
          'discapacidad y las diferencias '
          'de genero, y que ofrezcan '
          'entornos de aprendizaje seguros, '
          'no violentos, inclusivos y '
          'eficaces para todos',
    ),
    SdgTarget(
      code: '4.b',
      description: 'By 2020, substantially expand '
          'globally the number of '
          'scholarships available to '
          'developing countries, in '
          'particular least developed '
          'countries, small island '
          'developing States and African '
          'countries, for enrolment in '
          'higher education',
      descriptionJa:
          '2020年までに、開発途上国、特に後発開発途上国及び小島嶼開発途上国、ならびにアフリカ諸国を対象とした、職業訓練、情報通信技術、技術・工学・科学プログラムなど、先進国及びその他の開発途上国における高等教育の奨学金の件数を全世界で大幅に増加させる',
      descriptionEs: 'De aqui a 2020, aumentar '
          'considerablemente a nivel '
          'mundial el numero de becas '
          'disponibles para los paises en '
          'desarrollo, en particular los '
          'paises menos adelantados, los '
          'pequenos Estados insulares en '
          'desarrollo y los paises '
          'africanos, a fin de que sus '
          'estudiantes puedan matricularse '
          'en programas de ensenanza '
          'superior',
    ),
    SdgTarget(
      code: '4.c',
      description: 'By 2030, substantially increase '
          'the supply of qualified '
          'teachers, including through '
          'international cooperation for '
          'teacher training in developing '
          'countries, especially least '
          'developed countries and small '
          'island developing States',
      descriptionJa:
          '2030年までに、開発途上国、特に後発開発途上国及び小島嶼開発途上国における教員研修のための国際協力などを通じて、質の高い教員の数を大幅に増加させる',
      descriptionEs: 'De aqui a 2030, aumentar '
          'considerablemente la oferta de '
          'docentes calificados, incluso '
          'mediante la cooperacion '
          'internacional para la formacion '
          'de docentes en los paises en '
          'desarrollo, especialmente los '
          'paises menos adelantados y los '
          'pequenos Estados insulares en '
          'desarrollo',
    ),
  ],
  5: [
    SdgTarget(
      code: '5.1',
      description:
          'End all forms of discrimination against all women and girls everywhere',
      descriptionJa: 'あらゆる場所におけるすべての女性及び女児に対するあらゆる形態の差別を撤廃する',
      descriptionEs: 'Poner fin a todas las formas de '
          'discriminacion contra todas las '
          'mujeres y las ninas en todo el '
          'mundo',
    ),
    SdgTarget(
      code: '5.2',
      description: 'Eliminate all forms of violence '
          'against all women and girls in '
          'the public and private spheres, '
          'including trafficking and sexual '
          'and other types of exploitation',
      descriptionJa:
          'すべての女性及び女児に対する、公共・私的空間におけるあらゆる形態の暴力を排除する（人身売買や性的、その他の種類の搾取を含む）',
      descriptionEs: 'Eliminar todas las formas de '
          'violencia contra todas las '
          'mujeres y las ninas en los '
          'ambitos publico y privado, '
          'incluidas la trata y la '
          'explotacion sexual y otros tipos '
          'de explotacion',
    ),
    SdgTarget(
      code: '5.3',
      description: 'Eliminate all harmful practices, '
          'such as child, early and forced '
          'marriage and female genital '
          'mutilation',
      descriptionJa: '未成年者の結婚、早期結婚、強制結婚及び女性器切除など、あらゆる有害な慣行を撤廃する',
      descriptionEs: 'Eliminar todas las practicas '
          'nocivas, como el matrimonio '
          'infantil, precoz y forzado y la '
          'mutilacion genital femenina',
    ),
    SdgTarget(
      code: '5.4',
      description: 'Recognize and value unpaid care '
          'and domestic work through the '
          'provision of public services, '
          'infrastructure and social '
          'protection policies and the '
          'promotion of shared '
          'responsibility within the '
          'household and the family as '
          'nationally appropriate',
      descriptionJa:
          '公共のサービス、インフラ及び社会保障政策の提供、ならびに各国の状況に応じた世帯・家族内における責任分担を通じて、無報酬の育児・介護や家事労働を認識・評価する',
      descriptionEs: 'Reconocer y valorar los cuidados '
          'y el trabajo domestico no '
          'remunerados mediante servicios '
          'publicos, infraestructuras y '
          'politicas de proteccion social, '
          'y promoviendo la responsabilidad '
          'compartida en el hogar y la '
          'familia, segun proceda en cada '
          'pais',
    ),
    SdgTarget(
      code: '5.5',
      description: "Ensure women's full and "
          'effective participation and '
          'equal opportunities for '
          'leadership at all levels of '
          'decision-making in political, '
          'economic and public life',
      descriptionJa:
          '政治、経済、公共分野でのあらゆるレベルの意思決定において、完全かつ効果的な女性の参画及び平等なリーダーシップの機会を確保する',
      descriptionEs: 'Asegurar la participacion plena '
          'y efectiva de las mujeres y la '
          'igualdad de oportunidades de '
          'liderazgo a todos los niveles '
          'decisorios en la vida politica, '
          'economica y publica',
    ),
    SdgTarget(
      code: '5.6',
      description: 'Ensure universal access to '
          'sexual and reproductive health '
          'and reproductive rights as '
          'agreed in accordance with the '
          'Programme of Action of the '
          'International Conference on '
          'Population and Development and '
          'the Beijing Platform for Action',
      descriptionJa:
          '国際人口・開発会議の行動計画及び北京行動綱領、ならびにこれらの検証会議の成果文書に従い、性と生殖に関する健康及び権利への普遍的アクセスを確保する',
      descriptionEs: 'Asegurar el acceso universal a '
          'la salud sexual y reproductiva y '
          'los derechos reproductivos segun '
          'lo acordado de conformidad con '
          'el Programa de Accion de la '
          'Conferencia Internacional sobre '
          'la Poblacion y el Desarrollo, la '
          'Plataforma de Accion de Beijing',
    ),
    SdgTarget(
      code: '5.a',
      description: 'Undertake reforms to give women '
          'equal rights to economic '
          'resources, as well as access to '
          'ownership and control over land '
          'and other forms of property, '
          'financial services, inheritance '
          'and natural resources, in '
          'accordance with national laws',
      descriptionJa:
          '女性に対し、経済的資源に対する同等の権利、ならびに各国法に従い、オーナーシップ及び土地その他の財産、金融サービス、相続財産、天然資源に対するアクセスを与えるための改革に着手する',
      descriptionEs: 'Emprender reformas que otorguen '
          'a las mujeres igualdad de '
          'derechos a los recursos '
          'economicos, asi como acceso a la '
          'propiedad y al control de la '
          'tierra y otros tipos de bienes, '
          'los servicios financieros, la '
          'herencia y los recursos '
          'naturales, de conformidad con '
          'las leyes nacionales',
    ),
    SdgTarget(
      code: '5.b',
      description: 'Enhance the use of enabling '
          'technology, in particular '
          'information and communications '
          'technology, to promote the '
          'empowerment of women',
      descriptionJa: '女性の能力強化促進のため、ICTをはじめとする実現技術の活用を強化する',
      descriptionEs: 'Mejorar el uso de la tecnologia '
          'instrumental, en particular la '
          'tecnologia de la informacion y '
          'las comunicaciones, para '
          'promover el empoderamiento de '
          'las mujeres',
    ),
    SdgTarget(
      code: '5.c',
      description: 'Adopt and strengthen sound '
          'policies and enforceable '
          'legislation for the promotion of '
          'gender equality and the '
          'empowerment of all women and '
          'girls at all levels',
      descriptionJa:
          'ジェンダー平等の促進、ならびにすべての女性及び女子のあらゆるレベルでの能力強化のための適正な政策及び拘束力のある法規を導入・強化する',
      descriptionEs: 'Aprobar y fortalecer politicas '
          'acertadas y leyes aplicables '
          'para promover la igualdad de '
          'genero y el empoderamiento de '
          'todas las mujeres y las ninas a '
          'todos los niveles',
    ),
  ],
  6: [
    SdgTarget(
      code: '6.1',
      description: 'By 2030, achieve universal and '
          'equitable access to safe and '
          'affordable drinking water for '
          'all',
      descriptionJa: '2030年までに、すべての人々の、安全で安価な飲料水の普遍的かつ衡平なアクセスを達成する',
      descriptionEs: 'De aqui a 2030, lograr el acceso '
          'universal y equitativo al agua '
          'potable a un precio asequible '
          'para todos',
    ),
    SdgTarget(
      code: '6.2',
      description: 'By 2030, achieve access to '
          'adequate and equitable '
          'sanitation and hygiene for all '
          'and end open defecation, paying '
          'special attention to the needs '
          'of women and girls and those in '
          'vulnerable situations',
      descriptionJa:
          '2030年までに、すべての人々の、適切かつ平等な下水施設・衛生施設へのアクセスを達成し、野外での排泄をなくす。女性及び女児、ならびに脆弱な立場にある人々のニーズに特に注意を払う',
      descriptionEs: 'De aqui a 2030, lograr el acceso '
          'a servicios de saneamiento e '
          'higiene adecuados y equitativos '
          'para todos y poner fin a la '
          'defecacion al aire libre, '
          'prestando especial atencion a '
          'las necesidades de las mujeres y '
          'las ninas y las personas en '
          'situaciones de vulnerabilidad',
    ),
    SdgTarget(
      code: '6.3',
      description: 'By 2030, improve water quality '
          'by reducing pollution, '
          'eliminating dumping and '
          'minimizing release of hazardous '
          'chemicals and materials, halving '
          'the proportion of untreated '
          'wastewater and substantially '
          'increasing recycling and safe '
          'reuse globally',
      descriptionJa:
          '2030年までに、汚染の減少、投棄の廃絶と有害な化学物・物質の放出の最小化、未処理の排水の割合半減及び再生利用と安全な再利用の世界的規模で大幅な増加させることにより、水質を改善する',
      descriptionEs: 'De aqui a 2030, mejorar la '
          'calidad del agua reduciendo la '
          'contaminacion, eliminando el '
          'vertimiento y minimizando la '
          'emision de productos quimicos y '
          'materiales peligrosos, '
          'reduciendo a la mitad el '
          'porcentaje de aguas residuales '
          'sin tratar y aumentando '
          'considerablemente el reciclado y '
          'la reutilizacion sin riesgos a '
          'nivel mundial',
    ),
    SdgTarget(
      code: '6.4',
      description: 'By 2030, substantially increase '
          'water-use efficiency across all '
          'sectors and ensure sustainable '
          'withdrawals and supply of '
          'freshwater to address water '
          'scarcity and substantially '
          'reduce the number of people '
          'suffering from water scarcity',
      descriptionJa:
          '2030年までに、全セクターにおいて水利用の効率を大幅に改善し、淡水の持続可能な採取及び供給を確保し水不足に対処するとともに、水不足に悩む人々の数を大幅に減少させる',
      descriptionEs: 'De aqui a 2030, aumentar '
          'considerablemente el uso '
          'eficiente de los recursos '
          'hidricos en todos los sectores y '
          'asegurar la sostenibilidad de la '
          'extraccion y el abastecimiento '
          'de agua dulce para hacer frente '
          'a la escasez de agua y reducir '
          'considerablemente el numero de '
          'personas que sufren falta de '
          'agua',
    ),
    SdgTarget(
      code: '6.5',
      description: 'By 2030, implement integrated '
          'water resources management at '
          'all levels, including through '
          'transboundary cooperation as '
          'appropriate',
      descriptionJa: '2030年までに、国境を越えた適切な協力を含む、あらゆるレベルでの統合水資源管理を実施する',
      descriptionEs: 'De aqui a 2030, implementar la '
          'gestion integrada de los '
          'recursos hidricos a todos los '
          'niveles, incluso mediante la '
          'cooperacion transfronteriza, '
          'segun proceda',
    ),
    SdgTarget(
      code: '6.6',
      description: 'By 2020, protect and restore '
          'water-related ecosystems, '
          'including mountains, forests, '
          'wetlands, rivers, aquifers and '
          'lakes',
      descriptionJa: '2020年までに、山地、森林、湿地、河川、帯水層、湖沼を含む水に関連する生態系の保護・回復を行う',
      descriptionEs: 'De aqui a 2020, proteger y '
          'restablecer los ecosistemas '
          'relacionados con el agua, '
          'incluidos los bosques, las '
          'montanas, los humedales, los '
          'rios, los acuiferos y los lagos',
    ),
    SdgTarget(
      code: '6.a',
      description: 'By 2030, expand international '
          'cooperation and '
          'capacity-building support to '
          'developing countries in water- '
          'and sanitation-related '
          'activities and programmes, '
          'including water harvesting, '
          'desalination, water efficiency, '
          'wastewater treatment, recycling '
          'and reuse technologies',
      descriptionJa:
          '2030年までに、集水、海水淡水化、水の効率的利用、排水処理、リサイクル・再利用技術を含む開発途上国における水と衛生分野での活動と計画を対象とした国際協力と能力構築支援を拡大する',
      descriptionEs: 'De aqui a 2030, ampliar la '
          'cooperacion internacional y el '
          'apoyo prestado a los paises en '
          'desarrollo para la creacion de '
          'capacidad en actividades y '
          'programas relativos al agua y el '
          'saneamiento, como los de '
          'captacion de agua, '
          'desalinizacion, uso eficiente de '
          'los recursos hidricos, '
          'tratamiento de aguas residuales, '
          'reciclado y tecnologias de '
          'reutilizacion',
    ),
    SdgTarget(
      code: '6.b',
      description: 'Support and strengthen the '
          'participation of local '
          'communities in improving water '
          'and sanitation management',
      descriptionJa: '水と衛生の管理向上における地域コミュニティの参加を支援・強化する',
      descriptionEs: 'Apoyar y fortalecer la '
          'participacion de las comunidades '
          'locales en la mejora de la '
          'gestion del agua y el '
          'saneamiento',
    ),
  ],
  7: [
    SdgTarget(
      code: '7.1',
      description: 'By 2030, ensure universal access '
          'to affordable, reliable and '
          'modern energy services',
      descriptionJa: '2030年までに、安価かつ信頼できる現代的エネルギーサービスへの普遍的アクセスを確保する',
      descriptionEs: 'De aqui a 2030, garantizar el '
          'acceso universal a servicios '
          'energeticos asequibles, fiables '
          'y modernos',
    ),
    SdgTarget(
      code: '7.2',
      description: 'By 2030, increase substantially '
          'the share of renewable energy in '
          'the global energy mix',
      descriptionJa: '2030年までに、世界のエネルギーミックスにおける再生可能エネルギーの割合を大幅に拡大させる',
      descriptionEs: 'De aqui a 2030, aumentar '
          'considerablemente la proporcion '
          'de energia renovable en el '
          'conjunto de fuentes energeticas',
    ),
    SdgTarget(
      code: '7.3',
      description:
          'By 2030, double the global rate of improvement in energy efficiency',
      descriptionJa: '2030年までに、世界全体のエネルギー効率の改善率を倍増させる',
      descriptionEs: 'De aqui a 2030, duplicar la tasa '
          'mundial de mejora de la '
          'eficiencia energetica',
    ),
    SdgTarget(
      code: '7.a',
      description: 'By 2030, enhance international '
          'cooperation to facilitate access '
          'to clean energy research and '
          'technology, including renewable '
          'energy, energy efficiency and '
          'advanced and cleaner fossil-fuel '
          'technology, and promote '
          'investment in energy '
          'infrastructure and clean energy '
          'technology',
      descriptionJa:
          '2030年までに、再生可能エネルギー、エネルギー効率及び先進的かつ環境負荷の低い化石燃料技術などのクリーンエネルギーの研究及び技術へのアクセスを促進するための国際協力を強化し、エネルギー関連インフラとクリーンエネルギー技術への投資を促進する',
      descriptionEs: 'De aqui a 2030, aumentar la '
          'cooperacion internacional para '
          'facilitar el acceso a la '
          'investigacion y la tecnologia '
          'relativas a la energia limpia, '
          'incluidas las fuentes '
          'renovables, la eficiencia '
          'energetica y las tecnologias '
          'avanzadas y menos contaminantes '
          'de combustibles fosiles, y '
          'promover la inversion en '
          'infraestructura energetica y '
          'tecnologias limpias',
    ),
    SdgTarget(
      code: '7.b',
      description: 'By 2030, expand infrastructure '
          'and upgrade technology for '
          'supplying modern and sustainable '
          'energy services for all in '
          'developing countries, in '
          'particular least developed '
          'countries, small island '
          'developing States and landlocked '
          'developing countries',
      descriptionJa:
          '2030年までに、各々の支援プログラムに沿って開発途上国、特に後発開発途上国及び小島嶼開発途上国、内陸開発途上国のすべての人々に現代的で持続可能なエネルギーサービスを供給できるよう、インフラ拡大と技術向上を行う',
      descriptionEs: 'De aqui a 2030, ampliar la '
          'infraestructura y mejorar la '
          'tecnologia para prestar '
          'servicios energeticos modernos y '
          'sostenibles para todos en los '
          'paises en desarrollo, en '
          'particular los paises menos '
          'adelantados, los pequenos '
          'Estados insulares en desarrollo '
          'y los paises en desarrollo sin '
          'litoral',
    ),
  ],
  8: [
    SdgTarget(
      code: '8.1',
      description: 'Sustain per capita economic '
          'growth in accordance with '
          'national circumstances and, in '
          'particular, at least 7 per cent '
          'gross domestic product growth '
          'per annum in the least developed '
          'countries',
      descriptionJa: '各国の状況に応じて、一人当たり経済成長率を持続させる。特に後発開発途上国は少なくとも年率7%の成長率を保つ',
      descriptionEs: 'Mantener el crecimiento '
          'economico per capita de '
          'conformidad con las '
          'circunstancias nacionales y, en '
          'particular, un crecimiento del '
          'producto interno bruto de al '
          'menos el 7% anual en los paises '
          'menos adelantados',
    ),
    SdgTarget(
      code: '8.2',
      description: 'Achieve higher levels of '
          'economic productivity through '
          'diversification, technological '
          'upgrading and innovation, '
          'including through a focus on '
          'high value added and '
          'labour-intensive sectors',
      descriptionJa:
          '高付加価値セクターや労働集約型セクターに重点を置くことなどにより、多様化、技術向上及びイノベーションを通じた高いレベルの経済生産性を達成する',
      descriptionEs: 'Lograr niveles mas elevados de '
          'productividad economica mediante '
          'la diversificacion, la '
          'modernizacion tecnologica y la '
          'innovacion, entre otras cosas '
          'centrando la atencion en los '
          'sectores con gran valor anadido '
          'y un uso intensivo de la mano de '
          'obra',
    ),
    SdgTarget(
      code: '8.3',
      description: 'Promote development-oriented '
          'policies that support productive '
          'activities, decent job creation, '
          'entrepreneurship, creativity and '
          'innovation, and encourage the '
          'formalization and growth of '
          'micro-, small- and medium-sized '
          'enterprises, including through '
          'access to financial services',
      descriptionJa:
          '生産活動や適切な雇用創出、起業、創造性及びイノベーションを支援する開発重視型の政策を促進するとともに、金融サービスへのアクセス改善などを通じて中小零細企業の設立や成長を奨励する',
      descriptionEs: 'Promover politicas orientadas al '
          'desarrollo que apoyen las '
          'actividades productivas, la '
          'creacion de puestos de trabajo '
          'decentes, el emprendimiento, la '
          'creatividad y la innovacion, y '
          'fomentar la formalizacion y el '
          'crecimiento de las microempresas '
          'y las pequenas y medianas '
          'empresas, incluso mediante el '
          'acceso a servicios financieros',
    ),
    SdgTarget(
      code: '8.4',
      description: 'Improve progressively, through '
          '2030, global resource efficiency '
          'in consumption and production '
          'and endeavour to decouple '
          'economic growth from '
          'environmental degradation',
      descriptionJa:
          '2030年までに、世界の消費と生産における資源効率を漸進的に改善させ、先進国主導の下、持続可能な消費と生産に関する10年計画枠組みに従い、経済成長と環境悪化の分断を図る',
      descriptionEs: 'Mejorar progresivamente, de aqui '
          'a 2030, la produccion y el '
          'consumo eficientes de los '
          'recursos mundiales y procurar '
          'desvincular el crecimiento '
          'economico de la degradacion del '
          'medio ambiente',
    ),
    SdgTarget(
      code: '8.5',
      description: 'By 2030, achieve full and '
          'productive employment and decent '
          'work for all women and men, '
          'including for young people and '
          'persons with disabilities, and '
          'equal pay for work of equal '
          'value',
      descriptionJa:
          '2030年までに、若者や障害者を含むすべての男性及び女性の、完全かつ生産的な雇用及び働きがいのある人間らしい仕事、ならびに同一労働同一賃金を達成する',
      descriptionEs: 'De aqui a 2030, lograr el empleo '
          'pleno y productivo y el trabajo '
          'decente para todas las mujeres y '
          'los hombres, incluidos los '
          'jovenes y las personas con '
          'discapacidad, asi como la '
          'igualdad de remuneracion por '
          'trabajo de igual valor',
    ),
    SdgTarget(
      code: '8.6',
      description: 'By 2020, substantially reduce '
          'the proportion of youth not in '
          'employment, education or '
          'training',
      descriptionJa: '2020年までに、就労、就学及び職業訓練のいずれも行っていない若者の割合を大幅に減らす',
      descriptionEs: 'De aqui a 2020, reducir '
          'considerablemente la proporcion '
          'de jovenes que no estan '
          'empleados y no cursan estudios '
          'ni reciben capacitacion',
    ),
    SdgTarget(
      code: '8.7',
      description: 'Take immediate and effective '
          'measures to eradicate forced '
          'labour, end modern slavery and '
          'human trafficking and secure the '
          'prohibition and elimination of '
          'the worst forms of child labour, '
          'including recruitment and use of '
          'child soldiers, and by 2025 end '
          'child labour in all its forms',
      descriptionJa:
          '強制労働を根絶し、現代の奴隷制、人身売買を終わらせるための緊急かつ効果的な措置の実施、最悪な形態の児童労働の禁止及び撲滅を確保する。2025年までに児童兵士の募集と使用を含むあらゆる形態の児童労働を撲滅する',
      descriptionEs: 'Adoptar medidas inmediatas y '
          'eficaces para erradicar el '
          'trabajo forzoso, poner fin a las '
          'formas contemporaneas de '
          'esclavitud y la trata de '
          'personas y asegurar la '
          'prohibicion y eliminacion de las '
          'peores formas de trabajo '
          'infantil, incluidos el '
          'reclutamiento y la utilizacion '
          'de ninos soldados, y, de aqui a '
          '2025, poner fin al trabajo '
          'infantil en todas sus formas',
    ),
    SdgTarget(
      code: '8.8',
      description: 'Protect labour rights and '
          'promote safe and secure working '
          'environments for all workers, '
          'including migrant workers, in '
          'particular women migrants, and '
          'those in precarious employment',
      descriptionJa:
          '移住労働者、特に女性の移住労働者や不安定な雇用状態にある労働者など、すべての労働者の権利を保護し、安全・安心な労働環境を促進する',
      descriptionEs: 'Proteger los derechos laborales '
          'y promover un entorno de trabajo '
          'seguro y sin riesgos para todos '
          'los trabajadores, incluidos los '
          'trabajadores migrantes, en '
          'particular las mujeres migrantes '
          'y las personas con empleos '
          'precarios',
    ),
    SdgTarget(
      code: '8.9',
      description: 'By 2030, devise and implement '
          'policies to promote sustainable '
          'tourism that creates jobs and '
          'promotes local culture and '
          'products',
      descriptionJa:
          '2030年までに、雇用創出、地方の文化振興・産品販促につながる持続可能な観光業を促進するための政策を立案し実施する',
      descriptionEs: 'De aqui a 2030, elaborar y poner '
          'en practica politicas '
          'encaminadas a promover un '
          'turismo sostenible que cree '
          'puestos de trabajo y promueva la '
          'cultura y los productos locales',
    ),
    SdgTarget(
      code: '8.10',
      description: 'Strengthen the capacity of '
          'domestic financial institutions '
          'to encourage and expand access '
          'to banking, insurance and '
          'financial services for all',
      descriptionJa:
          'すべての人々のための銀行取引、保険及び金融サービスへのアクセスを促進・拡大するため、国内の金融機関の能力を強化する',
      descriptionEs: 'Fortalecer la capacidad de las '
          'instituciones financieras '
          'nacionales para fomentar y '
          'ampliar el acceso a los '
          'servicios bancarios, financieros '
          'y de seguros para todos',
    ),
    SdgTarget(
      code: '8.a',
      description: 'Increase Aid for Trade support '
          'for developing countries, in '
          'particular least developed '
          'countries, including through the '
          'Enhanced Integrated Framework '
          'for Trade-related Technical '
          'Assistance to Least Developed '
          'Countries',
      descriptionJa:
          '後発開発途上国への貿易関連技術支援のための拡大統合フレームワーク（EIF）などを通じた支援を含む、開発途上国、特に後発開発途上国に対する貿易のための援助を拡大する',
      descriptionEs: 'Aumentar el apoyo a la '
          'iniciativa de ayuda para el '
          'comercio en los paises en '
          'desarrollo, en particular los '
          'paises menos adelantados, '
          'incluso mediante el Marco '
          'Integrado Mejorado para la '
          'Asistencia Tecnica a los Paises '
          'Menos Adelantados en Materia de '
          'Comercio',
    ),
    SdgTarget(
      code: '8.b',
      description: 'By 2020, develop and '
          'operationalize a global strategy '
          'for youth employment and '
          'implement the Global Jobs Pact '
          'of the International Labour '
          'Organization',
      descriptionJa: '2020年までに、若年雇用のための世界的戦略及び国際労働機関の仕事に関する世界協定の実施を展開・運用化する',
      descriptionEs: 'De aqui a 2020, desarrollar y '
          'poner en marcha una estrategia '
          'mundial para el empleo de los '
          'jovenes y aplicar el Pacto '
          'Mundial para el Empleo de la '
          'Organizacion Internacional del '
          'Trabajo',
    ),
  ],
  9: [
    SdgTarget(
      code: '9.1',
      description: 'Develop quality, reliable, '
          'sustainable and resilient '
          'infrastructure, including '
          'regional and transborder '
          'infrastructure, to support '
          'economic development and human '
          'well-being, with a focus on '
          'affordable and equitable access '
          'for all',
      descriptionJa:
          'すべての人々に安価で公平なアクセスに重点を置いた経済発展と人間の福祉を支援するために、地域・越境インフラを含む質の高い、信頼でき、持続可能かつ強靱なインフラを開発する',
      descriptionEs: 'Desarrollar infraestructuras '
          'fiables, sostenibles, '
          'resilientes y de calidad, '
          'incluidas infraestructuras '
          'regionales y transfronterizas, '
          'para apoyar el desarrollo '
          'economico y el bienestar humano, '
          'haciendo especial hincapie en el '
          'acceso asequible y equitativo '
          'para todos',
    ),
    SdgTarget(
      code: '9.2',
      description: 'Promote inclusive and '
          'sustainable industrialization '
          'and, by 2030, significantly '
          "raise industry's share of "
          'employment and gross domestic '
          'product, in line with national '
          'circumstances, and double its '
          'share in least developed '
          'countries',
      descriptionJa:
          '包摂的かつ持続可能な産業化を促進し、2030年までに各国の状況に応じて雇用及びGDPに占める産業セクターの割合を大幅に増加させる。後発開発途上国については同割合を倍増させる',
      descriptionEs: 'Promover una industrializacion '
          'inclusiva y sostenible y, de '
          'aqui a 2030, aumentar '
          'significativamente la '
          'contribucion de la industria al '
          'empleo y al producto interno '
          'bruto, de acuerdo con las '
          'circunstancias nacionales, y '
          'duplicar esa contribucion en los '
          'paises menos adelantados',
    ),
    SdgTarget(
      code: '9.3',
      description: 'Increase the access of '
          'small-scale industrial and other '
          'enterprises, in particular in '
          'developing countries, to '
          'financial services, including '
          'affordable credit, and their '
          'integration into value chains '
          'and markets',
      descriptionJa:
          '特に開発途上国における小規模の製造業その他の企業の、安価な資金貸出などの金融サービスやバリューチェーン及び市場への統合へのアクセスを拡大する',
      descriptionEs: 'Aumentar el acceso de las '
          'pequenas industrias y otras '
          'empresas, particularmente en los '
          'paises en desarrollo, a los '
          'servicios financieros, incluidos '
          'creditos asequibles, y su '
          'integracion en las cadenas de '
          'valor y los mercados',
    ),
    SdgTarget(
      code: '9.4',
      description: 'By 2030, upgrade infrastructure '
          'and retrofit industries to make '
          'them sustainable, with increased '
          'resource-use efficiency and '
          'greater adoption of clean and '
          'environmentally sound '
          'technologies and industrial '
          'processes, with all countries '
          'taking action in accordance with '
          'their respective capabilities',
      descriptionJa:
          '2030年までに、資源利用効率の向上とクリーン技術及び環境に配慮した技術・産業プロセスの導入拡大を通じたインフラ改良や産業改善により、持続可能性を向上させる。すべての国々は各国の能力に応じた取組を行う',
      descriptionEs: 'De aqui a 2030, modernizar la '
          'infraestructura y reconvertir '
          'las industrias para que sean '
          'sostenibles, utilizando los '
          'recursos con mayor eficacia y '
          'promoviendo la adopcion de '
          'tecnologias y procesos '
          'industriales limpios y '
          'ambientalmente racionales, y '
          'logrando que todos los paises '
          'tomen medidas de acuerdo con sus '
          'capacidades respectivas',
    ),
    SdgTarget(
      code: '9.5',
      description: 'Enhance scientific research, '
          'upgrade the technological '
          'capabilities of industrial '
          'sectors in all countries, in '
          'particular developing countries, '
          'including, by 2030, encouraging '
          'innovation and substantially '
          'increasing the number of '
          'research and development workers '
          'per 1 million people',
      descriptionJa:
          '2030年までにイノベーションを促進させることや100万人当たりの研究開発従事者数を大幅に増加させ、また官民研究開発の支出を拡大させるなど、開発途上国をはじめとするすべての国々の産業セクターにおける科学研究を促進し、技術能力を向上させる',
      descriptionEs: 'Aumentar la investigacion '
          'cientifica y mejorar la '
          'capacidad tecnologica de los '
          'sectores industriales de todos '
          'los paises, en particular los '
          'paises en desarrollo, entre '
          'otras cosas fomentando la '
          'innovacion y aumentando '
          'considerablemente, de aqui a '
          '2030, el numero de personas que '
          'trabajan en investigacion y '
          'desarrollo por millon de '
          'habitantes',
    ),
    SdgTarget(
      code: '9.a',
      description: 'Facilitate sustainable and '
          'resilient infrastructure '
          'development in developing '
          'countries through enhanced '
          'financial, technological and '
          'technical support to African '
          'countries, least developed '
          'countries, landlocked developing '
          'countries and small island '
          'developing States',
      descriptionJa:
          'アフリカ諸国、後発開発途上国、内陸開発途上国及び小島嶼開発途上国への金融・テクノロジー・技術的支援の強化を通じて、開発途上国における持続可能かつ強靱なインフラ開発を促進する',
      descriptionEs: 'Facilitar el desarrollo de '
          'infraestructuras sostenibles y '
          'resilientes en los paises en '
          'desarrollo mediante un mayor '
          'apoyo financiero, tecnologico y '
          'tecnico a los paises africanos, '
          'los paises menos adelantados, '
          'los paises en desarrollo sin '
          'litoral y los pequenos Estados '
          'insulares en desarrollo',
    ),
    SdgTarget(
      code: '9.b',
      description: 'Support domestic technology '
          'development, research and '
          'innovation in developing '
          'countries, including by ensuring '
          'a conducive policy environment '
          'for, inter alia, industrial '
          'diversification and value '
          'addition to commodities',
      descriptionJa:
          '産業の多様化や商品への付加価値創造などに資する政策環境の確保などを通じて、開発途上国の国内における技術開発、研究及びイノベーションを支援する',
      descriptionEs: 'Apoyar el desarrollo de '
          'tecnologias, la investigacion y '
          'la innovacion nacionales en los '
          'paises en desarrollo, incluso '
          'garantizando un entorno '
          'normativo propicio a la '
          'diversificacion industrial y la '
          'adicion de valor a los productos '
          'basicos, entre otras cosas',
    ),
    SdgTarget(
      code: '9.c',
      description: 'Significantly increase access to '
          'information and communications '
          'technology and strive to provide '
          'universal and affordable access '
          'to the Internet in least '
          'developed countries by 2020',
      descriptionJa:
          '後発開発途上国において情報通信技術へのアクセスを大幅に向上させ、2020年までに普遍的かつ安価なインターネット・アクセスを提供できるよう図る',
      descriptionEs: 'Aumentar significativamente el '
          'acceso a la tecnologia de la '
          'informacion y las comunicaciones '
          'y esforzarse por proporcionar '
          'acceso universal y asequible a '
          'Internet en los paises menos '
          'adelantados de aqui a 2020',
    ),
  ],
  10: [
    SdgTarget(
      code: '10.1',
      description: 'By 2030, progressively achieve '
          'and sustain income growth of the '
          'bottom 40 per cent of the '
          'population at a rate higher than '
          'the national average',
      descriptionJa: '2030年までに、各国の所得下位40%の所得成長率について、国内平均を上回る数値を漸進的に達成し、持続させる',
      descriptionEs: 'De aqui a 2030, lograr '
          'progresivamente y mantener el '
          'crecimiento de los ingresos del '
          '40% mas pobre de la poblacion a '
          'una tasa superior a la media '
          'nacional',
    ),
    SdgTarget(
      code: '10.2',
      description: 'By 2030, empower and promote the '
          'social, economic and political '
          'inclusion of all, irrespective '
          'of age, sex, disability, race, '
          'ethnicity, origin, religion or '
          'economic or other status',
      descriptionJa:
          '2030年までに、年齢、性別、障害、人種、民族、出自、宗教、あるいは経済的地位その他の状況に関わりなく、すべての人々の能力強化及び社会的、経済的及び政治的な包含を促進する',
      descriptionEs: 'De aqui a 2030, potenciar y '
          'promover la inclusion social, '
          'economica y politica de todas '
          'las personas, independientemente '
          'de su edad, sexo, discapacidad, '
          'raza, etnia, origen, religion o '
          'situacion economica u otra '
          'condicion',
    ),
    SdgTarget(
      code: '10.3',
      description: 'Ensure equal opportunity and '
          'reduce inequalities of outcome, '
          'including by eliminating '
          'discriminatory laws, policies '
          'and practices and promoting '
          'appropriate legislation, '
          'policies and action in this '
          'regard',
      descriptionJa:
          '差別的な法律、政策及び慣行の撤廃、ならびに適切な関連法規、政策、行動の促進などを通じて、機会均等を確保し、成果の不平等を是正する',
      descriptionEs: 'Garantizar la igualdad de '
          'oportunidades y reducir la '
          'desigualdad de resultados, '
          'incluso eliminando las leyes, '
          'politicas y practicas '
          'discriminatorias y promoviendo '
          'legislaciones, politicas y '
          'medidas adecuadas a ese respecto',
    ),
    SdgTarget(
      code: '10.4',
      description: 'Adopt policies, especially '
          'fiscal, wage and social '
          'protection policies, and '
          'progressively achieve greater '
          'equality',
      descriptionJa: '税制、賃金、社会保障政策をはじめとする政策を導入し、平等の拡大を漸進的に達成する',
      descriptionEs: 'Adoptar politicas, especialmente '
          'fiscales, salariales y de '
          'proteccion social, y lograr '
          'progresivamente una mayor '
          'igualdad',
    ),
    SdgTarget(
      code: '10.5',
      description: 'Improve the regulation and '
          'monitoring of global financial '
          'markets and institutions and '
          'strengthen the implementation of '
          'such regulations',
      descriptionJa: '世界金融市場と金融機関に対する規制とモニタリングを改善し、こうした規制の実施を強化する',
      descriptionEs: 'Mejorar la reglamentacion y '
          'vigilancia de las instituciones '
          'y los mercados financieros '
          'mundiales y fortalecer la '
          'aplicacion de esos reglamentos',
    ),
    SdgTarget(
      code: '10.6',
      description: 'Ensure enhanced representation '
          'and voice for developing '
          'countries in decision-making in '
          'global international economic '
          'and financial institutions in '
          'order to deliver more effective, '
          'credible, accountable and '
          'legitimate institutions',
      descriptionJa:
          'より効果的で信用力があり、説明責任のある正当な制度を実現するため、地球規模の国際経済・金融制度の意思決定における開発途上国の参加や発言力を拡大する',
      descriptionEs: 'Asegurar una mayor '
          'representacion e intervencion de '
          'los paises en desarrollo en las '
          'decisiones adoptadas por las '
          'instituciones economicas y '
          'financieras internacionales para '
          'aumentar la eficacia, '
          'fiabilidad, rendicion de cuentas '
          'y legitimidad de esas '
          'instituciones',
    ),
    SdgTarget(
      code: '10.7',
      description: 'Facilitate orderly, safe, '
          'regular and responsible '
          'migration and mobility of '
          'people, including through the '
          'implementation of planned and '
          'well-managed migration policies',
      descriptionJa: '計画に基づく適正な移住政策の実施などを通じて、秩序のとれた、安全で規則的かつ責任ある移住や流動性を促進する',
      descriptionEs: 'Facilitar la migracion y la '
          'movilidad ordenadas, seguras, '
          'regulares y responsables de las '
          'personas, incluso mediante la '
          'aplicacion de politicas '
          'migratorias planificadas y bien '
          'gestionadas',
    ),
    SdgTarget(
      code: '10.a',
      description: 'Implement the principle of '
          'special and differential '
          'treatment for developing '
          'countries, in particular least '
          'developed countries, in '
          'accordance with World Trade '
          'Organization agreements',
      descriptionJa: '世界貿易機関協定に従い、開発途上国、特に後発開発途上国に対する特別かつ異なる待遇の原則を実施する',
      descriptionEs: 'Aplicar el principio del trato '
          'especial y diferenciado para los '
          'paises en desarrollo, en '
          'particular los paises menos '
          'adelantados, de conformidad con '
          'los acuerdos de la Organizacion '
          'Mundial del Comercio',
    ),
    SdgTarget(
      code: '10.b',
      description: 'Encourage official development '
          'assistance and financial flows, '
          'including foreign direct '
          'investment, to States where the '
          'need is greatest, in particular '
          'least developed countries, '
          'African countries, small island '
          'developing States and landlocked '
          'developing countries, in '
          'accordance with their national '
          'plans and programmes',
      descriptionJa:
          '各国の国家計画やプログラムに従って、後発開発途上国、アフリカ諸国、小島嶼開発途上国及び内陸開発途上国を始めとする、ニーズが最も大きい国々への、政府開発援助及び海外直接投資を含む資金の流入を促進する',
      descriptionEs: 'Fomentar la asistencia oficial '
          'para el desarrollo y las '
          'corrientes financieras, incluida '
          'la inversion extranjera directa, '
          'para los Estados con mayores '
          'necesidades, en particular los '
          'paises menos adelantados, los '
          'paises africanos, los pequenos '
          'Estados insulares en desarrollo '
          'y los paises en desarrollo sin '
          'litoral, en consonancia con sus '
          'planes y programas nacionales',
    ),
    SdgTarget(
      code: '10.c',
      description: 'By 2030, reduce to less than 3 '
          'per cent the transaction costs '
          'of migrant remittances and '
          'eliminate remittance corridors '
          'with costs higher than 5 per '
          'cent',
      descriptionJa: '2030年までに、移住労働者による送金コストを3%未満に引き下げ、コストが5%を超える送金経路を撤廃する',
      descriptionEs: 'De aqui a 2030, reducir a menos '
          'del 3% los costos de transaccion '
          'de las remesas de los migrantes '
          'y eliminar los corredores de '
          'remesas con un costo superior al '
          '5%',
    ),
  ],
  11: [
    SdgTarget(
      code: '11.1',
      description: 'By 2030, ensure access for all '
          'to adequate, safe and affordable '
          'housing and basic services and '
          'upgrade slums',
      descriptionJa:
          '2030年までに、すべての人々の、適切、安全かつ安価な住宅及び基本的サービスへのアクセスを確保し、スラムを改善する',
      descriptionEs: 'De aqui a 2030, asegurar el '
          'acceso de todas las personas a '
          'viviendas y servicios basicos '
          'adecuados, seguros y asequibles '
          'y mejorar los barrios marginales',
    ),
    SdgTarget(
      code: '11.2',
      description: 'By 2030, provide access to safe, '
          'affordable, accessible and '
          'sustainable transport systems '
          'for all, improving road safety, '
          'notably by expanding public '
          'transport, with special '
          'attention to the needs of those '
          'in vulnerable situations, women, '
          'children, persons with '
          'disabilities and older persons',
      descriptionJa:
          '2030年までに、脆弱な立場にある人々、女性、子ども、障害者及び高齢者のニーズに特に配慮し、公共交通機関の拡大などを通じた交通の安全性改善により、すべての人々に、安全かつ安価で容易に利用できる、持続可能な輸送システムへのアクセスを提供する',
      descriptionEs: 'De aqui a 2030, proporcionar '
          'acceso a sistemas de transporte '
          'seguros, asequibles, accesibles '
          'y sostenibles para todos y '
          'mejorar la seguridad vial, en '
          'particular mediante la '
          'ampliacion del transporte '
          'publico, prestando especial '
          'atencion a las necesidades de '
          'las personas en situacion de '
          'vulnerabilidad, las mujeres, los '
          'ninos, las personas con '
          'discapacidad y las personas de '
          'edad',
    ),
    SdgTarget(
      code: '11.3',
      description: 'By 2030, enhance inclusive and '
          'sustainable urbanization and '
          'capacity for participatory, '
          'integrated and sustainable human '
          'settlement planning and '
          'management in all countries',
      descriptionJa:
          '2030年までに、包摂的かつ持続可能な都市化を促進し、すべての国々の参加型、包摂的かつ持続可能な人間居住計画・管理の能力を強化する',
      descriptionEs: 'De aqui a 2030, aumentar la '
          'urbanizacion inclusiva y '
          'sostenible y la capacidad para '
          'la planificacion y la gestion '
          'participativas, integradas y '
          'sostenibles de los asentamientos '
          'humanos en todos los paises',
    ),
    SdgTarget(
      code: '11.4',
      description: 'Strengthen efforts to protect '
          "and safeguard the world's "
          'cultural and natural heritage',
      descriptionJa: '世界の文化遺産及び自然遺産の保護・保全の努力を強化する',
      descriptionEs: 'Redoblar los esfuerzos para '
          'proteger y salvaguardar el '
          'patrimonio cultural y natural '
          'del mundo',
    ),
    SdgTarget(
      code: '11.5',
      description: 'By 2030, significantly reduce '
          'the number of deaths and the '
          'number of people affected and '
          'substantially decrease the '
          'direct economic losses relative '
          'to global gross domestic product '
          'caused by disasters, including '
          'water-related disasters, with a '
          'focus on protecting the poor and '
          'people in vulnerable situations',
      descriptionJa:
          '2030年までに、貧困層及び脆弱な立場にある人々の保護に焦点をあてながら、水関連災害などの災害による死者や被災者数を大幅に削減し、世界の国内総生産比で直接的経済損失を大幅に減らす',
      descriptionEs: 'De aqui a 2030, reducir '
          'significativamente el numero de '
          'muertes causadas por los '
          'desastres, incluidos los '
          'relacionados con el agua, y de '
          'personas afectadas por ellos, y '
          'reducir considerablemente las '
          'perdidas economicas directas '
          'provocadas por los desastres en '
          'comparacion con el producto '
          'interno bruto mundial, haciendo '
          'especial hincapie en la '
          'proteccion de los pobres y las '
          'personas en situaciones de '
          'vulnerabilidad',
    ),
    SdgTarget(
      code: '11.6',
      description: 'By 2030, reduce the adverse per '
          'capita environmental impact of '
          'cities, including by paying '
          'special attention to air quality '
          'and municipal and other waste '
          'management',
      descriptionJa:
          '2030年までに、大気の質及び一般並びにその他の廃棄物の管理に特別な注意を払うことによるものを含め、都市の一人当たりの環境上の悪影響を軽減する',
      descriptionEs: 'De aqui a 2030, reducir el '
          'impacto ambiental negativo per '
          'capita de las ciudades, incluso '
          'prestando especial atencion a la '
          'calidad del aire y la gestion de '
          'los desechos municipales y de '
          'otro tipo',
    ),
    SdgTarget(
      code: '11.7',
      description: 'By 2030, provide universal '
          'access to safe, inclusive and '
          'accessible, green and public '
          'spaces, in particular for women '
          'and children, older persons and '
          'persons with disabilities',
      descriptionJa:
          '2030年までに、女性、子ども、高齢者及び障害者を含め、人々に安全で包摂的かつ利用が容易な緑地や公共スペースへの普遍的アクセスを提供する',
      descriptionEs: 'De aqui a 2030, proporcionar '
          'acceso universal a zonas verdes '
          'y espacios publicos seguros, '
          'inclusivos y accesibles, en '
          'particular para las mujeres y '
          'los ninos, las personas de edad '
          'y las personas con discapacidad',
    ),
    SdgTarget(
      code: '11.a',
      description: 'Support positive economic, '
          'social and environmental links '
          'between urban, peri-urban and '
          'rural areas by strengthening '
          'national and regional '
          'development planning',
      descriptionJa:
          '各国・地域規模の開発計画の強化を通じて、経済、社会、環境面における都市部、都市周辺部及び農村部間の良好なつながりを支援する',
      descriptionEs: 'Apoyar los vinculos economicos, '
          'sociales y ambientales positivos '
          'entre las zonas urbanas, '
          'periurbanas y rurales '
          'fortaleciendo la planificacion '
          'del desarrollo nacional y '
          'regional',
    ),
    SdgTarget(
      code: '11.b',
      description: 'By 2020, substantially increase '
          'the number of cities and human '
          'settlements adopting and '
          'implementing integrated policies '
          'and plans towards inclusion, '
          'resource efficiency, mitigation '
          'and adaptation to climate '
          'change, resilience to disasters',
      descriptionJa:
          '2020年までに、包含、資源効率、気候変動の緩和と適応、災害に対する強靱さを目指す総合的政策及び計画を導入・実施した都市及び人間居住地の件数を大幅に増加させる',
      descriptionEs: 'De aqui a 2020, aumentar '
          'considerablemente el numero de '
          'ciudades y asentamientos humanos '
          'que adoptan e implementan '
          'politicas y planes integrados '
          'para promover la inclusion, el '
          'uso eficiente de los recursos, '
          'la mitigacion del cambio '
          'climatico y la adaptacion a el y '
          'la resiliencia ante los '
          'desastres',
    ),
    SdgTarget(
      code: '11.c',
      description: 'Support least developed '
          'countries, including through '
          'financial and technical '
          'assistance, in building '
          'sustainable and resilient '
          'buildings utilizing local '
          'materials',
      descriptionJa:
          '財政的及び技術的な支援などを通じて、後発開発途上国における現地の資材を用いた、持続可能かつ強靱な建造物の整備を支援する',
      descriptionEs: 'Proporcionar apoyo a los paises '
          'menos adelantados, incluso '
          'mediante asistencia financiera y '
          'tecnica, para que puedan '
          'construir edificios sostenibles '
          'y resilientes utilizando '
          'materiales locales',
    ),
  ],
  12: [
    SdgTarget(
      code: '12.1',
      description: 'Implement the 10-Year Framework '
          'of Programmes on Sustainable '
          'Consumption and Production '
          'Patterns, all countries taking '
          'action, with developed countries '
          'taking the lead',
      descriptionJa:
          '開発途上国の開発状況や能力を勘案しつつ、持続可能な消費と生産に関する10年計画枠組みを実施し、先進国主導の下、すべての国々が対策を講じる',
      descriptionEs: 'Aplicar el Marco Decenal de '
          'Programas sobre Modalidades de '
          'Consumo y Produccion '
          'Sostenibles, con la '
          'participacion de todos los '
          'paises y bajo el liderazgo de '
          'los paises desarrollados',
    ),
    SdgTarget(
      code: '12.2',
      description: 'By 2030, achieve the sustainable '
          'management and efficient use of '
          'natural resources',
      descriptionJa: '2030年までに天然資源の持続可能な管理及び効率的な利用を達成する',
      descriptionEs: 'De aqui a 2030, lograr la '
          'gestion sostenible y el uso '
          'eficiente de los recursos '
          'naturales',
    ),
    SdgTarget(
      code: '12.3',
      description: 'By 2030, halve per capita global '
          'food waste at the retail and '
          'consumer levels and reduce food '
          'losses along production and '
          'supply chains, including '
          'post-harvest losses',
      descriptionJa:
          '2030年までに小売・消費レベルにおける世界全体の一人当たりの食料の廃棄を半減させ、収穫後損失などの生産・サプライチェーンにおける食品ロスを減少させる',
      descriptionEs: 'De aqui a 2030, reducir a la '
          'mitad el desperdicio de '
          'alimentos per capita mundial en '
          'la venta al por menor y a nivel '
          'de los consumidores y reducir '
          'las perdidas de alimentos en las '
          'cadenas de produccion y '
          'suministro, incluidas las '
          'perdidas posteriores a la '
          'cosecha',
    ),
    SdgTarget(
      code: '12.4',
      description: 'By 2020, achieve the '
          'environmentally sound management '
          'of chemicals and all wastes '
          'throughout their life cycle, in '
          'accordance with agreed '
          'international frameworks, and '
          'significantly reduce their '
          'release to air, water and soil '
          'in order to minimize their '
          'adverse impacts on human health '
          'and the environment',
      descriptionJa:
          '2020年までに、合意された国際的な枠組みに従い、製品ライフサイクルを通じ、環境上適正な化学物質やすべての廃棄物の管理を実現し、人の健康や環境への悪影響を最小化するため、化学物質や廃棄物の大気、水、土壌への放出を大幅に削減する',
      descriptionEs: 'De aqui a 2020, lograr la '
          'gestion ecologicamente racional '
          'de los productos quimicos y de '
          'todos los desechos a lo largo de '
          'su ciclo de vida, de conformidad '
          'con los marcos internacionales '
          'convenidos, y reducir '
          'significativamente su liberacion '
          'a la atmosfera, el agua y el '
          'suelo a fin de minimizar sus '
          'efectos adversos en la salud '
          'humana y el medio ambiente',
    ),
    SdgTarget(
      code: '12.5',
      description: 'By 2030, substantially reduce '
          'waste generation through '
          'prevention, reduction, recycling '
          'and reuse',
      descriptionJa: '2030年までに、廃棄物の発生防止、削減、再生利用及び再利用により、廃棄物の発生を大幅に削減する',
      descriptionEs: 'De aqui a 2030, reducir '
          'considerablemente la generacion '
          'de desechos mediante actividades '
          'de prevencion, reduccion, '
          'reciclado y reutilizacion',
    ),
    SdgTarget(
      code: '12.6',
      description: 'Encourage companies, especially '
          'large and transnational '
          'companies, to adopt sustainable '
          'practices and to integrate '
          'sustainability information into '
          'their reporting cycle',
      descriptionJa:
          '特に大企業や多国籍企業などの企業に対し、持続可能な取り組みを導入し、持続可能性に関する情報を定期報告に盛り込むよう奨励する',
      descriptionEs: 'Alentar a las empresas, en '
          'especial las grandes empresas y '
          'las empresas transnacionales, a '
          'que adopten practicas '
          'sostenibles e incorporen '
          'informacion sobre la '
          'sostenibilidad en su ciclo de '
          'presentacion de informes',
    ),
    SdgTarget(
      code: '12.7',
      description: 'Promote public procurement '
          'practices that are sustainable, '
          'in accordance with national '
          'policies and priorities',
      descriptionJa: '国内の政策や優先事項に従って持続可能な公共調達の慣行を促進する',
      descriptionEs: 'Promover practicas de '
          'adquisicion publica que sean '
          'sostenibles, de conformidad con '
          'las politicas y prioridades '
          'nacionales',
    ),
    SdgTarget(
      code: '12.8',
      description: 'By 2030, ensure that people '
          'everywhere have the relevant '
          'information and awareness for '
          'sustainable development and '
          'lifestyles in harmony with '
          'nature',
      descriptionJa:
          '2030年までに、人々があらゆる場所において、持続可能な開発及び自然と調和したライフスタイルに関する情報と意識を持つようにする',
      descriptionEs: 'De aqui a 2030, asegurar que las '
          'personas de todo el mundo tengan '
          'la informacion y los '
          'conocimientos pertinentes para '
          'el desarrollo sostenible y los '
          'estilos de vida en armonia con '
          'la naturaleza',
    ),
    SdgTarget(
      code: '12.a',
      description: 'Support developing countries to '
          'strengthen their scientific and '
          'technological capacity to move '
          'towards more sustainable '
          'patterns of consumption and '
          'production',
      descriptionJa: '開発途上国に対し、より持続可能な消費・生産形態の促進のための科学的・技術的能力の強化を支援する',
      descriptionEs: 'Ayudar a los paises en '
          'desarrollo a fortalecer su '
          'capacidad cientifica y '
          'tecnologica para avanzar hacia '
          'modalidades de consumo y '
          'produccion mas sostenibles',
    ),
    SdgTarget(
      code: '12.b',
      description: 'Develop and implement tools to '
          'monitor sustainable development '
          'impacts for sustainable tourism '
          'that creates jobs and promotes '
          'local culture and products',
      descriptionJa:
          '雇用創出、地方の文化振興・産品販促につながる持続可能な観光業に対して持続可能な開発がもたらす影響を測定する手法を開発・導入する',
      descriptionEs: 'Elaborar y aplicar instrumentos '
          'para vigilar los efectos en el '
          'desarrollo sostenible, a fin de '
          'lograr un turismo sostenible que '
          'cree puestos de trabajo y '
          'promueva la cultura y los '
          'productos locales',
    ),
    SdgTarget(
      code: '12.c',
      description: 'Rationalize inefficient '
          'fossil-fuel subsidies that '
          'encourage wasteful consumption '
          'by removing market distortions, '
          'in accordance with national '
          'circumstances, including by '
          'restructuring taxation and '
          'phasing out those harmful '
          'subsidies, where they exist, to '
          'reflect their environmental '
          'impacts',
      descriptionJa:
          '開発途上国の特別なニーズや状況を十分考慮し、貧困層やコミュニティを保護する形で開発に関する悪影響を最小限に留めつつ、税制改正や、有害な補助金が存在する場合はその環境への影響を考慮してその段階的廃止などを通じ、各国の状況に応じて、市場のひずみを除去することで、浪費的な消費を奨励する非効率な化石燃料補助金を合理化する',
      descriptionEs: 'Racionalizar los subsidios '
          'ineficientes a los combustibles '
          'fosiles que fomentan el consumo '
          'antieconimico eliminando las '
          'distorsiones del mercado, de '
          'acuerdo con las circunstancias '
          'nacionales, incluso mediante la '
          'reestructuracion de los sistemas '
          'tributarios y la eliminacion '
          'gradual de los subsidios '
          'perjudiciales, cuando existan, '
          'para reflejar su impacto '
          'ambiental',
    ),
  ],
  13: [
    SdgTarget(
      code: '13.1',
      description: 'Strengthen resilience and '
          'adaptive capacity to '
          'climate-related hazards and '
          'natural disasters in all '
          'countries',
      descriptionJa: 'すべての国々において、気候関連災害や自然災害に対する強靱性及び適応の能力を強化する',
      descriptionEs: 'Fortalecer la resiliencia y la '
          'capacidad de adaptacion a los '
          'riesgos relacionados con el '
          'clima y los desastres naturales '
          'en todos los paises',
    ),
    SdgTarget(
      code: '13.2',
      description: 'Integrate climate change '
          'measures into national policies, '
          'strategies and planning',
      descriptionJa: '気候変動対策を国別の政策、戦略及び計画に盛り込む',
      descriptionEs: 'Incorporar medidas relativas al '
          'cambio climatico en las '
          'politicas, estrategias y planes '
          'nacionales',
    ),
    SdgTarget(
      code: '13.3',
      description: 'Improve education, '
          'awareness-raising and human and '
          'institutional capacity on '
          'climate change mitigation, '
          'adaptation, impact reduction and '
          'early warning',
      descriptionJa: '気候変動の緩和、適応、影響軽減及び早期警戒に関する教育、啓発、人的能力及び制度機能を改善する',
      descriptionEs: 'Mejorar la educacion, la '
          'sensibilizacion y la capacidad '
          'humana e institucional respecto '
          'de la mitigacion del cambio '
          'climatico, la adaptacion a el, '
          'la reduccion de sus efectos y la '
          'alerta temprana',
    ),
    SdgTarget(
      code: '13.a',
      description: 'Implement the commitment '
          'undertaken by developed-country '
          'parties to the United Nations '
          'Framework Convention on Climate '
          'Change to a goal of mobilizing '
          r'jointly $100 billion annually by '
          '2020 from all sources to address '
          'the needs of developing '
          'countries in the context of '
          'meaningful mitigation actions '
          'and transparency on '
          'implementation',
      descriptionJa:
          '重要な緩和行動の実施とその実施における透明性確保に関する開発途上国のニーズに対応するため、2020年までにあらゆる供給源から年間1,000億ドルを共同で動員するという、UNFCCCの先進締約国によるコミットメントを実施する',
      descriptionEs: 'Cumplir el compromiso de los '
          'paises desarrollados que son '
          'partes en la Convencion Marco de '
          'las Naciones Unidas sobre el '
          'Cambio Climatico de lograr para '
          'el ano 2020 el objetivo de '
          'movilizar conjuntamente 100.000 '
          'millones de dolares anuales '
          'procedentes de todas las fuentes '
          'a fin de atender las necesidades '
          'de los paises en desarrollo',
    ),
    SdgTarget(
      code: '13.b',
      description: 'Promote mechanisms for raising '
          'capacity for effective climate '
          'change-related planning and '
          'management in least developed '
          'countries and small island '
          'developing States, including '
          'focusing on women, youth and '
          'local and marginalized '
          'communities',
      descriptionJa:
          '後発開発途上国及び小島嶼開発途上国において、女性や青年、地方及び社会的に疎外されたコミュニティに焦点を当てることを含め、気候変動関連の効果的な計画策定と管理のための能力を向上するメカニズムを推進する',
      descriptionEs: 'Promover mecanismos para '
          'aumentar la capacidad para la '
          'planificacion y gestion eficaces '
          'en relacion con el cambio '
          'climatico en los paises menos '
          'adelantados y los pequenos '
          'Estados insulares en desarrollo, '
          'haciendo particular hincapie en '
          'las mujeres, los jovenes y las '
          'comunidades locales y marginadas',
    ),
  ],
  14: [
    SdgTarget(
      code: '14.1',
      description: 'By 2025, prevent and '
          'significantly reduce marine '
          'pollution of all kinds, in '
          'particular from land-based '
          'activities, including marine '
          'debris and nutrient pollution',
      descriptionJa:
          '2025年までに、海洋ごみや富栄養化を含む、特に陸上活動による汚染など、あらゆる種類の海洋汚染を防止し、大幅に削減する',
      descriptionEs: 'De aqui a 2025, prevenir y '
          'reducir significativamente la '
          'contaminacion marina de todo '
          'tipo, en particular la producida '
          'por actividades realizadas en '
          'tierra, incluidos los detritos '
          'marinos y la polucion por '
          'nutrientes',
    ),
    SdgTarget(
      code: '14.2',
      description: 'By 2020, sustainably manage and '
          'protect marine and coastal '
          'ecosystems to avoid significant '
          'adverse impacts, including by '
          'strengthening their resilience, '
          'and take action for their '
          'restoration in order to achieve '
          'healthy and productive oceans',
      descriptionJa:
          '2020年までに、海洋及び沿岸の生態系に関する重大な悪影響を回避するため、強靱性の強化などによる持続的な管理と保護を行い、健全で生産的な海洋を実現するため、海洋及び沿岸の生態系の回復のための取組を行う',
      descriptionEs: 'De aqui a 2020, gestionar y '
          'proteger sosteniblemente los '
          'ecosistemas marinos y costeros '
          'para evitar efectos adversos '
          'importantes, incluso '
          'fortaleciendo su resiliencia, y '
          'adoptar medidas para '
          'restaurarlos a fin de '
          'restablecer la salud y la '
          'productividad de los oceanos',
    ),
    SdgTarget(
      code: '14.3',
      description: 'Minimize and address the impacts '
          'of ocean acidification, '
          'including through enhanced '
          'scientific cooperation at all '
          'levels',
      descriptionJa: 'あらゆるレベルでの科学的協力の促進などを通じて、海洋酸性化の影響を最小限化し、対処する',
      descriptionEs: 'Minimizar y abordar los efectos '
          'de la acidificacion de los '
          'oceanos, incluso mediante una '
          'mayor cooperacion cientifica a '
          'todos los niveles',
    ),
    SdgTarget(
      code: '14.4',
      description: 'By 2020, effectively regulate '
          'harvesting and end overfishing, '
          'illegal, unreported and '
          'unregulated fishing and '
          'destructive fishing practices '
          'and implement science-based '
          'management plans, in order to '
          'restore fish stocks in the '
          'shortest time feasible',
      descriptionJa:
          '水産資源を、実現可能な最短期間で少なくとも各資源の生物学的特性によって定められる最大持続生産量のレベルまで回復させるため、2020年までに、漁獲を効果的に規制し、過剰漁業や違法・無報告・無規制漁業及び破壊的な漁業慣行を終了し、科学的な管理計画を実施する',
      descriptionEs: 'De aqui a 2020, reglamentar '
          'eficazmente la explotacion '
          'pesquera y poner fin a la pesca '
          'excesiva, la pesca ilegal, no '
          'declarada y no reglamentada y '
          'las practicas pesqueras '
          'destructivas, y aplicar planes '
          'de gestion con fundamento '
          'cientifico a fin de restablecer '
          'las poblaciones de peces en el '
          'plazo mas breve posible',
    ),
    SdgTarget(
      code: '14.5',
      description: 'By 2020, conserve at least 10 '
          'per cent of coastal and marine '
          'areas, consistent with national '
          'and international law and based '
          'on the best available scientific '
          'information',
      descriptionJa:
          '2020年までに、国内法及び国際法に則り、最大限入手可能な科学情報に基づいて、少なくとも沿岸域及び海域の10パーセントを保全する',
      descriptionEs: 'De aqui a 2020, conservar al '
          'menos el 10% de las zonas '
          'costeras y marinas, de '
          'conformidad con las leyes '
          'nacionales y el derecho '
          'internacional y sobre la base de '
          'la mejor informacion cientifica '
          'disponible',
    ),
    SdgTarget(
      code: '14.6',
      description: 'By 2020, prohibit certain forms '
          'of fisheries subsidies which '
          'contribute to overcapacity and '
          'overfishing, eliminate subsidies '
          'that contribute to illegal, '
          'unreported and unregulated '
          'fishing and refrain from '
          'introducing new such subsidies',
      descriptionJa:
          '開発途上国及び後発開発途上国に対する適切かつ効果的な特別かつ異なる待遇が、世界貿易機関の漁業補助金交渉の不可分の要素であるべきことを認識した上で、2020年までに、過剰漁獲能力や過剰漁獲につながる漁業補助金を禁止し、違法・無報告・無規制漁業につながる補助金を撤廃し、同様の新たな補助金の導入を抑制する',
      descriptionEs: 'De aqui a 2020, prohibir ciertas '
          'formas de subvenciones a la '
          'pesca que contribuyen a la '
          'sobrecapacidad y la pesca '
          'excesiva, eliminar las '
          'subvenciones que contribuyen a '
          'la pesca ilegal, no declarada y '
          'no reglamentada y abstenerse de '
          'introducir nuevas subvenciones '
          'de esa indole',
    ),
    SdgTarget(
      code: '14.7',
      description: 'By 2030, increase the economic '
          'benefits to Small Island '
          'Developing States and least '
          'developed countries from the '
          'sustainable use of marine '
          'resources, including through '
          'sustainable management of '
          'fisheries, aquaculture and '
          'tourism',
      descriptionJa:
          '2030年までに、漁業、水産養殖及び観光の持続可能な管理などを通じ、小島嶼開発途上国及び後発開発途上国の海洋資源の持続的な利用による経済的便益を増大させる',
      descriptionEs: 'De aqui a 2030, aumentar los '
          'beneficios economicos que los '
          'pequenos Estados insulares en '
          'desarrollo y los paises menos '
          'adelantados obtienen del uso '
          'sostenible de los recursos '
          'marinos, en particular mediante '
          'la gestion sostenible de la '
          'pesca, la acuicultura y el '
          'turismo',
    ),
    SdgTarget(
      code: '14.a',
      description: 'Increase scientific knowledge, '
          'develop research capacity and '
          'transfer marine technology in '
          'order to improve ocean health '
          'and to enhance the contribution '
          'of marine biodiversity to the '
          'development of developing '
          'countries',
      descriptionJa:
          '海洋の健全性の改善と、開発途上国、特に小島嶼開発途上国および後発開発途上国の開発における海洋生物多様性の寄与向上のために、科学的知識の増進、研究能力の向上、及び海洋技術の移転を行う',
      descriptionEs: 'Aumentar los conocimientos '
          'cientificos, desarrollar la '
          'capacidad de investigacion y '
          'transferir tecnologia marina a '
          'fin de mejorar la salud de los '
          'oceanos y potenciar la '
          'contribucion de la biodiversidad '
          'marina al desarrollo de los '
          'paises en desarrollo',
    ),
    SdgTarget(
      code: '14.b',
      description: 'Provide access for small-scale '
          'artisanal fishers to marine '
          'resources and markets',
      descriptionJa: '小規模・沿岸零細漁業者に対し、海洋資源及び市場へのアクセスを提供する',
      descriptionEs: 'Facilitar el acceso de los '
          'pescadores artesanales a los '
          'recursos marinos y los mercados',
    ),
    SdgTarget(
      code: '14.c',
      description: 'Enhance the conservation and '
          'sustainable use of oceans and '
          'their resources by implementing '
          'international law as reflected '
          'in the United Nations Convention '
          'on the Law of the Sea',
      descriptionJa:
          '「我々の求める未来」のパラ158において想起されるとおり、海洋及び海洋資源の保全及び持続可能な利用のための法的枠組みを規定する海洋法に関する国際連合条約に反映されている国際法を実施することにより、海洋及び海洋資源の保全及び持続可能な利用を強化する',
      descriptionEs: 'Mejorar la conservacion y el uso '
          'sostenible de los oceanos y sus '
          'recursos aplicando el derecho '
          'internacional reflejado en la '
          'Convencion de las Naciones '
          'Unidas sobre el Derecho del Mar',
    ),
  ],
  15: [
    SdgTarget(
      code: '15.1',
      description: 'By 2020, ensure the '
          'conservation, restoration and '
          'sustainable use of terrestrial '
          'and inland freshwater ecosystems '
          'and their services, in '
          'particular forests, wetlands, '
          'mountains and drylands, in line '
          'with obligations under '
          'international agreements',
      descriptionJa:
          '2020年までに、国際協定の下での義務に則って、森林、湿地、山地及び乾燥地をはじめとする陸域生態系と内陸淡水生態系及びそれらのサービスの保全、回復及び持続可能な利用を確保する',
      descriptionEs: 'De aqui a 2020, asegurar la '
          'conservacion, el '
          'restablecimiento y el uso '
          'sostenible de los ecosistemas '
          'terrestres y los ecosistemas '
          'interiores de agua dulce y sus '
          'servicios, en particular los '
          'bosques, los humedales, las '
          'montanas y las zonas aridas, en '
          'consonancia con las obligaciones '
          'contraidas en virtud de acuerdos '
          'internacionales',
    ),
    SdgTarget(
      code: '15.2',
      description: 'By 2020, promote the '
          'implementation of sustainable '
          'management of all types of '
          'forests, halt deforestation, '
          'restore degraded forests and '
          'substantially increase '
          'afforestation and reforestation '
          'globally',
      descriptionJa:
          '2020年までに、あらゆる種類の森林の持続可能な経営の実施を促進し、森林減少を阻止し、劣化した森林を回復し、世界全体で新規植林及び再植林を大幅に増加させる',
      descriptionEs: 'De aqui a 2020, promover la '
          'puesta en practica de la gestion '
          'sostenible de todos los tipos de '
          'bosques, detener la '
          'deforestacion, recuperar los '
          'bosques degradados y aumentar '
          'considerablemente la forestacion '
          'y la reforestacion en todo el '
          'mundo',
    ),
    SdgTarget(
      code: '15.3',
      description: 'By 2030, combat desertification, '
          'restore degraded land and soil, '
          'including land affected by '
          'desertification, drought and '
          'floods, and strive to achieve a '
          'land degradation-neutral world',
      descriptionJa:
          '2030年までに、砂漠化に対処し、砂漠化、干ばつ及び洪水の影響を受けた土地などの劣化した土地と土壌を回復し、土地劣化に荷担しない世界の達成に尽力する',
      descriptionEs: 'De aqui a 2030, luchar contra la '
          'desertificacion, rehabilitar las '
          'tierras y los suelos degradados, '
          'incluidas las tierras afectadas '
          'por la desertificacion, la '
          'sequia y las inundaciones, y '
          'procurar lograr un mundo con '
          'efecto neutro en la degradacion '
          'del suelo',
    ),
    SdgTarget(
      code: '15.4',
      description: 'By 2030, ensure the conservation '
          'of mountain ecosystems, '
          'including their biodiversity, in '
          'order to enhance their capacity '
          'to provide benefits that are '
          'essential for sustainable '
          'development',
      descriptionJa:
          '2030年までに持続可能な開発に不可欠な便益をもたらす山地生態系の能力を強化するため、生物多様性を含む山地生態系の保全を確実に行う',
      descriptionEs: 'De aqui a 2030, asegurar la '
          'conservacion de los ecosistemas '
          'montanosos, incluida su '
          'diversidad biologica, a fin de '
          'mejorar su capacidad de '
          'proporcionar beneficios '
          'esenciales para el desarrollo '
          'sostenible',
    ),
    SdgTarget(
      code: '15.5',
      description: 'Take urgent and significant '
          'action to reduce the degradation '
          'of natural habitats, halt the '
          'loss of biodiversity and, by '
          '2020, protect and prevent the '
          'extinction of threatened species',
      descriptionJa:
          '自然生息地の劣化を抑制し、生物多様性の損失を阻止し、2020年までに絶滅危惧種を保護し、また絶滅防止するための緊急かつ意味のある対策を講じる',
      descriptionEs: 'Adoptar medidas urgentes y '
          'significativas para reducir la '
          'degradacion de los habitats '
          'naturales, detener la perdida de '
          'biodiversidad y, de aqui a 2020, '
          'proteger las especies amenazadas '
          'y evitar su extincion',
    ),
    SdgTarget(
      code: '15.6',
      description: 'Promote fair and equitable '
          'sharing of the benefits arising '
          'from the utilization of genetic '
          'resources and promote '
          'appropriate access to such '
          'resources, as internationally '
          'agreed',
      descriptionJa:
          '国際合意に基づき、遺伝資源の利用から生ずる利益の公正かつ衡平な配分を推進するとともに、遺伝資源への適切なアクセスを推進する',
      descriptionEs: 'Promover la participacion justa '
          'y equitativa en los beneficios '
          'derivados de la utilizacion de '
          'los recursos geneticos y '
          'promover el acceso adecuado a '
          'esos recursos, segun lo '
          'convenido internacionalmente',
    ),
    SdgTarget(
      code: '15.7',
      description: 'Take urgent action to end '
          'poaching and trafficking of '
          'protected species of flora and '
          'fauna and address both demand '
          'and supply of illegal wildlife '
          'products',
      descriptionJa:
          '保護の対象となっている動植物種の密猟及び違法取引を撲滅するための緊急対策を講じるとともに、違法な野生生物製品の需要と供給の両面に対処する',
      descriptionEs: 'Adoptar medidas urgentes para '
          'poner fin a la caza furtiva y el '
          'trafico de especies protegidas '
          'de flora y fauna y abordar tanto '
          'la demanda como la oferta de '
          'productos ilegales de flora y '
          'fauna silvestres',
    ),
    SdgTarget(
      code: '15.8',
      description: 'By 2020, introduce measures to '
          'prevent the introduction and '
          'significantly reduce the impact '
          'of invasive alien species on '
          'land and water ecosystems and '
          'control or eradicate the '
          'priority species',
      descriptionJa:
          '2020年までに、外来種の侵入を防止するとともに、これらの種による陸域・海洋生態系への影響を大幅に減少させるための対策を導入し、さらに優先種の駆除または根絶を行う',
      descriptionEs: 'De aqui a 2020, adoptar medidas '
          'para prevenir la introduccion de '
          'especies exoticas invasoras y '
          'reducir significativamente sus '
          'efectos en los ecosistemas '
          'terrestres y acuaticos y '
          'controlar o erradicar las '
          'especies prioritarias',
    ),
    SdgTarget(
      code: '15.9',
      description: 'By 2020, integrate ecosystem and '
          'biodiversity values into '
          'national and local planning, '
          'development processes, poverty '
          'reduction strategies and '
          'accounts',
      descriptionJa:
          '2020年までに、生態系と生物多様性の価値を、国や地方の計画策定、開発プロセス及び貧困削減のための戦略及び会計に組み込む',
      descriptionEs: 'De aqui a 2020, integrar los '
          'valores de los ecosistemas y la '
          'biodiversidad en la '
          'planificacion, los procesos de '
          'desarrollo, las estrategias de '
          'reduccion de la pobreza y la '
          'contabilidad nacionales y '
          'locales',
    ),
    SdgTarget(
      code: '15.a',
      description: 'Mobilize and significantly '
          'increase financial resources '
          'from all sources to conserve and '
          'sustainably use biodiversity and '
          'ecosystems',
      descriptionJa: '生物多様性と生態系の保全と持続的な利用のために、あらゆる資金源からの資金の動員及び大幅な増額を行う',
      descriptionEs: 'Movilizar y aumentar '
          'significativamente los recursos '
          'financieros procedentes de todas '
          'las fuentes para conservar y '
          'utilizar de forma sostenible la '
          'biodiversidad y los ecosistemas',
    ),
    SdgTarget(
      code: '15.b',
      description: 'Mobilize significant resources '
          'from all sources and at all '
          'levels to finance sustainable '
          'forest management and provide '
          'adequate incentives to '
          'developing countries to advance '
          'such management, including for '
          'conservation and reforestation',
      descriptionJa:
          '保全や再植林を含む持続可能な森林経営を推進するため、あらゆるレベルのあらゆる供給源から、持続可能な森林経営のための資金の調達と開発途上国への十分なインセンティブ付与のための相当量の資源を動員する',
      descriptionEs: 'Movilizar recursos considerables '
          'de todas las fuentes y a todos '
          'los niveles para financiar la '
          'gestion forestal sostenible y '
          'proporcionar incentivos '
          'adecuados a los paises en '
          'desarrollo para que promuevan '
          'dicha gestion, en particular con '
          'miras a la conservacion y la '
          'reforestacion',
    ),
    SdgTarget(
      code: '15.c',
      description: 'Enhance global support for '
          'efforts to combat poaching and '
          'trafficking of protected '
          'species, including by increasing '
          'the capacity of local '
          'communities to pursue '
          'sustainable livelihood '
          'opportunities',
      descriptionJa:
          '持続的な生計機会を追求するために地域コミュニティの能力向上を図る等、保護種の密猟及び違法な取引に対処するための努力に対する世界的な支援を強化する',
      descriptionEs: 'Aumentar el apoyo mundial a la '
          'lucha contra la caza furtiva y '
          'el trafico de especies '
          'protegidas, incluso aumentando '
          'la capacidad de las comunidades '
          'locales para perseguir '
          'oportunidades de subsistencia '
          'sostenibles',
    ),
  ],
  16: [
    SdgTarget(
      code: '16.1',
      description: 'Significantly reduce all forms '
          'of violence and related death '
          'rates everywhere',
      descriptionJa: 'あらゆる場所において、すべての形態の暴力及び暴力に関連する死亡率を大幅に減少させる',
      descriptionEs: 'Reducir significativamente todas '
          'las formas de violencia y las '
          'correspondientes tasas de '
          'mortalidad en todo el mundo',
    ),
    SdgTarget(
      code: '16.2',
      description: 'End abuse, exploitation, '
          'trafficking and all forms of '
          'violence against and torture of '
          'children',
      descriptionJa: '子どもに対する虐待、搾取、取引及びあらゆる形態の暴力及び拷問を撲滅する',
      descriptionEs: 'Poner fin al maltrato, la '
          'explotacion, la trata y todas '
          'las formas de violencia y '
          'tortura contra los ninos',
    ),
    SdgTarget(
      code: '16.3',
      description: 'Promote the rule of law at the '
          'national and international '
          'levels and ensure equal access '
          'to justice for all',
      descriptionJa: '国家及び国際的なレベルでの法の支配を促進し、すべての人々に司法への平等なアクセスを提供する',
      descriptionEs: 'Promover el estado de derecho en '
          'los planos nacional e '
          'internacional y garantizar la '
          'igualdad de acceso a la justicia '
          'para todos',
    ),
    SdgTarget(
      code: '16.4',
      description: 'By 2030, significantly reduce '
          'illicit financial and arms '
          'flows, strengthen the recovery '
          'and return of stolen assets and '
          'combat all forms of organized '
          'crime',
      descriptionJa:
          '2030年までに、違法な資金及び武器の取引を大幅に減少させ、奪われた財産の回復及び返還を強化し、あらゆる形態の組織犯罪を根絶する',
      descriptionEs: 'De aqui a 2030, reducir '
          'significativamente las '
          'corrientes financieras y de '
          'armas ilicitas, fortalecer la '
          'recuperacion y devolucion de los '
          'activos robados y luchar contra '
          'todas las formas de delincuencia '
          'organizada',
    ),
    SdgTarget(
      code: '16.5',
      description:
          'Substantially reduce corruption and bribery in all their forms',
      descriptionJa: 'あらゆる形態の汚職や贈賄を大幅に減少させる',
      descriptionEs:
          'Reducir considerablemente la corrupcion y el soborno en todas sus formas',
    ),
    SdgTarget(
      code: '16.6',
      description:
          'Develop effective, accountable and transparent institutions at all levels',
      descriptionJa: 'あらゆるレベルにおいて、有効で説明責任のある透明性の高い公共機関を発展させる',
      descriptionEs: 'Crear a todos los niveles '
          'instituciones eficaces y '
          'transparentes que rindan cuentas',
    ),
    SdgTarget(
      code: '16.7',
      description: 'Ensure responsive, inclusive, '
          'participatory and representative '
          'decision-making at all levels',
      descriptionJa: 'あらゆるレベルにおいて、対応的、包摂的、参加型及び代表的な意思決定を確保する',
      descriptionEs: 'Garantizar la adopcion en todos '
          'los niveles de decisiones '
          'inclusivas, participativas y '
          'representativas que respondan a '
          'las necesidades',
    ),
    SdgTarget(
      code: '16.8',
      description: 'Broaden and strengthen the '
          'participation of developing '
          'countries in the institutions of '
          'global governance',
      descriptionJa: 'グローバル・ガバナンス機関への開発途上国の参加を拡大・強化する',
      descriptionEs: 'Ampliar y fortalecer la '
          'participacion de los paises en '
          'desarrollo en las instituciones '
          'de gobernanza mundial',
    ),
    SdgTarget(
      code: '16.9',
      description:
          'By 2030, provide legal identity for all, including birth registration',
      descriptionJa: '2030年までに、すべての人々に出生登録を含む法的な身分証明を提供する',
      descriptionEs: 'De aqui a 2030, proporcionar '
          'acceso a una identidad juridica '
          'para todos, en particular '
          'mediante el registro de '
          'nacimientos',
    ),
    SdgTarget(
      code: '16.10',
      description: 'Ensure public access to '
          'information and protect '
          'fundamental freedoms, in '
          'accordance with national '
          'legislation and international '
          'agreements',
      descriptionJa: '国内法規及び国際協定に従い、情報への公共アクセスを確保し、基本的自由を保障する',
      descriptionEs: 'Garantizar el acceso publico a '
          'la informacion y proteger las '
          'libertades fundamentales, de '
          'conformidad con las leyes '
          'nacionales y los acuerdos '
          'internacionales',
    ),
    SdgTarget(
      code: '16.a',
      description: 'Strengthen relevant national '
          'institutions, including through '
          'international cooperation, for '
          'building capacity at all levels, '
          'in particular in developing '
          'countries, to prevent violence '
          'and combat terrorism and crime',
      descriptionJa:
          '特に開発途上国において、暴力の防止とテロリズム・犯罪の撲滅に関するあらゆるレベルでの能力構築のため、国際協力などを通じて関連国家機関を強化する',
      descriptionEs: 'Fortalecer las instituciones '
          'nacionales pertinentes, incluso '
          'mediante la cooperacion '
          'internacional, para crear a '
          'todos los niveles, '
          'particularmente en los paises en '
          'desarrollo, la capacidad de '
          'prevenir la violencia y combatir '
          'el terrorismo y la delincuencia',
    ),
    SdgTarget(
      code: '16.b',
      description: 'Promote and enforce '
          'non-discriminatory laws and '
          'policies for sustainable '
          'development',
      descriptionJa: '持続可能な開発のための非差別的な法規及び政策を推進し、実施する',
      descriptionEs: 'Promover y aplicar leyes y '
          'politicas no discriminatorias en '
          'favor del desarrollo sostenible',
    ),
  ],
  17: [
    SdgTarget(
      code: '17.1',
      description: 'Strengthen domestic resource '
          'mobilization, including through '
          'international support to '
          'developing countries, to improve '
          'domestic capacity for tax and '
          'other revenue collection',
      descriptionJa: '課税及び徴税能力の向上のため、開発途上国への国際的な支援なども通じて、国内資源の動員を強化する',
      descriptionEs: 'Fortalecer la movilizacion de '
          'recursos internos, incluso '
          'mediante la prestacion de apoyo '
          'internacional a los paises en '
          'desarrollo, con el fin de '
          'mejorar la capacidad nacional '
          'para recaudar ingresos fiscales '
          'y de otra indole',
    ),
    SdgTarget(
      code: '17.2',
      description: 'Developed countries to implement '
          'fully their official development '
          'assistance commitments, '
          'including the commitment by many '
          'developed countries to achieve '
          'the target of 0.7 per cent of '
          'gross national income for '
          'official development assistance '
          'to developing countries',
      descriptionJa:
          '先進国は、開発途上国に対するODAをGNI比0.7%に、後発開発途上国に対するODAをGNI比0.15~0.20%にするという目標を達成するとの多くの国によるコミットメントを含むODAに係るコミットメントを完全に実施する',
      descriptionEs: 'Velar por que los paises '
          'desarrollados cumplan plenamente '
          'sus compromisos en relacion con '
          'la asistencia oficial para el '
          'desarrollo, incluido el '
          'compromiso de numerosos paises '
          'desarrollados de alcanzar el '
          'objetivo de destinar el 0,7% del '
          'ingreso nacional bruto a la '
          'asistencia oficial para el '
          'desarrollo de los paises en '
          'desarrollo',
    ),
    SdgTarget(
      code: '17.3',
      description: 'Mobilize additional financial '
          'resources for developing '
          'countries from multiple sources',
      descriptionJa: '複数の財源から、開発途上国のための追加的資金源を動員する',
      descriptionEs: 'Movilizar recursos financieros '
          'adicionales de multiples fuentes '
          'para los paises en desarrollo',
    ),
    SdgTarget(
      code: '17.4',
      description: 'Assist developing countries in '
          'attaining long-term debt '
          'sustainability through '
          'coordinated policies aimed at '
          'fostering debt financing, debt '
          'relief and debt restructuring, '
          'as appropriate',
      descriptionJa:
          '必要に応じた負債による資金調達、債務救済及び債務再編の促進を目的とした協調的な政策により、開発途上国の長期的な債務の持続可能性の実現を支援し、重債務貧困国の対外債務への対応により債務リスクを軽減する',
      descriptionEs: 'Ayudar a los paises en '
          'desarrollo a lograr la '
          'sostenibilidad de la deuda a '
          'largo plazo con politicas '
          'coordinadas orientadas a '
          'fomentar la financiacion, el '
          'alivio y la reestructuracion de '
          'la deuda, segun proceda, y hacer '
          'frente a la deuda externa de los '
          'paises pobres muy endeudados a '
          'fin de reducir el endeudamiento '
          'excesivo',
    ),
    SdgTarget(
      code: '17.5',
      description: 'Adopt and implement investment '
          'promotion regimes for least '
          'developed countries',
      descriptionJa: '後発開発途上国のための投資促進枠組みを導入及び実施する',
      descriptionEs: 'Adoptar y aplicar sistemas de '
          'promocion de las inversiones en '
          'favor de los paises menos '
          'adelantados',
    ),
    SdgTarget(
      code: '17.6',
      description: 'Enhance North-South, South-South '
          'and triangular regional and '
          'international cooperation on and '
          'access to science, technology '
          'and innovation and enhance '
          'knowledge-sharing on mutually '
          'agreed terms',
      descriptionJa:
          '科学技術イノベーションに関する南北協力、南南協力及び地域的・国際的な三角協力へのアクセスを向上させ、また、相互に合意した条件で知識共有を進める',
      descriptionEs: 'Mejorar la cooperacion regional '
          'e internacional Norte-Sur, '
          'Sur-Sur y triangular en materia '
          'de ciencia, tecnologia e '
          'innovacion y el acceso a estas, '
          'y aumentar el intercambio de '
          'conocimientos en condiciones '
          'mutuamente convenidas',
    ),
    SdgTarget(
      code: '17.7',
      description: 'Promote the development, '
          'transfer, dissemination and '
          'diffusion of environmentally '
          'sound technologies to developing '
          'countries on favourable terms, '
          'including on concessional and '
          'preferential terms, as mutually '
          'agreed',
      descriptionJa:
          '開発途上国に対し、譲許的・特恵的条件などの相互に合意した有利な条件の下で、環境に配慮した技術の開発、移転、普及及び拡散を促進する',
      descriptionEs: 'Promover el desarrollo de '
          'tecnologias ecologicamente '
          'racionales y su transferencia, '
          'divulgacion y difusion a los '
          'paises en desarrollo en '
          'condiciones favorables, incluso '
          'en condiciones concesionarias y '
          'preferenciales, segun lo '
          'convenido de mutuo acuerdo',
    ),
    SdgTarget(
      code: '17.8',
      description: 'Fully operationalize the '
          'technology bank and science, '
          'technology and innovation '
          'capacity-building mechanism for '
          'least developed countries by '
          '2017 and enhance the use of '
          'enabling technology, in '
          'particular information and '
          'communications technology',
      descriptionJa:
          '2017年までに、後発開発途上国のための技術バンク及び科学技術イノベーション能力構築メカニズムを完全運用させ、情報通信技術をはじめとする実現技術の利用を強化する',
      descriptionEs: 'Poner en pleno funcionamiento, a '
          'mas tardar en 2017, el banco de '
          'tecnologia y el mecanismo de '
          'apoyo a la creacion de capacidad '
          'en materia de ciencia, '
          'tecnologia e innovacion para los '
          'paises menos adelantados y '
          'aumentar la utilizacion de '
          'tecnologias instrumentales, en '
          'particular la tecnologia de la '
          'informacion y las comunicaciones',
    ),
    SdgTarget(
      code: '17.9',
      description: 'Enhance international support '
          'for implementing effective and '
          'targeted capacity-building in '
          'developing countries to support '
          'national plans to implement all '
          'the Sustainable Development '
          'Goals',
      descriptionJa:
          'すべての持続可能な開発目標を実施するための国家計画を支援するべく、南北協力、南南協力及び三角協力などを通じて、開発途上国における効果的かつ的をしぼった能力構築の実施に対する国際的な支援を強化する',
      descriptionEs: 'Aumentar el apoyo internacional '
          'para realizar actividades de '
          'creacion de capacidad eficaces y '
          'especificas en los paises en '
          'desarrollo a fin de respaldar '
          'los planes nacionales de '
          'implementacion de todos los '
          'Objetivos de Desarrollo '
          'Sostenible',
    ),
    SdgTarget(
      code: '17.10',
      description: 'Promote a universal, '
          'rules-based, open, '
          'non-discriminatory and equitable '
          'multilateral trading system '
          'under the World Trade '
          'Organization, including through '
          'the conclusion of negotiations '
          'under its Doha Development '
          'Agenda',
      descriptionJa:
          'ドーハ・ラウンド交渉の受結などを通じ、世界貿易機関の下での普遍的でルールに基づいた、差別的でない、公平な多角的貿易体制を促進する',
      descriptionEs: 'Promover un sistema de comercio '
          'multilateral universal, basado '
          'en normas, abierto, no '
          'discriminatorio y equitativo en '
          'el marco de la Organizacion '
          'Mundial del Comercio, incluso '
          'mediante la conclusion de las '
          'negociaciones en el marco del '
          'Programa de Doha para el '
          'Desarrollo',
    ),
    SdgTarget(
      code: '17.11',
      description: 'Significantly increase the '
          'exports of developing countries, '
          'in particular with a view to '
          'doubling the least developed '
          "countries' share of global "
          'exports by 2020',
      descriptionJa: '開発途上国による輸出を大幅に増加させ、特に2020年までに世界の輸出に占める後発開発途上国のシェアを倍増させる',
      descriptionEs: 'Aumentar significativamente las '
          'exportaciones de los paises en '
          'desarrollo, en particular con '
          'miras a duplicar la '
          'participacion de los paises '
          'menos adelantados en las '
          'exportaciones mundiales de aqui '
          'a 2020',
    ),
    SdgTarget(
      code: '17.12',
      description: 'Realize timely implementation of '
          'duty-free and quota-free market '
          'access on a lasting basis for '
          'all least developed countries, '
          'consistent with World Trade '
          'Organization decisions',
      descriptionJa:
          '後発開発途上国からの輸入に対する特恵的な原産地規則が透明で簡略的かつ市場アクセスの円滑化に寄与するものとなるようにすることを含む世界貿易機関の決定に矛盾しない形で、すべての後発開発途上国に対し、永続的な無税・無枠の市場アクセスを適時実施する',
      descriptionEs: 'Lograr la consecucion oportuna '
          'del acceso a los mercados libre '
          'de derechos y contingentes de '
          'manera duradera para todos los '
          'paises menos adelantados, '
          'conforme a las decisiones de la '
          'Organizacion Mundial del '
          'Comercio',
    ),
    SdgTarget(
      code: '17.13',
      description: 'Enhance global macroeconomic '
          'stability, including through '
          'policy coordination and policy '
          'coherence',
      descriptionJa: '政策協調や政策の首尾一貫性などを通じて、世界的なマクロ経済の安定を促進する',
      descriptionEs: 'Aumentar la estabilidad '
          'macroeconomica mundial, incluso '
          'mediante la coordinacion y '
          'coherencia de las politicas',
    ),
    SdgTarget(
      code: '17.14',
      description: 'Enhance policy coherence for sustainable development',
      descriptionJa: '持続可能な開発のための政策の一貫性を強化する',
      descriptionEs:
          'Mejorar la coherencia de las politicas para el desarrollo sostenible',
    ),
    SdgTarget(
      code: '17.15',
      description: "Respect each country's policy "
          'space and leadership to '
          'establish and implement policies '
          'for poverty eradication and '
          'sustainable development',
      descriptionJa: '貧困撲滅と持続可能な開発のための政策の確立・実施にあたっては、各国の政策空間及びリーダーシップを尊重する',
      descriptionEs: 'Respetar el margen normativo y '
          'el liderazgo de cada pais para '
          'establecer y aplicar politicas '
          'de erradicacion de la pobreza y '
          'desarrollo sostenible',
    ),
    SdgTarget(
      code: '17.16',
      description: 'Enhance the Global Partnership '
          'for Sustainable Development, '
          'complemented by '
          'multi-stakeholder partnerships '
          'that mobilize and share '
          'knowledge, expertise, technology '
          'and financial resources, to '
          'support the achievement of the '
          'Sustainable Development Goals in '
          'all countries',
      descriptionJa:
          'すべての国々、特に開発途上国での持続可能な開発目標の達成を支援すべく、知識、専門的知見、技術及び資金源を動員、共有するマルチステークホルダー・パートナーシップによって補完しつつ、持続可能な開発のためのグローバル・パートナーシップを強化する',
      descriptionEs: 'Mejorar la Alianza Mundial para '
          'el Desarrollo Sostenible, '
          'complementada por alianzas entre '
          'multiples interesados que '
          'movilicen e intercambien '
          'conocimientos, especializacion, '
          'tecnologia y recursos '
          'financieros, a fin de apoyar el '
          'logro de los Objetivos de '
          'Desarrollo Sostenible en todos '
          'los paises',
    ),
    SdgTarget(
      code: '17.17',
      description: 'Encourage and promote effective '
          'public, public-private and civil '
          'society partnerships, building '
          'on the experience and resourcing '
          'strategies of partnerships',
      descriptionJa:
          'さまざまなパートナーシップの経験や資源戦略を基にした、効果的な公的、官民、市民社会のパートナーシップを奨励・推進する',
      descriptionEs: 'Fomentar y promover la '
          'constitucion de alianzas '
          'eficaces en las esferas publica, '
          'publico-privada y de la sociedad '
          'civil, aprovechando la '
          'experiencia y las estrategias de '
          'obtencion de recursos de las '
          'alianzas',
    ),
    SdgTarget(
      code: '17.18',
      description: 'By 2020, enhance '
          'capacity-building support to '
          'developing countries, including '
          'for least developed countries '
          'and small island developing '
          'states, to increase '
          'significantly the availability '
          'of high-quality, timely and '
          'reliable data',
      descriptionJa:
          '2020年までに、後発開発途上国及び小島嶼開発途上国を含む開発途上国に対する能力構築支援を強化し、所得、性別、年齢、人種、民族、居住資格、障害、地理的位置及びその他各国事情に関連する特性別の質が高く、タイムリーかつ信頼性のある非集計型データの入手可能性を向上させる',
      descriptionEs: 'De aqui a 2020, mejorar el apoyo '
          'a la creacion de capacidad '
          'prestado a los paises en '
          'desarrollo, incluidos los paises '
          'menos adelantados y los pequenos '
          'Estados insulares en desarrollo, '
          'para aumentar significativamente '
          'la disponibilidad de datos '
          'oportunos, fiables y de gran '
          'calidad',
    ),
    SdgTarget(
      code: '17.19',
      description: 'By 2030, build on existing '
          'initiatives to develop '
          'measurements of progress on '
          'sustainable development that '
          'complement gross domestic '
          'product, and support statistical '
          'capacity-building in developing '
          'countries',
      descriptionJa:
          '2030年までに、持続可能な開発の進捗状況を測るGDP以外の尺度を開発する既存の取組を更に前進させ、開発途上国における統計に関する能力構築を支援する',
      descriptionEs: 'De aqui a 2030, aprovechar las '
          'iniciativas existentes para '
          'elaborar indicadores que '
          'permitan medir los progresos en '
          'materia de desarrollo sostenible '
          'y complementen el producto '
          'interno bruto, y apoyar la '
          'creacion de capacidad '
          'estadistica en los paises en '
          'desarrollo',
    ),
  ],
};
