#!/usr/bin/env node

/**
 * Generates sdg_targets.dart with EN/JA/ES translations
 * for all 169 UN SDG targets.
 *
 * Sources:
 * - EN: UN A/RES/70/1
 * - JA: MOFA Japan / UNIC Tokyo official translation
 * - ES: UN Spanish official translation
 *
 * Usage: node scripts/generate_sdg_targets_i18n.js
 */

const fs = require('fs');
const path = require('path');

const DART_OUTPUT = path.join(
  __dirname, '..', 'lib', 'features', 'sdg',
  'data', 'sdg_targets.dart',
);
const JSON_OUTPUT = path.join(
  __dirname, '..', 'data', 'app',
  'sdg_targets.json',
);

// [code, en, ja, es]
const DATA = {
  1: [
    [
      '1.1',
      'By 2030, eradicate extreme poverty for all people everywhere, currently measured as people living on less than $1.25 a day',
      '2030年までに、現在1日1.25ドル未満で生活する人々と定義されている極度の貧困をあらゆる場所で終わらせる',
      'De aqui a 2030, erradicar para todas las personas y en todo el mundo la pobreza extrema, actualmente medida por un ingreso por persona inferior a 1,25 dolares de los Estados Unidos al dia',
    ],
    [
      '1.2',
      'By 2030, reduce at least by half the proportion of men, women and children of all ages living in poverty in all its dimensions according to national definitions',
      '2030年までに、各国定義によるあらゆる次元の貧困状態にある、すべての年齢の男性、女性、子どもの割合を半減させる',
      'De aqui a 2030, reducir al menos a la mitad la proporcion de hombres, mujeres y ninos de todas las edades que viven en la pobreza en todas sus dimensiones con arreglo a las definiciones nacionales',
    ],
    [
      '1.3',
      'Implement nationally appropriate social protection systems and measures for all, including floors, and by 2030 achieve substantial coverage of the poor and the vulnerable',
      '各国において最低限の基準を含む適切な社会保護制度及び対策を実施し、2030年までに貧困層及び脆弱層に対し十分な保護を達成する',
      'Implementar a nivel nacional sistemas y medidas apropiados de proteccion social para todos, incluidos niveles minimos, y, de aqui a 2030, lograr una amplia cobertura de las personas pobres y vulnerables',
    ],
    [
      '1.4',
      'By 2030, ensure that all men and women, in particular the poor and the vulnerable, have equal rights to economic resources, as well as access to basic services, ownership and control over land and other forms of property, inheritance, natural resources, appropriate new technology and financial services, including microfinance',
      '2030年までに、貧困層及び脆弱層をはじめ、すべての男性及び女性が、経済的資源に対する同等の権利を持つとともに、基礎的サービス、オーナーシップ及び土地その他の財産、相続財産、天然資源、適切な新技術、マイクロファイナンスを含む金融サービスへのアクセスを確保する',
      'De aqui a 2030, garantizar que todos los hombres y mujeres, en particular los pobres y los vulnerables, tengan los mismos derechos a los recursos economicos y acceso a los servicios basicos, la propiedad y el control de la tierra y otros bienes, la herencia, los recursos naturales, las nuevas tecnologias apropiadas y los servicios financieros, incluida la microfinanciacion',
    ],
    [
      '1.5',
      'By 2030, build the resilience of the poor and those in vulnerable situations and reduce their exposure and vulnerability to climate-related extreme events and other economic, social and environmental shocks and disasters',
      '2030年までに、貧困層や脆弱な状況にある人々の強靱性を構築し、気候変動に関連する極端な気象現象やその他の経済、社会、環境的ショック及び災害に対する暴露や脆弱性を軽減する',
      'De aqui a 2030, fomentar la resiliencia de los pobres y las personas que se encuentran en situaciones de vulnerabilidad y reducir su exposicion y vulnerabilidad a los fenomenos extremos relacionados con el clima y otras perturbaciones y desastres economicos, sociales y ambientales',
    ],
    [
      '1.a',
      'Ensure significant mobilization of resources from a variety of sources, including through enhanced development cooperation, in order to provide adequate and predictable means for developing countries, in particular least developed countries, to implement programmes and policies to end poverty in all its dimensions',
      'あらゆる次元での貧困を終わらせるための計画や政策を実施するべく、後発開発途上国をはじめとする開発途上国に対して適切かつ予測可能な手段を講じるため、開発協力の強化などを通じて、さまざまな供給源からの相当量の資源の動員を確保する',
      'Garantizar una movilizacion significativa de recursos procedentes de diversas fuentes, incluso mediante la mejora de la cooperacion para el desarrollo, a fin de proporcionar medios suficientes y previsibles a los paises en desarrollo, en particular los paises menos adelantados, para que implementen programas y politicas encaminados a poner fin a la pobreza en todas sus dimensiones',
    ],
    [
      '1.b',
      'Create sound policy frameworks at the national, regional and international levels, based on pro-poor and gender-sensitive development strategies, to support accelerated investment in poverty eradication actions',
      '貧困撲滅のための行動への投資拡大を支援するため、国、地域及び国際レベルで、貧困層やジェンダーに配慮した開発戦略に基づいた適正な政策的枠組みを構築する',
      'Crear marcos normativos solidos en los planos nacional, regional e internacional, sobre la base de estrategias de desarrollo en favor de los pobres que tengan en cuenta las cuestiones de genero, a fin de apoyar la inversion acelerada en medidas para erradicar la pobreza',
    ],
  ],
  2: [
    [
      '2.1',
      'By 2030, end hunger and ensure access by all people, in particular the poor and people in vulnerable situations, including infants, to safe, nutritious and sufficient food all year round',
      '2030年までに、飢餓を撲滅し、すべての人々、特に貧困層及び幼児を含む脆弱な立場にある人々が一年中安全かつ栄養のある食料を十分得られるようにする',
      'De aqui a 2030, poner fin al hambre y asegurar el acceso de todas las personas, en particular los pobres y las personas en situaciones de vulnerabilidad, incluidos los ninos menores de 1 ano, a una alimentacion sana, nutritiva y suficiente durante todo el ano',
    ],
    [
      '2.2',
      'By 2030, end all forms of malnutrition, including achieving by 2025 the internationally agreed targets on stunting and wasting in children under five years of age, and address the nutritional needs of adolescent girls, pregnant and lactating women, and older persons',
      '5歳未満の子どもの発育阻害や消耗性疾患について国際的に合意されたターゲットを2025年までに達成するなど、2030年までにあらゆる形態の栄養不良を解消し、若年女子、妊婦・授乳婦及び高齢者の栄養ニーズへの対処を行う',
      'De aqui a 2030, poner fin a todas las formas de malnutricion, incluso logrando, a mas tardar en 2025, las metas convenidas internacionalmente sobre el retraso del crecimiento y la emaciacion de los ninos menores de 5 anos, y abordar las necesidades de nutricion de las adolescentes, las mujeres embarazadas y lactantes y las personas de edad',
    ],
    [
      '2.3',
      'By 2030, double the agricultural productivity and incomes of small-scale food producers, in particular women, indigenous peoples, family farmers, pastoralists and fishers, including through secure and equal access to land, other productive resources and inputs, knowledge, financial services, markets and opportunities for value addition and non-farm employment',
      '2030年までに、土地、その他の生産資源や、投入財、知識、金融サービス、市場及び高付加価値化や非農業雇用の機会への確実かつ平等なアクセスの確保などを通じて、女性、先住民、家族農家、牧畜民及び漁業者をはじめとする小規模食料生産者の農業生産性及び所得を倍増させる',
      'De aqui a 2030, duplicar la productividad agricola y los ingresos de los productores de alimentos en pequena escala, en particular las mujeres, los pueblos indigenas, los agricultores familiares, los ganaderos y los pescadores, entre otras cosas mediante un acceso seguro y equitativo a las tierras, a otros recursos e insumos de produccion y a los conocimientos, los servicios financieros, los mercados y las oportunidades para anadir valor y obtener empleos no agricolas',
    ],
    [
      '2.4',
      'By 2030, ensure sustainable food production systems and implement resilient agricultural practices that increase productivity and production, that help maintain ecosystems, that strengthen capacity for adaptation to climate change, extreme weather, drought, flooding and other disasters and that progressively improve land and soil quality',
      '2030年までに、生産性を向上させ、生産量を増やし、生態系を維持し、気候変動や極端な気象現象、干ばつ、洪水及びその他の災害に対する適応能力を向上させ、漸進的に土地と土壌の質を改善させるような、持続可能な食料生産システムを確保し、強靱な農業を実践する',
      'De aqui a 2030, asegurar la sostenibilidad de los sistemas de produccion de alimentos y aplicar practicas agricolas resilientes que aumenten la productividad y la produccion, contribuyan al mantenimiento de los ecosistemas, fortalezcan la capacidad de adaptacion al cambio climatico, los fenomenos meteorologicos extremos, las sequias, las inundaciones y otros desastres, y mejoren progresivamente la calidad de la tierra y el suelo',
    ],
    [
      '2.5',
      'By 2020, maintain the genetic diversity of seeds, cultivated plants and farmed and domesticated animals and their related wild species, including through soundly managed and diversified seed and plant banks at the national, regional and international levels, and promote access to and fair and equitable sharing of benefits arising from the utilization of genetic resources and associated traditional knowledge, as internationally agreed',
      '2020年までに、国、地域及び国際レベルで適正に管理及び多様化された種子・植物バンクなども通じて、種子、栽培植物、飼育・家畜化された動物及びこれらの近縁野生種の遺伝的多様性を維持し、国際的合意に基づき、遺伝資源及びこれに関連する伝統的な知識へのアクセス及びその利用から生じる利益の公正かつ衡平な配分を促進する',
      'De aqui a 2020, mantener la diversidad genetica de las semillas, las plantas cultivadas y los animales de granja y domesticados y sus correspondientes especies silvestres, entre otras cosas mediante una buena gestion y diversificacion de los bancos de semillas y plantas a nivel nacional, regional e internacional, y promover el acceso a los beneficios que se deriven de la utilizacion de los recursos geneticos y los conocimientos tradicionales conexos y su distribucion justa y equitativa, segun lo convenido internacionalmente',
    ],
    [
      '2.a',
      'Increase investment, including through enhanced international cooperation, in rural infrastructure, agricultural research and extension services, technology development and plant and livestock gene banks in order to enhance agricultural productive capacity in developing countries, in particular least developed countries',
      '開発途上国、特に後発開発途上国における農業生産能力向上のために、国際協力の強化などを通じて、農村インフラ、農業研究・普及サービス、技術開発及び植物・家畜のジーン・バンクへの投資の拡大を図る',
      'Aumentar, incluso mediante una mayor cooperacion internacional, las inversiones en infraestructura rural, investigacion y servicios de extension agricola, desarrollo tecnologico y bancos de genes de plantas y ganado a fin de mejorar la capacidad de produccion agropecuaria en los paises en desarrollo, particularmente en los paises menos adelantados',
    ],
    [
      '2.b',
      'Correct and prevent trade restrictions and distortions in world agricultural markets, including through the parallel elimination of all forms of agricultural export subsidies and all export measures with equivalent effect, in accordance with the mandate of the Doha Development Round',
      'ドーハ開発ラウンドの決議に従い、すべての形態の農産物輸出補助金及び同等の効果を持つすべての輸出措置の並行的撤廃などを通じて、世界の農産物市場における貿易制限や歪みを是正及び防止する',
      'Corregir y prevenir las restricciones y distorsiones comerciales en los mercados agropecuarios mundiales, incluso mediante la eliminacion paralela de todas las formas de subvencion a las exportaciones agricolas y todas las medidas de exportacion con efectos equivalentes, de conformidad con el mandato de la Ronda de Doha para el Desarrollo',
    ],
    [
      '2.c',
      'Adopt measures to ensure the proper functioning of food commodity markets and their derivatives and facilitate timely access to market information, including on food reserves, in order to help limit extreme food price volatility',
      '食料価格の極端な変動に歯止めをかけるため、食料市場及びデリバティブ市場の適正な機能を確保するための措置を講じ、食料備蓄などの市場情報への適時のアクセスを容易にする',
      'Adoptar medidas para asegurar el buen funcionamiento de los mercados de productos basicos alimentarios y sus derivados y facilitar el acceso oportuno a la informacion sobre los mercados, incluso sobre las reservas de alimentos, a fin de ayudar a limitar la extrema volatilidad de los precios de los alimentos',
    ],
  ],
  3: [
    [
      '3.1',
      'By 2030, reduce the global maternal mortality ratio to less than 70 per 100,000 live births',
      '2030年までに、世界の妊産婦の死亡率を出生10万人当たり70人未満に削減する',
      'De aqui a 2030, reducir la tasa mundial de mortalidad materna a menos de 70 por cada 100.000 nacidos vivos',
    ],
    [
      '3.2',
      'By 2030, end preventable deaths of newborns and children under 5 years of age, with all countries aiming to reduce neonatal mortality to at least as low as 12 per 1,000 live births and under-5 mortality to at least as low as 25 per 1,000 live births',
      'すべての国が新生児死亡率を少なくとも出生1,000件中12件以下まで減らし、5歳以下死亡率を少なくとも出生1,000件中25件以下まで減らすことを目指し、2030年までに、新生児及び5歳未満児の予防可能な死亡を根絶する',
      'De aqui a 2030, poner fin a las muertes evitables de recien nacidos y de ninos menores de 5 anos, logrando que todos los paises intenten reducir la mortalidad neonatal al menos a 12 por cada 1.000 nacidos vivos y la mortalidad de los ninos menores de 5 anos al menos a 25 por cada 1.000 nacidos vivos',
    ],
    [
      '3.3',
      'By 2030, end the epidemics of AIDS, tuberculosis, malaria and neglected tropical diseases and combat hepatitis, water-borne diseases and other communicable diseases',
      '2030年までに、エイズ、結核、マラリア及び顧みられない熱帯病といった伝染病を根絶するとともに肝炎、水系感染症及びその他の感染症に対処する',
      'De aqui a 2030, poner fin a las epidemias del SIDA, la tuberculosis, la malaria y las enfermedades tropicales desatendidas y combatir la hepatitis, las enfermedades transmitidas por el agua y otras enfermedades transmisibles',
    ],
    [
      '3.4',
      'By 2030, reduce by one third premature mortality from non-communicable diseases through prevention and treatment and promote mental health and well-being',
      '2030年までに、非感染性疾患による若年死亡率を、予防や治療を通じて3分の1減少させ、精神保健及び福祉を促進する',
      'De aqui a 2030, reducir en un tercio la mortalidad prematura por enfermedades no transmisibles mediante su prevencion y tratamiento, y promover la salud mental y el bienestar',
    ],
    [
      '3.5',
      'Strengthen the prevention and treatment of substance abuse, including narcotic drug abuse and harmful use of alcohol',
      '薬物乱用やアルコールの有害な摂取を含む、物質乱用の防止・治療を強化する',
      'Fortalecer la prevencion y el tratamiento del abuso de sustancias adictivas, incluido el uso indebido de estupefacientes y el consumo nocivo de alcohol',
    ],
    [
      '3.6',
      'By 2020, halve the number of global deaths and injuries from road traffic accidents',
      '2020年までに、世界の道路交通事故による死傷者を半減させる',
      'De aqui a 2020, reducir a la mitad el numero de muertes y lesiones causadas por accidentes de trafico en el mundo',
    ],
    [
      '3.7',
      'By 2030, ensure universal access to sexual and reproductive health-care services, including for family planning, information and education, and the integration of reproductive health into national strategies and programmes',
      '2030年までに、家族計画、情報・教育及びリプロダクティブ・ヘルスの国家戦略・計画への組み入れを含む、性と生殖に関する保健サービスをすべての人々が利用できるようにする',
      'De aqui a 2030, garantizar el acceso universal a los servicios de salud sexual y reproductiva, incluidos los de planificacion familiar, informacion y educacion, y la integracion de la salud reproductiva en las estrategias y los programas nacionales',
    ],
    [
      '3.8',
      'Achieve universal health coverage, including financial risk protection, access to quality essential health-care services and access to safe, effective, quality and affordable essential medicines and vaccines for all',
      'すべての人々に対する財政リスクからの保護、質の高い基礎的な保健サービスへのアクセス及び安全で効果的かつ質が高く安価な必須医薬品とワクチンへのアクセスを含む、ユニバーサル・ヘルス・カバレッジを達成する',
      'Lograr la cobertura sanitaria universal, incluida la proteccion contra los riesgos financieros, el acceso a servicios de salud esenciales de calidad y el acceso a medicamentos y vacunas inocuos, eficaces, asequibles y de calidad para todos',
    ],
    [
      '3.9',
      'By 2030, substantially reduce the number of deaths and illnesses from hazardous chemicals and air, water and soil pollution and contamination',
      '2030年までに、有害化学物質、ならびに大気、水質及び土壌の汚染による死亡及び疾病の件数を大幅に減少させる',
      'De aqui a 2030, reducir considerablemente el numero de muertes y enfermedades causadas por productos quimicos peligrosos y por la polucion y contaminacion del aire, el agua y el suelo',
    ],
    [
      '3.a',
      'Strengthen the implementation of the World Health Organization Framework Convention on Tobacco Control in all countries, as appropriate',
      'すべての国々において、たばこの規制に関する世界保健機関枠組条約の実施を適宜強化する',
      'Fortalecer la aplicacion del Convenio Marco de la Organizacion Mundial de la Salud para el Control del Tabaco en todos los paises, segun proceda',
    ],
    [
      '3.b',
      'Support the research and development of vaccines and medicines for the communicable and non-communicable diseases that primarily affect developing countries, provide access to affordable essential medicines and vaccines for all',
      '主に開発途上国に影響を及ぼす感染性及び非感染性疾患のワクチン及び医薬品の研究開発を支援するとともに、すべての人々に安価な必須医薬品及びワクチンへのアクセスを提供する',
      'Apoyar las actividades de investigacion y desarrollo de vacunas y medicamentos contra las enfermedades transmisibles y no transmisibles que afectan primordialmente a los paises en desarrollo y facilitar el acceso a medicamentos y vacunas esenciales asequibles',
    ],
    [
      '3.c',
      'Substantially increase health financing and the recruitment, development, training and retention of the health workforce in developing countries, especially in least developed countries and small island developing States',
      '開発途上国、特に後発開発途上国及び小島嶼開発途上国において保健財政及び保健人材の採用、能力開発・訓練及び定着を大幅に拡大させる',
      'Aumentar considerablemente la financiacion de la salud y la contratacion, el perfeccionamiento, la capacitacion y la retencion del personal sanitario en los paises en desarrollo, especialmente en los paises menos adelantados y los pequenos Estados insulares en desarrollo',
    ],
    [
      '3.d',
      'Strengthen the capacity of all countries, in particular developing countries, for early warning, risk reduction and management of national and global health risks',
      'すべての国々、特に開発途上国の国家・世界規模な健康危険因子の早期警告、危険因子緩和及び危険因子管理のための能力を強化する',
      'Reforzar la capacidad de todos los paises, en particular los paises en desarrollo, en materia de alerta temprana, reduccion de riesgos y gestion de los riesgos para la salud nacional y mundial',
    ],
  ],
  4: [
    [
      '4.1',
      'By 2030, ensure that all girls and boys complete free, equitable and quality primary and secondary education leading to relevant and effective learning outcomes',
      '2030年までに、すべての子どもが男女の区別なく、適切かつ効果的な学習成果をもたらす、無償かつ公正で質の高い初等教育及び中等教育を修了できるようにする',
      'De aqui a 2030, asegurar que todas las ninas y todos los ninos terminen la ensenanza primaria y secundaria, que ha de ser gratuita, equitativa y de calidad y producir resultados de aprendizaje pertinentes y efectivos',
    ],
    [
      '4.2',
      'By 2030, ensure that all girls and boys have access to quality early childhood development, care and pre-primary education so that they are ready for primary education',
      '2030年までに、すべての子どもが男女の区別なく、質の高い乳幼児の発達・ケア及び就学前教育にアクセスすることにより、初等教育を受ける準備が整うようにする',
      'De aqui a 2030, asegurar que todas las ninas y todos los ninos tengan acceso a servicios de atencion y desarrollo en la primera infancia y educacion preescolar de calidad, a fin de que esten preparados para la ensenanza primaria',
    ],
    [
      '4.3',
      'By 2030, ensure equal access for all women and men to affordable and quality technical, vocational and tertiary education, including university',
      '2030年までに、すべての女性及び男性が、手の届く質の高い技術教育・職業教育及び大学を含む高等教育への平等なアクセスを得られるようにする',
      'De aqui a 2030, asegurar el acceso igualitario de todos los hombres y las mujeres a una formacion tecnica, profesional y superior de calidad, incluida la ensenanza universitaria',
    ],
    [
      '4.4',
      'By 2030, substantially increase the number of youth and adults who have relevant skills, including technical and vocational skills, for employment, decent jobs and entrepreneurship',
      '2030年までに、技術的・職業的スキルなど、雇用、働きがいのある人間らしい仕事及び起業に必要な技能を備えた若者と成人の割合を大幅に増加させる',
      'De aqui a 2030, aumentar considerablemente el numero de jovenes y adultos que tienen las competencias necesarias, en particular tecnicas y profesionales, para acceder al empleo, el trabajo decente y el emprendimiento',
    ],
    [
      '4.5',
      'By 2030, eliminate gender disparities in education and ensure equal access to all levels of education and vocational training for the vulnerable, including persons with disabilities, indigenous peoples and children in vulnerable situations',
      '2030年までに、教育におけるジェンダー格差を無くし、障害者、先住民及び脆弱な立場にある子どもなど、脆弱層があらゆるレベルの教育や職業訓練に平等にアクセスできるようにする',
      'De aqui a 2030, eliminar las disparidades de genero en la educacion y asegurar el acceso igualitario a todos los niveles de la ensenanza y la formacion profesional para las personas vulnerables, incluidas las personas con discapacidad, los pueblos indigenas y los ninos en situaciones de vulnerabilidad',
    ],
    [
      '4.6',
      'By 2030, ensure that all youth and a substantial proportion of adults, both men and women, achieve literacy and numeracy',
      '2030年までに、すべての若者及び大多数の成人が、男女ともに、読み書き能力及び基本的計算能力を身に付けられるようにする',
      'De aqui a 2030, asegurar que todos los jovenes y una proporcion considerable de los adultos, tanto hombres como mujeres, esten alfabetizados y tengan nociones elementales de aritmetica',
    ],
    [
      '4.7',
      'By 2030, ensure that all learners acquire the knowledge and skills needed to promote sustainable development, including through education for sustainable development and sustainable lifestyles, human rights, gender equality, promotion of a culture of peace and non-violence, global citizenship and appreciation of cultural diversity',
      '2030年までに、持続可能な開発のための教育及び持続可能なライフスタイル、人権、男女の平等、平和及び非暴力的文化の推進、グローバル・シチズンシップ、文化多様性と文化の持続可能な開発への貢献の理解の教育を通して、すべての学習者が、持続可能な開発を促進するために必要な知識及び技能を習得できるようにする',
      'De aqui a 2030, asegurar que todos los alumnos adquieran los conocimientos teoricos y practicos necesarios para promover el desarrollo sostenible, entre otras cosas mediante la educacion para el desarrollo sostenible y los estilos de vida sostenibles, los derechos humanos, la igualdad de genero, la promocion de una cultura de paz y no violencia, la ciudadania mundial y la valoracion de la diversidad cultural',
    ],
    [
      '4.a',
      'Build and upgrade education facilities that are child, disability and gender sensitive and provide safe, non-violent, inclusive and effective learning environments for all',
      '子ども、障害及びジェンダーに配慮した教育施設を構築・改良し、すべての人々に安全で非暴力的、包摂的、効果的な学習環境を提供できるようにする',
      'Construir y adecuar instalaciones educativas que tengan en cuenta las necesidades de los ninos y las personas con discapacidad y las diferencias de genero, y que ofrezcan entornos de aprendizaje seguros, no violentos, inclusivos y eficaces para todos',
    ],
    [
      '4.b',
      'By 2020, substantially expand globally the number of scholarships available to developing countries, in particular least developed countries, small island developing States and African countries, for enrolment in higher education',
      '2020年までに、開発途上国、特に後発開発途上国及び小島嶼開発途上国、ならびにアフリカ諸国を対象とした、職業訓練、情報通信技術、技術・工学・科学プログラムなど、先進国及びその他の開発途上国における高等教育の奨学金の件数を全世界で大幅に増加させる',
      'De aqui a 2020, aumentar considerablemente a nivel mundial el numero de becas disponibles para los paises en desarrollo, en particular los paises menos adelantados, los pequenos Estados insulares en desarrollo y los paises africanos, a fin de que sus estudiantes puedan matricularse en programas de ensenanza superior',
    ],
    [
      '4.c',
      'By 2030, substantially increase the supply of qualified teachers, including through international cooperation for teacher training in developing countries, especially least developed countries and small island developing States',
      '2030年までに、開発途上国、特に後発開発途上国及び小島嶼開発途上国における教員研修のための国際協力などを通じて、質の高い教員の数を大幅に増加させる',
      'De aqui a 2030, aumentar considerablemente la oferta de docentes calificados, incluso mediante la cooperacion internacional para la formacion de docentes en los paises en desarrollo, especialmente los paises menos adelantados y los pequenos Estados insulares en desarrollo',
    ],
  ],
  5: [
    [
      '5.1',
      'End all forms of discrimination against all women and girls everywhere',
      'あらゆる場所におけるすべての女性及び女児に対するあらゆる形態の差別を撤廃する',
      'Poner fin a todas las formas de discriminacion contra todas las mujeres y las ninas en todo el mundo',
    ],
    [
      '5.2',
      'Eliminate all forms of violence against all women and girls in the public and private spheres, including trafficking and sexual and other types of exploitation',
      'すべての女性及び女児に対する、公共・私的空間におけるあらゆる形態の暴力を排除する（人身売買や性的、その他の種類の搾取を含む）',
      'Eliminar todas las formas de violencia contra todas las mujeres y las ninas en los ambitos publico y privado, incluidas la trata y la explotacion sexual y otros tipos de explotacion',
    ],
    [
      '5.3',
      'Eliminate all harmful practices, such as child, early and forced marriage and female genital mutilation',
      '未成年者の結婚、早期結婚、強制結婚及び女性器切除など、あらゆる有害な慣行を撤廃する',
      'Eliminar todas las practicas nocivas, como el matrimonio infantil, precoz y forzado y la mutilacion genital femenina',
    ],
    [
      '5.4',
      'Recognize and value unpaid care and domestic work through the provision of public services, infrastructure and social protection policies and the promotion of shared responsibility within the household and the family as nationally appropriate',
      '公共のサービス、インフラ及び社会保障政策の提供、ならびに各国の状況に応じた世帯・家族内における責任分担を通じて、無報酬の育児・介護や家事労働を認識・評価する',
      'Reconocer y valorar los cuidados y el trabajo domestico no remunerados mediante servicios publicos, infraestructuras y politicas de proteccion social, y promoviendo la responsabilidad compartida en el hogar y la familia, segun proceda en cada pais',
    ],
    [
      '5.5',
      "Ensure women's full and effective participation and equal opportunities for leadership at all levels of decision-making in political, economic and public life",
      '政治、経済、公共分野でのあらゆるレベルの意思決定において、完全かつ効果的な女性の参画及び平等なリーダーシップの機会を確保する',
      'Asegurar la participacion plena y efectiva de las mujeres y la igualdad de oportunidades de liderazgo a todos los niveles decisorios en la vida politica, economica y publica',
    ],
    [
      '5.6',
      'Ensure universal access to sexual and reproductive health and reproductive rights as agreed in accordance with the Programme of Action of the International Conference on Population and Development and the Beijing Platform for Action',
      '国際人口・開発会議の行動計画及び北京行動綱領、ならびにこれらの検証会議の成果文書に従い、性と生殖に関する健康及び権利への普遍的アクセスを確保する',
      'Asegurar el acceso universal a la salud sexual y reproductiva y los derechos reproductivos segun lo acordado de conformidad con el Programa de Accion de la Conferencia Internacional sobre la Poblacion y el Desarrollo, la Plataforma de Accion de Beijing',
    ],
    [
      '5.a',
      'Undertake reforms to give women equal rights to economic resources, as well as access to ownership and control over land and other forms of property, financial services, inheritance and natural resources, in accordance with national laws',
      '女性に対し、経済的資源に対する同等の権利、ならびに各国法に従い、オーナーシップ及び土地その他の財産、金融サービス、相続財産、天然資源に対するアクセスを与えるための改革に着手する',
      'Emprender reformas que otorguen a las mujeres igualdad de derechos a los recursos economicos, asi como acceso a la propiedad y al control de la tierra y otros tipos de bienes, los servicios financieros, la herencia y los recursos naturales, de conformidad con las leyes nacionales',
    ],
    [
      '5.b',
      'Enhance the use of enabling technology, in particular information and communications technology, to promote the empowerment of women',
      '女性の能力強化促進のため、ICTをはじめとする実現技術の活用を強化する',
      'Mejorar el uso de la tecnologia instrumental, en particular la tecnologia de la informacion y las comunicaciones, para promover el empoderamiento de las mujeres',
    ],
    [
      '5.c',
      'Adopt and strengthen sound policies and enforceable legislation for the promotion of gender equality and the empowerment of all women and girls at all levels',
      'ジェンダー平等の促進、ならびにすべての女性及び女子のあらゆるレベルでの能力強化のための適正な政策及び拘束力のある法規を導入・強化する',
      'Aprobar y fortalecer politicas acertadas y leyes aplicables para promover la igualdad de genero y el empoderamiento de todas las mujeres y las ninas a todos los niveles',
    ],
  ],
  6: [
    [
      '6.1',
      'By 2030, achieve universal and equitable access to safe and affordable drinking water for all',
      '2030年までに、すべての人々の、安全で安価な飲料水の普遍的かつ衡平なアクセスを達成する',
      'De aqui a 2030, lograr el acceso universal y equitativo al agua potable a un precio asequible para todos',
    ],
    [
      '6.2',
      'By 2030, achieve access to adequate and equitable sanitation and hygiene for all and end open defecation, paying special attention to the needs of women and girls and those in vulnerable situations',
      '2030年までに、すべての人々の、適切かつ平等な下水施設・衛生施設へのアクセスを達成し、野外での排泄をなくす。女性及び女児、ならびに脆弱な立場にある人々のニーズに特に注意を払う',
      'De aqui a 2030, lograr el acceso a servicios de saneamiento e higiene adecuados y equitativos para todos y poner fin a la defecacion al aire libre, prestando especial atencion a las necesidades de las mujeres y las ninas y las personas en situaciones de vulnerabilidad',
    ],
    [
      '6.3',
      'By 2030, improve water quality by reducing pollution, eliminating dumping and minimizing release of hazardous chemicals and materials, halving the proportion of untreated wastewater and substantially increasing recycling and safe reuse globally',
      '2030年までに、汚染の減少、投棄の廃絶と有害な化学物・物質の放出の最小化、未処理の排水の割合半減及び再生利用と安全な再利用の世界的規模で大幅な増加させることにより、水質を改善する',
      'De aqui a 2030, mejorar la calidad del agua reduciendo la contaminacion, eliminando el vertimiento y minimizando la emision de productos quimicos y materiales peligrosos, reduciendo a la mitad el porcentaje de aguas residuales sin tratar y aumentando considerablemente el reciclado y la reutilizacion sin riesgos a nivel mundial',
    ],
    [
      '6.4',
      'By 2030, substantially increase water-use efficiency across all sectors and ensure sustainable withdrawals and supply of freshwater to address water scarcity and substantially reduce the number of people suffering from water scarcity',
      '2030年までに、全セクターにおいて水利用の効率を大幅に改善し、淡水の持続可能な採取及び供給を確保し水不足に対処するとともに、水不足に悩む人々の数を大幅に減少させる',
      'De aqui a 2030, aumentar considerablemente el uso eficiente de los recursos hidricos en todos los sectores y asegurar la sostenibilidad de la extraccion y el abastecimiento de agua dulce para hacer frente a la escasez de agua y reducir considerablemente el numero de personas que sufren falta de agua',
    ],
    [
      '6.5',
      'By 2030, implement integrated water resources management at all levels, including through transboundary cooperation as appropriate',
      '2030年までに、国境を越えた適切な協力を含む、あらゆるレベルでの統合水資源管理を実施する',
      'De aqui a 2030, implementar la gestion integrada de los recursos hidricos a todos los niveles, incluso mediante la cooperacion transfronteriza, segun proceda',
    ],
    [
      '6.6',
      'By 2020, protect and restore water-related ecosystems, including mountains, forests, wetlands, rivers, aquifers and lakes',
      '2020年までに、山地、森林、湿地、河川、帯水層、湖沼を含む水に関連する生態系の保護・回復を行う',
      'De aqui a 2020, proteger y restablecer los ecosistemas relacionados con el agua, incluidos los bosques, las montanas, los humedales, los rios, los acuiferos y los lagos',
    ],
    [
      '6.a',
      'By 2030, expand international cooperation and capacity-building support to developing countries in water- and sanitation-related activities and programmes, including water harvesting, desalination, water efficiency, wastewater treatment, recycling and reuse technologies',
      '2030年までに、集水、海水淡水化、水の効率的利用、排水処理、リサイクル・再利用技術を含む開発途上国における水と衛生分野での活動と計画を対象とした国際協力と能力構築支援を拡大する',
      'De aqui a 2030, ampliar la cooperacion internacional y el apoyo prestado a los paises en desarrollo para la creacion de capacidad en actividades y programas relativos al agua y el saneamiento, como los de captacion de agua, desalinizacion, uso eficiente de los recursos hidricos, tratamiento de aguas residuales, reciclado y tecnologias de reutilizacion',
    ],
    [
      '6.b',
      'Support and strengthen the participation of local communities in improving water and sanitation management',
      '水と衛生の管理向上における地域コミュニティの参加を支援・強化する',
      'Apoyar y fortalecer la participacion de las comunidades locales en la mejora de la gestion del agua y el saneamiento',
    ],
  ],
};

// Merge goals 7-12 and 13-17
const { DATA_7_12 } = require('./sdg_targets_data_7_12');
const { DATA_13_17 } = require('./sdg_targets_data_13_17');
Object.assign(DATA, DATA_7_12, DATA_13_17);

const LINE_LEN = 44;

function quoteSegment(seg) {
  const hasDollar = seg.includes('$');
  const hasApostrophe = seg.includes("'");
  if (hasDollar && hasApostrophe) {
    // Rare: both $ and ' in same segment
    return `r"${seg}"`;
  }
  if (hasDollar) return `r'${seg}'`;
  if (hasApostrophe) return `"${seg}"`;
  return `'${seg}'`;
}

function wrapStr(s, indent) {
  if (!s) return "''";

  if (s.length + indent + 2 <= 88) {
    return quoteSegment(s);
  }

  // Split into lines under LINE_LEN chars
  const words = s.split(' ');
  const lines = [];
  let cur = '';
  for (const w of words) {
    const test = cur ? `${cur} ${w}` : w;
    if (test.length + indent + 2 > LINE_LEN) {
      if (cur) lines.push(cur);
      cur = w;
    } else {
      cur = test;
    }
  }
  if (cur) lines.push(cur);

  if (lines.length === 1) {
    return quoteSegment(lines[0]);
  }

  const pad = ' '.repeat(indent);
  return lines
    .map((l, i) => {
      // Add trailing space except on last line
      const sp = i < lines.length - 1 ? ' ' : '';
      return `${pad}${quoteSegment(l + sp)}`;
    })
    .join('\n');
}

function generateDart() {
  const parts = [];
  parts.push(
    "/// UN SDG target data for all 17 goals.",
    "class SdgTarget {",
    "  const SdgTarget({",
    "    required this.code,",
    "    required this.description,",
    "    this.descriptionJa = '',",
    "    this.descriptionEs = '',",
    "  });",
    "",
    "  final String code;",
    "  final String description;",
    "  final String descriptionJa;",
    "  final String descriptionEs;",
    "",
    "  String getDescription(String locale) =>",
    "      switch (locale) {",
    "        'ja' when descriptionJa.isNotEmpty =>",
    "          descriptionJa,",
    "        'es' when descriptionEs.isNotEmpty =>",
    "          descriptionEs,",
    "        _ => description,",
    "      };",
    "}",
    "",
    "/// All 169 UN SDG targets keyed by goal number.",
    "const Map<int, List<SdgTarget>> sdgTargets = {",
  );

  for (let g = 1; g <= 17; g++) {
    const targets = DATA[g];
    if (!targets) continue;
    parts.push(`  ${g}: [`);
    for (const [code, en, ja, es] of targets) {
      parts.push("    SdgTarget(");
      parts.push(`      code: '${code}',`);

      // EN description
      const enLines = wrapStr(en, 10);
      if (enLines.includes('\n')) {
        parts.push("      description:");
        parts.push(enLines + ',');
      } else {
        parts.push(`      description: ${enLines},`);
      }

      // JA description
      const jaLines = wrapStr(ja, 10);
      if (jaLines.includes('\n')) {
        parts.push("      descriptionJa:");
        parts.push(jaLines + ',');
      } else {
        parts.push(`      descriptionJa: ${jaLines},`);
      }

      // ES description
      const esLines = wrapStr(es, 10);
      if (esLines.includes('\n')) {
        parts.push("      descriptionEs:");
        parts.push(esLines + ',');
      } else {
        parts.push(`      descriptionEs: ${esLines},`);
      }

      parts.push("    ),");
    }
    parts.push("  ],");
  }

  parts.push("};");
  parts.push("");

  return parts.join('\n');
}

function generateJson() {
  const result = {};
  for (let g = 1; g <= 17; g++) {
    const targets = DATA[g];
    if (!targets) continue;
    result[String(g)] = targets.map(
      ([code, en, ja, es]) => ({
        code,
        description: en,
        descriptionJa: ja,
        descriptionEs: es,
      }),
    );
  }
  return JSON.stringify(result, null, 2);
}

function main() {
  // Count targets
  let total = 0;
  for (let g = 1; g <= 17; g++) {
    const t = DATA[g];
    if (!t) {
      console.error(`Missing goal ${g}!`);
      process.exit(1);
    }
    console.log(`  Goal ${g}: ${t.length} targets`);
    total += t.length;
  }
  console.log(`  Total: ${total} targets`);

  if (total !== 169) {
    console.error(
      `Expected 169 targets, got ${total}`,
    );
    process.exit(1);
  }

  // Generate Dart
  const dart = generateDart();
  fs.writeFileSync(DART_OUTPUT, dart);
  const dkb = (
    fs.statSync(DART_OUTPUT).size / 1024
  ).toFixed(1);
  console.log(`\nWrote ${DART_OUTPUT} (${dkb} KB)`);

  // Generate JSON
  const json = generateJson();
  fs.writeFileSync(JSON_OUTPUT, json);
  const jkb = (
    fs.statSync(JSON_OUTPUT).size / 1024
  ).toFixed(1);
  console.log(`Wrote ${JSON_OUTPUT} (${jkb} KB)`);
}

main();
