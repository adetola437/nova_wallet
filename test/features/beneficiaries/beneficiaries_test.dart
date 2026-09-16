import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/models/bank.dart';
import 'package:nova_wallet/core/network/backend_reachability.dart';
import 'package:nova_wallet/core/network/reachability.dart';
import 'package:nova_wallet/features/beneficiaries/cubit/name_enquiry_cubit.dart';
import 'package:nova_wallet/features/beneficiaries/repository/beneficiary_repository_impl.dart';
import 'package:nova_wallet/features/connectivity/cubit/connectivity_cubit.dart';

import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

void main() {
  late OutboxHarness h;
  late BeneficiaryRepositoryImpl repo;
  late ConnectivityCubit connectivity;

  setUp(() async {
    h = await OutboxHarness.open(directory: await newTempDir(), tag: 'ben');
    await h.signIn();
    repo = BeneficiaryRepositoryImpl(db: h.db, api: h.server.server, session: h.session);
    connectivity = ConnectivityCubit(
      reachability: Reachability(
          networkInfo: h.network, controls: h.server.controls, backend: const AlwaysReachable()),
      onlineDebounce: const Duration(milliseconds: 10),
    );
    await connectivity.start();
  });

  tearDown(() async {
    await connectivity.close();
    await h.close(deleteFromDisk: true);
  });

  test('refresh caches the four seeded beneficiaries for offline use', () async {
    expect((await repo.refresh()).isRight(), isTrue);
    final all = await repo.all();
    expect(all.length, 4);
    expect(all.map((b) => b.verifiedName), contains('ADAEZE OKAFOR'));

    // Cached names remain available with no network — this is what makes an
    // offline send to a saved recipient safe.
    h.server.controls.simulateOffline = true;
    expect((await repo.all()).length, 4);
  });

  test('name enquiry verifies online and saves the beneficiary', () async {
    final cubit = NameEnquiryCubit(repository: repo, connectivity: connectivity);
    cubit.selectBank(Banks.byCode('058')!);
    await cubit.accountNumberChanged('0248214821');
    expect(cubit.state.verified!.verifiedName, 'ADAEZE OKAFOR');

    final saved = await cubit.confirm();
    expect(saved.isRight(), isTrue);
    expect((await repo.all()).any((b) => b.accountNumber == '0248214821'), isTrue);
    await cubit.close();
  });

  test('an unknown account is rejected before anything is saved', () async {
    final cubit = NameEnquiryCubit(repository: repo, connectivity: connectivity);
    cubit.selectBank(Banks.byCode('058')!);
    await cubit.accountNumberChanged('0001112223');
    expect((cubit.state.failure! as BusinessFailure).code, BusinessCode.invalidAccount);
    expect(cubit.state.verified, isNull);
    await cubit.close();
  });

  test('offline, a new recipient cannot be verified and says so', () async {
    h.network.connected = false;
    await connectivity.recheck();
    final cubit = NameEnquiryCubit(repository: repo, connectivity: connectivity);
    cubit.selectBank(Banks.byCode('058')!);
    await cubit.accountNumberChanged('0248214821');
    expect((cubit.state.failure! as ValidationFailure).code, ValidationCode.offline);
    expect(cubit.state.isVerifying, isFalse);
    await cubit.close();
  });
}
