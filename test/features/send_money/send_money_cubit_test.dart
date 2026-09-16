import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/api/fake/entities/server_entities.dart';
import 'package:nova_wallet/core/auth/biometric_signer.dart';
import 'package:nova_wallet/core/models/beneficiary.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/models/profile.dart';
import 'package:nova_wallet/core/network/backend_reachability.dart';
import 'package:nova_wallet/core/network/reachability.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/features/auth/cubit/auth_cubit.dart';
import 'package:nova_wallet/features/beneficiaries/repository/beneficiary_repository_impl.dart';
import 'package:nova_wallet/features/connectivity/cubit/connectivity_cubit.dart';
import 'package:nova_wallet/features/send_money/cubit/send_money_cubit.dart';
import 'package:nova_wallet/features/send_money/cubit/send_money_state.dart';
import 'package:nova_wallet/features/settings/repository/settings_repository_impl.dart';
import 'package:nova_wallet/features/sync/cubit/sync_cubit.dart';
import 'package:nova_wallet/features/wallet/cubit/wallet_cubit.dart';
import 'package:nova_wallet/features/wallet/repository/wallet_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/fake_biometric_gate.dart';
import '../../support/fake_sync_notifier.dart';
import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

const ada = Beneficiary(
    accountNumber: '0248214821', bankCode: '058', bankName: 'GTBank', verifiedName: 'ADAEZE OKAFOR');
const nobody = Beneficiary(
    accountNumber: '0001112223', bankCode: '058', bankName: 'GTBank', verifiedName: 'NO ONE');

void main() {
  late OutboxHarness h;
  late ConnectivityCubit connectivity;
  late SyncCubit sync;
  late WalletCubit wallet;
  late AuthCubit session;
  late SettingsRepositoryImpl settings;
  late FakeBiometricGate gate;
  late SendMoneyCubit cubit;

  setUp(() async {
    h = await OutboxHarness.open(directory: await newTempDir(), tag: 'send');
    await h.signIn();
    connectivity = ConnectivityCubit(
      reachability: Reachability(
          networkInfo: h.network, controls: h.server.controls, backend: const AlwaysReachable()),
      onlineDebounce: const Duration(milliseconds: 10),
    );
    await connectivity.start();
    sync = SyncCubit(
        outbox: h.outbox,
        connectivity: connectivity,
        notifier: FakeSyncNotifier(),
        backoff: (_) => const Duration(milliseconds: 20));
    await sync.start();
    wallet = WalletCubit(
      repository: WalletRepositoryImpl(db: h.db, api: h.server.server, session: h.session),
      sync: sync,
    );
    await wallet.start();
    settings = SettingsRepositoryImpl(localStorage: LocalStorageImpl(prefs: await SharedPreferences.getInstance()));
    session = AuthCubit(repository: h.authRepository, settings: settings);
    session.sessionStarted((await h.authRepository.cachedProfile())!);
    gate = FakeBiometricGate();
    cubit = SendMoneyCubit(
      outbox: h.outbox,
      auth: h.authRepository,
      settings: settings,
      beneficiaries: BeneficiaryRepositoryImpl(db: h.db, api: h.server.server, session: h.session),
      session: session,
      wallet: wallet,
      sync: sync,
      connectivity: connectivity,
      biometricGate: gate,
      outcomeWait: const Duration(seconds: 2),
    );
  });

  tearDown(() async {
    await cubit.close();
    await session.close();
    await wallet.close();
    await sync.close();
    await connectivity.close();
    await h.close(deleteFromDisk: true);
  });

  group('amount validation', () {
    test('below the ₦100.00 minimum', () {
      cubit.selectRecipient(ada);
      cubit.amountChanged('50');
      expect((cubit.state.amountError! as ValidationFailure).code, ValidationCode.amountTooSmall);
    });

    test('above the tier cap', () {
      const tierOne = Profile(
          fullName: 'Tolu Adeyemi', phone: AppConstants.demoPhone, email: 't@x.com',
          tier: 1, bvnVerified: false, accountNumber: '8012345678');
      session.sessionStarted(tierOne);
      cubit.selectRecipient(ada);
      cubit.amountChanged('150,000');
      expect((cubit.state.amountError! as ValidationFailure).code, ValidationCode.tierLimitExceeded);
    });

    test('above the available balance, and the fee is included', () {
      cubit.selectRecipient(ada);
      cubit.amountChanged('250,000');
      expect(cubit.state.feeKobo, 5375);
      expect(cubit.state.debitKobo, 25005375);
      expect((cubit.state.amountError! as ValidationFailure).code, ValidationCode.insufficientAvailable);
    });

    test('a valid amount computes the band fee and clears errors', () {
      cubit.selectRecipient(ada);
      cubit.amountChanged('25,000');
      expect(cubit.state.amountKobo, 2500000);
      expect(cubit.state.feeKobo, 2688);
      expect(cubit.state.amountError, isNull);
      expect(cubit.state.canContinue, isTrue);
    });
  });

  test('online send: PIN authorises, item settles as Sent and debits once', () async {
    cubit.selectRecipient(ada);
    cubit.amountChanged('25,000');
    await cubit.continueToReview();
    expect(cubit.state.stage, SendStage.review);
    expect(cubit.state.requiresBiometric, isFalse);

    await cubit.authoriseWithPin(AppConstants.demoPin);

    expect(cubit.state.outcome, SendOutcome.sent);
    expect(cubit.state.item!.status, OutboxStatus.succeeded);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688);
    expect(await h.db.server.processedRequests.count(), 1);
  });

  test('the wrong PIN queues nothing', () async {
    cubit.selectRecipient(ada);
    cubit.amountChanged('25,000');
    await cubit.continueToReview();
    await cubit.authoriseWithPin('9999');

    expect(cubit.state.pinError, isTrue);
    expect(cubit.state.stage, SendStage.review);
    expect(await h.outbox.activeItems(), isEmpty);
  });

  test('OFFLINE send: outcome is Pending, and it flips to Sent when sync runs', () async {
    h.network.connected = false;
    await connectivity.recheck();

    cubit.selectRecipient(ada);
    cubit.amountChanged('25,000');
    await cubit.continueToReview();
    await cubit.authoriseWithPin(AppConstants.demoPin);

    expect(cubit.state.outcome, SendOutcome.pending);
    expect(cubit.state.item!.status, OutboxStatus.queued);
    expect(cubit.state.item!.queuedWhileOffline, isTrue);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo);

    h.network.connected = true;
    await Future<void>.delayed(const Duration(milliseconds: 60));
    await sync.drain();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(cubit.state.outcome, SendOutcome.sent, reason: 'the open result screen updates itself');
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688);
  });

  test('a send at or above ₦50,000.00 requires biometrics and signs the amount', () async {
    await settings.setBiometricEnabled(true);
    cubit.selectRecipient(ada);
    cubit.amountChanged('50,000');
    await cubit.continueToReview();
    expect(cubit.state.requiresBiometric, isTrue);

    await cubit.authoriseWithBiometric();

    expect(gate.confirmCalls, 1);
    expect(gate.lastPayload, contains('5002688'));
    expect(cubit.state.outcome, SendOutcome.sent);
    expect(cubit.state.item!.biometricSignature, 'fake-signature');
  });

  test('when biometrics are unavailable the flow falls back to PIN', () async {
    await settings.setBiometricEnabled(true);
    gate.available = false;
    cubit.selectRecipient(ada);
    cubit.amountChanged('50,000');
    await cubit.continueToReview();
    expect(cubit.state.requiresBiometric, isFalse, reason: 'no hardware, so PIN it is');

    gate.available = true;
    gate.nextError = BiometricSignerError.keyMissing;
    await cubit.continueToReview();
    await cubit.authoriseWithBiometric();
    expect(cubit.state.needsPinFallback, isTrue);
    expect(await h.outbox.activeItems(), isEmpty);
  });

  test('a rejected send shows Failed, and Try again uses a NEW key', () async {
    cubit.selectRecipient(nobody);
    cubit.amountChanged('5,000');
    await cubit.continueToReview();
    await cubit.authoriseWithPin(AppConstants.demoPin);

    expect(cubit.state.outcome, SendOutcome.failed);
    final firstKey = cubit.state.item!.idempotencyKey;

    cubit.retry();
    expect(cubit.state.stage, SendStage.review);
    await cubit.authoriseWithPin(AppConstants.demoPin);
    expect(cubit.state.item!.idempotencyKey, isNot(firstKey));
  });
}
