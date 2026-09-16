import '../../models/activity_item.dart';
import '../../models/profile.dart';

typedef Json = Map<String, dynamic>;

class ProfileDto {
  const ProfileDto({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.tier,
    required this.bvnVerified,
    required this.accountNumber,
  });

  final String fullName;
  final String phone;
  final String email;
  final int tier;
  final bool bvnVerified;
  final String accountNumber;

  Profile toModel() => Profile(
    fullName: fullName,
    phone: phone,
    email: email,
    tier: tier,
    bvnVerified: bvnVerified,
    accountNumber: accountNumber,
  );

  Json toJson() => {
    'fullName': fullName,
    'phone': phone,
    'email': email,
    'tier': tier,
    'bvnVerified': bvnVerified,
    'accountNumber': accountNumber,
  };

  factory ProfileDto.fromJson(Json j) => ProfileDto(
    fullName: j['fullName'] as String,
    phone: j['phone'] as String,
    email: j['email'] as String,
    tier: j['tier'] as int,
    bvnVerified: j['bvnVerified'] as bool,
    accountNumber: j['accountNumber'] as String,
  );
}

class SessionDto {
  const SessionDto({required this.token, required this.profile, this.pinHash, this.pinSalt});

  final String token;
  final ProfileDto profile;

  /// Mock simplification: lets the device verify the PIN offline after login.
  final String? pinHash;
  final String? pinSalt;
}

class RegisterRequest {
  const RegisterRequest({required this.phone, required this.fullName, required this.email, required this.password});

  final String phone;
  final String fullName;
  final String email;
  final String password;
}

class WalletDto {
  const WalletDto({required this.balanceKobo, required this.profile});

  final int balanceKobo;
  final ProfileDto profile;
}

class TransactionDto {
  const TransactionDto({
    required this.ref,
    required this.kind,
    required this.direction,
    required this.amountKobo,
    required this.feeKobo,
    required this.title,
    required this.createdAt,
    this.subtitle,
    this.narration,
    this.goalClientId,
    this.idempotencyKey,
  });

  final String ref;
  final ActivityKind kind;
  final ActivityDirection direction;
  final int amountKobo;
  final int feeKobo;
  final String title;
  final String? subtitle;
  final String? narration;
  final String? goalClientId;
  final String? idempotencyKey;
  final DateTime createdAt;

  Json toJson() => {
    'ref': ref,
    'kind': kind.name,
    'direction': direction.name,
    'amountKobo': amountKobo,
    'feeKobo': feeKobo,
    'title': title,
    'subtitle': subtitle,
    'narration': narration,
    'goalClientId': goalClientId,
    'idempotencyKey': idempotencyKey,
    'createdAt': createdAt.toUtc().toIso8601String(),
  };

  factory TransactionDto.fromJson(Json j) => TransactionDto(
    ref: j['ref'] as String,
    kind: ActivityKind.values.byName(j['kind'] as String),
    direction: ActivityDirection.values.byName(j['direction'] as String),
    amountKobo: j['amountKobo'] as int,
    feeKobo: j['feeKobo'] as int,
    title: j['title'] as String,
    subtitle: j['subtitle'] as String?,
    narration: j['narration'] as String?,
    goalClientId: j['goalClientId'] as String?,
    idempotencyKey: j['idempotencyKey'] as String?,
    createdAt: DateTime.parse(j['createdAt'] as String).toLocal(),
  );
}

class GoalDto {
  const GoalDto({
    required this.clientId,
    required this.name,
    required this.targetKobo,
    required this.targetDate,
    required this.savedKobo,
    required this.createdAt,
  });

  final String clientId;
  final String name;
  final int targetKobo;
  final DateTime targetDate;
  final int savedKobo;
  final DateTime createdAt;

  Json toJson() => {
    'clientId': clientId,
    'name': name,
    'targetKobo': targetKobo,
    'targetDate': targetDate.toUtc().toIso8601String(),
    'savedKobo': savedKobo,
    'createdAt': createdAt.toUtc().toIso8601String(),
  };

  factory GoalDto.fromJson(Json j) => GoalDto(
    clientId: j['clientId'] as String,
    name: j['name'] as String,
    targetKobo: j['targetKobo'] as int,
    targetDate: DateTime.parse(j['targetDate'] as String).toLocal(),
    savedKobo: j['savedKobo'] as int,
    createdAt: DateTime.parse(j['createdAt'] as String).toLocal(),
  );
}

class BeneficiaryDto {
  const BeneficiaryDto({
    required this.accountNumber,
    required this.bankCode,
    required this.bankName,
    required this.accountName,
  });

  final String accountNumber;
  final String bankCode;
  final String bankName;
  final String accountName;
}

class TransferRequest {
  const TransferRequest({
    required this.bankCode,
    required this.bankName,
    required this.accountNumber,
    required this.recipientName,
    required this.amountKobo,
    this.narration,
  });

  final String bankCode;
  final String bankName;
  final String accountNumber;
  final String recipientName;
  final int amountKobo;
  final String? narration;

  Json toJson() => {
    'bankCode': bankCode,
    'bankName': bankName,
    'accountNumber': accountNumber,
    'recipientName': recipientName,
    'amountKobo': amountKobo,
    'narration': narration,
  };

  factory TransferRequest.fromJson(Json j) => TransferRequest(
    bankCode: j['bankCode'] as String,
    bankName: j['bankName'] as String,
    accountNumber: j['accountNumber'] as String,
    recipientName: j['recipientName'] as String,
    amountKobo: j['amountKobo'] as int,
    narration: j['narration'] as String?,
  );
}

class CreateGoalRequest {
  const CreateGoalRequest({
    required this.clientId,
    required this.name,
    required this.targetKobo,
    required this.targetDate,
  });

  final String clientId;
  final String name;
  final int targetKobo;
  final DateTime targetDate;

  Json toJson() => {
    'clientId': clientId,
    'name': name,
    'targetKobo': targetKobo,
    'targetDate': targetDate.toUtc().toIso8601String(),
  };

  factory CreateGoalRequest.fromJson(Json j) => CreateGoalRequest(
    clientId: j['clientId'] as String,
    name: j['name'] as String,
    targetKobo: j['targetKobo'] as int,
    targetDate: DateTime.parse(j['targetDate'] as String).toLocal(),
  );
}

class ContributeRequest {
  const ContributeRequest({required this.goalClientId, required this.amountKobo});

  final String goalClientId;
  final int amountKobo;

  Json toJson() => {'goalClientId': goalClientId, 'amountKobo': amountKobo};

  factory ContributeRequest.fromJson(Json j) =>
      ContributeRequest(goalClientId: j['goalClientId'] as String, amountKobo: j['amountKobo'] as int);
}

/// Moves confirmed savings from a goal back into the wallet.
///
/// [agreedFeeKobo] is the break fee the user saw and confirmed. The server
/// recomputes the fee when it applies the move and charges the LOWER of the
/// two: a goal that matured while the move sat in the queue costs nothing
/// extra, and nobody is ever charged more than they agreed to.
class MoveToWalletRequest {
  const MoveToWalletRequest({required this.goalClientId, required this.amountKobo, this.agreedFeeKobo = 0});

  final String goalClientId;
  final int amountKobo;
  final int agreedFeeKobo;

  Json toJson() => {'goalClientId': goalClientId, 'amountKobo': amountKobo, 'agreedFeeKobo': agreedFeeKobo};

  factory MoveToWalletRequest.fromJson(Json j) => MoveToWalletRequest(
    goalClientId: j['goalClientId'] as String,
    amountKobo: j['amountKobo'] as int,
    agreedFeeKobo: (j['agreedFeeKobo'] as int?) ?? 0,
  );
}

/// What every mutating endpoint returns, and what the idempotency record stores.
class MutationResultDto {
  const MutationResultDto({required this.ref, required this.balanceAfterKobo, this.transaction, this.goal});

  final String ref;
  final int balanceAfterKobo;
  final TransactionDto? transaction;
  final GoalDto? goal;

  Json toJson() => {
    'ref': ref,
    'balanceAfterKobo': balanceAfterKobo,
    'transaction': transaction?.toJson(),
    'goal': goal?.toJson(),
  };

  factory MutationResultDto.fromJson(Json j) => MutationResultDto(
    ref: j['ref'] as String,
    balanceAfterKobo: j['balanceAfterKobo'] as int,
    transaction: j['transaction'] == null ? null : TransactionDto.fromJson(j['transaction'] as Json),
    goal: j['goal'] == null ? null : GoalDto.fromJson(j['goal'] as Json),
  );
}
