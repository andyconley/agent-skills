# Work Breakdown Manifest Contract

The manifest is the reviewed desired-state contract between planning and Jira. Every Draft includes a complete manifest, even when no Jira change is expected.

## Identity and approval

- Use schema version 2 for child-only reconciliation.
- Use schema version 3 or 4 only when the manifest must verify or update the scoped Epic.
- Schema version 4 adds optional Draft provenance and per-child classification. Its Epic rules are the schema-3 rules.
- Give the manifest a stable manifest ID and integer revision.
- Bind approval to the exact content. For a standalone YAML file, calculate SHA-256 over its exact UTF-8 bytes after converting line endings to LF; include the final trailing newline.
- Approval is external to the YAML. A manifest cannot authorize itself.
- Any content change after approval creates a new revision or digest and requires new approval.
- Record Jira-assigned keys in the Apply result. Do not edit the approved artifact.

## Template binding

template_set names the registry and version. The selected template must declare compatibility with that set version. Every nonlegacy or schema-3 description names an exact template_id and template_sha256 and contains all reviewed values needed by that template.

New Drafts use template-set version 3. A schema-2 manifest bound to version 1 may omit template_sha256; resolve its template_id through the immutable v1 registry entry and verify the packaged asset hash. Never require a rewrite, migrate an approved manifest, or add fields to it.

Grandfathering covers the template asset and its declared key set. It does not cover content. The quality rules in [ticket-quality-and-completion.md](ticket-quality-and-completion.md) apply to every description in every template set. A v1-bound description with an unresolved placeholder, an `N/A` or `None` filler value, or generic evidence is rejected, and it may still use only the keys its own registry entry declares.

Reject an unknown set version or a template that does not list template_set.version in `compatible_set_versions`. When that metadata is absent, only the template's own `set_version` is compatible.

## Closed shapes

Reject unknown fields instead of ignoring them.

- Root: schema_version, manifest_id, revision, template_set, scope, epic, children, dependencies, rank, unknowns.
- Schema-4 root: the root fields, plus optional shaping and sources.
- Schema-4 child: the child fields, plus optional classification.
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
  version: 3

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
    template_id: jira-story-v3
    template_sha256: c19201ccb6e6f59671c0d33b45df3524d9d0662b3563d133e1f6f02c2774fef4
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
        instrumentation:
          - id: state-read-success
            class: operational
            signal: Successful current-state reads
            purpose: Shows that permitted consumers receive current state
            implementation_target: State-read service telemetry
            expected_observation: The counter increases during the functional scenario

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
- the selected template set must be compatible with `jira-epic-v2`.
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

## Schema 4: Draft provenance and classification

Schema 4 records how a Draft was shaped, which sources it read, and why each child has its classification. All three blocks are optional, and a schema-4 manifest without them is valid. The Epic block follows the schema-3 rules unchanged. The example is abridged: its Epic description and child template bindings follow the schema-3 and child rules. Reject shaping, sources, or a child classification in a schema-2 or schema-3 manifest.

~~~yaml
schema_version: 4
manifest_id: state-read-breakdown
revision: 1
template_set:
  id: jira-house-templates
  version: 2
scope:
  parent_key: INIT-100
  epic_key: EPIC-200
epic:
  disposition: existing
  verify:
    template_id: jira-epic-v2
    template_sha256: 18fefffa6ebb6fe385616ecc0dce1756a6238ce11cd5f41d972557313d42342e
    description_adf_sha256: 9f2c4b7a1e5d8036c4a91b2e7f60d3a85c19e4b70d2f6a83915ce4d70b8a2f61
    description: {} # the reviewed Epic description, as in schema 3
shaping:
  spike_shape:
    value: vertical-slice
    source: reused
    from_epic: EPIC-201
  task_granularity:
    value: per-flow
    source: asked
  reviewers:
    value: [API owner]
    source: asked
  source_order:
    value: [jira-amendment, design-page]
    source: default
sources:
  jira_context: present
  existing_children:
    - jira_key: WORK-203
      read: [description, status, links, link_history]
  conflicts:
    - claim: State reads use the cached projection.
      sources:
        - ref: docs/design/state.md
          date: "2026-01-10"
        - ref: WORK-203
          date: "2026-02-03"
      winner: WORK-203
      material: true
      stale: true
children:
  - ref: choose-transport
    type: Spike
    variant: design
    disposition: proposed
    classification:
      question: Which transport carries state reads within the payload limit?
      precedent:
        searched: [src/transport, docs/design]
        verdict: none
    # template binding and fields as for any proposed child
  - ref: build-endpoint
    type: Task
    disposition: proposed
    classification:
      precedent:
        searched: [src/api/handlers]
        verdict: found
        location: src/api/handlers/status.rb
      placeholder:
        defined_by: choose-transport
    # template binding and fields as for any proposed child
dependencies: []
rank:
  mode: scoped-relative
  order: [choose-transport, build-endpoint]
unknowns: []
~~~

### shaping

shaping records the answers that shaped the Draft. Its entries are spike_shape, task_granularity, reviewers, and source_order, and each is optional. Reject any other entry.

- Each entry contains value, source, and, only for a reused answer, from_epic.
- source is asked, reused, or default.
- from_epic is the Jira key, such as EPIC-201, of the sibling Epic the answer came from. It is required when source is reused and rejected otherwise.
- spike_shape.value is vertical-slice or by-layer.
- task_granularity.value is per-flow or finer.
- reviewers.value lists at least one nonempty reviewer name, and its source is asked or reused, never default. When no reviewer is known, omit the entry and record the gap in unknowns.
- source_order.value lists at least one nonempty source kind, most authoritative first.

### sources

sources records what the Draft read and how it resolved disagreements between sources. Its keys are jira_context, existing_children, and conflicts, and each is optional.

- jira_context is present or absent.
- existing_children lists each existing Epic child the Draft read, as jira_key plus read. read is a nonempty subset of description, amendments, status, links, and link_history, with no repeats. existing_children must be empty or omitted when jira_context is absent.
- conflicts lists each disagreement between sources. A conflict contains claim, sources, winner, material, and stale.
  - claim is the nonempty statement the sources disagree on.
  - sources lists at least two entries with distinct refs, ignoring surrounding whitespace, each a ref and a valid ISO calendar date in `YYYY-MM-DD` form. Quote the date so YAML keeps it as text.
  - winner equals the ref of one listed source.
  - material and stale are true or false.
- A schema-4 manifest with jira_context absent is rejected. Schema 4 always binds a live Epic digest, so a Draft without Jira context emits schema 2.

### classification

classification is an optional child key. Its keys are question, precedent, and placeholder. Reject any other key.

- question is the nonempty open question the child answers.
- precedent contains searched and verdict, and may contain location.
  - searched lists at least one nonempty location the Draft looked in.
  - verdict is none, found, or unverified.
  - location is where the precedent lives. It is required when verdict is found and optional otherwise.
- placeholder is allowed only on a Task. It contains only defined_by, which is either the ref of a Spike child in the same manifest or an existing Jira key.

A child bound to jira-spike-design-v3 or jira-spike-investigation-v3 states its question and precedent in its description in every schema. In schema 4 it also requires classification.question and classification.precedent, and the description's question and precedent must equal them. A verdict of none is a finding, not filler, so the description quality rules do not reject it. Its reviewers name people from a source or a shaping answer. When nobody is known, omit reviewers and record the gap in unknowns.

A Task that relies on an existing pattern carries classification.precedent with verdict found and a location. Draft never converts a Spike to a Task on verdict unverified, including when it cannot read the repository.

### Migration

Schema 2 and 3 manifests remain valid. Schema 4 adds optional blocks only. From the release that completes Slice A, a new Draft emits schema 4 when it has Jira context and schema 2 otherwise. It has Jira context when it can read the live Epic ADF and the Epic's existing children. Its output states which case applies.

## Child invariants

Each child uses a unique stable ref and exactly one disposition:

| Disposition | Jira key | Payload | Meaning |
| --- | --- | --- | --- |
| existing | Required | verify required | Verify only. Report drift; do not mutate. |
| update | Required | changes required | Change only named fields. Preserve omitted fields. |
| proposed | Null or omitted | fields required | Create one direct Epic child. |

Allowed child types are Spike, Task, and Story. A v2 Spike also names variant: design or variant: investigation.

Every child defines or verifies summary and done_when. Include evidence and estimate when known. Put material gaps in unknowns; do not invent values.

changes and fields may contain only summary, done_when, evidence, estimate, and description. A nonlegacy description requires an exact template ID and hash. A schema-2, template-set-1 manifest may omit the hash; the immutable registry entry supplies it. Description keys match the registered required and conditional keys. Apply cannot add template content after approval. Omission of a description preserves the live description.

For a Story, give each scenario, documentation artifact, and instrumentation signal a stable ID. Planned fields cover observable scenarios, contextual documentation, automated integration or functional tests mapped by scenario ID, and the smallest signal set that proves the Story outcome or an operational decision. Each signal names its class, precise signal, purpose, implementation target, and expected observation. The intended suite, location, and environment are optional at plan time; supply them when known and record material gaps in `unknowns`.

For each documentation, automated-test, and instrumentation obligation, supply either a nonempty plan or one complete approved exception—not both. An exception names the obligation, reason, approver, and approval evidence.

At `IN REVIEW`, evidence covers every planned artifact, scenario, and signal exactly once. Tests have status `passed` and use the planned environment when one was named. Documentation is `published`, `updated`, or `confirmed_current`; confirmation identifies the reviewer and applicable revision or review record. Instrumentation evidence names a representative environment and contains implementation evidence, observed output, and a retained reference. Unit tests, manual tests, instrumentation code without output, and output without implementation evidence do not satisfy the gate.

For every excepted class, `review_evidence.approved_exceptions` contains the obligation, status `confirmed`, and the same approval-evidence reference recorded in the plan. It contains no entry for a planned class and does not repeat the reason or approver.

For a Story whose approved template cannot represent the current evidence fields, Review or Audit may consume a separate lifecycle-evidence record. It identifies the exact Story key and template, maps automated evidence to stable scenario IDs, and supplies documentation, automated-test, and instrumentation evidence or a complete exception for each class. When the old description has no IDs, the record binds one unique ID to each exact scenario text. The bindings cover the existing scenarios exactly once. The record is evidence only: it does not become manifest content, migrate the template, or authorize Apply.

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

1. Jira context: `Jira context: present`, or `No Jira context: design claims are unverified`. Without Jira context, the manifest is schema 2 and each design claim it relies on is an `unknowns` entry beginning `Unverified design claim:`.
2. Epic outcome.
3. Reconciliation table: each proposed item, mapped to the existing Jira key it reconciles to or to `new`.
4. Material conflicts: each with both sources, their dates, and the winner, matching `sources.conflicts`.
5. Proposed child table.
6. Complete YAML manifest.
7. Dependency edge list or graph using A -> B for A blocks B.
8. Cycle, direction, duplicate, redundancy, missing-edge, and orphan checks.
9. Questions that materially affect the breakdown.

Use temporary references until Jira assigns keys. Do not create placeholder Jira keys.

## Review output

Report only material defects and the smallest corrections, as a findings block. The block is Review output, not manifest content.

~~~yaml
findings:
  - category: component-story
    ref: WORK-501
    correction: Merge the interface and API Stories into one demoable flow.
~~~

Each finding contains category, ref, and correction. ref is the child ref or Jira key the finding concerns. category is one of:

- `wrong-type`: wrong issue type or Spike variant.
- `misclassified-spike`: a Task that relies on an existing pattern whose precedent verdict is unverified or none. It stays a Spike until a precedent is found.
- `component-story`: a Story that is not a demoable user, partner, or system flow, such as a Story for one component or layer.
- `unverifiable-completion`: no independently verifiable completion.
- `missing-implementation`: missing implementation work.
- `missing-story-evidence`: missing Story scenarios, contextual documentation, mapped automated tests, or instrumentation that proves the Story outcome or an operational decision.
- `missing-review-evidence`: review-entry evidence missing for a Story entering IN REVIEW.
- `content-quality`: vague, trivial, repeated, or unsupported content.
- `too-broad`: work too broad to execute safely.
- `unsupported-assumption`: an assumption presented as fact.
- `stale-source`: a claim built on a design source that a later dated decision contradicts.
- `invalid-manifest`: invalid manifest or template binding.
- `dependency`: reversed, redundant, duplicate, missing, or cyclic dependencies.

Review and Audit never flag a team's own Spike shape or Task granularity. Those are Draft defaults, not defects.

Return a corrected edge list only when an edge changes. Do not replace valid work.
