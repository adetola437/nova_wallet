import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../config/flavor/app_constants.dart';
import '../../auth/secret_hasher.dart';
import '../../models/activity_item.dart';
import '../../models/bank.dart';
import '../../money/fees.dart';
import '../../network/firestore_backend_reachability.dart';
import '../../utils/masking.dart';
import '../../utils/phone.dart';
import '../backend_admin.dart';
import '../exception/failure.dart';
import '../fake/demo_seed.dart';
import '../fake/fake_server_controls.dart';
import '../service/dto.dart';
import '../service/nova_api_service.dart';
import 'firestore_paths.dart';

/// The real backend: Firebase Auth for sessions, Cloud Firestore for money.
///
/// Exactly-once on this backend, in one paragraph: every mutation runs inside a
/// Firestore transaction that FIRST reads `users/{uid}/processed/{key}`. If
/// that document exists, the stored response is returned and nothing moves.
/// Otherwise the balance, the goal, the receipt and the processed document are
/// written together, atomically — and the security rules forbid that document
/// from ever being updated or deleted. Firestore transactions need a live
/// connection and fail fast offline, which is what the outbox wants: a clean
/// [NetworkFailure] to retry later with the same key.
///
/// Firestore's own offline persistence MUST be off (see AppInitializer), so
/// the Isar outbox stays the only durable queue.
class FirebaseNovaService implements NovaApiService, BackendAdmin {
  FirebaseNovaService({
    required this.auth,
    required this.firestore,
    required this.controls,
    required this.hasher,
    this.reachability,
    DateTime Function()? clock,
    this.timeout = const Duration(seconds: 12),
  }) : _clock = clock ?? DateTime.now,
       paths = FirestorePaths(firestore);

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FakeServerControls controls;
  final SecretHasher hasher;

  /// Told about hard network errors so the offline banner appears immediately.
  final FirestoreBackendReachability? reachability;

  final DateTime Function() _clock;
  final Duration timeout;
  final FirestorePaths paths;

  static const _serverSource = GetOptions(source: Source.server);
  static const Failure _expired = BusinessFailure(
    BusinessCode.unauthorized,
    'Your session has expired. Please log in again.',
  );

  // ── Plumbing ────────────────────────────────────────────────────────────

  Future<Either<Failure, T>> _call<T>(Future<Either<Failure, T>> Function() body) async {
    if (controls.simulateOffline) return left(const NetworkFailure());
    try {
      return await body().timeout(timeout);
    } on TimeoutException {
      reachability?.reportUnreachable();
      return left(const NetworkFailure(message: 'Request timed out.', timedOut: true));
    } on FirebaseAuthException catch (e) {
      return left(_mapAuthError(e));
    } on FirebaseException catch (e) {
      return left(_mapFirestoreError(e));
    }
  }

  Failure _mapAuthError(FirebaseAuthException e) => switch (e.code) {
    'network-request-failed' => const NetworkFailure(),
    'email-already-in-use' => const BusinessFailure(
      BusinessCode.accountExists,
      'An account with this email already exists.',
    ),
    'invalid-credential' ||
    'wrong-password' ||
    'user-not-found' ||
    'invalid-email' => const BusinessFailure(BusinessCode.invalidCredentials, 'Email or password is incorrect.'),
    'too-many-requests' => const BusinessFailure(
      BusinessCode.invalidCredentials,
      'Too many attempts. Try again later.',
    ),
    'operation-not-allowed' => const BusinessFailure(
      BusinessCode.invalidCredentials,
      'Email sign-in is not enabled for this Firebase project.',
    ),
    _ => BusinessFailure(BusinessCode.invalidCredentials, e.message ?? 'Sign-in failed.'),
  };

  Failure _mapFirestoreError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.');
      case 'unavailable':
      case 'deadline-exceeded':
      case 'aborted': // transaction contention: safe to retry with the same key
        reachability?.reportUnreachable();
        return NetworkFailure(message: e.message ?? 'Network error.', timedOut: e.code != 'aborted');
      default:
        return NetworkFailure(message: e.message ?? 'Network error.');
    }
  }

  String? _uid(String token) {
    final user = auth.currentUser;
    if (user == null || user.uid != token) return null;
    return user.uid;
  }

  /// Deterministic: the same key always names the same receipt document.
  String _refFor(String key) => 'NP${key.replaceAll('-', '').substring(0, 12).toUpperCase()}';

  // ── Auth ────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> requestOtp({required String phone}) async => PhoneNumber.normalize(phone) == null
      ? left(const BusinessFailure(BusinessCode.invalidCredentials, 'Enter a valid Nigerian phone number.'))
      : right(unit);

  @override
  Future<Either<Failure, Unit>> verifyOtp({required String phone, required String code}) async =>
      code == AppConstants.fakeOtp
      ? right(unit)
      : left(const BusinessFailure(BusinessCode.invalidOtp, 'That code is incorrect.'));

  @override
  Future<Either<Failure, SessionDto>> register(RegisterRequest request) => _call(() async {
    final phone = PhoneNumber.normalize(request.phone);
    if (phone == null) {
      return left(const BusinessFailure(BusinessCode.invalidCredentials, 'Enter a valid Nigerian phone number.'));
    }
    final credential = await auth.createUserWithEmailAndPassword(
      email: request.email.trim(),
      password: request.password,
    );
    final uid = credential.user!.uid;
    final profile = ProfileDto(
      fullName: request.fullName.trim(),
      phone: phone,
      email: request.email.trim(),
      tier: 1,
      bvnVerified: false,
      accountNumber: phone.substring(1),
    );
    await _seedNewUser(uid, profile);
    await _publishDirectory(uid, profile);
    return right(SessionDto(token: uid, profile: profile));
  });

  /// [identifier] is an email on this backend.
  ///
  /// Demo convenience: the very first login with the published demo credentials
  /// creates that account (with its PIN and history), so a fresh Firebase
  /// project demos without a manual setup step. Any other failure is returned.
  @override
  Future<Either<Failure, SessionDto>> login({required String identifier, required String password}) => _call(() async {
    final email = identifier.trim();
    UserCredential credential;
    try {
      credential = await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final isDemo = email == AppConstants.demoEmail && password == AppConstants.demoPassword;
      if (!isDemo || !(e.code == 'user-not-found' || e.code == 'invalid-credential')) rethrow;
      credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      await _seedNewUser(
        credential.user!.uid,
        const ProfileDto(
          fullName: 'Tolu Adeyemi',
          phone: AppConstants.demoPhone,
          email: AppConstants.demoEmail,
          tier: 2,
          bvnVerified: true,
          accountNumber: '8012345678',
        ),
        pin: AppConstants.demoPin,
      );
    }
    final uid = credential.user!.uid;
    final data = (await paths.user(uid).get(_serverSource)).data();
    if (data == null) {
      return left(const BusinessFailure(BusinessCode.invalidCredentials, 'This account has no profile yet.'));
    }
    // Accounts created before NovaWallet transfers existed get listed on login.
    await _publishDirectory(uid, _profileFrom(data));
    return right(
      SessionDto(
        token: uid,
        profile: _profileFrom(data),
        pinHash: data['pinHash'] as String?,
        pinSalt: data['pinSalt'] as String?,
      ),
    );
  });

  @override
  Future<void> signOut() => auth.signOut();

  ProfileDto _profileFrom(Map<String, dynamic> d) => ProfileDto(
    fullName: d['fullName'] as String,
    phone: d['phone'] as String,
    email: d['email'] as String,
    tier: (d['tier'] as num).toInt(),
    bvnVerified: d['bvnVerified'] as bool? ?? false,
    accountNumber: d['accountNumber'] as String,
  );

  @override
  Future<Either<Failure, Unit>> setPin({required String token, required String pinHash, required String pinSalt}) =>
      _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        // Only the hash travels; the PIN never leaves the device.
        await paths.user(uid).update({'pinHash': pinHash, 'pinSalt': pinSalt});
        return right(unit);
      });

  @override
  Future<Either<Failure, ProfileDto>> verifyBvn({required String token, required String bvn}) => _call(() async {
    final uid = _uid(token);
    if (uid == null) return left(_expired);
    if (!RegExp(r'^[1-9]\d{10}$').hasMatch(bvn)) {
      return left(const BusinessFailure(BusinessCode.invalidBvn, "We couldn't verify this BVN."));
    }
    await paths.user(uid).update({'tier': 2, 'bvnVerified': true});
    final snap = await paths.user(uid).get(_serverSource);
    return right(_profileFrom(snap.data()!));
  });

  // ── Reads ───────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, WalletDto>> getWallet({required String token}) => _call(() async {
    final uid = _uid(token);
    if (uid == null) return left(_expired);
    final data = (await paths.user(uid).get(_serverSource)).data();
    if (data == null) return left(_expired);
    return right(WalletDto(balanceKobo: ((data['balanceKobo'] as num?) ?? 0).toInt(), profile: _profileFrom(data)));
  });

  @override
  Future<Either<Failure, List<TransactionDto>>> getTransactions({required String token, int limit = 200}) =>
      _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        final query = await paths
            .transactions(uid)
            .orderBy('createdAt', descending: true)
            .limit(limit)
            .get(_serverSource);
        return right(query.docs.map((d) => _txnFrom(d.data())).toList());
      });

  TransactionDto _txnFrom(Map<String, dynamic> d) => TransactionDto(
    ref: d['ref'] as String,
    kind: ActivityKind.values.byName(d['kind'] as String),
    direction: ActivityDirection.values.byName(d['direction'] as String),
    amountKobo: (d['amountKobo'] as num).toInt(),
    feeKobo: ((d['feeKobo'] as num?) ?? 0).toInt(),
    title: d['title'] as String,
    subtitle: d['subtitle'] as String?,
    narration: d['narration'] as String?,
    goalClientId: d['goalClientId'] as String?,
    idempotencyKey: d['idempotencyKey'] as String?,
    createdAt: DateTime.fromMillisecondsSinceEpoch((d['createdAt'] as num).toInt()),
  );

  GoalDto _goalFrom(String clientId, Map<String, dynamic> d) => GoalDto(
    clientId: clientId,
    name: d['name'] as String,
    targetKobo: (d['targetKobo'] as num).toInt(),
    targetDate: DateTime.fromMillisecondsSinceEpoch((d['targetDate'] as num).toInt()),
    savedKobo: ((d['savedKobo'] as num?) ?? 0).toInt(),
    createdAt: DateTime.fromMillisecondsSinceEpoch((d['createdAt'] as num).toInt()),
  );

  @override
  Future<Either<Failure, List<BeneficiaryDto>>> getBeneficiaries({required String token}) => _call(() async {
    final uid = _uid(token);
    if (uid == null) return left(_expired);
    final query = await paths.beneficiaries(uid).get(_serverSource);
    return right([
      for (final doc in query.docs)
        BeneficiaryDto(
          accountNumber: doc.data()['accountNumber'] as String,
          bankCode: doc.data()['bankCode'] as String,
          bankName: doc.data()['bankName'] as String,
          accountName: doc.data()['accountName'] as String,
        ),
    ]);
  });

  /// Both backends resolve names with the same deterministic directory, so no
  /// public collection has to be seeded with admin credentials. A production
  /// NIP name enquiry would be a server call here.
  @override
  Future<Either<Failure, BeneficiaryDto>> nameEnquiry({
    required String token,
    required String bankCode,
    required String accountNumber,
  }) => _call(() async {
    if (_uid(token) == null) return left(_expired);
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
  Future<Either<Failure, List<GoalDto>>> getGoals({required String token}) => _call(() async {
    final uid = _uid(token);
    if (uid == null) return left(_expired);
    final query = await paths.goals(uid).get(_serverSource);
    return right([for (final doc in query.docs) _goalFrom(doc.id, doc.data())]);
  });

  // ── Mutations ───────────────────────────────────────────────────────────

  /// Runs [body] at most once per [key], inside one Firestore transaction.
  ///
  /// [body] may READ (its reads come after ours, still before any write) and
  /// then write through the transaction. Rejections are stored too, so a replay
  /// returns the same refusal instead of being re-evaluated.
  Future<Either<Failure, MutationResultDto>> _idempotent({
    required String token,
    required String key,
    required Future<Either<BusinessFailure, MutationResultDto>> Function(
      Transaction txn,
      DocumentReference<Map<String, dynamic>> userRef,
      Map<String, dynamic> user,
      String ref,
    )
    body,
  }) => _call(() async {
    final uid = _uid(token);
    if (uid == null) return left(_expired);

    final userRef = paths.user(uid);
    final processedRef = paths.processed(uid, key);
    final ref = _refFor(key);

    final stored = await firestore.runTransaction<Map<String, dynamic>>((txn) async {
      // 1. Has this exact intent already been applied?
      final processedSnap = await txn.get(processedRef);
      if (processedSnap.exists) return processedSnap.data()!;

      // 2. No: read the account, then let the endpoint do its work.
      final userSnap = await txn.get(userRef);
      if (!userSnap.exists) {
        return {'ok': false, 'code': BusinessCode.unauthorized.name, 'message': 'Account not found.'};
      }
      final outcome = await body(txn, userRef, userSnap.data()!, ref);

      // 3. Record the outcome in the SAME transaction as the money move.
      final record = outcome.fold(
        (failure) => <String, dynamic>{
          'ok': false,
          'code': failure.code.name,
          'message': failure.message,
          'at': _clock().millisecondsSinceEpoch,
        },
        (result) => <String, dynamic>{
          'ok': true,
          'ref': result.ref,
          'result': result.toJson(),
          'at': _clock().millisecondsSinceEpoch,
        },
      );
      txn.set(processedRef, record);
      return record;
    }, timeout: timeout);

    // The lost-response demo switch: the server committed, the phone doesn't
    // hear about it. The replay is what proves the guarantee.
    if (controls.loseNextResponse) {
      controls.loseNextResponse = false;
      return left(const NetworkFailure(message: 'Request timed out.', timedOut: true));
    }

    if (stored['ok'] == false) {
      return left(BusinessFailure(BusinessCode.values.byName(stored['code'] as String), stored['message'] as String));
    }
    return right(MutationResultDto.fromJson(Map<String, dynamic>.from(stored['result'] as Map)));
  });

  @override
  Future<Either<Failure, MutationResultDto>> transfer({
    required String token,
    required String idempotencyKey,
    required TransferRequest request,
  }) {
    final name = DemoSeed.lookupName(bankCode: request.bankCode, accountNumber: request.accountNumber);
    final fee = Fees.transferFeeKobo(request.amountKobo, bankCode: request.bankCode);
    final debit = request.amountKobo + fee;
    final createdAt = _clock().millisecondsSinceEpoch;

    return _idempotent(
      token: token,
      key: idempotencyKey,
      body: (txn, userRef, user, ref) async {
        if (Banks.isNovaWallet(request.bankCode)) {
          return _novaTransfer(
            txn: txn,
            userRef: userRef,
            user: user,
            ref: ref,
            idempotencyKey: idempotencyKey,
            request: request,
            createdAt: createdAt,
          );
        }
        if (name == null) {
          return left(
            const BusinessFailure(BusinessCode.invalidAccount, "The recipient's account could not be found."),
          );
        }
        final tier = ((user['tier'] as num?) ?? 1).toInt();
        final cap = tier >= 2 ? AppConstants.tier2SingleSendCapKobo : AppConstants.tier1SingleSendCapKobo;
        if (request.amountKobo > cap) {
          return left(
            const BusinessFailure(BusinessCode.tierLimitExceeded, 'This amount is above your transfer limit.'),
          );
        }
        final balance = ((user['balanceKobo'] as num?) ?? 0).toInt();
        if (debit > balance) {
          return left(
            const BusinessFailure(BusinessCode.insufficientFunds, 'Insufficient funds when we tried to send.'),
          );
        }

        final balanceAfter = balance - debit;
        final receipt = <String, dynamic>{
          'ref': ref,
          'kind': ActivityKind.transfer.name,
          'direction': ActivityDirection.debit.name,
          'amountKobo': request.amountKobo,
          'feeKobo': fee,
          'title': name,
          'subtitle': '${request.bankName} · ${Masking.account(request.accountNumber)}',
          'narration': request.narration,
          'idempotencyKey': idempotencyKey,
          'createdAt': createdAt,
        };
        txn.update(userRef, {'balanceKobo': balanceAfter});
        txn.set(paths.transactions(userRef.id).doc(ref), receipt);

        return right(MutationResultDto(ref: ref, balanceAfterKobo: balanceAfter, transaction: _txnFrom(receipt)));
      },
    );
  }

  @override
  Future<Either<Failure, MutationResultDto>> createGoal({
    required String token,
    required String idempotencyKey,
    required CreateGoalRequest request,
  }) {
    final createdAt = _clock().millisecondsSinceEpoch;
    return _idempotent(
      token: token,
      key: idempotencyKey,
      body: (txn, userRef, user, ref) async {
        final goalRef = paths.goals(userRef.id).doc(request.clientId);
        final existing = await txn.get(goalRef); // read before any write
        final goal = <String, dynamic>{
          'name': request.name,
          'targetKobo': request.targetKobo,
          'targetDate': request.targetDate.millisecondsSinceEpoch,
          'savedKobo': ((existing.data()?['savedKobo'] as num?) ?? 0).toInt(),
          'createdAt': ((existing.data()?['createdAt'] as num?) ?? createdAt).toInt(),
        };
        txn.set(goalRef, goal);
        return right(
          MutationResultDto(
            ref: 'GOAL-${request.clientId}',
            balanceAfterKobo: ((user['balanceKobo'] as num?) ?? 0).toInt(),
            goal: _goalFrom(request.clientId, goal),
          ),
        );
      },
    );
  }

  @override
  Future<Either<Failure, MutationResultDto>> contribute({
    required String token,
    required String idempotencyKey,
    required ContributeRequest request,
  }) {
    final createdAt = _clock().millisecondsSinceEpoch;
    return _idempotent(
      token: token,
      key: idempotencyKey,
      body: (txn, userRef, user, ref) async {
        final goalRef = paths.goals(userRef.id).doc(request.goalClientId);
        final goalData = (await txn.get(goalRef)).data(); // read before any write
        if (goalData == null) {
          return left(const BusinessFailure(BusinessCode.goalNotFound, 'This savings goal no longer exists.'));
        }
        final balance = ((user['balanceKobo'] as num?) ?? 0).toInt();
        if (request.amountKobo > balance) {
          return left(
            const BusinessFailure(BusinessCode.insufficientFunds, 'Insufficient funds when we tried to save.'),
          );
        }

        final balanceAfter = balance - request.amountKobo;
        final savedAfter = ((goalData['savedKobo'] as num?) ?? 0).toInt() + request.amountKobo;
        final receipt = <String, dynamic>{
          'ref': ref,
          'kind': ActivityKind.contribution.name,
          'direction': ActivityDirection.debit.name,
          'amountKobo': request.amountKobo,
          'feeKobo': 0,
          'title': goalData['name'] as String,
          'subtitle': 'NovaSave',
          'goalClientId': request.goalClientId,
          'idempotencyKey': idempotencyKey,
          'createdAt': createdAt,
        };
        txn.update(userRef, {'balanceKobo': balanceAfter});
        txn.update(goalRef, {'savedKobo': savedAfter});
        txn.set(paths.transactions(userRef.id).doc(ref), receipt);

        return right(
          MutationResultDto(
            ref: ref,
            balanceAfterKobo: balanceAfter,
            goal: _goalFrom(request.goalClientId, {...goalData, 'savedKobo': savedAfter}),
            transaction: _txnFrom(receipt),
          ),
        );
      },
    );
  }

  @override
  Future<Either<Failure, MutationResultDto>> moveToWallet({
    required String token,
    required String idempotencyKey,
    required MoveToWalletRequest request,
  }) {
    final createdAt = _clock().millisecondsSinceEpoch;
    return _idempotent(
      token: token,
      key: idempotencyKey,
      body: (txn, userRef, user, ref) async {
        final goalRef = paths.goals(userRef.id).doc(request.goalClientId);
        final goalData = (await txn.get(goalRef)).data(); // read before any write
        if (goalData == null) {
          return left(const BusinessFailure(BusinessCode.goalNotFound, 'This savings goal no longer exists.'));
        }
        final saved = ((goalData['savedKobo'] as num?) ?? 0).toInt();
        if (request.amountKobo > saved) {
          return left(const BusinessFailure(BusinessCode.insufficientFunds, 'This goal no longer holds that much.'));
        }

        final computedFee = Fees.goalBreakFeeKobo(
          amountKobo: request.amountKobo,
          savedKobo: saved,
          targetKobo: (goalData['targetKobo'] as num).toInt(),
          targetDate: DateTime.fromMillisecondsSinceEpoch((goalData['targetDate'] as num).toInt()),
          now: _clock(),
        );
        final fee = computedFee < request.agreedFeeKobo ? computedFee : request.agreedFeeKobo;

        // Goal down, wallet up (less any break fee), receipt and processed
        // record: one transaction.
        final savedAfter = saved - request.amountKobo;
        final balanceAfter = ((user['balanceKobo'] as num?) ?? 0).toInt() + request.amountKobo - fee;
        final receipt = <String, dynamic>{
          'ref': ref,
          'kind': ActivityKind.goalWithdrawal.name,
          'direction': ActivityDirection.credit.name,
          'amountKobo': request.amountKobo - fee,
          'feeKobo': fee,
          'title': goalData['name'] as String,
          'subtitle': 'NovaSave',
          'goalClientId': request.goalClientId,
          'idempotencyKey': idempotencyKey,
          'createdAt': createdAt,
        };
        txn.update(userRef, {'balanceKobo': balanceAfter});
        txn.update(goalRef, {'savedKobo': savedAfter});
        txn.set(paths.transactions(userRef.id).doc(ref), receipt);

        return right(
          MutationResultDto(
            ref: ref,
            balanceAfterKobo: balanceAfter,
            goal: _goalFrom(request.goalClientId, {...goalData, 'savedKobo': savedAfter}),
            transaction: _txnFrom(receipt),
          ),
        );
      },
    );
  }

  // ── NovaWallet transfers ──────────────────────────────────────────────

  /// Lists this user so others can find them by email. Best effort: a failure
  /// here (say, an account number already claimed) must never block sign-in.
  Future<void> _publishDirectory(String uid, ProfileDto profile) async {
    try {
      await paths.directoryEmail(profile.email).set({
        'uid': uid,
        'accountNumber': profile.accountNumber,
        'fullName': profile.fullName,
      });
      await paths.directoryAccount(profile.accountNumber).set({'uid': uid});
    } on FirebaseException {
      // Not listed: they can still send, just not be found by email yet.
    }
  }

  @override
  Future<Either<Failure, BeneficiaryDto>> findNovaUser({required String token, required String email}) =>
      _call(() async {
        if (_uid(token) == null) return left(_expired);
        final needle = email.trim().toLowerCase();
        if ((auth.currentUser?.email ?? '').toLowerCase() == needle) {
          return left(const BusinessFailure(BusinessCode.selfTransfer, "You can't send money to yourself."));
        }
        final data = (await paths.directoryEmail(needle).get(_serverSource)).data();
        if (data == null) {
          return left(const BusinessFailure(BusinessCode.invalidAccount, 'No NovaWallet user has this email.'));
        }
        return right(
          BeneficiaryDto(
            accountNumber: data['accountNumber'] as String,
            bankCode: Banks.novaWallet.code,
            bankName: Banks.novaWallet.name,
            accountName: (data['fullName'] as String).toUpperCase(),
          ),
        );
      });

  /// Wallet to wallet, in the same transaction as the idempotency record:
  /// sender debit + sender receipt (naming the recipient) + recipient credit
  /// (by increment, so the sender never reads the recipient's private doc) +
  /// recipient receipt (naming the sender). `firestore.rules` accepts the
  /// cross-user writes only when all four agree on the amount.
  Future<Either<BusinessFailure, MutationResultDto>> _novaTransfer({
    required Transaction txn,
    required DocumentReference<Map<String, dynamic>> userRef,
    required Map<String, dynamic> user,
    required String ref,
    required String idempotencyKey,
    required TransferRequest request,
    required int createdAt,
  }) async {
    final directory = (await txn.get(paths.directoryAccount(request.accountNumber))).data();
    final recipientUid = directory?['uid'] as String?;
    if (recipientUid == null) {
      return left(const BusinessFailure(BusinessCode.invalidAccount, "The recipient's wallet could not be found."));
    }
    if (recipientUid == userRef.id) {
      return left(const BusinessFailure(BusinessCode.selfTransfer, "You can't send money to yourself."));
    }
    final tier = ((user['tier'] as num?) ?? 1).toInt();
    final cap = tier >= 2 ? AppConstants.tier2SingleSendCapKobo : AppConstants.tier1SingleSendCapKobo;
    if (request.amountKobo > cap) {
      return left(const BusinessFailure(BusinessCode.tierLimitExceeded, 'This amount is above your transfer limit.'));
    }
    final balance = ((user['balanceKobo'] as num?) ?? 0).toInt();
    if (request.amountKobo > balance) {
      return left(const BusinessFailure(BusinessCode.insufficientFunds, 'Insufficient funds when we tried to send.'));
    }

    final balanceAfter = balance - request.amountKobo;
    final receipt = <String, dynamic>{
      'ref': ref,
      'kind': ActivityKind.transfer.name,
      'direction': ActivityDirection.debit.name,
      'amountKobo': request.amountKobo,
      'feeKobo': 0,
      'title': request.recipientName,
      'subtitle': '${Banks.novaWallet.name} · ${Masking.account(request.accountNumber)}',
      'narration': request.narration,
      'recipientUid': recipientUid,
      'idempotencyKey': idempotencyKey,
      'createdAt': createdAt,
    };
    final credit = <String, dynamic>{
      'ref': ref,
      'kind': ActivityKind.credit.name,
      'direction': ActivityDirection.credit.name,
      'amountKobo': request.amountKobo,
      'feeKobo': 0,
      'title': ((user['fullName'] as String?) ?? 'NovaWallet user').toUpperCase(),
      'subtitle': '${Banks.novaWallet.name} transfer',
      'narration': request.narration,
      'fromUid': userRef.id,
      'createdAt': createdAt,
    };
    txn.update(userRef, {'balanceKobo': balanceAfter});
    txn.set(paths.transactions(userRef.id).doc(ref), receipt);
    txn.update(paths.user(recipientUid), {
      'balanceKobo': FieldValue.increment(request.amountKobo),
      'lastCreditRef': ref,
    });
    txn.set(paths.transactions(recipientUid).doc(ref), credit);

    return right(MutationResultDto(ref: ref, balanceAfterKobo: balanceAfter, transaction: _txnFrom(receipt)));
  }

  // ── Seeding and reset ───────────────────────────────────────────────────

  /// A new account starts with the demo balance, history, beneficiaries and a
  /// goal. One batch: 1 user + 60 receipts + 4 beneficiaries + 1 goal, well
  /// inside Firestore's 500-write limit. Reuses the fake backend's generator,
  /// so both backends show identical data.
  Future<void> _seedNewUser(String uid, ProfileDto profile, {String? pin}) async {
    final now = _clock();
    final seed = DemoSeed(hasher: hasher);
    final batch = firestore.batch();

    final user = <String, dynamic>{
      ...profile.toJson(),
      'balanceKobo': AppConstants.demoOpeningBalanceKobo,
      'createdAt': now.millisecondsSinceEpoch,
    };
    if (pin != null) {
      final salt = hasher.newSalt();
      user['pinSalt'] = salt;
      user['pinHash'] = hasher.hash(pin, salt);
    }
    batch.set(paths.user(uid), user);

    for (final row in seed.historyJson(profile.phone, now)) {
      batch.set(paths.transactions(uid).doc(row['ref'] as String), row);
    }
    for (final b in DemoSeed.beneficiaries) {
      batch.set(paths.beneficiaries(uid).doc('${b.bankCode}_${b.accountNumber}'), {
        'accountNumber': b.accountNumber,
        'bankCode': b.bankCode,
        'bankName': b.bankName,
        'accountName': b.accountName,
      });
    }
    batch.set(paths.goals(uid).doc('seed-goal-rent'), {
      'name': 'Rent — December',
      'targetKobo': 60000000,
      'targetDate': DateTime(2026, 12, 20).millisecondsSinceEpoch,
      'savedKobo': 21000000,
      'createdAt': now.subtract(const Duration(days: 45)).millisecondsSinceEpoch,
    });

    await batch.commit();
  }

  /// Developer panel → "Simulate incoming payment": balance and receipt move
  /// together in one transaction, exactly as a real inward transfer would land.
  @override
  Future<void> simulateIncomingPayment({required String token, required int amountKobo, required String from}) async {
    final uid = _uid(token);
    if (uid == null) return;
    final userRef = paths.user(uid);
    final ref = 'NPIN${_clock().millisecondsSinceEpoch}';
    await firestore.runTransaction<void>((txn) async {
      final snap = await txn.get(userRef);
      if (!snap.exists) return;
      final balance = ((snap.data()!['balanceKobo'] as num?) ?? 0).toInt();
      txn.update(userRef, {'balanceKobo': balance + amountKobo});
      txn.set(paths.transactions(uid).doc(ref), <String, dynamic>{
        'ref': ref,
        'kind': ActivityKind.credit.name,
        'direction': ActivityDirection.credit.name,
        'amountKobo': amountKobo,
        'feeKobo': 0,
        'title': from,
        'subtitle': 'Inward transfer · Moniepoint MFB',
        'createdAt': _clock().millisecondsSinceEpoch,
      });
    }, timeout: timeout);
  }

  /// Developer panel → "Reset demo data": wipes history, goals and
  /// beneficiaries, then seeds them again. `processed` is left alone: the rules
  /// forbid deleting it (that is the whole guarantee), and stale keys are
  /// harmless because every new intent gets a fresh uuid.
  @override
  Future<void> resetDemo() async {
    final user = auth.currentUser;
    if (user == null) return;
    final data = (await paths.user(user.uid).get(_serverSource)).data();
    if (data == null) return;

    for (final collection in [paths.transactions(user.uid), paths.goals(user.uid), paths.beneficiaries(user.uid)]) {
      final docs = await collection.get(_serverSource);
      final batch = firestore.batch();
      for (final doc in docs.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
    await _seedNewUser(user.uid, _profileFrom(data));
    // Re-seeding replaced the user document; restore the PIN the user already set.
    if (data['pinHash'] != null && data['pinSalt'] != null) {
      await paths.user(user.uid).update({'pinHash': data['pinHash'], 'pinSalt': data['pinSalt']});
    }
  }
}
