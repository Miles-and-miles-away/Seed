import 'package:flutter/material.dart';

/// UN Sustainable Development Goal data
class SdgGoal {
  const SdgGoal({
    required this.number,
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.color,
    required this.iconUrl,
    this.isLearnOnly = false,
    this.titleJa = '',
    this.titleEs = '',
    this.shortTitleJa = '',
    this.shortTitleEs = '',
    this.descriptionJa = '',
    this.descriptionEs = '',
  });

  final int number;
  final String title;
  final String shortTitle;
  final String description;
  final Color color;
  final String iconUrl;
  final bool isLearnOnly;
  final String titleJa;
  final String titleEs;
  final String shortTitleJa;
  final String shortTitleEs;
  final String descriptionJa;
  final String descriptionEs;

  String getTitle(String locale) => switch (locale) {
    'ja' when titleJa.isNotEmpty => titleJa,
    'es' when titleEs.isNotEmpty => titleEs,
    _ => title,
  };

  String getShortTitle(String locale) =>
      switch (locale) {
        'ja' when shortTitleJa.isNotEmpty =>
          shortTitleJa,
        'es' when shortTitleEs.isNotEmpty =>
          shortTitleEs,
        _ => shortTitle,
      };

  String getDescription(String locale) =>
      switch (locale) {
        'ja' when descriptionJa.isNotEmpty =>
          descriptionJa,
        'es' when descriptionEs.isNotEmpty =>
          descriptionEs,
        _ => description,
      };

  String get infographicAsset =>
      'assets/images/sdg_infographics/'
      'sdg_infographic_$number.jpg';
}

/// All 17 UN Sustainable Development Goals
/// Colors from official UN SDG Guidelines
const sdgGoals = <SdgGoal>[
  SdgGoal(
    number: 1,
    title: 'No Poverty',
    shortTitle: 'No Poverty',
    description:
        'End poverty in all its forms everywhere. '
        'More than 700 million people still live in '
        'extreme poverty and are struggling to fulfil '
        'the most basic needs like health, education, '
        'and access to water and sanitation. The '
        'overwhelming majority of people living on '
        r'less than $1.90 a day live in Southern Asia '
        'and sub-Saharan Africa. The goal calls for '
        'social protection systems, equal rights to '
        'economic resources, and support for those '
        'affected by climate-related disasters and '
        'other shocks.',
    color: Color(0xFFE5233D),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-01.jpg',
    titleJa: '貧困をなくそう',
    titleEs: 'Fin de la pobreza',
    shortTitleJa: '貧困をなくそう',
    shortTitleEs: 'Fin de la pobreza',
    descriptionJa:
        'あらゆる場所で、あらゆる形態の貧困に終止符を'
        '打つ。7億人以上が極度の貧困の中で暮らし、健'
        '康、教育、水と衛生へのアクセスといった最も基'
        '本的なニーズを満たすことに苦しんでいます。社'
        '会的保護制度、経済的資源への平等な権利、気候'
        '関連の災害やその他のショックの影響を受けた人'
        '々への支援を求めています。',
    descriptionEs:
        'Poner fin a la pobreza en todas sus formas '
        'en todo el mundo. Mas de 700 millones de '
        'personas viven en pobreza extrema y luchan '
        'por satisfacer las necesidades mas basicas '
        'como salud, educacion y acceso al agua y '
        'saneamiento. El objetivo pide sistemas de '
        'proteccion social, igualdad de derechos a '
        'recursos economicos y apoyo para los '
        'afectados por desastres climaticos.',
  ),
  SdgGoal(
    number: 2,
    title: 'Zero Hunger',
    shortTitle: 'Zero Hunger',
    description:
        'End hunger, achieve food security and '
        'improved nutrition and promote sustainable '
        'agriculture. After decades of steady decline, '
        'the number of people who suffer from hunger '
        'has slowly increased since 2015. An estimated '
        '690 million people are hungry. The food and '
        'agriculture sector offers key solutions for '
        'development. Agriculture is the single '
        'largest employer in the world, providing '
        'livelihoods for 40% of the global population. '
        'It is the largest source of income for poor '
        'rural households.',
    color: Color(0xFFDDA73A),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-02.jpg',
    titleJa: '飢餓をゼロに',
    titleEs: 'Hambre cero',
    shortTitleJa: '飢餓をゼロに',
    shortTitleEs: 'Hambre cero',
    descriptionJa:
        '飢餓に終止符を打ち、食料の安定確保と栄養状態'
        'の改善を達成するとともに、持続可能な農業を推'
        '進する。数十年にわたる着実な減少の後、飢餓に'
        '苦しむ人々の数は2015年以降ゆっくりと増加して'
        'います。推定6億9000万人が飢餓状態にあります。'
        '農業は世界最大の雇用主であり、世界人口の40%'
        'に生計を提供しています。',
    descriptionEs:
        'Poner fin al hambre, lograr la seguridad '
        'alimentaria, mejorar la nutricion y promover '
        'la agricultura sostenible. Despues de decadas '
        'de disminucion constante, el numero de '
        'personas que sufren hambre ha aumentado '
        'lentamente desde 2015. Se estima que 690 '
        'millones de personas pasan hambre. La '
        'agricultura es el mayor empleador del mundo '
        'y proporciona medios de vida al 40% de la '
        'poblacion mundial.',
  ),
  SdgGoal(
    number: 3,
    title: 'Good Health and Well-Being',
    shortTitle: 'Good Health',
    description:
        'Ensure healthy lives and promote well-being '
        'for all at all ages. We have made great '
        'progress against several leading causes of '
        'death and disease. Life expectancy has '
        'increased dramatically; infant and maternal '
        'mortality rates have declined. We have turned '
        'the tide on HIV and malaria deaths. However, '
        'more efforts are needed to fully eradicate '
        'diseases and address persistent and emerging '
        'health issues.',
    color: Color(0xFF4CA146),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-03.jpg',
    titleJa: 'すべての人に健康と福祉を',
    titleEs: 'Salud y bienestar',
    shortTitleJa: '健康と福祉',
    shortTitleEs: 'Salud y bienestar',
    descriptionJa:
        'あらゆる年齢のすべての人の健康的な生活を確保'
        'し、福祉を推進する。死亡と疾病のいくつかの主'
        '要な原因に対して大きな進歩を遂げました。平均'
        '寿命は劇的に伸び、乳児と妊産婦の死亡率は低'
        '下しました。しかし、疾病を完全に根絶し、根強'
        'い健康問題や新たな健康問題に対処するには、さ'
        'らなる努力が必要です。',
    descriptionEs:
        'Garantizar una vida sana y promover el '
        'bienestar de todos a todas las edades. Hemos '
        'logrado grandes avances contra varias causas '
        'principales de muerte y enfermedad. La '
        'esperanza de vida ha aumentado '
        'dramaticamente; las tasas de mortalidad '
        'infantil y materna han disminuido. Sin '
        'embargo, se necesitan mas esfuerzos para '
        'erradicar enfermedades y abordar problemas '
        'de salud persistentes y emergentes.',
  ),
  SdgGoal(
    number: 4,
    title: 'Quality Education',
    shortTitle: 'Education',
    description:
        'Ensure inclusive and equitable quality '
        'education and promote lifelong learning '
        'opportunities for all. Education enables '
        'upward socioeconomic mobility and is a key '
        'to escaping poverty. Over the past decade, '
        'major progress was made towards increasing '
        'access to education and school enrollment '
        'rates at all levels. Nevertheless, about 260 '
        'million children were still out of school '
        'in 2018.',
    color: Color(0xFFC5192D),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-04.jpg',
    isLearnOnly: true,
    titleJa: '質の高い教育をみんなに',
    titleEs: 'Educacion de calidad',
    shortTitleJa: '質の高い教育',
    shortTitleEs: 'Educacion',
    descriptionJa:
        'すべての人に包摂的かつ公平で質の高い教育を提'
        '供し、生涯学習の機会を促進する。教育は社会経'
        '済的な上昇移動を可能にし、貧困から脱出するた'
        'めの鍵です。過去10年間で、教育へのアクセスと'
        '就学率の向上に大きな進歩がありました。しかし'
        '、2018年時点で約2億6000万人の子どもたちがまだ'
        '学校に通えていません。',
    descriptionEs:
        'Garantizar una educacion inclusiva y '
        'equitativa de calidad y promover '
        'oportunidades de aprendizaje permanente para '
        'todos. La educacion permite la movilidad '
        'socioeconomica ascendente y es clave para '
        'escapar de la pobreza. En la ultima decada '
        'se lograron avances importantes en el acceso '
        'a la educacion. Sin embargo, unos 260 '
        'millones de ninos seguian sin escolarizar '
        'en 2018.',
  ),
  SdgGoal(
    number: 5,
    title: 'Gender Equality',
    shortTitle: 'Gender Equality',
    description:
        'Achieve gender equality and empower all '
        'women and girls. Gender equality is not only '
        'a fundamental human right, but a necessary '
        'foundation for a peaceful, prosperous and '
        'sustainable world. Providing women and girls '
        'with equal access to education, health care, '
        'decent work, and representation in political '
        'and economic decision-making processes will '
        'fuel sustainable economies and benefit '
        'societies and humanity at large.',
    color: Color(0xFFEF402C),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-05.jpg',
    titleJa: 'ジェンダー平等を実現しよう',
    titleEs: 'Igualdad de genero',
    shortTitleJa: 'ジェンダー平等',
    shortTitleEs: 'Igualdad de genero',
    descriptionJa:
        'ジェンダーの平等を達成し、すべての女性と女児'
        'のエンパワーメントを図る。ジェンダーの平等は'
        '基本的人権であるだけでなく、平和で豊かで持続'
        '可能な世界のために必要な基盤です。女性と女児'
        'に教育、医療、ディーセント・ワーク、政治・経'
        '済的意思決定への平等なアクセスを提供すること'
        'が持続可能な経済を促進します。',
    descriptionEs:
        'Lograr la igualdad de genero y empoderar a '
        'todas las mujeres y ninas. La igualdad de '
        'genero no es solo un derecho humano '
        'fundamental, sino una base necesaria para un '
        'mundo pacifico, prospero y sostenible. '
        'Proporcionar a mujeres y ninas acceso '
        'igualitario a educacion, atencion medica, '
        'trabajo decente y representacion en procesos '
        'de toma de decisiones impulsara economias '
        'sostenibles.',
  ),
  SdgGoal(
    number: 6,
    title: 'Clean Water and Sanitation',
    shortTitle: 'Clean Water',
    description:
        'Ensure availability and sustainable '
        'management of water and sanitation for all. '
        'Water scarcity affects more than 40% of '
        'people around the world. This is projected '
        'to increase with the rise of global '
        'temperatures. Since 1990, 2.1 billion people '
        'have gained access to improved water '
        'sanitation, but dwindling supplies of safe '
        'drinking water is a major problem impacting '
        'every continent.',
    color: Color(0xFF27BFE6),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-06.jpg',
    titleJa: '安全な水とトイレを世界中に',
    titleEs: 'Agua limpia y saneamiento',
    shortTitleJa: '安全な水',
    shortTitleEs: 'Agua limpia',
    descriptionJa:
        'すべての人に水と衛生へのアクセスと持続可能な'
        '管理を確保する。水不足は世界の40%以上の人々に'
        '影響を与えています。1990年以降、21億人が改善'
        'された水衛生へのアクセスを得ましたが、安全な'
        '飲料水の供給減少はすべての大陸に影響を与える'
        '大きな問題です。',
    descriptionEs:
        'Garantizar la disponibilidad y la gestion '
        'sostenible del agua y el saneamiento para '
        'todos. La escasez de agua afecta a mas del '
        '40% de las personas en todo el mundo. Desde '
        '1990, 2.100 millones de personas han obtenido '
        'acceso a agua mejorada, pero la disminucion '
        'del suministro de agua potable segura es un '
        'problema importante que afecta a todos los '
        'continentes.',
  ),
  SdgGoal(
    number: 7,
    title: 'Affordable and Clean Energy',
    shortTitle: 'Clean Energy',
    description:
        'Ensure access to affordable, reliable, '
        'sustainable and modern energy for all. Energy '
        'is central to nearly every major challenge '
        'and opportunity the world faces today. Be it '
        'for jobs, security, climate change, food '
        'production or increasing incomes, access to '
        'energy for all is essential. The world is '
        'making good progress: energy access in poorer '
        'countries has begun to accelerate, and energy '
        'efficiency continues to improve.',
    color: Color(0xFFFBC412),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-07.jpg',
    titleJa: 'エネルギーをみんなにそしてクリーンに',
    titleEs: 'Energia asequible y no contaminante',
    shortTitleJa: 'クリーンエネルギー',
    shortTitleEs: 'Energia limpia',
    descriptionJa:
        'すべての人に手頃で信頼でき、持続可能かつ近代'
        '的なエネルギーへのアクセスを確保する。エネル'
        'ギーは今日世界が直面するほぼすべての主要な課'
        '題と機会の中心にあります。世界は良い進歩を遂'
        'げており、貧しい国々でのエネルギーアクセスが'
        '加速し、エネルギー効率は改善を続けています。',
    descriptionEs:
        'Garantizar el acceso a una energia asequible, '
        'fiable, sostenible y moderna para todos. La '
        'energia es fundamental para casi todos los '
        'grandes desafios y oportunidades del mundo '
        'actual. El mundo esta progresando: el acceso '
        'a la energia en los paises mas pobres ha '
        'comenzado a acelerarse y la eficiencia '
        'energetica sigue mejorando.',
  ),
  SdgGoal(
    number: 8,
    title: 'Decent Work and Economic Growth',
    shortTitle: 'Decent Work',
    description:
        'Promote sustained, inclusive and sustainable '
        'economic growth, full and productive '
        'employment and decent work for all. Roughly '
        "half the world's population still lives on "
        r'the equivalent of about US$2 a day. In many '
        'places, having a job does not guarantee the '
        'ability to escape from poverty. This slow and '
        'uneven progress requires us to rethink and '
        'retool our economic and social policies aimed '
        'at eradicating poverty.',
    color: Color(0xFFA31C44),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-08.jpg',
    isLearnOnly: true,
    titleJa: '働きがいも経済成長も',
    titleEs: 'Trabajo decente y crecimiento economico',
    shortTitleJa: '働きがいと成長',
    shortTitleEs: 'Trabajo decente',
    descriptionJa:
        'すべての人のための持続的、包摂的かつ持続可能'
        'な経済成長、完全かつ生産的な雇用およびディー'
        'セント・ワークを推進する。世界人口の約半数が'
        '1日約2ドル相当で暮らしています。多くの場所で'
        '、仕事があっても貧困から脱出できる保証はあり'
        'ません。この遅く不均等な進歩は、貧困撲滅を目'
        '指す経済・社会政策の再考を求めています。',
    descriptionEs:
        'Promover el crecimiento economico sostenido, '
        'inclusivo y sostenible, el empleo pleno y '
        'productivo y el trabajo decente para todos. '
        'Aproximadamente la mitad de la poblacion '
        'mundial vive con el equivalente a unos 2 '
        'dolares al dia. En muchos lugares, tener un '
        'empleo no garantiza poder escapar de la '
        'pobreza. Este progreso lento y desigual nos '
        'obliga a replantear nuestras politicas '
        'economicas y sociales.',
  ),
  SdgGoal(
    number: 9,
    title: 'Industry, Innovation and Infrastructure',
    shortTitle: 'Innovation',
    description:
        'Build resilient infrastructure, promote '
        'inclusive and sustainable industrialization '
        'and foster innovation. Investment in '
        'infrastructure and innovation are crucial '
        'drivers of economic growth and development. '
        'With over half the world population now '
        'living in cities, mass transport and '
        'renewable energy are becoming ever more '
        'important, as are the growth of new '
        'industries and information and communication '
        'technologies.',
    color: Color(0xFFF26A2D),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-09.jpg',
    isLearnOnly: true,
    titleJa: '産業と技術革新の基盤をつくろう',
    titleEs: 'Industria, innovacion e infraestructura',
    shortTitleJa: '技術革新',
    shortTitleEs: 'Innovacion',
    descriptionJa:
        '強靭なインフラを整備し、包摂的で持続可能な産'
        '業化を推進するとともに、技術革新の拡大を図る'
        '。インフラと技術革新への投資は、経済成長と開'
        '発の重要な推進力です。世界人口の半数以上が都'
        '市に住む現在、大量輸送と再生可能エネルギーは'
        'ますます重要になっています。',
    descriptionEs:
        'Construir infraestructuras resilientes, '
        'promover la industrializacion inclusiva y '
        'sostenible y fomentar la innovacion. La '
        'inversion en infraestructura e innovacion son '
        'motores cruciales del crecimiento economico. '
        'Con mas de la mitad de la poblacion mundial '
        'viviendo en ciudades, el transporte masivo y '
        'la energia renovable son cada vez mas '
        'importantes.',
  ),
  SdgGoal(
    number: 10,
    title: 'Reduced Inequalities',
    shortTitle: 'Equality',
    description:
        'Reduce inequality within and among countries. '
        'Income inequality is on the rise, with the '
        'richest 10% earning up to 40% of total '
        'global income. The poorest 10% earn only '
        '2-7% of total global income. In developing '
        'countries, inequality has increased by 11% '
        'if we take into account population growth. '
        'These widening disparities require sound '
        'policies to empower lower income earners.',
    color: Color(0xFFE01483),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-10.jpg',
    titleJa: '人や国の不平等をなくそう',
    titleEs: 'Reduccion de las desigualdades',
    shortTitleJa: '不平等の是正',
    shortTitleEs: 'Igualdad',
    descriptionJa:
        '国内および国家間の不平等を是正する。所得格差'
        'は拡大しており、最も裕福な10%が世界の総所得の'
        '最大40%を稼いでいます。最も貧しい10%は世界の'
        '総所得のわずか2-7%です。人口増加を考慮すると'
        '、開発途上国では不平等が11%増加しています。こ'
        'の拡大する格差には低所得者を支援する健全な政'
        '策が必要です。',
    descriptionEs:
        'Reducir la desigualdad en los paises y entre '
        'ellos. La desigualdad de ingresos esta en '
        'aumento, con el 10% mas rico ganando hasta '
        'el 40% del ingreso global total. El 10% mas '
        'pobre gana solo el 2-7%. En los paises en '
        'desarrollo, la desigualdad ha aumentado un '
        '11% considerando el crecimiento poblacional. '
        'Estas disparidades crecientes requieren '
        'politicas solidas para empoderar a los de '
        'menores ingresos.',
  ),
  SdgGoal(
    number: 11,
    title: 'Sustainable Cities and Communities',
    shortTitle: 'Sustainable Cities',
    description:
        'Make cities and human settlements inclusive, '
        'safe, resilient and sustainable. Cities are '
        'hubs for ideas, commerce, culture, science, '
        'productivity, social development and much '
        'more. At their best, cities have enabled '
        'people to advance socially and economically. '
        'However, many challenges exist to maintaining '
        'cities in a way that continues to create '
        'jobs and prosperity without straining land '
        'and resources.',
    color: Color(0xFFF89D2A),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-11.jpg',
    titleJa: '住み続けられるまちづくりを',
    titleEs: 'Ciudades y comunidades sostenibles',
    shortTitleJa: '持続可能な都市',
    shortTitleEs: 'Ciudades sostenibles',
    descriptionJa:
        '都市と人間の居住地を包摂的、安全、強靭かつ持'
        '続可能にする。都市はアイデア、商業、文化、科'
        '学、生産性、社会開発などの拠点です。都市は人'
        '々の社会的・経済的な発展を可能にしてきました'
        '。しかし、土地と資源に負担をかけずに雇用と繁'
        '栄を生み出し続ける都市を維持するには、多くの'
        '課題があります。',
    descriptionEs:
        'Lograr que las ciudades y los asentamientos '
        'humanos sean inclusivos, seguros, resilientes '
        'y sostenibles. Las ciudades son centros de '
        'ideas, comercio, cultura, ciencia y '
        'productividad. En su mejor expresion, han '
        'permitido a las personas avanzar social y '
        'economicamente. Sin embargo, existen muchos '
        'desafios para mantener ciudades que creen '
        'empleo y prosperidad sin agotar los recursos.',
  ),
  SdgGoal(
    number: 12,
    title: 'Responsible Consumption and Production',
    shortTitle: 'Responsible Consumption',
    description:
        'Ensure sustainable consumption and production '
        'patterns. Achieving economic growth and '
        'sustainable development requires that we '
        'urgently reduce our ecological footprint by '
        'changing the way we produce and consume goods '
        'and resources. Agriculture is the biggest '
        'user of water worldwide, and irrigation now '
        'claims close to 70% of all freshwater for '
        'human use.',
    color: Color(0xFFBF8D2C),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-12.jpg',
    titleJa: 'つくる責任つかう責任',
    titleEs: 'Produccion y consumo responsables',
    shortTitleJa: '責任ある消費と生産',
    shortTitleEs: 'Consumo responsable',
    descriptionJa:
        '持続可能な消費と生産のパターンを確保する。経'
        '済成長と持続可能な開発を達成するには、商品と'
        '資源の生産・消費方法を変えることで、エコロジ'
        'カル・フットプリントを早急に削減する必要があ'
        'ります。農業は世界最大の水使用者であり、灌漑'
        'は人間が使用する全淡水の約70%を占めています。',
    descriptionEs:
        'Garantizar modalidades de consumo y '
        'produccion sostenibles. Para lograr el '
        'crecimiento economico y el desarrollo '
        'sostenible es urgente reducir nuestra huella '
        'ecologica cambiando la forma en que '
        'producimos y consumimos bienes y recursos. '
        'La agricultura es el mayor consumidor de '
        'agua a nivel mundial y el riego representa '
        'cerca del 70% de toda el agua dulce para '
        'uso humano.',
  ),
  SdgGoal(
    number: 13,
    title: 'Climate Action',
    shortTitle: 'Climate Action',
    description:
        'Take urgent action to combat climate change '
        'and its impacts. Climate change affects every '
        'country on every continent. It is disrupting '
        'national economies and affecting lives and '
        'livelihoods. Weather patterns are changing, '
        'sea levels are rising, and weather events '
        'are becoming more extreme. Greenhouse gas '
        'emissions are now at their highest levels '
        'in history.',
    color: Color(0xFF407F46),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-13.jpg',
    titleJa: '気候変動に具体的な対策を',
    titleEs: 'Accion por el clima',
    shortTitleJa: '気候変動対策',
    shortTitleEs: 'Accion climatica',
    descriptionJa:
        '気候変動とその影響に立ち向かうため、緊急対策'
        'を取る。気候変動はすべての大陸のすべての国に'
        '影響を与えています。国の経済を混乱させ、生活'
        'と生計に影響を与えています。気象パターンは変'
        '化し、海面は上昇し、気象現象はより極端になっ'
        'ています。温室効果ガスの排出量は史上最高水準'
        'にあります。',
    descriptionEs:
        'Adoptar medidas urgentes para combatir el '
        'cambio climatico y sus efectos. El cambio '
        'climatico afecta a todos los paises de todos '
        'los continentes. Esta perturbando las '
        'economias nacionales y afectando vidas y '
        'medios de subsistencia. Los patrones '
        'meteorologicos estan cambiando, el nivel del '
        'mar esta subiendo y los eventos climaticos '
        'son cada vez mas extremos.',
  ),
  SdgGoal(
    number: 14,
    title: 'Life Below Water',
    shortTitle: 'Life Below Water',
    description:
        'Conserve and sustainably use the oceans, '
        'seas and marine resources for sustainable '
        'development. The oceans drive global systems '
        'that make the Earth habitable for humankind. '
        'Our rainwater, drinking water, weather, '
        'climate, coastlines, much of our food, and '
        'even the oxygen in the air we breathe, are '
        'all ultimately provided and regulated by the '
        'sea. Careful management of this essential '
        'global resource is a key feature of a '
        'sustainable future.',
    color: Color(0xFF1F97D4),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-14.jpg',
    titleJa: '海の豊かさを守ろう',
    titleEs: 'Vida submarina',
    shortTitleJa: '海の豊かさ',
    shortTitleEs: 'Vida submarina',
    descriptionJa:
        '海洋と海洋資源を持続可能な開発に向けて保全し'
        '、持続可能な形で利用する。海洋は地球を人類が'
        '住める場所にしている世界的なシステムを動かし'
        'ています。雨水、飲料水、天候、気候、海岸線、'
        '食料の多く、そして呼吸する空気中の酸素さえも'
        '、すべて最終的には海によって提供され調節され'
        'ています。',
    descriptionEs:
        'Conservar y utilizar sosteniblemente los '
        'oceanos, los mares y los recursos marinos '
        'para el desarrollo sostenible. Los oceanos '
        'impulsan los sistemas globales que hacen la '
        'Tierra habitable. Nuestra agua de lluvia, '
        'agua potable, clima, costas, gran parte de '
        'nuestros alimentos e incluso el oxigeno que '
        'respiramos son proporcionados y regulados '
        'por el mar.',
  ),
  SdgGoal(
    number: 15,
    title: 'Life on Land',
    shortTitle: 'Life on Land',
    description:
        'Protect, restore and promote sustainable use '
        'of terrestrial ecosystems, sustainably manage '
        'forests, combat desertification, and halt '
        'and reverse land degradation and halt '
        'biodiversity loss. Human life depends on the '
        'earth as much as the ocean for sustenance '
        'and livelihoods. Forests cover 30% of the '
        "Earth and provide vital habitats for millions "
        'of species and important sources for clean '
        'air and water.',
    color: Color(0xFF59BA48),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-15.jpg',
    titleJa: '陸の豊かさも守ろう',
    titleEs: 'Vida de ecosistemas terrestres',
    shortTitleJa: '陸の豊かさ',
    shortTitleEs: 'Vida terrestre',
    descriptionJa:
        '陸上生態系の保護、回復および持続可能な利用の'
        '推進、森林の持続可能な管理、砂漠化への対処、'
        '土地劣化の阻止および逆転、ならびに生物多様性'
        '損失の阻止を図る。人間の生活は食料と生計のた'
        'めに海と同様に陸地に依存しています。森林は地'
        '球の30%を覆い、数百万の種に重要な生息地を提'
        '供しています。',
    descriptionEs:
        'Proteger, restablecer y promover el uso '
        'sostenible de los ecosistemas terrestres, '
        'gestionar sosteniblemente los bosques, luchar '
        'contra la desertificacion, detener e invertir '
        'la degradacion de las tierras y detener la '
        'perdida de biodiversidad. Los bosques cubren '
        'el 30% de la Tierra y proporcionan habitats '
        'vitales para millones de especies.',
  ),
  SdgGoal(
    number: 16,
    title: 'Peace, Justice and Strong Institutions',
    shortTitle: 'Peace & Justice',
    description:
        'Promote peaceful and inclusive societies for '
        'sustainable development, provide access to '
        'justice for all and build effective, '
        'accountable and inclusive institutions at all '
        'levels. Conflict, insecurity, weak '
        'institutions and limited access to justice '
        'remain a great threat to sustainable '
        'development. Armed violence and insecurity '
        'have a destructive impact on development, '
        'affecting economic growth and often resulting '
        'in long-standing grievances.',
    color: Color(0xFF126A9F),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-16.jpg',
    isLearnOnly: true,
    titleJa: '平和と公正をすべての人に',
    titleEs: 'Paz, justicia e instituciones solidas',
    shortTitleJa: '平和と公正',
    shortTitleEs: 'Paz y justicia',
    descriptionJa:
        '持続可能な開発に向けて平和で包摂的な社会を推'
        '進し、すべての人に司法へのアクセスを提供し、'
        'あらゆるレベルにおいて効果的で責任ある包摂的'
        'な制度を構築する。紛争、不安定、脆弱な制度、'
        '限られた司法へのアクセスは、持続可能な開発に'
        '対する大きな脅威であり続けています。',
    descriptionEs:
        'Promover sociedades pacificas e inclusivas '
        'para el desarrollo sostenible, facilitar el '
        'acceso a la justicia para todos y construir '
        'instituciones eficaces, responsables e '
        'inclusivas a todos los niveles. Los '
        'conflictos, la inseguridad, las instituciones '
        'debiles y el acceso limitado a la justicia '
        'siguen siendo una gran amenaza para el '
        'desarrollo sostenible.',
  ),
  SdgGoal(
    number: 17,
    title: 'Partnerships for the Goals',
    shortTitle: 'Partnerships',
    description:
        'Strengthen the means of implementation and '
        'revitalize the Global Partnership for '
        'Sustainable Development. The SDGs can only '
        'be realized with strong global partnerships '
        'and cooperation. A successful development '
        'agenda requires inclusive partnerships '
        'between governments, the private sector and '
        'civil society. These partnerships built upon '
        'principles and values, a shared vision, and '
        'shared goals that place people and the '
        'planet at the centre.',
    color: Color(0xFF13496B),
    iconUrl:
        'https://sdgs.un.org/sites/default/files/'
        'goals/E_SDG_Icons-17.jpg',
    isLearnOnly: true,
    titleJa: 'パートナーシップで目標を達成しよう',
    titleEs: 'Alianzas para lograr los objetivos',
    shortTitleJa: 'パートナーシップ',
    shortTitleEs: 'Alianzas',
    descriptionJa:
        '持続可能な開発に向けて実施手段を強化し、グロ'
        'ーバル・パートナーシップを活性化する。SDGsは'
        '強力なグローバル・パートナーシップと協力によ'
        'ってのみ実現できます。成功する開発アジェンダ'
        'には、政府、民間セクター、市民社会の間の包摂'
        '的なパートナーシップが必要です。',
    descriptionEs:
        'Fortalecer los medios de implementacion y '
        'revitalizar la Alianza Mundial para el '
        'Desarrollo Sostenible. Los ODS solo pueden '
        'lograrse con alianzas mundiales solidas y '
        'cooperacion. Una agenda de desarrollo exitosa '
        'requiere alianzas inclusivas entre gobiernos, '
        'el sector privado y la sociedad civil, '
        'construidas sobre principios, valores y '
        'objetivos compartidos.',
  ),
];

/// O(1) lookup by goal number.
final Map<int, SdgGoal> sdgGoalMap = {
  for (final g in sdgGoals) g.number: g,
};
