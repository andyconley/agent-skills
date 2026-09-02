# Workbreakdown Skill Plan

## Design

Create one host-neutral skill with progressive disclosure:

```text
skills/workbreakdown/
|-- SKILL.md
|-- VERSION
|-- agents/
|   `-- openai.yaml
`-- references/
    |-- work-breakdown-sop.md
    |-- manifest-contract.md
    `-- jira-change-protocol.md
```

- `SKILL.md` selects Draft, Review, Audit, or Apply; states universal hierarchy and dependency invariants; defines the write-authorization boundary; and routes to the minimum references required for the selected mode.
- `work-breakdown-sop.md` owns classification, hierarchy, sizing, Story acceptance, refinement, and graph-quality rules.
- `manifest-contract.md` owns the schema-versioned YAML desired-state contract and a complete example.
- `jira-change-protocol.md` owns live reads, capability checks, preflight, mutation order, link-direction verification, recovery, and final reconciliation.
- `agents/openai.yaml` supplies Codex UI metadata only. Claude Code ignores it and reads the same Markdown behavior.
- `VERSION` starts at `1.0.0` and matches the version repeated in `SKILL.md`.

## Manifest contract

Use `schema_version: 1`. Include:

- scoped parent and Epic keys
- Epic outcome and target duration
- direct-child entries with stable `ref`, optional `jira_key`, type, summary, `done_when`, evidence, estimate, and disposition
- dependencies as blocker/blocked reference pairs
- complete rank order
- unknowns

Allowed dispositions are `existing`, `proposed`, and `update`. Approval is not stored in the manifest; a document cannot authorize its own application. Only fields present in the approved manifest may change.

## Mode implementation

### Draft

Read source material and available Jira context. Return the Epic outcome, child table, complete YAML manifest, edge list or graph, graph checks, and material questions. Make no Jira changes.

### Review

Check issue classification, observable completion, missing implementation work, Story evidence, scope, assumptions, and graph defects. Return only material findings and the smallest correction. Make no Jira changes.

### Audit

Read live Jira or a supplied export. Return hierarchy, item table, edge list, graph defects, missing Story evidence, and the smallest proposed change set. Make no Jira changes.

### Apply

Require a specific reviewed manifest and direct user authorization. Confirm all required Jira read/write capabilities, read live scope, map references, validate the graph, and compare desired with live state. Stop before writes on material drift or ambiguity. Apply only authorized changes, journal link replacements, preserve unrelated state, reread all affected Jira state, and compare it with the complete manifest.

Jira operations are not transactional. On partial failure, stop dependent mutations, preserve created work and reference mappings, reread actual state, and report it. Do not delete newly created issues to hide a partial result.

## Repository integration

1. Replace the current untracked initializer scaffold with the completed skill.
2. Add `workbreakdown` to `skills/manifest.tsv`.
3. Update the main README, documentation index, and contributor-facing skill lists.
4. Add a checked-in manifest example only if it improves the mode tests without duplicating the canonical reference.
5. Add manual behavior tests for all modes.
6. Extend installer tests to cover selecting and uninstalling only `workbreakdown` across both runtime targets.
7. Install through `./install.sh --all --with-vale` after validation.

## Commit and release

Use a focused Conventional Commit such as `feat(workbreakdown): add Jira work breakdown skill`. Publish through the repository's normal pull-request and semantic-release path unless the user explicitly requests a different Git workflow during implementation.
