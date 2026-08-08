# Handback

## Summary

Installer now handles optional Vale dependency setup through explicit flags and an interactive prompt.

## Proof

- `bash -n install.sh scripts/*.sh tests/*.sh`
- `./scripts/validate-skills.sh`
- `./tests/install-test.sh`
- `./scripts/lint-prose.sh`

## Remaining Risk

Only Homebrew install is automated in this slice. Other systems get manual install guidance.

