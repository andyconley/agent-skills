# Validation Plan

## Static validation

- `./scripts/validate-skills.sh`
- Codex `quick_validate.py skills/workbreakdown`
- `./scripts/lint-prose.sh`
- `git diff --check`

Confirm that the folder, frontmatter name, manifest entry, `VERSION`, description version, and body version agree. Confirm that frontmatter contains no Claude-only fields and that every referenced file exists.

## Installer validation

- Run the full installer regression suite.
- Add explicit tests for `--skill workbreakdown` and `--uninstall --skill workbreakdown` across isolated Codex and Claude target directories.
- Confirm `--all` includes the new skill and preserves unrelated skills.
- Rerun `./install.sh --all --with-vale` locally and verify both runtime symlinks.

## Behavior validation

Use fresh-session or isolated manual cases:

1. Draft emits all required sections and parseable YAML without writing Jira.
2. Review identifies misclassified items and the smallest graph correction without redesigning approved work.
3. Audit reports live or supplied-state defects without writes.
4. Apply refuses an unapproved or ambiguous manifest.
5. Apply stops when Jira access, rank mutation, link mutation, or final readback is unavailable.
6. Graph checks catch cycles, duplicates, reversed links, redundant transitive links, orphaned Spikes or Tasks, and a Story blocking its prerequisite.
7. Apply preserves unrelated items and link types.
8. A simulated post-write mismatch is reported as unverified rather than success.
9. Final Apply output includes the complete reference-to-key mapping and created, updated, unchanged, failed, restored, untouched, and verified counts.

## Cross-host validation

- Confirm Codex discovers `$workbreakdown` from `~/.agents/skills/workbreakdown`.
- Confirm Claude Code discovers `/workbreakdown` from `~/.claude/skills/workbreakdown`.
- Confirm both hosts report version `1.0.0` and follow the same mode and write boundaries.
