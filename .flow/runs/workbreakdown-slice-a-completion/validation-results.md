# Validation results: Slice A completion

## Implementation clarifications (maintainer, 2026-09-24)

These settle four gaps in step 5 that the approved plan left open.

1. The agent under test also gets read-only `--add-dir` access to the two precedent repositories, so FX-PATTERN can reach `verdict: found`. The R2.2 control run omits them.
2. Rerun rule: a judged check that passes on its first run passes. A failing judged check runs twice more and passes only when both reruns pass, which is 2 of 3. This replaces "best of 3" in `validation-plan.md`.
3. The agent under test runs on Opus.
4. The release script lives in the KB worktree's `utilities/workbreakdown-release-check/` on its existing `claude/*` branch. The snapshot and results live under the private run's `evidence/` folder and are committed to KB locally.

## Per-step gates

Each gate ran `bash tests/workbreakdown-contract-test.sh`, `bash scripts/validate-skills.sh`, `bash tests/install-test.sh` and `./scripts/lint-prose.sh` on every changed prose file. All passed with Vale at 0 errors, 0 warnings and 0 suggestions. The compatibility diff of the `schema2-*` and `schema3-*` fixtures and of the set-1 to set-3 template assets was empty at every step. The public-safety grep returned no match at every step. Every mutant was run on a committed tree, judged by the suite's exit code, and restored with `git checkout`.

### Step 0: extract the validator (3f8f987)

- A multiset comparison of removed and added Ruby lines showed a pure move. The only additions are the new file's header comment and the `require_relative` line.
- M0, the validator skipping `validate_placeholder_definers`: caught.
- There was no separate reviewer gate, because step 0 is not a chunk. Its diff was included in the step-1 gate.

### Step 1: source authority (1ed21c1, fixes f687ed6)

- **Mutants, all caught:**
  - M1: accept `jira_context: absent`
  - M2: reword the SOP fallback sentence
  - M3: drop the fallback phrase from the contract's Draft output
  - M4: delete the Jira amendment rule
- **Assertion change:** the chunk-1 positive test "schema 4 with `jira_context: absent` validates" became a negative, per decision 3.
- **Quality gate:** approved with one Important finding. SKILL.md's Draft list lacked the Jira context line and the reconciliation table. Fixed in f687ed6, which also:
  - unified the definition of Jira context
  - tied a stale source to `stale: true`
  - added material conflicts to the Draft output
- **Test gate:** no Critical or Important findings. The precedence case it listed as missing is already covered by `children_without_jira`.

### Step 2: classification (56d84c3, fixes af85687)

- **Mutants, all caught:**
  - M5: drop the v3 Spike question requirement
  - M6 and M6b: restore each old SOP phrase
  - M7: let the question differ
  - M8: let the precedent differ
  - M9: add a `layer-split` category
  - M10: drop the set-4 existence check
  - M11: exempt the whole precedent from the quality check
  - M12: drop the Design Spike v3 render row
  - M13: skip validation of the description precedent
  - M14: disallow classified Stories
  - M15: allow a blank fallback question
- **Deviations from the plan:**
  1. The compatibility marks moved from step 4 to step 2:
     - epic-v2, task-v2 and the v2 Spikes became `[2, 3, 4]`
     - story-v3 became `[3, 4]`

     This was needed because `validate_registry` requires every set-4 default to be compatible with set 4.
  2. The description precedent must also equal `classification.precedent`. The plan named only the question.
  3. `precedent.verdict` is exempt from the "empty filler value" rule, because `none` is an enumerated verdict. Renaming the verdict would have reopened chunk 1's schema beyond decision 6.
  4. Added a test that the template guide's render table matches `RENDER_EXCEPTIONS`.
- **Quality gate:** approved with three Important prose findings, all fixed in af85687:
  - the ambiguous "either" in SKILL.md
  - SOP step 5 conflicting with the vertical-slice default
  - the SOP's Spike variants text not covering the v3 fields
- **Test gate:** two Important gaps, both fixed with new cases: a classified Story, and a Task's classification question.

### Step 3: placeholder Tasks (211a16b, fixes 9315c77)

- **Mutants, all caught:**
  - M16: allow the prefix on task-v2
  - M17: allow `classification.placeholder` on task-v2
  - M18: allow an estimate on a placeholder
  - M19: let the definer differ from the classification
  - M20: allow an unclassified placeholder
  - M21: allow an unprefixed placeholder
  - M22: skip the description definer
  - M23: unscope the SOP acceptance count
  - M30: accept a loose prefix
- **Deviation from the plan:** in schema 2 and 3 there is no classification, so a placeholder Task is valid when its description's `defined_by` names a Spike ref or a Jira key. Schema 4 requires `classification.placeholder` and requires the two to be equal. This follows the v3-Spike pattern.
- **Quality gate:** approved with one Important finding. The contract implied the placeholder classification applies in every schema. Fixed in 9315c77, which also:
  - kept the acceptance-count rule for every Task other than a placeholder Task, instead of scoping it to `jira-task-v2` only, so v1 Tasks keep the rule
  - stated what a placeholder's `done_when` means
  - documented `defined_by` key resolution in the template guide and in final verification
  - added a preflight check that a keyed definer is a Spike
  - renamed the template-token quality error to "unresolved template token"
- **Test gate:** one Important gap. The placeholder cases covered only proposed children. Fixed with update, existing and near-miss prefix cases.

### Step 4: shaping answers and template set 4 (1a8d986, fixes e13a868)

- **Mutants, all caught:**
  - M24: hard-code jira-epic-v2
  - M25: let the panel differ from shaping
  - M26: set the registry default back to 3
  - M27: have the validator accept default 3
  - M28: drop epic-v2's set-4 compatibility
  - M29: allow the panel in schema 3
  - M31: skip panel shape validation on a verified Epic
- **Choice the plan left open:** the portable `source_order` default is `[jira-amendment, jira-description, design-page]`. The default uses it only to break ties between sources with the same date. An asked or reused order replaces recency. Commit 09ca879 later narrowed this: a default or reused order only breaks ties, and only an asked order replaces recency.
- **Quality gate:** requested changes, with six Important prose findings, all fixed in e13a868:
  - non-interactive runs were not defined or stated
  - the order of reading existing work and collecting shaping was inconsistent
  - there was no rule for siblings that disagree
  - the `source_order` default was a rule, not a list
  - the schema-2 fallback had no way to record shaping
  - an Epic update could silently remove a live panel
- **Test gate:** one Critical finding, verify-side panel shape validation, fixed with a case caught by M31. The procedure pins were strengthened.

### Step 5: release check (in progress, paused 2026-09-24)

- **Harness status:** the private harness and the frozen gate snapshot are committed in the KB worktree. The harness is hardened after its quality and test gates, and a checker self-test was added.
- **Skill gaps found by the harness, all fixed and committed:**
  - documentation location (50557a3)
  - classification of existing Spikes (50557a3)
  - the child table's exit-condition column (50557a3)
  - YAML quoting (58fb44a)
- **Isolation evidence:** a positive-control codeword test shows that `--restricted` keeps every `CLAUDE.md` out of the agent's context.
- **Gate run:** the first full gate was stopped partway when the session paused. Its partial results are not gate evidence.
- **Pending before the next full gate:** harness fixes from the re-check of the harness fixes:
  - the R2.2 and S4 self-test mutants were no-ops on some runs
  - P1 reply parsing and path boundary
  - S1 relative and trailing globs
  - the selftest completion marker
  - R2.3 backend terms
  - clearing stale attempts
  - an offline recheck mode
- **Remaining after a green gate:**
  - step 6: VERSION 1.5.0 and the migration note
  - HANDOFF.md
  - `mark-handback-ready`
  - `flow-review`

#### Step 5 maintainer rulings (2026-09-24)

- **Option A, template-less Epics:** schema 4 gains `epic.disposition: unbound`. It binds only the observed ADF digest of a live Epic whose description fits no template, and it never authorizes a write (38aa866). Draft also self-checks every description against its template's required keys and the manifest invariants before returning.
- **R2.5:** relaxed. Review must flag at least one rev1 Story as `component-story` and never the demoable flow Story. Review consistently flagged a different pair of rev1 Stories from the tabletop's pair.
- **R2.2:** FX-PATTERN is narrowed to the list-read card. The delete, reverse-lookup and save-and-apply cards now hold genuinely open questions in live Jira, which supersedes the tabletop expectation. FX-BOUNDS and the negative control are unchanged.

### Step 5: release gate result (final)

- **Final gate.** It ran on skill commit 0d85152 against the frozen private snapshot. The harness and results are private, in the KB worktree.
  - It made 12 isolated headless Opus runs with reruns.
  - Six were Drafts of the six fixture Epics.
  - The rest were a defaults control, a no-Jira control, a no-sibling-panel control, a no-repository control, and two Reviews.
- **Structural checks, S1–S4:** pass on every run and every rerun. S1 checks paths, S2 the version, S3 isolation, and S4 manifest validity.
- **Negative controls:** R0.2-control, R0.3, R1.4, R2.2-control and R2.5-control all pass.
- **Criteria that pass:**
  - R0.1 and R0.2, including sibling reuse
  - R1.1, and R1.2 across two runs
  - R1.3, partial: FX-STALE-3 passes, and FX-STALE-2 is the accepted weakness below
  - R2.1–R2.5 and R2.7
  - R5
  - R2.8 and the unchanged public tests
- **R2.6** is carried by S4.
- **Checker self-test:** doctored copies of every run's first attempt, 77 mutants in all. Every targeted check flips to fail: 0 missed.
- **Accepted residual weakness:** R1.3 FX-STALE-2 failed, failed, then passed, so it fails the 2-of-3 rule. Across the three full gates, detecting that design-page deferral contradicts the Epic's scope landed about half the time. The maintainer accepted this on 2026-09-24 as a documented weakness instead of another skill cycle. It carries forward as a follow-up.
- **Skill gaps the gate found, all fixed before the final gate:**
  - documentation location, existing-Spike classification and the child table's exit-condition column (50557a3)
  - YAML quoting (58fb44a)
  - the precedent definition and live prefixed summaries (4512a28)
  - the `unbound` Epic for a template-less Epic, and the Draft self-check (38aa866)
  - angle-bracket tokens and single precedent paths (0d85152)
- **Isolation evidence:** a positive-control codeword test showed that no `CLAUDE.md` reaches the agent under `--restricted`.

### Step 6: release (28bd8cb)

- VERSION is 1.5.0, and both version lines in `SKILL.md` match. The version pin catches a mismatch: mutant exit 1.
- The migration note is in the contract's Migration section. There is no hand-written skill CHANGELOG, and the root CHANGELOG is untouched.
- The per-step gate passes:
  - the contract suite, `validate-skills` and `install-test`
  - Vale at 0/0/0
  - an empty diff for the `schema2-*` and `schema3-*` fixtures and the set-1 to set-3 assets
  - an empty public-safety grep

### After acceptance review (7d1b83b)

- These fix coherence gaps the acceptance review found. They came after the release gate, which ran on 0d85152.
  - The schema-4 example now uses template set 4 and a separate placeholder Task, and a test loads it.
  - Every schema-4 Spike requires classification. The validator enforces this, mutant M34 is caught, and the final gate's R2.1 already showed Drafts classify every Spike.
  - Final verification and template binding now cover schema 4.
  - The Apply preflight stops an update that would delete a live panel.
  - An asked `source_order` re-resolves earlier conflicts.
  - `from_epic` may name the Epic's own panel.
  - The stale "schema-3 Epic rules unchanged" wording is fixed.
- The changes are validated by the per-step gate: the suite, `validate-skills`, `install-test`, and Vale at 0/0/0. They were not re-run through the live release gate.
- Private local paths were scrubbed from the public run records.
