/// A single external resource link for an SDG.
class SdgResource {
  const SdgResource({
    required this.titleEn,
    required this.titleJa,
    required this.titleEs,
    required this.url,
    required this.type,
  });

  final String titleEn;
  final String titleJa;
  final String titleEs;
  final String url;
  final SdgResourceType type;

  String title(String languageCode) {
    return switch (languageCode) {
      'ja' => titleJa,
      'es' => titleEs,
      _ => titleEn,
    };
  }
}

enum SdgResourceType { official, action, education }

/// External resources for each SDG.
const sdgResources = <int, List<SdgResource>>{
  1: [
    SdgResource(
      titleEn: 'UN SDG 1: No Poverty',
      titleJa: 'UN SDG 1: 貧困をなくそう',
      titleEs: 'ODS 1: Fin de la pobreza',
      url: 'https://sdgs.un.org/goals/goal1',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'How to Help End Poverty',
      titleJa: '貧困をなくすためにできること',
      titleEs: 'Como ayudar a acabar con la pobreza',
      url: 'https://www.un.org/en/actnow',
      type: SdgResourceType.action,
    ),
  ],
  2: [
    SdgResource(
      titleEn: 'UN SDG 2: Zero Hunger',
      titleJa: 'UN SDG 2: 飢餓をゼロに',
      titleEs: 'ODS 2: Hambre cero',
      url: 'https://sdgs.un.org/goals/goal2',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Reduce Food Waste at Home',
      titleJa: '家庭での食品ロスを減らす',
      titleEs: 'Reducir el desperdicio de alimentos',
      url: 'https://www.fao.org/food-loss-reduction/en/',
      type: SdgResourceType.action,
    ),
  ],
  3: [
    SdgResource(
      titleEn: 'UN SDG 3: Good Health',
      titleJa: 'UN SDG 3: すべての人に健康と福祉を',
      titleEs: 'ODS 3: Salud y bienestar',
      url: 'https://sdgs.un.org/goals/goal3',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Active Transport & Health Benefits',
      titleJa: 'アクティブな移動と健康効果',
      titleEs: 'Transporte activo y beneficios para la salud',
      url: 'https://www.who.int/news-room/fact-sheets/detail/physical-activity',
      type: SdgResourceType.education,
    ),
  ],
  4: [
    SdgResource(
      titleEn: 'UN SDG 4: Quality Education',
      titleJa: 'UN SDG 4: 質の高い教育をみんなに',
      titleEs: 'ODS 4: Educacion de calidad',
      url: 'https://sdgs.un.org/goals/goal4',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Support Education Worldwide',
      titleJa: '世界の教育を支援する',
      titleEs: 'Apoyar la educacion mundial',
      url: 'https://www.globalpartnership.org/',
      type: SdgResourceType.action,
    ),
  ],
  5: [
    SdgResource(
      titleEn: 'UN SDG 5: Gender Equality',
      titleJa: 'UN SDG 5: ジェンダー平等を実現しよう',
      titleEs: 'ODS 5: Igualdad de genero',
      url: 'https://sdgs.un.org/goals/goal5',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Take Action for Gender Equality',
      titleJa: 'ジェンダー平等のために行動する',
      titleEs: 'Actuar por la igualdad de genero',
      url: 'https://www.unwomen.org/en',
      type: SdgResourceType.action,
    ),
  ],
  6: [
    SdgResource(
      titleEn: 'UN SDG 6: Clean Water',
      titleJa: 'UN SDG 6: 安全な水とトイレを世界中に',
      titleEs: 'ODS 6: Agua limpia y saneamiento',
      url: 'https://sdgs.un.org/goals/goal6',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Water Conservation Tips',
      titleJa: '節水のコツ',
      titleEs: 'Consejos para ahorrar agua',
      url: 'https://www.epa.gov/watersense',
      type: SdgResourceType.action,
    ),
  ],
  7: [
    SdgResource(
      titleEn: 'UN SDG 7: Clean Energy',
      titleJa: 'UN SDG 7: エネルギーをみんなにそしてクリーンに',
      titleEs: 'ODS 7: Energia asequible y no contaminante',
      url: 'https://sdgs.un.org/goals/goal7',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Home Energy Saving Guide',
      titleJa: '家庭の省エネガイド',
      titleEs: 'Guia de ahorro de energia en el hogar',
      url: 'https://www.energy.gov/energysaver',
      type: SdgResourceType.action,
    ),
  ],
  8: [
    SdgResource(
      titleEn: 'UN SDG 8: Decent Work',
      titleJa: 'UN SDG 8: 働きがいも経済成長も',
      titleEs: 'ODS 8: Trabajo decente y crecimiento economico',
      url: 'https://sdgs.un.org/goals/goal8',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Support Fair Trade',
      titleJa: 'フェアトレードを支援する',
      titleEs: 'Apoyar el comercio justo',
      url: 'https://www.fairtrade.net/',
      type: SdgResourceType.action,
    ),
  ],
  9: [
    SdgResource(
      titleEn: 'UN SDG 9: Innovation',
      titleJa: 'UN SDG 9: 産業と技術革新の基盤をつくろう',
      titleEs: 'ODS 9: Industria, innovacion e infraestructura',
      url: 'https://sdgs.un.org/goals/goal9',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Green Innovation Resources',
      titleJa: 'グリーンイノベーションリソース',
      titleEs: 'Recursos de innovacion verde',
      url: 'https://www.unido.org/',
      type: SdgResourceType.education,
    ),
  ],
  10: [
    SdgResource(
      titleEn: 'UN SDG 10: Reduced Inequalities',
      titleJa: 'UN SDG 10: 人や国の不平等をなくそう',
      titleEs: 'ODS 10: Reduccion de las desigualdades',
      url: 'https://sdgs.un.org/goals/goal10',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Fight Inequality',
      titleJa: '不平等と闘う',
      titleEs: 'Luchar contra la desigualdad',
      url: 'https://www.oxfam.org/',
      type: SdgResourceType.action,
    ),
  ],
  11: [
    SdgResource(
      titleEn: 'UN SDG 11: Sustainable Cities',
      titleJa: 'UN SDG 11: 住み続けられるまちづくりを',
      titleEs: 'ODS 11: Ciudades y comunidades sostenibles',
      url: 'https://sdgs.un.org/goals/goal11',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Green City Living Guide',
      titleJa: 'グリーンシティ生活ガイド',
      titleEs: 'Guia de vida en ciudades verdes',
      url: 'https://www.c40.org/',
      type: SdgResourceType.action,
    ),
  ],
  12: [
    SdgResource(
      titleEn: 'UN SDG 12: Responsible Consumption',
      titleJa: 'UN SDG 12: つくる責任つかう責任',
      titleEs: 'ODS 12: Produccion y consumo responsables',
      url: 'https://sdgs.un.org/goals/goal12',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Sustainable Living Tips',
      titleJa: 'サステナブルな生活のコツ',
      titleEs: 'Consejos para una vida sostenible',
      url: 'https://www.oneplanetnetwork.org/',
      type: SdgResourceType.action,
    ),
  ],
  13: [
    SdgResource(
      titleEn: 'UN SDG 13: Climate Action',
      titleJa: 'UN SDG 13: 気候変動に具体的な対策を',
      titleEs: 'ODS 13: Accion por el clima',
      url: 'https://sdgs.un.org/goals/goal13',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Calculate Your Carbon Footprint',
      titleJa: 'カーボンフットプリントを計算する',
      titleEs: 'Calcula tu huella de carbono',
      url: 'https://www.carbonfootprint.com/',
      type: SdgResourceType.action,
    ),
  ],
  14: [
    SdgResource(
      titleEn: 'UN SDG 14: Life Below Water',
      titleJa: 'UN SDG 14: 海の豊かさを守ろう',
      titleEs: 'ODS 14: Vida submarina',
      url: 'https://sdgs.un.org/goals/goal14',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Reduce Ocean Plastic Pollution',
      titleJa: '海洋プラスチック汚染を減らす',
      titleEs: 'Reducir la contaminacion plastica del oceano',
      url: 'https://www.oceanconservancy.org/',
      type: SdgResourceType.action,
    ),
  ],
  15: [
    SdgResource(
      titleEn: 'UN SDG 15: Life on Land',
      titleJa: 'UN SDG 15: 陸の豊かさも守ろう',
      titleEs: 'ODS 15: Vida de ecosistemas terrestres',
      url: 'https://sdgs.un.org/goals/goal15',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Plant Trees & Protect Forests',
      titleJa: '木を植えて森を守ろう',
      titleEs: 'Plantar arboles y proteger los bosques',
      url: 'https://www.plant-for-the-planet.org/',
      type: SdgResourceType.action,
    ),
  ],
  16: [
    SdgResource(
      titleEn: 'UN SDG 16: Peace & Justice',
      titleJa: 'UN SDG 16: 平和と公正をすべての人に',
      titleEs: 'ODS 16: Paz, justicia e instituciones solidas',
      url: 'https://sdgs.un.org/goals/goal16',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Promote Peace & Justice',
      titleJa: '平和と公正を推進する',
      titleEs: 'Promover la paz y la justicia',
      url: 'https://www.un.org/ruleoflaw/',
      type: SdgResourceType.action,
    ),
  ],
  17: [
    SdgResource(
      titleEn: 'UN SDG 17: Partnerships',
      titleJa: 'UN SDG 17: パートナーシップで目標を達成しよう',
      titleEs: 'ODS 17: Alianzas para lograr los objetivos',
      url: 'https://sdgs.un.org/goals/goal17',
      type: SdgResourceType.official,
    ),
    SdgResource(
      titleEn: 'Join the Global Goals Movement',
      titleJa: 'グローバルゴールズ運動に参加する',
      titleEs: 'Unete al movimiento de los Objetivos Globales',
      url: 'https://www.globalgoals.org/',
      type: SdgResourceType.action,
    ),
  ],
};
