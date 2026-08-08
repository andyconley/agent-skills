# Current State

## Repo

- Branch before work: `main`
- Worktree before work: clean

## Installer

- `install.sh` updates or clones the checkout, then execs `scripts/manage-skills.sh`.
- `scripts/manage-skills.sh` parses install/uninstall flags and links skills into Codex and Claude Code targets.

## Vale

- Vale config exists under `tools/vale/`.
- `scripts/lint-prose.sh` requires `vale` on `PATH`.
- CI runs Vale through the GitHub action.

