# NovaPay design review — 2026-09-16

Source: Claude Design project `20b5097c-fa82-4bb1-84f8-3cef42aa55ba`, file `NovaPay Send & Save.dc.html` (282 KB, 45 artboards across 4 boards) plus `support.js` (the Claude Design React runtime — no app content in it).

Boards: **1** design system + Wallet Home states (7) · **2** Send Money flow (14) · **3** Entry experience (12) · **4** NovaSave, Profile, Yorùbá & 200%-text variants (12).

> **Status — applied 2026-09-16.** Every fix below is now live in the Claude Design project (file re-uploaded and re-rendered; the language-bottom-sheet work done in the design chat is intact). Three items were resolved in the code instead of the artboards: the 104% cap (spec now allows >100% in text, caps only the bar), the demo OTP (`AppConstants.fakeOtp` now matches the design's `419372`), and the cancel promise (removed from the design copy; cancelling a queued action stays a documented non-goal).

Verdict: **strong work, build on it.** The money maths is right nearly everywhere, the offline story is told properly, and the accessibility groundwork (status pairs with contrast ratios, 48dp targets, the "gold is never text on white" rule) is better than most production fintech kits. The issues below are worth fixing before or during implementation — four of them conflict with the architecture we agreed.

---

## A. Conflicts with the agreed build (fix these first)

### A1. Log in uses phone + password; our backend uses email + password
`3k` collects **Phone number + Password**. Firebase Authentication as specified (Amendment B) signs in with **email + password**. Sign-up (`3g`) does collect an email, so the account exists — but the login screen can't use it.

**Options:** (a) change the login field to Email — one-line design change, zero code cost; (b) keep phone-login by storing a `phone → email` lookup and resolving it before `signInWithEmailAndPassword` (an extra public collection and a read, plus a rules hole to think about); (c) accept either and branch on whether the text contains `@`. **Recommend (a) for the deadline, (c) if the design must keep the phone field.**

### A2. "Use fingerprint" on the Log in screen can't work as a first factor
`3k` offers biometric sign-in on the *logged-out* screen. With Firebase there is no credential on the device before the first sign-in, so biometrics has nothing to unlock. It works on `3l · Unlock` (returning user) because the session already exists — which is exactly where the plan puts it.

**Fix:** drop the button from Log in, or show it only when a stored session exists (in which case the user should be on Unlock anyway).

### A3. Available balance ignores pending holds on three artboards
The hold model is stated correctly on `1d` (₦186,450.25 − ₦55,026.88 = **₦131,423.37**), then contradicted:
- `4e · Contribute — online`: "From NovaWallet **Available ₦186,450.25**", while `4a`/`4d` show ₦5,000.00 already pending on that goal. Should read **₦181,450.25**.
- `4f · Contribute — offline`: same ₦186,450.25 while two transfers are queued. Should read **₦131,423.37**.
- `1c · Wallet Home — online`: "**₦0.00** on hold" while the list contains a ⟳ Sending transfer of ₦7,500.00. Should read **₦7,500.00 on hold**.

This matters more than a typo: "available = ledger − holds" is the rule that stops a user queueing three transfers against one balance, and the panel will look for it.

### A4. The Pending result promises a cancel we don't build
`2k`: *"You can cancel it from Transaction details any time before it sends."* There is no cancel in the plan, and `2n · Transaction details` has no cancel control either — so the promise is unkeepable as drawn.

**Options:** (a) remove the sentence; (b) build it — genuinely cheap and a good demo beat: delete the outbox row inside one Isar transaction **only while `status == queued`**, never while `sending`, which releases the hold automatically. **I'd take (b) if the schedule holds, (a) otherwise.**

---

## B. Numbers and data that don't add up

### B1. Create-goal weekly figure is ~1.8× too low
`4c`: target **₦600,000**, target date **20 Dec 2026**, hint "Save about **₦24,000.00** a week to reach this by 20 Dec 2026", with the **6 months** chip selected.

The app's "today" is 16 Sep 2026 (`4d` says "Days left 95", and 20 Dec 2026 − 95 days = 16 Sep 2026). That's 13.6 weeks, so the correct figure is **₦600,000 ÷ 14 ≈ ₦42,857 a week**. ₦24,000/week corresponds to 25 weeks — which is the "6 months" chip, not the 20 Dec date.

**Fix:** either select the **3 months** chip and show ≈₦42,900, or keep 6 months and move the date to ~16 Mar 2027. (The implementation computes this with `Progress.suggestedWeeklyKobo`, so the screen will self-correct — but the artboard should be right for the presentation.)

### B2. 104% progress vs the 100% cap in the spec
`4a · Generator repair`: **104%**, ₦52,000.00 of ₦50,000.00, "✓ Goal reached", full green bar. The maths is right and the honesty is nice; the spec caps progress at 10000 bps.

**Decision needed:** I'd keep the design — show the true percentage in text, cap only the **bar width** at 100%. One-line change to the spec, and it reads better than a goal that says 100% when you actually over-saved.

### B3. The user changes identity between boards
- `1c`, `1f`, `4k`: **"Chidinma A."**
- `3g`, `3l`, `4g`, `4i`: **"Tolu Adeyemi" / "Tolu"** (with `+234 803 421 5590`, Tier 2)

Pick one person. The demo account in the plan is Tolu Adeyemi, so I'd change Home to match.

### B4. The pending scenario differs between Home and NovaSave
- `1d` Home: 2 pending = transfer ₦25,026.88 + **NovaSave Rent 2027 ₦30,000.00** = ₦55,026.88.
- `4a`/`4d` NovaSave: "**₦5,000.00** pending across 1 goal".
- `4h` Developer panel outbox: transfer ₦25,026.88 + **contribute ₦5,000.00** + failed ₦12,000.00.

Three tellings of one story. If a panellist flips between Home and NovaSave they'll spot it. Make the queued contribution **₦5,000.00 everywhere**, which makes Home's hold ₦30,026.88 and available ₦156,423.37 — and the developer panel already agrees.

---

## C. Localization (Yorùbá)

The Home screen has a **live** language table in the file; every other Yorùbá artboard is hard-coded, and the two disagree on five strings:

| Meaning | Live table (Home) | Hard-coded artboard `4i` |
|---|---|---|
| Available balance | IWỌ̀N OWÓ TÓ WÀ | OWÓ TÓ WÀ |
| Save | Pa owó mọ́ | Fi pamọ́ |
| Add money | Fi owó kún àpò | Fi owó kún |
| Recent transactions | Àwọn ìṣòwò tuntun | Àwọn ìdúnàádúrà tuntun |
| Greeting | Ẹ káàbọ̀ sí NovaPay, | Ẹ káàbọ̀, |

Also: **"internet" is translated two ways** — `1g` uses *ayélujára*, `4i` and `4l` use *íntánẹ́ẹ̀tì*. Pick one (I'd keep *íntánẹ́ẹ̀tì* for the offline banner and *ayélujára* nowhere, or vice versa — just not both).

And please check these as a native speaker, since they're AI-drafted and go straight into the ARB files:
- **"Àkọọ́lẹ̀"** for *Profile* in the bottom nav (`4i`) — is that right, or would *Ìwọ̀nfúnra* / something else read better?
- *"Àwọn ìdúnàádúrà"* vs *"Àwọn ìṣòwò"* for transactions.
- `4l`: *"ẹ̀rọ ìbánisọ̀rọ̀ rẹ"* for "your phone" — correct but long; *"fóònù rẹ"* may read more naturally.

Any correction you make here is a genuine `AI_USAGE.md` entry.

---

## D. Copy details worth a pass

| # | Where | Issue |
|---|---|---|
| D1 | `3e` Phone | "Nigeria (+234) · **10 digits after the leading 0**" contradicts itself — after +234 there is no leading 0. Say "10 digits, without the leading 0". |
| D2 | `3i` Create PIN | "You'll enter these 4 digits **every time** you send money" conflicts with `2i`, where ≥ ₦50,000 uses Face/fingerprint. Add "…or approve with Face/fingerprint for larger transfers". |
| D3 | `3h` BVN | Tier 2 promises a "**higher daily cap**". Daily caps are an explicit non-goal — only per-transfer caps exist. Drop those two words. |
| D4 | `3f` OTP | Demo code is **419 372**; the spec constant is **123456**. Align them (I'll take the design's number if you prefer). |
| D5 | `2b` Offline recipients | Header says "SAVED RECIPIENTS · AVAILABLE OFFLINE" but lists **4 of the 5** from `2a` (Emeka Udo is missing). Offline should show all cached recipients. |
| D6 | `1b` vs `2d`/`4j` | Quick-amount chips differ: ₦5,000/₦10,000/₦25,000 in the component sheet, ₦1,000/₦5,000/₦10,000 on the real screens. Pick one set. |
| D7 | `2e` only | A **Max** chip appears only on the over-balance screen. Either always offer it or never. |
| D8 | `3a` Splash | "Send & Save · by the NovaWallet **innovation lab**" — NovaWallet is the module, not a lab. "by the NovaPay innovation lab" reads better (and still avoids any real bank's name, which is the right call). |

---

## E. What's genuinely good (keep, and say so in the presentation)

- **Status colours ship as tinted-background + darker-ink pairs with the contrast ratios written on the board** (Sent 6.1:1, Pending 5.9:1, Sending 7.2:1, Failed 6.4:1), always with an icon *and* a label. That is the accessibility requirement answered before anyone asks.
- **"Gold is never used for text on white"** with a text-safe substitute (#8A5F06). That's the one mistake a navy/gold fintech palette usually makes.
- **Offline copy is reassuring, not alarming**, and the review screen adds "Held until sent ₦25,026.88" — the hold concept is visible to the user, not just in my code.
- **`2m · Failed`** says "Your money was not debited. Your balance is still ₦186,450.25" and explains *why* — exactly the tone a bank panel wants.
- **`2n · Transaction details`** timeline (Queued 14:02 → Sending 14:09 → Completed 14:09) is a one-to-one picture of the outbox state machine. This is the slide.
- **`4h · Developer panel`** shows the outbox with attempts and truncated idempotency keys, and states the guarantee in one line. Demo gold.
- **`1g` and `4k`** deliberately stress Yorùbá length and 200% system text — the brief asks for font-scale survival and the design already proves it.
- Fee bands are correct everywhere I checked (₦26.88 on ₦25,000; ₦53.75 on ₦75,000), totals and balance-after all reconcile, and figures are tabular throughout.

---

## F. Extracted tokens (ready for `app_colors.dart` / `app_text_styles.dart`)

**Brand & neutrals:** Navy 900 `#0A1E38` · Navy 700 `#14355C` · Gold 500 `#E0A526` · Gold ink 800 `#8A5F06` · App bg `#F6F5F2` · Surface `#FFFFFF` · Border `#E6E3DC` · Text secondary `#5C6779` · Text tertiary `#8A93A3`

**Status pairs (bg / ink):** Sent `#E3F3E8` / `#0F6435` · Pending `#FBEFD3` / `#7A5309` · Sending `#E6EDFB` / `#14459B` · Failed `#FBE7E7` / `#A31C1C`

**Type — Plus Jakarta Sans (400/500/600/700):** amount hero 40/700 tabular · H1 24/700 · H2 18/600 · body 16/500 · small 14/400 · caption 12/600. Yorùbá diacritics verified at all four weights; strings allotted ~40% extra width; **no text container has a fixed height**.

**Spacing (8pt):** 4 hairline · 8 icon↔label · 16 card padding/gutters · 24 section rhythm · 32 block separation
**Radii:** 8 pills/chips · 12 inputs/rows · 16 cards/sheets
**Elevation:** flat only — 1px `#E6E3DC` borders carry hierarchy; shadow only on the sheet scrim and nav edge; no blur, no glass, no gradient behind text.

These map straight onto the Plan 2 theme task, and they satisfy the low-end-Android constraint (no blur, no gradients, no heavy imagery).
