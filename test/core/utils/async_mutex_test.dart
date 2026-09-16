import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/utils/async_mutex.dart';

void main() {
  test('bodies never overlap and run in call order', () async {
    final mutex = AsyncMutex();
    final log = <String>[];
    Future<void> job(String name) => mutex.synchronized(() async {
          log.add('start $name');
          await Future<void>.delayed(const Duration(milliseconds: 5));
          log.add('end $name');
        });
    await Future.wait([job('a'), job('b'), job('c')]);
    expect(log, ['start a', 'end a', 'start b', 'end b', 'start c', 'end c']);
  });

  test('a throwing body releases the lock and propagates', () async {
    final mutex = AsyncMutex();
    await expectLater(mutex.synchronized<void>(() async => throw StateError('x')), throwsStateError);
    expect(await mutex.synchronized(() async => 42), 42);
  });
}
