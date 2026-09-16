import 'package:isar_community/isar.dart';

import '../../models/profile.dart';

part 'profile_entity.g.dart';

/// Single row (id 0) so the unlock screen can greet the user offline.
@collection
class ProfileEntity {
  Id id = 0;
  late String fullName;
  late String phone;
  late String email;
  late int tier;
  late bool bvnVerified;
  late String accountNumber;

  Profile toModel() => Profile(
    fullName: fullName,
    phone: phone,
    email: email,
    tier: tier,
    bvnVerified: bvnVerified,
    accountNumber: accountNumber,
  );

  static ProfileEntity fromModel(Profile p) => ProfileEntity()
    ..fullName = p.fullName
    ..phone = p.phone
    ..email = p.email
    ..tier = p.tier
    ..bvnVerified = p.bvnVerified
    ..accountNumber = p.accountNumber;
}
