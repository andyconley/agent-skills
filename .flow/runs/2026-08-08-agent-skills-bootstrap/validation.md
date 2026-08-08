# Validation

## Local checks

- `bash -n install.sh scripts/*.sh tests/*.sh`: passed.
- `scripts/validate-skills.sh`: passed; two active skills declared and matched to their folders/frontmatter.
- Codex `quick_validate.py`: passed for `humanizer` and `doc-flow-review`, both in the repository and through the installed links.
- `tests/install-test.sh`: 11/11 passed.
- Bootstrap integration against a temporary bare remote: clone, repeat update, link creation, and dirty-checkout refusal passed.
- `git diff --check`: passed.

## Published checks

- Public repository: `https://github.com/andyconley/agent-skills`.
- Initial commit: `cad4ef7 feat: publish portable agent skills`.
- GitHub Actions CI run `31271183331`: passed on Ubuntu and macOS.

## Local migration

- Installed repository-controlled links for both skills under `~/.agents/skills` and `~/.claude/skills`.
- Preserved unrelated Flow and Claude skills.
- Moved replaced Codex and Claude copies to `/Users/andyconley/.agent-skills-backups/20260808T180850Z`.
- Removed no skill source or unrelated runtime entry.

## Deferred

- ShellCheck was not installed locally; CI's syntax and integration coverage passed on both supported operating systems.
- Host discovery should be confirmed in a new Codex and Claude Code session because running sessions may cache skill metadata.
