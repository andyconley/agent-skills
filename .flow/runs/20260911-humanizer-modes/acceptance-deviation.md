# Best-effort release acceptance deviation

Date: 2026-09-14. Work ID: `20260911-humanizer-modes`.

Andy Conley explicitly instructed: “best effort release with the known failures documented.” This supersedes the approved plan's requirement that every live Claude and Codex behavioral assertion pass before release. It does not convert a failed assertion into a pass.

Known current-hash failures before the complete candidate suite:

- Claude default engineering `protection-engineering` retained the unprotected personal wish `I wanted **one** quiet evening.` The same source sometimes passed in other fresh sessions, so behavior is variable.
- Claude `regression-word-choice` changed the unsupported rollback statement to `Rollback is fast.` despite no duration in the source. In some runs it also suggested ungrounded expiration referents. A separate baseline changed source `task` to `job` without evidence.
- Some Claude engineering audit repair directions added an observation that the trail “appeared to end,” although the source only reported a prior belief.

The complete candidate suite should still be run in both runtimes to discover and document additional observed limitations. Existing static validation, source-provenance, exact protected-span checks, independent review, CI, PR, canonical sync/install, and fresh installed-client checks remain required as evidence. The release description and user-facing documentation must name material live failures and describe the skill as best-effort. Installed live results must be reported as observed, not inferred from the candidate or temporary native-plugin surrogate. A new failure involving exact protected technical material, false factual claims, or another material risk requires review before merge; this deviation is not blanket acceptance of unknown failures.

## Complete-suite and final-hash disposition (2026-09-14)

The complete pre-change two-runtime suite had 54 source-admissible calls. Independent reviews scored Claude 22/27 pass and Codex 25/27 pass. The exact failed cases and evidence are in `validation-results.md`, `validation/full-claude-review.md`, and `quality-review-resume.md`. These outcomes are accepted as *known best-effort limitations*, not converted to passes. The previously unknown Codex action-target loss and source-expectation loss prompted a general policy fix. All eight final-hash affected-case retakes were source-admissible; Codex preserved those facts in the retake, while Claude still made an unsupported rollback-speed claim and suggested ungrounded expiration referents. The README discloses these limits. Exact protected spans were retained in the complete-suite edit outputs.

This disposition permits release with transparent documentation under Andy Conley's best-effort instruction. It does not assert that the final policy passes every semantic fixture or that untested outputs are reliable. Remote CI and fresh installed-client observations remain separate delivery checks.
