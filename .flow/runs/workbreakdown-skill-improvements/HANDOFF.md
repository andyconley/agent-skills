# Handoff: Slice A, chunk 1

## Status
Chunk 1 (manifest schema 4 foundation) implemented and validated. Commits a6b9eb4 and 7b58289 on branch `claude/workbreakdown-slice-a`, local only, not pushed. VERSION remains 1.4.0 until Slice A completes.

## What changed
- `manifest-contract.md`: new "Schema 4: Draft provenance and classification" section (top-level `shaping` and `sources`, per-child `classification`, abridged example, migration note), plus schema-4 bullets in Identity and Closed shapes.
- `SKILL.md`: "Only schema 3" became "Only schema 3 or 4", plus the planned schema-4 sentence.
- `workbreakdown-template-contract-test.rb`: `validate_manifest` now accepts schemas [2, 3, 4]; added `validate_shaping`, `validate_sources`, `validate_classification`, and `validate_placeholder_definers`.
- `workbreakdown-contract-test.sh`: added `require_text` checks for schema 4 keywords.
- Two fixtures: `schema4-minimal-valid.yaml` and `schema4-full-valid.yaml`.

## Deviations from plan
- The plan asked for one SKILL.md sentence. The "3 or 4" wording and the Identity and Closed-shapes bullets were also needed, because the old text would have forbidden schema-4 Epic writes and rejected the new keys. The quality-reviewer judged these justified correctness fixes, not scope creep.
- Maintainer-confirmed assumptions: `from_epic` uses the Jira-key pattern; a placeholder Task still passes task-v2 validation until chunk 4; `defined_by` resolves manifest-wide.

## Proof
- Shell contract test: pass, all `require_text` pins.
- Ruby suite: both schema-4 fixtures valid; plan negative cases plus 10 coverage gaps, each with intended fragment.
- Schema 2 and 3 fixtures unchanged.
- Mutation checks: 5 of 5 caught (schema gating, placeholder definers, shaping/sources gates, jira_context enum, material/stale boolean).
- No public-safety violations.

## Review dispositions
- **Lead-developer**: validation order finding (classification before type check) fixed in 7b58289; no type/key errors.
- **Test-engineer**: coverage gaps (granularity, reviewers, source_order, jira_context, material/stale, question, precedent, amendments) all added in 7b58289.
- **Quality-reviewer**: verdict ready with fixes. Findings 1–6 addressed in 7b58289. Finding 7 (Epic error text precedence) deferred to chunk 5. Residual risk: schema-4 default requires live Epic ADF digest for every Draft; carry to chunk 2 planning.

## Next
- Deferred: finding 7 (Epic-compatible error text) in chunk 5.
- Residual risk: schema-4-by-default needs live Epic ADF per Draft (non-blocking, chunk 2 planning).
- Next lane: flow-review for chunk 1, then flow-plan for chunks 2, 3, 4 (any order) and 6. Do not push until maintainer approval.
