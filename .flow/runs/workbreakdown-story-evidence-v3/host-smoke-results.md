# Host Smoke Results

Run on 2026-09-09 in fresh, nonpersistent, read-only Codex and Claude Code sessions.

## Prompt

Report the installed workbreakdown version. Evaluate the same Story for `IMPLEMENTATION READY` when its documentation, mapped integration-test, and instrumentation plans are specific but not implemented, then for `IN REVIEW` when only unit tests and a manual demo passed and documentation, integration-test, and observed instrumentation evidence are absent. Do not change files or Jira.

## Results

| Host | Version | IMPLEMENTATION READY | IN REVIEW |
| --- | --- | --- | --- |
| Codex CLI 0.153.4, ephemeral read-only session | 1.4.0 | ALLOW | BLOCK: all three evidence classes missing |
| Claude Code, nonpersistent read-only session | 1.4.0 | ALLOW | BLOCK: all three evidence classes missing |

Both hosts loaded the installed skill, treated unit tests and the manual demo as supplemental, and required observed instrumentation in a named representative environment. Neither changed files or Jira.

The remaining manual prompt matrix—full v3 Draft, legacy Story review, exceptions, and controlled Apply—was not run.
