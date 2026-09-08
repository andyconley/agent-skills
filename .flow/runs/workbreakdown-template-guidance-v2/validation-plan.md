# Workbreakdown Template Guidance v2 Validation Plan

## Automated checks

Run:

```bash
bash -n install.sh scripts/*.sh tests/*.sh
./scripts/validate-skills.sh
./tests/workbreakdown-contract-test.sh
./tests/install-test.sh
./scripts/lint-prose.sh
python3 /Users/andyconley/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/workbreakdown
git diff --check
```

Extend `workbreakdown-contract-test.sh` to prove:

- v1 template files and identities remain present and match recorded hashes
- registry version 2 defaults select v2 templates
- design and investigation Spike variants resolve correctly
- v2 required and conditional keys are declared
- schema 2 contains no Epic mutation authority
- schema 3 supports Epic verify-only and update dispositions
- incomplete, unbound, drifted, or forbidden Epic payloads fail closed
- Apply instructions require Epic preflight, mutation journal, normalized ADF readback, omitted-field comparison, and accurate counts
- Story descriptions require contextual documentation and automated integration or functional-test mappings
- lifecycle rules gate `IN REVIEW`, not `IMPLEMENTATION READY`

Add a small validator and fixture harness so these checks parse YAML, resolve registry entries, render templates, and compare structured results. Text-presence checks alone do not prove the contracts. Include positive and negative fixtures for:

- immutable v1 bindings and v2 default selection
- duplicate IDs, missing files, invalid variants, undeclared sections, and hash drift
- omitted conditional sections, placeholders, generic evidence, copied DoD, and duplicated criteria
- Story readiness plans, review evidence, and explicit approved exceptions
- schema-2 refusal, schema-3 verify/update paths, forbidden fields, preflight drift, omitted-field preservation, normalized ADF comparison, and partial failure
- Codex and Claude Code installations exposing `VERSION`, the registry, all v1/v2 templates, and references

## Manual behavior checks

Use fresh Codex and Claude Code sessions.

1. Draft a mixed Epic breakdown. Confirm descriptions contain only meaningful sections and no filler, placeholders, duplicated criteria, or empty headings.
2. Draft an Epic with business metrics. Confirm acceptance criteria remain binary and do not repeat the metrics.
3. Draft a Story. Confirm it names contextual documentation and maps automated integration or functional tests to scenarios.
4. Review a Story that has planned documentation/tests but no completed evidence and is entering implementation. Confirm it can be `IMPLEMENTATION READY`.
5. Review the same Story entering `IN REVIEW`. Confirm missing published documentation or passing mapped tests is a blocking finding.
6. Review a manual-demo-only Story. Confirm the demo is supplementary and the automated-test gap remains.
7. Draft a Task. Confirm its acceptance conditions name the artifact/result and its DoD references a profile without copying the checklist.
8. Draft design and investigation Spikes. Confirm each uses the correct variant and the design Spike links rather than reproduces its design artifact.
9. Apply a controlled schema-3 manifest in an isolated Jira test project. Confirm Epic drift stops all writes and a valid update preserves omitted fields.
10. Force an ADF mismatch and a partial failure. Confirm the run reports actual state and never claims success or attempts destructive compensation.

## Documentation and privacy review

- Search changed distributed files for internal Jira keys, internal Confluence URLs, customer data, credentials, and company-specific identifiers.
- Confirm public docs describe behavior without copying internal policy language.
- Confirm version `1.2.0` is consistent across metadata, skill body, `VERSION`, and manual tests.
- Confirm the generated changelog is not edited before release automation runs.

## Acceptance evidence

Record commands, results, manual-case dispositions, changed files, remaining limitations, install status, and release status in the implementation handback.
