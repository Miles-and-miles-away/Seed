// Japanese/Spanish text doesn't use spaces between words
// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'dart:ui';

/// A section of a legal document with a title and body.
class LegalSection {
  const LegalSection({required this.title, required this.body});

  final String title;
  final String body;
}

/// A legal document with localized sections and shared metadata.
class LegalDocument {
  const LegalDocument._({
    required List<LegalSection> en,
    required List<LegalSection> ja,
    required List<LegalSection> es,
  })  : _en = en,
        _ja = ja,
        _es = es;

  final List<LegalSection> _en;
  final List<LegalSection> _ja;
  final List<LegalSection> _es;

  String get lastUpdated => _lastUpdated;
  String get contactEmail => _contactEmail;

  /// Sections for [locale], falling back to English.
  List<LegalSection> forLocale(Locale locale) {
    return switch (locale.languageCode) {
      'ja' => _ja,
      'es' => _es,
      _ => _en,
    };
  }
}

const _lastUpdated = '2026-02-14';
const _contactEmail = 'support@seedhabit.app';

/// Privacy policy content per locale.
const privacyPolicyContent = LegalDocument._(
  en: _privacyEn,
  ja: _privacyJa,
  es: _privacyEs,
);

/// Terms of service content per locale.
const termsOfServiceContent = LegalDocument._(
  en: _termsEn,
  ja: _termsJa,
  es: _termsEs,
);

const _privacyEn = [
  LegalSection(
    title: 'Key Points',
    body: '- We collect your email, display name, '
        'and action history\n'
        '- Data is stored securely on Firebase '
        '(Google Cloud)\n'
        '- We never sell or share your data with '
        'third parties\n'
        '- You can delete your account and all '
        'data at any time\n'
        '- Anonymous analytics can be opted out '
        'in settings',
  ),
  LegalSection(
    title: 'Introduction',
    body: 'Seed ("we", "our", or "us") operates the Seed '
        'mobile application. This Privacy Policy explains '
        'how we collect, use, and protect your personal '
        'information when you use our app.',
  ),
  LegalSection(
    title: 'Information We Collect',
    body: 'We collect the following information:\n\n'
        '- Email address (for account creation '
        'and authentication)\n'
        '- Display name (optional, shown in your profile)\n'
        '- Action log history (sustainability actions you '
        'record)\n'
        '- Device push notification token (for sending '
        'reminders)\n'
        '- Anonymous usage analytics (app feature usage, '
        'crash reports)',
  ),
  LegalSection(
    title: 'How We Use Your Information',
    body: 'Your information is used to:\n\n'
        '- Authenticate your account and provide '
        'access to the app\n'
        '- Track your sustainability actions and calculate '
        'your environmental impact\n'
        '- Send push notifications and daily reminders '
        '(with your permission)\n'
        '- Improve app performance and fix bugs through '
        'anonymous analytics\n'
        '- Display your progress, streaks, and mascot '
        'evolution',
  ),
  LegalSection(
    title: 'Data Storage and Security',
    body: 'Your data is stored securely on Firebase '
        '(Google Cloud) servers. We use industry-standard '
        'security measures including encrypted '
        'connections (TLS/SSL), Firebase Security Rules '
        'to restrict data access, and authentication '
        'tokens to protect your account.',
  ),
  LegalSection(
    title: 'Third-Party Services',
    body: 'We use the following third-party services:\n\n'
        '- Firebase Authentication (account management)\n'
        '- Cloud Firestore (data storage)\n'
        '- Firebase Cloud Messaging (push notifications)\n'
        '- Firebase Analytics (anonymous usage data)\n'
        '- Firebase Crashlytics (crash reporting)\n'
        '- RevenueCat (subscription management)\n\n'
        'These services have their own privacy policies. '
        'We do not sell or share your personal data with '
        'any other third parties.',
  ),
  LegalSection(
    title: "Children's Privacy",
    body: 'Seed is not directed at children under the age '
        'of 13. We do not knowingly collect personal '
        'information from children under 13. If you are a '
        'parent and believe your child has provided us '
        'with personal information, please contact us so '
        'we can delete it.',
  ),
  LegalSection(
    title: 'Your Rights',
    body: 'You have the right to:\n\n'
        '- Access your personal data at any time through '
        'the app\n'
        '- Delete your account and all associated data '
        'from Settings > Account\n'
        '- Opt out of push notifications through your '
        'device settings\n'
        '- Opt out of analytics data collection through '
        'the app settings\n\n'
        'When you delete your account, all your data '
        'including action history, mascot progress, and '
        'profile information is permanently removed from '
        'our servers.',
  ),
  LegalSection(
    title: 'Changes to This Policy',
    body: 'We may update this Privacy Policy from time to '
        'time. We will notify you of significant changes '
        'through the app or via email. Continued use of '
        'the app after changes constitutes acceptance of '
        'the updated policy.',
  ),
  LegalSection(
    title: 'Contact Us',
    body: 'If you have questions about this Privacy Policy '
        'or your personal data, please contact us at '
        '$_contactEmail.',
  ),
];

const _privacyJa = [
  LegalSection(
    title: '要点',
    body: '- メールアドレス、表示名、'
        'アクション履歴を収集します\n'
        '- データはFirebase（Google Cloud）に'
        '安全に保存されます\n'
        '- お客様のデータを第三者に販売・'
        '共有することはありません\n'
        '- いつでもアカウントとデータを'
        '削除できます\n'
        '- 匿名分析は設定からオプトアウトできます',
  ),
  LegalSection(
    title: 'はじめに',
    body: 'Seed（以下「当社」）は、Seedモバイル'
        'アプリケーションを運営しています。'
        'このプライバシーポリシーは、アプリの利用時に'
        '当社がどのように個人情報を収集、使用、'
        '保護するかを説明するものです。',
  ),
  LegalSection(
    title: '収集する情報',
    body: '当社は以下の情報を収集します：\n\n'
        '- メールアドレス（アカウント作成および認証用）\n'
        '- 表示名（任意、プロフィールに表示）\n'
        '- アクション履歴（記録されたサステナビリティ活動）\n'
        '- デバイスプッシュ通知トークン（リマインダー送信用）\n'
        '- 匿名の利用分析データ（アプリ機能の使用状況、クラッシュレポート）',
  ),
  LegalSection(
    title: '情報の利用方法',
    body: 'お客様の情報は以下の目的で使用されます：\n\n'
        '- アカウントの認証とアプリへのアクセス提供\n'
        '- サステナビリティ活動の追跡と環境への影響の計算\n'
        '- プッシュ通知と毎日のリマインダーの送信（許可を得た場合）\n'
        '- 匿名分析によるアプリパフォーマンスの向上とバグの修正\n'
        '- 進捗、連続記録、マスコットの進化の表示',
  ),
  LegalSection(
    title: 'データの保存とセキュリティ',
    body: 'お客様のデータはFirebase（Google Cloud）'
        'サーバーに安全に保存されます。'
        '暗号化された接続（TLS/SSL）、'
        'Firebaseセキュリティルールによるデータアクセス'
        '制限、認証トークンによるアカウント保護など、'
        '業界標準のセキュリティ対策を使用しています。',
  ),
  LegalSection(
    title: 'サードパーティサービス',
    body: '当社は以下のサードパーティサービスを使用しています：\n\n'
        '- Firebase Authentication（アカウント管理）\n'
        '- Cloud Firestore（データ保存）\n'
        '- Firebase Cloud Messaging（プッシュ通知）\n'
        '- Firebase Analytics（匿名利用データ）\n'
        '- Firebase Crashlytics（クラッシュレポート）\n'
        '- RevenueCat（サブスクリプション管理）\n\n'
        'これらのサービスには独自のプライバシーポリシーがあります。'
        '当社はお客様の個人データを他の第三者に販売または共有することはありません。',
  ),
  LegalSection(
    title: '子供のプライバシー',
    body: 'Seedは13歳未満の子供を対象としていません。'
        '13歳未満の子供から故意に個人情報を収集する'
        'ことはありません。保護者の方で、お子様が'
        '当社に個人情報を提供したと思われる場合は、'
        '削除のためにご連絡ください。',
  ),
  LegalSection(
    title: 'お客様の権利',
    body: 'お客様には以下の権利があります：\n\n'
        '- アプリを通じていつでも個人データにアクセス\n'
        '- 設定 > アカウントからアカウントと関連データをすべて削除\n'
        '- デバイス設定からプッシュ通知をオプトアウト\n'
        '- アプリ設定から分析データ収集をオプトアウト\n\n'
        'アカウントを削除すると、アクション履歴、'
        'マスコットの進捗、プロフィール情報を含む'
        'すべてのデータがサーバーから完全に削除されます。',
  ),
  LegalSection(
    title: 'ポリシーの変更',
    body: '当社はこのプライバシーポリシーを随時更新する'
        '場合があります。重要な変更については、アプリ内'
        'またはメールでお知らせします。変更後もアプリを'
        '継続して使用することは、更新されたポリシーへの'
        '同意を意味します。',
  ),
  LegalSection(
    title: 'お問い合わせ',
    body: 'このプライバシーポリシーまたは個人データに'
        'ついてご質問がある場合は、$_contactEmail '
        'までご連絡ください。',
  ),
];

const _privacyEs = [
  LegalSection(
    title: 'Puntos clave',
    body: '- Recopilamos su correo electronico, '
        'nombre de usuario e historial de acciones\n'
        '- Los datos se almacenan de forma segura '
        'en Firebase (Google Cloud)\n'
        '- Nunca vendemos ni compartimos sus datos '
        'con terceros\n'
        '- Puede eliminar su cuenta y todos sus '
        'datos en cualquier momento\n'
        '- Los analisis anonimos se pueden '
        'desactivar en los ajustes',
  ),
  LegalSection(
    title: 'Introduccion',
    body: 'Seed ("nosotros" o "nuestro") opera la '
        'aplicacion movil Seed. Esta Politica de '
        'Privacidad explica como recopilamos, usamos y '
        'protegemos su informacion personal cuando '
        'utiliza nuestra aplicacion.',
  ),
  LegalSection(
    title: 'Informacion que recopilamos',
    body: 'Recopilamos la siguiente informacion:\n\n'
        '- Direccion de correo electronico (para la '
        'creacion de cuenta y autenticacion)\n'
        '- Nombre de usuario (opcional, mostrado en '
        'su perfil)\n'
        '- Historial de acciones (actividades de '
        'sostenibilidad registradas)\n'
        '- Token de notificaciones push del dispositivo '
        '(para enviar recordatorios)\n'
        '- Datos anonimos de uso (uso de funciones '
        'de la aplicacion, informes de errores)',
  ),
  LegalSection(
    title: 'Como usamos su informacion',
    body: 'Su informacion se utiliza para:\n\n'
        '- Autenticar su cuenta y proporcionar acceso '
        'a la aplicacion\n'
        '- Rastrear sus acciones de sostenibilidad y '
        'calcular su impacto ambiental\n'
        '- Enviar notificaciones push y recordatorios '
        'diarios (con su permiso)\n'
        '- Mejorar el rendimiento de la aplicacion y '
        'corregir errores mediante analisis anonimos\n'
        '- Mostrar su progreso, rachas y evolucion '
        'de mascota',
  ),
  LegalSection(
    title: 'Almacenamiento y seguridad de datos',
    body: 'Sus datos se almacenan de forma segura en '
        'servidores de Firebase (Google Cloud). '
        'Utilizamos medidas de seguridad estandar de la '
        'industria, incluyendo conexiones cifradas '
        '(TLS/SSL), reglas de seguridad de Firebase para '
        'restringir el acceso a los datos y tokens de '
        'autenticacion para proteger su cuenta.',
  ),
  LegalSection(
    title: 'Servicios de terceros',
    body: 'Utilizamos los siguientes servicios de '
        'terceros:\n\n'
        '- Firebase Authentication (gestion de cuentas)\n'
        '- Cloud Firestore (almacenamiento de datos)\n'
        '- Firebase Cloud Messaging '
        '(notificaciones push)\n'
        '- Firebase Analytics (datos de uso anonimos)\n'
        '- Firebase Crashlytics (informes de errores)\n'
        '- RevenueCat (gestion de suscripciones)\n\n'
        'Estos servicios tienen sus propias politicas de '
        'privacidad. No vendemos ni compartimos sus datos '
        'personales con otros terceros.',
  ),
  LegalSection(
    title: 'Privacidad de los menores',
    body: 'Seed no esta dirigida a menores de 13 anos. '
        'No recopilamos intencionalmente informacion '
        'personal de menores de 13 anos. Si usted es '
        'padre o tutor y cree que su hijo nos ha '
        'proporcionado informacion personal, contactenos '
        'para que podamos eliminarla.',
  ),
  LegalSection(
    title: 'Sus derechos',
    body: 'Usted tiene derecho a:\n\n'
        '- Acceder a sus datos personales en cualquier '
        'momento a traves de la aplicacion\n'
        '- Eliminar su cuenta y todos los datos asociados '
        'desde Ajustes > Cuenta\n'
        '- Desactivar las notificaciones push desde la '
        'configuracion de su dispositivo\n'
        '- Desactivar la recopilacion de datos analiticos '
        'desde los ajustes de la aplicacion\n\n'
        'Cuando elimina su cuenta, todos sus datos, '
        'incluyendo historial de acciones, progreso de '
        'mascota e informacion de perfil, se eliminan '
        'permanentemente de nuestros servidores.',
  ),
  LegalSection(
    title: 'Cambios en esta politica',
    body: 'Podemos actualizar esta Politica de Privacidad '
        'periodicamente. Le notificaremos sobre cambios '
        'significativos a traves de la aplicacion o por '
        'correo electronico. El uso continuado de la '
        'aplicacion despues de los cambios constituye la '
        'aceptacion de la politica actualizada.',
  ),
  LegalSection(
    title: 'Contactenos',
    body: 'Si tiene preguntas sobre esta Politica de '
        'Privacidad o sus datos personales, contactenos '
        'en $_contactEmail.',
  ),
];

const _termsEn = [
  LegalSection(
    title: 'Key Points',
    body: '- You must create an account to use Seed\n'
        '- Points and virtual items have no '
        'real-world monetary value\n'
        '- CO2 estimates are approximate, for '
        'educational purposes\n'
        '- You can delete your account at any '
        'time from Settings\n'
        '- The app is provided "as is" without '
        'warranties',
  ),
  LegalSection(
    title: 'Acceptance of Terms',
    body: 'By creating an account or using the Seed '
        'mobile application, you agree to be bound by '
        'these Terms of Service. If you do not agree to '
        'these terms, please do not use the app.',
  ),
  LegalSection(
    title: 'Description of Service',
    body: 'Seed is a sustainability habit-tracking '
        'application that allows users to log '
        'eco-friendly actions, earn points based on '
        'estimated CO2 impact, grow a virtual mascot '
        'companion, and learn about the United Nations '
        'Sustainable Development Goals (SDGs).',
  ),
  LegalSection(
    title: 'User Accounts',
    body: 'You must create an account to use Seed. '
        'You are responsible for maintaining the '
        'confidentiality of your account credentials '
        'and for all activities that occur under your '
        'account. You agree to provide accurate and '
        'complete information when creating your account.',
  ),
  LegalSection(
    title: 'Acceptable Use',
    body: 'You agree to use Seed only for its intended '
        'purpose. You must not:\n\n'
        '- Attempt to gain unauthorized access to the '
        'app or its systems\n'
        '- Use the app to transmit harmful or malicious '
        'content\n'
        '- Create multiple accounts to manipulate points '
        'or rankings\n'
        '- Reverse engineer or decompile the application\n'
        '- Use automated systems to interact with '
        'the app',
  ),
  LegalSection(
    title: 'Points and Virtual Items',
    body: 'Points earned through logging actions and '
        'virtual items purchased in the cosmetic shop '
        'have no real-world monetary value. They exist '
        'solely within the app and cannot be exchanged, '
        'transferred, or refunded outside of the app.',
  ),
  LegalSection(
    title: 'Intellectual Property',
    body: 'All content, designs, graphics, and software '
        'within Seed are owned by or licensed to us. '
        'You may not copy, modify, distribute, or create '
        'derivative works from our content without prior '
        'written permission.',
  ),
  LegalSection(
    title: 'CO2 Impact Estimates',
    body: 'The CO2 savings estimates provided in Seed '
        'are approximate values based on publicly '
        'available research and averages. They are '
        'intended for educational and motivational '
        'purposes and should not be considered exact '
        'scientific measurements. Actual environmental '
        'impact may vary based on individual '
        'circumstances.',
  ),
  LegalSection(
    title: 'Disclaimer of Warranties',
    body: 'Seed is provided "as is" without warranties '
        'of any kind, whether express or implied. We do '
        'not guarantee that the app will be uninterrupted, '
        'error-free, or free of harmful components.',
  ),
  LegalSection(
    title: 'Limitation of Liability',
    body: 'To the maximum extent permitted by law, Seed '
        'and its developers shall not be liable for any '
        'indirect, incidental, special, or consequential '
        'damages arising from your use of the app.',
  ),
  LegalSection(
    title: 'Account Termination',
    body: 'You may delete your account at any time '
        'through Settings > Account. We reserve the right '
        'to suspend or terminate accounts that violate '
        'these terms. Upon termination, all associated '
        'data will be permanently deleted.',
  ),
  LegalSection(
    title: 'Changes to Terms',
    body: 'We may update these Terms of Service from '
        'time to time. We will notify you of significant '
        'changes through the app. Continued use of the '
        'app after changes constitutes acceptance of the '
        'updated terms.',
  ),
  LegalSection(
    title: 'Contact Us',
    body: 'If you have questions about these Terms of '
        'Service, please contact us at $_contactEmail.',
  ),
];

const _termsJa = [
  LegalSection(
    title: '要点',
    body: '- Seedを使用するにはアカウントの'
        '作成が必要です\n'
        '- ポイントと仮想アイテムには現実世界の'
        '金銭的価値はありません\n'
        '- CO2推定値は概算であり、'
        '教育目的のものです\n'
        '- 設定からいつでもアカウントを'
        '削除できます\n'
        '- アプリは保証なしの「現状のまま」で'
        '提供されます',
  ),
  LegalSection(
    title: '利用規約への同意',
    body: 'Seedモバイルアプリケーションのアカウントを'
        '作成するか、アプリを使用することにより、'
        'お客様はこの利用規約に拘束されることに'
        '同意するものとします。これらの条件に同意'
        'されない場合は、アプリを使用しないでください。',
  ),
  LegalSection(
    title: 'サービスの説明',
    body: 'Seedは、ユーザーがエコフレンドリーな活動を'
        '記録し、推定CO2影響に基づくポイントを獲得し、'
        'バーチャルマスコットを育て、国連の持続可能な'
        '開発目標（SDGs）について学ぶことができる'
        'サステナビリティ習慣追跡アプリケーションです。',
  ),
  LegalSection(
    title: 'ユーザーアカウント',
    body: 'Seedを使用するにはアカウントを作成する'
        '必要があります。アカウントの認証情報の機密性を'
        '維持し、アカウント下で行われるすべての活動に'
        '責任を負うものとします。アカウント作成時には'
        '正確かつ完全な情報を提供することに同意します。',
  ),
  LegalSection(
    title: '利用規則',
    body: 'Seedは意図された目的のみに使用することに'
        '同意します。以下の行為を行ってはなりません：\n\n'
        '- アプリまたはそのシステムへの不正アクセスの試み\n'
        '- 有害または悪意のあるコンテンツの送信\n'
        '- ポイントやランキングを操作するための'
        '複数アカウントの作成\n'
        '- アプリケーションのリバースエンジニアリング'
        'または逆コンパイル\n'
        '- 自動化システムによるアプリとのやり取り',
  ),
  LegalSection(
    title: 'ポイントと仮想アイテム',
    body: 'アクションの記録で獲得したポイントや'
        'コスメティックショップで購入した仮想アイテムは、'
        '現実世界の金銭的価値を持ちません。アプリ内'
        'でのみ存在し、アプリ外での交換、譲渡、'
        '返金はできません。',
  ),
  LegalSection(
    title: '知的財産',
    body: 'Seed内のすべてのコンテンツ、デザイン、'
        'グラフィックス、ソフトウェアは当社が所有'
        'またはライセンスを受けたものです。事前の'
        '書面による許可なく、当社のコンテンツを'
        'コピー、変更、配布、または派生物を作成する'
        'ことはできません。',
  ),
  LegalSection(
    title: 'CO2影響の推定値',
    body: 'Seedで提供されるCO2削減の推定値は、'
        '公開されている研究と平均値に基づく概算値です。'
        '教育的および動機付けの目的であり、正確な'
        '科学的測定値とはみなされません。実際の'
        '環境影響は個人の状況により異なる場合があります。',
  ),
  LegalSection(
    title: '保証の免責',
    body: 'Seedは明示的または黙示的を問わず、いかなる'
        '種類の保証もなく「現状のまま」で提供されます。'
        'アプリが中断なく、エラーなく、または有害な'
        'コンポーネントなく動作することを保証しません。',
  ),
  LegalSection(
    title: '責任の制限',
    body: '法律で許容される最大限の範囲において、'
        'Seedおよびその開発者は、アプリの使用に起因する'
        '間接的、偶発的、特別、または結果的損害について'
        '責任を負わないものとします。',
  ),
  LegalSection(
    title: 'アカウントの終了',
    body: '設定 > アカウントからいつでもアカウントを'
        '削除できます。当社は、これらの規約に違反する'
        'アカウントを一時停止または終了する権利を'
        '留保します。終了時には、関連するすべての'
        'データが完全に削除されます。',
  ),
  LegalSection(
    title: '規約の変更',
    body: '当社はこの利用規約を随時更新する場合が'
        'あります。重要な変更についてはアプリ内で'
        'お知らせします。変更後もアプリを継続して使用'
        'することは、更新された規約への同意を意味します。',
  ),
  LegalSection(
    title: 'お問い合わせ',
    body: 'この利用規約についてご質問がある場合は、'
        '$_contactEmail までご連絡ください。',
  ),
];

const _termsEs = [
  LegalSection(
    title: 'Puntos clave',
    body: '- Debe crear una cuenta para usar Seed\n'
        '- Los puntos y articulos virtuales no '
        'tienen valor monetario real\n'
        '- Las estimaciones de CO2 son aproximadas, '
        'con fines educativos\n'
        '- Puede eliminar su cuenta en cualquier '
        'momento desde Ajustes\n'
        '- La aplicacion se proporciona "tal cual" '
        'sin garantias',
  ),
  LegalSection(
    title: 'Aceptacion de los terminos',
    body: 'Al crear una cuenta o utilizar la aplicacion '
        'movil Seed, usted acepta estar sujeto a estos '
        'Terminos de Servicio. Si no esta de acuerdo con '
        'estos terminos, por favor no utilice la '
        'aplicacion.',
  ),
  LegalSection(
    title: 'Descripcion del servicio',
    body: 'Seed es una aplicacion de seguimiento de '
        'habitos de sostenibilidad que permite a los '
        'usuarios registrar acciones ecologicas, ganar '
        'puntos basados en el impacto estimado de CO2, '
        'criar una mascota virtual y aprender sobre los '
        'Objetivos de Desarrollo Sostenible (ODS) de las '
        'Naciones Unidas.',
  ),
  LegalSection(
    title: 'Cuentas de usuario',
    body: 'Debe crear una cuenta para usar Seed. Usted '
        'es responsable de mantener la confidencialidad '
        'de las credenciales de su cuenta y de todas las '
        'actividades que ocurran bajo su cuenta. Acepta '
        'proporcionar informacion precisa y completa al '
        'crear su cuenta.',
  ),
  LegalSection(
    title: 'Uso aceptable',
    body: 'Acepta usar Seed solo para su proposito '
        'previsto. No debe:\n\n'
        '- Intentar obtener acceso no autorizado a la '
        'aplicacion o sus sistemas\n'
        '- Usar la aplicacion para transmitir contenido '
        'danino o malicioso\n'
        '- Crear multiples cuentas para manipular puntos '
        'o clasificaciones\n'
        '- Realizar ingenieria inversa o descompilar la '
        'aplicacion\n'
        '- Usar sistemas automatizados para interactuar '
        'con la aplicacion',
  ),
  LegalSection(
    title: 'Puntos y articulos virtuales',
    body: 'Los puntos ganados al registrar acciones y '
        'los articulos virtuales comprados en la tienda '
        'cosmetica no tienen valor monetario real. '
        'Existen unicamente dentro de la aplicacion y '
        'no pueden ser intercambiados, transferidos o '
        'reembolsados fuera de la aplicacion.',
  ),
  LegalSection(
    title: 'Propiedad intelectual',
    body: 'Todo el contenido, disenos, graficos y '
        'software dentro de Seed son propiedad de o '
        'estan licenciados a nosotros. No puede copiar, '
        'modificar, distribuir o crear obras derivadas '
        'de nuestro contenido sin permiso previo por '
        'escrito.',
  ),
  LegalSection(
    title: 'Estimaciones de impacto de CO2',
    body: 'Las estimaciones de ahorro de CO2 '
        'proporcionadas en Seed son valores aproximados '
        'basados en investigaciones publicas y promedios. '
        'Estan destinadas a fines educativos y '
        'motivacionales y no deben considerarse '
        'mediciones cientificas exactas. El impacto '
        'ambiental real puede variar segun las '
        'circunstancias individuales.',
  ),
  LegalSection(
    title: 'Exencion de garantias',
    body: 'Seed se proporciona "tal cual" sin garantias '
        'de ningun tipo, ya sean expresas o implicitas. '
        'No garantizamos que la aplicacion sea '
        'ininterrumpida, libre de errores o libre de '
        'componentes daninos.',
  ),
  LegalSection(
    title: 'Limitacion de responsabilidad',
    body: 'En la medida maxima permitida por la ley, '
        'Seed y sus desarrolladores no seran '
        'responsables de ningun dano indirecto, '
        'incidental, especial o consecuente derivado '
        'del uso de la aplicacion.',
  ),
  LegalSection(
    title: 'Terminacion de cuenta',
    body: 'Puede eliminar su cuenta en cualquier momento '
        'desde Ajustes > Cuenta. Nos reservamos el '
        'derecho de suspender o terminar cuentas que '
        'violen estos terminos. Al terminar, todos los '
        'datos asociados seran eliminados permanentemente.',
  ),
  LegalSection(
    title: 'Cambios en los terminos',
    body: 'Podemos actualizar estos Terminos de Servicio '
        'periodicamente. Le notificaremos sobre cambios '
        'significativos a traves de la aplicacion. '
        'El uso continuado de la aplicacion despues de '
        'los cambios constituye la aceptacion de los '
        'terminos actualizados.',
  ),
  LegalSection(
    title: 'Contactenos',
    body: 'Si tiene preguntas sobre estos Terminos de '
        'Servicio, contactenos en $_contactEmail.',
  ),
];
