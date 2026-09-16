# Claude Design Brief: NovaPay "Send & Save"

This brief is pasted into Claude Design **one prompt at a time** (Prompt 1, review, Prompt 2, and so on). Many screens in a single request tends to give shallow results; batching keeps each screen high quality.
Source of truth: `docs/superpowers/specs/2026-09-15-novawallet-send-save-design.md`

---

## Prompt 1: design system and the core screens (paste this first)

```
You are designing a mobile fintech app called NovaPay (the NovaWallet "Send & Save" module) for the Nigerian / West African mass market. It is a fictional product built by a bank's digital innovation lab. Do NOT use any real bank's logo or trademarks. Create an original NovaPay mark (a simple geometric "N" / star-nova motif).

AUDIENCE & CONTEXT
- Everyday Nigerians, many on low-end Android phones (360×640 to 390×844) with patchy mobile data.
- The app must feel trustworthy, calm and premium, but light enough to render fast: flat surfaces, no blur/glassmorphism, no heavy illustrations or photos, no gradients behind text.
- Currency is Naira: always "₦" + digit grouping + 2 decimals, e.g. ₦250,000.00. Use tabular (monospaced) figures for all amounts.
- Two languages: English and Yorùbá. Yoruba strings run ~40% longer and use diacritics (ẹ ọ ṣ + tone marks). The typeface MUST render this correctly: "Ẹ káàbọ̀ sí NovaPay — Ṣé o fẹ́ fi owó ránṣẹ́?"

BRAND DIRECTION
- Primary: deep navy (starting point #0B1F3A; refine it). Accent: warm gold (starting point #E3A92B), used for highlights, the brand mark, progress fills and small accents. Never gold text on white (fails contrast).
- Neutrals: off-white app background, white cards, cool greys for secondary text.
- Status colours (each always paired with an icon AND a text label, never colour alone):
  Sent/Success = green, Pending/Queued = amber, Sending/Processing = blue, Failed = red. Provide a tinted background + darker foreground pair for each that passes WCAG AA.
- Typeface: a modern humanist/geometric sans with full Yoruba diacritic support (e.g. Inter, Manrope or Plus Jakarta Sans; verify the test string). One family, weights 400/500/600/700.
- Material 3 base, 8pt spacing grid, 12–16px card radius, subtle 1px borders instead of heavy shadows.

FINTECH DESIGN RULES (non-negotiable)
1. The key amount on each screen is the visual hero: largest type, tabular figures.
2. Review/confirm screens show recipient, bank, masked account (•••• 4321), amount, fee, TOTAL debit and balance after, all BEFORE the user authorises. No hidden fees.
3. Balance can be hidden (eye toggle → ••••••).
4. Account numbers are masked except where the user is entering them.
5. Offline is reassuring, not alarming: a slim persistent banner such as "You're offline. Transfers will be queued and sent automatically."
6. Human error copy that says what happened and what to do next.
7. No dark patterns, no fake urgency, no confetti overload. A single tasteful success moment is fine.
8. Accessibility: touch targets ≥ 48dp; AA contrast; layouts must still work at 200% system text size (no fixed-height text containers; things grow vertically).

DELIVER IN THIS PROMPT
A) A compact design-system board: colour tokens (with hex), type scale, spacing, radii, buttons (primary / secondary / text / disabled / loading), text inputs (default / focus / error), amount input, status pills (Pending / Sending / Sent / Failed), list row (transaction), bottom sheet, PIN pad, offline banner, skeleton loader, bottom navigation (Home · NovaSave · Profile).
B) Wallet Home, ONLINE: greeting, balance card (Available ₦186,450.25 as hero; secondary line "₦0.00 on hold"; eye toggle), quick actions (Send, Save, Add money), "Recent transactions" list showing ~6 rows (mix of credits, transfers, a NovaSave contribution), bottom nav.
C) Wallet Home, OFFLINE WITH PENDING: offline banner at top; balance card "Available ₦131,423.37" with "₦55,026.88 on hold for 2 pending"; a sync chip "2 pending: will send when back online"; the first two list rows are Pending items (amber pill, clock icon) above normal history.
D) Wallet Home, loading (skeletons) and empty ("No transactions yet").

Frame size 390×844. Label every artboard.
```

---

## Prompt 2: the Send Money flow

```
Using the NovaPay design system you just created, design the Send Money flow (390×844 each, labelled):

1. Choose recipient, ONLINE: search field; "Saved recipients" list (avatar initial, name, bank, masked account, e.g. "Adaeze Okafor · GTBank · •••• 4821"); a "New recipient" row at top.
2. Choose recipient, OFFLINE: same list still usable; "New recipient" row disabled with helper text "Connect to the internet to add a new recipient. You can still send to saved recipients."
3. New recipient: bank picker field, 10-digit account number input, verified-name confirmation card ("Account name: CHINEDU EMEKA OBI" with a check icon), "Save as beneficiary" toggle, Continue.
4. Enter amount, VALID: recipient chip at top; huge centred amount input "₦25,000.00"; "Available: ₦186,450.25"; quick chips ₦1,000 / ₦5,000 / ₦10,000; optional "Narration" field (0/50); fee line "Fee: ₦26.88"; Continue.
5. Enter amount, ERROR: amount exceeds available; inline error "This is more than your available balance of ₦186,450.25".
6. Review, ONLINE: summary card (To, Bank, Account •••• 4821, Amount ₦25,000.00, Fee ₦26.88, Total ₦25,026.88, Balance after ₦161,423.37); CTA "Send ₦25,026.88".
7. Review, OFFLINE: same plus an info callout: "You're offline. This transfer will be queued and sent automatically when you're back online." CTA "Queue transfer".
8. Authorise with PIN: bottom sheet over the review screen, 4 PIN dots, numeric keypad, "Forgot PIN?".
9. Authorise with biometrics (amount ≥ ₦50,000): sheet with fingerprint/face icon, "Confirm ₦75,053.75 transfer", "Use PIN instead".
10. Result: SENT (success check, amount, "Sent to Adaeze Okafor", reference, Done / View details).
11. Result: PENDING (clock icon, amber): title "Pending: will send when back online"; body "We've saved this transfer on your phone. It will go through automatically once you're connected, and we'll notify you." Done / View details.
12. Result: PROCESSING (online but slow): "Processing… We'll notify you when it's done."
13. Result: FAILED: red; "Transfer failed"; reason "Insufficient funds when we tried to send"; "Your money was not debited."; Try again / Done.
14. Transaction details: amount hero, status pill, vertical status timeline (Queued 14:02 → Sending 14:09 → Completed 14:09), details list (Recipient, Bank, Account, Fee, Reference, Date), "Report an issue".
```

---

## Prompt 3: splash, onboarding and account

```
Using the NovaPay design system, design the entry experience (390×844 each, labelled):

1. Splash: navy background, NovaPay mark centred with a subtle gold glow; show 3 keyframes of a short (<1s) reveal animation.
2–4. Onboarding PageView, 3 pages with simple flat vector spot-illustrations (lightweight, not photographic), page dots, Skip:
   (1) "Send money in seconds": "Transfer to any Nigerian bank instantly."
   (2) "Save towards what matters": "Set goals and watch your progress grow."
   (3) "Works even when network is bad": "No network? We'll queue your transfer and send it the moment you're back online."
   Last page CTAs: "Create account" (primary) and "I already have an account".
5. Phone number: +234 prefix selector, phone input, "We'll send you a code".
6. OTP: 6 boxes, resend countdown "Resend code in 0:42", plus a small dashed "DEMO" banner showing the code.
7. Your details: full name, email, password with a strength meter + rule hints, consent checkbox "I agree to the Terms and Privacy Policy (NDPA 2023)".
8. Verify BVN (optional): 11-digit input, why-we-ask explainer, tier comparison ("Tier 1: up to ₦100,000 per transfer · Tier 2: up to ₦1,000,000"), "Skip for now".
9. Create transaction PIN: 4 dots + keypad; second artboard "Confirm your PIN".
10. Log in: phone + password, "Use fingerprint" button, "Forgot password?", "New here? Create account".
11. Unlock (returning user): "Welcome back, Tolu", PIN dots, keypad with biometric key, "Not you? Sign out".
```

---

## Prompt 4: NovaSave, Profile and the edge-case variants

```
Using the NovaPay design system, design (390×844 each, labelled):

NOVASAVE
1. Goals list: cards with goal name, two-segment progress bar (solid gold = confirmed, striped/lighter = pending), "35%", "₦210,000.00 of ₦600,000.00", target date; "Create a goal" button. Also an empty state.
2. Create goal: name, target amount, target date picker, computed hint "Save about ₦24,000.00 a week to reach this by 20 Dec 2026", Create.
3. Goal details: big percentage, progress bar with a pending segment and legend ("₦210,000.00 saved · ₦5,000.00 pending"), days left, contribution history list with status pills, "Contribute" CTA.
4. Contribute bottom sheet: amount input, "From NovaWallet · Available ₦186,450.25", Continue → PIN. Plus the offline variant with the queued notice.

PROFILE
5. Profile: user card (name, phone, "Tier 2" badge), Language (English / Yorùbá segmented control), Biometrics toggle, Security, Help, Sign out.
6. Developer panel (debug tool, utilitarian but on-brand): switches "Simulate offline", "Lose next server response", a latency slider (400–1200 ms), "View outbox" list rows (type, amount, status pill, attempts, short idempotency key), "Reset demo data".

VARIANTS (important for the assessment)
7. Wallet Home in Yorùbá (use these draft strings): "Ẹ káàbọ̀, Tolu" · "Owó tó wà" (Available) · "Fi owó ránṣẹ́" (Send) · "Fi pamọ́" (Save) · "Fi owó kún" (Add money) · "Àwọn ìdúnàádúrà tuntun" (Recent transactions) · offline banner "O kò sí lórí íntánẹ́ẹ̀tì. A ó fi àwọn ìfiránṣẹ́ rẹ ránṣẹ́ nígbà tí o bá padà sórí ayélujára." Confirm the layout handles the longer text.
8. Send, Enter amount in Yorùbá: title "Èló ni o fẹ́ fi ránṣẹ́?", "Owó tó wà: ₦186,450.25", "Owó ìfiránṣẹ́: ₦26.88" (fee), "Tẹ̀síwájú" (Continue).
9. Wallet Home at 200% system text size on a 360×640 frame: show how cards and rows grow vertically, wrap, and stay usable (nothing truncated mid-amount).
10. Result PENDING in Yorùbá: "Ó ń dúró: yóò lọ nígbà tí o bá padà sórí íntánẹ́ẹ̀tì".
```

---

## After the designs are done

Bring back to Claude Code:
- The **final colour tokens, type scale, spacing and radii** (or a screenshot of the design-system board). These become `app_colors.dart`, `app_text_styles.dart` and `app_theme.dart`.
- The **chosen typeface** name, so the font files can be bundled locally.
- Export or screenshot each artboard, or share the project link, so the implementation matches the designs.

> Yorùbá strings above are AI drafts. Please check the tone marks and wording, and log any corrections for `AI_USAGE.md`.
