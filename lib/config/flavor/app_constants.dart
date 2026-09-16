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

  /// Breaking a goal early (moving money out before its target amount or its
  /// target date) costs this share of the amount moved: 250 bps = 2.5%.
  static const int goalBreakFeeBps = 250;

  /// Hard ceiling for any typed amount (₦1,000,000,000.00) — keeps int math far
  /// from overflow.
  static const int maxAmountKobo = 100000000000;

  /// Quick-amount chips on the Send and Contribute amount screens
  /// (₦1,000 / ₦5,000 / ₦10,000 — design review D6).
  static const List<int> quickAmountsKobo = [100000, 500000, 1000000];

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
  static const String demoEmail = 'tolu.adeyemi@mail.com';
  static const String demoPassword = 'NovaPay#2026';
  static const String demoPin = '1234';

  /// Matches the demo banner drawn on the OTP artboard.
  static const String fakeOtp = '419372';

  static const String clientDbName = 'nova_client';
  static const String serverDbName = 'nova_fake_server';

  // ── Copy the brief requires verbatim ──────────────────────────────────────
  static const String offlinePendingCopy = 'Pending — will send when back online';
}
