# Installed humanizer 4.8.1 follow-up

Date: 2026-09-14. Repository release: [v1.6.1](https://github.com/andyconley/agent-skills/releases/tag/v1.6.1). Humanizer version: 4.8.1. Canonical checkout and both installed skill links read entry SHA-256 `61c6d7577d99f8debc557b1abbbb066369e5462df14c45164ec62204f9c7f293` and policy SHA-256 `53a8a9b787777f4ce0d011fdb1dfd4075c943947801760f97abd8aa3c3565cf2`. The canonical checkout was clean at tag `v1.6.1`; all four local references were readable and byte-identical through both installed runtime links.

The `installed-481-followup` runner started fresh CLI sessions for five affected cases in Claude and Codex. All 10 calls exited 0, read the expected installed entry and policy, and met the source-admission rule at unchanged hashes. The exact protected-span scan found no missing protected spans in edit outputs. Explicit installed file paths were supplied, so this tests fresh installed-path loading and behavior, not automatic skill discovery by name.

| Case | Codex | Claude |
| --- | --- | --- |
| `regression-word-choice` | Pass | Fail: says `The rollback is fast.` without a measured duration, offers ungrounded expiration referents, and combines two operational actions. |
| `paired-engineering` | Pass | Fail: retains `It kept going, and so did I.` |
| `strict-file` | Pass: invokes the personal lint profile | Fail: no personal lint invocation in the tool trace. |
| `audit-formatting` | Pass | Pass: identifies excess emphasis and treats `**one**` as deliberate. |
| `personal-runbook` | Pass | Fail on response gate: procedure content retains facts and plain verbs, but an unrequested policy/method explanation follows the artifact. |

The independent quality review scores **Codex 5/5 and Claude 1/5** on these five checks. This is a sampled installed-client result, not a full final-hash 27-case suite. The Claude `regression-word-choice` trace successfully reads `pattern-classes.md`, `final-gates.md`, and `agent-output-discipline.md` under `~/.claude/skills/humanizer/references/`, and their content is returned. Codex also reads the packaged paths. This closes the installed-reference packaging incident found in 4.8.0; it does not remedy the separately documented model behavior failures.

Raw prompts, outputs, metadata, and tool events remain locally under ignored `validation/raw/installed-481-followup/`. The best-effort waiver accepts the named behavior limits as release risks. They are failures, not passes.
