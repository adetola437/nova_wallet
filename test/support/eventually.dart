import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

/// Polls [check] until it holds or [timeout] passes, then asserts it.
///
/// Used where the code under test finishes asynchronously on its own schedule
/// (session lifecycle, background refresh), so a fixed sleep would either be
/// flaky or needlessly slow.
Future<void> eventually(
  FutureOr<bool> Function() check, {
  Duration timeout = const Duration(seconds: 5),
  String? reason,
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    if (await check()) return;
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
  expect(await check(), isTrue, reason: reason ?? 'condition not met within $timeout');
}
