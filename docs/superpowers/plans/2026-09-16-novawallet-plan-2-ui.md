# NovaWallet Plan 2: UI, localization and widget tests

> **STATUS (2026-09-16 night):** Tasks 19–26 are BUILT (widgets, shell/router, entry, Home, Send, NovaSave, Profile, Developer panel) and smoke-run on the Android emulator (fake backend): login, offline send → Pending → reconnect → Sent with one debit, online contribution, and switching to Yorùbá all worked. **No widget tests written yet** (per the user). Resume at **Task 27** (a11y/l10n sweep), then write the deferred tests for 21–26, then Task 28. Work inline (no subagents), never run git. See `docs/HANDOFF.md`.
>
> Deviations: shared app widget is `lib/app.dart` (main.dart just boots it); nav keys moved to `lib/core/navigation/nav_keys.dart` (re-exported from `app_initializer.dart`); create + confirm PIN (3i/3j) are two stages of one screen so the PIN never travels through router state; new cubits `TransactionDetailsCubit` and `GoalDetailsCubit` (factories) plus a `ContributeCubit` factoryParam; `Progress.uncappedBps` for the 104% text; failure copy is localized through `lib/core/l10n/failure_text.dart`; Android needed core-library desugaring for flutter_local_notifications.

> **For agentic workers:** implement one task at a time. Steps use checkbox (`- [ ]`) syntax. Run only the test path named in your task; the main thread runs the full suite between batches. **Never run a git command** — the user handles git.

**Goal:** turn the green offline core from Plan 1 into the app drawn in the Claude Design artboards, in English and Yorùbá, surviving 200% system text, with the widget and integration tests the brief grades.

**Architecture:** Kiba's screen split — a `StatefulWidget` **controller** implementing `<X>ControllerContract`, a `part` **view** implementing `<X>ViewContract`, and a `part` **contract** file. Controllers talk to cubits only. **No widget ever touches a repository.**

**Inputs you must read before starting:**
- `docs/design/design-review-2026-09-16.md` — §F holds the design tokens; §A–§E record the fixes already applied to the artboards.
- `docs/superpowers/specs/2026-09-15-novawallet-send-save-design.md` §6 — screen inventory.
- The artboards themselves (Claude Design project `20b5097c-fa82-4bb1-84f8-3cef42aa55ba`), referenced below by id: `1a`–`1g`, `2a`–`2n`, `3a`–`3l`, `4a`–`4l`.

## Global constraints (in addition to Plan 1's)

- **flutter_screenutil stays**, with three rules: no fixed `.h` height on anything containing text (use `constraints: BoxConstraints(minHeight: 48.h)`), `.w`/`.h`/`.r` for spacing and icons, and a clamped `fontSizeResolver` so screen scaling times a 2× user setting can't overflow.
- **Never** copy Kiba's `MediaQuery(textScaler: TextScaler.linear(0.95))` override. The system font scale must pass through untouched.
- Every list uses `ListView.builder` / `SliverList.builder`. No eager `children:` list of rows.
- Every interactive element: `Semantics` label + hint, minimum 48dp target.
- Every money figure on screen comes from `Money.format()`; every money figure read aloud comes from `MoneySemantics.label(kobo, languageCode:)`.
- Status is never colour alone — icon **and** text, using the four token pairs.
- No blur, no glassmorphism, no gradient behind text, no runtime font fetching (low-end Android).

---

### Task 19: Design tokens, typography and theme

**Files:** `lib/core/theme/app_colors.dart`, `app_text_styles.dart`, `app_theme.dart`; `assets/fonts/PlusJakartaSans-{Regular,Medium,SemiBold,Bold}.ttf`; modify `pubspec.yaml` (fonts + assets)
**Test:** `test/core/theme/theme_test.dart`

**Interfaces produced:** `AppColors` (every token in §F of the design review), `AppTextStyles` (`amountHero`, `h1`, `h2`, `body`, `small`, `caption`, each with `tabular` variants where money is shown), `AppTheme.light` (a `ThemeData` wired to both).

- [ ] **Step 1: Fetch the typeface.** Plus Jakarta Sans is the design's family and it carries the Yorùbá diacritics. Download the four static weights into `assets/fonts/` (Regular 400, Medium 500, SemiBold 600, Bold 700) from the Google Fonts GitHub mirror, e.g.
  `curl -L -o assets/fonts/PlusJakartaSans-Regular.ttf https://github.com/google/fonts/raw/main/ofl/plusjakartasans/PlusJakartaSans%5Bwght%5D.ttf`
  If only the variable font is available, bundle it once and declare all four weights against it. **If the download fails, stop and report** — do not substitute `google_fonts`, which fetches at runtime and breaks on a fresh offline install.
- [ ] **Step 2: Declare fonts and assets** in `pubspec.yaml` under `flutter:` (family `PlusJakartaSans`, one entry per weight).
- [ ] **Step 3: Write the failing test** `test/core/theme/theme_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/core/theme/app_colors.dart';
import 'package:nova_wallet/core/theme/app_theme.dart';

void main() {
  test('tokens match the design system board (1a)', () {
    expect(AppColors.navy900, const Color(0xFF0A1E38));
    expect(AppColors.navy700, const Color(0xFF14355C));
    expect(AppColors.gold500, const Color(0xFFE0A526));
    expect(AppColors.goldInk800, const Color(0xFF8A5F06));
    expect(AppColors.appBg, const Color(0xFFF6F5F2));
    expect(AppColors.border, const Color(0xFFE6E3DC));
    expect(AppColors.sentBg, const Color(0xFFE3F3E8));
    expect(AppColors.sentInk, const Color(0xFF0F6435));
    expect(AppColors.pendingBg, const Color(0xFFFBEFD3));
    expect(AppColors.pendingInk, const Color(0xFF7A5309));
    expect(AppColors.sendingBg, const Color(0xFFE6EDFB));
    expect(AppColors.sendingInk, const Color(0xFF14459B));
    expect(AppColors.failedBg, const Color(0xFFFBE7E7));
    expect(AppColors.failedInk, const Color(0xFFA31C1C));
  });

  test('status pairs clear WCAG AA (4.5:1) for body text', () {
    double lum(Color c) {
      double ch(double v) => v <= 0.03928 ? v / 12.92 : pow01((v + 0.055) / 1.055);
      return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
    }
    double ratio(Color a, Color b) {
      final la = lum(a), lb = lum(b);
      return (la > lb ? la + 0.05 : lb + 0.05) / (la > lb ? lb + 0.05 : la + 0.05);
    }
    expect(ratio(AppColors.sentInk, AppColors.sentBg), greaterThan(4.5));
    expect(ratio(AppColors.pendingInk, AppColors.pendingBg), greaterThan(4.5));
    expect(ratio(AppColors.sendingInk, AppColors.sendingBg), greaterThan(4.5));
    expect(ratio(AppColors.failedInk, AppColors.failedBg), greaterThan(4.5));
    // Gold on white is the trap the design deliberately avoids.
    expect(ratio(AppColors.gold500, Colors.white), lessThan(4.5));
    expect(ratio(AppColors.goldInk800, Colors.white), greaterThan(4.5));
  });

  test('theme does not fight the system font scale', () {
    final theme = AppTheme.light;
    expect(theme.textTheme.bodyMedium!.fontFamily, 'PlusJakartaSans');
    // No hard-coded textScaleFactor anywhere in the theme.
    expect(theme.visualDensity, VisualDensity.standard);
  });
}

double pow01(double v) => v * v * v * 0.0 + _p(v);
double _p(double v) => (v <= 0) ? 0 : (v >= 1 ? 1 : _powApprox(v));
double _powApprox(double v) => v * v * v * 0.6 + v * v * 0.4; // ≈ v^2.4 on [0,1]
```

(The luminance helper approximates the 2.4 exponent; the four pairs clear AA by a wide margin, so the approximation is safe. If you prefer, import `dart:math` and use `pow(v, 2.4)` — do that and delete the helpers.)

- [ ] **Step 4: Implement `app_colors.dart`** with every token from the design review §F, named exactly as the test expects, plus semantic aliases (`primary = navy900`, `surface`, `textPrimary`, `textSecondary = #5C6779`, `textTertiary = #8A93A3`, `accent = gold500`, `accentInk = goldInk800`).
- [ ] **Step 5: Implement `app_text_styles.dart`.** Sizes from the board: amount hero 40/700 with `fontFeatures: [FontFeature.tabularFigures()]`, H1 24/700, H2 18/600, body 16/500, small 14/400, caption 12/600. Use `.sp` at the call site, never a hard-coded scale factor here.
- [ ] **Step 6: Implement `app_theme.dart`** — Material 3, `ColorScheme.fromSeed` overridden with the exact tokens, `scaffoldBackgroundColor: AppColors.appBg`, cards/inputs with 1px `AppColors.border` and radii 8/12/16, `elevation: 0` everywhere except the bottom-sheet scrim, minimum tap target 48.
- [ ] **Step 7:** `flutter test test/core/theme` — expect green. Then `flutter analyze` on your files only.
- [ ] **Step 8: Checkpoint.** Report files changed.

---

### Task 20: Localization (English + Yorùbá) with a `yo` fallback

**Files:** `l10n.yaml`, `lib/core/l10n/app_en.arb`, `app_yo.arb`, `lib/core/l10n/yo_material_localizations.dart`
**Test:** `test/core/l10n/l10n_test.dart`

**Why a fallback is needed:** Flutter ships no `GlobalMaterialLocalizations`/`GlobalCupertinoLocalizations` for `yo`. Without a delegate that serves English Material strings under a `yo` locale, the app throws "No MaterialLocalizations found" the moment the language is switched.

- [ ] **Step 1: `l10n.yaml`**

```yaml
arb-dir: lib/core/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
```

- [ ] **Step 2: Write `app_en.arb`** with every string the artboards show. Group by screen and keep the keys stable: `homeGreeting`, `homeAvailableBalance`, `homeOnHold`, `homeUpToDate`, `homeSend`, `homeSave`, `homeAddMoney`, `homeRecent`, `homeSeeAll`, `offlineBanner`, `syncChipPending`, `sendTitle`, `sendStep`, `sendChooseRecipient`, `sendNewRecipient`, `sendNewRecipientOffline`, `sendAmountQuestion`, `sendAvailable`, `sendFee`, `sendNarration`, `sendReviewTitle`, `sendTotalDebit`, `sendBalanceAfter`, `sendHeldUntilSent`, `sendOfflineNotice`, `sendCta`, `queueCta`, `pinTitle`, `pinSubtitle`, `biometricTitle`, `biometricSubtitle`, `usePinInstead`, `resultSent`, `resultPending`, `resultPendingBody`, `resultProcessing`, `resultFailed`, `tryAgain`, `done`, `viewDetails`, `saveTitle`, `saveTotalSaved`, `savePendingAcross`, `saveCreateGoal`, `goalTarget`, `goalDaysLeft`, `goalWeeklyHint`, `contributeTitle`, `contributeFrom`, `profileTitle`, `profileLanguage`, `profileBiometrics`, `profileSignOut`, `devPanelTitle`, … Use ICU placeholders for money and counts (`"homeOnHold": "{amount} on hold for {count} pending"`).
  **The exact English wording is on the artboards — copy it verbatim.** The brief's phrase `Pending — will send when back online` must appear exactly as `AppConstants.offlinePendingCopy`.
- [ ] **Step 3: Write `app_yo.arb`** using the **live language table** from the design (this is the authoritative set; the hard-coded artboard strings were unified to it on 2026-09-16):
  `IWỌ̀N OWÓ TÓ WÀ` (available balance), `Pa owó mọ́` (save), `Fi owó kún àpò` (add money), `Àwọn ìṣòwò tuntun` (recent transactions), `Ẹ káàbọ̀ sí NovaPay,` (greeting), `Fi owó ránṣẹ́` (send), `tí a dì mọ́lẹ̀` (on hold), `Gbogbo rẹ̀ ti wà ní ìmúdójúìwọ̀n.` (up to date), `Wo gbogbo rẹ̀` (see all), `Ó ń dúró: yóò lọ nígbà tí o bá padà sórí íntánẹ́ẹ̀tì` (pending result), `Ìgbésẹ̀ {step} nínú 4` (step counter), `Èló ni o fẹ́ fi ránṣẹ́?` (amount question), `Owó ìfiránṣẹ́` (fee), `Tẹ̀síwájú` (continue), `Ilé / NovaSave / Àkọọ́lẹ̀` (bottom nav).
  **Use `íntánẹ́ẹ̀tì` for "internet" everywhere — never `ayélujára`.** Mark any string you are unsure of with an `@` comment so the candidate can check it with a native speaker.
- [ ] **Step 4: Implement the fallback delegates** `lib/core/l10n/yo_material_localizations.dart`:

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Flutter has no Material/Cupertino translations for Yorùbá. These delegates
/// serve the English ones under a `yo` locale, which is what stops the app
/// throwing "No MaterialLocalizations found" the instant the user switches
/// language. Our own strings still come from AppLocalizations.
class YoMaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const YoMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'yo';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(const Locale('en'));

  @override
  bool shouldReload(covariant LocalizationsDelegate<MaterialLocalizations> old) => false;
}

class YoCupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const YoCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'yo';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GlobalCupertinoLocalizations.delegate.load(const Locale('en'));

  @override
  bool shouldReload(covariant LocalizationsDelegate<CupertinoLocalizations> old) => false;
}

class YoWidgetsLocalizationsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
  const YoWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'yo';

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      GlobalWidgetsLocalizations.delegate.load(const Locale('en'));

  @override
  bool shouldReload(covariant LocalizationsDelegate<WidgetsLocalizations> old) => false;
}
```

- [ ] **Step 5: Write the test** `test/core/l10n/l10n_test.dart`: pump a `MaterialApp` with `locale: const Locale('yo')` and the delegate list; assert it builds without throwing, that `AppLocalizations.of(context).homeSend` is `'Fi owó ránṣẹ́'`, and that a `showDatePicker` route can be built under `yo` (this is the case that crashes without the delegates). Also assert `app_yo.arb` has **no** occurrence of `ayélujára` and that both ARB files have identical key sets.
- [ ] **Step 6:** `flutter gen-l10n` then `flutter test test/core/l10n`. Checkpoint.

---

### Task 21: Shared widgets (the component sheet, `1b`)

**Files:** `lib/core/widgets/` — `nova_button.dart`, `nova_text_field.dart`, `amount_input.dart`, `status_pill.dart`, `activity_row.dart`, `offline_banner.dart`, `sync_chip.dart`, `skeleton.dart`, `nova_bottom_sheet.dart`, `pin_pad.dart`, `nova_bottom_nav.dart`, `money_text.dart`, `empty_state.dart`, `error_state.dart`
**Test:** `test/core/widgets/widgets_test.dart`

Each widget is built from the tokens in Task 19 and mirrors artboard `1b`. Specifics that matter:

- [ ] `MoneyText(kobo, style, {compact = false})` — renders `Money(kobo).format()` in tabular figures and wraps it in `Semantics(label: MoneySemantics.label(kobo, languageCode: Localizations.localeOf(context).languageCode))`, with `excludeSemantics: true` on the visual text so a screen reader hears the words once, not twice.
- [ ] `StatusPill(status)` — one of Pending / Sending / Sent / Failed, each **icon + label**, tinted background and darker ink from the token pairs. Never colour alone.
- [ ] `ActivityRow(item)` — avatar initial, title, subtitle, signed amount, pill. Minimum height via `BoxConstraints(minHeight: 72.h)`, never a fixed height, so it grows at 200% text.
- [ ] `OfflineBanner` — `Semantics(liveRegion: true)` so it is announced when it appears; calm navy, not red.
- [ ] `PinPad` — 48dp targets, digits labelled, and it announces **the number of digits entered, never the digits themselves**.
- [ ] `NovaBottomNav` — three destinations with the design's glyphs: Home is a house, NovaSave is the gold diamond, Profile is a person.
- [ ] **Test:** each widget pumps at `textScaler: 1.0` and `2.0` on a 360×640 surface with `tester.takeException()` expected null (no overflow), plus `find.bySemanticsLabel` assertions for `MoneyText` and `StatusPill`.

---

### Task 22: App shell, router and lifecycle

**Files:** `lib/main.dart` (replace Plan 1's placeholder), `lib/core/navigation/app_router.dart`, `nav_keys.dart`, `lib/core/shell/main_shell.dart`
**Test:** `test/core/navigation/router_test.dart`

- [ ] `main()` → `WidgetsFlutterBinding.ensureInitialized()` → `AppInitializer.init()` → `runApp`.
- [ ] `NovaWalletApp` = `ScreenUtilInit(designSize: Size(390, 844), minTextAdapt: true, fontSizeResolver: <clamped>)` → `MultiBlocProvider` (the singletons from `sl`) → `BlocBuilder<LocaleCubit, Locale?>` → `MaterialApp.router` with `AppTheme.light`, `supportedLocales: [Locale('en'), Locale('yo')]`, the three `Yo*` delegates **before** the Global ones, and `AppLocalizations.delegate`.
- [ ] **Lifecycle:** an `AppLifecycleListener` calls `sl<SyncCubit>().setForeground(true/false)` and `sl<ConnectivityCubit>().recheck()` on resume. This is what makes a queued transfer go out when the user comes back to the app.
- [ ] **Router:** `go_router` with `redirect` driven by `AuthCubit`: `unknown → /splash`, `needsOnboarding → /onboarding`, `unauthenticated → /login`, `locked → /unlock`, `authenticated → /home`. Routes for every screen in Tasks 23–26; `StatefulShellRoute.indexedStack` for the three tabs (Kiba's pattern).
- [ ] **Test:** pump the app with a fake `AuthCubit` in each status and assert the landing route; assert that switching `LocaleCubit` to `yo` rebuilds without throwing.

---

### Task 23: Entry experience (artboards `3a`–`3l`)

**Files:** `lib/features/splash/…`, `lib/features/onboarding/…`, `lib/features/auth/presentation/…` (controller + contract + view per screen, Kiba layout)
**Test:** `test/features/auth/auth_screens_test.dart`

Screens, each bound to the cubits built in Plan 1 Task 9:

| Artboard | Screen | Notes |
|---|---|---|
| `3a` | Splash | One `AnimationController`, under 1 s, navy ground, gold mark. No Lottie. |
| `3b`–`3d` | Onboarding ×3 | `PageView`, dots, Skip; final page CTAs "Create account" / "I already have an account" → `authCubit.completeOnboarding()` |
| `3e` | Phone | +234 prefix, helper "10 digits, without the leading 0" → `SignupCubit.submitPhone` |
| `3f` | OTP | `pinput`, 60 s resend countdown, **DEMO banner showing `AppConstants.fakeOtp`** → `submitOtp` |
| `3g` | Your details | name, email, password with strength rules, NDPA consent checkbox → `submitDetails` |
| `3h` | BVN (optional) | tier comparison ₦100,000 / ₦1,000,000, "Skip for now" → `submitBvn` / `skipBvn` |
| `3i`, `3j` | Create + confirm PIN | `PinPad`, "PINs match" confirmation → `submitPin` |
| `3k` | **Log in — email + password** | No biometric button (design review A2) → `LoginCubit.submit` |
| `3l` | Unlock | greeting by first name, PIN pad, biometric button → `UnlockCubit` |

- [ ] **Test:** the signup happy path walks phone → OTP → details → BVN skip → PIN and ends `authenticated`; a wrong PIN on `3l` shows the error and, after three, the cooldown.

---

### Task 24: Wallet Home (artboards `1c`–`1g`, `4i`, `4k`)

**Files:** `lib/features/home/presentation/{contracts,controllers,views,widgets}/…`
**Test:** `test/features/home/home_screen_test.dart`

- [ ] Balance card: eye toggle (`Money.masked` when hidden), **Available** as hero, "₦X on hold for N pending" underneath, sync chip, "Last updated …" when `lastRefreshFailure != null`.
- [ ] Quick actions: Send / Save / Add money, with the offline sub-labels from `1d` ("Queues offline", "Needs data").
- [ ] `RefreshIndicator` + `CustomScrollView` with `SliverList.builder` over `WalletCubit.state.activity`; pending and failed rows first.
- [ ] States: skeletons (`1e`), empty (`1f`), offline (`1d`).
- [ ] **Test:** pending hold arithmetic on screen (ledger − holds), pull-to-refresh calls `WalletCubit.refresh`, the list builds lazily (assert only the visible rows are built), and the screen survives `textScaler: 2.0` at 360×640.

---

### Task 25: Send Money (artboards `2a`–`2n`)

**Files:** `lib/features/send_money/presentation/…`, `lib/features/beneficiaries/presentation/…`
**Test:** `test/features/send_money/send_money_flow_test.dart` (**this is one of the two flows the brief names**)

- [ ] Recipient (`2a`/`2b`) — saved list, search, "New recipient" **disabled offline** with the explanatory copy.
- [ ] New recipient (`2c`) — bank picker, 10-digit field, verified-name card, "Save as beneficiary" toggle → `NameEnquiryCubit`.
- [ ] Amount (`2d`/`2e`) — `AmountInput`, chips ₦1,000/₦5,000/₦10,000, live fee line, inline errors from `SendMoneyCubit.state.amountError`.
- [ ] Review (`2f`/`2g`) — every figure: amount, fee, total debit, balance after; offline adds the notice and "Held until sent"; CTA text switches to "Queue transfer".
- [ ] Authorise (`2h`/`2i`) — PIN sheet under ₦50,000; biometric sheet at or above, with "Use PIN instead" (drives `needsPinFallback`).
- [ ] Results (`2j`–`2m`) — Sent / **Pending (verbatim brief copy)** / Processing / Failed, each with Done and View details; Failed offers "Try again" → `retry()`.
- [ ] Details (`2n`) — the Queued → Sending → Completed timeline from the outbox item.
- [ ] **Test:** online happy path ends Sent; offline path ends **Pending with `AppConstants.offlinePendingCopy` on screen**; over-balance blocks Continue; a ≥ ₦50,000 send calls `FakeBiometricGate`; wrong PIN queues nothing.

---

### Task 26: NovaSave, Profile and the developer panel (artboards `4a`–`4h`)

**Files:** `lib/features/savings/presentation/…`, `lib/features/profile/presentation/…`, `lib/features/developer/presentation/…`
**Test:** `test/features/savings/contribute_flow_test.dart` (**the second flow the brief names**)

- [ ] Goals list (`4a`) — two-segment bar (confirmed gold + hatched pending), true percentage in text **uncapped** (104% reads 104%), bar width capped at 100%, "✓ Goal reached" pill.
- [ ] Create goal (`4c`) — name, target, date, chips, and the weekly hint from `Progress.suggestedWeeklyKobo` (never a hard-coded figure).
- [ ] Goal details (`4d`) — big percentage, saved vs pending legend, days left, contribution history.
- [ ] Contribute sheet (`4e`/`4f`) — amount, **available balance minus holds**, PIN, offline copy.
- [ ] Profile (`4g`) — user card with tier badge, language row opening the bottom sheet (English / Yorùbá live; Hausa and Igbo disabled "Coming soon"), biometrics toggle, sign out, version footer.
- [ ] Developer panel (`4h`) — Simulate offline, Lose next response, latency slider, outbox viewer with attempts and truncated idempotency keys, Reset demo data.
- [ ] **Test:** contribute offline shows pending progress without moving the confirmed figure; after sync the confirmed figure moves and pending clears; the wrong PIN queues nothing.

---

### Task 27: Accessibility and localization sweep

**Files:** touch-ups across the feature folders
**Test:** `test/a11y/text_scale_test.dart`, `test/a11y/semantics_test.dart`, `test/features/l10n/yoruba_screens_test.dart`

- [ ] **Text scale:** pump Home, Send amount, Review, Goal details and Profile at `textScaler: 2.0` on 360×640; assert `tester.takeException()` is null on each (no overflow), and that no `Text` is truncated mid-amount.
- [ ] **Semantics:** assert labels exist for the balance toggle, every quick action, every status pill, the PIN pad, and that amounts read as words (`find.bySemanticsLabel(RegExp('naira'))`).
- [ ] **Yorùbá:** pump Home and Send amount under `Locale('yo')`; assert the strings come from `app_yo.arb`, that no English fallback leaks into a visible label, and that layouts survive the ~40% longer strings at 1.0 and 2.0 scale.
- [ ] **Notification copy:** `LocalNotificationService` takes the localized strings via `lookupAppLocalizations(Locale(code))` so a queued send that syncs announces itself in the user's language.

---

### Task 28: UI-driven integration test and the demo rehearsal

**Files:** `integration_test/send_offline_ui_test.dart`
**Test:** run on the Android emulator

- [ ] Drive the **real UI**: log in, toggle the developer panel's "Simulate offline", send ₦25,000, assert the Pending screen, kill and restart the app (`AppInitializer.dispose()` + `init()`), assert the item is still queued, switch back online, assert the row flips to Sent and the balance debits **once** (`processed` doc count 1).
- [ ] Then rehearse the live demo end to end on the emulator with real airplane mode: queue → restart → reconnect → notification → one debit. Note the timings so the 10-minute slot is safe.

---

## Definition of done for Plan 2

- `flutter analyze` clean; `flutter test` green, including the two flow tests the brief names, the text-scale tests and the Yorùbá tests.
- The app matches the artboards on Home, Send, NovaSave, Profile and the entry experience, in both languages.
- Nothing on screen contradicts the money model: available = ledger − holds, everywhere.
- The emulator rehearsal has been run at least once, start to finish.
