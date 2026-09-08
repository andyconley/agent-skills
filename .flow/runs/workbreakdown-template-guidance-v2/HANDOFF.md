# Workbreakdown 1.2.0 Handback

## Delivered

- Added concise v2 Epic, Story, Task, design-Spike, and investigation-Spike templates.
- Preserved the original v1 template bytes and pre-v2 schema-2 manifest compatibility.
- Added version-aware registry defaults, set membership, asset hashes, required fields, conditional fields, and Story obligation alternatives.
- Added anti-bloat rules, shared completion profiles, and Story lifecycle gates.
- Required contextual Story documentation and automated integration or functional tests without making completed evidence a start-work gate.
- Added schema-3 authority for exact, approved Epic description updates with closed fields, preflight drift checks, canonical ADF digests, journaling, field preservation, and readback.
- Added parsed YAML/ADF fixtures, negative contract cases, installer asset coverage, manual prompts, CI syntax coverage, and public documentation.

## Compatibility and safety

- `workbreakdown` reports 1.2.0.
- New Drafts use v2. Explicit template-set-1 manifests remain on immutable v1 assets and do not need a new template hash.
- Schema 2 remains child-only. Schema 3 is required for Epic verification or description updates.
- Jira status, project, hierarchy, rank, security, reporter, creation, deletion, and reparenting remain outside Epic Apply authority.
- `IMPLEMENTATION READY` requires specific documentation and test plans. `IN REVIEW` requires published documentation and passing mapped tests in the planned environment.
- Jira and Confluence were not changed.

## Proof

- Shell syntax passed.
- Skill validation passed for all 3 skills.
- Workbreakdown parsed fixture and contract tests passed.
- Installer tests passed 17/17.
- Vale reported 0 findings across 45 files.
- Codex skill validation passed.
- `git diff --check` passed.
- Quality review: PASS.
- Architecture boundary review: PASS.
- Mutation check: changing the registered Epic v1 hash caused the fixture suite to fail with `hash drift for jira-epic-v1`; restoring it returned the suite to green.

## Installation and Git

- The installer refreshed both runtime links from the clean checkout.
- Codex: `/Users/andyconley/.agents/skills/workbreakdown` reports 1.2.0.
- Claude Code: `/Users/andyconley/.claude/skills/workbreakdown` reports 1.2.0.
- Implementation commit: `4324cc5 feat(workbreakdown): add concise v2 ticket contracts`.
- Remote push and release: performed after this handback was written. `main` was pushed on 2026-09-08, and semantic-release published repository releases v1.3.0 and v1.3.1. The skill version is unchanged at 1.2.0; repository and skill versions are separate streams.
- Acceptance review followed the push rather than preceding it. See `review.md` for the findings and `validation-results.md` for the corrected evidence record.

## Remaining limits

- Fresh-agent behavior prompts were not run. Start new Codex and Claude Code sessions before evaluating discovery behavior.
- Live Jira Apply was not run. Use the manual controlled-Apply matrix only with explicit authorization and an isolated Jira project. Acceptance review recommends that the first live Apply run in an isolated project against both a bare and a populated Epic, with a deliberately induced drift case.
- All ten manual behavior checks remain unrun. Review follow-up added static fixture coverage for parts of checks 1, 2, 7, and 8: every declared v2 key now needs a render target in the shipped template, Epic acceptance criteria that duplicate a success measure are rejected, and Task and both Spike variants validate their description keys and variant binding. The judgment halves of those checks, and checks 3, 4, 5, 6, 9, and 10, still need a live agent or live Jira.
