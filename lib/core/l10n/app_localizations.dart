import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_yo.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('yo'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'NovaPay'**
  String get appName;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String stepOf(int step, int total);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSave.
  ///
  /// In en, this message translates to:
  /// **'NovaSave'**
  String get navSave;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusSending.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get statusSending;

  /// No description provided for @statusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get statusSent;

  /// No description provided for @statusReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get statusReceived;

  /// No description provided for @statusSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get statusSaved;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Transfers will be queued and sent automatically.'**
  String get offlineBanner;

  /// No description provided for @offlineBannerSave.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Contributions will be queued and sent automatically.'**
  String get offlineBannerSave;

  /// No description provided for @syncChipPending.
  ///
  /// In en, this message translates to:
  /// **'{count} pending: will send when back online'**
  String syncChipPending(int count);

  /// No description provided for @syncChipSending.
  ///
  /// In en, this message translates to:
  /// **'Sending {count} queued…'**
  String syncChipSending(int count);

  /// No description provided for @syncTrouble.
  ///
  /// In en, this message translates to:
  /// **'Having trouble sending. We\'ll keep trying.'**
  String get syncTrouble;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon,'**
  String get homeGreeting;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to NovaPay,'**
  String get homeWelcome;

  /// No description provided for @homeAvailableBalance.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE BALANCE'**
  String get homeAvailableBalance;

  /// No description provided for @homeOnHold.
  ///
  /// In en, this message translates to:
  /// **'{amount} on hold'**
  String homeOnHold(String amount);

  /// No description provided for @homeOnHoldPending.
  ///
  /// In en, this message translates to:
  /// **'{amount} on hold for {count} pending'**
  String homeOnHoldPending(String amount, int count);

  /// No description provided for @homeUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Everything is up to date.'**
  String get homeUpToDate;

  /// No description provided for @homeLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {time}. Held funds return to your balance if a queued transfer fails.'**
  String homeLastUpdated(String time);

  /// No description provided for @homeShowBalance.
  ///
  /// In en, this message translates to:
  /// **'Show balance'**
  String get homeShowBalance;

  /// No description provided for @homeHideBalance.
  ///
  /// In en, this message translates to:
  /// **'Hide balance'**
  String get homeHideBalance;

  /// No description provided for @homeBalanceHidden.
  ///
  /// In en, this message translates to:
  /// **'Balance hidden'**
  String get homeBalanceHidden;

  /// No description provided for @homeSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get homeSend;

  /// No description provided for @homeSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get homeSave;

  /// No description provided for @homeAddMoney.
  ///
  /// In en, this message translates to:
  /// **'Add money'**
  String get homeAddMoney;

  /// No description provided for @homeQueuesOffline.
  ///
  /// In en, this message translates to:
  /// **'Queues offline'**
  String get homeQueuesOffline;

  /// No description provided for @homeNeedsData.
  ///
  /// In en, this message translates to:
  /// **'Needs data'**
  String get homeNeedsData;

  /// No description provided for @homeRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get homeRecent;

  /// No description provided for @homeSavedCopy.
  ///
  /// In en, this message translates to:
  /// **'Showing saved copy'**
  String get homeSavedCopy;

  /// No description provided for @homeLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading your wallet… this can take a moment on a slow connection.'**
  String get homeLoading;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add money to your wallet or send your first transfer — everything you do will show up here.'**
  String get homeEmptyBody;

  /// No description provided for @homeAddMoneySoon.
  ///
  /// In en, this message translates to:
  /// **'Adding money is coming soon. Your demo wallet already has funds.'**
  String get homeAddMoneySoon;

  /// No description provided for @transferIn.
  ///
  /// In en, this message translates to:
  /// **'Transfer in'**
  String get transferIn;

  /// No description provided for @queuedAt.
  ///
  /// In en, this message translates to:
  /// **'Queued {time}'**
  String queuedAt(String time);

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

  /// No description provided for @sendTitle.
  ///
  /// In en, this message translates to:
  /// **'Send money'**
  String get sendTitle;

  /// No description provided for @sendSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name, bank or account'**
  String get sendSearchHint;

  /// No description provided for @sendSearchSavedHint.
  ///
  /// In en, this message translates to:
  /// **'Search saved recipients'**
  String get sendSearchSavedHint;

  /// No description provided for @sendNewRecipient.
  ///
  /// In en, this message translates to:
  /// **'New recipient'**
  String get sendNewRecipient;

  /// No description provided for @sendNewRecipientSub.
  ///
  /// In en, this message translates to:
  /// **'Send to a new account number'**
  String get sendNewRecipientSub;

  /// No description provided for @sendNewRecipientOffline.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet to add a new recipient. You can still send to saved recipients.'**
  String get sendNewRecipientOffline;

  /// No description provided for @sendSavedRecipients.
  ///
  /// In en, this message translates to:
  /// **'SAVED RECIPIENTS'**
  String get sendSavedRecipients;

  /// No description provided for @sendSavedRecipientsOffline.
  ///
  /// In en, this message translates to:
  /// **'SAVED RECIPIENTS · AVAILABLE OFFLINE'**
  String get sendSavedRecipientsOffline;

  /// No description provided for @sendNoRecipients.
  ///
  /// In en, this message translates to:
  /// **'No saved recipients yet.'**
  String get sendNoRecipients;

  /// No description provided for @newRecipientTitle.
  ///
  /// In en, this message translates to:
  /// **'New recipient'**
  String get newRecipientTitle;

  /// No description provided for @bankLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bankLabel;

  /// No description provided for @chooseBank.
  ///
  /// In en, this message translates to:
  /// **'Choose a bank'**
  String get chooseBank;

  /// No description provided for @accountNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get accountNumberLabel;

  /// No description provided for @accountNumberHelp.
  ///
  /// In en, this message translates to:
  /// **'Digits stay visible while you type, then we mask them.'**
  String get accountNumberHelp;

  /// No description provided for @accountVerified.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT VERIFIED'**
  String get accountVerified;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountName;

  /// No description provided for @accountCheckName.
  ///
  /// In en, this message translates to:
  /// **'Check the name matches the person you intend to pay.'**
  String get accountCheckName;

  /// No description provided for @verifyingAccount.
  ///
  /// In en, this message translates to:
  /// **'Checking account…'**
  String get verifyingAccount;

  /// No description provided for @saveBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Save as beneficiary'**
  String get saveBeneficiary;

  /// No description provided for @saveBeneficiarySub.
  ///
  /// In en, this message translates to:
  /// **'Keeps them on your saved list, even offline'**
  String get saveBeneficiarySub;

  /// No description provided for @amountTitle.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountTitle;

  /// No description provided for @amountQuestion.
  ///
  /// In en, this message translates to:
  /// **'How much are you sending?'**
  String get amountQuestion;

  /// No description provided for @youAreSending.
  ///
  /// In en, this message translates to:
  /// **'You are sending'**
  String get youAreSending;

  /// No description provided for @availableAmount.
  ///
  /// In en, this message translates to:
  /// **'Available: {amount}'**
  String availableAmount(String amount);

  /// No description provided for @narrationLabel.
  ///
  /// In en, this message translates to:
  /// **'Narration (optional)'**
  String get narrationLabel;

  /// No description provided for @narrationHint.
  ///
  /// In en, this message translates to:
  /// **'What is this for?'**
  String get narrationHint;

  /// No description provided for @feeLabel.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get feeLabel;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review transfer'**
  String get reviewTitle;

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toLabel;

  /// No description provided for @accountLabel.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @totalDebit.
  ///
  /// In en, this message translates to:
  /// **'Total debit'**
  String get totalDebit;

  /// No description provided for @balanceAfter.
  ///
  /// In en, this message translates to:
  /// **'Balance after'**
  String get balanceAfter;

  /// No description provided for @heldUntilSent.
  ///
  /// In en, this message translates to:
  /// **'Held until sent'**
  String get heldUntilSent;

  /// No description provided for @reviewNoCharges.
  ///
  /// In en, this message translates to:
  /// **'No other charges. Transfers usually land in seconds; it can take up to 24 hours if the receiving bank is slow.'**
  String get reviewNoCharges;

  /// No description provided for @reviewOfflineNotice.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. This transfer will be queued and sent automatically when you\'re back online.'**
  String get reviewOfflineNotice;

  /// No description provided for @reviewOfflineFooter.
  ///
  /// In en, this message translates to:
  /// **'Nothing is sent until your phone reconnects.'**
  String get reviewOfflineFooter;

  /// No description provided for @editDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get editDetails;

  /// No description provided for @sendCta.
  ///
  /// In en, this message translates to:
  /// **'Send {amount}'**
  String sendCta(String amount);

  /// No description provided for @queueTransfer.
  ///
  /// In en, this message translates to:
  /// **'Queue transfer'**
  String get queueTransfer;

  /// No description provided for @pinTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your 4-digit PIN'**
  String get pinTitle;

  /// No description provided for @pinSending.
  ///
  /// In en, this message translates to:
  /// **'Sending {amount} to {name}'**
  String pinSending(String amount, String name);

  /// No description provided for @pinWrong.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN. Try again.'**
  String get pinWrong;

  /// No description provided for @forgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get forgotPin;

  /// No description provided for @pinDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get pinDelete;

  /// No description provided for @pinEnteredCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of 4 digits entered'**
  String pinEnteredCount(int count);

  /// No description provided for @biometricTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm {amount} transfer'**
  String biometricTitle(String amount);

  /// No description provided for @biometricBody.
  ///
  /// In en, this message translates to:
  /// **'Transfers of ₦50,000.00 and above need your fingerprint or face. Touch the sensor to authorise.'**
  String get biometricBody;

  /// No description provided for @biometricWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your fingerprint…'**
  String get biometricWaiting;

  /// No description provided for @usePinInstead.
  ///
  /// In en, this message translates to:
  /// **'Use PIN instead'**
  String get usePinInstead;

  /// No description provided for @cancelTransfer.
  ///
  /// In en, this message translates to:
  /// **'Cancel transfer'**
  String get cancelTransfer;

  /// No description provided for @biometricFallback.
  ///
  /// In en, this message translates to:
  /// **'Biometrics aren\'t available on this device. Use your PIN.'**
  String get biometricFallback;

  /// No description provided for @resultSentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent to {name}'**
  String resultSentTo(String name);

  /// No description provided for @resultPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending — will send when back online'**
  String get resultPendingTitle;

  /// No description provided for @resultPendingBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ve saved this transfer on your phone. It will go through automatically once you\'re connected, and we\'ll notify you.'**
  String get resultPendingBody;

  /// No description provided for @resultProcessingTitle.
  ///
  /// In en, this message translates to:
  /// **'Processing…'**
  String get resultProcessingTitle;

  /// No description provided for @resultProcessingBody.
  ///
  /// In en, this message translates to:
  /// **'The bank is taking longer than usual to confirm. Your money is held until they respond. You can close this screen — the transfer keeps going.'**
  String get resultProcessingBody;

  /// No description provided for @resultFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer failed'**
  String get resultFailedTitle;

  /// No description provided for @resultNotDebited.
  ///
  /// In en, this message translates to:
  /// **'Your money was not debited.'**
  String get resultNotDebited;

  /// No description provided for @heldFromBalance.
  ///
  /// In en, this message translates to:
  /// **'Held from balance'**
  String get heldFromBalance;

  /// No description provided for @referenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get referenceLabel;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @detailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction details'**
  String get detailsTitle;

  /// No description provided for @progressLabel.
  ///
  /// In en, this message translates to:
  /// **'PROGRESS'**
  String get progressLabel;

  /// No description provided for @detailsLabel.
  ///
  /// In en, this message translates to:
  /// **'DETAILS'**
  String get detailsLabel;

  /// No description provided for @timelineQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get timelineQueued;

  /// No description provided for @timelineQueuedSub.
  ///
  /// In en, this message translates to:
  /// **'Saved on your phone'**
  String get timelineQueuedSub;

  /// No description provided for @timelineSending.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get timelineSending;

  /// No description provided for @timelineSendingSub.
  ///
  /// In en, this message translates to:
  /// **'Sent to the bank'**
  String get timelineSendingSub;

  /// No description provided for @timelineCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get timelineCompleted;

  /// No description provided for @timelineCompletedSub.
  ///
  /// In en, this message translates to:
  /// **'The bank confirmed the credit'**
  String get timelineCompletedSub;

  /// No description provided for @timelineFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get timelineFailed;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @idempotencyKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Idempotency key'**
  String get idempotencyKeyLabel;

  /// No description provided for @attemptsLabel.
  ///
  /// In en, this message translates to:
  /// **'Attempts'**
  String get attemptsLabel;

  /// No description provided for @saveTitle.
  ///
  /// In en, this message translates to:
  /// **'NovaSave'**
  String get saveTitle;

  /// No description provided for @saveGoalsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 goal} other{{count} goals}}'**
  String saveGoalsCount(int count);

  /// No description provided for @saveTotalSaved.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SAVED'**
  String get saveTotalSaved;

  /// No description provided for @savePendingAcross.
  ///
  /// In en, this message translates to:
  /// **'{amount} pending across {count, plural, =1{1 goal} other{{count} goals}}'**
  String savePendingAcross(String amount, int count);

  /// No description provided for @saveOfTarget.
  ///
  /// In en, this message translates to:
  /// **'{saved} of {target}'**
  String saveOfTarget(String saved, String target);

  /// No description provided for @saveTargetDate.
  ///
  /// In en, this message translates to:
  /// **'Target {date}'**
  String saveTargetDate(String date);

  /// No description provided for @savePendingPill.
  ///
  /// In en, this message translates to:
  /// **'{amount} pending'**
  String savePendingPill(String amount);

  /// No description provided for @saveGoalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal reached'**
  String get saveGoalReached;

  /// No description provided for @saveGoalSyncing.
  ///
  /// In en, this message translates to:
  /// **'Creating…'**
  String get saveGoalSyncing;

  /// No description provided for @saveGoalFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create'**
  String get saveGoalFailed;

  /// No description provided for @saveCreateGoal.
  ///
  /// In en, this message translates to:
  /// **'Create a goal'**
  String get saveCreateGoal;

  /// No description provided for @saveEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No savings goals yet'**
  String get saveEmptyTitle;

  /// No description provided for @saveEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Name what you\'re saving for, set a target, and add money whenever you have it.'**
  String get saveEmptyBody;

  /// No description provided for @savePopular.
  ///
  /// In en, this message translates to:
  /// **'POPULAR STARTING POINTS'**
  String get savePopular;

  /// No description provided for @saveIdeaRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get saveIdeaRent;

  /// No description provided for @saveIdeaSchool.
  ///
  /// In en, this message translates to:
  /// **'School fees'**
  String get saveIdeaSchool;

  /// No description provided for @saveIdeaEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency fund'**
  String get saveIdeaEmergency;

  /// No description provided for @createGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a goal'**
  String get createGoalTitle;

  /// No description provided for @goalNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal name'**
  String get goalNameLabel;

  /// No description provided for @targetAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get targetAmountLabel;

  /// No description provided for @targetDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Target date'**
  String get targetDateLabel;

  /// No description provided for @months3.
  ///
  /// In en, this message translates to:
  /// **'3 months'**
  String get months3;

  /// No description provided for @months6.
  ///
  /// In en, this message translates to:
  /// **'6 months'**
  String get months6;

  /// No description provided for @year1.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get year1;

  /// No description provided for @weeklyHint.
  ///
  /// In en, this message translates to:
  /// **'Save about {amount} a week to reach this by {date}'**
  String weeklyHint(String amount, String date);

  /// No description provided for @weeklyHintSub.
  ///
  /// In en, this message translates to:
  /// **'A guide, not a commitment — contribute any amount, any time.'**
  String get weeklyHintSub;

  /// No description provided for @createGoalCta.
  ///
  /// In en, this message translates to:
  /// **'Create goal'**
  String get createGoalCta;

  /// No description provided for @goalSaved.
  ///
  /// In en, this message translates to:
  /// **'{amount} saved'**
  String goalSaved(String amount);

  /// No description provided for @goalPending.
  ///
  /// In en, this message translates to:
  /// **'{amount} pending'**
  String goalPending(String amount);

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'Days left'**
  String get daysLeft;

  /// No description provided for @contributionsLabel.
  ///
  /// In en, this message translates to:
  /// **'CONTRIBUTIONS'**
  String get contributionsLabel;

  /// No description provided for @contribute.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get contribute;

  /// No description provided for @contributeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to {goal}'**
  String contributeTitle(String goal);

  /// No description provided for @contributeSub.
  ///
  /// In en, this message translates to:
  /// **'Money moves from your wallet into this goal.'**
  String get contributeSub;

  /// No description provided for @contributeFrom.
  ///
  /// In en, this message translates to:
  /// **'From NovaWallet'**
  String get contributeFrom;

  /// No description provided for @contributeOfflineNotice.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. This contribution will be queued and added to your goal automatically when you\'re back online.'**
  String get contributeOfflineNotice;

  /// No description provided for @contributeNoFee.
  ///
  /// In en, this message translates to:
  /// **'You\'ll enter your PIN next. No fee on NovaSave contributions.'**
  String get contributeNoFee;

  /// No description provided for @queueContribution.
  ///
  /// In en, this message translates to:
  /// **'Queue contribution'**
  String get queueContribution;

  /// No description provided for @contributeHeld.
  ///
  /// In en, this message translates to:
  /// **'Held from your balance until it sends. Nothing is lost if it fails.'**
  String get contributeHeld;

  /// No description provided for @contributeSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to your goal'**
  String get contributeSaved;

  /// No description provided for @contributePending.
  ///
  /// In en, this message translates to:
  /// **'Queued — will save when back online'**
  String get contributePending;

  /// No description provided for @contributeFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save to your goal'**
  String get contributeFailed;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileTier.
  ///
  /// In en, this message translates to:
  /// **'Tier {tier}'**
  String profileTier(int tier);

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'Changes apply immediately. Amounts stay in Naira.'**
  String get profileLanguageHint;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageYoruba.
  ///
  /// In en, this message translates to:
  /// **'Yorùbá'**
  String get languageYoruba;

  /// No description provided for @languageHausa.
  ///
  /// In en, this message translates to:
  /// **'Hausa'**
  String get languageHausa;

  /// No description provided for @languageIgbo.
  ///
  /// In en, this message translates to:
  /// **'Igbo'**
  String get languageIgbo;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @profileBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Biometrics'**
  String get profileBiometrics;

  /// No description provided for @profileBiometricsSub.
  ///
  /// In en, this message translates to:
  /// **'Unlock and approve transfers with your fingerprint'**
  String get profileBiometricsSub;

  /// No description provided for @profileSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileSecurity;

  /// No description provided for @profileSecuritySub.
  ///
  /// In en, this message translates to:
  /// **'Change PIN, password and devices'**
  String get profileSecuritySub;

  /// No description provided for @profileHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get profileHelp;

  /// No description provided for @profileHelpSub.
  ///
  /// In en, this message translates to:
  /// **'Chat with us, or call 0700 NOVAPAY'**
  String get profileHelpSub;

  /// No description provided for @profileDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer panel'**
  String get profileDeveloper;

  /// No description provided for @profileDeveloperSub.
  ///
  /// In en, this message translates to:
  /// **'Demo build only'**
  String get profileDeveloperSub;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @versionFooter.
  ///
  /// In en, this message translates to:
  /// **'NovaPay 1.0.0 · demo build'**
  String get versionFooter;

  /// No description provided for @devTitle.
  ///
  /// In en, this message translates to:
  /// **'Developer panel'**
  String get devTitle;

  /// No description provided for @devSimulateOffline.
  ///
  /// In en, this message translates to:
  /// **'Simulate offline'**
  String get devSimulateOffline;

  /// No description provided for @devLoseResponse.
  ///
  /// In en, this message translates to:
  /// **'Lose next server response'**
  String get devLoseResponse;

  /// No description provided for @devLatency.
  ///
  /// In en, this message translates to:
  /// **'Latency'**
  String get devLatency;

  /// No description provided for @devOutbox.
  ///
  /// In en, this message translates to:
  /// **'OUTBOX'**
  String get devOutbox;

  /// No description provided for @devOutboxItems.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String devOutboxItems(int count);

  /// No description provided for @devOutboxEmpty.
  ///
  /// In en, this message translates to:
  /// **'The outbox is empty.'**
  String get devOutboxEmpty;

  /// No description provided for @devIdempotencyNote.
  ///
  /// In en, this message translates to:
  /// **'Idempotency keys are generated per transfer, so a retry after a lost response can never double-debit.'**
  String get devIdempotencyNote;

  /// No description provided for @devReset.
  ///
  /// In en, this message translates to:
  /// **'Reset demo data'**
  String get devReset;

  /// No description provided for @devResetConfirm.
  ///
  /// In en, this message translates to:
  /// **'This wipes your demo data and signs you out.'**
  String get devResetConfirm;

  /// No description provided for @onboardSendTitle.
  ///
  /// In en, this message translates to:
  /// **'Send money in seconds'**
  String get onboardSendTitle;

  /// No description provided for @onboardSendBody.
  ///
  /// In en, this message translates to:
  /// **'Transfer to any Nigerian bank instantly.'**
  String get onboardSendBody;

  /// No description provided for @onboardSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save towards what matters'**
  String get onboardSaveTitle;

  /// No description provided for @onboardSaveBody.
  ///
  /// In en, this message translates to:
  /// **'Set goals and watch your progress grow.'**
  String get onboardSaveBody;

  /// No description provided for @onboardOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Works even when network is bad'**
  String get onboardOfflineTitle;

  /// No description provided for @onboardOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'No network? We\'ll queue your transfer and send it the moment you\'re back online.'**
  String get onboardOfflineBody;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get haveAccount;

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your phone number?'**
  String get phoneTitle;

  /// No description provided for @phoneBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send you a code to confirm it\'s you. Standard SMS rates may apply.'**
  String get phoneBody;

  /// No description provided for @phoneHelp.
  ///
  /// In en, this message translates to:
  /// **'Nigeria (+234) · 10 digits, without the leading 0'**
  String get phoneHelp;

  /// No description provided for @phonePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Use the number registered to your SIM. We never share it and we don\'t read your contacts.'**
  String get phonePrivacy;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send me a code'**
  String get sendCode;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your 6-digit code'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent by SMS to {phone}.'**
  String otpSentTo(String phone);

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get changeNumber;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {time}'**
  String resendIn(String time);

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @otpDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo build only — real SMS codes are never shown in the app.'**
  String get otpDemo;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @detailsTitleSignup.
  ///
  /// In en, this message translates to:
  /// **'Your details'**
  String get detailsTitleSignup;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @fullNameHelp.
  ///
  /// In en, this message translates to:
  /// **'As it appears on your bank records.'**
  String get fullNameHelp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @pwRuleLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get pwRuleLength;

  /// No description provided for @pwRuleMix.
  ///
  /// In en, this message translates to:
  /// **'One capital letter and one number'**
  String get pwRuleMix;

  /// No description provided for @pwRuleSymbol.
  ///
  /// In en, this message translates to:
  /// **'One symbol, e.g. ! or #'**
  String get pwRuleSymbol;

  /// No description provided for @consent.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms and Privacy Policy (NDPA 2023)'**
  String get consent;

  /// No description provided for @bvnTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your BVN'**
  String get bvnTitle;

  /// No description provided for @bvnHelp.
  ///
  /// In en, this message translates to:
  /// **'Dial *565*0# on your registered line to see your BVN.'**
  String get bvnHelp;

  /// No description provided for @bvnWhy.
  ///
  /// In en, this message translates to:
  /// **'WHY WE ASK'**
  String get bvnWhy;

  /// No description provided for @bvnWhyBody.
  ///
  /// In en, this message translates to:
  /// **'Nigerian regulation ties higher transfer limits to a verified identity. We only read your name and date of birth — never your bank balances.'**
  String get bvnWhyBody;

  /// No description provided for @tier1.
  ///
  /// In en, this message translates to:
  /// **'Tier 1 · now'**
  String get tier1;

  /// No description provided for @tier1Limit.
  ///
  /// In en, this message translates to:
  /// **'₦100,000 per transfer, no BVN needed'**
  String get tier1Limit;

  /// No description provided for @tier2.
  ///
  /// In en, this message translates to:
  /// **'Tier 2 · with BVN'**
  String get tier2;

  /// No description provided for @tier2Limit.
  ///
  /// In en, this message translates to:
  /// **'₦1,000,000 per transfer'**
  String get tier2Limit;

  /// No description provided for @bvnLater.
  ///
  /// In en, this message translates to:
  /// **'You can add your BVN later from Profile — nothing here blocks you from sending today.'**
  String get bvnLater;

  /// No description provided for @verifyBvn.
  ///
  /// In en, this message translates to:
  /// **'Verify BVN'**
  String get verifyBvn;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @createPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your transaction PIN'**
  String get createPinTitle;

  /// No description provided for @createPinBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll enter these 4 digits to send money — transfers of ₦50,000.00 and above use your face or fingerprint instead. Never share it.'**
  String get createPinBody;

  /// No description provided for @confirmPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your PIN'**
  String get confirmPinTitle;

  /// No description provided for @confirmPinBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the same 4 digits again so we know it saved correctly.'**
  String get confirmPinBody;

  /// No description provided for @pinsMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs match'**
  String get pinsMatch;

  /// No description provided for @pinsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Those PINs don\'t match. Start again.'**
  String get pinsDontMatch;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcome;

  /// No description provided for @loginBody.
  ///
  /// In en, this message translates to:
  /// **'Log in to send, save and check your balance.'**
  String get loginBody;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @newHere.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get newHere;

  /// No description provided for @unlockGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String unlockGreeting(String name);

  /// No description provided for @unlockBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to unlock NovaPay'**
  String get unlockBody;

  /// No description provided for @unlockBiometric.
  ///
  /// In en, this message translates to:
  /// **'Unlock with fingerprint'**
  String get unlockBiometric;

  /// No description provided for @notYou.
  ///
  /// In en, this message translates to:
  /// **'Not you? Sign out'**
  String get notYou;

  /// No description provided for @unlockLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in a moment.'**
  String get unlockLocked;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Connect to the internet and try again.'**
  String get errorOffline;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'That email and password don\'t match. Try again.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorInvalidOtp.
  ///
  /// In en, this message translates to:
  /// **'That code isn\'t right. Check the SMS and try again.'**
  String get errorInvalidOtp;

  /// No description provided for @errorAccountExists.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with these details. Log in instead.'**
  String get errorAccountExists;

  /// No description provided for @errorInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Nigerian phone number.'**
  String get errorInvalidPhone;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get errorInvalidEmail;

  /// No description provided for @errorInvalidBvn.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t verify that BVN. Check the 11 digits.'**
  String get errorInvalidBvn;

  /// No description provided for @errorInvalidInput.
  ///
  /// In en, this message translates to:
  /// **'Check the details and try again.'**
  String get errorInvalidInput;

  /// No description provided for @errorInsufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'That\'s more than your available balance.'**
  String get errorInsufficientFunds;

  /// No description provided for @errorTierLimit.
  ///
  /// In en, this message translates to:
  /// **'That\'s above your per-transfer limit. Verify your BVN to raise it.'**
  String get errorTierLimit;

  /// No description provided for @errorInvalidAccount.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that account. Check the number and bank.'**
  String get errorInvalidAccount;

  /// No description provided for @errorAmountTooSmall.
  ///
  /// In en, this message translates to:
  /// **'That amount is too small.'**
  String get errorAmountTooSmall;

  /// No description provided for @errorAmountTooLarge.
  ///
  /// In en, this message translates to:
  /// **'That amount is too large.'**
  String get errorAmountTooLarge;

  /// No description provided for @errorGoalNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find that goal.'**
  String get errorGoalNotFound;

  /// No description provided for @errorSessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Log in again.'**
  String get errorSessionEnded;

  /// No description provided for @unlockTryIn.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {seconds}s.'**
  String unlockTryIn(int seconds);

  /// No description provided for @forgotPasswordSoon.
  ///
  /// In en, this message translates to:
  /// **'Password reset isn\'t part of this demo build.'**
  String get forgotPasswordSoon;

  /// No description provided for @bvnLabel.
  ///
  /// In en, this message translates to:
  /// **'BVN'**
  String get bvnLabel;

  /// No description provided for @bvnHint.
  ///
  /// In en, this message translates to:
  /// **'11 digits'**
  String get bvnHint;

  /// No description provided for @demoLabel.
  ///
  /// In en, this message translates to:
  /// **'DEMO'**
  String get demoLabel;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Send & save, even offline'**
  String get splashTagline;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening,'**
  String get homeGreetingEvening;

  /// No description provided for @homeLoadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more…'**
  String get homeLoadingMore;

  /// No description provided for @goalProgressA11y.
  ///
  /// In en, this message translates to:
  /// **'{percent} saved'**
  String goalProgressA11y(String percent);

  /// No description provided for @goalNoContributions.
  ///
  /// In en, this message translates to:
  /// **'No contributions yet.'**
  String get goalNoContributions;

  /// No description provided for @goalNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. New laptop'**
  String get goalNameHint;

  /// No description provided for @createGoalDateHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get createGoalDateHint;

  /// No description provided for @contributeAmountQuestion.
  ///
  /// In en, this message translates to:
  /// **'How much are you adding?'**
  String get contributeAmountQuestion;

  /// No description provided for @profileAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account {number}'**
  String profileAccountNumber(String number);

  /// No description provided for @devLatencyMs.
  ///
  /// In en, this message translates to:
  /// **'{ms} ms'**
  String devLatencyMs(int ms);

  /// No description provided for @devSimulateOfflineSub.
  ///
  /// In en, this message translates to:
  /// **'Treat the backend as unreachable'**
  String get devSimulateOfflineSub;

  /// No description provided for @devLoseResponseSub.
  ///
  /// In en, this message translates to:
  /// **'The server applies the next request, but the reply never arrives'**
  String get devLoseResponseSub;

  /// No description provided for @devSimulateCredit.
  ///
  /// In en, this message translates to:
  /// **'Simulate incoming payment'**
  String get devSimulateCredit;

  /// No description provided for @devSimulateCreditSub.
  ///
  /// In en, this message translates to:
  /// **'Credits ₦25,000.00 from Kunle Bankole and sends a notification'**
  String get devSimulateCreditSub;

  /// No description provided for @moveToWallet.
  ///
  /// In en, this message translates to:
  /// **'Move to wallet'**
  String get moveToWallet;

  /// No description provided for @moveTitle.
  ///
  /// In en, this message translates to:
  /// **'Move from {goal}'**
  String moveTitle(String goal);

  /// No description provided for @moveSub.
  ///
  /// In en, this message translates to:
  /// **'Money moves from this goal back to your wallet.'**
  String get moveSub;

  /// No description provided for @moveInGoal.
  ///
  /// In en, this message translates to:
  /// **'In this goal: {amount}'**
  String moveInGoal(String amount);

  /// No description provided for @moveAll.
  ///
  /// In en, this message translates to:
  /// **'Move all'**
  String get moveAll;

  /// No description provided for @moveQuestion.
  ///
  /// In en, this message translates to:
  /// **'How much are you moving?'**
  String get moveQuestion;

  /// No description provided for @moveOfflineNotice.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. This will be queued and moved to your wallet automatically when you\'re back online.'**
  String get moveOfflineNotice;

  /// No description provided for @movePinNote.
  ///
  /// In en, this message translates to:
  /// **'You\'ll enter your PIN next.'**
  String get movePinNote;

  /// No description provided for @queueMove.
  ///
  /// In en, this message translates to:
  /// **'Queue move'**
  String get queueMove;

  /// No description provided for @moveDone.
  ///
  /// In en, this message translates to:
  /// **'Moved to your wallet'**
  String get moveDone;

  /// No description provided for @movePending.
  ///
  /// In en, this message translates to:
  /// **'Queued — will move when back online'**
  String get movePending;

  /// No description provided for @moveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t move to your wallet'**
  String get moveFailed;

  /// No description provided for @goalReachedBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached your target. Keep saving, or move the money to your wallet whenever you\'re ready.'**
  String get goalReachedBanner;

  /// No description provided for @goalMoving.
  ///
  /// In en, this message translates to:
  /// **'{amount} moving to wallet'**
  String goalMoving(String amount);

  /// No description provided for @statusMoved.
  ///
  /// In en, this message translates to:
  /// **'Moved'**
  String get statusMoved;

  /// No description provided for @contributePastTarget.
  ///
  /// In en, this message translates to:
  /// **'This takes you past your target, and that\'s fine.'**
  String get contributePastTarget;

  /// No description provided for @breakFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Early break fee ({percent})'**
  String breakFeeLabel(String percent);

  /// No description provided for @moveYouReceive.
  ///
  /// In en, this message translates to:
  /// **'You\'ll receive'**
  String get moveYouReceive;

  /// No description provided for @breakFeeWarning.
  ///
  /// In en, this message translates to:
  /// **'This goal hasn\'t reached its target or its date yet, so breaking it now costs {percent} of what you move. It\'s free once you reach {target} or on {date}.'**
  String breakFeeWarning(String percent, String target, String date);

  /// No description provided for @moveFree.
  ///
  /// In en, this message translates to:
  /// **'No fee: this goal has reached its target or its date.'**
  String get moveFree;

  /// No description provided for @createGoalBreakNotice.
  ///
  /// In en, this message translates to:
  /// **'Need the money early? You can break this goal any time, but a {percent} fee comes off what you take out before you reach your target amount or your target date. After either one, moving money to your wallet is free.'**
  String createGoalBreakNotice(String percent);

  /// No description provided for @breakGoal.
  ///
  /// In en, this message translates to:
  /// **'Break goal'**
  String get breakGoal;

  /// No description provided for @sendNovaUser.
  ///
  /// In en, this message translates to:
  /// **'NovaWallet user'**
  String get sendNovaUser;

  /// No description provided for @sendNovaUserSub.
  ///
  /// In en, this message translates to:
  /// **'Send free to anyone on NovaWallet, using their email'**
  String get sendNovaUserSub;

  /// No description provided for @sendNovaUserOffline.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet to find a NovaWallet user. You can still send to saved recipients.'**
  String get sendNovaUserOffline;

  /// No description provided for @novaUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Send to a NovaWallet user'**
  String get novaUserTitle;

  /// No description provided for @novaUserBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the email they use for NovaWallet. We\'ll show their name so you can check it\'s the right person.'**
  String get novaUserBody;

  /// No description provided for @novaUserFind.
  ///
  /// In en, this message translates to:
  /// **'Find user'**
  String get novaUserFind;

  /// No description provided for @novaUserFound.
  ///
  /// In en, this message translates to:
  /// **'NOVAWALLET USER FOUND'**
  String get novaUserFound;

  /// No description provided for @novaUserFree.
  ///
  /// In en, this message translates to:
  /// **'No fee between NovaWallet users. The money lands in their wallet straight away.'**
  String get novaUserFree;

  /// No description provided for @errorSelfTransfer.
  ///
  /// In en, this message translates to:
  /// **'That\'s your own email. Enter the email of the person you\'re paying.'**
  String get errorSelfTransfer;
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
      <String>['en', 'yo'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'yo':
      return AppLocalizationsYo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
