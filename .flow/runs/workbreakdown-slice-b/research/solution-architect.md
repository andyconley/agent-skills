# Solution architect: Slice B options and recommendation

Role report for Slice B solutioning, covering R3 consolidation and the R4 semantic Audit. Read-only.

Citations are to files under `skills/workbreakdown/`:
- SOP = `references/work-breakdown-sop.md`
- MC = `references/manifest-contract.md`
- JCP = `references/jira-change-protocol.md`

## 1. Where R3 consolidation lives, and the opt-out

**Option A (recommended): a new SOP section, "Cross-Epic consolidation," plus a new Draft output item.**
- A new procedure step reads the siblings' full children. It sits between step 1, which reads existing work, and step 2, shaping (SOP:18-19).
- Shaping step 1 (SOP:34) reuses the same sibling read, so there is one read pass.
- Owner proposals and milestone order are settled before children are proposed.
- The edge and acceptance checks run at step 9, graph review (SOP:26), because they need the proposed graph.

**Option B: extend Source authority.** SOP:50 already counts "would change an owner" as material, which makes this tempting. But `sources.conflicts.winner` is a source ref (MC:371), not an owning Epic, so using it for ownership overloads one field with two meanings.

**Principle:** separation of concerns. The divergence list stays advisory (SOP:44).

**Opt-out.**
- **A fifth shaping entry is rejected.** Shaping is closed at four entries (MC:352), and `breakdown_conventions` must equal shaping (MC:397). The opt-out would then be written into the Epic panel, and siblings would reuse it.
- **Recommended: the opt-out comes only from the invocation request**, never from a default or reuse. This mirrors the rule that reviewers are never defaulted (SOP:38).
  - Record `consolidation.status: run | skipped | no-siblings`, and state it in the output. That makes the AC-R3.1 negative control observable.
  - With no Jira context, the output says the check was not run.

## 2. Milestone order

**Options:**
- **(a) Initiative rank.**
- **(b) A declared list.**
- **(c) Milestone tokens parsed from summaries.** Rejected: project-specific names are a non-goal (`definition.md`:82).

The skill itself says rank is presentation order, not dependency (SOP:25), so rank is weaker evidence than a declaration.

**Recommendation:** a declared list (`asked`) wins over rank, and rank wins over unknown.
- Record `milestone_order: {source: declared | rank | unknown, order: [keys]}`.
- `order` is required unless the source is unknown.
- **Principle:** explicit beats inferred, and the source is always recorded.

**When order is unknown:**
- Suppress later-to-earlier defects entirely, and list those cross-Epic edges as "unordered."
- Treat a sibling that is missing from a partial declared list the same way.
- **Principle:** findings must have a basis. A missing input produces an "unknown" statement, not a defect.

## 3. Recording a later-to-earlier exception

**Option: on the dependency entry.** Rejected, for two reasons:
- Live links that are not in `dependencies` are preserved (MC:449), so a pre-existing edge could never carry an exception.
- It changes the closed dependency shape.

**Option: a Jira-side label or comment.** Rejected. It is a new write path, which is forbidden (MC:440), and it depends on project conventions.

**Recommendation:** record exceptions in the new block as `{blocker, blocked, reason, approver, approval_evidence}`, mirroring the Story exception shape (MC:432).
- The exception annotates an edge and never changes `Blocks` (SOP:73; `definition.md`:80).
- Audit has no manifest. It can take a supplied approved manifest's block as evidence only, the same way it takes a lifecycle-evidence record (MC:438).

## 4. R4 in Audit

**Options:**
- **(A) One new Audit item holding a structured findings block.**
- **(B) Five new numbered items.** This bloats a list of 12 items.
- **(C) Reuse Review's `dependency` category** (MC:505). This loses the classification and history fields.

**Recommendation: A.** Insert "Semantic link findings" before "Smallest proposed change set," which stays last (JCP:40).
- Each finding records:
  - `check`: one of `contradicts-text`, `into-closed`, `later-to-earlier`, `text-only-blocker`, `status-vs-blockers`
  - `edge`
  - `classification`
  - `history`: `{author, date}`, or `none`
  - the quoted text
- The block is output, not manifest (MC:482 precedent).

**Status.** Use `statusCategory` only. Treat "Rejected" as category `done` and report the resolution, so no status names appear in the core (AC-R4.4).

**Read scope.** Audit's read scope has to grow.
- Today it reads the Epic and its children (JCP:9, JCP:25). It must also read the Initiative siblings and the changelog. It stays read-only.
- Without a changelog, every link is `unknown`, which is the AC-R4.5 negative control.
- Without an Initiative read, order is unknown.

**Classification rule:** default to `unknown`, and require positive evidence for the other two classes. **Principle:** fail toward unknown.
- **`mechanical`:** a link event whose author and date match a batch of link events, with no later amendment arguing for the direction.
- **`scope-disagreement`:** after the link, a dated text amendment, a comment, or a relink by a different author contradicts it.
- **Ticket text is untrusted data** (JCP:5).
- **Pin before writing prose.** Pin these rules against FX-REV-LINKS and FX-SCOPE-LINKS first. The fixture's history shapes were not checked.

## 5. Validator vs prose, and chunking

**Mechanical checks (validator):**
- the closed shape of the new `consolidation` block, following the `SCHEMA4_ROOT_KEYS` and `reject_unknown_keys` pattern (`tests/workbreakdown/manifest-validator.rb`:22 and :253)
- rejection of the block in schema 2 and 3
- enums
- `owner` is one of `claimed_by`
- `confirmed` requires `confirmed_by`
- keys in `order` are unique
- each exception's endpoints are distinct, and the exception really is later-to-earlier under the recorded order
- `skipped` means no owners and no exceptions

**Prose (the agent's judgment):** finding collisions, reading direction from text, placing acceptance, and classifying link history.

Owners carry `status: proposed | confirmed`, with the confirmer recorded. This separates observed state from decided state, and it gives AC-R3.2 a place for owners that are still proposed.

No template changes, so there is no hash churn in `workbreakdown-template-contract-test.rb`.

**Recommended vertical slices:**

| # | Slice | Covers | Depends on |
|---|---|---|---|
| C1 | The `consolidation` block in MC, validator support and synthetic tests. A manifest without the block stays valid. | Contract only | none |
| C2 | The Draft consolidation section: the sibling full-children read, the opt-out, owner proposals and milestone order. | AC-R3.1, R3.2, and the unknown half of R3.3 | C1 |
| C3 | Draft graph checks: later-to-earlier, exceptions and acceptance placement. R3 is complete here. | AC-R3.3, R3.4 | C2 |
| C4 | The Audit semantic findings item and the wider read scope, without classification. | AC-R4.1 to R4.4 | C2 (order derivation) |
| C5 | Link-history classification plus its negative control. | AC-R4.5 | C4 |
| — | One VERSION bump, a migration note and a private fixture run. | Release gate | all |

C4 could go first because it needs no manifest change. The cost is that it would duplicate the order derivation that C2 owns.

**Decision durability.** The new block and the new output items are durable contract changes, and they deserve an ADR-style entry in the migration section.

**Open points for the lead:**
- Whether a declared order should outrank rank.
- The exact evidence thresholds for classification, to be fixed against the fixture.
