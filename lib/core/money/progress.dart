/// Savings progress in integer basis points (10000 = 100%).
abstract class Progress {
  static const int full = 10000;

  static int bps({required int savedKobo, required int targetKobo}) {
    if (targetKobo <= 0 || savedKobo <= 0) return 0;
    if (savedKobo >= targetKobo) return full;
    return savedKobo * full ~/ targetKobo;
  }

  /// The true percentage, NOT capped: a goal at ₦624,000 of ₦600,000 reads
  /// 104%. Use [bps] for bar widths and this for the text.
  static int uncappedBps({required int savedKobo, required int targetKobo}) {
    if (targetKobo <= 0 || savedKobo <= 0) return 0;
    return savedKobo * full ~/ targetKobo;
  }

  /// `3500` → `35%`, `3550` → `35.5%`, `3333` → `33.33%`.
  static String formatPercent(int bps) {
    final whole = bps ~/ 100;
    final frac = bps % 100;
    if (frac == 0) return '$whole%';
    if (frac % 10 == 0) return '$whole.${frac ~/ 10}%';
    return '$whole.${frac.toString().padLeft(2, '0')}%';
  }

  /// Weekly amount that reaches the goal by [targetDate], rounded **up**.
  static int suggestedWeeklyKobo({required int remainingKobo, required DateTime from, required DateTime targetDate}) {
    if (remainingKobo <= 0) return 0;
    // UTC dates so a DST change on the test machine can't shave off a day.
    final start = DateTime.utc(from.year, from.month, from.day);
    final end = DateTime.utc(targetDate.year, targetDate.month, targetDate.day);
    final days = end.difference(start).inDays;
    if (days <= 0) return remainingKobo;
    final weeks = (days + 6) ~/ 7;
    return (remainingKobo + weeks - 1) ~/ weeks;
  }
}
