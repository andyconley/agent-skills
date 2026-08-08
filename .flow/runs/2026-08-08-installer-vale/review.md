# Review

## Lead developer

- Kept `install.sh` as the checkout/update shim.
- Put option handling in `scripts/manage-skills.sh`, where installer behavior already lives.
- Ensured Vale install happens after target preflight.

## Test engineer

- Added mocked-path tests for missing Vale, skipped Vale, unsupported `--with-vale`, fake Homebrew install, and invalid uninstall combination.
- Confirmed test suite now reports `1..15`.

## Quality reviewer

- Confirmed Vale remains optional for normal installs.
- Confirmed explicit `--with-vale` fails clearly when unsupported.

## Dispositions

- No blocking findings.

