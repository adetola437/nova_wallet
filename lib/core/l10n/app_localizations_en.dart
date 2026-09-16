// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'NovaPay';

  @override
  String get continueLabel => 'Continue';

  @override
  String get done => 'Done';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Try again';

  @override
  String get back => 'Back';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get change => 'Change';

  @override
  String get seeAll => 'See all';

  @override
  String get viewDetails => 'View details';

  @override
  String get optional => 'optional';

  @override
  String stepOf(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navSave => 'NovaSave';

  @override
  String get navProfile => 'Profile';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusSending => 'Sending';

  @override
  String get statusSent => 'Sent';

  @override
  String get statusReceived => 'Received';

  @override
  String get statusSaved => 'Saved';

  @override
  String get statusFailed => 'Failed';

  @override
  String get offlineBanner =>
      'You\'re offline. Transfers will be queued and sent automatically.';

  @override
  String get offlineBannerSave =>
      'You\'re offline. Contributions will be queued and sent automatically.';

  @override
  String syncChipPending(int count) {
    return '$count pending: will send when back online';
  }

  @override
  String syncChipSending(int count) {
    return 'Sending $count queued…';
  }

  @override
  String get syncTrouble => 'Having trouble sending. We\'ll keep trying.';

  @override
  String get homeGreeting => 'Good afternoon,';

  @override
  String get homeWelcome => 'Welcome to NovaPay,';

  @override
  String get homeAvailableBalance => 'AVAILABLE BALANCE';

  @override
  String homeOnHold(String amount) {
    return '$amount on hold';
  }

  @override
  String homeOnHoldPending(String amount, int count) {
    return '$amount on hold for $count pending';
  }

  @override
  String get homeUpToDate => 'Everything is up to date.';

  @override
  String homeLastUpdated(String time) {
    return 'Last updated $time. Held funds return to your balance if a queued transfer fails.';
  }

  @override
  String get homeShowBalance => 'Show balance';

  @override
  String get homeHideBalance => 'Hide balance';

  @override
  String get homeBalanceHidden => 'Balance hidden';

  @override
  String get homeSend => 'Send';

  @override
  String get homeSave => 'Save';

  @override
  String get homeAddMoney => 'Add money';

  @override
  String get homeQueuesOffline => 'Queues offline';

  @override
  String get homeNeedsData => 'Needs data';

  @override
  String get homeRecent => 'Recent transactions';

  @override
  String get homeSavedCopy => 'Showing saved copy';

  @override
  String get homeLoading =>
      'Loading your wallet… this can take a moment on a slow connection.';

  @override
  String get homeEmptyTitle => 'No transactions yet';

  @override
  String get homeEmptyBody =>
      'Add money to your wallet or send your first transfer — everything you do will show up here.';

  @override
  String get homeAddMoneySoon =>
      'Adding money is coming soon. Your demo wallet already has funds.';

  @override
  String get transferIn => 'Transfer in';

  @override
  String queuedAt(String time) {
    return 'Queued $time';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get sendTitle => 'Send money';

  @override
  String get sendSearchHint => 'Search name, bank or account';

  @override
  String get sendSearchSavedHint => 'Search saved recipients';

  @override
  String get sendNewRecipient => 'New recipient';

  @override
  String get sendNewRecipientSub => 'Send to a new account number';

  @override
  String get sendNewRecipientOffline =>
      'Connect to the internet to add a new recipient. You can still send to saved recipients.';

  @override
  String get sendSavedRecipients => 'SAVED RECIPIENTS';

  @override
  String get sendSavedRecipientsOffline =>
      'SAVED RECIPIENTS · AVAILABLE OFFLINE';

  @override
  String get sendNoRecipients => 'No saved recipients yet.';

  @override
  String get newRecipientTitle => 'New recipient';

  @override
  String get bankLabel => 'Bank';

  @override
  String get chooseBank => 'Choose a bank';

  @override
  String get accountNumberLabel => 'Account number';

  @override
  String get accountNumberHelp =>
      'Digits stay visible while you type, then we mask them.';

  @override
  String get accountVerified => 'ACCOUNT VERIFIED';

  @override
  String get accountName => 'Account name';

  @override
  String get accountCheckName =>
      'Check the name matches the person you intend to pay.';

  @override
  String get verifyingAccount => 'Checking account…';

  @override
  String get saveBeneficiary => 'Save as beneficiary';

  @override
  String get saveBeneficiarySub =>
      'Keeps them on your saved list, even offline';

  @override
  String get amountTitle => 'Amount';

  @override
  String get amountQuestion => 'How much are you sending?';

  @override
  String get youAreSending => 'You are sending';

  @override
  String availableAmount(String amount) {
    return 'Available: $amount';
  }

  @override
  String get narrationLabel => 'Narration (optional)';

  @override
  String get narrationHint => 'What is this for?';

  @override
  String get feeLabel => 'Fee';

  @override
  String get reviewTitle => 'Review transfer';

  @override
  String get toLabel => 'To';

  @override
  String get accountLabel => 'Account';

  @override
  String get amountLabel => 'Amount';

  @override
  String get totalDebit => 'Total debit';

  @override
  String get balanceAfter => 'Balance after';

  @override
  String get heldUntilSent => 'Held until sent';

  @override
  String get reviewNoCharges =>
      'No other charges. Transfers usually land in seconds; it can take up to 24 hours if the receiving bank is slow.';

  @override
  String get reviewOfflineNotice =>
      'You\'re offline. This transfer will be queued and sent automatically when you\'re back online.';

  @override
  String get reviewOfflineFooter =>
      'Nothing is sent until your phone reconnects.';

  @override
  String get editDetails => 'Edit details';

  @override
  String sendCta(String amount) {
    return 'Send $amount';
  }

  @override
  String get queueTransfer => 'Queue transfer';

  @override
  String get pinTitle => 'Enter your 4-digit PIN';

  @override
  String pinSending(String amount, String name) {
    return 'Sending $amount to $name';
  }

  @override
  String get pinWrong => 'Incorrect PIN. Try again.';

  @override
  String get forgotPin => 'Forgot PIN?';

  @override
  String get pinDelete => 'Delete';

  @override
  String pinEnteredCount(int count) {
    return '$count of 4 digits entered';
  }

  @override
  String biometricTitle(String amount) {
    return 'Confirm $amount transfer';
  }

  @override
  String get biometricBody =>
      'Transfers of ₦50,000.00 and above need your fingerprint or face. Touch the sensor to authorise.';

  @override
  String get biometricWaiting => 'Waiting for your fingerprint…';

  @override
  String get usePinInstead => 'Use PIN instead';

  @override
  String get cancelTransfer => 'Cancel transfer';

  @override
  String get biometricFallback =>
      'Biometrics aren\'t available on this device. Use your PIN.';

  @override
  String resultSentTo(String name) {
    return 'Sent to $name';
  }

  @override
  String get resultPendingTitle => 'Pending — will send when back online';

  @override
  String get resultPendingBody =>
      'We\'ve saved this transfer on your phone. It will go through automatically once you\'re connected, and we\'ll notify you.';

  @override
  String get resultProcessingTitle => 'Processing…';

  @override
  String get resultProcessingBody =>
      'The bank is taking longer than usual to confirm. Your money is held until they respond. You can close this screen — the transfer keeps going.';

  @override
  String get resultFailedTitle => 'Transfer failed';

  @override
  String get resultNotDebited => 'Your money was not debited.';

  @override
  String get heldFromBalance => 'Held from balance';

  @override
  String get referenceLabel => 'Reference';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get detailsTitle => 'Transaction details';

  @override
  String get progressLabel => 'PROGRESS';

  @override
  String get detailsLabel => 'DETAILS';

  @override
  String get timelineQueued => 'Queued';

  @override
  String get timelineQueuedSub => 'Saved on your phone';

  @override
  String get timelineSending => 'Sending';

  @override
  String get timelineSendingSub => 'Sent to the bank';

  @override
  String get timelineCompleted => 'Completed';

  @override
  String get timelineCompletedSub => 'The bank confirmed the credit';

  @override
  String get timelineFailed => 'Failed';

  @override
  String get dateLabel => 'Date';

  @override
  String get idempotencyKeyLabel => 'Idempotency key';

  @override
  String get attemptsLabel => 'Attempts';

  @override
  String get saveTitle => 'NovaSave';

  @override
  String saveGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goals',
      one: '1 goal',
    );
    return '$_temp0';
  }

  @override
  String get saveTotalSaved => 'TOTAL SAVED';

  @override
  String savePendingAcross(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count goals',
      one: '1 goal',
    );
    return '$amount pending across $_temp0';
  }

  @override
  String saveOfTarget(String saved, String target) {
    return '$saved of $target';
  }

  @override
  String saveTargetDate(String date) {
    return 'Target $date';
  }

  @override
  String savePendingPill(String amount) {
    return '$amount pending';
  }

  @override
  String get saveGoalReached => 'Goal reached';

  @override
  String get saveGoalSyncing => 'Creating…';

  @override
  String get saveGoalFailed => 'Couldn\'t create';

  @override
  String get saveCreateGoal => 'Create a goal';

  @override
  String get saveEmptyTitle => 'No savings goals yet';

  @override
  String get saveEmptyBody =>
      'Name what you\'re saving for, set a target, and add money whenever you have it.';

  @override
  String get savePopular => 'POPULAR STARTING POINTS';

  @override
  String get saveIdeaRent => 'Rent';

  @override
  String get saveIdeaSchool => 'School fees';

  @override
  String get saveIdeaEmergency => 'Emergency fund';

  @override
  String get createGoalTitle => 'Create a goal';

  @override
  String get goalNameLabel => 'Goal name';

  @override
  String get targetAmountLabel => 'Target amount';

  @override
  String get targetDateLabel => 'Target date';

  @override
  String get months3 => '3 months';

  @override
  String get months6 => '6 months';

  @override
  String get year1 => '1 year';

  @override
  String weeklyHint(String amount, String date) {
    return 'Save about $amount a week to reach this by $date';
  }

  @override
  String get weeklyHintSub =>
      'A guide, not a commitment — contribute any amount, any time.';

  @override
  String get createGoalCta => 'Create goal';

  @override
  String goalSaved(String amount) {
    return '$amount saved';
  }

  @override
  String goalPending(String amount) {
    return '$amount pending';
  }

  @override
  String get daysLeft => 'Days left';

  @override
  String get contributionsLabel => 'CONTRIBUTIONS';

  @override
  String get contribute => 'Contribute';

  @override
  String contributeTitle(String goal) {
    return 'Add to $goal';
  }

  @override
  String get contributeSub => 'Money moves from your wallet into this goal.';

  @override
  String get contributeFrom => 'From NovaWallet';

  @override
  String get contributeOfflineNotice =>
      'You\'re offline. This contribution will be queued and added to your goal automatically when you\'re back online.';

  @override
  String get contributeNoFee =>
      'You\'ll enter your PIN next. No fee on NovaSave contributions.';

  @override
  String get queueContribution => 'Queue contribution';

  @override
  String get contributeHeld =>
      'Held from your balance until it sends. Nothing is lost if it fails.';

  @override
  String get contributeSaved => 'Saved to your goal';

  @override
  String get contributePending => 'Queued — will save when back online';

  @override
  String get contributeFailed => 'Couldn\'t save to your goal';

  @override
  String get profileTitle => 'Profile';

  @override
  String profileTier(int tier) {
    return 'Tier $tier';
  }

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileLanguageHint =>
      'Changes apply immediately. Amounts stay in Naira.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageYoruba => 'Yorùbá';

  @override
  String get languageHausa => 'Hausa';

  @override
  String get languageIgbo => 'Igbo';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get profileBiometrics => 'Biometrics';

  @override
  String get profileBiometricsSub =>
      'Unlock and approve transfers with your fingerprint';

  @override
  String get profileSecurity => 'Security';

  @override
  String get profileSecuritySub => 'Change PIN, password and devices';

  @override
  String get profileHelp => 'Help';

  @override
  String get profileHelpSub => 'Chat with us, or call 0700 NOVAPAY';

  @override
  String get profileDeveloper => 'Developer panel';

  @override
  String get profileDeveloperSub => 'Demo build only';

  @override
  String get signOut => 'Sign out';

  @override
  String get versionFooter => 'NovaPay 1.0.0 · demo build';

  @override
  String get devTitle => 'Developer panel';

  @override
  String get devSimulateOffline => 'Simulate offline';

  @override
  String get devLoseResponse => 'Lose next server response';

  @override
  String get devLatency => 'Latency';

  @override
  String get devOutbox => 'OUTBOX';

  @override
  String devOutboxItems(int count) {
    return '$count items';
  }

  @override
  String get devOutboxEmpty => 'The outbox is empty.';

  @override
  String get devIdempotencyNote =>
      'Idempotency keys are generated per transfer, so a retry after a lost response can never double-debit.';

  @override
  String get devReset => 'Reset demo data';

  @override
  String get devResetConfirm => 'This wipes your demo data and signs you out.';

  @override
  String get onboardSendTitle => 'Send money in seconds';

  @override
  String get onboardSendBody => 'Transfer to any Nigerian bank instantly.';

  @override
  String get onboardSaveTitle => 'Save towards what matters';

  @override
  String get onboardSaveBody => 'Set goals and watch your progress grow.';

  @override
  String get onboardOfflineTitle => 'Works even when network is bad';

  @override
  String get onboardOfflineBody =>
      'No network? We\'ll queue your transfer and send it the moment you\'re back online.';

  @override
  String get createAccount => 'Create account';

  @override
  String get haveAccount => 'I already have an account';

  @override
  String get phoneTitle => 'What\'s your phone number?';

  @override
  String get phoneBody =>
      'We\'ll send you a code to confirm it\'s you. Standard SMS rates may apply.';

  @override
  String get phoneHelp => 'Nigeria (+234) · 10 digits, without the leading 0';

  @override
  String get phonePrivacy =>
      'Use the number registered to your SIM. We never share it and we don\'t read your contacts.';

  @override
  String get sendCode => 'Send me a code';

  @override
  String get otpTitle => 'Enter your 6-digit code';

  @override
  String otpSentTo(String phone) {
    return 'Sent by SMS to $phone.';
  }

  @override
  String get changeNumber => 'Change number';

  @override
  String resendIn(String time) {
    return 'Resend code in $time';
  }

  @override
  String get resend => 'Resend';

  @override
  String get otpDemo =>
      'Demo build only — real SMS codes are never shown in the app.';

  @override
  String get verify => 'Verify';

  @override
  String get detailsTitleSignup => 'Your details';

  @override
  String get fullName => 'Full name';

  @override
  String get fullNameHelp => 'As it appears on your bank records.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get show => 'Show';

  @override
  String get hide => 'Hide';

  @override
  String get pwRuleLength => 'At least 8 characters';

  @override
  String get pwRuleMix => 'One capital letter and one number';

  @override
  String get pwRuleSymbol => 'One symbol, e.g. ! or #';

  @override
  String get consent => 'I agree to the Terms and Privacy Policy (NDPA 2023)';

  @override
  String get bvnTitle => 'Verify your BVN';

  @override
  String get bvnHelp => 'Dial *565*0# on your registered line to see your BVN.';

  @override
  String get bvnWhy => 'WHY WE ASK';

  @override
  String get bvnWhyBody =>
      'Nigerian regulation ties higher transfer limits to a verified identity. We only read your name and date of birth — never your bank balances.';

  @override
  String get tier1 => 'Tier 1 · now';

  @override
  String get tier1Limit => '₦100,000 per transfer, no BVN needed';

  @override
  String get tier2 => 'Tier 2 · with BVN';

  @override
  String get tier2Limit => '₦1,000,000 per transfer';

  @override
  String get bvnLater =>
      'You can add your BVN later from Profile — nothing here blocks you from sending today.';

  @override
  String get verifyBvn => 'Verify BVN';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get createPinTitle => 'Create your transaction PIN';

  @override
  String get createPinBody =>
      'You\'ll enter these 4 digits to send money — transfers of ₦50,000.00 and above use your face or fingerprint instead. Never share it.';

  @override
  String get confirmPinTitle => 'Confirm your PIN';

  @override
  String get confirmPinBody =>
      'Enter the same 4 digits again so we know it saved correctly.';

  @override
  String get pinsMatch => 'PINs match';

  @override
  String get pinsDontMatch => 'Those PINs don\'t match. Start again.';

  @override
  String get loginWelcome => 'Welcome back';

  @override
  String get loginBody => 'Log in to send, save and check your balance.';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get logIn => 'Log in';

  @override
  String get newHere => 'New here?';

  @override
  String unlockGreeting(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get unlockBody => 'Enter your PIN to unlock NovaPay';

  @override
  String get unlockBiometric => 'Unlock with fingerprint';

  @override
  String get notYou => 'Not you? Sign out';

  @override
  String get unlockLocked => 'Too many attempts. Try again in a moment.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorOffline =>
      'You\'re offline. Connect to the internet and try again.';

  @override
  String get errorInvalidCredentials =>
      'That email and password don\'t match. Try again.';

  @override
  String get errorInvalidOtp =>
      'That code isn\'t right. Check the SMS and try again.';

  @override
  String get errorAccountExists =>
      'An account already exists with these details. Log in instead.';

  @override
  String get errorInvalidPhone => 'Enter a valid Nigerian phone number.';

  @override
  String get errorInvalidEmail => 'Enter a valid email address.';

  @override
  String get errorInvalidBvn =>
      'We couldn\'t verify that BVN. Check the 11 digits.';

  @override
  String get errorInvalidInput => 'Check the details and try again.';

  @override
  String get errorInsufficientFunds =>
      'That\'s more than your available balance.';

  @override
  String get errorTierLimit =>
      'That\'s above your per-transfer limit. Verify your BVN to raise it.';

  @override
  String get errorInvalidAccount =>
      'We couldn\'t find that account. Check the number and bank.';

  @override
  String get errorAmountTooSmall => 'That amount is too small.';

  @override
  String get errorAmountTooLarge => 'That amount is too large.';

  @override
  String get errorGoalNotFound => 'We couldn\'t find that goal.';

  @override
  String get errorSessionEnded => 'Your session has ended. Log in again.';

  @override
  String unlockTryIn(int seconds) {
    return 'Too many attempts. Try again in ${seconds}s.';
  }

  @override
  String get forgotPasswordSoon =>
      'Password reset isn\'t part of this demo build.';

  @override
  String get bvnLabel => 'BVN';

  @override
  String get bvnHint => '11 digits';

  @override
  String get demoLabel => 'DEMO';

  @override
  String get splashTagline => 'Send & save, even offline';

  @override
  String get homeGreetingMorning => 'Good morning,';

  @override
  String get homeGreetingEvening => 'Good evening,';

  @override
  String get homeLoadingMore => 'Loading more…';

  @override
  String goalProgressA11y(String percent) {
    return '$percent saved';
  }

  @override
  String get goalNoContributions => 'No contributions yet.';

  @override
  String get goalNameHint => 'e.g. New laptop';

  @override
  String get createGoalDateHint => 'Pick a date';

  @override
  String get contributeAmountQuestion => 'How much are you adding?';

  @override
  String profileAccountNumber(String number) {
    return 'Account $number';
  }

  @override
  String devLatencyMs(int ms) {
    return '$ms ms';
  }

  @override
  String get devSimulateOfflineSub => 'Treat the backend as unreachable';

  @override
  String get devLoseResponseSub =>
      'The server applies the next request, but the reply never arrives';

  @override
  String get devSimulateCredit => 'Simulate incoming payment';

  @override
  String get devSimulateCreditSub =>
      'Credits ₦25,000.00 from Kunle Bankole and sends a notification';

  @override
  String get moveToWallet => 'Move to wallet';

  @override
  String moveTitle(String goal) {
    return 'Move from $goal';
  }

  @override
  String get moveSub => 'Money moves from this goal back to your wallet.';

  @override
  String moveInGoal(String amount) {
    return 'In this goal: $amount';
  }

  @override
  String get moveAll => 'Move all';

  @override
  String get moveQuestion => 'How much are you moving?';

  @override
  String get moveOfflineNotice =>
      'You\'re offline. This will be queued and moved to your wallet automatically when you\'re back online.';

  @override
  String get movePinNote => 'You\'ll enter your PIN next.';

  @override
  String get queueMove => 'Queue move';

  @override
  String get moveDone => 'Moved to your wallet';

  @override
  String get movePending => 'Queued — will move when back online';

  @override
  String get moveFailed => 'Couldn\'t move to your wallet';

  @override
  String get goalReachedBanner =>
      'You\'ve reached your target. Keep saving, or move the money to your wallet whenever you\'re ready.';

  @override
  String goalMoving(String amount) {
    return '$amount moving to wallet';
  }

  @override
  String get statusMoved => 'Moved';

  @override
  String get contributePastTarget =>
      'This takes you past your target, and that\'s fine.';

  @override
  String breakFeeLabel(String percent) {
    return 'Early break fee ($percent)';
  }

  @override
  String get moveYouReceive => 'You\'ll receive';

  @override
  String breakFeeWarning(String percent, String target, String date) {
    return 'This goal hasn\'t reached its target or its date yet, so breaking it now costs $percent of what you move. It\'s free once you reach $target or on $date.';
  }

  @override
  String get moveFree =>
      'No fee: this goal has reached its target or its date.';

  @override
  String createGoalBreakNotice(String percent) {
    return 'Need the money early? You can break this goal any time, but a $percent fee comes off what you take out before you reach your target amount or your target date. After either one, moving money to your wallet is free.';
  }

  @override
  String get breakGoal => 'Break goal';

  @override
  String get sendNovaUser => 'NovaWallet user';

  @override
  String get sendNovaUserSub =>
      'Send free to anyone on NovaWallet, using their email';

  @override
  String get sendNovaUserOffline =>
      'Connect to the internet to find a NovaWallet user. You can still send to saved recipients.';

  @override
  String get novaUserTitle => 'Send to a NovaWallet user';

  @override
  String get novaUserBody =>
      'Enter the email they use for NovaWallet. We\'ll show their name so you can check it\'s the right person.';

  @override
  String get novaUserFind => 'Find user';

  @override
  String get novaUserFound => 'NOVAWALLET USER FOUND';

  @override
  String get novaUserFree =>
      'No fee between NovaWallet users. The money lands in their wallet straight away.';

  @override
  String get errorSelfTransfer =>
      'That\'s your own email. Enter the email of the person you\'re paying.';
}
