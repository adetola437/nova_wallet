import 'package:isar_community/isar.dart';

part 'server_entities.g.dart';

// Collections of the *fake remote*. They live in a separate Isar instance so
// they survive app restarts the way a real backend's database would.

@collection
class ServerAccount {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String phone;

  late String fullName;
  late String email;
  late String passwordHash;
  late String passwordSalt;
  String? pinHash;
  String? pinSalt;
  int tier = 1;
  bool bvnVerified = false;
  late int balanceKobo;
  late String accountNumber;
}

@collection
class ServerSession {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String token;

  late String phone;
  late DateTime issuedAt;
}

@collection
class ServerTransaction {
  Id id = Isar.autoIncrement;

  @Index()
  late String phone;

  @Index(unique: true)
  late String ref;

  /// `ActivityKind.name` / `ActivityDirection.name`.
  late String kind;
  late String direction;
  late int amountKobo;
  int feeKobo = 0;
  late String title;
  String? subtitle;
  String? narration;
  String? goalClientId;
  String? idempotencyKey;

  @Index()
  late DateTime createdAt;
}

@collection
class ServerGoal {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String clientId;

  @Index()
  late String phone;

  late String name;
  late int targetKobo;
  late DateTime targetDate;
  int savedKobo = 0;
  late DateTime createdAt;
}

@collection
class ServerBeneficiary {
  Id id = Isar.autoIncrement;

  @Index()
  late String phone;

  late String accountNumber;
  late String bankCode;
  late String bankName;
  late String accountName;
}

/// The idempotency record: key → the exact response first returned.
@collection
class ProcessedRequest {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String idempotencyKey;

  late String phone;
  late String endpoint;
  late String responseJson;
  late DateTime processedAt;
}
