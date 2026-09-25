# Review: Slice A, chunk 1 (manifest schema 4 foundation)

- **Lane:** flow-review, 2026-09-24. Branch `claude/workbreakdown-slice-a`, final commit bafcc78, local only.
- **Judged against:** `plan.md` (in scope 1–5, out of scope), `validation-plan.md`, definition R1.2, R1.4, R2.1, R2.2, R2.6, and the three maintainer-confirmed assumptions.
- **Reviewers:**
  - quality-reviewer, opus, independent acceptance pass
  - test-engineer, sonnet, proof pass
  - quality-reviewer, fresh context, reviewing the fix commit 54f665a
  - the coordinator's own read of the prose and validator

  None of them wrote the code.

## Verdict

Ready to accept, after in-lane refinement. The first pass gave two verdicts: the quality-reviewer said ready to accept, and the test-engineer said needs refinement. Every Important finding was fixed and re-proven in the review lane. The fix-commit review found no Critical or Important issues.

## Findings and dispositions

| Severity | Finding | Source | Disposition |
| --- | --- | --- | --- |
| Important | Nothing tested the Jira-key format for `from_epic` or `existing_children.jira_key`. A bad `from_epic` reported "requires from_epic". | quality-reviewer | Fixed in 54f665a: a separate fragment and two negative cases (M6) |
| Important | The mutation evidence for M3 overstated what it proved | test-engineer | Reframed in validation-results.md. Two paths enforce the rule. |
| Important | No pin between the validator and the prose contract | test-engineer | Fixed in 54f665a, cedeb73 and bafcc78: a vocabulary pin plus generated rule sentences over the prose with the example stripped (M10–M12, M15). Free-text rules remain pinned only by tests. |
| Suggestion | Schema-2/3 error precedence changed when a manifest had two errors | quality-reviewer | Fixed in 54f665a: main's order is restored, with a regression case (M9) |
| Suggestion | Empty lists passed the "nonempty list" check | quality-reviewer | Fixed in 54f665a: at least one entry, with prose aligned |
| Suggestion | The date check was format only | coordinator, quality-reviewer | Fixed in 54f665a: strict ISO parse (M7) |
| Suggestion | Duplicate conflict refs and repeated `read` entries passed | quality-reviewer | Fixed in 54f665a and cedeb73, including whitespace-padded refs (M8) |
| Suggestion | The prose didn't require a nonempty `claim`; a non-string `claim` passed | quality-reviewer, both passes | Fixed in 54f665a and cedeb73 (M14) |
| Suggestion | The pin scanned the worked example, so most tokens were free passes | fix-commit reviewer | Fixed in cedeb73 and bafcc78 |
| Suggestion | `reviewers` with `source: default` let a default stand in for a person (R0.4, R2.7) | fix-commit reviewer | Fixed in cedeb73: rejected, with prose updated (M13) |
| Suggestion | A YAML root that is a list now raises TypeError instead of NoMethodError | fix-commit reviewer | No change: both reject, and it only affects which error is raised |
| Suggestion | The handback said "10 extra cases" | quality-reviewer | Corrected in validation-results.md: 41 against main |
| Carried | "schema 3 requires an Epic-compatible template set" also fires for schema 4 | implement-lane review | Deferred to chunk 5 |
| Process | The mutation helper grepped the output instead of reading the exit code | coordinator | All 15 mutants re-run by exit code; recorded in validation-results.md |

## Requirement fit

All of plan in-scope items 1–5 are delivered. Nothing out of scope was added: no templates, no behavior change, no VERSION or CHANGELOG edits. Declared deviations:
- "Only schema 3 or 4" in SKILL.md, and the Identity and Closed-shapes bullets, were needed for correctness.
- Validation is stricter than the plan's minimum: Jira-key format, strict dates, distinct refs, nonempty lists and no default reviewers.

The stricter rules follow the plan's intent and R0.4/R2.7. They narrow what schema 4 accepts before any Draft emits it, so they break no existing manifest.

## Validation fit

Every validation-plan check has command output in `validation-results.md`. Mutation checks: 15 of 15 caught, judged by exit code. The evidence was produced against the change itself, not a surrogate. The reviewers had no shell; the coordinator ran every command.

## Residual risks

- **Chunk 2 planning:** schema 4 as the Draft default needs a live Epic ADF digest for every Draft, including child-only breakdowns.
- **Free-text rules:** prose rules that aren't enumerated, such as `location` being required when the verdict is `found`, are pinned only by negative tests. A prose-only edit to them would not be caught.
- **The Ruby validator is a reference reimplementation.** Draft, Review and Apply behavior is proven only by the live-agent release script (chunk 6).
