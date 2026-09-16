import 'package:dartz/dartz.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/api/service/dto.dart';
import '../../../core/api/service/nova_api_service.dart';
import '../../../core/auth/secret_hasher.dart';
import '../../../core/models/profile.dart';
import '../../../core/storage/entities/profile_entity.dart';
import '../../../core/storage/isar_db.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/storage/session_store.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl({
    required this.remote,
    required this.session,
    required this.db,
    required this.localStorage,
    required this.hasher,
  });

  final NovaApiService remote;
  final SessionStore session;
  final IsarDb db;
  final LocalStorage localStorage;
  final SecretHasher hasher;

  @override
  Future<Either<Failure, Unit>> requestOtp(String phone) => remote.requestOtp(phone: phone);

  @override
  Future<Either<Failure, Unit>> verifyOtp({required String phone, required String code}) =>
      remote.verifyOtp(phone: phone, code: code);

  @override
  Future<Either<Failure, Profile>> register({
    required String phone,
    required String fullName,
    required String email,
    required String password,
  }) async {
    final result = await remote.register(
      RegisterRequest(phone: phone, fullName: fullName, email: email, password: password),
    );
    return result.fold(left, (dto) async => right(await _startSession(dto)));
  }

  @override
  Future<Either<Failure, Profile>> login({required String identifier, required String password}) async {
    final result = await remote.login(identifier: identifier, password: password);
    return result.fold(left, (dto) async {
      // A different customer on the same device must never inherit the previous
      // one's cached data or queued items.
      final cached = await cachedProfile();
      if (cached != null && cached.phone != dto.profile.phone) await db.clearClient();
      return right(await _startSession(dto));
    });
  }

  Future<Profile> _startSession(SessionDto dto) async {
    await session.saveToken(dto.token);
    final pinHash = dto.pinHash;
    final pinSalt = dto.pinSalt;
    if (pinHash != null && pinSalt != null) {
      await session.savePinHash(hash: pinHash, salt: pinSalt);
    }
    final profile = dto.profile.toModel();
    await _cacheProfile(profile);
    return profile;
  }

  Future<void> _cacheProfile(Profile profile) =>
      db.client.writeTxn(() => db.client.profileEntitys.put(ProfileEntity.fromModel(profile)));

  @override
  Future<Either<Failure, Profile>> verifyBvn(String bvn) async {
    final token = await session.readToken();
    if (token == null) return left(_expired);
    final result = await remote.verifyBvn(token: token, bvn: bvn);
    return result.fold(left, (dto) async {
      final profile = dto.toModel();
      await _cacheProfile(profile);
      return right(profile);
    });
  }

  @override
  Future<Either<Failure, Unit>> createPin(String pin) async {
    final token = await session.readToken();
    if (token == null) return left(_expired);
    final salt = hasher.newSalt();
    final hash = hasher.hash(pin, salt);
    final result = await remote.setPin(token: token, pinHash: hash, pinSalt: salt);
    return result.fold(left, (_) async {
      await session.savePinHash(hash: hash, salt: salt);
      return right(unit);
    });
  }

  @override
  Future<bool> hasSession() async => (await session.readToken()) != null;

  @override
  Future<bool> hasPin() => session.hasPin();

  @override
  Future<Profile?> cachedProfile() async => (await db.client.profileEntitys.get(0))?.toModel();

  @override
  Future<bool> verifyPin(String pin) => session.verifyPin(pin);

  @override
  Future<void> signOut() async {
    await remote.signOut();
    await session.clear();
    await db.clearClient();
    await localStorage.clearSessionScoped();
  }

  static const Failure _expired = BusinessFailure(
    BusinessCode.unauthorized,
    'Your session has expired. Please log in again.',
  );
}
