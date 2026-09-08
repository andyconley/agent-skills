# Current State

- `workbreakdown` reports version 1.1.0. The repository release tag is 1.2.0, but repository releases and per-skill versions are independent streams.
- The registry is schema 1 and maps `jira-*-v1` identities to unversioned template filenames.
- The four current templates have fixed baseline hashes captured in the validation plan.
- Template guidance requires every section or `None`/`N/A`, which conflicts with the accepted anti-bloat rule.
- Manifest schema 2 authorizes child reconciliation only. It has no Epic disposition, expected-current digest, or Epic description mutation contract.
- Contract tests mostly assert text presence. They do not parse registry or manifest fixtures, validate hashes, resolve variants, or compare normalized ADF.
- The installer links the complete skill directory into Codex and Claude Code. Existing tests cover link safety but only sample packaged files.
- Baseline validation passed before implementation in the lead-developer review.
