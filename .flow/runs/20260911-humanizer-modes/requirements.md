# Humanizer engineering and personal modes

Status: approved by Andy Conley on 2026-09-12 at 03:38:21 UTC (September 11, 11:38:21 p.m. EDT). Definition run: 20260911-humanizer-modes.

## Problem and audience
Humanizer's engineering-first rules conflict with some of its own texture examples and can erase useful voice in personal prose. The author needs predictable rigorous engineering edits and an explicitly selected lighter personal edit. Maintainers need one coherent contract whose shared dependencies do not change doc-flow-review behavior accidentally.

## Confirmed outcome
Strengthen engineering writing and add personal writing. Engineering remains the default. Explicit personal requests preserve the draft's voice with minimum effective edits. The scope and complete requirements below are approved.

## Requirements
R1. Engineering mode retains the full-rewrite default, technical preservation, document-type branches, STE-inspired discipline, mandatory class-by-class construction sweeps in normal and strict operation, and protected technical exceptions.
R2. Personal mode is explicitly requested by name or a clear equivalent request for personal writing with minimal edits and voice preservation. Genre, first-person pronouns, or a generic request to make prose natural do not silently activate it. No new mandatory prompt syntax is required.
R3. Personal mode changes only spans with identifiable defects such as ambiguity, unnecessary repetition, unsupported emphasis, or conflict with the requested objective. Preserve effective source sentences, opinions, humor, cadence, useful digressions, and intentional roughness. Do not manufacture personality or introduce facts, examples, certainty, opinions, or enthusiasm. A writing sample is optional supporting evidence; use the submitted draft as the voice source and do not pause solely to request a sample.
R4. Truth, uncertainty, technical behavior, obligations and immutable content remain protected in both modes. Preserve quotes, citations, commands, identifiers and exact source material unless the user explicitly authorizes changing that material. Correct claims only with reliable task evidence and disclose material corrections.
R5. Personal mode still performs the construction sweep as diagnosis. A pattern match alone does not require an edit. Clear, source-grounded rhetorical constructions, idioms, first-person narration and cadence may remain when they carry voice and do not harm meaning. Engineering's technical-only exception policy remains unchanged.
R6. Writing mode, operation (edit or audit), and validation intensity (normal or strict) have distinct meanings. Strict personal validation enforces the personal contract and all preservation rules. Engineering-oriented lint findings cannot silently convert the draft to engineering voice. Describe actual validation limits accurately; do not claim that inapplicable or unavailable checks passed.
R7. Audit is explicitly selectable under either mode and defaults to engineering. It leaves the draft and source unchanged, reports exact spans or unambiguous locations, names the pattern and concrete reader consequence under the selected policy, and gives a short repair direction. Replacement wording is optional when a repair is supported. Do not return a replacement draft, scores or authorship probabilities. Report no findings when none are justified.
R8. Add a portability diagnostic alongside the deletion test. Evaluate the sentence in context; do not flag useful abstractions, transitions, supported conclusions or protected material merely because wording could occur elsewhere. Add positive and legitimate counterexamples for colon reveals, superficial trailing analysis and decorative formatting. Avoid blanket vocabulary bans.
R9. Reconcile contradictory texture examples and consolidate the execution sequence. Each example must specify the applicable mode/conditions. Mode precedence must be explicit rather than leaving later generic rules to override earlier exceptions.
R10. Personal exceptions govern the edited personal artifact, not generic agent commentary or doc-flow-review. Shared-file changes are permitted only if their scope preserves doc-flow-review's existing review-only behavior and mandatory output sweeps.
R11. An artifact is operational/reference when readers use any substantive section to execute, configure, verify, troubleshoot, comply with, or repeatedly retrieve instructions or requirements. Such artifacts retain engineering discipline, including existing whole-document mixed-reference rules. A personal narrative does not become an operational artifact merely because it quotes a command, contains a list, or mentions technical facts. Preserve such spans and their meaning. If a draft's actual purpose is ambiguous and the classification materially changes editing, ask one focused question; do not silently normalize the narrative or relax a procedure.
R12. Documentation, examples and behavioral validation must demonstrate default engineering edits, explicit personal edits, mode-aware audits, strict personal behavior and protected mixed content. Show actual before/after evidence on representative cases; do not present mechanical lint results as proof of voice quality.

## Success criteria
An author can obtain the three requested behaviors predictably: engineering edits by default, minimal personal edits explicitly, or an actionable audit without rewriting. Engineering safeguards and doc-flow-review behavior remain intact. Personal fixtures retain named source traits and clean spans while seeded reader problems are corrected. Quality claims remain limited to exercised cases.

## Non-goals
AI authorship detection or scoring; automatic personal-mode selection; personality simulation; mandatory reference samples; a separate STE mode or compliance claim; broad doc-flow-review redesign; rewriting user documents as part of this change; adopting an external blacklist wholesale. Definition does not authorize implementation, publication or installation.

## Constraints and assumptions
Canonical source is /Users/andyconley/Documents/agent-skills. Installed humanizer is a symlink to skills/humanizer. Reuse existing technical safeguards and regression approach. No benchmark demonstrates improved output yet. Source-voice intent is inferred from the supplied draft unless the author provides additional direction.

## Evidence and prior decisions
See research.md and brief.md. Archive retrieval was unavailable, not a no-match result. Manually inspected prior requirements are outside selection 8933967ee514ad5aeb48ab0568087a69e70acf580ad85a92ce2f34a2475e2a6e.
Approved precedent disposition: retain STE, strictest-wins mixed-reference rules and technical-only construction exceptions for engineering; supersede their universal application only for explicitly selected personal artifact prose under R3–R6 and R11. Keep shared commentary/doc-flow-review behavior and the no-generic-detector non-goal. Andy Conley explicitly approved this exception with these requirements.

## Model advice
Recommended coordinator profile: judgment, resolved gpt-5.6-sol/high; provisional because availability and active-parent match are unverified. Active parent unknown per flow model context. No switch performed.

## Approval and next work
Approved. The approve-definition CLI transition succeeded at 2026-09-12T03:38:21Z and recorded requirements, acceptance criteria and orchestration manifest. Adversarial review dispositions are recorded separately. Next lane: flow-solution to settle mode precedence, audit/strict composition and shared-validation boundaries. Solutioning and implementation have not started.
