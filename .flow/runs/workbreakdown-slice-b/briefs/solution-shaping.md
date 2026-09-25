# Brief: solution shaping for workbreakdown Slice B

**Role:** read-only. Return your analysis as your final message. The coordinator writes it into `research/`.

## Problem (confirmed with the maintainer, 2026-09-25)

Slice B makes the Epics under one Initiative consistent with each other, and makes Audit catch dependency-graph defects that are about meaning. Both R3 and R4 are solutioned together.

- **R3, cross-Epic consistency.** Whenever sibling Epics exist, Draft runs a consolidation check. It runs even for a single-Epic Draft, and it can be opted out of explicitly.
  - Draft proposes one owner for each decision claimed by more than one Epic, and the lead confirms.
  - Milestone order comes from Initiative rank or a declared list. Otherwise it is reported as unknown.
  - A later-to-earlier edge is a defect unless it is recorded as an exception.
  - Acceptance sits in the same Epic as the work that proves it, or is joined to it by a forward edge.
- **R4, semantic Audit checks,** with no manifest change:
  - a link whose direction contradicts the ticket text
  - a link into Done or Rejected work
  - a later-to-earlier edge
  - a blocker stated only in text
  - a status that contradicts open blockers, using Jira status categories

  Each link finding is classified `mechanical`, `scope-disagreement` or `unknown` from the link history, citing the author and date.

## Maintainer answers

1. R3 and R4 are solutioned together.
2. The confirmed owner of a shared decision is recorded in a **new optional schema-4 block**.
3. A single-Epic Draft reads the **siblings' full children**.
4. Link classification comes from the changelog's author and date plus the ticket text, and is `unknown` when intent is not evident. The lead does not have to confirm each one.
5. Proof reuses the private release check and frozen fixture. The fixture's change history includes Link events with author and date, on 52 cards.

## Binding precedent (from archive retrieval of prior workbreakdown runs)

- **Schema 4:**
  - Its blocks are optional and closed-shape, and unknown fields are rejected.
  - Schema 2 and 3 and template sets 1–3 are frozen.
  - Any new block must keep a manifest without it valid.
- **Apply:**
  - It stays fail-closed.
  - No new Jira write path.
  - `Blocks` semantics do not change, which is a definition non-goal.
- **Audit:** it is read-only and returns findings and a proposed change set.
- **Divergence list:** it is advisory. Owner arbitration was deferred to Slice B, and the divergence list must not grow into it.

## Evidence inventory (what exists)

Skill at 1.5.0 under `skills/workbreakdown/`:
- `SKILL.md`
- `references/work-breakdown-sop.md`, which has the Shaping questions, Source authority, Classification and precedent, and Dependency rules sections
- `references/manifest-contract.md`, which has the schema-4 shaping, sources, classification, unbound Epic, breakdown_conventions, Draft output and Review output sections
- `references/jira-change-protocol.md`, which has the Audit 12-item output list, Preflight, and Apply order
- `references/jira-description-templates.md`
- `assets/jira-templates/registry.yaml`, where template set 4 is the default

Validator and tests:
- the validator, `tests/workbreakdown/manifest-validator.rb`
- `tests/workbreakdown/workbreakdown-template-contract-test.rb`
- `tests/workbreakdown-contract-test.sh`

Run records:
- The definition is `.flow/runs/workbreakdown-slice-b/definition.md` (Slice B section, R3 and R4), and the criteria are in `acceptance-criteria.md`, which has the AC-R3.* and AC-R4.* entries.
- The Slice A run records are under `.flow/runs/workbreakdown-slice-a-completion/`: `plan.md`, `validation-results.md` and `HANDOFF.md`.

Fixture cases, by ID only:
- FX-COLLISIONS, FX-COPY-ACCEPT, FX-EXCEPTIONS
- FX-REV-LINKS, FX-DONE-LINK, FX-SCOPE-LINKS
- FX-TEXT-BLOCKERS, FX-STATUS, FX-FORWARD-OK

## What each role returns

Cite file and line. Give at least two options where a real choice exists, each with its tradeoffs, and name what you would recommend and why.
