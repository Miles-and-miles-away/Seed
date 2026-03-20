/// Daily and multi-day challenge template definitions.
library;

/// A single-day challenge targeting one action category.
class DailyChallengeTemplate {
  const DailyChallengeTemplate({
    required this.id,
    required this.category,
    required this.titleEn,
    required this.titleEs,
    required this.titleJa,
  });

  final String id;
  final String category;
  final String titleEn;
  final String titleEs;
  final String titleJa;

  String title(String locale) {
    return switch (locale) {
      'es' => titleEs,
      'ja' => titleJa,
      _ => titleEn,
    };
  }
}

/// A multi-day challenge spanning several consecutive days.
class MultiDayChallengeTemplate {
  const MultiDayChallengeTemplate({
    required this.id,
    required this.category,
    required this.targetDays,
    required this.titleEn,
    required this.titleEs,
    required this.titleJa,
    required this.descriptionEn,
    required this.descriptionEs,
    required this.descriptionJa,
  });

  final String id;
  final String? category;
  final int targetDays;
  final String titleEn;
  final String titleEs;
  final String titleJa;
  final String descriptionEn;
  final String descriptionEs;
  final String descriptionJa;

  String title(String locale) {
    return switch (locale) {
      'es' => titleEs,
      'ja' => titleJa,
      _ => titleEn,
    };
  }

  String description(String locale) {
    return switch (locale) {
      'es' => descriptionEs,
      'ja' => descriptionJa,
      _ => descriptionEn,
    };
  }
}

/// 27 daily challenge templates (3 per ActionCategory).
const dailyChallengeTemplates = <DailyChallengeTemplate>[
  // Recycling
  DailyChallengeTemplate(
    id: 'recycling_1',
    category: 'recycling',
    titleEn: 'Log a Recycling action today',
    titleEs: 'Registra una accion de Reciclaje hoy',
    titleJa: '今日リサイクルのアクションを記録しよう',
  ),
  DailyChallengeTemplate(
    id: 'recycling_2',
    category: 'recycling',
    titleEn: 'Recycle something today',
    titleEs: 'Recicla algo hoy',
    titleJa: '今日何かをリサイクルしよう',
  ),
  DailyChallengeTemplate(
    id: 'recycling_3',
    category: 'recycling',
    titleEn: 'Sort your waste today',
    titleEs: 'Separa tus residuos hoy',
    titleJa: '今日ごみを分別しよう',
  ),

  // Transport
  DailyChallengeTemplate(
    id: 'transport_1',
    category: 'transport',
    titleEn: 'Choose green transport today',
    titleEs: 'Elige transporte ecologico hoy',
    titleJa: '今日エコな移動手段を選ぼう',
  ),
  DailyChallengeTemplate(
    id: 'transport_2',
    category: 'transport',
    titleEn: 'Walk or bike somewhere today',
    titleEs: 'Camina o usa la bicicleta hoy',
    titleJa: '今日は歩くか自転車で移動しよう',
  ),
  DailyChallengeTemplate(
    id: 'transport_3',
    category: 'transport',
    titleEn: 'Take public transit today',
    titleEs: 'Usa el transporte publico hoy',
    titleJa: '今日は公共交通機関を使おう',
  ),

  // Food
  DailyChallengeTemplate(
    id: 'food_1',
    category: 'food',
    titleEn: 'Log a Food action today',
    titleEs: 'Registra una accion de Alimentacion hoy',
    titleJa: '今日食事のアクションを記録しよう',
  ),
  DailyChallengeTemplate(
    id: 'food_2',
    category: 'food',
    titleEn: 'Eat a plant-based meal today',
    titleEs: 'Come una comida vegetal hoy',
    titleJa: '今日は植物ベースの食事をしよう',
  ),
  DailyChallengeTemplate(
    id: 'food_3',
    category: 'food',
    titleEn: 'Reduce food waste today',
    titleEs: 'Reduce el desperdicio de comida hoy',
    titleJa: '今日は食品ロスを減らそう',
  ),

  // Energy
  DailyChallengeTemplate(
    id: 'energy_1',
    category: 'energy',
    titleEn: 'Save energy today',
    titleEs: 'Ahorra energia hoy',
    titleJa: '今日はエネルギーを節約しよう',
  ),
  DailyChallengeTemplate(
    id: 'energy_2',
    category: 'energy',
    titleEn: 'Unplug unused devices today',
    titleEs: 'Desenchufa dispositivos sin usar hoy',
    titleJa: '今日は使っていない機器のプラグを抜こう',
  ),
  DailyChallengeTemplate(
    id: 'energy_3',
    category: 'energy',
    titleEn: 'Log an Energy action today',
    titleEs: 'Registra una accion de Energia hoy',
    titleJa: '今日エネルギーのアクションを記録しよう',
  ),

  // Consumption
  DailyChallengeTemplate(
    id: 'consumption_1',
    category: 'consumption',
    titleEn: 'Make a sustainable choice today',
    titleEs: 'Haz una eleccion sostenible hoy',
    titleJa: '今日はサステナブルな選択をしよう',
  ),
  DailyChallengeTemplate(
    id: 'consumption_2',
    category: 'consumption',
    titleEn: 'Use a reusable item today',
    titleEs: 'Usa un articulo reutilizable hoy',
    titleJa: '今日は再利用可能なアイテムを使おう',
  ),
  DailyChallengeTemplate(
    id: 'consumption_3',
    category: 'consumption',
    titleEn: 'Log a Consumption action today',
    titleEs: 'Registra una accion de Consumo hoy',
    titleJa: '今日消費のアクションを記録しよう',
  ),

  // Water
  DailyChallengeTemplate(
    id: 'water_1',
    category: 'water',
    titleEn: 'Save water today',
    titleEs: 'Ahorra agua hoy',
    titleJa: '今日は水を節約しよう',
  ),
  DailyChallengeTemplate(
    id: 'water_2',
    category: 'water',
    titleEn: 'Take a shorter shower today',
    titleEs: 'Toma una ducha mas corta hoy',
    titleJa: '今日は短めのシャワーにしよう',
  ),
  DailyChallengeTemplate(
    id: 'water_3',
    category: 'water',
    titleEn: 'Log a Water action today',
    titleEs: 'Registra una accion de Agua hoy',
    titleJa: '今日水のアクションを記録しよう',
  ),

  // Community
  DailyChallengeTemplate(
    id: 'community_1',
    category: 'community',
    titleEn: 'Do something for your community today',
    titleEs: 'Haz algo por tu comunidad hoy',
    titleJa: '今日はコミュニティのために何かしよう',
  ),
  DailyChallengeTemplate(
    id: 'community_2',
    category: 'community',
    titleEn: 'Log a Community action today',
    titleEs: 'Registra una accion de Comunidad hoy',
    titleJa: '今日コミュニティのアクションを記録しよう',
  ),
  DailyChallengeTemplate(
    id: 'community_3',
    category: 'community',
    titleEn: 'Help a neighbor or local cause today',
    titleEs: 'Ayuda a un vecino o causa local hoy',
    titleJa: '今日は近所の人や地域の活動を手伝おう',
  ),

  // Advocacy
  DailyChallengeTemplate(
    id: 'advocacy_1',
    category: 'advocacy',
    titleEn: 'Advocate for sustainability today',
    titleEs: 'Aboga por la sostenibilidad hoy',
    titleJa: '今日はサステナビリティを推進しよう',
  ),
  DailyChallengeTemplate(
    id: 'advocacy_2',
    category: 'advocacy',
    titleEn: 'Share eco-knowledge today',
    titleEs: 'Comparte conocimiento ecologico hoy',
    titleJa: '今日はエコ知識を共有しよう',
  ),
  DailyChallengeTemplate(
    id: 'advocacy_3',
    category: 'advocacy',
    titleEn: 'Log an Advocacy action today',
    titleEs: 'Registra una accion de Defensa hoy',
    titleJa: '今日アドボカシーのアクションを記録しよう',
  ),

  // Learning
  DailyChallengeTemplate(
    id: 'learning_1',
    category: 'learning',
    titleEn: 'Learn something about sustainability',
    titleEs: 'Aprende algo sobre sostenibilidad',
    titleJa: 'サステナビリティについて学ぼう',
  ),
  DailyChallengeTemplate(
    id: 'learning_2',
    category: 'learning',
    titleEn: 'Log a Learning action today',
    titleEs: 'Registra una accion de Aprendizaje hoy',
    titleJa: '今日学習のアクションを記録しよう',
  ),
  DailyChallengeTemplate(
    id: 'learning_3',
    category: 'learning',
    titleEn: 'Explore an SDG topic today',
    titleEs: 'Explora un tema de ODS hoy',
    titleJa: '今日はSDGのテーマを探ろう',
  ),
];

/// 6 multi-day challenge templates.
const multiDayChallengeTemplates = <MultiDayChallengeTemplate>[
  MultiDayChallengeTemplate(
    id: 'md_vegan_week',
    category: 'food',
    targetDays: 7,
    titleEn: 'Vegan Week',
    titleEs: 'Semana Vegana',
    titleJa: 'ヴィーガンウィーク',
    descriptionEn: 'Log a Food action every day for 7 days.',
    descriptionEs:
        'Registra una accion de Alimentacion cada dia durante 7 dias.',
    descriptionJa: '7日間毎日食事のアクションを記録しよう。',
  ),
  MultiDayChallengeTemplate(
    id: 'md_veganuary',
    category: 'food',
    targetDays: 30,
    titleEn: 'Veganuary',
    titleEs: 'Veganuary',
    titleJa: 'ヴィーガニュアリー',
    descriptionEn: 'Log a Food action every day for 30 days.',
    descriptionEs:
        'Registra una accion de Alimentacion cada dia durante 30 dias.',
    descriptionJa: '30日間毎日食事のアクションを記録しよう。',
  ),
  MultiDayChallengeTemplate(
    id: 'md_zero_waste_week',
    category: 'recycling',
    targetDays: 7,
    titleEn: 'Zero Waste Week',
    titleEs: 'Semana Basura Cero',
    titleJa: 'ゼロウェイストウィーク',
    descriptionEn: 'Log a Recycling action every day for 7 days.',
    descriptionEs: 'Registra una accion de Reciclaje cada dia durante 7 dias.',
    descriptionJa: '7日間毎日リサイクルのアクションを記録しよう。',
  ),
  MultiDayChallengeTemplate(
    id: 'md_transport_week',
    category: 'transport',
    targetDays: 7,
    titleEn: 'Green Transport Week',
    titleEs: 'Semana de Transporte Verde',
    titleJa: 'グリーン交通ウィーク',
    descriptionEn: 'Log a Transport action every day for 7 days.',
    descriptionEs: 'Registra una accion de Transporte cada dia durante 7 dias.',
    descriptionJa: '7日間毎日交通のアクションを記録しよう。',
  ),
  MultiDayChallengeTemplate(
    id: 'md_streak_14',
    category: null,
    targetDays: 14,
    titleEn: 'Two-Week Streak',
    titleEs: 'Racha de Dos Semanas',
    titleJa: '2週間チャレンジ',
    descriptionEn: 'Log any action every day for 14 days.',
    descriptionEs: 'Registra cualquier accion cada dia durante 14 dias.',
    descriptionJa: '14日間毎日何かのアクションを記録しよう。',
  ),
  MultiDayChallengeTemplate(
    id: 'md_streak_30',
    category: null,
    targetDays: 30,
    titleEn: 'Monthly Momentum',
    titleEs: 'Impulso Mensual',
    titleJa: '月間モメンタム',
    descriptionEn: 'Log any action every day for 30 days.',
    descriptionEs: 'Registra cualquier accion cada dia durante 30 dias.',
    descriptionJa: '30日間毎日何かのアクションを記録しよう。',
  ),
];
