## Archive Summary

### Work Closed
- **Run:** workbreakdown-slice-a-completion.
- **What changed:** it delivered chunks 2–6 and released skill 1.5.0.
  - source authority, with the schema-2 fallback and the `unbound` Epic
  - classification, with v3 Spikes, a precedent definition and review findings
  - placeholder Tasks
  - recorded shaping answers, with the epic-v3 panel and template set 4 as the default
  - the Draft self-check
- **Merge:** main, in PR #18 (squash 07648ab). The repository release tagged 1.7.0.
- **Outcome:** review accepted, with every Critical and Important finding fixed and re-checked.

### Validation
- **Automated:**
  - The per-step gates passed: contract suite, skill validation, install test, and Vale at 0/0/0.
  - The compatibility diffs were empty, and the public-safety grep was clean.
  - All 34 named mutants were caught by exit code on committed trees.
  - CI passed on macOS and Ubuntu for PR #18.
- **Manual:**
  - A quality gate and a test gate ran after each step, with every Critical and Important finding fixed.
  - At acceptance, quality, proof and security reviews ran, plus a re-check of the fixes.
  - Post-review fixes (7d1b83b, bb2016f) came after the live gate. The suite and mutant M34 cover them, but they were not re-run live.
- **Runtime/deploy:** the live release gate used the private release check in the maintainer's knowledge base. It made 12 isolated headless runs:
  - six fixture-Epic Drafts
  - four controls: defaults, no Jira, no sibling panel and no repositories
  - two Reviews

  Structural checks S1–S4 and every negative control passed on every run and rerun. Every criterion passed except R1.3 FX-STALE-2. The checker self-test caught 77 of 77 mutants.

### Residual Risks
- **R1.3 FX-STALE-2 is an accepted weakness.** Detecting a design-page deferral that contradicts the Epic's scope passed on about half of attempts. It failed the 2-of-3 rule in the final gate, and the maintainer accepted it on 2026-09-24.
- **Maintainer rulings are in `validation-results.md`:**
  - the `unbound` Epic disposition
  - FX-PATTERN narrowed to the list-read card
  - R2.5 relaxed to "at least one rev1 component Story, never the demoable flow"
- **The validator is a reference reimplementation,** not the skill itself.
- **Judged checks and pinned prose depend on exact wording.** Judged checks use patterns, and the prose rules are pinned by exact text.
- **The gate snapshot is frozen at 2026-09-24.**
- **Home paths remain in older public run records.** This was an open suggestion from review.

### Follow-up Work
- Slice B, R3 and R4, needs its own solutioning and planning.
- Strengthen stale-design detection, R1.3 FX-STALE-2.
- Decide whether "a placeholder cannot carry a found precedent" should become an enforced rule.
- Scrub home paths from older public run records.

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
- **Ledger:** all ten keys recorded against workbreakdown-slice-a-completion. Eight are reuses and two are new.
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
