# Brief: plan shaping for workbreakdown Slice B

You are one role in `/flow-plan` for run `workbreakdown-slice-b`. Work read-only, and return your report as your final message. The coordinator writes it to `research/plan-<role>.md`.

## Public-safety rule (hard)

This repository is public. Your report must not contain:
- Jira keys from the private fixture (use the public `FX-*` case IDs)
- people's names, private repository names, company or project names
- absolute local paths

Refer to the private harness only as "the private release check".

## Approved inputs

- `definition.md` and `acceptance-criteria.md`, Slice B section: AC-R3.1 to R3.4, AC-R4.1 to R4.5, AC-B-precision
- `solution.md`: the approved design, maintainer decisions 1 to 9, and chunks C1, C2, C3, C4, C5a, C5 and R
- `research/*.md`: the solutioning role reports

## Planning decisions made in engagement (2026-09-24)

1. **Fixture.** A GET-only refresh captures Initiative rank and the sibling Epics' full children, frozen as a new `gate-b` snapshot. Slice A's `gate` snapshot is untouched.
2. **FX-EXCEPTIONS.** Its two edges come from tabletop draft items, not live Jira. The private release check supplies them as an approved manifest input carrying a `consolidation` block that records both exceptions. The skill must match them and flag any unrecorded later-to-earlier edge.
3. **One implementation run** covers C1 to C5 and R. It pauses at C5a for the maintainer to ratify the link-classification answer key.
4. **Release gate scope.** All Slice B cases, plus a rerun of the Slice A Draft runs, since every Draft now reads siblings. The Slice A Reviews and the no-Jira control are not rerun.
5. **Version.** The release is 1.6.0, a minor bump.

## Evidence inventory (what already exists)

- `skills/workbreakdown/SKILL.md`, `VERSION` (1.5.0) and `references/`:
  - `work-breakdown-sop.md`
  - `manifest-contract.md`
  - `jira-change-protocol.md`
  - `template-registry.yaml`
- `tests/workbreakdown/manifest-validator.rb`: the reference validator, which has `SCHEMA4_ROOT_KEYS` and `reject_unknown_keys`
- `tests/workbreakdown/workbreakdown-template-contract-test.rb`: the synthetic manifest tests and `expect_error`
- `tests/workbreakdown-contract-test.sh`: the `require_text` and `reject_text` prose pins
- `.flow/runs/workbreakdown-slice-a-completion/` (archived), whose `plan.md`, `validation-plan.md` and `validation-results.md` are the precedent for plan and step-gate shape:
  - per-step suite, `validate-skills`, install-test and Vale
  - named mutants, judged by exit code on a committed tree
  - a public-safety grep
- The private release check runs isolated headless Opus attempts. Its structural checks are S1 to S4. Judged checks use the 2-of-3 rerun rule, negative controls never rerun, and a checker self-test mutates real attempts. It lives outside this repository.

## Your role's question

See the dispatch prompt.
