# Planning input: business-analyst (sonnet/medium, read-only)

The business-analyst mapped every Slice A acceptance criterion to its chunk, its synthetic proof and its live assertion. The mapping itself is consolidated into `plan.md`. The analyst flagged the criteria below; each carries the coordinator's proposed resolution, which is pending the maintainer.

| AC | Flag | Proposed resolution |
| --- | --- | --- |
| R1.4 | The schema-2 fallback has no `sources` block, so there is nowhere structured to mark design claims as unverified. | Schema 2 already has `unknowns`, a list of strings. Define a Draft convention: each unverified design claim becomes an `unknowns` entry prefixed `Unverified design claim:`. The script can assert on the prefix, and no schema change is needed. |
| R2.5 | A component Story finding has no structured representation. | Add a machine-readable findings block to the Review output contract. This is Review output, not the manifest, so schema 4 is not reopened. Each finding carries `category` (for example `component-story`), `ref` and `correction`. |
| R0.3 | "Reports divergence" has no field. | The Draft output gains a divergence list: entry, sibling Epic, sibling value, proposed value. The manifest assertion uses `source: reused` and `from_epic`. |
| R2.7 | It is ambiguous whether reviewers are set per Spike or once globally. | They are per Spike. The v3 Spike templates carry a `reviewers` description key. `shaping.reviewers` is the default pool the Draft draws from. Both are asserted. |
| R2.3 | No field gives flow identity, so the script cannot count flows. | The script asserts that no front-end-only Spike like the FX-FE-SPLIT case appears, using type, variant and summary. One-Spike-per-flow stays a judged check with a documented tolerance. |
| R2.4 / R2.8 / R5 | These criteria are behavioral or rest on the text of the skill's own files. | Assert them with the existing public suites and with grep on the SOP text, not through the live-agent script. |
