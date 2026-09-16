import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';

void main() {
  test('money constants are integer kobo matching the spec', () {
    expect(AppConstants.biometricThresholdKobo, 5000000);
    expect(AppConstants.tier1SingleSendCapKobo, 10000000);
    expect(AppConstants.tier2SingleSendCapKobo, 100000000);
    expect(AppConstants.minSendKobo, 10000);
    expect(AppConstants.demoOpeningBalanceKobo, 25000000);
    expect(AppConstants.offlinePendingCopy, 'Pending — will send when back online');
  });

  test('demo credentials match the design artboards', () {
    expect(AppConstants.demoEmail, 'tolu.adeyemi@mail.com');
    expect(AppConstants.fakeOtp, '419372');
  });
}
