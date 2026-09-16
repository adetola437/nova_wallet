import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/money/fees.dart';

void main() {
  test('band edges', () {
    expect(Fees.transferFeeKobo(0), 0);
    expect(Fees.transferFeeKobo(10000), 1075);
    expect(Fees.transferFeeKobo(500000), 1075); // ₦5,000.00
    expect(Fees.transferFeeKobo(500001), 2688); // ₦5,000.01
    expect(Fees.transferFeeKobo(5000000), 2688); // ₦50,000.00
    expect(Fees.transferFeeKobo(5000001), 5375);
  });
}
