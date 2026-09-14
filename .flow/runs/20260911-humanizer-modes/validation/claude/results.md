# Claude runtime results

Date: 2026-09-14. User-authorized authenticated service. `validation/raw/` retains prompts, outputs, metadata, and tool events locally.

- Complete candidate suite before the final policy/path edits: 27/27 source-admissible calls, 22/27 fixture checks passed under independent test-engineer review. Failures: `strict-personal`, `strict-file`, `audit-formatting`, `paired-engineering`, and `regression-word-choice` (see `validation/full-claude-review.md`). The four-case affected retake at the corrected policy hash scored 2/4.
- Installed 4.8.0 at v1.6.0: eight calls source-admissible, 4/8 fixture checks passed. The `regression-word-choice` output reported missing shared definition files under the installed skill path. This was a packaging defect and prompted 4.8.1.
- Installed 4.8.1 at v1.6.1: five affected calls source-admissible at entry `61c6d757...` and policy `53a8a9b7...`, 1/5 fixture checks fully passed under independent quality review. The `regression-word-choice` tool trace successfully read all three packaged shared references with returned content, closing the packaging defect. Remaining failures: unsupported rollback speed and invented examples in `regression-word-choice`; mirrored close in `paired-engineering`; omitted personal lint in `strict-file`; unrequested process prose after the `personal-runbook` artifact. `audit-formatting` passed. Exact protected-span scan: none omitted in edit outputs.

These are failed behavioral checks accepted only under the user's explicit best-effort release instruction. The installed-path sessions used explicit skill file paths and do not prove automatic skill-name discovery.
