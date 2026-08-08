# Plan

## Change surface

- Add repo-level shared output contract in `shared/agent-output-discipline.md`.
- Add examples under `examples/`:
  - `humanizer-agent-output.md`
  - `doc-flow-review-agent-output.md`
  - `agent-output-regression-prompts.md`
- Update both `SKILL.md` files to require the shared discipline.
- Update versions and metadata.
- Update README to describe shared examples and validation prompts.

## Contract

- Agent output should be the shortest complete useful answer by default.
- No method narration unless the user asks.
- No praise sandwich.
- No generic recap.
- No invented facts, examples, certainty, or enthusiasm.
- Findings/change notes are capped by default, with room for depth when explicitly requested.

## Validation

- Run `./scripts/validate-skills.sh`.
- Run `./tests/install-test.sh`.
- Review changed files for host-specific assumptions.
- Create branch, commit, push, open PR, merge.

