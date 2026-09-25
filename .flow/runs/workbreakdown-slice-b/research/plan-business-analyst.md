# Business analyst: Slice B acceptance traceability

Role report for Slice B planning. Read-only. The coordinator wrote it from the agent's returned report.

## Per-criterion matrix

| Criterion | Chunk | Observable output | Negative control |
|---|---|---|---|
| AC-R3.1 | C2 | The Draft output states `consolidation.status: run` for a Draft invoked against one Epic | With the opt-out set, the output states `status: skipped`, and the block holds no claims or exceptions |
| AC-R3.2 | C2 | `consolidation.claims[].owner` and `rationale`, with `confirmation.state: proposed` | None. Judged, 2 of 3, on a rationale that is present and not generic |
| AC-R3.3 | C2 (order derivation) and C3 (edge check) | `consolidation.order.source: rank` and its `value`. Recorded exceptions are matched, and an unmatched later-to-earlier edge is a graph-review defect | With no rank: `order.source: unknown`, an empty `value`, and exceptions forbidden |
| AC-R3.4 | C3 | A graph-review finding for FX-COPY-ACCEPT: missing forward edge or misplaced acceptance | None |
| AC-R4.1 | C4 | An Audit finding `check: contradicts-text` for FX-REV-LINKS, with its edge and quoted evidence | None |
| AC-R4.2 | C4 | An Audit finding `check: into-closed` for FX-DONE-LINK | None |
| AC-R4.3 | C4 | An Audit finding `check: text-only-blocker` for FX-TEXT-BLOCKERS | None |
| AC-R4.4 | C4 | An Audit finding `check: status-vs-blockers`, using status category only, plus a `reject_text` pin on status names in the core | The `reject_text` pin |
| AC-R4.5 | C5, with ground truth from C5a | `classification: mechanical` for FX-REV-LINKS and `scope-disagreement` for FX-SCOPE-LINKS, each with `history {author, date}` | With history removed, both are `unknown` |
| AC-B-precision | C4 | No finding for any FX-FORWARD-OK edge | This row is itself a negative control |

C1 targets no criterion directly. It enables the others, because every R3 criterion depends on the `consolidation` schema. Chunk R runs every Slice B criterion and its negative controls together on the frozen fixture.

## Interpretations to record

1. **AC-R3.1, "single-Epic Draft".** The phrase names the invocation target, one Epic, not an isolated read. The Draft still reads its siblings.
2. **AC-R3.3, "order taken from rank".** The case exercises the rank branch because no declared order is present. It is not evidence against the order of precedence: declared, then rank, then unknown.
3. **AC-R3.4, "missing forward edge or misplaced acceptance".** The check emits one of the two finding shapes, and the release check accepts either one.
4. **AC-R4.4, "no project status names in the core".** The core skill prose and logic never branch on a status name, and the `reject_text` pin covers that prose. Quoted `evidence` is untrusted ticket text and may contain raw status names.
5. **"Reported", for Audit.** A finding is reported when it is an entry in the findings block with `check`, `edge` or `ref`, and `evidence`. The release check matches each finding's ref and check against an expected set, not against prose.
6. **AC-R3.2, confirmation.** The fixture exercises only `proposed`, because no lead takes part in a gate run. The `confirmed` state is covered by C1's synthetic tests only.

## Constraints to restate

- No estimate or ticket-count mode.
- No change to `Blocks` semantics, Apply, or Story evidence rules.
- No new Jira write path. Claims and exceptions are annotations only, and Apply writes only the edges in `dependencies`.
- No project-specific names or statuses in the skill core.
- One VERSION bump (1.6.0) and a migration note, both in chunk R.
- The fixture and the release-check scripts stay outside this repository. The public tests use synthetic fixtures only.
- Jira text is untrusted data.
- The opt-out comes only from the request. It is never a default and never reused from a sibling.
