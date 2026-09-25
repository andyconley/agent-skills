# Product manager: Slice B scope and sequencing

Role report for Slice B planning. Read-only. The coordinator wrote it from the agent's returned report.

## Scope

**In scope:**
- **C1.** The optional schema-4 `consolidation` block, its validator invariants and synthetic tests.
- **C2.** The Draft consolidation step:
  - the sibling full-children read
  - the request-only opt-out
  - owner proposals, which stay `proposed` until confirmed
  - milestone order: declared, then rank, then unknown
- **C3.** Graph review: later-to-earlier edge detection, exception matching and copied-acceptance placement.
- **C4.** The Audit semantic findings item, the wider read scope, and four checks without classification (R4.1 to R4.4).
- **C5a.** The link-classification answer key, drafted from the frozen fixture's changelogs and ratified by the maintainer.
- **C5.** The classification rule and its negative control.
- **R.** The 1.6.0 bump, the migration note, the private release-check cases, the gate run, and a rerun of the Slice A Drafts.

**Out of scope:**
- **Jira writes of any kind.** Everything is GET-only.
- **Any change to `Blocks` semantics.** Exceptions annotate edges and never add, remove or reverse a link, and Apply writes only the edges named in `dependencies`.
- **Template changes,** and so any template hash churn.
- **The R1.3 stale-design follow-up.**
- **Project vocabulary in the skill core.**
- **Estimates or ticket-count behavior.**
- **Reruns of the Slice A Reviews and the no-Jira control.**
- **Auto-fix behavior in any check.** Findings are reported, never fixed.

## Step order

1. **Step 0: a GET-only fixture refresh to `gate-b`,** before any skill change. Confirm that every Slice B fixture case exists in the new snapshot before writing a release-check case against it. This is the point to raise a missing case, never substitute one.
2. **C1, C2, C3 and C4 in order.** C3 and C4 both depend only on C2, but keep the sequence.
3. **C5a, a hard maintainer checkpoint.** No classification rule prose is written before the key is ratified.
4. **C5,** written against the ratified key.
5. **R, last.** Write each release-check case after its skill chunk lands. The VERSION bump, the migration note and the gate run are the final actions.

## Stop points: return to the maintainer

- A Slice B fixture case is missing from `gate-b`.
- The C5a answer key is ready for ratification.
- A judged check hovers near the 2-of-3 threshold. Flag it as a risk; don't iterate silently.
- A contract conflict appears:
  - the claims overlap `sources.conflicts`
  - an exception implies a write to a live edge
  - schema 2 or 3 accepts the new block
- Private data appears in a public diff.

## Done

The run is done when all of these hold:
- C1 to C5 are committed, and VERSION is 1.6.0.
- The migration note is written.
- Every Slice B criterion and its negative control passes the private gate, and so do the Slice A Draft reruns.
- The checker self-test is extended and green.
- The public-safety grep is clean.

**Deferred:** the push and PR (the maintainer decides), R1.3 hardening, and any refinement of the classification rule beyond the ratified key.

## Scope-creep risks

- **The sibling read is the highest risk.** Watch that it never reaches grandchildren and never adds caching or pagination logic. An unread sibling is recorded as a gap.
- **The copied-acceptance check could drift into auto-fix.** It must only report.
