# Validation Results

## Automated checks

- `tests/workbreakdown-contract-test.sh`: passed.
- `scripts/validate-skills.sh`: passed; 3 skills validated.
- `scripts/lint-prose.sh`: passed; 0 errors, warnings, or suggestions across 46 files.
- `tests/install-test.sh`: passed; 17 of 17 checks.
- `git diff --check`: passed.

## Contract coverage

- Template set 3 selects immutable Story v3.
- Story v2 retains SHA-256 `ca7c5dcf753d6a0e2f432ef436801422ea81ca4c5c20bdabb358197c9c4fc6b4`.
- Set compatibility, schema-3 Epic compatibility, plan-or-exception exclusivity, integration/functional-only automation, documentation outcomes, signal IDs, review mappings, named representative environments, exception confirmation, and legacy v1 evidence bindings have positive and negative cases.
- Codex and Claude installer fixtures include `story-v3.md`.
- Current local Codex and Claude skill links both resolve to this repository and report workbreakdown `1.4.0`.

## Mutation check

Ran. Removed `observed_output` from the instrumentation review requirements. The targeted contract suite failed with `expected validation error containing "incomplete instrumentation evidence"`. Restored the requirement; the full suite passed.

## Review

Independent quality review initially found two enforcement gaps: review-time exception confirmation and legacy Story identity/scenario binding. Both were fixed and re-reviewed. Final verdict: approved with no remaining material defect.

## Not run

- Fresh interactive Codex and Claude manual prompts were not run. The manual cases were updated for later host-level smoke testing.
- No live Jira mutation was needed or authorized; this change affects the portable skill contract and local tests only.
