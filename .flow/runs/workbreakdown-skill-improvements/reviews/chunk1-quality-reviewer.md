# Chunk 1 review: quality-reviewer (acceptance)

Reviewer: quality-reviewer agent (opus/medium), read-only (no shell), against commit a6b9eb4. **Verdict: ready with fixes.**

All in-scope items are delivered, and nothing out of scope was added. The SKILL.md change from "Only schema 3" to "Only schema 3 or 4", and the added Identity and Closed-shapes bullets, were judged justified correctness fixes, not scope creep.

| # | Finding | Disposition |
| --- | --- | --- |
| 1 | The schema-4 example used a ``` fence; the file uses `~~~` | Fixed in 7b58289 |
| 2 | The abridged example would not validate if copied | Fixed: one sentence says it is abridged |
| 3 | "precedent contains searched, verdict, and location" read as three required keys | Fixed: "may contain location" |
| 4 | `source_order` values are not "names" | Fixed: split into reviewer names and source kinds |
| 5 | "Use schema version 3 only when…" had a leftover "only" | Fixed: "3 or 4" |
| 6 | Example keys differed from the file's INIT-100/EPIC-200 style | Fixed in the prose example; fixtures keep INIT-1 like the other fixtures |
| 7 | "schema 3 requires an Epic-compatible template set" also fires for schema 4 | Deferred to chunk 5, which touches the Epic path |
| R | **Residual risk:** with schema 4 as the Draft default, every Draft needs a live Epic ADF digest, including child-only breakdowns | Carried to chunk 2 planning |

**Also, from the lead-developer review:** a classification was checked before the child type. Fixed in 7b58289, scoped to classified children so that schema 2 and 3 error precedence stays unchanged, with a new test (`unsupported_classified`).

The reviewer's unverified claims (fixtures unchanged, CHANGELOG untouched) were closed with git in `validation-results.md`.
