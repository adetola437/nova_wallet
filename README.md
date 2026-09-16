# NovaWallet Mobile — Send & Save

A Flutter app for two NovaPay journeys: **sending money from NovaWallet** and **contributing to a NovaSave goal**. The interesting part is what happens when the network isn't reliable.

Built against **Flutter 3.44.1 (stable) / Dart 3.12**.

```bash
flutter pub get
dart run build_runner build          # Isar collections
flutter run                          # Firebase backend (default)
flutter run --dart-define=BACKEND=fake   # fully offline demo backend
flutter test                         # unit + widget tests
flutter test integration_test/offline_queue_sync_test.dart -d <device>
```

---

## The short version

Every transfer, goal and contribution is written to a **durable outbox in Isar before anything reaches the network**. A single sync engine drains that queue in FIFO order, one item at a time, and each item carries an **idempotency key created once and never regenerated**. The backend refuses to process a key twice. That combination — at-least-once delivery from the phone, deduplication on the server — is what makes a queued action arrive **exactly once**, including across an app restart, a lost response, or a flapping connection.

The phone alone cannot guarantee exactly-once. If the app dies after the server accepts a transfer but before it records the acknowledgement, the device has no way to know what happened. So the device does the only safe thing: it retries with the same key, and the server recognises it.

---

## Architecture

```
Screen (StatefulWidget controller + part view)   ← never touches a repository
        │
     Cubit                                        ← the only caller of repositories
        │
   Repository  (Either<Failure, T>)
        │
        ├── Isar (outbox, cache, ledger snapshot) · SecureStorage · SharedPreferences
        └── NovaApiService ──┬── FirebaseNovaService  (Auth + Cloud Firestore)
                             └── FakeNovaServer       (in-process, --dart-define=BACKEND=fake)
```

**State management: Bloc/Cubit.** Chosen because this app's hard problem is a state machine (`queued → sending → succeeded | failed`) driven by external events — connectivity, app lifecycle, server responses. Cubits give that an explicit, testable shape without the ceremony of full events, and `bloc_test` makes the sync engine's guarantees assertable. The layering mirrors an existing production app of mine, so the conventions are proven rather than invented for the exercise.

**One rule throughout:** repositories are injected into cubits and *only* cubits. Controllers, views and services never call them. It keeps the dependency direction obvious and the widget layer trivially testable.

### Where the money lives

| Concern | Home |
|---|---|
| Durable queue of user intents | Isar `OutboxItemEntity` |
| Cached ledger balance, transactions, goals, beneficiaries | Isar |
| Session token, PIN hash + salt | `flutter_secure_storage` |
| Locale, onboarding flag, biometric preference, demo switches | `SharedPreferences` |

**No token, PIN or secret is ever written to SharedPreferences** — an explicit constraint in the brief.

---

## The offline design

### One path

Online or offline, a send takes the same route: validate → **enqueue** → drain. There is no "send directly when online" branch, so there is no second code path to get wrong. Online simply means the queue empties in about a second.

### Holds, not optimism

`available = ledgerBalance − sum(active outbox debits)`. Holds are **derived from the queue**, never stored separately, so they cannot drift from the items that caused them. Three transfers queued offline against one balance is arithmetically impossible: the third is refused at enqueue time, inside the same Isar write transaction that would have saved it.

### The lifecycle

```
queued ──claim──► sending ──success──────────► succeeded   (ledger, receipt and item settle together)
   ▲                 │──business rejection───► failed      (hold released, reason shown, never retried)
   └── network error / timeout / 5xx ─────────┘ back to queued, SAME key, exponential backoff
```

Guarantees, and why each exists:

1. **The key is persisted before the first network call** and never regenerated for that item.
2. **Single flight.** `drain()` joins the pass already running, so a connection that flickers five times triggers one replay, not five.
3. **Claim before call.** An item moves to `sending` in its own transaction before the request goes out.
4. **Recovery on start.** Anything still `sending` after a restart goes back to `queued`, keeping its key.
5. **A timeout means "unknown", not "failed".** It is replayed with the same key; the server returns the original result.
6. **Strict FIFO, one at a time**, so a later send cannot overtake an earlier one and overspend.
7. **No retry loops.** Replays are triggered by reconnection, app resume, pull-to-refresh, enqueue, or a backoff timer — never a spin.
8. **A refresh never races a send.** Both take the same lock, so a balance read cannot overwrite the balance a send just applied.

### Server-side enforcement, stated honestly

On Firestore, one transaction reads `users/{uid}/processed/{key}` first; if that document exists, the stored response is returned and **no money moves**. Otherwise the balance, the goal, the receipt and that record are written **atomically**. Security rules then make the record permanent:

```
match /processed/{key} {
  allow read, create: if isOwner(uid);
  allow update, delete: if false;     // the guarantee, enforced by the server
}
```

**What this does and does not prove.** The rules make a *replayed intent* impossible and shape-check money (`is int`, `>= 0`). They cannot verify arithmetic: a client holding the user's own credentials could write its own balance. In production the mutation belongs behind a trusted backend (Cloud Functions or a real core-banking API); here the client-side transaction is the deliberate, documented boundary of a take-home. So: **duplication is impossible; tampering is not.**

### Why Firestore's own offline mode is switched off

Firestore persists writes and serves cached reads by default. Left on, it would keep a **second durable queue** underneath the outbox — the textbook way to send the same transfer twice — and a second cache underneath Isar. So `Settings(persistenceEnabled: false)`, every read with `Source.server`, and every call wrapped in a timeout, which turns an offline write into a plain `NetworkFailure` the sync engine already knows how to retry. Isar is the cache; Isar is the queue; Firestore is the wire.

---

## Money

`Money` holds **integer kobo**. No `double` holds, parses, sums or compares money anywhere in this app — including input parsing, fees, progress and the savings projection. `double.parse('0.29') * 100` is `28.999999999999996`, which truncates to 28 kobo; `KoboParser` splits on the decimal point and parses both halves as integers instead. There is a test named after that bug.

Savings progress is integer basis points. An over-saved goal honestly reads **104%** in text; only the bar width is capped.

---

## Accessibility and performance

- Layouts are tested at **200% system text** on a 360×640 surface. `flutter_screenutil` handles device scaling, but nothing containing text has a fixed height — rows grow instead of clipping.
- Amounts are announced as words ("twelve thousand five hundred naira, fifty kobo"), not digit-by-digit.
- Status is always **icon + label**, never colour alone, with tinted-background/darker-ink pairs that clear WCAG AA (there is a test asserting the contrast ratios).
- Every list uses `ListView.builder`/`SliverList.builder`, paginated out of Isar.
- No blur, no gradients behind text, and fonts are bundled rather than fetched at runtime — a runtime font fetch fails on exactly the low-end, badly-connected devices this app is for.

---

## Testing

| Layer | What it proves |
|---|---|
| Unit | Kobo parsing and formatting, fee bands, basis-point progress, semantics labels |
| Unit | The fake server: same key → same response, **one** balance change; stored rejections replay unchanged |
| Unit (`bloc_test`) | Sync engine: single flight under concurrent drains, recovery of interrupted items, lost-response replay, business failures release the hold, FIFO order, no attempts while offline |
| Unit | Outbox repository: atomic enqueue, the available-balance check under two rapid confirms, **crash-after-accept** |
| Widget | Send Money flow and NovaSave contribution, online and offline |
| Widget | 200% text with no overflow; Semantics labels present; Yorùbá renders without falling back |
| Integration | **Offline → app restart → reconnect → synced exactly once**, run against both backends |

---

## Assumptions

1. **"Idempotency key per attempt"** means one key per user-confirmed intent; automatic retries reuse it, and "Try again" after a failure is a new intent with a new key.
2. **Offline sends go only to saved beneficiaries** whose names were verified online and cached. A new account number needs a connection, because a name enquiry does.
3. **Fees** are fictional NIP-style bands in kobo: ≤ ₦5,000 → ₦10.75; ≤ ₦50,000 → ₦26.88; above → ₦53.75. NovaSave contributions are free.
4. **KYC tiers cap a single transfer only:** Tier 1 ₦100,000, Tier 2 (BVN) ₦1,000,000. No daily caps.
5. **Biometrics** are required at or above ₦50,000, falling back to PIN where the hardware is absent (the iOS Simulator has no Secure Enclave). The signature is generated by a real hardware-backed key; the mock backend does not verify it.
6. **Login is email + password**; the phone number is profile data collected at signup. A returning user unlocks **offline** with PIN or biometrics, since both live on the device.
7. **Dates fall back to English formatting under Yorùbá**, where `intl` has no `yo` symbols. Money is always ₦ with en-NG grouping.

---

## Trade-offs I would revisit with more time

- **Background sync** (`workmanager`) so a queued transfer goes out while the app is closed. Deliberately skipped: it is hard to demonstrate live and harder to test, and it does not change the guarantee.
- **Cancelling a queued transfer** before it sends — cheap to add (delete the row while it is still `queued`), left out to keep the state machine small.
- **Server-authoritative ledger** via Cloud Functions, which is the real answer to §"stated honestly" above.
- **Golden tests** for the wallet home. The font-scale and semantics tests cover the same ground more usefully for now.
- **Daily/cumulative KYC limits**, modelled in the UI copy but not enforced.

---

## Demo

The developer panel (Profile → Developer panel, demo builds) drives the live demonstration:

- **Simulate offline** — the backend becomes unreachable without touching the device's radios.
- **Lose next server response** — the server commits the transfer and the phone gets a timeout. This is the crash-after-accept case; the replay proves the guarantee.
- **Latency slider**, an **outbox viewer** showing attempts and truncated idempotency keys, and **Reset demo data**.

Seeded demo account: `tolu.adeyemi@mail.com` / `NovaPay#2026`, PIN `1234`, demo OTP `419372`, opening balance ₦250,000.00, 60 transactions, 4 beneficiaries and one savings goal.
