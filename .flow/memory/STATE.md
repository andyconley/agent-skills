# State

Durable facts about this repository that are not obvious from the code and have already cost time once.

## The installed skills are whatever branch is checked out

`install.sh` symlinks each skill directory into `~/.agents/skills/` and `~/.claude/skills/` rather than copying it. A `git pull` therefore takes effect with no reinstall, which is the intent — but switching branches silently changes what Codex and Claude Code load. During the 1.3.0 work both runtimes served an unmerged branch for as long as it stayed checked out.

Check with `cat ~/.claude/skills/<name>/VERSION` and `git rev-parse --abbrev-ref HEAD` together; either alone can mislead.

## Repository releases and skill versions are separate streams

The repository tag comes from semantic-release and counts commits. Each skill carries its own hand-maintained `VERSION`. They have never matched and are not meant to: repository v1.3.0 shipped workbreakdown 1.2.0, and repository v1.4.1 shipped workbreakdown 1.3.0.

A repository tag tells you nothing about which skill versions it contains. Read `skills/<name>/VERSION` at the tag.

The workbreakdown contract test derives its version assertion from that `VERSION` file, so `SKILL.md` and `VERSION` cannot drift apart silently.

## Release notes need conventional-changelog-conventionalcommits 9.x or lower

`conventional-changelog-conventionalcommits@10.3.0` is incompatible with semantic-release 25.0.9. Its notes generator returns an empty body and exits zero, so the workflow passes, the tag is created, and the release publishes with nothing in it.

Four releases shipped empty before anyone noticed, and the first diagnosis was wrong because v1.2.0's notes had been written by hand in `3be9dee` and looked like a working baseline. The pin in `.github/workflows/release.yml` is now 9.1.0. Versions 8.0.0 and 9.1.0 both render correctly with the existing config.

If notes go empty again, reproduce with `semantic-release --dry-run --no-ci --branches <branch>` from a worktree on a branch that exists on the remote. That isolates note generation from the analyzer, which was never the problem.
