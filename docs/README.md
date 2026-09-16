# NovaWallet — project index

Everything decided so far, newest first. Start here in a fresh session.

| Document | What it holds |
|---|---|
| [design/design-review-2026-09-16.md](design/design-review-2026-09-16.md) | Review of the Claude Design artboards: 4 conflicts with the build, 4 numeric errors, Yorùbá inconsistencies, copy fixes, **and the extracted design tokens** (colours, type, spacing, radii) ready for the theme files |
| [superpowers/plans/2026-09-15-novawallet-plan-1-offline-core.md](superpowers/plans/2026-09-15-novawallet-plan-1-offline-core.md) | **Plan 1** — foundation + offline core, 18 TDD tasks with full code. Read **Amendment A** (Firebase) and **Amendment B** (Firestore supersedes Amendment A's Realtime Database sections) at the end of the file before starting |
| [superpowers/specs/2026-09-15-novawallet-send-save-design.md](superpowers/specs/2026-09-15-novawallet-send-save-design.md) | Approved design spec: assumptions, architecture, data model, the exactly-once rules, screens, testing, deliverables |
| [design/claude-design-brief.md](design/claude-design-brief.md) | The 4 prompts used to produce the Claude Design artboards |

## Where the rest lives

- **Design source:** Claude Design project `20b5097c-fa82-4bb1-84f8-3cef42aa55ba`, file `NovaPay Send & Save.dc.html` (45 artboards). Not stored in this repo yet.
- **Reference architecture:** the Kiba app at `~/Documents/mobile/kiba` — GetIt DI, cubit/repository layering, controller/contract/view `part` split, `Money`, `BiometricSigner`.
- **Brief:** `~/Downloads/Doc1_TakeHome_Frontend_Flutter.pdf`.

## The rules that shape every decision

1. **Only cubits call repositories.** Repositories are injected into cubits; controllers, views and services never touch them.
2. **Money is integer kobo everywhere.** No `double` may hold, parse, sum or compare money.
3. **The Isar outbox is the only durable queue.** Firestore's offline persistence stays off, so it can't keep a second one.
4. **No git commands are run for you** — files are written, you commit them.

## Still to write

- **Plan 2** — UI: theme from the tokens above, l10n (en/yo), splash, onboarding, auth, Home, Send, NovaSave, Profile/developer panel, widget and text-scale tests.
- **Plan 3** — `README.md`, `AI_USAGE.md`, the 10-minute deck, emulator dry run.
