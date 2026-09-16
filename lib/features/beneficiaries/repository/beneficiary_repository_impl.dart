import 'package:dartz/dartz.dart';
import 'package:isar_community/isar.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/api/service/mappers.dart';
import '../../../core/api/service/nova_api_service.dart';
import '../../../core/models/beneficiary.dart';
import '../../../core/storage/entities/beneficiary_entity.dart';
import '../../../core/storage/isar_db.dart';
import '../../../core/storage/session_store.dart';
import 'beneficiary_repository.dart';

class BeneficiaryRepositoryImpl implements IBeneficiaryRepository {
  BeneficiaryRepositoryImpl({required this.db, required this.api, required this.session, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final IsarDb db;
  final NovaApiService api;
  final SessionStore session;
  final DateTime Function() _clock;

  Isar get _isar => db.client;

  static const Failure _expired = BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.');

  Query<BeneficiaryEntity> get _query =>
      _isar.beneficiaryEntitys.where().sortByLastUsedAtDesc().thenByVerifiedName().build();

  @override
  Stream<List<Beneficiary>> watchAll() =>
      _query.watch(fireImmediately: true).map((rows) => rows.map((e) => e.toModel()).toList());

  @override
  Future<List<Beneficiary>> all() async => (await _query.findAll()).map((e) => e.toModel()).toList();

  @override
  Future<Either<Failure, Beneficiary>> verify({required String bankCode, required String accountNumber}) async {
    final token = await session.readToken();
    if (token == null) return left(_expired);
    final result = await api.nameEnquiry(token: token, bankCode: bankCode, accountNumber: accountNumber);
    return result.fold(
      left,
      (dto) => right(
        Beneficiary(
          accountNumber: dto.accountNumber,
          bankCode: dto.bankCode,
          bankName: dto.bankName,
          verifiedName: dto.accountName,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, Beneficiary>> findNovaUser(String email) async {
    final token = await session.readToken();
    if (token == null) return left(_expired);
    final result = await api.findNovaUser(token: token, email: email);
    return result.fold(
      left,
      (dto) => right(
        Beneficiary(
          accountNumber: dto.accountNumber,
          bankCode: dto.bankCode,
          bankName: dto.bankName,
          verifiedName: dto.accountName,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> save(Beneficiary beneficiary) async {
    try {
      await _isar.writeTxn(
        () => _isar.beneficiaryEntitys.put(
          BeneficiaryEntity()
            ..accountNumber = beneficiary.accountNumber
            ..bankCode = beneficiary.bankCode
            ..bankName = beneficiary.bankName
            ..verifiedName = beneficiary.verifiedName
            ..verifiedAt = _clock()
            ..lastUsedAt = beneficiary.lastUsedAt,
        ),
      );
      return right(unit);
    } on IsarError catch (e) {
      return left(StorageFailure(e.message));
    }
  }

  @override
  Future<void> touch(Beneficiary beneficiary) => _isar.writeTxn(() async {
    final existing = await _isar.beneficiaryEntitys.getByAccountNumberBankCode(
      beneficiary.accountNumber,
      beneficiary.bankCode,
    );
    if (existing == null) return;
    existing.lastUsedAt = _clock();
    await _isar.beneficiaryEntitys.put(existing);
  });

  @override
  Future<Either<Failure, Unit>> refresh() async {
    final token = await session.readToken();
    if (token == null) return left(_expired);
    final result = await api.getBeneficiaries(token: token);
    return result.fold(left, (rows) async {
      final now = _clock();
      await _isar.writeTxn(() async {
        for (final dto in rows) {
          final existing = await _isar.beneficiaryEntitys.getByAccountNumberBankCode(dto.accountNumber, dto.bankCode);
          final entity = beneficiaryEntityFromDto(dto, verifiedAt: now)..lastUsedAt = existing?.lastUsedAt;
          await _isar.beneficiaryEntitys.put(entity);
        }
      });
      return right(unit);
    });
  }
}
