import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/outbox_item.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../wallet/cubit/wallet_cubit.dart';
import '../repository/developer_repository.dart';

class DeveloperCubit extends Cubit<DevSettings> {
  DeveloperCubit({required this.repository, required this.authCubit, this.wallet})
    : super(const DevSettings(simulateOffline: false, loseNextResponse: false, latencyMs: 1200));

  final IDeveloperRepository repository;
  final AuthCubit authCubit;
  final WalletCubit? wallet;

  Future<void> load() async {
    final settings = await repository.load();
    if (!isClosed) emit(settings);
  }

  Future<void> setSimulateOffline(bool value) async {
    await repository.setSimulateOffline(value);
    if (!isClosed) emit(state.copyWith(simulateOffline: value));
  }

  void setLoseNextResponse(bool value) {
    repository.setLoseNextResponse(value);
    if (!isClosed) emit(state.copyWith(loseNextResponse: value));
  }

  Future<void> setLatency(int ms) async {
    await repository.setLatencyMs(ms);
    if (!isClosed) emit(state.copyWith(latencyMs: ms));
  }

  Stream<List<OutboxItem>> watchOutbox() => repository.watchOutbox();

  /// Credits the account server-side, then re-reads the wallet so the new
  /// credit is picked up and the "money received" notification fires.
  Future<void> simulateIncomingPayment() async {
    await repository.simulateIncomingPayment(amountKobo: 2500000, from: 'KUNLE BANKOLE');
    await wallet?.checkForUpdates();
  }

  /// Wipes everything and returns to a signed-out app. The backend reset runs
  /// inside sign-out: after session work has stopped, but while the user is
  /// still signed in (a Firebase reset needs the current user).
  Future<void> resetDemoData() => authCubit.signOut(beforeWipe: repository.resetDemoData);
}
