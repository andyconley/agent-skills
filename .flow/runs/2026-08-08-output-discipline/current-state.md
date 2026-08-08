# Current State

## Repo

- Repository: `andyconley/agent-skills`
- Branch before work: `main`
- Worktree before work: clean

## Skill layout

- `skills/humanizer/SKILL.md`
- `skills/humanizer/VERSION`
- `skills/humanizer/agents/openai.yaml`
- `skills/doc-flow-review/SKILL.md`
- `skills/doc-flow-review/VERSION`
- `skills/doc-flow-review/assets/reviewer-block.md`
- `skills/doc-flow-review/agents/openai.yaml`

## Validation

`scripts/validate-skills.sh` enforces:

- every top-level directory under `skills/` must be declared in active or retired manifests
- version file, frontmatter description, and body version must match
- body must include `**Version: X.Y.Z.**`

Because of that, shared material should not live under `skills/shared`.

