# Requirements

## Goal

Publish `andyconley/agent-skills` as the public source of truth for portable Agent Skills, beginning with `humanizer` and `doc-flow-review`.

## Accepted behavior

- Use the MIT license and publish directly to `main`.
- Keep the stable checkout at `${AGENT_SKILLS_HOME:-$HOME/agent-skills}`.
- Install selected skills into both `~/.agents/skills` and `~/.claude/skills` using symlinks.
- Drive selection from `skills/manifest.tsv`; support interactive choice, `--all`, and repeated `--skill`.
- Treat empty interactive input as cancellation.
- Validate the full selection before changing any runtime target.
- Accept an existing correct symlink as success. Stop on a file, directory, broken/unrelated symlink, dirty checkout, or unexpected origin.
- Update only with `git pull --ff-only`.
- Never prune or remove unrelated or unselected skills.
- Support explicit narrow uninstall with `--uninstall`; remove only expected repo-controlled symlinks.
- Move retired declarations to `skills/retired.tsv` and keep their source in the repository so existing links do not break.
- Test on macOS and Linux.
- Migrate the current machine with timestamped backups rather than hard deletion.

## Non-goals

- Windows support.
- Version-channel or tag selection in the first release.
- Automatic cleanup of runtime directories.
- Guaranteeing a built-in fallback after uninstall; that depends on the host.
