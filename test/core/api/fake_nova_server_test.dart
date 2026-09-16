import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/api/fake/demo_seed.dart';
import 'package:nova_wallet/core/api/fake/entities/server_entities.dart';
import 'package:nova_wallet/core/api/service/dto.dart';
import 'package:nova_wallet/core/auth/secret_hasher.dart';

import '../../support/isar_test_db.dart';
import '../../support/server_harness.dart';

const phone = AppConstants.demoPhone;

TransferRequest transfer(int amountKobo, {String account = '0248214821'}) => TransferRequest(
    bankCode: '058', bankName: 'GTBank', accountNumber: account,
    recipientName: 'ADAEZE OKAFOR', amountKobo: amountKobo);

T right<T>(Either<Failure, T> e) => e.fold((f) => fail('expected Right, got $f'), (r) => r);
Failure leftOf<T>(Either<Failure, T> e) => e.fold((f) => f, (r) => fail('expected Left, got $r'));

void main() {
  late String dir;
  late ServerHarness h;
  late String token;

  setUp(() async {
    dir = await newTempDir();
    h = await ServerHarness.open(directory: dir, tag: 'server');
    token = await h.demoToken();
  });
  tearDown(() => h.close(deleteFromDisk: true));

  group('auth', () {
    test('demo account is seeded: Tier 2, ₦250,000.00, history, beneficiaries, goal', () async {
      final wallet = right(await h.server.getWallet(token: token));
      expect(wallet.balanceKobo, 25000000);
      expect(wallet.profile.tier, 2);
      expect(wallet.profile.fullName, 'Tolu Adeyemi');
      expect(right(await h.server.getTransactions(token: token)).length, 60);
      expect(right(await h.server.getBeneficiaries(token: token)).length, 4);
      expect(right(await h.server.getGoals(token: token)).single.savedKobo, 21000000);
    });

    test('wrong password is a business failure', () async {
      final f = leftOf(await h.server.login(identifier: phone, password: 'nope'));
      expect((f as BusinessFailure).code, BusinessCode.invalidCredentials);
    });

    test('register creates a Tier 1 account once', () async {
      const req = RegisterRequest(phone: '+2349031234567', fullName: 'Tolu Ade', email: 't@x.com', password: 'Secret#123');
      final session = right(await h.server.register(req));
      expect(session.profile.phone, '09031234567');
      expect(session.profile.tier, 1);
      final dup = leftOf(await h.server.register(req));
      expect((dup as BusinessFailure).code, BusinessCode.accountExists);
    });

    test('OTP and BVN checks', () async {
      expect(right(await h.server.verifyOtp(phone: phone, code: AppConstants.fakeOtp)), unit);
      expect((leftOf(await h.server.verifyOtp(phone: phone, code: '000000')) as BusinessFailure).code,
          BusinessCode.invalidOtp);
      expect((leftOf(await h.server.verifyBvn(token: token, bvn: '123')) as BusinessFailure).code,
          BusinessCode.invalidBvn);
      expect(right(await h.server.verifyBvn(token: token, bvn: '22123456789')).bvnVerified, isTrue);
    });
  });

  test('unreachable server fails with NetworkFailure and changes nothing', () async {
    h.controls.simulateOffline = true;
    expect(leftOf(await h.server.transfer(token: token, idempotencyKey: 'k-off', request: transfer(500000))),
        isA<NetworkFailure>());
    expect(await h.balanceOf(phone), 25000000);
    expect(await h.db.server.processedRequests.count(), 0);
  });

  group('idempotency', () {
    test('same key twice → identical response, ONE debit, ONE transaction', () async {
      final first = right(await h.server.transfer(token: token, idempotencyKey: 'k1', request: transfer(500000)));
      final second = right(await h.server.transfer(token: token, idempotencyKey: 'k1', request: transfer(500000)));
      expect(second.ref, first.ref);
      expect(second.balanceAfterKobo, first.balanceAfterKobo);
      expect(await h.balanceOf(phone), 25000000 - 500000 - 1075);
      expect(await h.db.server.serverTransactions.filter().idempotencyKeyEqualTo('k1').count(), 1);
    });

    test('a different key is a different transfer', () async {
      right(await h.server.transfer(token: token, idempotencyKey: 'a', request: transfer(500000)));
      right(await h.server.transfer(token: token, idempotencyKey: 'b', request: transfer(500000)));
      expect(await h.balanceOf(phone), 25000000 - 2 * 501075);
    });

    test('lost response: applied on the server, timeout on the phone, replay returns the original', () async {
      h.controls.loseNextResponse = true;
      final lost = leftOf(await h.server.transfer(token: token, idempotencyKey: 'lost', request: transfer(1000000)));
      expect((lost as NetworkFailure).timedOut, isTrue);
      expect(await h.balanceOf(phone), 25000000 - 1002688);

      final replay = right(await h.server.transfer(token: token, idempotencyKey: 'lost', request: transfer(1000000)));
      expect(replay.balanceAfterKobo, 25000000 - 1002688);
      expect(await h.balanceOf(phone), 25000000 - 1002688);
    });

    test('rejections are stored and replayed, not re-evaluated', () async {
      final f = leftOf(await h.server.transfer(token: token, idempotencyKey: 'big', request: transfer(99000000)));
      expect((f as BusinessFailure).code, BusinessCode.insufficientFunds);
      final again = leftOf(await h.server.transfer(token: token, idempotencyKey: 'big', request: transfer(99000000)));
      expect(again, f);
    });

    test('processed keys survive a server restart', () async {
      final first = right(await h.server.transfer(token: token, idempotencyKey: 'persist', request: transfer(500000)));
      await h.close();
      h = await ServerHarness.open(directory: dir, tag: 'server');
      token = await h.demoToken();
      final replay = right(await h.server.transfer(token: token, idempotencyKey: 'persist', request: transfer(500000)));
      expect(replay.ref, first.ref);
      expect(await h.balanceOf(phone), 25000000 - 501075);
    });
  });

  group('business rules', () {
    test('tier cap applies to Tier 1 accounts', () async {
      final s = right(await h.server.register(const RegisterRequest(
          phone: '09031234567', fullName: 'T One', email: 't@x.com', password: 'Secret#123')));
      final f = leftOf(await h.server.transfer(token: s.token, idempotencyKey: 'cap', request: transfer(10000001)));
      expect((f as BusinessFailure).code, BusinessCode.tierLimitExceeded);
    });

    test('invalid account numbers are rejected by name enquiry and transfer', () async {
      expect((leftOf(await h.server.nameEnquiry(token: token, bankCode: '058', accountNumber: '0001112223'))
              as BusinessFailure).code, BusinessCode.invalidAccount);
      expect(right(await h.server.nameEnquiry(token: token, bankCode: '058', accountNumber: '0248214821')).accountName,
          'ADAEZE OKAFOR');
      final f = leftOf(await h.server.transfer(token: token, idempotencyKey: 'bad', request: transfer(500000, account: '0001112223')));
      expect((f as BusinessFailure).code, BusinessCode.invalidAccount);
    });

    test('create goal then contribute debits wallet and credits goal', () async {
      final goal = right(await h.server.createGoal(token: token, idempotencyKey: 'g1', request: CreateGoalRequest(
          clientId: 'goal-1', name: 'Laptop', targetKobo: 80000000, targetDate: DateTime(2027, 3, 1))));
      expect(goal.goal!.savedKobo, 0);
      final c = right(await h.server.contribute(token: token, idempotencyKey: 'c1',
          request: const ContributeRequest(goalClientId: 'goal-1', amountKobo: 500000)));
      expect(c.goal!.savedKobo, 500000);
      expect(c.balanceAfterKobo, 25000000 - 500000);
      expect(c.transaction!.goalClientId, 'goal-1');
    });

    test('contribution to an unknown goal is goalNotFound', () async {
      final f = leftOf(await h.server.contribute(token: token, idempotencyKey: 'c2',
          request: const ContributeRequest(goalClientId: 'missing', amountKobo: 500000)));
      expect((f as BusinessFailure).code, BusinessCode.goalNotFound);
    });
  });

  test('both backends seed identical history from one generator', () {
    final seed = DemoSeed(hasher: SecretHasher());
    final a = seed.historyJson(phone, DateTime(2026, 9, 16, 12));
    final b = seed.historyJson(phone, DateTime(2026, 9, 16, 12));
    expect(a.length, 60);
    expect(a, b, reason: 'deterministic: same input, same rows');
    expect(a.every((r) => r['amountKobo'] is int && r['createdAt'] is int), isTrue);
  });
}
