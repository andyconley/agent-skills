# Validation plan: workbreakdown Slice B (release 1.6.0)

This plan follows the shape of Slice A's validation. Source: `research/plan-test-engineer.md`, with the coordinator's corrections.

## Per-step gates (C1, C2, C3, C4, C5, R)

Run these after each step, on a committed tree, before starting the next:
1. **Contract suite:** `tests/workbreakdown-contract-test.sh`, which runs the Ruby template contract test and every `require_text` and `reject_text` pin.
2. **Skill scripts:** `validate-skills` and `install-test` pass.
3. **Vale:** strict mode on every changed prose file, with 0 errors, warnings or suggestions.
4. **Compatibility:**
   - The `schema2-*` and `schema3-*` fixtures, the set 1–3 template assets and the registry are unchanged against `main`.
   - The template-hash pins pass.
   - The diff of the Ruby files removes no assertion.
5. **Mutants:** the step's named mutants, each applied to a committed tree, judged by exit code, and restored. Set `PYTHONDONTWRITEBYTECODE=1`.
6. **Public-safety grep:** grep the diff against `main` for fixture Jira keys, people's names, private repository names and absolute home paths. It must be empty.
7. **Review:** a read-only quality-reviewer and test-engineer pass. Findings and their dispositions go in `validation-results.md`. Fix Critical and Important findings before the next step.

## Named mutants

Each mutant must make the named test fail.

| ID | Step | Break | Caught by |
|---|---|---|---|
| M40 | C1 | Schema 2/3 accepts `consolidation` | schema-gating test |
| M41 | C1 | Claims or exceptions allowed under `skipped` or `no-siblings` | status test |
| M42 | C1 | `claimed_by` allowed with one key | claim test |
| M43 | C1 | Nonempty `order.value` allowed with `source: unknown` | order test |
| M44 | C1 | `confirmed` allowed without `confirmed_by` and `evidence` | confirmation test |
| M45 | C1 | `status` made optional | status-required test |
| M46 | C2 | Sibling-read sentence removed from the SOP | `require_text` pin |
| M47 | C2 | Request-only opt-out sentence removed | `require_text` pin |
| M48 | C3 | Exception accepted when order is `unknown` | exception test |
| M49 | C3 | Exception allowed with `blocker == blocked` | exception test |
| M50 | C3 | Exception accepted on an edge that is not later-to-earlier | exception test |
| M51 | C3 | Exception accepted with an Epic missing from the order | exception test |
| M52 | C3 | Unordered-not-defect sentence removed | `require_text` pin |
| M53 | C4 | An Audit check value missing from the prose or the constant | prose-matches-constants test |
| M54 | C4 | An Audit finding allowed without evidence | findings test |
| M55 | C4 | Status-category-only sentence removed | `require_text` pin |
| M56 | C4 | Grandchild exclusion removed from the Audit read scope | `require_text` pin |
| M57 | C5 | Link finding allowed without history | classification test |
| M58 | C5 | A classification other than `unknown` allowed with `history: none` | classification test |
| M59 | C5 | Default-to-unknown sentence removed | `require_text` pin |
| M60 | R | VERSION and the SKILL.md front matter disagree | version pin |

Prose behavior that the public suite cannot observe is proven in the private release check. That covers the sibling read in practice, honoring the opt-out, copied acceptance, and classification accuracy.

## Private release check (1.6.0, on `gate-b`)

Every run is an isolated headless Opus attempt, launched with the Slice A isolation flags.

### Runs

| # | Run | Criteria |
|---|---|---|
| 1 | Draft FX-E3 solo | AC-R3.1 |
| 2 | Draft FX-E3, opt-out in the request | AC-R3.1 control |
| 3 | Draft of the Epic holding FX-COLLISIONS | AC-R3.2 |
| 4 | Draft with rank present | AC-R3.3 order |
| 5 | Draft with the supplied rev2 manifest recording the FX-EXCEPTIONS edges | AC-R3.3 exceptions and defects |
| 6 | Draft with rank removed | AC-R3.3 control |
| 7 | Draft of the Epic holding FX-COPY-ACCEPT | AC-R3.4 |
| 8 | Audit with changelogs | AC-R4.1 to R4.5, AC-B-precision |
| 9 | Audit with changelogs removed | AC-R4.5 control |
| 10 | Reruns of the six Slice A Epic Drafts | Slice A regression |

Runs may be combined where one Draft serves several cases, as long as every criterion keeps its own check.

### Checks

**Structural** (never rerun, must pass on every attempt):
- **S1 to S4:** unchanged from Slice A.
- **S5:** no sibling grandchild was read.

**Mechanical** (parsed from the output and compared against `cases.yaml`):
- **AC-R3.1:** `consolidation.status` is `run` on run 1.
- **AC-R3.3:**
  - `order.source: rank` and the expected `value`.
  - Both supplied exceptions are matched.
  - Every later-to-earlier edge between Epics without an exception is reported as a defect.
- **AC-R3.4:** a finding for FX-COPY-ACCEPT of either shape.
- **AC-R4.1 to R4.4:** each expected `(check, edge or ref)` pair is present in the findings block.
- **AC-R4.4:** no project status name appears in the finding output outside quoted evidence.

**Negative controls** (never rerun):
- **AC-R3.1:** run 2 reports `skipped` and has no claims or exceptions.
- **AC-R3.3:** run 6 reports order `unknown`, and lists edges as unordered with no defects.
- **AC-R4.5:** on run 9, every classification is `unknown` and every history is `none`.
- **AC-B-precision:** no finding for any FX-FORWARD-OK edge.

**Judged** (2 of 3: a pass on the first attempt passes, otherwise both reruns must pass):
- **AC-R3.2:** each FX-COLLISIONS case has one owner, `proposed`, and a rationale that is present and not generic.
- **AC-R4.5:** each classification and history matches the ratified answer key exactly.

**Slice A reruns:** S1 to S5, R0.1, R0.2, R1.1 (now including sibling children) and AC-A-regression. The other Slice A criteria keep their 1.5.0 gate results. The accepted R1.3 FX-STALE-2 weakness is not a gate blocker.

### Checker self-test

Doctor a copy of each run's first attempt so that each new check must fail, and confirm the checker catches it:
- violate each consolidation invariant
- remove a matched exception
- change a finding's check or edge
- swap a classification or drop its history
- insert a status name into the finding output
- insert a false FX-FORWARD-OK finding
- insert a grandchild read, for S5

A missed mutant fails the gate. A check that already fails on the untouched attempt is skipped.

## The C5a answer key

- **Contents.** The key is private and kept next to `gate-b`, with one entry per link event: the edge, the deciding evidence (author role, whether a comment is present, and the time gap), the expected classification, and the author and date to cite.
- **Ratification.** The maintainer ratifies it line by line before C5 prose is written.
- **Use.** The AC-R4.5 check looks up each expected edge in the key and requires an exact match. The check never derives the ground truth itself.

## Evidence recorded

`validation-results.md` records the following:
- each step's gate outputs, and each mutant with its exit code
- the reviewer findings and their dispositions
- the `gate-b` capture date and the case-presence check
- the ratified key's date, which is not published
- the gate report summary with per-check verdicts, and the self-test count
