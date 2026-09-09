# Implementation Handoff

## Outcome

Story completion is now operationally provable without invalidating approved manifests.

New Story drafts use immutable `jira-story-v3`. Existing `jira-story-v2` bytes and SHA-256 binding remain unchanged. The workbreakdown skill version is `1.4.0`.

## Shipped behavior

Before `IN REVIEW`, every Story must provide evidence or one complete approved exception for each class:

- Automated integration or functional tests mapped to stable scenario IDs. Unit and manual tests do not qualify.
- The smallest instrumentation set that proves the Story outcome or an operational decision.
- Documentation appropriate to the Story, either published, updated, or reviewed and confirmed current.

At review time, instrumentation evidence includes implementation evidence, observed output, retained evidence, and a named representative environment. Exceptions are re-confirmed against the original obligation and approval evidence.

Review and Audit apply the gate to legacy Stories without rewriting their descriptions or invalidating approved manifests. Legacy evidence binds to the exact Story, template, and scenario text.

## Proof

Passed:

- Workbreakdown contract suite
- Skill validation
- Prose lint
- Installer checks: 17 of 17
- `git diff --check`
- Targeted mutation test proving missing instrumentation output fails validation
- Independent quality review after correcting exception confirmation and legacy evidence binding

Both local runtime links resolve to this repository and report workbreakdown `1.4.0`.

## Limitations

- Fresh interactive Codex and Claude prompts were not run.
- No live Jira mutation was needed or performed.
- Organization-specific rules for authorized exception approvers remain outside this portable skill.

## Next actions

Run the documented Codex and Claude smoke prompts. A controlled live Jira validation remains optional and requires separate authorization.
