# Workbreakdown Template Guidance v2 Solution

## Decision

Add a backward-compatible template-set version 2. Freeze the current v1 assets and identities for approved manifests. New Drafts select v2 templates by default. Advance the manifest to schema 3 because Apply gains explicit authority to update the scoped Epic; template-set versioning continues to own description-shape evolution.

## Package shape

```text
skills/workbreakdown/
|-- SKILL.md
|-- VERSION
|-- assets/jira-templates/
|   |-- registry.yaml
|   |-- epic-v1.md
|   |-- epic-v2.md
|   |-- story-v1.md
|   |-- story-v2.md
|   |-- task-v1.md
|   |-- task-v2.md
|   |-- spike-v1.md
|   |-- spike-design-v2.md
|   `-- spike-investigation-v2.md
`-- references/
    |-- jira-description-templates.md
    |-- ticket-quality-and-completion.md
    |-- manifest-contract.md
    |-- work-breakdown-sop.md
    `-- jira-change-protocol.md
```

The registry becomes template-centric. It records defaults, issue type, variant, status, file, required keys, conditional keys, and a content hash for each immutable template identity.

## Content model

Use concise required cores and conditional sections. The renderer omits conditional sections with no material content. It uses `N/A` only when a fixed Jira table cell requires a value.

Reference shared Definition-of-Done profiles rather than copying their checklists into tickets:

```yaml
definition_of_done:
  profile: ticket
  additions:
    - Recovery is verified on representative hardware.
  exceptions: []
```

Render only additions and approved exceptions when the base profile is already known to the team.

### Epic v2

Separate milestone outcome, success criteria, acceptance criteria, and release completion:

- Success criteria: measurable post-delivery outcomes, including target, timeframe, and measurement source when known.
- Acceptance criteria: 3–5 binary milestone conditions, each with verification evidence and acceptor when known.
- Definition of Done: reference the applicable release profile plus additions or approved exceptions.
- Never use “same as success criteria” as acceptance.

Schema 3 gives `epic` the same fail-closed disposition model used for children, limited to `existing` verification or explicit `update` changes. It binds description changes to `jira-epic-v2` and allows only approved Epic fields. Omitted fields remain unchanged. Apply preflights the live Epic, journals the field delta, and verifies the final description and acceptance content through readback.

### Story v2

Require observable scenarios and planned delivery evidence:

- contextual documentation: artifact, audience, intended location, and owner when known
- automated integration or functional tests: scenario mapping, level, suite or proposed location, environment, and expected evidence

At `IMPLEMENTATION READY`, the plan is sufficient; documents and tests need not exist or pass. Before `IN REVIEW`, documentation must be published or updated and the mapped automated tests must pass in the named environment. Exceptions require explicit approval. Manual demonstration is supplementary.

### Task v2

Require context, a concrete artifact or operational result, 2–5 binary acceptance conditions, named validation, and a ticket-level DoD profile. Include assumptions, exclusions, constraints, risks, or open questions only when they change execution or review.

### Spike variants

- Design: bounded decision, key questions, constraints, material alternatives and tradeoffs, linked design/evidence artifact, relevant checklist coverage, reviewers, decision evidence, risks, closure conditions, and downstream updates.
- Investigation: bounded question, evidence method, findings or decision, closure conditions, and downstream effect.

Do not reproduce a design document in Jira. The ticket governs the decision and evidence; the linked design artifact carries the detail.

## Lifecycle and mutation boundary

Treat `IMPLEMENTATION READY` and `IN REVIEW` as Review and Audit eligibility judgments. Do not add Jira status to the manifest or authorize status transitions. Apply remains limited to the exact approved Epic and child fields, descriptions, and links.

## Alternatives rejected

- Rewrite v1 assets in place: breaks approved manifest identity and reproducibility.
- Fill every section with `None` or `N/A`: creates noise and hides missing substance.
- Copy layered DoD checklists into every ticket: repeats policy and bloats descriptions.
- Read internal Confluence at runtime: breaks portability, adds authentication dependencies, and can leak internal identifiers.
- Force all Spikes through a design template: burdens investigation work with irrelevant sections.
- Hide Epic update authority inside schema 2: makes a materially broader mutation contract look backward-compatible.
