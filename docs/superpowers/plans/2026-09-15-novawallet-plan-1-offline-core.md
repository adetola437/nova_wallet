# NovaWallet Plan 1: Foundation & Offline Core Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build everything below the UI: kobo money primitives, Isar storage, the idempotent fake server, auth/session logic, the outbox with its exactly-once `SyncCubit`, and every feature cubit. All of it is covered by unit tests plus the offline→restart→sync test, so Plan 2 only has to draw screens.

**Architecture:** Kiba layering. Controller → Cubit → Repository → (Isar / SecureStorage / SharedPreferences | `NovaApiService` → `FakeNovaServer`). **Only cubits call repositories.** Every send, goal creation and contribution goes through a persisted Isar outbox. A single-flight `SyncCubit` replays items FIFO with the same idempotency key, and the fake server remembers processed keys in its own Isar instance.

**Tech Stack:** Flutter 3.44.1 / Dart 3.12 · flutter_bloc 8 · get_it 8 · dartz · isar_community 3.3.2 · **firebase_core / firebase_auth / cloud_firestore** · shared_preferences · flutter_secure_storage · connectivity_plus · biometric_signature 13 · flutter_local_notifications 22 · uuid · crypto · bloc_test · mocktail

> **READ AMENDMENTS A AND B AT THE END OF THIS FILE BEFORE STARTING.** Amendment B (Cloud Firestore) supersedes Amendment A's Realtime Database sections.
>
> **Amendment A:** Firebase (Auth + Realtime Database) is the real backend as of 2026-09-16; `FakeNovaServer` becomes a switchable fallback and the unit-test double. Amendment A lists the deltas to Tasks 1, 6, 9, 16, 17 and 18, and adds Tasks 7B and 7C. The offline-first design is unchanged: the Isar outbox is still the only durable queue.

**Spec:** `docs/superpowers/specs/2026-09-15-novawallet-send-save-design.md`

## Plan series

| Plan | Scope | Written |
|---|---|---|
| **1 (this)** | Foundation & offline core: no screens | now |
| 2 | UI: theme tokens from Claude Design, l10n (en/yo), splash, onboarding, auth, Home, Send, NovaSave, Profile/developer panel, widget tests, text-scale tests, UI-driven integration test | after Claude Design returns (view code must match the artboards) |
| 3 | README.md, AI_USAGE.md, PowerPoint deck, emulator dry run | after Plan 2 |

## Global Constraints

- Package name `nova_wallet`; Flutter 3.44.1 (stable), Dart SDK `^3.12.1`.
- **Only cubits call repositories.** Repositories are injected into cubits via GetIt. Controllers, views, services and other repositories never call a repository.
- **Money is `int` kobo everywhere.** No `double` may hold, parse, sum or compare money. `double` is allowed only at the final paint edge (progress bar fraction).
- **No git commands of any kind.** Each task ends with a *Checkpoint* where the executor reports the files changed so the user can commit.
- **SharedPreferences stores only non-sensitive values** (locale, onboardingSeen, biometricEnabled, developer flags). Session token and PIN hash/salt go in `flutter_secure_storage`.
- **Isar:** use `isar_community` (`import 'package:isar_community/isar.dart';`). Generated code comes from `dart run build_runner build --delete-conflicting-outputs`. Collection accessors are pluralised with a trailing `s` (e.g. `outboxItemEntitys`).
- **Do NOT copy Kiba's `main.dart` `MediaQuery(textScaler: TextScaler.linear(0.95))` override.** It ignores the system font scale, which the brief forbids.
- Constants (copied from spec): biometric threshold ₦50,000.00 (`5000000` kobo); Tier 1 single-send cap ₦100,000.00 (`10000000`); Tier 2 cap ₦1,000,000.00 (`100000000`); minimum send ₦100.00 (`10000`); fee bands ≤ ₦5,000.00 → `1075`, ≤ ₦50,000.00 → `2688`, else `5375`; demo opening balance ₦250,000.00 (`25000000`); send outcome wait 8 s; backoff `min(2^attempts, 60)` seconds; trouble threshold 8 attempts.
- Demo account: phone `08012345678`, password `NovaPay#2026`, PIN `1234`, Tier 2. Fake OTP `419372`. **Login is by email + password** (Firebase); the login screen collects an email, not a phone number.
- Offline copy that must appear verbatim in Plan 2: **"Pending — will send when back online"**.
- Host tests that touch Isar call `await Isar.initializeIsarCore(download: true);` in `setUpAll`. The first run downloads the native lib into the project root, and it is git-ignored.
- **Firestore offline persistence is switched off** (`Settings(persistenceEnabled: false)`) and every read uses `Source.server`. Firestore caches and queues writes by default, which would put a second cache and a second durable queue underneath Isar. Every Firebase call is wrapped in a timeout so an offline write becomes a `NetworkFailure` our sync engine retries with the same key (Amendment A.0).

## File map (created in this plan)

```
pubspec.yaml, analysis_options.yaml, .gitignore            (modified)
lib/config/flavor/app_constants.dart
lib/config/di/app_initializer.dart
lib/core/money/{money,kobo_parser,fees,progress,money_semantics}.dart
lib/core/api/exception/failure.dart
lib/core/utils/{phone,async_mutex,streams,masking}.dart
lib/core/auth/{secret_hasher,biometric_signer,biometric_gate}.dart
lib/core/models/{bank,profile,beneficiary,outbox_item,wallet_overview,activity_item,goal_view}.dart
lib/core/storage/entities/{outbox_item_entity,wallet_snapshot_entity,profile_entity,transaction_entity,beneficiary_entity,goal_entity}.dart
lib/core/storage/{isar_db,local_storage,local_storage_impl,secure_storage,secure_storage_impl,session_store}.dart
lib/core/network/{network_info,network_info_impl,reachability}.dart
lib/core/api/fake/{fake_server_controls,fake_nova_server,demo_seed}.dart
lib/core/api/fake/entities/server_entities.dart
lib/core/api/service/{nova_api_service,dto}.dart
lib/core/notifications/{sync_notifier,local_notification_service}.dart
lib/core/session/session_lifecycle.dart
lib/features/connectivity/cubit/connectivity_cubit.dart
lib/features/settings/{repository/settings_repository.dart,repository/settings_repository_impl.dart,cubit/locale_cubit.dart,cubit/biometric_settings_cubit.dart}
lib/features/auth/repository/{auth_repository,auth_repository_impl}.dart
lib/features/auth/cubit/{auth_cubit,auth_state,signup_cubit,signup_state,login_cubit,login_state,unlock_cubit,unlock_state}.dart
lib/features/sync/repository/{outbox_repository,outbox_repository_impl}.dart
lib/features/sync/cubit/{sync_cubit,sync_state}.dart
lib/features/wallet/repository/{wallet_repository,wallet_repository_impl}.dart
lib/features/wallet/cubit/{wallet_cubit,wallet_state}.dart
lib/features/beneficiaries/repository/{beneficiary_repository,beneficiary_repository_impl}.dart
lib/features/beneficiaries/cubit/{beneficiaries_cubit,name_enquiry_cubit,name_enquiry_state}.dart
lib/features/savings/repository/{savings_repository,savings_repository_impl}.dart
lib/features/savings/cubit/{savings_cubit,create_goal_cubit,create_goal_state,contribute_cubit,contribute_state}.dart
lib/features/send_money/cubit/{send_money_cubit,send_money_state}.dart
lib/features/developer/repository/{developer_repository,developer_repository_impl}.dart
lib/features/developer/cubit/developer_cubit.dart
test/support/{fakes,harness,offline_restart_scenario}.dart
test/... (one test file per task, listed in each task)
integration_test/offline_queue_sync_test.dart
```

---

### Task 1: Project setup and constants

**Files:**
- Modify: `pubspec.yaml`, `analysis_options.yaml`, `.gitignore`
- Create: `lib/config/flavor/app_constants.dart`
- Test: `test/config/app_constants_test.dart`

**Interfaces:**
- Produces: `AppConstants` (all static const values below), used by every later task.

- [ ] **Step 1: Replace `pubspec.yaml`**

```yaml
name: nova_wallet
description: "NovaWallet Mobile — Send & Save (FirstBank Digital Factory take-home)."
publish_to: 'none'
version: 0.1.0+1

environment:
  sdk: ^3.12.1

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State management
  flutter_bloc: ^8.1.6
  bloc: ^8.1.4
  equatable: ^2.0.7

  # DI + functional results (Kiba)
  get_it: ^8.2.0
  dartz: ^0.10.1

  # Routing / responsiveness (Kiba)
  go_router: ^16.2.4
  flutter_screenutil: ^5.9.3

  # Storage
  isar_community: 3.3.2
  isar_community_flutter_libs: 3.3.2
  path_provider: ^2.1.5
  shared_preferences: ^2.5.3
  flutter_secure_storage: ^9.2.4

  # Platform
  connectivity_plus: ^6.1.5
  biometric_signature: ^13.0.0
  flutter_local_notifications: ^22.2.0

  # UI helpers
  pinput: ^5.0.2
  shimmer: ^3.0.0

  # Utils
  intl: any
  uuid: ^4.5.1
  crypto: ^3.0.6

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
  build_runner: ^2.10.5
  isar_community_generator: 3.3.2
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
  generate: true
  config:
    # Same reason as Kiba: biometric_signature's SPM manifest fights other pods.
    enable-swift-package-manager: false
```

(These versions were resolved together against Flutter 3.44.1 on 2026-09-15, and isar codegen was verified.)

- [ ] **Step 2: Replace `analysis_options.yaml`**

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - build/**
    - "**/*.g.dart"
  language:
    strict-casts: true
    strict-raw-types: true

linter:
  rules:
    - prefer_const_constructors
    - avoid_print
    - unawaited_futures
```

- [ ] **Step 3: Append to `.gitignore`**

```
# Isar native core downloaded by host unit tests
libisar.dylib
libisar.so
isar.dll
```

- [ ] **Step 4: Write the failing test** `test/config/app_constants_test.dart`

```dart
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
}
```

- [ ] **Step 5: Run to see it fail**

Run: `flutter pub get && flutter test test/config/app_constants_test.dart`
Expected: compilation error, `app_constants.dart` not found.

- [ ] **Step 6: Create `lib/config/flavor/app_constants.dart`**

```dart
/// App-wide constants. Money values are integer kobo; never add a double here.
abstract class AppConstants {
  static const String appName = 'NovaPay';

  // ── Money rules ───────────────────────────────────────────────────────────
  /// Sends at or above this need biometric confirmation (₦50,000.00).
  static const int biometricThresholdKobo = 5000000;

  /// Tier 1 (no BVN) single-send cap (₦100,000.00).
  static const int tier1SingleSendCapKobo = 10000000;

  /// Tier 2 (BVN verified) single-send cap (₦1,000,000.00).
  static const int tier2SingleSendCapKobo = 100000000;

  /// Smallest transfer allowed (₦100.00).
  static const int minSendKobo = 10000;

  /// Smallest goal target / contribution (₦1,000.00 / ₦100.00).
  static const int minGoalTargetKobo = 100000;
  static const int minContributionKobo = 10000;

  /// Hard ceiling for any typed amount (₦1,000,000,000.00) — keeps int math far
  /// from overflow.
  static const int maxAmountKobo = 100000000000;

  /// Credited to every new account so the demo has money to move (₦250,000.00).
  static const int demoOpeningBalanceKobo = 25000000;

  // ── Sync ──────────────────────────────────────────────────────────────────
  static const Duration sendOutcomeWait = Duration(seconds: 8);
  static const Duration connectivityDebounce = Duration(seconds: 1);
  static const int maxBackoffSeconds = 60;
  static const int troubleAttemptThreshold = 8;

  // ── Lists ─────────────────────────────────────────────────────────────────
  static const int pageSize = 50;

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const int pinLength = 4;
  static const int pinCooldownAfter = 3;
  static const int pinSignOutAfter = 5;
  static const Duration pinCooldown = Duration(seconds: 30);

  // ── Demo / fake backend ───────────────────────────────────────────────────
  static const String demoPhone = '08012345678';
  static const String demoPassword = 'NovaPay#2026';
  static const String demoPin = '1234';
  static const String fakeOtp = '419372'; // matches the design's demo banner
  static const String clientDbName = 'nova_client';
  static const String serverDbName = 'nova_fake_server';

  // ── Copy the brief requires verbatim ──────────────────────────────────────
  static const String offlinePendingCopy = 'Pending — will send when back online';
}
```

- [ ] **Step 7: Run the test**

Run: `flutter test test/config/app_constants_test.dart`
Expected: PASS.

- [ ] **Step 8: Checkpoint**. Report the changed files (`pubspec.yaml`, `analysis_options.yaml`, `.gitignore`, `app_constants.dart`, test) for the user to commit. Run no git commands.

---

### Task 2: Money primitives (Money, KoboParser, Fees, Progress, MoneySemantics)

**Files:**
- Create: `lib/core/money/money.dart`, `kobo_parser.dart`, `fees.dart`, `progress.dart`, `money_semantics.dart`
- Test: `test/core/money/money_test.dart`, `kobo_parser_test.dart`, `fees_test.dart`, `progress_test.dart`, `money_semantics_test.dart`

**Interfaces:**
- Produces:
  - `class Money { const Money(int kobo); const Money.zero(); final int kobo; String format({bool withSymbol = true}); static const String masked; operator + - ; compareTo }`
  - `enum KoboParseError { empty, invalid, tooManyDecimals, tooLarge }`
  - `abstract class KoboParser { static Either<KoboParseError, int> parse(String input, {int maxKobo}); static String toInputText(int kobo); }`
  - `abstract class Fees { static int transferFeeKobo(int amountKobo); }`
  - `abstract class Progress { static const int full = 10000; static int bps({required int savedKobo, required int targetKobo}); static String formatPercent(int bps); static int suggestedWeeklyKobo({required int remainingKobo, required DateTime from, required DateTime targetDate}); }`
  - `abstract class MoneySemantics { static String label(int kobo, {required String languageCode}); }`

- [ ] **Step 1: Write the failing tests**

`test/core/money/money_test.dart`
```dart
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
```

`test/core/money/kobo_parser_test.dart`
```dart
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
```

`test/core/money/fees_test.dart`
```dart
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
```

`test/core/money/progress_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/money/progress.dart';

void main() {
  test('bps uses integer division and caps at 100%', () {
    expect(Progress.bps(savedKobo: 21000000, targetKobo: 60000000), 3500);
    expect(Progress.bps(savedKobo: 1, targetKobo: 3), 3333);
    expect(Progress.bps(savedKobo: 70000000, targetKobo: 60000000), 10000);
    expect(Progress.bps(savedKobo: 0, targetKobo: 60000000), 0);
    expect(Progress.bps(savedKobo: 5, targetKobo: 0), 0);
  });

  test('formatPercent trims trailing zeros', () {
    expect(Progress.formatPercent(3500), '35%');
    expect(Progress.formatPercent(3550), '35.5%');
    expect(Progress.formatPercent(3333), '33.33%');
    expect(Progress.formatPercent(10000), '100%');
  });

  test('suggestedWeeklyKobo rounds up so the goal is reached', () {
    final from = DateTime(2026, 9, 15);
    // 96 days → 14 weeks; 39,000,000 / 14 = 2,785,714.28… → 2,785,715
    expect(
      Progress.suggestedWeeklyKobo(remainingKobo: 39000000, from: from, targetDate: DateTime(2026, 12, 20)),
      2785715,
    );
    expect(Progress.suggestedWeeklyKobo(remainingKobo: 0, from: from, targetDate: DateTime(2026, 12, 20)), 0);
    expect(Progress.suggestedWeeklyKobo(remainingKobo: 500, from: from, targetDate: from), 500);
  });
}
```

`test/core/money/money_semantics_test.dart`
```dart
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
```

- [ ] **Step 2: Run to see them fail**

Run: `flutter test test/core/money`
Expected: compilation errors (files missing).

- [ ] **Step 3: Implement**

`lib/core/money/money.dart`
```dart
import 'package:intl/intl.dart';

/// An amount of Naira held as integer kobo (ported from Kiba's Money, NGN only).
///
/// `int` in, `int` out: even [format] splits whole and fractional parts with
/// integer division so nothing is rounded on the way to the screen.
class Money implements Comparable<Money> {
  const Money(this.kobo);
  const Money.zero() : kobo = 0;

  final int kobo;

  /// What a hidden balance shows behind the eye toggle.
  static const String masked = '••••••';

  static final NumberFormat _grouped = NumberFormat('#,##0', 'en_US');

  bool get isZero => kobo == 0;
  bool get isNegative => kobo < 0;

  String format({bool withSymbol = true}) {
    final sign = kobo < 0 ? '-' : '';
    final abs = kobo.abs();
    final whole = _grouped.format(abs ~/ 100);
    final minor = (abs % 100).toString().padLeft(2, '0');
    return '$sign${withSymbol ? '₦' : ''}$whole.$minor';
  }

  Money operator +(Money other) => Money(kobo + other.kobo);
  Money operator -(Money other) => Money(kobo - other.kobo);
  bool operator >(Money other) => kobo > other.kobo;
  bool operator <(Money other) => kobo < other.kobo;

  @override
  int compareTo(Money other) => kobo.compareTo(other.kobo);

  @override
  bool operator ==(Object other) => other is Money && other.kobo == kobo;

  @override
  int get hashCode => kobo.hashCode;

  @override
  String toString() => 'Money($kobo kobo)';
}
```

`lib/core/money/kobo_parser.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

import '../../config/flavor/app_constants.dart';

enum KoboParseError { empty, invalid, tooManyDecimals, tooLarge }

/// Turns what a user typed into integer kobo without ever touching a double.
///
/// `double.parse('0.29') * 100` is 28.999999999999996, which truncates to 28
/// kobo. Splitting on '.' and parsing both halves as ints avoids that class of
/// bug entirely.
abstract class KoboParser {
  static final RegExp _shape = RegExp(r'^\d+(\.\d*)?$');
  static final NumberFormat _grouped = NumberFormat('#,##0', 'en_US');

  /// 13 whole digits is already far above [AppConstants.maxAmountKobo]; checking
  /// length first means int.parse can never overflow.
  static const int _maxWholeDigits = 13;

  static Either<KoboParseError, int> parse(
    String input, {
    int maxKobo = AppConstants.maxAmountKobo,
  }) {
    final cleaned =
        input.replaceAll('₦', '').replaceAll(',', '').replaceAll(' ', '').trim();
    if (cleaned.isEmpty) return left(KoboParseError.empty);
    if (!_shape.hasMatch(cleaned)) return left(KoboParseError.invalid);

    final parts = cleaned.split('.');
    final wholeDigits = parts[0].replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final fracDigits = parts.length > 1 ? parts[1] : '';

    if (fracDigits.length > 2) return left(KoboParseError.tooManyDecimals);
    if (wholeDigits.length > _maxWholeDigits) return left(KoboParseError.tooLarge);

    final kobo = int.parse(wholeDigits) * 100 + int.parse(fracDigits.padRight(2, '0'));
    if (kobo > maxKobo) return left(KoboParseError.tooLarge);
    return right(kobo);
  }

  /// Text to prefill an input with (quick-amount chips): `1,000` or `1,500.50`.
  static String toInputText(int kobo) {
    final whole = _grouped.format(kobo ~/ 100);
    final minor = kobo % 100;
    return minor == 0 ? whole : '$whole.${minor.toString().padLeft(2, '0')}';
  }
}
```

`lib/core/money/fees.dart`
```dart
/// Fictional NIP-style transfer fee bands, in kobo (spec assumption A5).
abstract class Fees {
  static const int _band1UpperKobo = 500000; // ₦5,000.00
  static const int _band2UpperKobo = 5000000; // ₦50,000.00

  static int transferFeeKobo(int amountKobo) {
    if (amountKobo <= 0) return 0;
    if (amountKobo <= _band1UpperKobo) return 1075; // ₦10.75
    if (amountKobo <= _band2UpperKobo) return 2688; // ₦26.88
    return 5375; // ₦53.75
  }
}
```

`lib/core/money/progress.dart`
```dart
/// Savings progress in integer basis points (10000 = 100%).
abstract class Progress {
  static const int full = 10000;

  static int bps({required int savedKobo, required int targetKobo}) {
    if (targetKobo <= 0 || savedKobo <= 0) return 0;
    if (savedKobo >= targetKobo) return full;
    return savedKobo * full ~/ targetKobo;
  }

  /// `3500` → `35%`, `3550` → `35.5%`, `3333` → `33.33%`.
  static String formatPercent(int bps) {
    final whole = bps ~/ 100;
    final frac = bps % 100;
    if (frac == 0) return '$whole%';
    if (frac % 10 == 0) return '$whole.${frac ~/ 10}%';
    return '$whole.${frac.toString().padLeft(2, '0')}%';
  }

  /// Weekly amount that reaches the goal by [targetDate], rounded **up**.
  static int suggestedWeeklyKobo({
    required int remainingKobo,
    required DateTime from,
    required DateTime targetDate,
  }) {
    if (remainingKobo <= 0) return 0;
    // UTC dates so a DST change on the test machine can't shave off a day.
    final start = DateTime.utc(from.year, from.month, from.day);
    final end = DateTime.utc(targetDate.year, targetDate.month, targetDate.day);
    final days = end.difference(start).inDays;
    if (days <= 0) return remainingKobo;
    final weeks = (days + 6) ~/ 7;
    return (remainingKobo + weeks - 1) ~/ weeks;
  }
}
```

`lib/core/money/money_semantics.dart`
```dart
import 'package:intl/intl.dart';

/// Screen-reader label for an amount.
///
/// TalkBack/VoiceOver read "₦12,500.50" as "N twelve thousand five hundred
/// point five zero". Naming the units reads naturally in both languages while
/// leaving the digits for the TTS engine to voice in its own language.
abstract class MoneySemantics {
  static final NumberFormat _grouped = NumberFormat('#,##0', 'en_US');

  static String label(int kobo, {required String languageCode}) {
    final naira = _grouped.format(kobo.abs() ~/ 100);
    final minor = kobo.abs() % 100;

    if (languageCode == 'yo') {
      final base = minor == 0 ? 'náírà $naira' : 'náírà $naira àti kọ́bọ̀ $minor';
      return kobo < 0 ? 'àyọkúrò $base' : base;
    }

    final base = minor == 0 ? '$naira naira' : '$naira naira $minor kobo';
    return kobo < 0 ? 'minus $base' : base;
  }
}
```

- [ ] **Step 4: Run the tests**

Run: `flutter test test/core/money`
Expected: all PASS.

- [ ] **Step 5: Checkpoint**. Report the files for the user to commit. Note for `AI_USAGE.md`: the Kiba withdraw controller's `double.tryParse` would fail the `0.29` test.

---

### Task 3: Failures and small utilities (phone, masking, hashing, mutex, streams)

**Files:**
- Create: `lib/core/api/exception/failure.dart`, `lib/core/utils/phone.dart`, `lib/core/utils/masking.dart`, `lib/core/auth/secret_hasher.dart`, `lib/core/utils/async_mutex.dart`, `lib/core/utils/streams.dart`
- Test: `test/core/utils/utils_test.dart`, `test/core/utils/async_mutex_test.dart`

**Interfaces:**
- Produces:
  - `sealed class Failure extends Equatable { String get message; String failureMessage(); }`
  - `class NetworkFailure extends Failure { const NetworkFailure({String message = 'No internet connection.', bool timedOut = false}); final bool timedOut; }`
  - `enum BusinessCode { insufficientFunds, tierLimitExceeded, invalidAccount, goalNotFound, invalidCredentials, accountExists, invalidOtp, invalidBvn, unauthorized }`
  - `class BusinessFailure extends Failure { const BusinessFailure(this.code, String message); final BusinessCode code; }`
  - `enum ValidationCode { amountTooSmall, amountTooLarge, tierLimitExceeded, insufficientAvailable, invalidInput, wrongPin, pinMismatch, locked, offline }`
  - `class ValidationFailure extends Failure { const ValidationFailure(this.code, String message); final ValidationCode code; }`
  - `class StorageFailure extends Failure { const StorageFailure(String message); }`
  - `abstract class PhoneNumber { static String? normalize(String input); }` returns an 11-digit local form `0XXXXXXXXXX` or null
  - `abstract class Masking { static String account(String accountNumber); }` → `'•••• 4821'`
  - `class SecretHasher { SecretHasher({Random? random}); String newSalt(); String hash(String secret, String salt); bool verify(String secret, String salt, String expectedHash); }`
  - `class AsyncMutex { Future<T> synchronized<T>(Future<T> Function() body); }`
  - `Stream<R> combineLatest2<A, B, R>(Stream<A> a, Stream<B> b, R Function(A, B) combine)`

- [ ] **Step 1: Write the failing tests**

`test/core/utils/utils_test.dart`
```dart
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
```

`test/core/utils/async_mutex_test.dart`
```dart
import 'dart:async';

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
```

- [ ] **Step 2: Run to see them fail**

Run: `flutter test test/core/utils`
Expected: compilation errors.

- [ ] **Step 3: Implement**

`lib/core/api/exception/failure.dart`
```dart
import 'package:equatable/equatable.dart';

/// Every recoverable error crossing the repository boundary.
///
/// Sealed so `switch` over a failure is exhaustive. That matters in the sync
/// engine, where the failure type decides between "retry with the same key"
/// ([NetworkFailure]) and "stop, tell the user" ([BusinessFailure]).
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  /// Kiba-compatible accessor.
  String failureMessage() => message;

  @override
  List<Object?> get props => [runtimeType, message];
}

/// Offline, timeout or 5xx. The server may or may not have applied the request,
/// so the only safe move is a replay with the SAME idempotency key.
class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'No internet connection.', this.timedOut = false})
      : super(message);

  final bool timedOut;

  @override
  List<Object?> get props => [...super.props, timedOut];
}

enum BusinessCode {
  insufficientFunds,
  tierLimitExceeded,
  invalidAccount,
  goalNotFound,
  invalidCredentials,
  accountExists,
  invalidOtp,
  invalidBvn,
  unauthorized,
}

/// The server understood the request and said no. Terminal for that request.
class BusinessFailure extends Failure {
  const BusinessFailure(this.code, String message) : super(message);

  final BusinessCode code;

  @override
  List<Object?> get props => [...super.props, code];
}

enum ValidationCode {
  amountTooSmall,
  amountTooLarge,
  tierLimitExceeded,
  insufficientAvailable,
  invalidInput,
  wrongPin,
  pinMismatch,
  locked,
  offline,
}

/// Rejected on the device before anything was queued or sent.
class ValidationFailure extends Failure {
  const ValidationFailure(this.code, String message) : super(message);

  final ValidationCode code;

  @override
  List<Object?> get props => [...super.props, code];
}

/// Local persistence failed (Isar / secure storage).
class StorageFailure extends Failure {
  const StorageFailure(super.message);
}
```

`lib/core/utils/phone.dart`
```dart
/// Nigerian mobile numbers, normalised to the 11-digit local form `0XXXXXXXXXX`.
abstract class PhoneNumber {
  static final RegExp _local = RegExp(r'^0[789][01]\d{8}$');

  static String? normalize(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('234') && digits.length == 13) {
      digits = '0${digits.substring(3)}';
    } else if (digits.length == 10) {
      digits = '0$digits';
    }
    return _local.hasMatch(digits) ? digits : null;
  }
}
```

`lib/core/utils/masking.dart`
```dart
/// NDPA-friendly masking for identifiers shown on screen.
abstract class Masking {
  static String account(String accountNumber) {
    final tail = accountNumber.length <= 4
        ? accountNumber
        : accountNumber.substring(accountNumber.length - 4);
    return '•••• $tail';
  }
}
```

`lib/core/auth/secret_hasher.dart`
```dart
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Salted SHA-256 for the mock backend's passwords and the on-device PIN.
///
/// A production system would use a slow KDF (Argon2id/PBKDF2) and verify the
/// PIN server-side. This is documented as a mock trade-off in the README.
class SecretHasher {
  SecretHasher({Random? random}) : _random = random ?? Random.secure();

  final Random _random;

  String newSalt() => base64UrlEncode(List<int>.generate(16, (_) => _random.nextInt(256)));

  String hash(String secret, String salt) =>
      sha256.convert(utf8.encode('$salt:$secret')).toString();

  bool verify(String secret, String salt, String expectedHash) {
    final actual = hash(secret, salt);
    if (actual.length != expectedHash.length) return false;
    var diff = 0;
    for (var i = 0; i < actual.length; i++) {
      diff |= actual.codeUnitAt(i) ^ expectedHash.codeUnitAt(i);
    }
    return diff == 0;
  }
}
```

`lib/core/utils/async_mutex.dart`
```dart
import 'dart:async';

/// Serialises async critical sections in one isolate.
///
/// The sync engine holds it for a whole replay pass, and a wallet refresh holds
/// it too. A balance fetched mid-send can therefore never overwrite the balance
/// that send just applied.
class AsyncMutex {
  Future<void> _last = Future<void>.value();

  Future<T> synchronized<T>(Future<T> Function() body) {
    final previous = _last;
    final release = Completer<void>();
    _last = release.future;
    return previous.then((_) => body()).whenComplete(release.complete);
  }
}
```

`lib/core/utils/streams.dart`
```dart
import 'dart:async';

/// Emits `combine(latestA, latestB)` whenever either stream emits, once both
/// have emitted at least once. Small enough not to justify rxdart.
Stream<R> combineLatest2<A, B, R>(
  Stream<A> a,
  Stream<B> b,
  R Function(A, B) combine,
) {
  late StreamController<R> controller;
  StreamSubscription<A>? subA;
  StreamSubscription<B>? subB;
  A? lastA;
  B? lastB;
  var hasA = false;
  var hasB = false;

  void emit() {
    if (hasA && hasB) controller.add(combine(lastA as A, lastB as B));
  }

  controller = StreamController<R>(
    onListen: () {
      subA = a.listen((v) {
        lastA = v;
        hasA = true;
        emit();
      }, onError: controller.addError);
      subB = b.listen((v) {
        lastB = v;
        hasB = true;
        emit();
      }, onError: controller.addError);
    },
    onCancel: () async {
      await subA?.cancel();
      await subB?.cancel();
    },
  );
  return controller.stream;
}
```

- [ ] **Step 4: Run the tests**

Run: `flutter test test/core/utils`
Expected: all PASS.

- [ ] **Step 5: Checkpoint**. Report the files for the user to commit.

---

### Task 4: Domain models

**Files:**
- Create: `lib/core/models/bank.dart`, `profile.dart`, `beneficiary.dart`, `outbox_item.dart`, `wallet_overview.dart`, `activity_item.dart`, `goal_view.dart`
- Test: `test/core/models/models_test.dart`

**Interfaces:**
- Consumes: `AppConstants`, `Masking.account`, `Progress`
- Produces (exact names used by later tasks):
  - `class Bank { const Bank({required String code, required String name}); }`, `abstract class Banks { static const List<Bank> all; static Bank? byCode(String code); }`
  - `class Profile { fullName, phone, email, int tier, bool bvnVerified, accountNumber; String get firstName; int get singleSendCapKobo; Profile copyWith({int? tier, bool? bvnVerified}); }`
  - `class Beneficiary { accountNumber, bankCode, bankName, verifiedName, DateTime? lastUsedAt; String get maskedAccount; }`
  - `enum OutboxType { send, createGoal, contribute }`, `enum OutboxStatus { queued, sending, succeeded, failed }`
  - `class OutboxItem { int id; String idempotencyKey; OutboxType type; OutboxStatus status; int amountKobo; int feeKobo; String payloadJson; String? goalClientId; String? counterpartyName; String? counterpartyBank; String? maskedAccount; String? narration; int attempts; DateTime? nextAttemptAt; DateTime createdAt; DateTime? lastAttemptAt; DateTime? completedAt; String? serverRef; String? failureCode; String? failureMessage; bool queuedWhileOffline; String? biometricSignature; int get debitKobo; bool get isActive; bool get isTerminal; }`
  - `class WalletOverview { int ledgerKobo; int heldKobo; int pendingCount; DateTime? lastSyncedAt; int get availableKobo; static const WalletOverview empty; }`
  - `enum ActivityStatus { pending, sending, failed, completed }`, `enum ActivityKind { transfer, contribution, credit, goalCreated }`, `enum ActivityDirection { debit, credit }`
  - `class ActivityItem { String id; ActivityStatus status; ActivityKind kind; ActivityDirection direction; int amountKobo; int feeKobo; String title; String? subtitle; String? narration; DateTime createdAt; int? outboxId; String? serverRef; String? failureMessage; String? goalClientId; int get signedKobo; }`
  - `enum GoalSyncState { pending, synced, failed }`
  - `class GoalView { clientId, name, int targetKobo, DateTime targetDate, int savedKobo, int pendingKobo, GoalSyncState syncState, DateTime createdAt; int get savedBps; int get projectedBps; int get remainingKobo; }`

- [ ] **Step 1: Write the failing test** `test/core/models/models_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/models/activity_item.dart';
import 'package:nova_wallet/core/models/bank.dart';
import 'package:nova_wallet/core/models/beneficiary.dart';
import 'package:nova_wallet/core/models/goal_view.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/models/profile.dart';
import 'package:nova_wallet/core/models/wallet_overview.dart';

void main() {
  final now = DateTime(2026, 9, 15, 14);

  test('Profile derives first name and tier cap', () {
    const p = Profile(
        fullName: '  Tolu  Adebayo ', phone: '08012345678', email: 't@x.com',
        tier: 1, bvnVerified: false, accountNumber: '8012345678');
    expect(p.firstName, 'Tolu');
    expect(p.singleSendCapKobo, AppConstants.tier1SingleSendCapKobo);
    expect(p.copyWith(tier: 2).singleSendCapKobo, AppConstants.tier2SingleSendCapKobo);
  });

  test('Banks lookup and beneficiary masking', () {
    expect(Banks.byCode('058')!.name, 'GTBank');
    expect(Banks.byCode('nope'), isNull);
    const b = Beneficiary(accountNumber: '0123454821', bankCode: '058', bankName: 'GTBank', verifiedName: 'ADAEZE OKAFOR');
    expect(b.maskedAccount, '•••• 4821');
  });

  test('OutboxItem debit and state helpers', () {
    final item = OutboxItem(
      id: 1, idempotencyKey: 'k', type: OutboxType.send, status: OutboxStatus.queued,
      amountKobo: 2500000, feeKobo: 2688, payloadJson: '{}', createdAt: now);
    expect(item.debitKobo, 2502688);
    expect(item.isActive, isTrue);
    expect(item.copyWith(status: OutboxStatus.failed).isTerminal, isTrue);
  });

  test('WalletOverview.available subtracts holds', () {
    const o = WalletOverview(ledgerKobo: 18645025, heldKobo: 5502688, pendingCount: 2);
    expect(o.availableKobo, 13142337);
    expect(WalletOverview.empty.availableKobo, 0);
  });

  test('ActivityItem.signedKobo includes fee on debits only', () {
    final debit = ActivityItem(id: 'a', status: ActivityStatus.completed, kind: ActivityKind.transfer,
        direction: ActivityDirection.debit, amountKobo: 500000, feeKobo: 1075, title: 'Ada', createdAt: now);
    final credit = ActivityItem(id: 'b', status: ActivityStatus.completed, kind: ActivityKind.credit,
        direction: ActivityDirection.credit, amountKobo: 500000, title: 'Salary', createdAt: now);
    expect(debit.signedKobo, -501075);
    expect(credit.signedKobo, 500000);
  });

  test('GoalView progress in bps, pending projected separately', () {
    final g = GoalView(clientId: 'g', name: 'Rent', targetKobo: 60000000, targetDate: DateTime(2026, 12, 20),
        savedKobo: 21000000, pendingKobo: 500000, syncState: GoalSyncState.synced, createdAt: now);
    expect(g.savedBps, 3500);
    expect(g.projectedBps, 3583);
    expect(g.remainingKobo, 39000000);
  });
}
```

- [ ] **Step 2: Run to see it fail**

Run: `flutter test test/core/models/models_test.dart`
Expected: compilation errors.

- [ ] **Step 3: Implement the models**

`lib/core/models/bank.dart`
```dart
import 'package:equatable/equatable.dart';

class Bank extends Equatable {
  const Bank({required this.code, required this.name});

  final String code;
  final String name;

  @override
  List<Object?> get props => [code, name];
}

/// Fixed list for the new-recipient bank picker (no network needed to show it).
abstract class Banks {
  static const List<Bank> all = [
    Bank(code: '044', name: 'Access Bank'),
    Bank(code: '058', name: 'GTBank'),
    Bank(code: '011', name: 'First Bank'),
    Bank(code: '033', name: 'UBA'),
    Bank(code: '057', name: 'Zenith Bank'),
    Bank(code: '50515', name: 'Moniepoint MFB'),
    Bank(code: '999992', name: 'OPay'),
    Bank(code: '999991', name: 'PalmPay'),
  ];

  static Bank? byCode(String code) {
    for (final bank in all) {
      if (bank.code == code) return bank;
    }
    return null;
  }
}
```

`lib/core/models/profile.dart`
```dart
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

  int get singleSendCapKobo => tier >= 2
      ? AppConstants.tier2SingleSendCapKobo
      : AppConstants.tier1SingleSendCapKobo;

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
```

`lib/core/models/beneficiary.dart`
```dart
import 'package:equatable/equatable.dart';

import '../utils/masking.dart';

/// A recipient whose name was verified online (NIP name enquiry) and cached.
/// Only these can receive a transfer queued while offline (spec A2).
class Beneficiary extends Equatable {
  const Beneficiary({
    required this.accountNumber,
    required this.bankCode,
    required this.bankName,
    required this.verifiedName,
    this.lastUsedAt,
  });

  final String accountNumber;
  final String bankCode;
  final String bankName;
  final String verifiedName;
  final DateTime? lastUsedAt;

  String get maskedAccount => Masking.account(accountNumber);

  @override
  List<Object?> get props => [accountNumber, bankCode, bankName, verifiedName, lastUsedAt];
}
```

`lib/core/models/outbox_item.dart`
```dart
import 'package:equatable/equatable.dart';

enum OutboxType { send, createGoal, contribute }

enum OutboxStatus { queued, sending, succeeded, failed }

/// Immutable view of one persisted user intent in the outbox.
class OutboxItem extends Equatable {
  const OutboxItem({
    required this.id,
    required this.idempotencyKey,
    required this.type,
    required this.status,
    required this.amountKobo,
    required this.payloadJson,
    required this.createdAt,
    this.feeKobo = 0,
    this.goalClientId,
    this.counterpartyName,
    this.counterpartyBank,
    this.maskedAccount,
    this.narration,
    this.attempts = 0,
    this.nextAttemptAt,
    this.lastAttemptAt,
    this.completedAt,
    this.serverRef,
    this.failureCode,
    this.failureMessage,
    this.queuedWhileOffline = false,
    this.biometricSignature,
  });

  final int id;
  final String idempotencyKey;
  final OutboxType type;
  final OutboxStatus status;
  final int amountKobo;
  final int feeKobo;
  final String payloadJson;
  final String? goalClientId;
  final String? counterpartyName;
  final String? counterpartyBank;
  final String? maskedAccount;
  final String? narration;
  final int attempts;
  final DateTime? nextAttemptAt;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  final DateTime? completedAt;
  final String? serverRef;
  final String? failureCode;
  final String? failureMessage;
  final bool queuedWhileOffline;
  final String? biometricSignature;

  int get debitKobo => amountKobo + feeKobo;
  bool get isActive => status == OutboxStatus.queued || status == OutboxStatus.sending;
  bool get isTerminal => status == OutboxStatus.succeeded || status == OutboxStatus.failed;

  OutboxItem copyWith({OutboxStatus? status, int? attempts}) => OutboxItem(
        id: id,
        idempotencyKey: idempotencyKey,
        type: type,
        status: status ?? this.status,
        amountKobo: amountKobo,
        feeKobo: feeKobo,
        payloadJson: payloadJson,
        goalClientId: goalClientId,
        counterpartyName: counterpartyName,
        counterpartyBank: counterpartyBank,
        maskedAccount: maskedAccount,
        narration: narration,
        attempts: attempts ?? this.attempts,
        nextAttemptAt: nextAttemptAt,
        createdAt: createdAt,
        lastAttemptAt: lastAttemptAt,
        completedAt: completedAt,
        serverRef: serverRef,
        failureCode: failureCode,
        failureMessage: failureMessage,
        queuedWhileOffline: queuedWhileOffline,
        biometricSignature: biometricSignature,
      );

  @override
  List<Object?> get props => [
        id, idempotencyKey, type, status, amountKobo, feeKobo, payloadJson, goalClientId,
        counterpartyName, counterpartyBank, maskedAccount, narration, attempts, nextAttemptAt,
        createdAt, lastAttemptAt, completedAt, serverRef, failureCode, failureMessage,
        queuedWhileOffline, biometricSignature,
      ];
}
```

`lib/core/models/wallet_overview.dart`
```dart
import 'package:equatable/equatable.dart';

/// Balance as the Home screen shows it. [heldKobo] is derived from active
/// outbox debits, never stored, so it can't drift from the items causing it.
class WalletOverview extends Equatable {
  const WalletOverview({
    required this.ledgerKobo,
    required this.heldKobo,
    required this.pendingCount,
    this.lastSyncedAt,
  });

  static const WalletOverview empty = WalletOverview(ledgerKobo: 0, heldKobo: 0, pendingCount: 0);

  /// Last server-confirmed balance.
  final int ledgerKobo;
  final int heldKobo;
  final int pendingCount;
  final DateTime? lastSyncedAt;

  int get availableKobo => ledgerKobo - heldKobo;

  @override
  List<Object?> get props => [ledgerKobo, heldKobo, pendingCount, lastSyncedAt];
}
```

`lib/core/models/activity_item.dart`
```dart
import 'package:equatable/equatable.dart';

enum ActivityStatus { pending, sending, failed, completed }

enum ActivityKind { transfer, contribution, credit, goalCreated }

enum ActivityDirection { debit, credit }

/// One row in a transaction list: a settled server transaction or an
/// unfinished outbox item.
class ActivityItem extends Equatable {
  const ActivityItem({
    required this.id,
    required this.status,
    required this.kind,
    required this.direction,
    required this.amountKobo,
    required this.title,
    required this.createdAt,
    this.feeKobo = 0,
    this.subtitle,
    this.narration,
    this.outboxId,
    this.serverRef,
    this.failureMessage,
    this.goalClientId,
  });

  final String id;
  final ActivityStatus status;
  final ActivityKind kind;
  final ActivityDirection direction;
  final int amountKobo;
  final int feeKobo;
  final String title;
  final String? subtitle;
  final String? narration;
  final DateTime createdAt;
  final int? outboxId;
  final String? serverRef;
  final String? failureMessage;
  final String? goalClientId;

  /// Negative for money leaving the wallet (amount + fee), positive otherwise.
  int get signedKobo =>
      direction == ActivityDirection.debit ? -(amountKobo + feeKobo) : amountKobo;

  @override
  List<Object?> get props => [
        id, status, kind, direction, amountKobo, feeKobo, title, subtitle, narration,
        createdAt, outboxId, serverRef, failureMessage, goalClientId,
      ];
}
```

`lib/core/models/goal_view.dart`
```dart
import 'dart:math';

import 'package:equatable/equatable.dart';

import '../money/progress.dart';

enum GoalSyncState { pending, synced, failed }

class GoalView extends Equatable {
  const GoalView({
    required this.clientId,
    required this.name,
    required this.targetKobo,
    required this.targetDate,
    required this.savedKobo,
    required this.pendingKobo,
    required this.syncState,
    required this.createdAt,
  });

  final String clientId;
  final String name;
  final int targetKobo;
  final DateTime targetDate;

  /// Server-confirmed.
  final int savedKobo;

  /// Sum of queued/sending contributions to this goal.
  final int pendingKobo;
  final GoalSyncState syncState;
  final DateTime createdAt;

  int get savedBps => Progress.bps(savedKobo: savedKobo, targetKobo: targetKobo);
  int get projectedBps => Progress.bps(savedKobo: savedKobo + pendingKobo, targetKobo: targetKobo);
  int get remainingKobo => max(0, targetKobo - savedKobo);

  @override
  List<Object?> get props =>
      [clientId, name, targetKobo, targetDate, savedKobo, pendingKobo, syncState, createdAt];
}
```

- [ ] **Step 4: Run the test**

Run: `flutter test test/core/models/models_test.dart`
Expected: PASS. (Check: 21,500,000 × 10000 ÷ 60,000,000 = 3583.)

- [ ] **Step 5: Checkpoint**. Report the files for the user to commit.

---

### Task 5: Storage (Isar entities, IsarDb, LocalStorage, SecureStorage, SessionStore)

**Files:**
- Create: `lib/core/storage/entities/outbox_item_entity.dart`, `wallet_snapshot_entity.dart`, `profile_entity.dart`, `transaction_entity.dart`, `beneficiary_entity.dart`, `goal_entity.dart`
- Create: `lib/core/api/fake/entities/server_entities.dart`
- Create: `lib/core/storage/isar_db.dart`, `local_storage.dart`, `local_storage_impl.dart`, `secure_storage.dart`, `secure_storage_impl.dart`, `session_store.dart`
- Create (test support): `test/support/isar_test_db.dart`, `test/support/in_memory_secure_storage.dart`
- Test: `test/core/storage/storage_test.dart`

**Interfaces:**
- Consumes: models from Task 4, `SecretHasher`, `AppConstants`
- Produces:
  - Entities (`OutboxItemEntity`, `WalletSnapshotEntity` (id 0), `ProfileEntity` (id 0), `TransactionEntity`, `BeneficiaryEntity`, `GoalEntity`) with `toModel()` / `toActivity()` and `static fromModel(...)` where noted.
  - Server entities `ServerAccount`, `ServerSession`, `ServerTransaction`, `ServerGoal`, `ServerBeneficiary`, `ProcessedRequest`
  - `class IsarDb { final Isar client; final Isar server; static Future<IsarDb> open({required String directory, String clientName, String serverName}); Future<void> clearClient(); Future<void> clearServer(); Future<void> close({bool deleteFromDisk = false}); }`
  - `abstract class LocalStorage` (methods below) + `LocalStorageImpl({required SharedPreferences prefs})`
  - `abstract class SecureStorage { write, read, delete, deleteAll }` + `SecureStorageImpl({required FlutterSecureStorage secureStorage})`
  - `class SessionStore { SessionStore({required SecureStorage secureStorage, required SecretHasher hasher}); Future<String?> readToken(); Future<void> saveToken(String token); Future<void> savePinHash({required String hash, required String salt}); Future<bool> hasPin(); Future<bool> verifyPin(String pin); Future<void> clear(); }`
  - Test support: `Future<IsarDb> openTestDb({required String directory, required String tag})`, `Future<String> newTempDir()`, `class InMemorySecureStorage implements SecureStorage`

- [ ] **Step 1: Create the client entities**

`lib/core/storage/entities/outbox_item_entity.dart`
```dart
import 'package:isar_community/isar.dart';

import '../../models/outbox_item.dart';

part 'outbox_item_entity.g.dart';

@collection
class OutboxItemEntity {
  /// Auto-increment ids are monotonic, so ascending id is the FIFO order.
  Id id = Isar.autoIncrement;

  /// Unique: two rows can never share a key, even under a bug.
  @Index(unique: true)
  late String idempotencyKey;

  @Enumerated(EnumType.name)
  late OutboxType type;

  @Index()
  @Enumerated(EnumType.name)
  late OutboxStatus status;

  late int amountKobo;
  int feeKobo = 0;
  late String payloadJson;

  @Index()
  String? goalClientId;

  String? counterpartyName;
  String? counterpartyBank;
  String? maskedAccount;
  String? narration;

  int attempts = 0;
  DateTime? nextAttemptAt;
  late DateTime createdAt;
  DateTime? lastAttemptAt;
  DateTime? completedAt;

  String? serverRef;
  String? failureCode;
  String? failureMessage;
  bool queuedWhileOffline = false;
  String? biometricSignature;

  @ignore
  int get debitKobo => amountKobo + feeKobo;

  OutboxItem toModel() => OutboxItem(
        id: id,
        idempotencyKey: idempotencyKey,
        type: type,
        status: status,
        amountKobo: amountKobo,
        feeKobo: feeKobo,
        payloadJson: payloadJson,
        goalClientId: goalClientId,
        counterpartyName: counterpartyName,
        counterpartyBank: counterpartyBank,
        maskedAccount: maskedAccount,
        narration: narration,
        attempts: attempts,
        nextAttemptAt: nextAttemptAt,
        createdAt: createdAt,
        lastAttemptAt: lastAttemptAt,
        completedAt: completedAt,
        serverRef: serverRef,
        failureCode: failureCode,
        failureMessage: failureMessage,
        queuedWhileOffline: queuedWhileOffline,
        biometricSignature: biometricSignature,
      );
}
```

`lib/core/storage/entities/wallet_snapshot_entity.dart`
```dart
import 'package:isar_community/isar.dart';

part 'wallet_snapshot_entity.g.dart';

/// Single row (id 0): the last server-confirmed balance.
@collection
class WalletSnapshotEntity {
  Id id = 0;
  late int ledgerBalanceKobo;
  DateTime? lastSyncedAt;
}
```

`lib/core/storage/entities/profile_entity.dart`
```dart
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
```

`lib/core/storage/entities/transaction_entity.dart`
```dart
import 'package:isar_community/isar.dart';

import '../../models/activity_item.dart';

part 'transaction_entity.g.dart';

/// Local cache of settled server transactions.
@collection
class TransactionEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String serverRef;

  @Enumerated(EnumType.name)
  late ActivityKind kind;

  @Enumerated(EnumType.name)
  late ActivityDirection direction;

  late int amountKobo;
  int feeKobo = 0;
  late String title;
  String? subtitle;
  String? narration;

  @Index()
  String? goalClientId;

  String? idempotencyKey;

  @Index()
  late DateTime createdAt;

  ActivityItem toActivity() => ActivityItem(
        id: 'txn:$serverRef',
        status: ActivityStatus.completed,
        kind: kind,
        direction: direction,
        amountKobo: amountKobo,
        feeKobo: feeKobo,
        title: title,
        subtitle: subtitle,
        narration: narration,
        createdAt: createdAt,
        serverRef: serverRef,
        goalClientId: goalClientId,
      );
}
```

`lib/core/storage/entities/beneficiary_entity.dart`
```dart
import 'package:isar_community/isar.dart';

import '../../models/beneficiary.dart';

part 'beneficiary_entity.g.dart';

@collection
class BeneficiaryEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, composite: [CompositeIndex('bankCode')])
  late String accountNumber;

  late String bankCode;
  late String bankName;
  late String verifiedName;
  late DateTime verifiedAt;
  DateTime? lastUsedAt;

  Beneficiary toModel() => Beneficiary(
        accountNumber: accountNumber,
        bankCode: bankCode,
        bankName: bankName,
        verifiedName: verifiedName,
        lastUsedAt: lastUsedAt,
      );
}
```

`lib/core/storage/entities/goal_entity.dart`
```dart
import 'package:isar_community/isar.dart';

import '../../models/goal_view.dart';

part 'goal_entity.g.dart';

@collection
class GoalEntity {
  Id id = Isar.autoIncrement;

  /// Created on the phone so contributions can reference a goal before it syncs.
  @Index(unique: true, replace: true)
  late String clientId;

  late String name;
  late int targetKobo;
  late DateTime targetDate;
  int savedKobo = 0;

  @Enumerated(EnumType.name)
  GoalSyncState syncState = GoalSyncState.pending;

  late DateTime createdAt;

  GoalView toView({required int pendingKobo}) => GoalView(
        clientId: clientId,
        name: name,
        targetKobo: targetKobo,
        targetDate: targetDate,
        savedKobo: savedKobo,
        pendingKobo: pendingKobo,
        syncState: syncState,
        createdAt: createdAt,
      );
}
```

- [ ] **Step 2: Create the fake-server entities** `lib/core/api/fake/entities/server_entities.dart`

```dart
import 'package:isar_community/isar.dart';

part 'server_entities.g.dart';

// Collections of the *fake remote*. They live in a separate Isar instance so
// they survive app restarts the way a real backend's database would.

@collection
class ServerAccount {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String phone;

  late String fullName;
  late String email;
  late String passwordHash;
  late String passwordSalt;
  String? pinHash;
  String? pinSalt;
  int tier = 1;
  bool bvnVerified = false;
  late int balanceKobo;
  late String accountNumber;
}

@collection
class ServerSession {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String token;

  late String phone;
  late DateTime issuedAt;
}

@collection
class ServerTransaction {
  Id id = Isar.autoIncrement;

  @Index()
  late String phone;

  @Index(unique: true)
  late String ref;

  /// `ActivityKind.name` / `ActivityDirection.name`.
  late String kind;
  late String direction;
  late int amountKobo;
  int feeKobo = 0;
  late String title;
  String? subtitle;
  String? narration;
  String? goalClientId;
  String? idempotencyKey;

  @Index()
  late DateTime createdAt;
}

@collection
class ServerGoal {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String clientId;

  @Index()
  late String phone;

  late String name;
  late int targetKobo;
  late DateTime targetDate;
  int savedKobo = 0;
  late DateTime createdAt;
}

@collection
class ServerBeneficiary {
  Id id = Isar.autoIncrement;

  @Index()
  late String phone;

  late String accountNumber;
  late String bankCode;
  late String bankName;
  late String accountName;
}

/// The idempotency record: key → the exact response first returned.
@collection
class ProcessedRequest {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String idempotencyKey;

  late String phone;
  late String endpoint;
  late String responseJson;
  late DateTime processedAt;
}
```

- [ ] **Step 3: Generate Isar code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: writes 7 `.g.dart` files, no errors.

- [ ] **Step 4: Write the failing test and support files**

`test/support/isar_test_db.dart`
```dart
import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:nova_wallet/core/storage/isar_db.dart';

bool _coreReady = false;

Future<String> newTempDir() async =>
    (await Directory.systemTemp.createTemp('nova_test')).path;

/// Opens client + server Isar in [directory]. Reopening with the same [tag]
/// and directory reads the same data back, which is how tests simulate a restart.
Future<IsarDb> openTestDb({required String directory, required String tag}) async {
  if (!_coreReady) {
    await Isar.initializeIsarCore(download: true);
    _coreReady = true;
  }
  return IsarDb.open(directory: directory, clientName: 'client_$tag', serverName: 'server_$tag');
}
```

`test/support/in_memory_secure_storage.dart`
```dart
import 'package:nova_wallet/core/storage/secure_storage.dart';

class InMemorySecureStorage implements SecureStorage {
  final Map<String, String> values = {};

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<void> deleteAll() async => values.clear();
}
```

`test/core/storage/storage_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:nova_wallet/core/auth/secret_hasher.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/storage/entities/outbox_item_entity.dart';
import 'package:nova_wallet/core/storage/isar_db.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/core/storage/session_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_secure_storage.dart';
import '../../support/isar_test_db.dart';

void main() {
  late IsarDb db;

  setUp(() async => db = await openTestDb(directory: await newTempDir(), tag: 'storage'));
  tearDown(() => db.close(deleteFromDisk: true));

  OutboxItemEntity item(String key) => OutboxItemEntity()
    ..idempotencyKey = key
    ..type = OutboxType.send
    ..status = OutboxStatus.queued
    ..amountKobo = 100
    ..payloadJson = '{}'
    ..createdAt = DateTime(2026, 9, 15);

  test('idempotency keys are unique at the database level', () async {
    await db.client.writeTxn(() => db.client.outboxItemEntitys.put(item('k1')));
    expect(
      () => db.client.writeTxn(() => db.client.outboxItemEntitys.put(item('k1'))),
      throwsA(isA<IsarError>()),
    );
  });

  test('reopening the same directory keeps data (restart)', () async {
    final dir = await newTempDir();
    var first = await openTestDb(directory: dir, tag: 'restart');
    await first.client.writeTxn(() => first.client.outboxItemEntitys.put(item('persisted')));
    await first.close();
    first = await openTestDb(directory: dir, tag: 'restart');
    expect(await first.client.outboxItemEntitys.getByIdempotencyKey('persisted'), isNotNull);
    await first.close(deleteFromDisk: true);
  });

  test('SessionStore keeps token + PIN hash in secure storage only', () async {
    final secure = InMemorySecureStorage();
    final hasher = SecretHasher();
    final store = SessionStore(secureStorage: secure, hasher: hasher);
    final salt = hasher.newSalt();
    await store.saveToken('tok');
    await store.savePinHash(hash: hasher.hash('1234', salt), salt: salt);
    expect(await store.readToken(), 'tok');
    expect(await store.hasPin(), isTrue);
    expect(await store.verifyPin('1234'), isTrue);
    expect(await store.verifyPin('0000'), isFalse);
    expect(secure.values.values, isNot(contains('1234')));
    await store.clear();
    expect(await store.readToken(), isNull);
    expect(await store.hasPin(), isFalse);
  });

  test('LocalStorage round-trips non-sensitive prefs', () async {
    SharedPreferences.setMockInitialValues({});
    final local = LocalStorageImpl(prefs: await SharedPreferences.getInstance());
    expect(await local.getOnboardingSeen(), isFalse);
    await local.saveOnboardingSeen(true);
    await local.saveLocaleCode('yo');
    await local.saveBiometricEnabled(true);
    await local.saveSimulateOffline(true);
    await local.saveLatencyMs(900);
    expect(await local.getOnboardingSeen(), isTrue);
    expect(await local.getLocaleCode(), 'yo');
    expect(await local.getSimulateOffline(), isTrue);
    expect(await local.getLatencyMs(), 900);
    await local.clearSessionScoped();
    expect(await local.getBiometricEnabled(), isFalse);
    expect(await local.getOnboardingSeen(), isTrue);
  });
}
```

- [ ] **Step 5: Run to see it fail**

Run: `flutter test test/core/storage/storage_test.dart`
Expected: compilation errors (`isar_db.dart`, `session_store.dart`, `local_storage_impl.dart` missing).

- [ ] **Step 6: Implement storage classes**

`lib/core/storage/isar_db.dart`
```dart
import 'package:isar_community/isar.dart';

import '../../config/flavor/app_constants.dart';
import '../api/fake/entities/server_entities.dart';
import 'entities/beneficiary_entity.dart';
import 'entities/goal_entity.dart';
import 'entities/outbox_item_entity.dart';
import 'entities/profile_entity.dart';
import 'entities/transaction_entity.dart';
import 'entities/wallet_snapshot_entity.dart';

/// Owns the two Isar instances: the app's own data (`client`) and the fake
/// backend's data (`server`). Keeping them separate means wiping the device
/// (sign-out) never wipes the "remote", just like reality.
class IsarDb {
  IsarDb._(this.client, this.server);

  final Isar client;
  final Isar server;

  static final List<CollectionSchema<dynamic>> clientSchemas = [
    OutboxItemEntitySchema,
    WalletSnapshotEntitySchema,
    ProfileEntitySchema,
    TransactionEntitySchema,
    BeneficiaryEntitySchema,
    GoalEntitySchema,
  ];

  static final List<CollectionSchema<dynamic>> serverSchemas = [
    ServerAccountSchema,
    ServerSessionSchema,
    ServerTransactionSchema,
    ServerGoalSchema,
    ServerBeneficiarySchema,
    ProcessedRequestSchema,
  ];

  static Future<IsarDb> open({
    required String directory,
    String clientName = AppConstants.clientDbName,
    String serverName = AppConstants.serverDbName,
  }) async {
    final client = Isar.getInstance(clientName) ??
        await Isar.open(clientSchemas, directory: directory, name: clientName);
    final server = Isar.getInstance(serverName) ??
        await Isar.open(serverSchemas, directory: directory, name: serverName);
    return IsarDb._(client, server);
  }

  Future<void> clearClient() => client.writeTxn(() => client.clear());
  Future<void> clearServer() => server.writeTxn(() => server.clear());

  Future<void> close({bool deleteFromDisk = false}) async {
    if (client.isOpen) await client.close(deleteFromDisk: deleteFromDisk);
    if (server.isOpen) await server.close(deleteFromDisk: deleteFromDisk);
  }
}
```

`lib/core/storage/local_storage.dart`
```dart
/// Non-sensitive preferences only (SharedPreferences). Anything secret goes to
/// [SecureStorage]; the brief forbids tokens in plain SharedPreferences.
abstract class LocalStorage {
  Future<String?> getLocaleCode();
  Future<void> saveLocaleCode(String code);

  Future<bool> getOnboardingSeen();
  Future<void> saveOnboardingSeen(bool seen);

  Future<bool> getBiometricEnabled();
  Future<void> saveBiometricEnabled(bool enabled);

  // Developer panel
  Future<bool> getSimulateOffline();
  Future<void> saveSimulateOffline(bool value);
  Future<int?> getLatencyMs();
  Future<void> saveLatencyMs(int ms);

  /// Clears values tied to the signed-in user (keeps onboarding + locale).
  Future<void> clearSessionScoped();
}
```

`lib/core/storage/local_storage_impl.dart`
```dart
import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage.dart';

class LocalStorageImpl implements LocalStorage {
  LocalStorageImpl({required this.prefs});

  final SharedPreferences prefs;

  static const _locale = 'nova.locale';
  static const _onboardingSeen = 'nova.onboarding_seen';
  static const _biometricEnabled = 'nova.biometric_enabled';
  static const _simulateOffline = 'nova.dev.simulate_offline';
  static const _latencyMs = 'nova.dev.latency_ms';

  @override
  Future<String?> getLocaleCode() async => prefs.getString(_locale);
  @override
  Future<void> saveLocaleCode(String code) => prefs.setString(_locale, code);

  @override
  Future<bool> getOnboardingSeen() async => prefs.getBool(_onboardingSeen) ?? false;
  @override
  Future<void> saveOnboardingSeen(bool seen) => prefs.setBool(_onboardingSeen, seen);

  @override
  Future<bool> getBiometricEnabled() async => prefs.getBool(_biometricEnabled) ?? false;
  @override
  Future<void> saveBiometricEnabled(bool enabled) => prefs.setBool(_biometricEnabled, enabled);

  @override
  Future<bool> getSimulateOffline() async => prefs.getBool(_simulateOffline) ?? false;
  @override
  Future<void> saveSimulateOffline(bool value) => prefs.setBool(_simulateOffline, value);

  @override
  Future<int?> getLatencyMs() async => prefs.getInt(_latencyMs);
  @override
  Future<void> saveLatencyMs(int ms) => prefs.setInt(_latencyMs, ms);

  @override
  Future<void> clearSessionScoped() async {
    await prefs.remove(_biometricEnabled);
  }
}
```

`lib/core/storage/secure_storage.dart`
```dart
abstract class SecureStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}
```

`lib/core/storage/secure_storage_impl.dart`
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage.dart';

class SecureStorageImpl implements SecureStorage {
  SecureStorageImpl({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  @override
  Future<void> write(String key, String value) => secureStorage.write(key: key, value: value);
  @override
  Future<String?> read(String key) => secureStorage.read(key: key);
  @override
  Future<void> delete(String key) => secureStorage.delete(key: key);
  @override
  Future<void> deleteAll() => secureStorage.deleteAll();
}
```

`lib/core/storage/session_store.dart`
```dart
import '../auth/secret_hasher.dart';
import 'secure_storage.dart';

abstract class SecureKeys {
  static const sessionToken = 'nova.session_token';
  static const pinHash = 'nova.pin_hash';
  static const pinSalt = 'nova.pin_salt';
}

/// Session secrets, always in secure storage.
class SessionStore {
  SessionStore({required this.secureStorage, required this.hasher});

  final SecureStorage secureStorage;
  final SecretHasher hasher;

  Future<String?> readToken() => secureStorage.read(SecureKeys.sessionToken);
  Future<void> saveToken(String token) => secureStorage.write(SecureKeys.sessionToken, token);

  Future<void> savePinHash({required String hash, required String salt}) async {
    await secureStorage.write(SecureKeys.pinHash, hash);
    await secureStorage.write(SecureKeys.pinSalt, salt);
  }

  Future<bool> hasPin() async => (await secureStorage.read(SecureKeys.pinHash)) != null;

  /// Local check so unlock and send authorisation work offline (spec A8).
  Future<bool> verifyPin(String pin) async {
    final hash = await secureStorage.read(SecureKeys.pinHash);
    final salt = await secureStorage.read(SecureKeys.pinSalt);
    if (hash == null || salt == null) return false;
    return hasher.verify(pin, salt, hash);
  }

  Future<void> clear() async {
    await secureStorage.delete(SecureKeys.sessionToken);
    await secureStorage.delete(SecureKeys.pinHash);
    await secureStorage.delete(SecureKeys.pinSalt);
  }
}
```

- [ ] **Step 7: Run the test**

Run: `flutter test test/core/storage/storage_test.dart`
Expected: PASS (the first run downloads `libisar` and takes about 10 s).

- [ ] **Step 8: Checkpoint**. Report the files for the user to commit (the `.g.dart` files included).

---

### Task 6: Network: NetworkInfo, FakeServerControls, Reachability, ConnectivityCubit

**Files:**
- Create: `lib/core/network/network_info.dart`, `network_info_impl.dart`, `reachability.dart`
- Create: `lib/core/api/fake/fake_server_controls.dart`
- Create: `lib/features/connectivity/cubit/connectivity_cubit.dart`
- Create (test support): `test/support/fake_network_info.dart`
- Test: `test/features/connectivity/connectivity_cubit_test.dart`

**Interfaces:**
- Consumes: `AppConstants.connectivityDebounce`
- Produces:
  - `abstract class NetworkInfo { Future<bool> get isConnected; Stream<bool> get onConnectivityChanged; }`
  - `class FakeServerControls { FakeServerControls({bool simulateOffline = false, Duration minLatency = 400ms, Duration maxLatency = 1200ms}); bool simulateOffline (get/set, emits); Stream<bool> get simulateOfflineChanges; bool loseNextResponse; Duration minLatency; Duration maxLatency; void setLatencyMs(int ms); Future<void> dispose(); }`
  - `class Reachability { Reachability({required NetworkInfo networkInfo, required FakeServerControls controls}); Future<bool> get isReachable; Stream<bool> get onChanged; }`
  - `enum ConnectivityStatus { unknown, online, offline }`
  - `class ConnectivityCubit extends Cubit<ConnectivityStatus> { ConnectivityCubit({required Reachability reachability, Duration onlineDebounce}); bool get isOnline; Future<void> start(); Future<void> recheck(); }`
  - Test support: `class FakeNetworkInfo implements NetworkInfo { FakeNetworkInfo({bool connected = true}); bool connected (get/set, emits); }`

- [ ] **Step 1: Create the test support and failing test**

`test/support/fake_network_info.dart`
```dart
import 'dart:async';

import 'package:nova_wallet/core/network/network_info.dart';

/// Scriptable connectivity, the unit-test stand-in for airplane mode.
class FakeNetworkInfo implements NetworkInfo {
  FakeNetworkInfo({bool connected = true}) : _connected = connected;

  bool _connected;
  final _controller = StreamController<bool>.broadcast();

  bool get connected => _connected;

  set connected(bool value) {
    _connected = value;
    _controller.add(value);
  }

  @override
  Future<bool> get isConnected async => _connected;

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;
}
```

`test/features/connectivity/connectivity_cubit_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/api/fake/fake_server_controls.dart';
import 'package:nova_wallet/core/network/reachability.dart';
import 'package:nova_wallet/features/connectivity/cubit/connectivity_cubit.dart';

import '../../support/fake_network_info.dart';

void main() {
  late FakeNetworkInfo network;
  late FakeServerControls controls;
  late ConnectivityCubit cubit;
  const debounce = Duration(milliseconds: 30);

  setUp(() {
    network = FakeNetworkInfo();
    controls = FakeServerControls(minLatency: Duration.zero, maxLatency: Duration.zero);
    cubit = ConnectivityCubit(
      reachability: Reachability(networkInfo: network, controls: controls),
      onlineDebounce: debounce,
    );
  });

  tearDown(() async {
    await cubit.close();
    await controls.dispose();
  });

  test('start reports the current state immediately', () async {
    await cubit.start();
    expect(cubit.state, ConnectivityStatus.online);
  });

  test('going offline is immediate', () async {
    await cubit.start();
    network.connected = false;
    await pumpEventQueue();
    expect(cubit.state, ConnectivityStatus.offline);
  });

  test('a flapping connection produces ONE online event after the debounce', () async {
    network.connected = false;
    await cubit.start();
    final states = <ConnectivityStatus>[];
    final sub = cubit.stream.listen(states.add);

    for (var i = 0; i < 5; i++) {
      network.connected = true;
      await pumpEventQueue();
      network.connected = false;
      await pumpEventQueue();
    }
    network.connected = true;
    await Future<void>.delayed(debounce * 3);

    expect(states.where((s) => s == ConnectivityStatus.online).length, 1);
    expect(cubit.state, ConnectivityStatus.online);
    await sub.cancel();
  });

  test('the developer "simulate offline" switch overrides real connectivity', () async {
    await cubit.start();
    controls.simulateOffline = true;
    await pumpEventQueue();
    expect(cubit.state, ConnectivityStatus.offline);
    controls.simulateOffline = false;
    await Future<void>.delayed(debounce * 3);
    expect(cubit.state, ConnectivityStatus.online);
  });
}
```

- [ ] **Step 2: Run to see it fail**

Run: `flutter test test/features/connectivity`
Expected: compilation errors.

- [ ] **Step 3: Implement**

`lib/core/network/network_info.dart`
```dart
/// Whether a network interface is up. This is not proof that the internet
/// works (captive portals, dead data plans). [Reachability] layers on top.
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}
```

`lib/core/network/network_info_impl.dart`
```dart
import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({Connectivity? connectivity}) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static bool _anyUp(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  @override
  Future<bool> get isConnected async => _anyUp(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get onConnectivityChanged => _connectivity.onConnectivityChanged.map(_anyUp);
}
```

`lib/core/api/fake/fake_server_controls.dart`
```dart
import 'dart:async';

/// Knobs for the live demo and for tests. They drive [FakeNovaServer] and
/// [Reachability].
class FakeServerControls {
  FakeServerControls({
    bool simulateOffline = false,
    this.minLatency = const Duration(milliseconds: 400),
    this.maxLatency = const Duration(milliseconds: 1200),
  }) : _simulateOffline = simulateOffline;

  final _changes = StreamController<bool>.broadcast();
  bool _simulateOffline;

  /// When true the fake server behaves as unreachable, even on Wi-Fi.
  bool get simulateOffline => _simulateOffline;

  set simulateOffline(bool value) {
    if (value == _simulateOffline) return;
    _simulateOffline = value;
    _changes.add(value);
  }

  Stream<bool> get simulateOfflineChanges => _changes.stream;

  /// The next mutating request is APPLIED on the server, but the phone gets a
  /// timeout. This reproduces "server accepted, response lost".
  bool loseNextResponse = false;

  Duration minLatency;
  Duration maxLatency;

  void setLatencyMs(int ms) {
    minLatency = Duration(milliseconds: ms);
    maxLatency = Duration(milliseconds: ms);
  }

  Future<void> dispose() => _changes.close();
}
```

`lib/core/network/reachability.dart`
```dart
import 'dart:async';

import '../api/fake/fake_server_controls.dart';
import 'network_info.dart';

/// "Can we reach the backend?" Interface up AND the simulate-offline switch off.
/// A production build would also probe a health endpoint (spec A3).
class Reachability {
  Reachability({required this.networkInfo, required this.controls});

  final NetworkInfo networkInfo;
  final FakeServerControls controls;

  Future<bool> get isReachable async => !controls.simulateOffline && await networkInfo.isConnected;

  Stream<bool> get onChanged {
    late StreamController<bool> controller;
    StreamSubscription<bool>? network;
    StreamSubscription<bool>? simulated;

    Future<void> push() async {
      final reachable = await isReachable;
      if (!controller.isClosed) controller.add(reachable);
    }

    controller = StreamController<bool>(
      onListen: () {
        network = networkInfo.onConnectivityChanged.listen((_) => push());
        simulated = controls.simulateOfflineChanges.listen((_) => push());
      },
      onCancel: () async {
        await network?.cancel();
        await simulated?.cancel();
      },
    );
    return controller.stream;
  }
}
```

`lib/features/connectivity/cubit/connectivity_cubit.dart`
```dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/network/reachability.dart';

enum ConnectivityStatus { unknown, online, offline }

/// App-wide online/offline signal (offline banner, sync trigger).
///
/// Offline is reported immediately so the UI never promises an instant send it
/// can't make. Online is debounced so a flapping connection triggers one
/// replay, not five.
class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  ConnectivityCubit({
    required this.reachability,
    this.onlineDebounce = AppConstants.connectivityDebounce,
  }) : super(ConnectivityStatus.unknown);

  final Reachability reachability;
  final Duration onlineDebounce;

  StreamSubscription<bool>? _sub;
  Timer? _debounce;

  bool get isOnline => state == ConnectivityStatus.online;

  Future<void> start() async {
    if (_sub != null) return;
    _sub = reachability.onChanged.listen(_onRaw);
    final reachable = await reachability.isReachable;
    if (!isClosed) emit(reachable ? ConnectivityStatus.online : ConnectivityStatus.offline);
  }

  /// Called on app resume. The OS may not have sent an event while suspended.
  Future<void> recheck() async => _onRaw(await reachability.isReachable);

  void _onRaw(bool reachable) {
    _debounce?.cancel();
    if (!reachable) {
      if (state != ConnectivityStatus.offline && !isClosed) emit(ConnectivityStatus.offline);
      return;
    }
    if (state == ConnectivityStatus.online) return;
    _debounce = Timer(onlineDebounce, () {
      if (!isClosed) emit(ConnectivityStatus.online);
    });
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    await _sub?.cancel();
    return super.close();
  }
}
```

- [ ] **Step 4: Run the tests**

Run: `flutter test test/features/connectivity`
Expected: all PASS.

- [ ] **Step 5: Checkpoint**. Report the files for the user to commit.

---

### Task 7: API contract, DTOs and the idempotent FakeNovaServer

**Files:**
- Create: `lib/core/api/service/dto.dart`, `nova_api_service.dart`, `mappers.dart`
- Create: `lib/core/api/fake/demo_seed.dart`, `fake_nova_server.dart`
- Create (test support): `test/support/server_harness.dart`
- Test: `test/core/api/fake_nova_server_test.dart`

**Interfaces:**
- Consumes: `Failure` family, `PhoneNumber`, `Masking`, `SecretHasher`, `Fees`, `Banks`, `ActivityKind/ActivityDirection`, server entities, `Reachability`, `FakeServerControls`, `AppConstants`, client entities (mappers)
- Produces:
  - DTOs: `ProfileDto`, `SessionDto {token, profile, pinHash?, pinSalt?}`, `RegisterRequest {phone, fullName, email, password}`, `WalletDto {balanceKobo, profile}`, `TransactionDto`, `GoalDto`, `BeneficiaryDto {accountNumber, bankCode, bankName, accountName}`, `TransferRequest {bankCode, bankName, accountNumber, recipientName, amountKobo, narration?}`, `CreateGoalRequest {clientId, name, targetKobo, targetDate}`, `ContributeRequest {goalClientId, amountKobo}`, `MutationResultDto {ref, balanceAfterKobo, transaction?, goal?}`. All have `toJson()` / `fromJson(Map<String, dynamic>)`; `ProfileDto.toModel()`.
  - `abstract class NovaApiService` (signatures in Step 3)
  - Mappers: `TransactionEntity transactionEntityFromDto(TransactionDto)`, `GoalEntity goalEntityFromDto(GoalDto)`, `BeneficiaryEntity beneficiaryEntityFromDto(BeneficiaryDto, {required DateTime verifiedAt})`
  - `class DemoSeed { static const List<BeneficiaryDto> beneficiaries; static String? lookupName({required String bankCode, required String accountNumber}); }`
  - `class FakeNovaServer implements NovaApiService { FakeNovaServer({required Isar db, required Reachability reachability, required FakeServerControls controls, required SecretHasher hasher, DateTime Function()? clock, Random? random, Uuid? uuid}); Future<void> ensureSeeded(); Future<void> resetDemo(); }`
  - Test support: `class ServerHarness { IsarDb db; FakeNetworkInfo network; FakeServerControls controls; Reachability reachability; FakeNovaServer server; static Future<ServerHarness> open({required String directory, required String tag}); Future<String> demoToken(); Future<int> balanceOf(String phone); Future<void> close({bool deleteFromDisk}); }`

- [ ] **Step 1: Create the DTOs** `lib/core/api/service/dto.dart`

```dart
import '../../models/activity_item.dart';
import '../../models/profile.dart';

typedef Json = Map<String, dynamic>;

class ProfileDto {
  const ProfileDto({
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

  Profile toModel() => Profile(
        fullName: fullName,
        phone: phone,
        email: email,
        tier: tier,
        bvnVerified: bvnVerified,
        accountNumber: accountNumber,
      );

  Json toJson() => {
        'fullName': fullName,
        'phone': phone,
        'email': email,
        'tier': tier,
        'bvnVerified': bvnVerified,
        'accountNumber': accountNumber,
      };

  factory ProfileDto.fromJson(Json j) => ProfileDto(
        fullName: j['fullName'] as String,
        phone: j['phone'] as String,
        email: j['email'] as String,
        tier: j['tier'] as int,
        bvnVerified: j['bvnVerified'] as bool,
        accountNumber: j['accountNumber'] as String,
      );
}

class SessionDto {
  const SessionDto({required this.token, required this.profile, this.pinHash, this.pinSalt});

  final String token;
  final ProfileDto profile;

  /// Mock simplification: lets the device verify the PIN offline after login.
  final String? pinHash;
  final String? pinSalt;
}

class RegisterRequest {
  const RegisterRequest({
    required this.phone,
    required this.fullName,
    required this.email,
    required this.password,
  });

  final String phone;
  final String fullName;
  final String email;
  final String password;
}

class WalletDto {
  const WalletDto({required this.balanceKobo, required this.profile});

  final int balanceKobo;
  final ProfileDto profile;
}

class TransactionDto {
  const TransactionDto({
    required this.ref,
    required this.kind,
    required this.direction,
    required this.amountKobo,
    required this.feeKobo,
    required this.title,
    required this.createdAt,
    this.subtitle,
    this.narration,
    this.goalClientId,
    this.idempotencyKey,
  });

  final String ref;
  final ActivityKind kind;
  final ActivityDirection direction;
  final int amountKobo;
  final int feeKobo;
  final String title;
  final String? subtitle;
  final String? narration;
  final String? goalClientId;
  final String? idempotencyKey;
  final DateTime createdAt;

  Json toJson() => {
        'ref': ref,
        'kind': kind.name,
        'direction': direction.name,
        'amountKobo': amountKobo,
        'feeKobo': feeKobo,
        'title': title,
        'subtitle': subtitle,
        'narration': narration,
        'goalClientId': goalClientId,
        'idempotencyKey': idempotencyKey,
        'createdAt': createdAt.toUtc().toIso8601String(),
      };

  factory TransactionDto.fromJson(Json j) => TransactionDto(
        ref: j['ref'] as String,
        kind: ActivityKind.values.byName(j['kind'] as String),
        direction: ActivityDirection.values.byName(j['direction'] as String),
        amountKobo: j['amountKobo'] as int,
        feeKobo: j['feeKobo'] as int,
        title: j['title'] as String,
        subtitle: j['subtitle'] as String?,
        narration: j['narration'] as String?,
        goalClientId: j['goalClientId'] as String?,
        idempotencyKey: j['idempotencyKey'] as String?,
        createdAt: DateTime.parse(j['createdAt'] as String).toLocal(),
      );
}

class GoalDto {
  const GoalDto({
    required this.clientId,
    required this.name,
    required this.targetKobo,
    required this.targetDate,
    required this.savedKobo,
    required this.createdAt,
  });

  final String clientId;
  final String name;
  final int targetKobo;
  final DateTime targetDate;
  final int savedKobo;
  final DateTime createdAt;

  Json toJson() => {
        'clientId': clientId,
        'name': name,
        'targetKobo': targetKobo,
        'targetDate': targetDate.toUtc().toIso8601String(),
        'savedKobo': savedKobo,
        'createdAt': createdAt.toUtc().toIso8601String(),
      };

  factory GoalDto.fromJson(Json j) => GoalDto(
        clientId: j['clientId'] as String,
        name: j['name'] as String,
        targetKobo: j['targetKobo'] as int,
        targetDate: DateTime.parse(j['targetDate'] as String).toLocal(),
        savedKobo: j['savedKobo'] as int,
        createdAt: DateTime.parse(j['createdAt'] as String).toLocal(),
      );
}

class BeneficiaryDto {
  const BeneficiaryDto({
    required this.accountNumber,
    required this.bankCode,
    required this.bankName,
    required this.accountName,
  });

  final String accountNumber;
  final String bankCode;
  final String bankName;
  final String accountName;
}

class TransferRequest {
  const TransferRequest({
    required this.bankCode,
    required this.bankName,
    required this.accountNumber,
    required this.recipientName,
    required this.amountKobo,
    this.narration,
  });

  final String bankCode;
  final String bankName;
  final String accountNumber;
  final String recipientName;
  final int amountKobo;
  final String? narration;

  Json toJson() => {
        'bankCode': bankCode,
        'bankName': bankName,
        'accountNumber': accountNumber,
        'recipientName': recipientName,
        'amountKobo': amountKobo,
        'narration': narration,
      };

  factory TransferRequest.fromJson(Json j) => TransferRequest(
        bankCode: j['bankCode'] as String,
        bankName: j['bankName'] as String,
        accountNumber: j['accountNumber'] as String,
        recipientName: j['recipientName'] as String,
        amountKobo: j['amountKobo'] as int,
        narration: j['narration'] as String?,
      );
}

class CreateGoalRequest {
  const CreateGoalRequest({
    required this.clientId,
    required this.name,
    required this.targetKobo,
    required this.targetDate,
  });

  final String clientId;
  final String name;
  final int targetKobo;
  final DateTime targetDate;

  Json toJson() => {
        'clientId': clientId,
        'name': name,
        'targetKobo': targetKobo,
        'targetDate': targetDate.toUtc().toIso8601String(),
      };

  factory CreateGoalRequest.fromJson(Json j) => CreateGoalRequest(
        clientId: j['clientId'] as String,
        name: j['name'] as String,
        targetKobo: j['targetKobo'] as int,
        targetDate: DateTime.parse(j['targetDate'] as String).toLocal(),
      );
}

class ContributeRequest {
  const ContributeRequest({required this.goalClientId, required this.amountKobo});

  final String goalClientId;
  final int amountKobo;

  Json toJson() => {'goalClientId': goalClientId, 'amountKobo': amountKobo};

  factory ContributeRequest.fromJson(Json j) => ContributeRequest(
        goalClientId: j['goalClientId'] as String,
        amountKobo: j['amountKobo'] as int,
      );
}

/// What every mutating endpoint returns, and what the idempotency record stores.
class MutationResultDto {
  const MutationResultDto({
    required this.ref,
    required this.balanceAfterKobo,
    this.transaction,
    this.goal,
  });

  final String ref;
  final int balanceAfterKobo;
  final TransactionDto? transaction;
  final GoalDto? goal;

  Json toJson() => {
        'ref': ref,
        'balanceAfterKobo': balanceAfterKobo,
        'transaction': transaction?.toJson(),
        'goal': goal?.toJson(),
      };

  factory MutationResultDto.fromJson(Json j) => MutationResultDto(
        ref: j['ref'] as String,
        balanceAfterKobo: j['balanceAfterKobo'] as int,
        transaction: j['transaction'] == null ? null : TransactionDto.fromJson(j['transaction'] as Json),
        goal: j['goal'] == null ? null : GoalDto.fromJson(j['goal'] as Json),
      );
}
```

- [ ] **Step 2: Create the mappers** `lib/core/api/service/mappers.dart`

```dart
import '../../models/goal_view.dart';
import '../../storage/entities/beneficiary_entity.dart';
import '../../storage/entities/goal_entity.dart';
import '../../storage/entities/transaction_entity.dart';
import 'dto.dart';

TransactionEntity transactionEntityFromDto(TransactionDto d) => TransactionEntity()
  ..serverRef = d.ref
  ..kind = d.kind
  ..direction = d.direction
  ..amountKobo = d.amountKobo
  ..feeKobo = d.feeKobo
  ..title = d.title
  ..subtitle = d.subtitle
  ..narration = d.narration
  ..goalClientId = d.goalClientId
  ..idempotencyKey = d.idempotencyKey
  ..createdAt = d.createdAt;

GoalEntity goalEntityFromDto(GoalDto d) => GoalEntity()
  ..clientId = d.clientId
  ..name = d.name
  ..targetKobo = d.targetKobo
  ..targetDate = d.targetDate
  ..savedKobo = d.savedKobo
  ..syncState = GoalSyncState.synced
  ..createdAt = d.createdAt;

BeneficiaryEntity beneficiaryEntityFromDto(BeneficiaryDto d, {required DateTime verifiedAt}) =>
    BeneficiaryEntity()
      ..accountNumber = d.accountNumber
      ..bankCode = d.bankCode
      ..bankName = d.bankName
      ..verifiedName = d.accountName
      ..verifiedAt = verifiedAt;
```

- [ ] **Step 3: Create the service contract** `lib/core/api/service/nova_api_service.dart`

```dart
import 'package:dartz/dartz.dart';

import '../exception/failure.dart';
import 'dto.dart';

/// Remote data source. Today it's [FakeNovaServer]; a Dio implementation would
/// slot in behind the same interface.
///
/// Mutating calls take an idempotency key. The server MUST return the original
/// response for a key it has already processed, including a stored rejection.
abstract class NovaApiService {
  // ── Auth ────────────────────────────────────────────────────────────────
  Future<Either<Failure, Unit>> requestOtp({required String phone});
  Future<Either<Failure, Unit>> verifyOtp({required String phone, required String code});
  Future<Either<Failure, SessionDto>> register(RegisterRequest request);
  Future<Either<Failure, SessionDto>> login({required String phone, required String password});
  Future<Either<Failure, Unit>> setPin({required String token, required String pinHash, required String pinSalt});
  Future<Either<Failure, ProfileDto>> verifyBvn({required String token, required String bvn});

  // ── Reads ───────────────────────────────────────────────────────────────
  Future<Either<Failure, WalletDto>> getWallet({required String token});
  Future<Either<Failure, List<TransactionDto>>> getTransactions({required String token, int limit = 200});
  Future<Either<Failure, List<BeneficiaryDto>>> getBeneficiaries({required String token});
  Future<Either<Failure, BeneficiaryDto>> nameEnquiry({
    required String token,
    required String bankCode,
    required String accountNumber,
  });
  Future<Either<Failure, List<GoalDto>>> getGoals({required String token});

  // ── Mutations (idempotent) ──────────────────────────────────────────────
  Future<Either<Failure, MutationResultDto>> transfer({
    required String token,
    required String idempotencyKey,
    required TransferRequest request,
  });
  Future<Either<Failure, MutationResultDto>> createGoal({
    required String token,
    required String idempotencyKey,
    required CreateGoalRequest request,
  });
  Future<Either<Failure, MutationResultDto>> contribute({
    required String token,
    required String idempotencyKey,
    required ContributeRequest request,
  });
}
```

- [ ] **Step 4: Create the demo seed** `lib/core/api/fake/demo_seed.dart`

```dart
import 'dart:math';

import 'package:isar_community/isar.dart';

import '../../../config/flavor/app_constants.dart';
import '../../auth/secret_hasher.dart';
import '../../models/activity_item.dart';
import '../../models/bank.dart';
import '../../money/fees.dart';
import '../../utils/masking.dart';
import '../service/dto.dart';
import 'entities/server_entities.dart';

/// Deterministic demo data for the fake backend.
class DemoSeed {
  DemoSeed({required this.hasher});

  final SecretHasher hasher;

  static const List<BeneficiaryDto> beneficiaries = [
    BeneficiaryDto(accountNumber: '0248214821', bankCode: '058', bankName: 'GTBank', accountName: 'ADAEZE OKAFOR'),
    BeneficiaryDto(accountNumber: '1234567890', bankCode: '044', bankName: 'Access Bank', accountName: 'AMINA BELLO'),
    BeneficiaryDto(accountNumber: '2233445566', bankCode: '057', bankName: 'Zenith Bank', accountName: 'OLUWASEUN ADEYEMI'),
    BeneficiaryDto(accountNumber: '8123456789', bankCode: '999992', bankName: 'OPay', accountName: 'IFEOMA NWANKWO'),
  ];

  static const List<String> _directoryNames = [
    'CHINEDU EMEKA OBI', 'FATIMA SANI MUSA', 'BABATUNDE AJAYI', 'NGOZI EZE',
    'IBRAHIM LAWAL', 'FUNMILAYO OGUNLEYE', 'EMEKA NNAMDI', 'HAUWA ABUBAKAR',
  ];

  static final RegExp _tenDigits = RegExp(r'^\d{10}$');

  /// Name enquiry. Numbers starting `000` or unknown banks don't exist; every
  /// other valid number resolves to a stable name so the demo can add anyone.
  static String? lookupName({required String bankCode, required String accountNumber}) {
    if (!_tenDigits.hasMatch(accountNumber) || accountNumber.startsWith('000')) return null;
    if (Banks.byCode(bankCode) == null) return null;
    for (final b in beneficiaries) {
      if (b.accountNumber == accountNumber && b.bankCode == bankCode) return b.accountName;
    }
    final digitSum = accountNumber.codeUnits.fold<int>(0, (sum, c) => sum + c - 48);
    return _directoryNames[digitSum % _directoryNames.length];
  }

  /// Creates an account with history and beneficiaries. MUST run inside a
  /// server write transaction.
  Future<ServerAccount> createAccount(
    Isar server, {
    required String phone,
    required String fullName,
    required String email,
    required String password,
    required DateTime now,
    String? pin,
    int tier = 1,
    bool bvnVerified = false,
    bool withGoal = false,
  }) async {
    final passwordSalt = hasher.newSalt();
    final account = ServerAccount()
      ..phone = phone
      ..fullName = fullName
      ..email = email
      ..passwordSalt = passwordSalt
      ..passwordHash = hasher.hash(password, passwordSalt)
      ..tier = tier
      ..bvnVerified = bvnVerified
      ..balanceKobo = AppConstants.demoOpeningBalanceKobo
      ..accountNumber = phone.substring(1);
    if (pin != null) {
      final pinSalt = hasher.newSalt();
      account
        ..pinSalt = pinSalt
        ..pinHash = hasher.hash(pin, pinSalt);
    }
    await server.serverAccounts.put(account);
    await server.serverTransactions.putAll(_history(phone, now));
    await server.serverBeneficiarys.putAll([
      for (final b in beneficiaries)
        ServerBeneficiary()
          ..phone = phone
          ..accountNumber = b.accountNumber
          ..bankCode = b.bankCode
          ..bankName = b.bankName
          ..accountName = b.accountName,
    ]);
    if (withGoal) {
      await server.serverGoals.put(ServerGoal()
        ..clientId = 'seed-goal-rent-$phone'
        ..phone = phone
        ..name = 'Rent — December'
        ..targetKobo = 60000000
        ..targetDate = DateTime(2026, 12, 20)
        ..savedKobo = 21000000
        ..createdAt = now.subtract(const Duration(days: 45)));
    }
    return account;
  }

  List<ServerTransaction> _history(String phone, DateTime now) {
    final random = Random(42);
    const payees = [
      ('ADAEZE OKAFOR', 'GTBank', '0248214821'),
      ('IKEJA ELECTRIC', 'Zenith Bank', '1010101010'),
      ('SHOPRITE LEKKI', 'Access Bank', '2020202020'),
      ('AMINA BELLO', 'Access Bank', '1234567890'),
      ('MTN DATA BUNDLE', 'UBA', '3030303030'),
      ('IFEOMA NWANKWO', 'OPay', '8123456789'),
    ];
    const amounts = [99950, 150000, 250000, 500000, 750000, 1200000, 2000000, 350000];
    final suffix = phone.substring(phone.length - 4);

    return List.generate(60, (i) {
      final createdAt = now.subtract(Duration(hours: 9 + i * 17));
      final ref = 'NP$suffix${(i + 1).toString().padLeft(5, '0')}';
      if (i % 7 == 3) {
        return ServerTransaction()
          ..phone = phone
          ..ref = ref
          ..kind = ActivityKind.credit.name
          ..direction = ActivityDirection.credit.name
          ..amountKobo = 15000000
          ..title = 'KUNLE BANKOLE'
          ..subtitle = 'Inward transfer · Moniepoint MFB'
          ..createdAt = createdAt;
      }
      final payee = payees[random.nextInt(payees.length)];
      final amount = amounts[random.nextInt(amounts.length)];
      return ServerTransaction()
        ..phone = phone
        ..ref = ref
        ..kind = ActivityKind.transfer.name
        ..direction = ActivityDirection.debit.name
        ..amountKobo = amount
        ..feeKobo = Fees.transferFeeKobo(amount)
        ..title = payee.$1
        ..subtitle = '${payee.$2} · ${Masking.account(payee.$3)}'
        ..createdAt = createdAt;
    });
  }
}
```

- [ ] **Step 5: Write the failing test and harness**

`test/support/server_harness.dart`
```dart
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/fake/fake_nova_server.dart';
import 'package:nova_wallet/core/api/fake/fake_server_controls.dart';
import 'package:nova_wallet/core/auth/secret_hasher.dart';
import 'package:nova_wallet/core/network/reachability.dart';
import 'package:nova_wallet/core/storage/isar_db.dart';
import 'package:nova_wallet/core/api/fake/entities/server_entities.dart';

import 'fake_network_info.dart';
import 'isar_test_db.dart';

class ServerHarness {
  ServerHarness._(this.db, this.network, this.controls, this.reachability, this.server);

  final IsarDb db;
  final FakeNetworkInfo network;
  final FakeServerControls controls;
  final Reachability reachability;
  final FakeNovaServer server;

  static Future<ServerHarness> open({
    required String directory,
    required String tag,
    FakeNetworkInfo? network,
    FakeServerControls? controls,
  }) async {
    final db = await openTestDb(directory: directory, tag: tag);
    final net = network ?? FakeNetworkInfo();
    final ctl = controls ?? FakeServerControls(minLatency: Duration.zero, maxLatency: Duration.zero);
    final reach = Reachability(networkInfo: net, controls: ctl);
    final server = FakeNovaServer(db: db.server, reachability: reach, controls: ctl, hasher: SecretHasher());
    await server.ensureSeeded();
    return ServerHarness._(db, net, ctl, reach, server);
  }

  Future<String> demoToken() async => (await server.login(
        phone: AppConstants.demoPhone,
        password: AppConstants.demoPassword,
      ))
          .fold((f) => throw StateError(f.message), (s) => s.token);

  Future<int> balanceOf(String phone) async =>
      (await db.server.serverAccounts.getByPhone(phone))!.balanceKobo;

  Future<void> close({bool deleteFromDisk = false}) => db.close(deleteFromDisk: deleteFromDisk);
}
```

`test/core/api/fake_nova_server_test.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/api/fake/entities/server_entities.dart';
import 'package:nova_wallet/core/api/service/dto.dart';

import '../../support/isar_test_db.dart';
import '../../support/server_harness.dart';

const phone = AppConstants.demoPhone;

TransferRequest transfer(int amountKobo, {String account = '0248214821'}) => TransferRequest(
      bankCode: '058', bankName: 'GTBank', accountNumber: account,
      recipientName: 'ADAEZE OKAFOR', amountKobo: amountKobo);

T right<T>(Either<Failure, T> e) => e.fold((f) => fail('expected Right, got $f'), (r) => r);
Failure leftOf<T>(Either<Failure, T> e) => e.fold((f) => f, (r) => fail('expected Left, got $r'));

void main() {
  late String dir;
  late ServerHarness h;
  late String token;

  setUp(() async {
    dir = await newTempDir();
    h = await ServerHarness.open(directory: dir, tag: 'server');
    token = await h.demoToken();
  });
  tearDown(() => h.close(deleteFromDisk: true));

  group('auth', () {
    test('demo account is seeded: Tier 2, ₦250,000.00, history, beneficiaries, goal', () async {
      final wallet = right(await h.server.getWallet(token: token));
      expect(wallet.balanceKobo, 25000000);
      expect(wallet.profile.tier, 2);
      expect(right(await h.server.getTransactions(token: token)).length, 60);
      expect(right(await h.server.getBeneficiaries(token: token)).length, 4);
      expect(right(await h.server.getGoals(token: token)).single.savedKobo, 21000000);
    });

    test('wrong password is a business failure', () async {
      final f = leftOf(await h.server.login(phone: phone, password: 'nope'));
      expect((f as BusinessFailure).code, BusinessCode.invalidCredentials);
    });

    test('register creates a Tier 1 account once', () async {
      const req = RegisterRequest(phone: '+2349031234567', fullName: 'Tolu Ade', email: 't@x.com', password: 'Secret#123');
      final session = right(await h.server.register(req));
      expect(session.profile.phone, '09031234567');
      expect(session.profile.tier, 1);
      final dup = leftOf(await h.server.register(req));
      expect((dup as BusinessFailure).code, BusinessCode.accountExists);
    });

    test('OTP and BVN checks', () async {
      expect(right(await h.server.verifyOtp(phone: phone, code: AppConstants.fakeOtp)), unit);
      expect((leftOf(await h.server.verifyOtp(phone: phone, code: '000000')) as BusinessFailure).code,
          BusinessCode.invalidOtp);
      expect((leftOf(await h.server.verifyBvn(token: token, bvn: '123')) as BusinessFailure).code,
          BusinessCode.invalidBvn);
      expect(right(await h.server.verifyBvn(token: token, bvn: '22123456789')).bvnVerified, isTrue);
    });
  });

  test('unreachable server fails with NetworkFailure and changes nothing', () async {
    h.controls.simulateOffline = true;
    expect(leftOf(await h.server.transfer(token: token, idempotencyKey: 'k-off', request: transfer(500000))),
        isA<NetworkFailure>());
    expect(await h.balanceOf(phone), 25000000);
    expect(await h.db.server.processedRequests.count(), 0);
  });

  group('idempotency', () {
    test('same key twice → identical response, ONE debit, ONE transaction', () async {
      final first = right(await h.server.transfer(token: token, idempotencyKey: 'k1', request: transfer(500000)));
      final second = right(await h.server.transfer(token: token, idempotencyKey: 'k1', request: transfer(500000)));
      expect(second.ref, first.ref);
      expect(second.balanceAfterKobo, first.balanceAfterKobo);
      expect(await h.balanceOf(phone), 25000000 - 500000 - 1075);
      expect(await h.db.server.serverTransactions.filter().idempotencyKeyEqualTo('k1').count(), 1);
    });

    test('a different key is a different transfer', () async {
      right(await h.server.transfer(token: token, idempotencyKey: 'a', request: transfer(500000)));
      right(await h.server.transfer(token: token, idempotencyKey: 'b', request: transfer(500000)));
      expect(await h.balanceOf(phone), 25000000 - 2 * 501075);
    });

    test('lost response: applied on the server, timeout on the phone, replay returns the original', () async {
      h.controls.loseNextResponse = true;
      final lost = leftOf(await h.server.transfer(token: token, idempotencyKey: 'lost', request: transfer(1000000)));
      expect((lost as NetworkFailure).timedOut, isTrue);
      expect(await h.balanceOf(phone), 25000000 - 1002688);

      final replay = right(await h.server.transfer(token: token, idempotencyKey: 'lost', request: transfer(1000000)));
      expect(replay.balanceAfterKobo, 25000000 - 1002688);
      expect(await h.balanceOf(phone), 25000000 - 1002688);
    });

    test('rejections are stored and replayed, not re-evaluated', () async {
      final f = leftOf(await h.server.transfer(token: token, idempotencyKey: 'big', request: transfer(99000000)));
      expect((f as BusinessFailure).code, BusinessCode.insufficientFunds);
      final again = leftOf(await h.server.transfer(token: token, idempotencyKey: 'big', request: transfer(99000000)));
      expect(again, f);
    });

    test('processed keys survive a server restart', () async {
      final first = right(await h.server.transfer(token: token, idempotencyKey: 'persist', request: transfer(500000)));
      await h.close();
      h = await ServerHarness.open(directory: dir, tag: 'server');
      token = await h.demoToken();
      final replay = right(await h.server.transfer(token: token, idempotencyKey: 'persist', request: transfer(500000)));
      expect(replay.ref, first.ref);
      expect(await h.balanceOf(phone), 25000000 - 501075);
    });
  });

  group('business rules', () {
    test('tier cap applies to Tier 1 accounts', () async {
      final s = right(await h.server.register(const RegisterRequest(
          phone: '09031234567', fullName: 'T One', email: 't@x.com', password: 'Secret#123')));
      final f = leftOf(await h.server.transfer(token: s.token, idempotencyKey: 'cap', request: transfer(10000001)));
      expect((f as BusinessFailure).code, BusinessCode.tierLimitExceeded);
    });

    test('invalid account numbers are rejected by name enquiry and transfer', () async {
      expect((leftOf(await h.server.nameEnquiry(token: token, bankCode: '058', accountNumber: '0001112223'))
              as BusinessFailure).code, BusinessCode.invalidAccount);
      expect(right(await h.server.nameEnquiry(token: token, bankCode: '058', accountNumber: '0248214821')).accountName,
          'ADAEZE OKAFOR');
      final f = leftOf(await h.server.transfer(token: token, idempotencyKey: 'bad', request: transfer(500000, account: '0001112223')));
      expect((f as BusinessFailure).code, BusinessCode.invalidAccount);
    });

    test('create goal then contribute debits wallet and credits goal', () async {
      final goal = right(await h.server.createGoal(token: token, idempotencyKey: 'g1', request: CreateGoalRequest(
          clientId: 'goal-1', name: 'Laptop', targetKobo: 80000000, targetDate: DateTime(2027, 3, 1))));
      expect(goal.goal!.savedKobo, 0);
      final c = right(await h.server.contribute(token: token, idempotencyKey: 'c1',
          request: const ContributeRequest(goalClientId: 'goal-1', amountKobo: 500000)));
      expect(c.goal!.savedKobo, 500000);
      expect(c.balanceAfterKobo, 25000000 - 500000);
      expect(c.transaction!.goalClientId, 'goal-1');
    });

    test('contribution to an unknown goal is goalNotFound', () async {
      final f = leftOf(await h.server.contribute(token: token, idempotencyKey: 'c2',
          request: const ContributeRequest(goalClientId: 'missing', amountKobo: 500000)));
      expect((f as BusinessFailure).code, BusinessCode.goalNotFound);
    });
  });
}
```

- [ ] **Step 6: Run to see it fail**

Run: `flutter test test/core/api/fake_nova_server_test.dart`
Expected: compilation error (`fake_nova_server.dart` missing).

- [ ] **Step 7: Implement** `lib/core/api/fake/fake_nova_server.dart`

```dart
import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../config/flavor/app_constants.dart';
import '../../auth/secret_hasher.dart';
import '../../models/activity_item.dart';
import '../../models/bank.dart';
import '../../money/fees.dart';
import '../../network/reachability.dart';
import '../../utils/masking.dart';
import '../../utils/phone.dart';
import '../exception/failure.dart';
import '../service/dto.dart';
import '../service/nova_api_service.dart';
import 'demo_seed.dart';
import 'entities/server_entities.dart';
import 'fake_server_controls.dart';

/// In-process stand-in for the NovaPay backend.
///
/// Honest about the things that matter for the brief: it is unreachable when
/// the device is offline, it has latency, it rejects on business rules, and
/// every mutating call is idempotent. The idempotency record is persisted in the
/// same transaction as the money movement, so "applied" and "remembered" can
/// never disagree, even across restarts.
class FakeNovaServer implements NovaApiService {
  FakeNovaServer({
    required this.db,
    required this.reachability,
    required this.controls,
    required this.hasher,
    DateTime Function()? clock,
    Random? random,
    Uuid? uuid,
  })  : _clock = clock ?? DateTime.now,
        _random = random ?? Random(),
        _uuid = uuid ?? const Uuid(),
        _seed = DemoSeed(hasher: hasher);

  final Isar db;
  final Reachability reachability;
  final FakeServerControls controls;
  final SecretHasher hasher;
  final DateTime Function() _clock;
  final Random _random;
  final Uuid _uuid;
  final DemoSeed _seed;

  // ── Demo data ───────────────────────────────────────────────────────────

  Future<void> ensureSeeded() async {
    if (await db.serverAccounts.getByPhone(AppConstants.demoPhone) != null) return;
    await db.writeTxn(() => _seed.createAccount(
          db,
          phone: AppConstants.demoPhone,
          fullName: 'Tolu Adebayo',
          email: 'tolu.adebayo@example.com',
          password: AppConstants.demoPassword,
          pin: AppConstants.demoPin,
          tier: 2,
          bvnVerified: true,
          withGoal: true,
          now: _clock(),
        ));
  }

  Future<void> resetDemo() async {
    await db.writeTxn(() => db.clear());
    await ensureSeeded();
  }

  // ── Transport simulation ────────────────────────────────────────────────

  Future<Either<Failure, T>> _call<T>(Future<Either<Failure, T>> Function() body) async {
    if (!await reachability.isReachable) return left(const NetworkFailure());
    final latency = _latency();
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    // Dropped while "in the air": the request never arrived.
    if (!await reachability.isReachable) {
      return left(const NetworkFailure(message: 'Connection lost.', timedOut: true));
    }
    return body();
  }

  Duration _latency() {
    final min = controls.minLatency.inMilliseconds;
    final max = controls.maxLatency.inMilliseconds;
    if (max <= min) return Duration(milliseconds: min);
    return Duration(milliseconds: min + _random.nextInt(max - min + 1));
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  static const _unauthorized = BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.');

  Future<ServerAccount?> _accountFor(String token) async {
    final session = await db.serverSessions.getByToken(token);
    if (session == null) return null;
    return db.serverAccounts.getByPhone(session.phone);
  }

  Future<ServerSession> _newSession(String phone) async {
    final session = ServerSession()
      ..token = 'nova_${_uuid.v4()}'
      ..phone = phone
      ..issuedAt = _clock();
    await db.serverSessions.put(session);
    return session;
  }

  ProfileDto _profile(ServerAccount a) => ProfileDto(
        fullName: a.fullName,
        phone: a.phone,
        email: a.email,
        tier: a.tier,
        bvnVerified: a.bvnVerified,
        accountNumber: a.accountNumber,
      );

  TransactionDto _txnDto(ServerTransaction t) => TransactionDto(
        ref: t.ref,
        kind: ActivityKind.values.byName(t.kind),
        direction: ActivityDirection.values.byName(t.direction),
        amountKobo: t.amountKobo,
        feeKobo: t.feeKobo,
        title: t.title,
        subtitle: t.subtitle,
        narration: t.narration,
        goalClientId: t.goalClientId,
        idempotencyKey: t.idempotencyKey,
        createdAt: t.createdAt,
      );

  GoalDto _goalDto(ServerGoal g) => GoalDto(
        clientId: g.clientId,
        name: g.name,
        targetKobo: g.targetKobo,
        targetDate: g.targetDate,
        savedKobo: g.savedKobo,
        createdAt: g.createdAt,
      );

  String _newRef() => 'NP${_clock().millisecondsSinceEpoch}${_random.nextInt(900) + 100}';

  // ── Auth ────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> requestOtp({required String phone}) => _call(() async {
        if (PhoneNumber.normalize(phone) == null) {
          return left(const BusinessFailure(BusinessCode.invalidCredentials, 'Enter a valid Nigerian phone number.'));
        }
        return right(unit);
      });

  @override
  Future<Either<Failure, Unit>> verifyOtp({required String phone, required String code}) => _call(() async {
        if (code != AppConstants.fakeOtp) {
          return left(const BusinessFailure(BusinessCode.invalidOtp, 'That code is incorrect.'));
        }
        return right(unit);
      });

  @override
  Future<Either<Failure, SessionDto>> register(RegisterRequest request) => _call(() async {
        final phone = PhoneNumber.normalize(request.phone);
        if (phone == null) {
          return left(const BusinessFailure(BusinessCode.invalidCredentials, 'Enter a valid Nigerian phone number.'));
        }
        if (await db.serverAccounts.getByPhone(phone) != null) {
          return left(const BusinessFailure(BusinessCode.accountExists, 'An account with this phone number already exists.'));
        }
        late ServerAccount account;
        late ServerSession session;
        await db.writeTxn(() async {
          account = await _seed.createAccount(
            db,
            phone: phone,
            fullName: request.fullName.trim(),
            email: request.email.trim(),
            password: request.password,
            now: _clock(),
          );
          session = await _newSession(phone);
        });
        return right(SessionDto(token: session.token, profile: _profile(account)));
      });

  @override
  Future<Either<Failure, SessionDto>> login({required String phone, required String password}) => _call(() async {
        final normalized = PhoneNumber.normalize(phone);
        final account = normalized == null ? null : await db.serverAccounts.getByPhone(normalized);
        if (account == null || !hasher.verify(password, account.passwordSalt, account.passwordHash)) {
          return left(const BusinessFailure(BusinessCode.invalidCredentials, 'Phone number or password is incorrect.'));
        }
        final session = await db.writeTxn(() => _newSession(account.phone));
        return right(SessionDto(
          token: session.token,
          profile: _profile(account),
          pinHash: account.pinHash,
          pinSalt: account.pinSalt,
        ));
      });

  @override
  Future<Either<Failure, Unit>> setPin({required String token, required String pinHash, required String pinSalt}) =>
      _call(() async {
        final account = await _accountFor(token);
        if (account == null) return left(_unauthorized);
        account
          ..pinHash = pinHash
          ..pinSalt = pinSalt;
        await db.writeTxn(() => db.serverAccounts.put(account));
        return right(unit);
      });

  @override
  Future<Either<Failure, ProfileDto>> verifyBvn({required String token, required String bvn}) => _call(() async {
        final account = await _accountFor(token);
        if (account == null) return left(_unauthorized);
        if (!RegExp(r'^[1-9]\d{10}$').hasMatch(bvn)) {
          return left(const BusinessFailure(BusinessCode.invalidBvn, "We couldn't verify this BVN."));
        }
        account
          ..tier = 2
          ..bvnVerified = true;
        await db.writeTxn(() => db.serverAccounts.put(account));
        return right(_profile(account));
      });

  // ── Reads ───────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, WalletDto>> getWallet({required String token}) => _call(() async {
        final account = await _accountFor(token);
        if (account == null) return left(_unauthorized);
        return right(WalletDto(balanceKobo: account.balanceKobo, profile: _profile(account)));
      });

  @override
  Future<Either<Failure, List<TransactionDto>>> getTransactions({required String token, int limit = 200}) =>
      _call(() async {
        final account = await _accountFor(token);
        if (account == null) return left(_unauthorized);
        final rows = await db.serverTransactions
            .filter()
            .phoneEqualTo(account.phone)
            .sortByCreatedAtDesc()
            .limit(limit)
            .findAll();
        return right(rows.map(_txnDto).toList());
      });

  @override
  Future<Either<Failure, List<BeneficiaryDto>>> getBeneficiaries({required String token}) => _call(() async {
        final account = await _accountFor(token);
        if (account == null) return left(_unauthorized);
        final rows = await db.serverBeneficiarys.filter().phoneEqualTo(account.phone).findAll();
        return right([
          for (final b in rows)
            BeneficiaryDto(
              accountNumber: b.accountNumber,
              bankCode: b.bankCode,
              bankName: b.bankName,
              accountName: b.accountName,
            ),
        ]);
      });

  @override
  Future<Either<Failure, BeneficiaryDto>> nameEnquiry({
    required String token,
    required String bankCode,
    required String accountNumber,
  }) =>
      _call(() async {
        if (await _accountFor(token) == null) return left(_unauthorized);
        final name = DemoSeed.lookupName(bankCode: bankCode, accountNumber: accountNumber);
        if (name == null) {
          return left(const BusinessFailure(
              BusinessCode.invalidAccount, "We couldn't find this account. Check the number and bank."));
        }
        return right(BeneficiaryDto(
          accountNumber: accountNumber,
          bankCode: bankCode,
          bankName: Banks.byCode(bankCode)!.name,
          accountName: name,
        ));
      });

  @override
  Future<Either<Failure, List<GoalDto>>> getGoals({required String token}) => _call(() async {
        final account = await _accountFor(token);
        if (account == null) return left(_unauthorized);
        final rows = await db.serverGoals.filter().phoneEqualTo(account.phone).findAll();
        return right(rows.map(_goalDto).toList());
      });

  // ── Mutations ───────────────────────────────────────────────────────────

  /// Runs [apply] at most once per [idempotencyKey].
  ///
  /// Lookup, money movement and the idempotency record share ONE write
  /// transaction. A replay (same key) returns the stored JSON, so the first
  /// response and every replay are byte-identical, rejections included.
  Future<Either<Failure, MutationResultDto>> _mutate({
    required String token,
    required String idempotencyKey,
    required String endpoint,
    required Future<Either<BusinessFailure, MutationResultDto>> Function(ServerAccount account) apply,
  }) =>
      _call(() async {
        final account = await _accountFor(token);
        if (account == null) return left(_unauthorized);

        final stored = await db.writeTxn<String>(() async {
          final existing = await db.processedRequests.getByIdempotencyKey(idempotencyKey);
          if (existing != null) return existing.responseJson;

          final outcome = await apply(account);
          final json = _encode(outcome);
          await db.processedRequests.put(ProcessedRequest()
            ..idempotencyKey = idempotencyKey
            ..phone = account.phone
            ..endpoint = endpoint
            ..responseJson = json
            ..processedAt = _clock());
          return json;
        });

        if (controls.loseNextResponse) {
          controls.loseNextResponse = false;
          return left(const NetworkFailure(message: 'Request timed out.', timedOut: true));
        }
        return _decode(stored);
      });

  String _encode(Either<BusinessFailure, MutationResultDto> outcome) => jsonEncode(outcome.fold(
        (f) => {'ok': false, 'code': f.code.name, 'message': f.message},
        (r) => {'ok': true, 'result': r.toJson()},
      ));

  Either<Failure, MutationResultDto> _decode(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    if (map['ok'] == true) {
      return right(MutationResultDto.fromJson(map['result'] as Map<String, dynamic>));
    }
    return left(BusinessFailure(
      BusinessCode.values.byName(map['code'] as String),
      map['message'] as String,
    ));
  }

  @override
  Future<Either<Failure, MutationResultDto>> transfer({
    required String token,
    required String idempotencyKey,
    required TransferRequest request,
  }) =>
      _mutate(
        token: token,
        idempotencyKey: idempotencyKey,
        endpoint: 'transfer',
        apply: (account) async {
          final name = DemoSeed.lookupName(bankCode: request.bankCode, accountNumber: request.accountNumber);
          if (name == null) {
            return left(const BusinessFailure(BusinessCode.invalidAccount, "The recipient's account could not be found."));
          }
          final cap = account.tier >= 2 ? AppConstants.tier2SingleSendCapKobo : AppConstants.tier1SingleSendCapKobo;
          if (request.amountKobo > cap) {
            return left(const BusinessFailure(BusinessCode.tierLimitExceeded, 'This amount is above your transfer limit.'));
          }
          final fee = Fees.transferFeeKobo(request.amountKobo);
          final debit = request.amountKobo + fee;
          if (debit > account.balanceKobo) {
            return left(const BusinessFailure(BusinessCode.insufficientFunds, 'Insufficient funds when we tried to send.'));
          }

          account.balanceKobo -= debit;
          await db.serverAccounts.put(account);
          final txn = ServerTransaction()
            ..phone = account.phone
            ..ref = _newRef()
            ..kind = ActivityKind.transfer.name
            ..direction = ActivityDirection.debit.name
            ..amountKobo = request.amountKobo
            ..feeKobo = fee
            ..title = name
            ..subtitle = '${request.bankName} · ${Masking.account(request.accountNumber)}'
            ..narration = request.narration
            ..idempotencyKey = idempotencyKey
            ..createdAt = _clock();
          await db.serverTransactions.put(txn);
          return right(MutationResultDto(ref: txn.ref, balanceAfterKobo: account.balanceKobo, transaction: _txnDto(txn)));
        },
      );

  @override
  Future<Either<Failure, MutationResultDto>> createGoal({
    required String token,
    required String idempotencyKey,
    required CreateGoalRequest request,
  }) =>
      _mutate(
        token: token,
        idempotencyKey: idempotencyKey,
        endpoint: 'createGoal',
        apply: (account) async {
          final goal = await db.serverGoals.getByClientId(request.clientId) ??
              (ServerGoal()
                ..clientId = request.clientId
                ..phone = account.phone
                ..name = request.name
                ..targetKobo = request.targetKobo
                ..targetDate = request.targetDate
                ..createdAt = _clock());
          await db.serverGoals.put(goal);
          return right(MutationResultDto(
            ref: 'GOAL-${goal.clientId}',
            balanceAfterKobo: account.balanceKobo,
            goal: _goalDto(goal),
          ));
        },
      );

  @override
  Future<Either<Failure, MutationResultDto>> contribute({
    required String token,
    required String idempotencyKey,
    required ContributeRequest request,
  }) =>
      _mutate(
        token: token,
        idempotencyKey: idempotencyKey,
        endpoint: 'contribute',
        apply: (account) async {
          final goal = await db.serverGoals.getByClientId(request.goalClientId);
          if (goal == null || goal.phone != account.phone) {
            return left(const BusinessFailure(BusinessCode.goalNotFound, 'This savings goal no longer exists.'));
          }
          if (request.amountKobo > account.balanceKobo) {
            return left(const BusinessFailure(BusinessCode.insufficientFunds, 'Insufficient funds when we tried to save.'));
          }

          account.balanceKobo -= request.amountKobo;
          goal.savedKobo += request.amountKobo;
          await db.serverAccounts.put(account);
          await db.serverGoals.put(goal);
          final txn = ServerTransaction()
            ..phone = account.phone
            ..ref = _newRef()
            ..kind = ActivityKind.contribution.name
            ..direction = ActivityDirection.debit.name
            ..amountKobo = request.amountKobo
            ..title = goal.name
            ..subtitle = 'NovaSave'
            ..goalClientId = goal.clientId
            ..idempotencyKey = idempotencyKey
            ..createdAt = _clock();
          await db.serverTransactions.put(txn);
          return right(MutationResultDto(
            ref: txn.ref,
            balanceAfterKobo: account.balanceKobo,
            transaction: _txnDto(txn),
            goal: _goalDto(goal),
          ));
        },
      );
}
```

- [ ] **Step 8: Run the tests**

Run: `flutter test test/core/api/fake_nova_server_test.dart`
Expected: all PASS.

- [ ] **Step 9: Checkpoint**. Report the files for the user to commit.

---

### Task 8: Settings repository, LocaleCubit and the biometric gate

**Files:**
- Create: `lib/features/settings/repository/settings_repository.dart`, `settings_repository_impl.dart`
- Create: `lib/features/settings/cubit/locale_cubit.dart`
- Create: `lib/core/auth/biometric_signer.dart`, `lib/core/auth/biometric_gate.dart`
- Create (test support): `test/support/fake_biometric_gate.dart`
- Test: `test/features/settings/settings_test.dart`

**Interfaces:**
- Consumes: `LocalStorage`
- Produces:
  - `abstract class ISettingsRepository { Future<String?> localeCode(); Future<void> saveLocaleCode(String code); Future<bool> onboardingSeen(); Future<void> markOnboardingSeen(); Future<bool> biometricEnabled(); Future<void> setBiometricEnabled(bool enabled); }`
  - `class LocaleCubit extends Cubit<Locale?> { LocaleCubit({required ISettingsRepository repository}); Future<void> load(); Future<void> setLocale(String code); }`
  - `enum BiometricSignerError { unavailable, notEnrolled, canceled, lockedOut, keyInvalidated, keyMissing, failed }`
  - `class BiometricSigner` (ported from Kiba): `Future<bool> isAvailable()`, `Future<bool> hasKey()`, `Future<Either<BiometricSignerError, String>> createKey({String promptMessage})`, `Future<Either<BiometricSignerError, String>> sign(String payload, {String promptMessage})`, `Future<void> deleteKey()`
  - `abstract class BiometricGate { Future<bool> isAvailable(); Future<Either<BiometricSignerError, Unit>> enable(); Future<void> disable(); Future<Either<BiometricSignerError, String>> confirm({required String payload, required String reason}); }`
  - `class SignerBiometricGate implements BiometricGate { SignerBiometricGate({required BiometricSigner signer}); }`
  - Test support: `class FakeBiometricGate implements BiometricGate { bool available; BiometricSignerError? nextError; String signature; int confirmCalls; String? lastPayload; }`

- [ ] **Step 1: Write the failing test** `test/features/settings/settings_test.dart`

```dart
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/features/settings/cubit/locale_cubit.dart';
import 'package:nova_wallet/features/settings/repository/settings_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SettingsRepositoryImpl> buildRepo() async {
  SharedPreferences.setMockInitialValues({});
  return SettingsRepositoryImpl(localStorage: LocalStorageImpl(prefs: await SharedPreferences.getInstance()));
}

void main() {
  test('settings repository persists locale, onboarding and biometric flags', () async {
    final repo = await buildRepo();
    expect(await repo.onboardingSeen(), isFalse);
    expect(await repo.localeCode(), isNull);
    await repo.markOnboardingSeen();
    await repo.saveLocaleCode('yo');
    await repo.setBiometricEnabled(true);
    expect(await repo.onboardingSeen(), isTrue);
    expect(await repo.localeCode(), 'yo');
    expect(await repo.biometricEnabled(), isTrue);
  });

  test('LocaleCubit loads the saved locale and switches', () async {
    final repo = await buildRepo();
    await repo.saveLocaleCode('yo');
    final cubit = LocaleCubit(repository: repo);
    await cubit.load();
    expect(cubit.state, const Locale('yo'));
    await cubit.setLocale('en');
    expect(cubit.state, const Locale('en'));
    expect(await repo.localeCode(), 'en');
    await cubit.close();
  });
}
```

- [ ] **Step 2: Run to see it fail**

Run: `flutter test test/features/settings`
Expected: compilation errors.

- [ ] **Step 3: Implement settings**

`lib/features/settings/repository/settings_repository.dart`
```dart
/// Device preferences. Nothing here is sensitive, so it all lives in
/// SharedPreferences.
abstract class ISettingsRepository {
  Future<String?> localeCode();
  Future<void> saveLocaleCode(String code);

  Future<bool> onboardingSeen();
  Future<void> markOnboardingSeen();

  Future<bool> biometricEnabled();
  Future<void> setBiometricEnabled(bool enabled);
}
```

`lib/features/settings/repository/settings_repository_impl.dart`
```dart
import '../../../core/storage/local_storage.dart';
import 'settings_repository.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  SettingsRepositoryImpl({required this.localStorage});

  final LocalStorage localStorage;

  @override
  Future<String?> localeCode() => localStorage.getLocaleCode();
  @override
  Future<void> saveLocaleCode(String code) => localStorage.saveLocaleCode(code);

  @override
  Future<bool> onboardingSeen() => localStorage.getOnboardingSeen();
  @override
  Future<void> markOnboardingSeen() => localStorage.saveOnboardingSeen(true);

  @override
  Future<bool> biometricEnabled() => localStorage.getBiometricEnabled();
  @override
  Future<void> setBiometricEnabled(bool enabled) => localStorage.saveBiometricEnabled(enabled);
}
```

`lib/features/settings/cubit/locale_cubit.dart`
```dart
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/settings_repository.dart';

/// `null` means "follow the device locale".
class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit({required this.repository}) : super(null);

  final ISettingsRepository repository;

  Future<void> load() async {
    final code = await repository.localeCode();
    if (code != null && !isClosed) emit(Locale(code));
  }

  Future<void> setLocale(String code) async {
    await repository.saveLocaleCode(code);
    if (!isClosed) emit(Locale(code));
  }
}
```

- [ ] **Step 4: Port Kiba's signer** `lib/core/auth/biometric_signer.dart`

Copy `~/Documents/mobile/kiba/lib/core/auth/biometric_signer.dart` verbatim, with exactly two changes:
1. `static const String keyAlias = 'nova_biometric_confirm';`
2. default prompts: `createKey({String promptMessage = 'Confirm to enable biometric approval'})` and `sign(payload, {String promptMessage = 'Approve this transfer'})`.

Everything else (the `BiometricSignerError` enum, `CreateKeysConfig` with `setInvalidatedByBiometricEnrollment: true`, `isAvailable`, `hasKey`, `deleteKey`, `_map`) is unchanged. The header comment must note: the iOS Simulator has no Secure Enclave, so `isAvailable()` is false there and the flow falls back to PIN.

- [ ] **Step 5: Create the gate** `lib/core/auth/biometric_gate.dart`

```dart
import 'package:dartz/dartz.dart';

import 'biometric_signer.dart';

/// Biometric approval for high-value sends (spec A7, brief stretch goal).
///
/// A stub in one respect only: the fake server does not verify the signature.
/// Everything on the device is real — a hardware-backed EC P-256 key that the
/// OS destroys if biometrics change.
abstract class BiometricGate {
  /// Hardware present, a biometric enrolled, AND our key still valid.
  Future<bool> isAvailable();

  /// Creates the device key (enrolment).
  Future<Either<BiometricSignerError, Unit>> enable();

  Future<void> disable();

  /// Prompts, and returns the base64 DER signature over [payload].
  Future<Either<BiometricSignerError, String>> confirm({
    required String payload,
    required String reason,
  });
}

class SignerBiometricGate implements BiometricGate {
  SignerBiometricGate({required this.signer});

  final BiometricSigner signer;

  @override
  Future<bool> isAvailable() async => await signer.isAvailable() && await signer.hasKey();

  @override
  Future<Either<BiometricSignerError, Unit>> enable() async {
    final result = await signer.createKey();
    return result.fold(left, (_) => right(unit));
  }

  @override
  Future<void> disable() => signer.deleteKey();

  @override
  Future<Either<BiometricSignerError, String>> confirm({
    required String payload,
    required String reason,
  }) =>
      signer.sign(payload, promptMessage: reason);
}
```

- [ ] **Step 6: Create the test fake** `test/support/fake_biometric_gate.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:nova_wallet/core/auth/biometric_gate.dart';
import 'package:nova_wallet/core/auth/biometric_signer.dart';

class FakeBiometricGate implements BiometricGate {
  FakeBiometricGate({this.available = true});

  bool available;

  /// When set, [confirm] and [enable] fail with this error.
  BiometricSignerError? nextError;
  String signature = 'fake-signature';
  int confirmCalls = 0;
  String? lastPayload;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<Either<BiometricSignerError, Unit>> enable() async {
    final error = nextError;
    if (error != null) return left(error);
    available = true;
    return right(unit);
  }

  @override
  Future<void> disable() async => available = false;

  @override
  Future<Either<BiometricSignerError, String>> confirm({
    required String payload,
    required String reason,
  }) async {
    confirmCalls++;
    lastPayload = payload;
    final error = nextError;
    if (error != null) return left(error);
    return right(signature);
  }
}
```

- [ ] **Step 7: Run the tests**

Run: `flutter test test/features/settings`
Expected: PASS. Then `flutter analyze` — expect no issues.

- [ ] **Step 8: Checkpoint**. Report the files for the user to commit.

---

### Task 9: Auth repository and the auth cubits

**Files:**
- Create: `lib/features/auth/repository/auth_repository.dart`, `auth_repository_impl.dart`
- Create: `lib/features/auth/cubit/auth_state.dart`, `auth_cubit.dart`, `signup_state.dart`, `signup_cubit.dart`, `login_state.dart`, `login_cubit.dart`, `unlock_state.dart`, `unlock_cubit.dart`
- Test: `test/features/auth/auth_repository_test.dart`, `test/features/auth/auth_cubits_test.dart`

**Interfaces:**
- Consumes: `NovaApiService`, `SessionStore`, `IsarDb`, `LocalStorage`, `SecretHasher`, `ISettingsRepository`, `BiometricGate`, `Profile`, `ProfileEntity`, failures
- Produces:
  - `abstract class IAuthRepository { Future<Either<Failure, Unit>> requestOtp(String phone); Future<Either<Failure, Unit>> verifyOtp({required String phone, required String code}); Future<Either<Failure, Profile>> register({required String phone, required String fullName, required String email, required String password}); Future<Either<Failure, Profile>> login({required String phone, required String password}); Future<Either<Failure, Profile>> verifyBvn(String bvn); Future<Either<Failure, Unit>> createPin(String pin); Future<bool> hasSession(); Future<bool> hasPin(); Future<Profile?> cachedProfile(); Future<bool> verifyPin(String pin); Future<void> signOut(); }`
  - `enum AuthStatus { unknown, needsOnboarding, unauthenticated, locked, authenticated }`
  - `class AuthState { AuthStatus status; Profile? profile; }`
  - `class AuthCubit extends Cubit<AuthState> { AuthCubit({required IAuthRepository repository, required ISettingsRepository settings}); Future<void> bootstrap(); Future<void> completeOnboarding(); void sessionStarted(Profile profile); void unlocked(); void profileUpdated(Profile profile); Future<void> signOut(); Profile? get profile; }`
  - `enum SignupStep { phone, otp, details, bvn, pin, done }`
  - `class SignupState { SignupStep step; String phone; bool isSubmitting; Failure? failure; Profile? profile; }`
  - `class SignupCubit extends Cubit<SignupState> { SignupCubit({required IAuthRepository repository, required AuthCubit authCubit}); Future<void> submitPhone(String phone); Future<void> submitOtp(String code); Future<void> submitDetails({required String fullName, required String email, required String password}); Future<void> submitBvn(String bvn); void skipBvn(); Future<void> submitPin(String pin); }`
  - `class LoginState { bool isSubmitting; Failure? failure; }`, `class LoginCubit extends Cubit<LoginState> { LoginCubit({required IAuthRepository repository, required AuthCubit authCubit}); Future<void> submit({required String phone, required String password}); }`
  - `class UnlockState { bool isVerifying; int failedAttempts; DateTime? lockedUntil; Failure? failure; bool get isLocked; }`, `class UnlockCubit extends Cubit<UnlockState> { UnlockCubit({required IAuthRepository repository, required ISettingsRepository settings, required BiometricGate biometricGate, required AuthCubit authCubit, DateTime Function()? clock}); Future<void> unlockWithPin(String pin); Future<bool> biometricAvailable(); Future<void> unlockWithBiometric(); }`

- [ ] **Step 1: Write the failing tests**

`test/features/auth/auth_repository_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/auth/secret_hasher.dart';
import 'package:nova_wallet/core/models/activity_item.dart';
import 'package:nova_wallet/core/storage/entities/transaction_entity.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/core/storage/session_store.dart';
import 'package:nova_wallet/features/auth/repository/auth_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_secure_storage.dart';
import '../../support/isar_test_db.dart';
import '../../support/server_harness.dart';

void main() {
  late ServerHarness h;
  late AuthRepositoryImpl repo;
  late InMemorySecureStorage secure;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    h = await ServerHarness.open(directory: await newTempDir(), tag: 'auth');
    secure = InMemorySecureStorage();
    repo = AuthRepositoryImpl(
      remote: h.server,
      session: SessionStore(secureStorage: secure, hasher: SecretHasher()),
      db: h.db,
      localStorage: LocalStorageImpl(prefs: await SharedPreferences.getInstance()),
      hasher: SecretHasher(),
    );
  });
  tearDown(() => h.close(deleteFromDisk: true));

  test('login stores the token in secure storage and caches the profile', () async {
    final profile = (await repo.login(phone: AppConstants.demoPhone, password: AppConstants.demoPassword))
        .getOrElse(() => throw StateError('login failed'));
    expect(profile.firstName, 'Tolu');
    expect(await repo.hasSession(), isTrue);
    expect(secure.values[SecureKeys.sessionToken], startsWith('nova_'));
    expect((await repo.cachedProfile())!.phone, AppConstants.demoPhone);
    // The demo account already has a PIN, so login carries its hash down.
    expect(await repo.hasPin(), isTrue);
    expect(await repo.verifyPin(AppConstants.demoPin), isTrue);
    expect(await repo.verifyPin('9999'), isFalse);
  });

  test('wrong password leaves no session', () async {
    final result = await repo.login(phone: AppConstants.demoPhone, password: 'wrong');
    expect(result.isLeft(), isTrue);
    expect(await repo.hasSession(), isFalse);
  });

  test('register then createPin: PIN verifies offline afterwards', () async {
    final profile = (await repo.register(
            phone: '09031234567', fullName: 'Tolu Ade', email: 't@x.com', password: 'Secret#123'))
        .getOrElse(() => throw StateError('register failed'));
    expect(profile.tier, 1);
    expect(await repo.hasPin(), isFalse);
    expect((await repo.createPin('1357')).isRight(), isTrue);
    expect(await repo.verifyPin('1357'), isTrue);

    final upgraded = (await repo.verifyBvn('22123456789')).getOrElse(() => throw StateError('bvn failed'));
    expect(upgraded.tier, 2);
    expect((await repo.cachedProfile())!.tier, 2);
  });

  test('signOut clears session, PIN and all client data (server keeps its own)', () async {
    await repo.login(phone: AppConstants.demoPhone, password: AppConstants.demoPassword);
    await h.db.client.writeTxn(() => h.db.client.transactionEntitys.put(TransactionEntity()
      ..serverRef = 'x'
      ..kind = ActivityKind.transfer
      ..direction = ActivityDirection.debit
      ..amountKobo = 1
      ..title = 't'
      ..createdAt = DateTime(2026, 9, 15)));
    await repo.signOut();
    expect(await repo.hasSession(), isFalse);
    expect(await repo.hasPin(), isFalse);
    expect(await repo.cachedProfile(), isNull);
    expect(await h.db.client.transactionEntitys.count(), 0);
    expect(await h.db.server.serverAccounts.count(), greaterThan(0));
  });

  test('offline register surfaces a NetworkFailure', () async {
    h.controls.simulateOffline = true;
    final result = await repo.register(phone: '09031234567', fullName: 'T', email: 't@x.com', password: 'Secret#123');
    expect(result.swap().getOrElse(() => throw StateError('expected failure')), isA<NetworkFailure>());
  });
}
```

`test/features/auth/auth_cubits_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/auth/secret_hasher.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/core/storage/session_store.dart';
import 'package:nova_wallet/features/auth/cubit/auth_cubit.dart';
import 'package:nova_wallet/features/auth/cubit/auth_state.dart';
import 'package:nova_wallet/features/auth/cubit/login_cubit.dart';
import 'package:nova_wallet/features/auth/cubit/signup_cubit.dart';
import 'package:nova_wallet/features/auth/cubit/signup_state.dart';
import 'package:nova_wallet/features/auth/cubit/unlock_cubit.dart';
import 'package:nova_wallet/features/auth/repository/auth_repository_impl.dart';
import 'package:nova_wallet/features/settings/repository/settings_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/fake_biometric_gate.dart';
import '../../support/in_memory_secure_storage.dart';
import '../../support/isar_test_db.dart';
import '../../support/server_harness.dart';

void main() {
  late ServerHarness h;
  late AuthRepositoryImpl repo;
  late SettingsRepositoryImpl settings;
  late AuthCubit auth;
  late FakeBiometricGate gate;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    h = await ServerHarness.open(directory: await newTempDir(), tag: 'authcubit');
    final prefs = await SharedPreferences.getInstance();
    final local = LocalStorageImpl(prefs: prefs);
    repo = AuthRepositoryImpl(
      remote: h.server,
      session: SessionStore(secureStorage: InMemorySecureStorage(), hasher: SecretHasher()),
      db: h.db,
      localStorage: local,
      hasher: SecretHasher(),
    );
    settings = SettingsRepositoryImpl(localStorage: local);
    auth = AuthCubit(repository: repo, settings: settings);
    gate = FakeBiometricGate();
  });

  tearDown(() async {
    await auth.close();
    await h.close(deleteFromDisk: true);
  });

  test('bootstrap: first launch needs onboarding, then unauthenticated', () async {
    await auth.bootstrap();
    expect(auth.state.status, AuthStatus.needsOnboarding);
    await auth.completeOnboarding();
    expect(auth.state.status, AuthStatus.unauthenticated);
  });

  test('bootstrap with a stored session goes to locked, not authenticated', () async {
    await repo.login(phone: AppConstants.demoPhone, password: AppConstants.demoPassword);
    await auth.bootstrap();
    expect(auth.state.status, AuthStatus.locked);
    expect(auth.state.profile!.firstName, 'Tolu');
  });

  test('login cubit signs in through AuthCubit', () async {
    final login = LoginCubit(repository: repo, authCubit: auth);
    await login.submit(phone: AppConstants.demoPhone, password: 'wrong');
    expect(login.state.failure, isNotNull);
    expect(auth.state.status, isNot(AuthStatus.authenticated));
    await login.submit(phone: AppConstants.demoPhone, password: AppConstants.demoPassword);
    expect(auth.state.status, AuthStatus.authenticated);
    await login.close();
  });

  test('signup walks phone → otp → details → bvn → pin and ends authenticated', () async {
    final signup = SignupCubit(repository: repo, authCubit: auth);
    await signup.submitPhone('09031234567');
    expect(signup.state.step, SignupStep.otp);
    await signup.submitOtp('000000');
    expect(signup.state.failure, isNotNull);
    await signup.submitOtp(AppConstants.fakeOtp);
    expect(signup.state.step, SignupStep.details);
    await signup.submitDetails(fullName: 'Tolu Ade', email: 't@x.com', password: 'Secret#123');
    expect(signup.state.step, SignupStep.bvn);
    await signup.submitBvn('22123456789');
    expect(signup.state.step, SignupStep.pin);
    await signup.submitPin('1357');
    expect(signup.state.step, SignupStep.done);
    expect(auth.state.status, AuthStatus.authenticated);
    expect(auth.state.profile!.tier, 2);
    expect(await repo.verifyPin('1357'), isTrue);
    await signup.close();
  });

  test('unlock: wrong PIN cools down after 3 and signs out after 5', () async {
    await repo.login(phone: AppConstants.demoPhone, password: AppConstants.demoPassword);
    await auth.bootstrap();
    var now = DateTime(2026, 9, 16, 9);
    final unlock = UnlockCubit(
        repository: repo, settings: settings, biometricGate: gate, authCubit: auth, clock: () => now);

    for (var i = 0; i < 3; i++) {
      await unlock.unlockWithPin('0000');
    }
    expect(unlock.state.failedAttempts, 3);
    expect(unlock.state.isLocked, isTrue);
    expect(auth.state.status, AuthStatus.locked);

    // While cooling down, an attempt is refused without counting.
    await unlock.unlockWithPin('0000');
    expect(unlock.state.failedAttempts, 3);

    // After the cooldown the remaining attempts count, and the 5th signs out.
    now = now.add(const Duration(seconds: 31));
    await unlock.unlockWithPin('0000');
    expect(unlock.state.failedAttempts, 4);
    now = now.add(const Duration(seconds: 31));
    await unlock.unlockWithPin('0000');
    expect(auth.state.status, AuthStatus.unauthenticated);
    await unlock.close();
  });

  test('unlock with the right PIN authenticates, and biometrics work offline', () async {
    await repo.login(phone: AppConstants.demoPhone, password: AppConstants.demoPassword);
    await auth.bootstrap();
    await settings.setBiometricEnabled(true);
    h.controls.simulateOffline = true;

    final unlock = UnlockCubit(repository: repo, settings: settings, biometricGate: gate, authCubit: auth);
    expect(await unlock.biometricAvailable(), isTrue);
    await unlock.unlockWithBiometric();
    expect(auth.state.status, AuthStatus.authenticated);
    expect(gate.confirmCalls, 1);

    await unlock.close();
  });
}
```

- [ ] **Step 2: Run to see them fail**

Run: `flutter test test/features/auth`
Expected: compilation errors.

- [ ] **Step 3: Implement the repository**

`lib/features/auth/repository/auth_repository.dart`
```dart
import 'package:dartz/dartz.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/profile.dart';

/// Sessions, registration and the device PIN.
abstract class IAuthRepository {
  Future<Either<Failure, Unit>> requestOtp(String phone);
  Future<Either<Failure, Unit>> verifyOtp({required String phone, required String code});

  Future<Either<Failure, Profile>> register({
    required String phone,
    required String fullName,
    required String email,
    required String password,
  });

  Future<Either<Failure, Profile>> login({required String phone, required String password});
  Future<Either<Failure, Profile>> verifyBvn(String bvn);

  /// Sets the transaction PIN: hashed on device, hash mirrored to the server so
  /// a later login on this device can verify it offline.
  Future<Either<Failure, Unit>> createPin(String pin);

  Future<bool> hasSession();
  Future<bool> hasPin();
  Future<Profile?> cachedProfile();

  /// Local, offline-capable check (spec A8).
  Future<bool> verifyPin(String pin);

  /// Clears the session, the PIN and ALL client data.
  Future<void> signOut();
}
```

`lib/features/auth/repository/auth_repository_impl.dart`
```dart
import 'package:dartz/dartz.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/api/service/dto.dart';
import '../../../core/api/service/nova_api_service.dart';
import '../../../core/auth/secret_hasher.dart';
import '../../../core/models/profile.dart';
import '../../../core/storage/entities/profile_entity.dart';
import '../../../core/storage/isar_db.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/storage/session_store.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl({
    required this.remote,
    required this.session,
    required this.db,
    required this.localStorage,
    required this.hasher,
  });

  final NovaApiService remote;
  final SessionStore session;
  final IsarDb db;
  final LocalStorage localStorage;
  final SecretHasher hasher;

  @override
  Future<Either<Failure, Unit>> requestOtp(String phone) => remote.requestOtp(phone: phone);

  @override
  Future<Either<Failure, Unit>> verifyOtp({required String phone, required String code}) =>
      remote.verifyOtp(phone: phone, code: code);

  @override
  Future<Either<Failure, Profile>> register({
    required String phone,
    required String fullName,
    required String email,
    required String password,
  }) async {
    final result = await remote.register(
        RegisterRequest(phone: phone, fullName: fullName, email: email, password: password));
    return result.fold(left, (dto) async => right(await _startSession(dto)));
  }

  @override
  Future<Either<Failure, Profile>> login({required String phone, required String password}) async {
    final result = await remote.login(phone: phone, password: password);
    return result.fold(left, (dto) async {
      // A different customer on the same device must never inherit the previous
      // one's cached data or queued items.
      final cached = await cachedProfile();
      if (cached != null && cached.phone != dto.profile.phone) await db.clearClient();
      return right(await _startSession(dto));
    });
  }

  Future<Profile> _startSession(SessionDto dto) async {
    await session.saveToken(dto.token);
    final pinHash = dto.pinHash;
    final pinSalt = dto.pinSalt;
    if (pinHash != null && pinSalt != null) {
      await session.savePinHash(hash: pinHash, salt: pinSalt);
    }
    final profile = dto.profile.toModel();
    await _cacheProfile(profile);
    return profile;
  }

  Future<void> _cacheProfile(Profile profile) => db.client
      .writeTxn(() => db.client.profileEntitys.put(ProfileEntity.fromModel(profile)));

  @override
  Future<Either<Failure, Profile>> verifyBvn(String bvn) async {
    final token = await session.readToken();
    if (token == null) return left(_expired);
    final result = await remote.verifyBvn(token: token, bvn: bvn);
    return result.fold(left, (dto) async {
      final profile = dto.toModel();
      await _cacheProfile(profile);
      return right(profile);
    });
  }

  @override
  Future<Either<Failure, Unit>> createPin(String pin) async {
    final token = await session.readToken();
    if (token == null) return left(_expired);
    final salt = hasher.newSalt();
    final hash = hasher.hash(pin, salt);
    final result = await remote.setPin(token: token, pinHash: hash, pinSalt: salt);
    return result.fold(left, (_) async {
      await session.savePinHash(hash: hash, salt: salt);
      return right(unit);
    });
  }

  @override
  Future<bool> hasSession() async => (await session.readToken()) != null;

  @override
  Future<bool> hasPin() => session.hasPin();

  @override
  Future<Profile?> cachedProfile() async =>
      (await db.client.profileEntitys.get(0))?.toModel();

  @override
  Future<bool> verifyPin(String pin) => session.verifyPin(pin);

  @override
  Future<void> signOut() async {
    await session.clear();
    await db.clearClient();
    await localStorage.clearSessionScoped();
  }

  static const Failure _expired =
      BusinessFailure(BusinessCode.unauthorized, 'Your session has expired. Please log in again.');
}
```

- [ ] **Step 4: Implement AuthCubit**

`lib/features/auth/cubit/auth_state.dart`
```dart
import 'package:equatable/equatable.dart';

import '../../../core/models/profile.dart';

enum AuthStatus {
  /// Before bootstrap finishes (splash).
  unknown,
  needsOnboarding,
  unauthenticated,

  /// A session exists but the app is locked (PIN / biometric).
  locked,
  authenticated,
}

class AuthState extends Equatable {
  const AuthState({required this.status, this.profile});

  const AuthState.unknown() : status = AuthStatus.unknown, profile = null;

  final AuthStatus status;
  final Profile? profile;

  AuthState copyWith({AuthStatus? status, Profile? profile}) =>
      AuthState(status: status ?? this.status, profile: profile ?? this.profile);

  @override
  List<Object?> get props => [status, profile];
}
```

`lib/features/auth/cubit/auth_cubit.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/profile.dart';
import '../../settings/repository/settings_repository.dart';
import '../repository/auth_repository.dart';
import 'auth_state.dart';

/// The session state machine every other session-scoped cubit follows.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.repository, required this.settings}) : super(const AuthState.unknown());

  final IAuthRepository repository;
  final ISettingsRepository settings;

  Profile? get profile => state.profile;

  /// Runs on the splash screen.
  Future<void> bootstrap() async {
    if (await repository.hasSession()) {
      emit(AuthState(status: AuthStatus.locked, profile: await repository.cachedProfile()));
      return;
    }
    final seen = await settings.onboardingSeen();
    emit(AuthState(status: seen ? AuthStatus.unauthenticated : AuthStatus.needsOnboarding));
  }

  Future<void> completeOnboarding() async {
    await settings.markOnboardingSeen();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void sessionStarted(Profile profile) =>
      emit(AuthState(status: AuthStatus.authenticated, profile: profile));

  void unlocked() => emit(AuthState(status: AuthStatus.authenticated, profile: state.profile));

  void profileUpdated(Profile profile) => emit(state.copyWith(profile: profile));

  Future<void> signOut() async {
    await repository.signOut();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
```

- [ ] **Step 5: Implement the signup, login and unlock cubits**

`lib/features/auth/cubit/signup_state.dart`
```dart
import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/profile.dart';

enum SignupStep { phone, otp, details, bvn, pin, done }

class SignupState extends Equatable {
  const SignupState({
    this.step = SignupStep.phone,
    this.phone = '',
    this.isSubmitting = false,
    this.failure,
    this.profile,
  });

  final SignupStep step;
  final String phone;
  final bool isSubmitting;
  final Failure? failure;
  final Profile? profile;

  SignupState copyWith({
    SignupStep? step,
    String? phone,
    bool? isSubmitting,
    Failure? failure,
    Profile? profile,
    bool clearFailure = false,
  }) =>
      SignupState(
        step: step ?? this.step,
        phone: phone ?? this.phone,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        failure: clearFailure ? null : (failure ?? this.failure),
        profile: profile ?? this.profile,
      );

  @override
  List<Object?> get props => [step, phone, isSubmitting, failure, profile];
}
```

`lib/features/auth/cubit/signup_cubit.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/utils/phone.dart';
import '../repository/auth_repository.dart';
import 'auth_cubit.dart';
import 'signup_state.dart';

/// One instance per signup run (registered as a factory).
class SignupCubit extends Cubit<SignupState> {
  SignupCubit({required this.repository, required this.authCubit}) : super(const SignupState());

  final IAuthRepository repository;
  final AuthCubit authCubit;

  String _fullName = '';
  String _email = '';
  String _password = '';

  Future<void> submitPhone(String phone) async {
    final normalized = PhoneNumber.normalize(phone);
    if (normalized == null) {
      emit(state.copyWith(
          failure: const ValidationFailure(ValidationCode.invalidInput, 'Enter a valid Nigerian phone number.')));
      return;
    }
    await _run(() async {
      final result = await repository.requestOtp(normalized);
      result.fold(
        (f) => emit(state.copyWith(failure: f)),
        (_) => emit(state.copyWith(step: SignupStep.otp, phone: normalized, clearFailure: true)),
      );
    });
  }

  Future<void> resendOtp() => _run(() async {
        final result = await repository.requestOtp(state.phone);
        result.fold((f) => emit(state.copyWith(failure: f)), (_) => emit(state.copyWith(clearFailure: true)));
      });

  Future<void> submitOtp(String code) => _run(() async {
        final result = await repository.verifyOtp(phone: state.phone, code: code);
        result.fold(
          (f) => emit(state.copyWith(failure: f)),
          (_) => emit(state.copyWith(step: SignupStep.details, clearFailure: true)),
        );
      });

  Future<void> submitDetails({
    required String fullName,
    required String email,
    required String password,
  }) =>
      _run(() async {
        _fullName = fullName;
        _email = email;
        _password = password;
        final result = await repository.register(
            phone: state.phone, fullName: fullName, email: email, password: password);
        result.fold(
          (f) => emit(state.copyWith(failure: f)),
          (profile) => emit(state.copyWith(step: SignupStep.bvn, profile: profile, clearFailure: true)),
        );
      });

  Future<void> submitBvn(String bvn) => _run(() async {
        final result = await repository.verifyBvn(bvn);
        result.fold(
          (f) => emit(state.copyWith(failure: f)),
          (profile) => emit(state.copyWith(step: SignupStep.pin, profile: profile, clearFailure: true)),
        );
      });

  void skipBvn() => emit(state.copyWith(step: SignupStep.pin, clearFailure: true));

  Future<void> submitPin(String pin) => _run(() async {
        final result = await repository.createPin(pin);
        await result.fold(
          (f) async => emit(state.copyWith(failure: f)),
          (_) async {
            final profile = state.profile ?? await repository.cachedProfile();
            if (profile != null) authCubit.sessionStarted(profile);
            emit(state.copyWith(step: SignupStep.done, clearFailure: true));
          },
        );
      });

  Future<void> _run(Future<void> Function() body) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, clearFailure: true));
    await body();
    if (!isClosed) emit(state.copyWith(isSubmitting: false));
  }
}
```

`lib/features/auth/cubit/login_state.dart`
```dart
import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';

class LoginState extends Equatable {
  const LoginState({this.isSubmitting = false, this.failure});

  final bool isSubmitting;
  final Failure? failure;

  @override
  List<Object?> get props => [isSubmitting, failure];
}
```

`lib/features/auth/cubit/login_cubit.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/utils/phone.dart';
import '../repository/auth_repository.dart';
import 'auth_cubit.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.repository, required this.authCubit}) : super(const LoginState());

  final IAuthRepository repository;
  final AuthCubit authCubit;

  Future<void> submit({required String phone, required String password}) async {
    if (state.isSubmitting) return;
    final normalized = PhoneNumber.normalize(phone);
    if (normalized == null) {
      emit(const LoginState(
          failure: ValidationFailure(ValidationCode.invalidInput, 'Enter a valid Nigerian phone number.')));
      return;
    }
    emit(const LoginState(isSubmitting: true));
    final result = await repository.login(phone: normalized, password: password);
    if (isClosed) return;
    result.fold(
      (f) => emit(LoginState(failure: f)),
      (profile) {
        authCubit.sessionStarted(profile);
        emit(const LoginState());
      },
    );
  }
}
```

`lib/features/auth/cubit/unlock_state.dart`
```dart
import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';

class UnlockState extends Equatable {
  const UnlockState({
    this.isVerifying = false,
    this.failedAttempts = 0,
    this.lockedUntil,
    this.failure,
  });

  final bool isVerifying;
  final int failedAttempts;
  final DateTime? lockedUntil;
  final Failure? failure;

  bool get isLocked => lockedUntil != null;

  @override
  List<Object?> get props => [isVerifying, failedAttempts, lockedUntil, failure];
}
```

`lib/features/auth/cubit/unlock_cubit.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/auth/biometric_gate.dart';
import '../../settings/repository/settings_repository.dart';
import '../repository/auth_repository.dart';
import 'auth_cubit.dart';
import 'unlock_state.dart';

/// Returning-user unlock. Works with no network: the PIN hash and the hardware
/// key both live on the device.
class UnlockCubit extends Cubit<UnlockState> {
  UnlockCubit({
    required this.repository,
    required this.settings,
    required this.biometricGate,
    required this.authCubit,
    DateTime Function()? clock,
  })  : _clock = clock ?? DateTime.now,
        super(const UnlockState());

  final IAuthRepository repository;
  final ISettingsRepository settings;
  final BiometricGate biometricGate;
  final AuthCubit authCubit;
  final DateTime Function() _clock;

  Future<bool> biometricAvailable() async =>
      await settings.biometricEnabled() && await biometricGate.isAvailable();

  Future<void> unlockWithPin(String pin) async {
    final lockedUntil = state.lockedUntil;
    if (lockedUntil != null && lockedUntil.isAfter(_clock())) {
      emit(UnlockState(
        failedAttempts: state.failedAttempts,
        lockedUntil: lockedUntil,
        failure: const ValidationFailure(ValidationCode.locked, 'Too many attempts. Try again shortly.'),
      ));
      return;
    }

    emit(UnlockState(isVerifying: true, failedAttempts: state.failedAttempts));
    final ok = await repository.verifyPin(pin);
    if (isClosed) return;

    if (ok) {
      emit(const UnlockState());
      authCubit.unlocked();
      return;
    }

    final attempts = state.failedAttempts + 1;
    if (attempts >= AppConstants.pinSignOutAfter) {
      emit(const UnlockState());
      await authCubit.signOut();
      return;
    }
    emit(UnlockState(
      failedAttempts: attempts,
      lockedUntil: attempts >= AppConstants.pinCooldownAfter
          ? _clock().add(AppConstants.pinCooldown)
          : null,
      failure: const ValidationFailure(ValidationCode.wrongPin, 'Incorrect PIN.'),
    ));
  }

  Future<void> unlockWithBiometric() async {
    if (!await biometricAvailable()) return;
    emit(UnlockState(isVerifying: true, failedAttempts: state.failedAttempts));
    final result = await biometricGate.confirm(
      payload: 'unlock:${_clock().millisecondsSinceEpoch}',
      reason: 'Unlock NovaPay',
    );
    if (isClosed) return;
    result.fold(
      (_) => emit(UnlockState(failedAttempts: state.failedAttempts)),
      (_) {
        emit(const UnlockState());
        authCubit.unlocked();
      },
    );
  }
}
```

- [ ] **Step 6: Run the tests**

Run: `flutter test test/features/auth`
Expected: all PASS.

- [ ] **Step 7: Checkpoint**. Report the files for the user to commit.

---

### Task 10: The outbox repository (the heart of the offline design)

**Files:**
- Create: `lib/features/sync/repository/outbox_repository.dart`, `outbox_repository_impl.dart`
- Create (test support): `test/support/outbox_harness.dart`
- Test: `test/features/sync/outbox_repository_test.dart`

**Interfaces:**
- Consumes: `IsarDb`, `NovaApiService`, `SessionStore`, DTOs, mappers, `OutboxItem*`, failures, `Beneficiary`
- Produces:
  - `class SendDraft { const SendDraft({required Beneficiary beneficiary, required int amountKobo, required int feeKobo, String? narration}); }`
  - `class CreateGoalDraft { const CreateGoalDraft({required String clientId, required String name, required int targetKobo, required DateTime targetDate}); }`
  - `class ContributeDraft { const ContributeDraft({required String goalClientId, required String goalName, required int amountKobo}); }`
  - `abstract class IOutboxRepository` with: `enqueueSend({required SendDraft draft, required bool online, String? biometricSignature})`, `enqueueCreateGoal({required CreateGoalDraft draft, required bool online})`, `enqueueContribute({required ContributeDraft draft, required bool online})` → `Future<Either<Failure, OutboxItem>>`; `Future<int> recoverInterrupted()`; `Future<OutboxItem?> claimNext(DateTime now)`; `Future<Either<Failure, MutationResultDto>> dispatch(OutboxItem item)`; `Future<void> markSucceeded(int id, MutationResultDto result, DateTime now)`; `Future<void> markFailed(int id, BusinessFailure failure, DateTime now)`; `Future<void> markRetry(int id, {required String message, DateTime? nextAttemptAt, bool countAttempt = true})`; `Future<void> clearBackoff()`; `Future<DateTime?> headRetryAt()`; `Future<OutboxItem?> byId(int id)`; `Stream<OutboxItem?> watchItem(int id)`; `Stream<List<OutboxItem>> watchActive()`; `Stream<List<OutboxItem>> watchAll({int limit})`; `Future<List<OutboxItem>> activeItems()`
  - `class OutboxRepositoryImpl implements IOutboxRepository { OutboxRepositoryImpl({required IsarDb db, required NovaApiService api, required SessionStore session, Uuid? uuid, DateTime Function()? clock}); }`
  - Test support: `class OutboxHarness { ServerHarness server; OutboxRepositoryImpl outbox; SessionStore session; IsarDb db; static Future<OutboxHarness> open({required String directory, required String tag}); Future<void> signIn(); Future<void> setLedger(int kobo); Future<int> ledger(); Future<void> close({bool deleteFromDisk}); }`

- [ ] **Step 1: Write the failing test and harness**

`test/support/outbox_harness.dart`
```dart
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/auth/secret_hasher.dart';
import 'package:nova_wallet/core/storage/entities/wallet_snapshot_entity.dart';
import 'package:nova_wallet/core/storage/isar_db.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/core/storage/session_store.dart';
import 'package:nova_wallet/features/auth/repository/auth_repository_impl.dart';
import 'package:nova_wallet/features/sync/repository/outbox_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_network_info.dart';
import 'in_memory_secure_storage.dart';
import 'server_harness.dart';

/// Client-side wiring for outbox/sync tests: a real Isar client DB, the fake
/// server, a real auth repository (so PIN checks work) and a signed-in session.
class OutboxHarness {
  OutboxHarness._(this.server, this.session, this.outbox, this.secure, this.authRepository);

  final ServerHarness server;
  final SessionStore session;
  final OutboxRepositoryImpl outbox;
  final InMemorySecureStorage secure;
  final AuthRepositoryImpl authRepository;

  IsarDb get db => server.db;
  FakeNetworkInfo get network => server.network;

  static Future<OutboxHarness> open({
    required String directory,
    required String tag,
    InMemorySecureStorage? secureStorage,
    FakeNetworkInfo? network,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final serverHarness = await ServerHarness.open(directory: directory, tag: tag, network: network);
    final secure = secureStorage ?? InMemorySecureStorage();
    final session = SessionStore(secureStorage: secure, hasher: SecretHasher());
    final outbox = OutboxRepositoryImpl(db: serverHarness.db, api: serverHarness.server, session: session);
    final auth = AuthRepositoryImpl(
      remote: serverHarness.server,
      session: session,
      db: serverHarness.db,
      localStorage: LocalStorageImpl(prefs: prefs),
      hasher: SecretHasher(),
    );
    return OutboxHarness._(serverHarness, session, outbox, secure, auth);
  }

  /// Logs in as the demo account, so the token AND the demo PIN hash are on the
  /// device, then seeds the local ledger.
  Future<void> signIn() async {
    await authRepository.login(
      phone: AppConstants.demoPhone,
      password: AppConstants.demoPassword,
    );
    await setLedger(AppConstants.demoOpeningBalanceKobo);
  }

  Future<void> setLedger(int kobo) => db.client.writeTxn(() => db.client.walletSnapshotEntitys.put(
        WalletSnapshotEntity()
          ..id = 0
          ..ledgerBalanceKobo = kobo
          ..lastSyncedAt = DateTime(2026, 9, 16),
      ));

  Future<int> ledger() async => (await db.client.walletSnapshotEntitys.get(0))!.ledgerBalanceKobo;

  Future<void> close({bool deleteFromDisk = false}) => server.close(deleteFromDisk: deleteFromDisk);
}
```

`test/features/sync/outbox_repository_test.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/models/beneficiary.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/features/sync/repository/outbox_repository.dart';

import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

const ada = Beneficiary(
    accountNumber: '0248214821', bankCode: '058', bankName: 'GTBank', verifiedName: 'ADAEZE OKAFOR');

SendDraft send(int amountKobo, {int feeKobo = 2688}) =>
    SendDraft(beneficiary: ada, amountKobo: amountKobo, feeKobo: feeKobo);

OutboxItem unwrap(Either<Failure, OutboxItem> either) =>
    either.fold((f) => fail('expected Right, got $f'), (r) => r);

void main() {
  late String dir;
  late OutboxHarness h;

  setUp(() async {
    dir = await newTempDir();
    h = await OutboxHarness.open(directory: dir, tag: 'outbox');
    await h.signIn();
  });
  tearDown(() => h.close(deleteFromDisk: true));

  test('enqueue persists a unique key, holds the funds, and is queued', () async {
    final item = unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: false));
    expect(item.status, OutboxStatus.queued);
    expect(item.idempotencyKey, isNotEmpty);
    expect(item.debitKobo, 2502688);
    expect(item.queuedWhileOffline, isTrue);
    expect((await h.outbox.activeItems()).single.id, item.id);
  });

  test('available balance is checked inside the transaction, so holds cannot be overspent', () async {
    await h.setLedger(5000000);
    unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: true));
    final second = await h.outbox.enqueueSend(draft: send(2500000), online: true);
    expect(second.isLeft(), isTrue);
    expect((second.swap().getOrElse(() => throw StateError('x')) as ValidationFailure).code,
        ValidationCode.insufficientAvailable);
    expect((await h.outbox.activeItems()).length, 1);
  });

  test('claimNext is FIFO and refuses to claim while another item is sending', () async {
    final first = unwrap(await h.outbox.enqueueSend(draft: send(100000, feeKobo: 1075), online: true));
    final second = unwrap(await h.outbox.enqueueSend(draft: send(200000, feeKobo: 1075), online: true));
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    expect(claimed!.id, first.id);
    expect(claimed.status, OutboxStatus.sending);
    expect(claimed.attempts, 1);
    expect(await h.outbox.claimNext(DateTime(2026, 9, 16, 10)), isNull, reason: 'one in flight');
    expect(second.status, OutboxStatus.queued);
  });

  test('success applies the server balance, saves the transaction and releases the hold', () async {
    final item = unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: true));
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    final result = (await h.outbox.dispatch(claimed!)).getOrElse(() => throw StateError('dispatch failed'));
    await h.outbox.markSucceeded(item.id, result, DateTime(2026, 9, 16, 10));

    final stored = (await h.outbox.byId(item.id))!;
    expect(stored.status, OutboxStatus.succeeded);
    expect(stored.serverRef, result.ref);
    expect(await h.ledger(), AppConstants.demoOpeningBalanceKobo - 2502688);
    expect(await h.outbox.activeItems(), isEmpty);
    expect(await h.db.client.transactionEntitys.count(), 1);
  });

  test('business rejection is terminal and releases the hold', () async {
    await h.setLedger(99000000); // client thinks it has more than the server does
    final item = unwrap(await h.outbox.enqueueSend(draft: send(90000000, feeKobo: 5375), online: true));
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    final failure = (await h.outbox.dispatch(claimed!)).swap().getOrElse(() => throw StateError('x'));
    await h.outbox.markFailed(item.id, failure as BusinessFailure, DateTime(2026, 9, 16, 10));

    final stored = (await h.outbox.byId(item.id))!;
    expect(stored.status, OutboxStatus.failed);
    expect(stored.failureCode, BusinessCode.insufficientFunds.name);
    expect(await h.outbox.activeItems(), isEmpty);
  });

  test('retry keeps the key, schedules backoff, and clearBackoff makes it due', () async {
    final item = unwrap(await h.outbox.enqueueSend(draft: send(100000, feeKobo: 1075), online: true));
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    final due = DateTime(2026, 9, 16, 10, 0, 4);
    await h.outbox.markRetry(claimed!.id, message: 'timeout', nextAttemptAt: due);

    final retried = (await h.outbox.byId(item.id))!;
    expect(retried.status, OutboxStatus.queued);
    expect(retried.idempotencyKey, item.idempotencyKey);
    expect(retried.attempts, 1);
    expect(await h.outbox.claimNext(DateTime(2026, 9, 16, 10, 0, 1)), isNull);
    expect(await h.outbox.headRetryAt(), due);
    await h.outbox.clearBackoff();
    expect((await h.outbox.claimNext(DateTime(2026, 9, 16, 10, 0, 1)))!.id, item.id);
  });

  test('an attempt that never reached the network is not counted', () async {
    unwrap(await h.outbox.enqueueSend(draft: send(100000, feeKobo: 1075), online: true));
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    expect(claimed!.attempts, 1);
    await h.outbox.markRetry(claimed.id, message: 'offline', countAttempt: false);
    expect((await h.outbox.byId(claimed.id))!.attempts, 0);
  });

  test('CRASH AFTER ACCEPT: server applied it, app died before marking — replay debits once', () async {
    final item = unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: true));
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    // The server applies the transfer...
    final firstResult = (await h.outbox.dispatch(claimed!)).getOrElse(() => throw StateError('x'));
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688);
    // ...and the app dies here, before markSucceeded. Restart:
    await h.close();
    h = await OutboxHarness.open(directory: dir, tag: 'outbox');
    await h.session.saveToken(await h.server.demoToken());

    expect(await h.outbox.recoverInterrupted(), 1);
    final recovered = (await h.outbox.byId(item.id))!;
    expect(recovered.status, OutboxStatus.queued);
    expect(recovered.idempotencyKey, item.idempotencyKey);

    final reclaimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10, 5));
    final replay = (await h.outbox.dispatch(reclaimed!)).getOrElse(() => throw StateError('x'));
    await h.outbox.markSucceeded(item.id, replay, DateTime(2026, 9, 16, 10, 5));

    expect(replay.ref, firstResult.ref, reason: 'same key returns the original response');
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688,
        reason: 'debited exactly once');
    expect((await h.outbox.byId(item.id))!.status, OutboxStatus.succeeded);
  });

  test('creating a goal writes a local goal in the same transaction', () async {
    final draft = CreateGoalDraft(
        clientId: 'goal-x', name: 'Laptop', targetKobo: 80000000, targetDate: DateTime(2027, 3, 1));
    unwrap(await h.outbox.enqueueCreateGoal(draft: draft, online: false));
    final goal = await h.db.client.goalEntitys.getByClientId('goal-x');
    expect(goal, isNotNull);
    expect(goal!.savedKobo, 0);
  });
}
```

- [ ] **Step 2: Run to see it fail**

Run: `flutter test test/features/sync/outbox_repository_test.dart`
Expected: compilation errors.

- [ ] **Step 3: Implement the interface** `lib/features/sync/repository/outbox_repository.dart`

```dart
import 'package:dartz/dartz.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/api/service/dto.dart';
import '../../../core/models/beneficiary.dart';
import '../../../core/models/outbox_item.dart';

class SendDraft {
  const SendDraft({
    required this.beneficiary,
    required this.amountKobo,
    required this.feeKobo,
    this.narration,
  });

  final Beneficiary beneficiary;
  final int amountKobo;
  final int feeKobo;
  final String? narration;
}

class CreateGoalDraft {
  const CreateGoalDraft({
    required this.clientId,
    required this.name,
    required this.targetKobo,
    required this.targetDate,
  });

  final String clientId;
  final String name;
  final int targetKobo;
  final DateTime targetDate;
}

class ContributeDraft {
  const ContributeDraft({
    required this.goalClientId,
    required this.goalName,
    required this.amountKobo,
  });

  final String goalClientId;
  final String goalName;
  final int amountKobo;
}

/// The durable queue of user intents, and the only path to a mutating call.
///
/// Every method that changes an item does so in one Isar transaction, so the
/// item's state and the money it represents can never disagree.
abstract class IOutboxRepository {
  /// Saves the intent with a fresh idempotency key and holds the funds.
  /// Returns [ValidationFailure] if the available balance can't cover it.
  Future<Either<Failure, OutboxItem>> enqueueSend({
    required SendDraft draft,
    required bool online,
    String? biometricSignature,
  });

  Future<Either<Failure, OutboxItem>> enqueueCreateGoal({
    required CreateGoalDraft draft,
    required bool online,
  });

  Future<Either<Failure, OutboxItem>> enqueueContribute({
    required ContributeDraft draft,
    required bool online,
  });

  /// `sending` → `queued` after a crash or restart. Keeps the key.
  Future<int> recoverInterrupted();

  /// Claims the FIFO head if it is due and nothing else is in flight.
  Future<OutboxItem?> claimNext(DateTime now);

  /// Sends the claimed item. Performs no local writes.
  Future<Either<Failure, MutationResultDto>> dispatch(OutboxItem item);

  Future<void> markSucceeded(int id, MutationResultDto result, DateTime now);
  Future<void> markFailed(int id, BusinessFailure failure, DateTime now);

  /// Back to `queued` with the same key. [countAttempt] false when the attempt
  /// never reached the network.
  Future<void> markRetry(int id, {required String message, DateTime? nextAttemptAt, bool countAttempt = true});

  /// Makes every queued item immediately due (used when connectivity returns).
  Future<void> clearBackoff();

  /// When the FIFO head becomes due, if it is waiting.
  Future<DateTime?> headRetryAt();

  Future<OutboxItem?> byId(int id);
  Stream<OutboxItem?> watchItem(int id);
  Stream<List<OutboxItem>> watchActive();
  Stream<List<OutboxItem>> watchAll({int limit});
  Future<List<OutboxItem>> activeItems();
}
```

- [ ] **Step 4: Implement** `lib/features/sync/repository/outbox_repository_impl.dart`

```dart
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/api/service/dto.dart';
import '../../../core/api/service/mappers.dart';
import '../../../core/api/service/nova_api_service.dart';
import '../../../core/models/goal_view.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/storage/entities/goal_entity.dart';
import '../../../core/storage/entities/outbox_item_entity.dart';
import '../../../core/storage/isar_db.dart';
import '../../../core/storage/session_store.dart';
import 'outbox_repository.dart';

class OutboxRepositoryImpl implements IOutboxRepository {
  OutboxRepositoryImpl({
    required this.db,
    required this.api,
    required this.session,
    Uuid? uuid,
    DateTime Function()? clock,
  })  : _uuid = uuid ?? const Uuid(),
        _clock = clock ?? DateTime.now;

  final IsarDb db;
  final NovaApiService api;
  final SessionStore session;
  final Uuid _uuid;
  final DateTime Function() _clock;

  Isar get _isar => db.client;
  IsarCollection<OutboxItemEntity> get _items => _isar.outboxItemEntitys;

  // ── Enqueue ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, OutboxItem>> enqueueSend({
    required SendDraft draft,
    required bool online,
    String? biometricSignature,
  }) {
    final b = draft.beneficiary;
    final entity = OutboxItemEntity()
      ..idempotencyKey = _uuid.v4()
      ..type = OutboxType.send
      ..status = OutboxStatus.queued
      ..amountKobo = draft.amountKobo
      ..feeKobo = draft.feeKobo
      ..payloadJson = jsonEncode(TransferRequest(
        bankCode: b.bankCode,
        bankName: b.bankName,
        accountNumber: b.accountNumber,
        recipientName: b.verifiedName,
        amountKobo: draft.amountKobo,
        narration: draft.narration,
      ).toJson())
      ..counterpartyName = b.verifiedName
      ..counterpartyBank = b.bankName
      ..maskedAccount = b.maskedAccount
      ..narration = draft.narration
      ..queuedWhileOffline = !online
      ..biometricSignature = biometricSignature
      ..createdAt = _clock();
    return _enqueue(entity, requiresFunds: true);
  }

  @override
  Future<Either<Failure, OutboxItem>> enqueueCreateGoal({
    required CreateGoalDraft draft,
    required bool online,
  }) {
    final now = _clock();
    final entity = OutboxItemEntity()
      ..idempotencyKey = _uuid.v4()
      ..type = OutboxType.createGoal
      ..status = OutboxStatus.queued
      ..amountKobo = 0
      ..payloadJson = jsonEncode(CreateGoalRequest(
        clientId: draft.clientId,
        name: draft.name,
        targetKobo: draft.targetKobo,
        targetDate: draft.targetDate,
      ).toJson())
      ..goalClientId = draft.clientId
      ..counterpartyName = draft.name
      ..queuedWhileOffline = !online
      ..createdAt = now;

    // The local goal is written in the SAME transaction, so a contribution can
    // reference it before it has ever reached the server.
    return _enqueue(
      entity,
      requiresFunds: false,
      alsoWrite: () => _isar.goalEntitys.put(GoalEntity()
        ..clientId = draft.clientId
        ..name = draft.name
        ..targetKobo = draft.targetKobo
        ..targetDate = draft.targetDate
        ..savedKobo = 0
        ..syncState = GoalSyncState.pending
        ..createdAt = now),
    );
  }

  @override
  Future<Either<Failure, OutboxItem>> enqueueContribute({
    required ContributeDraft draft,
    required bool online,
  }) {
    final entity = OutboxItemEntity()
      ..idempotencyKey = _uuid.v4()
      ..type = OutboxType.contribute
      ..status = OutboxStatus.queued
      ..amountKobo = draft.amountKobo
      ..payloadJson = jsonEncode(ContributeRequest(
        goalClientId: draft.goalClientId,
        amountKobo: draft.amountKobo,
      ).toJson())
      ..goalClientId = draft.goalClientId
      ..counterpartyName = draft.goalName
      ..queuedWhileOffline = !online
      ..createdAt = _clock();
    return _enqueue(entity, requiresFunds: true);
  }

  Future<Either<Failure, OutboxItem>> _enqueue(
    OutboxItemEntity entity, {
    required bool requiresFunds,
    Future<void> Function()? alsoWrite,
  }) async {
    try {
      final accepted = await _isar.writeTxn<bool>(() async {
        if (requiresFunds) {
          final snapshot = await _isar.walletSnapshotEntitys.get(0);
          final ledger = snapshot?.ledgerBalanceKobo ?? 0;
          final held = (await _activeEntities()).fold<int>(0, (sum, i) => sum + i.debitKobo);
          // Inside the write transaction, so two rapid confirms serialise and
          // the second sees the first one's hold.
          if (entity.debitKobo > ledger - held) return false;
        }
        await _items.put(entity);
        if (alsoWrite != null) await alsoWrite();
        return true;
      });
      if (!accepted) {
        return left(const ValidationFailure(
            ValidationCode.insufficientAvailable, 'This is more than your available balance.'));
      }
      return right(entity.toModel());
    } on IsarError catch (e) {
      return left(StorageFailure(e.message));
    }
  }

  Future<List<OutboxItemEntity>> _activeEntities() => _items
      .filter()
      .statusEqualTo(OutboxStatus.queued)
      .or()
      .statusEqualTo(OutboxStatus.sending)
      .findAll();

  // ── Claim / dispatch / settle ───────────────────────────────────────────

  @override
  Future<int> recoverInterrupted() => _isar.writeTxn<int>(() async {
        final stuck = await _items.filter().statusEqualTo(OutboxStatus.sending).findAll();
        for (final item in stuck) {
          item
            ..status = OutboxStatus.queued
            ..nextAttemptAt = null;
        }
        await _items.putAll(stuck);
        return stuck.length;
      });

  @override
  Future<OutboxItem?> claimNext(DateTime now) => _isar.writeTxn<OutboxItem?>(() async {
        // Never two in flight, whatever called us.
        final inFlight = await _items.filter().statusEqualTo(OutboxStatus.sending).count();
        if (inFlight > 0) return null;

        // Ascending id == FIFO. A later send must not overtake an earlier one.
        final head = await _items.filter().statusEqualTo(OutboxStatus.queued).findFirst();
        if (head == null) return null;
        final due = head.nextAttemptAt;
        if (due != null && due.isAfter(now)) return null;

        head
          ..status = OutboxStatus.sending
          ..attempts += 1
          ..lastAttemptAt = now
          ..nextAttemptAt = null;
        await _items.put(head);
        return head.toModel();
      });

  @override
  Future<Either<Failure, MutationResultDto>> dispatch(OutboxItem item) async {
    final token = await session.readToken();
    if (token == null) {
      return left(const BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.'));
    }
    final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
    switch (item.type) {
      case OutboxType.send:
        return api.transfer(
            token: token, idempotencyKey: item.idempotencyKey, request: TransferRequest.fromJson(payload));
      case OutboxType.createGoal:
        return api.createGoal(
            token: token, idempotencyKey: item.idempotencyKey, request: CreateGoalRequest.fromJson(payload));
      case OutboxType.contribute:
        return api.contribute(
            token: token, idempotencyKey: item.idempotencyKey, request: ContributeRequest.fromJson(payload));
    }
  }

  @override
  Future<void> markSucceeded(int id, MutationResultDto result, DateTime now) => _isar.writeTxn(() async {
        final item = await _items.get(id);
        if (item == null) return;
        item
          ..status = OutboxStatus.succeeded
          ..serverRef = result.ref
          ..completedAt = now
          ..nextAttemptAt = null
          ..failureCode = null
          ..failureMessage = null;
        await _items.put(item);

        // Ledger and item settle together: the hold disappears exactly as the
        // new balance lands, so available can never jump.
        final snapshot = await _isar.walletSnapshotEntitys.get(0) ??
            (WalletSnapshotEntity()
              ..id = 0
              ..ledgerBalanceKobo = 0);
        snapshot
          ..ledgerBalanceKobo = result.balanceAfterKobo
          ..lastSyncedAt = now;
        await _isar.walletSnapshotEntitys.put(snapshot);

        final txn = result.transaction;
        if (txn != null) await _isar.transactionEntitys.put(transactionEntityFromDto(txn));

        final goal = result.goal;
        if (goal != null) await _isar.goalEntitys.put(goalEntityFromDto(goal));
      });

  @override
  Future<void> markFailed(int id, BusinessFailure failure, DateTime now) => _isar.writeTxn(() async {
        final item = await _items.get(id);
        if (item == null) return;
        item
          ..status = OutboxStatus.failed
          ..completedAt = now
          ..nextAttemptAt = null
          ..failureCode = failure.code.name
          ..failureMessage = failure.message;
        await _items.put(item);

        // A goal whose creation was rejected must not look real.
        final goalId = item.goalClientId;
        if (item.type == OutboxType.createGoal && goalId != null) {
          final goal = await _isar.goalEntitys.getByClientId(goalId);
          if (goal != null) {
            goal.syncState = GoalSyncState.failed;
            await _isar.goalEntitys.put(goal);
          }
        }
      });

  @override
  Future<void> markRetry(
    int id, {
    required String message,
    DateTime? nextAttemptAt,
    bool countAttempt = true,
  }) =>
      _isar.writeTxn(() async {
        final item = await _items.get(id);
        if (item == null) return;
        item
          ..status = OutboxStatus.queued
          ..nextAttemptAt = nextAttemptAt
          ..failureMessage = message;
        if (!countAttempt && item.attempts > 0) item.attempts -= 1;
        await _items.put(item);
      });

  @override
  Future<void> clearBackoff() => _isar.writeTxn(() async {
        final waiting = await _items
            .filter()
            .statusEqualTo(OutboxStatus.queued)
            .nextAttemptAtIsNotNull()
            .findAll();
        for (final item in waiting) {
          item.nextAttemptAt = null;
        }
        await _items.putAll(waiting);
      });

  @override
  Future<DateTime?> headRetryAt() async {
    final head = await _items.filter().statusEqualTo(OutboxStatus.queued).findFirst();
    return head?.nextAttemptAt;
  }

  // ── Reads ───────────────────────────────────────────────────────────────

  @override
  Future<OutboxItem?> byId(int id) async => (await _items.get(id))?.toModel();

  @override
  Stream<OutboxItem?> watchItem(int id) =>
      _items.watchObject(id, fireImmediately: true).map((e) => e?.toModel());

  @override
  Stream<List<OutboxItem>> watchActive() => _items
      .filter()
      .statusEqualTo(OutboxStatus.queued)
      .or()
      .statusEqualTo(OutboxStatus.sending)
      .watch(fireImmediately: true)
      .map((rows) => rows.map((e) => e.toModel()).toList());

  @override
  Stream<List<OutboxItem>> watchAll({int limit = 100}) => _items
      .where()
      .sortByCreatedAtDesc()
      .limit(limit)
      .watch(fireImmediately: true)
      .map((rows) => rows.map((e) => e.toModel()).toList());

  @override
  Future<List<OutboxItem>> activeItems() async =>
      (await _activeEntities()).map((e) => e.toModel()).toList();
}
```

(`markSucceeded` imports `WalletSnapshotEntity` from `core/storage/entities/wallet_snapshot_entity.dart`.)

- [ ] **Step 5: Run the tests**

Run: `flutter test test/features/sync/outbox_repository_test.dart`
Expected: all PASS, including "CRASH AFTER ACCEPT".

- [ ] **Step 6: Checkpoint**. Report the files for the user to commit. This task is the core of the deck's exactly-once slide.

---

### Task 11: SyncCubit — single-flight, FIFO, exactly-once replay

**Files:**
- Create: `lib/core/notifications/sync_notifier.dart`
- Create: `lib/features/sync/cubit/sync_state.dart`, `sync_cubit.dart`
- Create (test support): `test/support/fake_sync_notifier.dart`
- Test: `test/features/sync/sync_cubit_test.dart`

**Interfaces:**
- Consumes: `IOutboxRepository`, `ConnectivityCubit`, `AsyncMutex`, `AppConstants`, `OutboxItem`, failures
- Produces:
  - `abstract class SyncNotifier { Future<void> syncSucceeded(OutboxItem item); Future<void> syncFailed(OutboxItem item); }`
  - `class SyncState { int pendingCount; int pendingDebitKobo; int troubleCount; bool isSyncing; DateTime? lastSyncedAt; int settledCount; }`
  - `class SyncCubit extends Cubit<SyncState> { SyncCubit({required IOutboxRepository outbox, required ConnectivityCubit connectivity, required SyncNotifier notifier, DateTime Function()? clock, Duration Function(int attempts)? backoff}); final AsyncMutex lock; Future<void> start(); Future<void> reset(); Future<void> drain(); void setForeground(bool value); }`
  - Test support: `class FakeSyncNotifier implements SyncNotifier { List<OutboxItem> succeeded; List<OutboxItem> failed; }`

- [ ] **Step 1: Write the failing test and the notifier fake**

`test/support/fake_sync_notifier.dart`
```dart
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/notifications/sync_notifier.dart';

class FakeSyncNotifier implements SyncNotifier {
  final List<OutboxItem> succeeded = [];
  final List<OutboxItem> failed = [];

  @override
  Future<void> syncSucceeded(OutboxItem item) async => succeeded.add(item);

  @override
  Future<void> syncFailed(OutboxItem item) async => failed.add(item);
}
```

`test/features/sync/sync_cubit_test.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/models/beneficiary.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/network/reachability.dart';
import 'package:nova_wallet/features/connectivity/cubit/connectivity_cubit.dart';
import 'package:nova_wallet/features/sync/cubit/sync_cubit.dart';
import 'package:nova_wallet/features/sync/repository/outbox_repository.dart';

import '../../support/fake_sync_notifier.dart';
import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

const ada = Beneficiary(
    accountNumber: '0248214821', bankCode: '058', bankName: 'GTBank', verifiedName: 'ADAEZE OKAFOR');
const nobody = Beneficiary(
    accountNumber: '0001112223', bankCode: '058', bankName: 'GTBank', verifiedName: 'NO ONE');

SendDraft send(int amountKobo, {Beneficiary to = ada, int feeKobo = 2688}) =>
    SendDraft(beneficiary: to, amountKobo: amountKobo, feeKobo: feeKobo);

OutboxItem unwrap(Either<Failure, OutboxItem> e) =>
    e.fold((f) => fail('expected Right, got $f'), (r) => r);

void main() {
  late String dir;
  late OutboxHarness h;
  late ConnectivityCubit connectivity;
  late FakeSyncNotifier notifier;
  late SyncCubit sync;

  Future<void> buildSync() async {
    connectivity = ConnectivityCubit(
      reachability: Reachability(networkInfo: h.network, controls: h.server.controls),
      onlineDebounce: const Duration(milliseconds: 10),
    );
    await connectivity.start();
    notifier = FakeSyncNotifier();
    sync = SyncCubit(
      outbox: h.outbox,
      connectivity: connectivity,
      notifier: notifier,
      backoff: (attempts) => const Duration(milliseconds: 20),
    );
  }

  setUp(() async {
    dir = await newTempDir();
    h = await OutboxHarness.open(directory: dir, tag: 'sync');
    await h.signIn();
    await buildSync();
  });

  tearDown(() async {
    await sync.close();
    await connectivity.close();
    await h.close(deleteFromDisk: true);
  });

  test('offline: nothing is sent and the item stays queued', () async {
    h.network.connected = false;
    await connectivity.recheck();
    final item = unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: false));
    await sync.start();
    await sync.drain();

    expect((await h.outbox.byId(item.id))!.status, OutboxStatus.queued);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo);
    expect(sync.state.pendingCount, 1);
    expect(sync.state.pendingDebitKobo, 2502688);
  });

  test('reconnecting drains the queue and notifies once', () async {
    h.network.connected = false;
    await connectivity.recheck();
    final item = unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: false));
    await sync.start();

    h.network.connected = true;
    await Future<void>.delayed(const Duration(milliseconds: 60));
    await sync.drain();

    expect((await h.outbox.byId(item.id))!.status, OutboxStatus.succeeded);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688);
    expect(await h.ledger(), AppConstants.demoOpeningBalanceKobo - 2502688);
    expect(notifier.succeeded.length, 1);
    expect(sync.state.pendingCount, 0);
  });

  test('SINGLE FLIGHT: five concurrent drains produce one debit', () async {
    unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: true));
    await sync.start();

    await Future.wait([sync.drain(), sync.drain(), sync.drain(), sync.drain(), sync.drain()]);

    expect(await h.db.server.processedRequests.count(), 1);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688);
  });

  test('RESTART RECOVERY: an item left sending is replayed with the same key, once', () async {
    final item = unwrap(await h.outbox.enqueueSend(draft: send(2500000), online: true));
    // Claim + dispatch, then "crash" before marking: the server has applied it.
    final claimed = await h.outbox.claimNext(DateTime(2026, 9, 16, 10));
    await h.outbox.dispatch(claimed!);
    expect((await h.outbox.byId(item.id))!.status, OutboxStatus.sending);

    await sync.start(); // start() recovers stuck items, then drains
    await sync.drain();

    expect((await h.outbox.byId(item.id))!.status, OutboxStatus.succeeded);
    expect(await h.db.server.processedRequests.count(), 1);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688);
  });

  test('LOST RESPONSE: timeout requeues with the same key; the replay debits nothing extra', () async {
    final item = unwrap(await h.outbox.enqueueSend(draft: send(1000000, feeKobo: 2688), online: true));
    h.server.controls.loseNextResponse = true;
    await sync.start();
    await sync.drain();

    final afterTimeout = (await h.outbox.byId(item.id))!;
    expect(afterTimeout.status, OutboxStatus.queued);
    expect(afterTimeout.attempts, 1);
    expect(afterTimeout.idempotencyKey, item.idempotencyKey);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 1002688);

    await Future<void>.delayed(const Duration(milliseconds: 40));
    await sync.drain();

    expect((await h.outbox.byId(item.id))!.status, OutboxStatus.succeeded);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 1002688);
    expect(await h.ledger(), AppConstants.demoOpeningBalanceKobo - 1002688);
  });

  test('a rejected item fails terminally and the next item still goes out (FIFO)', () async {
    final bad = unwrap(await h.outbox.enqueueSend(draft: send(500000, to: nobody, feeKobo: 1075), online: true));
    final good = unwrap(await h.outbox.enqueueSend(draft: send(500000, feeKobo: 1075), online: true));
    await sync.start();
    await sync.drain();

    expect((await h.outbox.byId(bad.id))!.status, OutboxStatus.failed);
    expect((await h.outbox.byId(bad.id))!.failureCode, BusinessCode.invalidAccount.name);
    expect((await h.outbox.byId(good.id))!.status, OutboxStatus.succeeded);
    expect(notifier.failed.length, 1);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 501075);
  });

  test('a queued goal is created before the contribution that depends on it', () async {
    final goal = unwrap(await h.outbox.enqueueCreateGoal(
        draft: CreateGoalDraft(
            clientId: 'goal-1', name: 'Laptop', targetKobo: 80000000, targetDate: DateTime(2027, 3, 1)),
        online: false));
    final contribution = unwrap(await h.outbox.enqueueContribute(
        draft: const ContributeDraft(goalClientId: 'goal-1', goalName: 'Laptop', amountKobo: 500000),
        online: false));

    await sync.start();
    await sync.drain();

    expect((await h.outbox.byId(goal.id))!.status, OutboxStatus.succeeded);
    expect((await h.outbox.byId(contribution.id))!.status, OutboxStatus.succeeded);
    expect((await h.db.client.goalEntitys.getByClientId('goal-1'))!.savedKobo, 500000);
  });
}
```

- [ ] **Step 2: Run to see it fail**

Run: `flutter test test/features/sync/sync_cubit_test.dart`
Expected: compilation errors.

- [ ] **Step 3: Implement the notifier contract** `lib/core/notifications/sync_notifier.dart`

```dart
import '../models/outbox_item.dart';

/// What the sync engine tells the user about, without knowing how (the local
/// notification implementation arrives in a later task).
abstract class SyncNotifier {
  Future<void> syncSucceeded(OutboxItem item);
  Future<void> syncFailed(OutboxItem item);
}
```

- [ ] **Step 4: Implement the state** `lib/features/sync/cubit/sync_state.dart`

```dart
import 'package:equatable/equatable.dart';

class SyncState extends Equatable {
  const SyncState({
    this.pendingCount = 0,
    this.pendingDebitKobo = 0,
    this.troubleCount = 0,
    this.isSyncing = false,
    this.lastSyncedAt,
    this.settledCount = 0,
  });

  /// Items queued or sending.
  final int pendingCount;

  /// Money those items are holding.
  final int pendingDebitKobo;

  /// Items that have failed to reach the server many times (trouble copy).
  final int troubleCount;

  final bool isSyncing;
  final DateTime? lastSyncedAt;

  /// Increments on every terminal outcome. The wallet watches this to refresh.
  final int settledCount;

  SyncState copyWith({
    int? pendingCount,
    int? pendingDebitKobo,
    int? troubleCount,
    bool? isSyncing,
    DateTime? lastSyncedAt,
    int? settledCount,
  }) =>
      SyncState(
        pendingCount: pendingCount ?? this.pendingCount,
        pendingDebitKobo: pendingDebitKobo ?? this.pendingDebitKobo,
        troubleCount: troubleCount ?? this.troubleCount,
        isSyncing: isSyncing ?? this.isSyncing,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        settledCount: settledCount ?? this.settledCount,
      );

  @override
  List<Object?> get props =>
      [pendingCount, pendingDebitKobo, troubleCount, isSyncing, lastSyncedAt, settledCount];
}
```

- [ ] **Step 5: Implement** `lib/features/sync/cubit/sync_cubit.dart`

```dart
import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/notifications/sync_notifier.dart';
import '../../../core/utils/async_mutex.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../repository/outbox_repository.dart';
import 'sync_state.dart';

/// Replays the outbox. The ONLY place that sends a queued action.
///
/// Guarantees, in the order they matter:
/// 1. one replay at a time ([drain] joins an in-flight pass);
/// 2. strict FIFO, one item at a time;
/// 3. an item is claimed (`sending`) before the network call, and recovered to
///    `queued` on the next start if the app died mid-flight;
/// 4. a transport failure NEVER fails the item — it is retried with the same
///    idempotency key, which the server deduplicates;
/// 5. a business rejection is terminal, releases the hold and tells the user.
class SyncCubit extends Cubit<SyncState> {
  SyncCubit({
    required this.outbox,
    required this.connectivity,
    required this.notifier,
    DateTime Function()? clock,
    Duration Function(int attempts)? backoff,
  })  : _clock = clock ?? DateTime.now,
        _backoff = backoff ?? defaultBackoff,
        super(const SyncState());

  final IOutboxRepository outbox;
  final ConnectivityCubit connectivity;
  final SyncNotifier notifier;
  final DateTime Function() _clock;
  final Duration Function(int attempts) _backoff;

  /// Held for a whole pass. A wallet refresh takes it too, so a balance read
  /// can never interleave with a send that is settling.
  final AsyncMutex lock = AsyncMutex();

  bool appInForeground = true;

  Future<void>? _inFlight;
  bool _rerun = false;
  Timer? _retryTimer;
  StreamSubscription<List<OutboxItem>>? _activeSub;
  StreamSubscription<ConnectivityStatus>? _connSub;

  /// 2s, 4s, 8s … capped at 60s.
  static Duration defaultBackoff(int attempts) =>
      Duration(seconds: min(AppConstants.maxBackoffSeconds, 1 << attempts.clamp(1, 6)));

  Future<void> start() async {
    if (_activeSub != null) return;
    // Anything the last run left in flight goes back in the queue, same key.
    await outbox.recoverInterrupted();
    _activeSub = outbox.watchActive().listen(_onActive);
    _connSub = connectivity.stream.listen((status) async {
      if (status != ConnectivityStatus.online) return;
      // Back online: don't sit out a backoff that was scheduled while offline.
      await outbox.clearBackoff();
      unawaited(drain());
    });
    if (connectivity.isOnline) unawaited(drain());
  }

  Future<void> reset() async {
    _retryTimer?.cancel();
    await _activeSub?.cancel();
    await _connSub?.cancel();
    _activeSub = null;
    _connSub = null;
    _safeEmit(const SyncState());
  }

  /// App resumed/paused. Resuming is a replay trigger.
  void setForeground(bool value) {
    appInForeground = value;
    if (value && connectivity.isOnline) unawaited(drain());
  }

  /// Runs a replay pass, or joins the one already running.
  Future<void> drain() {
    final running = _inFlight;
    if (running != null) {
      _rerun = true; // something new arrived; do one more pass afterwards
      return running;
    }
    final completer = Completer<void>();
    _inFlight = completer.future;
    unawaited(() async {
      try {
        do {
          _rerun = false;
          await lock.synchronized(_pass);
        } while (_rerun && connectivity.isOnline);
      } catch (_) {
        // A pass must never take the app down; failures are recorded per item.
      } finally {
        _inFlight = null;
        completer.complete();
      }
    }());
    return completer.future;
  }

  Future<void> _pass() async {
    if (!connectivity.isOnline) return;
    _safeEmit(state.copyWith(isSyncing: true));
    try {
      while (connectivity.isOnline) {
        final item = await outbox.claimNext(_clock());
        if (item == null) break;

        final result = await outbox.dispatch(item);
        final keepGoing = await result.fold(
          (failure) => _handleFailure(item, failure),
          (success) async {
            await outbox.markSucceeded(item.id, success, _clock());
            final settled = (await outbox.byId(item.id)) ?? item;
            await _notify(settled, succeeded: true);
            _safeEmit(state.copyWith(settledCount: state.settledCount + 1));
            return true;
          },
        );
        if (!keepGoing) break;
      }
    } finally {
      _safeEmit(state.copyWith(isSyncing: false, lastSyncedAt: _clock()));
      await _scheduleRetry();
    }
  }

  /// Returns whether the pass should continue with the next item.
  Future<bool> _handleFailure(OutboxItem item, Failure failure) async {
    // An expired session is not the item's fault: keep it queued.
    final retryable = failure is NetworkFailure ||
        failure is StorageFailure ||
        (failure is BusinessFailure && failure.code == BusinessCode.unauthorized);

    if (!retryable && failure is BusinessFailure) {
      await outbox.markFailed(item.id, failure, _clock());
      final settled = (await outbox.byId(item.id)) ?? item;
      await _notify(settled, succeeded: false);
      _safeEmit(state.copyWith(settledCount: state.settledCount + 1));
      return true; // a rejection blocks nobody else
    }

    // Unknown outcome. Same key, later.
    final wentOffline = !connectivity.isOnline;
    await outbox.markRetry(
      item.id,
      message: failure.message,
      nextAttemptAt: wentOffline ? null : _clock().add(_backoff(item.attempts)),
      countAttempt: !wentOffline,
    );
    return false; // FIFO: don't let the next item overtake the head
  }

  Future<void> _notify(OutboxItem item, {required bool succeeded}) async {
    // Only tell the user about things they weren't watching happen.
    if (!item.queuedWhileOffline && appInForeground) return;
    if (succeeded) {
      await notifier.syncSucceeded(item);
    } else {
      await notifier.syncFailed(item);
    }
  }

  Future<void> _scheduleRetry() async {
    _retryTimer?.cancel();
    if (!connectivity.isOnline) return;
    final at = await outbox.headRetryAt();
    if (at == null) return;
    final delay = at.difference(_clock());
    _retryTimer = Timer(delay.isNegative ? Duration.zero : delay, () => unawaited(drain()));
  }

  void _onActive(List<OutboxItem> items) {
    _safeEmit(state.copyWith(
      pendingCount: items.length,
      pendingDebitKobo: items.fold<int>(0, (sum, i) => sum + i.debitKobo),
      troubleCount: items.where((i) => i.attempts >= AppConstants.troubleAttemptThreshold).length,
    ));
  }

  void _safeEmit(SyncState next) {
    if (!isClosed) emit(next);
  }

  @override
  Future<void> close() async {
    _retryTimer?.cancel();
    await _activeSub?.cancel();
    await _connSub?.cancel();
    return super.close();
  }
}
```

- [ ] **Step 6: Run the tests**

Run: `flutter test test/features/sync`
Expected: all PASS.

- [ ] **Step 7: Checkpoint**. Report the files for the user to commit. Slides 4 and 5 of the deck come straight from this file's class comment.

---

### Task 12: Wallet repository and WalletCubit

**Files:**
- Create: `lib/features/wallet/repository/wallet_repository.dart`, `wallet_repository_impl.dart`
- Create: `lib/features/wallet/cubit/wallet_state.dart`, `wallet_cubit.dart`
- Test: `test/features/wallet/wallet_test.dart`

**Interfaces:**
- Consumes: `IsarDb`, `NovaApiService`, `SessionStore`, `SyncCubit`, `combineLatest2`, `WalletOverview`, `ActivityItem`, entities
- Produces:
  - `abstract class IWalletRepository { Stream<WalletOverview> watchOverview(); Stream<List<ActivityItem>> watchActivity({int limit}); Future<WalletOverview> currentOverview(); Future<Either<Failure, Unit>> refresh(); }`
  - `class WalletRepositoryImpl implements IWalletRepository { WalletRepositoryImpl({required IsarDb db, required NovaApiService api, required SessionStore session, DateTime Function()? clock}); }`
  - `enum WalletStatus { initial, loading, ready, error }`
  - `class WalletState { WalletStatus status; WalletOverview overview; List<ActivityItem> activity; bool isRefreshing; Failure? lastRefreshFailure; int limit; }`
  - `class WalletCubit extends Cubit<WalletState> { WalletCubit({required IWalletRepository repository, required SyncCubit sync}); Future<void> start(); Future<void> reset(); Future<void> refresh(); Future<void> loadMore(); int get availableKobo; }`

- [ ] **Step 1: Write the failing test** `test/features/wallet/wallet_test.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/models/activity_item.dart';
import 'package:nova_wallet/core/models/beneficiary.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/features/sync/repository/outbox_repository.dart';
import 'package:nova_wallet/features/wallet/repository/wallet_repository_impl.dart';

import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

const ada = Beneficiary(
    accountNumber: '0248214821', bankCode: '058', bankName: 'GTBank', verifiedName: 'ADAEZE OKAFOR');

OutboxItem unwrap(Either<Failure, OutboxItem> e) =>
    e.fold((f) => fail('expected Right, got $f'), (r) => r);

void main() {
  late OutboxHarness h;
  late WalletRepositoryImpl wallet;

  setUp(() async {
    h = await OutboxHarness.open(directory: await newTempDir(), tag: 'wallet');
    await h.signIn();
    wallet = WalletRepositoryImpl(db: h.db, api: h.server.server, session: h.session);
  });
  tearDown(() => h.close(deleteFromDisk: true));

  test('refresh pulls the balance, profile and history into Isar', () async {
    await h.setLedger(0);
    expect((await wallet.refresh()).isRight(), isTrue);
    final overview = await wallet.currentOverview();
    expect(overview.ledgerKobo, AppConstants.demoOpeningBalanceKobo);
    expect(overview.availableKobo, AppConstants.demoOpeningBalanceKobo);
    expect(await h.db.client.transactionEntitys.count(), 60);
  });

  test('refresh while offline keeps cached data and reports the failure', () async {
    await wallet.refresh();
    h.server.controls.simulateOffline = true;
    final result = await wallet.refresh();
    expect(result.swap().getOrElse(() => throw StateError('x')), isA<NetworkFailure>());
    expect((await wallet.currentOverview()).ledgerKobo, AppConstants.demoOpeningBalanceKobo);
    expect(await h.db.client.transactionEntitys.count(), 60);
  });

  test('available balance subtracts pending holds as soon as an item is queued', () async {
    await wallet.refresh();
    final overviews = <int>[];
    final sub = wallet.watchOverview().listen((o) => overviews.add(o.availableKobo));
    await pumpEventQueue();

    unwrap(await h.outbox.enqueueSend(
        draft: const SendDraft(beneficiary: ada, amountKobo: 2500000, feeKobo: 2688), online: false));
    await pumpEventQueue();

    expect(overviews.first, AppConstants.demoOpeningBalanceKobo);
    expect(overviews.last, AppConstants.demoOpeningBalanceKobo - 2502688);
    final current = await wallet.currentOverview();
    expect(current.heldKobo, 2502688);
    expect(current.pendingCount, 1);
    await sub.cancel();
  });

  test('activity shows pending items above settled history', () async {
    await wallet.refresh();
    unwrap(await h.outbox.enqueueSend(
        draft: const SendDraft(beneficiary: ada, amountKobo: 2500000, feeKobo: 2688), online: false));
    final activity = await wallet.watchActivity(limit: 10).first;

    expect(activity.first.status, ActivityStatus.pending);
    expect(activity.first.title, 'ADAEZE OKAFOR');
    expect(activity.first.signedKobo, -2502688);
    expect(activity.skip(1).every((a) => a.status == ActivityStatus.completed), isTrue);
    expect(activity.length, 10);
  });
}
```

- [ ] **Step 2: Run to see it fail.** Run: `flutter test test/features/wallet` — compilation errors.

- [ ] **Step 3: Implement the repository**

`lib/features/wallet/repository/wallet_repository.dart`
```dart
import 'package:dartz/dartz.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/activity_item.dart';
import '../../../core/models/wallet_overview.dart';

/// Reads the wallet from local storage (so the app renders offline) and pulls
/// fresh figures when asked.
abstract class IWalletRepository {
  /// Ledger balance minus outbox holds. Emits on every relevant Isar change.
  Stream<WalletOverview> watchOverview();

  /// Pending/failed outbox items first, then settled transactions.
  Stream<List<ActivityItem>> watchActivity({int limit});

  Future<WalletOverview> currentOverview();

  /// Pulls balance, profile and history. Caller holds the sync lock.
  Future<Either<Failure, Unit>> refresh();
}
```

`lib/features/wallet/repository/wallet_repository_impl.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:isar_community/isar.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/api/service/mappers.dart';
import '../../../core/api/service/nova_api_service.dart';
import '../../../core/models/activity_item.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/models/wallet_overview.dart';
import '../../../core/storage/entities/outbox_item_entity.dart';
import '../../../core/storage/entities/profile_entity.dart';
import '../../../core/storage/entities/transaction_entity.dart';
import '../../../core/storage/entities/wallet_snapshot_entity.dart';
import '../../../core/storage/isar_db.dart';
import '../../../core/storage/session_store.dart';
import '../../../core/utils/streams.dart';
import 'wallet_repository.dart';

class WalletRepositoryImpl implements IWalletRepository {
  WalletRepositoryImpl({
    required this.db,
    required this.api,
    required this.session,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final IsarDb db;
  final NovaApiService api;
  final SessionStore session;
  final DateTime Function() _clock;

  Isar get _isar => db.client;

  /// Unsettled items: queued and sending hold money; failed ones are shown so
  /// the user can see what went wrong.
  Query<OutboxItemEntity> get _unsettled => _isar.outboxItemEntitys
      .filter()
      .statusEqualTo(OutboxStatus.queued)
      .or()
      .statusEqualTo(OutboxStatus.sending)
      .or()
      .statusEqualTo(OutboxStatus.failed)
      .sortByCreatedAtDesc()
      .build();

  WalletOverview _overview(WalletSnapshotEntity? snapshot, List<OutboxItemEntity> unsettled) {
    final active = unsettled.where((i) => i.status != OutboxStatus.failed).toList();
    return WalletOverview(
      ledgerKobo: snapshot?.ledgerBalanceKobo ?? 0,
      heldKobo: active.fold<int>(0, (sum, i) => sum + i.debitKobo),
      pendingCount: active.length,
      lastSyncedAt: snapshot?.lastSyncedAt,
    );
  }

  @override
  Stream<WalletOverview> watchOverview() => combineLatest2(
        _isar.walletSnapshotEntitys.watchObject(0, fireImmediately: true),
        _unsettled.watch(fireImmediately: true),
        _overview,
      );

  @override
  Future<WalletOverview> currentOverview() async =>
      _overview(await _isar.walletSnapshotEntitys.get(0), await _unsettled.findAll());

  @override
  Stream<List<ActivityItem>> watchActivity({int limit = AppConstants.pageSize}) => combineLatest2(
        _unsettled.watch(fireImmediately: true),
        _isar.transactionEntitys.where().sortByCreatedAtDesc().limit(limit).watch(fireImmediately: true),
        (List<OutboxItemEntity> pending, List<TransactionEntity> settled) => [
          for (final item in pending) _activityFromOutbox(item),
          for (final txn in settled) txn.toActivity(),
        ].take(limit).toList(),
      );

  ActivityItem _activityFromOutbox(OutboxItemEntity item) => ActivityItem(
        id: 'outbox:${item.id}',
        status: switch (item.status) {
          OutboxStatus.sending => ActivityStatus.sending,
          OutboxStatus.failed => ActivityStatus.failed,
          _ => ActivityStatus.pending,
        },
        kind: switch (item.type) {
          OutboxType.contribute => ActivityKind.contribution,
          OutboxType.createGoal => ActivityKind.goalCreated,
          OutboxType.send => ActivityKind.transfer,
        },
        direction: ActivityDirection.debit,
        amountKobo: item.amountKobo,
        feeKobo: item.feeKobo,
        title: item.counterpartyName ?? 'NovaPay',
        subtitle: item.counterpartyBank == null
            ? item.maskedAccount
            : '${item.counterpartyBank} · ${item.maskedAccount ?? ''}'.trim(),
        narration: item.narration,
        createdAt: item.createdAt,
        outboxId: item.id,
        failureMessage: item.failureMessage,
        goalClientId: item.goalClientId,
      );

  @override
  Future<Either<Failure, Unit>> refresh() async {
    final token = await session.readToken();
    if (token == null) {
      return left(const BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.'));
    }

    final walletResult = await api.getWallet(token: token);
    return walletResult.fold(left, (wallet) async {
      final txnResult = await api.getTransactions(token: token);
      return txnResult.fold(left, (transactions) async {
        await _isar.writeTxn(() async {
          await _isar.walletSnapshotEntitys.put(WalletSnapshotEntity()
            ..id = 0
            ..ledgerBalanceKobo = wallet.balanceKobo
            ..lastSyncedAt = _clock());
          await _isar.profileEntitys.put(ProfileEntity.fromModel(wallet.profile.toModel()));
          await _isar.transactionEntitys.putAll(transactions.map(transactionEntityFromDto).toList());
        });
        return right(unit);
      });
    });
  }
}
```

- [ ] **Step 4: Implement the cubit**

`lib/features/wallet/cubit/wallet_state.dart`
```dart
import 'package:equatable/equatable.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/models/activity_item.dart';
import '../../../core/models/wallet_overview.dart';

enum WalletStatus { initial, loading, ready, error }

class WalletState extends Equatable {
  const WalletState({
    this.status = WalletStatus.initial,
    this.overview = WalletOverview.empty,
    this.activity = const [],
    this.isRefreshing = false,
    this.lastRefreshFailure,
    this.limit = AppConstants.pageSize,
  });

  final WalletStatus status;
  final WalletOverview overview;
  final List<ActivityItem> activity;
  final bool isRefreshing;

  /// Set when a refresh failed while cached figures are still on screen
  /// ("Last updated …").
  final Failure? lastRefreshFailure;
  final int limit;

  WalletState copyWith({
    WalletStatus? status,
    WalletOverview? overview,
    List<ActivityItem>? activity,
    bool? isRefreshing,
    Failure? lastRefreshFailure,
    bool clearFailure = false,
    int? limit,
  }) =>
      WalletState(
        status: status ?? this.status,
        overview: overview ?? this.overview,
        activity: activity ?? this.activity,
        isRefreshing: isRefreshing ?? this.isRefreshing,
        lastRefreshFailure: clearFailure ? null : (lastRefreshFailure ?? this.lastRefreshFailure),
        limit: limit ?? this.limit,
      );

  @override
  List<Object?> get props => [status, overview, activity, isRefreshing, lastRefreshFailure, limit];
}
```

`lib/features/wallet/cubit/wallet_cubit.dart`
```dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/models/activity_item.dart';
import '../../../core/models/wallet_overview.dart';
import '../../sync/cubit/sync_cubit.dart';
import '../repository/wallet_repository.dart';
import 'wallet_state.dart';

/// Home screen state. Session-scoped: [start] on sign-in, [reset] on sign-out.
class WalletCubit extends Cubit<WalletState> {
  WalletCubit({required this.repository, required this.sync}) : super(const WalletState());

  final IWalletRepository repository;
  final SyncCubit sync;

  StreamSubscription<WalletOverview>? _overviewSub;
  StreamSubscription<List<ActivityItem>>? _activitySub;
  StreamSubscription<SyncState>? _syncSub;
  int _lastSettledCount = 0;

  int get availableKobo => state.overview.availableKobo;

  Future<void> start() async {
    if (_overviewSub != null) return;
    emit(state.copyWith(status: WalletStatus.loading));
    _overviewSub = repository.watchOverview().listen(
          (overview) => emit(state.copyWith(overview: overview, status: WalletStatus.ready)),
        );
    _subscribeActivity();
    // Every settled item changes the server-side truth; re-read it quietly.
    _lastSettledCount = sync.state.settledCount;
    _syncSub = sync.stream.listen((syncState) {
      if (syncState.settledCount == _lastSettledCount) return;
      _lastSettledCount = syncState.settledCount;
      unawaited(_quietRefresh());
    });
    await refresh();
  }

  void _subscribeActivity() {
    _activitySub?.cancel();
    _activitySub = repository
        .watchActivity(limit: state.limit)
        .listen((activity) => emit(state.copyWith(activity: activity)));
  }

  /// Pull-to-refresh: send what's queued first, then read the balance.
  Future<void> refresh() async {
    emit(state.copyWith(isRefreshing: true, clearFailure: true));
    await sync.drain();
    await _quietRefresh();
    if (!isClosed) emit(state.copyWith(isRefreshing: false));
  }

  Future<void> _quietRefresh() async {
    // Under the sync lock: a balance fetched mid-send must never overwrite the
    // balance that send is about to apply.
    final result = await sync.lock.synchronized(repository.refresh);
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(
        lastRefreshFailure: failure,
        status: state.status == WalletStatus.loading ? WalletStatus.ready : state.status,
      )),
      (_) => emit(state.copyWith(status: WalletStatus.ready, clearFailure: true)),
    );
  }

  Future<void> loadMore() async {
    emit(state.copyWith(limit: state.limit + AppConstants.pageSize));
    _subscribeActivity();
  }

  Future<void> reset() async {
    await _overviewSub?.cancel();
    await _activitySub?.cancel();
    await _syncSub?.cancel();
    _overviewSub = null;
    _activitySub = null;
    _syncSub = null;
    if (!isClosed) emit(const WalletState());
  }

  @override
  Future<void> close() async {
    await _overviewSub?.cancel();
    await _activitySub?.cancel();
    await _syncSub?.cancel();
    return super.close();
  }
}
```

- [ ] **Step 5: Run the tests.** Run: `flutter test test/features/wallet` — all PASS.

- [ ] **Step 6: Checkpoint.** Report the files for the user to commit.

---

### Task 13: Beneficiaries (saved recipients and name enquiry)

**Files:**
- Create: `lib/features/beneficiaries/repository/beneficiary_repository.dart`, `beneficiary_repository_impl.dart`
- Create: `lib/features/beneficiaries/cubit/beneficiaries_cubit.dart`, `name_enquiry_state.dart`, `name_enquiry_cubit.dart`
- Test: `test/features/beneficiaries/beneficiaries_test.dart`

**Interfaces:**
- Produces:
  - `abstract class IBeneficiaryRepository { Stream<List<Beneficiary>> watchAll(); Future<List<Beneficiary>> all(); Future<Either<Failure, Beneficiary>> verify({required String bankCode, required String accountNumber}); Future<Either<Failure, Unit>> save(Beneficiary beneficiary); Future<void> touch(Beneficiary beneficiary); Future<Either<Failure, Unit>> refresh(); }`
  - `class BeneficiariesCubit extends Cubit<List<Beneficiary>> { BeneficiariesCubit({required IBeneficiaryRepository repository}); Future<void> start(); Future<void> reset(); Future<void> refresh(); void search(String query); List<Beneficiary> get visible; }`
  - `class NameEnquiryState { Bank? bank; String accountNumber; bool isVerifying; Beneficiary? verified; Failure? failure; bool saveBeneficiary; }`
  - `class NameEnquiryCubit extends Cubit<NameEnquiryState> { NameEnquiryCubit({required IBeneficiaryRepository repository, required ConnectivityCubit connectivity}); void selectBank(Bank bank); Future<void> accountNumberChanged(String value); void toggleSave(bool value); Future<Either<Failure, Beneficiary>> confirm(); }`

- [ ] **Step 1: Write the failing test** `test/features/beneficiaries/beneficiaries_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/models/bank.dart';
import 'package:nova_wallet/core/network/reachability.dart';
import 'package:nova_wallet/features/beneficiaries/cubit/name_enquiry_cubit.dart';
import 'package:nova_wallet/features/beneficiaries/repository/beneficiary_repository_impl.dart';
import 'package:nova_wallet/features/connectivity/cubit/connectivity_cubit.dart';

import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

void main() {
  late OutboxHarness h;
  late BeneficiaryRepositoryImpl repo;
  late ConnectivityCubit connectivity;

  setUp(() async {
    h = await OutboxHarness.open(directory: await newTempDir(), tag: 'ben');
    await h.signIn();
    repo = BeneficiaryRepositoryImpl(db: h.db, api: h.server.server, session: h.session);
    connectivity = ConnectivityCubit(
      reachability: Reachability(networkInfo: h.network, controls: h.server.controls),
      onlineDebounce: const Duration(milliseconds: 10),
    );
    await connectivity.start();
  });

  tearDown(() async {
    await connectivity.close();
    await h.close(deleteFromDisk: true);
  });

  test('refresh caches the four seeded beneficiaries for offline use', () async {
    expect((await repo.refresh()).isRight(), isTrue);
    final all = await repo.all();
    expect(all.length, 4);
    expect(all.map((b) => b.verifiedName), contains('ADAEZE OKAFOR'));

    // Cached names remain available with no network — this is what makes an
    // offline send to a saved recipient safe.
    h.server.controls.simulateOffline = true;
    expect((await repo.all()).length, 4);
  });

  test('name enquiry verifies online and saves the beneficiary', () async {
    final cubit = NameEnquiryCubit(repository: repo, connectivity: connectivity);
    cubit.selectBank(Banks.byCode('058')!);
    await cubit.accountNumberChanged('0248214821');
    expect(cubit.state.verified!.verifiedName, 'ADAEZE OKAFOR');

    final saved = await cubit.confirm();
    expect(saved.isRight(), isTrue);
    expect((await repo.all()).any((b) => b.accountNumber == '0248214821'), isTrue);
    await cubit.close();
  });

  test('an unknown account is rejected before anything is saved', () async {
    final cubit = NameEnquiryCubit(repository: repo, connectivity: connectivity);
    cubit.selectBank(Banks.byCode('058')!);
    await cubit.accountNumberChanged('0001112223');
    expect((cubit.state.failure! as BusinessFailure).code, BusinessCode.invalidAccount);
    expect(cubit.state.verified, isNull);
    await cubit.close();
  });

  test('offline, a new recipient cannot be verified and says so', () async {
    h.network.connected = false;
    await connectivity.recheck();
    final cubit = NameEnquiryCubit(repository: repo, connectivity: connectivity);
    cubit.selectBank(Banks.byCode('058')!);
    await cubit.accountNumberChanged('0248214821');
    expect((cubit.state.failure! as ValidationFailure).code, ValidationCode.offline);
    expect(cubit.state.isVerifying, isFalse);
    await cubit.close();
  });
}
```

- [ ] **Step 2: Run to see it fail.** Run: `flutter test test/features/beneficiaries` — compilation errors.

- [ ] **Step 3: Implement the repository**

`lib/features/beneficiaries/repository/beneficiary_repository.dart`
```dart
import 'package:dartz/dartz.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/beneficiary.dart';

/// Saved recipients with server-verified names, cached so an offline send has
/// a name it can trust (spec A2).
abstract class IBeneficiaryRepository {
  Stream<List<Beneficiary>> watchAll();
  Future<List<Beneficiary>> all();

  /// NIP-style name enquiry. Needs the network.
  Future<Either<Failure, Beneficiary>> verify({required String bankCode, required String accountNumber});

  Future<Either<Failure, Unit>> save(Beneficiary beneficiary);
  Future<void> touch(Beneficiary beneficiary);
  Future<Either<Failure, Unit>> refresh();
}
```

`lib/features/beneficiaries/repository/beneficiary_repository_impl.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:isar_community/isar.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/api/service/mappers.dart';
import '../../../core/api/service/nova_api_service.dart';
import '../../../core/models/beneficiary.dart';
import '../../../core/storage/entities/beneficiary_entity.dart';
import '../../../core/storage/isar_db.dart';
import '../../../core/storage/session_store.dart';
import 'beneficiary_repository.dart';

class BeneficiaryRepositoryImpl implements IBeneficiaryRepository {
  BeneficiaryRepositoryImpl({
    required this.db,
    required this.api,
    required this.session,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final IsarDb db;
  final NovaApiService api;
  final SessionStore session;
  final DateTime Function() _clock;

  Isar get _isar => db.client;

  Query<BeneficiaryEntity> get _query =>
      _isar.beneficiaryEntitys.where().sortByLastUsedAtDesc().thenByVerifiedName().build();

  @override
  Stream<List<Beneficiary>> watchAll() =>
      _query.watch(fireImmediately: true).map((rows) => rows.map((e) => e.toModel()).toList());

  @override
  Future<List<Beneficiary>> all() async => (await _query.findAll()).map((e) => e.toModel()).toList();

  @override
  Future<Either<Failure, Beneficiary>> verify({
    required String bankCode,
    required String accountNumber,
  }) async {
    final token = await session.readToken();
    if (token == null) {
      return left(const BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.'));
    }
    final result = await api.nameEnquiry(token: token, bankCode: bankCode, accountNumber: accountNumber);
    return result.fold(
      left,
      (dto) => right(Beneficiary(
        accountNumber: dto.accountNumber,
        bankCode: dto.bankCode,
        bankName: dto.bankName,
        verifiedName: dto.accountName,
      )),
    );
  }

  @override
  Future<Either<Failure, Unit>> save(Beneficiary beneficiary) async {
    try {
      await _isar.writeTxn(() => _isar.beneficiaryEntitys.put(BeneficiaryEntity()
        ..accountNumber = beneficiary.accountNumber
        ..bankCode = beneficiary.bankCode
        ..bankName = beneficiary.bankName
        ..verifiedName = beneficiary.verifiedName
        ..verifiedAt = _clock()
        ..lastUsedAt = beneficiary.lastUsedAt));
      return right(unit);
    } on IsarError catch (e) {
      return left(StorageFailure(e.message));
    }
  }

  @override
  Future<void> touch(Beneficiary beneficiary) => _isar.writeTxn(() async {
        final existing = await _isar.beneficiaryEntitys
            .getByAccountNumberBankCode(beneficiary.accountNumber, beneficiary.bankCode);
        if (existing == null) return;
        existing.lastUsedAt = _clock();
        await _isar.beneficiaryEntitys.put(existing);
      });

  @override
  Future<Either<Failure, Unit>> refresh() async {
    final token = await session.readToken();
    if (token == null) {
      return left(const BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.'));
    }
    final result = await api.getBeneficiaries(token: token);
    return result.fold(left, (rows) async {
      final now = _clock();
      await _isar.writeTxn(() async {
        for (final dto in rows) {
          final existing =
              await _isar.beneficiaryEntitys.getByAccountNumberBankCode(dto.accountNumber, dto.bankCode);
          final entity = beneficiaryEntityFromDto(dto, verifiedAt: now)..lastUsedAt = existing?.lastUsedAt;
          await _isar.beneficiaryEntitys.put(entity);
        }
      });
      return right(unit);
    });
  }
}
```

- [ ] **Step 4: Implement the cubits**

`lib/features/beneficiaries/cubit/beneficiaries_cubit.dart`
```dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/beneficiary.dart';
import '../repository/beneficiary_repository.dart';

/// Saved recipients, with a client-side search filter.
class BeneficiariesCubit extends Cubit<List<Beneficiary>> {
  BeneficiariesCubit({required this.repository}) : super(const []);

  final IBeneficiaryRepository repository;

  StreamSubscription<List<Beneficiary>>? _sub;
  String _query = '';

  List<Beneficiary> get visible {
    if (_query.isEmpty) return state;
    final needle = _query.toLowerCase();
    return state
        .where((b) =>
            b.verifiedName.toLowerCase().contains(needle) || b.accountNumber.contains(needle))
        .toList();
  }

  Future<void> start() async {
    if (_sub != null) return;
    _sub = repository.watchAll().listen((rows) {
      if (!isClosed) emit(rows);
    });
    await repository.refresh();
  }

  Future<void> refresh() => repository.refresh();

  void search(String query) {
    _query = query.trim();
    if (!isClosed) emit(List<Beneficiary>.from(state)); // re-emit so `visible` recomputes
  }

  Future<void> reset() async {
    await _sub?.cancel();
    _sub = null;
    _query = '';
    if (!isClosed) emit(const []);
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
```

`lib/features/beneficiaries/cubit/name_enquiry_state.dart`
```dart
import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/bank.dart';
import '../../../core/models/beneficiary.dart';

class NameEnquiryState extends Equatable {
  const NameEnquiryState({
    this.bank,
    this.accountNumber = '',
    this.isVerifying = false,
    this.verified,
    this.failure,
    this.saveBeneficiary = true,
  });

  final Bank? bank;
  final String accountNumber;
  final bool isVerifying;
  final Beneficiary? verified;
  final Failure? failure;
  final bool saveBeneficiary;

  bool get canVerify => bank != null && accountNumber.length == 10;

  NameEnquiryState copyWith({
    Bank? bank,
    String? accountNumber,
    bool? isVerifying,
    Beneficiary? verified,
    Failure? failure,
    bool? saveBeneficiary,
    bool clearVerified = false,
    bool clearFailure = false,
  }) =>
      NameEnquiryState(
        bank: bank ?? this.bank,
        accountNumber: accountNumber ?? this.accountNumber,
        isVerifying: isVerifying ?? this.isVerifying,
        verified: clearVerified ? null : (verified ?? this.verified),
        failure: clearFailure ? null : (failure ?? this.failure),
        saveBeneficiary: saveBeneficiary ?? this.saveBeneficiary,
      );

  @override
  List<Object?> get props => [bank, accountNumber, isVerifying, verified, failure, saveBeneficiary];
}
```

`lib/features/beneficiaries/cubit/name_enquiry_cubit.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/bank.dart';
import '../../../core/models/beneficiary.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../repository/beneficiary_repository.dart';
import 'name_enquiry_state.dart';

/// Adding a NEW recipient. Requires connectivity: without a verified name we
/// will not let a transfer be queued (spec A2).
class NameEnquiryCubit extends Cubit<NameEnquiryState> {
  NameEnquiryCubit({required this.repository, required this.connectivity})
      : super(const NameEnquiryState());

  final IBeneficiaryRepository repository;
  final ConnectivityCubit connectivity;

  static const _offline = ValidationFailure(
      ValidationCode.offline, 'Connect to the internet to add a new recipient.');

  void selectBank(Bank bank) =>
      emit(state.copyWith(bank: bank, clearVerified: true, clearFailure: true));

  void toggleSave(bool value) => emit(state.copyWith(saveBeneficiary: value));

  Future<void> accountNumberChanged(String value) async {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    emit(state.copyWith(accountNumber: digits, clearVerified: true, clearFailure: true));
    if (!state.canVerify) return;

    if (!connectivity.isOnline) {
      emit(state.copyWith(failure: _offline));
      return;
    }

    emit(state.copyWith(isVerifying: true));
    final result = await repository.verify(bankCode: state.bank!.code, accountNumber: digits);
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(isVerifying: false, failure: failure, clearVerified: true)),
      (beneficiary) => emit(state.copyWith(isVerifying: false, verified: beneficiary, clearFailure: true)),
    );
  }

  /// Saves the verified recipient (when the toggle is on) and returns it.
  Future<Either<Failure, Beneficiary>> confirm() async {
    final verified = state.verified;
    if (verified == null) {
      return left(const ValidationFailure(ValidationCode.invalidInput, 'Verify the account first.'));
    }
    if (!state.saveBeneficiary) return right(verified);
    final saved = await repository.save(verified);
    return saved.fold(left, (_) => right(verified));
  }
}
```

- [ ] **Step 5: Run the tests.** Run: `flutter test test/features/beneficiaries` — all PASS.

- [ ] **Step 6: Checkpoint.** Report the files for the user to commit.

---

### Task 14: NovaSave (goals, create, contribute)

**Files:**
- Create: `lib/features/sync/cubit/outcome_watcher.dart`
- Create: `lib/features/savings/repository/savings_repository.dart`, `savings_repository_impl.dart`
- Create: `lib/features/savings/cubit/savings_cubit.dart`, `create_goal_state.dart`, `create_goal_cubit.dart`, `contribute_state.dart`, `contribute_cubit.dart`
- Test: `test/features/savings/savings_test.dart`

**Interfaces:**
- Consumes: `IOutboxRepository`, `SyncCubit`, `ConnectivityCubit`, `WalletCubit`, `IAuthRepository`, `GoalView`, `KoboParser`, `Progress`, `AppConstants`
- Produces:
  - `mixin OutboxOutcomeWatcher { Future<OutboxItem> awaitOutcome({required IOutboxRepository outbox, required int id, required Duration timeout}); }`
  - `abstract class ISavingsRepository { Stream<List<GoalView>> watchGoals(); Stream<GoalView?> watchGoal(String clientId); Stream<List<ActivityItem>> watchContributions(String clientId); Future<Either<Failure, Unit>> refresh(); }`
  - `class SavingsCubit extends Cubit<List<GoalView>> { SavingsCubit({required ISavingsRepository repository}); Future<void> start(); Future<void> refresh(); Future<void> reset(); }`
  - `class CreateGoalState { String name; String targetText; DateTime? targetDate; bool isSubmitting; Failure? failure; OutboxItem? created; int? suggestedWeeklyKobo; }`
  - `class CreateGoalCubit extends Cubit<CreateGoalState> { CreateGoalCubit({required IOutboxRepository outbox, required SyncCubit sync, required ConnectivityCubit connectivity, Uuid? uuid, DateTime Function()? clock}); void nameChanged(String v); void targetChanged(String v); void dateChanged(DateTime v); Future<void> submit(); }`
  - `enum ContributeStage { editing, submitting, done }`, `enum ContributeOutcome { saved, pending, processing, failed }`
  - `class ContributeState { ContributeStage stage; String amountText; int? amountKobo; Failure? validation; bool pinError; OutboxItem? item; ContributeOutcome? outcome; }`
  - `class ContributeCubit extends Cubit<ContributeState> { ContributeCubit({required GoalView goal, required IOutboxRepository outbox, required IAuthRepository auth, required WalletCubit wallet, required SyncCubit sync, required ConnectivityCubit connectivity, Duration outcomeWait}); void amountChanged(String v); Future<void> submit(String pin); }`

- [ ] **Step 1: Write the failing test** `test/features/savings/savings_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/models/goal_view.dart';
import 'package:nova_wallet/core/network/reachability.dart';
import 'package:nova_wallet/features/connectivity/cubit/connectivity_cubit.dart';
import 'package:nova_wallet/features/savings/cubit/contribute_cubit.dart';
import 'package:nova_wallet/features/savings/cubit/contribute_state.dart';
import 'package:nova_wallet/features/savings/cubit/create_goal_cubit.dart';
import 'package:nova_wallet/features/savings/repository/savings_repository_impl.dart';
import 'package:nova_wallet/features/sync/cubit/sync_cubit.dart';
import 'package:nova_wallet/features/wallet/cubit/wallet_cubit.dart';
import 'package:nova_wallet/features/wallet/repository/wallet_repository_impl.dart';

import '../../support/fake_sync_notifier.dart';
import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

void main() {
  late OutboxHarness h;
  late ConnectivityCubit connectivity;
  late SyncCubit sync;
  late SavingsRepositoryImpl savings;
  late WalletCubit wallet;

  setUp(() async {
    h = await OutboxHarness.open(directory: await newTempDir(), tag: 'savings');
    await h.signIn();
    connectivity = ConnectivityCubit(
      reachability: Reachability(networkInfo: h.network, controls: h.server.controls),
      onlineDebounce: const Duration(milliseconds: 10),
    );
    await connectivity.start();
    sync = SyncCubit(
        outbox: h.outbox,
        connectivity: connectivity,
        notifier: FakeSyncNotifier(),
        backoff: (_) => const Duration(milliseconds: 20));
    savings = SavingsRepositoryImpl(db: h.db, api: h.server.server, session: h.session);
    wallet = WalletCubit(
      repository: WalletRepositoryImpl(db: h.db, api: h.server.server, session: h.session),
      sync: sync,
    );
    await wallet.start();
    await sync.start();
  });

  tearDown(() async {
    await wallet.close();
    await sync.close();
    await connectivity.close();
    await h.close(deleteFromDisk: true);
  });

  test('refresh brings the seeded goal down with 35% progress', () async {
    expect((await savings.refresh()).isRight(), isTrue);
    final goals = await savings.watchGoals().first;
    expect(goals.single.name, 'Rent — December');
    expect(goals.single.savedBps, 3500);
    expect(goals.single.syncState, GoalSyncState.synced);
  });

  test('a goal created offline appears immediately as pending, then syncs', () async {
    h.network.connected = false;
    await connectivity.recheck();
    final create = CreateGoalCubit(outbox: h.outbox, sync: sync, connectivity: connectivity);
    create.nameChanged('Laptop');
    create.targetChanged('800,000');
    create.dateChanged(DateTime(2027, 3, 1));
    await create.submit();
    expect(create.state.failure, isNull);

    var goals = await savings.watchGoals().first;
    final created = goals.firstWhere((g) => g.name == 'Laptop');
    expect(created.syncState, GoalSyncState.pending);
    expect(created.targetKobo, 80000000);

    h.network.connected = true;
    await Future<void>.delayed(const Duration(milliseconds: 60));
    await sync.drain();

    goals = await savings.watchGoals().first;
    expect(goals.firstWhere((g) => g.name == 'Laptop').syncState, GoalSyncState.synced);
    await create.close();
  });

  test('create goal validation: name, target floor and a future date', () async {
    final create = CreateGoalCubit(outbox: h.outbox, sync: sync, connectivity: connectivity);
    await create.submit();
    expect((create.state.failure! as ValidationFailure).code, ValidationCode.invalidInput);

    create.nameChanged('Laptop');
    create.targetChanged('500');
    create.dateChanged(DateTime(2027, 3, 1));
    await create.submit();
    expect((create.state.failure! as ValidationFailure).code, ValidationCode.amountTooSmall);
    await create.close();
  });

  test('a contribution queued offline shows as pending progress, not saved progress', () async {
    await savings.refresh();
    final goal = (await savings.watchGoals().first).single;
    h.network.connected = false;
    await connectivity.recheck();

    final contribute = ContributeCubit(
      goal: goal,
      outbox: h.outbox,
      auth: h.authRepository,
      wallet: wallet,
      sync: sync,
      connectivity: connectivity,
      outcomeWait: const Duration(milliseconds: 100),
    );
    contribute.amountChanged('5,000');
    await contribute.submit(AppConstants.demoPin);

    expect(contribute.state.outcome, ContributeOutcome.pending);
    final pending = (await savings.watchGoals().first).single;
    expect(pending.savedKobo, 21000000);
    expect(pending.pendingKobo, 500000);
    expect(pending.projectedBps, 3583);

    h.network.connected = true;
    await Future<void>.delayed(const Duration(milliseconds: 60));
    await sync.drain();

    final synced = (await savings.watchGoals().first).single;
    expect(synced.savedKobo, 21500000);
    expect(synced.pendingKobo, 0);
    await contribute.close();
  });

  test('the wrong PIN never queues anything', () async {
    await savings.refresh();
    final goal = (await savings.watchGoals().first).single;
    final contribute = ContributeCubit(
      goal: goal,
      outbox: h.outbox,
      auth: h.authRepository,
      wallet: wallet,
      sync: sync,
      connectivity: connectivity,
      outcomeWait: const Duration(milliseconds: 100),
    );
    contribute.amountChanged('5,000');
    await contribute.submit('9999');
    expect(contribute.state.pinError, isTrue);
    expect(await h.outbox.activeItems(), isEmpty);
    await contribute.close();
  });
}
```

(`h.authRepository` and the PIN-carrying `signIn()` come from the harness built in Task 10.)

- [ ] **Step 2: Run to see it fail.** Run: `flutter test test/features/savings` — compilation errors.

- [ ] **Step 3: Implement the outcome watcher** `lib/features/sync/cubit/outcome_watcher.dart`

```dart
import 'dart:async';

import '../../../core/models/outbox_item.dart';
import '../repository/outbox_repository.dart';

/// Waits for a queued item to settle, so a screen can show Sent/Failed rather
/// than a spinner that never resolves. On timeout it returns the item as it
/// stands — still queued means "Pending", which is a truthful answer.
mixin OutboxOutcomeWatcher {
  Future<OutboxItem> awaitOutcome({
    required IOutboxRepository outbox,
    required int id,
    required Duration timeout,
  }) async {
    try {
      return await outbox
          .watchItem(id)
          .where((item) => item != null && item.isTerminal)
          .map((item) => item!)
          .first
          .timeout(timeout);
    } on TimeoutException {
      return (await outbox.byId(id))!;
    }
  }
}
```

- [ ] **Step 4: Implement the savings repository**

`lib/features/savings/repository/savings_repository.dart`
```dart
import 'package:dartz/dartz.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/activity_item.dart';
import '../../../core/models/goal_view.dart';

abstract class ISavingsRepository {
  /// Goals with confirmed and pending amounts kept separate, so the bar can
  /// show "saved" and "on the way" as different segments.
  Stream<List<GoalView>> watchGoals();
  Stream<GoalView?> watchGoal(String clientId);
  Stream<List<ActivityItem>> watchContributions(String clientId);
  Future<Either<Failure, Unit>> refresh();
}
```

`lib/features/savings/repository/savings_repository_impl.dart`
```dart
import 'package:dartz/dartz.dart';
import 'package:isar_community/isar.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/api/service/mappers.dart';
import '../../../core/api/service/nova_api_service.dart';
import '../../../core/models/activity_item.dart';
import '../../../core/models/goal_view.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/storage/entities/goal_entity.dart';
import '../../../core/storage/entities/outbox_item_entity.dart';
import '../../../core/storage/entities/transaction_entity.dart';
import '../../../core/storage/isar_db.dart';
import '../../../core/storage/session_store.dart';
import '../../../core/utils/streams.dart';
import 'savings_repository.dart';

class SavingsRepositoryImpl implements ISavingsRepository {
  SavingsRepositoryImpl({required this.db, required this.api, required this.session});

  final IsarDb db;
  final NovaApiService api;
  final SessionStore session;

  Isar get _isar => db.client;

  Query<OutboxItemEntity> get _activeContributions => _isar.outboxItemEntitys
      .filter()
      .typeEqualTo(OutboxType.contribute)
      .and()
      .group((q) => q.statusEqualTo(OutboxStatus.queued).or().statusEqualTo(OutboxStatus.sending))
      .build();

  int _pendingFor(String clientId, List<OutboxItemEntity> items) => items
      .where((i) => i.goalClientId == clientId)
      .fold<int>(0, (sum, i) => sum + i.amountKobo);

  @override
  Stream<List<GoalView>> watchGoals() => combineLatest2(
        _isar.goalEntitys.where().sortByCreatedAtDesc().watch(fireImmediately: true),
        _activeContributions.watch(fireImmediately: true),
        (List<GoalEntity> goals, List<OutboxItemEntity> pending) => [
          for (final goal in goals) goal.toView(pendingKobo: _pendingFor(goal.clientId, pending)),
        ],
      );

  @override
  Stream<GoalView?> watchGoal(String clientId) => watchGoals().map((goals) {
        for (final goal in goals) {
          if (goal.clientId == clientId) return goal;
        }
        return null;
      });

  @override
  Stream<List<ActivityItem>> watchContributions(String clientId) => combineLatest2(
        _isar.outboxItemEntitys
            .filter()
            .goalClientIdEqualTo(clientId)
            .and()
            .group((q) => q
                .statusEqualTo(OutboxStatus.queued)
                .or()
                .statusEqualTo(OutboxStatus.sending)
                .or()
                .statusEqualTo(OutboxStatus.failed))
            .sortByCreatedAtDesc()
            .watch(fireImmediately: true),
        _isar.transactionEntitys
            .filter()
            .goalClientIdEqualTo(clientId)
            .sortByCreatedAtDesc()
            .watch(fireImmediately: true),
        (List<OutboxItemEntity> pending, List<TransactionEntity> settled) => [
          for (final item in pending)
            ActivityItem(
              id: 'outbox:${item.id}',
              status: switch (item.status) {
                OutboxStatus.sending => ActivityStatus.sending,
                OutboxStatus.failed => ActivityStatus.failed,
                _ => ActivityStatus.pending,
              },
              kind: ActivityKind.contribution,
              direction: ActivityDirection.debit,
              amountKobo: item.amountKobo,
              title: item.counterpartyName ?? 'NovaSave',
              createdAt: item.createdAt,
              outboxId: item.id,
              failureMessage: item.failureMessage,
              goalClientId: item.goalClientId,
            ),
          for (final txn in settled) txn.toActivity(),
        ],
      );

  @override
  Future<Either<Failure, Unit>> refresh() async {
    final token = await session.readToken();
    if (token == null) {
      return left(const BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.'));
    }
    final result = await api.getGoals(token: token);
    return result.fold(left, (goals) async {
      await _isar.writeTxn(() async {
        await _isar.goalEntitys.putAll(goals.map(goalEntityFromDto).toList());
      });
      return right(unit);
    });
  }
}
```

- [ ] **Step 5: Implement SavingsCubit**

`lib/features/savings/cubit/savings_cubit.dart`
```dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/goal_view.dart';
import '../repository/savings_repository.dart';

class SavingsCubit extends Cubit<List<GoalView>> {
  SavingsCubit({required this.repository}) : super(const []);

  final ISavingsRepository repository;
  StreamSubscription<List<GoalView>>? _sub;

  Future<void> start() async {
    if (_sub != null) return;
    _sub = repository.watchGoals().listen((goals) {
      if (!isClosed) emit(goals);
    });
    await repository.refresh();
  }

  Future<void> refresh() => repository.refresh();

  Future<void> reset() async {
    await _sub?.cancel();
    _sub = null;
    if (!isClosed) emit(const []);
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
```

- [ ] **Step 6: Implement CreateGoalCubit**

`lib/features/savings/cubit/create_goal_state.dart`
```dart
import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/outbox_item.dart';

class CreateGoalState extends Equatable {
  const CreateGoalState({
    this.name = '',
    this.targetText = '',
    this.targetDate,
    this.isSubmitting = false,
    this.failure,
    this.created,
    this.suggestedWeeklyKobo,
  });

  final String name;
  final String targetText;
  final DateTime? targetDate;
  final bool isSubmitting;
  final Failure? failure;
  final OutboxItem? created;

  /// "Save about ₦X a week to reach this by …" — whole kobo, rounded up.
  final int? suggestedWeeklyKobo;

  CreateGoalState copyWith({
    String? name,
    String? targetText,
    DateTime? targetDate,
    bool? isSubmitting,
    Failure? failure,
    OutboxItem? created,
    int? suggestedWeeklyKobo,
    bool clearFailure = false,
  }) =>
      CreateGoalState(
        name: name ?? this.name,
        targetText: targetText ?? this.targetText,
        targetDate: targetDate ?? this.targetDate,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        failure: clearFailure ? null : (failure ?? this.failure),
        created: created ?? this.created,
        suggestedWeeklyKobo: suggestedWeeklyKobo ?? this.suggestedWeeklyKobo,
      );

  @override
  List<Object?> get props =>
      [name, targetText, targetDate, isSubmitting, failure, created, suggestedWeeklyKobo];
}
```

`lib/features/savings/cubit/create_goal_cubit.dart`
```dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/money/kobo_parser.dart';
import '../../../core/money/progress.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../sync/cubit/sync_cubit.dart';
import '../../sync/repository/outbox_repository.dart';
import 'create_goal_state.dart';

class CreateGoalCubit extends Cubit<CreateGoalState> {
  CreateGoalCubit({
    required this.outbox,
    required this.sync,
    required this.connectivity,
    Uuid? uuid,
    DateTime Function()? clock,
  })  : _uuid = uuid ?? const Uuid(),
        _clock = clock ?? DateTime.now,
        super(const CreateGoalState());

  final IOutboxRepository outbox;
  final SyncCubit sync;
  final ConnectivityCubit connectivity;
  final Uuid _uuid;
  final DateTime Function() _clock;

  void nameChanged(String value) => emit(state.copyWith(name: value, clearFailure: true));

  void targetChanged(String value) {
    emit(state.copyWith(targetText: value, clearFailure: true));
    _recomputeSuggestion();
  }

  void dateChanged(DateTime value) {
    emit(state.copyWith(targetDate: value, clearFailure: true));
    _recomputeSuggestion();
  }

  void _recomputeSuggestion() {
    final target = KoboParser.parse(state.targetText).fold((_) => null, (kobo) => kobo);
    final date = state.targetDate;
    if (target == null || date == null) return;
    emit(state.copyWith(
      suggestedWeeklyKobo:
          Progress.suggestedWeeklyKobo(remainingKobo: target, from: _clock(), targetDate: date),
    ));
  }

  Future<void> submit() async {
    if (state.isSubmitting) return;

    final name = state.name.trim();
    if (name.isEmpty || name.length > 40) {
      emit(state.copyWith(
          failure: const ValidationFailure(ValidationCode.invalidInput, 'Give your goal a short name.')));
      return;
    }
    final parsed = KoboParser.parse(state.targetText);
    final target = parsed.fold((_) => null, (kobo) => kobo);
    if (target == null) {
      emit(state.copyWith(
          failure: const ValidationFailure(ValidationCode.invalidInput, 'Enter a valid target amount.')));
      return;
    }
    if (target < AppConstants.minGoalTargetKobo) {
      emit(state.copyWith(
          failure: const ValidationFailure(ValidationCode.amountTooSmall, 'The smallest goal is ₦1,000.00.')));
      return;
    }
    final date = state.targetDate;
    final today = _clock();
    if (date == null || !date.isAfter(DateTime(today.year, today.month, today.day))) {
      emit(state.copyWith(
          failure: const ValidationFailure(ValidationCode.invalidInput, 'Pick a date in the future.')));
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearFailure: true));
    // Queued like any other action, so creating a goal works offline too.
    final result = await outbox.enqueueCreateGoal(
      draft: CreateGoalDraft(
        clientId: _uuid.v4(),
        name: name,
        targetKobo: target,
        targetDate: date,
      ),
      online: connectivity.isOnline,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(isSubmitting: false, failure: failure)),
      (item) {
        emit(state.copyWith(isSubmitting: false, created: item, clearFailure: true));
        unawaited(sync.drain());
      },
    );
  }
}
```

- [ ] **Step 7: Implement ContributeCubit**

`lib/features/savings/cubit/contribute_state.dart`
```dart
import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/outbox_item.dart';

enum ContributeStage { editing, submitting, done }

enum ContributeOutcome { saved, pending, processing, failed }

class ContributeState extends Equatable {
  const ContributeState({
    this.stage = ContributeStage.editing,
    this.amountText = '',
    this.amountKobo,
    this.validation,
    this.pinError = false,
    this.item,
    this.outcome,
  });

  final ContributeStage stage;
  final String amountText;
  final int? amountKobo;
  final Failure? validation;
  final bool pinError;
  final OutboxItem? item;
  final ContributeOutcome? outcome;

  bool get canSubmit => amountKobo != null && validation == null;

  ContributeState copyWith({
    ContributeStage? stage,
    String? amountText,
    int? amountKobo,
    Failure? validation,
    bool? pinError,
    OutboxItem? item,
    ContributeOutcome? outcome,
    bool clearAmount = false,
    bool clearValidation = false,
  }) =>
      ContributeState(
        stage: stage ?? this.stage,
        amountText: amountText ?? this.amountText,
        amountKobo: clearAmount ? null : (amountKobo ?? this.amountKobo),
        validation: clearValidation ? null : (validation ?? this.validation),
        pinError: pinError ?? this.pinError,
        item: item ?? this.item,
        outcome: outcome ?? this.outcome,
      );

  @override
  List<Object?> get props => [stage, amountText, amountKobo, validation, pinError, item, outcome];
}
```

`lib/features/savings/cubit/contribute_cubit.dart`
```dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/models/goal_view.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/money/kobo_parser.dart';
import '../../auth/repository/auth_repository.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../sync/cubit/outcome_watcher.dart';
import '../../sync/cubit/sync_cubit.dart';
import '../../sync/repository/outbox_repository.dart';
import '../../wallet/cubit/wallet_cubit.dart';
import 'contribute_state.dart';

/// One contribution attempt (registered as a factory).
class ContributeCubit extends Cubit<ContributeState> with OutboxOutcomeWatcher {
  ContributeCubit({
    required this.goal,
    required this.outbox,
    required this.auth,
    required this.wallet,
    required this.sync,
    required this.connectivity,
    this.outcomeWait = AppConstants.sendOutcomeWait,
  }) : super(const ContributeState());

  final GoalView goal;
  final IOutboxRepository outbox;
  final IAuthRepository auth;
  final WalletCubit wallet;
  final SyncCubit sync;
  final ConnectivityCubit connectivity;
  final Duration outcomeWait;

  StreamSubscription<OutboxItem?>? _itemSub;

  void amountChanged(String value) {
    final parsed = KoboParser.parse(value);
    parsed.fold(
      (error) => emit(state.copyWith(
        amountText: value,
        clearAmount: true,
        validation: error == KoboParseError.empty
            ? null
            : const ValidationFailure(ValidationCode.invalidInput, 'Enter a valid amount.'),
        clearValidation: error == KoboParseError.empty,
      )),
      (kobo) {
        if (kobo < AppConstants.minContributionKobo) {
          emit(state.copyWith(
            amountText: value,
            amountKobo: kobo,
            validation:
                const ValidationFailure(ValidationCode.amountTooSmall, 'The smallest contribution is ₦100.00.'),
          ));
          return;
        }
        if (kobo > wallet.availableKobo) {
          emit(state.copyWith(
            amountText: value,
            amountKobo: kobo,
            validation: const ValidationFailure(
                ValidationCode.insufficientAvailable, 'This is more than your available balance.'),
          ));
          return;
        }
        emit(state.copyWith(amountText: value, amountKobo: kobo, clearValidation: true));
      },
    );
  }

  Future<void> submit(String pin) async {
    if (!state.canSubmit || state.stage == ContributeStage.submitting) return;

    if (!await auth.verifyPin(pin)) {
      emit(state.copyWith(pinError: true));
      return;
    }
    emit(state.copyWith(stage: ContributeStage.submitting, pinError: false));

    final result = await outbox.enqueueContribute(
      draft: ContributeDraft(
        goalClientId: goal.clientId,
        goalName: goal.name,
        amountKobo: state.amountKobo!,
      ),
      online: connectivity.isOnline,
    );
    if (isClosed) return;

    await result.fold(
      (failure) async =>
          emit(state.copyWith(stage: ContributeStage.editing, validation: failure)),
      (item) async {
        emit(state.copyWith(item: item));
        if (!connectivity.isOnline) {
          // Queued: the sync engine will send it when the network returns.
          unawaited(sync.drain());
          _finish(item, ContributeOutcome.pending);
          return;
        }
        unawaited(sync.drain());
        final settled = await awaitOutcome(outbox: outbox, id: item.id, timeout: outcomeWait);
        if (isClosed) return;
        _finish(settled, _outcomeFor(settled));
      },
    );
  }

  ContributeOutcome _outcomeFor(OutboxItem item) => switch (item.status) {
        OutboxStatus.succeeded => ContributeOutcome.saved,
        OutboxStatus.failed => ContributeOutcome.failed,
        _ => connectivity.isOnline ? ContributeOutcome.processing : ContributeOutcome.pending,
      };

  void _finish(OutboxItem item, ContributeOutcome outcome) {
    emit(state.copyWith(stage: ContributeStage.done, item: item, outcome: outcome));
    // Keep the result screen honest if the item settles while it is open.
    _itemSub = outbox.watchItem(item.id).listen((latest) {
      if (latest == null || isClosed) return;
      emit(state.copyWith(item: latest, outcome: _outcomeFor(latest)));
    });
  }

  @override
  Future<void> close() async {
    await _itemSub?.cancel();
    return super.close();
  }
}
```

- [ ] **Step 8: Run the tests.** Run: `flutter test test/features/savings` — all PASS.

- [ ] **Step 9: Checkpoint.** Report the files for the user to commit.

---

### Task 15: SendMoneyCubit (recipient → amount → review → authorise → result)

**Files:**
- Create: `lib/features/send_money/cubit/send_money_state.dart`, `send_money_cubit.dart`
- Test: `test/features/send_money/send_money_cubit_test.dart`

**Interfaces:**
- Consumes: `IOutboxRepository`, `IAuthRepository`, `ISettingsRepository`, `IBeneficiaryRepository`, `AuthCubit`, `WalletCubit`, `SyncCubit`, `ConnectivityCubit`, `BiometricGate`, `Fees`, `KoboParser`, `AppConstants`, `OutboxOutcomeWatcher`
- Produces:
  - `enum SendStage { recipient, amount, review, submitting, result }`
  - `enum SendOutcome { sent, pending, processing, failed }`
  - `class SendMoneyState { SendStage stage; Beneficiary? recipient; String amountText; int? amountKobo; int feeKobo; String narration; Failure? amountError; bool requiresBiometric; bool needsPinFallback; bool pinError; OutboxItem? item; SendOutcome? outcome; Failure? submitFailure; int get debitKobo; bool get canContinue; }`
  - `class SendMoneyCubit extends Cubit<SendMoneyState> { SendMoneyCubit({required IOutboxRepository outbox, required IAuthRepository auth, required ISettingsRepository settings, required IBeneficiaryRepository beneficiaries, required AuthCubit session, required WalletCubit wallet, required SyncCubit sync, required ConnectivityCubit connectivity, required BiometricGate biometricGate, Duration outcomeWait}); void selectRecipient(Beneficiary b); void amountChanged(String v); void narrationChanged(String v); Future<void> continueToReview(); void backToAmount(); Future<void> authoriseWithPin(String pin); Future<void> authoriseWithBiometric(); void retry(); }`

- [ ] **Step 1: Write the failing test** `test/features/send_money/send_money_cubit_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/exception/failure.dart';
import 'package:nova_wallet/core/auth/biometric_signer.dart';
import 'package:nova_wallet/core/models/beneficiary.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/models/profile.dart';
import 'package:nova_wallet/core/network/reachability.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/features/auth/cubit/auth_cubit.dart';
import 'package:nova_wallet/features/beneficiaries/repository/beneficiary_repository_impl.dart';
import 'package:nova_wallet/features/connectivity/cubit/connectivity_cubit.dart';
import 'package:nova_wallet/features/send_money/cubit/send_money_cubit.dart';
import 'package:nova_wallet/features/send_money/cubit/send_money_state.dart';
import 'package:nova_wallet/features/settings/repository/settings_repository_impl.dart';
import 'package:nova_wallet/features/sync/cubit/sync_cubit.dart';
import 'package:nova_wallet/features/wallet/cubit/wallet_cubit.dart';
import 'package:nova_wallet/features/wallet/repository/wallet_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/fake_biometric_gate.dart';
import '../../support/fake_sync_notifier.dart';
import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

const ada = Beneficiary(
    accountNumber: '0248214821', bankCode: '058', bankName: 'GTBank', verifiedName: 'ADAEZE OKAFOR');
const nobody = Beneficiary(
    accountNumber: '0001112223', bankCode: '058', bankName: 'GTBank', verifiedName: 'NO ONE');

void main() {
  late OutboxHarness h;
  late ConnectivityCubit connectivity;
  late SyncCubit sync;
  late WalletCubit wallet;
  late AuthCubit session;
  late SettingsRepositoryImpl settings;
  late FakeBiometricGate gate;
  late SendMoneyCubit cubit;

  SendMoneyCubit build() => SendMoneyCubit(
        outbox: h.outbox,
        auth: h.authRepository,
        settings: settings,
        beneficiaries: BeneficiaryRepositoryImpl(db: h.db, api: h.server.server, session: h.session),
        session: session,
        wallet: wallet,
        sync: sync,
        connectivity: connectivity,
        biometricGate: gate,
        outcomeWait: const Duration(seconds: 2),
      );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    h = await OutboxHarness.open(directory: await newTempDir(), tag: 'send');
    await h.signIn();
    connectivity = ConnectivityCubit(
      reachability: Reachability(networkInfo: h.network, controls: h.server.controls),
      onlineDebounce: const Duration(milliseconds: 10),
    );
    await connectivity.start();
    sync = SyncCubit(
        outbox: h.outbox,
        connectivity: connectivity,
        notifier: FakeSyncNotifier(),
        backoff: (_) => const Duration(milliseconds: 20));
    await sync.start();
    wallet = WalletCubit(
      repository: WalletRepositoryImpl(db: h.db, api: h.server.server, session: h.session),
      sync: sync,
    );
    await wallet.start();
    settings = SettingsRepositoryImpl(
        localStorage: LocalStorageImpl(prefs: await SharedPreferences.getInstance()));
    session = AuthCubit(repository: h.authRepository, settings: settings);
    session.sessionStarted((await h.authRepository.cachedProfile())!);
    gate = FakeBiometricGate();
    cubit = build();
  });

  tearDown(() async {
    await cubit.close();
    await session.close();
    await wallet.close();
    await sync.close();
    await connectivity.close();
    await h.close(deleteFromDisk: true);
  });

  group('amount validation', () {
    test('below the ₦100.00 minimum', () {
      cubit.selectRecipient(ada);
      cubit.amountChanged('50');
      expect((cubit.state.amountError! as ValidationFailure).code, ValidationCode.amountTooSmall);
    });

    test('above the tier cap', () {
      const tierOne = Profile(
          fullName: 'Tolu Adebayo', phone: AppConstants.demoPhone, email: 't@x.com',
          tier: 1, bvnVerified: false, accountNumber: '8012345678');
      session.sessionStarted(tierOne);
      cubit.selectRecipient(ada);
      cubit.amountChanged('150,000');
      expect((cubit.state.amountError! as ValidationFailure).code, ValidationCode.tierLimitExceeded);
    });

    test('above the available balance, and the fee is included', () {
      cubit.selectRecipient(ada);
      cubit.amountChanged('250,000');
      expect(cubit.state.feeKobo, 5375);
      expect(cubit.state.debitKobo, 25005375);
      expect((cubit.state.amountError! as ValidationFailure).code, ValidationCode.insufficientAvailable);
    });

    test('a valid amount computes the band fee and clears errors', () {
      cubit.selectRecipient(ada);
      cubit.amountChanged('25,000');
      expect(cubit.state.amountKobo, 2500000);
      expect(cubit.state.feeKobo, 2688);
      expect(cubit.state.amountError, isNull);
      expect(cubit.state.canContinue, isTrue);
    });
  });

  test('online send: PIN authorises, item settles as Sent and debits once', () async {
    cubit.selectRecipient(ada);
    cubit.amountChanged('25,000');
    await cubit.continueToReview();
    expect(cubit.state.stage, SendStage.review);
    expect(cubit.state.requiresBiometric, isFalse);

    await cubit.authoriseWithPin(AppConstants.demoPin);

    expect(cubit.state.outcome, SendOutcome.sent);
    expect(cubit.state.item!.status, OutboxStatus.succeeded);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688);
    expect(await h.db.server.processedRequests.count(), 1);
  });

  test('the wrong PIN queues nothing', () async {
    cubit.selectRecipient(ada);
    cubit.amountChanged('25,000');
    await cubit.continueToReview();
    await cubit.authoriseWithPin('9999');

    expect(cubit.state.pinError, isTrue);
    expect(cubit.state.stage, SendStage.review);
    expect(await h.outbox.activeItems(), isEmpty);
  });

  test('OFFLINE send: outcome is Pending, and it flips to Sent when sync runs', () async {
    h.network.connected = false;
    await connectivity.recheck();

    cubit.selectRecipient(ada);
    cubit.amountChanged('25,000');
    await cubit.continueToReview();
    await cubit.authoriseWithPin(AppConstants.demoPin);

    expect(cubit.state.outcome, SendOutcome.pending);
    expect(cubit.state.item!.status, OutboxStatus.queued);
    expect(cubit.state.item!.queuedWhileOffline, isTrue);
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo);

    h.network.connected = true;
    await Future<void>.delayed(const Duration(milliseconds: 60));
    await sync.drain();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(cubit.state.outcome, SendOutcome.sent, reason: 'the open result screen updates itself');
    expect(await h.server.balanceOf(AppConstants.demoPhone), AppConstants.demoOpeningBalanceKobo - 2502688);
  });

  test('a send at or above ₦50,000.00 requires biometrics and signs the amount', () async {
    await settings.setBiometricEnabled(true);
    cubit.selectRecipient(ada);
    cubit.amountChanged('50,000');
    await cubit.continueToReview();
    expect(cubit.state.requiresBiometric, isTrue);

    await cubit.authoriseWithBiometric();

    expect(gate.confirmCalls, 1);
    expect(gate.lastPayload, contains('5002688'));
    expect(cubit.state.outcome, SendOutcome.sent);
    expect(cubit.state.item!.biometricSignature, 'fake-signature');
  });

  test('when biometrics are unavailable the flow falls back to PIN', () async {
    await settings.setBiometricEnabled(true);
    gate.available = false;
    cubit.selectRecipient(ada);
    cubit.amountChanged('50,000');
    await cubit.continueToReview();
    expect(cubit.state.requiresBiometric, isFalse, reason: 'no hardware, so PIN it is');

    gate.available = true;
    gate.nextError = BiometricSignerError.keyMissing;
    await cubit.continueToReview();
    await cubit.authoriseWithBiometric();
    expect(cubit.state.needsPinFallback, isTrue);
    expect(await h.outbox.activeItems(), isEmpty);
  });

  test('a rejected send shows Failed, and Try again uses a NEW key', () async {
    cubit.selectRecipient(nobody);
    cubit.amountChanged('5,000');
    await cubit.continueToReview();
    await cubit.authoriseWithPin(AppConstants.demoPin);

    expect(cubit.state.outcome, SendOutcome.failed);
    final firstKey = cubit.state.item!.idempotencyKey;

    cubit.retry();
    expect(cubit.state.stage, SendStage.review);
    await cubit.authoriseWithPin(AppConstants.demoPin);
    expect(cubit.state.item!.idempotencyKey, isNot(firstKey));
  });
}
```

- [ ] **Step 2: Run to see it fail.** Run: `flutter test test/features/send_money` — compilation errors.

- [ ] **Step 3: Implement the state** `lib/features/send_money/cubit/send_money_state.dart`

```dart
import 'package:equatable/equatable.dart';

import '../../../core/api/exception/failure.dart';
import '../../../core/models/beneficiary.dart';
import '../../../core/models/outbox_item.dart';

enum SendStage { recipient, amount, review, submitting, result }

enum SendOutcome {
  /// Confirmed by the server while the user waited.
  sent,

  /// Queued because the device is offline.
  pending,

  /// Online but still in flight when the wait elapsed.
  processing,

  /// The server rejected it.
  failed,
}

class SendMoneyState extends Equatable {
  const SendMoneyState({
    this.stage = SendStage.recipient,
    this.recipient,
    this.amountText = '',
    this.amountKobo,
    this.feeKobo = 0,
    this.narration = '',
    this.amountError,
    this.requiresBiometric = false,
    this.needsPinFallback = false,
    this.pinError = false,
    this.item,
    this.outcome,
    this.submitFailure,
  });

  final SendStage stage;
  final Beneficiary? recipient;
  final String amountText;
  final int? amountKobo;
  final int feeKobo;
  final String narration;
  final Failure? amountError;

  /// Amount ≥ ₦50,000.00 AND biometrics enabled and usable.
  final bool requiresBiometric;

  /// The biometric attempt could not run; show the PIN sheet instead.
  final bool needsPinFallback;
  final bool pinError;
  final OutboxItem? item;
  final SendOutcome? outcome;
  final Failure? submitFailure;

  int get debitKobo => (amountKobo ?? 0) + feeKobo;
  bool get canContinue => amountKobo != null && amountError == null && recipient != null;

  SendMoneyState copyWith({
    SendStage? stage,
    Beneficiary? recipient,
    String? amountText,
    int? amountKobo,
    int? feeKobo,
    String? narration,
    Failure? amountError,
    bool? requiresBiometric,
    bool? needsPinFallback,
    bool? pinError,
    OutboxItem? item,
    SendOutcome? outcome,
    Failure? submitFailure,
    bool clearAmount = false,
    bool clearAmountError = false,
    bool clearItem = false,
    bool clearSubmitFailure = false,
  }) =>
      SendMoneyState(
        stage: stage ?? this.stage,
        recipient: recipient ?? this.recipient,
        amountText: amountText ?? this.amountText,
        amountKobo: clearAmount ? null : (amountKobo ?? this.amountKobo),
        feeKobo: feeKobo ?? this.feeKobo,
        narration: narration ?? this.narration,
        amountError: clearAmountError ? null : (amountError ?? this.amountError),
        requiresBiometric: requiresBiometric ?? this.requiresBiometric,
        needsPinFallback: needsPinFallback ?? this.needsPinFallback,
        pinError: pinError ?? this.pinError,
        item: clearItem ? null : (item ?? this.item),
        outcome: clearItem ? null : (outcome ?? this.outcome),
        submitFailure: clearSubmitFailure ? null : (submitFailure ?? this.submitFailure),
      );

  @override
  List<Object?> get props => [
        stage, recipient, amountText, amountKobo, feeKobo, narration, amountError,
        requiresBiometric, needsPinFallback, pinError, item, outcome, submitFailure,
      ];
}
```

- [ ] **Step 4: Implement** `lib/features/send_money/cubit/send_money_cubit.dart`

```dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/flavor/app_constants.dart';
import '../../../core/api/exception/failure.dart';
import '../../../core/auth/biometric_gate.dart';
import '../../../core/auth/biometric_signer.dart';
import '../../../core/models/beneficiary.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/money/fees.dart';
import '../../../core/money/kobo_parser.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/repository/auth_repository.dart';
import '../../beneficiaries/repository/beneficiary_repository.dart';
import '../../connectivity/cubit/connectivity_cubit.dart';
import '../../settings/repository/settings_repository.dart';
import '../../sync/cubit/outcome_watcher.dart';
import '../../sync/cubit/sync_cubit.dart';
import '../../sync/repository/outbox_repository.dart';
import '../../wallet/cubit/wallet_cubit.dart';
import 'send_money_state.dart';

/// One send attempt (registered as a factory, so two flows never share state).
///
/// The cubit never talks to the network. It validates, authorises, and puts the
/// intent in the outbox; [SyncCubit] owns everything after that.
class SendMoneyCubit extends Cubit<SendMoneyState> with OutboxOutcomeWatcher {
  SendMoneyCubit({
    required this.outbox,
    required this.auth,
    required this.settings,
    required this.beneficiaries,
    required this.session,
    required this.wallet,
    required this.sync,
    required this.connectivity,
    required this.biometricGate,
    this.outcomeWait = AppConstants.sendOutcomeWait,
  }) : super(const SendMoneyState());

  final IOutboxRepository outbox;
  final IAuthRepository auth;
  final ISettingsRepository settings;
  final IBeneficiaryRepository beneficiaries;
  final AuthCubit session;
  final WalletCubit wallet;
  final SyncCubit sync;
  final ConnectivityCubit connectivity;
  final BiometricGate biometricGate;
  final Duration outcomeWait;

  StreamSubscription<OutboxItem?>? _itemSub;

  int get _capKobo => session.profile?.singleSendCapKobo ?? AppConstants.tier1SingleSendCapKobo;

  void selectRecipient(Beneficiary beneficiary) =>
      emit(state.copyWith(recipient: beneficiary, stage: SendStage.amount));

  void narrationChanged(String value) =>
      emit(state.copyWith(narration: value.length > 50 ? value.substring(0, 50) : value));

  void amountChanged(String value) {
    final parsed = KoboParser.parse(value);
    parsed.fold(
      (error) => emit(state.copyWith(
        amountText: value,
        clearAmount: true,
        feeKobo: 0,
        amountError: error == KoboParseError.empty
            ? null
            : const ValidationFailure(ValidationCode.invalidInput, 'Enter a valid amount.'),
        clearAmountError: error == KoboParseError.empty,
      )),
      (kobo) {
        final fee = Fees.transferFeeKobo(kobo);
        final debit = kobo + fee;
        Failure? error;
        if (kobo < AppConstants.minSendKobo) {
          error = const ValidationFailure(ValidationCode.amountTooSmall, 'The smallest transfer is ₦100.00.');
        } else if (kobo > _capKobo) {
          error = const ValidationFailure(
              ValidationCode.tierLimitExceeded, 'This is above your transfer limit. Verify your BVN to raise it.');
        } else if (debit > wallet.availableKobo) {
          error = const ValidationFailure(
              ValidationCode.insufficientAvailable, 'This is more than your available balance.');
        }
        emit(state.copyWith(
          amountText: value,
          amountKobo: kobo,
          feeKobo: fee,
          amountError: error,
          clearAmountError: error == null,
        ));
      },
    );
  }

  Future<void> continueToReview() async {
    if (!state.canContinue) return;
    final needsBiometric = state.amountKobo! >= AppConstants.biometricThresholdKobo &&
        await settings.biometricEnabled() &&
        await biometricGate.isAvailable();
    if (isClosed) return;
    emit(state.copyWith(
      stage: SendStage.review,
      requiresBiometric: needsBiometric,
      needsPinFallback: false,
      pinError: false,
      clearSubmitFailure: true,
    ));
  }

  void backToAmount() => emit(state.copyWith(stage: SendStage.amount));

  Future<void> authoriseWithPin(String pin) async {
    if (state.stage != SendStage.review) return;
    if (!await auth.verifyPin(pin)) {
      emit(state.copyWith(pinError: true));
      return;
    }
    emit(state.copyWith(pinError: false));
    await _submit();
  }

  Future<void> authoriseWithBiometric() async {
    if (state.stage != SendStage.review) return;
    final result = await biometricGate.confirm(
      // Signing the amount and recipient ties the approval to THIS transfer.
      payload: 'send|${state.recipient!.bankCode}|${state.recipient!.accountNumber}|${state.debitKobo}',
      reason: 'Approve this transfer',
    );
    if (isClosed) return;
    await result.fold(
      (error) async {
        if (error == BiometricSignerError.canceled) return; // routine, stay put
        // Nothing usable on this device: let the user pay with the PIN instead.
        emit(state.copyWith(needsPinFallback: true, requiresBiometric: false));
      },
      (signature) => _submit(biometricSignature: signature),
    );
  }

  Future<void> _submit({String? biometricSignature}) async {
    emit(state.copyWith(stage: SendStage.submitting, clearSubmitFailure: true));

    final recipient = state.recipient!;
    final result = await outbox.enqueueSend(
      draft: SendDraft(
        beneficiary: recipient,
        amountKobo: state.amountKobo!,
        feeKobo: state.feeKobo,
        narration: state.narration.isEmpty ? null : state.narration,
      ),
      online: connectivity.isOnline,
      biometricSignature: biometricSignature,
    );
    if (isClosed) return;

    await result.fold(
      (failure) async => emit(state.copyWith(stage: SendStage.review, submitFailure: failure)),
      (item) async {
        await beneficiaries.touch(recipient);
        unawaited(sync.drain());
        if (!connectivity.isOnline) {
          _finish(item, SendOutcome.pending);
          return;
        }
        final settled = await awaitOutcome(outbox: outbox, id: item.id, timeout: outcomeWait);
        if (isClosed) return;
        _finish(settled, _outcomeFor(settled));
      },
    );
  }

  SendOutcome _outcomeFor(OutboxItem item) => switch (item.status) {
        OutboxStatus.succeeded => SendOutcome.sent,
        OutboxStatus.failed => SendOutcome.failed,
        _ => connectivity.isOnline ? SendOutcome.processing : SendOutcome.pending,
      };

  void _finish(OutboxItem item, SendOutcome outcome) {
    emit(state.copyWith(stage: SendStage.result, item: item, outcome: outcome));
    // A Pending screen that is still open when the queue drains should say Sent.
    _itemSub?.cancel();
    _itemSub = outbox.watchItem(item.id).listen((latest) {
      if (latest == null || isClosed) return;
      emit(state.copyWith(item: latest, outcome: _outcomeFor(latest)));
    });
  }

  /// "Try again" after a rejection: a NEW intent, so the next submit gets a new
  /// idempotency key (spec A1).
  void retry() {
    _itemSub?.cancel();
    _itemSub = null;
    emit(state.copyWith(stage: SendStage.review, clearItem: true, pinError: false, clearSubmitFailure: true));
  }

  @override
  Future<void> close() async {
    await _itemSub?.cancel();
    return super.close();
  }
}
```

- [ ] **Step 5: Run the tests.** Run: `flutter test test/features/send_money` — all PASS.

- [ ] **Step 6: Checkpoint.** Report the files for the user to commit.

---

### Task 16: Notifications, biometric settings and the developer panel

**Files:**
- Create: `lib/core/notifications/local_notification_service.dart`
- Create: `lib/features/settings/cubit/biometric_settings_cubit.dart`
- Create: `lib/features/developer/repository/developer_repository.dart`, `developer_repository_impl.dart`
- Create: `lib/features/developer/cubit/developer_cubit.dart`
- Test: `test/features/developer/developer_test.dart`

**Interfaces:**
- Produces:
  - `class LocalNotificationService implements SyncNotifier { LocalNotificationService({FlutterLocalNotificationsPlugin? plugin}); Future<void> init({void Function(String payload)? onTap}); Future<void> requestPermission(); }`
  - `class BiometricSettingsState { bool enabled; bool available; bool busy; BiometricSignerError? error; }`
  - `class BiometricSettingsCubit extends Cubit<BiometricSettingsState> { BiometricSettingsCubit({required ISettingsRepository settings, required BiometricGate gate}); Future<void> load(); Future<void> toggle(bool value); }`
  - `class DevSettings { bool simulateOffline; bool loseNextResponse; int latencyMs; }`
  - `abstract class IDeveloperRepository { Future<DevSettings> load(); Future<void> setSimulateOffline(bool value); void setLoseNextResponse(bool value); Future<void> setLatencyMs(int ms); Stream<List<OutboxItem>> watchOutbox(); Future<void> resetDemoData(); }`
  - `class DeveloperCubit extends Cubit<DevSettings> { DeveloperCubit({required IDeveloperRepository repository, required AuthCubit authCubit}); Future<void> load(); Future<void> setSimulateOffline(bool v); void setLoseNextResponse(bool v); Future<void> setLatency(int ms); Stream<List<OutboxItem>> watchOutbox(); Future<void> resetDemoData(); }`

- [ ] **Step 1: Write the failing test** `test/features/developer/developer_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/storage/local_storage_impl.dart';
import 'package:nova_wallet/features/auth/cubit/auth_cubit.dart';
import 'package:nova_wallet/features/auth/cubit/auth_state.dart';
import 'package:nova_wallet/features/developer/cubit/developer_cubit.dart';
import 'package:nova_wallet/features/developer/repository/developer_repository_impl.dart';
import 'package:nova_wallet/features/settings/repository/settings_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/isar_test_db.dart';
import '../../support/outbox_harness.dart';

void main() {
  late OutboxHarness h;
  late DeveloperCubit dev;
  late AuthCubit auth;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    h = await OutboxHarness.open(directory: await newTempDir(), tag: 'dev');
    await h.signIn();
    final local = LocalStorageImpl(prefs: await SharedPreferences.getInstance());
    auth = AuthCubit(
        repository: h.authRepository, settings: SettingsRepositoryImpl(localStorage: local));
    dev = DeveloperCubit(
      repository: DeveloperRepositoryImpl(
        localStorage: local,
        controls: h.server.controls,
        outbox: h.outbox,
        server: h.server.server,
        db: h.db,
      ),
      authCubit: auth,
    );
  });

  tearDown(() async {
    await dev.close();
    await auth.close();
    await h.close(deleteFromDisk: true);
  });

  test('simulate-offline is persisted and applied to the fake server', () async {
    await dev.load();
    expect(dev.state.simulateOffline, isFalse);
    await dev.setSimulateOffline(true);
    expect(h.server.controls.simulateOffline, isTrue);
    expect(dev.state.simulateOffline, isTrue);

    // A fresh repository (as after a restart) restores the switch.
    final restored = await DeveloperRepositoryImpl(
      localStorage: LocalStorageImpl(prefs: await SharedPreferences.getInstance()),
      controls: h.server.controls,
      outbox: h.outbox,
      server: h.server.server,
      db: h.db,
    ).load();
    expect(restored.simulateOffline, isTrue);
  });

  test('latency and lose-next-response reach the controls', () async {
    await dev.load();
    await dev.setLatency(900);
    expect(h.server.controls.maxLatency.inMilliseconds, 900);
    dev.setLoseNextResponse(true);
    expect(h.server.controls.loseNextResponse, isTrue);
  });

  test('reset demo data wipes both databases and signs out', () async {
    await dev.load();
    await dev.resetDemoData();
    expect(await h.db.client.transactionEntitys.count(), 0);
    expect(await h.db.server.processedRequests.count(), 0);
    // The demo account is seeded again so the next login works.
    expect(await h.db.server.serverAccounts.getByPhone(AppConstants.demoPhone), isNotNull);
    expect(auth.state.status, AuthStatus.unauthenticated);
  });
}
```

- [ ] **Step 2: Run to see it fail.** Run: `flutter test test/features/developer` — compilation errors.

- [ ] **Step 3: Implement the notification service** `lib/core/notifications/local_notification_service.dart`

```dart
import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/outbox_item.dart';
import '../money/money.dart';
import 'sync_notifier.dart';

/// Local notifications for queued actions that finish while the user isn't
/// looking (brief stretch goal).
class LocalNotificationService implements SyncNotifier {
  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'nova_sync',
    'Transfers and savings',
    description: 'Tells you when a queued transfer or contribution goes through.',
    importance: Importance.high,
  );

  Future<void> init({void Function(String payload)? onTap}) async {
    if (_ready) return;
    _ready = true;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: darwin),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) onTap?.call(payload);
      },
    );
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// Asked for the first time an action is queued offline, not at launch.
  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      return;
    }
    await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  @override
  Future<void> syncSucceeded(OutboxItem item) => _show(
        item,
        title: switch (item.type) {
          OutboxType.send => 'Transfer sent',
          OutboxType.contribute => 'Saved to your goal',
          OutboxType.createGoal => 'Goal created',
        },
        body: switch (item.type) {
          OutboxType.send =>
            '${Money(item.amountKobo).format()} sent to ${item.counterpartyName ?? 'your recipient'}',
          OutboxType.contribute =>
            '${Money(item.amountKobo).format()} added to ${item.counterpartyName ?? 'your goal'}',
          OutboxType.createGoal => '${item.counterpartyName ?? 'Your goal'} is ready',
        },
      );

  @override
  Future<void> syncFailed(OutboxItem item) => _show(
        item,
        title: item.type == OutboxType.send ? 'Transfer failed' : "Couldn't save to your goal",
        body: item.failureMessage ?? 'Open NovaPay to see what happened.',
      );

  Future<void> _show(OutboxItem item, {required String title, required String body}) async {
    if (!_ready) return;
    await _plugin.show(
      id: item.id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: 'outbox:${item.id}',
    );
  }
}
```

(Plan 2 replaces the English strings here with localized ones via `lookupAppLocalizations`.)

- [ ] **Step 4: Implement the biometric settings cubit** `lib/features/settings/cubit/biometric_settings_cubit.dart`

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/auth/biometric_gate.dart';
import '../../../core/auth/biometric_signer.dart';
import '../repository/settings_repository.dart';

class BiometricSettingsState extends Equatable {
  const BiometricSettingsState({
    this.enabled = false,
    this.available = false,
    this.busy = false,
    this.error,
  });

  final bool enabled;
  final bool available;
  final bool busy;
  final BiometricSignerError? error;

  @override
  List<Object?> get props => [enabled, available, busy, error];
}

class BiometricSettingsCubit extends Cubit<BiometricSettingsState> {
  BiometricSettingsCubit({required this.settings, required this.gate})
      : super(const BiometricSettingsState());

  final ISettingsRepository settings;
  final BiometricGate gate;

  Future<void> load() async {
    final enabled = await settings.biometricEnabled();
    final available = await gate.isAvailable();
    if (!isClosed) emit(BiometricSettingsState(enabled: enabled && available, available: available));
  }

  Future<void> toggle(bool value) async {
    emit(BiometricSettingsState(enabled: state.enabled, available: state.available, busy: true));
    if (!value) {
      await gate.disable();
      await settings.setBiometricEnabled(false);
      await load();
      return;
    }
    final result = await gate.enable();
    await result.fold(
      (error) async => emit(BiometricSettingsState(available: state.available, error: error)),
      (_) async => settings.setBiometricEnabled(true),
    );
    await load();
  }
}
```

- [ ] **Step 5: Implement the developer repository and cubit**

`lib/features/developer/repository/developer_repository.dart`
```dart
import '../../../core/models/outbox_item.dart';

class DevSettings {
  const DevSettings({
    required this.simulateOffline,
    required this.loseNextResponse,
    required this.latencyMs,
  });

  final bool simulateOffline;
  final bool loseNextResponse;
  final int latencyMs;

  DevSettings copyWith({bool? simulateOffline, bool? loseNextResponse, int? latencyMs}) => DevSettings(
        simulateOffline: simulateOffline ?? this.simulateOffline,
        loseNextResponse: loseNextResponse ?? this.loseNextResponse,
        latencyMs: latencyMs ?? this.latencyMs,
      );
}

/// Backs the demo panel: the switches the panel flips during the interview.
abstract class IDeveloperRepository {
  Future<DevSettings> load();
  Future<void> setSimulateOffline(bool value);
  void setLoseNextResponse(bool value);
  Future<void> setLatencyMs(int ms);
  Stream<List<OutboxItem>> watchOutbox();
  Future<void> resetDemoData();
}
```

`lib/features/developer/repository/developer_repository_impl.dart`
```dart
import '../../../core/api/fake/fake_nova_server.dart';
import '../../../core/api/fake/fake_server_controls.dart';
import '../../../core/models/outbox_item.dart';
import '../../../core/storage/isar_db.dart';
import '../../../core/storage/local_storage.dart';
import '../../sync/repository/outbox_repository.dart';
import 'developer_repository.dart';

class DeveloperRepositoryImpl implements IDeveloperRepository {
  DeveloperRepositoryImpl({
    required this.localStorage,
    required this.controls,
    required this.outbox,
    required this.server,
    required this.db,
  });

  final LocalStorage localStorage;
  final FakeServerControls controls;
  final IOutboxRepository outbox;
  final FakeNovaServer server;
  final IsarDb db;

  /// Applies the saved switches to the running server. Called at startup so
  /// "offline" survives a restart during the demo.
  @override
  Future<DevSettings> load() async {
    final offline = await localStorage.getSimulateOffline();
    final latency = await localStorage.getLatencyMs() ?? controls.maxLatency.inMilliseconds;
    controls.simulateOffline = offline;
    controls.setLatencyMs(latency);
    return DevSettings(
        simulateOffline: offline, loseNextResponse: controls.loseNextResponse, latencyMs: latency);
  }

  @override
  Future<void> setSimulateOffline(bool value) async {
    controls.simulateOffline = value;
    await localStorage.saveSimulateOffline(value);
  }

  @override
  void setLoseNextResponse(bool value) => controls.loseNextResponse = value;

  @override
  Future<void> setLatencyMs(int ms) async {
    controls.setLatencyMs(ms);
    await localStorage.saveLatencyMs(ms);
  }

  @override
  Stream<List<OutboxItem>> watchOutbox() => outbox.watchAll();

  @override
  Future<void> resetDemoData() async {
    await db.clearClient();
    await server.resetDemo();
  }
}
```

`lib/features/developer/cubit/developer_cubit.dart`
```dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/outbox_item.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../repository/developer_repository.dart';

class DeveloperCubit extends Cubit<DevSettings> {
  DeveloperCubit({required this.repository, required this.authCubit})
      : super(const DevSettings(simulateOffline: false, loseNextResponse: false, latencyMs: 1200));

  final IDeveloperRepository repository;
  final AuthCubit authCubit;

  Future<void> load() async {
    final settings = await repository.load();
    if (!isClosed) emit(settings);
  }

  Future<void> setSimulateOffline(bool value) async {
    await repository.setSimulateOffline(value);
    if (!isClosed) emit(state.copyWith(simulateOffline: value));
  }

  void setLoseNextResponse(bool value) {
    repository.setLoseNextResponse(value);
    if (!isClosed) emit(state.copyWith(loseNextResponse: value));
  }

  Future<void> setLatency(int ms) async {
    await repository.setLatencyMs(ms);
    if (!isClosed) emit(state.copyWith(latencyMs: ms));
  }

  Stream<List<OutboxItem>> watchOutbox() => repository.watchOutbox();

  /// Wipes everything and returns to a signed-out app.
  Future<void> resetDemoData() async {
    await repository.resetDemoData();
    await authCubit.signOut();
  }
}
```

- [ ] **Step 6: Run the tests.** Run: `flutter test test/features/developer` — all PASS.

- [ ] **Step 7: Checkpoint.** Report the files for the user to commit.

---

### Task 17: Dependency injection, session lifecycle and app bootstrap

**Files:**
- Create: `lib/core/session/session_lifecycle.dart`
- Create: `lib/config/di/app_initializer.dart`
- Modify: `lib/main.dart`
- Test: `test/config/app_initializer_test.dart`

**Interfaces:**
- Produces:
  - `final GetIt sl`
  - `class AppInitializer { static Future<void> init({String? directory, NetworkInfo? networkInfo, SecureStorage? secureStorage, BiometricGate? biometricGate, SyncNotifier? notifier, SharedPreferences? preferences}); static Future<void> dispose(); }`
  - `class SessionLifecycle { SessionLifecycle({required AuthCubit auth, required SyncCubit sync, required WalletCubit wallet, required BeneficiariesCubit beneficiaries, required SavingsCubit savings}); void attach(); Future<void> detach(); }`

- [ ] **Step 1: Write the failing test** `test/config/app_initializer_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/config/di/app_initializer.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/features/auth/cubit/auth_cubit.dart';
import 'package:nova_wallet/features/auth/cubit/auth_state.dart';
import 'package:nova_wallet/features/auth/cubit/login_cubit.dart';
import 'package:nova_wallet/features/beneficiaries/cubit/beneficiaries_cubit.dart';
import 'package:nova_wallet/features/savings/cubit/savings_cubit.dart';
import 'package:nova_wallet/features/send_money/cubit/send_money_cubit.dart';
import 'package:nova_wallet/features/sync/cubit/sync_cubit.dart';
import 'package:nova_wallet/features/wallet/cubit/wallet_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_biometric_gate.dart';
import '../support/fake_network_info.dart';
import '../support/fake_sync_notifier.dart';
import '../support/in_memory_secure_storage.dart';
import '../support/isar_test_db.dart';

void main() {
  tearDown(() => AppInitializer.dispose());

  test('the container wires the whole graph and bootstraps to onboarding', () async {
    SharedPreferences.setMockInitialValues({});
    await AppInitializer.init(
      directory: await newTempDir(),
      networkInfo: FakeNetworkInfo(),
      secureStorage: InMemorySecureStorage(),
      biometricGate: FakeBiometricGate(),
      notifier: FakeSyncNotifier(),
      preferences: await SharedPreferences.getInstance(),
    );

    expect(sl<AuthCubit>().state.status, AuthStatus.needsOnboarding);
    expect(sl<SyncCubit>(), same(sl<SyncCubit>()), reason: 'singleton');
    expect(sl<SendMoneyCubit>(), isNot(same(sl<SendMoneyCubit>())), reason: 'factory per send');
    expect(sl<WalletCubit>(), isNotNull);
    expect(sl<BeneficiariesCubit>(), isNotNull);
    expect(sl<SavingsCubit>(), isNotNull);
  });

  test('signing in starts the session-scoped cubits; signing out clears them', () async {
    SharedPreferences.setMockInitialValues({});
    await AppInitializer.init(
      directory: await newTempDir(),
      networkInfo: FakeNetworkInfo(),
      secureStorage: InMemorySecureStorage(),
      biometricGate: FakeBiometricGate(),
      notifier: FakeSyncNotifier(),
      preferences: await SharedPreferences.getInstance(),
    );

    final login = LoginCubit(repository: sl(), authCubit: sl<AuthCubit>());
    await login.submit(phone: AppConstants.demoPhone, password: AppConstants.demoPassword);
    expect(sl<AuthCubit>().state.status, AuthStatus.authenticated);

    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(sl<WalletCubit>().state.overview.ledgerKobo, AppConstants.demoOpeningBalanceKobo);
    expect(sl<BeneficiariesCubit>().state.length, 4);
    expect(sl<SavingsCubit>().state.length, 1);

    await sl<AuthCubit>().signOut();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(sl<WalletCubit>().state.overview.ledgerKobo, 0);
    expect(sl<SavingsCubit>().state, isEmpty);
    await login.close();
  });
}
```

- [ ] **Step 2: Run to see it fail.** Run: `flutter test test/config/app_initializer_test.dart` — compilation errors.

- [ ] **Step 3: Implement the session lifecycle** `lib/core/session/session_lifecycle.dart`

```dart
import 'dart:async';

import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/auth/cubit/auth_state.dart';
import '../../features/beneficiaries/cubit/beneficiaries_cubit.dart';
import '../../features/savings/cubit/savings_cubit.dart';
import '../../features/sync/cubit/sync_cubit.dart';
import '../../features/wallet/cubit/wallet_cubit.dart';

/// Starts and stops session-scoped cubits as the session changes (Kiba wires
/// this inside each cubit; doing it in one place keeps the cubits testable).
///
/// Note that sync starts while the app is still LOCKED: a queued transfer
/// should go out as soon as there is a network, even before the user unlocks.
class SessionLifecycle {
  SessionLifecycle({
    required this.auth,
    required this.sync,
    required this.wallet,
    required this.beneficiaries,
    required this.savings,
  });

  final AuthCubit auth;
  final SyncCubit sync;
  final WalletCubit wallet;
  final BeneficiariesCubit beneficiaries;
  final SavingsCubit savings;

  StreamSubscription<AuthState>? _sub;

  void attach() {
    unawaited(_handle(auth.state));
    _sub = auth.stream.listen((state) => unawaited(_handle(state)));
  }

  Future<void> _handle(AuthState state) async {
    switch (state.status) {
      case AuthStatus.locked:
        await sync.start();
      case AuthStatus.authenticated:
        await sync.start();
        await wallet.start();
        await beneficiaries.start();
        await savings.start();
      case AuthStatus.unauthenticated:
      case AuthStatus.needsOnboarding:
        await wallet.reset();
        await beneficiaries.reset();
        await savings.reset();
        await sync.reset();
      case AuthStatus.unknown:
        break;
    }
  }

  Future<void> detach() async {
    await _sub?.cancel();
    _sub = null;
  }
}
```

- [ ] **Step 4: Implement** `lib/config/di/app_initializer.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api/fake/fake_nova_server.dart';
import '../../core/api/fake/fake_server_controls.dart';
import '../../core/api/service/nova_api_service.dart';
import '../../core/auth/biometric_gate.dart';
import '../../core/auth/biometric_signer.dart';
import '../../core/auth/secret_hasher.dart';
import '../../core/network/network_info.dart';
import '../../core/network/network_info_impl.dart';
import '../../core/network/reachability.dart';
import '../../core/notifications/local_notification_service.dart';
import '../../core/notifications/sync_notifier.dart';
import '../../core/session/session_lifecycle.dart';
import '../../core/storage/isar_db.dart';
import '../../core/storage/local_storage.dart';
import '../../core/storage/local_storage_impl.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/storage/secure_storage_impl.dart';
import '../../core/storage/session_store.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/auth/cubit/login_cubit.dart';
import '../../features/auth/cubit/signup_cubit.dart';
import '../../features/auth/cubit/unlock_cubit.dart';
import '../../features/auth/repository/auth_repository.dart';
import '../../features/auth/repository/auth_repository_impl.dart';
import '../../features/beneficiaries/cubit/beneficiaries_cubit.dart';
import '../../features/beneficiaries/cubit/name_enquiry_cubit.dart';
import '../../features/beneficiaries/repository/beneficiary_repository.dart';
import '../../features/beneficiaries/repository/beneficiary_repository_impl.dart';
import '../../features/connectivity/cubit/connectivity_cubit.dart';
import '../../features/developer/cubit/developer_cubit.dart';
import '../../features/developer/repository/developer_repository.dart';
import '../../features/developer/repository/developer_repository_impl.dart';
import '../../features/savings/cubit/create_goal_cubit.dart';
import '../../features/savings/cubit/savings_cubit.dart';
import '../../features/savings/repository/savings_repository.dart';
import '../../features/savings/repository/savings_repository_impl.dart';
import '../../features/send_money/cubit/send_money_cubit.dart';
import '../../features/settings/cubit/biometric_settings_cubit.dart';
import '../../features/settings/cubit/locale_cubit.dart';
import '../../features/settings/repository/settings_repository.dart';
import '../../features/settings/repository/settings_repository_impl.dart';
import '../../features/sync/cubit/sync_cubit.dart';
import '../../features/sync/repository/outbox_repository.dart';
import '../../features/sync/repository/outbox_repository_impl.dart';
import '../../features/wallet/cubit/wallet_cubit.dart';
import '../../features/wallet/repository/wallet_repository.dart';
import '../../features/wallet/repository/wallet_repository_impl.dart';

final GetIt sl = GetIt.instance;

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

/// Builds the object graph in dependency order: core → repositories → cubits.
/// Every override exists so tests (and the integration test's simulated
/// restart) can swap the platform pieces.
class AppInitializer {
  AppInitializer._();

  static SessionLifecycle? _lifecycle;

  static Future<void> init({
    String? directory,
    NetworkInfo? networkInfo,
    SecureStorage? secureStorage,
    BiometricGate? biometricGate,
    SyncNotifier? notifier,
    SharedPreferences? preferences,
  }) async {
    final prefs = preferences ?? await SharedPreferences.getInstance();
    final dir = directory ?? (await getApplicationDocumentsDirectory()).path;
    final db = await IsarDb.open(directory: dir);

    // ── Core ───────────────────────────────────────────────────────────────
    sl.registerSingleton<SharedPreferences>(prefs);
    sl.registerSingleton<IsarDb>(db);
    sl.registerSingleton<SecretHasher>(SecretHasher());
    sl.registerSingleton<LocalStorage>(LocalStorageImpl(prefs: prefs));
    sl.registerSingleton<SecureStorage>(
        secureStorage ?? SecureStorageImpl(secureStorage: const FlutterSecureStorage()));
    sl.registerSingleton<SessionStore>(SessionStore(secureStorage: sl(), hasher: sl()));
    sl.registerSingleton<NetworkInfo>(networkInfo ?? NetworkInfoImpl());
    sl.registerSingleton<FakeServerControls>(FakeServerControls());
    sl.registerSingleton<Reachability>(Reachability(networkInfo: sl(), controls: sl()));
    sl.registerSingleton<BiometricGate>(
        biometricGate ?? SignerBiometricGate(signer: BiometricSigner()));

    final server = FakeNovaServer(
      db: db.server,
      reachability: sl(),
      controls: sl(),
      hasher: sl(),
    );
    sl.registerSingleton<FakeNovaServer>(server);
    sl.registerSingleton<NovaApiService>(server);

    final localNotifications = LocalNotificationService();
    sl.registerSingleton<LocalNotificationService>(localNotifications);
    sl.registerSingleton<SyncNotifier>(notifier ?? localNotifications);

    // ── Repositories ───────────────────────────────────────────────────────
    sl.registerLazySingleton<ISettingsRepository>(() => SettingsRepositoryImpl(localStorage: sl()));
    sl.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl(
        remote: sl(), session: sl(), db: sl(), localStorage: sl(), hasher: sl()));
    sl.registerLazySingleton<IOutboxRepository>(
        () => OutboxRepositoryImpl(db: sl(), api: sl(), session: sl()));
    sl.registerLazySingleton<IWalletRepository>(
        () => WalletRepositoryImpl(db: sl(), api: sl(), session: sl()));
    sl.registerLazySingleton<IBeneficiaryRepository>(
        () => BeneficiaryRepositoryImpl(db: sl(), api: sl(), session: sl()));
    sl.registerLazySingleton<ISavingsRepository>(
        () => SavingsRepositoryImpl(db: sl(), api: sl(), session: sl()));
    sl.registerLazySingleton<IDeveloperRepository>(() => DeveloperRepositoryImpl(
        localStorage: sl(), controls: sl(), outbox: sl(), server: sl<FakeNovaServer>(), db: sl()));

    // ── Cubits ─────────────────────────────────────────────────────────────
    sl.registerSingleton<ConnectivityCubit>(ConnectivityCubit(reachability: sl()));
    sl.registerSingleton<AuthCubit>(AuthCubit(repository: sl(), settings: sl()));
    sl.registerSingleton<LocaleCubit>(LocaleCubit(repository: sl()));
    sl.registerSingleton<SyncCubit>(
        SyncCubit(outbox: sl(), connectivity: sl(), notifier: sl()));
    sl.registerSingleton<WalletCubit>(WalletCubit(repository: sl(), sync: sl()));
    sl.registerSingleton<BeneficiariesCubit>(BeneficiariesCubit(repository: sl()));
    sl.registerSingleton<SavingsCubit>(SavingsCubit(repository: sl()));
    sl.registerSingleton<DeveloperCubit>(DeveloperCubit(repository: sl(), authCubit: sl()));

    // One per flow, as Kiba does for PurchaseCubit.
    sl.registerFactory<SignupCubit>(() => SignupCubit(repository: sl(), authCubit: sl()));
    sl.registerFactory<LoginCubit>(() => LoginCubit(repository: sl(), authCubit: sl()));
    sl.registerFactory<UnlockCubit>(() =>
        UnlockCubit(repository: sl(), settings: sl(), biometricGate: sl(), authCubit: sl()));
    sl.registerFactory<NameEnquiryCubit>(
        () => NameEnquiryCubit(repository: sl(), connectivity: sl()));
    sl.registerFactory<CreateGoalCubit>(
        () => CreateGoalCubit(outbox: sl(), sync: sl(), connectivity: sl()));
    sl.registerFactory<BiometricSettingsCubit>(
        () => BiometricSettingsCubit(settings: sl(), gate: sl()));
    sl.registerFactory<SendMoneyCubit>(() => SendMoneyCubit(
          outbox: sl(),
          auth: sl(),
          settings: sl(),
          beneficiaries: sl(),
          session: sl(),
          wallet: sl(),
          sync: sl(),
          connectivity: sl(),
          biometricGate: sl(),
        ));

    // ── Start up ───────────────────────────────────────────────────────────
    await server.ensureSeeded();
    await sl<DeveloperCubit>().load(); // restores the demo switches
    await sl<LocaleCubit>().load();
    await sl<ConnectivityCubit>().start();
    if (notifier == null) await localNotifications.init();

    _lifecycle = SessionLifecycle(
      auth: sl(),
      sync: sl(),
      wallet: sl(),
      beneficiaries: sl(),
      savings: sl(),
    )..attach();

    await sl<AuthCubit>().bootstrap();
  }

  /// Tears the graph down. Used on sign-out of the process in tests, and by the
  /// integration test to simulate the app being killed.
  static Future<void> dispose() async {
    await _lifecycle?.detach();
    _lifecycle = null;
    if (sl.isRegistered<WalletCubit>()) await sl<WalletCubit>().close();
    if (sl.isRegistered<SavingsCubit>()) await sl<SavingsCubit>().close();
    if (sl.isRegistered<BeneficiariesCubit>()) await sl<BeneficiariesCubit>().close();
    if (sl.isRegistered<SyncCubit>()) await sl<SyncCubit>().close();
    if (sl.isRegistered<ConnectivityCubit>()) await sl<ConnectivityCubit>().close();
    if (sl.isRegistered<AuthCubit>()) await sl<AuthCubit>().close();
    if (sl.isRegistered<LocaleCubit>()) await sl<LocaleCubit>().close();
    if (sl.isRegistered<DeveloperCubit>()) await sl<DeveloperCubit>().close();
    if (sl.isRegistered<FakeServerControls>()) await sl<FakeServerControls>().dispose();
    if (sl.isRegistered<IsarDb>()) await sl<IsarDb>().close();
    await sl.reset();
  }
}
```

- [ ] **Step 5: Boot the app** `lib/main.dart` (temporary shell; Plan 2 replaces the widget tree)

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/di/app_initializer.dart';
import 'features/auth/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppInitializer.init();
  runApp(const NovaWalletApp());
}

/// Placeholder shell: proves the graph boots on a device. Plan 2 replaces this
/// with ScreenUtilInit + MaterialApp.router + the real screens.
class NovaWalletApp extends StatelessWidget {
  const NovaWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovaPay',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: messengerKey,
      home: Scaffold(
        body: Center(
          child: Text('NovaPay core ready — session: ${sl<AuthCubit>().state.status.name}'),
        ),
      ),
    );
  }
}
```

- [ ] **Step 6: Run the tests.** Run: `flutter test test/config/app_initializer_test.dart` — PASS. Then `flutter analyze` — no issues.

- [ ] **Step 7: Checkpoint.** Report the files for the user to commit.

---

### Task 18: The offline → restart → sync integration test (the graded scenario)

**Files:**
- Create: `test/support/offline_restart_scenario.dart`
- Create: `test/integration/offline_restart_sync_test.dart` (host, fast)
- Create: `integration_test/offline_queue_sync_test.dart` (device/emulator)
- Test: both of the above

**Interfaces:**
- Consumes: `AppInitializer`, `sl`, every cubit
- Produces: `Future<void> runOfflineRestartScenario({required String directory, required FakeNetworkInfo network, required InMemorySecureStorage secure, required FakeSyncNotifier notifier, bool downloadIsarCore = false})`

- [ ] **Step 1: Write the shared scenario** `test/support/offline_restart_scenario.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:nova_wallet/config/di/app_initializer.dart';
import 'package:nova_wallet/config/flavor/app_constants.dart';
import 'package:nova_wallet/core/api/fake/entities/server_entities.dart';
import 'package:nova_wallet/core/models/outbox_item.dart';
import 'package:nova_wallet/core/storage/isar_db.dart';
import 'package:nova_wallet/features/auth/cubit/auth_cubit.dart';
import 'package:nova_wallet/features/auth/cubit/login_cubit.dart';
import 'package:nova_wallet/features/beneficiaries/cubit/beneficiaries_cubit.dart';
import 'package:nova_wallet/features/connectivity/cubit/connectivity_cubit.dart';
import 'package:nova_wallet/features/savings/cubit/contribute_cubit.dart';
import 'package:nova_wallet/features/savings/cubit/savings_cubit.dart';
import 'package:nova_wallet/features/send_money/cubit/send_money_cubit.dart';
import 'package:nova_wallet/features/send_money/cubit/send_money_state.dart';
import 'package:nova_wallet/features/sync/cubit/sync_cubit.dart';
import 'package:nova_wallet/features/sync/repository/outbox_repository.dart';
import 'package:nova_wallet/features/wallet/cubit/wallet_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_biometric_gate.dart';
import 'fake_network_info.dart';
import 'fake_sync_notifier.dart';
import 'in_memory_secure_storage.dart';

/// The scenario the brief grades: queue while offline, kill the app, come back,
/// reconnect, and confirm each action reached the server EXACTLY once.
///
/// [secure] is passed in so the "restart" keeps the session, exactly as the
/// real keychain would.
Future<void> runOfflineRestartScenario({
  required String directory,
  required FakeNetworkInfo network,
  required InMemorySecureStorage secure,
  required FakeSyncNotifier notifier,
  bool downloadIsarCore = false,
}) async {
  if (downloadIsarCore) await Isar.initializeIsarCore(download: true);

  Future<void> boot() async {
    final prefs = await SharedPreferences.getInstance();
    await AppInitializer.init(
      directory: directory,
      networkInfo: network,
      secureStorage: secure,
      biometricGate: FakeBiometricGate(available: false),
      notifier: notifier,
      preferences: prefs,
    );
  }

  // ── 1. Sign in while online ───────────────────────────────────────────────
  network.connected = true;
  await boot();
  final login = LoginCubit(repository: sl(), authCubit: sl<AuthCubit>());
  await login.submit(phone: AppConstants.demoPhone, password: AppConstants.demoPassword);
  await login.close();
  expect(sl<AuthCubit>().state.status, AuthStatus.authenticated);
  await _settle();
  expect(sl<WalletCubit>().state.overview.ledgerKobo, AppConstants.demoOpeningBalanceKobo);

  final startingBalance = AppConstants.demoOpeningBalanceKobo;
  final recipient = sl<BeneficiariesCubit>().state.first;
  final goal = sl<SavingsCubit>().state.first;

  // ── 2. Go offline and queue a transfer and a contribution ────────────────
  network.connected = false;
  await sl<ConnectivityCubit>().recheck();

  final send = sl<SendMoneyCubit>()
    ..selectRecipient(recipient)
    ..amountChanged('25,000');
  await send.continueToReview();
  await send.authoriseWithPin(AppConstants.demoPin);
  expect(send.state.outcome, SendOutcome.pending);

  final contribute = ContributeCubit(
    goal: goal,
    outbox: sl(),
    auth: sl(),
    wallet: sl<WalletCubit>(),
    sync: sl<SyncCubit>(),
    connectivity: sl(),
  )..amountChanged('5,000');
  await contribute.submit(AppConstants.demoPin);
  await contribute.close();
  await send.close();

  expect((await sl<IOutboxRepository>().activeItems()).length, 2);
  expect(sl<WalletCubit>().state.overview.availableKobo, startingBalance - 2502688 - 500000);
  expect(await _serverBalance(), startingBalance, reason: 'nothing has been sent yet');

  final keys = (await sl<IOutboxRepository>().activeItems()).map((i) => i.idempotencyKey).toList();

  // ── 3. Kill the app while still offline, then start it again ─────────────
  await AppInitializer.dispose();
  await boot();
  expect(sl<AuthCubit>().state.status, AuthStatus.locked, reason: 'session survived the restart');

  final afterRestart = await sl<IOutboxRepository>().activeItems();
  expect(afterRestart.length, 2, reason: 'the queue survived the restart');
  expect(afterRestart.map((i) => i.idempotencyKey).toList(), keys, reason: 'same keys, never regenerated');
  expect(afterRestart.every((i) => i.status == OutboxStatus.queued), isTrue);

  // ── 4. Reconnect, with a flapping connection and two concurrent drains ───
  network.connected = true;
  network.connected = false;
  network.connected = true;
  await Future<void>.delayed(const Duration(seconds: 2));
  await Future.wait([sl<SyncCubit>().drain(), sl<SyncCubit>().drain()]);
  await _settle();

  // ── 5. Exactly once ──────────────────────────────────────────────────────
  final db = sl<IsarDb>();
  for (final key in keys) {
    expect(await db.server.processedRequests.getByIdempotencyKey(key), isNotNull);
    expect(await db.server.serverTransactions.filter().idempotencyKeyEqualTo(key).count(), 1,
        reason: 'key $key produced exactly one transaction');
  }
  expect(await _serverBalance(), startingBalance - 2502688 - 500000);
  expect(await sl<IOutboxRepository>().activeItems(), isEmpty);
  expect(notifier.succeeded.length, 2, reason: 'both queued actions notified the user');
  expect(notifier.failed, isEmpty);

  await AppInitializer.dispose();
}

Future<int> _serverBalance() async =>
    (await sl<IsarDb>().server.serverAccounts.getByPhone(AppConstants.demoPhone))!.balanceKobo;

Future<void> _settle() => Future<void>.delayed(const Duration(milliseconds: 400));
```

- [ ] **Step 2: Write the host test** `test/integration/offline_restart_sync_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fake_network_info.dart';
import '../support/fake_sync_notifier.dart';
import '../support/in_memory_secure_storage.dart';
import '../support/isar_test_db.dart';
import '../support/offline_restart_scenario.dart';

void main() {
  test('offline queue survives a restart and syncs exactly once', () async {
    SharedPreferences.setMockInitialValues({});
    await runOfflineRestartScenario(
      directory: await newTempDir(),
      network: FakeNetworkInfo(),
      secure: InMemorySecureStorage(),
      notifier: FakeSyncNotifier(),
      downloadIsarCore: true,
    );
  }, timeout: const Timeout(Duration(minutes: 2)));
}
```

- [ ] **Step 3: Write the device test** `integration_test/offline_queue_sync_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/support/fake_network_info.dart';
import '../test/support/fake_sync_notifier.dart';
import '../test/support/in_memory_secure_storage.dart';
import '../test/support/offline_restart_scenario.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('offline queue survives an app restart and syncs exactly once', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final dir = await getApplicationDocumentsDirectory();
    await runOfflineRestartScenario(
      directory: dir.path,
      network: FakeNetworkInfo(),
      secure: InMemorySecureStorage(),
      notifier: FakeSyncNotifier(),
    );
  }, timeout: const Timeout(Duration(minutes: 3)));
}
```

- [ ] **Step 4: Run both**

Run: `flutter test test/integration/offline_restart_sync_test.dart`
Expected: PASS.

Run (Android emulator running): `flutter test integration_test/offline_queue_sync_test.dart`
Expected: PASS on the device.

- [ ] **Step 5: Run everything**

Run: `flutter analyze && flutter test`
Expected: no analyzer issues; every test passes.

- [ ] **Step 6: Checkpoint.** Report the files for the user to commit. Plan 1 is complete: the offline core is built and proven, with no UI yet.

---

## Definition of done for Plan 1

- `flutter analyze` is clean and `flutter test` is green, including the crash-after-accept, lost-response, single-flight and restart tests.
- `flutter run` boots on the Android emulator and shows the placeholder screen (proof the graph and Isar work on a device).
- The brief's non-negotiables that live below the UI are all covered: integer kobo everywhere, a durable queue that survives restart and syncs exactly once, no secrets in SharedPreferences, and a fake backend that is honest about being offline.
- Deferred to Plan 2 (UI): Semantics and font-scale work, `ListView.builder` screens, Yoruba localization, the biometric prompt UI, notification copy localization, and the widget/golden-free test set the brief asks for.

---

# AMENDMENT A (2026-09-16): Firebase as the real backend

**Decision:** Firebase Authentication (email + password) and Realtime Database replace the in-process fake as the *default* backend. `FakeNovaServer` stays as a switchable fallback and as the fast unit-test double.

**This does not change the offline-first design.** The Isar outbox is still the only queue, `SyncCubit` is still the only thing that sends, and idempotency keys still guarantee exactly-once. Firebase sits behind the existing `NovaApiService` interface — that is the whole reason the interface exists.

## A.0 Non-negotiable Firebase rules

1. **Realtime Database persistence stays OFF** (`FirebaseDatabase.instance.setPersistenceEnabled(false)`, never call `keepSynced(true)`).
   RTDB's disk persistence keeps its **own durable write queue** that replays on reconnect. Two durable queues holding one intent is a duplicate-send waiting to happen, and it would hide the queue design this task is graded on. Isar caches; Isar queues; Firebase is only the wire.
2. **Never `await` a database write without a timeout.** With persistence off, an offline write still sits in memory until the connection returns, so every call is wrapped in `.timeout(...)` → `NetworkFailure(timedOut: true)` → our own retry with the same key.
3. **Money state for one user lives under ONE node** (`users/{uid}/money`), because an RTDB transaction is atomic over a single subtree. Balance, processed keys and goal totals therefore move together or not at all.
4. **Transaction refs are derived from the idempotency key**, so a replay rewrites the same child instead of adding a second one.
5. **Firebase Cloud Messaging does not replace the local notification.** The graded stretch goal ("notify when a queued send syncs") is fired locally by `SyncCubit`. FCM is optional garnish (a console-sent "money received" push during the demo).
6. **Backend is chosen at build time:** `--dart-define=BACKEND=fake` runs fully offline (demo parachute, unit tests); the default is `firebase`.

## A.1 Delta to Task 1 (setup)

- [ ] Add to `pubspec.yaml` dependencies (verified to resolve with the existing set on 2026-09-16):

```yaml
  firebase_core: ^4.1.1
  firebase_auth: ^6.1.0
  firebase_database: ^12.0.1
  # firebase_messaging: ^16.0.1  # OMIT for the deadline: the graded sync
  #                                notification is local. Add only if time
  #                                remains after Plan 3., Task 16 delta
```

- [ ] Create the Firebase project and platform config (CLI is already installed):

```bash
flutterfire configure --project=novapay-takehome --platforms=android,ios --out=lib/config/firebase/firebase_options.dart
```

If the project does not exist yet, create it first at console.firebase.google.com (Spark/free plan is enough — no Cloud Functions), enable **Authentication → Email/Password**, and create a **Realtime Database** in test mode; the rules are replaced in Task 7B.

- [ ] `android/app/build.gradle`: `minSdkVersion 23` (firebase_auth 6 requires it).
- [ ] `ios/Podfile`: `platform :ios, '15.0'`.
- [ ] `.gitignore`: add `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`, `.firebase/`. Commit `lib/config/firebase/firebase_options.dart` (it holds no secrets — access is controlled by the security rules).
- [ ] `firebase.json` and `database.rules.json` come from Task 7B.

## A.2 Delta to Task 6 (reachability) — *RTDB parts superseded by B.2; the `BackendReachability` interface and `AlwaysReachable` still stand*

`.info/connected` reports whether the **database** is reachable, which is strictly better than "an interface is up". Add a second source to `Reachability`, injected so the fake backend keeps working:

- [ ] Create `lib/core/network/backend_reachability.dart`:

```dart
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

/// Whether the backend itself answers. For Firebase this is the database's own
/// `.info/connected` flag — a captive portal or a dead data plan shows up here,
/// where `connectivity_plus` would still say "connected".
abstract class BackendReachability {
  Future<bool> get isReachable;
  Stream<bool> get changes;
}

/// Fake backend: reachable whenever the device is.
class AlwaysReachable implements BackendReachability {
  const AlwaysReachable();

  @override
  Future<bool> get isReachable async => true;

  @override
  Stream<bool> get changes => const Stream<bool>.empty();
}

class FirebaseBackendReachability implements BackendReachability {
  FirebaseBackendReachability({required FirebaseDatabase database})
      : _ref = database.ref('.info/connected');

  final DatabaseReference _ref;
  bool _connected = false;

  @override
  Future<bool> get isReachable async => _connected;

  @override
  Stream<bool> get changes => _ref.onValue.map((event) {
        _connected = event.snapshot.value == true;
        return _connected;
      });
}
```

- [ ] Modify `Reachability` (Task 6) to take `BackendReachability backend` and to AND it in:

```dart
  Future<bool> get isReachable async =>
      !controls.simulateOffline && await networkInfo.isConnected && await backend.isReachable;
```
and add `backend.changes.listen((_) => push())` beside the other two subscriptions in `onChanged`. Every existing test passes `const AlwaysReachable()`.

## A.3 NEW Task 7B: Database shape, security rules and seed — **SUPERSEDED BY B.3 (Firestore)**

**Files:** `database.rules.json`, `firebase.json`, `tool/seed_directory.json`, `lib/core/api/firebase/rtdb_paths.dart`

**Data shape** (one user's money under one node, so a single transaction is atomic over it):

```
users/{uid}/profile            {fullName, phone, email, tier, bvnVerified, accountNumber, pinHash, pinSalt}
users/{uid}/money/balanceKobo  25000000
users/{uid}/money/processed/{idempotencyKey}  {ok, result|code, message}
users/{uid}/money/goals/{clientId}            {name, targetKobo, targetDate, savedKobo, createdAt}
users/{uid}/transactions/{ref}                {kind, direction, amountKobo, feeKobo, title, ...}
users/{uid}/beneficiaries/{bankCode_accountNumber}  {accountNumber, bankCode, bankName, accountName}
directory/{bankCode}/{accountNumber}          "ADAEZE OKAFOR"     // public read: name enquiry
```

- [ ] **Step 1: Write `database.rules.json`**

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "auth != null && auth.uid === $uid",
        ".write": "auth != null && auth.uid === $uid",
        "money": {
          "balanceKobo": {
            ".validate": "newData.isNumber() && newData.val() >= 0 && newData.val() === newData.val() | 0"
          },
          "processed": {
            "$key": {
              ".validate": "newData.hasChild('ok')",
              ".write": "auth != null && auth.uid === $uid && !data.exists()"
            }
          }
        },
        "transactions": {
          "$ref": {
            ".validate": "newData.hasChildren(['kind','direction','amountKobo','createdAt'])"
          }
        }
      }
    },
    "directory": {
      ".read": "auth != null",
      ".write": false
    }
  }
}
```

The `processed` rule is the one to point at in the interview: **an idempotency record can be created but never overwritten**, enforced by the server, not by the client's good manners.

- [ ] **Step 2: `firebase.json`**

```json
{
  "database": { "rules": "database.rules.json" },
  "emulators": {
    "auth": { "port": 9099 },
    "database": { "port": 9000 },
    "ui": { "enabled": true }
  }
}
```

- [ ] **Step 3: Seed the public account directory** — `tool/seed_directory.json` holding the four demo beneficiaries plus a dozen extra accounts (same names as `DemoSeed._directoryNames`), then:

```bash
firebase deploy --only database
firebase database:set /directory tool/seed_directory.json --project novapay-takehome
```

- [ ] **Step 4: Path constants** — `lib/core/api/firebase/rtdb_paths.dart`

```dart
/// Every database path in one place, so a typo is a compile error.
abstract class RtdbPaths {
  static String user(String uid) => 'users/$uid';
  static String profile(String uid) => 'users/$uid/profile';
  static String money(String uid) => 'users/$uid/money';
  static String balance(String uid) => 'users/$uid/money/balanceKobo';
  static String processed(String uid, String key) => 'users/$uid/money/processed/$key';
  static String goals(String uid) => 'users/$uid/money/goals';
  static String transactions(String uid) => 'users/$uid/transactions';
  static String transaction(String uid, String ref) => 'users/$uid/transactions/$ref';
  static String beneficiaries(String uid) => 'users/$uid/beneficiaries';
  static String directoryEntry(String bankCode, String accountNumber) =>
      'directory/$bankCode/$accountNumber';
}
```

- [ ] **Step 5: Checkpoint.** Report the files for the user to commit.

## A.4 NEW Task 7C: FirebaseNovaService — **SUPERSEDED BY B.4 (Firestore)**; only Step 1 (`BackendAdmin`) still applies

**Files:** `lib/core/api/firebase/firebase_nova_service.dart`, `lib/core/api/backend_admin.dart`
**Test:** `integration_test/firebase_service_test.dart` (runs against the Firebase emulator — see A.7)

**Interfaces:**
- Produces: `abstract class BackendAdmin { Future<void> resetDemo(); }` (implemented by both `FakeNovaServer` and `FirebaseNovaService`) and `class FirebaseNovaService implements NovaApiService, BackendAdmin`.
- The session "token" is the Firebase **uid**: the SDK owns the real credential, and every call asserts the uid matches `FirebaseAuth.currentUser`.

- [ ] **Step 1: `lib/core/api/backend_admin.dart`**

```dart
/// Wipes and reseeds demo data. Implemented by whichever backend is active, so
/// the developer panel doesn't need to know which one it is.
abstract class BackendAdmin {
  Future<void> resetDemo();
}
```
Add `implements BackendAdmin` to `FakeNovaServer` (its `resetDemo()` already matches).

- [ ] **Step 2: Implement `lib/core/api/firebase/firebase_nova_service.dart`**

```dart
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../config/flavor/app_constants.dart';
import '../../auth/secret_hasher.dart';
import '../../models/activity_item.dart';
import '../../models/bank.dart';
import '../../money/fees.dart';
import '../../utils/masking.dart';
import '../../utils/phone.dart';
import '../backend_admin.dart';
import '../exception/failure.dart';
import '../fake/demo_seed.dart';
import '../fake/fake_server_controls.dart';
import '../service/dto.dart';
import '../service/nova_api_service.dart';
import 'rtdb_paths.dart';

/// The real backend: Firebase Auth for sessions, Realtime Database for money.
///
/// Three things make this safe to drive from a phone that keeps its own queue:
/// 1. **Persistence is off** (set in AppInitializer) so RTDB never keeps a
///    second durable write queue behind our outbox;
/// 2. every call has a **timeout**, so an offline write surfaces as a
///    [NetworkFailure] our sync engine retries with the SAME key;
/// 3. every mutation runs inside an **RTDB transaction over `users/{uid}/money`**,
///    which writes the balance, the goal and the idempotency record atomically.
class FirebaseNovaService implements NovaApiService, BackendAdmin {
  FirebaseNovaService({
    required this.auth,
    required this.database,
    required this.controls,
    required this.hasher,
    DateTime Function()? clock,
    this.timeout = const Duration(seconds: 12),
  }) : _clock = clock ?? DateTime.now;

  final FirebaseAuth auth;
  final FirebaseDatabase database;
  final FakeServerControls controls;
  final SecretHasher hasher;
  final DateTime Function() _clock;
  final Duration timeout;

  // ── Plumbing ────────────────────────────────────────────────────────────

  /// Wraps every call: honours the demo offline switch, maps SDK errors, and
  /// never waits forever.
  Future<Either<Failure, T>> _call<T>(Future<Either<Failure, T>> Function() body) async {
    if (controls.simulateOffline) return left(const NetworkFailure());
    try {
      return await body().timeout(timeout);
    } on TimeoutException {
      return left(const NetworkFailure(message: 'Request timed out.', timedOut: true));
    } on FirebaseAuthException catch (e) {
      return left(_mapAuthError(e));
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return left(const BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.'));
      }
      return left(NetworkFailure(message: e.message ?? 'Network error.'));
    }
  }

  Failure _mapAuthError(FirebaseAuthException e) => switch (e.code) {
        'network-request-failed' => const NetworkFailure(),
        'email-already-in-use' =>
          const BusinessFailure(BusinessCode.accountExists, 'An account with this email already exists.'),
        'invalid-credential' || 'wrong-password' || 'user-not-found' || 'invalid-email' =>
          const BusinessFailure(BusinessCode.invalidCredentials, 'Email or password is incorrect.'),
        'too-many-requests' =>
          const BusinessFailure(BusinessCode.invalidCredentials, 'Too many attempts. Try again later.'),
        _ => BusinessFailure(BusinessCode.invalidCredentials, e.message ?? 'Sign-in failed.'),
      };

  /// The "token" callers pass is the uid; the real credential lives in the SDK.
  String? _uid(String token) {
    final user = auth.currentUser;
    if (user == null || user.uid != token) return null;
    return user.uid;
  }

  DatabaseReference _ref(String path) => database.ref(path);

  Map<String, dynamic> _map(Object? value) =>
      (value as Map<Object?, Object?>? ?? {}).map((k, v) => MapEntry(k.toString(), v));

  // ── Auth ────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> requestOtp({required String phone}) async =>
      PhoneNumber.normalize(phone) == null
          ? left(const BusinessFailure(BusinessCode.invalidCredentials, 'Enter a valid Nigerian phone number.'))
          : right(unit);

  /// Email/password is the live credential (spec amendment): the OTP step stays
  /// as a phone-number confirmation, with a fixed demo code.
  @override
  Future<Either<Failure, Unit>> verifyOtp({required String phone, required String code}) async =>
      code == AppConstants.fakeOtp
          ? right(unit)
          : left(const BusinessFailure(BusinessCode.invalidOtp, 'That code is incorrect.'));

  @override
  Future<Either<Failure, SessionDto>> register(RegisterRequest request) => _call(() async {
        final phone = PhoneNumber.normalize(request.phone);
        if (phone == null) {
          return left(const BusinessFailure(BusinessCode.invalidCredentials, 'Enter a valid Nigerian phone number.'));
        }
        final credential = await auth.createUserWithEmailAndPassword(
            email: request.email.trim(), password: request.password);
        final uid = credential.user!.uid;

        final profile = ProfileDto(
          fullName: request.fullName.trim(),
          phone: phone,
          email: request.email.trim(),
          tier: 1,
          bvnVerified: false,
          accountNumber: phone.substring(1),
        );
        await _seedNewUser(uid, profile);
        return right(SessionDto(token: uid, profile: profile));
      });

  @override
  Future<Either<Failure, SessionDto>> login({required String phone, required String password}) =>
      _call(() async {
        // `phone` carries the email on this backend (the login screen collects
        // an email; the field name is kept so the interface stays backend-agnostic).
        final credential =
            await auth.signInWithEmailAndPassword(email: phone.trim(), password: password);
        final uid = credential.user!.uid;
        final snapshot = await _ref(RtdbPaths.profile(uid)).get();
        if (!snapshot.exists) {
          return left(const BusinessFailure(BusinessCode.invalidCredentials, 'This account has no profile yet.'));
        }
        final data = _map(snapshot.value);
        return right(SessionDto(
          token: uid,
          profile: _profileFrom(data),
          pinHash: data['pinHash'] as String?,
          pinSalt: data['pinSalt'] as String?,
        ));
      });

  ProfileDto _profileFrom(Map<String, dynamic> data) => ProfileDto(
        fullName: data['fullName'] as String,
        phone: data['phone'] as String,
        email: data['email'] as String,
        tier: (data['tier'] as num).toInt(),
        bvnVerified: data['bvnVerified'] as bool? ?? false,
        accountNumber: data['accountNumber'] as String,
      );

  @override
  Future<Either<Failure, Unit>> setPin({
    required String token,
    required String pinHash,
    required String pinSalt,
  }) =>
      _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        // Only the hash travels; the PIN itself never leaves the device.
        await _ref(RtdbPaths.profile(uid)).update({'pinHash': pinHash, 'pinSalt': pinSalt});
        return right(unit);
      });

  @override
  Future<Either<Failure, ProfileDto>> verifyBvn({required String token, required String bvn}) =>
      _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        if (!RegExp(r'^[1-9]\d{10}$').hasMatch(bvn)) {
          return left(const BusinessFailure(BusinessCode.invalidBvn, "We couldn't verify this BVN."));
        }
        await _ref(RtdbPaths.profile(uid)).update({'tier': 2, 'bvnVerified': true});
        final snapshot = await _ref(RtdbPaths.profile(uid)).get();
        return right(_profileFrom(_map(snapshot.value)));
      });

  // ── Reads ───────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, WalletDto>> getWallet({required String token}) => _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        final profile = await _ref(RtdbPaths.profile(uid)).get();
        final balance = await _ref(RtdbPaths.balance(uid)).get();
        if (!profile.exists) return left(_expired);
        return right(WalletDto(
          balanceKobo: ((balance.value as num?) ?? 0).toInt(),
          profile: _profileFrom(_map(profile.value)),
        ));
      });

  @override
  Future<Either<Failure, List<TransactionDto>>> getTransactions({
    required String token,
    int limit = 200,
  }) =>
      _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        final snapshot = await _ref(RtdbPaths.transactions(uid))
            .orderByChild('createdAt')
            .limitToLast(limit)
            .get();
        final rows = _map(snapshot.value)
            .values
            .map((v) => _txnFrom(_map(v)))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return right(rows);
      });

  TransactionDto _txnFrom(Map<String, dynamic> data) => TransactionDto(
        ref: data['ref'] as String,
        kind: ActivityKind.values.byName(data['kind'] as String),
        direction: ActivityDirection.values.byName(data['direction'] as String),
        amountKobo: (data['amountKobo'] as num).toInt(),
        feeKobo: ((data['feeKobo'] as num?) ?? 0).toInt(),
        title: data['title'] as String,
        subtitle: data['subtitle'] as String?,
        narration: data['narration'] as String?,
        goalClientId: data['goalClientId'] as String?,
        idempotencyKey: data['idempotencyKey'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch((data['createdAt'] as num).toInt()),
      );

  GoalDto _goalFrom(String clientId, Map<String, dynamic> data) => GoalDto(
        clientId: clientId,
        name: data['name'] as String,
        targetKobo: (data['targetKobo'] as num).toInt(),
        targetDate: DateTime.fromMillisecondsSinceEpoch((data['targetDate'] as num).toInt()),
        savedKobo: ((data['savedKobo'] as num?) ?? 0).toInt(),
        createdAt: DateTime.fromMillisecondsSinceEpoch((data['createdAt'] as num).toInt()),
      );

  @override
  Future<Either<Failure, List<BeneficiaryDto>>> getBeneficiaries({required String token}) =>
      _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        final snapshot = await _ref(RtdbPaths.beneficiaries(uid)).get();
        return right([
          for (final value in _map(snapshot.value).values)
            () {
              final data = _map(value);
              return BeneficiaryDto(
                accountNumber: data['accountNumber'] as String,
                bankCode: data['bankCode'] as String,
                bankName: data['bankName'] as String,
                accountName: data['accountName'] as String,
              );
            }(),
        ]);
      });

  @override
  Future<Either<Failure, BeneficiaryDto>> nameEnquiry({
    required String token,
    required String bankCode,
    required String accountNumber,
  }) =>
      _call(() async {
        if (_uid(token) == null) return left(_expired);
        final snapshot = await _ref(RtdbPaths.directoryEntry(bankCode, accountNumber)).get();
        final name = snapshot.value as String?;
        if (name == null || Banks.byCode(bankCode) == null) {
          return left(const BusinessFailure(
              BusinessCode.invalidAccount, "We couldn't find this account. Check the number and bank."));
        }
        return right(BeneficiaryDto(
          accountNumber: accountNumber,
          bankCode: bankCode,
          bankName: Banks.byCode(bankCode)!.name,
          accountName: name,
        ));
      });

  @override
  Future<Either<Failure, List<GoalDto>>> getGoals({required String token}) => _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        final snapshot = await _ref(RtdbPaths.goals(uid)).get();
        return right([
          for (final entry in _map(snapshot.value).entries) _goalFrom(entry.key, _map(entry.value)),
        ]);
      });

  // ── Mutations ───────────────────────────────────────────────────────────

  /// Applies [apply] at most once per [idempotencyKey].
  ///
  /// The whole thing happens inside ONE RTDB transaction over
  /// `users/{uid}/money`: if the key is already recorded the transaction is
  /// aborted and the stored response is returned unchanged; otherwise the new
  /// balance, the goal and the idempotency record commit together. The security
  /// rules also forbid overwriting an existing `processed/{key}`.
  Future<Either<Failure, MutationResultDto>> _mutate({
    required String token,
    required String idempotencyKey,
    required Map<String, dynamic>? Function(Map<String, dynamic> money, String ref) apply,
    required MutationResultDto Function(Map<String, dynamic> money, String ref) describe,
    BusinessFailure? Function(Map<String, dynamic> money)? reject,
    Map<String, dynamic>? Function(Map<String, dynamic> money, String ref)? transactionRecord,
  }) =>
      _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);

        // Deterministic: a replay writes the same child, never a second one.
        final ref = 'NP${idempotencyKey.replaceAll('-', '').substring(0, 12).toUpperCase()}';
        final moneyRef = _ref(RtdbPaths.money(uid));

        BusinessFailure? rejection;
        final result = await moneyRef.runTransaction((current) {
          final money = _map(current);
          final processed = _map(money['processed']);
          if (processed.containsKey(idempotencyKey)) {
            return Transaction.abort(); // already applied: leave everything alone
          }
          rejection = reject?.call(money);
          if (rejection != null) {
            final updated = Map<String, dynamic>.from(money);
            updated['processed'] = {
              ...processed,
              idempotencyKey: {'ok': false, 'code': rejection!.code.name, 'message': rejection!.message},
            };
            return Transaction.success(updated); // remember the rejection too
          }
          final updated = apply(money, ref);
          if (updated == null) return Transaction.abort();
          updated['processed'] = {
            ...processed,
            idempotencyKey: {'ok': true, 'ref': ref},
          };
          return Transaction.success(updated);
        }, applyLocally: false);

        final money = _map(result.snapshot.value);
        final stored = _map(_map(money['processed'])[idempotencyKey]);
        if (stored['ok'] == false) {
          return left(BusinessFailure(
            BusinessCode.values.byName(stored['code'] as String),
            stored['message'] as String,
          ));
        }

        // The ledger is committed; the receipt row is keyed by the same ref, so
        // writing it twice is a no-op.
        final record = transactionRecord?.call(money, stored['ref'] as String? ?? ref);
        if (record != null) {
          await _ref(RtdbPaths.transaction(uid, stored['ref'] as String? ?? ref)).set(record);
        }

        if (controls.loseNextResponse) {
          controls.loseNextResponse = false;
          return left(const NetworkFailure(message: 'Request timed out.', timedOut: true));
        }
        return right(describe(money, stored['ref'] as String? ?? ref));
      });

  @override
  Future<Either<Failure, MutationResultDto>> transfer({
    required String token,
    required String idempotencyKey,
    required TransferRequest request,
  }) async {
    // Name enquiry runs BEFORE the transaction: the transaction handler must be
    // synchronous, and a rejected account should never open one.
    final lookup = await nameEnquiry(
        token: token, bankCode: request.bankCode, accountNumber: request.accountNumber);
    final recipient = lookup.fold((f) => f, (dto) => dto);
    if (recipient is Failure) return left(recipient);
    final verified = recipient as BeneficiaryDto;

    // The tier cap is read here too, for the same reason.
    final uid = _uid(token);
    if (uid == null) return left(_expired);
    final tierSnapshot = await _ref(RtdbPaths.profile(uid)).child('tier').get();
    final tier = ((tierSnapshot.value as num?) ?? 1).toInt();
    final capKobo = tier >= 2
        ? AppConstants.tier2SingleSendCapKobo
        : AppConstants.tier1SingleSendCapKobo;

    final fee = Fees.transferFeeKobo(request.amountKobo);
    final debit = request.amountKobo + fee;
    final createdAt = _clock().millisecondsSinceEpoch;

    return _mutate(
      token: token,
      idempotencyKey: idempotencyKey,
      reject: (money) {
        final balance = ((money['balanceKobo'] as num?) ?? 0).toInt();
        if (request.amountKobo > capKobo) {
          return const BusinessFailure(
              BusinessCode.tierLimitExceeded, 'This amount is above your transfer limit.');
        }
        if (debit > balance) {
          return const BusinessFailure(
              BusinessCode.insufficientFunds, 'Insufficient funds when we tried to send.');
        }
        return null;
      },
      apply: (money, ref) {
        final updated = Map<String, dynamic>.from(money);
        updated['balanceKobo'] = ((money['balanceKobo'] as num?) ?? 0).toInt() - debit;
        return updated;
      },
      transactionRecord: (money, ref) => {
        'ref': ref,
        'kind': ActivityKind.transfer.name,
        'direction': ActivityDirection.debit.name,
        'amountKobo': request.amountKobo,
        'feeKobo': fee,
        'title': verified.accountName,
        'subtitle': '${request.bankName} · ${Masking.account(request.accountNumber)}',
        'narration': request.narration,
        'idempotencyKey': idempotencyKey,
        'createdAt': createdAt,
      },
      describe: (money, ref) => MutationResultDto(
        ref: ref,
        balanceAfterKobo: ((money['balanceKobo'] as num?) ?? 0).toInt(),
        transaction: TransactionDto(
          ref: ref,
          kind: ActivityKind.transfer,
          direction: ActivityDirection.debit,
          amountKobo: request.amountKobo,
          feeKobo: fee,
          title: verified.accountName,
          subtitle: '${request.bankName} · ${Masking.account(request.accountNumber)}',
          narration: request.narration,
          idempotencyKey: idempotencyKey,
          createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, MutationResultDto>> createGoal({
    required String token,
    required String idempotencyKey,
    required CreateGoalRequest request,
  }) {
    final createdAt = _clock().millisecondsSinceEpoch;
    return _mutate(
      token: token,
      idempotencyKey: idempotencyKey,
      apply: (money, ref) {
        final goals = _map(money['goals']);
        final updated = Map<String, dynamic>.from(money);
        updated['goals'] = {
          ...goals,
          request.clientId: {
            'name': request.name,
            'targetKobo': request.targetKobo,
            'targetDate': request.targetDate.millisecondsSinceEpoch,
            'savedKobo': _map(goals[request.clientId])['savedKobo'] ?? 0,
            'createdAt': createdAt,
          },
        };
        return updated;
      },
      describe: (money, ref) => MutationResultDto(
        ref: 'GOAL-${request.clientId}',
        balanceAfterKobo: ((money['balanceKobo'] as num?) ?? 0).toInt(),
        goal: _goalFrom(request.clientId, _map(_map(money['goals'])[request.clientId])),
      ),
    );
  }

  @override
  Future<Either<Failure, MutationResultDto>> contribute({
    required String token,
    required String idempotencyKey,
    required ContributeRequest request,
  }) {
    final createdAt = _clock().millisecondsSinceEpoch;
    return _mutate(
      token: token,
      idempotencyKey: idempotencyKey,
      reject: (money) {
        final goals = _map(money['goals']);
        if (!goals.containsKey(request.goalClientId)) {
          return const BusinessFailure(BusinessCode.goalNotFound, 'This savings goal no longer exists.');
        }
        if (request.amountKobo > ((money['balanceKobo'] as num?) ?? 0).toInt()) {
          return const BusinessFailure(
              BusinessCode.insufficientFunds, 'Insufficient funds when we tried to save.');
        }
        return null;
      },
      apply: (money, ref) {
        final goals = _map(money['goals']);
        final goal = _map(goals[request.goalClientId]);
        final updated = Map<String, dynamic>.from(money);
        updated['balanceKobo'] = ((money['balanceKobo'] as num?) ?? 0).toInt() - request.amountKobo;
        updated['goals'] = {
          ...goals,
          request.goalClientId: {
            ...goal,
            'savedKobo': ((goal['savedKobo'] as num?) ?? 0).toInt() + request.amountKobo,
          },
        };
        return updated;
      },
      transactionRecord: (money, ref) => {
        'ref': ref,
        'kind': ActivityKind.contribution.name,
        'direction': ActivityDirection.debit.name,
        'amountKobo': request.amountKobo,
        'feeKobo': 0,
        'title': _map(_map(money['goals'])[request.goalClientId])['name'] ?? 'NovaSave',
        'subtitle': 'NovaSave',
        'goalClientId': request.goalClientId,
        'idempotencyKey': idempotencyKey,
        'createdAt': createdAt,
      },
      describe: (money, ref) => MutationResultDto(
        ref: ref,
        balanceAfterKobo: ((money['balanceKobo'] as num?) ?? 0).toInt(),
        goal: _goalFrom(request.goalClientId, _map(_map(money['goals'])[request.goalClientId])),
        transaction: TransactionDto(
          ref: ref,
          kind: ActivityKind.contribution,
          direction: ActivityDirection.debit,
          amountKobo: request.amountKobo,
          feeKobo: 0,
          title: _map(_map(money['goals'])[request.goalClientId])['name'] as String? ?? 'NovaSave',
          subtitle: 'NovaSave',
          goalClientId: request.goalClientId,
          idempotencyKey: idempotencyKey,
          createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
        ),
      ),
    );
  }

  // ── Seeding / admin ─────────────────────────────────────────────────────

  /// New accounts start with the demo balance, history, beneficiaries and a
  /// goal, so the app has something to show on first launch.
  Future<void> _seedNewUser(String uid, ProfileDto profile) async {
    final now = _clock();
    final seed = DemoSeed(hasher: hasher);
    await _ref(RtdbPaths.user(uid)).set({
      'profile': profile.toJson(),
      'money': {
        'balanceKobo': AppConstants.demoOpeningBalanceKobo,
        'goals': {
          'seed-goal-rent': {
            'name': 'Rent — December',
            'targetKobo': 60000000,
            'targetDate': DateTime(2026, 12, 20).millisecondsSinceEpoch,
            'savedKobo': 21000000,
            'createdAt': now.subtract(const Duration(days: 45)).millisecondsSinceEpoch,
          },
        },
      },
      'beneficiaries': {
        for (final b in DemoSeed.beneficiaries)
          '${b.bankCode}_${b.accountNumber}': {
            'accountNumber': b.accountNumber,
            'bankCode': b.bankCode,
            'bankName': b.bankName,
            'accountName': b.accountName,
          },
      },
      'transactions': {
        for (final t in seed.historyJson(profile.phone, now)) t['ref'] as String: t,
      },
    });
  }

  @override
  Future<void> resetDemo() async {
    final user = auth.currentUser;
    if (user == null) return;
    final snapshot = await _ref(RtdbPaths.profile(user.uid)).get();
    if (!snapshot.exists) return;
    await _ref(RtdbPaths.user(user.uid)).remove();
    await _seedNewUser(user.uid, _profileFrom(_map(snapshot.value)));
  }

  static const Failure _expired =
      BusinessFailure(BusinessCode.unauthorized, 'Your session has expired. Please log in again.');
}
```

- [ ] **Step 3: Small additions this needs**
  - `DemoSeed`: add `List<Map<String, dynamic>> historyJson(String phone, DateTime now)` — the same 60 rows as `_history`, emitted as maps (`ref`, `kind`, `direction`, `amountKobo`, `feeKobo`, `title`, `subtitle`, `createdAt` as `millisecondsSinceEpoch`). Keep one generator and have `_history` build its entities from those maps, so the two backends seed identical data.
  - `AppConstants`, `Masking` and `Fees` are already imported by the file above; no other helper is needed.

- [ ] **Step 4: Checkpoint.** Report the files for the user to commit.

## A.5 Delta to Task 9 (auth repository)

No structural change — `AuthRepositoryImpl` keeps talking to `NovaApiService`. Two adjustments:
- [ ] The login screen collects an **email**; `IAuthRepository.login({required String phone, required String password})` keeps its name but passes the email through on the Firebase backend. Rename the parameter to `identifier` in both the interface and the fake (the fake normalises it as a phone number, Firebase treats it as an email). Update `LoginCubit.submit({required String identifier, required String password})` to skip phone normalisation when the backend is Firebase; simplest rule: **if the text contains `@`, pass it through; otherwise normalise it as a phone number.**
- [ ] `signOut()` also calls `FirebaseAuth.instance.signOut()`. Add an optional `Future<void> Function()? remoteSignOut` to `AuthRepositoryImpl` and wire it in DI.

## A.6 Deltas to Tasks 16 and 17

- [ ] **Task 16:** `DeveloperRepositoryImpl` takes `BackendAdmin admin` instead of `FakeNovaServer server`, and `resetDemoData()` calls `admin.resetDemo()`. FCM is optional: if you add it, port Kiba's `NotificationServiceImpl` foreground handler and use it only for console-sent demo pushes — the sync notification stays local.
- [ ] **Task 17 (`AppInitializer`):**

```dart
  // Backend selection: firebase by default, fake for offline demos and tests.
  const backend = String.fromEnvironment('BACKEND', defaultValue: 'firebase');

  if (backend == 'firebase' && firebaseOverride == null) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // NON-NEGOTIABLE: our Isar outbox is the only durable queue.
    FirebaseDatabase.instance.setPersistenceEnabled(false);
    final service = FirebaseNovaService(
      auth: FirebaseAuth.instance,
      database: FirebaseDatabase.instance,
      controls: sl(),
      hasher: sl(),
    );
    sl.registerSingleton<NovaApiService>(service);
    sl.registerSingleton<BackendAdmin>(service);
    sl.registerSingleton<BackendReachability>(
        FirebaseBackendReachability(database: FirebaseDatabase.instance));
  } else {
    final server = FakeNovaServer(db: db.server, reachability: sl(), controls: sl(), hasher: sl());
    sl.registerSingleton<FakeNovaServer>(server);
    sl.registerSingleton<NovaApiService>(server);
    sl.registerSingleton<BackendAdmin>(server);
    sl.registerSingleton<BackendReachability>(const AlwaysReachable());
  }
```
Register `Reachability` **after** `BackendReachability`, and `await server.ensureSeeded()` only on the fake branch. Add an `AppInitializer.init({NovaApiService? backendOverride, BackendReachability? reachabilityOverride})` pair so tests inject the fake without a dart-define.

## A.7 Delta to Task 18 (tests)

- [ ] Host unit tests keep running against `FakeNovaServer` — they are fast, deterministic, and need no network. That is the point of keeping it.
- [ ] Add `integration_test/firebase_service_test.dart` running against the **Firebase emulator**, started with `firebase emulators:start --only auth,database`. In `setUpAll`:

```dart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // 10.0.2.2 is the host machine as seen from the Android emulator.
  await FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
  FirebaseDatabase.instance.useDatabaseEmulator('10.0.2.2', 9000);
  FirebaseDatabase.instance.setPersistenceEnabled(false);
```
Port these cases from `fake_nova_server_test.dart`, which is the proof the two backends behave identically: **same key twice → one debit**; **rejection stored and replayed**; **lose-next-response then replay → one debit**; **concurrent transfers with different keys both apply**.
- [ ] Run `integration_test/offline_queue_sync_test.dart` twice: once with `--dart-define=BACKEND=fake` and once against the emulator. Both must pass.

## A.8 Delta to Plan 3 (docs)

- [ ] `README.md` gains a **Backends** section: why Firebase persistence is disabled, why the outbox is the only queue, the `users/{uid}/money` transaction shape, the `processed/{key}` security rule, and how to run either backend.
- [ ] `AI_USAGE.md` gains this entry, written in the candidate's voice:

> **Where I overrode the AI, and what it caught in return.** Claude's first design used an in-process fake backend. I directed it to use Firebase (Auth + Realtime Database) for a real integration. Claude accepted the change but flagged a risk in it: Realtime Database's offline persistence maintains its own durable write queue, which would have sat underneath my Isar outbox and could replay the same transfer twice — precisely the failure this task is about. We disabled Firebase persistence, kept the outbox as the single queue, and moved idempotency into an RTDB transaction over one user node, with a security rule that forbids overwriting an existing `processed/{key}`. The in-process fake survives as a second implementation of the same `NovaApiService` interface, which keeps unit tests fast and gives the live demo a no-network fallback.

## A.9 Time and risk

Firebase adds roughly **3–5 hours** (project setup, rules, service, re-testing). With submission at 2 PM Thursday, protect the graded core in this order: **offline core → Firebase service → screens → tests → docs/deck**. If time runs short, ship with `BACKEND=fake` as the demo default and Firebase documented as implemented-and-tested; do **not** cut the outbox tests.

---

# AMENDMENT B (2026-09-16): Cloud Firestore instead of Realtime Database

**Decision:** the Firebase backend uses **Cloud Firestore**. Amendment A stands except for the database itself: **A.2, A.3 and A.4 are superseded by B.2, B.3 and B.4 below.** Auth, the backend switch, the fake fallback, the local notification and the outbox are all unchanged.

**Why this is an improvement, not just a swap:** a Firestore transaction spans **multiple documents**, while an RTDB transaction is confined to one subtree. The money state no longer has to be crammed into a single node, and the idempotency record becomes its own document whose existence *is* the "already applied" check. Rules can then make that document **create-once**, which is the cleanest possible statement of the guarantee.

## B.0 Non-negotiable Firestore rules (replaces A.0 items 1–3)

1. **Offline persistence is ON by default in Firestore — turn it OFF.**
   `FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);` before the first use, and every read passes `GetOptions(source: Source.server)`.
   This matters more than it did for RTDB: Firestore's default behaviour queues writes on disk *and* serves reads from a local cache, which would put a second durable queue and a second cache underneath Isar. Isar is the cache; Isar is the queue; Firestore is the wire.
2. **All mutations go through `runTransaction`.** A Firestore transaction **requires a live connection** and fails fast with `unavailable` when there isn't one — exactly the behaviour our outbox wants: fail, don't queue silently.
3. **One transaction covers: the idempotency doc, the balance, the goal, and the receipt.** Reads first, writes after (Firestore's rule), with a hard timeout.
4. Deterministic document ids stay: the receipt lives at `users/{uid}/transactions/{ref}` where `ref` derives from the idempotency key, so a replay rewrites the same doc.
5. `--dart-define=BACKEND=fake` still runs the in-process fake. Unchanged.

## B.1 Delta to Task 1 (replaces the `firebase_database` line)

```yaml
  firebase_core: ^4.1.1
  firebase_auth: ^6.1.0
  cloud_firestore: ^6.1.2
  # firebase_messaging: ^16.0.1  # OMIT for the deadline: the graded sync
  #                                notification is local. Add only if time
  #                                remains after Plan 3.
```
Resolved and verified on 2026-09-16 (firebase_core 4.15.0, firebase_auth 6.7.0, cloud_firestore 6.10.0). In the Firebase console enable **Authentication → Email/Password** and **Firestore Database** (production mode; the rules below replace the defaults).

## B.2 Reachability (replaces A.2's `FirebaseBackendReachability`)

Firestore has no `.info/connected`. Instead, probe a tiny public document — which is what the spec's assumption A3 asked for anyway ("a production build would also probe a health endpoint"):

```dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'backend_reachability.dart';

/// Reads a one-field public document, from the server, with a short timeout.
/// A captive portal or a dead data plan fails here, where `connectivity_plus`
/// would still report "connected". Cached for a few seconds so a flapping
/// connection can't turn into a storm of reads.
class FirestoreBackendReachability implements BackendReachability {
  FirestoreBackendReachability({
    required this.firestore,
    this.probeTimeout = const Duration(seconds: 3),
    this.cacheFor = const Duration(seconds: 5),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final FirebaseFirestore firestore;
  final Duration probeTimeout;
  final Duration cacheFor;
  final DateTime Function() _clock;

  final _changes = StreamController<bool>.broadcast();
  bool _last = true;
  DateTime? _checkedAt;

  @override
  Future<bool> get isReachable async {
    final checkedAt = _checkedAt;
    if (checkedAt != null && _clock().difference(checkedAt) < cacheFor) return _last;
    var reachable = false;
    try {
      await firestore
          .doc('meta/health')
          .get(const GetOptions(source: Source.server))
          .timeout(probeTimeout);
      reachable = true;
    } catch (_) {
      reachable = false;
    }
    _checkedAt = _clock();
    if (reachable != _last) {
      _last = reachable;
      if (!_changes.isClosed) _changes.add(reachable);
    }
    return reachable;
  }

  /// Lets the service report "the backend just went away" without a probe.
  void reportUnreachable() {
    _checkedAt = _clock();
    if (_last) {
      _last = false;
      if (!_changes.isClosed) _changes.add(false);
    }
  }

  @override
  Stream<bool> get changes => _changes.stream;

  Future<void> dispose() => _changes.close();
}
```

`FirebaseNovaService` calls `reportUnreachable()` whenever it maps a Firestore `unavailable`/`deadline-exceeded` error, so the offline banner appears the instant a send fails, without waiting for a probe.

## B.3 Task 7B rewritten: Firestore shape, rules and seed

**Files:** `firestore.rules`, `firestore.indexes.json`, `firebase.json`, `tool/seed_directory.dart`, `lib/core/api/firebase/firestore_paths.dart`

**Collections**

```
users/{uid}                      { fullName, phone, email, tier, bvnVerified, accountNumber,
                                   pinHash, pinSalt, balanceKobo, createdAt }
users/{uid}/processed/{key}      { ok, ref?, result?, code?, message?, at }     ← create-once
users/{uid}/transactions/{ref}   { ref, kind, direction, amountKobo, feeKobo, title, subtitle,
                                   narration, goalClientId, idempotencyKey, createdAt }
users/{uid}/goals/{clientId}     { name, targetKobo, targetDate, savedKobo, createdAt }
users/{uid}/beneficiaries/{id}   { accountNumber, bankCode, bankName, accountName }   id = bankCode_accountNumber
directory/{bankCode_accountNumber}  { accountName }        ← public read, name enquiry
meta/health                      { ok: true }              ← reachability probe
```

Money values are **integer kobo** in Firestore too (`is int` in the rules). Dates are `int` milliseconds since epoch, matching the DTO JSON on both backends.

- [ ] **Step 1: `firestore.rules`**

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isOwner(uid) {
      return request.auth != null && request.auth.uid == uid;
    }

    match /users/{uid} {
      allow read, create: if isOwner(uid);
      // The balance may change, but never to a non-integer or a negative number.
      allow update: if isOwner(uid)
        && request.resource.data.balanceKobo is int
        && request.resource.data.balanceKobo >= 0;
      allow delete: if false;

      // The exactly-once guarantee, enforced by the server: an idempotency
      // record can be created once and can never be changed or removed.
      match /processed/{key} {
        allow read, create: if isOwner(uid);
        allow update, delete: if false;
      }

      match /transactions/{ref} {
        allow read: if isOwner(uid);
        allow create, update: if isOwner(uid)
          && request.resource.data.amountKobo is int
          && request.resource.data.amountKobo >= 0
          && request.resource.data.ref == ref;
        // Owner delete exists only so "Reset demo data" can wipe history.
        allow delete: if isOwner(uid);
      }

      // read/delete must not reference request.resource: it is undefined for
      // those operations, and an undefined reference makes the whole condition
      // error out — which Firestore treats as deny. The original combined
      // `allow read, write` rule would have denied every getGoals() call.
      match /goals/{goalId} {
        allow read, delete: if isOwner(uid);
        allow create, update: if isOwner(uid)
          && request.resource.data.savedKobo is int
          && request.resource.data.savedKobo >= 0;
      }

      match /beneficiaries/{beneficiaryId} {
        allow read, write: if isOwner(uid);
      }
    }

    match /directory/{entry} {
      allow read: if request.auth != null;
      allow write: if false;
    }

    // Public read: the reachability probe also runs on the login screen,
    // before any auth exists. Requiring auth here would make a logged-out
    // user look permanently offline. The doc holds nothing but { ok: true }.
    match /meta/{doc} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

The `processed` block is the slide: **"exactly-once isn't a promise my client makes, it's a rule the server enforces."**

- [ ] **Step 2: `firebase.json`**

```json
{
  "firestore": { "rules": "firestore.rules", "indexes": "firestore.indexes.json" },
  "emulators": {
    "auth": { "port": 9099 },
    "firestore": { "port": 8080 },
    "ui": { "enabled": true }
  }
}
```
`firestore.indexes.json` starts as `{ "indexes": [], "fieldOverrides": [] }` — the only ordered query (`transactions` by `createdAt`) uses a single-field index, which Firestore creates automatically.

- [ ] **Step 3: Seed the directory and health doc** — `tool/seed_directory.dart`, a small Dart script run with `dart run tool/seed_directory.dart` against the emulator or the live project, writing `meta/health = {ok: true}` and one `directory/{bankCode}_{accountNumber}` document per demo account (the four beneficiaries from `DemoSeed.beneficiaries` plus a dozen names from `DemoSeed._directoryNames`, which the script imports so the two backends resolve the same names). **The rules block client writes to `directory/` and `meta/`**, so the script cannot use the plain client SDK against the live project: authenticate with the Admin SDK (`dart_firebase_admin` + a service-account JSON — it bypasses rules, and works against the emulator via `FIRESTORE_EMULATOR_HOST`), or hand-create the ~17 documents once in the Firebase console. Do not weaken the rules to make the script work.

- [ ] **Step 4: Deploy** — `firebase deploy --only firestore:rules --project novapay-takehome`

- [ ] **Step 5: Path helpers** — `lib/core/api/firebase/firestore_paths.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Every collection path in one place.
class FirestorePaths {
  const FirestorePaths(this.firestore);

  final FirebaseFirestore firestore;

  DocumentReference<Map<String, dynamic>> user(String uid) => firestore.doc('users/$uid');
  DocumentReference<Map<String, dynamic>> processed(String uid, String key) =>
      user(uid).collection('processed').doc(key);
  CollectionReference<Map<String, dynamic>> transactions(String uid) =>
      user(uid).collection('transactions');
  CollectionReference<Map<String, dynamic>> goals(String uid) => user(uid).collection('goals');
  CollectionReference<Map<String, dynamic>> beneficiaries(String uid) =>
      user(uid).collection('beneficiaries');
  DocumentReference<Map<String, dynamic>> directoryEntry(String bankCode, String accountNumber) =>
      firestore.doc('directory/${bankCode}_$accountNumber');
  DocumentReference<Map<String, dynamic>> health() => firestore.doc('meta/health');
}
```

- [ ] **Step 6: Checkpoint.** Report the files for the user to commit.

## B.4 Task 7C rewritten: FirebaseNovaService on Firestore

**File:** `lib/core/api/firebase/firebase_nova_service.dart` (replaces the RTDB version in A.4; `BackendAdmin` from A.4 Step 1 is unchanged)

- [ ] **Step 1: The idempotency skeleton and plumbing**

```dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../config/flavor/app_constants.dart';
import '../../auth/secret_hasher.dart';
import '../../models/activity_item.dart';
import '../../models/bank.dart';
import '../../money/fees.dart';
import '../../network/firestore_backend_reachability.dart';
import '../../utils/masking.dart';
import '../../utils/phone.dart';
import '../backend_admin.dart';
import '../exception/failure.dart';
import '../fake/demo_seed.dart';
import '../fake/fake_server_controls.dart';
import '../service/dto.dart';
import '../service/nova_api_service.dart';
import 'firestore_paths.dart';

/// The real backend: Firebase Auth for sessions, Cloud Firestore for money.
///
/// The exactly-once story on this backend, in one paragraph: every mutation runs
/// inside a Firestore transaction that FIRST reads `users/{uid}/processed/{key}`.
/// If that document exists, the stored response is returned and nothing moves.
/// Otherwise the balance, the goal, the receipt and the processed document are
/// written together, atomically — and the security rules forbid that document
/// from ever being updated or deleted. Firestore transactions need a live
/// connection and fail fast offline, which is exactly what our outbox wants:
/// a clean [NetworkFailure] to retry later with the same key.
class FirebaseNovaService implements NovaApiService, BackendAdmin {
  FirebaseNovaService({
    required this.auth,
    required this.firestore,
    required this.controls,
    required this.hasher,
    this.reachability,
    DateTime Function()? clock,
    this.timeout = const Duration(seconds: 12),
  })  : _clock = clock ?? DateTime.now,
        paths = FirestorePaths(firestore);

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FakeServerControls controls;
  final SecretHasher hasher;

  /// Told about hard network errors so the offline banner appears immediately.
  final FirestoreBackendReachability? reachability;

  final DateTime Function() _clock;
  final Duration timeout;
  final FirestorePaths paths;

  static const _serverSource = GetOptions(source: Source.server);
  static const Failure _expired =
      BusinessFailure(BusinessCode.unauthorized, 'Your session has expired. Please log in again.');

  Future<Either<Failure, T>> _call<T>(Future<Either<Failure, T>> Function() body) async {
    if (controls.simulateOffline) return left(const NetworkFailure());
    try {
      return await body().timeout(timeout);
    } on TimeoutException {
      reachability?.reportUnreachable();
      return left(const NetworkFailure(message: 'Request timed out.', timedOut: true));
    } on FirebaseAuthException catch (e) {
      return left(_mapAuthError(e));
    } on FirebaseException catch (e) {
      return left(_mapFirestoreError(e));
    }
  }

  Failure _mapAuthError(FirebaseAuthException e) => switch (e.code) {
        'network-request-failed' => const NetworkFailure(),
        'email-already-in-use' =>
          const BusinessFailure(BusinessCode.accountExists, 'An account with this email already exists.'),
        'invalid-credential' || 'wrong-password' || 'user-not-found' || 'invalid-email' =>
          const BusinessFailure(BusinessCode.invalidCredentials, 'Email or password is incorrect.'),
        'too-many-requests' =>
          const BusinessFailure(BusinessCode.invalidCredentials, 'Too many attempts. Try again later.'),
        _ => BusinessFailure(BusinessCode.invalidCredentials, e.message ?? 'Sign-in failed.'),
      };

  Failure _mapFirestoreError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const BusinessFailure(BusinessCode.unauthorized, 'Your session has expired.');
      case 'unavailable':
      case 'deadline-exceeded':
        reachability?.reportUnreachable();
        return NetworkFailure(message: e.message ?? 'Network error.', timedOut: true);
      case 'aborted':
        // Transaction contention, not an outage: retry with the same key,
        // but do NOT flip the offline banner via reportUnreachable().
        return const NetworkFailure(message: 'Please try again.');
      default:
        return NetworkFailure(message: e.message ?? 'Network error.');
    }
  }

  String? _uid(String token) {
    final user = auth.currentUser;
    if (user == null || user.uid != token) return null;
    return user.uid;
  }

  /// Deterministic: the same key always names the same receipt document.
  String _refFor(String key) => 'NP${key.replaceAll('-', '').substring(0, 12).toUpperCase()}';

  /// Runs [body] at most once per [key], inside one Firestore transaction.
  ///
  /// [body] may READ (its reads come after ours, still before any write) and
  /// then write through [txn]. Rejections are stored too, so a replay returns
  /// the same refusal instead of being re-evaluated against a changed balance.
  Future<Either<Failure, MutationResultDto>> _idempotent({
    required String token,
    required String key,
    required Future<Either<BusinessFailure, MutationResultDto>> Function(
      Transaction txn,
      DocumentReference<Map<String, dynamic>> userRef,
      Map<String, dynamic> user,
      String ref,
    ) body,
  }) =>
      _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);

        final userRef = paths.user(uid);
        final processedRef = paths.processed(uid, key);
        final ref = _refFor(key);

        final stored = await firestore.runTransaction<Map<String, dynamic>>(
          (txn) async {
            // 1. Has this exact intent already been applied?
            final processedSnap = await txn.get(processedRef);
            if (processedSnap.exists) return processedSnap.data()!;

            // 2. No: read the account, then let the endpoint do its work.
            final userSnap = await txn.get(userRef);
            if (!userSnap.exists) {
              return {'ok': false, 'code': BusinessCode.unauthorized.name, 'message': 'Account not found.'};
            }
            final outcome = await body(txn, userRef, userSnap.data()!, ref);

            // 3. Record the outcome in the SAME transaction as the money move.
            final record = outcome.fold(
              (failure) => <String, dynamic>{
                'ok': false,
                'code': failure.code.name,
                'message': failure.message,
                'at': _clock().millisecondsSinceEpoch,
              },
              (result) => <String, dynamic>{
                'ok': true,
                'ref': result.ref,
                'result': result.toJson(),
                'at': _clock().millisecondsSinceEpoch,
              },
            );
            txn.set(processedRef, record);
            return record;
          },
          timeout: timeout,
        );

        // The lost-response demo switch: the server committed, the phone doesn't
        // hear about it. The replay is what proves the guarantee.
        if (controls.loseNextResponse) {
          controls.loseNextResponse = false;
          return left(const NetworkFailure(message: 'Request timed out.', timedOut: true));
        }

        if (stored['ok'] == false) {
          return left(BusinessFailure(
            BusinessCode.values.byName(stored['code'] as String),
            stored['message'] as String,
          ));
        }
        return right(MutationResultDto.fromJson(stored['result'] as Map<String, dynamic>));
      });
```

- [ ] **Step 2: Auth and reads** — identical in shape to A.4, with Firestore calls:

```dart
  @override
  Future<Either<Failure, Unit>> requestOtp({required String phone}) async =>
      PhoneNumber.normalize(phone) == null
          ? left(const BusinessFailure(BusinessCode.invalidCredentials, 'Enter a valid Nigerian phone number.'))
          : right(unit);

  @override
  Future<Either<Failure, Unit>> verifyOtp({required String phone, required String code}) async =>
      code == AppConstants.fakeOtp
          ? right(unit)
          : left(const BusinessFailure(BusinessCode.invalidOtp, 'That code is incorrect.'));

  @override
  Future<Either<Failure, SessionDto>> register(RegisterRequest request) => _call(() async {
        final phone = PhoneNumber.normalize(request.phone);
        if (phone == null) {
          return left(const BusinessFailure(BusinessCode.invalidCredentials, 'Enter a valid Nigerian phone number.'));
        }
        final profile = ProfileDto(
          fullName: request.fullName.trim(),
          phone: phone,
          email: request.email.trim(),
          tier: 1,
          bvnVerified: false,
          accountNumber: phone.substring(1),
        );
        late final String uid;
        try {
          final credential = await auth.createUserWithEmailAndPassword(
              email: request.email.trim(), password: request.password);
          uid = credential.user!.uid;
        } on FirebaseAuthException catch (e) {
          // A crash between account creation and the seed batch leaves an auth
          // user with no profile — a dead end ("email already in use" on
          // register, "no profile" on login). Registering again with the same
          // credentials completes the seed instead.
          if (e.code != 'email-already-in-use') rethrow;
          final credential = await auth.signInWithEmailAndPassword(
              email: request.email.trim(), password: request.password);
          uid = credential.user!.uid;
          final existing = await paths.user(uid).get(_serverSource);
          if (existing.exists) {
            return left(const BusinessFailure(
                BusinessCode.accountExists, 'An account with this email already exists.'));
          }
        }
        await _seedNewUser(uid, profile);
        return right(SessionDto(token: uid, profile: profile));
      });

  /// `identifier` is an email on this backend (see A.5).
  @override
  Future<Either<Failure, SessionDto>> login({required String identifier, required String password}) =>
      _call(() async {
        final credential =
            await auth.signInWithEmailAndPassword(email: identifier.trim(), password: password);
        final uid = credential.user!.uid;
        final snap = await paths.user(uid).get(_serverSource);
        final data = snap.data();
        if (data == null) {
          return left(const BusinessFailure(BusinessCode.invalidCredentials, 'This account has no profile yet.'));
        }
        return right(SessionDto(
          token: uid,
          profile: _profileFrom(data),
          pinHash: data['pinHash'] as String?,
          pinSalt: data['pinSalt'] as String?,
        ));
      });

  ProfileDto _profileFrom(Map<String, dynamic> d) => ProfileDto(
        fullName: d['fullName'] as String,
        phone: d['phone'] as String,
        email: d['email'] as String,
        tier: (d['tier'] as num).toInt(),
        bvnVerified: d['bvnVerified'] as bool? ?? false,
        accountNumber: d['accountNumber'] as String,
      );

  @override
  Future<Either<Failure, Unit>> setPin({
    required String token,
    required String pinHash,
    required String pinSalt,
  }) =>
      _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        // Only the hash travels; the PIN never leaves the device.
        await paths.user(uid).update({'pinHash': pinHash, 'pinSalt': pinSalt});
        return right(unit);
      });

  @override
  Future<Either<Failure, ProfileDto>> verifyBvn({required String token, required String bvn}) =>
      _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        if (!RegExp(r'^[1-9]\d{10}$').hasMatch(bvn)) {
          return left(const BusinessFailure(BusinessCode.invalidBvn, "We couldn't verify this BVN."));
        }
        await paths.user(uid).update({'tier': 2, 'bvnVerified': true});
        final snap = await paths.user(uid).get(_serverSource);
        return right(_profileFrom(snap.data()!));
      });

  @override
  Future<Either<Failure, WalletDto>> getWallet({required String token}) => _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        final snap = await paths.user(uid).get(_serverSource);
        final data = snap.data();
        if (data == null) return left(_expired);
        return right(WalletDto(
          balanceKobo: ((data['balanceKobo'] as num?) ?? 0).toInt(),
          profile: _profileFrom(data),
        ));
      });

  @override
  Future<Either<Failure, List<TransactionDto>>> getTransactions({
    required String token,
    int limit = 200,
  }) =>
      _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        final query = await paths
            .transactions(uid)
            .orderBy('createdAt', descending: true)
            .limit(limit)
            .get(_serverSource);
        return right(query.docs.map((d) => _txnFrom(d.data())).toList());
      });

  TransactionDto _txnFrom(Map<String, dynamic> d) => TransactionDto(
        ref: d['ref'] as String,
        kind: ActivityKind.values.byName(d['kind'] as String),
        direction: ActivityDirection.values.byName(d['direction'] as String),
        amountKobo: (d['amountKobo'] as num).toInt(),
        feeKobo: ((d['feeKobo'] as num?) ?? 0).toInt(),
        title: d['title'] as String,
        subtitle: d['subtitle'] as String?,
        narration: d['narration'] as String?,
        goalClientId: d['goalClientId'] as String?,
        idempotencyKey: d['idempotencyKey'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch((d['createdAt'] as num).toInt()),
      );

  GoalDto _goalFrom(String clientId, Map<String, dynamic> d) => GoalDto(
        clientId: clientId,
        name: d['name'] as String,
        targetKobo: (d['targetKobo'] as num).toInt(),
        targetDate: DateTime.fromMillisecondsSinceEpoch((d['targetDate'] as num).toInt()),
        savedKobo: ((d['savedKobo'] as num?) ?? 0).toInt(),
        createdAt: DateTime.fromMillisecondsSinceEpoch((d['createdAt'] as num).toInt()),
      );

  @override
  Future<Either<Failure, List<BeneficiaryDto>>> getBeneficiaries({required String token}) =>
      _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        final query = await paths.beneficiaries(uid).get(_serverSource);
        return right([
          for (final doc in query.docs)
            BeneficiaryDto(
              accountNumber: doc.data()['accountNumber'] as String,
              bankCode: doc.data()['bankCode'] as String,
              bankName: doc.data()['bankName'] as String,
              accountName: doc.data()['accountName'] as String,
            ),
        ]);
      });

  @override
  Future<Either<Failure, BeneficiaryDto>> nameEnquiry({
    required String token,
    required String bankCode,
    required String accountNumber,
  }) =>
      _call(() async {
        if (_uid(token) == null) return left(_expired);
        final snap = await paths.directoryEntry(bankCode, accountNumber).get(_serverSource);
        final name = snap.data()?['accountName'] as String?;
        if (name == null || Banks.byCode(bankCode) == null) {
          return left(const BusinessFailure(
              BusinessCode.invalidAccount, "We couldn't find this account. Check the number and bank."));
        }
        return right(BeneficiaryDto(
          accountNumber: accountNumber,
          bankCode: bankCode,
          bankName: Banks.byCode(bankCode)!.name,
          accountName: name,
        ));
      });

  @override
  Future<Either<Failure, List<GoalDto>>> getGoals({required String token}) => _call(() async {
        final uid = _uid(token);
        if (uid == null) return left(_expired);
        final query = await paths.goals(uid).get(_serverSource);
        return right([for (final doc in query.docs) _goalFrom(doc.id, doc.data())]);
      });
```

- [ ] **Step 3: The three mutations**

```dart
  @override
  Future<Either<Failure, MutationResultDto>> transfer({
    required String token,
    required String idempotencyKey,
    required TransferRequest request,
  }) async {
    // Name enquiry happens BEFORE the transaction: a transaction may not read
    // a document outside itself after writing, and a bad account should never
    // open one at all.
    final lookup = await nameEnquiry(
        token: token, bankCode: request.bankCode, accountNumber: request.accountNumber);
    if (lookup.isLeft()) {
      return left(lookup.swap().getOrElse(() => const NetworkFailure()));
    }
    final verified = lookup.getOrElse(() => throw StateError('unreachable'));

    final fee = Fees.transferFeeKobo(request.amountKobo);
    final debit = request.amountKobo + fee;
    final createdAt = _clock().millisecondsSinceEpoch;

    return _idempotent(
      token: token,
      key: idempotencyKey,
      body: (txn, userRef, user, ref) async {
        final tier = ((user['tier'] as num?) ?? 1).toInt();
        final cap = tier >= 2
            ? AppConstants.tier2SingleSendCapKobo
            : AppConstants.tier1SingleSendCapKobo;
        if (request.amountKobo > cap) {
          return left(const BusinessFailure(
              BusinessCode.tierLimitExceeded, 'This amount is above your transfer limit.'));
        }
        final balance = ((user['balanceKobo'] as num?) ?? 0).toInt();
        if (debit > balance) {
          return left(const BusinessFailure(
              BusinessCode.insufficientFunds, 'Insufficient funds when we tried to send.'));
        }

        final balanceAfter = balance - debit;
        final receipt = <String, dynamic>{
          'ref': ref,
          'kind': ActivityKind.transfer.name,
          'direction': ActivityDirection.debit.name,
          'amountKobo': request.amountKobo,
          'feeKobo': fee,
          'title': verified.accountName,
          'subtitle': '${request.bankName} · ${Masking.account(request.accountNumber)}',
          'narration': request.narration,
          'idempotencyKey': idempotencyKey,
          'createdAt': createdAt,
        };
        txn.update(userRef, {'balanceKobo': balanceAfter});
        txn.set(paths.transactions(userRef.id).doc(ref), receipt);

        return right(MutationResultDto(
          ref: ref,
          balanceAfterKobo: balanceAfter,
          transaction: _txnFrom(receipt),
        ));
      },
    );
  }

  @override
  Future<Either<Failure, MutationResultDto>> createGoal({
    required String token,
    required String idempotencyKey,
    required CreateGoalRequest request,
  }) {
    final createdAt = _clock().millisecondsSinceEpoch;
    return _idempotent(
      token: token,
      key: idempotencyKey,
      body: (txn, userRef, user, ref) async {
        final goalRef = paths.goals(userRef.id).doc(request.clientId);
        final existing = await txn.get(goalRef); // read before any write
        final saved = ((existing.data()?['savedKobo'] as num?) ?? 0).toInt();
        final goal = <String, dynamic>{
          'name': request.name,
          'targetKobo': request.targetKobo,
          'targetDate': request.targetDate.millisecondsSinceEpoch,
          'savedKobo': saved,
          'createdAt': ((existing.data()?['createdAt'] as num?) ?? createdAt).toInt(),
        };
        txn.set(goalRef, goal);
        return right(MutationResultDto(
          ref: 'GOAL-${request.clientId}',
          balanceAfterKobo: ((user['balanceKobo'] as num?) ?? 0).toInt(),
          goal: _goalFrom(request.clientId, goal),
        ));
      },
    );
  }

  @override
  Future<Either<Failure, MutationResultDto>> contribute({
    required String token,
    required String idempotencyKey,
    required ContributeRequest request,
  }) {
    final createdAt = _clock().millisecondsSinceEpoch;
    return _idempotent(
      token: token,
      key: idempotencyKey,
      body: (txn, userRef, user, ref) async {
        final goalRef = paths.goals(userRef.id).doc(request.goalClientId);
        final goalSnap = await txn.get(goalRef); // read before any write
        final goalData = goalSnap.data();
        if (goalData == null) {
          return left(const BusinessFailure(BusinessCode.goalNotFound, 'This savings goal no longer exists.'));
        }
        final balance = ((user['balanceKobo'] as num?) ?? 0).toInt();
        if (request.amountKobo > balance) {
          return left(const BusinessFailure(
              BusinessCode.insufficientFunds, 'Insufficient funds when we tried to save.'));
        }

        final balanceAfter = balance - request.amountKobo;
        final savedAfter = ((goalData['savedKobo'] as num?) ?? 0).toInt() + request.amountKobo;
        final receipt = <String, dynamic>{
          'ref': ref,
          'kind': ActivityKind.contribution.name,
          'direction': ActivityDirection.debit.name,
          'amountKobo': request.amountKobo,
          'feeKobo': 0,
          'title': goalData['name'] as String,
          'subtitle': 'NovaSave',
          'goalClientId': request.goalClientId,
          'idempotencyKey': idempotencyKey,
          'createdAt': createdAt,
        };
        txn.update(userRef, {'balanceKobo': balanceAfter});
        txn.update(goalRef, {'savedKobo': savedAfter});
        txn.set(paths.transactions(userRef.id).doc(ref), receipt);

        return right(MutationResultDto(
          ref: ref,
          balanceAfterKobo: balanceAfter,
          goal: _goalFrom(request.goalClientId, {...goalData, 'savedKobo': savedAfter}),
          transaction: _txnFrom(receipt),
        ));
      },
    );
  }
```

- [ ] **Step 4: Seeding and reset**

```dart
  /// A new account starts with the demo balance, history, beneficiaries and a
  /// goal. One batch: 1 user + 60 receipts + 4 beneficiaries + 1 goal, well
  /// inside Firestore's 500-write limit.
  Future<void> _seedNewUser(String uid, ProfileDto profile) async {
    final now = _clock();
    final seed = DemoSeed(hasher: hasher);
    final batch = firestore.batch();

    batch.set(paths.user(uid), {
      ...profile.toJson(),
      'balanceKobo': AppConstants.demoOpeningBalanceKobo,
      'createdAt': now.millisecondsSinceEpoch,
    });
    for (final row in seed.historyJson(profile.phone, now)) {
      batch.set(paths.transactions(uid).doc(row['ref'] as String), row);
    }
    for (final b in DemoSeed.beneficiaries) {
      batch.set(paths.beneficiaries(uid).doc('${b.bankCode}_${b.accountNumber}'), {
        'accountNumber': b.accountNumber,
        'bankCode': b.bankCode,
        'bankName': b.bankName,
        'accountName': b.accountName,
      });
    }
    batch.set(paths.goals(uid).doc('seed-goal-rent'), {
      'name': 'Rent — December',
      'targetKobo': 60000000,
      'targetDate': DateTime(2026, 12, 20).millisecondsSinceEpoch,
      'savedKobo': 21000000,
      'createdAt': now.subtract(const Duration(days: 45)).millisecondsSinceEpoch,
    });

    await batch.commit();
  }

  /// Developer panel → "Reset demo data": wipes history, goals and
  /// beneficiaries, then seeds them again. `processed` is left alone (the
  /// rules forbid deleting it, and stale keys are harmless).
  @override
  Future<void> resetDemo() async {
    final user = auth.currentUser;
    if (user == null) return;
    final snap = await paths.user(user.uid).get(_serverSource);
    final data = snap.data();
    if (data == null) return;

    // `processed` is create-once by rule and deliberately NOT wiped: the rules
    // forbid deleting it (that is the whole guarantee), and stale idempotency
    // records are harmless because every new intent gets a fresh uuid key.
    for (final collection in [
      paths.transactions(user.uid),
      paths.goals(user.uid),
      paths.beneficiaries(user.uid),
    ]) {
      final docs = await collection.get(_serverSource);
      final batch = firestore.batch();
      for (final doc in docs.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
    await _seedNewUser(user.uid, _profileFrom(data));
  }
}
```

- [ ] **Step 5: Checkpoint.** Report the files for the user to commit.

## B.5 Deltas to Amendment A's remaining sections

- **A.5 (auth repository):** unchanged — `identifier` instead of `phone`, and `signOut()` also calls `FirebaseAuth.instance.signOut()`.
- **A.6 (DI):** replace the Firebase branch with:

```dart
  if (backend == 'firebase' && backendOverride == null) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // NON-NEGOTIABLE: Firestore caching and its offline write queue are off, so
    // Isar stays the only cache and the only queue.
    FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
    final reachability = FirestoreBackendReachability(firestore: FirebaseFirestore.instance);
    final service = FirebaseNovaService(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      controls: sl(),
      hasher: sl(),
      reachability: reachability,
    );
    sl.registerSingleton<NovaApiService>(service);
    sl.registerSingleton<BackendAdmin>(service);
    sl.registerSingleton<BackendReachability>(reachability);
  } else { /* the fake branch from A.6, unchanged */ }
```
- **A.7 (tests):** the emulator command becomes `firebase emulators:start --only auth,firestore`, and the test setup becomes:

```dart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('10.0.2.2', 8080);
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
```
Same four ported cases, plus one Firestore-specific case worth having: **a second `create` of the same `processed/{key}` document is rejected by the rules**, proving the guarantee is enforced server-side even if a buggy client tried.
- **A.8 (docs):** the README's Backends section describes the Firestore shape and the create-once rule. It must also state the trust boundary honestly, before the panel asks: the rules make a *replayed* intent impossible (create-once `processed/{key}`) and shape-check money (`is int`, `>= 0`), but they cannot verify arithmetic — a client holding the user's own credentials could set its own balance. Production moves the mutation behind a trusted backend (Cloud Functions / a real core-banking API); here the client-side transaction is the deliberate, documented boundary of a take-home. Phrase the deck's "server-enforced" slide as *duplication is impossible*, not *tampering is impossible*. The `AI_USAGE.md` entry gains one sentence: *"We moved from Realtime Database to Firestore because a Firestore transaction spans multiple documents, which let the idempotency record become a create-once document enforced by security rules rather than a field inside a hand-managed node."*
- **A.9 (time):** unchanged. Firestore costs the same 3–5 hours and removes the single-node contortion, so if anything it is slightly quicker.
