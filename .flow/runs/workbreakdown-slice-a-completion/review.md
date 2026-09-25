# Review: workbreakdown Slice A completion (skill 1.5.0)

## Verdict

Ready to accept. Every Slice A acceptance criterion and plan step (0–6) is either delivered or covered by a recorded maintainer ruling. Every Critical and Important review finding is fixed and re-checked.

## Inputs compared

- **Intent:**
  - `../workbreakdown-skill-improvements/definition.md`: R0, R1, R2 and R5
  - `../workbreakdown-skill-improvements/acceptance-criteria.md`
  - `plan.md`, including maintainer decisions 1–10
  - `validation-plan.md`
- **Implementation:** `770249e..HEAD`, for skills and tests. The release commit is 28bd8cb. The post-review fixes are 7d1b83b and bb2016f.
- **Evidence:**
  - `validation-results.md`
  - `HANDOFF.md`
  - `reviews/step-gates-*.md` and `reviews/acceptance-*.md`
  - the private release-gate results, summarized in `validation-results.md`

## Findings and dispositions

- **Critical:** none in acceptance.
- **Important (quality):** four coherence gaps, all fixed in 7d1b83b and re-checked (approve):
  - the worked example
  - the schema-4 Spike classification rule
  - schema-4 wording in final verification and template binding
  - panel-deletion preflight
- **Important (proof):**
  - R1.3 was labeled as a full pass. It is now marked partial.
  - The rerun-rule timing concern does not apply, because it covered the release gate only.
- **Security:** accept. All three adopted suggestions are applied.
- **Suggestions left open:**
  - Home paths in older, pre-existing public run records.
  - Whether a placeholder with a found precedent should become an enforced rule.
  - Tightening the generic "Verify" pin, which predates this work.

## Requirement fit

- **Source authority (R1).** Draft reads and reconciles existing work first, and the most recent dated decision wins. Only an asked `source_order` overrides that. Conflicts and stale sources are recorded. The no-Jira fallback emits schema 2 with unverified design claims. A template-less Epic is bound by digest (`unbound`).
- **Classification (R2):**
  - v3 Spikes carry a question and a precedent.
  - Every schema-4 Spike is classified.
  - Precedent is defined.
  - Review findings are categorized, and there is no category for a team's own Spike shape or Task granularity.
  - Placeholder Tasks exist, on template set 4.
- **Shaping (R0).** Draft asks, reuses or defaults each shaping answer and records its source. Reviewers never come from a default. The panel is written only through the guarded Epic update. The divergence list is advisory.
- **Compatibility.** Schema 2 and 3 and template sets 1–3 are unchanged, and their hashes are pinned.
- **Scope.** Slice B remains out of scope.

## Validation fit

- **Per step:** the suites, `validate-skills`, `install-test` and Vale pass. There are 34 named mutants, each judged by exit code.
- **Release gate:** 12 isolated headless runs.
  - Every structural check passes on every run and every rerun.
  - Every negative control passes, and so does every criterion except R1.3 FX-STALE-2.
  - The checker self-test caught all 77 mutants.
- **Residual evidence gap:** the post-gate commits 7d1b83b and bb2016f were validated by the suite and a mutant, not re-run live.

## Residual risks

- **R1.3 FX-STALE-2.** Detecting a design-page deferral that conflicts with the Epic's scope passes on about half of attempts. The maintainer accepted this on 2026-09-24, and it carries forward as a follow-up.
- **Reference validator.** It is a reimplementation of the contract, not the skill.
- **Judged checks.** The release checks use patterns held in the private harness.
- **Prose rules.** They are pinned by exact text only.
- **Gate snapshot.** It is frozen at 2026-09-24.

## Next actions

- Push the branch when the maintainer says so.
- Slice B needs its own solutioning.
- Follow-up on stale-design detection.
