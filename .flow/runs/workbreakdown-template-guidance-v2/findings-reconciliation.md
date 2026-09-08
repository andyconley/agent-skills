# Findings Reconciliation

The business, product, architecture, and test reviews agree on v1 preservation, v2 defaults, conditional rendering, Story documentation and automated-test evidence, and the `IMPLEMENTATION READY` versus `IN REVIEW` distinction.

Accepted for shaping:

- Keep manifest schema 2 and evolve templates through `template_set.version`.
- Add separate design and investigation Spike variants.
- Reference shared DoD profiles; do not repeat generic checklists in tickets.
- Treat lifecycle rules as Review and Audit judgments, not Jira status mutation authority.
- Keep internal Confluence sources and Jira identifiers out of the public package.
- Replace text-presence-only checks with parsed fixtures and behavior assertions for registry selection, rendering, lifecycle gates, and manifest safety.
- Extend installer coverage to prove both host links expose every v1 and v2 bundled asset.

User decision after architecture review:

- Include Epic mutation authority. Advance the manifest to schema 3 and require explicit Epic disposition, field-level changes, template binding, preflight, journaling, and final readback.

Implementation review dispositions:

- Grandfathered authentic schema-2/template-set-1 manifests without adding a per-template hash. Registry hashes keep v1 assets immutable.
- Added closed shapes, template-set membership, child type/reference/disposition validation, full schema-3 verify semantics, and canonical ADF hashing.
- Defined preservation as observable mutable business fields and excluded server-managed metadata.
- Removed the forced Story owner cell; added explicit exception render locations and one-of validation.
- Added stable scenario and documentation IDs with exact plan-to-review evidence and environment matching.
- Expanded negative coverage for version mixing, unknown fields, unbound descriptions, missing evidence, placeholders, generic evidence, drift, preservation, and partial failure.

Quality and architecture re-reviews passed with no remaining actionable finding.
