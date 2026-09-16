import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/money/progress.dart';

void main() {
  test('bps uses integer division and caps at 100%', () {
    expect(Progress.bps(savedKobo: 21000000, targetKobo: 60000000), 3500);
    expect(Progress.bps(savedKobo: 1, targetKobo: 3), 3333);
    expect(Progress.bps(savedKobo: 70000000, targetKobo: 60000000), 10000);
    expect(Progress.bps(savedKobo: 0, targetKobo: 60000000), 0);
    expect(Progress.bps(savedKobo: 5, targetKobo: 0), 0);
  });

  test('formatPercent trims trailing zeros', () {
    expect(Progress.formatPercent(3500), '35%');
    expect(Progress.formatPercent(3550), '35.5%');
    expect(Progress.formatPercent(3333), '33.33%');
    expect(Progress.formatPercent(10000), '100%');
  });

  test('suggestedWeeklyKobo rounds up so the goal is reached', () {
    final from = DateTime(2026, 9, 15);
    // 96 days → 14 weeks; 39,000,000 / 14 = 2,785,714.28… → 2,785,715
    expect(
      Progress.suggestedWeeklyKobo(remainingKobo: 39000000, from: from, targetDate: DateTime(2026, 12, 20)),
      2785715,
    );
    expect(Progress.suggestedWeeklyKobo(remainingKobo: 0, from: from, targetDate: DateTime(2026, 12, 20)), 0);
    expect(Progress.suggestedWeeklyKobo(remainingKobo: 500, from: from, targetDate: from), 500);
  });
}
