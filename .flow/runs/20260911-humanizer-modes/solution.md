# Humanizer solution — accepted
Andy Conley accepted Option A in the conversation on September 12, 2026. Approved requirements remain unchanged. No implementation has occurred.

## Accepted decision
A: Keep artifact policy inside humanizer. A short SKILL.md entry point owns routing and one authoritative workflow; a required humanizer-local support file owns the policy matrix and mode-specific dispositions. Shared discipline remains the commentary/doc-flow-review contract. Do not create a general profile framework for other skills.

## Alternatives
A has medium implementation complexity, high reversibility and limited shared impact. Costs: explicit support-file loading/installation checks and local dispositions for shared construction names.
B parameterizes shared rules/gates across skills. Centralizes vocabulary and allows future reuse, but costs more, spreads precedence across consumers and increases doc-flow-review regression risk. Medium reversibility; no second personal-mode consumer currently needs it.
An inline-only humanizer branch is also possible, but leaves a long entry file and duplicated competing instructions; local support files improve readability only if loading is explicit and tested.
Reject one global Vale gate with ignored personal errors. It conflicts with engineering/error semantics and encourages untracked suppressions. Do not globally downgrade engineering errors.

## Policy flow
Explicit intent -> requested writing mode (engineering default) -> artifact purpose and protected spans -> effective writing policy -> edit/audit -> normal/strict validation -> applicable optional mechanical checks. Actual operational/reference content retains engineering policy. Incidental quotes/commands/lists do not convert a personal narrative. Semantic selection happens in the skill; Vale never classifies author intent, artifact purpose, truth or voice.

## Validation boundary
Repository documentation/engineering artifacts use applicable blocking engineering checks. Personal mechanical checks, if retained, are narrow advisory candidates and never force removal of source voice. If no suitable mechanical checks apply, record inapplicability honestly and perform semantic gates; do not call a skipped check passed. Intentional source/output fixtures are data with behavioral assertions, separate from governing documentation. Do not broadly exempt all docs or doc-flow-review fixtures.
Route local lint and CI through one profile/target mapping. Current CI invokes Vale directly, so wrapper-only implementation is insufficient. Keep no new model judge, remote evaluation service, authorship score or full-text output snapshots. Use fake-Vale tests for argument/config routing and failures, plus actual Vale checks for applicable profile behavior; neither proves editorial quality.
Six live constructed fixture groups: default engineering; minimal personal changes; same phrase under both modes; mode selection and mixed purpose; defective/clean audits; strict-personal availability plus portability and legitimate pattern counterexamples. Record exact protected spans and named voice traits to preserve, seeded defects to repair, input/output and observed outcomes. Constructed evidence cannot establish the user's personal voice satisfaction beyond exercised cases.

## Architecture and durability
Domain: humanizer artifact policy, shared response contract, optional lint adapter and behavior fixtures have distinct responsibilities.
Interfaces: resolve policy before lint; audit emits findings rather than edited artifact.
State: no new service, state store or migration; policy is versioned files.
Operations: same local/CI mapping; installed Codex/Claude support paths checked; missing tooling reported accurately.
Durability: reversible local policy boundary; run solution record is enough. Shared multi-skill redesign would warrant ADR.
Principles: architecture/Core principles (reversible boundaries), Domain and integration boundaries (do not let regex determine semantic policy), Evidence/Whether the evidence could have failed (positive/negative behavior cases). See role and engagement notes for provenance.

## Proposed mergeable work
1. Coherent local policy and engineering cleanup, with repaired engineering examples and regression evidence. No advertised personal path until its full contract works.
2. Complete personal and audit paths with constructed behavioral fixtures, supporting metadata/docs and installed support-file checks. Include mode-aware lint/CI handling needed to keep this slice valid; do not ship personal mode with engineering strict gates.
3. Remaining targeted pattern diagnostics, paired counterexamples, documentation and delivery evidence. Move any dependencies of earlier slices into those slices rather than deferring required proof.
Planning may combine 1 and 2 if splitting creates duplicate rules. No arbitrary split should leave an incoherent shipping skill.

## Risks and ownership
Implementation agent owns local/shared isolation and enforces unchanged doc-flow-review cases. Implementation agent owns unified lint/CI mapping and installed-path validation. Test engineer/reviewer owns falsifiable fixtures and scoped quality claims. Andy Conley owns final voice acceptance against constructed examples. These are proposed future assignment responsibilities, not dispatched implementation tasks.

## Status
Engineer accepted Option A. Core architect and requested test-engineer reviews complete. This document captures the accepted solution. approve-solution succeeded at 2026-09-12T04:47:51Z with risk=owned. Next lane: flow-plan. No planning or implementation has started.

## Model advice and evidence
Coordinator: judgment profile, gpt-5.6-sol/high, provisional; active parent unknown per Flow context. No switch performed. Delegated routing: solution-architect gpt-5.6-sol/medium; test-engineer gpt-5.6-terra/medium, per configured role declarations, not independently observed runtime identities.
Solution archive selection ea56bf9f42eef5537e10c0e10b137728a132143394759e0524391efcf9aecf6a unavailable; manually inspected evidence remains outside retrieval. See solution-engagement.md, solution-options-architect.md and solution-validation-review.md. Prior approved personal exception is retained. No additional supersession is introduced.

## Risk accountability
Andy Conley is the accountable owner of remaining delivery risks until planning assigns implementer and reviewer responsibilities. Shared-behavior drift: isolate local policy and run unchanged doc-flow-review fixtures. Lint divergence/false mandates: one local/CI mapping and advisory-only personal signals. Missing installed support file: verify Codex/Claude resolved paths. False confidence in voice quality: constructed live cases with retained spans and scoped claims. Planning must assign these checks to concrete execution roles.

## Artifact decision
This run-level solution plus approved requirements and acceptance criteria is sufficient. No ADR is needed for the reversible humanizer-local boundary. Exact support-file/config names and command syntax are planning decisions.
