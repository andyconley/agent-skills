# Plan

## Change Surface

- Update `scripts/manage-skills.sh`.
- Update `README.md`.
- Update `tests/install-test.sh`.

## Installer Contract

- `--with-vale`: install Vale if missing; fail clearly if unsupported.
- `--no-vale`: skip dependency handling.
- default interactive install: prompt when Vale is missing.
- default noninteractive install: skip with a short note.
- uninstall mode: never installs Vale.

## Validation

- `bash -n install.sh scripts/*.sh tests/*.sh`
- `./scripts/validate-skills.sh`
- `./tests/install-test.sh`
- `./scripts/lint-prose.sh`

