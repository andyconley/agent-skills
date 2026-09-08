# Work Breakdown Manifest Contract

The manifest is the reviewed desired-state contract between planning and Jira. Every Draft includes a complete manifest, even when no Jira change is expected.

## Identity and approval

- Use schema version 2 for child-only reconciliation.
- Use schema version 3 only when the manifest must verify or update the scoped Epic.
- Give the manifest a stable manifest ID and integer revision.
- Bind approval to the exact content. For a standalone YAML file, calculate SHA-256 over its exact UTF-8 bytes after converting line endings to LF; include the final trailing newline.
- Approval is external to the YAML. A manifest cannot authorize itself.
- Any content change after approval creates a new revision or digest and requires new approval.
- Record Jira-assigned keys in the Apply result. Do not edit the approved artifact.

## Template binding

template_set names the registry and version. The selected template must belong to that set version. Every v2 or schema-3 description names an exact template_id and template_sha256 and contains all reviewed values needed by that template.

New Drafts use template-set version 2. A pre-v2 schema-2 manifest bound to version 1 may omit template_sha256; resolve its template_id through the immutable v1 registry entry and verify the packaged asset hash. Never require a rewrite, migrate it to v2, or add fields to the approved artifact.

Reject an unknown set version or a template whose registered set_version does not match template_set.version.

## Closed shapes

Reject unknown fields instead of ignoring them.

- Root: schema_version, manifest_id, revision, template_set, scope, epic, children, dependencies, rank, unknowns.
- template_set: id, version.
- scope: parent_key, epic_key.
- Schema-2 epic: outcome, target_duration.
- Schema-3 existing epic: disposition, verify.
- Schema-3 update epic: disposition, template_id, template_sha256, expected_current, changes.
- Epic verify: template_id, template_sha256, description_adf_sha256, description.
- expected_current: description_adf_sha256.
- Epic changes: description only.

## Schema 2: child-only

Schema 2 may describe the Epic outcome for planning context. It cannot authorize any Epic write.

~~~yaml
schema_version: 2
manifest_id: cell-state-m1
revision: 1

template_set:
  id: jira-house-templates
  version: 2

scope:
  parent_key: INIT-100
  epic_key: EPIC-200

epic:
  outcome: A consumer retrieves current system state through the supported API.
  target_duration: 2 sprints

children:
  - ref: source-inventory
    jira_key: WORK-201
    type: Spike
    variant: investigation
    template_id: jira-spike-investigation-v2
    template_sha256: 988d1188e66b2afe7932b5dc6be0da2f29af51b62cff483df91855056fb7e960
    disposition: existing
    verify:
      summary: Inventory supported state sources
      done_when: Supported sources, gaps, and recommendations are recorded.

  - ref: source-adapters
    jira_key: WORK-202
    type: Task
    template_id: jira-task-v2
    template_sha256: fedfeda541933a2a379bf7569703b138e078aa9ee730438a839977824bdd06b3
    disposition: update
    changes:
      summary: Implement supported-source adapters
      done_when: Supported sources produce the canonical state model.
      evidence:
        - Automated component-test result
        - Verified sample output
      estimate: 3
      description:
        result: Supported-source adapters produce the canonical state model.
        context: Current adapters return inconsistent source data.
        acceptance_criteria:
          - Each supported source maps to the canonical state model.
          - Source errors retain source-specific evidence.
        validation:
          - Run the adapter contract suite against every supported source fixture.

  - ref: prove-status
    jira_key: null
    type: Story
    template_id: jira-story-v2
    template_sha256: 3e5453d38390f864babd7e6f41a78a45e8a269d6b0de8619d47e66024165a6cf
    disposition: proposed
    fields:
      summary: Prove current state reads
      done_when: Consumer-facing scenarios pass against representative state data.
      evidence:
        - Retained functional-test result
        - Published API behavior reference
      estimate: 3
      description:
        outcome: A permitted consumer receives current state from a supported source.
        scenarios:
          - id: current-state-read
            given: A consumer has valid credentials and access to a supported system.
            when: The consumer requests current state.
            then: The response returns the current canonical state.
        documentation:
          - id: state-api-reference
            artifact: Supported state fields and freshness behavior
            audience: API consumer
            intended_location: docs/api/state.md
        automated_tests:
          - scenario_id: current-state-read
            level: functional
            suite_or_location: tests/functional/state-read
            environment: representative-system
            expected_evidence: Retained CI result

dependencies:
  - action: ensure
    blocker: {ref: source-inventory}
    blocked: {ref: source-adapters}
  - action: ensure
    blocker: {ref: source-adapters}
    blocked: {ref: prove-status}

rank:
  mode: scoped-relative
  order: [source-inventory, source-adapters, prove-status]

unknowns:
  - Supported platform versions
~~~

Reject schema 2 when epic contains disposition, verify, expected_current, or changes.

## Schema 3: scoped Epic authority

Schema 3 keeps the child contract and adds exactly one Epic disposition. epic.disposition must be exactly `existing` or `update`. Reject any other value instead of interpreting it.

### Verify only

~~~yaml
schema_version: 3
manifest_id: cell-state-m1
revision: 2
template_set: {id: jira-house-templates, version: 2}
scope: {parent_key: INIT-100, epic_key: EPIC-200}

epic:
  disposition: existing
  verify:
    template_id: jira-epic-v2
    template_sha256: 18fefffa6ebb6fe385616ecc0dce1756a6238ce11cd5f41d972557313d42342e
    description_adf_sha256: 9f2c4b7a1e5d8036c4a91b2e7f60d3a85c19e4b70d2f6a83915ce4d70b8a2f61
    description:
      milestone_outcome: A consumer retrieves current system state through the supported API.
      problem: Current integrations cannot retrieve one supported, current representation of system state.
      acceptance_criteria:
        - condition: A permitted consumer retrieves current state from every supported source.
          evidence: Passing functional-test report from the named verification environment.
          acceptor: API owner
        - condition: Stale source data is identified and never returned as current.
          evidence: Passing stale-data scenario and retained response.
          acceptor: Service owner
        - condition: Unsupported sources return the documented failure contract.
          evidence: Passing failure-contract scenario and published API documentation.
          acceptor: Support owner
      success_measures:
        - Supported consumers complete state reads within the agreed service target during the first 30 days.

children: []
dependencies: []
rank: {mode: scoped-relative, order: []}
unknowns: []
~~~

existing verifies the exact approved description and digest and never mutates the Epic. Apply validates the template, hash, description keys, criteria, and ADF digest with the same rules as update.

### Exact description update

~~~yaml
schema_version: 3
manifest_id: cell-state-m1
revision: 3
template_set: {id: jira-house-templates, version: 2}
scope: {parent_key: INIT-100, epic_key: EPIC-200}

epic:
  disposition: update
  template_id: jira-epic-v2
  template_sha256: 18fefffa6ebb6fe385616ecc0dce1756a6238ce11cd5f41d972557313d42342e
  expected_current:
    description_adf_sha256: 9f2c4b7a1e5d8036c4a91b2e7f60d3a85c19e4b70d2f6a83915ce4d70b8a2f61
  changes:
    description:
      milestone_outcome: A consumer retrieves current system state through the supported API.
      problem: Current integrations cannot retrieve one supported, current representation of system state.
      acceptance_criteria:
        - condition: A permitted consumer retrieves current state from every supported source.
          evidence: Passing functional-test report from the named verification environment.
          acceptor: API owner
        - condition: Stale source data is identified and never returned as current.
          evidence: Passing stale-data scenario and retained response.
          acceptor: Service owner
        - condition: Unsupported sources return the documented failure contract.
          evidence: Passing failure-contract scenario and published API documentation.
          acceptor: Support owner
      success_measures:
        - Supported consumers complete state reads within the agreed service target during the first 30 days.

children: []
dependencies: []
rank: {mode: scoped-relative, order: []}
unknowns: []
~~~

For update:

- scope.epic_key is the only Epic identity.
- template-set version must be 2.
- template_id must be jira-epic-v2 and the asset hash must match the installed registry.
- expected_current.description_adf_sha256 is required and must be exactly 64 lowercase hexadecimal characters. Any other value, including a template token, an empty string, or a description of how to obtain the digest, is a manifest rejection.
- Compute it by removing only `localId` properties from raw live ADF, then serializing UTF-8 JSON with sorted object keys, preserved array order, and no insignificant whitespace, then calculating SHA-256.
- Capture the digest from live Jira before approval. Apply never computes, fills, refreshes, or substitutes this value. A digest derived from the state Apply just read proves nothing and satisfies no gate.
- When the live Epic has no description, or its description is empty, the digest is the digest of the empty document `{"type":"doc","version":1,"content":[]}`. A manifest naming that sentinel is rejected when the live description is non-empty, and a manifest naming any other digest is rejected when the live description is absent or empty. Either mismatch is material drift and produces zero writes.
- changes may contain only description.
- The description contains every required key and only approved conditional keys.
- Acceptance criteria contain 3–5 binary conditions with evidence and an acceptor when known.
- Omitted Epic fields are preserved. They never become empty write values.

Schema 3 does not authorize Epic creation, deletion, reparenting, retyping, ranking, or project, status, sprint, security, reporter, or arbitrary-field changes. It also does not authorize any non-field write on the Epic, including comments, attachments, watchers, worklogs, and labels.

## Child invariants

Each child uses a unique stable ref and exactly one disposition:

| Disposition | Jira key | Payload | Meaning |
| --- | --- | --- | --- |
| existing | Required | verify required | Verify only. Report drift; do not mutate. |
| update | Required | changes required | Change only named fields. Preserve omitted fields. |
| proposed | Null or omitted | fields required | Create one direct Epic child. |

Allowed child types are Spike, Task, and Story. A v2 Spike also names variant: design or variant: investigation.

Every child defines or verifies summary and done_when. Include evidence and estimate when known. Put material gaps in unknowns; do not invent values.

changes and fields may contain only summary, done_when, evidence, estimate, and description. A v2 description requires an exact template ID and hash. A schema-2, template-set-1 manifest may omit the hash; the immutable registry entry supplies it. Description keys match the registered required and conditional keys. Apply cannot add template content after approval. Omission of a description preserves the live description.

For a Story, give each scenario and documentation artifact a stable ID. Planned fields cover observable scenarios, contextual documentation, automated integration or functional tests mapped by scenario ID, intended suite or location, verification environment, and expected evidence. For each documentation and automated-test obligation, supply either a nonempty plan or one complete approved exception—not both. An exception names the obligation, reason, approver, and approval evidence. At IN REVIEW, evidence must cover every planned artifact and mapped scenario exactly once.

Derive the parent from scope.epic_key and the Jira issue type from type. The manifest cannot delete or archive issues; move issues between projects or parents; change issue type, status, sprint, reporter, security, or permissions; or mutate a link type other than Blocks.

## Dependency invariants

- action is ensure or remove.
- Use `action: ensure` to add a required edge and `action: remove` to remove one exact observed edge.
- Each endpoint contains exactly one ref or jira_key.
- A local ref names a declared child. Use jira_key for an external endpoint.
- At least one endpoint uses a local ref. Never change a link between two external issues.
- Absence from dependencies means preserve the live link. It is never deletion permission.
- remove is the only link-deletion authority. Bind it to the exact observed Blocks link ID and approved endpoints in the mutation journal.
- Interpret each pair as blocker -> blocked.
- Reject duplicate, reversed, cyclic, and unjustified transitive edges before Apply.

## Rank invariants

scoped-relative orders only manifest children relative to one another. It must preserve the relative order of unrelated live Epic children.

If exact placement among all live children matters, use full-live-order and include every live direct child. Any live mismatch is material drift and requires a new manifest revision.

## Draft output

Return:

1. Epic outcome.
2. Proposed child table.
3. Complete YAML manifest.
4. Dependency edge list or graph using A -> B for A blocks B.
5. Cycle, direction, duplicate, redundancy, missing-edge, and orphan checks.
6. Questions that materially affect the breakdown.

Use temporary references until Jira assigns keys. Do not create placeholder Jira keys.

## Review output

Report only material defects and the smallest corrections:

- wrong issue type or Spike variant
- no independently verifiable completion
- missing implementation work
- missing Story scenarios, contextual documentation, or mapped automated tests
- review-entry evidence missing for a Story entering IN REVIEW
- vague, trivial, repeated, or unsupported content
- work too broad to execute safely
- assumptions presented as facts
- invalid manifest or template binding
- reversed, redundant, duplicate, missing, or cyclic dependencies

Return a corrected edge list only when an edge changes. Do not replace valid work.
