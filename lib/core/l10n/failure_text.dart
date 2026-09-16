import '../api/exception/failure.dart';
import 'app_localizations.dart';

/// Cubits carry English developer messages inside [Failure]; screens show the
/// user's language by mapping the failure's code instead.
extension FailureText on Failure {
  String localized(AppLocalizations l10n) => switch (this) {
    NetworkFailure() => l10n.errorOffline,
    StorageFailure() => l10n.errorGeneric,
    BusinessFailure(:final code) => switch (code) {
      BusinessCode.insufficientFunds => l10n.errorInsufficientFunds,
      BusinessCode.tierLimitExceeded => l10n.errorTierLimit,
      BusinessCode.invalidAccount => l10n.errorInvalidAccount,
      BusinessCode.goalNotFound => l10n.errorGoalNotFound,
      BusinessCode.invalidCredentials => l10n.errorInvalidCredentials,
      BusinessCode.accountExists => l10n.errorAccountExists,
      BusinessCode.invalidOtp => l10n.errorInvalidOtp,
      BusinessCode.invalidBvn => l10n.errorInvalidBvn,
      BusinessCode.unauthorized => l10n.errorSessionEnded,
      BusinessCode.selfTransfer => l10n.errorSelfTransfer,
    },
    ValidationFailure(:final code) => switch (code) {
      ValidationCode.amountTooSmall => l10n.errorAmountTooSmall,
      ValidationCode.amountTooLarge => l10n.errorAmountTooLarge,
      ValidationCode.tierLimitExceeded => l10n.errorTierLimit,
      ValidationCode.insufficientAvailable => l10n.errorInsufficientFunds,
      ValidationCode.invalidInput => l10n.errorInvalidInput,
      ValidationCode.wrongPin => l10n.pinWrong,
      ValidationCode.pinMismatch => l10n.pinsDontMatch,
      ValidationCode.locked => l10n.unlockLocked,
      ValidationCode.offline => l10n.errorOffline,
    },
  };
}
