# Solution: workbreakdown Slice A (R0, R1, R2, R5)

- Status: Approved 2026-09-24 by the maintainer. This is a sanitized copy of the private run's approved solution.
- Engagement answers: plan Slice A first; record answers in the epic's Jira description; mark placeholders with a `[PLACEHOLDER]` summary prefix; bump the manifest schema; make the release test a script.

## Decisions

1. **Recorded answers live in an epic-v3 `breakdown_conventions` panel.**
   - The panel holds the shaping answers, reviewers and any source-order override, each with its source (`asked`, `reused` or `default`).
   - It is written only by the existing schema-3 guarded Epic update at Apply (`manifest-contract.md`, "Schema 3: scoped Epic authority").
   - Siblings are read from the Initiative's epics.
   - Rejected: a Jira entity property. It is invisible to people, needs a new write path, and is unevenly exposed by MCP tools. It remains the fallback if hand edits to the panel cause drift.
2. **Manifest schema 4 carries every Slice A field.**
   - `shaping` (R0)
   - `sources.existing_children`, `sources.conflicts[]` (both sources, dates, winner, material) and `sources.jira_context` (R1)
   - per Spike: `question` and `precedent {searched[], verdict: none|found|unverified, location?}` (R2.1–2.2)
   - a reviewer slot on both Spike variants (R2.7)
   - per Task: `placeholder {defined_by}` (R2.6) and `precedent.location` (R2.2)

   Review, Apply and the release script check these fields mechanically. Schemas 2 and 3 stay valid. Rejected: a minimal schema 4 that leaves these checks in prose.
3. **Placeholders use the `[PLACEHOLDER]` summary prefix and a new `task-placeholder-v3` template** containing only `purpose` and `defined_by` (an inline card to the Spike). By construction, the Task acceptance-count rule and the unresolved-placeholder rejection do not apply to it. Rejected: a flag that relaxes validation on task-v2.

## Architecture

- **Boundaries:** Draft and Review only read. Apply is the only writer, and there is no new write path.
- **Interfaces:** manifest schema 4, plus epic-v3, spike-design-v3, spike-investigation-v3 and task-placeholder-v3.
- **State:** Jira remains the store. The epic panel is the only durable home for the answers.
- **Operations:** a private live-agent release script runs outside this repository.
- **Durability:** one minor bump, to 1.5.0, when Slice A is complete, with a migration note.

## Chunks

Build order: 1 first, then 2, 3 and 4 in any order, then 5. Chunk 6 can start any time after 1.

1. **Schema 4 foundation.** The schema 4 definition, with every Slice A field optional. Validators accept schemas 2, 3 and 4. Fixtures for schemas 2 and 3 are unchanged, plus a schema-4 fixture.
2. **R1 source authority.** Inventory of existing children, conflict and staleness detection, and the no-Jira fallback.
3. **R2 classification.** Precedent fields, the reviewer slot on both Spike templates (v3), the component-Story finding, the SOP rewrite, and the vertical-slice default.
4. **Placeholders.** The task-placeholder-v3 template, the prefix, `defined_by`, and registry entries.
5. **R0 invocation questions.** The question set, the epic-v3 panel, sibling discovery, divergence reporting, and non-interactive defaults.
6. **Release script.** Private, outside this repository.

## Risks

Andy, the maintainer, owns every risk unless one is marked otherwise.

- **Panel writes to an epic someone else owns.** Mitigation: Draft never writes; Apply requires the epic owner's agreement, and the preflight states this.
- **Schema 2 or 3 regressions.** Owner: the implementer. Mitigation: existing fixtures stay unchanged, and validator changes are additive.
- **The panel drifts from the manifest.** Mitigation: Review reports divergence, and the entity-property option is the fallback.
- **Flaky live-agent runs.** Mitigation: assertions run on structured manifest fields, with negative controls and a documented rerun tolerance.
- **Private identifiers leak into this repository.** Mitigation: fixtures stay out of the repository, public tests are synthetic, and a key-pattern grep of the diff is a release check.
- **Imprecise precedent checks.** Owner: the implementer. Mitigation: an unverified precedent never downgrades a Spike.

## Next lane

`flow-plan`, chunk 1.
