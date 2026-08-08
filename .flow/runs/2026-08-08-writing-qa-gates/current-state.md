# Current State

## Repo

- Repository: `andyconley/agent-skills`
- Starting branch: `main`
- Worktree state: clean

## Existing support files

- `shared/agent-output-discipline.md`
- `examples/agent-output-regression-prompts.md`
- `examples/doc-flow-review-agent-output.md`
- `examples/humanizer-agent-output.md`

## Existing validation

- `scripts/validate-skills.sh` checks manifest and version consistency.
- `tests/install-test.sh` verifies install, uninstall, and preflight behavior.

## Constraints

- No Vale rules in this slice.
- No host-specific runtime assumptions.
- `SKILL.md` files must remain useful even if a host does not load shared files.

