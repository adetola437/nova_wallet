import 'package:isar_community/isar.dart';

import '../../models/beneficiary.dart';

part 'beneficiary_entity.g.dart';

@collection
class BeneficiaryEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, composite: [CompositeIndex('bankCode')])
  late String accountNumber;

  late String bankCode;
  late String bankName;
  late String verifiedName;
  late DateTime verifiedAt;
  DateTime? lastUsedAt;

  Beneficiary toModel() => Beneficiary(
    accountNumber: accountNumber,
    bankCode: bankCode,
    bankName: bankName,
    verifiedName: verifiedName,
    lastUsedAt: lastUsedAt,
  );
}
