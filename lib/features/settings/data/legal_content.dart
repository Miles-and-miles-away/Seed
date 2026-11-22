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
  }) : _en = en,
       _ja = ja,
       _es = es;

  final List<LegalSection> _en;
  final List<LegalSection> _ja;
  final List<LegalSection> _es;

  String get lastUpdated => _lastUpdated;

  /// Sections for [locale], falling back to English.
  List<LegalSection> forLocale(Locale locale) {
    return switch (locale.languageCode) {
      'ja' => _ja,
      'es' => _es,
      _ => _en,
    };
  }
}

const _lastUpdated = '2026-11-21';
const _contactEmail = 'support@seedahabit.com';

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
    body:
        '- We collect your email, display name, '
        'and action history\n'
        '- Data is stored securely on Firebase '
        '(Google Cloud)\n'
        '- We never sell or share your data with '
        'third parties\n'
        '- You can delete your account and all '
        'data at any time\n'
        '- Pseudonymous analytics can be turned off '
        'in settings\n'
        '- You can download a copy of your data from '
        'Settings > Account',
  ),
  LegalSection(
    title: 'Introduction',
    body:
        'The Seed mobile application is operated by '
        'Miles Desforges, a sole trader ("we", "our", or '
        '"us"), who is the data controller for your '
        'personal data. This Privacy Policy explains '
        'how we collect, use, and protect your personal '
        'information when you use our app.',
  ),
  LegalSection(
    title: 'Information We Collect',
    body:
        'We collect the following information:\n\n'
        '- Email address (for account creation '
        'and authentication)\n'
        '- Display name (optional, shown in your profile)\n'
        '- Personal goal (optional, shown on your home screen)\n'
        '- Profile photo link (the address of your Google '
        'profile picture, if you sign in with Google)\n'
        '- Action log history (sustainability actions you '
        'record)\n'
        '- Device push notification token (to send push '
        'notifications from our servers)\n'
        '- Approximate location (country or region, derived '
        'from your IP address by analytics)\n'
        '- Pseudonymous usage analytics (app feature usage, '
        'crash reports, performance data), linked to an '
        'app instance identifier and not to your account\n'
        '- Feedback emails you send us, which include your '
        'user ID and app and device details',
  ),
  LegalSection(
    title: 'How We Use Your Information',
    body:
        'Your information is used to:\n\n'
        '- Authenticate your account and provide '
        'access to the app\n'
        '- Track your sustainability actions and calculate '
        'your environmental impact\n'
        '- Send push notifications and daily reminders '
        '(with your permission)\n'
        '- Improve app performance and fix bugs through '
        'pseudonymous analytics\n'
        '- Display your progress, streaks, and mascot '
        'evolution\n'
        '- Answer feedback and support requests',
  ),
  LegalSection(
    title: 'Legal Basis for Processing',
    body:
        'Under the UK GDPR, we rely on these legal bases:\n\n'
        '- Contract: to provide your account, record your '
        'actions, and show your progress\n'
        '- Consent: to send push notifications and '
        'reminders. You can withdraw consent at any time '
        'in your device settings\n'
        '- Legitimate interests: to improve the app with '
        'analytics, crash reports, and performance data, '
        'to protect the service from abuse with App '
        'Check, and to answer your feedback. You can turn '
        'off analytics, crash reports, and performance '
        'data in the app settings',
  ),
  LegalSection(
    title: 'Data Storage and Security',
    body:
        'Your data is stored securely on Firebase '
        '(Google Cloud) servers. We use industry-standard '
        'security measures including encrypted '
        'connections (TLS/SSL), Firebase Security Rules '
        'to restrict data access, and authentication '
        'tokens to protect your account.\n\n'
        "Your account data is stored in Google Cloud's "
        'Tokyo, Japan region. The UK recognises Japan as '
        'giving adequate protection to personal data. '
        'Firebase Authentication processes sign-in data '
        'in the United States. Google LLC is certified '
        'under the UK Extension to the EU-U.S. Data '
        'Privacy Framework. Other Firebase services can '
        "process data on Google's global infrastructure "
        "under Google's data processing terms.",
  ),
  LegalSection(
    title: 'Data Retention',
    body:
        'We keep your data only as long as we need it:\n\n'
        '- Account data: until you delete your account. '
        'Firebase Authentication removes sign-in records '
        'from its backups within 180 days of deletion\n'
        '- Accounts with an unverified email address: '
        'deleted automatically after 7 days\n'
        '- Crash reports: 90 days\n'
        '- Performance data: up to 60 days\n'
        '- App Check data: up to 30 days\n'
        '- Analytics data: up to 14 months\n'
        '- Feedback emails: as long as we need them to '
        'answer and act on your feedback',
  ),
  LegalSection(
    title: 'Third-Party Services',
    body:
        'We use the following third-party services:\n\n'
        '- Firebase Authentication (account management)\n'
        '- Cloud Firestore (data storage)\n'
        '- Firebase Cloud Messaging (push notifications)\n'
        '- Firebase Analytics (pseudonymous usage data)\n'
        '- Firebase Crashlytics (crash reporting)\n'
        '- Firebase Performance Monitoring '
        '(app performance data)\n'
        '- Firebase App Check (abuse prevention)\n'
        '- Google Sign-In (optional sign-in method)\n'
        '- Sign in with Apple (optional sign-in method)\n'
        '- Cloudflare Email Routing (forwards the feedback '
        'and support emails you send us)\n\n'
        'These services have their own privacy policies. '
        'We do not sell or share your personal data with '
        'any other third parties.',
  ),
  LegalSection(
    title: "Children's Privacy",
    body:
        'Seed is not directed at children under the age '
        'of 13. We do not knowingly collect personal '
        'information from children under 13. If you are a '
        'parent and believe your child has provided us '
        'with personal information, please contact us so '
        'we can delete it.',
  ),
  LegalSection(
    title: 'Your Rights',
    body:
        'Under the UK GDPR, you have the right to:\n\n'
        '- Access your personal data. You can see it in '
        'the app, or download a copy from Settings > '
        'Account > Download My Data\n'
        '- Correct your data. You can edit your display '
        'name, goal, and email in Settings > Account\n'
        '- Delete your account and all associated data '
        'from Settings > Account\n'
        '- Receive your data in a portable format. The '
        'download is a JSON file\n'
        '- Restrict or object to processing. You can turn '
        'off analytics in the app settings, or contact us\n'
        '- Withdraw consent to push notifications in your '
        'device settings\n'
        "- Complain to the Information Commissioner's "
        'Office (ICO) at ico.org.uk\n\n'
        'To use a right that the app does not cover, email '
        'us at $_contactEmail. We will reply within one '
        'month.\n\n'
        'If you live outside the UK, the data protection '
        'law of your country may give you similar rights, '
        'and you may be able to complain to your local data '
        'protection authority.\n\n'
        'When you delete your account, all your data '
        'including action history, mascot progress, and '
        'profile information is permanently removed from '
        'our servers. Analytics, crash, and performance '
        'data are not linked to your account and are '
        'deleted on the schedule in Data Retention.',
  ),
  LegalSection(
    title: 'Changes to This Policy',
    body:
        'We may update this Privacy Policy from time to '
        'time. We will notify you of significant changes '
        'through the app or via email. Continued use of '
        'the app after changes constitutes acceptance of '
        'the updated policy.',
  ),
  LegalSection(
    title: 'Contact Us',
    body:
        'If you have questions about this Privacy Policy '
        'or your personal data, please contact us at '
        '$_contactEmail.',
  ),
];

const _privacyJa = [
  LegalSection(
    title: '要点',
    body:
        '- メールアドレス、表示名、'
        'アクション履歴を収集します\n'
        '- データはFirebase（Google Cloud）に'
        '安全に保存されます\n'
        '- お客様のデータを第三者に販売・'
        '共有することはありません\n'
        '- いつでもアカウントとデータを'
        '削除できます\n'
        '- 仮名化された分析は設定からオフにできます\n'
        '- 設定 > アカウントからデータのコピーを'
        'ダウンロードできます',
  ),
  LegalSection(
    title: 'はじめに',
    body:
        'Seedモバイルアプリケーションは、個人事業主の'
        'Miles Desforges（以下「当社」）が運営しており、'
        '当社がお客様の個人データの管理者です。'
        'このプライバシーポリシーは、アプリの利用時に'
        '当社がどのように個人情報を収集、使用、'
        '保護するかを説明するものです。',
  ),
  LegalSection(
    title: '収集する情報',
    body:
        '当社は以下の情報を収集します：\n\n'
        '- メールアドレス（アカウント作成および認証用）\n'
        '- 表示名（任意、プロフィールに表示）\n'
        '- 目標（任意、ホーム画面に表示）\n'
        '- プロフィール写真のリンク（Googleでサインインした場合の、'
        'Googleプロフィール画像のアドレス）\n'
        '- アクション履歴（記録されたサステナビリティ活動）\n'
        '- デバイスプッシュ通知トークン'
        '（当社のサーバーからプッシュ通知を送信するため）\n'
        '- おおよその位置情報（分析のためIPアドレスから推定される国または地域）\n'
        '- 仮名化された利用分析データ（アプリ機能の使用状況、'
        'クラッシュレポート、パフォーマンスデータ）。'
        'アカウントではなく、アプリのインスタンス識別子に'
        '紐付けられます\n'
        '- お客様から届いたフィードバックメール'
        '（ユーザーID、アプリとデバイスの情報を含みます）',
  ),
  LegalSection(
    title: '情報の利用方法',
    body:
        'お客様の情報は以下の目的で使用されます：\n\n'
        '- アカウントの認証とアプリへのアクセス提供\n'
        '- サステナビリティ活動の追跡と環境への影響の計算\n'
        '- プッシュ通知と毎日のリマインダーの送信（許可を得た場合）\n'
        '- 仮名化された分析によるアプリパフォーマンスの'
        '向上とバグの修正\n'
        '- 進捗、連続記録、マスコットの進化の表示\n'
        '- フィードバックとお問い合わせへの回答',
  ),
  LegalSection(
    title: '処理の法的根拠',
    body:
        '英国GDPRに基づき、当社は以下の法的根拠に'
        '依拠します：\n\n'
        '- 契約：アカウントの提供、アクションの記録、'
        '進捗の表示のため\n'
        '- 同意：プッシュ通知とリマインダーの送信のため。'
        'デバイス設定からいつでも同意を撤回できます\n'
        '- 正当な利益：分析、クラッシュレポート、'
        'パフォーマンスデータによるアプリの改善、'
        'App Checkによる不正利用からのサービス保護、'
        'フィードバックへの回答のため。分析、'
        'クラッシュレポート、パフォーマンスデータは'
        'アプリ設定からオフにできます',
  ),
  LegalSection(
    title: 'データの保存とセキュリティ',
    body:
        'お客様のデータはFirebase（Google Cloud）'
        'サーバーに安全に保存されます。'
        '暗号化された接続（TLS/SSL）、'
        'Firebaseセキュリティルールによるデータアクセス'
        '制限、認証トークンによるアカウント保護など、'
        '業界標準のセキュリティ対策を使用しています。\n\n'
        'お客様のアカウントデータは、Google Cloudの'
        '日本・東京リージョンに保存されます。英国は、'
        '日本が個人データを十分に保護していると'
        '認めています。Firebase Authenticationは'
        'サインインデータを米国で処理します。Google LLCは'
        'EU-U.S. Data Privacy Frameworkの英国拡張の'
        '認証を受けています。その他のFirebaseサービスは、'
        'Googleのデータ処理規約に基づき、Googleの'
        'グローバルなインフラでデータを処理する'
        '場合があります。',
  ),
  LegalSection(
    title: 'データの保存期間',
    body:
        '当社はデータを必要な期間だけ保存します：\n\n'
        '- アカウントデータ：アカウントを削除するまで。'
        'Firebase Authenticationは削除から180日以内に'
        'バックアップからサインイン記録を削除します\n'
        '- メールアドレスが未確認のアカウント：'
        '7日後に自動的に削除されます\n'
        '- クラッシュレポート：90日\n'
        '- パフォーマンスデータ：最長60日\n'
        '- App Checkのデータ：最長30日\n'
        '- 分析データ：最長14か月\n'
        '- フィードバックメール：回答と対応に必要な期間',
  ),
  LegalSection(
    title: 'サードパーティサービス',
    body:
        '当社は以下のサードパーティサービスを使用しています：\n\n'
        '- Firebase Authentication（アカウント管理）\n'
        '- Cloud Firestore（データ保存）\n'
        '- Firebase Cloud Messaging（プッシュ通知）\n'
        '- Firebase Analytics（仮名化された利用データ）\n'
        '- Firebase Crashlytics（クラッシュレポート）\n'
        '- Firebase Performance Monitoring'
        '（アプリのパフォーマンスデータ）\n'
        '- Firebase App Check（不正利用防止）\n'
        '- Google Sign-In（任意のサインイン方法）\n'
        '- Sign in with Apple（任意のサインイン方法）\n'
        '- Cloudflare Email Routing（お客様から届いた'
        'フィードバックメールとお問い合わせメールの転送）\n\n'
        'これらのサービスには独自のプライバシーポリシーがあります。'
        '当社はお客様の個人データを他の第三者に販売または共有することはありません。',
  ),
  LegalSection(
    title: '子供のプライバシー',
    body:
        'Seedは13歳未満の子供を対象としていません。'
        '13歳未満の子供から故意に個人情報を収集する'
        'ことはありません。保護者の方で、お子様が'
        '当社に個人情報を提供したと思われる場合は、'
        '削除のためにご連絡ください。',
  ),
  LegalSection(
    title: 'お客様の権利',
    body:
        '英国GDPRに基づき、お客様には以下の権利が'
        'あります：\n\n'
        '- 個人データへのアクセス。アプリで確認するか、'
        '設定 > アカウント > データをダウンロードから'
        'コピーを入手できます\n'
        '- データの訂正。表示名、目標、メールアドレスは'
        '設定 > アカウントで編集できます\n'
        '- 設定 > アカウントからアカウントと関連データを'
        'すべて削除\n'
        '- 持ち運び可能な形式でのデータの受け取り。'
        'ダウンロードはJSONファイルです\n'
        '- 処理の制限または異議申し立て。分析は'
        'アプリ設定からオフにできます。または当社に'
        'ご連絡ください\n'
        '- デバイス設定からプッシュ通知への同意を撤回\n'
        '- 英国情報コミッショナー事務局（ICO、ico.org.uk）'
        'への苦情申し立て\n\n'
        'アプリで対応していない権利を行使するには、'
        '$_contactEmail までメールでご連絡ください。'
        '1か月以内に回答します。\n\n'
        '英国外にお住まいの場合、お住まいの国のデータ保護法に'
        'より同様の権利が認められることがあり、お住まいの国の'
        'データ保護機関に苦情を申し立てられる場合があります。\n\n'
        'アカウントを削除すると、アクション履歴、'
        'マスコットの進捗、プロフィール情報を含む'
        'すべてのデータがサーバーから完全に削除されます。'
        '分析、クラッシュ、パフォーマンスのデータは'
        'アカウントに紐付けられておらず、「データの'
        '保存期間」に記載の期間で削除されます。',
  ),
  LegalSection(
    title: 'ポリシーの変更',
    body:
        '当社はこのプライバシーポリシーを随時更新する'
        '場合があります。重要な変更については、アプリ内'
        'またはメールでお知らせします。変更後もアプリを'
        '継続して使用することは、更新されたポリシーへの'
        '同意を意味します。',
  ),
  LegalSection(
    title: 'お問い合わせ',
    body:
        'このプライバシーポリシーまたは個人データに'
        'ついてご質問がある場合は、$_contactEmail '
        'までご連絡ください。',
  ),
];

const _privacyEs = [
  LegalSection(
    title: 'Puntos clave',
    body:
        '- Recopilamos su correo electrónico, '
        'nombre de usuario e historial de acciones\n'
        '- Los datos se almacenan de forma segura '
        'en Firebase (Google Cloud)\n'
        '- Nunca vendemos ni compartimos sus datos '
        'con terceros\n'
        '- Puede eliminar su cuenta y todos sus '
        'datos en cualquier momento\n'
        '- Los análisis seudonimizados se pueden '
        'desactivar en los ajustes\n'
        '- Puede descargar una copia de sus datos '
        'desde Ajustes > Cuenta',
  ),
  LegalSection(
    title: 'Introducción',
    body:
        'La aplicación móvil Seed la gestiona '
        'Miles Desforges, empresario individual '
        '(«nosotros»), que es el responsable del '
        'tratamiento de sus datos personales. Esta '
        'Política de '
        'Privacidad explica cómo recopilamos, usamos y '
        'protegemos su información personal cuando '
        'utiliza nuestra aplicación.',
  ),
  LegalSection(
    title: 'Información que recopilamos',
    body:
        'Recopilamos la siguiente información:\n\n'
        '- Dirección de correo electrónico (para la '
        'creación de cuenta y autenticación)\n'
        '- Nombre de usuario (opcional, mostrado en '
        'su perfil)\n'
        '- Objetivo personal (opcional, mostrado en '
        'la pantalla de inicio)\n'
        '- Enlace a la foto de perfil (la dirección de su '
        'imagen de perfil de Google, si inicia sesión con '
        'Google)\n'
        '- Historial de acciones (actividades de '
        'sostenibilidad registradas)\n'
        '- Token de notificaciones push del dispositivo '
        '(para enviar notificaciones push desde nuestros '
        'servidores)\n'
        '- Ubicación aproximada (país o región, derivada de '
        'su dirección IP por los análisis)\n'
        '- Datos de uso seudonimizados (uso de funciones '
        'de la aplicación, informes de errores, datos de '
        'rendimiento), vinculados a un identificador de '
        'instancia de la aplicación y no a su cuenta\n'
        '- Los correos de comentarios que nos envía, que '
        'incluyen su ID de usuario y datos de la '
        'aplicación y del dispositivo',
  ),
  LegalSection(
    title: 'Cómo usamos su información',
    body:
        'Su información se utiliza para:\n\n'
        '- Autenticar su cuenta y proporcionar acceso '
        'a la aplicación\n'
        '- Registrar sus acciones de sostenibilidad y '
        'calcular su impacto ambiental\n'
        '- Enviar notificaciones push y recordatorios '
        'diarios (con su permiso)\n'
        '- Mejorar el rendimiento de la aplicación y '
        'corregir errores mediante análisis '
        'seudonimizados\n'
        '- Mostrar su progreso, rachas y evolución '
        'de su mascota\n'
        '- Responder a comentarios y solicitudes de '
        'asistencia',
  ),
  LegalSection(
    title: 'Base jurídica del tratamiento',
    body:
        'Conforme al RGPD del Reino Unido, nos basamos en '
        'estas bases jurídicas:\n\n'
        '- Contrato: para ofrecer su cuenta, registrar sus '
        'acciones y mostrar su progreso\n'
        '- Consentimiento: para enviar notificaciones push '
        'y recordatorios. Puede retirar su consentimiento '
        'en cualquier momento desde los ajustes de su '
        'dispositivo\n'
        '- Interés legítimo: para mejorar la aplicación '
        'con análisis, informes de errores y datos de '
        'rendimiento, para proteger el servicio contra '
        'abusos con App Check y para responder a sus '
        'comentarios. Puede desactivar los análisis, los '
        'informes de errores y los datos de rendimiento en '
        'los ajustes de la aplicación',
  ),
  LegalSection(
    title: 'Almacenamiento y seguridad de datos',
    body:
        'Sus datos se almacenan de forma segura en '
        'servidores de Firebase (Google Cloud). '
        'Utilizamos medidas de seguridad estándar del '
        'sector, como conexiones cifradas '
        '(TLS/SSL), reglas de seguridad de Firebase para '
        'restringir el acceso a los datos y tokens de '
        'autenticación para proteger su cuenta.\n\n'
        'Los datos de su cuenta se almacenan en la región '
        'de Google Cloud de Tokio (Japón). El Reino Unido '
        'reconoce que Japón ofrece una protección adecuada '
        'de los datos personales. Firebase Authentication '
        'trata los datos de inicio de sesión en Estados '
        'Unidos. Google LLC está certificada conforme a la '
        'extensión del Reino Unido del EU-U.S. Data Privacy '
        'Framework. Otros servicios de Firebase pueden '
        'tratar datos en la infraestructura global de '
        'Google conforme a las condiciones de tratamiento '
        'de datos de Google.',
  ),
  LegalSection(
    title: 'Conservación de los datos',
    body:
        'Conservamos sus datos solo el tiempo necesario:\n\n'
        '- Datos de la cuenta: hasta que elimine su '
        'cuenta. Firebase Authentication elimina los '
        'registros de inicio de sesión de sus copias de '
        'seguridad en un plazo de 180 días\n'
        '- Cuentas con el correo electrónico sin '
        'verificar: se eliminan automáticamente a los '
        '7 días\n'
        '- Informes de errores: 90 días\n'
        '- Datos de rendimiento: hasta 60 días\n'
        '- Datos de App Check: hasta 30 días\n'
        '- Datos analíticos: hasta 14 meses\n'
        '- Correos de comentarios: el tiempo necesario para '
        'responder y actuar sobre sus comentarios',
  ),
  LegalSection(
    title: 'Servicios de terceros',
    body:
        'Utilizamos los siguientes servicios de '
        'terceros:\n\n'
        '- Firebase Authentication (gestión de cuentas)\n'
        '- Cloud Firestore (almacenamiento de datos)\n'
        '- Firebase Cloud Messaging '
        '(notificaciones push)\n'
        '- Firebase Analytics (datos de uso '
        'seudonimizados)\n'
        '- Firebase Crashlytics (informes de errores)\n'
        '- Firebase Performance Monitoring '
        '(datos de rendimiento de la aplicación)\n'
        '- Firebase App Check (prevención de abusos)\n'
        '- Google Sign-In (método de inicio de sesión opcional)\n'
        '- Sign in with Apple (método de inicio de sesión opcional)\n'
        '- Cloudflare Email Routing (reenvía los correos de '
        'comentarios y de asistencia que nos envía)\n\n'
        'Estos servicios tienen sus propias políticas de '
        'privacidad. No vendemos ni compartimos sus datos '
        'personales con otros terceros.',
  ),
  LegalSection(
    title: 'Privacidad de los menores',
    body:
        'Seed no está dirigida a menores de 13 años. '
        'No recopilamos a sabiendas información '
        'personal de menores de 13 años. Si es usted '
        'padre, madre o tutor y cree que un menor a su '
        'cargo nos ha proporcionado información personal, '
        'póngase en contacto con nosotros para que '
        'podamos eliminarla.',
  ),
  LegalSection(
    title: 'Sus derechos',
    body:
        'Conforme al RGPD del Reino Unido, usted tiene '
        'derecho a:\n\n'
        '- Acceder a sus datos personales. Puede verlos en '
        'la aplicación o descargar una copia desde '
        'Ajustes > Cuenta > Descargar mis datos\n'
        '- Rectificar sus datos. Puede editar su nombre de '
        'usuario, su objetivo y su correo electrónico en '
        'Ajustes > Cuenta\n'
        '- Eliminar su cuenta y todos los datos asociados '
        'desde Ajustes > Cuenta\n'
        '- Recibir sus datos en un formato portable. La '
        'descarga es un archivo JSON\n'
        '- Limitar el tratamiento u oponerse a él. Puede '
        'desactivar los análisis en los ajustes de la '
        'aplicación o ponerse en contacto con nosotros\n'
        '- Retirar su consentimiento a las notificaciones '
        'push desde los ajustes de su dispositivo\n'
        '- Presentar una reclamación ante la Oficina del '
        'Comisionado de Información del Reino Unido (ICO) '
        'en ico.org.uk\n\n'
        'Para ejercer un derecho que la aplicación no '
        'cubre, escríbanos a $_contactEmail. Le '
        'responderemos en el plazo de un mes.\n\n'
        'Si reside fuera del Reino Unido, la legislación de '
        'protección de datos de su país puede otorgarle '
        'derechos similares, y es posible que pueda '
        'presentar una reclamación ante la autoridad de '
        'protección de datos de su país.\n\n'
        'Cuando elimina su cuenta, todos sus datos, '
        'incluidos el historial de acciones, el progreso '
        'de la mascota y la información del perfil, se '
        'eliminan permanentemente de nuestros servidores. '
        'Los datos analíticos, de errores y de rendimiento '
        'no están vinculados a su cuenta y se eliminan '
        'según los plazos de «Conservación de los datos».',
  ),
  LegalSection(
    title: 'Cambios en esta política',
    body:
        'Podemos actualizar esta Política de Privacidad '
        'periódicamente. Le avisaremos de los cambios '
        'importantes a través de la aplicación o por '
        'correo electrónico. El uso continuado de la '
        'aplicación después de los cambios constituye la '
        'aceptación de la política actualizada.',
  ),
  LegalSection(
    title: 'Contacto',
    body:
        'Si tiene preguntas sobre esta Política de '
        'Privacidad o sus datos personales, escríbanos '
        'a $_contactEmail.',
  ),
];

const _termsEn = [
  LegalSection(
    title: 'Key Points',
    body:
        '- You must create an account to use Seed\n'
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
    body:
        'By creating an account or using the Seed '
        'mobile application, you agree to be bound by '
        'these Terms of Service. If you do not agree to '
        'these terms, please do not use the app.',
  ),
  LegalSection(
    title: 'Description of Service',
    body:
        'Seed is a sustainability habit-tracking '
        'application that allows users to log '
        'eco-friendly actions, earn points based on '
        'estimated CO2 impact, grow a virtual mascot '
        'companion, and learn about the United Nations '
        'Sustainable Development Goals (SDGs).',
  ),
  LegalSection(
    title: 'User Accounts',
    body:
        'You must create an account to use Seed. '
        'You are responsible for maintaining the '
        'confidentiality of your account credentials '
        'and for all activities that occur under your '
        'account. You agree to provide accurate and '
        'complete information when creating your account.',
  ),
  LegalSection(
    title: 'Acceptable Use',
    body:
        'You agree to use Seed only for its intended '
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
    body:
        'Points and virtual items earned through '
        'logging actions have no real-world monetary '
        'value. They exist '
        'solely within the app and cannot be exchanged, '
        'transferred, or refunded outside of the app.',
  ),
  LegalSection(
    title: 'Intellectual Property',
    body:
        'All content, designs, graphics, and software '
        'within Seed are owned by or licensed to us. '
        'You may not copy, modify, distribute, or create '
        'derivative works from our content without prior '
        'written permission.',
  ),
  LegalSection(
    title: 'CO2 Impact Estimates',
    body:
        'The CO2 savings estimates provided in Seed '
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
    body:
        'Seed is provided "as is" without warranties '
        'of any kind, whether express or implied. We do '
        'not guarantee that the app will be uninterrupted, '
        'error-free, or free of harmful components.',
  ),
  LegalSection(
    title: 'Limitation of Liability',
    body:
        'To the maximum extent permitted by law, Seed '
        'and its developers shall not be liable for any '
        'indirect, incidental, special, or consequential '
        'damages arising from your use of the app.',
  ),
  LegalSection(
    title: 'Account Termination',
    body:
        'You may delete your account at any time '
        'through Settings > Account. We reserve the right '
        'to suspend or terminate accounts that violate '
        'these terms. Upon termination, all associated '
        'data will be permanently deleted.',
  ),
  LegalSection(
    title: 'Changes to Terms',
    body:
        'We may update these Terms of Service from '
        'time to time. We will notify you of significant '
        'changes through the app. Continued use of the '
        'app after changes constitutes acceptance of the '
        'updated terms.',
  ),
  LegalSection(
    title: 'Contact Us',
    body:
        'If you have questions about these Terms of '
        'Service, please contact us at $_contactEmail.',
  ),
];

const _termsJa = [
  LegalSection(
    title: '要点',
    body:
        '- Seedを使用するにはアカウントの'
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
    body:
        'Seedモバイルアプリケーションのアカウントを'
        '作成するか、アプリを使用することにより、'
        'お客様はこの利用規約に拘束されることに'
        '同意するものとします。これらの条件に同意'
        'されない場合は、アプリを使用しないでください。',
  ),
  LegalSection(
    title: 'サービスの説明',
    body:
        'Seedは、ユーザーがエコフレンドリーな活動を'
        '記録し、推定CO2影響に基づくポイントを獲得し、'
        'バーチャルマスコットを育て、国連の持続可能な'
        '開発目標（SDGs）について学ぶことができる'
        'サステナビリティ習慣追跡アプリケーションです。',
  ),
  LegalSection(
    title: 'ユーザーアカウント',
    body:
        'Seedを使用するにはアカウントを作成する'
        '必要があります。アカウントの認証情報の機密性を'
        '維持し、アカウントで行われるすべての活動に'
        '責任を負うものとします。アカウント作成時には'
        '正確かつ完全な情報を提供することに同意します。',
  ),
  LegalSection(
    title: '利用規則',
    body:
        'Seedは意図された目的のみに使用することに'
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
    body:
        'アクションの記録で獲得したポイントや'
        '仮想アイテムは、'
        '現実世界の金銭的価値を持ちません。アプリ内'
        'でのみ存在し、アプリ外での交換、譲渡、'
        '返金はできません。',
  ),
  LegalSection(
    title: '知的財産',
    body:
        'Seed内のすべてのコンテンツ、デザイン、'
        'グラフィックス、ソフトウェアは当社が所有'
        'またはライセンスを受けたものです。事前の'
        '書面による許可なく、当社のコンテンツを'
        'コピー、変更、配布、または派生物を作成する'
        'ことはできません。',
  ),
  LegalSection(
    title: 'CO2影響の推定値',
    body:
        'Seedで提供されるCO2削減の推定値は、'
        '公開されている研究と平均値に基づく概算値です。'
        '教育的および動機付けの目的であり、正確な'
        '科学的測定値とはみなされません。実際の'
        '環境影響は個人の状況により異なる場合があります。',
  ),
  LegalSection(
    title: '保証の免責',
    body:
        'Seedは明示的または黙示的を問わず、いかなる'
        '種類の保証もなく「現状のまま」で提供されます。'
        'アプリが中断なく、エラーなく、または有害な'
        'コンポーネントなく動作することを保証しません。',
  ),
  LegalSection(
    title: '責任の制限',
    body:
        '法律で許容される最大限の範囲において、'
        'Seedおよびその開発者は、アプリの使用に起因する'
        '間接的、偶発的、特別、または結果的損害について'
        '責任を負わないものとします。',
  ),
  LegalSection(
    title: 'アカウントの停止と削除',
    body:
        '設定 > アカウントからいつでもアカウントを'
        '削除できます。当社は、これらの規約に違反する'
        'アカウントを一時停止または削除する権利を'
        '留保します。削除時には、関連するすべての'
        'データが完全に削除されます。',
  ),
  LegalSection(
    title: '規約の変更',
    body:
        '当社はこの利用規約を随時更新する場合が'
        'あります。重要な変更についてはアプリ内で'
        'お知らせします。変更後もアプリを継続して使用'
        'することは、更新された規約への同意を意味します。',
  ),
  LegalSection(
    title: 'お問い合わせ',
    body:
        'この利用規約についてご質問がある場合は、'
        '$_contactEmail までご連絡ください。',
  ),
];

const _termsEs = [
  LegalSection(
    title: 'Puntos clave',
    body:
        '- Debe crear una cuenta para usar Seed\n'
        '- Los puntos y artículos virtuales no '
        'tienen valor monetario real\n'
        '- Las estimaciones de CO2 son aproximadas, '
        'con fines educativos\n'
        '- Puede eliminar su cuenta en cualquier '
        'momento desde Ajustes\n'
        '- La aplicación se proporciona "tal cual" '
        'sin garantías',
  ),
  LegalSection(
    title: 'Aceptación de los términos',
    body:
        'Al crear una cuenta o utilizar la aplicación '
        'móvil Seed, usted acepta estar sujeto a estos '
        'Términos de Servicio. Si no está de acuerdo con '
        'estos términos, no utilice la '
        'aplicación.',
  ),
  LegalSection(
    title: 'Descripción del servicio',
    body:
        'Seed es una aplicación de seguimiento de '
        'hábitos de sostenibilidad que permite a los '
        'usuarios registrar acciones ecológicas, ganar '
        'puntos basados en el impacto estimado de CO2, '
        'criar una mascota virtual y aprender sobre los '
        'Objetivos de Desarrollo Sostenible (ODS) de las '
        'Naciones Unidas.',
  ),
  LegalSection(
    title: 'Cuentas de usuario',
    body:
        'Debe crear una cuenta para usar Seed. Usted '
        'es responsable de mantener la confidencialidad '
        'de las credenciales de su cuenta y de todas las '
        'actividades realizadas con su cuenta. Acepta '
        'proporcionar información precisa y completa al '
        'crear su cuenta.',
  ),
  LegalSection(
    title: 'Uso aceptable',
    body:
        'Acepta usar Seed solo para el fin previsto. '
        'No debe:\n\n'
        '- Intentar obtener acceso no autorizado a la '
        'aplicación o sus sistemas\n'
        '- Usar la aplicación para transmitir contenido '
        'dañino o malicioso\n'
        '- Crear múltiples cuentas para manipular puntos '
        'o clasificaciones\n'
        '- Realizar ingeniería inversa o descompilar la '
        'aplicación\n'
        '- Usar sistemas automatizados para interactuar '
        'con la aplicación',
  ),
  LegalSection(
    title: 'Puntos y artículos virtuales',
    body:
        'Los puntos y artículos virtuales ganados al '
        'registrar acciones no tienen valor monetario '
        'real. '
        'Existen únicamente dentro de la aplicación y '
        'no pueden intercambiarse, transferirse ni '
        'reembolsarse fuera de la aplicación.',
  ),
  LegalSection(
    title: 'Propiedad intelectual',
    body:
        'Todo el contenido, diseños, gráficos y '
        'software de Seed son de nuestra propiedad o '
        'contamos con licencia para usarlos. No puede copiar, '
        'modificar, distribuir o crear obras derivadas '
        'de nuestro contenido sin permiso previo por '
        'escrito.',
  ),
  LegalSection(
    title: 'Estimaciones de impacto de CO2',
    body:
        'Las estimaciones de ahorro de CO2 '
        'proporcionadas en Seed son valores aproximados '
        'basados en investigaciones públicas y medias. '
        'Están destinadas a fines educativos y '
        'motivacionales y no deben considerarse '
        'mediciones científicas exactas. El impacto '
        'ambiental real puede variar según las '
        'circunstancias individuales.',
  ),
  LegalSection(
    title: 'Exención de garantías',
    body:
        'Seed se proporciona "tal cual" sin garantías '
        'de ningún tipo, ya sean expresas o implícitas. '
        'No garantizamos que la aplicación funcione sin '
        'interrupciones ni errores, ni que esté libre de '
        'componentes dañinos.',
  ),
  LegalSection(
    title: 'Limitación de responsabilidad',
    body:
        'En la medida máxima permitida por la ley, '
        'Seed y sus desarrolladores no serán '
        'responsables de ningún daño indirecto, '
        'incidental, especial o consecuente derivado '
        'del uso de la aplicación.',
  ),
  LegalSection(
    title: 'Cancelación de la cuenta',
    body:
        'Puede eliminar su cuenta en cualquier momento '
        'desde Ajustes > Cuenta. Nos reservamos el '
        'derecho a suspender o cancelar las cuentas que '
        'incumplan estos términos. Tras la cancelación, '
        'todos los datos asociados se eliminarán de '
        'forma permanente.',
  ),
  LegalSection(
    title: 'Cambios en los términos',
    body:
        'Podemos actualizar estos Términos de Servicio '
        'periódicamente. Le avisaremos de los cambios '
        'importantes a través de la aplicación. '
        'El uso continuado de la aplicación después de '
        'los cambios constituye la aceptación de los '
        'términos actualizados.',
  ),
  LegalSection(
    title: 'Contacto',
    body:
        'Si tiene preguntas sobre estos Términos de '
        'Servicio, escríbanos a $_contactEmail.',
  ),
];
