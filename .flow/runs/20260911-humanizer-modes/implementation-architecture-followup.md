# Humanizer architecture follow-up after live failures

Status: decision needed before release. Date: 2026-09-14.

## Evidence

The selected-mode capsule experiment did not meet its stop condition: source-admissible Claude runs retained an unprotected personal wish in default engineering mode and upgraded a vague rollback claim to `Rollback is fast.` It was reverted as one unit. A restored combined-policy baseline then showed variable behavior at the same hashes: journal and wish cases passed, while the runbook changed source `task` to `job` and added process commentary.

A consolidated source-to-output workflow and explicit personal construction inventory now exist in the current combined candidate. Its five focused source-admissible Claude calls still failed the default engineering wish and rollback assertions; Codex passed the paired controls. An explicit-engineering prompt improved the wish and speed cases but added unsupported example referents in a clarification. This is one diagnostic contrast, not a reliable mode-selection proof.

A session-only Claude plugin copy loaded as the namespaced native `humanizer-candidate:humanizer` skill, with exact current candidate entry/policy hashes and a candidate policy read. The global installed humanizer link remained pointed at canonical 4.7. The native runbook output still said `Rollback is fast.` and offered possible expired items not established by the draft. It is a surrogate diagnostic, not installed-release evidence. Claude documents `--plugin-dir` as a session-only local test mechanism and namespaces plugin skills: https://code.claude.com/docs/en/plugins .

Independent quality review in `quality-review-resume.md` retains REQUEST CHANGES. The current candidate has no acceptance pass. The prior approved plan requires source-verified full candidate behavior, CI/PR/merge, canonical sync/install, and fresh installed live proof; none of those delivery gates can be honestly claimed from these runs.

## Architecture assessment

The failures cross different instruction layouts and occur after correct source loading. They cannot be attributed solely to a missing file or stale installed skill. Claude's default-mode behavior varies across fresh sessions, and source-fidelity failures remain under explicit engineering and native loading. More instructions aimed at the exact examples would tune to the fixture rather than establish a durable boundary.

The smallest defensible path is to hold the release gate while deciding whether the skill is expected to meet the approved per-case live assertions in both runtimes, or whether a documented best-effort contract with known model variability is acceptable. The latter changes the approved acceptance contract and needs the engineer's explicit product decision. Under the current approved contract, continue architecture work on a genuinely different enforcement mechanism or stop without publishing. Do not lower a fixture assertion based only on a model's output.

## Current local state

The combined-policy workflow refinement remains uncommitted and is explicitly marked failed in `validation-results.md`. Raw evidence and reversible backups are preserved. No shared generic skill files, canonical installation, GitHub branch, or release was changed. `mark-handback-ready` has not run.
