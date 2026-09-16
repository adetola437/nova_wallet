import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/money/money_semantics.dart';

void main() {
  test('english reads naira and kobo as units', () {
    expect(MoneySemantics.label(1250050, languageCode: 'en'), '12,500 naira 50 kobo');
    expect(MoneySemantics.label(25000000, languageCode: 'en'), '250,000 naira');
    expect(MoneySemantics.label(-507, languageCode: 'en'), 'minus 5 naira 7 kobo');
  });

  test('yoruba label uses náírà / kọ́bọ̀', () {
    expect(MoneySemantics.label(1250050, languageCode: 'yo'), 'náírà 12,500 àti kọ́bọ̀ 50');
    expect(MoneySemantics.label(25000000, languageCode: 'yo'), 'náírà 250,000');
  });
}
