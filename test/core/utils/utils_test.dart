import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/auth/secret_hasher.dart';
import 'package:nova_wallet/core/utils/masking.dart';
import 'package:nova_wallet/core/utils/phone.dart';
import 'package:nova_wallet/core/utils/streams.dart';

void main() {
  test('PhoneNumber.normalize accepts local and +234 forms', () {
    expect(PhoneNumber.normalize('08012345678'), '08012345678');
    expect(PhoneNumber.normalize('+234 801 234 5678'), '08012345678');
    expect(PhoneNumber.normalize('2348012345678'), '08012345678');
    expect(PhoneNumber.normalize('8012345678'), '08012345678');
    expect(PhoneNumber.normalize('0601234567'), isNull);
    expect(PhoneNumber.normalize('0501234567'), isNull);
    expect(PhoneNumber.normalize('12345'), isNull);
  });

  test('Masking.account keeps the last four digits', () {
    expect(Masking.account('0123454821'), '•••• 4821');
    expect(Masking.account('12'), '•••• 12');
  });

  test('SecretHasher verifies only the right secret', () {
    final hasher = SecretHasher();
    final salt = hasher.newSalt();
    final hash = hasher.hash('1234', salt);
    expect(hash, isNot('1234'));
    expect(hasher.verify('1234', salt, hash), isTrue);
    expect(hasher.verify('1235', salt, hash), isFalse);
    expect(hasher.hash('1234', hasher.newSalt()), isNot(hash));
  });

  test('failures compare by value', () {
    expect(const BusinessFailure(BusinessCode.insufficientFunds, 'x'),
        const BusinessFailure(BusinessCode.insufficientFunds, 'x'));
    expect(const NetworkFailure(timedOut: true).timedOut, isTrue);
  });

  test('combineLatest2 emits once both sides have a value', () async {
    final a = StreamController<int>();
    final b = StreamController<String>();
    final out = <String>[];
    final sub = combineLatest2<int, String, String>(a.stream, b.stream, (x, y) => '$x$y').listen(out.add);
    a.add(1);
    await pumpEventQueue();
    expect(out, isEmpty);
    b.add('a');
    a.add(2);
    await pumpEventQueue();
    expect(out, ['1a', '2a']);
    await sub.cancel();
  });
}
