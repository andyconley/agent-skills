## Archive Summary

### Work Closed

- Run `workbreakdown-template-guidance-v2`, lane `implement` through `review`, closed 2026-09-08.
- `workbreakdown` moved from 1.1.0 to 1.3.0. The v1 Epic, Story, Task, and Spike templates were frozen byte-for-byte as `*-v1.md` and are now addressed by SHA-256 in a version-aware registry. Five v2 templates were added and made the default for new Drafts, splitting Spike into design and investigation variants.
- Descriptions became concise through a required/conditional key split rather than shorter templates. The v1 entries declared every key required, which is what produced boilerplate headings and `N/A` filler; the v2 entries render conditional sections only when they carry content. Epic went from 11 required keys to 4 required and 5 conditional, Story from 8 to 2 and 8.
- Manifest schema 3 added scoped Epic description authority. Schema 2 remains child-only and is rejected outright if it carries Epic mutation keys. Schema 3 requires an explicit disposition, exact template binding, an expected-current ADF digest captured before approval, journaling, and final readback. Epic creation, deletion, reparenting, retyping, ranking, status, and non-field writes stay prohibited by name.
- Story lifecycle gates separated planning readiness from delivered evidence. `IMPLEMENTATION READY` needs a documentation and automated-test plan; `IN REVIEW` needs published documentation and passing mapped tests in a named environment. A demonstration supplements that evidence and never replaces it.
- Two decisions taken during review widened and then narrowed the contract. The v2 content bar now applies to every template set, so grandfathering covers the frozen asset and its declared key set but never content. Story suite location and environment became optional at plan time, because a Story could not otherwise be drafted before its repository existed and the skill forbids inventing either value.
- Acceptance review found and closed four Critical and eight Important defects. Details in `review.md`.

### Validation

- Automated: shell syntax, skill validation across 3 skills, installer 17/17, the workbreakdown contract and parsed fixture suites, Vale at 0 findings across 45 files, and `git diff --check`. All pass in the default locale and under `LC_ALL=C`, which CI now runs as a separate step. CI is green on `ubuntu-latest` and `macos-latest`.
- Mutation checks, three of them, each confirmed to fail for the intended reason and then restored: altering the registered Epic v1 hash; removing `## Downstream updates` from `spike-design-v2.md` with all three hash sites realigned so the drift check could not mask it; and setting `VERSION` out of step with `SKILL.md`.
- Manual: none of the ten behavior checks in `validation-plan.md` were run. Static fixture coverage was added for parts of checks 1, 2, 7, and 8. The judgment halves, and checks 3 through 6, 9, and 10, still need a live agent or live Jira.
- Runtime/deploy: the installer refreshed both runtime links; Codex and Claude Code both resolve the skill. Repository releases v1.3.0 through v1.4.1 published. Release notes were empty for four releases until the cause was found and fixed; all historical entries were backfilled.

### Residual Risks

- The Epic write boundary is specification-only. Live Apply has never executed, so nothing confirms that a real Atlassian ADF round-trip is digest-stable under the stated normalization, that the preservation projection is constructible from a real Epic's field payload, that genuine drift produces zero writes rather than a partial write, or that a bare Epic behaves as the empty-document sentinel predicts.
- The skill ships no executable code. Every structural assertion runs against a Ruby reimplementation of the contract, which proves the specification is self-consistent, not that an agent following `SKILL.md` produces conforming output.
- Anti-bloat is only partly machine-checkable. Placeholders, filler values, and two literal generic strings are caught. "Do not repeat the same fact" and "every sentence must help" are prose an agent satisfies by paraphrase, and the Epic duplication check is exact-string and defeated by rewording.
- A v1-bound Story cannot express the v2 evidence keys, so its documentation and automated-test obligations rest on Review and Audit judgment rather than manifest structure.
- Nothing prevents a new manifest from declaring `template_set.version: 1`. v2-as-default remains advisory.

### Follow-up Work

- Run the first live Apply in an isolated Jira project against both a bare and a populated Epic, with a deliberately induced drift case, before this authority touches a real Epic.
- Run the ten manual behavior checks in fresh Codex and Claude Code sessions.
- Decide whether to enforce template set 2 on new manifests. This needs a rule for what counts as a new manifest.
- Consider a release-workflow assertion that generated notes contain at least one section heading whenever the range holds a non-`chore` commit. The empty-notes defect survived four releases because the failure exits zero.

### Capability Gaps Observed

- Work shipped past its own lane with no objection. The run sat at `handback_ready` while two PRs merged and three releases published, and Flow held that state throughout without surfacing that validation was still pending.
- Recovering the legal path out of `handback_ready` meant reading `TRANSITIONS` in `cli/runstate.py`. `flow run transition` rejects an unknown event without naming the legal ones, and no subcommand lists them.
- Ledger: `release-publishes-before-validation` reused; `legal-transitions-not-discoverable-from-cli` new.
- Repeats: `release-publishes-before-validation`, now seen 2 times.

### Memory Updates

- STATE (`.flow/memory/STATE.md`): created. This project had no memory overlay; the file records three durable facts that cost time this session.
- Runtime memory entries written: n/a — no durable provider decisions beyond the project STATE file.
