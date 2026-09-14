## Review Summary

**Verdict:** REQUEST CHANGES

**Overview:** The implementation has a coherent two-mode contract, preserves the existing doc-flow boundary, and passes the current static suite. The frozen live evidence contains two material Claude failures in default engineering behavior, and one candidate case loaded the installed 4.7 skill instead of the worktree candidate. The implementation is not ready for acceptance at hashes `a11a2b99...` and `99a1e0e2...`.

### Critical Issues

- None.

### Important Issues

- [.flow/runs/20260911-humanizer-modes/validation/raw/candidate-closed/claude/journal-default/output.md:1] The unqualified journal audit returns `No actionable findings` even though engineering is the default and the fixture deliberately contains the unprotected mirrored closing `It kept going, and so did I.` This misses the required same-construction/different-mode behavior in acceptance criteria 3 and the explicit oracle at [tests/fixtures/humanizer/cases.json:314]. Make the engineering construction sweep binding for an unqualified memoir or journal audit, then rerun both `journal-default` and the paired personal cases to show that genre alone does not select personal.
- [.flow/runs/20260911-humanizer-modes/validation/raw/candidate-regression/claude/regression-word-choice/output.md:6] The legacy runbook regression invents that the unnamed six-month item is a cache, turns the ambiguous fragment into a new cache-expiry/rebuild instruction, changes the source's `job`/`task` terms without evidence they are interchangeable, and upgrades `pretty fast` to `fast`. This violates truth, uncertainty, and one-name-per-concept protections in requirements R1/R4 and the ambiguity rule at [skills/humanizer/references/policy.md:11]. The final design must preserve or explicitly surface the unresolved referent and uncertainty instead of completing them. Rerun the complete legacy regression batch after the fix, not only this single case.
- [.flow/runs/20260911-humanizer-modes/validation/raw/candidate-closed/claude/protection-engineering/events.jsonl:7] This candidate check invoked Claude's native `humanizer` skill and loaded installed version 4.7 from `~/.claude/skills/humanizer`; it never read the requested 4.8 worktree entry or policy. Its output is invalid evidence about the candidate, rather than a demonstrated candidate defect. Prevent native skill lookup during pre-install worktree checks, assert that every run read the expected entry and required policy, and rerun this case before acceptance. Keep native skill invocation enabled for the separate post-install check.

### Suggestions

- [.flow/runs/20260911-humanizer-modes/validation/raw/candidate-closed/claude/portability/output.md:7] The correct audit findings are followed by a non-actionable `Not flagged` keep-list, contrary to the audit response contract. Treat this as a lower-priority framing deviation because it does not alter the diagnosis or protected text, but retain it in residual-risk evidence.
- [.flow/runs/20260911-humanizer-modes/validation/raw/candidate-closed/claude/strict-restricted/output.md:3] The required limitation is accurate, but the sentence also reports routine editorial work and the duplicate removal. This is minor method narration rather than a semantic failure.
- [.flow/runs/20260911-humanizer-modes/validation/mechanical.md:1] Regenerate the durable mechanical record after the source is final. The checked-in record still says 22 fixtures, while the current fixture suite validates 27.

### What's Done Well

- [skills/humanizer/SKILL.md:20] Request resolution separates protected content, artifact purpose, mode, operation, and validation intensity. Engineering remains the default, while operational/reference purpose can override a personal request without allowing an incidental command to reclassify a narrative.
- [skills/humanizer/SKILL.md:41] Edit and audit output contracts are concise and distinguish supported correction or validation-limit notes from routine process reporting.
- [skills/humanizer/references/policy.md:17] The policy matrix makes engineering and personal dispositions directly comparable. The personal policy uses identifiable reader impact and minimum effective edits while retaining humor, admission, cadence, and intentional roughness.
- [scripts/lint-prose.sh:65] The wrapper provides repository, engineering, and personal profiles and preserves the existing bare-target engineering shorthand used by doc-flow-review. The argument tests cover space-containing and dash-leading targets as well as routing mutations.
- [tests/fixtures/humanizer/cases.json:1] The 27 fixtures now cover groups A-F and compatibility, include paired engineering/personal sources, identify protected spans and retained traits, and distinguish explicitly accidental repetition from potentially intentional cadence.
- Live Codex results at the frozen hashes pass the reviewed candidate-closed cases. Both runtimes preserve the unchanged doc-flow-review behavior in the five-case legacy regression batch.
- The change stays within the humanizer, lint wrapper, documentation, CI, and tests. Shared policy, doc-flow-review source, and existing regression sources remain unchanged.

### Verification Story

- Tests reviewed: yes. I reran `python3 tests/humanizer-fixture-test.py` (27 fixtures and two package-fault mutations), `tests/lint-prose-test.sh`, `scripts/validate-skills.sh` (3 skills), and `tests/install-test.sh` (18 checks); all passed. Earlier recorded shell syntax, workbreakdown tests in default and C locales, repository Vale lint, and `git diff --check` also passed. These checks validate structure and routing, not model judgment.
- Build/runtime checks reviewed: yes. I inspected all 16 candidate-closed outputs and all 10 legacy regression outputs. Fifteen candidate-closed runs and all regression runs read the expected worktree sources at entry hash `a11a2b9922f3ed1e2806d6df1801576fcf50b53ad6bd8fff23a8569f7769ee84` and policy hash `99a1e0e24b710499febb5c54fed0745178bf8268e2e4570e77fdea9015ee613a`; the Claude protection-engineering trace did not. Successful process status does not override the two substantive failures or the invalid load.
- Structural fit reviewed: yes. No new cross-skill dependency was introduced; the doc-flow strict and normal runs remain review-only. Commit-message review does not apply because this worktree has no implementation commit yet.
- Safety reviewed: yes. Auth, secrets, persistent data, migrations, and production operations do not apply. CI's pinned public Vale download is the only new external executable path observed.
- Remaining risks: Mode-specific rules are present in the written contract but are not applied consistently by one target runtime. Repeated additions to a long prose policy have not closed that execution gap. Release, canonical sync, installation, and post-install live checks must wait until the semantic failures are fixed and rerun on final hashes.
