# Validation Evidence

## Automated

- `./scripts/validate-skills.sh` -> `Validated 2 skills.`
- `./tests/install-test.sh` -> `1..16`, all checks passed.
- `./scripts/lint-prose.sh` -> `0 errors, 0 warnings and 0 suggestions in 21 files.`
- `git diff --check` -> no whitespace errors.

## Targeted Vale Checks

- `/tmp/agent-skills-humanizer-bad.md` failed as expected:
  - `AgentVoice.AphoristicClosers`
  - `AgentVoice.MirroredRhythm`
  - `AgentVoice.DecorativeContrast`
  - `AgentVoice.WeakSTE`
- `./scripts/lint-prose.sh examples/regression/protected-parallelism.md` passed with `0 errors, 0 warnings`.

## Manual Review

- Diff reviewed for version consistency, over-broad Vale duplication, and accidental polished prose.
- Removed duplicate STE warnings from `CorporateFiller`; `WeakSTE` owns the softer STE tripwires.
