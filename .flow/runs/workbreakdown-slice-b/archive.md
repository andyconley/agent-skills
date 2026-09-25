## Archive Summary

### Work Closed

**Run:** `workbreakdown-slice-b`. This is Slice B of the workbreakdown improvements, requirements R3 and R4. Its review was accepted in 02a9e0c. It was merged to main in PR #21 (squash 45eb9cf), and the repository released 1.8.0.

**Workbreakdown 1.6.0 adds:**
- **An optional schema-4 `consolidation` block.** It records a required status, claims, milestone order, and exceptions that each name exactly one later-to-earlier edge.
- **A cross-Epic consolidation step in Draft.** The sibling children are read in two passes, and only the request can opt out. The step proposes owners for decisions this Epic shares with a sibling. It takes milestone order from a declared order, then Initiative rank, then unknown.
- **Graph checks for edges between milestone Epics,** in Draft and in any Review. Each later-to-earlier edge is reported as a recorded exception or a defect, and copied acceptance without a forward edge is reported with fixed labels.
- **Audit semantic link findings.** There are five checks, and ready statuses come only from the request. Each link's history is classified, defaulting to `unknown`.
- **A stricter Draft self-check.** When it finds a gap, the Draft rewrites the manifest instead of appending a correction, and it parses the manifest as YAML before returning.

**Compatibility:** schemas 2 and 3, template sets 1 to 4 and the registry are unchanged. Every approved manifest stays valid.

### Validation

- **Automated:**
  - At every step, the contract suite, `validate-skills`, `install-test` and Vale passed. Vale reported 0 errors, 0 warnings and 0 suggestions.
  - Every named mutant from M40 to M70 was caught, judged by exit code on a committed tree.
  - CI passed on macOS and Ubuntu for PR #21 and on main.
- **Manual:**
  - Four step reviews and three acceptance reviews (quality, test and security) ran. None found a Critical issue, and every Important finding was fixed.
  - The maintainer ratified the link-classification answer key before the classification rule was written.
- **Runtime:** the private release gate is green. 131 checks pass across 15 isolated headless Opus runs on the frozen `gate-b` snapshot, and the checker self-test passes on all 15. It has three caveats:
  - FX-E3 solo passed on a single attempt after its last fix.
  - The results span skill commits aed48c6 and 85b486e, which differ by two wording sentences.
  - The acceptance-review fixes in 823abaa were validated by the suite only, by maintainer decision.

### Residual Risks

- **Format rules.** The model's compliance varies: one broken manifest and one missing label appeared in earlier attempts.
- **Two-pass sibling read.** A collision described only deep inside a sibling card can be missed.
- **Claims.** A pair that excludes the scoped Epic is found only by its own Epic's Draft.
- **Draft cost.** A Draft takes 5.5 to 14 minutes and costs $2 to $4 on Opus.
- **Judged checks.** They rest on the ratified answer key and on a snapshot frozen on 2026-09-24.

### Follow-up Work

- The release check's divergence-list parser should accept an inline label.
- Draft cost could drop further. Most reads are now the Epic's own children.
- Non-interactive Drafts still take reviewers from sibling panels. That was deferred from the security review.
- The validator does not check the Epic field of an exception endpoint given as an existing child's Jira key.
- The stale-design detection weakness (R1.3 FX-STALE-2) carries over from 1.5.0.

### Capability Gaps Observed

- **Handback draft not checked.** A drafting role returned a handback with factual errors, and nothing checks role drafts against run artifacts before they become durable.
- **No way to amend criteria.** Implementation rulings narrowed approved acceptance criteria, and the only recourse was an amendments section appended by hand.
- **No re-gate decision point.** Review fixes changed model-facing prose after the release gate, and no lane step asks whether the gate must rerun.
- **No mutant harness.** Named mutants ran through a hand-written scratch script again.
- **No tolerance standard for judged checks.** Judged model-behaviour checks need tolerance and minimum-sample rules, and single-attempt passes after a fix needed caveats.
- **Fixture expectations not checked.** A fixture expectation came from draft artifacts and had no live support until the gate exposed it.
- **No wait contract for long runs.** Multi-hour gates ran with no declared duration or progress signal.
- **No cost budget.** The definition template has no latency or cost budget, so a large per-run cost increase surfaced only during validation.
- **Ledger:**
  - Reused: `role-output-not-verified-before-durable-use`, `acceptance-criteria-cannot-be-amended-honestly`, `review-fixes-re-enter-with-no-review`, `mutation-checks-have-no-harness`, `judged-release-checks-have-no-tolerance-standard`, `synthetic-fixtures-not-checked-against-real-data` and `long-running-work-has-no-wait-contract`.
  - New: `definition-has-no-cost-budget`.
- **Repeats:**
  - Already promoted: role-output (12), review-fixes (7), acceptance-criteria (6) and mutation-checks (3).
  - Still open: long-running-work (3), synthetic-fixtures (3) and judged-release-checks (2).

### Memory Updates

- **STATE (`.flow/memory/STATE.md`):** it now says no run is in flight, 1.6.0 is merged and archived, and the workbreakdown follow-ups are open.
- **Runtime memory:** `project_workbreakdown_slice_a` was rewritten to cover both slices, the `run.sh --suite` release check, the rulings, the follow-ups and the gate lessons. Its index line in `MEMORY.md` was updated.
- **Parent-overlay implications:** the private release check and the Slice B evidence live in the KB workspace, committed on its worktree branch. No KB-level archive is needed beyond that.
