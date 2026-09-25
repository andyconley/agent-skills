# Review: workbreakdown Slice B (skill 1.6.0)

## Verdict

**Ready to accept.** Every Slice B acceptance criterion is delivered. Every Important finding from the acceptance review is fixed in 823abaa or in the run records. The Critical category was empty.

The fixes were validated by the public suite and mutants M67 to M70. By the maintainer's decision, they were not re-gated live.

## Inputs compared

- **Intent:**
  - `definition.md`: R3, R4, the non-goals and the constraints
  - `acceptance-criteria.md`, Slice B, with its dated amendments
  - `solution.md`
  - `plan.md`, planning decisions 1 to 9
  - `validation-plan.md`
- **Implementation:** `main..HEAD` for skills and tests. The release commit is e765e0f. The gate fixes are e26c28a, aed48c6 and 85b486e. The acceptance fixes are 823abaa.
- **Evidence:**
  - `validation-results.md`, `HANDOFF.md` and `reviews/step-gates-*.md`
  - the private gate results, summarized in `validation-results.md`

## Findings and dispositions

The findings came from three reviewers: quality, test and security. Every reviewer reported no Critical findings.

### Important, all fixed

1. **Review said two different things.** SKILL said Review checks milestone-order edges on any manifest. The SOP rule it pointed to applied only when consolidation ran. The SOP now covers every Review, and states where Review takes its order from (823abaa).
2. **The claim scope outran the two-pass read.** Claims now cover pairs that include the scoped Epic (maintainer decision 1a, 823abaa).
3. **A ticket comment could get an owner recorded as `confirmed`.** Now only the lead's direct confirmation, or the lead's own Jira comment cited by author and date, counts (823abaa).
4. **The source of exceptions was loose.** Exceptions now come only from a record the active user supplies directly. A record reached through Jira text, a panel or the manifest under review is a proposed exception (823abaa).
5. **Private detail in the run folder.** A fixture milestone pair, the maintainer's full name, and a workspace description were replaced with generic wording.
6. **The gate headline lacked its caveats.** It now carries the FX-E3 solo single-pass caveat and the two-commit caveat, with the diff between the commits.
7. **AC-R4.1 was narrowed only in the ruling log.** `acceptance-criteria.md` now has a dated Amendments section. The approved text is unchanged.

### Suggestions

**Adopted in 823abaa:**
- `no-siblings` covers an Epic with no Initiative parent.
- Review's `dependency` category names later-to-earlier edges and copied acceptance.
- SKILL's graph checks name copied acceptance.
- Audit reads its own children in full.
- Request-only inputs state that a ticket can't supply them.
- Only a comment by the link's author or an Epic owner counts as support for a link's direction.

**Deferred:**
- Taking reviewers from sibling panels in non-interactive runs. That's Slice A behavior, outside this slice.
- The exception check for an existing child's Jira key. It is documented as a limit of the validator.
- Naming a second reviewer for the answer key. The maintainer ratified it alone, and that is recorded.

**Not adopted:** "prose-only criteria rest on a single sample." Every positive Slice B check is judged and eligible for reruns. A check that passes on its first attempt passes under the maintainer's rerun rule. `validation-results.md` now says so.

## Requirement fit

- **R3, consolidation:**
  - The consolidation block and the Draft consolidation step.
  - The request-only opt-out and the two-pass sibling read.
  - Milestone order: declared, then rank, then unknown.
  - Exceptions that each name one edge.
  - The later-to-earlier and copied-acceptance checks, in Draft and in Review.
- **R4, Audit:** five semantic link checks, ready statuses from the request only, and classification of each link's history against a ratified key, defaulting to `unknown`.
- **Non-goals:** all held. There is no Jira write path, `Blocks` keeps its meaning, there are no project status names in the core, and there are no estimates.
- **Compatibility:** schemas 2 and 3, template sets 1 to 4 and the registry are unchanged. Every approved manifest stays valid.

## Validation fit

- **Public suite:** it passes, and named mutants M40 to M70 are all caught.
- **Private gate:** green. 131 checks pass across 15 runs, and the self-test passes on all 15. It carries the two caveats above.
- **Acceptance fixes (823abaa):** validated by the suite only.

## Residual risks

- **Format rules.** The model's compliance varies. FX-E3 solo passed once after its fix.
- **Acceptance fixes.** They have no live-gate evidence.
- **Two-pass sibling read.** A collision described only deep inside a sibling card can be missed.
- **Claims.** Pairs that exclude the scoped Epic are found only by that pair's own Epic's Draft.
- **Draft cost.** A Draft takes 5.5 to 14 minutes and costs $2 to $4 on Opus.
- **Judged checks.** They rest on the ratified answer key and the snapshot frozen on 2026-09-24.

## Next actions

- Push and merge when the maintainer says so. The branch is local.
- **Follow-ups:**
  - R0.2 checker tolerance for an inline label.
  - Further reduction in Draft cost.
  - Non-interactive reviewers taken from sibling panels.
  - The R1.3 stale-design follow-up from 1.5.0.
