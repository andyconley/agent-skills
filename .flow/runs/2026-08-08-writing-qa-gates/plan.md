# Plan

## Shared files

- Add `shared/final-gates.md`.
- Add `shared/pattern-classes.md`.
- Update `shared/agent-output-discipline.md` to reference strict mode and final gates.

## Skill files

- Update `humanizer/SKILL.md`:
  - version `4.4.0`
  - strict mode
  - final gate summary
  - pattern-class routing
  - truth-preservation boundary

- Update `doc-flow-review/SKILL.md`:
  - version `1.3.0`
  - strict mode
  - final gate summary
  - doc-flow-specific pattern classes

## Regression files

- Add examples under `examples/regression/`.
- Add manual prompts under `tests/manual/`.
- Update README to describe strict mode and manual QA.

## Validation

- Run `./scripts/validate-skills.sh`.
- Run `./tests/install-test.sh`.
- Inspect changed files for host-specific assumptions.
- Open PR, wait for CI, merge, sync local `main`, install updated skills.

