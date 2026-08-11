# Handback

## What shipped

`humanizer` 4.5.0 to 4.6.0 and `doc-flow-review` 1.4.0 to 1.5.0, on branch `add-ste-vocabulary-discipline`. Four commits, local only, not pushed.

The skills absorb the ASD-STE100 rules they lacked: one term per thing, plain verbs instead of phrasal verbs, no idioms, one instruction per step, and numbers instead of adjectives. The rules attach to reference documents and escalate to the whole document when any section is reference, checklist, or procedure. Humanizer's texture moves stay with argument documents.

The same word-choice rules govern the agent's own replies through `shared/agent-output-discipline.md`, which is why a request that started as a document-rewrite change also changed how both skills speak.

`doc-flow-review` gained one terminology-drift question in the disclosure pass. It reports the drift and leaves the choice of name to the author, so the scope gate holds.

## Commits

| Commit | Slice |
| --- | --- |
| `7c3e1da` | Shared word-choice discipline and the Term Drift pattern class |
| `61a4340` | Humanizer STE rules, document-level escalation, 4.6.0 |
| `e6428ba` | Doc-flow-review terminology finding, 1.5.0 |
| `7333bd8` | Vale `PlainVerbs` and `TermDrift`, documentation surfaces |

A fifth commit carries the fixtures, manual tests, worked example, and these run artifacts.

## Proof

All four automated checks pass. The repo lints clean at 0 errors, 0 warnings, and 0 suggestions across 21 files, so it satisfies the rules it now ships. Rule behavior was probed directly rather than assumed, which is how the `turn one problem` false positive was ruled out.

## Risks

- **Whole-document escalation is blunt.** One rollback section now strips texture from an entire design document. Chosen deliberately; the narrower fix, if it proves wrong, is to escalate only past some share of the document.
- **`PlainVerbs` cannot see quoted material.** It runs at `warning` for that reason.
- **`TermDrift` ships opinions.** `folder` to `directory` flagged the repo's own README. The list is documented as a starter set meant to be replaced.

## Next actions

1. Open a new agent session and confirm the versions report as 4.6.0 and 1.5.0.
2. Decide whether to push and open a PR. Nothing is pushed.
3. The source Slack thread proposed a global `CLAUDE.md` block. Two of its rules were deliberately excluded as code-comment conventions rather than prose rules: comments say why rather than what, and name both behaviours when a platform changed. Those still belong in a personal `CLAUDE.md`.
