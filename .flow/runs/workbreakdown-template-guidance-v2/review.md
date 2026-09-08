# Acceptance Review Record

Run: `workbreakdown-template-guidance-v2`. Reviewed 2026-09-08 against `requirements.md`, `acceptance-criteria.md`, `plan.md`, `solution.md`, and `validation-plan.md`.

Roles: `quality-reviewer` (requirement and structural fit), `test-engineer` (validation evidence), `security-reviewer` (Epic write-authorization boundary, invoked because schema 3 grants new mutation authority over live Jira). Orchestration validated at the acceptance stage. Every finding below was independently re-verified by the orchestrator against the files; findings that did not survive verification are recorded as corrected.

## Verdict

**Needs refinement.** No finding blocks the work as designed. The contract is coherent, the compatibility boundary holds, and the fail-closed Apply chain is intact. What is not yet true is that the evidence proves what the validation plan said it would prove, and three specification gaps let an Apply agent resolve an ambiguity permissively.

The change is already merged and released as repository v1.3.0. This review therefore reads as a defect list against shipped work, not as a gate on a pending merge.

## Findings

### Critical

1. **Five validator branches are never exercised.** `tests/workbreakdown/workbreakdown-v2-test.rb:82` (missing template asset), `:99` and `:218` (Spike variant mismatch), `:165` (unapproved description key), `:186` (Epic acceptance duplicates success measures). The suite has 29 `expect_error` cases and none targets these. Three of the five are named in `validation-plan.md` as required negative fixtures: invalid variants, undeclared sections, duplicated criteria. A branch that never fires is not proof; the hash-drift mutation check demonstrated the correct pattern and was not applied here.

2. **The conditional-render check tests itself.** `workbreakdown-v2-test.rb:473-482` builds a renderer inline, runs it over `fixtures/render-conditionals.yaml`, and asserts on its own output. No shipped template is read. It passes unchanged if every real template is broken. This is the failure mode `validation-plan.md` warned about, moved from string level to structure level. The adjacent check at `:484-487` reads the real `story-v2.md` and is sound.

3. **No v2 Task or Spike description is ever validated.** Registry and hash presence are checked, but `validate_description` key enforcement runs only for Epic v2 and Story v2. Acceptance criteria 12, 13, and 14 have no automated proof, and their only planned proof was manual checks 7 and 8, which were not run.

4. **Both Spike v2 templates require a key they cannot render.** `registry.yaml` lists `downstream_updates` in `required_keys` for `jira-spike-design-v2` and `jira-spike-investigation-v2`. Neither template has a matching section — design has Decision, Questions and constraints, Design artifact, Done when, References; investigation has Question, Evidence needed, Done when, Boundaries, References. An agent must invent a heading, which contradicts the preserve-section-order rule, or omit the key and fail the registry contract. Finding 3 is why nothing catches it. Either add the section to both templates and re-hash, or drop the key and let `done_when` carry it, as it already does.

### Important

5. **`review_evidence` has three incompatible homes.** `registry.yaml` registers it as a Story description conditional key; `story-v2.md:51` renders it as a description section, so an approved Apply writes reviewer evidence into the live Jira description; `fixtures/story-lifecycle.yaml:16` models it as a sibling of `description`. The manifest contract's closed payload set (summary, done_when, evidence, estimate, description) cannot carry it as a sibling at all, so the fixture's shape is not expressible in an approved manifest. Pick one home and make all three agree.

6. **The drift anchor has no provenance rule.** `manifest-contract.md:228` requires `expected_current.description_adf_sha256` and defines how to compute it, but never says it must be captured from live Jira *before* approval, nor that Apply must never compute, fill, or substitute it. A hex digest an Apply agent derives from the state it just read satisfies every stated rule, which makes the drift gate self-satisfying and silently overwrites a description a colleague changed after drafting. The format half of this is already enforced — see Corrected findings — but provenance is absent from both the contract and the harness.

7. **An absent live Epic description is undefined.** Nothing in the references defines the digest of a null or empty description, or says that live-absent against a declared `expected_current` is material drift. This is the likely shape of the first real Apply: a bare Epic at draft time, hand-written by someone before Apply runs. Readback then confirms the intended state and never reveals that a prior state was overwritten. Define a sentinel — the digest of `{"type":"doc","version":1,"content":[]}` — and make the empty/non-empty mismatch a rejection.

8. **`epic.disposition` closes its keys but not its values.** The contract enumerates allowed keys for the `existing` and `update` shapes and rejects unknown fields, but never states that the value must be exactly one of those two. `manifest-contract.md:144` reads as cardinality, not enumeration. The child section at `:238` has the closure pattern the Epic section lacks.

9. **Preservation is unprovable as specified.** `jira-change-protocol.md:71` asks Apply to project "every observable, mutable business field not authorized for change," with an exclusion list but no inclusion rule, then compares that projection to itself after the write. An agent that projects only `description` satisfies the comparison vacuously. Require the projection to enumerate the live Epic's editable field set minus the exclusions, and put the field count in the journal so a near-empty projection is visible.

10. **Link-direction calibration takes control input from live data.** `jira-change-protocol.md:64` requires verifying `Blocks` direction against "one known-good live link," and `:85` makes the live link authoritative, but nothing defines how a link becomes known-good. A reversed link already under the Epic can be selected as the reference and invert every link the Apply writes. This is the one place where untrusted live content steers behavior rather than merely being read.

11. **No key-to-section mapping exists.** The registry is declared the source of truth for required and conditional keys, but nothing states where each key renders, and several are non-obvious: `reviewers` and `checklist_coverage` are bullets inside `## Design artifact`; `out_of_scope` renders as `**Out:**` under `## Scope`; `supplemental_demonstration` is a bullet under `## Review evidence`. Add a `renders_in` field per key, or a mapping table.

12. **Release notes are empty for this work.** `validation-plan.md` includes a changelog review item. v1.2.0 published a Features section naming its commit; v1.3.0 and v1.3.1 published nothing. `4324cc5` appears in no changelog entry or release body, so the release record for the entire v2 change is blank. A suspicious detail is that `release.config.cjs` uses an `effect` key in `presetConfig.types` where `conventional-changelog-conventionalcommits` expects `hidden`, but the same config produced correct notes for v1.2.0, so this needs its own investigation rather than a guess.

### Suggestions

- Flip each of the five dead branches with a deliberate-break fixture, following the hash-drift pattern already in the suite.
- Convert manual checks 1, 2, 3, 7, and 8 to fixtures. They test static structural properties, not live-agent judgment, and the harness already automates the equivalent for Epics and Stories. Checks 4, 5, 6, 9, and 10 need a live agent or live Jira and are legitimately deferred.
- Add `LC_ALL=C` as a second CI locale. The defect fixed in v1.3.1 escaped every reviewer and the whole suite because all of them ran in a UTF-8 shell.
- Prohibit Epic comments, attachments, watchers, and worklogs explicitly. They are currently unmentioned, and unmentioned is not prohibited.
- Nothing stops a *new* manifest from declaring `template_set.version: 1`. v2-as-default is advisory; validation only grandfathers.

## Disposition of findings

Addressed on 2026-09-08 on branch `claude/review-findings-v2`. Every change was re-verified in the default locale and under `LC_ALL=C`.

| Finding | Disposition |
| --- | --- |
| 1 Five dead validator branches | Fixed. All five now have negative fixtures: missing template asset, default Spike variant mismatch, unapproved description key, Epic acceptance duplicating a success measure, and child Spike variant mismatch. `expect_error` fails when nothing raises, so each branch is proven to fire. |
| 2 Self-referential render check | Fixed. The inline renderer and its fixture are gone. Every v2 template is now read from disk and each declared key must have a render target, with a `RENDER_EXCEPTIONS` map mirroring the new table in `jira-description-templates.md`. Mutation-checked: removing the new Spike section, with all three hash sites realigned so drift could not mask it, produced the expected failure. |
| 3 No v2 Task or Spike description coverage | Fixed. `fixtures/schema2-v2-children.yaml` carries Task v2, design Spike v2, and investigation Spike v2 children with full descriptions, each exercised for missing required keys and undeclared keys. |
| 4 Spike v2 required a key with no render target | Fixed. `## Downstream updates` added to both Spike v2 templates, absorbing the duplicated Done-when bullet. Registry hashes updated; a stale copy of the old hash in `manifest-contract.md` was also corrected. |
| 5 `review_evidence` in three homes | Fixed. It now lives inside `description`, matching the registry and the template. The fixture and validator were repointed. |
| 6 Drift anchor had no provenance rule | Fixed in contract text: 64 lowercase hex required, captured from live Jira before approval, and Apply never computes, fills, refreshes, or substitutes it. Both placeholder examples replaced with a real digest. |
| 7 Absent live Epic description undefined | Fixed. The empty-document digest is now the defined sentinel, and either direction of mismatch is material drift producing zero writes. |
| 8 `epic.disposition` values not enumerated | Fixed. Must be exactly `existing` or `update`; any other value is rejected rather than interpreted. |
| 9 Preservation projection unprovable | Fixed. The projection must be built by enumerating the live editable field set minus authorized and server-managed fields, the field count goes in the journal, and readback compares counts. |
| 10 Link calibration steered by live data | Fixed. A link is known-good only on user confirmation or agreement across two independent live links; otherwise stop and ask. |
| 11 No key-to-section mapping | Fixed. `jira-description-templates.md` gained a Key rendering section with the default rule and a table of every exception. The test's `RENDER_EXCEPTIONS` map must agree with it. |
| 12 Empty release notes | Fixed on the second attempt. The first diagnosis was wrong: `5140bab`'s `effect` key was already in place when v1.2.0 was released, so it could not explain the regression. v1.4.0 published empty notes and disproved it. A local `semantic-release --dry-run` isolated the real cause: `conventional-changelog-conventionalcommits@10.3.0`, the version pinned in `release.yml`, is incompatible with semantic-release 25.0.9 and yields an empty body with no error. Versions 8.0.0 and 9.1.0 both render correctly with the config unchanged; the pin moved to 9.1.0. The `hidden` key was kept because it is the documented option, but it fixed nothing. Note also that this repository never had a working baseline: the v1.2.0 Features section was hand-written in `3be9dee`, which is what made the first diagnosis look plausible. |
| Suggestion: C-locale CI | Done. `ci.yml` runs the contract suite a second time under `LC_ALL=C LANG=C`. |
| Suggestion: prohibit non-field Epic writes | Done. Comments, attachments, watchers, worklogs, and labels are now named prohibitions. |
| Suggestion: neutralize echoed untrusted text | Done. Live Jira text renders as quoted data in Audit tables, drift reports, and journals. |
| Suggestion: convert manual checks | Partial. Static parts of checks 1, 2, 7, and 8 are now fixtures. The judgment halves still need a live agent. |
| Suggestion: enforce v2 for new manifests | Resolved by user decision on 2026-09-08: apply the v2 content bar to every template set. Grandfathering now covers the frozen template asset and its declared key set only, never content. `validate_quality` runs on every description, and v1-bound descriptions are rejected for placeholders, `N/A`/`None` filler, and generic evidence, while still being limited to the keys their own registry entry declares. A v1 Story cannot express the v2 evidence keys, so its documentation and automated-test obligations stay Review and Audit lifecycle judgments; scenario-ID uniqueness is enforced structurally for both sets. Skill version bumped to 1.3.0 because existing v1-bound manifests that previously validated can now be rejected. |

Not addressed, and deliberately so: the residual risks below. They need a live Jira Apply in an isolated project, which was not authorized.

## Corrected findings

Recorded because they were reported and did not survive verification.

- The security review's lead finding held that nothing enforces the digest's format, so the contract's own placeholder examples would validate. The harness does enforce it: `workbreakdown-v2-test.rb:264` requires `/\A[0-9a-f]{64}\z/`, and a direct probe rejected the contract's `<normalized-live-adf-digest>` token, an empty string, and non-hex junk. The error message reads "missing current ADF digest" for what is actually a format failure, which is what made the rule easy to miss. What survives is narrower and still real: the rule lives only in a test, the shipped skill contains no executable validator, and `manifest-contract.md:160` and `:199` still show a placeholder in both canonical examples. Recorded as finding 6, provenance only.

## Requirement fit

Fifteen of seventeen acceptance criteria are met in the specification. Criterion 2 (no repeated facts) is partially met — placeholders, `N/A`, and literal generic strings are machine-checked, but "do not repeat the same fact" and "every sentence must help" are prose an agent satisfies by paraphrase, and the Epic duplication check is exact-string and defeated by rewording. Criterion 13 (design-Spike field set) is partially met, blocked by finding 4.

Criteria 12, 13, and 14 have no automated proof at all. Criterion 17 (checks pass) is verified: the full suite passes, and CI is green on `ubuntu-latest` and `macos-latest`.

Verified directly by the orchestrator, closing gaps the roles could not reach without a shell:

- All four v1 templates are byte-identical to their pre-rename originals at tag `v1.2.0`, and their SHA-256 values match the registry.
- No Atlassian URLs, internal Jira keys, Confluence links, or credential patterns anywhere in `skills/` or `shared/`.
- v1 templates carried forced placeholder cells — epic 3, story 2, task 1. The v2 templates carry none. The anti-bloat mechanism is real, not aspirational.
- Version 1.2.0 is consistent across the SKILL.md frontmatter, the skill body, `VERSION`, and the manual tests.

## Validation fit

The suite is a genuine improvement on the text-presence checks it replaced, and the parts that are structural are good: schema-2 containment is defended in three places and exercised by a real coaxing fixture; schema-3 verify and update paths, forbidden fields, preflight drift, omitted-field preservation, ADF comparison, and partial failure all have real assertions; Story documentation and test-mapping coverage is thorough, including exactly-once scenario coverage.

The gap is that the skill ships no executable code — `VERSION` is the only non-Markdown, non-YAML file — so every structural assertion runs against a Ruby reimplementation of the intended contract. That proves the specification is self-consistent. It does not prove an agent following `SKILL.md` produces conforming output. Only the manual checks close that gap, and none were run. The acceptance record should say this plainly rather than let "automated checks pass" stand in for behavioral proof.

## Residual risks

The Epic write boundary is specification-only. Live Apply was never executed and no isolated project was authorized, so none of this has been observed: that a real Atlassian ADF round-trip is digest-stable under the stated normalization; that the preservation projection is constructible from a real Epic's field payload; that a genuine drift case produces zero writes rather than a partial write; that a bare Epic behaves as finding 7 predicts.

Recommendation: before this authority touches a real Epic, run a first Apply in an isolated project against both a bare and a populated Epic, with a deliberately induced drift case.

## Process note

This run reached `handback_ready` and then the implementing session hit a usage limit. Work continued outside the lane: the two commits were pushed, repository releases v1.3.0 and v1.3.1 were cut, and PR #9 was merged, all before any review was recorded. `HANDOFF.md` still states "Remote push and release: not performed," and `validation-results.md` records a passing check for a test file that has since changed. Both should be corrected before archive.

## Planning review record

Retained from the shaping phase: business analysis, product scope, architecture, lead development, test strategy, and quality review shaped and checked this work. Implementation findings were corrected and independently re-reviewed. Quality and architecture returned PASS. Jira and Confluence were not changed.
