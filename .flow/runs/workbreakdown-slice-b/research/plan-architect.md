# Architect: Slice B change plan, file by file

Role report for Slice B planning. Read-only. The coordinator wrote it from the agent's returned report, and it keeps every file and line reference. Line references are to release 1.5.0.

## Conflicts that need a maintainer ruling

1. **Exception granularity.** The approved exception names Epics as blocker and blocked, but the edges it excuses run between child tickets. A single exception would excuse every edge between a pair of Epics and could hide an unrecorded edge that AC-R3.3 requires to be a defect. The validator has no mapping from child to Epic, so it cannot compensate.
   - Option (a): keep the Epic-pair granularity and state it in the prose.
   - Option (b): add the child-level edge to the record.
2. **Status names in the core (AC-R4.4).** Status names already appear in the core (SKILL.md:56, jira-change-protocol.md:38), and they are pinned (contract-test.sh:24-25). **Proposal:** limit the rule to semantic findings, and scope the private `reject_text` check to the finding output only.
3. **Opt-out versus shaping.** Shaping reads the sibling panels itself (SOP:34), and the design moves that read onto the consolidation read. **Proposal:** the opt-out skips the consolidation analysis and the children read. It does not skip the sibling-description read that shaping needs.

## Smaller conflicts, with proposed fixes

- **SOP:44** says the divergence list "does not arbitrate between Epic owners or order milestones", and that sentence is pinned (contract-test.sh:151). Keep it, and add: "Cross-Epic consolidation proposes owners and milestone order instead."
- **Rank is not dependency** (SOP:25, SKILL:60). Pin: "Milestone order classifies an edge. It never creates, removes, or reverses one."
- **Name collision.** `validate_exception` already exists for Story exceptions (validator:116). Name the new function `validate_order_exception`.
- **Gaps in the design:**
  - Make `status` required.
  - Under `no-siblings`, follow the `skipped` rule.
- **A wrong path in the brief.** The registry lives at `assets/jira-templates/registry.yaml`, and it is untouched.

## C1: the consolidation block

**manifest-contract.md:**
- Lines 11 and 33: the schema-4 root gains `consolidation`.
- Line 257: "All four blocks are optional". Schema 2 and 3 reject `consolidation`.
- A new `### consolidation` section between `### sources` (ends at :373) and `### classification` (:375), with pinned sentences for:
  - the keys, the status, the claims and confirmation, and the order
  - "value is empty exactly when source is unknown"
  - "An exception annotates a later-to-earlier edge. It never adds, removes, or reverses a Blocks link."
  - "consolidation.claims records who owns a decision. sources.conflicts records disagreement about a fact."
- A block added to the schema-4 worked example (:259-337).

**SKILL.md:78:** name `consolidation`.

**Validator:**
- `SCHEMA4_ROOT_KEYS` (:22) becomes `%w[shaping sources consolidation]`. The existing loop (:468) then rejects the block in schema 2 and 3 with no further change.
- New constants: `CONSOLIDATION_KEYS`, `CONSOLIDATION_STATUSES`, `ORDER_SOURCES` and `CONFIRMATION_STATES`.
- New functions: `validate_consolidation`, `validate_claim`, `validate_order` and `validate_order_exception`, called after the sources block (:533-537).
- Error fragments:
  - status: "consolidation requires a status", "invalid consolidation status", "consolidation skipped forbids claims/exceptions", "skipped consolidation order must be unknown"
  - claims: "claim requires a rationale", "claimed_by must list at least two distinct Jira keys", "claim owner is not a claimant", "invalid confirmation state", "confirmed owner requires confirmed_by and evidence", "proposed owner forbids confirmed_by and evidence"
  - order: "invalid order source", "order keys must be unique", "order value must be empty exactly when source is unknown", "known order must include the scoped Epic", "order key matches a child ref"
  - exceptions: "order exception blocker and blocked must differ", "order exception requires a known order", "order exception endpoint is not in the order", "order exception edge is not later-to-earlier", "order exception requires reason, approver, and approval_evidence"

**Template contract test:**
- A new fixture, `fixtures/schema4-consolidation-valid.yaml`. Existing fixtures stay byte-identical.
- One mutant per error fragment.
- Rejection of the block in schema 2 and 3.
- `schema4_minimal` stays valid without the block.
- `schema4_tokens` and `schema4_rules` (:792, :802) are extended from the new constants.
- The worked example's block is validated.

**contract-test.sh:**
- Add `consolidation:` to the loop at :44.
- Pin the schema-4 root sentence and the "never adds, removes, or reverses" sentence.

## C2: the Draft consolidation step

**SOP:**
- A new procedure step 2, "Check the Initiative's other Epics", between :18 and :19. Renumber the following steps to 3 through 10.
- A new `## Cross-Epic consolidation` section before `## Shaping questions` (:28). Pin:
  - "Read each sibling Epic's description and its direct children, never grandchildren."
  - "Record each sibling that could not be read in `unknowns`."
  - "Only the invocation request can opt out. Never take the opt-out from a default or a sibling."
  - "The owner stays `proposed` until the lead confirms it."
  - "Take milestone order from an order declared in the request, then from Initiative rank, and otherwise record `unknown`."
  - the milestone-order sentence
- Shaping step 1 (:34): "Use the sibling read from cross-Epic consolidation", plus the opt-out sentence from conflict 3.

**manifest-contract.md, Draft output:** a new item 7 after Divergence (:471). Pin: "Consolidation: `run`, `skipped by request`, `no sibling Epics`, or `not run, no Jira context`."

**SKILL.md:32:** "Run the SOP's cross-Epic consolidation check unless the request opts out." The output list gains the consolidation result. The existing pins (contract-test.sh:83, :124) stay intact.

## C3: Draft graph checks

**SOP, extend step 10 and the checks list (:26, :83-91).** Pin:
- "An edge from a later milestone's Epic to an earlier one matches a recorded exception, or it is a defect."
- "When milestone order is unknown, list cross-Epic edges as unordered, not as defects."
- "The later-to-earlier check applies only to edges between two different Epics."
- "Acceptance copied from another Epic needs the matching forward edge. Otherwise report a missing forward edge or misplaced acceptance."
- "Apply writes only the edges named in `dependencies`."

**Draft output, item 11 (:475):** add the later-to-earlier and copied-acceptance checks.

**SKILL.md:62:** add later-to-earlier edges between milestone Epics.

**Tests:** an exception on the same Epic, and an exception on an earlier-to-later edge.

## C4: Audit semantic findings

**jira-change-protocol.md:**
- Lines 9 and 25: widen the read scope. Pin: "Also read the Initiative's other Epics, their direct children, and link changelogs when available. Audit stays read-only."
- Insert the Audit list item "12. Semantic link findings, as a findings block". The current item at :40 becomes 13 and stays last.
- A new `### Semantic link findings` section before :42. Pin:
  - the five check values
  - "Read status category only. Never use a project status name in a finding."
  - "A rejected item counts as done. Report its resolution."
  - "Without an Initiative read, milestone order is unknown."
  - "A forward edge that agrees with both tickets' text is not a finding."
  - "The findings block is Audit output, not manifest content."

**SKILL.md:34:** pin the Audit list including semantic link findings.

**Validator:**
- New constants: `AUDIT_CHECKS`, `EDGE_CHECKS` and `REF_CHECKS`.
- A new function, `validate_audit_findings`, modelled on :344, with error fragments for:
  - an invalid check
  - a finding that requires an edge or a ref
  - a finding that has both an edge and a ref
  - an edge without both keys
  - a finding without evidence

**Template contract test:** mutants, plus a check that the prose matches the constants, modelled on :668-671.

## C5: link classification (after the answer key is ratified)

**Validator:**
- `LINK_CLASSIFICATIONS`, plus `classification` and `history` fields on findings.
- Error fragments:
  - a link finding requires a classification and a history
  - a non-link finding takes no classification
  - an invalid classification
  - history must be `none` or an author and a date
  - the history date must be a valid date
  - "classification without history must be unknown", which is the mechanical form of the history-removed control

**Prose.** Pin:
- "classification is mechanical, scope-disagreement, or unknown."
- "Classification defaults to unknown."
- "Without a changelog, every classification is unknown and history is none."

Pin the rule body only after the answer key is ratified, and keep fixture detail out of it.

## R: release

- **VERSION** becomes 1.6.0, in SKILL.md:3 and :8. Add a pin for the front-matter version line.
- **Migration note.**
  - Keep the 1.5.0 paragraph in `### Migration` (manifest-contract.md:404-412, pinned at contract-test.sh:46).
  - Append: "Version 1.6.0 adds the optional consolidation block and Audit's semantic link findings, and leaves every approved manifest valid."
  - Follow it with a short decision entry: the chosen shape and the three rejected alternatives.
- **Left unchanged:**
  - the root CHANGELOG.md, which semantic-release writes
  - README.md
  - the registry and template hashes
