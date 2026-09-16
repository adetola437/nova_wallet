# NovaWallet Mobile — Send & Save: Design Spec

- **Date:** 2026-09-15
- **Brief:** FirstBank Digital Factory take-home, "NovaWallet Mobile — Send & Save" (Frontend Engineer — Mobile, Flutter)
- **Deadline:** submission 2:00 PM, Thursday 17 September 2026. A 10-minute live presentation with a PowerPoint deck saved under the candidate's name.
- **Target toolchain:** Flutter 3.44.1 (stable), Dart 3.12
- **Reference architecture:** Kiba (`~/Documents/mobile/kiba`)

---

## 1. What we are building and what is graded

This is a Flutter app for two NovaPay journeys: **sending money from NovaWallet** and **contributing to a NovaSave goal**. The hard part is behaviour on an unreliable network. Graded criteria, in the order we optimise for:

1. **Correctness.** Money is an integer number of kobo everywhere. Queued actions sync **exactly once**, even across an app restart.
2. **Offline/sync architecture.** The queue and its replay guarantee must be defensible.
3. **State and widget architecture.** A defensible state-management choice. We use Bloc/Cubit in the Kiba layering.
4. **Accessibility and performance.** Semantics, respect for the system font scale, `ListView.builder`.
5. **Test rigour.** Tests that catch regressions in the offline-sync path.
6. **AI fluency and judgment.** `AI_USAGE.md` with real cases where AI was wrong.
7. **Communication.** README, the deck and live defence. The panel will toggle airplane mode and may ask for live code changes.

### Goals
- Everything in brief §2.1 and §2.2.
- Stretch goals from the brief: **Yoruba localization** (whole app), **biometric-confirmation stub** above a threshold, **local notification when a queued action syncs**.
- Added product scope: **animated splash**, **onboarding PageView**, **create account (signup)**, **fake login**, **unlock for returning users**.

### Non-goals (documented as trade-offs)
- Golden tests. Dark mode. Background sync while the app is killed (`workmanager`). Daily or cumulative KYC limits. Withdrawing from a goal. Real "Add money" funding. A real HTTP backend or Dio client. Server-side verification of biometric signatures. USSD channel.

---

## 2. Assumptions (copied into the README)

| # | Assumption |
|---|---|
| A1 | **"Idempotency key per attempt"** means one key per *user-confirmed intent*. Automatic retries and replays of that intent reuse the key. A user tapping "Try again" on a failed item creates a new intent with a new key after re-confirming. |
| A2 | **Offline sends go only to saved beneficiaries** whose names were verified online (NIP name enquiry) and cached. Adding a new recipient requires connectivity. |
| A3 | **Reachability** in the demo is connectivity (`connectivity_plus`) AND NOT the in-app "Simulate offline" switch. A production build would also probe a health endpoint, because an attached interface does not mean working internet. |
| A4 | **The fake server keeps its own state** in a separate Isar instance. That state survives app restarts as a real backend would, so its idempotency record is durable. |
| A5 | **Transfer fees are fictional NIP-style bands in kobo:** ≤ ₦5,000.00 → ₦10.75; ₦5,000.01–₦50,000.00 → ₦26.88; > ₦50,000.00 → ₦53.75. Contributions to your own NovaSave goal are free. |
| A6 | **KYC tiers (single-transaction cap only):** Tier 1 (no BVN) is ₦100,000.00 per send. Tier 2 (BVN verified) is ₦1,000,000.00 per send. |
| A7 | **Biometric threshold:** sends **≥ ₦50,000.00** require biometric confirmation, falling back to PIN when biometrics are unavailable (e.g. the iOS Simulator). Sends below it require the transaction PIN. Every send and contribution is authorised. |
| A8 | **Login and signup need connectivity.** A returning user with a stored session can **unlock offline** with PIN or biometrics. |
| A9 | **A new account is credited with a demo balance** of ₦250,000.00 and seeded with about 60 historical transactions and 4 saved beneficiaries, so list performance and offline sends can be shown at once. A seeded demo account also exists (see §6.4). |
| A10 | **Dates in Yoruba** fall back to English formatting where `intl` has no `yo` date symbols. Money is always `₦` with en-NG digit grouping. |

---

## 3. Architecture

### 3.1 Layering (Kiba), with one non-negotiable rule

```
Screen (StatefulWidget = Controller, implements <X>ControllerContract)
   └─ View (part file, implements <X>ViewContract, StatelessWidget)
        │  reads/calls
        ▼
     Cubit  ──(may depend on other cubits, as Kiba's WalletCubit(authCubit:))
        │  ONLY cubits call repositories (repositories are injected into cubits)
        ▼
   Repository (interface I<X>Repository → <X>RepositoryImpl), returns Either<Failure, T>
        │
        ├─ Local data source: Isar (client DB), SharedPreferences, SecureStorage
        └─ Remote data source: NovaApiService → FakeNovaServer (in-process)
```

- **Controllers and views never touch a repository**, `NovaApiService` or Isar.
- **Core services** (`NetworkInfo`, `BiometricGate`, `LocalNotificationService`) are injected into cubits or repositories, never into widgets.
- **DI** uses GetIt in `AppInitializer` in dependency order: core → repositories → cubits. App-wide state uses lazy singletons. Per-flow state uses factories (as Kiba's `PurchaseCubit`).
- **Routing** uses `go_router`, with a redirect guard driven by `AuthCubit`.

### 3.2 Folder structure

```
lib/
  main.dart
  config/
    di/app_initializer.dart
    flavor/app_constants.dart           thresholds, fee bands, tier caps, demo seed
  core/
    api/
      exception/failure.dart            Failure, NetworkFailure (retryable), BusinessFailure (terminal), ValidationFailure
      service/nova_api_service.dart     remote contract (auth, wallet, transfers, savings, name enquiry)
      fake/fake_nova_server.dart        implements NovaApiService
      fake/fake_server_controls.dart    simulate offline, lose next response, latency
      fake/server_models.dart           Isar collections for the "remote"
    auth/
      biometric_signer.dart             copied from Kiba (alias renamed)
      biometric_gate.dart               interface + SignerBiometricGate
      pin_hasher.dart                   salted SHA-256 via `crypto`
    l10n/                               ARB files + generated AppLocalizations + yo fallback delegates
    models/                             domain models (Money, Beneficiary, WalletSnapshot, OutboxItem view, Goal…)
    money/
      money.dart                        from Kiba (int kobo, exact formatting)
      kobo_parser.dart                  "1,500.5" → 150050, no double
      fees.dart                         fee band lookup (kobo)
      progress.dart                     basis-points progress
      money_semantics.dart              "twelve thousand five hundred naira, fifty kobo" (en + yo)
    navigation/app_router.dart, nav_keys.dart
    network/network_info.dart, network_info_impl.dart
    notifications/local_notification_service.dart
    storage/
      isar_db.dart                      opens client + server instances (injectable directory for tests)
      local_storage.dart / _impl.dart   SharedPreferences: locale, onboardingSeen, biometricEnabled, dev flags
      secure_storage.dart / _impl.dart  session token, PIN hash + salt
    theme/app_colors.dart, app_text_styles.dart, app_theme.dart   (tokens from Claude Design)
    utils/contract.dart, formatters.dart
    widgets/                            offline banner, status pill, amount text, PIN pad, skeletons, app bar, buttons
  features/
    splash/  onboarding/  auth/  (signup, login, unlock)
    home/    wallet/      transactions/
    beneficiaries/        send_money/
    savings/              (NovaSave)
    profile/              (settings, developer panel, outbox viewer)
    sync/                 SyncCubit + OutboxRepository
```

Each feature follows Kiba: `cubit/`, `repository/`, `presentation/{contracts,controllers,views,widgets}`.

### 3.3 Cubits

| Cubit | Scope | Depends on | Responsibility |
|---|---|---|---|
| `AuthCubit` | singleton | `IAuthRepository` | Session: `unknown → onboarding → unauthenticated → locked → authenticated`. Sign-out wipes client data. |
| `SignupCubit` | factory | `IAuthRepository` | Phone → OTP → details → BVN → PIN |
| `LoginCubit` | factory | `IAuthRepository`, `AuthCubit` | Phone + password, biometric login |
| `UnlockCubit` | factory | `IAuthRepository`, `BiometricGate`, `AuthCubit` | Offline-capable PIN or biometric unlock |
| `LocaleCubit` | singleton | `ISettingsRepository` | en / yo, persisted |
| `ConnectivityCubit` | singleton | `NetworkInfo`, `FakeServerControls` | `online` / `offline`, debounced 1 s |
| `SyncCubit` | singleton | `IOutboxRepository`, `ConnectivityCubit`, `LocalNotificationService` | Drain, recovery, backoff, pending summary |
| `WalletCubit` | singleton | `IWalletRepository`, `SyncCubit` | Balance snapshot, available balance, recent transactions (Isar watch), refresh |
| `BeneficiariesCubit` | singleton | `IBeneficiaryRepository` | Saved recipients |
| `NameEnquiryCubit` | factory | `IBeneficiaryRepository`, `ConnectivityCubit` | New recipient verify and save |
| `SendMoneyCubit` | factory | `IOutboxRepository`, `IWalletRepository`, `SyncCubit`, `BiometricGate`, `IAuthRepository` | Recipient, amount, fee, validation, authorise, enqueue, outcome |
| `SavingsCubit` | singleton | `ISavingsRepository` | Goals list and progress (Isar watch) |
| `CreateGoalCubit` | factory | `IOutboxRepository`, `SyncCubit` | Create goal (queued like any action) |
| `ContributeCubit` | factory | `IOutboxRepository`, `IWalletRepository`, `SyncCubit`, `IAuthRepository` | Contribute amount, authorise, enqueue |
| `TransactionDetailCubit` | factory | `IWalletRepository`, `IOutboxRepository` | Timeline for one transaction |
| `BiometricSettingsCubit` | factory | `ISettingsRepository`, `BiometricGate` | Enable/disable |
| `DeveloperCubit` | singleton | `IDeveloperRepository` | Simulate offline, lose next response, latency, reset demo, outbox list |

Repositories: `IAuthRepository`, `ISettingsRepository`, `IWalletRepository`, `IBeneficiaryRepository`, `ISavingsRepository`, `IOutboxRepository`, `IDeveloperRepository`.

---

## 4. Data model

### 4.1 Client Isar instance (`nova_client`)

- **`OutboxItemEntity`**
  - Identity and payload: `id` (auto) · `idempotencyKey` (String, **unique index**, uuid v4) · `type` (`send | createGoal | contribute`) · `payloadJson` (all amounts are int kobo)
  - Money fields: `amountKobo` (int) · `feeKobo` (int) · `debitKobo` = amount + fee (int) · `goalClientId` (nullable)
  - State: `status` (`queued | sending | succeeded | failed`, indexed) · `attempts` (int, counts only attempts that reached the network) · `nextAttemptAt` (DateTime?)
  - Timestamps: `createdAt` (indexed, FIFO order) · `lastAttemptAt` · `completedAt`
  - Results and flags: `serverRef` · `failureCode` · `failureMessage` · `queuedWhileOffline` (bool, drives notification) · `biometricSignature` (String?, stub)
- **`WalletSnapshotEntity`**: single row. `ledgerBalanceKobo` (last server-confirmed) · `lastSyncedAt`.
- **`TransactionEntity`**: cache of server transactions. `serverRef` (unique) · `direction` · `amountKobo` · `feeKobo` · `counterpartyName` · `bankName` · `maskedAccount` · `narration` · `createdAt` (indexed) · `kind` (`transfer | contribution | credit`).
- **`BeneficiaryEntity`**: `accountNumber` + `bankCode` (composite unique) · `verifiedName` · `bankName` · `verifiedAt` · `lastUsedAt`.
- **`GoalEntity`**: `clientId` (uuid, unique) · `name` · `targetKobo` · `targetDate` · `savedKobo` (server-confirmed) · `synced` (bool).

### 4.2 Fake-server Isar instance (`nova_fake_server`)

`ServerAccount` (phone unique, name, email, passwordHash + salt, tier, bvnVerified, balanceKobo), `ServerTransaction`, `ServerGoal`, `ServerBeneficiaryDirectory` (a fixed bank/account → name table for name enquiry), and **`ProcessedRequest`** (`idempotencyKey` unique, `responseJson`, `processedAt`).

### 4.3 Secure storage vs SharedPreferences

- **Secure storage:** session token (mock JWT-like string), PIN hash + salt, biometric key id.
- **SharedPreferences:** locale, `onboardingSeen`, `biometricEnabled`, developer flags. Nothing sensitive, which is an explicit brief constraint.

### 4.4 Derived values (never stored)

- `pendingDebitKobo` = Σ `debitKobo` of outbox items with status ∈ {queued, sending} and type ∈ {send, contribute}.
- `availableKobo` = `ledgerBalanceKobo − pendingDebitKobo`.
- For goal *g*, `goalPendingKobo` = Σ `amountKobo` of active contribute items with `goalClientId == g`.

Holds are **derived from the outbox**, not stored separately, so a hold can never drift out of sync with the item that caused it.

---

## 5. Offline queue and the exactly-once guarantee

### 5.1 Rule 0: one path

Every send, goal creation and contribution goes through the outbox, online or offline. There is no "send directly" branch.

### 5.2 Enqueue (in `IOutboxRepository`, called only by cubits)

One Isar write transaction:
1. Re-reads `ledgerBalanceKobo` and active outbox debits, and rejects with `ValidationFailure(insufficientAvailable)` if `debitKobo > availableKobo`. The check runs inside the transaction, so two rapid confirms cannot both pass.
2. Inserts an `OutboxItemEntity` with a fresh uuid v4 `idempotencyKey`, `status = queued`, and `queuedWhileOffline = !online`.

The cubit then calls `syncCubit.drain()`.

### 5.3 Lifecycle

```
queued ──claim (txn)──► sending ──success────────────► succeeded
  ▲                        │                           (same txn: ledger balance := server balanceAfter,
  │                        │                            upsert TransactionEntity / GoalEntity, completedAt)
  │                        ├──BusinessFailure──────────► failed  (hold released by derivation; reason stored)
  └──NetworkFailure / timeout / 5xx: attempts++, nextAttemptAt = now + min(2^attempts s, 60 s)
```

### 5.4 Guarantees

1. **The key is persisted before any network call** and is never regenerated for that item.
2. **Single flight.** `SyncCubit.drain()` stores a `Future? _inFlight`. Concurrent callers get the same future, and when it completes a queued-trigger flag causes one more pass if new triggers arrived meanwhile.
3. **Claim before call.** The status moves to `sending` in its own transaction before `NovaApiService` is invoked.
4. **Recovery.** On startup (splash), all `sending` items move back to `queued`, keeping their key, before the first drain.
5. **Unknown outcome (timeout) means retry with the same key, not failure.** `FakeNovaServer` checks `ProcessedRequest` first and returns the stored response for a known key without moving money again.
6. **Strict FIFO, one item at a time**, ordered by `createdAt`. A terminal failure does not block later items. If the head item is backing off, later items wait: ordering matters more than throughput for balance correctness.
7. **No loops.** Triggers are: connectivity regained (debounced), app resumed, pull-to-refresh, enqueue, and the backoff timer for the earliest `nextAttemptAt`. While offline, drain returns immediately and does not count attempts.
8. **Refresh never races sync.** `WalletCubit.refresh()` awaits `syncCubit.drain()` before fetching the snapshot. The ledger balance is therefore never fetched while an item is `sending`, which would double-count its hold.
9. **Persistent retryable trouble.** After 8 online attempts the item stays `queued` (the money state is unknown, so it must not be marked failed). The UI shows "Having trouble sending — we'll keep trying" with a "Contact support" affordance.
10. **Dependency.** A contribution to an unsynced goal waits behind its `createGoal` item (FIFO). If goal creation fails, the server rejects the contribution with `goalNotFound`, so it is marked `failed` and its hold is released.

### 5.5 Notifications

On `sending → succeeded` or `→ failed`, if `queuedWhileOffline` is true or the app is backgrounded, `LocalNotificationService` shows, for example, "₦5,000.00 sent to Ada Obi" or "Transfer to Ada Obi failed: insufficient funds". Tapping opens the transaction details. The Android 13+ notification permission is requested the first time an item is queued offline.

### 5.6 The fake server (`FakeNovaServer implements NovaApiService`)

- Every call first checks `FakeServerControls.simulateOffline` or the absence of real connectivity, and throws `NetworkFailure` without touching state.
- Latency is 400–1200 ms by default, adjustable in the developer panel.
- **Mutating calls** (`transfer`, `createGoal`, `contribute`) run in one server transaction:
  - A known key returns the stored response.
  - Otherwise the server validates (balance, tier cap, goal exists), applies the change, and stores the `ProcessedRequest`.
  - Business rejections are stored too, so a replay returns the same rejection.
- **"Lose next response"** commits the server transaction and then throws a timeout `NetworkFailure`. This is the crash-after-accept case, used in the demo and tests.

---

## 6. Screens and flows

### 6.1 Launch and auth

```
Splash ─► onboardingSeen? no ─► Onboarding ─► Create account ─► Home
   │                              └─ "I have an account" ─► Login ─► Home
   └─► session stored? yes ─► Unlock (PIN / biometric, offline OK) ─► Home
       session stored? no  ─► Login
```

| Screen | Content |
|---|---|
| Splash | Native launch screen, then a Flutter animation of the NovaPay mark (under 1 s). Runs session restore and outbox recovery. |
| Onboarding | 3-page `PageView` with skip, dots and CTA. (1) "Send money in seconds", (2) "Save towards what matters", (3) "Works even when network is bad". Final page: Create account / I have an account. |
| Phone | +234 prefix, 11-digit NG number check |
| OTP | 6-digit `pinput`, 60 s resend timer, **dev banner shows the fake code** |
| Your details | Full name, email, password (≥ 8 chars, strength hints), terms and privacy consent checkbox (NDPA) |
| BVN (optional) | 11 digits, fake verification → Tier 2. Skip → Tier 1, with an explanation of limits. |
| Create PIN | 4 digits, entered twice; the hash goes to secure storage |
| Login | Phone + password; "Use biometrics" if enabled; "Create account" link. Needs connectivity. |
| Unlock | Greeting with first name, PIN pad, biometric button, "Not you? Sign out". Works offline. |

### 6.2 Main shell (bottom navigation: Home · NovaSave · Profile)

**Home**
- **Balance card:** hide/show toggle (masked `••••••`), **Available ₦X** as the dominant figure, "₦Y on hold for N pending" as secondary, and a sync chip ("2 pending — will send when back online" offline, "Sending…" online).
- **Quick actions:** Send, Save, Add money (placeholder sheet).
- **Recent transactions:** `ListView.builder` inside a `RefreshIndicator` (a `CustomScrollView` with `SliverList.builder`). Pending and failed outbox items appear first, then cached server transactions. Each row: avatar initial, name, date, signed amount, and a status pill with icon **and** text.
- **Offline banner:** persistent at the top of the shell while offline, as a live region.
- **States:** skeletons on first load, empty state, and a stale-data note ("Last updated 14:02") when the refresh fails.

**Send Money**
1. **Recipient:** saved beneficiaries (search, recent first) and a "New recipient" row. Offline, that row is disabled with an explanation.
2. **New recipient:** bank picker (a fixed list of NG banks), 10-digit account number, automatic name enquiry, verified-name confirmation, and "Save beneficiary" (on by default).
3. **Amount:** large amount input (parsed as text to kobo) with Available shown under it, quick chips (₦1,000 / ₦5,000 / ₦10,000), optional narration (max 50 chars), live fee line and inline errors (exceeds available, exceeds tier cap, below minimum ₦100.00).
4. **Review:** recipient name, bank, masked account, amount, fee, **total debit**, balance after. When offline: "You're offline. This transfer will be queued and sent automatically when you're back online." CTA "Send ₦X".
5. **Authorise:** PIN sheet if below ₦50,000.00; biometric prompt if at or above it, with fallback to PIN.
6. **Result:**
   - **Sent** when succeeded within 8 s.
   - **Pending — will send when back online** when offline.
   - **Processing** when online but slow, with the note "we'll notify you".
   - **Failed** with a plain-language reason and "Try again", which restarts at Review with a new key.
   - Every result offers "Done" and "View details".
7. **Transaction details:** status timeline (Queued → Sending → Completed / Failed), reference, date, fee, masked account. The shortened idempotency key appears in debug builds only.

**NovaSave**
- **Goals list:** a card per goal with name, a two-segment progress bar (confirmed and pending), percentage, and "₦saved of ₦target". An empty state has the CTA "Create a goal".
- **Create goal:** name, target amount, target date (must be in the future), and a suggested weekly amount calculated with whole numbers (`ceil(remainingKobo / weeksLeft)`). Queued like any action.
- **Goal details:** big percentage, progress bar, days left, contribution history (`ListView.builder`) and a "Contribute" CTA.
- **Contribute:** bottom sheet with amount, "From NovaWallet · Available ₦X", PIN, then queued. Offline copy uses the same "Pending — will send when back online" wording.

**Profile**
- **Settings:** name, phone and tier; Language (English / Yorùbá, instant switch); Biometrics toggle; Sign out.
- **Developer panel** (visible in debug builds and via a 7-tap easter egg in release): Simulate offline · Lose next response · Latency slider · Outbox viewer (status, key, attempts) · Reset demo data.

### 6.3 Biometric stub (`BiometricGate`)

```dart
abstract class BiometricGate {
  Future<bool> isAvailable();
  Future<Either<BiometricSignerError, String>> confirm({required String payload, required String reason});
}
```

`SignerBiometricGate` wraps Kiba's `BiometricSigner`. A key is created when the user enables biometrics. `confirm` signs `"$idempotencyKey|$debitKobo"` and stores the signature on the outbox item. **The fake server does not verify it** (stub, documented). If the gate is unavailable or `keyMissing`, the flow falls back to PIN. If `canceled`, the user returns to Review silently. Tests use `FakeBiometricGate`.

### 6.4 Demo seed

- **Seeded account:** phone `08012345678`, password `NovaPay#2026`, PIN `1234`, Tier 2, ₦250,000.00, 60 transactions, 4 beneficiaries, 1 goal ("Rent — December", target ₦600,000.00, 35% saved).
- "Reset demo data" in the developer panel restores this.

---

## 7. Money

- The only money type is `Money(int kobo)`, ported from Kiba. **A `double` never holds money**, including in input parsing, fees, progress, the suggested weekly amount and semantics labels.
- **`KoboParser.parse(String)`**:
  - Strips `₦`, spaces and commas.
  - Accepts up to 2 decimal places; `"1,500.5"` becomes `150050`. Rejects more than 2 decimals, negatives and non-digits.
  - Caps at ₦1,000,000,000.00 to prevent overflow.
  - Splits on `.` and computes with `int.parse`.
- **Progress:** `bps = min(10000, savedKobo * 10000 ~/ targetKobo)`, displayed as `Bps.format` (Kiba). The bar fraction for the widget is `bps / 10000`, conversion at the paint edge only.
- **Known AI trap to document:** Kiba's `WithdrawAmountController` uses `double.tryParse` and `toStringAsFixed`, the naive pattern the brief warns about.

---

## 8. Accessibility, responsiveness and performance

- **flutter_screenutil stays** (Kiba), with `ScreenUtilInit(designSize: 375×812, minTextAdapt: true, fontSizeResolver: <clamped>)`. The system font scale is still honoured on top of `.sp`.
  - **No fixed `.h` height on any widget containing text.** Use `BoxConstraints(minHeight: 48.h)` instead.
  - `.h` and `.w` are fine for spacing, icons and decorative sizes.
  - The `.sp` resolver is clamped so screen-size scaling times a 2.0 user scale cannot overflow on large devices.
- **Semantics:**
  - Every interactive element has a label and hint. Tap targets are at least 48 dp.
  - Amounts use `Semantics(label: moneySemantics(kobo, locale))`. The balance toggle announces "Balance hidden" or "Balance shown".
  - Status pills read, e.g., "Pending, will send when back online".
  - The offline banner and result screens use `liveRegion: true`. PIN pad digits have labels, and the entered count is announced without revealing digits.
  - Decorative illustrations are excluded from semantics.
- Contrast meets WCAG AA. Status is never shown by colour alone.
- **Performance:**
  - Lists use `ListView.builder` or `SliverList.builder`. Isar queries are paginated (50 per page, loaded as the user scrolls).
  - No blur, no large images, no Lottie. The splash animation uses a single `AnimationController`. Fonts are bundled locally (no runtime `google_fonts` fetch).

---

## 9. Localization (English + Yorùbá)

- `flutter gen-l10n` with `app_en.arb` and `app_yo.arb` covers **all screens**.
- **`GlobalMaterialLocalizations` and `GlobalCupertinoLocalizations` do not support `yo`.** Custom fallback delegates provide English Material and Cupertino strings when the locale is `yo`, which prevents the "No MaterialLocalizations found" crash. A widget test pumps the app in `yo`.
- The locale is persisted by `LocaleCubit` through `ISettingsRepository` (SharedPreferences). The default is the device locale if it is `yo`, otherwise `en`.
- **Font requirement:** full Yoruba coverage (ẹ ọ ṣ with combining tone marks). Acceptance string: `Ẹ káàbọ̀ sí NovaPay — Ṣé o fẹ́ fi owó ránṣẹ́?`
- Layouts allow 40% longer strings.
- **Yoruba strings are AI-drafted and reviewed by the candidate.** Corrections are logged in `AI_USAGE.md`.

---

## 10. Error handling

| Failure | Where | User sees |
|---|---|---|
| `NetworkFailure` on enqueue-time checks | never; enqueue is local | — |
| `NetworkFailure` during drain | `SyncCubit` | Item stays Pending; banner or chip |
| `BusinessFailure` (insufficient funds, tier cap, invalid account, goal not found) | `SyncCubit` → item failed | Failed row and details with reason; notification if queued offline |
| `ValidationFailure` (available exceeded, bad amount, bad date) | Send/Contribute/CreateGoal cubits | Inline field error |
| Name enquiry offline or failure | `NameEnquiryCubit` | "Connect to the internet to add a new recipient" / "We couldn't verify this account" |
| Login/signup offline | `LoginCubit` / `SignupCubit` | Inline banner with retry |
| Wrong PIN ×3 | `UnlockCubit` / authorise | 30 s cooldown; after 5, sign out |
| Isar open failure | `AppInitializer` | Full-screen error with "Restart app" |

---

## 11. Testing

| Layer | File(s) | Asserts |
|---|---|---|
| Unit | `money_test`, `kobo_parser_test`, `fees_test`, `progress_test`, `money_semantics_test` | Exact kobo results, rejections, band edges (₦5,000.00 / ₦5,000.01), bps cap, large values |
| Unit | `fake_nova_server_test` | Same key → same response and one balance change; rejection stored and replayed; lose-next-response commits |
| Unit (`bloc_test`) | `sync_cubit_test` | Single flight under 5 concurrent `drain()`; recovery of `sending`; timeout → same key → one debit; business failure releases hold; FIFO; no attempts while offline; backoff scheduling |
| Unit | `outbox_repository_test` | Atomic enqueue; available-balance check under two rapid enqueues |
| Widget | `send_money_flow_test` | Recipient → amount validation → review → PIN → **Sent**; offline → **Pending — will send when back online**; new recipient disabled offline; ≥ ₦50k uses `FakeBiometricGate` |
| Widget | `novasave_contribute_test` | Contribute updates progress; pending segment; offline queues |
| Widget | `text_scale_test` | Home, Amount, Review, Goal details at `textScaler 2.0` on 360×640: no overflow exceptions; key semantics labels present |
| Widget | `yoruba_locale_test` | App pumps in `yo` without a localization crash; Send screen strings are Yoruba |
| Integration | `integration_test/offline_queue_sync_test.dart` | Offline → send + contribute to the seeded goal → **dispose Isar and GetIt, rebuild from the same directory** (restart) → items still queued → online plus connectivity flap plus two concurrent drains → server `ProcessedRequest` count == 2, balance debited exactly once each, items succeeded. Plus a lose-next-response variant. |

Isar in tests uses `Isar.initializeIsarCore(download: true)` and a temp directory.

---

## 12. Deliverables

1. **Git repository.** Created and pushed **by the candidate** (the assistant performs no git operations).
2. **`README.md`:** architecture diagram and layering rule, state-management rationale, outbox and exactly-once argument, trade-offs and non-goals, assumptions (§2), how to run (`flutter pub get && dart run build_runner build && flutter run`) and test, targeted Flutter/Dart versions, demo account.
3. **`AI_USAGE.md`:** tools used, 2–3 concrete prompts and outputs, and at least one wrong or risky output caught (planned candidates: double-based amount parsing; a queue draft that regenerated keys or allowed concurrent replays; Yoruba diacritic errors).
4. **Tests** per §11.
5. **PowerPoint deck** (about 10 slides, 10 minutes) saved under the candidate's name: context → prioritisation → architecture → outbox lifecycle → exactly-once proof → money in kobo → accessibility and screenutil → testing → AI judgment → trade-offs and next steps. Then the live demo: airplane mode → queue → restart → reconnect → one debit plus notification.

---

## 13. Delivery order

1. **Claude Design canvas** (NovaPay sub-brand, fintech rules, all screens in §6 including offline, pending, failed and Yoruba variants) → candidate review.
2. Implementation plan (writing-plans).
3. Setup: packages, DI, Isar (client and server), theme tokens, l10n scaffolding, Money and tests.
4. **Fake server, outbox and `SyncCubit`, with unit tests (graded core first).**
5. Splash, onboarding and auth → Home → Send → NovaSave → biometric stub → notifications → Profile and developer panel.
6. Widget and integration tests, text-scale pass, Yoruba review.
7. README, AI_USAGE, deck, emulator dry run, submission before 2:00 PM Thursday.

---

## 14. Design direction (input to Claude Design)

- **Brand:** a *NovaPay* sub-brand of the fictional FirstBank Digital Factory product. Deep navy primary with a warm gold accent. **No FirstBank logo or trademarks.**
- **Fintech rules:**
  - The key amount on each screen is dominant, in tabular figures, always `₦` with 2 decimals.
  - Review screens show fee and total before any authorisation.
  - Masked account numbers and a balance hide toggle.
  - Calm, trustworthy tone; no dark patterns, no urgency tricks.
  - Human error copy that says what to do next.
  - Status (Pending / Sending / Sent / Failed) shown with icon and text, with distinct but accessible colours.
  - An offline state that is **reassuring, not alarming**.
- **Constraints:** 48 dp minimum targets; AA contrast; layouts that survive 200% text and 40% longer Yoruba strings; low-end Android friendly (flat surfaces, no blur or heavy imagery); Yoruba-capable typeface; Material 3 base.
- **Artboards:**
  - Splash, onboarding ×3, phone, OTP, details, BVN, PIN, login, unlock.
  - Home (online, offline with pending, empty, loading).
  - Send: recipient (online / offline), new recipient, amount (valid / error), review (online / offline), PIN sheet, biometric prompt, results ×4, transaction details.
  - NovaSave: list, create, details, contribute sheet.
  - Profile, developer panel.
  - Home and Send amount in Yorùbá; Home at 200% text.
