# Workbreakdown Template Guidance v2 Plan

## Outcome

Release `workbreakdown` 1.2.0 with concise v2 Jira templates, immutable v1 compatibility, explicit Story documentation and automated-test completion gates, and manifest-schema-3 authority for approved Epic description updates.

## Implementation sequence

### 1. Preserve v1 and make the registry version-aware

Files:

- `skills/workbreakdown/assets/jira-templates/registry.yaml`
- existing template assets under `skills/workbreakdown/assets/jira-templates/`

Changes:

1. Rename the current unversioned Epic, Story, Task, and Spike files to `*-v1.md` without changing their contents.
2. Advance the registry to schema 2 and template-set version 2.
3. Make registry entries template-centric. Record ID, issue type, variant, status, file, required keys, conditional keys, and SHA-256.
4. Retain each current `jira-*-v1` identity as `legacy` and verify its file hash.
5. Add defaults for Epic, Story, Task, and Spike variants. New Drafts use v2; an explicitly bound v1 manifest continues to resolve v1.
6. Reject unknown template-set versions, IDs, variants, missing assets, and hash mismatches.

### 2. Add concise v2 templates and population rules

Files:

- `skills/workbreakdown/assets/jira-templates/epic-v2.md`
- `skills/workbreakdown/assets/jira-templates/story-v2.md`
- `skills/workbreakdown/assets/jira-templates/task-v2.md`
- `skills/workbreakdown/assets/jira-templates/spike-design-v2.md`
- `skills/workbreakdown/assets/jira-templates/spike-investigation-v2.md`
- `skills/workbreakdown/references/ticket-quality-and-completion.md`
- `skills/workbreakdown/references/jira-description-templates.md`
- `skills/workbreakdown/references/work-breakdown-sop.md`

Changes:

1. Define required core fields and material conditional fields for each template. Omit empty conditional sections; use `N/A` only for a required fixed cell.
2. Add quality checks that reject placeholders, repeated facts, empty headings, generic claims, unsupported content, and text that does not help implementation or verification.
3. Define shared DoD profiles for ticket, sprint, and release layers. Tickets reference the profile and render only additions, approved exceptions, and evidence.
4. Epic v2 separates milestone outcome, success measures, acceptance criteria, and release DoD. Require 3–5 binary acceptance conditions with evidence and acceptor when known.
5. Story v2 includes materially distinct observable scenarios and structured delivery evidence:
   - contextual documentation artifact, audience, intended location, and owner when known
   - automated integration or functional tests mapped to scenarios, with level, suite or proposed location, environment, and expected evidence
6. Define lifecycle semantics:
   - `IMPLEMENTATION READY`: planned documentation and test coverage are specific enough to start work; artifacts need not exist or pass.
   - `IN REVIEW`: documentation is published or updated, mapped automated tests pass in the named environment, and evidence is linked. Missing evidence blocks review entry.
7. Task v2 names one concrete artifact or operational result, 2–5 binary acceptance conditions, validation evidence, and ticket-level DoD.
8. Design-Spike v2 governs a design decision and linked artifact without copying the design into Jira. Investigation-Spike v2 remains smaller and evidence-oriented.

### 3. Add manifest-schema-3 Epic authority

Files:

- `skills/workbreakdown/references/manifest-contract.md`
- `skills/workbreakdown/references/jira-change-protocol.md`
- `skills/workbreakdown/SKILL.md`

Changes:

1. Preserve schema 2 for child-only manifests. It cannot authorize Epic mutation.
2. Define schema 3 for manifests that verify or update the scoped Epic.
3. Give `epic` exactly one disposition:
   - `existing`: verify declared fields and report drift; never mutate.
   - `update`: change only fields under `changes`.
4. Bind an Epic description update to `scope.epic_key`, `jira-epic-v2`, template-set version 2, asset hash, complete approved content, and an expected-current normalized ADF digest.
5. Keep acceptance criteria inside the templated description unless the manifest explicitly names a verified Jira field. Do not infer or duplicate a custom field.
6. Reject Epic creation, deletion, reparenting, retyping, ranking, project/status/sprint/security/reporter changes, and every omitted field mutation.
7. Preflight the raw Epic ADF and relevant fields before any write. Stop the whole Apply on material Epic drift.
8. Journal the Epic delta, render only approved values, read the Epic back, compare normalized structure and meaning while ignoring regenerated `localId` values, and prove omitted fields stayed unchanged.
9. Record Epic outcomes in Apply counts and partial-failure reporting. Do not attempt compensating changes that overwrite unrelated state.
10. Add Review and Audit findings for ticket quality and lifecycle eligibility without authorizing status changes.

### 4. Update validation, documentation, and release metadata

Files:

- `tests/workbreakdown-contract-test.sh`
- `tests/manual/workbreakdown.md`
- `skills/workbreakdown/VERSION`
- `skills/workbreakdown/SKILL.md`
- `skills/manifest.tsv`
- `README.md`
- `docs/README.md`

Changes:

1. Add registry and asset tests for v1 identity/hash preservation, v2 defaults, required/conditional keys, and both Spike variants.
2. Add a small validator and fixture harness that parses registry and manifest YAML, resolves templates, and checks rendered output. Do not rely on text-presence assertions alone.
3. Add contract tests proving schema 2 cannot mutate an Epic and schema 3 rejects missing disposition, template, complete description, expected-current digest, forbidden fields, or unapproved criteria.
4. Add manual Draft and Review cases for concise content, Epic criteria separation, Story documentation/test plans, and material conditional sections.
5. Add lifecycle cases proving planned evidence allows `IMPLEMENTATION READY`, while missing published documentation or passing mapped tests blocks `IN REVIEW`.
6. Add Apply cases for Epic drift causing zero writes, omitted-field preservation, normalized ADF readback, mismatch reporting, and partial failure.
7. Extend installer tests to prove both Codex and Claude Code expose every bundled v1 and v2 template asset without weakening uninstall safety.
8. Bump the skill version to `1.2.0` in `VERSION`, frontmatter, body, and manual discovery tests.
9. Update public docs to describe v1 compatibility, v2 defaults, schema 3 Epic updates, and Story completion gates without internal sources or identifiers.
10. Use a focused Conventional Commit such as `feat(workbreakdown): strengthen ticket completion contracts` during implementation. Let semantic release update the repository changelog and release.

## Constraints

- Do not modify Jira or Confluence while implementing the skill.
- Do not include internal Jira keys, Confluence URLs, company-specific policy prose, credentials, or required connectors.
- Do not change v1 template bytes after their versioned copies are created.
- Do not make documentation or passing tests prerequisites for starting implementation.
- Do not add Jira status mutation authority.
- Do not replace automated integration or functional tests with manual demonstrations.
- Do not broaden Task or Spike requirements with irrelevant Story or release gates.

## Completion

Implementation is complete when the accepted criteria pass, all required automated checks are green, manual cases have recorded results, installed Codex and Claude Code copies report `workbreakdown` 1.2.0, and the final diff contains no internal identifiers or unintended files.
