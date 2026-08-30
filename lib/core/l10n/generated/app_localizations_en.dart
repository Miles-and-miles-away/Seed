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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points',
      one: '$count point',
    );
    return '$_temp0';
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
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return '$_temp0';
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
  String get errorOpenLink => 'Could not open link.';

  @override
  String get errorActionTooSoon => 'Please wait a few seconds between actions.';

  @override
  String get errorOffline =>
      'You\'re offline. Check your connection and try again.';

  @override
  String get errorAuthEmailInUse =>
      'An account already exists with this email address.';

  @override
  String get errorAuthInvalidEmail => 'Please enter a valid email address.';

  @override
  String get errorAuthOperationNotAllowed =>
      'This sign-in method is not enabled. Please contact support.';

  @override
  String get errorAuthWeakPassword =>
      'Password is too weak. Please use at least 6 characters.';

  @override
  String get errorAuthUserDisabled =>
      'This account has been disabled. Please contact support.';

  @override
  String get errorAuthInvalidCredentials =>
      'Invalid email or password. Please try again.';

  @override
  String get errorAuthTooManyRequests =>
      'Too many attempts. Please wait a moment and try again.';

  @override
  String get errorAuthNetwork =>
      'Network error. Please check your internet connection.';

  @override
  String get errorAuthSignInCancelled => 'Sign-in was cancelled.';

  @override
  String get errorAuthAccountExistsWithDifferentCredential =>
      'An account already exists with this email using a different sign-in method.';

  @override
  String get errorAuthLinkExpired =>
      'This link has expired. Please request a new one.';

  @override
  String get errorAuthLinkInvalid =>
      'This link is invalid. Please request a new one.';

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
  String get accountSettingsProfile => 'Profile';

  @override
  String get accountSettingsDisplayName => 'Display Name';

  @override
  String get accountSettingsNotSet => 'Not set';

  @override
  String get accountSettingsDisplayNameUpdated =>
      'Display name updated successfully';

  @override
  String get accountSettingsDisplayNameRequired => 'Please enter a name';

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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count actions logged',
      one: '$count action logged',
    );
    return '$_temp0';
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
      'The following info is included to help us investigate: app version, device and OS, language, and your account ID.';

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
  String get mascotStatsTitle => 'Our Journey';

  @override
  String get mascotStatBirthday => 'Birthday';

  @override
  String get mascotStatDaysTogether => 'Days together';

  @override
  String get mascotStatCo2Together => 'CO₂ saved together';

  @override
  String mascotLevelShort(int level) {
    return 'Lv $level';
  }

  @override
  String mascotLevelsToGo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count levels to go',
      one: '$count level to go',
    );
    return '$_temp0';
  }

  @override
  String mascotLevelProgress(int current, int max) {
    return 'Level $current / $max';
  }

  @override
  String get homeExploreGoals => 'Explore the SDG Goals';

  @override
  String get homeExploreGoalsSubtitle =>
      'Tap to learn about the UN Sustainable Development Goals';

  @override
  String get homeLearnMore => 'Learn more at UN.org';

  @override
  String get homePoints => 'Points';

  @override
  String get myGoalTitle => 'My Goal';

  @override
  String get myGoalEmptyPrompt => 'Tap to set your sustainability goal';

  @override
  String get myGoalUpdated => 'Goal updated successfully';

  @override
  String get goalPickerTitle => 'Choose your goal';

  @override
  String get goalPickerCustomOption => 'Write your own';

  @override
  String get goalPickerCustomHint => 'My goal is...';

  @override
  String get personalGoalReduceFlights => 'Reduce long-haul flights';

  @override
  String get personalGoalPlantBased => 'Eat more plant-based meals';

  @override
  String get personalGoalLessPlastic => 'Cut out single-use plastic';

  @override
  String get personalGoalWalkBike => 'Walk or bike instead of driving';

  @override
  String get personalGoalLessFoodWaste => 'Waste less food';

  @override
  String get personalGoalBuyLess => 'Buy less, reuse more';

  @override
  String get personalGoalInspireOthers => 'Inspire friends and family to act';

  @override
  String get personalGoalSaveWorld => 'Save the world';

  @override
  String sdgGoalNumber(int number) {
    return 'Goal $number';
  }

  @override
  String get sdgProgressChart => 'Global progress';

  @override
  String get sdgProgressChartHint => 'Tap to enlarge';

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
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return '$_temp0';
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
      'Full lifecycle emissions of one beef burger (113 g patty), from cattle farming to retail. A chicken burger emits roughly 10x less; a bean burger roughly 50x less.';

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
  String ecoDexAchievement(String hint) {
    return 'Achievement: $hint';
  }

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

  @override
  String get transportCalculatorTitle => 'Transport Calculator';

  @override
  String get calculatorsSheetTitle => 'Calculators';

  @override
  String get calculatorsButtonTooltip => 'Calculators';

  @override
  String get calculatorHomeEnergy => 'Home energy';

  @override
  String get calculatorComingSoon => 'Coming soon';

  @override
  String get transportJourneyEmpty =>
      'Add a leg to build your journey and see its CO2e footprint.';

  @override
  String get transportAddLeg => 'Add leg';

  @override
  String get transportEditLeg => 'Edit leg';

  @override
  String get transportSelectMode => 'Choose a transport mode';

  @override
  String get transportChangeMode => 'Change';

  @override
  String get transportDistanceLabel => 'Distance (km)';

  @override
  String get transportDistanceInvalid => 'Enter a distance of 0 km or more';

  @override
  String get transportDistanceEstimateNote =>
      'Estimate derived from city locations. Edit it to match your route.';

  @override
  String get transportDistanceUnknown => 'Unknown';

  @override
  String transportFlightBandNote(String band) {
    return 'This distance uses the $band factor, so a short hop is never priced as a long-haul flight.';
  }

  @override
  String get transportOccupantsLabel => 'People in the vehicle';

  @override
  String get transportOccupantsAdd => 'Add a person';

  @override
  String get transportOccupantsRemove => 'Remove a person';

  @override
  String transportOccupantsSemantic(int count) {
    return 'People in the vehicle: $count';
  }

  @override
  String get transportTotalLabel => 'Total';

  @override
  String get transportRemoveLeg => 'Remove leg';

  @override
  String get transportFromCity => 'From city';

  @override
  String get transportToCity => 'To city';

  @override
  String get transportCityPrefillHint =>
      'Pick two cities to estimate leg distances.';

  @override
  String transportEstimatedKm(String km) {
    return '~$km km';
  }

  @override
  String transportKmValue(String km) {
    return '$km km';
  }

  @override
  String transportOccupantsValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return '$_temp0';
  }

  @override
  String transportModeFactorPerPassenger(int grams) {
    return '$grams g CO2e per km';
  }

  @override
  String transportModeFactorPerVehicle(int grams) {
    return '$grams g CO2e per vehicle km';
  }

  @override
  String get transportGroupActive => 'Walking & cycling';

  @override
  String get transportGroupMicro => 'Micromobility';

  @override
  String get transportGroupCar => 'Car & motorbike';

  @override
  String get transportGroupBus => 'Bus & coach';

  @override
  String get transportGroupTaxi => 'Taxi';

  @override
  String get transportGroupRail => 'Rail';

  @override
  String get transportGroupWater => 'Water';

  @override
  String get transportGroupAir => 'Air';

  @override
  String get transportGroupHighImpact => 'High impact';

  @override
  String get transportModeScienceTooltip => 'About this factor';

  @override
  String get transportBasisEvGrid =>
      'Global-average grid; varies with your electricity';

  @override
  String get transportBasisJetRf =>
      'Includes the same high-altitude (radiative forcing) uplift as flights';

  @override
  String get transportBasisZeroDirect => '0 direct emissions';

  @override
  String get transportBasisElectricityOnly => 'Electricity only';

  @override
  String get transportComparisonTitle => 'Compare journeys';

  @override
  String get transportAddToComparison => 'Add as option';

  @override
  String get calculatorStagedOptions => 'Options to compare';

  @override
  String get calculatorRemoveOption => 'Remove this option';

  @override
  String calculatorEntryPreview(String amount) {
    return 'This adds $amount CO2e';
  }

  @override
  String get co2eDefinitionTitle => 'What is CO2e?';

  @override
  String get co2eDefinitionBody =>
      'CO2e counts methane and other greenhouse gases as their CO2 equivalent, so a burger and a flight compare fairly.';

  @override
  String get calculatorOptionA => 'Option A';

  @override
  String get calculatorOptionB => 'Option B';

  @override
  String get calculatorDropHint => 'Drag or tap an item below to add it here';

  @override
  String get calculatorAddToA => 'Add to A';

  @override
  String get calculatorAddToB => 'Add to B';

  @override
  String get calculatorBrowseAll => 'Browse all';

  @override
  String get transportColumnEmptyHint => 'Tap Add leg to start this journey';

  @override
  String get calculatorNeedBothOptions => 'Build both options to compare them';

  @override
  String get calculatorRemoveEntry => 'Remove';

  @override
  String get scienceNotesHeading => 'How it\'s calculated';

  @override
  String get scienceSourcesHeading => 'Sources';

  @override
  String scienceAccessed(String date) {
    return 'Accessed $date';
  }

  @override
  String transportComparisonFull(int max) {
    return 'Comparison full ($max options)';
  }

  @override
  String transportCompareOptions(int count) {
    return 'Compare $count options';
  }

  @override
  String transportOptionStaged(int count) {
    return 'Added option $count';
  }

  @override
  String transportComparisonDelta(
    String label,
    String amount,
    String worse,
    int percent,
  ) {
    return '$label emits $amount CO2e less than $worse ($percent% lower)';
  }

  @override
  String transportComparisonTreesEquiv(String count) {
    return 'That\'s about $count trees absorbing CO2 for a year';
  }

  @override
  String get transportMethodologyTitle => 'Methodology & sources';

  @override
  String transportMethodologyBody(int grid) {
    return 'Every figure in this tool is an estimate for learning, traceable to the sources listed below.\n\n### What\'s counted\nOnly operational energy: fuel burned by engines and the electricity generated for electric modes. Vehicle manufacturing and infrastructure are excluded. Walking and cycling count as zero by convention -- the calories you burn are left out, as they may not add to a normal diet.\n\n### Occupancy\nCars and taxis are measured per vehicle, so their footprint is divided by the number of people aboard. Buses, trains and flights are already per passenger, at typical occupancy.\n\n### Flights and radiative forcing\nAircraft warm the climate beyond their CO2 through contrails and high-altitude effects. Following DESNZ 2025, flight and private-jet factors include a 1.7x central-estimate uplift on the CO2 component. Private jets carry the same uplift, so the comparison stays like for like.\n\n### Electric modes and the grid\nElectric cars, e-bikes and e-scooters emit nothing from the tailpipe; their footprint comes from generating the electricity. This tool uses a global-average grid of $grid g CO2e per kWh, which varies widely by country and time of day, so your real figure may be higher or lower.\n\n### Averages, not your exact trip\nFactors are category averages, not your specific vehicle, route or driving style. Use them to compare options, not for precise carbon accounting.\n\n### Close calls\nSome modes sit very close -- coach and rail, for example, are within a few grams and their order can flip between yearly factor revisions. Treat small differences as a tie, not a clear winner.';
  }

  @override
  String get transportLogChoiceTitle => 'Take the greener option?';

  @override
  String transportLogChoiceBody(String amount) {
    return 'Log this as a transport action and bank the $amount CO2e you avoid by choosing the lower-carbon option.';
  }

  @override
  String transportLogChoiceCta(String label) {
    return 'I chose $label';
  }

  @override
  String transportChoiceLoggedMessage(String amount) {
    return 'Logged. You banked $amount CO2e.';
  }

  @override
  String transportCustomActionName(String greener, String worse) {
    return 'Chose $greener over $worse';
  }

  @override
  String get transportChoseLabel => 'I took';

  @override
  String get transportInsteadOfLabel => 'instead of';

  @override
  String get transportChoiceDistinctHint =>
      'Pick two different options to log the choice you made.';

  @override
  String get transportActionsEntryTitle => 'Log a Custom Transport action';

  @override
  String get customActionBadge => 'Custom';

  @override
  String get actionReproduce => 'Do this again';

  @override
  String get actionReproducedMessage => 'Logged again';

  @override
  String get foodCalculatorTitle => 'Food Calculator';

  @override
  String get foodMethodologyTitle => 'Methodology & sources';

  @override
  String get foodTotalLabel => 'Total';

  @override
  String get foodMealEmpty =>
      'Add an ingredient to build your meal and see its CO2e footprint.';

  @override
  String get foodAddIngredient => 'Add ingredient';

  @override
  String get foodEditIngredient => 'Edit ingredient';

  @override
  String get foodSelectItem => 'Choose a food';

  @override
  String get foodChangeItem => 'Change';

  @override
  String get foodQuantityLabel => 'Quantity (g)';

  @override
  String get foodQuantityInvalid => 'Enter a quantity of 0 g or more';

  @override
  String foodGramsValue(String grams) {
    return '$grams g';
  }

  @override
  String get foodRemoveIngredient => 'Remove ingredient';

  @override
  String get foodItemScienceTooltip => 'About this factor';

  @override
  String get foodColumnEmptyHint => 'Tap Add ingredient to start this meal';

  @override
  String get foodSearchHint => 'Search foods...';

  @override
  String get foodSearchNoResults => 'No foods match that search.';

  @override
  String foodItemFactorWithServing(
    String perKg,
    String perServing,
    String serving,
  ) {
    return '$perKg kg CO2e per kg  ·  $perServing per $serving';
  }

  @override
  String foodItemFactorPerKg(String value) {
    return '$value kg CO2e per kg';
  }

  @override
  String get foodGroupMeat => 'Meat';

  @override
  String get foodGroupSeafood => 'Seafood';

  @override
  String get foodGroupDairyEggs => 'Dairy & eggs';

  @override
  String get foodGroupPlantProtein => 'Plant protein';

  @override
  String get foodGroupStaples => 'Staples';

  @override
  String get foodGroupVegetables => 'Vegetables';

  @override
  String get foodGroupFruit => 'Fruit';

  @override
  String get foodGroupDrinks => 'Drinks';

  @override
  String get foodGroupTreats => 'Treats';

  @override
  String get foodGroupOils => 'Oils';

  @override
  String get foodAddToComparison => 'Add as option';

  @override
  String foodComparisonFull(int max) {
    return 'Comparison full ($max options)';
  }

  @override
  String foodCompareOptions(int count) {
    return 'Compare $count options';
  }

  @override
  String foodOptionStaged(int count) {
    return 'Added option $count';
  }

  @override
  String get foodComparisonTitle => 'Compare meals';

  @override
  String get foodGroupNutsSeeds => 'Nuts & seeds';

  @override
  String get foodGroupCondiments => 'Condiments';

  @override
  String get foodGroupPrepared => 'Prepared foods';

  @override
  String get foodBasisDry =>
      'Dry weight -- weigh it before cooking or soaking.';

  @override
  String get foodBasisDrained =>
      'Drained weight -- weigh it after draining the tin.';

  @override
  String get foodBasisEdible =>
      'Edible weight -- weigh it without shell, bone or skin.';

  @override
  String get foodBasisConcentrate =>
      'Undiluted weight -- weigh the concentrate, not the drink.';

  @override
  String get foodBoundaryNarrower =>
      'Measured over a shorter supply chain than most foods here, so it reads low against them.';

  @override
  String get foodPickerRecents => 'Recent';

  @override
  String get foodVerdictWhyCta => 'Why is there no result?';

  @override
  String get foodVerdictBlockedTitle => 'Not a big enough difference to log';

  @override
  String foodVerdictTooClose(int percent) {
    return 'These two meals are within $percent% of each other. Most foods here share an average with a whole category, and many are statistically tied, so a gap this small is inside what the underlying research can actually tell apart. Both totals are shown above -- we just won\'t declare one the winner.';
  }

  @override
  String foodVerdictCrossSource(int percent) {
    return 'These meals are measured by different studies, one of which covers a shorter supply chain. Part of any gap between them could be that difference rather than a real one, so we\'d need one meal to emit less than half the other -- around $percent% -- before saying which is better.';
  }

  @override
  String foodVerdictTiedBasis(int percent) {
    return 'The gap here rests on ingredients that share one underlying research figure. Where two of those disagree, the disagreement is an accounting choice made in the original study rather than anything measured on a farm. Set that aside and these meals land within $percent% of each other, so we won\'t name a winner. Both totals are shown above.';
  }

  @override
  String get foodVerdictTiedBasisFlips =>
      'Which meal comes out ahead here depends on an accounting choice in the source study rather than on the food. Some ingredients on the two sides share one underlying research figure, and holding that figure to a single value reverses the result. A winner that swaps like that is a fact about the study, so we won\'t name one. Both totals are shown above.';

  @override
  String foodVerdictUncertainItem(String item, String ratio, int percent) {
    return '$item is the problem here, not your meals. The research behind it disagrees with itself: a minority of very high-impact producers pulls its average to $ratio times its midpoint, so where it lands depends heavily on which farms you count. A gap of about $percent% would outrun that uncertainty; this one doesn\'t. You can still log the meal as a normal action.';
  }

  @override
  String get foodComparisonTooClose =>
      'These two are too close to call. Below a 20% difference the gap sits inside what the underlying research can actually resolve, so we show both totals without naming a winner.';

  @override
  String foodComparisonDelta(
    String label,
    String amount,
    String worse,
    int percent,
  ) {
    return '$label emits $amount CO2e less than $worse ($percent% lower)';
  }

  @override
  String foodComparisonCarKmEquiv(int km) {
    return 'That\'s about $km km not driven in a petrol car';
  }

  @override
  String get foodChoseLabel => 'I ate';

  @override
  String get foodInsteadOfLabel => 'instead of';

  @override
  String foodLogChoiceBody(String amount) {
    return 'Log this as a food action and bank the $amount CO2e you avoid by choosing the lower-carbon meal.';
  }

  @override
  String get foodChoiceDistinctHint =>
      'Pick two different meals to log the choice you made.';

  @override
  String foodLogChoiceCta(String label) {
    return 'I chose $label';
  }

  @override
  String foodChoiceLoggedMessage(String amount) {
    return 'Logged. You banked $amount CO2e.';
  }

  @override
  String foodCustomActionName(String greener, String worse) {
    return 'Chose $greener over $worse';
  }

  @override
  String get foodActionsEntryTitle => 'Log a Custom Food action';

  @override
  String get foodMethodologyBody =>
      'Every figure in this tool is an estimate for learning, traceable to the sources listed below.\n\n### What\'s counted\nEach factor covers a food\'s full cradle-to-retail lifecycle -- land-use change, farming, animal feed, processing, transport and packaging -- from Poore & Nemecek\'s 2018 meta-analysis of ~38,000 farms, as published by Our World in Data. Home cooking energy and household food waste are excluded. This is a wider boundary than the transport calculator\'s operational-only scope, so never add figures from the two tools together. Figures are the study\'s production-weighted means including supply-chain losses, not its medians, because means better represent total global impact.\n\n### One number, huge spread\nThese are global category averages. The same food can vary 10-50x between producers: beef ranges from about 9 to 105 kg CO2e per 100 g of protein, and tomatoes from 0.45 kg CO2e/kg grown outdoors in season to 2.20 in a heated greenhouse. Use the figures to compare foods, not to judge a specific farm.\n\n### Why we don\'t always name a winner\nEvery figure here is an average across thousands of farms, and those farms are not spread evenly around it. A minority of high-impact producers pulls the average above what a typical farm looks like, which is why the study also publishes a midpoint -- the value with half of world production either side of it. For most foods the two sit close together. For some they do not: dark chocolate averages 46.65 kg CO2e/kg against a midpoint of 18.7, and farmed fish 13.63 against 5.1.\n\nWe use the averages, because they represent total global impact rather than the typical farm. The consequence is that two foods close together can change places depending on which of the two figures you read. So this tool only calls one meal better than another when the gap reaches 20%; below that it shows both totals and leaves the comparison to you.\n\nThat 20% is tested rather than chosen for neatness. Across every pair of foods here for which the study publishes both figures, a gap of 20% or more points the same way under either one. Three foods are the exception, because their own average and midpoint differ by more than a factor of two: dark chocolate, farmed fish and tree nuts. For those, no gap is dependable, so they are never used to declare a winner at all. And where a comparison spans two different studies -- a few foods here are measured by a second source over a shorter supply chain -- we require one meal to emit less than half the other, because a smaller gap could be nothing more than the difference in what each study counted.\n\n### \'Organic\' and \'local\'\nThere is no organic or local discount here, and that is deliberate. Transport is usually under 10% of a food\'s footprint, so local beef still has a far bigger footprint than imported beans, and organic is often similar or higher per kg. What you eat matters far more than how far it travelled or how it was farmed.';

  @override
  String get energyGroupHotWater => 'Hot water';

  @override
  String get energyGroupDishes => 'Dishes';

  @override
  String get energyGroupLaundryWash => 'Laundry: washing';

  @override
  String get energyGroupLaundryDry => 'Laundry: drying';

  @override
  String get energyGroupSpaceHeat => 'Heating';

  @override
  String get energyGroupSpaceCool => 'Cooling';

  @override
  String get energyGroupBoil => 'Boiling water';

  @override
  String get energyGroupCook => 'Cooking';

  @override
  String get energyGroupLighting => 'Lighting';

  @override
  String get energyGroupDevice => 'Devices';

  @override
  String get energyPickerRecents => 'Recently used';

  @override
  String get energyBehaviorScienceTooltip => 'Where this number comes from';

  @override
  String get energyLowConfidenceNote => 'Least certain figure in this dataset';

  @override
  String energyFactorPerMinute(String kwh) {
    return '$kwh kWh per minute';
  }

  @override
  String energyFactorPerHour(String kwh) {
    return '$kwh kWh per hour';
  }

  @override
  String energyFactorPerUse(String kwh) {
    return '$kwh kWh per use';
  }

  @override
  String energyFactorPerDay(String kwh) {
    return '$kwh kWh per day';
  }

  @override
  String energyQuantityMinutes(String units) {
    return '$units minutes';
  }

  @override
  String energyQuantityHours(String units) {
    return '$units hours';
  }

  @override
  String energyQuantityUses(String units) {
    return '$units x';
  }

  @override
  String energyQuantityDays(String units) {
    return '$units days';
  }

  @override
  String get energyScienceNoSources =>
      'This figure has no citation, on purpose. Its own notes above explain why.';

  @override
  String get energyCalculatorTitle => 'Home energy';

  @override
  String get energyAddUsage => 'Add';

  @override
  String get energyColumnEmptyHint =>
      'Add something you do at home to build this routine';

  @override
  String get energyNoPointsNote =>
      'This calculator is for learning. It awards no points and logs nothing.';

  @override
  String get energyPresetsLabel => 'Common amounts';

  @override
  String get energyQuantityLabel => 'Amount';

  @override
  String get energyQuantityInvalid => 'Enter a number greater than zero';

  @override
  String energyComparisonDelta(
    String label,
    String amount,
    String worse,
    int percent,
  ) {
    return '$label uses $amount CO2e less than $worse ($percent% lower)';
  }

  @override
  String get energyComparisonNoVerdict => 'No winner here';

  @override
  String get energyVerdictWhyCta => 'Why not?';

  @override
  String get energyVerdictDifferentGroup =>
      'These two are different kinds of thing, so saying one is better would be a category error rather than a close call. Compare like with like -- a bath against a shower, a tumble dryer against a washing line.';

  @override
  String get energyVerdictDifferentCarrier =>
      'One of these runs on gas and the other on electricity, and which comes out cleaner depends on your local grid rather than on what you did. Below about 241 g CO2e per kWh electric heating wins; above it gas does. So both numbers are shown and no winner is declared.';

  @override
  String energyVerdictTooClose(int percent) {
    return 'These are within $percent% of each other, which is inside the accuracy of the underlying measurements. Calling a winner would be reading precision the sources do not have.';
  }

  @override
  String get energyUnitSuffixMinute => 'min';

  @override
  String get energyUnitSuffixHour => 'h';

  @override
  String get energyUnitSuffixUse => 'uses';

  @override
  String get energyUnitSuffixDay => 'days';
}
