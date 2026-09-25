# Validation plan: Slice A completion (chunks 2–6, release 1.5.0)

## Per-step gate

Run these from the agent-skills worktree after each step (0 through 4 and 6), before starting the next step.

1. `bash tests/workbreakdown-contract-test.sh` passes. It includes the Ruby suite and every new `require_text` and `reject_text` pin.
2. `bash scripts/validate-skills.sh` and `bash tests/install-test.sh` pass.
3. `./scripts/lint-prose.sh` reports 0 errors and 0 warnings on every prose file changed in the step.
4. **Compatibility.** Neither of these commands shows any change:
   - `git diff main --stat -- tests/workbreakdown/fixtures/schema2-* tests/workbreakdown/fixtures/schema3-*`
   - a diff of the set-1 to set-3 template assets

   The set-3 hash pins pass. Also inspect the removed-line diff of the Ruby files, which must remove no assertion. The exception is step 0, where lines move to `manifest-validator.rb` unchanged; `git diff --color-moved` shows the move.
5. **Mutation check.** Break at least one new rule per step and confirm the suite fails. Judge by the suite's exit code, never by grepping its output. Commit before mutating, and restore with `git checkout`. Minimum mutants:
   - **Step 0:** have the extracted validator skip `validate_placeholder_definers`. The suite must fail.
   - **Step 1:** accept `jira_context: absent` with a digest; remove the fallback sentence from the prose.
   - **Step 2:**
     - drop the v3 Spike `question` requirement
     - restore either old SOP phrase
     - let the description `question` differ from `classification.question`
   - **Step 3:**
     - allow the `[PLACEHOLDER]` prefix on task-v2
     - allow `classification.placeholder` on task-v2
     - allow an estimate on a placeholder
   - **Step 4:**
     - hard-code `jira-epic-v2` again
     - allow a panel that differs from `shaping`
     - make set 3 the default again
     - drop epic-v2's set-4 compatibility
6. **Public-safety check.** `git diff main -- . ':(exclude).flow' | grep -nE 'AE-[0-9]+|ER-[0-9]+'` is empty, and no private people or project names appear.
7. **Quick quality and test gate.** Two read-only reviewers look at the step's diff and report findings with dispositions: `quality-reviewer` and `test-engineer`. Fix Critical and Important findings before the next step. Record the results in `validation-results.md` under the step.

## Release gate (step 5, private script)

The run uses the frozen gate snapshot. The live-snapshot diff is advisory.

**Structural checks** get no rerun and must all pass:

- **S1:** every Read path is under the worktree skill or the snapshot, and none is under `~/.claude/skills` or `~/agent-skills`.
- **S2:** the reported skill version equals the worktree VERSION.
- **S3:** the transcript has zero Bash, network or MCP tool calls, and the ATLASSIAN_* variables are absent from the agent environment.
- **S4:** every Draft output has exactly one manifest block, and it passes `manifest-validator.rb`.

**Criteria.** Each row shows the fixture case and the field that is asserted. Judged checks use a best-of-3 rerun tolerance.

| AC | Run | Assertion (parsed field) | Negative control |
| --- | --- | --- | --- |
| R0.1 | FX-E1, with answers in the prompt | `shaping.spike_shape`, `task_granularity` and `reviewers` are present with `source: asked` | R0.3 row |
| R0.2 | FX-E3 after FX-E1 (FX-E1's panel is in the snapshot) | entries have `source: reused` and `from_epic` = FX-E1's key; the divergence list names any changed entry | FX-E3 run with no sibling panel: no `reused` entries |
| R0.3 | FX-E1, non-interactive, no answers | every entry is `source: default`; no `reviewers` entry; `unknowns` holds the reviewer gap; the output has no project vocabulary (denylist grep) | this row is the control |
| R1.1 | all six Epics | `sources.existing_children` covers every snapshot child; every child is `existing`/`update` with a key, or new | none |
| R1.2 | FX-STALE-1 | a conflict with ≥2 sources, `winner` = the most recent dated decision, `material: true`; no child `precedent.location` or dependency references the losing ref | none |
| R1.3 | FX-STALE-2 and FX-STALE-3 | a conflict with `stale: true` on the design source | none |
| R1.4 | FX-E1 with the Epic ADF removed from the snapshot | `schema_version: 2`; the output states no Jira context; `unknowns` entries start with `Unverified design claim:` | this row is the control |
| R2.1 | all six Epics | every Spike has `classification.question` and a non-empty `precedent.searched` | none |
| R2.2 | FX-BOUNDS, FX-PATTERN | FX-BOUNDS items stay `type: Spike` with verdict `none` or `unverified`; FX-PATTERN items are `type: Task` with verdict `found` and a `location` | a run without repository files: no Spike becomes a Task, and no verdict is `found` without a `location` |
| R2.3 | FX-E1 | `shaping.spike_shape.value: vertical-slice`; no Spike matches the FX-FE-SPLIT front-end-only pattern (summary/description denylist per `cases.yaml`) | judged, best of 3 |
| R2.4 | FX-E1 Draft; Review of the team's existing children | Draft declares `task_granularity` with its source; Review `findings` has no layer-split or granularity category | none |
| R2.5 | Review of the FX-COMP-STORY rev1 draft | `findings` has `category: component-story` for each FX-COMP-STORY ref | Review of the team's children: no false `component-story` for demoable flows |
| R2.6 | all six Epics | every placeholder uses `jira-task-placeholder-v3`, the `[PLACEHOLDER] ` prefix and a `defined_by` that resolves to a Spike ref; the manifest validates | none |
| R2.7 | all six Epics | every v3 Spike has a `reviewers` key filled from the snapshot or `shaping.reviewers`, or an `unknowns` reviewer gap; no reviewer outside the sources or answers (allowlist per `cases.yaml`) | the R0.3 row |
| R2.8 | agent-skills worktree | the public `reject_text` and `require_text` pins pass | — |
| R5 | all six Epics | every fixture exit condition and in-scope user-facing surface (list in `cases.yaml`) maps to an owning child; the public graph, Apply-refusal and Story-evidence tests pass unchanged | — |
| A-regression | all six Epics | none of the five original failure categories recurs unflagged, checked through the rows above | the rows above |

The results go to `results-<timestamp>.md` in the private run folder. The release gate is green when S1–S4 all pass and every criterion passes within its tolerance.

## Release step (step 6)

- VERSION reads 1.5.0, and the `SKILL.md` version pin passes.
- The migration note is present.
- Neither the root CHANGELOG nor the private files are in the diff.
- The per-step gate passes.

## Final review

Run `flow-review` over the full diff against main, together with the release-gate results. It must end with no open Critical or Important findings.
