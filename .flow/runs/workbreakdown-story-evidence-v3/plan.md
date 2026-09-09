# Implementation Plan

## Outcome

Make Story completion operationally provable while keeping tickets concise and preserving approved manifests.

## Scope

### In scope

- Add template set 3 and `jira-story-v3`.
- Add explicit compatibility metadata for unchanged v2 Epic, Task, and Spike templates.
- Define instrumentation plans, review evidence, and approved exceptions.
- Extend the `IN REVIEW` gate across Draft, Review, and Audit guidance.
- Add parsed fixtures and negative contract tests.
- Update skill metadata, portable packaging documentation, and installer checks.

### Out of scope

- Changing v1 or v2 template bytes or approved manifest bindings.
- Automatic Story migration or Jira status transitions.
- New Jira fields, subtasks, production-only evidence, mandatory dashboards, or mandatory SLOs.
- Requiring both an operational signal and a business metric.
- Requiring every documentation type.
- Defining organization-specific exception approvers.

## Change sequence

1. Freeze compatibility with hash assertions for Story v2.
2. Extend the registry with set 3 and compatible-set metadata.
3. Add Story v3 and its manifest/rendering contract.
4. Extend lifecycle and Jira audit rules.
5. Rename the version-specific contract harness and add positive and negative fixtures.
6. Update version and distribution documentation.
7. Run automated checks, a targeted mutation check, and independent review.

## Contract decisions

- Planning may omit an instrumentation environment when it is unknown and record the gap in `unknowns`.
- Review evidence must name a representative environment; no environment name is prescribed.
- A signal plan requires a stable ID, `operational` or `business` class, precise signal, purpose, implementation target, and expected observation.
- Review evidence requires the planned signal ID, environment, implementation evidence, observed output, and retained evidence.
- Documentation evidence uses `published`, `updated`, or `confirmed_current`. Confirmation must identify the reviewer and applicable revision or review record.
- Existing manifests continue to validate against their selected template set and exact template identity.
