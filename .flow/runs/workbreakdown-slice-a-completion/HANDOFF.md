# Workbreakdown Slice A Completion Handoff

## What shipped: skill 1.5.0

Branch: `claude/workbreakdown-slice-a` (local only, not pushed)

**Source authority and schema-2 fallback.** Draft now reads existing Jira work—descriptions, amendments, statuses, links, and changelogs—before proposing new children. It reconciles every proposed item to an existing card, reporting disposition (`existing`, `update`, or `new`) and material conflicts with both sources and the winner. When the Epic has no Jira context (no ADF digest), Draft emits schema 2 and states so explicitly in the output; each design claim it relies on is recorded in `unknowns` as `Unverified design claim:` to mark the source as unverified. The fallback preserves schema 2 validity; schema 4 is not loosened.

**Classification with v3 Spikes and findings.** Spikes bound to the v3 templates now carry two required fields: a `question` that matches the Jira description, and a `precedent` that holds search evidence and a verdict. A Task that relies on a pattern carries `precedent` with `verdict: found` and a location; Draft never converts a Spike to a Task on an unverified precedent. Review output gains a categorized `findings` block that flags misclassified Spikes (a Task that relies on a pattern whose precedent verdict is unverified or none), component Stories (non-demoable flow Stories), stale sources, and invalid manifests. The SOP refinement tightens the Spike-split rule (narrow questions, independent questions only) and the Task-size rule (forecastable, verifiable completion, split if completion can't be observed).

**Placeholder Tasks.** Tasks bound to the new `jira-task-placeholder-v3` template have summaries starting with `[PLACEHOLDER]`, carry a required `classification.placeholder.defined_by` field resolving to a Spike, and omit estimates. Placeholders do not hold acceptance-count or definition-of-done expectations. When the defining Spike closes, replace the placeholder with a real Task. Placeholders appear in sets 1–3 when the description includes a `defined_by` key; schema 4 enforces the classification and requires the two to be equal.

**Shaping questions, epic-v3 panel and template set 4 default.** Draft now asks for missing breakdown conventions—spike shape, task granularity, reviewers, and source order—and records each answer's source (`asked`, `reused` with the sibling Epic, or `default`). The new `epic-v3` template includes a `breakdown_conventions` panel that holds these answers in schema-4 manifests. Set 4 becomes the default and includes the v3 Spike templates and the placeholder Task template. Set 3 is frozen; sets 1–3 and schema 2–3 remain valid.

**Unbound Epic.** Schema 4 gains `epic.disposition: unbound` for live Epics whose description fits no template. An unbound Epic binds only the observed ADF digest and never authorizes a write.

**Draft self-check.** Before returning, Draft validates every description against its template's required keys and manifest invariants. This gates most template mismatches before they reach the gate script.

## Proof

### Per-step gates

All steps (0–4 and 6) passed their contract suite, skill validation, install test, and Vale lint at 0 errors/0 warnings. Compatibility diffs of `schema2-*` and `schema3-*` fixtures and template sets 1–3 remained empty. Public-safety grep returned no matches. All mutants were run on a committed tree, judged by exit code, and restored.

| Step | Commit(s) | Mutants | Focus |
|------|-----------|---------|-------|
| 0 | 3f8f987 | 1 (M0) | Extract manifest validator, pure move |
| 1 | 1ed21c1, f687ed6 | 4 (M1–M4) | Source authority, Jira amendment rule, schema-2 fallback sentence |
| 2 | 56d84c3, af85687 | 11 (M5–M15) | v3 Spike question and precedent, set-4 compatibility, description-precedent match |
| 3 | 211a16b, 9315c77 | 8 (M16–M23, M30) | Placeholder prefix, classification scope, estimate rejection, description-definer match |
| 4 | 1a8d986, e13a868 | 8 (M24–M29, M31) | Epic template rule, panel shape validation, set-4 default flip |
| 6 | 28bd8cb | — | VERSION 1.5.0, migration note |

### Final release gate

Run on 2026-09-24 against the frozen private snapshot (skill commit 0d85152, which includes every gate-found fix: 50557a3, 58fb44a, 4512a28, 38aa866 and 0d85152 itself). Twelve isolated headless Opus runs: six Draft runs of fixture Epics and controls (defaults, no Jira, no sibling, no repository, two Reviews).

**Structural checks (S1–S4):** pass on every run. S1 path isolation, S2 version match, S3 tool/environment isolation, S4 manifest schema validity.

**Criteria:**
- R0 (shaping answers): R0.1 asked answers, R0.2 reused with sibling, R0.3 defaults with reviewer gap all pass
- R1 (source authority): R1.1 existing-children inventory passes. R1.2 multi-source conflicts with a dated winner pass. R1.3 FX-STALE-3 stale design conflict passes. R1.3 FX-STALE-2 is the accepted weakness (see Residual risks).
- R1.4 schema-2 fallback: pass with `Unverified design claim:` unknowns
- R2 (classification): all pass. R2.1 covers the Spike question and precedent. R2.2 covers precedent verdicts: FX-BOUNDS stays a Spike without a found precedent, and the FX-PATTERN card gets verdict found with a traced location. R2.3 covers the vertical-slice default, R2.4 the task-granularity declaration, R2.5 component-story findings, R2.6 placeholder schema validity, and R2.7 reviewers from the snapshot or an answer.
- R5 (coverage): exit conditions and user-facing surfaces mapped, public graph and apply tests unchanged
- R2.8 and public tests: `require_text` and `reject_text` pins pass unchanged

**Checker self-test:** 77 mutants (doctored runs) deliberately failing targeted checks. All 77 caught; zero missed.

**Negative controls:** R0.2-control (no sibling panel), R0.3 (non-interactive defaults), R1.4 (no Epic ADF), R2.2-control (no repository files), R2.5-control (no component-story finding on the team's own children) all behave as specified.

## Deviations from plan and maintainer rulings

1. **R2.2 FX-PATTERN narrowed (decision in step 5).** The delete, reverse-lookup and save-and-apply fixture cards now hold open design questions in live Jira, superseding tabletop expectations. Only the list-read card remains in FX-PATTERN. FX-BOUNDS and the negative control unchanged.

2. **R2.5 relaxed (decision in step 5).** Review flags at least one rev1 Story as `component-story` but never the demoable flow Story. The gate observed a different pair of rev1 Stories from the tabletop fixture pair; both behaviors are correct.

3. **Compatibility marks moved to step 2 (deviation, step 2).** Epic-v2, task-v2, and v2 Spikes became `compatible_set_versions: [2, 3, 4]`; story-v3 became `[3, 4]`. This was necessary because `validate_registry` requires every set-4 default to be compatible with set 4.

4. **Description precedent must match classification (deviation, step 2).** The plan named only the question; the implementation requires both question and precedent descriptions to match their classifications for consistency with the v3-Spike pattern.

5. **`precedent.verdict` exempt from "empty filler value" rule (deviation, step 2).** The verdict `none` is an enumerated value, not filler; renaming it would have reopened chunk 1's schema beyond the approved decision 6.

6. **Placeholder Tasks in schema 2 and 3 (deviation, step 3).** In schema 2 and 3, a placeholder Task is valid when its description includes a `defined_by` key naming a Spike ref or Jira key. Schema 4 requires `classification.placeholder` and enforces equality between description and classification, following the v3-Spike pattern.

7. **Portable `source_order` default chosen in step 4.** The default is `[jira-amendment, jira-description, design-page]`. It is used only to break ties between sources with the same date; an asked or reused order replaces recency.

8. **Acceptance-count rule scoped universally (step 3 fix).** Every Task except placeholder Tasks must hold an acceptance count. v1-bound Tasks keep the rule; only placeholder Tasks are exempt.

## Residual risks

**R1.3 FX-STALE-2 accepted weakness.** Detecting whether a design-page deferral contradicts the Epic's scope passed on about half of its attempts across the three full gates on the same frozen snapshot. It failed the 2-of-3 rule in the final gate (fail, fail, pass). The maintainer accepted this on 2026-09-24 as a documented limitation instead of another skill cycle. The variance is model judgment, not fixture drift. Follow-up: strengthen how Draft compares design-page deferrals against the Epic's current scope.

**Reference validator is a reimplementation, not the skill.** The script uses `manifest-validator.rb` extracted from the contract suite; it is not a third-party verifier. A reimplemented check can hide a common bug in both versions.

**Judged checks rely on pattern detection in prose.** The FX-FE-SPLIT pattern for frontend-only Spikes and the FX-COMP-STORY pattern for non-demoable Stories are denylist regexps matched against summaries and descriptions. They succeed when the actual Jira state follows the expected pattern; they can miss or misidentify if Jira wording drifts.

**Prose rules are pinned only by text.** The SOP rewrites at lines 21 and 51, and the `require_text` pins on the new wording, are checked by exact substring match. Synonymous rewording that doesn't trigger the pins will pass CI but violate the intent.

**Release-check fixture frozen at 2026-09-24.** The six fixture Epics and their children were snapshotted once and are read-only for gating. If the live Jira state changes significantly, the gate's advisory snapshot diff will widen; it remains valid unless the schema or a structural check regresses.

## Next actions

1. **Flow-review of the full diff against main**, together with the release-gate results. It must close with no open Critical or Important findings.

2. **Push only when the maintainer says so.** The branch is local. No CI has run. A public push will trigger the full skill marketplace pipeline.

3. **Slice B requires separate solutioning:** R3 (cross-epic consolidation, owner arbitration, milestone order from rank, later-to-earlier edges) and R4 (semantic Audit checks). These are out of scope for Slice A.

4. **Follow-up on R1.3 stale-design detection.** Investigate whether the observed 50% pass rate can be hardened without widening the rule, or whether the rule should be clarified or split.
