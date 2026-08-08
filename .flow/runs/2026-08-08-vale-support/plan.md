# Plan

## Files

- Add `tools/vale/.vale.ini`.
- Add custom style files under `tools/vale/styles/AgentVoice/`.
- Add `tools/vale/README.md`.
- Add `scripts/lint-prose.sh`.
- Update CI to run `scripts/lint-prose.sh` or official Vale action.
- Update both skills for Vale-aware strict mode.
- Update README with optional Vale usage.

## Wrapper contract

- No args: lint default repo paths.
- Args: lint only supplied files/directories.
- Missing Vale: exit clearly with install/use guidance.

## CI contract

- CI fails on configured Vale errors.
- CI should lint the repo's default Markdown paths.

## Validation

- `./scripts/validate-skills.sh`
- `./tests/install-test.sh`
- `./scripts/lint-prose.sh`
- `./scripts/lint-prose.sh examples/regression/`
- GitHub CI passes.

