# Test Evidence Review Brief

Review whether the test and runtime evidence can fail for every material Story-v3 acceptance obligation. Do not edit files. Identify missing positive, negative, compatibility, distribution, or host-behavior proof with file and line evidence. Distinguish required gaps from optional hardening.

## Evidence inventory

- Acceptance obligations are listed in `.flow/runs/workbreakdown-story-evidence-v3/acceptance-criteria.md:3-13`.
- The executable contract harness is `tests/workbreakdown/workbreakdown-template-contract-test.rb`, especially lines 82-111, 128-218, 322-430, and 689-879.
- Positive lifecycle fixtures are `tests/workbreakdown/fixtures/story-v3-lifecycle.yaml:1-42` and `story-v1-lifecycle.yaml:1-43`.
- Top-level and installer coverage exists in `tests/workbreakdown-contract-test.sh:1-82` and `tests/install-test.sh:45-59`.
- Manual host cases exist in `tests/manual/workbreakdown.md:5-107`.
- Prior results and the `observed_output` mutation check are recorded in `.flow/runs/workbreakdown-story-evidence-v3/validation-results.md:3-30`.
- Fresh Codex and Claude smoke sessions passed version discovery and the planning-versus-review gate after publication.
- Checked and genuinely absent: the full concise-v3 Draft prompt, legacy Story prompt, exception prompt, and controlled live Jira Apply prompt were not run in fresh hosts.
- Search method: read the acceptance criteria, changed test harness and fixtures, top-level checks, installer checks, manual prompts, and recorded validation results.

Assess proof strength and fault detection. Do not infer live Jira behavior from local contract tests.
