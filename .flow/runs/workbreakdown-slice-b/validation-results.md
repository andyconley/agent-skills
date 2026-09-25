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
| Gate fixes | e26c28a, aed48c6, 85b486e | M61–M66 | Self-check and wording, two-pass sibling read, consolidation label line and YAML parse |

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

**Result: green, with two caveats.** 131 checks pass across 15 isolated headless Opus runs on the frozen `gate-b` snapshot. The checker self-test passes on all 15 runs, with no missed mutant.

1. **FX-E3 solo** passed on a single attempt after its last fix. It had earlier failed one attempt in three.
2. **The results span two skill commits,** aed48c6 and 85b486e. `git diff --stat aed48c6 85b486e -- skills tests` shows two files changed, with 4 insertions and 3 deletions: two sentences in `manifest-contract.md` and their pins.

See "Residual evidence gaps" below.

### How the gate got to green

1. **First gate (skill e765e0f): not green.**
   - Two checker defects were fixed, each with a self-test mutant:
     - S1 flagged the agent reading back its own spilled tool output.
     - The consolidation label parser rejected a heading form of the label.
   - Four skill failures remained:
     - Two Drafts returned invalid manifests. One appended a "correction" instead of fixing the manifest, and one left a precedent's search list empty.
     - Copied acceptance was found but not labelled.
     - The FX-E3 Draft found one of three collision pairs.
   - **Maintainer ruling (2026-09-25).** The self-check and the wording were tightened in e26c28a. B3.2 was narrowed to live evidence. One FX-COLLISIONS pair with no live card was dropped, and each remaining pair is checked on its own Epic's Draft.
2. **Draft cost.** A Draft took 6 to 11 minutes and $2 to $4, mostly reading every sibling child card. **Maintainer ruling:** read sibling children in two passes (aed48c6), and run the gate 5 at a time.
3. **Second full gate (skill aed48c6).**
   - Every check passes on 14 of 15 runs.
   - FX-E3 solo failed:
     - S4 on its third attempt: a YAML value with an unquoted colon.
     - B3.1 on its first attempt: the section omitted the `run` label.
   - **Maintainer ruling:** open the consolidation item with a literal label line, and parse the manifest as YAML before returning (85b486e). Then rerun FX-E3 solo only.
4. **FX-E3 solo rerun (skill 85b486e):** all 7 checks passed on the first attempt.

The results mix two skill commits:
- 14 runs used aed48c6.
- FX-E3 solo used 85b486e, which differs from aed48c6 only in two output-wording sentences.

The superseded attempts are kept with the private evidence.

### Checks by criterion

- **AC-R3.1:** B3.1, the consolidation announced, and B3.1-control, the opt-out.
- **AC-R3.2:** B3.2. The collision pair is claimed on its own Epic's Draft.
- **AC-R3.3:**
  - B3.3-order: order from rank.
  - B3.3-control: no rank means order unknown.
  - B3.3-recorded: supplied exceptions are not flagged.
  - B3.3-unrecorded: both edges are flagged without the record.
- **AC-R3.4:** B3.4, copied acceptance reported.
- **AC-R4.1 to R4.4:** B4.1 to B4.4. All matched on each finding's check and ref.
- **AC-R4.5:** B4.5, classification matches the ratified key, and B4.5-control, no history means unknown.
- **AC-B-precision:** B-precision, no finding on a correct forward link.
- **Slice A regression:** the six Slice A Epic Drafts pass their Slice A checks, including S1 to S4, R0.1, R0.2, R1.1, R2.x, R5 and P1. R1.3-FX-STALE-2 is excluded as the accepted 1.5.0 weakness.

### Cost

On the final gate, a run averaged 7.3 minutes. The 15 runs cost about $38 in total. A Draft takes 5.5 to 14 minutes. Most of its reads are now the Epic's own children, which the SOP reads in full.

### Rerun rule, and what a single attempt proves

- Every positive Slice B check is judged. A judged check that passes on its first attempt passes. One that fails reruns twice, and both reruns must pass.
- The negative controls and the structural checks run once and must pass on every attempt.
- A positive check that passed on attempt 1 therefore had no repeat. That is the rule the maintainer set, not a missing rerun.

### Acceptance-review fixes, validated by the suite only

**What changed.** 823abaa closes the acceptance-review gaps:
- Review checks milestone-order edges on every manifest.
- Claims cover only pairs that include the scoped Epic.
- A confirmed owner needs the lead's own confirmation.
- Exceptions come only from a record the active user supplies.
- A request-only input can't come from ticket text.
- Review's dependency category names the new checks.
- Audit reads its own children in full.

**How it was validated.** The suite, `validate-skills`, `install-test`, Vale, and mutants M67 to M70 all passed. The maintainer chose not to re-gate (2026-09-25), so the private gate did not rerun on this commit.

**Claim scope.** Narrowing claims to pairs that include the scoped Epic matches how B3.2 is already checked, one pair on each pair's own Epic Draft.

### Residual evidence gaps

- **FX-E3 solo after the last fix.** It passed on one attempt after 85b486e. Its earlier failures (one broken manifest in three attempts, one missing label) show real variance in how well the model follows the format rules.
- **Two commits.** The final results come from two skill commits, as described above.
- **The two-pass sibling read.** It was checked by the collision and copied-acceptance cases on this fixture only. A collision described only deep in a sibling card's description could be missed.
- **R0.2's checker.** It reads the divergence list only under a heading. One attempt wrote the list as an inline bold label and failed. It passed under the rerun rule.
