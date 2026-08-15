# Validation

Run from the repo root on branch `add-ste-vocabulary-discipline`.

## Automated

| Check | Command | Result |
| --- | --- | --- |
| Skill and version consistency | `./scripts/validate-skills.sh` | `Validated 2 skills.` |
| Shell syntax | `bash -n install.sh scripts/*.sh tests/*.sh` | Clean |
| Installer behavior | `./tests/install-test.sh` | 16 of 16 pass |
| Prose lint | `./scripts/lint-prose.sh` | 0 errors, 0 warnings, 0 suggestions in 21 files |

The file count moved from 18 to 21 with the three new example files. The repo passes the rules it now ships.

## Rule behavior

Probed against a scratch file before commit:

- `Do not turn one problem into several overlapping findings.` — not flagged. Word boundaries hold.
- `Turn off the service, then set up the replacement.` — two `PlainVerbs` warnings.
- `The folder holds the file name and the e-mail template.` — three `TermDrift` suggestions.
- `We utilize the back-end to carry out the migration.` — two suggestions and one warning.

## Fixtures

| File | Proves |
| --- | --- |
| `examples/regression/humanizer-term-drift.md` | One name per concept, chosen from existing usage |
| `examples/regression/humanizer-phrasal-verbs.md` | Plain verbs, one instruction per step, texture moves dropped in a procedure |
| `examples/regression/doc-flow-term-drift.md` | The review reports drift and does not rewrite prose or pick the name |
| `tests/manual/humanizer.md` | Word Choice Pass and Mixed Document Pass, including the document-level escalation |

## Manual smoke

Pending: open a new agent session and ask for the running version. Expect `humanizer` 4.6.0 and `doc-flow-review` 1.5.0. A session opened before the change reports the version it loaded, as `README.md` records.
