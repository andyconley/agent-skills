# Test Strategy Review

## Finding

The existing `tests/workbreakdown-contract-test.sh` mainly checks whether expected text exists. That will not prove registry resolution, template rendering, lifecycle judgments, or manifest mutation boundaries.

## Required automated coverage

- Add a small validator and fixture harness that parses registry and manifest YAML, resolves templates, renders conditional content, and compares structured results.
- Preserve v1 identities and bytes by hash. Prove new Drafts select v2 while explicitly bound v1 manifests remain v1.
- Reject duplicate IDs, missing assets, invalid variants, required-section mismatches, hash drift, placeholders, empty conditional sections, copied DoD, duplicated criteria, and generic evidence.
- Prove planned documentation and automated tests allow `IMPLEMENTATION READY`; published documentation and passing mapped tests are required for `IN REVIEW`. A manual demo is not a substitute.
- Exercise schema 2 refusal and schema 3 verify/update paths, forbidden fields, exact preflight drift, omitted-field preservation, ADF normalization, journaling, final readback, and partial failure.
- Extend installer tests so Codex and Claude Code both expose `VERSION`, the registry, every v1/v2 template, and references while uninstall remains narrow.

## Manual coverage

- Draft and review one Epic, Story, Task, design Spike, and investigation Spike. Confirm the output is concise, conditional sections disappear when unused, and each ticket carries only its own completion contract.
- Audit otherwise identical Stories at implementation readiness and review entry. Confirm planned evidence passes the first gate and missing delivered evidence blocks the second.
- In an explicitly authorized isolated Jira project, prove a schema-3 Epic update changes only approved description content, stops on drift, preserves unrelated fields, and does not claim success after a readback mismatch.

Schema-3 authorization, drift refusal, readback, and Story lifecycle gates are critical. Template compatibility, rendering, packaging, and anti-bloat checks are high priority because they protect every future use.
