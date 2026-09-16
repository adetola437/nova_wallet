import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/money/kobo_parser.dart';

int ok(String s) => KoboParser.parse(s).fold((e) => fail('unexpected $e'), (k) => k);
KoboParseError err(String s) => KoboParser.parse(s).fold((e) => e, (k) => fail('unexpected $k'));

void main() {
  test('parses grouped, symbol-prefixed and partial-decimal input', () {
    expect(ok('1,500.5'), 150050);
    expect(ok('₦ 2,000'), 200000);
    expect(ok('0.01'), 1);
    expect(ok('00012'), 1200);
    expect(ok('1.'), 100);
    expect(ok('1000000000'), 100000000000);
  });

  test('does not suffer float truncation (0.29 * 100 == 28.999… in double)', () {
    expect(ok('0.29'), 29);
    expect(ok('1.15'), 115);
    expect(ok('19.99'), 1999);
  });

  test('rejects bad input without throwing', () {
    expect(err(''), KoboParseError.empty);
    expect(err('   '), KoboParseError.empty);
    expect(err('abc'), KoboParseError.invalid);
    expect(err('-5'), KoboParseError.invalid);
    expect(err('1.2.3'), KoboParseError.invalid);
    expect(err('1.234'), KoboParseError.tooManyDecimals);
    expect(err('1000000000.01'), KoboParseError.tooLarge);
    expect(err('99999999999999999999999'), KoboParseError.tooLarge);
  });

  test('toInputText round-trips without a double', () {
    expect(KoboParser.toInputText(100000), '1,000');
    expect(KoboParser.toInputText(150050), '1,500.50');
    expect(ok(KoboParser.toInputText(123456789)), 123456789);
  });
}
