# Planning brief: complete workbreakdown Slice A (chunks 2, 3, 4, 5, 6) in one implementation run

You are one of three planning roles. The work is read-only: don't edit any file. Return your analysis as text; the coordinator writes the plan.

## Confirmed by the maintainer

- **One implementation run covers chunks 2, 3, 4, 5 and 6.** Chunk 1, the manifest schema 4 foundation, is accepted: see `.flow/runs/workbreakdown-skill-improvements/review.md`. This run completes Slice A.
- **Templates:** the new templates go in a new template set 4. Set 4 becomes the default for new Drafts. Set 3 is frozen as is.
- **No Jira context:** when Draft has no Jira context and so no Epic ADF digest, it falls back to emitting schema 2 and says so. Schema 4 is not amended.
- **Release script source (chunk 6):** both sources, with the saved snapshot as the gate.
  - The snapshot is the private fixture, never committed to this repository.
  - Live Jira is read-only and advisory.
  - Coordinator proposal: the script fetches live Jira itself through REST GETs into a fresh snapshot, and the agent only ever reads snapshots. The agent never holds Jira credentials or write tools.
- **Review cadence:** a quick quality and test gate after each chunk inside the run, then a full review at the end.

## Evidence inventory

Paths are relative to `/Users/andyconley/agent-skills-worktrees/workbreakdown-slice-a`.

- **Approved requirements:** `.flow/runs/workbreakdown-skill-improvements/definition.md`, R0, R1, R2 and R5.
- **Acceptance criteria:** `.flow/runs/workbreakdown-skill-improvements/acceptance-criteria.md`, Slice A: AC-R0.1–R0.3, AC-R1.1–R1.4, AC-R2.1–R2.8, AC-R5 and AC-A-regression.
- **Approved solution:** `.flow/runs/workbreakdown-skill-improvements/solution.md`. It covers:
  - the epic-v3 `breakdown_conventions` panel, written only through the schema-3 Epic update
  - full schema 4
  - `task-placeholder-v3` with only `purpose` and `defined_by`
  - the `[PLACEHOLDER]` summary prefix
  - a minor bump to 1.5.0 with a migration note
- **Chunk 1 results:** `.flow/runs/workbreakdown-skill-improvements/plan.md`, `HANDOFF.md` and `review.md`. The review records these residual risks:
  - the Epic digest when there is no Jira access, now resolved as option (a)
  - "schema 3 requires an Epic-compatible template set" also fires for schema 4, deferred to chunk 5
  - free-text prose rules are pinned only by tests
- **Skill** (`skills/workbreakdown/`, VERSION 1.4.0):
  - `SKILL.md`, 79 lines, with the Draft, Review, Audit and Apply modes
  - `references/work-breakdown-sop.md`, 131 lines. Line 21 reads "Prefer several short Spikes over one open-ended research ticket." Line 51 reads "Aim for one to two days of focused work per Spike or Task when practical." Line 97 holds the Task acceptance count. Lines 105–107 cover Spike completion.
  - `references/manifest-contract.md`, 443 lines, including the Schema 4 section
  - `references/jira-description-templates.md`, 109 lines: selection, population, key rendering, review checks and ADF rendering
  - `references/jira-change-protocol.md`, 121 lines: the Apply preflight and writes
  - `references/ticket-quality-and-completion.md`
- **Templates:** `assets/jira-templates/`.
  - `registry.yaml` is schema 2 and `default_set_version: 3`. Its sets are 1, 2 and 3. Set 3 is epic-v2, story-v3, task-v2, spike-design-v2 and spike-investigation-v2.
  - Each template carries a sha256, `required_keys` and `conditional_keys`.
  - `spike-design-v2` already has a reviewers key. `spike-investigation-v2` does not.
- **Tests:**
  - `tests/workbreakdown-contract-test.sh` runs the `require_text` pins.
  - `tests/workbreakdown/workbreakdown-template-contract-test.rb` is the Ruby reference validator: registry, hashes, `validate_manifest` for schemas 2, 3 and 4, and the prose pins.
  - Fixtures are in `tests/workbreakdown/fixtures/`.
  - The suite asserts that the public skill folder contains no `AE-`/`ER-` keys.
- **Installed skill:** `~/.claude/skills/workbreakdown` is a symlink to `~/agent-skills/skills/workbreakdown`, the main checkout at 1.4.0, not this worktree. Headless `claude` 2.1.282 is available at `~/.local/bin/claude`.
- **Private fixture:** `/Users/andyconley/KB/.claude/worktrees/nostalgic-kapitsa-82d9e6/.flow/runs/workbreakdown-skill-improvements/`. It holds `evidence/tabletop/` (team snapshot, drafts, comparison) and `fixture-cases.md`, which maps FX-* IDs to real evidence. This location is private, so never copy real keys or names into public text.
- **Constraints:**
  - `agent-skills` is a public repository.
  - Commits are local only and use conventional messages. semantic-release generates the root CHANGELOG, but the skill CHANGELOG, if one exists, is hand-written.
  - Never estimate or point tickets.
  - Never write to Jira in tests.

## Out of scope

- Slice B (R3 cross-epic checks, R4 semantic Audit), except where a Slice A criterion depends on it.
- Pushing or releasing.
