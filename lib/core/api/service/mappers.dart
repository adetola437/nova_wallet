import '../../models/goal_view.dart';
import '../../storage/entities/beneficiary_entity.dart';
import '../../storage/entities/goal_entity.dart';
import '../../storage/entities/transaction_entity.dart';
import 'dto.dart';

TransactionEntity transactionEntityFromDto(TransactionDto d) => TransactionEntity()
  ..serverRef = d.ref
  ..kind = d.kind
  ..direction = d.direction
  ..amountKobo = d.amountKobo
  ..feeKobo = d.feeKobo
  ..title = d.title
  ..subtitle = d.subtitle
  ..narration = d.narration
  ..goalClientId = d.goalClientId
  ..idempotencyKey = d.idempotencyKey
  ..createdAt = d.createdAt;

GoalEntity goalEntityFromDto(GoalDto d) => GoalEntity()
  ..clientId = d.clientId
  ..name = d.name
  ..targetKobo = d.targetKobo
  ..targetDate = d.targetDate
  ..savedKobo = d.savedKobo
  ..syncState = GoalSyncState.synced
  ..createdAt = d.createdAt;

BeneficiaryEntity beneficiaryEntityFromDto(BeneficiaryDto d, {required DateTime verifiedAt}) => BeneficiaryEntity()
  ..accountNumber = d.accountNumber
  ..bankCode = d.bankCode
  ..bankName = d.bankName
  ..verifiedName = d.accountName
  ..verifiedAt = verifiedAt;
