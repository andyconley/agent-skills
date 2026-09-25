# Workbreakdown Slice B Handoff

## What shipped: skill 1.6.0

Branch: `claude/workbreakdown-slice-b`. It is local only and has not been pushed.

**Cross-Epic consolidation in Draft.** A Draft now checks its Epic against the Initiative's other Epics, even when the request names one Epic.
- It lists each sibling's direct children with one search, and opens a full card only when the card looks like it overlaps this Epic's work or links to its children.
- It proposes one owner for each decision two or more Epics both own, marked `proposed` until the lead confirms it.
- It records milestone order from an order declared in the request, then Initiative rank, and otherwise `unknown`.
- Only the request can opt out, and only by asking explicitly.
- The output opens its consolidation item with a literal label line.

**Schema 4 `consolidation` block.** This block is optional, with a required `status` (`run`, `skipped` or `no-siblings`).
- `claims` records each claim with its claimants, owner, rationale and confirmation.
- `order` records the order and its source.
- `exceptions` records approved later-to-earlier edges. Each one names exactly one edge and both of its Epics.
- The block never changes `Blocks`. Apply still writes only `dependencies`. Schemas 2 and 3 reject the block, and every approved manifest stays valid.

**Graph checks.**
- Each edge between milestone Epics is reported as forward, as a recorded exception, as a defect, or as unordered when milestone order is unknown.
- Copied acceptance that lacks its forward edge is reported as `missing forward edge` or `misplaced acceptance`.
- Review runs the same check on any manifest. It takes exceptions from a `consolidation` block or from a supplied approved decision record.

**Audit semantic link findings.** Audit returns a findings block with five checks: `contradicts-text`, `into-closed`, `later-to-earlier`, `text-only-blocker` and `status-vs-blockers`.
- Status is read by category. The ready statuses come only from the request, and the output says so when they are absent.
- Each link finding carries a classification (`mechanical`, `scope-disagreement` or `unknown`) and the history of the link's changelog event.
- Classification defaults to `unknown`. Without a changelog, every link is `unknown` with history `none`.

**Draft self-check.** When the check finds a gap, the Draft rewrites the manifest. It never adds a field or appends a correction. It parses the manifest as YAML before returning.

## Proof

### Per-step gates

At every step:
- The contract suite, `validate-skills`, `install-test` and Vale passed, with Vale at 0 errors, 0 warnings and 0 suggestions.
- The compatibility diff was empty. The only fixture added is `schema4-consolidation-valid.yaml`.
- The public-safety grep returned no match.
- Every named mutant from M40 to M70 was run on a committed tree, judged by exit code, and caught.

| Step | Commits | Focus |
| --- | --- | --- |
| 0 | private | Frozen `gate-b` snapshot with Initiative rank, status categories and every Initiative Epic's children |
| C1 | 5759fd8, 42cc5d0 | `consolidation` block and validator |
| C2 | 93a3b77, 9cf0e76 | Draft consolidation step, opt-out, output labels |
| C3 | 1535a9e, 4ca04a7 | Edges between milestone Epics, exceptions, copied acceptance, Review on any manifest |
| C4 | ed51a4f, 4a85617 | Audit semantic link findings, ready statuses |
| C5a | private | Link-classification answer key, ratified 2026-09-25 |
| C5 | 94df53c | Link classification and history |
| R | e765e0f | VERSION 1.6.0, migration note and decision entry |
| Gate fixes | e26c28a, aed48c6, 85b486e | Self-check and wording, two-pass sibling read, consolidation label line and YAML parse |

Four step reviews ran, and they raised 15 Important findings. All were fixed and re-gated.

### Private release gate

**Green.** 131 checks pass across 15 isolated headless Opus runs on the frozen snapshot. The checker self-test passes on every run.
- **Structural checks:** S1 to S4 pass on every attempt.
- **Slice B criteria:** AC-R3.1 to R3.4, AC-R4.1 to R4.5 and AC-B-precision all pass. So do their negative controls: opt-out, no rank, no history and correct forward links.
- **Slice A regression:** the six Slice A Epic Drafts pass their Slice A checks: R0.1, R0.2, R1.1, R1.3-FX-STALE-3, R2.x, R5 and P1. R1.3-FX-STALE-2 is excluded as the accepted 1.5.0 weakness.
- **Two skill commits:** 14 runs used aed48c6. FX-E3 solo was rerun on 85b486e, which differs only in two output-wording sentences.
- **Cost:** 7.3 minutes a run on average, about $38 for the gate.

The gate took three full passes and one rerun to reach green. `validation-results.md` records each failure and the ruling that followed it.

## Deviations and maintainer rulings

1. **Plan-stage rulings:**
   - Planning decisions 6 to 9 cover exceptions naming one real edge, status names, the opt-out's scope, and the gap fills.
   - Evidence lives in a private Slice B folder.
   - The release check gained a `slice-b` suite.
   - Declared order has no live gate case.
2. **FX-STATUS.** Audit takes ready statuses from the request only, and falls back to status category without them.
3. **The answer key** was ratified with three decisions:
   - The rule stays as drafted.
   - AC-R4.1 requires the two edges with quotable text.
   - Names may appear in the private key only.
4. **B3.2 narrowed to live evidence.** One FX-COLLISIONS pair with no live card was dropped, and each remaining pair is checked on its own Epic's Draft. After the acceptance review, claims cover only pairs that include the scoped Epic.
5. **Draft cost.** The sibling read became two passes, and the gate runs 5 at a time instead of 3.
6. **Three late fixes after gate failures:**
   - the self-check and fixed labels
   - ownership disagreements recorded as claims
   - the consolidation label line and the YAML parse
7. **Deviations:**
   - S5 is not implemented, because the snapshot holds no grandchildren.
   - FX-EXCEPTIONS has two Review runs.
   - Review checks milestone-order edges on any manifest.
   - The Slice A reruns keep their Slice A checks.

## Residual risks

- **Acceptance-review fixes (823abaa).** They were validated by the suite and mutants only, not by a live gate rerun (maintainer decision).

- **Format-rule variance.** FX-E3 solo passed once after 85b486e. Earlier, one attempt in three returned unparseable YAML, and one omitted the label.
- **Two skill commits in the final gate,** as described above.
- **Two-pass sibling read.** It was proven on this fixture only. A collision described only deep inside a sibling card could be missed.
- **Draft cost.** A Draft takes 5.5 to 14 minutes and costs $2 to $4 on Opus. Most reads are now the Epic's own children.
- **Judged checks.** They rest on the ratified answer key and on a snapshot frozen on 2026-09-24.
- **R0.2's checker.** It reads the divergence list only under a heading. It passed under the rerun rule.

## Next actions

1. Run `/flow-review` of the full diff against main, together with the gate results.
2. Push and merge only when the maintainer says so. The branch is local, and no CI has run.
3. **Follow-ups:**
   - R0.2 checker tolerance for an inline label.
   - Further reduction in Draft cost.
   - The R1.3 stale-design follow-up carried from 1.5.0.
