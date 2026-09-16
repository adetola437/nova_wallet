import 'package:equatable/equatable.dart';

import '../../config/flavor/app_constants.dart';

class Profile extends Equatable {
  const Profile({
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

  String get firstName => fullName.trim().split(RegExp(r'\s+')).first;

  int get singleSendCapKobo => tier >= 2 ? AppConstants.tier2SingleSendCapKobo : AppConstants.tier1SingleSendCapKobo;

  Profile copyWith({int? tier, bool? bvnVerified}) => Profile(
    fullName: fullName,
    phone: phone,
    email: email,
    tier: tier ?? this.tier,
    bvnVerified: bvnVerified ?? this.bvnVerified,
    accountNumber: accountNumber,
  );

  @override
  List<Object?> get props => [fullName, phone, email, tier, bvnVerified, accountNumber];
}
