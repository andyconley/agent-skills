# Validation Plan

## Automated

- Run skill, prose, registry, manifest, fixture, installer, and shell checks.
- Prove template set 3 resolves Story v3 while set 2 continues to resolve the unchanged Story v2 hash.
- Reject cross-set Story bindings and incompatible templates.
- Reject unit-only and manual-only automation evidence.
- Reject missing, duplicate, extra, or unmapped scenario, signal, and document IDs.
- Reject instrumentation without implementation evidence, observed output, retained evidence, or a named review environment.
- Reject generic evidence and incomplete exceptions.
- Prove existing v1/v2 fixtures still validate unchanged.

## Mutation check

Break one instrumentation review requirement, confirm its targeted test fails, restore it, and rerun the suite.

## Manual

- Draft a concise Story using one meaningful operational signal.
- Confirm an approved exception replaces only its named evidence class.
- Confirm a representative non-production environment is accepted.
- Confirm a legacy Story is not reformatted but cannot enter `IN REVIEW` without current evidence.

## Distribution

Verify the repository package and both Codex and Claude links expose the new asset and version.
