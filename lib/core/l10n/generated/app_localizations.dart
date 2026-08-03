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
    Locale('ja'),
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
  /// **'{count, plural, one{{count} point} other{{count} points}}'**
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
  /// **'{days, plural, one{{days} day} other{{days} days}}'**
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

  /// No description provided for @errorOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open link.'**
  String get errorOpenLink;

  /// No description provided for @errorActionTooSoon.
  ///
  /// In en, this message translates to:
  /// **'Please wait a few seconds between actions.'**
  String get errorActionTooSoon;

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Check your connection and try again.'**
  String get errorOffline;

  /// No description provided for @errorAuthEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email address.'**
  String get errorAuthEmailInUse;

  /// No description provided for @errorAuthInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get errorAuthInvalidEmail;

  /// No description provided for @errorAuthOperationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This sign-in method is not enabled. Please contact support.'**
  String get errorAuthOperationNotAllowed;

  /// No description provided for @errorAuthWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak. Please use at least 6 characters.'**
  String get errorAuthWeakPassword;

  /// No description provided for @errorAuthUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled. Please contact support.'**
  String get errorAuthUserDisabled;

  /// No description provided for @errorAuthInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please try again.'**
  String get errorAuthInvalidCredentials;

  /// No description provided for @errorAuthTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get errorAuthTooManyRequests;

  /// No description provided for @errorAuthNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get errorAuthNetwork;

  /// No description provided for @errorAuthSignInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in was cancelled.'**
  String get errorAuthSignInCancelled;

  /// No description provided for @errorAuthAccountExistsWithDifferentCredential.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email using a different sign-in method.'**
  String get errorAuthAccountExistsWithDifferentCredential;

  /// No description provided for @errorAuthLinkExpired.
  ///
  /// In en, this message translates to:
  /// **'This link has expired. Please request a new one.'**
  String get errorAuthLinkExpired;

  /// No description provided for @errorAuthLinkInvalid.
  ///
  /// In en, this message translates to:
  /// **'This link is invalid. Please request a new one.'**
  String get errorAuthLinkInvalid;

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

  /// No description provided for @accountSettingsProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get accountSettingsProfile;

  /// No description provided for @accountSettingsDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get accountSettingsDisplayName;

  /// No description provided for @accountSettingsNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get accountSettingsNotSet;

  /// No description provided for @accountSettingsDisplayNameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Display name updated successfully'**
  String get accountSettingsDisplayNameUpdated;

  /// No description provided for @accountSettingsDisplayNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get accountSettingsDisplayNameRequired;

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
  /// **'{count, plural, one{{count} action logged} other{{count} actions logged}}'**
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

  /// No description provided for @settingsSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsSupport;

  /// No description provided for @settingsFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get settingsFeedback;

  /// No description provided for @settingsFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Report a bug or share your thoughts'**
  String get settingsFeedbackSubtitle;

  /// No description provided for @aboutLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get aboutLegal;

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

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get feedbackCategoryLabel;

  /// No description provided for @feedbackCategoryBug.
  ///
  /// In en, this message translates to:
  /// **'Bug Report'**
  String get feedbackCategoryBug;

  /// No description provided for @feedbackCategoryFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature Request'**
  String get feedbackCategoryFeature;

  /// No description provided for @feedbackCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General Feedback'**
  String get feedbackCategoryGeneral;

  /// No description provided for @feedbackDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Describe your feedback'**
  String get feedbackDescriptionLabel;

  /// No description provided for @feedbackDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us what\'s on your mind...'**
  String get feedbackDescriptionHint;

  /// No description provided for @feedbackMetadataNote.
  ///
  /// In en, this message translates to:
  /// **'The following info is included to help us investigate: app version, device and OS, language, and your account ID.'**
  String get feedbackMetadataNote;

  /// No description provided for @feedbackSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get feedbackSubmit;

  /// No description provided for @feedbackThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your feedback!'**
  String get feedbackThanks;

  /// No description provided for @feedbackMailFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open your mail app. Please try again.'**
  String get feedbackMailFailed;

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

  /// No description provided for @mascotStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Journey'**
  String get mascotStatsTitle;

  /// No description provided for @mascotStatBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get mascotStatBirthday;

  /// No description provided for @mascotStatDaysTogether.
  ///
  /// In en, this message translates to:
  /// **'Days together'**
  String get mascotStatDaysTogether;

  /// No description provided for @mascotStatCo2Together.
  ///
  /// In en, this message translates to:
  /// **'CO₂ saved together'**
  String get mascotStatCo2Together;

  /// No description provided for @mascotLevelShort.
  ///
  /// In en, this message translates to:
  /// **'Lv {level}'**
  String mascotLevelShort(int level);

  /// No description provided for @mascotLevelsToGo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} level to go} other{{count} levels to go}}'**
  String mascotLevelsToGo(int count);

  /// No description provided for @mascotLevelProgress.
  ///
  /// In en, this message translates to:
  /// **'Level {current} / {max}'**
  String mascotLevelProgress(int current, int max);

  /// No description provided for @homeExploreGoals.
  ///
  /// In en, this message translates to:
  /// **'Explore the SDG Goals'**
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

  /// No description provided for @myGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'My Goal'**
  String get myGoalTitle;

  /// No description provided for @myGoalEmptyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap to set your sustainability goal'**
  String get myGoalEmptyPrompt;

  /// No description provided for @myGoalUpdated.
  ///
  /// In en, this message translates to:
  /// **'Goal updated successfully'**
  String get myGoalUpdated;

  /// No description provided for @goalPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your goal'**
  String get goalPickerTitle;

  /// No description provided for @goalPickerCustomOption.
  ///
  /// In en, this message translates to:
  /// **'Write your own'**
  String get goalPickerCustomOption;

  /// No description provided for @goalPickerCustomHint.
  ///
  /// In en, this message translates to:
  /// **'My goal is...'**
  String get goalPickerCustomHint;

  /// No description provided for @personalGoalReduceFlights.
  ///
  /// In en, this message translates to:
  /// **'Reduce long-haul flights'**
  String get personalGoalReduceFlights;

  /// No description provided for @personalGoalPlantBased.
  ///
  /// In en, this message translates to:
  /// **'Eat more plant-based meals'**
  String get personalGoalPlantBased;

  /// No description provided for @personalGoalLessPlastic.
  ///
  /// In en, this message translates to:
  /// **'Cut out single-use plastic'**
  String get personalGoalLessPlastic;

  /// No description provided for @personalGoalWalkBike.
  ///
  /// In en, this message translates to:
  /// **'Walk or bike instead of driving'**
  String get personalGoalWalkBike;

  /// No description provided for @personalGoalLessFoodWaste.
  ///
  /// In en, this message translates to:
  /// **'Waste less food'**
  String get personalGoalLessFoodWaste;

  /// No description provided for @personalGoalBuyLess.
  ///
  /// In en, this message translates to:
  /// **'Buy less, reuse more'**
  String get personalGoalBuyLess;

  /// No description provided for @personalGoalInspireOthers.
  ///
  /// In en, this message translates to:
  /// **'Inspire friends and family to act'**
  String get personalGoalInspireOthers;

  /// No description provided for @personalGoalSaveWorld.
  ///
  /// In en, this message translates to:
  /// **'Save the world'**
  String get personalGoalSaveWorld;

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
  /// **'{days, plural, one{{days} day} other{{days} days}}'**
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

  /// No description provided for @trendChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily trend'**
  String get trendChartTitle;

  /// No description provided for @trendChartAverageLabel.
  ///
  /// In en, this message translates to:
  /// **'average'**
  String get trendChartAverageLabel;

  /// No description provided for @categoryChartTitle.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get categoryChartTitle;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @equivalentToHeader.
  ///
  /// In en, this message translates to:
  /// **'Equivalent to'**
  String get equivalentToHeader;

  /// No description provided for @equivTreesLabel.
  ///
  /// In en, this message translates to:
  /// **'tree-years'**
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
  /// **'beef burgers'**
  String get equivBurgersLabel;

  /// No description provided for @impactInfoTooltip.
  ///
  /// In en, this message translates to:
  /// **'How we calculate this'**
  String get impactInfoTooltip;

  /// No description provided for @impactInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'How we calculate this'**
  String get impactInfoTitle;

  /// No description provided for @impactInfoIntro.
  ///
  /// In en, this message translates to:
  /// **'We translate the CO2 you\'ve saved into everyday comparisons. The figures are illustrative -- we use global averages and mix CO2 with CO2-equivalent (methane, grid electricity, food lifecycle), so your real impact will vary with local grid mix and supply chain.'**
  String get impactInfoIntro;

  /// No description provided for @impactInfoFormulaLabel.
  ///
  /// In en, this message translates to:
  /// **'Formula'**
  String get impactInfoFormulaLabel;

  /// No description provided for @impactInfoSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get impactInfoSourceLabel;

  /// No description provided for @equivTreesExplainer.
  ///
  /// In en, this message translates to:
  /// **'Approximate CO2 absorbed by a single mature urban tree in one year. Newly planted saplings absorb far less -- this is the steady-state mature figure.'**
  String get equivTreesExplainer;

  /// No description provided for @equivCarKmExplainer.
  ///
  /// In en, this message translates to:
  /// **'Average passenger car emissions per kilometer driven, fleet-weighted across petrol and diesel vehicles.'**
  String get equivCarKmExplainer;

  /// No description provided for @equivPhoneChargesExplainer.
  ///
  /// In en, this message translates to:
  /// **'Grid electricity used to fully charge an average smartphone, based on the US national grid mix. Cleaner grids (e.g. Norway) use less; coal-heavy grids use more.'**
  String get equivPhoneChargesExplainer;

  /// No description provided for @equivBurgersExplainer.
  ///
  /// In en, this message translates to:
  /// **'Full lifecycle emissions of one beef burger (113 g patty), from cattle farming to retail. A chicken burger emits roughly 10x less; a bean burger roughly 50x less.'**
  String get equivBurgersExplainer;

  /// No description provided for @equivFormulaTemplate.
  ///
  /// In en, this message translates to:
  /// **'g of CO2 / {factor}'**
  String equivFormulaTemplate(String factor);

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

  /// No description provided for @ecoDexAchievement.
  ///
  /// In en, this message translates to:
  /// **'Achievement: {hint}'**
  String ecoDexAchievement(String hint);

  /// No description provided for @ecoDexNewDiscovery.
  ///
  /// In en, this message translates to:
  /// **'New Eco-Dex discovery!'**
  String get ecoDexNewDiscovery;

  /// No description provided for @ecoDexNextUp.
  ///
  /// In en, this message translates to:
  /// **'Next Up'**
  String get ecoDexNextUp;

  /// No description provided for @ecoDexDiscoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'New Discovery!'**
  String get ecoDexDiscoveryTitle;

  /// No description provided for @ecoDexDiscoveryAcknowledge.
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get ecoDexDiscoveryAcknowledge;

  /// No description provided for @ecoDexDiscoveryMoreQueued.
  ///
  /// In en, this message translates to:
  /// **'+{count} more queued'**
  String ecoDexDiscoveryMoreQueued(int count);

  /// No description provided for @ecoDexEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Log your first action to make your first discovery.'**
  String get ecoDexEmptyHint;

  /// No description provided for @ecoDexInfoTooltip.
  ///
  /// In en, this message translates to:
  /// **'About the Eco-Dex'**
  String get ecoDexInfoTooltip;

  /// No description provided for @ecoDexInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'About the Eco-Dex'**
  String get ecoDexInfoTitle;

  /// No description provided for @ecoDexInfoBody.
  ///
  /// In en, this message translates to:
  /// **'The Eco-Dex is your encyclopedia of facts about our planet. Entries unlock automatically as you use Seed: logging actions, saving CO2, keeping up streaks, completing challenges, and reading eco facts. Tap a locked card for a hint on how to discover it, and tap a discovered entry to read its full fact. Discoveries do not award points: each one rewards you with knowledge.'**
  String get ecoDexInfoBody;

  /// No description provided for @transportCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Transport Calculator'**
  String get transportCalculatorTitle;

  /// No description provided for @calculatorsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculators'**
  String get calculatorsSheetTitle;

  /// No description provided for @calculatorsButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Calculators'**
  String get calculatorsButtonTooltip;

  /// No description provided for @calculatorHomeEnergy.
  ///
  /// In en, this message translates to:
  /// **'Home energy'**
  String get calculatorHomeEnergy;

  /// No description provided for @calculatorComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get calculatorComingSoon;

  /// No description provided for @transportJourneyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add a leg to build your journey and see its CO2e footprint.'**
  String get transportJourneyEmpty;

  /// Button under each journey column that opens the mode picker for that column
  ///
  /// In en, this message translates to:
  /// **'Add leg'**
  String get transportAddLeg;

  /// No description provided for @transportEditLeg.
  ///
  /// In en, this message translates to:
  /// **'Edit leg'**
  String get transportEditLeg;

  /// No description provided for @transportSelectMode.
  ///
  /// In en, this message translates to:
  /// **'Choose a transport mode'**
  String get transportSelectMode;

  /// No description provided for @transportChangeMode.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get transportChangeMode;

  /// No description provided for @transportDistanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance (km)'**
  String get transportDistanceLabel;

  /// No description provided for @transportDistanceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a distance of 0 km or more'**
  String get transportDistanceInvalid;

  /// No description provided for @transportDistanceEstimateNote.
  ///
  /// In en, this message translates to:
  /// **'Estimate derived from city locations. Edit it to match your route.'**
  String get transportDistanceEstimateNote;

  /// Placeholder in the leg editor's distance field when the chosen city pair has no estimate for this mode (water-blocked or out of range); clears on focus so the user can type
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get transportDistanceUnknown;

  /// Shown in the leg editor when the leg's cities imply a different flight band than the air mode picked
  ///
  /// In en, this message translates to:
  /// **'This distance uses the {band} factor, so a short hop is never priced as a long-haul flight.'**
  String transportFlightBandNote(String band);

  /// No description provided for @transportOccupantsLabel.
  ///
  /// In en, this message translates to:
  /// **'People in the vehicle'**
  String get transportOccupantsLabel;

  /// No description provided for @transportOccupantsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a person'**
  String get transportOccupantsAdd;

  /// No description provided for @transportOccupantsRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove a person'**
  String get transportOccupantsRemove;

  /// No description provided for @transportOccupantsSemantic.
  ///
  /// In en, this message translates to:
  /// **'People in the vehicle: {count}'**
  String transportOccupantsSemantic(int count);

  /// No description provided for @transportTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get transportTotalLabel;

  /// No description provided for @transportRemoveLeg.
  ///
  /// In en, this message translates to:
  /// **'Remove leg'**
  String get transportRemoveLeg;

  /// No description provided for @transportFromCity.
  ///
  /// In en, this message translates to:
  /// **'From city'**
  String get transportFromCity;

  /// No description provided for @transportToCity.
  ///
  /// In en, this message translates to:
  /// **'To city'**
  String get transportToCity;

  /// No description provided for @transportCityPrefillHint.
  ///
  /// In en, this message translates to:
  /// **'Pick two cities to estimate leg distances.'**
  String get transportCityPrefillHint;

  /// No description provided for @transportEstimatedKm.
  ///
  /// In en, this message translates to:
  /// **'~{km} km'**
  String transportEstimatedKm(String km);

  /// No description provided for @transportKmValue.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String transportKmValue(String km);

  /// No description provided for @transportOccupantsValue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 person} other{{count} people}}'**
  String transportOccupantsValue(int count);

  /// No description provided for @transportModeFactorPerPassenger.
  ///
  /// In en, this message translates to:
  /// **'{grams} g CO2e per km'**
  String transportModeFactorPerPassenger(int grams);

  /// No description provided for @transportModeFactorPerVehicle.
  ///
  /// In en, this message translates to:
  /// **'{grams} g CO2e per vehicle km'**
  String transportModeFactorPerVehicle(int grams);

  /// No description provided for @transportGroupActive.
  ///
  /// In en, this message translates to:
  /// **'Walking & cycling'**
  String get transportGroupActive;

  /// No description provided for @transportGroupMicro.
  ///
  /// In en, this message translates to:
  /// **'Micromobility'**
  String get transportGroupMicro;

  /// No description provided for @transportGroupCar.
  ///
  /// In en, this message translates to:
  /// **'Car & motorbike'**
  String get transportGroupCar;

  /// No description provided for @transportGroupBus.
  ///
  /// In en, this message translates to:
  /// **'Bus & coach'**
  String get transportGroupBus;

  /// No description provided for @transportGroupTaxi.
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get transportGroupTaxi;

  /// No description provided for @transportGroupRail.
  ///
  /// In en, this message translates to:
  /// **'Rail'**
  String get transportGroupRail;

  /// No description provided for @transportGroupWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get transportGroupWater;

  /// No description provided for @transportGroupAir.
  ///
  /// In en, this message translates to:
  /// **'Air'**
  String get transportGroupAir;

  /// No description provided for @transportGroupHighImpact.
  ///
  /// In en, this message translates to:
  /// **'High impact'**
  String get transportGroupHighImpact;

  /// No description provided for @transportModeScienceTooltip.
  ///
  /// In en, this message translates to:
  /// **'About this factor'**
  String get transportModeScienceTooltip;

  /// No description provided for @transportBasisEvGrid.
  ///
  /// In en, this message translates to:
  /// **'Global-average grid; varies with your electricity'**
  String get transportBasisEvGrid;

  /// No description provided for @transportBasisJetRf.
  ///
  /// In en, this message translates to:
  /// **'Includes the same high-altitude (radiative forcing) uplift as flights'**
  String get transportBasisJetRf;

  /// No description provided for @transportBasisZeroDirect.
  ///
  /// In en, this message translates to:
  /// **'0 direct emissions'**
  String get transportBasisZeroDirect;

  /// No description provided for @transportBasisElectricityOnly.
  ///
  /// In en, this message translates to:
  /// **'Electricity only'**
  String get transportBasisElectricityOnly;

  /// No description provided for @transportScienceNotesHeading.
  ///
  /// In en, this message translates to:
  /// **'How it\'s calculated'**
  String get transportScienceNotesHeading;

  /// No description provided for @transportScienceSourcesHeading.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get transportScienceSourcesHeading;

  /// No description provided for @transportScienceAccessed.
  ///
  /// In en, this message translates to:
  /// **'Accessed {date}'**
  String transportScienceAccessed(String date);

  /// No description provided for @transportComparisonTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare journeys'**
  String get transportComparisonTitle;

  /// No description provided for @transportAddToComparison.
  ///
  /// In en, this message translates to:
  /// **'Add as option'**
  String get transportAddToComparison;

  /// Heading above the staged comparison option chips in the transport and food calculator builders
  ///
  /// In en, this message translates to:
  /// **'Options to compare'**
  String get calculatorStagedOptions;

  /// Tooltip on the delete button of a staged comparison option chip
  ///
  /// In en, this message translates to:
  /// **'Remove this option'**
  String get calculatorRemoveOption;

  /// Live CO2e preview in the leg/ingredient editor, recomputed as distance, quantity or occupancy changes
  ///
  /// In en, this message translates to:
  /// **'This adds {amount} CO2e'**
  String calculatorEntryPreview(String amount);

  /// Title of the dialog explaining the CO2e unit, opened from the tappable CO2e amount
  ///
  /// In en, this message translates to:
  /// **'What is CO2e?'**
  String get co2eDefinitionTitle;

  /// Plain-language definition of CO2e shown in that dialog
  ///
  /// In en, this message translates to:
  /// **'CO2e counts methane and other greenhouse gases as their CO2 equivalent, so a burger and a flight compare fairly.'**
  String get co2eDefinitionBody;

  /// Header of the first comparison column
  ///
  /// In en, this message translates to:
  /// **'Option A'**
  String get calculatorOptionA;

  /// Header of the second comparison column
  ///
  /// In en, this message translates to:
  /// **'Option B'**
  String get calculatorOptionB;

  /// Empty-state hint inside a comparison column
  ///
  /// In en, this message translates to:
  /// **'Drag or tap an item below to add it here'**
  String get calculatorDropHint;

  /// Button adding the selected item to column A
  ///
  /// In en, this message translates to:
  /// **'Add to A'**
  String get calculatorAddToA;

  /// Button adding the selected item to column B
  ///
  /// In en, this message translates to:
  /// **'Add to B'**
  String get calculatorAddToB;

  /// Opens the full grouped picker from the item pool
  ///
  /// In en, this message translates to:
  /// **'Browse all'**
  String get calculatorBrowseAll;

  /// Placeholder shown in an empty journey column
  ///
  /// In en, this message translates to:
  /// **'Tap Add leg to start this journey'**
  String get transportColumnEmptyHint;

  /// Shown in place of the result when one column is empty
  ///
  /// In en, this message translates to:
  /// **'Build both options to compare them'**
  String get calculatorNeedBothOptions;

  /// Tooltip on the remove button of a card inside a comparison column
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get calculatorRemoveEntry;

  /// No description provided for @transportComparisonFull.
  ///
  /// In en, this message translates to:
  /// **'Comparison full ({max} options)'**
  String transportComparisonFull(int max);

  /// No description provided for @transportCompareOptions.
  ///
  /// In en, this message translates to:
  /// **'Compare {count} options'**
  String transportCompareOptions(int count);

  /// No description provided for @transportOptionStaged.
  ///
  /// In en, this message translates to:
  /// **'Added option {count}'**
  String transportOptionStaged(int count);

  /// No description provided for @transportComparisonDelta.
  ///
  /// In en, this message translates to:
  /// **'{label} emits {amount} CO2e less than {worse} ({percent}% lower)'**
  String transportComparisonDelta(
    String label,
    String amount,
    String worse,
    int percent,
  );

  /// No description provided for @transportComparisonTreesEquiv.
  ///
  /// In en, this message translates to:
  /// **'That\'s about {count} trees absorbing CO2 for a year'**
  String transportComparisonTreesEquiv(String count);

  /// No description provided for @transportMethodologyTitle.
  ///
  /// In en, this message translates to:
  /// **'Methodology & sources'**
  String get transportMethodologyTitle;

  /// No description provided for @transportMethodologyBody.
  ///
  /// In en, this message translates to:
  /// **'Every figure in this tool is an estimate for learning, traceable to the sources listed below.\n\n### What\'s counted\nOnly operational energy: fuel burned by engines and the electricity generated for electric modes. Vehicle manufacturing and infrastructure are excluded. Walking and cycling count as zero by convention -- the calories you burn are left out, as they may not add to a normal diet.\n\n### Occupancy\nCars and taxis are measured per vehicle, so their footprint is divided by the number of people aboard. Buses, trains and flights are already per passenger, at typical occupancy.\n\n### Flights and radiative forcing\nAircraft warm the climate beyond their CO2 through contrails and high-altitude effects. Following DESNZ 2025, flight and private-jet factors include a 1.7x central-estimate uplift on the CO2 component. Private jets carry the same uplift, so the comparison stays like for like.\n\n### Electric modes and the grid\nElectric cars, e-bikes and e-scooters emit nothing from the tailpipe; their footprint comes from generating the electricity. This tool uses a global-average grid of {grid} g CO2e per kWh, which varies widely by country and time of day, so your real figure may be higher or lower.\n\n### Averages, not your exact trip\nFactors are category averages, not your specific vehicle, route or driving style. Use them to compare options, not for precise carbon accounting.\n\n### Close calls\nSome modes sit very close -- coach and rail, for example, are within a few grams and their order can flip between yearly factor revisions. Treat small differences as a tie, not a clear winner.'**
  String transportMethodologyBody(int grid);

  /// No description provided for @transportLogChoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Take the greener option?'**
  String get transportLogChoiceTitle;

  /// No description provided for @transportLogChoiceBody.
  ///
  /// In en, this message translates to:
  /// **'Log this as a transport action and bank the {amount} CO2e you avoid by choosing the lower-carbon option.'**
  String transportLogChoiceBody(String amount);

  /// No description provided for @transportLogChoiceCta.
  ///
  /// In en, this message translates to:
  /// **'I chose {label}'**
  String transportLogChoiceCta(String label);

  /// No description provided for @transportChoiceLoggedMessage.
  ///
  /// In en, this message translates to:
  /// **'Logged. You banked {amount} CO2e.'**
  String transportChoiceLoggedMessage(String amount);

  /// No description provided for @transportCustomActionName.
  ///
  /// In en, this message translates to:
  /// **'Chose {greener} over {worse}'**
  String transportCustomActionName(String greener, String worse);

  /// No description provided for @transportChoseLabel.
  ///
  /// In en, this message translates to:
  /// **'I took'**
  String get transportChoseLabel;

  /// No description provided for @transportInsteadOfLabel.
  ///
  /// In en, this message translates to:
  /// **'instead of'**
  String get transportInsteadOfLabel;

  /// No description provided for @transportChoiceDistinctHint.
  ///
  /// In en, this message translates to:
  /// **'Pick two different options to log the choice you made.'**
  String get transportChoiceDistinctHint;

  /// No description provided for @transportActionsEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Log a Custom Transport action'**
  String get transportActionsEntryTitle;

  /// No description provided for @customActionBadge.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customActionBadge;

  /// No description provided for @actionReproduce.
  ///
  /// In en, this message translates to:
  /// **'Do this again'**
  String get actionReproduce;

  /// No description provided for @actionReproducedMessage.
  ///
  /// In en, this message translates to:
  /// **'Logged again'**
  String get actionReproducedMessage;

  /// No description provided for @foodCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Food Calculator'**
  String get foodCalculatorTitle;

  /// No description provided for @foodMethodologyTitle.
  ///
  /// In en, this message translates to:
  /// **'Methodology & sources'**
  String get foodMethodologyTitle;

  /// No description provided for @foodTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get foodTotalLabel;

  /// No description provided for @foodMealEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add an ingredient to build your meal and see its CO2e footprint.'**
  String get foodMealEmpty;

  /// Button under each meal column that opens the food picker for that column
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get foodAddIngredient;

  /// No description provided for @foodEditIngredient.
  ///
  /// In en, this message translates to:
  /// **'Edit ingredient'**
  String get foodEditIngredient;

  /// No description provided for @foodSelectItem.
  ///
  /// In en, this message translates to:
  /// **'Choose a food'**
  String get foodSelectItem;

  /// No description provided for @foodChangeItem.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get foodChangeItem;

  /// No description provided for @foodQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity (g)'**
  String get foodQuantityLabel;

  /// No description provided for @foodQuantityInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity of 0 g or more'**
  String get foodQuantityInvalid;

  /// No description provided for @foodGramsValue.
  ///
  /// In en, this message translates to:
  /// **'{grams} g'**
  String foodGramsValue(String grams);

  /// No description provided for @foodRemoveIngredient.
  ///
  /// In en, this message translates to:
  /// **'Remove ingredient'**
  String get foodRemoveIngredient;

  /// No description provided for @foodItemScienceTooltip.
  ///
  /// In en, this message translates to:
  /// **'About this factor'**
  String get foodItemScienceTooltip;

  /// Placeholder shown in an empty meal column
  ///
  /// In en, this message translates to:
  /// **'Tap Add ingredient to start this meal'**
  String get foodColumnEmptyHint;

  /// Hint text in the food picker search field
  ///
  /// In en, this message translates to:
  /// **'Search foods...'**
  String get foodSearchHint;

  /// Shown when a food picker search returns nothing
  ///
  /// In en, this message translates to:
  /// **'No foods match that search.'**
  String get foodSearchNoResults;

  /// No description provided for @foodItemFactorPerKg.
  ///
  /// In en, this message translates to:
  /// **'{value} kg CO2e per kg'**
  String foodItemFactorPerKg(String value);

  /// No description provided for @foodScienceNotesHeading.
  ///
  /// In en, this message translates to:
  /// **'How it\'s calculated'**
  String get foodScienceNotesHeading;

  /// No description provided for @foodScienceSourcesHeading.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get foodScienceSourcesHeading;

  /// No description provided for @foodScienceAccessed.
  ///
  /// In en, this message translates to:
  /// **'Accessed {date}'**
  String foodScienceAccessed(String date);

  /// No description provided for @foodGroupMeat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get foodGroupMeat;

  /// No description provided for @foodGroupSeafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get foodGroupSeafood;

  /// No description provided for @foodGroupDairyEggs.
  ///
  /// In en, this message translates to:
  /// **'Dairy & eggs'**
  String get foodGroupDairyEggs;

  /// No description provided for @foodGroupPlantProtein.
  ///
  /// In en, this message translates to:
  /// **'Plant protein'**
  String get foodGroupPlantProtein;

  /// No description provided for @foodGroupStaples.
  ///
  /// In en, this message translates to:
  /// **'Staples'**
  String get foodGroupStaples;

  /// No description provided for @foodGroupVegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get foodGroupVegetables;

  /// No description provided for @foodGroupFruit.
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get foodGroupFruit;

  /// No description provided for @foodGroupDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get foodGroupDrinks;

  /// No description provided for @foodGroupTreats.
  ///
  /// In en, this message translates to:
  /// **'Treats'**
  String get foodGroupTreats;

  /// No description provided for @foodGroupOils.
  ///
  /// In en, this message translates to:
  /// **'Oils'**
  String get foodGroupOils;

  /// No description provided for @foodAddToComparison.
  ///
  /// In en, this message translates to:
  /// **'Add as option'**
  String get foodAddToComparison;

  /// No description provided for @foodComparisonFull.
  ///
  /// In en, this message translates to:
  /// **'Comparison full ({max} options)'**
  String foodComparisonFull(int max);

  /// No description provided for @foodCompareOptions.
  ///
  /// In en, this message translates to:
  /// **'Compare {count} options'**
  String foodCompareOptions(int count);

  /// No description provided for @foodOptionStaged.
  ///
  /// In en, this message translates to:
  /// **'Added option {count}'**
  String foodOptionStaged(int count);

  /// No description provided for @foodComparisonTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare meals'**
  String get foodComparisonTitle;

  /// No description provided for @foodComparisonDelta.
  ///
  /// In en, this message translates to:
  /// **'{label} emits {amount} CO2e less than {worse} ({percent}% lower)'**
  String foodComparisonDelta(
    String label,
    String amount,
    String worse,
    int percent,
  );

  /// No description provided for @foodComparisonCarKmEquiv.
  ///
  /// In en, this message translates to:
  /// **'That\'s about {km} km not driven in a petrol car'**
  String foodComparisonCarKmEquiv(int km);

  /// No description provided for @foodChoseLabel.
  ///
  /// In en, this message translates to:
  /// **'I ate'**
  String get foodChoseLabel;

  /// No description provided for @foodInsteadOfLabel.
  ///
  /// In en, this message translates to:
  /// **'instead of'**
  String get foodInsteadOfLabel;

  /// No description provided for @foodLogChoiceBody.
  ///
  /// In en, this message translates to:
  /// **'Log this as a food action and bank the {amount} CO2e you avoid by choosing the lower-carbon meal.'**
  String foodLogChoiceBody(String amount);

  /// No description provided for @foodChoiceDistinctHint.
  ///
  /// In en, this message translates to:
  /// **'Pick two different meals to log the choice you made.'**
  String get foodChoiceDistinctHint;

  /// No description provided for @foodLogChoiceCta.
  ///
  /// In en, this message translates to:
  /// **'I chose {label}'**
  String foodLogChoiceCta(String label);

  /// No description provided for @foodChoiceLoggedMessage.
  ///
  /// In en, this message translates to:
  /// **'Logged. You banked {amount} CO2e.'**
  String foodChoiceLoggedMessage(String amount);

  /// No description provided for @foodCustomActionName.
  ///
  /// In en, this message translates to:
  /// **'Chose {greener} over {worse}'**
  String foodCustomActionName(String greener, String worse);

  /// No description provided for @foodActionsEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Log a Custom Food action'**
  String get foodActionsEntryTitle;

  /// No description provided for @foodMethodologyBody.
  ///
  /// In en, this message translates to:
  /// **'Every figure in this tool is an estimate for learning, traceable to the sources listed below.\n\n### What\'s counted\nEach factor covers a food\'s full cradle-to-retail lifecycle -- land-use change, farming, animal feed, processing, transport and packaging -- from Poore & Nemecek\'s 2018 meta-analysis of ~38,000 farms, as published by Our World in Data. Home cooking energy and household food waste are excluded. This is a wider boundary than the transport calculator\'s operational-only scope, so never add figures from the two tools together. Figures are the study\'s production-weighted means including supply-chain losses, not its medians, because means better represent total global impact.\n\n### One number, huge spread\nThese are global category averages. The same food can vary 10-50x between producers: beef ranges from about 9 to 105 kg CO2e per 100 g of protein, and tomatoes from 0.45 kg CO2e/kg grown outdoors in season to 2.20 in a heated greenhouse. Use the figures to compare foods, not to judge a specific farm.\n\n### \'Organic\' and \'local\'\nThere is no organic or local discount here, and that is deliberate. Transport is usually under 10% of a food\'s footprint, so local beef still has a far bigger footprint than imported beans, and organic is often similar or higher per kg. What you eat matters far more than how far it travelled or how it was farmed.'**
  String get foodMethodologyBody;
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
    'that was used.',
  );
}
