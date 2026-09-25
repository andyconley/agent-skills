# Humanizer engineering and personal modes — draft

Status: discovery and role review in progress; not approved. Owner/approver: Andy Conley.

## Problem and audience
Humanizer 4.7.0 targets engineering prose. Its global STE and construction priorities conflict with preserving personal cadence; some texture examples also conflict with its final gates. Users need predictable editing of engineering documents and personal prose without inventing content or damaging technical meaning.

## Confirmed outcome
Engineering remains the default. An explicitly requested personal mode preserves the draft's voice with the minimum effective edit. Preserve technical truth in both modes.

## Proposed requirements
R1. Preserve engineering rules: construction-class sweeps in normal and strict operation, technical exceptions, term consistency, procedure and reference protections.
R2. Personal mode permits useful humor, cadence, opinions, admissions and digressions already present. Do not manufacture personality, anecdotes or opinions. Leave effective source sentences alone. Optional author sample is supporting context, not a prerequisite.
R3. Define how mode interacts with edit versus audit and normal versus strict validation. Strict validation must enforce the selected mode instead of silently converting personal writing to engineering voice.
R4. Audit quotes source spans, names patterns, and gives brief proposed fixes without rewriting, numerical scoring or authorship inference. A clean audit reports no findings.
R5. Use a portability test alongside the deletion test. Generic-looking necessary transitions and exact technical statements are not automatically defects. Add clear examples for colon reveals, empty trailing analysis and decorative formatting, with legitimate counterexamples.
R6. Reconcile conflicting examples and consolidate the execution order. All guidance and examples must agree with the chosen mode's priorities.
R7. Changes to shared guidance must preserve doc-flow-review behavior. Scope personal exceptions to the edited artifact; agent commentary retains concise shared output discipline.
R8. A personal narrative containing protected text must preserve that text and technical meaning. Proposed boundary: actual operational/reference documents retain engineering requirements; incidental embedded quotes, commands or lists alone do not erase personal mode. Exact boundary awaits review.

## Success and proof
Use paired engineering/personal cases, clean-text preservation cases, mixed technical content, audit-only and strict-personal cases. Evaluate observable facts and preservation of source traits rather than an AI-likelihood score or word-count target. Include both positive and negative examples so rules can fail on overediting and underediting. Existing engineering and doc-flow-review fixtures must remain applicable.

## Non-goals
AI authorship detection; generic voice impersonation; automatic mode selection; standalone STE mode or compliance; changes to doc-flow-review scope; copying the external blacklist wholesale; rewriting existing user documents; implementation or installation during definition.

## Evidence and precedent
See brief.md. Research question: which candidate additions address an observed contract gap, and where can personal voice coexist with engineering protections? Existing source and the already-read no-ai-slop primary files suffice for initial definition. No comparative output benchmark exists; quality improvement is a hypothesis requiring behavioral validation.
Manual prior requirements establish engineering STE and mixed-document strictest-wins. Retain those for engineering. Proposed supersession: personal artifact prose gets a bounded exception for voice-bearing constructions/idioms; engineer must approve the exception with final requirements. Generic AI detector non-goal remains unchanged; audit detects constructions only.
Archive search selection 8933967ee514ad5aeb48ab0568087a69e70acf580ad85a92ce2f34a2475e2a6e was unavailable (missing source identities). No ranked hits. Prior requirements were manually inspected outside the selection. flow doctor confirms archive coverage unknown and project manifest missing; no archive backfill requested.

## Remaining decisions
Role-review findings and mode boundary dispositions; engineer approval of complete requirements. Detect operation and additional checks are proposed, not separately confirmed.

## Artifact and model advice
Durable artifacts under this run are appropriate because two modes intersect shared rules, prior requirements, linting and behavioral validation.
Coordinator recommendation: judgment, gpt-5.6-sol/high, provisional because account availability is unverified; mode precedence requires judgment. Active parent: unknown per flow model context. No switch performed.
