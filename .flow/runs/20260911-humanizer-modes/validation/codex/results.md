# Codex runtime results

Date: 2026-09-14. User-authorized authenticated service. `validation/raw/` retains prompts, outputs, metadata, and tool events locally.

- Complete candidate suite before the final policy/path edits: 27/27 source-admissible calls, 25/27 fixture checks passed under independent quality review. `paired-engineering` lost the prior mistaken expectation; `regression-word-choice` dropped the `config` action target. A general policy correction addressed both in a four-case affected retake (4/4 pass), but this is not a final-hash full-suite pass.
- Installed 4.8.0 at repository release v1.6.0: eight selected calls source-admissible, 8/8 fixture checks passed. The `strict-file` trace invoked the personal lint profile.
- Installed 4.8.1 at repository release v1.6.1: five affected calls source-admissible at entry `61c6d757...` and policy `53a8a9b7...`, 5/5 fixture checks passed. The `strict-file` trace again invoked personal lint; packaged reference paths were read. Exact protected-span scan: none omitted in edit outputs.

This is sampled installed-path behavior with explicit skill file paths, not proof of automatic skill-name discovery.
