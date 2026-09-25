# Test engineer: Slice B validation plan (release 1.6.0)

Role report for Slice B planning. Read-only. The coordinator wrote it from the agent's returned report. The coordinator's corrections are marked **[coordinator]**.

## 1. Per-step gates, in the Slice A shape

Run these after each chunk, before starting the next:
1. **Contract suite.** The Ruby suite plus every new `require_text` and `reject_text` pin.
2. **Skill scripts.** `validate-skills` and `install-test` pass.
3. **Vale.** 0 errors, warnings or suggestions on every changed prose file.
4. **Compatibility diff.**
   - The `schema2-*` and `schema3-*` fixtures and the set 1–3 template assets are unchanged against `main`.
   - The set-3 hash pins pass.
   - The diff of the Ruby files removes no assertion.
5. **Mutation check.** Commit first, break one named rule, confirm the suite fails by exit code, then restore.
6. **Public-safety grep.** Grep the diff against `main` for the private key pattern and private names. It must come back empty.
7. **Reviewer pass.** A read-only quality-reviewer and test-engineer pass. Findings go in `validation-results.md`, and Critical and Important findings are fixed before the next chunk.

## 2. Named mutants (M40 onward), judged by exit code on a committed tree

**C1:**
- **M40:** schema 2/3 accepts `consolidation`.
- **M41:** claims or exceptions are allowed with `status: skipped`.
- **M42:** `claimed_by` is allowed with one key.
- **M43:** `order.value` is allowed to be nonempty when `source: unknown`.
- **M44:** `confirmed` is allowed without `confirmed_by` or `evidence`.

**C2:**
- **M45:** the sibling full-children read is removed.
- **M46:** consolidation always runs, ignoring the opt-out.
- **M47:** the opt-out is reused from a sibling.
- **[coordinator]** These are prose behaviors. They are caught by `require_text` pins on the SOP wording and by release-check runs. A synthetic manifest test can only catch a manifest-level effect, for example that `skipped` forbids claims.

**C3:**
- **M48:** a later-to-earlier defect is suppressed when order is `unknown`.
  - **[coordinator]** This is inverted. Suppressing the defect under an unknown order is the correct behavior. The real mutant reports a defect, or accepts an exception, when the order is `unknown`.
- **M49:** an exception is allowed with `blocker == blocked`.
- **M50:** an exception is accepted that is not later-to-earlier under the known order.
- **M51:** the copied-acceptance check is dropped. **[coordinator]** This is prose, so it takes a pin and a release-check case.
- **M52:** the later-to-earlier check applies within one Epic.

**C4:**
- **M53:** a finding category is missing from the findings schema.
- **M54:** the read scope reaches grandchildren. **[coordinator]** This is prose, so it takes a pin plus S5.
- **M55:** a literal status name appears in the core prose. This is caught by a `reject_text` pin.
- **M56:** evidence is paraphrased rather than quoted.

**C5:**
- **M57:** a classification is allowed without history (author and date).
- **M58:** the default is not `unknown`.
- **M59:** a classification other than `unknown` is allowed with history removed.

**R:**
- **M60:** VERSION does not match the reported version.

C5a has no public mutant, because it only produces the private answer key.

## 3. Private release-check design (1.6.0)

**Runs:**
1. **Draft FX-E3 solo:** AC-R3.1.
2. **Draft FX-E3 with the opt-out:** AC-R3.1 negative control.
3. **Draft covering FX-COLLISIONS:** AC-R3.2.
4. **Epic Draft with rank:** AC-R3.3 order derivation.
5. **FX-EXCEPTIONS with the supplied rev2 manifest,** which carries the recorded exceptions: AC-R3.3 positive case.
6. **No-rank control:** AC-R3.3 negative control.
7. **Draft covering FX-COPY-ACCEPT:** AC-R3.4.
8. **Audit with changelog:** AC-R4.1 to R4.5 and AC-B-precision.
9. **Audit without changelog:** AC-R4.5 negative control.
10. **Slice A Draft reruns:** the six fixture Epics. The Reviews and the no-Jira control are not rerun.

**Structural checks** never rerun and must pass on every attempt: S1 to S4 unchanged, plus a new **S5**. S5 checks that the sibling read covers descriptions and children only, never grandchildren.

**Mechanical checks** parse the output and compare it against `cases.yaml`:
- **AC-R3.1:** `consolidation.status`.
- **AC-R3.3:** `order.source` and `order.value`, each exception against the supplied manifest, and unmatched later-to-earlier edges flagged.
- **AC-R3.4:** a missing forward edge or misplaced acceptance, either one accepted.
- **AC-R4.1 to R4.4:** each finding's `check` and `ref` against the expected set, plus a `reject_text` for status names in the output outside quoted evidence.

**Negative controls** never rerun:
- the AC-R3.1 opt-out
- AC-R3.3 with no rank
- AC-R4.5 with history removed
- AC-B-precision, meaning no finding on any FX-FORWARD-OK edge

**Judged checks,** 2 of 3:
- **AC-R3.2:** the rationale is present and not generic.
- **AC-R4.5:** the classification and history match the ratified key.

**Checks that re-apply on the Slice A reruns:** S1 to S4, R0.1, R0.2, R1.1 (now including sibling children) and AC-A-regression. The other Slice A criteria keep their 1.5.0 gate results.

## 4. The C5a answer-key procedure

The answer key is a private file, one entry per link event, kept next to the fixture. Each entry records:
- the edge
- the deciding evidence: author role, whether a comment is present, and the time gap
- the expected classification
- the author and date the finding must cite

The maintainer ratifies it line by line before C5 writes any rule. The AC-R4.5 check looks up each expected edge in the key and requires an exact match on classification and citation. It never derives the ground truth itself.

## 5. Checker self-test mutants for the new checks

Doctor a copy of each run's first attempt so that a new check should fail, and confirm the checker catches it:
- violate each consolidation invariant
- change a finding's check or ref
- swap a classification or drop its citation
- insert a status name into the output
- insert a false FX-FORWARD-OK finding
- insert a grandchild read, for S5
