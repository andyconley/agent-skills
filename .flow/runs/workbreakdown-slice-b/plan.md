# Plan: workbreakdown Slice B (release 1.6.0)

Status: approved by the maintainer on 2026-09-24.

Inputs:
- `definition.md` and `acceptance-criteria.md`, Slice B section
- `solution.md`, with decisions 1 to 9
- `research/plan-*.md`: the architect, business-analyst, product-manager and test-engineer reports

## Problem statement

- **What:** add cross-Epic consolidation to Draft (R3) and semantic link findings to Audit (R4), then release them as workbreakdown 1.6.0.
- **Who:** leads who break an Initiative into Epics, and anyone who runs Draft or Audit on an Epic with siblings.
- **Why now:** Slice A shipped as 1.5.0. R3 and R4 are the remaining tabletop requirements, and the frozen fixture that proves them is getting older.

## Desired outcome

- A Draft reports each decision claimed by more than one Epic with a proposed owner.
- It reports milestone order with its source.
- It reports every later-to-earlier edge between milestone Epics as either a recorded exception or a defect.
- An Audit reports semantic link defects as structured findings, and classifies link history, defaulting to `unknown`.
- Every approved manifest stays valid, and nothing new is written to Jira.

## Planning decisions (2026-09-24)

These are recorded in addition to solution decisions 1 to 9.

1. **Fixture refresh.** A GET-only refresh captures Initiative rank and the sibling Epics' direct children. It is frozen as a new `gate-b` snapshot, and Slice A's `gate` snapshot is untouched.
2. **FX-EXCEPTIONS.** The private release check supplies the tabletop rev2 edges as an approved manifest input, with a `consolidation` block that records both exceptions.
3. **One implementation run** covers step 0, C1 to C5, and R. It pauses at C5a.
4. **Release gate scope.** All Slice B cases, plus reruns of the six Slice A Drafts. The Slice A Reviews and the no-Jira control are not rerun.
5. **Version.** The release is 1.6.0.
6. **Exceptions record the real edge (amends the solution's block shape).**
   - The fields are `{blocker, blocked, blocker_epic, blocked_epic, reason, approver, approval_evidence}`.
   - `blocker` and `blocked` are the tickets on the edge: a Jira key, or a manifest child ref for a proposed item.
   - `blocker_epic` and `blocked_epic` are Jira keys that must be in a known order, and the edge must run later-to-earlier under that order.
   - One exception excuses exactly one edge, never a pair of Epics.
7. **Status names.** "Status category only, no project status names" applies to the semantic findings. The existing pinned rules elsewhere in the core are unchanged. The private check scans the finding output only.
8. **Opt-out scope.** The opt-out skips the consolidation analysis and the siblings' children read. It does not skip the sibling description read that shaping already needs.
9. **Gap fills.** `status` is required, and `no-siblings` follows the `skipped` rule: no claims or exceptions, and the order is absent or `unknown`.

## Interpretations of the acceptance criteria

- **AC-R3.1:** "single-Epic Draft" names one target Epic. The Draft still reads its siblings.
- **AC-R3.2:**
  - The fixture exercises only `proposed` owners.
  - The `confirmed` state is covered by synthetic tests.
  - The rationale is judged on being present and not generic.
- **AC-R3.3:** the case uses rank because no order is declared. It is not evidence against the order of precedence: declared, then rank, then unknown.
- **AC-R3.4:** either finding shape passes: a missing forward edge, or misplaced acceptance.
- **AC-R4.1 to R4.3 and AC-B-precision:** "reported" means an entry in the Audit findings block whose `check` and `edge` or `ref` match the expected set.
- **AC-R4.4:** the rule covers finding output and the new Audit prose. Quoted evidence is untrusted ticket text and may contain raw status names.
- **AC-R4.5:** classification and history must match the maintainer-ratified answer key exactly.

## Scope

**In scope:**
- Step 0, the fixture.
- C1 to C5.
- R, the release.
- Extending the private release check: a `gate-b` fetch, new cases, checks and self-test mutants, and a README update.

**Out of scope:**
- Jira writes of any kind.
- Any change to `Blocks` semantics or to Apply. Apply writes only the edges in `dependencies`.
- Template, registry and template-hash changes.
- The R1.3 stale-design follow-up.
- Project vocabulary in the core.
- Estimates.
- Auto-fix behavior.
- Grandchild reads, and caching or pagination logic.
- Reruns of the Slice A Reviews and the no-Jira control.
- The push and PR, which the maintainer decides.

## Steps

The architect report holds the full file, section and line detail for each step, along with the draft pin text and the validator error fragments. The implementer follows it, with the changes that planning decisions 6 to 9 make.

### Step 0: the `gate-b` fixture (private release check)

- **Fetch.** Extend the private fetch script, GET-only, to capture the Initiative's rank order and each sibling Epic's direct children, with their links, comments and change history. Write the result as a new `gate-b` snapshot. Slice A's `gate` snapshot is never modified.
- **Confirm the cases.** Confirm that every card cited by the nine Slice B fixture cases is present, along with a rank for each sibling. Stop and report to the maintainer if any is missing.
- **Build the rev2 input.** Build the approved manifest for FX-EXCEPTIONS, planning decision 2. It records both exceptions in the decision 6 shape.

### C1: the `consolidation` block (contract)

**Contract (`references/manifest-contract.md`):**
- The schema-4 root sentences name `consolidation`.
- Schema 2 and 3 reject it.
- A new `### consolidation` section, placed after `### sources`.
- A block added to the schema-4 worked example.
- The decision entry in the migration note waits for R.

**Validator (`tests/workbreakdown/manifest-validator.rb`):**
- `consolidation` joins `SCHEMA4_ROOT_KEYS`.
- New functions: `validate_consolidation`, `validate_claim`, `validate_order` and `validate_order_exception`. The name avoids a collision with the existing `validate_exception`.
- Invariants follow the solution, plus decisions 6 and 9:
  - a claim needs its rationale
  - the owner is one of the claimants
  - the confirmation state and evidence are consistent
  - order keys are unique
  - `value` is empty exactly when the order is unknown
  - the scoped Epic is in a known order
  - no order key matches a child ref
  - an exception's Epics are in a known order, and the edge runs later-to-earlier
  - `blocker` and `blocked` are distinct Jira keys or child refs
  - the exception text fields are nonempty
- The template contract test gains a new valid fixture, `schema4-consolidation-valid.yaml`, and one mutant per error fragment. It also checks that schema 2 and 3 reject the block, and that `schema4_minimal` stays valid without it.
- `tests/workbreakdown-contract-test.sh` gains `consolidation:` in the token loop, the schema-4 root pin, and the "never adds, removes, or reverses a Blocks link" pin.
- `SKILL.md` names the block.

### C2: the Draft consolidation step

- **Procedure (SOP).** A new procedure step 2, "Check the Initiative's other Epics", with the later steps renumbered.
- **Consolidation section (SOP).** A new `## Cross-Epic consolidation` section, before Shaping questions. It covers:
  - the sibling read: descriptions and direct children only, never grandchildren
  - unread siblings, recorded in `unknowns`
  - the request-only opt-out, with decision 8's scope
  - owners staying `proposed` until the lead confirms them
  - milestone order: declared, then rank, then `unknown`
  - "Milestone order classifies an edge. It never creates, removes, or reverses one."
  - that cross-Epic consolidation, not the divergence list, proposes owners and order
- **Shaping step 1** reuses the consolidation read.
- **Draft output** gains the item "Consolidation: `run`, `skipped by request`, `no sibling Epics`, or `not run, no Jira context`."
- **`SKILL.md`** gains the step and its output. The existing pins stay intact.
- **Tests.** Only prose pins. There is no validator change.

### C3: Draft graph checks

- The SOP's graph-review step and checks list gain four rules:
  - A later-to-earlier edge between Epics matches a recorded exception, or it is a defect.
  - When the order is unknown, those edges are listed as unordered, not as defects.
  - The check applies only between two different Epics.
  - Copied acceptance needs a forward edge. Otherwise, report a missing forward edge or misplaced acceptance.
- Pin: "Apply writes only the edges named in `dependencies`."
- The Draft output graph-check item and `SKILL.md` name the new checks.
- **Tests:** an exception within one Epic, an exception on an earlier-to-later edge, and an exception whose Epics are missing from the order.

### C4: Audit semantic findings

**`references/jira-change-protocol.md`:**
- The read scope adds the Initiative's other Epics, their direct children, and link changelogs when they are available. Audit stays read-only.
- The Audit list gains item 12, "Semantic link findings", and "Smallest proposed change set" becomes item 13 and stays last.
- A new `### Semantic link findings` section covers:
  - the five check values
  - status category only, with a rejected item counting as done and its resolution reported
  - order is unknown without an Initiative read
  - a forward edge that agrees with both tickets' text is not a finding
  - the block is output, not manifest content

**Validator and tests:**
- The validator gains `validate_audit_findings`, with the constants `AUDIT_CHECKS`, `EDGE_CHECKS` and `REF_CHECKS`.
- The tests gain mutants and a check that the prose matches the constants.

**`SKILL.md`** gains the Audit list pin.

### C5a: the answer key (maintainer checkpoint, private)

- Draft the answer key from `gate-b`'s changelogs for every link event in FX-REV-LINKS and FX-SCOPE-LINKS. Each entry records:
  - the edge
  - the deciding evidence: author role, whether a comment is present, and the time gap
  - the expected classification
  - the author and date the finding must cite
- The key stays in the private release check.
- **Stop.** The maintainer ratifies the key line by line before any classification rule prose is written.

### C5: link classification

**Validator:**
- `LINK_CLASSIFICATIONS`, plus `classification` and `history` fields on the findings of the three edge checks.
- `history` is `none` or `{author, date}`, with a valid date.
- A classification without history must be `unknown`.

**Prose:**
- The three classification values.
- The default is `unknown`.
- Without a changelog, every classification is `unknown` and history is `none`.
- The positive-evidence rule, written generically against the ratified key, with no fixture detail.

### R: release

- **VERSION** becomes 1.6.0, in `VERSION` and the `SKILL.md` front matter, with a new pin on the front-matter version line.
- **Migration note.** Keep the 1.5.0 paragraph. Append the pinned sentence: "Version 1.6.0 adds the optional consolidation block and Audit's semantic link findings, and leaves every approved manifest valid." Follow it with a short decision entry: the chosen shape and the rejected alternatives.
- **Private release check:**
  - new cases, checks, S5, and self-test mutants
  - the answer-key lookup
  - finding-output-only status-name scanning
  - a README update
  - then the gate run, following `validation-plan.md`
- **Records.** `validation-results.md` and `HANDOFF.md`.
- **Left unchanged:** the root CHANGELOG.md (written by semantic-release), README.md, the registry and templates.

## Stop points: return to the maintainer

- A Slice B fixture card or sibling rank is missing from `gate-b`.
- C5a, for ratification.
- A judged check hovers near the 2-of-3 threshold. Report it; don't iterate silently.
- A contract conflict that this plan does not resolve.
- Private data in a public diff.

## States and contracts

There is no UI.

**Data contract.** The optional schema-4 `consolidation` block:
- **status**, required: run, skipped or no-siblings.
- **claims:** claim, claimed_by, owner, rationale and confirmation.
- **order:** source and value.
- **exceptions:** the decision 6 shape.
- **compatibility:** a manifest without the block stays valid, and schema 2 and 3 reject it.

**Output contracts:**
- the Draft consolidation result item
- the extended graph checks
- the Audit semantic findings block: `check`, `edge` or `ref`, and quoted `evidence`, plus `classification` and `history` on link checks

**Workflow contract:**
- no new Jira write path
- Apply unchanged
- the opt-out comes from the request only

## Done

The run is done when all of these hold:
- C1 to C5 and R are committed on `claude/workbreakdown-slice-b`, and VERSION is 1.6.0.
- Every per-step gate and named mutant passes.
- The private gate passes every Slice B criterion and control, and the rerun Slice A Draft checks.
- The checker self-test catches every mutant.
- The public-safety grep is clean.
- `validation-results.md` and `HANDOFF.md` are written, and `mark-handback-ready` succeeds.
