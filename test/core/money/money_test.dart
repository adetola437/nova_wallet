import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/money/money.dart';

void main() {
  group('Money.format', () {
    test('formats zero, kobo-only and grouped values exactly', () {
      expect(const Money(0).format(), '₦0.00');
      expect(const Money(1).format(), '₦0.01');
      expect(const Money(150050).format(), '₦1,500.50');
      expect(const Money(25000000).format(), '₦250,000.00');
      expect(const Money(100000000000).format(), '₦1,000,000,000.00');
    });

    test('negative values put the sign before the symbol', () {
      expect(const Money(-507).format(), '-₦5.07');
    });

    test('withSymbol false drops ₦', () {
      expect(const Money(2688).format(withSymbol: false), '26.88');
    });
  });

  test('arithmetic stays in integers', () {
    // 0.1 + 0.2 in doubles is 0.30000000000000004; in kobo it is exact.
    expect((const Money(10) + const Money(20)).kobo, 30);
    expect((const Money(18645025) - const Money(5502688)).format(), '₦131,423.37');
  });
}
