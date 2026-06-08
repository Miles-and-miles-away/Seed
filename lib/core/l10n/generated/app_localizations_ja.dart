// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Seed';

  @override
  String get appTagline => 'サステナブルな習慣を育てよう';

  @override
  String get navHome => 'ホーム';

  @override
  String get navProgress => '進捗';

  @override
  String get navLogAction => 'アクション';

  @override
  String get navMascot => 'マスコット';

  @override
  String get navProfile => 'プロフ';

  @override
  String get navSettings => '設定';

  @override
  String get authLogin => 'ログイン';

  @override
  String get authRegister => '新規登録';

  @override
  String get authLogout => 'ログアウト';

  @override
  String get authEmail => 'メールアドレス';

  @override
  String get authPassword => 'パスワード';

  @override
  String get authConfirmPassword => 'パスワード確認';

  @override
  String get authForgotPassword => 'パスワードをお忘れですか？';

  @override
  String get authContinueWithGoogle => 'Googleで続ける';

  @override
  String get authContinueWithApple => 'Appleで続ける';

  @override
  String get authOrDivider => 'または';

  @override
  String homeWelcome(String name) {
    return 'おかえりなさい、$nameさん！';
  }

  @override
  String get homeLogAction => 'アクションを記録';

  @override
  String get homeRecentActions => '最近のアクション';

  @override
  String get homeNoActions => 'まだアクションがありません。始めましょう！';

  @override
  String get actionLogTitle => 'アクションを記録';

  @override
  String get actionSearchHint => 'アクションを検索...';

  @override
  String actionLogged(int points) {
    return '記録しました！ $pointsポイント獲得';
  }

  @override
  String get noActionsFound => 'アクションが見つかりません';

  @override
  String get actionHistoryTitle => 'アクション履歴';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get addNoteOptional => 'メモを追加（任意）';

  @override
  String get noteHint => '例：お店でマイバッグを使った';

  @override
  String pointsLabel(int count) {
    return '$countポイント';
  }

  @override
  String levelLabel(int level) {
    return 'レベル$level';
  }

  @override
  String streakLabel(int days) {
    return '$days日連続';
  }

  @override
  String co2Saved(String amount) {
    return '$amount CO₂削減';
  }

  @override
  String mascotName(String name) {
    return '$name';
  }

  @override
  String get mascotRename => '名前を変更';

  @override
  String mascotEvolution(int stage) {
    return '進化段階 $stage';
  }

  @override
  String get mascotSelectionTitle => 'あなたの相棒を選ぼう';

  @override
  String get mascotSelectionSubtitle => 'この小さな友達があなたのサステナビリティの旅に一緒に成長します！';

  @override
  String get mascotNameLabel => '相棒に名前をつけよう';

  @override
  String get mascotNameHint => '例：スプラウティ、リーフィ、バド...';

  @override
  String get mascotNameRequired => '名前を入力してください';

  @override
  String get mascotNameTooLong => '名前は20文字以内にしてください';

  @override
  String get mascotSelectionConfirm => '一緒に成長しよう！';

  @override
  String get evolutionTitle => '進化！';

  @override
  String get evolutionSubtitle => 'あなたの相棒がもっと強くなりました！';

  @override
  String get evolutionContinue => 'すごい！';

  @override
  String get profileTitle => 'プロフィール';

  @override
  String get profileStats => '統計';

  @override
  String get profileTotalActions => '合計アクション';

  @override
  String get profileTotalCO2 => '合計CO₂削減量';

  @override
  String get profileMemberSince => '登録日';

  @override
  String get profileCurrentStreak => '現在の連続日数';

  @override
  String get profileLongestStreak => '最長連続日数';

  @override
  String profileNextLevel(int points) {
    return '次のレベルまで$pointsポイント';
  }

  @override
  String profileDaysActive(int days) {
    return '$days日';
  }

  @override
  String profileEvolutionStage(int stage) {
    return '進化段階$stage';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsReminderTime => '毎日のリマインダー';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsThemeSystem => 'システム';

  @override
  String get settingsThemeLight => 'ライト';

  @override
  String get settingsThemeDark => 'ダーク';

  @override
  String get settingsAccount => 'アカウント';

  @override
  String get settingsSubscription => 'サブスクリプション';

  @override
  String get settingsAbout => 'このアプリについて';

  @override
  String get settingsPrivacy => 'プライバシーポリシー';

  @override
  String get settingsTerms => '利用規約';

  @override
  String get subscriptionFree => '無料';

  @override
  String get subscriptionPremium => 'プレミアム';

  @override
  String get subscriptionUpgrade => 'プレミアムにアップグレード';

  @override
  String get categoryRecycling => 'リサイクル';

  @override
  String get categoryTransport => '移動';

  @override
  String get categoryFood => '食事';

  @override
  String get categoryEnergy => 'エネルギー';

  @override
  String get categoryConsumption => '消費';

  @override
  String get categoryWater => '水';

  @override
  String get categoryCommunity => 'コミュニティ';

  @override
  String get categoryAdvocacy => 'アドボカシー';

  @override
  String get categoryLearning => '学習';

  @override
  String get errorGeneric => 'エラーが発生しました。もう一度お試しください。';

  @override
  String get errorNetwork => 'インターネット接続がありません。';

  @override
  String get errorAuth => '認証に失敗しました。もう一度お試しください。';

  @override
  String get buttonSave => '保存';

  @override
  String get buttonCancel => 'キャンセル';

  @override
  String get buttonConfirm => '確認';

  @override
  String get buttonClose => '閉じる';

  @override
  String get buttonRetry => '再試行';

  @override
  String get buttonContinue => '続ける';

  @override
  String get progressTitle => '進捗';

  @override
  String get progressGoalsToday => '今日の目標';

  @override
  String get progressGoalReached => '日目標達成！';

  @override
  String get progressSetDailyGoal => '毎日の目標を設定';

  @override
  String get progressSetDailyGoalSubtitle => '毎日いくつのエコアクションを達成したいですか？';

  @override
  String get progressStartJourney => '始める';

  @override
  String get progressTargetDescriptionEasy => '優しいスタート — 初心者にぴったり！';

  @override
  String get progressTargetDescriptionModerate =>
      'バランスの取れたチャレンジ — ほとんどのユーザーにおすすめ。';

  @override
  String get progressTargetDescriptionChallenge => '野心的！環境への影響を与えることに真剣です。';

  @override
  String get progressTargetDescriptionExpert =>
      'エキスパートレベル — あなたはサステナビリティチャンピオンです！';

  @override
  String get languageSettingsTitle => '言語';

  @override
  String get languageSettingsDescription => '希望の言語を選択してください。アプリはすぐに更新されます。';

  @override
  String get languageSettingsNote => 'アクションライブラリの一部のコンテンツは元の言語のままになる場合があります。';

  @override
  String settingsNotificationsSubtitle(int count) {
    return '$count件のリマインダーが有効';
  }

  @override
  String get settingsNotificationsOff => '通知はオフです';

  @override
  String settingsLanguageSubtitle(String language) {
    return '$language';
  }

  @override
  String get settingsAccountSubtitle => 'メール、パスワード、アカウント削除';

  @override
  String get settingsAboutSubtitle => 'バージョン、ライセンス、お問い合わせ';

  @override
  String get accountSettingsTitle => 'アカウント';

  @override
  String get accountSettingsEmail => 'メールアドレス';

  @override
  String get accountSettingsChangeEmail => 'メールアドレスを変更';

  @override
  String get accountSettingsChangePassword => 'パスワードを変更';

  @override
  String get accountSettingsDeleteAccount => 'アカウントを削除';

  @override
  String get accountSettingsDeleteAccountWarning =>
      'この操作は取り消せません。すべてのデータが完全に削除されます。';

  @override
  String get accountSettingsDeleteConfirmTitle => 'アカウントを削除しますか？';

  @override
  String get accountSettingsDeleteConfirmMessage =>
      '本当にアカウントを削除しますか？マスコット、アクション履歴、進捗などすべてのデータが完全に削除されます。';

  @override
  String get accountSettingsDeleteConfirmButton => 'アカウントを削除';

  @override
  String get accountSettingsCurrentEmail => '現在のメールアドレス';

  @override
  String get accountSettingsNewEmail => '新しいメールアドレス';

  @override
  String get accountSettingsCurrentPassword => '現在のパスワード';

  @override
  String get accountSettingsNewPassword => '新しいパスワード';

  @override
  String get accountSettingsConfirmNewPassword => '新しいパスワードを確認';

  @override
  String get accountSettingsPasswordMismatch => 'パスワードが一致しません';

  @override
  String get accountSettingsEmailUpdated => 'メールアドレスが更新されました';

  @override
  String get accountSettingsPasswordUpdated => 'パスワードが更新されました';

  @override
  String get accountSettingsReauthRequired => '続行するには、パスワードを再入力してください';

  @override
  String get accountSettingsProfile => 'プロフィール';

  @override
  String get accountSettingsDisplayName => '表示名';

  @override
  String get accountSettingsNotSet => '未設定';

  @override
  String get accountSettingsDisplayNameUpdated => '表示名が更新されました';

  @override
  String get accountSettingsDisplayNameRequired => '名前を入力してください';

  @override
  String get aboutSettingsTitle => 'このアプリについて';

  @override
  String get aboutSettingsVersion => 'バージョン';

  @override
  String get aboutSettingsLicenses => 'オープンソースライセンス';

  @override
  String get aboutSettingsPrivacy => 'プライバシーポリシー';

  @override
  String get aboutSettingsTerms => '利用規約';

  @override
  String get streakMilestoneTitle => 'すごい！';

  @override
  String streakMilestoneWeeks(int count) {
    return '$count週間連続達成！';
  }

  @override
  String streakMilestoneDays(int count) {
    return '$count日連続でアクションを記録しました！';
  }

  @override
  String get streakMilestoneKeepGoing => 'この調子で続けましょう！';

  @override
  String get streakMilestoneContinue => '続ける';

  @override
  String get streakBrokenTitle => '連続記録が途切れました';

  @override
  String get streakBrokenMessage => '大丈夫！今日から新しい記録を始めましょう。';

  @override
  String streakBrokenPrevious(int count) {
    return '前回の記録: $count日';
  }

  @override
  String get streakBrokenStartNew => '新しい記録を始める';

  @override
  String get sortLabel => '並べ替え';

  @override
  String get sortAlphabeticalAZ => '名前 (あ→わ)';

  @override
  String get sortAlphabeticalZA => '名前 (わ→あ)';

  @override
  String get sortCo2HighToLow => 'CO₂ (多い順)';

  @override
  String get sortCo2LowToHigh => 'CO₂ (少ない順)';

  @override
  String get sortPointsHighToLow => 'ポイント (多い順)';

  @override
  String get sortPointsLowToHigh => 'ポイント (少ない順)';

  @override
  String get filterBySDG => 'SDGでフィルター';

  @override
  String get allCategories => 'すべて';

  @override
  String co2PerAction(Object amount) {
    return '${amount}g CO₂';
  }

  @override
  String get sdgYourImpact => 'あなたの影響';

  @override
  String sdgActionsLogged(int count) {
    return '$count件のアクションを記録';
  }

  @override
  String sdgCo2SavedForGoal(String amount) {
    return 'この目標への$amount CO₂削減';
  }

  @override
  String get sdgRelatedActions => '関連アクション';

  @override
  String get sdgViewAllActions => 'すべて表示';

  @override
  String get sdgResources => 'リソース';

  @override
  String get sdgLearnOnlyExplanation =>
      'この目標は集団的な行動を必要とする体系的な問題に取り組んでいます。直接的な日々のアクションは記録できませんが、学ぶことで全体像を理解し、貢献する方法を見つけることができます。';

  @override
  String get sdgWaysToContribute => '貢献する方法';

  @override
  String get sdgNoActionsYet => 'この目標に関連するアクションはまだ記録されていません';

  @override
  String get learnOnlyBadge => '学ぶ';

  @override
  String get learnOnlyTitle => 'このアクションについて学ぶ';

  @override
  String get learnOnlyDescription =>
      'このアクションはより広いサステナビリティ目標を支援します。直接記録はできませんが、学ぶことで全体像を理解できます。';

  @override
  String get learnOnlyRelatedSdgs => '関連する目標';

  @override
  String get learnOnlyDismiss => '了解';

  @override
  String get settingsAnalytics => 'プライバシー';

  @override
  String get settingsAnalyticsSubtitle => '匿名の使用データを共有してSeedの改善にご協力ください';

  @override
  String get privacyPolicyTitle => 'プライバシーポリシー';

  @override
  String get termsOfServiceTitle => '利用規約';

  @override
  String legalLastUpdated(String date) {
    return '最終更新日: $date';
  }

  @override
  String get eggDiscoveryTitle => '不思議なタマゴ！';

  @override
  String eggDiscoveryMessage(String mascotName) {
    return '一晩で、$mascotNameのそばに不思議なタマゴが現れました！';
  }

  @override
  String get eggDiscoverySubtitle => '30日間毎日アクションを記録して孵化させよう。';

  @override
  String get eggDiscoveryDismiss => 'わくわくする！';

  @override
  String get eggHatchingTitle => '孵化中！';

  @override
  String get eggHatchingNamePrompt => '新しい相棒に名前をつけよう';

  @override
  String get eggHatchingConfirm => 'ようこそ！';

  @override
  String eggProgressLabel(int current, int total) {
    return '$current日目/$total日';
  }

  @override
  String get mascotCollectionTitle => 'マイマスコット';

  @override
  String get mascotSwitchConfirm => 'マスコットを切り替える？';

  @override
  String get switchToMascot => '切り替え先:';

  @override
  String get switchMascotButton => '切り替え';

  @override
  String get actionLearnMore => 'タップして科学を学ぶ';

  @override
  String get maxEvolutionTitle => '最大進化！';

  @override
  String get maxEvolutionSubtitle => 'あなたの相棒は最高の姿に到達しました！';

  @override
  String get maxEvolutionEggHint => 'タマゴを育てて新しい相棒を見つけよう！';

  @override
  String get sdgAboutGoal => 'この目標について';

  @override
  String get sdgViewTargets => 'ターゲットを見る';

  @override
  String get sdgTargetsTitle => '国連ターゲット';

  @override
  String get notifSettingsTitle => '通知設定';

  @override
  String get notifSectionNotifications => '通知';

  @override
  String get notifEnableTitle => '通知を有効にする';

  @override
  String get notifEnableSubtitle => 'アクション記録のリマインダーを受け取る';

  @override
  String get notifSmartTitle => 'スマートリマインダー';

  @override
  String get notifSmartOnlyTitle => '今日アクションがない場合のみ通知';

  @override
  String get notifSmartOnlySubtitle => '既に記録した日はリマインダーをスキップ';

  @override
  String get notifSmartDescription =>
      '有効にすると、その日にサステナブルなアクションを記録していない場合のみリマインダーが表示されます。';

  @override
  String get notifReminderTimesTitle => 'リマインダー時間';

  @override
  String get notifNoReminders => 'リマインダーが設定されていません';

  @override
  String get notifAddReminder => 'リマインダーを追加して通知を受け取る';

  @override
  String get notifAddReminderTime => 'リマインダー時間を追加';

  @override
  String get notifMaxReminders => 'リマインダーは最大5件まで';

  @override
  String get notifEditTime => 'リマインダー時間を編集';

  @override
  String get notifSelectTime => 'リマインダー時間を選択';

  @override
  String get notifLabelTitle => 'リマインダーラベル';

  @override
  String get notifLabelHint => '例：朝、仕事後...';

  @override
  String get notifLabelOptional => 'ラベル（任意）';

  @override
  String get notifDeleteTitle => 'リマインダーを削除しますか？';

  @override
  String notifDeleteMessage(String time) {
    return '$timeのリマインダーを削除しますか？';
  }

  @override
  String get notifAdd => '追加';

  @override
  String get settingsPreferences => '設定';

  @override
  String settingsVersionFormat(String version) {
    return 'バージョン $version';
  }

  @override
  String get settingsNoReminders => 'リマインダーが設定されていません';

  @override
  String settingsRemindersCount(int count) {
    return '$count件のリマインダー設定済み';
  }

  @override
  String get settingsOneReminder => '1件のリマインダー設定済み';

  @override
  String get settingsTapToAddReminders => 'タップしてリマインダーを追加';

  @override
  String get settingsAllRemindersDisabled => '全リマインダーが無効';

  @override
  String settingsRemindersPlusMore(String time, int count) {
    return '$time + 他$count件';
  }

  @override
  String get settingsErrorLoading => '設定の読み込みエラー';

  @override
  String get settingsSupport => 'サポート';

  @override
  String get settingsFeedback => 'フィードバックを送る';

  @override
  String get settingsFeedbackSubtitle => 'バグ報告や感想をお寄せください';

  @override
  String get aboutLegal => '法的情報';

  @override
  String get aboutFooterSdg => 'Seedは国連の持続可能な開発目標に沿ったサステナブルなアクションを記録するアプリです。';

  @override
  String get aboutFooterMade => '地球への思いを込めて。';

  @override
  String get aboutSubtitleTracker => 'サステナビリティ習慣トラッカー';

  @override
  String get feedbackTitle => 'フィードバックを送る';

  @override
  String get feedbackCategoryLabel => 'カテゴリー';

  @override
  String get feedbackCategoryBug => 'バグ報告';

  @override
  String get feedbackCategoryFeature => '機能のリクエスト';

  @override
  String get feedbackCategoryGeneral => '一般的なフィードバック';

  @override
  String get feedbackDescriptionLabel => 'フィードバックの内容';

  @override
  String get feedbackDescriptionHint => 'ご意見をお聞かせください...';

  @override
  String get feedbackMetadataNote =>
      '調査のため、以下の情報を一緒に送信します: アプリのバージョン、端末とOS、言語、アカウントID。';

  @override
  String get feedbackSubmit => '送信する';

  @override
  String get feedbackThanks => 'フィードバックありがとうございます！';

  @override
  String get feedbackMailFailed => 'メールアプリを開けませんでした。もう一度お試しください。';

  @override
  String get mascotEvolutionTimeline => '進化タイムライン';

  @override
  String get mascotNextEvolution => '次の進化';

  @override
  String get mascotStatsTitle => 'ふたりの歩み';

  @override
  String get mascotStatBirthday => '誕生日';

  @override
  String get mascotStatDaysTogether => '一緒に過ごした日数';

  @override
  String get mascotStatCo2Together => '一緒に削減したCO₂';

  @override
  String mascotLevelShort(int level) {
    return 'Lv $level';
  }

  @override
  String mascotLevelsToGo(int count) {
    return 'あと$countレベル';
  }

  @override
  String mascotLevelProgress(int current, int max) {
    return 'レベル $current / $max';
  }

  @override
  String get homeExploreGoals => 'SDGsの目標を探る';

  @override
  String get homeExploreGoalsSubtitle => '国連の持続可能な開発目標について学ぶ';

  @override
  String get homeLearnMore => 'UN.orgで詳しく見る';

  @override
  String get homePoints => 'ポイント';

  @override
  String get myGoalTitle => 'マイゴール';

  @override
  String get myGoalEmptyPrompt => 'タップしてあなたの目標を設定しましょう';

  @override
  String get myGoalUpdated => '目標が更新されました';

  @override
  String get goalPickerTitle => '目標を選びましょう';

  @override
  String get goalPickerCustomOption => '自分で書く';

  @override
  String get goalPickerCustomHint => '私の目標は…';

  @override
  String get personalGoalReduceFlights => '長距離フライトを減らす';

  @override
  String get personalGoalPlantBased => '植物性の食事を増やす';

  @override
  String get personalGoalLessPlastic => '使い捨てプラスチックをやめる';

  @override
  String get personalGoalWalkBike => '車の代わりに徒歩や自転車で移動する';

  @override
  String get personalGoalLessFoodWaste => '食品ロスを減らす';

  @override
  String get personalGoalBuyLess => '買う量を減らして再利用する';

  @override
  String get personalGoalInspireOthers => '友人や家族に行動を促す';

  @override
  String get personalGoalSaveWorld => '世界を救う';

  @override
  String sdgGoalNumber(int number) {
    return '目標 $number';
  }

  @override
  String get sdgBadge => '国連SDG';

  @override
  String get buttonDelete => '削除';

  @override
  String get buttonSkip => 'スキップ';

  @override
  String get authWelcomeBack => 'おかえりなさい';

  @override
  String get authSignInSubtitle => 'サステナビリティの旅を続けましょう';

  @override
  String get authSignIn => 'サインイン';

  @override
  String get authOrContinueWith => 'または次の方法で続ける';

  @override
  String get authNoAccount => 'アカウントをお持ちでないですか？';

  @override
  String get authCreateAccount => 'アカウント作成';

  @override
  String get authCreateAccountSubtitle => '今日からサステナビリティの旅を始めましょう';

  @override
  String get authOrSignUpWith => 'または次の方法で登録';

  @override
  String get authHaveAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get authAgreePrefix => '以下に同意します: ';

  @override
  String get authAgreeAnd => 'および';

  @override
  String get authAcceptTermsError => '利用規約とプライバシーポリシーに同意してください';

  @override
  String get authForgotPasswordTitle => 'パスワードをリセット';

  @override
  String get authForgotPasswordHint => 'メールアドレスを入力してください';

  @override
  String get authForgotPasswordSend => '送信';

  @override
  String get authForgotPasswordSent =>
      'このメールアドレスのアカウントが存在する場合、パスワードリセットリンクが送信されました。';

  @override
  String get authVerifyEmailTitle => 'メール認証';

  @override
  String get authCheckEmail => 'メールを確認してください';

  @override
  String get authVerificationSentTo => '確認リンクを送信しました:';

  @override
  String get authVerifyInstructions =>
      'メール内のリンクをクリックしてアカウントを認証し、ここに戻って下のボタンをタップしてください。';

  @override
  String get authChecking => '確認中...';

  @override
  String get authVerifiedButton => 'メールを認証しました';

  @override
  String get authVerificationSent => '認証メールを送信しました！';

  @override
  String get authResendEmail => 'メールを再送信';

  @override
  String get authDifferentEmail => '別のメールアドレスを使用';

  @override
  String get authEmailVerified => 'メール認証完了！Seedへようこそ！';

  @override
  String get authEmailNotVerified =>
      'メールがまだ認証されていません。受信トレイを確認し、認証リンクをクリックしてください。';

  @override
  String get authValidationEmailRequired => 'メールアドレスを入力してください';

  @override
  String get authValidationEmailInvalid => '有効なメールアドレスを入力してください';

  @override
  String get authValidationPasswordRequired => 'パスワードを入力してください';

  @override
  String get authValidationPasswordShort => 'パスワードは6文字以上にしてください';

  @override
  String get authValidationConfirmRequired => 'パスワードを確認してください';

  @override
  String pointsAbbreviated(int count) {
    return '$count pts';
  }

  @override
  String stageFallback(int stage) {
    return 'ステージ $stage';
  }

  @override
  String get dayDetailActions => 'アクション';

  @override
  String get dayDetailNoActions => 'この日のアクション記録はありません';

  @override
  String get dayDetailFactLocked => 'この日のエコファクトは解除されていません';

  @override
  String get ecoFactTitle => '今日のエコファクト';

  @override
  String get ecoFactDidYouKnow => '知っていましたか？';

  @override
  String get ecoFactSource => '出典';

  @override
  String get ecoFactLocked => '今日のチャレンジを完了してファクトを解除しよう！';

  @override
  String get ecoFactInboxTitle => '受信トレイ';

  @override
  String get ecoFactInboxEmpty => 'まだメールはありません。今日のチャレンジを完了して最初のエコファクトを受け取ろう。';

  @override
  String get ecoFactInboxLockedSubject => 'ロック中のエコファクト';

  @override
  String get ecoFactCategoryComparison => '比較';

  @override
  String get ecoFactCategoryIndividual => '個人の影響';

  @override
  String get ecoFactCategoryMythBuster => '誤解を解く';

  @override
  String get ecoFactCategoryNatureWonder => '自然の驚異';

  @override
  String get ecoFactCategoryPositiveNews => 'ポジティブニュース';

  @override
  String get challengeDialogTitle => '今日のチャレンジ';

  @override
  String get challengeDialogLater => 'あとで';

  @override
  String get challengeDialogLogAction => 'アクションを記録';

  @override
  String get challengeDialogUnlock => '完了して今日のエコファクトを解除しよう！';

  @override
  String get challengeTabLabel => 'チャレンジ';

  @override
  String get challengeCompleted => '完了！';

  @override
  String get challengeNotCompleted => '未完了';

  @override
  String get challengeSeeFact => '今日のエコファクトを見る';

  @override
  String challengeStreakDays(int days) {
    return 'チャレンジ$days日連続';
  }

  @override
  String challengeMultiDayProgress(int current, int target) {
    return '$target日中$current日目';
  }

  @override
  String get challengeCompletedSnackbar => 'チャレンジ完了！エコファクトが解除されました！';

  @override
  String get challengeBrowse => 'チャレンジを探す';

  @override
  String get challengesScreenTitle => 'マルチデイチャレンジ';

  @override
  String get challengeStart => 'チャレンジ開始';

  @override
  String get challengeStartConfirm => 'このチャレンジを開始しますか？';

  @override
  String get challengeActive => '進行中';

  @override
  String get challengeCompletedBadge => '完了';

  @override
  String get challengeAvailable => '利用可能';

  @override
  String get challengeAbandon => '中断';

  @override
  String get challengeAbandonConfirm => 'このチャレンジを中断しますか？進捗は失われます。';

  @override
  String challengeDays(int days) {
    return '$days日間';
  }

  @override
  String get challengeAnyCategory => '全カテゴリ';

  @override
  String get challengeLocked => 'ロック中';

  @override
  String get progressCalendarTab => 'カレンダー';

  @override
  String get ecoDexTab => 'エコ図鑑';

  @override
  String get impactTab => 'インパクト';

  @override
  String get periodToday => '今日';

  @override
  String get periodThisWeek => '今週';

  @override
  String get periodThisMonth => '今月';

  @override
  String get periodAllTime => '累計';

  @override
  String get co2SavedToday => '今日のCO2削減量';

  @override
  String get co2SavedThisWeek => '今週のCO2削減量';

  @override
  String get co2SavedThisMonth => '今月のCO2削減量';

  @override
  String get co2SavedAllTime => '累計のCO2削減量';

  @override
  String get kgUnit => 'kg';

  @override
  String get vsYesterday => '昨日比';

  @override
  String get vsLastWeek => '先週比';

  @override
  String get vsLastMonth => '先月比';

  @override
  String get trendChartTitle => '日々の推移';

  @override
  String get trendChartAverageLabel => '平均';

  @override
  String get categoryChartTitle => 'カテゴリ別';

  @override
  String get categoryOther => 'その他';

  @override
  String get equivalentToHeader => 'つまり';

  @override
  String get equivTreesLabel => '本・年（成木）';

  @override
  String get equivCarKmLabel => 'km の運転回避';

  @override
  String get equivPhoneChargesLabel => '回のスマホ充電';

  @override
  String get equivBurgersLabel => '個の牛肉バーガー';

  @override
  String get impactInfoTooltip => '計算方法について';

  @override
  String get impactInfoTitle => '計算方法について';

  @override
  String get impactInfoIntro =>
      '節約した CO2 を身近な例に換算しています。世界平均を使い、CO2 と CO2 換算（メタン、電力、食料ライフサイクル）を併用しているため、あくまで目安です。実際の効果は地域の電源構成や供給網によって変わります。';

  @override
  String get impactInfoFormulaLabel => '計算式';

  @override
  String get impactInfoSourceLabel => '出典';

  @override
  String get equivTreesExplainer =>
      '成木一本が一年間に吸収する CO2 量の目安です。植えたばかりの苗木が吸収する量はこれよりずっと少なくなります。';

  @override
  String get equivCarKmExplainer =>
      'ガソリン・ディーゼル車を含めた平均的な乗用車が 1 km 走行するときの CO2 排出量です。';

  @override
  String get equivPhoneChargesExplainer =>
      '平均的なスマートフォンを一度満充電するのに必要な電力量を、米国の電源構成で換算した値です。再エネ比率の高い地域ではより少なく、石炭依存の高い地域では多くなります。';

  @override
  String get equivBurgersExplainer =>
      '牛肉バーガー一個分の生産から小売までのライフサイクル排出量です。鶏肉や植物性バーガーは概ね 5〜10 分の 1 程度に収まります。';

  @override
  String equivFormulaTemplate(String factor) {
    return 'CO2 のグラム数 ÷ $factor';
  }

  @override
  String get ecoDexTitle => 'エコ図鑑';

  @override
  String ecoDexProgress(int discovered, int total) {
    return '$discovered / $total 発見済み';
  }

  @override
  String get ecoDexLocked => '未発見';

  @override
  String get ecoDexViewSource => '出典を見る';

  @override
  String get ecoDexNewDiscovery => '新しいエコ図鑑の発見！';

  @override
  String get ecoDexNextUp => 'もうすぐ発見';

  @override
  String get ecoDexDiscoveryTitle => '新発見！';

  @override
  String get ecoDexDiscoveryAcknowledge => 'やったね！';

  @override
  String ecoDexDiscoveryMoreQueued(int count) {
    return '他に$count件';
  }

  @override
  String get ecoDexEmptyHint => '最初のアクションを記録して最初の発見をしましょう。';

  @override
  String get ecoDexInfoTooltip => 'エコ図鑑について';

  @override
  String get ecoDexInfoTitle => 'エコ図鑑について';

  @override
  String get ecoDexInfoBody =>
      'エコ図鑑は地球に関する事実を集めた百科事典です。アクションの記録、CO2の削減、ストリークの継続、チャレンジの達成、エコ知識の閲覧など、Seedを使ううちに自動で解放されます。ロック中のカードをタップすると発見のヒントが、発見済みのエントリーをタップすると詳しい事実が見られます。発見でポイントは増えません。発見した知識そのものがごほうびです。';
}
