# Architecture Review

- Make the registry template-centric, with explicit defaults, issue types, variants, required keys, conditional keys, and hashes.
- Freeze v1 template files and IDs. Add v2 Epic, Story, Task, design-Spike, and investigation-Spike templates.
- Use `template_set.version: 2` for new Drafts. Never migrate an approved v1 manifest silently.
- Keep DoD in a shared profile reference with ticket-specific additions and exceptions.
- Model Story documentation and automated tests as structured planned evidence at implementation readiness and observed evidence at review readiness.
- Do not copy the technical design into Jira. A design Spike names the design artifact, reviewers, checklist coverage, decision evidence, risks, and downstream changes.
- The user expanded this slice to include exact Epic description updates. Add manifest schema 3 for that authority while keeping schema 2 valid and child-only.
- In schema 3, require `epic.disposition` to be `existing` or `update`. Bind updates to the scoped Epic, registered template and hash, complete approved content, and expected-current ADF digest.
- Limit Epic writes to explicitly allowlisted description content. Preflight before any write, journal the delta, normalize only regenerated `localId` values during readback, and prove omitted fields were preserved.
- Keep status, sprint, project, issue type, rank, security, reporter, creation, deletion, and reparenting outside the Apply boundary.
