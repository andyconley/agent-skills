# Implementation Test Review

## Test approach

Keep the fast shell smoke checks. Add a parser-backed fixture harness that validates registry identity and hashes, resolves template versions and variants, checks manifest authority, renders conditional content, evaluates lifecycle rules, and normalizes ADF for comparison.

## Required coverage

- Preserve every v1 template byte and identity. Explicit v1 manifests never migrate.
- Default new Drafts to v2 and select design versus investigation Spike variants explicitly.
- Reject registry duplicates, missing assets, bad variants, and hash drift.
- Omit empty conditional sections and reject placeholders, generic evidence, copied DoD, repeated facts, and success/acceptance duplication.
- Allow planned Story documentation/tests at `IMPLEMENTATION READY`; require published docs and passing mapped tests at `IN REVIEW`.
- Reject unapproved exceptions and manual-demo substitution.
- Reject all schema-2 Epic writes. Require explicit schema-3 Epic disposition, template binding, current ADF digest, allowlisted fields, and complete content.
- Prove preflight drift produces zero writes, omitted fields remain unchanged, normalized readback matches, and partial failures stop dependent work.
- Prove both host links expose `VERSION`, the registry, all v1/v2 assets, and references.

Schema-3 authorization, drift, readback, and Story lifecycle gates are release blockers. Template compatibility, rendering, packaging, and anti-bloat behavior are high priority.
