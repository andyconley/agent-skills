# Acceptance Criteria

- `workbreakdown` is declared in `skills/manifest.tsv`, reports version `1.0.0`, and passes repository and Codex skill validation.
- Fresh Codex and Claude Code sessions discover the same skill instructions and version.
- The concise entrypoint routes to complete canonical references without dropping any supplied hierarchy, classification, dependency, sizing, Story acceptance, refinement, or Jira verification rule.
- Every Draft response includes a valid schema-versioned YAML manifest.
- Review and Audit never authorize or perform Jira writes.
- Apply refuses to write without both a complete approved manifest and a direct request to apply it.
- Apply stops before the first write when Jira capabilities or live mappings are insufficient or live drift would change the approved plan.
- Jira changes affect only authorized Epic children, fields, ranks, and `Blocks` links.
- Dependency direction is verified against a known-good live link before bulk changes.
- Final Jira readback must match the approved manifest; an API success response alone does not pass.
- Apply reports the reference-to-key mapping and created, updated, unchanged, failed, restored, untouched, and verified counts.
- Installer coverage proves selected install and uninstall for both Codex and Claude targets.
- Manual behavior tests cover all four modes, graph defects, unavailable Jira access, live drift, and post-write mismatch.
- Vale and repository checks pass.
