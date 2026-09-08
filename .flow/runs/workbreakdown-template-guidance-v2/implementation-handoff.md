# Workbreakdown Template Guidance v2 Implementation Handoff

## Objective

Implement the accepted v2 template and schema-3 Epic update plan without relying on this chat.

## Canonical artifacts

- Requirements: `.flow/runs/workbreakdown-template-guidance-v2/requirements.md`
- Acceptance: `.flow/runs/workbreakdown-template-guidance-v2/acceptance-criteria.md`
- Solution: `.flow/runs/workbreakdown-template-guidance-v2/solution.md`
- Plan: `.flow/runs/workbreakdown-template-guidance-v2/plan.md`
- Validation: `.flow/runs/workbreakdown-template-guidance-v2/validation-plan.md`
- Role reviews: `.flow/runs/workbreakdown-template-guidance-v2/reviews/`

## Required order

1. Capture exact hashes of the current template assets and preserve their content as v1 files.
2. Build the version-aware registry and v2 assets.
3. Add population and Definition-of-Done guidance.
4. Update the SOP, manifest schema, Epic mutation protocol, and skill routing.
5. Extend automated and manual tests.
6. Update public documentation and version metadata.
7. Run the complete validation plan.
8. Review the final diff for bloat, compatibility, mutation scope, and internal identifiers.
9. Install locally only after validation. Commit and publish only when the user requests it or the implementation request includes publication.

## Non-negotiable behavior

- New Drafts default to v2; v1-bound manifests remain reproducible.
- Schema 2 stays child-only. Schema 3 alone can authorize a scoped Epic update.
- Epic updates are exact, field-scoped, drift-checked, journaled, and verified.
- Story documentation and automated-test plans are present at implementation readiness; completed evidence gates review entry.
- Irrelevant sections disappear. Generic process language does not enter rendered tickets.
- Jira status changes remain outside Apply authority.
- Internal source material does not enter the public repository.

## Required handback

- Files changed and template/hash mapping
- Schema and compatibility behavior
- Automated and manual validation results
- Local install/version status
- Git and release status
- Deviations, unresolved risks, and follow-up work
