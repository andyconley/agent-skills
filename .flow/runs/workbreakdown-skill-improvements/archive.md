## Archive Summary

### Work Closed
- **Run:** workbreakdown-skill-improvements.
- **What it covered:** it defined the full improvement (R0–R5, Slices A and B) and chose the approach. It then planned, implemented and reviewed only chunk 1: the manifest schema 4 foundation, with optional `shaping`, `sources` and per-child `classification`. Schema 2 and 3 were unchanged.
- **Outcome:** review accepted at bafcc78, with date-check follow-ups in b9d4bfc, 5816ae2 and ce19d0e.
- **Why the rest moved:** chunks 2–6 continued in workbreakdown-slice-a-completion, because this run could not re-enter planning after review.
- **Release:** released as part of skill 1.5.0, merged to main in PR #18 (07648ab).

### Validation
- **Automated:**
  - The shell contract suite gained new `require_text` pins.
  - The Ruby reference validator suite gained schema-4 fixtures and about 45 new rejection and positive cases.
  - The schema-2 and schema-3 fixture diffs are empty.
  - A vocabulary pin and generated rule sentences tie the validator to the prose contract.
- **Mutation checks:** 15 of 15 mutants were caught when re-run by exit code, plus two date-check mutants.
  - One date mutant, M16, first survived and was recorded as caught by mistake.
  - Tests for the other ISO date forms were added, and the record was corrected.
- **Manual:**
  - The independent quality and test reviews, plus a review of the fix commit.
  - Every Important finding was fixed in the review lane (54f665a, cedeb73, bafcc78).
- **Runtime/deploy:** none for this chunk. The live release gate ran in the second run.

### Residual Risks
- Free-text rules are pinned only by tests and prose pins.
- The Ruby validator is a reference reimplementation of the contract, not the skill's own behavior.

### Follow-up Work
- Chunks 2–6 were delivered in workbreakdown-slice-a-completion, which also resolved the chunk-1 deferral: the Epic path is now generalized.
- Slice B, R3 (cross-Epic consistency) and R4 (semantic Audit), needs its own solutioning.

### Capability Gaps Observed
- **Tool grants too narrow for the brief:** reviewer roles were briefed to run the suites, but their tool grants had no shell. (`agent-brief-exceeds-tool-grant`, reuse, now seen 5 times)
- **No lane back into review for fixes:** each fix re-check was dispatched by hand, and two rounds of fixes introduced new contradictions. (`review-fixes-re-enter-with-no-review`, reuse, 6)
- **Delegated drafts not checked:** handback and archive drafts carried factual errors, and nothing required checking them against the run record. (`role-output-not-verified-before-durable-use`, reuse, 11)
- **Orchestration cannot see out-of-tree work:** the manifest could not declare work or evidence held in a second, private repository. (`orchestration-cannot-reference-out-of-tree-outputs`, reuse, 3)
- **No mutation harness:** mutation checks were hand-rolled at every step. (`mutation-checks-have-no-harness`, reuse, 2)
- **Checker shipped without a self-test:** the release-gate checker had none until review demanded one. (`verification-code-ships-unverified`, reuse, 4)
- **No honest amendment record for criteria:** two criteria were relaxed by ruling, with no record tying each change to its evidence. (`acceptance-criteria-cannot-be-amended-honestly`, reuse, 5)
- **No isolation standard for an agent under test:** proving isolation took an ad hoc probe. (`agent-isolation-has-no-ambient-context-boundary`, reuse, 2)
- **A running job's inputs are not frozen:** a long validation run broke when files it read were edited mid-run. (`in-flight-run-inputs-not-frozen`, new)
- **No tolerance standard for judged gates:** the tolerance for model-judged gate checks was invented during the run, and there was no stop rule. (`judged-release-checks-have-no-tolerance-standard`, new)
- **Ledger:** all ten keys recorded against workbreakdown-slice-a-completion, the run that closed Slice A. They apply to this whole two-run effort. Eight are reuses and two are new.
- **Repeats:**
  - `role-output-not-verified-before-durable-use` 11
  - `review-fixes-re-enter-with-no-review` 6
  - `agent-brief-exceeds-tool-grant` 5
  - `acceptance-criteria-cannot-be-amended-honestly` 5
  - `verification-code-ships-unverified` 4
  - `orchestration-cannot-reference-out-of-tree-outputs` 3
  - `mutation-checks-have-no-harness` 2
  - `agent-isolation-has-no-ambient-context-boundary` 2

### Memory Updates
- **STATE (`.flow/memory/STATE.md`):** the current-work note now says no Flow run is in progress or awaiting archive, workbreakdown 1.5.0 is released, and Slice B needs solutioning.
- **Runtime memory entries written:** `project_workbreakdown_slice_a.md`. It records that Slice A is released, the maintainer rulings, where the private release check lives, and that Slice B is next.
