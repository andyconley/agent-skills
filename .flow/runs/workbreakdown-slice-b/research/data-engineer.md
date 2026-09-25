# Data engineer: the consolidation block's shape

Role report for Slice B solutioning. Read-only. Line references are to the skill and validator at release 1.5.0.

## Recommendation: one `consolidation` block, following the `sources` pattern

**Precedent.** The schema-4 root already allows one optional key, `sources` (manifest-contract.md:290-373), which groups three unrelated concerns: `jira_context`, `existing_children` and `conflicts`. It relies on `reject_unknown_keys` (manifest-validator.rb:32,276). A new `consolidation` key with three closed sub-keys, `claims`, `order` and `exceptions`, fits that shape better than three new root keys.

### Option A: a single `consolidation` block (recommended)

```yaml
consolidation:
  claims:
    - claim: "State reads use the cached projection."
      claimed_by: [EPIC-201, EPIC-202]
      owner: EPIC-201
      confirmation: {state: confirmed, evidence: "Lead sign-off, 2026-09-20"}
  order:
    value: [EPIC-200, EPIC-201, EPIC-202]
    source: rank
  exceptions:
    - edge: {earlier: EPIC-202, later: EPIC-201}
      reason: "Hardware lead time forces EPIC-202 first."
      approver: "Program lead"
      approval_evidence: "Confluence decision log, 2026-09-18"
```

**Tradeoff.** There is one closed shape to review, but three different life cycles share a key. Ownership rarely changes once it is confirmed, while order and exceptions are derived again on every Draft run. `reject_unknown_keys` still isolates each sub-shape, so the cost is cosmetic, not a validation gap.

### Option B: split into `consolidation` (claims) and `milestone_order` (order and exceptions)

This separates who owns a decision, which is long-lived and confirmed by the lead, from how milestones are sequenced, which is recomputed on each Draft. It gives cleaner diffs on a new Draft. The cost is a second `SCHEMA4_ROOT_KEYS` entry and a second acceptance surface. The contract states the schema-4 root as "the root fields, plus optional shaping and sources" (manifest-contract.md:22), which sets a precedent of exactly two optional keys.

**Recommend Option A.** It keeps three optional keys on the schema-4 root instead of four, and it follows the `sources` precedent exactly. The brief also asks for one new optional schema-4 block.

## Invariants a validator enforces

- `claims[].claim` is nonempty, mirroring the `conflicts` claim check (manifest-validator.rb:296).
- `claimed_by` lists at least two distinct Epics in `JIRA_KEY` format (manifest-validator.rb:35, 298, 305 pattern).
- `owner` is one of `claimed_by`, mirroring the check that `winner` is in `sources` (manifest-validator.rb:306).
- `confirmation.state` is exactly `proposed` or `confirmed`. `evidence` is required when `confirmed` and forbidden otherwise. This mirrors the Story exception shape (manifest-contract.md:432) and the `approved_exceptions` check (manifest-validator.rb:589-594).
- `order.value`:
  - holds unique `JIRA_KEY`s
  - `order.source` is one of `rank`, `declared` or `unknown`
  - `value` is empty when `source` is `unknown`, mirroring the rule that omits `reviewers` when unknown (manifest-contract.md:359)
  - `scope.epic_key` appears in `value` whenever `source` is not `unknown`
- `exceptions[].edge`:
  - `earlier` and `later` are distinct, valid Jira keys
  - the pair matches either a `dependencies` entry with `scope.epic_key` at one end (manifest-contract.md:442-451), or an external edge between two Jira keys, neither of them a manifest-owned child of `scope.epic_key`
  - there is no third source of edge authority, which keeps the rule of no new Jira write path
- `reason`, `approver` and `approval_evidence` are nonempty text, the same shape as the existing exception fields.

## Interaction with existing blocks

- **`sources.conflicts`.** No duplication. `sources.conflicts` records disagreement about a fact, while `consolidation.claims` records agreement about who owns a decision. The two concerns are separate and share no field.
- **`rank.order`.** `consolidation.order` is scoped to the Initiative and holds Epic keys. `rank.order` holds children and is local to one Epic (manifest-contract.md:454-458), so the two never overlap. A validator should reject an Epic key that matches a declared child `ref`.
- **`dependencies`.** `consolidation.exceptions` refers to `dependencies` and never adds authority to change edges. Apply still writes only the edges named there.
- **`breakdown_conventions`.** Left untouched. It holds per-Epic shaping defaults and is exempt from Review and Audit flags (manifest-validator.rb:507). `consolidation` decisions span Epics and can always be flagged, so they stay out of that panel.

## Compatibility

The block fits schema 4 as it stands, and no schema 5 is needed. The changes:
- Add `consolidation` to `SCHEMA4_ROOT_KEYS` (manifest-validator.rb:22).
- Add it to the schema-2/3 rejection loop (manifest-validator.rb:466-469) and the contract text (manifest-contract.md:257).

All three sub-keys are optional. A schema-4 manifest without `consolidation` stays valid, matching the contract's rule that a manifest without the block is valid (manifest-contract.md:257).

## Error fragments (style-matched)

- `consolidation claim requires at least two claiming Epics`
- `consolidation owner is not a claiming Epic`
- `invalid consolidation confirmation state`
- `consolidation confirmation requires evidence`
- `consolidation order must list unique Jira keys`
- `consolidation order value forbidden when source is unknown`
- `scoped Epic missing from a known consolidation order`
- `consolidation exception edge must name two distinct Epics`
- `consolidation exception does not match a declared or external edge`
