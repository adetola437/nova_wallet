# AI usage

I used AI heavily on this task, and the interesting part is not that it wrote code — it's where I had to overrule it, and where it caught me. Both directions are documented below.

## Tools

| Tool | What I used it for |
|---|---|
| **Claude Code (Opus)** | Reading the brief, designing the offline architecture, writing the spec and the implementation plans, and most of the implementation. Also ran parallel sub-agents, one per plan task, for the mechanical work. |
| **Claude Design** | The UI: 45 artboards across 4 boards (design system, Send Money flow, entry experience, NovaSave/Profile/Yorùbá variants). |
| **Claude Code, again, as a reviewer** | Reading the finished artboards back and checking them against the architecture and the money model. This found ten defects — see §4. |

The repository history shows the order: brief → spec → plan → design → implementation. The spec and both plans are in `docs/`, kept up to date as decisions changed, so the reasoning is auditable rather than reconstructed afterwards.

---

## 1. Prompts that shaped the work

**Prompt 1 — the one that set the architecture.**

> "NovaWallet Mobile — Send & Save Flutter take-home. Reuse my Kiba architecture, Isar + SharedPreferences for offline storage, the Kiba biometric as the stub, Yoruba localization. Break this down and come up with a plan."

What came back was a scoping pass rather than code: it read the brief and identified that the graded core is **exactly-once sync**, not the UI, and it flagged something I had not thought about — that "exactly once" cannot be guaranteed by the phone alone. If the app dies after the server accepts a transfer but before it records the acknowledgement, the device cannot know. The design that came out of that is at-least-once delivery from the phone plus a server that deduplicates by idempotency key, which is the honest version of the guarantee. That framing is now the core of my README and my presentation.

**Prompt 2 — the one where I overruled it.**

> "We are also going to use Firebase as the core backend. That is a lot better than creating a mock backend service. Mind you this doesn't change the offline-first approach."

Its first plan used an in-process fake backend. I wanted a real integration. It accepted the change but immediately flagged a risk in *my* direction, which I had not considered: **Firestore's offline persistence is on by default and maintains its own durable write queue**. Left alone it would have sat underneath my Isar outbox — two durable queues holding the same intent, which is exactly how the same transfer goes out twice. The resolution: `Settings(persistenceEnabled: false)`, every read with `Source.server`, and the Isar outbox as the single queue. The in-process fake survives behind the same `NovaApiService` interface as a test double and an offline demo fallback.

Later I moved from Realtime Database to Firestore, because a Firestore transaction spans multiple documents; that let the idempotency record become a **create-once document** enforced by security rules, rather than a field inside a node I maintain by hand.

**Prompt 3 — the review prompt.**

> "Scan this design properly and if any mistakes are noted, bring it to my notice."

This produced the defect list in §4 below. Asking the AI to attack its own earlier output, with the spec as the reference, was the highest-value prompt of the whole exercise.

---

## 2. Where the AI was wrong, and how I caught it

### 2.1 A security rule that would have broken the app silently

It wrote this Firestore rule for savings goals:

```
match /goals/{goalId} {
  allow read, write: if isOwner(uid)
    && request.resource.data.savedKobo is int
    && request.resource.data.savedKobo >= 0;
}
```

This is wrong in a way that does not look wrong. `request.resource` only exists for **write** operations. On a read it is undefined, referencing a field on it raises an error, and Firestore treats a rule error as **deny**. Every `getGoals()` call would have failed, and NovaSave would have shown an empty list with no error message pointing at the cause — the kind of bug that eats an afternoon.

I split it:

```
match /goals/{goalId} {
  allow read, delete: if isOwner(uid);
  allow create, update: if isOwner(uid)
    && request.resource.data.savedKobo is int
    && request.resource.data.savedKobo >= 0;
}
```

I caught it by reading the rules against each operation the service actually performs, rather than reading them as prose.

### 2.2 A reset function that contradicted the guarantee it was protecting

"Reset demo data" deleted every subcollection, including `processed` — the idempotency records. But the rule that makes the guarantee real is `allow update, delete: if false` on exactly those documents. The function would have thrown `permission-denied` on the first batch. The fix was to stop deleting them and say why in the code: stale keys are harmless, because every new intent gets a fresh UUID. Deleting them would mean the guarantee is not actually enforced.

The same review found that `transactions` needed an owner-delete rule for the reset to work at all, which I allowed deliberately and documented as a demo affordance.

### 2.3 Naive kobo maths — the exact trap the brief warns about

My own Kiba codebase (which the AI was told to follow) parses money like this:

```dart
final val = double.tryParse(raw);   // then val * 100 somewhere downstream
```

`double.parse('0.29') * 100` is `28.999999999999996`, which truncates to **28 kobo**. The AI copied Kiba's `Money` class faithfully but would have carried the flow's `double` habit forward. There is now a test named after the bug:

```dart
test('does not suffer float truncation (0.29 * 100 == 28.999… in double)', () {
  expect(ok('0.29'), 29);
});
```

`KoboParser` splits on the decimal point and parses both halves as integers. No `double` holds, parses, sums or compares money anywhere in this app.

### 2.4 A copied line that would have failed an explicit requirement

Kiba's `main.dart` contains:

```dart
MediaQuery(data: ...copyWith(textScaler: TextScaler.linear(0.95)), child: ...)
```

That silently overrides the user's system font-size setting — which the brief explicitly requires the app to respect. Because I asked for a Kiba-style port, it would have come along for the ride. It is now a written "do not copy" rule in the plan, and the font-scale tests pump every key screen at 200%.

### 2.5 AI-drafted Yorùbá that disagreed with itself

The translations were AI-drafted. The review found that the Home screen's live language table and the hard-coded Yorùbá artboards had drifted apart on five strings — including two different words for "transactions" (*ìṣòwò* vs *ìdúnàádúrà*) and two for "internet" (*ayélujára* vs *íntánẹ́ẹ̀tì*). A user switching language would have seen inconsistent vocabulary between screens.

They are unified now, and the remaining wording is being checked by a native speaker rather than trusted. **This is the limit I would put on AI for localization: it is fine for a first draft, and not acceptable as the last word.**

### 2.6 Design numbers that did not reconcile

The AI-generated artboards also carried arithmetic errors that a reader would not catch by eye: a savings hint that said "save about ₦24,000 a week" for a goal that actually needed ₦42,900 a week, and three screens showing the available balance **without** subtracting pending holds — contradicting the hold model shown on the Home screen. Both are fixed. The lesson is the same one as §2.1: plausible-looking output needs to be checked against the model, not against intuition.

### 2.7 A regression test that passed with the fix removed

While building the wallet, a test crashed with `Isar instance has already been closed`. The cause was real: after a transfer settles, the wallet refreshes in the background, and closing the wallet cancelled the *subscription* but not the refresh already in flight. In the app, that same window exists at **sign-out** — a late refresh could write the previous user's balance back into a database that had just been wiped.

The fix was to stop new work, then await in-flight work, before closing. The AI then wrote a regression test for it — and I asked it to prove the test worked by **deleting the fix and re-running the test**. The test still passed. It checked the database after 300 ms, but the refresh makes two server calls totalling ~300 ms, so the late write landed just *after* the assertion. With a wait comfortably past the refresh, the sabotaged code fails (`Expected: 0, Actual: 60` — sixty transactions re-inserted after the wipe) and the real code passes.

**A test that has never failed has not proven anything.** I now sabotage the fix before trusting any test written for a race.

### 2.8 The same race, one layer up

The dependency-injection test then caught the next version of it: `signOut()` wiped local data **first** and announced the sign-out **second**, and only the announcement stopped the session's background work. So the refresh still had a window between the wipe and the stop. The fix is ordering — stop session work → wipe → announce — and "Reset demo data" needed the mirror image, because a Firebase reset requires the user to still be signed in: stop → reset the backend → wipe → sign out.

Neither race would have shown up in a demo. Both would have shown up for a real user who signs out while their connection is slow.

---

## 3. What I let the AI do unsupervised, and what I did not

**Unsupervised:** mechanical implementation of fully-specified tasks (value types, models, storage entities, code generation) — each ran as its own sub-agent against a plan that already contained the code and the tests, and each finished with its test suite green.

**Not unsupervised:** the outbox and the sync engine. That is the part I will be questioned on live, so I wrote and reviewed it line by line. The same goes for the security rules, after §2.1.

---

## 4. Scorecard

The design review produced ten defects in AI-generated artboards: four architectural conflicts (login method, biometric placement, available-balance maths, a promised "cancel" feature that did not exist), four data errors, and two localization inconsistencies. All are fixed and the fixes are recorded in `docs/design/design-review-2026-09-16.md`.

My honest summary: AI moved this from "a weekend" to "a day and a half", and it caught one genuine design flaw in my own instruction (the double-queue problem). It also produced two defects that would have shipped silently if I had trusted the output because it looked confident. Directing it well meant knowing which parts to check hardest — the security boundary, the money maths, and the language I do not speak natively.
