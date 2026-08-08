# Requirements

## Problem

The repo now ships Vale-backed strict mode, but the installer only links skills. On a fresh machine, users can install updated skills and still miss the optional Vale dependency.

## Desired Change

- Add optional Vale handling to the skill installer.
- Keep normal skill installation working when Vale is absent.
- Add explicit unattended flags:
  - `--with-vale`
  - `--no-vale`
- Prompt interactively when Vale is missing and no explicit flag is supplied.
- Fail only when `--with-vale` is requested and Vale cannot be installed.

## Constraints

- Do not make Vale mandatory for default skill installation.
- Do not remove or alter unrelated installed tools.
- Keep behavior safe in noninteractive install paths.

