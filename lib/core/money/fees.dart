import '../../config/flavor/app_constants.dart';
import '../models/bank.dart';

/// Fictional NIP-style transfer fee bands, in kobo (spec assumption A5).
abstract class Fees {
  static const int _band1UpperKobo = 500000; // ₦5,000.00
  static const int _band2UpperKobo = 5000000; // ₦50,000.00

  /// Transfers to another NovaWallet user ([Banks.novaWallet]) are free.
  static int transferFeeKobo(int amountKobo, {String? bankCode}) {
    if (amountKobo <= 0) return 0;
    if (bankCode != null && Banks.isNovaWallet(bankCode)) return 0;
    if (amountKobo <= _band1UpperKobo) return 1075; // ₦10.75
    if (amountKobo <= _band2UpperKobo) return 2688; // ₦26.88
    return 5375; // ₦53.75
  }

  /// Whether moving money out of a goal right now is free: the target amount
  /// has been reached, or the target date has arrived (compared by calendar
  /// day, so "on the date" counts).
  static bool goalIsMatured({
    required int savedKobo,
    required int targetKobo,
    required DateTime targetDate,
    required DateTime now,
  }) {
    if (savedKobo >= targetKobo) return true;
    final today = DateTime.utc(now.year, now.month, now.day);
    final due = DateTime.utc(targetDate.year, targetDate.month, targetDate.day);
    return !today.isBefore(due);
  }

  /// Fee for breaking a goal early: [AppConstants.goalBreakFeeBps] of the
  /// amount, rounded UP to the kobo, integer maths only. Zero once matured.
  static int goalBreakFeeKobo({
    required int amountKobo,
    required int savedKobo,
    required int targetKobo,
    required DateTime targetDate,
    required DateTime now,
  }) {
    if (amountKobo <= 0) return 0;
    if (goalIsMatured(savedKobo: savedKobo, targetKobo: targetKobo, targetDate: targetDate, now: now)) return 0;
    return (amountKobo * AppConstants.goalBreakFeeBps + 9999) ~/ 10000;
  }
}
