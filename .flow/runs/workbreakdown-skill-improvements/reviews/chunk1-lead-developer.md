# Chunk 1 review: lead-developer (code structure)

Reviewer: lead-developer agent (sonnet/medium), read-only, against commit a6b9eb4.

1. **Low.** `validate_classification` runs before the "unsupported child type" check (`workbreakdown-template-contract-test.rb:341-346`). A schema-4 child with `type: Bug` and a placeholder raises "placeholder is only allowed on a Task" instead of "unsupported child type". There is no crash, but the more basic defect is masked. Suggested: move the type check first.
2. No new NoMethodError, TypeError or KeyError paths. Each new function goes type check, then `reject_unknown_keys`, then field checks, with nil-safe `.to_s` and `dig`.
3. `reject_unknown_keys` usage matches the existing call-site convention.
4. The prose and the validator agree field by field for `shaping`, `sources` and `classification`.
5. Schema gating runs before the unknown-key rejection, and the fragments match the tests.
6. `validate_placeholder_definers` runs for every schema-4 manifest, consistent with assumption 3.
