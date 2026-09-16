# Handoff — start here in a new session

_Written 2026-09-16 evening. Submission: **2:00 PM Thursday 17 September 2026**._

## Where things stand

| Area | State |
|---|---|
| **Plan 1** (offline core, Tasks 1–18) | **Done.** 116 tests green, including the graded offline → restart → sync-exactly-once scenario (`test/integration/offline_restart_sync_test.dart`). Device version written (`integration_test/offline_queue_sync_test.dart`), **not yet run on a device**. |
| **Firebase** | **Wired and live.** Project `nova-wallet-d5713`. `firestore.rules` **deployed**. `lib/core/api/firebase/firebase_nova_service.dart` implements the backend. `flutter run` uses Firebase by default; `--dart-define=BACKEND=fake` uses the in-process fake. **Exercised end to end on 2026-09-16** (Android emulator, real airplane mode): first login self-provisions; online send; offline send → force-stop → offline unlock → reconnect → Sent + notification + one debit; lose-next-response retry (attempts 2, same key, one debit); offline goal create + offline contribution both sync; sign out → log in restores everything from Firestore. No rule or index errors. Check Authentication → Email/Password is enabled in the console. |
| **Plan 2** (UI, Tasks 19–28) | **Task 19 done** (tokens, theme, bundled Plus Jakarta Sans variable font — Yorùbá glyphs verified). **Task 20 done** (`lib/core/l10n/app_en.arb` + `app_yo.arb`, identical key sets, generated `AppLocalizations`, `yo_fallback_localizations.dart`). **Tasks 21–26 built** (see the STATUS note at the top of the plan for deviations) and smoke-tested on the emulator with `--dart-define=BACKEND=fake`. **Tasks 27–28 not started; widget tests for 21–26 deferred.** |
| **Docs** | `README.md` and `AI_USAGE.md` drafted and current (AI_USAGE §2.7–2.8 record the two sign-out races caught this session). PowerPoint deck not started. |
| Suite | **121 tests green, `flutter analyze` clean.** |

## Working rules for the next session (from the user)

1. **Build first — do not write new tests right now.** Keep running `flutter analyze` as the compile check. Existing tests must stay green.
2. **Work inline — do not spawn subagents** (cost). The user stopped a subagent earlier and chose inline.
3. **Never run git commands.** The user handles git.
4. **Only cubits call repositories.** Screens (controllers/views) talk to cubits only.

## Next: Plan 2 from Task 21

Plan file: `docs/superpowers/plans/2026-09-16-novawallet-plan-2-ui.md` (read "Global constraints" first).

1. **Task 21 — shared widgets** in `lib/core/widgets/`: `MoneyText` (Money.format + `MoneySemantics` label), `StatusPill` (icon + label, token pairs), `ActivityRow` (minHeight, never fixed height), `OfflineBanner` (liveRegion), `PinPad` (announces count, not digits), `NovaBottomNav` (house / gold diamond / person), `AmountInput`, `SyncChip`, skeleton, empty/error states.
2. **Task 22 — app shell**: replace the placeholder in `lib/main.dart` with `ScreenUtilInit(designSize: 390×844, minTextAdapt: true, clamped fontSizeResolver)` → `MultiBlocProvider` → `MaterialApp.router` (theme `AppTheme.light`, locales en/yo, **the three `Yo*` delegates before the Global ones**, `AppLocalizations.delegate`) + `go_router` redirect driven by `AuthCubit` + `AppLifecycleListener` calling `SyncCubit.setForeground` and `ConnectivityCubit.recheck`.
3. **Tasks 23–26 — screens**, Kiba split (controller `StatefulWidget` implementing `…ControllerContract`, `part` view implementing `…ViewContract`, `part` contract file):
   - 23 Entry: splash, onboarding ×3, phone, OTP (DEMO banner shows `AppConstants.fakeOtp`), details, BVN, create + confirm PIN, **login = email + password (no biometric button)**, unlock.
   - 24 Home: balance card (available = ledger − holds), sync chip, quick actions, `SliverList.builder` activity, offline/loading/empty states.
   - 25 Send: recipient (new recipient disabled offline), new recipient, amount, review, PIN sheet / biometric sheet, results Sent / **Pending — will send when back online** / Processing / Failed, transaction details timeline.
   - 26 NovaSave (list with confirmed + pending bar, true % text, create goal, details, contribute sheet), Profile (language sheet: English + Yorùbá live, Hausa/Igbo "Coming soon"), Developer panel (simulate offline, lose next response, latency, outbox viewer, reset).
4. Then Plan 3: finish README/AI_USAGE, build the 10-minute PowerPoint deck (saved under the candidate's name), and run a full emulator rehearsal with real airplane mode.

## Two known gaps in the reactive (stream) layer — fix while building Plan 2

The data flow is deliberate: repositories return Isar `watch()` streams, cubits subscribe (the only place `StreamSubscription`s live besides core plumbing) and cancel in `close()`/`reset()`. Two gaps remain:

1. **No `onError` on any of the 10 `.listen()` calls** (cubits + `session_lifecycle.dart` + `reachability.dart`). Add an `onError` that emits a failure/stale state (or logs) instead of leaving an uncaught async error.
2. **Over-emission:** Isar `watch()` fires on any change to the collection and `combineLatest2` re-emits every event. Add `.distinct()` where a stream maps to an `Equatable` value, and use `buildWhen` / `BlocSelector` in the new widgets so e.g. the 50-row history doesn't rebuild on every outbox change.

## Things a fresh session needs to know

- **Design source of truth:** Claude Design project `20b5097c-fa82-4bb1-84f8-3cef42aa55ba`, file `NovaPay Send & Save.dc.html` (45 artboards; ids `1a`–`4l`). All review fixes are applied there. Tokens and fixes are summarised in `docs/design/design-review-2026-09-16.md`. The DesignSync MCP is unusable here; read the file via the user's Chrome + `claude.ai/design/anthropic.omelette.api.v1alpha.OmeletteService/GetFile` `{projectId, path}` if needed.
- **Demo account:** `tolu.adeyemi@mail.com` / `NovaPay#2026`, PIN `1234`, OTP `419372`, ₦250,000.00. On the fake backend the login identifier is the phone `08012345678`; on Firebase it is the email (first login self-provisions the account).
- **Cubit singletons** (from `sl`): `AuthCubit`, `LocaleCubit`, `ConnectivityCubit`, `SyncCubit`, `WalletCubit`, `BeneficiariesCubit`, `SavingsCubit`, `DeveloperCubit`. **Factories:** `SignupCubit`, `LoginCubit`, `UnlockCubit`, `NameEnquiryCubit`, `CreateGoalCubit`, `SendMoneyCubit`, `BiometricSettingsCubit`. `ContributeCubit` is constructed per goal (needs a `GoalView`).
- **Text styles:** `AppTextStyles` sets both `fontWeight` and the variable-font `wght` axis — use its getters, don't build ad-hoc `TextStyle`s with a family.
- **Never** copy Kiba's `MediaQuery(textScaler: 0.95)` override; no fixed `.h` height on anything containing text.
- **Android emulator available:** `Medium_Phone_API_36.1` (`flutter emulators --launch Medium_Phone_API_36.1`).
- **Open item for the user:** native-speaker check of the Yorùbá in `app_yo.arb` (`Àkọọ́lẹ̀` for Profile, general tone marks). Record any corrections in `AI_USAGE.md` §2.5.
