# Validation Results

## Automated checks

- Shell syntax: passed for installer, scripts, and tests.
- `scripts/validate-skills.sh`: passed; three skills declared and version-consistent.
- `tests/workbreakdown-contract-test.sh`: passed.
- `tests/install-test.sh`: 17 of 17 passed, including explicit `workbreakdown` install and uninstall for both runtime targets.
- `scripts/lint-prose.sh`: passed with 0 errors, 0 warnings, and 0 suggestions across 34 files.
- Codex `quick_validate.py skills/workbreakdown`: passed.
- Manifest example: parsed as YAML with all required top-level fields and `schema_version: 1`.
- `git diff --check`: passed.

## Mutation check

Ran. Changed only `skills/workbreakdown/VERSION` from `1.0.0` to `1.0.1`. `scripts/validate-skills.sh` failed because the description did not report the changed version. Restored `1.0.0` and reran the full suite successfully.

This proves version-drift fault detection. Agent behavior remains covered by manual black-box cases because the repository has no deterministic LLM evaluation harness.

## Validation location

All static, package, YAML, installer, and prose checks ran against the changed checkout itself. The installer test uses isolated temporary Codex and Claude target directories; its path, symlink, conflict, and uninstall verdicts transfer because those checks do not depend on live host discovery.

Fresh-session Codex and Claude discovery and live Jira Apply remain runtime checks. Their verdict is not inferred from the isolated tests.
