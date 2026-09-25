# Solution: workbreakdown Slice B (R3 cross-Epic consolidation, R4 semantic Audit)

Status: approved by the maintainer on 2026-09-24.

Inputs:
- `definition.md` and `acceptance-criteria.md`, Slice B section
- `briefs/solution-shaping.md`
- the role reports in `research/`: solution-architect, data-engineer and test-engineer

## Problem

The skill drafts one Epic at a time. It never checks that decision against the Initiative's other Epics, so collisions go unreported:
- two Epics claim the same decision
- milestone order is contradicted by a later-to-earlier `Blocks` edge
- acceptance is copied into an Epic that lacks the forward edge

Audit reports structural defects, but it misses semantic ones:
- a link that contradicts its ticket's own text
- a blocker into closed work
- a blocker stated only in text
- a status that contradicts the item's blockers

It also cannot tell a mechanical link mistake from a genuine scope disagreement.

## Maintainer decisions (2026-09-24)

1. R3 and R4 are solutioned together and ship in one release.
2. The confirmed owner is recorded in a new optional schema-4 block.
3. A single-Epic Draft reads the sibling Epics' full children.
4. Link classification comes from changelog author and date plus ticket text. It is `unknown` when intent isn't evident.
5. The proof reuses the private release check and the frozen fixture.
6. For milestone order, a declared order from the request beats Initiative rank, and rank beats unknown.
7. The consolidation opt-out comes only from the invocation request. It is never a default and never reused from a sibling.
8. The link-classification answer key is drafted from the frozen fixture's changelogs and ratified by the maintainer before chunk C5 writes the rule.
9. Chunks are built in the order C1 to C5.

## Applicable rules and precedent

- **Archive precedent** (four prior workbreakdown runs, all binding):
  - New manifest fields stay optional and closed in shape.
  - Apply stays fail-closed.
  - `Blocks` semantics don't change.
  - There is no new Jira write path.
- **The `sources` precedent** (MC, schema-4 root). A single optional root key groups related sub-shapes behind `reject_unknown_keys`. `consolidation` follows it exactly.
- **Never default reviewers** (SOP, shaping). The opt-out mirrors this rule: an absent answer is never filled in from a default.
- **Rank is presentation order, not dependency** (SOP, graph review). This is why a declared order outranks rank.
- **Output-only blocks** (MC, Review `findings`). Audit's semantic findings follow the Review findings precedent. They are output, not manifest.
- **Separation of concerns.** `sources.conflicts` records disagreement about a fact, while `consolidation.claims` records who owns a decision. The two never share a field.

## Options considered

| Decision | Chosen | Rejected, and why |
|---|---|---|
| Where consolidation lives | A new SOP step after reading existing work, plus a new Draft output item | Extending Source authority: `conflicts.winner` is a source ref, not an owning Epic, so the field would carry two meanings |
| Block shape | One `consolidation` root key with `status`, `claims`, `order` and `exceptions` | Two root keys (`consolidation` and `milestone_order`): cleaner diffs on a new Draft, but a second acceptance surface on a frozen root |
| Opt-out | From the request only, recorded as `status: skipped` | A fifth shaping entry: it would be written into the Epic panel and reused by siblings |
| Milestone order | declared, then rank, then unknown | Parsing milestone tokens from summaries (project vocabulary, which is a non-goal); rank always winning (weaker evidence) |
| Exceptions | Records in the block that annotate an edge | On the dependency entry: live edges outside `dependencies` could never carry one. A Jira label or comment: a new write path |
| R4 output | One Audit item holding a structured findings block | Five numbered prose items (bloat, and not checkable); reusing Review's `dependency` category (loses classification and history) |
| Classification ground truth | An answer key drafted from the fixture, ratified by the maintainer | Maintainer-written from scratch (slower, same outcome); heuristic only (risks a repeat of R1.3 FX-STALE-2) |

## Design

### The `consolidation` block (schema 4, optional)

```yaml
consolidation:
  status: run            # run | skipped | no-siblings
  claims:
    - claim: "State reads use the cached projection."
      claimed_by: [EPIC-201, EPIC-202]
      owner: EPIC-201
      rationale: "EPIC-201 introduces the projection; EPIC-202 only consumes it."
      confirmation:
        state: proposed  # proposed | confirmed
  order:
    source: rank         # declared | rank | unknown
    value: [EPIC-200, EPIC-201, EPIC-202]
  exceptions:
    - blocker: EPIC-202
      blocked: EPIC-201
      reason: "Hardware lead time forces the later milestone's work first."
      approver: "Program lead"
      approval_evidence: "Decision log, 2026-09-18"
```

**Validator invariants:**
- **Where the block is allowed.** It is rejected in schema 2 and 3. Its keys are closed, and an absent block stays valid.
- **`status`:**
  - `skipped` and `no-siblings` forbid `claims` and `exceptions`.
  - With `skipped`, `order` is absent or `unknown`.
- **`claims`:**
  - `claim` and `rationale` are nonempty.
  - `claimed_by` names at least two distinct Jira keys, and `owner` is one of them.
  - `confirmation.state` is `proposed` or `confirmed`. `confirmed` requires `confirmed_by` and `evidence`, and `proposed` forbids both.
- **`order`:**
  - Keys are unique, and `value` is empty exactly when `source` is `unknown`.
  - When the order is known, the scoped Epic appears in it.
  - No Epic key in `order` matches a child `ref`.
- **`exceptions`:**
  - `blocker` and `blocked` are distinct.
  - Both appear in a known order, and the edge really is later-to-earlier under that order.
  - `reason`, `approver` and `approval_evidence` are nonempty.
  - Exceptions are forbidden when the order is `unknown`.

An exception annotates an edge. It never adds, removes or reverses a `Blocks` link, and Apply writes only the edges named in `dependencies`.

### Draft

**New SOP step: cross-Epic consolidation.** It runs after reading existing work and before shaping.
- **Reading siblings.** It reads each Initiative sibling's description and full children. Shaping's sibling-panel reuse draws on the same read.
- **Status.** It records `status`, and the output states it:
  - `run` when the check ran
  - `skipped` when the request opted out
  - `no-siblings` when there are none
  - With no Jira context, the output says the check did not run, and the manifest is schema 2.
- **Claims.** It finds decisions claimed by more than one Epic and proposes one owner each, with a rationale. The owner stays `proposed` until the lead confirms it.
- **Order.** It derives the milestone order from a declared order, then rank, then records `unknown`. The source is always recorded.

**Graph review (existing step, extended):**
- **Later-to-earlier edges.** Each one is either matched to a recorded exception or reported as a defect.
- **Unknown order.** Cross-Epic edges are listed as "unordered", never as defects.
- **Copied acceptance.** Acceptance copied into an Epic that lacks the matching forward edge is reported as a missing forward edge or as misplaced acceptance.

### Audit

**New item, "Semantic link findings".** It sits before "Smallest proposed change set", which stays last.

**Structured findings block (output, not manifest).** Each finding records:
- `check`: one of `contradicts-text`, `into-closed`, `later-to-earlier`, `text-only-blocker`, `status-vs-blockers`
- `edge` or `ref`
- `evidence`: quoted ticket text, handled as untrusted data
- for link findings, `classification` (`mechanical`, `scope-disagreement` or `unknown`) and `history` (`{author, date}` or `none`)

**How Audit reads:**
- **Status.** Audit reads status category only, with no project status names. A rejected item counts as category `done`, and its resolution is reported.
- **Read scope.** The scope widens to the Initiative's siblings and the changelog. Audit stays read-only.
- **Missing inputs.** Without a changelog, every classification is `unknown`. Without an Initiative read, the order is `unknown`.
- **Classification.** It defaults to `unknown`. The other two classes need positive evidence under the ratified answer key's rule.

No template changes are needed, so template hashes stay put.

## Proof strategy

- **Mechanical, in the public suite:**
  - the block's shape and invariants, each with a named mutant
  - `require_text` pins on the new SOP, Audit and contract wording
  - the synthetic findings-block shape
  - existing schema 2, 3 and 4 fixtures, and the template-set hashes, unchanged
- **Private release check,** on the frozen fixture:
  - **Cases:** FX-E3 solo, FX-E3 opt-out, FX-COLLISIONS, FX-EXCEPTIONS with rank, a no-rank control, FX-COPY-ACCEPT, an Audit with the changelog, and an Audit without it.
  - **Checks:** the Audit checks match finding `ref` and `check` against an expected set held in `cases.yaml`, not prose patterns. AC-R4.4 also uses `reject_text` on status names.
- **Negative controls, never rerun:**
  - the AC-R3.1 opt-out
  - AC-R3.3 with no rank
  - AC-R4.5 with history removed
  - AC-B-precision, FX-FORWARD-OK
- **Judged checks, rerun 2 of 3:**
  - **AC-R3.2:** a rationale is present and not generic.
  - **AC-R4.5:** classifications match the ratified answer key.
- **Checker self-test.** It is extended with a mutant for each new check.

## Chunks

| # | Chunk | Covers | Depends on |
|---|---|---|---|
| C1 | The `consolidation` block in the manifest contract, validator support and synthetic tests. An absent block stays valid. | Contract | none |
| C2 | The Draft consolidation step: the sibling full-children read, the opt-out, owner proposals and milestone order. | AC-R3.1, R3.2, and R3.3's unknown control | C1 |
| C3 | Draft graph checks: later-to-earlier edges, exceptions and acceptance placement. R3 is complete here. | AC-R3.3, R3.4 | C2 |
| C4 | The Audit semantic findings item and the wider read scope, without classification. | AC-R4.1 to R4.4, AC-B-precision | C2 |
| C5a | Draft the link-classification answer key from the frozen fixture's changelogs. The maintainer ratifies it. It is kept private, in the release check. | Ground truth for AC-R4.5 | C4 |
| C5 | Link-history classification and its negative control, written against the ratified key. | AC-R4.5 | C5a |
| R | A VERSION bump (minor), a migration note with an ADR-style entry for the new block and output items, the private release-check cases, and the gate run. | Release | all |

## Owned risks

- **Classification variance repeats R1.3 FX-STALE-2.** Owner: the maintainer. Mitigation: a ratified answer key before any rule prose (C5a), the rule fails toward `unknown`, and the history-removed negative control is mechanical.
- **The wider sibling read overruns context on large Initiatives.** Owner: the maintainer. Mitigation: read each sibling's description and children only, never grandchildren, and record any sibling that could not be read as a gap instead of guessing.
- **The fixture lacks a case for a check.** Owner: the maintainer. Mitigation: C1 through C4 confirm that each FX-* case exists in the frozen snapshot before its release-check case is written. A missing case is raised to the maintainer, not substituted.
- **Private data leaks into the public repo.** Owner: the maintainer. Mitigation: the answer key and fixture mappings stay in the private release check, and the diff is grepped before every commit.
- **The later-to-earlier check misfires on edges within one Epic.** Owner: the maintainer. Mitigation: the check applies only to edges between two different Epics, and a synthetic test pins that.

## Next lane

`flow-plan`, to shape C1 through C5 and R into an implementation plan and validation plan.
