# Validation results: workbreakdown Slice B (release 1.6.0)

This records the implementation evidence for `plan.md` and `validation-plan.md`. The private release check lives outside this repository. It is summarized here without fixture keys or names.

## Per-step gates

Each step ran these checks, on a committed tree:
- `bash tests/workbreakdown-contract-test.sh`
- `bash scripts/validate-skills.sh`
- `bash tests/install-test.sh`
- `./scripts/lint-prose.sh`, on every changed prose file

All of them passed, with Vale at 0 errors, 0 warnings and 0 suggestions.

At every step:
- The compatibility diff was empty. No existing fixture, template asset or registry entry changed. The only fixture added is `schema4-consolidation-valid.yaml`.
- The public-safety grep returned no match.
- Every mutant was run on a committed tree, judged by the suite's exit code, and restored with `git checkout`.

| Step | Commits | Mutants (all caught) | Focus |
| --- | --- | --- | --- |
| 0 | private | none | `gate-b` snapshot, GET-only, with Initiative rank, status categories and every Initiative Epic's children. All cards the Slice B fixture cases cite are present. |
| C1 | 5759fd8, 42cc5d0 | M40–M45, M45b–M45d | Optional schema-4 `consolidation` block: status, claims, order, exceptions |
| C2 | 93a3b77, 9cf0e76 | M46, M47 | Draft cross-Epic consolidation step, opt-out and output line |
| C3 | 1535a9e, 4ca04a7 | M48–M52, M52b | Edges between milestone Epics, exceptions, copied acceptance; Review without a consolidation block |
| C4 | ed51a4f, 4a85617 | M53–M56, M53b, M55b, M56b–M56d | Audit semantic link findings and the ready-status input |
| C5a | private | none | Link-classification answer key, ratified by the maintainer on 2026-09-25 |
| C5 | 94df53c | M57–M59, M59b, M59c | Link classification and history |
| R | e765e0f | M60 | VERSION 1.6.0, migration note and decision entry |

### Mutants

Each mutant is listed with the test that caught it.

**C1:**
- **M40:** schema 2/3 accepts `consolidation`. Caught by the schema-gating test.
- **M41:** `skipped` allows claims. Caught by the status test.
- **M42:** `claimed_by` with one key. Caught by the claim test.
- **M43:** the rule that value is empty exactly when source is unknown was removed. Caught by the order test.
- **M44:** `confirmed` without evidence. Caught by the confirmation test.
- **M45:** status made optional. Caught by the status test.
- **M45b:** a child-ref endpoint is not tied to the scoped Epic. Caught by the exception test.
- **M45c:** an exception on a proposed child without an ensure dependency. Caught by the exception test.
- **M45d:** duplicate exceptions. Caught by the exception test.

**C2:**
- **M46:** the sibling-read sentence was removed. Caught by a pin.
- **M47:** the request-only opt-out sentence was removed. Caught by a pin.

**C3:**
- **M48:** an exception accepted under an unknown order. Caught by the exception test.
- **M49:** blocker equals blocked. Caught by the exception test.
- **M50:** an exception on an edge that is not later-to-earlier. Caught by the exception test.
- **M51:** an Epic missing from the order. Caught by the exception test.
- **M52:** the unordered-not-defect sentence was removed. Caught by a pin.
- **M52b:** the copied-acceptance sentence was removed. Caught by a pin.

**C4:**
- **M53:** a check dropped from the prose. Caught by the prose-matches-constants test.
- **M53b:** a check dropped from the constant. Caught by the same test.
- **M54:** a finding without evidence. Caught by the findings test.
- **M55:** the status-category sentence was removed. Caught by a pin.
- **M55b:** the ready statuses made inferable. Caught by a pin.
- **M56:** the forward-edge exemption was removed. Caught by a pin.
- **M56b:** a link finding without an edge. Caught by the findings test.
- **M56c:** duplicate findings. Caught by the findings test.
- **M56d:** a reversed link reported twice. Caught by a pin.

**C5:**
- **M57:** a link finding without classification. Caught by the classification test.
- **M58:** a known class with `history: none`. Caught by the classification test.
- **M59:** the default class changed. Caught by the prose-matches-constants test.
- **M59b:** the no-changelog rule was removed. Caught by a pin.
- **M59c:** an invalid history date. Caught by the classification test.

**R:**
- **M60:** the front-matter version disagrees with VERSION. Caught by the version pin.

The validation plan's M48 was stated backwards. Suppressing a defect under an unknown order is the correct behavior. The mutant that ran accepts an exception under an unknown order.

## Step reviews

Each review ran read-only. Every Important finding was fixed before the next step and then re-gated.

- **C1 test review: 12 uncovered rules.** Examples: shape guards, the `claim` text check, and the blocker branch of the endpoint check. All are covered in 42cc5d0. The "order key matches a child ref" rule was unreachable once order keys had to be Jira keys, so it was removed, together with its prose clause.
- **C1 quality review: three Important findings,** all fixed in 42cc5d0:
  - an exception's ticket and Epic were not tied together
  - the worked example excused an edge that could not exist
  - missing mutants
- **C2 and C3 quality review: four Important findings,** all fixed in 9cf0e76. All four concerned output that a checker parses:
  - how each status maps to its output label
  - what the graph-check item says when the order is unknown or the check did not run
  - where unordered and proposed exceptions go
  - the scope of a claim
- **C4 quality review: four Important findings,** all fixed in 4a85617:
  - Audit's own source for milestone order and exceptions
  - the scope of the forward-edge exemption
  - reversed links reported under two checks
  - status names in quoted evidence

## Maintainer rulings during implementation

1. **Evidence location, release-check extension and declared order** (2026-09-24). Slice B evidence lives in its own private run folder. The existing harness is extended with a `slice-b` suite. Declared order gets no live gate case.
2. **FX-STATUS and the ready statuses** (2026-09-25). A status check by category alone cannot find a "ready" status whose category is "to do". Audit therefore takes ready statuses only from the invocation request. Without them it falls back to category only and says so.
3. **The answer key** (2026-09-25). The maintainer ratified it with three decisions:
   - The classification rule stays as drafted.
   - AC-R4.1 requires only the two edges with quotable contradicting text. The other two are optional.
   - Author names may appear in the private key.

## Deviations from the plan

- **S5 is not implemented.** The check that no sibling grandchild is read has nothing to observe, because the snapshot holds no grandchildren. A prose pin covers the rule.
- **FX-EXCEPTIONS has two Review runs, not one.** The rev2 M4 draft has no later-to-earlier edge other than the two recorded ones, so one run supplies the decision record and one doesn't. Both halves of AC-R3.3 are exercised.
- **Review checks milestone-order edges on any manifest** (4ca04a7). Previously it did so only for a manifest with a `consolidation` block. The rev2 input is schema 2.
- **Slice A reruns keep their Slice A checks,** except the accepted R1.3 FX-STALE-2 weakness. That replaces the plan's narrower list and gives more regression signal from the same runs.

## Private release gate

Status: running. Results are pending.
