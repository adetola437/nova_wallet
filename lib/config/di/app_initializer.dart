import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api/backend_admin.dart';
import '../../core/api/fake/fake_nova_server.dart';
import '../../core/api/fake/fake_server_controls.dart';
import '../../core/api/firebase/firebase_nova_service.dart';
import '../../core/api/service/nova_api_service.dart';
import '../../core/auth/biometric_gate.dart';
import '../../core/auth/biometric_signer.dart';
import '../../core/auth/secret_hasher.dart';
import '../../core/network/backend_reachability.dart';
import '../../core/network/firestore_backend_reachability.dart';
import '../../core/network/network_info.dart';
import '../../core/network/network_info_impl.dart';
import '../../core/network/reachability.dart';
import '../../core/notifications/local_notification_service.dart';
import '../../core/notifications/sync_notifier.dart';
import '../../core/session/session_lifecycle.dart';
import '../../core/storage/isar_db.dart';
import '../../core/storage/local_storage.dart';
import '../../core/storage/local_storage_impl.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/storage/secure_storage_impl.dart';
import '../../core/storage/session_store.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/auth/cubit/login_cubit.dart';
import '../../features/auth/cubit/signup_cubit.dart';
import '../../features/auth/cubit/unlock_cubit.dart';
import '../../features/auth/repository/auth_repository.dart';
import '../../features/auth/repository/auth_repository_impl.dart';
import '../../features/beneficiaries/cubit/beneficiaries_cubit.dart';
import '../../features/beneficiaries/cubit/name_enquiry_cubit.dart';
import '../../features/beneficiaries/repository/beneficiary_repository.dart';
import '../../features/beneficiaries/repository/beneficiary_repository_impl.dart';
import '../../features/connectivity/cubit/connectivity_cubit.dart';
import '../../features/developer/cubit/developer_cubit.dart';
import '../../features/developer/repository/developer_repository.dart';
import '../../features/developer/repository/developer_repository_impl.dart';
import '../../core/models/goal_view.dart';
import '../../features/savings/cubit/contribute_cubit.dart';
import '../../features/savings/cubit/create_goal_cubit.dart';
import '../../features/savings/cubit/goal_details_cubit.dart';
import '../../features/savings/cubit/move_to_wallet_cubit.dart';
import '../../features/savings/cubit/savings_cubit.dart';
import '../../features/savings/repository/savings_repository.dart';
import '../../features/savings/repository/savings_repository_impl.dart';
import '../../features/send_money/cubit/send_money_cubit.dart';
import '../../features/settings/cubit/biometric_settings_cubit.dart';
import '../../features/settings/cubit/locale_cubit.dart';
import '../../features/settings/repository/settings_repository.dart';
import '../../features/settings/repository/settings_repository_impl.dart';
import '../../features/sync/cubit/sync_cubit.dart';
import '../../features/transactions/cubit/transaction_details_cubit.dart';
import '../../features/sync/repository/outbox_repository.dart';
import '../../features/sync/repository/outbox_repository_impl.dart';
import '../../features/wallet/cubit/wallet_cubit.dart';
import '../../features/wallet/repository/wallet_repository.dart';
import '../../features/wallet/repository/wallet_repository_impl.dart';
import '../../firebase_options.dart';

export '../../core/navigation/nav_keys.dart';

final GetIt sl = GetIt.instance;

/// Which backend sits behind [NovaApiService]:
/// `firebase` (default — Auth + Cloud Firestore) or `fake` (in-process server
/// for a fully offline demo: `flutter run --dart-define=BACKEND=fake`).
const String backendFlag = String.fromEnvironment('BACKEND', defaultValue: 'firebase');

/// Builds the object graph in dependency order: core → repositories → cubits.
/// Every override exists so tests — and the integration test's simulated app
/// restart — can swap the platform pieces.
class AppInitializer {
  AppInitializer._();

  static SessionLifecycle? _lifecycle;

  static Future<void> init({
    String? directory,
    NetworkInfo? networkInfo,
    SecureStorage? secureStorage,
    BiometricGate? biometricGate,
    SyncNotifier? notifier,
    SharedPreferences? preferences,
    FakeServerControls? controls,
    String backend = backendFlag,
  }) async {
    final prefs = preferences ?? await SharedPreferences.getInstance();
    final dir = directory ?? (await getApplicationDocumentsDirectory()).path;
    final db = await IsarDb.open(directory: dir);

    // ── Core ───────────────────────────────────────────────────────────────
    sl.registerSingleton<SharedPreferences>(prefs);
    sl.registerSingleton<IsarDb>(db);
    sl.registerSingleton<SecretHasher>(SecretHasher());
    sl.registerSingleton<LocalStorage>(LocalStorageImpl(prefs: prefs));
    sl.registerSingleton<SecureStorage>(
      secureStorage ?? SecureStorageImpl(secureStorage: const FlutterSecureStorage()),
    );
    sl.registerSingleton<SessionStore>(SessionStore(secureStorage: sl(), hasher: sl()));
    sl.registerSingleton<NetworkInfo>(networkInfo ?? NetworkInfoImpl());
    sl.registerSingleton<FakeServerControls>(controls ?? FakeServerControls());
    sl.registerSingleton<BiometricGate>(biometricGate ?? SignerBiometricGate(signer: BiometricSigner()));

    if (backend == 'fake') {
      _registerFakeBackend(db);
    } else {
      await _registerFirebaseBackend();
    }

    sl.registerSingleton<Reachability>(Reachability(networkInfo: sl(), controls: sl(), backend: sl()));

    final localNotifications = LocalNotificationService();
    sl.registerSingleton<LocalNotificationService>(localNotifications);
    sl.registerSingleton<SyncNotifier>(notifier ?? localNotifications);

    // ── Repositories ───────────────────────────────────────────────────────
    sl.registerLazySingleton<ISettingsRepository>(() => SettingsRepositoryImpl(localStorage: sl()));
    sl.registerLazySingleton<IAuthRepository>(
      () => AuthRepositoryImpl(remote: sl(), session: sl(), db: sl(), localStorage: sl(), hasher: sl()),
    );
    sl.registerLazySingleton<IOutboxRepository>(() => OutboxRepositoryImpl(db: sl(), api: sl(), session: sl()));
    sl.registerLazySingleton<IWalletRepository>(() => WalletRepositoryImpl(db: sl(), api: sl(), session: sl()));
    sl.registerLazySingleton<IBeneficiaryRepository>(
      () => BeneficiaryRepositoryImpl(db: sl(), api: sl(), session: sl()),
    );
    sl.registerLazySingleton<ISavingsRepository>(() => SavingsRepositoryImpl(db: sl(), api: sl(), session: sl()));
    sl.registerLazySingleton<IDeveloperRepository>(
      () => DeveloperRepositoryImpl(
        localStorage: sl(),
        controls: sl(),
        outbox: sl(),
        admin: sl(),
        db: sl(),
        session: sl(),
      ),
    );

    // ── Cubits ─────────────────────────────────────────────────────────────
    sl.registerSingleton<ConnectivityCubit>(ConnectivityCubit(reachability: sl()));
    sl.registerSingleton<AuthCubit>(AuthCubit(repository: sl(), settings: sl()));
    sl.registerSingleton<LocaleCubit>(LocaleCubit(repository: sl()));
    sl.registerSingleton<SyncCubit>(SyncCubit(outbox: sl(), connectivity: sl(), notifier: sl()));
    sl.registerSingleton<WalletCubit>(WalletCubit(repository: sl(), sync: sl(), notifier: sl()));
    sl.registerSingleton<BeneficiariesCubit>(BeneficiariesCubit(repository: sl()));
    sl.registerSingleton<SavingsCubit>(SavingsCubit(repository: sl()));
    sl.registerSingleton<DeveloperCubit>(DeveloperCubit(repository: sl(), authCubit: sl(), wallet: sl()));

    // One per flow, as Kiba does for PurchaseCubit.
    sl.registerFactory<SignupCubit>(() => SignupCubit(repository: sl(), authCubit: sl()));
    sl.registerFactory<LoginCubit>(() => LoginCubit(repository: sl(), authCubit: sl()));
    sl.registerFactory<UnlockCubit>(
      () => UnlockCubit(repository: sl(), settings: sl(), biometricGate: sl(), authCubit: sl()),
    );
    sl.registerFactory<NameEnquiryCubit>(() => NameEnquiryCubit(repository: sl(), connectivity: sl()));
    sl.registerFactory<CreateGoalCubit>(() => CreateGoalCubit(outbox: sl(), sync: sl(), connectivity: sl()));
    sl.registerFactoryParam<ContributeCubit, GoalView, void>(
      (goal, _) => ContributeCubit(goal: goal, outbox: sl(), auth: sl(), wallet: sl(), sync: sl(), connectivity: sl()),
    );
    sl.registerFactoryParam<MoveToWalletCubit, GoalView, void>(
      (goal, _) => MoveToWalletCubit(goal: goal, outbox: sl(), auth: sl(), sync: sl(), connectivity: sl()),
    );
    sl.registerFactory<GoalDetailsCubit>(() => GoalDetailsCubit(repository: sl()));
    sl.registerFactory<TransactionDetailsCubit>(() => TransactionDetailsCubit(outbox: sl()));
    sl.registerFactory<BiometricSettingsCubit>(() => BiometricSettingsCubit(settings: sl(), gate: sl()));
    sl.registerFactory<SendMoneyCubit>(
      () => SendMoneyCubit(
        outbox: sl(),
        auth: sl(),
        settings: sl(),
        beneficiaries: sl(),
        session: sl(),
        wallet: sl(),
        sync: sl(),
        connectivity: sl(),
        biometricGate: sl(),
      ),
    );

    // ── Start up ───────────────────────────────────────────────────────────
    final api = sl<NovaApiService>();
    if (api is FakeNovaServer) await api.ensureSeeded();
    await sl<DeveloperCubit>().load(); // restores the demo switches
    await sl<LocaleCubit>().load();
    await sl<ConnectivityCubit>().start();
    if (notifier == null) await localNotifications.init();

    _lifecycle = SessionLifecycle(auth: sl(), sync: sl(), wallet: sl(), beneficiaries: sl(), savings: sl())..attach();

    await sl<AuthCubit>().bootstrap();
  }

  static Future<void> _registerFirebaseBackend() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // NON-NEGOTIABLE: Firestore's cache and its offline write queue are off, so
    // the Isar outbox stays the only durable queue. Left on, Firestore would
    // hold a second copy of every queued write — the classic double-send.
    FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);

    final reachability = FirestoreBackendReachability(firestore: FirebaseFirestore.instance);
    final service = FirebaseNovaService(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      controls: sl(),
      hasher: sl(),
      reachability: reachability,
    );
    sl.registerSingleton<BackendReachability>(reachability);
    sl.registerSingleton<NovaApiService>(service);
    sl.registerSingleton<BackendAdmin>(service);
  }

  static void _registerFakeBackend(IsarDb db) {
    final server = FakeNovaServer(
      db: db.server,
      // Reachability depends on the backend's own probe, so the fake gets a
      // Reachability built on the same pieces; for the fake that probe is
      // "always reachable when the device is".
      reachability: Reachability(networkInfo: sl(), controls: sl(), backend: const AlwaysReachable()),
      controls: sl(),
      hasher: sl(),
    );
    sl.registerSingleton<BackendReachability>(const AlwaysReachable());
    sl.registerSingleton<FakeNovaServer>(server);
    sl.registerSingleton<NovaApiService>(server);
    sl.registerSingleton<BackendAdmin>(server);
  }

  /// Waits until every auth transition has started/stopped its cubits.
  static Future<void> get settled => _lifecycle?.settled ?? Future<void>.value();

  /// Tears the graph down. Used by tests, and by the integration test to
  /// simulate the app being killed.
  static Future<void> dispose() async {
    await _lifecycle?.detach();
    _lifecycle = null;
    if (sl.isRegistered<WalletCubit>()) await sl<WalletCubit>().close();
    if (sl.isRegistered<SavingsCubit>()) await sl<SavingsCubit>().close();
    if (sl.isRegistered<BeneficiariesCubit>()) await sl<BeneficiariesCubit>().close();
    if (sl.isRegistered<SyncCubit>()) await sl<SyncCubit>().close();
    if (sl.isRegistered<ConnectivityCubit>()) await sl<ConnectivityCubit>().close();
    if (sl.isRegistered<DeveloperCubit>()) await sl<DeveloperCubit>().close();
    if (sl.isRegistered<AuthCubit>()) await sl<AuthCubit>().close();
    if (sl.isRegistered<LocaleCubit>()) await sl<LocaleCubit>().close();
    if (sl.isRegistered<FakeServerControls>()) await sl<FakeServerControls>().dispose();
    if (sl.isRegistered<IsarDb>()) await sl<IsarDb>().close();
    await sl.reset();
  }
}
