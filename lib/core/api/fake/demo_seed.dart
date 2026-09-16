import 'dart:math';

import 'package:isar_community/isar.dart';

import '../../../config/flavor/app_constants.dart';
import '../../auth/secret_hasher.dart';
import '../../models/activity_item.dart';
import '../../models/bank.dart';
import '../../money/fees.dart';
import '../../utils/masking.dart';
import '../service/dto.dart';
import 'entities/server_entities.dart';

/// Deterministic demo data, shared by both backends so they seed the same
/// account.
class DemoSeed {
  DemoSeed({required this.hasher});

  final SecretHasher hasher;

  static const List<BeneficiaryDto> beneficiaries = [
    BeneficiaryDto(accountNumber: '0248214821', bankCode: '058', bankName: 'GTBank', accountName: 'ADAEZE OKAFOR'),
    BeneficiaryDto(accountNumber: '1234567890', bankCode: '044', bankName: 'Access Bank', accountName: 'AMINA BELLO'),
    BeneficiaryDto(
      accountNumber: '2233445566',
      bankCode: '057',
      bankName: 'Zenith Bank',
      accountName: 'OLUWASEUN ADEYEMI',
    ),
    BeneficiaryDto(accountNumber: '8123456789', bankCode: '999992', bankName: 'OPay', accountName: 'IFEOMA NWANKWO'),
  ];

  static const List<String> directoryNames = [
    'CHINEDU EMEKA OBI',
    'FATIMA SANI MUSA',
    'BABATUNDE AJAYI',
    'NGOZI EZE',
    'IBRAHIM LAWAL',
    'FUNMILAYO OGUNLEYE',
    'EMEKA NNAMDI',
    'HAUWA ABUBAKAR',
  ];

  static final RegExp _tenDigits = RegExp(r'^\d{10}$');

  /// Name enquiry. Numbers starting `000` or unknown banks don't exist; every
  /// other valid number resolves to a stable name so the demo can add anyone.
  static String? lookupName({required String bankCode, required String accountNumber}) {
    if (!_tenDigits.hasMatch(accountNumber) || accountNumber.startsWith('000')) return null;
    if (Banks.byCode(bankCode) == null) return null;
    for (final b in beneficiaries) {
      if (b.accountNumber == accountNumber && b.bankCode == bankCode) return b.accountName;
    }
    final digitSum = accountNumber.codeUnits.fold<int>(0, (sum, c) => sum + c - 48);
    return directoryNames[digitSum % directoryNames.length];
  }

  /// The 60-row transaction history as plain maps — the one generator both
  /// backends use. `createdAt` is milliseconds since epoch.
  List<Map<String, dynamic>> historyJson(String phone, DateTime now) {
    final random = Random(42);
    const payees = [
      ('ADAEZE OKAFOR', 'GTBank', '0248214821'),
      ('IKEJA ELECTRIC', 'Zenith Bank', '1010101010'),
      ('SHOPRITE LEKKI', 'Access Bank', '2020202020'),
      ('AMINA BELLO', 'Access Bank', '1234567890'),
      ('MTN DATA BUNDLE', 'UBA', '3030303030'),
      ('IFEOMA NWANKWO', 'OPay', '8123456789'),
    ];
    const amounts = [99950, 150000, 250000, 500000, 750000, 1200000, 2000000, 350000];
    final suffix = phone.substring(phone.length - 4);

    return List.generate(60, (i) {
      final createdAt = now.subtract(Duration(hours: 9 + i * 17)).millisecondsSinceEpoch;
      final ref = 'NP$suffix${(i + 1).toString().padLeft(5, '0')}';
      if (i % 7 == 3) {
        return <String, dynamic>{
          'ref': ref,
          'kind': ActivityKind.credit.name,
          'direction': ActivityDirection.credit.name,
          'amountKobo': 15000000,
          'feeKobo': 0,
          'title': 'KUNLE BANKOLE',
          'subtitle': 'Inward transfer · Moniepoint MFB',
          'createdAt': createdAt,
        };
      }
      final payee = payees[random.nextInt(payees.length)];
      final amount = amounts[random.nextInt(amounts.length)];
      return <String, dynamic>{
        'ref': ref,
        'kind': ActivityKind.transfer.name,
        'direction': ActivityDirection.debit.name,
        'amountKobo': amount,
        'feeKobo': Fees.transferFeeKobo(amount),
        'title': payee.$1,
        'subtitle': '${payee.$2} · ${Masking.account(payee.$3)}',
        'createdAt': createdAt,
      };
    });
  }

  /// Creates an account with history and beneficiaries. MUST run inside a
  /// server write transaction.
  Future<ServerAccount> createAccount(
    Isar server, {
    required String phone,
    required String fullName,
    required String email,
    required String password,
    required DateTime now,
    String? pin,
    int tier = 1,
    bool bvnVerified = false,
    bool withGoal = false,
  }) async {
    final passwordSalt = hasher.newSalt();
    final account = ServerAccount()
      ..phone = phone
      ..fullName = fullName
      ..email = email
      ..passwordSalt = passwordSalt
      ..passwordHash = hasher.hash(password, passwordSalt)
      ..tier = tier
      ..bvnVerified = bvnVerified
      ..balanceKobo = AppConstants.demoOpeningBalanceKobo
      ..accountNumber = phone.substring(1);
    if (pin != null) {
      final pinSalt = hasher.newSalt();
      account
        ..pinSalt = pinSalt
        ..pinHash = hasher.hash(pin, pinSalt);
    }
    await server.serverAccounts.put(account);
    await server.serverTransactions.putAll([
      for (final row in historyJson(phone, now))
        ServerTransaction()
          ..phone = phone
          ..ref = row['ref'] as String
          ..kind = row['kind'] as String
          ..direction = row['direction'] as String
          ..amountKobo = row['amountKobo'] as int
          ..feeKobo = row['feeKobo'] as int
          ..title = row['title'] as String
          ..subtitle = row['subtitle'] as String?
          ..createdAt = DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int),
    ]);
    await server.serverBeneficiarys.putAll([
      for (final b in beneficiaries)
        ServerBeneficiary()
          ..phone = phone
          ..accountNumber = b.accountNumber
          ..bankCode = b.bankCode
          ..bankName = b.bankName
          ..accountName = b.accountName,
    ]);
    if (withGoal) {
      await server.serverGoals.put(
        ServerGoal()
          ..clientId = 'seed-goal-rent-$phone'
          ..phone = phone
          ..name = 'Rent — December'
          ..targetKobo = 60000000
          ..targetDate = DateTime(2026, 12, 20)
          ..savedKobo = 21000000
          ..createdAt = now.subtract(const Duration(days: 45)),
      );
    }
    return account;
  }
}
