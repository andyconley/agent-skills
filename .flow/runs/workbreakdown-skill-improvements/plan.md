# Plan: Slice A, chunk 1: manifest schema 4 foundation

- Work item: workbreakdown-skill-improvements
- Inputs: `definition.md` (R0, R1, R2.1, R2.2, R2.6), `solution.md` (decision 2, chunk 1), `acceptance-criteria.md`
- Status: Approved by the maintainer, 2026-09-24

## Problem statement

- **What:** add manifest schema 4 so the rest of Slice A has somewhere to put its fields. Schema 4 carries every Slice A field that isn't tied to a template, all optional. Schemas 2 and 3 are unchanged.
- **Who:** skill users, and chunks 2–5, which write into these fields.
- **Why now:** every later Slice A chunk depends on it.

## Desired outcome

The prose contract and the reference validator accept schema 4 and reject malformed schema 4 manifests with specific errors. Schema 2 and 3 manifests validate exactly as before. Schema 4 stays dormant: Draft does not emit it yet, and emitting it becomes the default when Slice A releases.

## Scope

### In scope

1. **Schema 4 top-level keys.** These are the existing top-level keys plus two optional blocks. Both are allowed only when `schema_version: 4`.
   - `shaping`: a map whose optional entries are `spike_shape`, `task_granularity`, `reviewers` and `source_order`.
     - Each entry is `{value, source, from_epic?}`.
     - `source` must be `asked`, `reused` or `default`.
     - `from_epic` is a Jira key, required when `source: reused` and forbidden otherwise.
     - `spike_shape.value` must be `vertical-slice` or `by-layer`.
     - `task_granularity.value` must be `per-flow` or `finer`.
     - `reviewers.value` is a list of non-empty strings.
     - `source_order.value` is a list of non-empty strings.
     - Unknown entry keys are rejected.
   - `sources`: a map with these optional keys:
     - `jira_context`: `present` or `absent`.
     - `existing_children`: a list of `{jira_key, read}`, where `read` is a non-empty subset of `description`, `amendments`, `status`, `links` and `link_history`. It must be empty or absent when `jira_context: absent`.
     - `conflicts`: a list of `{claim, sources, winner, material, stale}`.
       - `sources` has at least two entries, each `{ref, date}`, with dates in ISO `YYYY-MM-DD` form.
       - `winner` must equal one listed `ref`.
       - `material` and `stale` are booleans.
2. **A new optional child key, `classification`,** allowed only in schema 4.
   - `question`: a non-empty string.
   - `precedent`: `{searched, verdict, location?}`.
     - `searched` is a list of non-empty strings.
     - `verdict` must be `none`, `found` or `unverified`.
     - `location` is required when the verdict is `found` and optional otherwise.
   - `placeholder`: `{defined_by}`, allowed only on `type: Task`. `defined_by` must be the `ref` of a `type: Spike` child in the same manifest, or match `/\A[A-Z][A-Z0-9]+-\d+\z/`, which means an existing Jira key.
   - Unknown keys are rejected.
3. **The epic block** in schema 4 uses the schema-3 rules unchanged (`existing` or `update`, epic-v2).
4. **Prose.**
   - `skills/workbreakdown/references/manifest-contract.md` gets a new "Schema 4: Draft provenance and classification" section. It holds the field definitions above, one worked example that uses every block, and a migration note: "Schema 2 and 3 manifests remain valid. Schema 4 adds optional blocks only. Draft emits schema 4 from the release that completes Slice A."
   - `skills/workbreakdown/SKILL.md` gets one sentence under the schema paragraph: "Schema 4 adds optional Draft provenance (`shaping`, `sources`) and per-child `classification`; it keeps the schema-3 Epic rules." Keep every phrase that `tests/workbreakdown-contract-test.sh` pins, including "Manifest schema 2 remains child-only."
5. **Tests.**
   - `tests/workbreakdown/workbreakdown-template-contract-test.rb`, `validate_manifest` accepts `[2, 3, 4]`. Build the allowed top-level keys per schema (base keys, plus `shaping` and `sources` for 4). Route the schema-4 epic through the schema-3 path. Add `validate_shaping`, `validate_sources` and `validate_classification`. Allow `classification` on children only when the schema is 4, by passing the schema into `validate_child`.
   - `tests/workbreakdown-contract-test.sh` adds `require_text` checks on `manifest-contract.md` for `schema_version: 4`, `shaping:`, `sources:` and `classification:`.
   - New fixtures under `tests/workbreakdown/fixtures/`:
     - `schema4-minimal-valid.yaml`: schema 4 with no new blocks. It is valid.
     - `schema4-full-valid.yaml`: every block and field, including one placeholder Task pointing at a Spike ref and one conflict. It is valid.
   - Negative cases follow the existing pattern: clone the valid fixture, mutate it, then `expect_error("<fragment>")`. Each case has its own error fragment:
     - an unknown `shaping` entry
     - `reused` without `from_epic`
     - `from_epic` without `reused`
     - a bad `spike_shape` value
     - a conflict with one source
     - a conflict `winner` that isn't a listed ref
     - `existing_children` present while `jira_context: absent`
     - a bad `verdict`
     - `found` without `location`
     - `placeholder` on a Spike
     - `defined_by` pointing to a missing ref or a non-Spike child
     - `classification` in a schema-3 manifest
     - `shaping` in a schema-3 manifest
     - `schema_version: 5`

### Out of scope

- The v3 Spike templates and reviewer description slots (chunk 3).
- `task-placeholder-v3` and the `[PLACEHOLDER]` prefix rendering (chunk 4).
- Epic-v3 and the `breakdown_conventions` panel (chunk 5).
- Any Draft, Review or Audit behavior change, and the SOP rewrite (chunks 2 and 3).
- A VERSION bump. It happens once, when Slice A completes.
- Hand edits to the root `CHANGELOG.md`, which semantic-release generates. Use a conventional commit, `feat(workbreakdown): …`.
- The release fixture script (chunk 6, private, outside this repo).

## States and contracts

- **Required states:** none, because there is no UI.
- **Data-shape contract:** additive. The schema-4 rules above are the whole contract. There is no migration, and schema 2 and 3 behavior is byte-for-byte unchanged.
- **Error contract:** each rejection raises `ArgumentError` with a distinct fragment, which the tests assert.

## Validation

See `validation-plan.md`.

## Recommended lane

`flow-implement`. The change spans several files (prose, the Ruby validator, the shell test and fixtures) and a contract, so it is more than a scout.
