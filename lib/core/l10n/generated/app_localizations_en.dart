// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Seed';

  @override
  String get appTagline => 'Grow your sustainability habits';

  @override
  String get navHome => 'Home';

  @override
  String get navProgress => 'Progress';

  @override
  String get navLogAction => 'Action';

  @override
  String get navMascot => 'Mascot';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get authLogin => 'Log In';

  @override
  String get authRegister => 'Sign Up';

  @override
  String get authLogout => 'Log Out';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithApple => 'Continue with Apple';

  @override
  String get authOrDivider => 'or';

  @override
  String homeWelcome(String name) {
    return 'Welcome back, $name!';
  }

  @override
  String get homeLogAction => 'Log Action';

  @override
  String get homeRecentActions => 'Recent Actions';

  @override
  String get homeNoActions => 'No actions logged yet. Start your journey!';

  @override
  String get actionLogTitle => 'Log an Action';

  @override
  String get actionSearchHint => 'Search actions...';

  @override
  String actionLogged(int points) {
    return 'Action logged! $points points earned';
  }

  @override
  String get noActionsFound => 'No actions found';

  @override
  String get actionHistoryTitle => 'Action History';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get addNoteOptional => 'Add a note (optional)';

  @override
  String get noteHint => 'e.g., Used my own bag at the store';

  @override
  String pointsLabel(int count) {
    return '$count points';
  }

  @override
  String levelLabel(int level) {
    return 'Level $level';
  }

  @override
  String streakLabel(int days) {
    return '$days day streak';
  }

  @override
  String co2Saved(String amount) {
    return '$amount CO₂ saved';
  }

  @override
  String mascotName(String name) {
    return '$name';
  }

  @override
  String get mascotRename => 'Rename';

  @override
  String mascotEvolution(int stage) {
    return 'Evolution Stage $stage';
  }

  @override
  String get mascotSelectionTitle => 'Choose Your Companion';

  @override
  String get mascotSelectionSubtitle =>
      'This little friend will grow with you on your sustainability journey!';

  @override
  String get mascotNameLabel => 'Give your companion a name';

  @override
  String get mascotNameHint => 'e.g., Sprouty, Leafy, Bud...';

  @override
  String get mascotNameRequired => 'Please enter a name';

  @override
  String get mascotNameTooShort => 'Name must be at least 2 characters';

  @override
  String get mascotNameTooLong => 'Name must be 20 characters or less';

  @override
  String get mascotSelectionConfirm => 'Let\'s Grow Together!';

  @override
  String get evolutionTitle => 'Evolution!';

  @override
  String get evolutionSubtitle => 'Your companion has grown stronger!';

  @override
  String get evolutionContinue => 'Amazing!';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileStats => 'Statistics';

  @override
  String get profileTotalActions => 'Total Actions';

  @override
  String get profileTotalCO2 => 'Total CO₂ Saved';

  @override
  String get profileMemberSince => 'Member Since';

  @override
  String get profileCurrentStreak => 'Current Streak';

  @override
  String get profileLongestStreak => 'Longest Streak';

  @override
  String profileNextLevel(int points) {
    return '$points pts to next level';
  }

  @override
  String profileDaysActive(int days) {
    return '$days days';
  }

  @override
  String profileEvolutionStage(int stage) {
    return 'Evolution Stage $stage';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsReminderTime => 'Daily Reminder';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsSubscription => 'Subscription';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsPrivacy => 'Privacy Policy';

  @override
  String get settingsTerms => 'Terms of Service';

  @override
  String get subscriptionFree => 'Free';

  @override
  String get subscriptionPremium => 'Premium';

  @override
  String get subscriptionUpgrade => 'Upgrade to Premium';

  @override
  String get categoryRecycling => 'Recycling';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryEnergy => 'Energy';

  @override
  String get categoryConsumption => 'Consumption';

  @override
  String get categoryWater => 'Water';

  @override
  String get categoryCommunity => 'Community';

  @override
  String get categoryAdvocacy => 'Advocacy';

  @override
  String get categoryLearning => 'Learning';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorAuth => 'Authentication failed. Please try again.';

  @override
  String get buttonSave => 'Save';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonConfirm => 'Confirm';

  @override
  String get buttonClose => 'Close';

  @override
  String get buttonRetry => 'Retry';

  @override
  String get buttonContinue => 'Continue';

  @override
  String get progressTitle => 'Progress';

  @override
  String get progressGoalsToday => 'goals today';

  @override
  String get progressGoalReached => 'Daily goal reached!';

  @override
  String get progressSetDailyGoal => 'Set Your Daily Goal';

  @override
  String get progressSetDailyGoalSubtitle =>
      'How many eco-friendly actions do you want to complete each day?';

  @override
  String get progressStartJourney => 'Start My Journey';

  @override
  String get progressTargetDescriptionEasy =>
      'A gentle start — perfect for beginners!';

  @override
  String get progressTargetDescriptionModerate =>
      'A balanced challenge — recommended for most users.';

  @override
  String get progressTargetDescriptionChallenge =>
      'Ambitious! You\'re committed to making an impact.';

  @override
  String get progressTargetDescriptionExpert =>
      'Expert level — you\'re a sustainability champion!';

  @override
  String get languageSettingsTitle => 'Language';

  @override
  String get languageSettingsDescription =>
      'Choose your preferred language. The app will update immediately.';

  @override
  String get languageSettingsNote =>
      'Some content from the action library may remain in its original language.';

  @override
  String settingsNotificationsSubtitle(int count) {
    return '$count reminders enabled';
  }

  @override
  String get settingsNotificationsOff => 'Notifications are off';

  @override
  String settingsLanguageSubtitle(String language) {
    return '$language';
  }

  @override
  String get settingsAccountSubtitle => 'Email, password, delete account';

  @override
  String get settingsAboutSubtitle => 'Version, licenses, contact';

  @override
  String get accountSettingsTitle => 'Account';

  @override
  String get accountSettingsEmail => 'Email Address';

  @override
  String get accountSettingsChangeEmail => 'Change Email';

  @override
  String get accountSettingsChangePassword => 'Change Password';

  @override
  String get accountSettingsDeleteAccount => 'Delete Account';

  @override
  String get accountSettingsDeleteAccountWarning =>
      'This action cannot be undone. All your data will be permanently deleted.';

  @override
  String get accountSettingsDeleteConfirmTitle => 'Delete Account?';

  @override
  String get accountSettingsDeleteConfirmMessage =>
      'Are you sure you want to delete your account? This will permanently delete all your data including your mascot, action history, and progress.';

  @override
  String get accountSettingsDeleteConfirmButton => 'Delete My Account';

  @override
  String get accountSettingsCurrentEmail => 'Current email';

  @override
  String get accountSettingsNewEmail => 'New email';

  @override
  String get accountSettingsCurrentPassword => 'Current password';

  @override
  String get accountSettingsNewPassword => 'New password';

  @override
  String get accountSettingsConfirmNewPassword => 'Confirm new password';

  @override
  String get accountSettingsPasswordMismatch => 'Passwords do not match';

  @override
  String get accountSettingsEmailUpdated => 'Email updated successfully';

  @override
  String get accountSettingsPasswordUpdated => 'Password updated successfully';

  @override
  String get accountSettingsReauthRequired =>
      'Please re-enter your password to continue';

  @override
  String get aboutSettingsTitle => 'About';

  @override
  String get aboutSettingsVersion => 'Version';

  @override
  String get aboutSettingsLicenses => 'Open Source Licenses';

  @override
  String get aboutSettingsPrivacy => 'Privacy Policy';

  @override
  String get aboutSettingsTerms => 'Terms of Service';

  @override
  String get streakMilestoneTitle => 'Amazing!';

  @override
  String streakMilestoneWeeks(int count) {
    return '$count Week Streak!';
  }

  @override
  String streakMilestoneDays(int count) {
    return 'You\'ve logged actions for $count days in a row!';
  }

  @override
  String get streakMilestoneKeepGoing => 'Keep up the amazing work!';

  @override
  String get streakMilestoneContinue => 'Continue';

  @override
  String get streakBrokenTitle => 'Streak Broken';

  @override
  String get streakBrokenMessage => 'Don\'t worry! Start a new streak today.';

  @override
  String streakBrokenPrevious(int count) {
    return 'Previous streak: $count days';
  }

  @override
  String get streakBrokenStartNew => 'Start New Streak';

  @override
  String get sortLabel => 'Sort';

  @override
  String get sortAlphabeticalAZ => 'Name (A-Z)';

  @override
  String get sortAlphabeticalZA => 'Name (Z-A)';

  @override
  String get sortCo2HighToLow => 'CO₂ (High to Low)';

  @override
  String get sortCo2LowToHigh => 'CO₂ (Low to High)';

  @override
  String get sortPointsHighToLow => 'Points (High to Low)';

  @override
  String get sortPointsLowToHigh => 'Points (Low to High)';

  @override
  String get filterBySDG => 'Filter by SDG';

  @override
  String get allCategories => 'All';

  @override
  String co2PerAction(Object amount) {
    return '${amount}g CO₂';
  }

  @override
  String get sdgYourImpact => 'Your Impact';

  @override
  String sdgActionsLogged(int count) {
    return '$count actions logged';
  }

  @override
  String sdgCo2SavedForGoal(String amount) {
    return '$amount CO₂ saved for this goal';
  }

  @override
  String get sdgRelatedActions => 'Related Actions';

  @override
  String get sdgViewAllActions => 'View All';

  @override
  String get sdgResources => 'Resources';

  @override
  String get sdgLearnOnlyExplanation =>
      'This goal addresses systemic issues that require collective action. While you can\'t log daily actions for it directly, learning about it helps you understand the bigger picture and find ways to contribute.';

  @override
  String get sdgWaysToContribute => 'Ways to Contribute';

  @override
  String get sdgNoActionsYet => 'No actions logged for this goal yet';

  @override
  String get learnOnlyBadge => 'Learn';

  @override
  String get learnOnlyTitle => 'Learn About This Action';

  @override
  String get learnOnlyDescription =>
      'This action supports broader sustainability goals. While it can\'t be logged directly, learning about it helps you understand the bigger picture.';

  @override
  String get learnOnlyRelatedSdgs => 'Related Goals';

  @override
  String get learnOnlyDismiss => 'Got It';

  @override
  String get settingsAnalytics => 'Privacy';

  @override
  String get settingsAnalyticsSubtitle =>
      'Help improve Seed by sharing anonymous usage data';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String legalLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get eggDiscoveryTitle => 'A Mysterious Egg!';

  @override
  String eggDiscoveryMessage(String mascotName) {
    return 'Overnight, a mysterious egg appeared beside $mascotName!';
  }

  @override
  String get eggDiscoverySubtitle =>
      'Log actions every day for 30 days to hatch it.';

  @override
  String get eggDiscoveryDismiss => 'How exciting!';

  @override
  String get eggHatchingTitle => 'It\'s Hatching!';

  @override
  String get eggHatchingNamePrompt => 'Give your new companion a name';

  @override
  String get eggHatchingConfirm => 'Welcome!';

  @override
  String eggProgressLabel(int current, int total) {
    return 'Day $current/$total';
  }

  @override
  String get mascotCollectionTitle => 'My Mascots';

  @override
  String get mascotSwitchConfirm => 'Switch Mascot?';

  @override
  String get switchToMascot => 'Switch to';

  @override
  String get switchMascotButton => 'Switch';

  @override
  String get actionLearnMore => 'Tap to learn the science';

  @override
  String get maxEvolutionTitle => 'Maximum Evolution!';

  @override
  String get maxEvolutionSubtitle =>
      'Your companion has reached their full potential!';

  @override
  String get maxEvolutionEggHint =>
      'Nurture your egg to discover a new companion!';

  @override
  String get sdgAboutGoal => 'About this Goal';

  @override
  String get sdgViewTargets => 'View targets';

  @override
  String get sdgTargetsTitle => 'UN Targets';

  @override
  String get notifSettingsTitle => 'Notification Settings';

  @override
  String get notifSectionNotifications => 'Notifications';

  @override
  String get notifEnableTitle => 'Enable Notifications';

  @override
  String get notifEnableSubtitle => 'Receive daily reminders to log actions';

  @override
  String get notifSmartTitle => 'Smart Reminders';

  @override
  String get notifSmartOnlyTitle => 'Only remind if no action today';

  @override
  String get notifSmartOnlySubtitle =>
      'Skip reminders on days you\'ve already logged';

  @override
  String get notifSmartDescription =>
      'When enabled, reminders will only appear if you haven\'t logged any sustainable actions that day.';

  @override
  String get notifReminderTimesTitle => 'Reminder Times';

  @override
  String get notifNoReminders => 'No reminders set';

  @override
  String get notifAddReminder => 'Add a reminder to get notified';

  @override
  String get notifAddReminderTime => 'Add Reminder Time';

  @override
  String get notifMaxReminders => 'Maximum 5 reminders allowed';

  @override
  String get notifEditTime => 'Edit reminder time';

  @override
  String get notifSelectTime => 'Select reminder time';

  @override
  String get notifLabelTitle => 'Reminder Label';

  @override
  String get notifLabelHint => 'e.g., Morning, After work...';

  @override
  String get notifLabelOptional => 'Label (optional)';

  @override
  String get notifDeleteTitle => 'Delete Reminder?';

  @override
  String notifDeleteMessage(String time) {
    return 'Remove the $time reminder?';
  }

  @override
  String get notifAdd => 'Add';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String settingsVersionFormat(String version) {
    return 'Version $version';
  }

  @override
  String get settingsNoReminders => 'No reminders set';

  @override
  String settingsRemindersCount(int count) {
    return '$count reminders configured';
  }

  @override
  String get settingsOneReminder => '1 reminder configured';

  @override
  String get settingsTapToAddReminders => 'Tap to add reminders';

  @override
  String get settingsAllRemindersDisabled => 'All reminders disabled';

  @override
  String settingsRemindersPlusMore(String time, int count) {
    return '$time + $count more';
  }

  @override
  String get settingsErrorLoading => 'Error loading settings';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsFeedback => 'Send Feedback';

  @override
  String get settingsFeedbackSubtitle => 'Report a bug or share your thoughts';

  @override
  String get aboutLegal => 'Legal';

  @override
  String get aboutFooterSdg =>
      'Seed helps track sustainable actions aligned with the UN Sustainable Development Goals.';

  @override
  String get aboutFooterMade => 'Made with care for our planet.';

  @override
  String get aboutSubtitleTracker => 'Sustainability Habit Tracker';

  @override
  String get feedbackTitle => 'Send Feedback';

  @override
  String get feedbackCategoryLabel => 'Category';

  @override
  String get feedbackCategoryBug => 'Bug Report';

  @override
  String get feedbackCategoryFeature => 'Feature Request';

  @override
  String get feedbackCategoryGeneral => 'General Feedback';

  @override
  String get feedbackDescriptionLabel => 'Describe your feedback';

  @override
  String get feedbackDescriptionHint => 'Tell us what\'s on your mind...';

  @override
  String get feedbackMetadataNote =>
      'The following info is included to help us investigate:';

  @override
  String get feedbackSubmit => 'Submit Feedback';

  @override
  String get feedbackThanks => 'Thanks for your feedback!';

  @override
  String get feedbackMailFailed =>
      'Couldn\'t open your mail app. Please try again.';

  @override
  String get mascotEvolutionTimeline => 'Evolution Timeline';

  @override
  String get mascotNextEvolution => 'Next Evolution';

  @override
  String mascotLevelShort(int level) {
    return 'Lv $level';
  }

  @override
  String mascotLevelsToGo(int count) {
    return '$count levels to go';
  }

  @override
  String mascotLevelProgress(int current, int max) {
    return 'Level $current / $max';
  }

  @override
  String get homeExploreGoals => 'Explore the Goals';

  @override
  String get homeExploreGoalsSubtitle =>
      'Tap to learn about the UN Sustainable Development Goals';

  @override
  String get homeLearnMore => 'Learn more at UN.org';

  @override
  String get homePoints => 'Points';

  @override
  String sdgGoalNumber(int number) {
    return 'Goal $number';
  }

  @override
  String get sdgBadge => 'UN SDG';

  @override
  String get buttonDelete => 'Delete';

  @override
  String get buttonSkip => 'Skip';

  @override
  String get authWelcomeBack => 'Welcome Back';

  @override
  String get authSignInSubtitle =>
      'Sign in to continue your sustainability journey';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authOrContinueWith => 'or continue with';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authCreateAccountSubtitle =>
      'Start your sustainability journey today';

  @override
  String get authOrSignUpWith => 'or sign up with';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authAgreePrefix => 'I agree to the ';

  @override
  String get authAgreeAnd => ' and ';

  @override
  String get authAcceptTermsError =>
      'Please accept the Terms of Service and Privacy Policy';

  @override
  String get authForgotPasswordTitle => 'Reset Password';

  @override
  String get authForgotPasswordHint => 'Enter your email address';

  @override
  String get authForgotPasswordSend => 'Send';

  @override
  String get authForgotPasswordSent =>
      'If an account exists with this email, a password reset link has been sent.';

  @override
  String get authVerifyEmailTitle => 'Verify Email';

  @override
  String get authCheckEmail => 'Check Your Email';

  @override
  String get authVerificationSentTo => 'We sent a verification link to:';

  @override
  String get authVerifyInstructions =>
      'Click the link in the email to verify your account, then return here and tap the button below.';

  @override
  String get authChecking => 'Checking...';

  @override
  String get authVerifiedButton => 'I\'ve Verified My Email';

  @override
  String get authVerificationSent => 'Verification email sent!';

  @override
  String get authResendEmail => 'Resend Email';

  @override
  String get authDifferentEmail => 'Use a Different Email';

  @override
  String get authEmailVerified => 'Email verified! Welcome to Seed!';

  @override
  String get authEmailNotVerified =>
      'Email not verified yet. Please check your inbox and click the verification link.';

  @override
  String get authValidationEmailRequired => 'Please enter your email';

  @override
  String get authValidationEmailInvalid => 'Please enter a valid email';

  @override
  String get authValidationPasswordRequired => 'Please enter your password';

  @override
  String get authValidationPasswordShort =>
      'Password must be at least 6 characters';

  @override
  String get authValidationConfirmRequired => 'Please confirm your password';

  @override
  String pointsAbbreviated(int count) {
    return '$count pts';
  }

  @override
  String stageFallback(int stage) {
    return 'Stage $stage';
  }

  @override
  String get dayDetailActions => 'Actions';

  @override
  String get dayDetailNoActions => 'No actions logged this day';

  @override
  String get dayDetailFactLocked => 'No eco-fact unlocked this day';

  @override
  String get ecoFactTitle => 'Today\'s Eco-Fact';

  @override
  String get ecoFactDidYouKnow => 'Did you know?';

  @override
  String get ecoFactSource => 'Source';

  @override
  String get ecoFactLocked =>
      'Complete today\'s challenge to unlock this fact!';

  @override
  String get ecoFactInboxTitle => 'Inbox';

  @override
  String get ecoFactInboxEmpty =>
      'No mail yet. Complete today\'s challenge to receive your first eco-fact.';

  @override
  String get ecoFactInboxLockedSubject => 'Locked eco-fact';

  @override
  String get ecoFactCategoryComparison => 'Comparison';

  @override
  String get ecoFactCategoryIndividual => 'Individual Impact';

  @override
  String get ecoFactCategoryMythBuster => 'Myth Buster';

  @override
  String get ecoFactCategoryNatureWonder => 'Nature Wonder';

  @override
  String get ecoFactCategoryPositiveNews => 'Positive News';

  @override
  String get challengeDialogTitle => 'Today\'s Challenge';

  @override
  String get challengeDialogLater => 'Later';

  @override
  String get challengeDialogLogAction => 'Log Action';

  @override
  String get challengeDialogUnlock => 'Complete to unlock today\'s eco-fact!';

  @override
  String get challengeTabLabel => 'Challenge';

  @override
  String get challengeCompleted => 'Complete!';

  @override
  String get challengeNotCompleted => 'Not yet completed';

  @override
  String get challengeSeeFact => 'See today\'s eco-fact';

  @override
  String challengeStreakDays(int days) {
    return '$days day challenge streak';
  }

  @override
  String challengeMultiDayProgress(int current, int target) {
    return 'Day $current of $target';
  }

  @override
  String get challengeCompletedSnackbar =>
      'Challenge completed! Eco-fact unlocked!';

  @override
  String get challengeBrowse => 'Browse Challenges';

  @override
  String get challengesScreenTitle => 'Multi-Day Challenges';

  @override
  String get challengeStart => 'Start Challenge';

  @override
  String get challengeStartConfirm => 'Start this challenge?';

  @override
  String get challengeActive => 'Active';

  @override
  String get challengeCompletedBadge => 'Completed';

  @override
  String get challengeAvailable => 'Available';

  @override
  String get challengeAbandon => 'Abandon';

  @override
  String get challengeAbandonConfirm =>
      'Abandon this challenge? Progress will be lost.';

  @override
  String challengeDays(int days) {
    return '$days days';
  }

  @override
  String get challengeAnyCategory => 'Any category';

  @override
  String get challengeLocked => 'Locked';

  @override
  String get progressCalendarTab => 'Calendar';

  @override
  String get ecoDexTab => 'Eco-Dex';

  @override
  String get impactTab => 'Impact';

  @override
  String get periodToday => 'Today';

  @override
  String get periodThisWeek => 'This Week';

  @override
  String get periodThisMonth => 'This Month';

  @override
  String get periodAllTime => 'All Time';

  @override
  String get co2SavedToday => 'CO2 saved today';

  @override
  String get co2SavedThisWeek => 'CO2 saved this week';

  @override
  String get co2SavedThisMonth => 'CO2 saved this month';

  @override
  String get co2SavedAllTime => 'CO2 saved all time';

  @override
  String get kgUnit => 'kg';

  @override
  String get vsYesterday => 'vs. yesterday';

  @override
  String get vsLastWeek => 'vs. last week';

  @override
  String get vsLastMonth => 'vs. last month';

  @override
  String get trendChartTitle => 'Daily trend';

  @override
  String get trendChartAverageLabel => 'average';

  @override
  String get categoryChartTitle => 'By category';

  @override
  String get categoryOther => 'Other';

  @override
  String get equivalentToHeader => 'Equivalent to';

  @override
  String get equivTreesLabel => 'tree-years';

  @override
  String get equivCarKmLabel => 'km not driven';

  @override
  String get equivPhoneChargesLabel => 'phone charges';

  @override
  String get equivBurgersLabel => 'beef burgers';

  @override
  String get impactInfoTooltip => 'How we calculate this';

  @override
  String get impactInfoTitle => 'How we calculate this';

  @override
  String get impactInfoIntro =>
      'We translate the CO2 you\'ve saved into everyday comparisons. The figures are illustrative -- we use global averages and mix CO2 with CO2-equivalent (methane, grid electricity, food lifecycle), so your real impact will vary with local grid mix and supply chain.';

  @override
  String get impactInfoFormulaLabel => 'Formula';

  @override
  String get impactInfoSourceLabel => 'Source';

  @override
  String get equivTreesExplainer =>
      'Approximate CO2 absorbed by a single mature urban tree in one year. Newly planted saplings absorb far less -- this is the steady-state mature figure.';

  @override
  String get equivCarKmExplainer =>
      'Average passenger car emissions per kilometer driven, fleet-weighted across petrol and diesel vehicles.';

  @override
  String get equivPhoneChargesExplainer =>
      'Grid electricity used to fully charge an average smartphone, based on the US national grid mix. Cleaner grids (e.g. Norway) use less; coal-heavy grids use more.';

  @override
  String get equivBurgersExplainer =>
      'Full lifecycle emissions of one beef burger, from cattle farming to retail. Chicken or plant-based burgers emit roughly 5-10x less.';

  @override
  String equivFormulaTemplate(String factor) {
    return 'g of CO2 / $factor';
  }

  @override
  String get ecoDexTitle => 'Eco-Dex';

  @override
  String ecoDexProgress(int discovered, int total) {
    return '$discovered / $total discovered';
  }

  @override
  String get ecoDexLocked => 'Undiscovered';

  @override
  String get ecoDexViewSource => 'View source';

  @override
  String get ecoDexNewDiscovery => 'New Eco-Dex discovery!';

  @override
  String get ecoDexNextUp => 'Next Up';

  @override
  String get ecoDexDiscoveryTitle => 'New Discovery!';

  @override
  String get ecoDexDiscoveryAcknowledge => 'Awesome!';

  @override
  String ecoDexDiscoveryMoreQueued(int count) {
    return '+$count more queued';
  }

  @override
  String get ecoDexEmptyHint =>
      'Log your first action to make your first discovery.';

  @override
  String get ecoDexInfoTooltip => 'About the Eco-Dex';

  @override
  String get ecoDexInfoTitle => 'About the Eco-Dex';

  @override
  String get ecoDexInfoBody =>
      'The Eco-Dex is your encyclopedia of facts about our planet. Entries unlock automatically as you use Seed: logging actions, saving CO2, keeping up streaks, completing challenges, and reading eco facts. Tap a locked card for a hint on how to discover it, and tap a discovered entry to read its full fact. Discoveries do not award points: each one rewards you with knowledge.';
}
