# Implementation

## Changed

- Added installer flags:
  - `--with-vale`
  - `--no-vale`
- Added optional Vale install handling to `scripts/manage-skills.sh`.
- Updated README with Vale installer behavior.
- Expanded install tests from 11 to 16 checks.

## Behavior

- Existing Vale: report installed version and continue.
- Missing Vale + interactive default: prompt to install.
- Missing Vale + noninteractive default: print a short skip note and continue.
- `--with-vale`: install through Homebrew when available; fail clearly otherwise.
- `--no-vale`: skip dependency handling.
- `--uninstall --with-vale`: reject as invalid.

## Safety

- Target symlink preflight runs before any Vale install attempt.
- Normal skill install does not fail because Vale is missing.
