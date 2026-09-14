# Installed 4.8.0 smoke, before the shared-reference patch

Date: 2026-09-14. Published repository release: [v1.6.0](https://github.com/andyconley/agent-skills/releases/tag/v1.6.0), humanizer 4.8.0. The canonical checkout was clean at tag `v1.6.0`; both installed skill links read entry SHA-256 `48749ba8...` and policy SHA-256 `860b0cf0...`.

The `installed-best-effort-smoke` runner started fresh CLI sessions for eight selected cases in Claude and Codex. All 16 calls exited 0 and read the expected installed entry and policy with unchanged hashes. An exact protected-span scan found no omitted exact spans in edit outputs. The runner used explicit installed-file paths, so this proves installed-path loading in fresh sessions, not automatic skill discovery by name.

| Case | Codex | Claude |
| --- | --- | --- |
| `natural-default` | Pass | Pass |
| `personal` | Pass | Pass |
| `personal-runbook` | Pass | Pass |
| `strict-file` | Pass; personal lint invoked | Fail; no personal lint invocation in tool trace |
| `protection-engineering` | Pass | Pass |
| `regression-word-choice` | Pass | Fail; rollback-duration unknown omitted, source ambiguity filled with suggested referents, and extra method commentary |
| `audit-formatting` | Pass | Review concern; finds excess bold but adds a second finding about intentional `**one**` emphasis and non-actionable keep commentary |
| `paired-engineering` | Pass | Fail; retains author-state opening and paired closing construction |

The Codex strict-file trace invokes `scripts/lint-prose.sh --profile personal` on the draft. The Claude strict-file trace does not invoke that check. The Claude `regression-word-choice` output explicitly reports that `../../shared/pattern-classes.md`, `final-gates.md`, and `agent-output-discipline.md` were absent from the installed path. The files existed in the repository, but the entry's paths were interpreted relative to the installed skill symlink. This is a packaging defect, separate from the accepted semantic failures, and is being fixed in humanizer 4.8.1 with local reference links, resolver checks, and installed-path tests.

Raw prompts, outputs, metadata, and tool events remain in ignored `validation/raw/installed-best-effort-smoke/`. The conservative provisional score is Codex 8/8 and Claude 4/8; the Claude formatting case is an editorial judgment to be reconciled in independent review. No score here converts the documented failures to passes.
