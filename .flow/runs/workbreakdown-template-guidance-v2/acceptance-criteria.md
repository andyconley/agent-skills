# Workbreakdown Template Guidance v2 Acceptance Criteria

- [ ] New Drafts use v2 templates; manifests explicitly bound to v1 remain valid and render from unchanged v1 assets.
- [ ] V2 descriptions omit irrelevant optional sections and contain no empty headings, boilerplate `N/A`, unresolved placeholders, or repeated facts.
- [ ] Review flags content that is vague, trivial, redundant, non-actionable, or unsupported by known evidence.
- [ ] Epic success criteria describe measurable outcomes. Epic acceptance criteria contain 3–5 independently verifiable milestone conditions and do not defer to success criteria.
- [ ] The new manifest schema supports explicit Epic `verify` and `changes` payloads, including template-bound description content.
- [ ] Apply changes only approved Epic fields, preserves omitted Epic fields, stops on material drift, and proves the final Epic state through readback.
- [ ] Every proposed Story names its applicable user, operator, support, API, or other documentation target, audience, owner when known, and intended location.
- [ ] Every proposed Story maps its acceptance scenarios to automated integration or functional tests, including the intended suite or location, environment, and evidence.
- [ ] A Story can be `IMPLEMENTATION READY` with planned documentation and automated-test work that does not yet exist or pass.
- [ ] Review or Audit flags a Story entering `IN REVIEW` unless the contextual documentation is published or updated and the mapped automated integration or functional tests pass in the named environment.
- [ ] Documentation and automated-test exceptions require explicit review and approval. Manual demonstration is not an automated-test substitute.
- [ ] Task v2 separates its artifact-specific acceptance conditions from a referenced ticket-level Definition-of-Done profile.
- [ ] Design-Spike v2 requires a bounded decision, material questions and constraints, named design/evidence artifact, reviewers, applicable checklist coverage, closure conditions, and downstream updates without reproducing the design document in Jira.
- [ ] Investigation and feasibility Spikes are not forced through the design-Spike template.
- [ ] Apply remains bound to the exact approved manifest and cannot add template content after approval.
- [ ] The distributed package contains no internal Jira keys, internal Confluence links, credentials, or required host integration.
- [ ] Automated skill, contract, installer, lint, and format checks pass.
