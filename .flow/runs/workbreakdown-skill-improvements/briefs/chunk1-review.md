# Review brief: Slice A chunk 1 (manifest schema 4 foundation)

Review commit `a6b9eb4` on branch `claude/workbreakdown-slice-a` against `main`. Read only. Do not edit files.

## Spec

`.flow/runs/workbreakdown-skill-improvements/plan.md` is the complete spec. `validation-plan.md` lists the required checks. Implementer assumptions confirmed by the maintainer:
1. `from_epic` uses the same Jira-key pattern as `defined_by`.
2. A placeholder Task still passes its normal task-v2 template validation; the exemption arrives with task-placeholder-v3 in chunk 4.
3. `defined_by` is resolved manifest-wide after children validate.

## Evidence inventory (what exists, with paths)

- Validator (reference reimplementation of the prose contract): `tests/workbreakdown/workbreakdown-template-contract-test.rb`. New: `SCHEMA4_ROOT_KEYS`, `SHAPING_VALUES`, `SOURCES_READ`, `JIRA_KEY`, `validate_shaping`, `validate_sources`, `validate_classification`, `validate_placeholder_definers`; `validate_child` gains a `schema` arg; `validate_manifest` accepts [2, 3, 4]. Schema-4 tests follow the `Spike variant mismatch` test.
- Fixtures: `tests/workbreakdown/fixtures/schema4-minimal-valid.yaml` (schema-3 fixture with schema_version 4), `schema4-full-valid.yaml` (every block). Existing schema-2/3 fixtures unchanged.
- Prose: `skills/workbreakdown/references/manifest-contract.md` section "Schema 4: Draft provenance and classification"; Identity and Closed shapes bullets. `skills/workbreakdown/SKILL.md` schema paragraph (changed "Only schema 3" to "Only schema 3 or 4", plus one new sentence).
- Shell pins: `tests/workbreakdown-contract-test.sh`.
- Evidence so far: both suites pass; 3 mutants (accept schema 5, drop defined_by check, allow shaping in schema 3) each fail the suite; schema-2/3 fixtures unchanged; no private identifiers in diff; VERSION 1.4.0 unchanged.

## Out of scope (do not flag as missing)

v3 Spike templates, task-placeholder-v3, `[PLACEHOLDER]` prefix, epic-v3 panel, any Draft/Review/Audit behavior, SOP rewrite, VERSION bump, root CHANGELOG (semantic-release).

## Return

Findings ranked by severity, each with file:line, the concrete failure scenario, and a suggested disposition (fix now / defer to chunk N / no change). Say "no findings" for an area you checked and found clean. Distinguish observed from inferred.
