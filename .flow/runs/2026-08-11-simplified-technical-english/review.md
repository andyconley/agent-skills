# Review

## Findings and dispositions

| # | Finding | Disposition |
| --- | --- | --- |
| 1 | A naive `turn on` token matches `turn one problem`, which appears in `doc-flow-review/SKILL.md:24`. | Resolved. Vale's `substitution` check applies word boundaries by default. Verified against a probe file before commit; the line was not flagged. |
| 2 | Error-level Vale rules would lint the skill files into a red build, because CI sets `fail_on_error: true` over `skills`, `shared`, and `examples`. | Resolved. `PlainVerbs` ships at `warning`, `TermDrift` at `suggestion`. Repo lints clean at 0 errors, 0 warnings, 0 suggestions across 21 files. |
| 3 | Regression fixtures quote bad prose, which Vale would flag. | Resolved. The established fixture format puts bad source inside fenced code blocks, which Vale skips. New fixtures follow it. |
| 4 | `cell` and `workcell` were used as drift examples. That is product vocabulary in a public repo. | Resolved. Replaced with `job`/`task` and `folder`/`directory` in both the skill and the shared pattern class. |
| 5 | Two humanizer fixtures were added but none for doc-flow-review, whose behavior differs: it reports drift rather than fixing it. | Resolved. Added `examples/regression/doc-flow-term-drift.md`, whose bad case is a review that rewrote the prose. |
| 6 | `TermDrift` prefers `directory` over `folder`, which flagged the repo's own README. | Accepted and fixed. The rule has opinions by design and ships at `suggestion` with instructions to replace the list. |

## Risks carried forward

**Whole-document escalation is aggressive.** A long design document with one short rollback section now takes the rules throughout and loses its texture moves. This was chosen deliberately over per-section application, on the grounds that a reader working through a procedure should not switch registers. The escape hatch is that the branch is inferred from purpose, so a user can direct the document type explicitly. If this proves too blunt in practice, the narrower fix is to escalate only when the procedure exceeds some share of the document.

**`PlainVerbs` cannot see quoted material.** Humanizer preserves quoted output exactly, but Vale will flag a phrasal verb inside a quoted error string. The rule runs at `warning` and `tools/vale/README.md` records the reason.

**The before/after is constructed, not captured.** `examples/ste-before-after.md` labels itself as a worked example rather than a customer artifact. It demonstrates the rules honestly but is weaker evidence than a real capture would be.

## Scope check

No changes to `install.sh`, `.github/workflows/ci.yml`, `skills/manifest.tsv`, or `tools/vale/.vale.ini`. `BasedOnStyles = AgentVoice` picks up the new rules without configuration.
