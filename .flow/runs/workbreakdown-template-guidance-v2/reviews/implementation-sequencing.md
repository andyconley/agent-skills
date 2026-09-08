# Implementation Sequencing Review

## Observed facts

- The skill is 1.1.0; the registry is schema 1 / template-set version 1.
- Existing `jira-*-v1` IDs point to unversioned template files.
- Current guidance requires empty sections to be filled with `None` or `N/A`.
- Schema 2 contains Epic outcome metadata but no Epic mutation authority.
- Existing contract tests are text-presence based.
- The installer links the whole skill directory to both supported hosts.

## Recommended slices

1. Freeze the existing templates as byte-identical v1 assets and establish parsed registry checks.
2. Add concise v2 assets, shared quality rules, lifecycle guidance, and rendering fixtures.
3. Add schema 3 as an explicit Epic-mutation boundary with drift, preservation, journal, and readback checks.
4. Update distribution assertions, manuals, public documentation, and per-skill version metadata.

## Coupling hazards

- Rename v1 assets and update registry references together.
- Keep schema 3 parser, manifest contract, Apply protocol, and tests identical in allowed scope.
- Ignore only regenerated ADF `localId` values during normalization.
- Treat lifecycle labels as Review/Audit judgments, never status-transition authority.
- Keep live Jira checks optional and explicitly authorized.

The repository already has a repo-wide `v1.2.0` release. Repository and per-skill versions are independent, so this implementation keeps the approved `workbreakdown` 1.2.0 target.
