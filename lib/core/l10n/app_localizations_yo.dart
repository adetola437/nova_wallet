// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Yoruba (`yo`).
class AppLocalizationsYo extends AppLocalizations {
  AppLocalizationsYo([String locale = 'yo']) : super(locale);

  @override
  String get appName => 'NovaPay';

  @override
  String get continueLabel => 'Tẹ̀síwájú';

  @override
  String get done => 'Ó ti tán';

  @override
  String get cancel => 'Fagilé';

  @override
  String get retry => 'Gbìyànjú lẹ́ẹ̀kan sí i';

  @override
  String get back => 'Padà';

  @override
  String get skip => 'Fò ó';

  @override
  String get next => 'Èyí tó kàn';

  @override
  String get change => 'Yí i padà';

  @override
  String get seeAll => 'Wo gbogbo rẹ̀';

  @override
  String get viewDetails => 'Wo àwọn àlàyé';

  @override
  String get optional => 'kò ṣe dandan';

  @override
  String stepOf(int step, int total) {
    return 'Ìgbésẹ̀ $step nínú $total';
  }

  @override
  String get navHome => 'Ilé';

  @override
  String get navSave => 'NovaSave';

  @override
  String get navProfile => 'Àkọọ́lẹ̀';

  @override
  String get statusPending => 'Ó ń dúró';

  @override
  String get statusSending => 'Ó ń lọ';

  @override
  String get statusSent => 'Ó ti lọ';

  @override
  String get statusReceived => 'Ó wọlé';

  @override
  String get statusSaved => 'A ti fi pamọ́';

  @override
  String get statusFailed => 'Kò ṣeé ṣe';

  @override
  String get offlineBanner =>
      'O kò sí lórí íntánẹ́ẹ̀tì. A ó fi àwọn ìfiránṣẹ́ rẹ ránṣẹ́ fúnra wọn nígbà tí o bá padà sórí íntánẹ́ẹ̀tì.';

  @override
  String get offlineBannerSave =>
      'O kò sí lórí íntánẹ́ẹ̀tì. A ó fi owó tí o fẹ́ fi pamọ́ ránṣẹ́ fúnra rẹ̀ nígbà tí o bá padà.';

  @override
  String syncChipPending(int count) {
    return '$count ń dúró: a ó fi ránṣẹ́ nígbà tí íntánẹ́ẹ̀tì bá padà';
  }

  @override
  String syncChipSending(int count) {
    return 'A ń fi $count tó ń dúró ránṣẹ́…';
  }

  @override
  String get syncTrouble => 'Ó ń ṣòro láti fi ránṣẹ́. A ó máa gbìyànjú.';

  @override
  String get homeGreeting => 'Ẹ káàbọ̀ sí NovaPay,';

  @override
  String get homeWelcome => 'Ẹ káàbọ̀ sí NovaPay,';

  @override
  String get homeAvailableBalance => 'IWỌ̀N OWÓ TÓ WÀ';

  @override
  String homeOnHold(String amount) {
    return '$amount tí a dì mọ́lẹ̀';
  }

  @override
  String homeOnHoldPending(String amount, int count) {
    return '$amount tí a dì mọ́lẹ̀ fún $count tí ń dúró';
  }

  @override
  String get homeUpToDate => 'Gbogbo rẹ̀ ti wà ní ìmúdójúìwọ̀n.';

  @override
  String homeLastUpdated(String time) {
    return 'Ìmúdójúìwọ̀n tó kẹ́yìn: $time. Owó tí a dì mọ́lẹ̀ yóò padà sí àpò rẹ tí ìfiránṣẹ́ bá kùnà.';
  }

  @override
  String get homeShowBalance => 'Fi iye owó hàn';

  @override
  String get homeHideBalance => 'Bo iye owó';

  @override
  String get homeBalanceHidden => 'A ti bo iye owó';

  @override
  String get homeSend => 'Fi owó ránṣẹ́';

  @override
  String get homeSave => 'Pa owó mọ́';

  @override
  String get homeAddMoney => 'Fi owó kún àpò';

  @override
  String get homeQueuesOffline => 'Yóò dúró di ìgbà tí íntánẹ́ẹ̀tì bá dé';

  @override
  String get homeNeedsData => 'Ó nílò íntánẹ́ẹ̀tì';

  @override
  String get homeRecent => 'Àwọn ìṣòwò tuntun';

  @override
  String get homeSavedCopy => 'Ẹ̀dà tí a fi pamọ́';

  @override
  String get homeLoading =>
      'A ń gbé àpò rẹ wá… ó lè pẹ́ díẹ̀ tí íntánẹ́ẹ̀tì bá lọ́ra.';

  @override
  String get homeEmptyTitle => 'Kò sí ìṣòwò kankan síbẹ̀';

  @override
  String get homeEmptyBody =>
      'Fi owó kún àpò rẹ tàbí fi owó àkọ́kọ́ ránṣẹ́ — gbogbo ohun tí o bá ṣe yóò hàn níbí.';

  @override
  String get homeAddMoneySoon =>
      'Fífi owó kún àpò ń bọ̀ láìpẹ́. Àpò àpẹẹrẹ rẹ ti ní owó tẹ́lẹ̀.';

  @override
  String get transferIn => 'Owó tí ó wọlé';

  @override
  String queuedAt(String time) {
    return 'Ó ń dúró láti $time';
  }

  @override
  String get today => 'Òní';

  @override
  String get yesterday => 'Àná';

  @override
  String get sendTitle => 'Fi owó ránṣẹ́';

  @override
  String get sendSearchHint => 'Wá orúkọ, ilé ìfowópamọ́ tàbí nọ́mbà àkọọ́lẹ̀';

  @override
  String get sendSearchSavedHint => 'Wá àwọn tí o ti fi pamọ́';

  @override
  String get sendNewRecipient => 'Olùgbà tuntun';

  @override
  String get sendNewRecipientSub => 'Fi ránṣẹ́ sí nọ́mbà àkọọ́lẹ̀ tuntun';

  @override
  String get sendNewRecipientOffline =>
      'Wọlé sórí íntánẹ́ẹ̀tì láti fi olùgbà tuntun kún un. O ṣì lè fi ránṣẹ́ sí àwọn tí o ti fi pamọ́.';

  @override
  String get sendSavedRecipients => 'ÀWỌN OLÙGBÀ TÍ O TI FI PAMỌ́';

  @override
  String get sendSavedRecipientsOffline =>
      'ÀWỌN OLÙGBÀ TÍ O TI FI PAMỌ́ · WÀ LÁÌSÍ ÍNTÁNẸ́Ẹ̀TÌ';

  @override
  String get sendNoRecipients => 'Kò sí olùgbà tí o fi pamọ́ síbẹ̀.';

  @override
  String get newRecipientTitle => 'Olùgbà tuntun';

  @override
  String get bankLabel => 'Ilé ìfowópamọ́';

  @override
  String get chooseBank => 'Yan ilé ìfowópamọ́';

  @override
  String get accountNumberLabel => 'Nọ́mbà àkọọ́lẹ̀';

  @override
  String get accountNumberHelp =>
      'Àwọn nọ́mbà yóò hàn bí o ṣe ń tẹ̀ wọ́n, lẹ́yìn náà a ó bò wọ́n.';

  @override
  String get accountVerified => 'A TI ṢÀYẸ̀WÒ ÀKỌỌ́LẸ̀ NÁÀ';

  @override
  String get accountName => 'Orúkọ àkọọ́lẹ̀';

  @override
  String get accountCheckName =>
      'Rí i dájú pé orúkọ náà bá ẹni tí o fẹ́ sanwó fún mu.';

  @override
  String get verifyingAccount => 'A ń ṣàyẹ̀wò àkọọ́lẹ̀…';

  @override
  String get saveBeneficiary => 'Fi olùgbà pamọ́';

  @override
  String get saveBeneficiarySub =>
      'Yóò wà lórí àkójọ rẹ, kódà láìsí íntánẹ́ẹ̀tì';

  @override
  String get amountTitle => 'Iwọ̀n owó';

  @override
  String get amountQuestion => 'Èló ni o fẹ́ fi ránṣẹ́?';

  @override
  String get youAreSending => 'O ń fi ránṣẹ́';

  @override
  String availableAmount(String amount) {
    return 'Owó tó wà: $amount';
  }

  @override
  String get narrationLabel => 'Àlàyé (kò ṣe dandan)';

  @override
  String get narrationHint => 'Kín ni owó yìí fún?';

  @override
  String get feeLabel => 'Owó ìfiránṣẹ́';

  @override
  String get reviewTitle => 'Ṣàyẹ̀wò ìfiránṣẹ́';

  @override
  String get toLabel => 'Sí';

  @override
  String get accountLabel => 'Àkọọ́lẹ̀';

  @override
  String get amountLabel => 'Iwọ̀n owó';

  @override
  String get totalDebit => 'Àpapọ̀ owó tí yóò kúrò';

  @override
  String get balanceAfter => 'Owó tí yóò kù';

  @override
  String get heldUntilSent => 'A dì í mọ́lẹ̀ títí yóò fi lọ';

  @override
  String get reviewNoCharges =>
      'Kò sí owó mìíràn. Ìfiránṣẹ́ máa ń dé láàrin ìṣẹ́jú-àáyá; ó lè gba wákàtí mẹ́rìnlélógún tí ilé ìfowópamọ́ olùgbà bá lọ́ra.';

  @override
  String get reviewOfflineNotice =>
      'O kò sí lórí íntánẹ́ẹ̀tì. A ó fi ìfiránṣẹ́ yìí pamọ́, a ó sì fi ránṣẹ́ fúnra rẹ̀ nígbà tí o bá padà.';

  @override
  String get reviewOfflineFooter =>
      'Kò sí ohun tí yóò lọ títí fóònù rẹ yóò fi padà sórí íntánẹ́ẹ̀tì.';

  @override
  String get editDetails => 'Ṣàtúnṣe àwọn àlàyé';

  @override
  String sendCta(String amount) {
    return 'Fi $amount ránṣẹ́';
  }

  @override
  String get queueTransfer => 'Fi ìfiránṣẹ́ sí ìlà';

  @override
  String get pinTitle => 'Tẹ PIN oní-nọ́mbà mẹ́rin rẹ';

  @override
  String pinSending(String amount, String name) {
    return 'O ń fi $amount ránṣẹ́ sí $name';
  }

  @override
  String get pinWrong => 'PIN kò tọ̀nà. Gbìyànjú lẹ́ẹ̀kan sí i.';

  @override
  String get forgotPin => 'O gbàgbé PIN?';

  @override
  String get pinDelete => 'Pa rẹ́';

  @override
  String pinEnteredCount(int count) {
    return 'A ti tẹ $count nínú nọ́mbà mẹ́rin';
  }

  @override
  String biometricTitle(String amount) {
    return 'Fọwọ́ sí ìfiránṣẹ́ $amount';
  }

  @override
  String get biometricBody =>
      'Ìfiránṣẹ́ ₦50,000.00 sókè nílò ìka tàbí ojú rẹ. Fọwọ́ kan sensọ̀ náà láti fọwọ́ sí i.';

  @override
  String get biometricWaiting => 'A ń dúró de ìka rẹ…';

  @override
  String get usePinInstead => 'Lo PIN dípò rẹ̀';

  @override
  String get cancelTransfer => 'Fagilé ìfiránṣẹ́';

  @override
  String get biometricFallback =>
      'Ìka tàbí ojú kò ṣeé lò lórí fóònù yìí. Lo PIN rẹ.';

  @override
  String resultSentTo(String name) {
    return 'A ti fi ránṣẹ́ sí $name';
  }

  @override
  String get resultPendingTitle =>
      'Ó ń dúró: yóò lọ nígbà tí o bá padà sórí íntánẹ́ẹ̀tì';

  @override
  String get resultPendingBody =>
      'A ti tọ́jú ìfiránṣẹ́ yìí sínú fóònù rẹ. Yóò lọ fúnra rẹ̀ nígbà tí íntánẹ́ẹ̀tì bá padà, a ó sì sọ fún ọ.';

  @override
  String get resultProcessingTitle => 'Ó ń lọ lọ́wọ́…';

  @override
  String get resultProcessingBody =>
      'Ilé ìfowópamọ́ ń pẹ́ ju bí ó ti yẹ lọ láti fìdí rẹ̀ múlẹ̀. A dì owó rẹ mọ́lẹ̀ títí wọn yóò fi dáhùn. O lè pa ojú-ìwé yìí — ìfiránṣẹ́ náà ń bá a lọ.';

  @override
  String get resultFailedTitle => 'Ìfiránṣẹ́ kò ṣeé ṣe';

  @override
  String get resultNotDebited => 'A kò gba owó kankan lọ́wọ́ rẹ.';

  @override
  String get heldFromBalance => 'Owó tí a dì mọ́lẹ̀';

  @override
  String get referenceLabel => 'Àmì ìdánimọ̀';

  @override
  String get copy => 'Ṣe ẹ̀dà';

  @override
  String get copied => 'A ti ṣe ẹ̀dà rẹ̀';

  @override
  String get detailsTitle => 'Àlàyé ìṣòwò';

  @override
  String get progressLabel => 'ÌLỌSÍWÁJÚ';

  @override
  String get detailsLabel => 'ÀWỌN ÀLÀYÉ';

  @override
  String get timelineQueued => 'Ó wà ní ìlà';

  @override
  String get timelineQueuedSub => 'A fi pamọ́ sínú fóònù rẹ';

  @override
  String get timelineSending => 'Ó ń lọ';

  @override
  String get timelineSendingSub => 'A fi ránṣẹ́ sí ilé ìfowópamọ́';

  @override
  String get timelineCompleted => 'Ó ti parí';

  @override
  String get timelineCompletedSub => 'Ilé ìfowópamọ́ ti fìdí rẹ̀ múlẹ̀';

  @override
  String get timelineFailed => 'Kò ṣeé ṣe';

  @override
  String get dateLabel => 'Ọjọ́';

  @override
  String get idempotencyKeyLabel => 'Kọ́kọ́rọ́ ìdánimọ̀';

  @override
  String get attemptsLabel => 'Ìgbìyànjú';

  @override
  String get saveTitle => 'NovaSave';

  @override
  String saveGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'àfojúsùn $count',
      one: 'àfojúsùn 1',
    );
    return '$_temp0';
  }

  @override
  String get saveTotalSaved => 'ÀPAPỌ̀ OWÓ TÍ A FI PAMỌ́';

  @override
  String savePendingAcross(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'àfojúsùn $count',
      one: 'àfojúsùn 1',
    );
    return '$amount ń dúró lórí $_temp0';
  }

  @override
  String saveOfTarget(String saved, String target) {
    return '$saved nínú $target';
  }

  @override
  String saveTargetDate(String date) {
    return 'Ọjọ́ àfojúsùn: $date';
  }

  @override
  String savePendingPill(String amount) {
    return '$amount ń dúró';
  }

  @override
  String get saveGoalReached => 'A ti dé àfojúsùn';

  @override
  String get saveGoalSyncing => 'A ń ṣẹ̀dá rẹ̀…';

  @override
  String get saveGoalFailed => 'Kò ṣeé ṣẹ̀dá';

  @override
  String get saveCreateGoal => 'Ṣẹ̀dá àfojúsùn';

  @override
  String get saveEmptyTitle => 'Kò sí àfojúsùn ìfowópamọ́ síbẹ̀';

  @override
  String get saveEmptyBody =>
      'Sọ ohun tí o ń fi owó pamọ́ fún, fi iye àfojúsùn sí i, kí o sì máa fi owó kún un nígbàkúùgbà.';

  @override
  String get savePopular => 'ÀWỌN ÀBÁ TÍ Ó WỌ́PỌ̀';

  @override
  String get saveIdeaRent => 'Owó ilé';

  @override
  String get saveIdeaSchool => 'Owó ilé-ìwé';

  @override
  String get saveIdeaEmergency => 'Owó pàjáwìrì';

  @override
  String get createGoalTitle => 'Ṣẹ̀dá àfojúsùn';

  @override
  String get goalNameLabel => 'Orúkọ àfojúsùn';

  @override
  String get targetAmountLabel => 'Iye àfojúsùn';

  @override
  String get targetDateLabel => 'Ọjọ́ àfojúsùn';

  @override
  String get months3 => 'Oṣù mẹ́ta';

  @override
  String get months6 => 'Oṣù mẹ́fà';

  @override
  String get year1 => 'Ọdún kan';

  @override
  String weeklyHint(String amount, String date) {
    return 'Fi nǹkan bí $amount pamọ́ lọ́sọ̀ọ̀sẹ̀ láti dé ibẹ̀ ní $date';
  }

  @override
  String get weeklyHintSub =>
      'Àbá ni, kì í ṣe dandan — fi iye owó kankan kún un nígbàkúùgbà.';

  @override
  String get createGoalCta => 'Ṣẹ̀dá àfojúsùn';

  @override
  String goalSaved(String amount) {
    return '$amount tí a fi pamọ́';
  }

  @override
  String goalPending(String amount) {
    return '$amount ń dúró';
  }

  @override
  String get daysLeft => 'Ọjọ́ tó kù';

  @override
  String get contributionsLabel => 'ÀWỌN ÌFIKÚN';

  @override
  String get contribute => 'Fi kún un';

  @override
  String contributeTitle(String goal) {
    return 'Fi kún $goal';
  }

  @override
  String get contributeSub => 'Owó yóò kúrò nínú àpò rẹ sínú àfojúsùn yìí.';

  @override
  String get contributeFrom => 'Láti NovaWallet';

  @override
  String get contributeOfflineNotice =>
      'O kò sí lórí íntánẹ́ẹ̀tì. A ó fi ìfikún yìí sí ìlà, a ó sì fi kún àfojúsùn rẹ fúnra rẹ̀ nígbà tí o bá padà.';

  @override
  String get contributeNoFee =>
      'Ìwọ yóò tẹ PIN rẹ lẹ́yìn èyí. Kò sí owó ìfiránṣẹ́ fún NovaSave.';

  @override
  String get queueContribution => 'Fi ìfikún sí ìlà';

  @override
  String get contributeHeld =>
      'A dì í mọ́lẹ̀ títí yóò fi lọ. Kò sí ohun tí yóò sọnù tí ó bá kùnà.';

  @override
  String get contributeSaved => 'A ti fi kún àfojúsùn rẹ';

  @override
  String get contributePending =>
      'Ó wà ní ìlà — yóò lọ nígbà tí íntánẹ́ẹ̀tì bá padà';

  @override
  String get contributeFailed => 'Kò ṣeé ṣe láti fi kún àfojúsùn rẹ';

  @override
  String get profileTitle => 'Àkọọ́lẹ̀';

  @override
  String profileTier(int tier) {
    return 'Ìpele $tier';
  }

  @override
  String get profileLanguage => 'Èdè';

  @override
  String get profileLanguageHint =>
      'Àyípadà yóò hàn lẹ́sẹ̀kẹsẹ̀. Iye owó yóò wà ní Náírà.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageYoruba => 'Yorùbá';

  @override
  String get languageHausa => 'Hausa';

  @override
  String get languageIgbo => 'Igbo';

  @override
  String get comingSoon => 'Ó ń bọ̀ láìpẹ́';

  @override
  String get profileBiometrics => 'Ìka tàbí ojú';

  @override
  String get profileBiometricsSub =>
      'Ṣí àpò rẹ kí o sì fọwọ́ sí ìfiránṣẹ́ pẹ̀lú ìka rẹ';

  @override
  String get profileSecurity => 'Ààbò';

  @override
  String get profileSecuritySub => 'Yí PIN, ọ̀rọ̀ aṣínà àti àwọn ẹ̀rọ padà';

  @override
  String get profileHelp => 'Ìrànlọ́wọ́';

  @override
  String get profileHelpSub => 'Bá wa sọ̀rọ̀, tàbí pè 0700 NOVAPAY';

  @override
  String get profileDeveloper => 'Ojú-ìwé olùgbéjáde';

  @override
  String get profileDeveloperSub => 'Fún àpẹẹrẹ nìkan';

  @override
  String get signOut => 'Jáde';

  @override
  String get versionFooter => 'NovaPay 1.0.0 · àpẹẹrẹ';

  @override
  String get devTitle => 'Ojú-ìwé olùgbéjáde';

  @override
  String get devSimulateOffline => 'Ṣe bí ẹni pé kò sí íntánẹ́ẹ̀tì';

  @override
  String get devLoseResponse => 'Pàdánù ìdáhùn tó kàn láti olùpín';

  @override
  String get devLatency => 'Ìdádúró';

  @override
  String get devOutbox => 'ÌLÀ ÌFIRÁNṢẸ́';

  @override
  String devOutboxItems(int count) {
    return 'Ohun $count';
  }

  @override
  String get devOutboxEmpty => 'Ìlà ìfiránṣẹ́ ṣófo.';

  @override
  String get devIdempotencyNote =>
      'Ìfiránṣẹ́ kọ̀ọ̀kan ní kọ́kọ́rọ́ ìdánimọ̀ tirẹ̀, nítorí náà ìgbìyànjú kejì kò lè gba owó lẹ́ẹ̀mejì.';

  @override
  String get devReset => 'Tún àwọn dátà àpẹẹrẹ ṣe';

  @override
  String get devResetConfirm =>
      'Èyí yóò pa dátà àpẹẹrẹ rẹ rẹ́, yóò sì mú ọ jáde.';

  @override
  String get onboardSendTitle => 'Fi owó ránṣẹ́ láàrin ìṣẹ́jú-àáyá';

  @override
  String get onboardSendBody =>
      'Fi owó ránṣẹ́ sí ilé ìfowópamọ́ èyíkéyìí ní Nàìjíríà lẹ́sẹ̀kẹsẹ̀.';

  @override
  String get onboardSaveTitle => 'Fi owó pamọ́ fún ohun tó ṣe pàtàkì';

  @override
  String get onboardSaveBody => 'Ṣètò àfojúsùn kí o sì wo bí ó ṣe ń dàgbà.';

  @override
  String get onboardOfflineTitle =>
      'Ó ń ṣiṣẹ́ kódà nígbà tí íntánẹ́ẹ̀tì kò dára';

  @override
  String get onboardOfflineBody =>
      'Kò sí íntánẹ́ẹ̀tì? A ó fi ìfiránṣẹ́ rẹ sí ìlà, a ó sì fi ránṣẹ́ ní kété tí o bá padà.';

  @override
  String get createAccount => 'Ṣí àkọọ́lẹ̀';

  @override
  String get haveAccount => 'Mo ti ní àkọọ́lẹ̀';

  @override
  String get phoneTitle => 'Kí ni nọ́mbà fóònù rẹ?';

  @override
  String get phoneBody =>
      'A ó fi kóòdù ránṣẹ́ sí ọ láti fìdí rẹ̀ múlẹ̀ pé ìwọ ni. Owó SMS lè wà.';

  @override
  String get phoneHelp => 'Nàìjíríà (+234) · nọ́mbà mẹ́wàá, láìsí 0 ìbẹ̀rẹ̀';

  @override
  String get phonePrivacy =>
      'Lo nọ́mbà tí a forúkọ SIM rẹ sí. A kì í pín in, a kì í sì ka àwọn olùbásọ̀rọ̀ rẹ.';

  @override
  String get sendCode => 'Fi kóòdù ránṣẹ́ sí mi';

  @override
  String get otpTitle => 'Tẹ kóòdù oní-nọ́mbà mẹ́fà rẹ';

  @override
  String otpSentTo(String phone) {
    return 'A fi SMS ránṣẹ́ sí $phone.';
  }

  @override
  String get changeNumber => 'Yí nọ́mbà padà';

  @override
  String resendIn(String time) {
    return 'Tún fi ránṣẹ́ ní $time';
  }

  @override
  String get resend => 'Tún fi ránṣẹ́';

  @override
  String get otpDemo =>
      'Fún àpẹẹrẹ nìkan — a kì í fi kóòdù SMS gidi hàn nínú áàpù.';

  @override
  String get verify => 'Fìdí rẹ̀ múlẹ̀';

  @override
  String get detailsTitleSignup => 'Àwọn àlàyé rẹ';

  @override
  String get fullName => 'Orúkọ kíkún';

  @override
  String get fullNameHelp => 'Bí ó ṣe wà nínú àkọọ́lẹ̀ ilé ìfowópamọ́ rẹ.';

  @override
  String get email => 'Ímeèlì';

  @override
  String get password => 'Ọ̀rọ̀ aṣínà';

  @override
  String get show => 'Fihàn';

  @override
  String get hide => 'Bò ó';

  @override
  String get pwRuleLength => 'Ó kéré tán lẹ́tà mẹ́jọ';

  @override
  String get pwRuleMix => 'Lẹ́tà ńlá kan àti nọ́mbà kan';

  @override
  String get pwRuleSymbol => 'Àmì kan, bí ! tàbí #';

  @override
  String get consent => 'Mo gbà pẹ̀lú Àwọn Òfin àti Ìlànà Àṣírí (NDPA 2023)';

  @override
  String get bvnTitle => 'Fìdí BVN rẹ múlẹ̀';

  @override
  String get bvnHelp => 'Tẹ *565*0# lórí nọ́mbà tí o forúkọ sí láti rí BVN rẹ.';

  @override
  String get bvnWhy => 'ÌDÍ TÍ A FI Ń BÉÈRÈ';

  @override
  String get bvnWhyBody =>
      'Òfin Nàìjíríà so ìfiránṣẹ́ owó ńlá mọ́ ìdánimọ̀ tí a ti fìdí rẹ̀ múlẹ̀. Orúkọ àti ọjọ́ ìbí rẹ nìkan ni a ń kà — kì í ṣe iye owó rẹ ní ilé ìfowópamọ́.';

  @override
  String get tier1 => 'Ìpele 1 · báyìí';

  @override
  String get tier1Limit => '₦100,000 fún ìfiránṣẹ́ kọ̀ọ̀kan, kò nílò BVN';

  @override
  String get tier2 => 'Ìpele 2 · pẹ̀lú BVN';

  @override
  String get tier2Limit => '₦1,000,000 fún ìfiránṣẹ́ kọ̀ọ̀kan';

  @override
  String get bvnLater =>
      'O lè fi BVN rẹ kún un lẹ́yìn náà láti Àkọọ́lẹ̀ — kò sí ohun tí yóò dí ọ lọ́wọ́ láti fi owó ránṣẹ́ lónìí.';

  @override
  String get verifyBvn => 'Fìdí BVN múlẹ̀';

  @override
  String get skipForNow => 'Fò ó fún báyìí';

  @override
  String get createPinTitle => 'Ṣẹ̀dá PIN ìṣòwò rẹ';

  @override
  String get createPinBody =>
      'Ìwọ yóò tẹ nọ́mbà mẹ́rin yìí láti fi owó ránṣẹ́ — ìfiránṣẹ́ ₦50,000.00 sókè yóò lo ojú tàbí ìka rẹ dípò rẹ̀. Má ṣe pín in.';

  @override
  String get confirmPinTitle => 'Fìdí PIN rẹ múlẹ̀';

  @override
  String get confirmPinBody =>
      'Tún tẹ nọ́mbà mẹ́rin kan náà kí a lè mọ̀ pé ó wọlé dáadáa.';

  @override
  String get pinsMatch => 'PIN méjèèjì bá ara mu';

  @override
  String get pinsDontMatch => 'PIN méjèèjì kò bá ara mu. Bẹ̀rẹ̀ lẹ́ẹ̀kan sí i.';

  @override
  String get loginWelcome => 'Ẹ káàbọ̀ padà';

  @override
  String get loginBody =>
      'Wọlé láti fi owó ránṣẹ́, fi pamọ́ àti wo iye owó rẹ.';

  @override
  String get forgotPassword => 'O gbàgbé ọ̀rọ̀ aṣínà?';

  @override
  String get logIn => 'Wọlé';

  @override
  String get newHere => 'Ṣé o jẹ́ tuntun?';

  @override
  String unlockGreeting(String name) {
    return 'Ẹ káàbọ̀ padà, $name';
  }

  @override
  String get unlockBody => 'Tẹ PIN rẹ láti ṣí NovaPay';

  @override
  String get unlockBiometric => 'Ṣí i pẹ̀lú ìka rẹ';

  @override
  String get notYou => 'Kì í ṣe ìwọ? Jáde';

  @override
  String get unlockLocked => 'Ìgbìyànjú ti pọ̀ jù. Dúró díẹ̀ kí o tó gbìyànjú.';

  @override
  String get errorGeneric => 'Nǹkan kan ṣẹlẹ̀. Jọ̀wọ́ gbìyànjú lẹ́ẹ̀kan sí i.';

  @override
  String get errorOffline =>
      'O kò sí lórí íntánẹ́ẹ̀tì. Wọlé sórí íntánẹ́ẹ̀tì kí o sì gbìyànjú lẹ́ẹ̀kan sí i.';

  @override
  String get errorInvalidCredentials =>
      'Ímeèlì àti ọ̀rọ̀ aṣínà náà kò bá ara mu. Gbìyànjú lẹ́ẹ̀kan sí i.';

  @override
  String get errorInvalidOtp =>
      'Kóòdù náà kò tọ̀nà. Ṣàyẹ̀wò SMS náà kí o sì gbìyànjú lẹ́ẹ̀kan sí i.';

  @override
  String get errorAccountExists =>
      'Àkọọ́lẹ̀ ti wà pẹ̀lú àwọn àlàyé yìí. Wọlé dípò bẹ́ẹ̀.';

  @override
  String get errorInvalidPhone => 'Tẹ nọ́ńbà fóònù Nàìjíríà tó tọ̀nà.';

  @override
  String get errorInvalidEmail => 'Tẹ àdírẹ́sì ímeèlì tó tọ̀nà.';

  @override
  String get errorInvalidBvn =>
      'A kò lè jẹ́rìísí BVN náà. Ṣàyẹ̀wò àwọn nọ́ńbà mọ́kànlá náà.';

  @override
  String get errorInvalidInput =>
      'Ṣàyẹ̀wò àwọn àlàyé náà kí o sì gbìyànjú lẹ́ẹ̀kan sí i.';

  @override
  String get errorInsufficientFunds => 'Èyí ju iye owó tó wà lọ́wọ́ rẹ lọ.';

  @override
  String get errorTierLimit =>
      'Èyí ju òdiwọ̀n ìfiránṣẹ́ rẹ lọ. Jẹ́rìísí BVN rẹ láti gbé e sókè.';

  @override
  String get errorInvalidAccount =>
      'A kò rí àkọọ́lẹ̀ náà. Ṣàyẹ̀wò nọ́ńbà àti báńkì náà.';

  @override
  String get errorAmountTooSmall => 'Iye owó náà kéré jù.';

  @override
  String get errorAmountTooLarge => 'Iye owó náà pọ̀ jù.';

  @override
  String get errorGoalNotFound => 'A kò rí àfojúsùn náà.';

  @override
  String get errorSessionEnded => 'Ìgbà rẹ ti parí. Wọlé lẹ́ẹ̀kan sí i.';

  @override
  String unlockTryIn(int seconds) {
    return 'Ìgbìyànjú ti pọ̀ jù. Gbìyànjú lẹ́yìn ìṣẹ́jú-àáyá $seconds.';
  }

  @override
  String get forgotPasswordSoon => 'Àtúntò ọ̀rọ̀ aṣínà kò sí nínú àfihàn yìí.';

  @override
  String get bvnLabel => 'BVN';

  @override
  String get bvnHint => 'Nọ́ńbà mọ́kànlá';

  @override
  String get demoLabel => 'ÀFIHÀN';

  @override
  String get splashTagline =>
      'Fi owó ránṣẹ́ kí o sì pa owó mọ́, kódà láìsí íntánẹ́ẹ̀tì';

  @override
  String get homeGreetingMorning => 'Ẹ káàárọ̀,';

  @override
  String get homeGreetingEvening => 'Ẹ kú ìrọ̀lẹ́,';

  @override
  String get homeLoadingMore => 'À ń gbé púpọ̀ sí i wá…';

  @override
  String goalProgressA11y(String percent) {
    return '$percent ti wà ní ìpamọ́';
  }

  @override
  String get goalNoContributions => 'Kò sí owó tí a ti fi kún un síbẹ̀.';

  @override
  String get goalNameHint => 'fún àpẹẹrẹ, Kọ̀ǹpútà tuntun';

  @override
  String get createGoalDateHint => 'Yan ọjọ́ kan';

  @override
  String get contributeAmountQuestion => 'Èló ni o fẹ́ fi kún un?';

  @override
  String profileAccountNumber(String number) {
    return 'Àkọọ́lẹ̀ $number';
  }

  @override
  String devLatencyMs(int ms) {
    return '$ms ms';
  }

  @override
  String get devSimulateOfflineSub => 'Ṣe bí ẹni pé olupin kò ṣeé dé';

  @override
  String get devLoseResponseSub =>
      'Olupin yóò ṣe ìbéèrè tó kàn, ṣùgbọ́n èsì rẹ̀ kò ní dé';

  @override
  String get devSimulateCredit => 'Ṣe bí ẹni pé owó wọlé';

  @override
  String get devSimulateCreditSub =>
      'Yóò fi ₦25,000.00 láti ọ̀dọ̀ Kunle Bankole kún àkọọ́lẹ̀ rẹ, yóò sì fi ìfitónilétí ránṣẹ́';

  @override
  String get moveToWallet => 'Gbé e lọ sínú àpò';

  @override
  String moveTitle(String goal) {
    return 'Gbé owó kúrò nínú $goal';
  }

  @override
  String get moveSub => 'Owó yóò kúrò nínú àfojúsùn yìí padà sínú àpò rẹ.';

  @override
  String moveInGoal(String amount) {
    return 'Nínú àfojúsùn yìí: $amount';
  }

  @override
  String get moveAll => 'Gbé gbogbo rẹ̀';

  @override
  String get moveQuestion => 'Èló ni o fẹ́ gbé?';

  @override
  String get moveOfflineNotice =>
      'O kò sí lórí íntánẹ́ẹ̀tì. A ó gbé e sínú àpò rẹ fúnra rẹ̀ nígbà tí o bá padà sórí íntánẹ́ẹ̀tì.';

  @override
  String get movePinNote => 'O máa tẹ PIN rẹ lẹ́yìn èyí.';

  @override
  String get queueMove => 'Fi sí ìlà';

  @override
  String get moveDone => 'Ó ti wọ inú àpò rẹ';

  @override
  String get movePending =>
      'Ó ń dúró: yóò lọ nígbà tí o bá padà sórí íntánẹ́ẹ̀tì';

  @override
  String get moveFailed => 'A kò lè gbé e sínú àpò rẹ';

  @override
  String get goalReachedBanner =>
      'O ti dé àfojúsùn rẹ. Máa bá a lọ láti fi owó pamọ́, tàbí gbé owó náà lọ sínú àpò rẹ nígbàkúgbà tí o bá ṣetán.';

  @override
  String goalMoving(String amount) {
    return '$amount ń lọ sínú àpò';
  }

  @override
  String get statusMoved => 'Ó ti wọlé';

  @override
  String get contributePastTarget => 'Èyí kọjá àfojúsùn rẹ, kò sì burú.';

  @override
  String breakFeeLabel(String percent) {
    return 'Owó ìjánu ṣáájú àkókò ($percent)';
  }

  @override
  String get moveYouReceive => 'Ohun tí o máa gbà';

  @override
  String breakFeeWarning(String percent, String target, String date) {
    return 'Àfojúsùn yìí kò tíì dé iye tàbí ọjọ́ rẹ̀, nítorí náà jíjá a nísinsìnyí máa ná ọ ní $percent nínú ohun tí o bá gbé. Kò ní owó kankan tí o bá dé $target tàbí ní $date.';
  }

  @override
  String get moveFree => 'Kò sí owó: àfojúsùn yìí ti dé iye tàbí ọjọ́ rẹ̀.';

  @override
  String createGoalBreakNotice(String percent) {
    return 'Ṣé o nílò owó náà ṣáájú àkókò? O lè já àfojúsùn yìí nígbàkúgbà, ṣùgbọ́n a ó yọ $percent kúrò nínú ohun tí o bá gbé jáde ṣáájú kí o tó dé iye tàbí ọjọ́ àfojúsùn rẹ. Lẹ́yìn èyíkéyìí nínú méjèèjì, gbígbé owó sínú àpò rẹ kò ní owó kankan.';
  }

  @override
  String get breakGoal => 'Já àfojúsùn';

  @override
  String get sendNovaUser => 'Oníbàárà NovaWallet';

  @override
  String get sendNovaUserSub =>
      'Fi owó ránṣẹ́ lọ́fẹ̀ẹ́ sí ẹnikẹ́ni lórí NovaWallet pẹ̀lú ímeèlì wọn';

  @override
  String get sendNovaUserOffline =>
      'Wọlé sórí íntánẹ́ẹ̀tì láti wá oníbàárà NovaWallet. O ṣì lè fi owó ránṣẹ́ sí àwọn tí o ti fi pamọ́.';

  @override
  String get novaUserTitle => 'Fi owó ránṣẹ́ sí oníbàárà NovaWallet';

  @override
  String get novaUserBody =>
      'Tẹ ímeèlì tí wọ́n ń lò fún NovaWallet. A ó fi orúkọ wọn hàn kí o lè ríi dájú pé ẹni tó tọ́ ni.';

  @override
  String get novaUserFind => 'Wá oníbàárà';

  @override
  String get novaUserFound => 'A RÍ ONÍBÀÁRÀ NOVAWALLET';

  @override
  String get novaUserFree =>
      'Kò sí owó ìfiránṣẹ́ láàárín àwọn oníbàárà NovaWallet. Owó náà yóò wọ inú àpò wọn lẹ́sẹ̀kẹsẹ̀.';

  @override
  String get errorSelfTransfer =>
      'Ímeèlì tìrẹ nìyẹn. Tẹ ímeèlì ẹni tí o fẹ́ san owó fún.';
}
