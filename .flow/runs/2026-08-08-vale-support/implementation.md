# Implementation

## Added

- `tools/vale/.vale.ini`
- `tools/vale/styles/AgentVoice/*.yml`
- `tools/vale/README.md`
- `scripts/lint-prose.sh`

## Changed

- Updated CI to run Vale through `vale-cli/vale-action@v3`.
- Updated `humanizer` to `4.5.0`.
- Updated `doc-flow-review` to `1.4.0`.
- Updated strict mode to run Vale when available and fall back manually.
- Updated README and metadata for optional Vale support.

## Notes

- Vale was installed locally with Homebrew for validation.
- CI uses the official Vale action, not a repo-managed dependency install.
- Vale rules are mechanical tripwires; final gates and pattern classes remain the judgment layer.

