import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../config/flavor/app_constants.dart';
import '../../auth/secret_hasher.dart';
import '../../models/activity_item.dart';
import '../../models/bank.dart';
import '../../money/fees.dart';
import '../../network/reachability.dart';
import '../../utils/masking.dart';
import '../../utils/phone.dart';
import '../backend_admin.dart';
import '../exception/failure.dart';
import '../service/dto.dart';
import '../service/nova_api_service.dart';
import 'demo_seed.dart';
import 'entities/server_entities.dart';
import 'fake_server_controls.dart';

/// In-process stand-in for the NovaPay backend.
///
/// Honest about the things that matter for the brief: it is unreachable when
/// the device is offline, it has latency, it rejects on business rules, and
/// every mutating call is idempotent. The idempotency record is persisted in the
/// same transaction as the money movement, so "applied" and "remembered" can
/// never disagree, even across restarts.
class FakeNovaServer implements NovaApiService, BackendAdmin {
  FakeNovaServer({
    required this.db,
    required this.reachability,
    required this.controls,
    required this.hasher,
    DateTime Function()? clock,
    Random? random,
    Uuid? uuid,
  }) : _clock = clock ?? DateTime.now,
       _random = random ?? Random(),
       _uuid = uuid ?? const Uuid(),
       _seed = DemoSeed(hasher: hasher);

  final Isar db;
  final Reachability reachability;
  final FakeServerControls controls;
  final SecretHasher hasher;
  final DateTime Function() _clock;
  final Random _random;
  final Uuid _uuid;
  final DemoSeed _seed;

  // ── Demo data ───────────────────────────────────────────────────────────

  Future<void> ensureSeeded() async {
    if (await db.serverAccounts.getByPhone(AppConstants.demoPhone) != null) return;
    await db.writeTxn(
      () => _seed.createAccount(
        db,
        phone: AppConstants.demoPhone,
        fullName: 'Tolu Adeyemi',
        email: AppConstants.demoEmail,
        password: AppConstants.demoPassword,
        pin: AppConstants.demoPin,
        tier: 2,
        bvnVerified: true,
        withGoal: true,
        now: _clock(),
      ),
    );
  }

  @override
  Future<void> resetDemo() async {
    await db.writeTxn(() => db.clear());
    await ensureSeeded();
  }

  @override
  Future<void> simulateIncomingPayment({required String token, required int amountKobo, required String from}) async {
    await db.writeTxn(() async {
      final account = await _accountFor(token);
      if (account == null) return;
      account.balanceKobo += amountKobo;
      await db.serverAccounts.put(account);
      await db.serverTransactions.put(
        ServerTransaction()
          ..phone = account.phone
          ..ref = _newRef()
          ..kind = ActivityKind.credit.name
          ..direction = ActivityDirection.credit.name
          ..amountKobo = amountKobo
          ..title = from
          ..subtitle = 'Inward transfer · Moniepoint MFB'
          ..createdAt = _clock(),
      );
    });
  }

  // ── Transport simulation ────────────────────────────────────────────────

  Future<Either<Failure, T>> _call<T>(Future<Either<Failure, T>> Function() body) async {
    if (!await reachability.isReachable) return left(const NetworkFailure());
    final latency = _latency();
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    // Dropped while "in the air": the request never arrived.
    if (!await reachability.isReachable) {
      return left(const NetworkFailure(message: 'Connection lost.', timedOut: true));
    }
    return body();
  }

  Duration _latency() {
    final min = controls.minLatency.inMilliseconds;
    final max = controls.maxLatency.inMilliseconds;
    if (max <= min) return Duration(milliseconds: min);
    return Duration(milliseconds: min + _random.nextInt(max - min + 1));
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  static const _unauthorized = BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.');

  Future<ServerAccount?> _accountFor(String token) async {
    final session = await db.serverSessions.getByToken(token);
    if (session == null) return null;
    return db.serverAccounts.getByPhone(session.phone);
  }

  Future<ServerSession> _newSession(String phone) async {
    final session = ServerSession()
      ..token = 'nova_${_uuid.v4()}'
      ..phone = phone
      ..issuedAt = _clock();
    await db.serverSessions.put(session);
    return session;
  }

  ProfileDto _profile(ServerAccount a) => ProfileDto(
    fullName: a.fullName,
    phone: a.phone,
    email: a.email,
    tier: a.tier,
    bvnVerified: a.bvnVerified,
    accountNumber: a.accountNumber,
  );

  TransactionDto _txnDto(ServerTransaction t) => TransactionDto(
    ref: t.ref,
    kind: ActivityKind.values.byName(t.kind),
    direction: ActivityDirection.values.byName(t.direction),
    amountKobo: t.amountKobo,
    feeKobo: t.feeKobo,
    title: t.title,
    subtitle: t.subtitle,
    narration: t.narration,
    goalClientId: t.goalClientId,
    idempotencyKey: t.idempotencyKey,
    createdAt: t.createdAt,
  );

  GoalDto _goalDto(ServerGoal g) => GoalDto(
    clientId: g.clientId,
    name: g.name,
    targetKobo: g.targetKobo,
    targetDate: g.targetDate,
    savedKobo: g.savedKobo,
    createdAt: g.createdAt,
  );

  String _newRef() => 'NP${_clock().millisecondsSinceEpoch}${_random.nextInt(900) + 100}';

  // ── Auth ────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> requestOtp({required String phone}) => _call(() async {
    if (PhoneNumber.normalize(phone) == null) {
      return left(const BusinessFailure(BusinessCode.invalidCredentials, 'Enter a valid Nigerian phone number.'));
    }
    return right(unit);
  });

  @override
  Future<Either<Failure, Unit>> verifyOtp({required String phone, required String code}) => _call(() async {
    if (code != AppConstants.fakeOtp) {
      return left(const BusinessFailure(BusinessCode.invalidOtp, 'That code is incorrect.'));
    }
    return right(unit);
  });

  @override
  Future<Either<Failure, SessionDto>> register(RegisterRequest request) => _call(() async {
    final phone = PhoneNumber.normalize(request.phone);
    if (phone == null) {
      return left(const BusinessFailure(BusinessCode.invalidCredentials, 'Enter a valid Nigerian phone number.'));
    }
    if (await db.serverAccounts.getByPhone(phone) != null) {
      return left(
        const BusinessFailure(BusinessCode.accountExists, 'An account with this phone number already exists.'),
      );
    }
    late ServerAccount account;
    late ServerSession session;
    await db.writeTxn(() async {
      account = await _seed.createAccount(
        db,
        phone: phone,
        fullName: request.fullName.trim(),
        email: request.email.trim(),
        password: request.password,
        now: _clock(),
      );
      session = await _newSession(phone);
    });
    return right(SessionDto(token: session.token, profile: _profile(account)));
  });

  /// This backend is phone-based: [identifier] is normalised as a phone number.
  @override
  Future<Either<Failure, SessionDto>> login({required String identifier, required String password}) => _call(() async {
    final normalized = PhoneNumber.normalize(identifier);
    final account = normalized == null ? null : await db.serverAccounts.getByPhone(normalized);
    if (account == null || !hasher.verify(password, account.passwordSalt, account.passwordHash)) {
      return left(const BusinessFailure(BusinessCode.invalidCredentials, 'Phone number or password is incorrect.'));
    }
    final session = await db.writeTxn(() => _newSession(account.phone));
    return right(
      SessionDto(token: session.token, profile: _profile(account), pinHash: account.pinHash, pinSalt: account.pinSalt),
    );
  });

  /// Sessions here are plain tokens the device forgets; nothing to end.
  @override
  Future<void> signOut() async {}

  @override
  Future<Either<Failure, Unit>> setPin({required String token, required String pinHash, required String pinSalt}) =>
      _call(() async {
        final account = await _accountFor(token);
        if (account == null) return left(_unauthorized);
        account
          ..pinHash = pinHash
          ..pinSalt = pinSalt;
        await db.writeTxn(() => db.serverAccounts.put(account));
        return right(unit);
      });

  @override
  Future<Either<Failure, ProfileDto>> verifyBvn({required String token, required String bvn}) => _call(() async {
    final account = await _accountFor(token);
    if (account == null) return left(_unauthorized);
    if (!RegExp(r'^[1-9]\d{10}$').hasMatch(bvn)) {
      return left(const BusinessFailure(BusinessCode.invalidBvn, "We couldn't verify this BVN."));
    }
    account
      ..tier = 2
      ..bvnVerified = true;
    await db.writeTxn(() => db.serverAccounts.put(account));
    return right(_profile(account));
  });

  // ── Reads ───────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, WalletDto>> getWallet({required String token}) => _call(() async {
    final account = await _accountFor(token);
    if (account == null) return left(_unauthorized);
    return right(WalletDto(balanceKobo: account.balanceKobo, profile: _profile(account)));
  });

  @override
  Future<Either<Failure, List<TransactionDto>>> getTransactions({required String token, int limit = 200}) =>
      _call(() async {
        final account = await _accountFor(token);
        if (account == null) return left(_unauthorized);
        final rows = await db.serverTransactions
            .filter()
            .phoneEqualTo(account.phone)
            .sortByCreatedAtDesc()
            .limit(limit)
            .findAll();
        return right(rows.map(_txnDto).toList());
      });

  @override
  Future<Either<Failure, List<BeneficiaryDto>>> getBeneficiaries({required String token}) => _call(() async {
    final account = await _accountFor(token);
    if (account == null) return left(_unauthorized);
    final rows = await db.serverBeneficiarys.filter().phoneEqualTo(account.phone).findAll();
    return right([
      for (final b in rows)
        BeneficiaryDto(
          accountNumber: b.accountNumber,
          bankCode: b.bankCode,
          bankName: b.bankName,
          accountName: b.accountName,
        ),
    ]);
  });

  @override
  Future<Either<Failure, BeneficiaryDto>> nameEnquiry({
    required String token,
    required String bankCode,
    required String accountNumber,
  }) => _call(() async {
    if (await _accountFor(token) == null) return left(_unauthorized);
    final name = DemoSeed.lookupName(bankCode: bankCode, accountNumber: accountNumber);
    if (name == null) {
      return left(
        const BusinessFailure(BusinessCode.invalidAccount, "We couldn't find this account. Check the number and bank."),
      );
    }
    return right(
      BeneficiaryDto(
        accountNumber: accountNumber,
        bankCode: bankCode,
        bankName: Banks.byCode(bankCode)!.name,
        accountName: name,
      ),
    );
  });

  @override
  Future<Either<Failure, BeneficiaryDto>> findNovaUser({required String token, required String email}) =>
      _call(() async {
        final me = await _accountFor(token);
        if (me == null) return left(_unauthorized);
        final needle = email.trim().toLowerCase();
        if (me.email.toLowerCase() == needle) {
          return left(const BusinessFailure(BusinessCode.selfTransfer, "You can't send money to yourself."));
        }
        final other = await db.serverAccounts.filter().emailEqualTo(needle, caseSensitive: false).findFirst();
        if (other == null) {
          return left(const BusinessFailure(BusinessCode.invalidAccount, 'No NovaWallet user has this email.'));
        }
        return right(
          BeneficiaryDto(
            accountNumber: other.accountNumber,
            bankCode: Banks.novaWallet.code,
            bankName: Banks.novaWallet.name,
            accountName: other.fullName.toUpperCase(),
          ),
        );
      });

  @override
  Future<Either<Failure, List<GoalDto>>> getGoals({required String token}) => _call(() async {
    final account = await _accountFor(token);
    if (account == null) return left(_unauthorized);
    final rows = await db.serverGoals.filter().phoneEqualTo(account.phone).findAll();
    return right(rows.map(_goalDto).toList());
  });

  // ── Mutations ───────────────────────────────────────────────────────────

  /// Runs [apply] at most once per [idempotencyKey].
  ///
  /// Lookup, money movement and the idempotency record share ONE write
  /// transaction. A replay (same key) returns the stored JSON, so the first
  /// response and every replay are byte-identical, rejections included.
  Future<Either<Failure, MutationResultDto>> _mutate({
    required String token,
    required String idempotencyKey,
    required String endpoint,
    required Future<Either<BusinessFailure, MutationResultDto>> Function(ServerAccount account) apply,
  }) => _call(() async {
    final account = await _accountFor(token);
    if (account == null) return left(_unauthorized);

    final stored = await db.writeTxn<String>(() async {
      final existing = await db.processedRequests.getByIdempotencyKey(idempotencyKey);
      if (existing != null) return existing.responseJson;

      final outcome = await apply(account);
      final json = _encode(outcome);
      await db.processedRequests.put(
        ProcessedRequest()
          ..idempotencyKey = idempotencyKey
          ..phone = account.phone
          ..endpoint = endpoint
          ..responseJson = json
          ..processedAt = _clock(),
      );
      return json;
    });

    if (controls.loseNextResponse) {
      controls.loseNextResponse = false;
      return left(const NetworkFailure(message: 'Request timed out.', timedOut: true));
    }
    return _decode(stored);
  });

  String _encode(Either<BusinessFailure, MutationResultDto> outcome) => jsonEncode(
    outcome.fold(
      (f) => {'ok': false, 'code': f.code.name, 'message': f.message},
      (r) => {'ok': true, 'result': r.toJson()},
    ),
  );

  Either<Failure, MutationResultDto> _decode(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    if (map['ok'] == true) {
      return right(MutationResultDto.fromJson(map['result'] as Map<String, dynamic>));
    }
    return left(BusinessFailure(BusinessCode.values.byName(map['code'] as String), map['message'] as String));
  }

  @override
  Future<Either<Failure, MutationResultDto>> transfer({
    required String token,
    required String idempotencyKey,
    required TransferRequest request,
  }) => _mutate(
    token: token,
    idempotencyKey: idempotencyKey,
    endpoint: 'transfer',
    apply: (account) async {
      if (Banks.isNovaWallet(request.bankCode)) return _novaTransfer(account, idempotencyKey, request);
      final name = DemoSeed.lookupName(bankCode: request.bankCode, accountNumber: request.accountNumber);
      if (name == null) {
        return left(const BusinessFailure(BusinessCode.invalidAccount, "The recipient's account could not be found."));
      }
      final cap = account.tier >= 2 ? AppConstants.tier2SingleSendCapKobo : AppConstants.tier1SingleSendCapKobo;
      if (request.amountKobo > cap) {
        return left(const BusinessFailure(BusinessCode.tierLimitExceeded, 'This amount is above your transfer limit.'));
      }
      final fee = Fees.transferFeeKobo(request.amountKobo);
      final debit = request.amountKobo + fee;
      if (debit > account.balanceKobo) {
        return left(const BusinessFailure(BusinessCode.insufficientFunds, 'Insufficient funds when we tried to send.'));
      }

      account.balanceKobo -= debit;
      await db.serverAccounts.put(account);
      final txn = ServerTransaction()
        ..phone = account.phone
        ..ref = _newRef()
        ..kind = ActivityKind.transfer.name
        ..direction = ActivityDirection.debit.name
        ..amountKobo = request.amountKobo
        ..feeKobo = fee
        ..title = name
        ..subtitle = '${request.bankName} · ${Masking.account(request.accountNumber)}'
        ..narration = request.narration
        ..idempotencyKey = idempotencyKey
        ..createdAt = _clock();
      await db.serverTransactions.put(txn);
      return right(MutationResultDto(ref: txn.ref, balanceAfterKobo: account.balanceKobo, transaction: _txnDto(txn)));
    },
  );

  /// Wallet to wallet: the sender's debit, the recipient's credit and both
  /// receipts land in the same write transaction as the idempotency record.
  Future<Either<BusinessFailure, MutationResultDto>> _novaTransfer(
    ServerAccount sender,
    String idempotencyKey,
    TransferRequest request,
  ) async {
    final recipient = await db.serverAccounts.filter().accountNumberEqualTo(request.accountNumber).findFirst();
    if (recipient == null) {
      return left(const BusinessFailure(BusinessCode.invalidAccount, "The recipient's wallet could not be found."));
    }
    if (recipient.phone == sender.phone) {
      return left(const BusinessFailure(BusinessCode.selfTransfer, "You can't send money to yourself."));
    }
    final cap = sender.tier >= 2 ? AppConstants.tier2SingleSendCapKobo : AppConstants.tier1SingleSendCapKobo;
    if (request.amountKobo > cap) {
      return left(const BusinessFailure(BusinessCode.tierLimitExceeded, 'This amount is above your transfer limit.'));
    }
    if (request.amountKobo > sender.balanceKobo) {
      return left(const BusinessFailure(BusinessCode.insufficientFunds, 'Insufficient funds when we tried to send.'));
    }

    final ref = _newRef();
    final now = _clock();
    sender.balanceKobo -= request.amountKobo;
    recipient.balanceKobo += request.amountKobo;
    await db.serverAccounts.putAll([sender, recipient]);

    final debit = ServerTransaction()
      ..phone = sender.phone
      ..ref = ref
      ..kind = ActivityKind.transfer.name
      ..direction = ActivityDirection.debit.name
      ..amountKobo = request.amountKobo
      ..title = recipient.fullName.toUpperCase()
      ..subtitle = '${Banks.novaWallet.name} · ${Masking.account(recipient.accountNumber)}'
      ..narration = request.narration
      ..idempotencyKey = idempotencyKey
      ..createdAt = now;
    final credit = ServerTransaction()
      ..phone = recipient.phone
      ..ref = '${ref}IN'
      ..kind = ActivityKind.credit.name
      ..direction = ActivityDirection.credit.name
      ..amountKobo = request.amountKobo
      ..title = sender.fullName.toUpperCase()
      ..subtitle = '${Banks.novaWallet.name} transfer'
      ..narration = request.narration
      ..createdAt = now;
    await db.serverTransactions.putAll([debit, credit]);
    return right(MutationResultDto(ref: ref, balanceAfterKobo: sender.balanceKobo, transaction: _txnDto(debit)));
  }

  @override
  Future<Either<Failure, MutationResultDto>> createGoal({
    required String token,
    required String idempotencyKey,
    required CreateGoalRequest request,
  }) => _mutate(
    token: token,
    idempotencyKey: idempotencyKey,
    endpoint: 'createGoal',
    apply: (account) async {
      final goal =
          await db.serverGoals.getByClientId(request.clientId) ??
          (ServerGoal()
            ..clientId = request.clientId
            ..phone = account.phone
            ..name = request.name
            ..targetKobo = request.targetKobo
            ..targetDate = request.targetDate
            ..createdAt = _clock());
      await db.serverGoals.put(goal);
      return right(
        MutationResultDto(ref: 'GOAL-${goal.clientId}', balanceAfterKobo: account.balanceKobo, goal: _goalDto(goal)),
      );
    },
  );

  @override
  Future<Either<Failure, MutationResultDto>> contribute({
    required String token,
    required String idempotencyKey,
    required ContributeRequest request,
  }) => _mutate(
    token: token,
    idempotencyKey: idempotencyKey,
    endpoint: 'contribute',
    apply: (account) async {
      final goal = await db.serverGoals.getByClientId(request.goalClientId);
      if (goal == null || goal.phone != account.phone) {
        return left(const BusinessFailure(BusinessCode.goalNotFound, 'This savings goal no longer exists.'));
      }
      if (request.amountKobo > account.balanceKobo) {
        return left(const BusinessFailure(BusinessCode.insufficientFunds, 'Insufficient funds when we tried to save.'));
      }

      account.balanceKobo -= request.amountKobo;
      goal.savedKobo += request.amountKobo;
      await db.serverAccounts.put(account);
      await db.serverGoals.put(goal);
      final txn = ServerTransaction()
        ..phone = account.phone
        ..ref = _newRef()
        ..kind = ActivityKind.contribution.name
        ..direction = ActivityDirection.debit.name
        ..amountKobo = request.amountKobo
        ..title = goal.name
        ..subtitle = 'NovaSave'
        ..goalClientId = goal.clientId
        ..idempotencyKey = idempotencyKey
        ..createdAt = _clock();
      await db.serverTransactions.put(txn);
      return right(
        MutationResultDto(
          ref: txn.ref,
          balanceAfterKobo: account.balanceKobo,
          transaction: _txnDto(txn),
          goal: _goalDto(goal),
        ),
      );
    },
  );

  @override
  Future<Either<Failure, MutationResultDto>> moveToWallet({
    required String token,
    required String idempotencyKey,
    required MoveToWalletRequest request,
  }) => _mutate(
    token: token,
    idempotencyKey: idempotencyKey,
    endpoint: 'moveToWallet',
    apply: (account) async {
      final goal = await db.serverGoals.getByClientId(request.goalClientId);
      if (goal == null || goal.phone != account.phone) {
        return left(const BusinessFailure(BusinessCode.goalNotFound, 'This savings goal no longer exists.'));
      }
      if (request.amountKobo > goal.savedKobo) {
        return left(const BusinessFailure(BusinessCode.insufficientFunds, 'This goal no longer holds that much.'));
      }

      final computedFee = Fees.goalBreakFeeKobo(
        amountKobo: request.amountKobo,
        savedKobo: goal.savedKobo,
        targetKobo: goal.targetKobo,
        targetDate: goal.targetDate,
        now: _clock(),
      );
      final fee = computedFee < request.agreedFeeKobo ? computedFee : request.agreedFeeKobo;

      goal.savedKobo -= request.amountKobo;
      account.balanceKobo += request.amountKobo - fee;
      await db.serverAccounts.put(account);
      await db.serverGoals.put(goal);
      final txn = ServerTransaction()
        ..phone = account.phone
        ..ref = _newRef()
        ..kind = ActivityKind.goalWithdrawal.name
        ..direction = ActivityDirection.credit.name
        // What reached the wallet; the break fee is recorded beside it.
        ..amountKobo = request.amountKobo - fee
        ..feeKobo = fee
        ..title = goal.name
        ..subtitle = 'NovaSave'
        ..goalClientId = goal.clientId
        ..idempotencyKey = idempotencyKey
        ..createdAt = _clock();
      await db.serverTransactions.put(txn);
      return right(
        MutationResultDto(
          ref: txn.ref,
          balanceAfterKobo: account.balanceKobo,
          transaction: _txnDto(txn),
          goal: _goalDto(goal),
        ),
      );
    },
  );
}
