# Work Breakdown Manifest Contract

The manifest is the reviewed desired-state contract between planning and Jira. Every Draft response includes a complete manifest, even when Jira changes are not expected.

## Identity and approval

- Set `schema_version: 1`.
- Give the manifest a stable `manifest_id` and integer `revision`.
- Bind Apply approval to the exact content. For a standalone YAML file, calculate SHA-256 over its exact UTF-8 bytes after converting line endings to LF; include the final trailing newline. Do not digest Markdown fences or surrounding prose. If that representation is unavailable, use an immutable document revision ID supplied by the source system.
- Approval is external to the YAML. A manifest cannot authorize itself.
- Any content change after approval creates a new revision or digest and requires new approval.
- Record Jira-assigned keys in the Apply result mapping. Do not edit the approved artifact in place.

## Complete shape

```yaml
schema_version: 1
manifest_id: partner-state-m1
revision: 1

scope:
  parent_key: ER-215
  epic_key: AE-1495

epic:
  outcome: A partner can retrieve current cell state through the supported API.
  target_duration: 2 sprints

children:
  - ref: source-inventory
    jira_key: AE-1496
    type: Spike
    disposition: existing
    verify:
      summary: Inventory supported cell-state sources
      done_when: Supported sources, gaps, and recommendations are recorded.

  - ref: source-adapters
    jira_key: AE-1501
    type: Task
    disposition: update
    changes:
      summary: Implement supported-source adapters
      done_when: Supported sources produce the canonical state model.
      evidence:
        - Automated component tests
        - Verified sample output
      estimate: 3

  - ref: prove-status
    jira_key: null
    type: Story
    disposition: proposed
    fields:
      summary: Prove real cell-status reads
      done_when: Partner-facing scenarios pass against real cell data.
      evidence:
        - Gherkin scenarios for main, failure, and authorization paths
        - Integration-test results
        - Demonstration record
        - Verification environment
      estimate: 3

dependencies:
  - action: ensure
    blocker:
      ref: source-inventory
    blocked:
      ref: source-adapters
  - action: ensure
    blocker:
      ref: source-adapters
    blocked:
      ref: prove-status
  - action: remove
    blocker:
      jira_key: AE-1400
    blocked:
      ref: prove-status

rank:
  mode: scoped-relative
  order:
    - source-inventory
    - source-adapters
    - prove-status

unknowns:
  - Supported Forge versions
```

## Child invariants

Each child uses a unique, stable `ref` and exactly one disposition:

| Disposition | Jira key | Payload | Meaning |
| --- | --- | --- | --- |
| `existing` | Required | `verify` required | Verify only. Do not mutate differing fields. Report drift. |
| `update` | Required | `changes` required | Change only the fields named under `changes`. Preserve every omitted field. |
| `proposed` | Must be null or omitted | `fields` required | Create a new direct Epic child with the listed fields. |

Allowed child types are `Spike`, `Task`, and `Story`. Every child must define or verify a `summary` and `done_when`. Include `evidence` and `estimate` when known. Do not invent missing values; place material gaps in `unknowns`.

In v1, `changes` and `fields` may contain only `summary`, `done_when`, `evidence`, and `estimate`. Derive the parent from `scope.epic_key` and the Jira issue type from `type`. Never use the manifest to delete or archive issues; move an issue between projects or parents; change its issue type, status, sprint, reporter, security, or permissions; or mutate a link type other than `Blocks`.

For a Story, its fields or verification expectations must cover observable behavior, Gherkin scenarios, the integration tests that prove them, deployment or packaging evidence, and verification environment. Use failure, authorization, version, and compatibility scenarios where applicable.

## Dependency invariants

- `action` is `ensure` or `remove`.
- Each endpoint contains exactly one of `ref` or `jira_key`.
- A local `ref` must name a declared child. Use `jira_key` for an external endpoint, including a cross-Epic dependency.
- At least one endpoint must use a local `ref`. Never change a link between two external issues.
- Absence from `dependencies` means preserve the live link. It is never permission to delete.
- `remove` is the only deletion authority. Before removal, bind it to the exact observed `Blocks` link ID and approved endpoints in the mutation journal.
- Interpret each pair as `blocker -> blocked`.
- Reject duplicate, reversed, cyclic, and unjustified transitive edges before Apply.

## Rank invariants

`scoped-relative` orders only the manifest's children relative to one another. It must not change the relative order of unrelated live Epic children. Apply can use this mode only when the available Jira capability can prove that preservation.

If exact placement among all live children matters, use:

```yaml
rank:
  mode: full-live-order
  order:
    - AE-1490
    - source-inventory
    - source-adapters
    - AE-1491
    - prove-status
```

The full order must include every live direct child. Any live mismatch is material drift and requires a new manifest revision.

## Draft output

Return these six sections:

1. Epic outcome.
2. Proposed child table.
3. Complete YAML manifest.
4. Dependency edge list or graph using `A -> B` for A blocks B.
5. Results for cycles, direction, duplicates, redundancy, missing edges, and orphaned work.
6. Questions that materially affect the breakdown.

Use temporary references until Jira assigns keys. Do not create placeholder Jira keys.

## Review output

Report only:

- misclassified issue types
- work without independently verifiable completion
- missing implementation work
- Stories without observable behavior, Gherkin, or integration evidence
- work too broad to execute safely
- assumptions presented as facts
- reversed, redundant, duplicate, missing, or cyclic dependencies
- invalid manifest invariants

For each finding, give the smallest correction. Return a corrected edge list when an edge changes. Do not replace valid parts of the plan.
