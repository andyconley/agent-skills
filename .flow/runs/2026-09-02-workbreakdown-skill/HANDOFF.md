# Workbreakdown Skill Handback

## Outcome

Added portable `workbreakdown` version `1.0.0` for Codex and Claude Code. It supports Draft, Review, read-only Audit, and explicitly authorized Apply modes. Every Draft emits a complete YAML desired-state manifest.

## Delivered

- Concise skill entrypoint with mode routing and fail-closed write authorization.
- Canonical work-item, sizing, acceptance, and dependency SOP.
- Versioned manifest contract with field-level mutation authority, scoped ranking, explicit dependency actions, and immutable approval identity.
- Connector-neutral Jira Audit and Apply protocol with untrusted-data isolation, capability preflight, mutation journaling, partial-failure handling, and final readback.
- Active manifest registration, public documentation, contributor guidance, and issue-template updates.
- Static contract checks, 17 installer cases, and manual behavior tests for all four modes.
- Managed installation under both `~/.agents/skills/workbreakdown` and `~/.claude/skills/workbreakdown`.

## Proof

- Package and version validation passed for all three repository skills.
- Workbreakdown static contract test passed.
- Installer suite passed 17 of 17 cases on the local checkout.
- Vale reported 0 findings across 34 files.
- The example manifest parsed as YAML with every required top-level field.
- Version mutation was detected by the repository validator and restored.
- Quality and security reviews accepted the final implementation with no open findings.
- Both local runtime links report `1.0.0` and resolve to the same source.

## Limits

- Fresh-session UI discovery still requires opening new Codex and Claude Code sessions. Static metadata and runtime paths are verified; this run cannot restart itself to prove UI discovery.
- Live Jira Audit and Apply were not exercised. The skill intentionally ships no Jira connector or credentials. Controlled live validation should use an isolated Jira project and the cases in `tests/manual/workbreakdown.md`.

## Recovery and next action

The feature is committed on `feat/workbreakdown-skill` and pushed to GitHub. Review and merge the pull request, then rerun `./install.sh --with-vale --all` on `main`. Existing local symlinks already point to the feature content in this checkout.
