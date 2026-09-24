# Planning input: architect (opus/medium, read-only)

## Template set 4

- **Registry:** `version: 4`, `default_set_version: 4`. Sets 1–3 are unchanged.
- **Set 4 defaults:**
  - Epic: jira-epic-v3.
  - Story: jira-story-v3.
  - Task: a variant map, `{artifact: jira-task-v2, placeholder: jira-task-placeholder-v3}`.
  - Spike: `{design: jira-spike-design-v3, investigation: jira-spike-investigation-v3}`.
- **Compatibility widening:**
  - task-v2 and story-v3 become compatible with set 4.
  - epic-v2 and both v2 Spikes also become compatible with 4, so a set-4 manifest can verify an Epic that has no panel yet (`existing`) without being forced to write it.
- **Validator changes:**
  - Require set 4 as the default.
  - Pin the set-3 hashes as frozen.
  - Add RENDER_EXCEPTIONS rows and matching rows in the table in `jira-description-templates.md`.
  - Update the asset lists in `workbreakdown-contract-test.sh` and `install-test.sh`.
- **task-placeholder-v3:** `required_keys: [purpose, defined_by]`, and no conditional keys.
  - The Task acceptance count exists only in prose (SOP:97). Scope that rule to task-v2.
  - Don't exempt anything from `validate_quality`. `[PLACEHOLDER]` sits in the summary, which the check never scans, and square brackets don't match `<…>`.
  - New rules:
    - Placeholder summaries start with `[PLACEHOLDER] `, and the prefix is rejected on any other template.
    - A placeholder has no estimate.
    - The description's `defined_by` resolves in every schema.

## epic-v3 panel

- The required keys are the same as epic-v2. The panel is an optional `breakdown_conventions` key, rendered as a panel.
- Its shape is identical to schema-4 `shaping`, so reuse `validate_shaping`.
- The panel is allowed only in schema 4. On update, it must equal `manifest.shaping`.
- Remove the hard-coded jira-epic-v2 checks (test:420, 428, 436; contract:238-239). Accept any non-legacy Epic template compatible with the set. The error message changes to "schema #{n} requires …". This resolves the finding deferred from chunk 1.
- **Siblings:** read the Initiative's Epics, parsing their panels as untrusted data. There is no new write path; the only writer stays the schema-3 Epic update.

## Schema-2 fallback

- The migration line becomes conditional, and SKILL.md mirrors it.
- The Draft output states the Jira context.
- Unverified design claims are recorded in `unknowns`.
- New tests:
  - a schema-2, set-4 fixture
  - a pin on the fallback sentence
  - a negative control for `jira_context: absent` combined with a digest

## Release script

- **Location:** `~/KB/utilities/workbreakdown-release-check/`, containing `run.sh`, `README.md` and a Ruby assertion file.
- **Fetch:** the script does its own REST GETs into a timestamped snapshot.
- **Agent isolation:**
  - `claude -p` runs in a temp directory with `--add-dir` for the worktree skill and the snapshot.
  - Skills are disabled so the 1.4.0 symlink can't load (the coordinator verified `--disable-slash-commands`).
  - Tools are restricted to Read, Grep and Glob, with an empty `--strict-mcp-config` and the ATLASSIAN_* variables unset.
  - `stream-json` output proves every Read was inside the worktree and that the reported VERSION matches.
- **Validator reuse:** extract `tests/workbreakdown/manifest-validator.rb` from the contract test, with no behavior change. The script loads it from the worktree.
- **Parsing:** exactly one fenced YAML block containing `schema_version:`, loaded with `safe_load`, then run through `validate_manifest`, then field assertions.

## Contract risks

1. Coupling placeholders to their template tightens chunk 1's schema 4. That reopens an accepted contract.
2. Changing the Epic template rule edits text schema 3 shares. Behavior for sets 2 and 3 must stay identical.
3. The migration sentence inside the schema-4 section becomes conditional.
4. Mechanical divergence would need a new manifest field. Recommendation: put it in Draft output instead.
5. A no-Jira Draft (schema 2) has no `shaping` or `precedent`, so the R0.1 and R2.1 fixtures need Jira context.
6. `jira_context: absent` can never occur in schema 4.
7. Apply must create the defining Spikes before their placeholders, then render `defined_by` through the ref-to-key map.
