# Current State

## Repository

- Checkout: `/Users/andyconley/agent-skills`
- Starting revision: `5140bab` on clean `main`, plus the approved Flow run and untracked initializer scaffold.
- Distribution: `scripts/manage-skills.sh` reads `skills/manifest.tsv` and links selected skill directories into both `~/.agents/skills` and `~/.claude/skills`.
- Validation: `scripts/validate-skills.sh` enforces folder, manifest, frontmatter name, SemVer, and visible version consistency. CI runs it on macOS and Ubuntu.

## Existing scaffold

- `skills/workbreakdown/SKILL.md` contains initializer TODO text only.
- `skills/workbreakdown/agents/openai.yaml` contains suitable display metadata and an initial default prompt.
- `VERSION`, references, manifest registration, documentation, and tests do not exist yet.

## Existing proof surfaces

- `tests/install-test.sh` tests dual-runtime links, idempotency, conflict preflight, narrow uninstall, unrelated-skill preservation, and optional Vale setup.
- `tests/manual/` contains Markdown behavior checks for live agents.
- `scripts/lint-prose.sh` checks repository prose with Vale.
- Codex `quick_validate.py` validates individual skill packages.

## Review-driven contract refinements

- Child mutation authority must be field-specific: `existing` is verify-only; `update` requires a Jira key and explicit changes; `proposed` must not claim a Jira key.
- Rank defaults to relative order among scoped children only. Unrelated children must retain their relative order.
- Dependency endpoints may use a local reference or external Jira key. Removing an edge requires an explicit `remove` action; absence is not deletion authority.
- Apply approval must identify the exact manifest revision or digest. A changed manifest requires new approval.
- Jira mutations are not transactional. Partial failure must preserve and report actual state rather than attempting destructive rollback of created issues.
