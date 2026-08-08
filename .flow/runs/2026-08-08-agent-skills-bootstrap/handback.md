# Handback

## Outcome

`andyconley/agent-skills` is the public source of truth for `humanizer` and `doc-flow-review`. The repository includes a validated active/retired manifest, curl bootstrap, transactional symlink manager, explicit uninstall, integration tests, and macOS/Linux CI.

## Operations

- Interactive install: `curl -fsSL https://raw.githubusercontent.com/andyconley/agent-skills/main/install.sh | bash`
- Install all: append `| bash -s -- --all` to the curl command, or run `./install.sh --all` from the checkout.
- Uninstall selected: `./install.sh --uninstall --skill <name>`.
- Uninstall all managed skills: `./install.sh --uninstall --all`.
- Update: rerun the installer from a clean checkout.

The installer never prunes unselected skills. Uninstall removes only exact symlinks into this checkout. A host's built-in skill resumes only if that host ships one with the same name.

## Recovery

The pre-migration copies are at `/Users/andyconley/.agent-skills-backups/20260808T180850Z`. Restore them only after uninstalling the managed links so paths do not conflict.

## Resume point

Start new Codex and Claude Code sessions and confirm `$humanizer`/`$doc-flow-review` and `/humanizer`/`/doc-flow-review` discovery. Tag-based release channels remain intentionally deferred.
