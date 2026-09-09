# Acceptance Criteria

- New drafts use an immutable `jira-story-v3` contract; the existing `jira-story-v2` asset and hash remain unchanged.
- Story v3 requires a plan or a complete approved exception for documentation, automated tests, and instrumentation, never both for the same class.
- Automated tests map stable scenario IDs exactly once and accept only `integration` or `functional` levels.
- Instrumentation uses unique stable IDs and names a precise signal, its class, purpose, implementation target, and expected observation.
- Instrumentation may use the smallest meaningful mix of operational and business signals. Neither class is mandatory when the other is sufficient.
- `IN REVIEW` evidence maps exactly to planned document, scenario, and signal IDs.
- Instrumentation review evidence contains implementation evidence, observed output, retained evidence, and a named representative environment.
- Documentation review evidence proves the artifact was published, updated, or reviewed and confirmed current.
- Generic claims such as `tests added`, `metrics added`, and `docs reviewed` are rejected.
- Review and Audit apply the current lifecycle gate to legacy Stories without rewriting or invalidating their approved manifests.
- Both Codex and Claude installations expose the new template and current skill version.
