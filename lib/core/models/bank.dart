import 'package:equatable/equatable.dart';

class Bank extends Equatable {
  const Bank({required this.code, required this.name});

  final String code;
  final String name;

  @override
  List<Object?> get props => [code, name];
}

/// Fixed list for the new-recipient bank picker (no network needed to show it).
abstract class Banks {
  static const List<Bank> all = [
    Bank(code: '044', name: 'Access Bank'),
    Bank(code: '058', name: 'GTBank'),
    Bank(code: '011', name: 'First Bank'),
    Bank(code: '033', name: 'UBA'),
    Bank(code: '057', name: 'Zenith Bank'),
    Bank(code: '50515', name: 'Moniepoint MFB'),
    Bank(code: '999992', name: 'OPay'),
    Bank(code: '999991', name: 'PalmPay'),
  ];

  /// In-app transfers to another NovaWallet user. Not in the bank picker: the
  /// recipient is found by email, and the account number is their wallet's.
  static const Bank novaWallet = Bank(code: 'NOVAWALLET', name: 'NovaWallet');

  static bool isNovaWallet(String bankCode) => bankCode == novaWallet.code;

  static Bank? byCode(String code) {
    if (code == novaWallet.code) return novaWallet;
    for (final bank in all) {
      if (bank.code == code) return bank;
    }
    return null;
  }
}
