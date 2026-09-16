import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/models/activity_item.dart';
import 'package:nova_wallet/core/models/bank.dart';
import 'package:nova_wallet/core/models/beneficiary.dart';
import 'package:nova_wallet/core/models/goal_view.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/models/profile.dart';
import 'package:nova_wallet/core/models/wallet_overview.dart';

void main() {
  final now = DateTime(2026, 9, 15, 14);

  test('Profile derives first name and tier cap', () {
    const p = Profile(
        fullName: '  Tolu  Adebayo ', phone: '08012345678', email: 't@x.com',
        tier: 1, bvnVerified: false, accountNumber: '8012345678');
    expect(p.firstName, 'Tolu');
    expect(p.singleSendCapKobo, AppConstants.tier1SingleSendCapKobo);
    expect(p.copyWith(tier: 2).singleSendCapKobo, AppConstants.tier2SingleSendCapKobo);
  });

  test('Banks lookup and beneficiary masking', () {
    expect(Banks.byCode('058')!.name, 'GTBank');
    expect(Banks.byCode('nope'), isNull);
    const b = Beneficiary(accountNumber: '0123454821', bankCode: '058', bankName: 'GTBank', verifiedName: 'ADAEZE OKAFOR');
    expect(b.maskedAccount, '•••• 4821');
  });

  test('OutboxItem debit and state helpers', () {
    final item = OutboxItem(
      id: 1, idempotencyKey: 'k', type: OutboxType.send, status: OutboxStatus.queued,
      amountKobo: 2500000, feeKobo: 2688, payloadJson: '{}', createdAt: now);
    expect(item.debitKobo, 2502688);
    expect(item.isActive, isTrue);
    expect(item.copyWith(status: OutboxStatus.failed).isTerminal, isTrue);
  });

  test('WalletOverview.available subtracts holds', () {
    const o = WalletOverview(ledgerKobo: 18645025, heldKobo: 5502688, pendingCount: 2);
    expect(o.availableKobo, 13142337);
    expect(WalletOverview.empty.availableKobo, 0);
  });

  test('ActivityItem.signedKobo includes fee on debits only', () {
    final debit = ActivityItem(id: 'a', status: ActivityStatus.completed, kind: ActivityKind.transfer,
        direction: ActivityDirection.debit, amountKobo: 500000, feeKobo: 1075, title: 'Ada', createdAt: now);
    final credit = ActivityItem(id: 'b', status: ActivityStatus.completed, kind: ActivityKind.credit,
        direction: ActivityDirection.credit, amountKobo: 500000, title: 'Salary', createdAt: now);
    expect(debit.signedKobo, -501075);
    expect(credit.signedKobo, 500000);
  });

  test('GoalView progress in bps, pending projected separately', () {
    final g = GoalView(clientId: 'g', name: 'Rent', targetKobo: 60000000, targetDate: DateTime(2026, 12, 20),
        savedKobo: 21000000, pendingKobo: 500000, syncState: GoalSyncState.synced, createdAt: now);
    expect(g.savedBps, 3500);
    expect(g.projectedBps, 3583);
    expect(g.remainingKobo, 39000000);
  });
}
