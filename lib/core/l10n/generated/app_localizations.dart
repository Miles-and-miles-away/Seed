import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Seed'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Grow your sustainability habits'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navLogAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get navLogAction;

  /// No description provided for @navMascot.
  ///
  /// In en, this message translates to:
  /// **'Mascot'**
  String get navMascot;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLogin;

  /// No description provided for @authRegister.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authRegister;

  /// No description provided for @authLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get authLogout;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authContinueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueWithApple;

  /// No description provided for @authOrDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get authOrDivider;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String homeWelcome(String name);

  /// No description provided for @homeLogAction.
  ///
  /// In en, this message translates to:
  /// **'Log Action'**
  String get homeLogAction;

  /// No description provided for @homeRecentActions.
  ///
  /// In en, this message translates to:
  /// **'Recent Actions'**
  String get homeRecentActions;

  /// No description provided for @homeNoActions.
  ///
  /// In en, this message translates to:
  /// **'No actions logged yet. Start your journey!'**
  String get homeNoActions;

  /// No description provided for @actionLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log an Action'**
  String get actionLogTitle;

  /// No description provided for @actionSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search actions...'**
  String get actionSearchHint;

  /// No description provided for @actionLogged.
  ///
  /// In en, this message translates to:
  /// **'Action logged! {points} points earned'**
  String actionLogged(int points);

  /// No description provided for @noActionsFound.
  ///
  /// In en, this message translates to:
  /// **'No actions found'**
  String get noActionsFound;

  /// No description provided for @actionHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Action History'**
  String get actionHistoryTitle;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @addNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Add a note (optional)'**
  String get addNoteOptional;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Used my own bag at the store'**
  String get noteHint;

  /// No description provided for @pointsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} points'**
  String pointsLabel(int count);

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelLabel(int level);

  /// No description provided for @streakLabel.
  ///
  /// In en, this message translates to:
  /// **'{days} day streak'**
  String streakLabel(int days);

  /// No description provided for @co2Saved.
  ///
  /// In en, this message translates to:
  /// **'{amount} CO₂ saved'**
  String co2Saved(String amount);

  /// No description provided for @mascotName.
  ///
  /// In en, this message translates to:
  /// **'{name}'**
  String mascotName(String name);

  /// No description provided for @mascotRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get mascotRename;

  /// No description provided for @mascotEvolution.
  ///
  /// In en, this message translates to:
  /// **'Evolution Stage {stage}'**
  String mascotEvolution(int stage);

  /// No description provided for @mascotSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Companion'**
  String get mascotSelectionTitle;

  /// No description provided for @mascotSelectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This little friend will grow with you on your sustainability journey!'**
  String get mascotSelectionSubtitle;

  /// No description provided for @mascotNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Give your companion a name'**
  String get mascotNameLabel;

  /// No description provided for @mascotNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Sprouty, Leafy, Bud...'**
  String get mascotNameHint;

  /// No description provided for @mascotNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get mascotNameRequired;

  /// No description provided for @mascotNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get mascotNameTooShort;

  /// No description provided for @mascotNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name must be 20 characters or less'**
  String get mascotNameTooLong;

  /// No description provided for @mascotSelectionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Grow Together!'**
  String get mascotSelectionConfirm;

  /// No description provided for @evolutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Evolution!'**
  String get evolutionTitle;

  /// No description provided for @evolutionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your companion has grown stronger!'**
  String get evolutionSubtitle;

  /// No description provided for @evolutionContinue.
  ///
  /// In en, this message translates to:
  /// **'Amazing!'**
  String get evolutionContinue;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get profileStats;

  /// No description provided for @profileTotalActions.
  ///
  /// In en, this message translates to:
  /// **'Total Actions'**
  String get profileTotalActions;

  /// No description provided for @profileTotalCO2.
  ///
  /// In en, this message translates to:
  /// **'Total CO₂ Saved'**
  String get profileTotalCO2;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get profileMemberSince;

  /// No description provided for @profileCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get profileCurrentStreak;

  /// No description provided for @profileLongestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get profileLongestStreak;

  /// No description provided for @profileNextLevel.
  ///
  /// In en, this message translates to:
  /// **'{points} pts to next level'**
  String profileNextLevel(int points);

  /// No description provided for @profileDaysActive.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String profileDaysActive(int days);

  /// No description provided for @profileEvolutionStage.
  ///
  /// In en, this message translates to:
  /// **'Evolution Stage {stage}'**
  String profileEvolutionStage(int stage);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get settingsReminderTime;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get settingsSubscription;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTerms;

  /// No description provided for @subscriptionFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get subscriptionFree;

  /// No description provided for @subscriptionPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get subscriptionPremium;

  /// No description provided for @subscriptionUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get subscriptionUpgrade;

  /// No description provided for @categoryRecycling.
  ///
  /// In en, this message translates to:
  /// **'Recycling'**
  String get categoryRecycling;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get categoryEnergy;

  /// No description provided for @categoryConsumption.
  ///
  /// In en, this message translates to:
  /// **'Consumption'**
  String get categoryConsumption;

  /// No description provided for @categoryWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get categoryWater;

  /// No description provided for @categoryCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get categoryCommunity;

  /// No description provided for @categoryAdvocacy.
  ///
  /// In en, this message translates to:
  /// **'Advocacy'**
  String get categoryAdvocacy;

  /// No description provided for @categoryLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get categoryLearning;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get errorNetwork;

  /// No description provided for @errorAuth.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get errorAuth;

  /// No description provided for @buttonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// No description provided for @buttonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get buttonConfirm;

  /// No description provided for @buttonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get buttonClose;

  /// No description provided for @buttonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get buttonRetry;

  /// No description provided for @buttonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get buttonContinue;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTitle;

  /// No description provided for @progressGoalsToday.
  ///
  /// In en, this message translates to:
  /// **'goals today'**
  String get progressGoalsToday;

  /// No description provided for @progressGoalReached.
  ///
  /// In en, this message translates to:
  /// **'Daily goal reached!'**
  String get progressGoalReached;

  /// No description provided for @progressSetDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Your Daily Goal'**
  String get progressSetDailyGoal;

  /// No description provided for @progressSetDailyGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How many eco-friendly actions do you want to complete each day?'**
  String get progressSetDailyGoalSubtitle;

  /// No description provided for @progressStartJourney.
  ///
  /// In en, this message translates to:
  /// **'Start My Journey'**
  String get progressStartJourney;

  /// No description provided for @progressTargetDescriptionEasy.
  ///
  /// In en, this message translates to:
  /// **'A gentle start — perfect for beginners!'**
  String get progressTargetDescriptionEasy;

  /// No description provided for @progressTargetDescriptionModerate.
  ///
  /// In en, this message translates to:
  /// **'A balanced challenge — recommended for most users.'**
  String get progressTargetDescriptionModerate;

  /// No description provided for @progressTargetDescriptionChallenge.
  ///
  /// In en, this message translates to:
  /// **'Ambitious! You\'re committed to making an impact.'**
  String get progressTargetDescriptionChallenge;

  /// No description provided for @progressTargetDescriptionExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert level — you\'re a sustainability champion!'**
  String get progressTargetDescriptionExpert;

  /// No description provided for @languageSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettingsTitle;

  /// No description provided for @languageSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language. The app will update immediately.'**
  String get languageSettingsDescription;

  /// No description provided for @languageSettingsNote.
  ///
  /// In en, this message translates to:
  /// **'Some content from the action library may remain in its original language.'**
  String get languageSettingsNote;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} reminders enabled'**
  String settingsNotificationsSubtitle(int count);

  /// No description provided for @settingsNotificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off'**
  String get settingsNotificationsOff;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{language}'**
  String settingsLanguageSubtitle(String language);

  /// No description provided for @settingsAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Email, password, delete account'**
  String get settingsAccountSubtitle;

  /// No description provided for @settingsAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version, licenses, contact'**
  String get settingsAboutSubtitle;

  /// No description provided for @accountSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSettingsTitle;

  /// No description provided for @accountSettingsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get accountSettingsEmail;

  /// No description provided for @accountSettingsChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get accountSettingsChangeEmail;

  /// No description provided for @accountSettingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get accountSettingsChangePassword;

  /// No description provided for @accountSettingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get accountSettingsDeleteAccount;

  /// No description provided for @accountSettingsDeleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently deleted.'**
  String get accountSettingsDeleteAccountWarning;

  /// No description provided for @accountSettingsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get accountSettingsDeleteConfirmTitle;

  /// No description provided for @accountSettingsDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This will permanently delete all your data including your mascot, action history, and progress.'**
  String get accountSettingsDeleteConfirmMessage;

  /// No description provided for @accountSettingsDeleteConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get accountSettingsDeleteConfirmButton;

  /// No description provided for @accountSettingsCurrentEmail.
  ///
  /// In en, this message translates to:
  /// **'Current email'**
  String get accountSettingsCurrentEmail;

  /// No description provided for @accountSettingsNewEmail.
  ///
  /// In en, this message translates to:
  /// **'New email'**
  String get accountSettingsNewEmail;

  /// No description provided for @accountSettingsCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get accountSettingsCurrentPassword;

  /// No description provided for @accountSettingsNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get accountSettingsNewPassword;

  /// No description provided for @accountSettingsConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get accountSettingsConfirmNewPassword;

  /// No description provided for @accountSettingsPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get accountSettingsPasswordMismatch;

  /// No description provided for @accountSettingsEmailUpdated.
  ///
  /// In en, this message translates to:
  /// **'Email updated successfully'**
  String get accountSettingsEmailUpdated;

  /// No description provided for @accountSettingsPasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get accountSettingsPasswordUpdated;

  /// No description provided for @accountSettingsReauthRequired.
  ///
  /// In en, this message translates to:
  /// **'Please re-enter your password to continue'**
  String get accountSettingsReauthRequired;

  /// No description provided for @aboutSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSettingsTitle;

  /// No description provided for @aboutSettingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutSettingsVersion;

  /// No description provided for @aboutSettingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get aboutSettingsLicenses;

  /// No description provided for @aboutSettingsContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get aboutSettingsContact;

  /// No description provided for @aboutSettingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutSettingsPrivacy;

  /// No description provided for @aboutSettingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get aboutSettingsTerms;

  /// No description provided for @streakMilestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Amazing!'**
  String get streakMilestoneTitle;

  /// No description provided for @streakMilestoneWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count} Week Streak!'**
  String streakMilestoneWeeks(int count);

  /// No description provided for @streakMilestoneDays.
  ///
  /// In en, this message translates to:
  /// **'You\'ve logged actions for {count} days in a row!'**
  String streakMilestoneDays(int count);

  /// No description provided for @streakMilestoneKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep up the amazing work!'**
  String get streakMilestoneKeepGoing;

  /// No description provided for @streakMilestoneContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get streakMilestoneContinue;

  /// No description provided for @streakBrokenTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak Broken'**
  String get streakBrokenTitle;

  /// No description provided for @streakBrokenMessage.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! Start a new streak today.'**
  String get streakBrokenMessage;

  /// No description provided for @streakBrokenPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous streak: {count} days'**
  String streakBrokenPrevious(int count);

  /// No description provided for @streakBrokenStartNew.
  ///
  /// In en, this message translates to:
  /// **'Start New Streak'**
  String get streakBrokenStartNew;

  /// No description provided for @sortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortLabel;

  /// No description provided for @sortAlphabeticalAZ.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get sortAlphabeticalAZ;

  /// No description provided for @sortAlphabeticalZA.
  ///
  /// In en, this message translates to:
  /// **'Name (Z-A)'**
  String get sortAlphabeticalZA;

  /// No description provided for @sortCo2HighToLow.
  ///
  /// In en, this message translates to:
  /// **'CO₂ (High to Low)'**
  String get sortCo2HighToLow;

  /// No description provided for @sortCo2LowToHigh.
  ///
  /// In en, this message translates to:
  /// **'CO₂ (Low to High)'**
  String get sortCo2LowToHigh;

  /// No description provided for @sortPointsHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Points (High to Low)'**
  String get sortPointsHighToLow;

  /// No description provided for @sortPointsLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Points (Low to High)'**
  String get sortPointsLowToHigh;

  /// No description provided for @filterBySDG.
  ///
  /// In en, this message translates to:
  /// **'Filter by SDG'**
  String get filterBySDG;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @co2PerAction.
  ///
  /// In en, this message translates to:
  /// **'{amount}g CO₂'**
  String co2PerAction(Object amount);

  /// No description provided for @sdgYourImpact.
  ///
  /// In en, this message translates to:
  /// **'Your Impact'**
  String get sdgYourImpact;

  /// No description provided for @sdgActionsLogged.
  ///
  /// In en, this message translates to:
  /// **'{count} actions logged'**
  String sdgActionsLogged(int count);

  /// No description provided for @sdgCo2SavedForGoal.
  ///
  /// In en, this message translates to:
  /// **'{amount} CO₂ saved for this goal'**
  String sdgCo2SavedForGoal(String amount);

  /// No description provided for @sdgRelatedActions.
  ///
  /// In en, this message translates to:
  /// **'Related Actions'**
  String get sdgRelatedActions;

  /// No description provided for @sdgViewAllActions.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get sdgViewAllActions;

  /// No description provided for @sdgResources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get sdgResources;

  /// No description provided for @sdgLearnOnlyExplanation.
  ///
  /// In en, this message translates to:
  /// **'This goal addresses systemic issues that require collective action. While you can\'t log daily actions for it directly, learning about it helps you understand the bigger picture and find ways to contribute.'**
  String get sdgLearnOnlyExplanation;

  /// No description provided for @sdgWaysToContribute.
  ///
  /// In en, this message translates to:
  /// **'Ways to Contribute'**
  String get sdgWaysToContribute;

  /// No description provided for @sdgNoActionsYet.
  ///
  /// In en, this message translates to:
  /// **'No actions logged for this goal yet'**
  String get sdgNoActionsYet;

  /// No description provided for @learnOnlyBadge.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learnOnlyBadge;

  /// No description provided for @learnOnlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn About This Action'**
  String get learnOnlyTitle;

  /// No description provided for @learnOnlyDescription.
  ///
  /// In en, this message translates to:
  /// **'This action supports broader sustainability goals. While it can\'t be logged directly, learning about it helps you understand the bigger picture.'**
  String get learnOnlyDescription;

  /// No description provided for @learnOnlyRelatedSdgs.
  ///
  /// In en, this message translates to:
  /// **'Related Goals'**
  String get learnOnlyRelatedSdgs;

  /// No description provided for @learnOnlyDismiss.
  ///
  /// In en, this message translates to:
  /// **'Got It'**
  String get learnOnlyDismiss;

  /// No description provided for @settingsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsAnalytics;

  /// No description provided for @settingsAnalyticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help improve Seed by sharing anonymous usage data'**
  String get settingsAnalyticsSubtitle;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceTitle;

  /// No description provided for @legalLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String legalLastUpdated(String date);

  /// No description provided for @eggDiscoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'A Mysterious Egg!'**
  String get eggDiscoveryTitle;

  /// No description provided for @eggDiscoveryMessage.
  ///
  /// In en, this message translates to:
  /// **'Overnight, a mysterious egg appeared beside {mascotName}!'**
  String eggDiscoveryMessage(String mascotName);

  /// No description provided for @eggDiscoverySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log actions every day for 30 days to hatch it.'**
  String get eggDiscoverySubtitle;

  /// No description provided for @eggDiscoveryDismiss.
  ///
  /// In en, this message translates to:
  /// **'How exciting!'**
  String get eggDiscoveryDismiss;

  /// No description provided for @eggHatchingTitle.
  ///
  /// In en, this message translates to:
  /// **'It\'s Hatching!'**
  String get eggHatchingTitle;

  /// No description provided for @eggHatchingNamePrompt.
  ///
  /// In en, this message translates to:
  /// **'Give your new companion a name'**
  String get eggHatchingNamePrompt;

  /// No description provided for @eggHatchingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get eggHatchingConfirm;

  /// No description provided for @eggProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {current}/{total}'**
  String eggProgressLabel(int current, int total);

  /// No description provided for @mascotCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'My Mascots'**
  String get mascotCollectionTitle;

  /// No description provided for @mascotSwitchConfirm.
  ///
  /// In en, this message translates to:
  /// **'Switch Mascot?'**
  String get mascotSwitchConfirm;

  /// No description provided for @switchToMascot.
  ///
  /// In en, this message translates to:
  /// **'Switch to'**
  String get switchToMascot;

  /// No description provided for @switchMascotButton.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchMascotButton;

  /// No description provided for @actionLearnMore.
  ///
  /// In en, this message translates to:
  /// **'Tap to learn the science'**
  String get actionLearnMore;

  /// No description provided for @maxEvolutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Maximum Evolution!'**
  String get maxEvolutionTitle;

  /// No description provided for @maxEvolutionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your companion has reached their full potential!'**
  String get maxEvolutionSubtitle;

  /// No description provided for @maxEvolutionEggHint.
  ///
  /// In en, this message translates to:
  /// **'Nurture your egg to discover a new companion!'**
  String get maxEvolutionEggHint;

  /// No description provided for @sdgAboutGoal.
  ///
  /// In en, this message translates to:
  /// **'About this Goal'**
  String get sdgAboutGoal;

  /// No description provided for @sdgViewTargets.
  ///
  /// In en, this message translates to:
  /// **'View targets'**
  String get sdgViewTargets;

  /// No description provided for @sdgTargetsTitle.
  ///
  /// In en, this message translates to:
  /// **'UN Targets'**
  String get sdgTargetsTitle;

  /// No description provided for @notifSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notifSettingsTitle;

  /// No description provided for @notifSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifSectionNotifications;

  /// No description provided for @notifEnableTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get notifEnableTitle;

  /// No description provided for @notifEnableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive daily reminders to log actions'**
  String get notifEnableSubtitle;

  /// No description provided for @notifSmartTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Reminders'**
  String get notifSmartTitle;

  /// No description provided for @notifSmartOnlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Only remind if no action today'**
  String get notifSmartOnlyTitle;

  /// No description provided for @notifSmartOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Skip reminders on days you\'ve already logged'**
  String get notifSmartOnlySubtitle;

  /// No description provided for @notifSmartDescription.
  ///
  /// In en, this message translates to:
  /// **'When enabled, reminders will only appear if you haven\'t logged any sustainable actions that day.'**
  String get notifSmartDescription;

  /// No description provided for @notifReminderTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Times'**
  String get notifReminderTimesTitle;

  /// No description provided for @notifNoReminders.
  ///
  /// In en, this message translates to:
  /// **'No reminders set'**
  String get notifNoReminders;

  /// No description provided for @notifAddReminder.
  ///
  /// In en, this message translates to:
  /// **'Add a reminder to get notified'**
  String get notifAddReminder;

  /// No description provided for @notifAddReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Add Reminder Time'**
  String get notifAddReminderTime;

  /// No description provided for @notifMaxReminders.
  ///
  /// In en, this message translates to:
  /// **'Maximum 5 reminders allowed'**
  String get notifMaxReminders;

  /// No description provided for @notifEditTime.
  ///
  /// In en, this message translates to:
  /// **'Edit reminder time'**
  String get notifEditTime;

  /// No description provided for @notifSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Select reminder time'**
  String get notifSelectTime;

  /// No description provided for @notifLabelTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Label'**
  String get notifLabelTitle;

  /// No description provided for @notifLabelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Morning, After work...'**
  String get notifLabelHint;

  /// No description provided for @notifLabelOptional.
  ///
  /// In en, this message translates to:
  /// **'Label (optional)'**
  String get notifLabelOptional;

  /// No description provided for @notifDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Reminder?'**
  String get notifDeleteTitle;

  /// No description provided for @notifDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove the {time} reminder?'**
  String notifDeleteMessage(String time);

  /// No description provided for @notifAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get notifAdd;

  /// No description provided for @settingsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsPreferences;

  /// No description provided for @settingsVersionFormat.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersionFormat(String version);

  /// No description provided for @settingsNoReminders.
  ///
  /// In en, this message translates to:
  /// **'No reminders set'**
  String get settingsNoReminders;

  /// No description provided for @settingsRemindersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reminders configured'**
  String settingsRemindersCount(int count);

  /// No description provided for @settingsOneReminder.
  ///
  /// In en, this message translates to:
  /// **'1 reminder configured'**
  String get settingsOneReminder;

  /// No description provided for @settingsTapToAddReminders.
  ///
  /// In en, this message translates to:
  /// **'Tap to add reminders'**
  String get settingsTapToAddReminders;

  /// No description provided for @settingsAllRemindersDisabled.
  ///
  /// In en, this message translates to:
  /// **'All reminders disabled'**
  String get settingsAllRemindersDisabled;

  /// No description provided for @settingsRemindersPlusMore.
  ///
  /// In en, this message translates to:
  /// **'{time} + {count} more'**
  String settingsRemindersPlusMore(String time, int count);

  /// No description provided for @settingsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading settings'**
  String get settingsErrorLoading;

  /// No description provided for @aboutLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get aboutLegal;

  /// No description provided for @aboutSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get aboutSupport;

  /// No description provided for @aboutFooterSdg.
  ///
  /// In en, this message translates to:
  /// **'Seed helps track sustainable actions aligned with the UN Sustainable Development Goals.'**
  String get aboutFooterSdg;

  /// No description provided for @aboutFooterMade.
  ///
  /// In en, this message translates to:
  /// **'Made with care for our planet.'**
  String get aboutFooterMade;

  /// No description provided for @aboutSubtitleTracker.
  ///
  /// In en, this message translates to:
  /// **'Sustainability Habit Tracker'**
  String get aboutSubtitleTracker;

  /// No description provided for @aboutEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'Seed App Feedback'**
  String get aboutEmailSubject;

  /// No description provided for @mascotEvolutionTimeline.
  ///
  /// In en, this message translates to:
  /// **'Evolution Timeline'**
  String get mascotEvolutionTimeline;

  /// No description provided for @mascotNextEvolution.
  ///
  /// In en, this message translates to:
  /// **'Next Evolution'**
  String get mascotNextEvolution;

  /// No description provided for @mascotLevelShort.
  ///
  /// In en, this message translates to:
  /// **'Lv {level}'**
  String mascotLevelShort(int level);

  /// No description provided for @mascotLevelsToGo.
  ///
  /// In en, this message translates to:
  /// **'{count} levels to go'**
  String mascotLevelsToGo(int count);

  /// No description provided for @mascotLevelProgress.
  ///
  /// In en, this message translates to:
  /// **'Level {current} / {max}'**
  String mascotLevelProgress(int current, int max);

  /// No description provided for @homeExploreGoals.
  ///
  /// In en, this message translates to:
  /// **'Explore the Goals'**
  String get homeExploreGoals;

  /// No description provided for @homeExploreGoalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to learn about the UN Sustainable Development Goals'**
  String get homeExploreGoalsSubtitle;

  /// No description provided for @homeLearnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more at UN.org'**
  String get homeLearnMore;

  /// No description provided for @homePoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get homePoints;

  /// No description provided for @sdgGoalNumber.
  ///
  /// In en, this message translates to:
  /// **'Goal {number}'**
  String sdgGoalNumber(int number);

  /// No description provided for @sdgBadge.
  ///
  /// In en, this message translates to:
  /// **'UN SDG'**
  String get sdgBadge;

  /// No description provided for @buttonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get buttonDelete;

  /// No description provided for @buttonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get buttonSkip;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authWelcomeBack;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your sustainability journey'**
  String get authSignInSubtitle;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get authOrContinueWith;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccount;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authCreateAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your sustainability journey today'**
  String get authCreateAccountSubtitle;

  /// No description provided for @authOrSignUpWith.
  ///
  /// In en, this message translates to:
  /// **'or sign up with'**
  String get authOrSignUpWith;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHaveAccount;

  /// No description provided for @authAgreePrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get authAgreePrefix;

  /// No description provided for @authAgreeAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get authAgreeAnd;

  /// No description provided for @authAcceptTermsError.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms of Service and Privacy Policy'**
  String get authAcceptTermsError;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get authForgotPasswordHint;

  /// No description provided for @authForgotPasswordSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get authForgotPasswordSend;

  /// No description provided for @authForgotPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists with this email, a password reset link has been sent.'**
  String get authForgotPasswordSent;

  /// No description provided for @authVerifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get authVerifyEmailTitle;

  /// No description provided for @authCheckEmail.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get authCheckEmail;

  /// No description provided for @authVerificationSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification link to:'**
  String get authVerificationSentTo;

  /// No description provided for @authVerifyInstructions.
  ///
  /// In en, this message translates to:
  /// **'Click the link in the email to verify your account, then return here and tap the button below.'**
  String get authVerifyInstructions;

  /// No description provided for @authChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get authChecking;

  /// No description provided for @authVerifiedButton.
  ///
  /// In en, this message translates to:
  /// **'I\'ve Verified My Email'**
  String get authVerifiedButton;

  /// No description provided for @authVerificationSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent!'**
  String get authVerificationSent;

  /// No description provided for @authResendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get authResendEmail;

  /// No description provided for @authDifferentEmail.
  ///
  /// In en, this message translates to:
  /// **'Use a Different Email'**
  String get authDifferentEmail;

  /// No description provided for @authEmailVerified.
  ///
  /// In en, this message translates to:
  /// **'Email verified! Welcome to Seed!'**
  String get authEmailVerified;

  /// No description provided for @authEmailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email not verified yet. Please check your inbox and click the verification link.'**
  String get authEmailNotVerified;

  /// No description provided for @authValidationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get authValidationEmailRequired;

  /// No description provided for @authValidationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get authValidationEmailInvalid;

  /// No description provided for @authValidationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get authValidationPasswordRequired;

  /// No description provided for @authValidationPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authValidationPasswordShort;

  /// No description provided for @authValidationConfirmRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get authValidationConfirmRequired;

  /// No description provided for @pointsAbbreviated.
  ///
  /// In en, this message translates to:
  /// **'{count} pts'**
  String pointsAbbreviated(int count);

  /// No description provided for @stageFallback.
  ///
  /// In en, this message translates to:
  /// **'Stage {stage}'**
  String stageFallback(int stage);

  /// No description provided for @dayDetailActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get dayDetailActions;

  /// No description provided for @dayDetailNoActions.
  ///
  /// In en, this message translates to:
  /// **'No actions logged this day'**
  String get dayDetailNoActions;

  /// No description provided for @dayDetailFactLocked.
  ///
  /// In en, this message translates to:
  /// **'No eco-fact unlocked this day'**
  String get dayDetailFactLocked;

  /// No description provided for @ecoFactTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Eco-Fact'**
  String get ecoFactTitle;

  /// No description provided for @ecoFactDidYouKnow.
  ///
  /// In en, this message translates to:
  /// **'Did you know?'**
  String get ecoFactDidYouKnow;

  /// No description provided for @ecoFactSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get ecoFactSource;

  /// No description provided for @ecoFactLocked.
  ///
  /// In en, this message translates to:
  /// **'Complete today\'s challenge to unlock this fact!'**
  String get ecoFactLocked;

  /// No description provided for @ecoFactInboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get ecoFactInboxTitle;

  /// No description provided for @ecoFactInboxEmpty.
  ///
  /// In en, this message translates to:
  /// **'No mail yet. Complete today\'s challenge to receive your first eco-fact.'**
  String get ecoFactInboxEmpty;

  /// No description provided for @ecoFactInboxLockedSubject.
  ///
  /// In en, this message translates to:
  /// **'Locked eco-fact'**
  String get ecoFactInboxLockedSubject;

  /// No description provided for @ecoFactCategoryComparison.
  ///
  /// In en, this message translates to:
  /// **'Comparison'**
  String get ecoFactCategoryComparison;

  /// No description provided for @ecoFactCategoryIndividual.
  ///
  /// In en, this message translates to:
  /// **'Individual Impact'**
  String get ecoFactCategoryIndividual;

  /// No description provided for @ecoFactCategoryMythBuster.
  ///
  /// In en, this message translates to:
  /// **'Myth Buster'**
  String get ecoFactCategoryMythBuster;

  /// No description provided for @ecoFactCategoryNatureWonder.
  ///
  /// In en, this message translates to:
  /// **'Nature Wonder'**
  String get ecoFactCategoryNatureWonder;

  /// No description provided for @ecoFactCategoryPositiveNews.
  ///
  /// In en, this message translates to:
  /// **'Positive News'**
  String get ecoFactCategoryPositiveNews;

  /// No description provided for @challengeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Challenge'**
  String get challengeDialogTitle;

  /// No description provided for @challengeDialogLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get challengeDialogLater;

  /// No description provided for @challengeDialogLogAction.
  ///
  /// In en, this message translates to:
  /// **'Log Action'**
  String get challengeDialogLogAction;

  /// No description provided for @challengeDialogUnlock.
  ///
  /// In en, this message translates to:
  /// **'Complete to unlock today\'s eco-fact!'**
  String get challengeDialogUnlock;

  /// No description provided for @challengeTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get challengeTabLabel;

  /// No description provided for @challengeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Complete!'**
  String get challengeCompleted;

  /// No description provided for @challengeNotCompleted.
  ///
  /// In en, this message translates to:
  /// **'Not yet completed'**
  String get challengeNotCompleted;

  /// No description provided for @challengeSeeFact.
  ///
  /// In en, this message translates to:
  /// **'See today\'s eco-fact'**
  String get challengeSeeFact;

  /// No description provided for @challengeStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{days} day challenge streak'**
  String challengeStreakDays(int days);

  /// No description provided for @challengeMultiDayProgress.
  ///
  /// In en, this message translates to:
  /// **'Day {current} of {target}'**
  String challengeMultiDayProgress(int current, int target);

  /// No description provided for @challengeCompletedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Challenge completed! Eco-fact unlocked!'**
  String get challengeCompletedSnackbar;

  /// No description provided for @challengeBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse Challenges'**
  String get challengeBrowse;

  /// No description provided for @challengesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Multi-Day Challenges'**
  String get challengesScreenTitle;

  /// No description provided for @challengeStart.
  ///
  /// In en, this message translates to:
  /// **'Start Challenge'**
  String get challengeStart;

  /// No description provided for @challengeStartConfirm.
  ///
  /// In en, this message translates to:
  /// **'Start this challenge?'**
  String get challengeStartConfirm;

  /// No description provided for @challengeActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get challengeActive;

  /// No description provided for @challengeCompletedBadge.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get challengeCompletedBadge;

  /// No description provided for @challengeAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get challengeAvailable;

  /// No description provided for @challengeAbandon.
  ///
  /// In en, this message translates to:
  /// **'Abandon'**
  String get challengeAbandon;

  /// No description provided for @challengeAbandonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Abandon this challenge? Progress will be lost.'**
  String get challengeAbandonConfirm;

  /// No description provided for @challengeDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String challengeDays(int days);

  /// No description provided for @challengeAnyCategory.
  ///
  /// In en, this message translates to:
  /// **'Any category'**
  String get challengeAnyCategory;

  /// No description provided for @challengeLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get challengeLocked;

  /// No description provided for @progressCalendarTab.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get progressCalendarTab;

  /// No description provided for @ecoDexTab.
  ///
  /// In en, this message translates to:
  /// **'Eco-Dex'**
  String get ecoDexTab;

  /// No description provided for @impactTab.
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get impactTab;

  /// No description provided for @periodToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get periodToday;

  /// No description provided for @periodThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get periodThisWeek;

  /// No description provided for @periodThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get periodThisMonth;

  /// No description provided for @periodAllTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get periodAllTime;

  /// No description provided for @co2SavedToday.
  ///
  /// In en, this message translates to:
  /// **'CO2 saved today'**
  String get co2SavedToday;

  /// No description provided for @co2SavedThisWeek.
  ///
  /// In en, this message translates to:
  /// **'CO2 saved this week'**
  String get co2SavedThisWeek;

  /// No description provided for @co2SavedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'CO2 saved this month'**
  String get co2SavedThisMonth;

  /// No description provided for @co2SavedAllTime.
  ///
  /// In en, this message translates to:
  /// **'CO2 saved all time'**
  String get co2SavedAllTime;

  /// No description provided for @kgUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kgUnit;

  /// No description provided for @vsYesterday.
  ///
  /// In en, this message translates to:
  /// **'vs. yesterday'**
  String get vsYesterday;

  /// No description provided for @vsLastWeek.
  ///
  /// In en, this message translates to:
  /// **'vs. last week'**
  String get vsLastWeek;

  /// No description provided for @vsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'vs. last month'**
  String get vsLastMonth;

  /// No description provided for @equivalentToHeader.
  ///
  /// In en, this message translates to:
  /// **'Equivalent to'**
  String get equivalentToHeader;

  /// No description provided for @equivTreesLabel.
  ///
  /// In en, this message translates to:
  /// **'trees / year'**
  String get equivTreesLabel;

  /// No description provided for @equivCarKmLabel.
  ///
  /// In en, this message translates to:
  /// **'km not driven'**
  String get equivCarKmLabel;

  /// No description provided for @equivPhoneChargesLabel.
  ///
  /// In en, this message translates to:
  /// **'phone charges'**
  String get equivPhoneChargesLabel;

  /// No description provided for @equivBurgersLabel.
  ///
  /// In en, this message translates to:
  /// **'burgers'**
  String get equivBurgersLabel;

  /// No description provided for @ecoDexTitle.
  ///
  /// In en, this message translates to:
  /// **'Eco-Dex'**
  String get ecoDexTitle;

  /// No description provided for @ecoDexProgress.
  ///
  /// In en, this message translates to:
  /// **'{discovered} / {total} discovered'**
  String ecoDexProgress(int discovered, int total);

  /// No description provided for @ecoDexLocked.
  ///
  /// In en, this message translates to:
  /// **'Undiscovered'**
  String get ecoDexLocked;

  /// No description provided for @ecoDexViewSource.
  ///
  /// In en, this message translates to:
  /// **'View source'**
  String get ecoDexViewSource;

  /// No description provided for @ecoDexNewDiscovery.
  ///
  /// In en, this message translates to:
  /// **'New Eco-Dex discovery!'**
  String get ecoDexNewDiscovery;

  /// No description provided for @ecoDexNewDiscoveryMessage.
  ///
  /// In en, this message translates to:
  /// **'You discovered: {name}'**
  String ecoDexNewDiscoveryMessage(String name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
