# Humanizer policy

Use this policy after [the humanizer entry point](../SKILL.md) resolves writing mode, operation, and validation intensity. This policy applies to the artifact being edited or audited. Shared output discipline still applies to the response around that artifact.

## Non-negotiable protections

Both modes preserve true facts, sourcing, uncertainty, technical behavior, obligations, and the author's intended level of certainty. Keep quotes, citations, commands, identifiers, paths, flags, code, configuration, API and parameter tables, and exact source material unchanged unless the user explicitly authorizes a change.

Correct a claim only when reliable task evidence supports the correction. Disclose a material correction in the change notes. Do not invent facts, examples, evidence, certainty, opinions, enthusiasm, or a reference voice. Split sentences rather than removing a caveat. Copy repository terms exactly and use one term for one concept.

Do not resolve ambiguous source prose by guessing an actor, object, cause, mechanism, or relationship. If a clause cannot be restated without deciding one of those facts, remove it from the rewrite. When an omitted clause is a material operational step, quote the exact source span in a concise clarification line and ask for the missing fact. Do not turn an unclear answer into a claim about producing, causing, or locating something. Do not ask the user to confirm an invented reading.

Do not add modality or status that the source does not support. This includes an expectation, intention, requirement, confirmation, or likelihood. Preserve the source's stated certainty or identify the unknown.

Do not promote an author preference, observation, wish, or personal habit into an operational requirement, condition, guarantee, or instruction. If a procedure needs such a requirement but the source only gives a preference, remove it or identify the missing requirement without inventing it.

## Policy matrix

| Decision | Engineering | Personal |
| --- | --- | --- |
| Selection | Default. Also required for operational, reference, checklist, and procedure artifacts. | Explicit user request only. Genre, first-person prose, and a generic naturalness request do not select it. |
| Editing goal | Full rewrite when needed to make the writing direct, grounded, and technically safe. Rebuild weak sentence architecture. | Minimum effective edit. Change a span only for an identifiable defect or the requested objective. |
| Voice | Use experienced engineering-leader voice after technical safeguards and construction rules pass. | Preserve effective cadence, humor, opinions, admissions, useful digressions, idioms, and intentional roughness. The submitted draft is the voice source; a sample is optional. |
| Construction sweep | A matched defective construction is rewritten unless a named technical protection applies. | Diagnose every class. Rewrite only when the construction harms meaning, creates ambiguity, repeats needlessly, adds unsupported emphasis, or conflicts with the request. Form alone is not a defect. |
| Procedures and reference text | Use STE-inspired discipline throughout the artifact: plain verbs, one instruction per step, no idioms, and numbers when known. | A substantive procedure or reference artifact uses engineering policy. Protected incidental commands or lists inside a personal narrative remain exact without changing the surrounding personal policy. |
| Strict mechanical checks | Applicable engineering checks may block completion. | Only applicable personal candidates are advisory. Engineering-only findings never mandate a voice change. |

## Engineering policy

Use engineering mode for technical writing, case studies, messages, issue descriptions, emails, specifications, checklists, documentation, arguments, analyses, and mixed engineering documents.

Rebuild weak sentences and paragraphs. Do not substitute a few corporate words and leave the same architecture. Apply STE-inspired discipline, the deletion test, portability diagnostic, final gates, and the guardrails below.

Choose a pronoun posture and hold it: second person for reader instructions, first-person plural for shared practice, and first-person singular only for authorship or error ownership. Do not switch posture merely for rhythm.

Keep an authored action or error ownership when it carries technical information. Remove a wish, mood, or preference with no technical information. Do not convert it into an operational instruction.

### Purpose branches

**Reference, checklist, or standard:** State the requirement or action. Cut rationale from body items. Start most bullets with verbs. Use one instruction per step and one term for one thing. Keep the named target of each operational action and its source condition; a shorter instruction must identify the same target unambiguously. Use plain verbs: `disable`, not `turn off`; `configure`, not `set up`; `perform`, not `carry out`. Avoid idioms and conversational asides. Use numbers rather than vague adjectives when known.

**Argument or analysis:** Keep the conclusion, evidence, tradeoffs, constraints, and consequences visible. Remove filler without removing reasoning.

**Mixed:** Apply the appropriate branch by section. If a section directs operational work, use engineering discipline across the artifact so a reader does not switch registers halfway through.

### Engineering construction sweep

Check these classes separately, in this order:

1. mirrored rhythm
2. stance sentences
3. stance headings
4. author-state narration
5. signpost nominalization
6. decorative contrast
7. free-relative antithesis
8. rule-of-three or escalating enumeration
9. aphoristic close
10. em-dash appositive

Use `pattern-classes.md` for class definitions. Remove a construction unless changing it would damage quoted text, identifiers, commands, source structure, a `DO` / `DO NOT` pair, repeated evidence markers, or a comparison where different values require different handling. When retaining a pattern, be able to name the technical meaning that plain prose would lose.

For author-state narration, make the subject the finding, correction, limit, or unknown. Do not retain `I concluded` or substitute a new first-person conclusion. State the finding only when the source identifies it. For mirrored rhythm, map each clause’s subject and relationship before rewriting. Remove the form without deciding an unclear referent or adding a causal claim.

Also check subordinate clauses attached to most main clauses, comma triads that hide separate actions, nominalized states, abstract process nouns for human events, term drift, vague attribution, corporate filler, and hedging that obscures the actual uncertainty.

### Engineering final gates

- Each paragraph is about the work, not the author, agent, review, or writing process.
- Each sentence carries a fact, decision, constraint, risk, fix, or necessary transition.
- Use working headings such as `Summary`, `Problems to fix`, `Risks`, `Unknowns`, and `What to watch`.
- Remove preambles, method narration, praise sandwiches, generic recaps, self-congratulation, and decorative certainty.
- Attach uncertainty to the unknown rather than the writer's feeling about it.
- Preserve technical caveats and one name per concept.

### Engineering guardrails

**Rant boundary:** State behavior and artifacts, not frustration with people. Do not make the author a wronged character.

**Over-editing:** Keep the core message, sourcing, constraints, tradeoffs, and technical accuracy. Preserve a source belief or expectation when it explains a later correction; do not replace it with only the corrected observation. A direct result still needs to be substantive.

## Personal policy

Use personal mode only after explicit selection. The goal is to preserve the draft’s useful character while removing a real reader problem.

Name source traits that carry voice: for example, humor, an admission, cadence, a useful digression, a firm opinion, or intentional roughness. Change only spans with a concrete reason: ambiguity, unnecessary repetition, unsupported emphasis, a missing needed transition, a factual conflict, or a direct conflict with the user’s requested objective. Restore any effective source sentence or progression that a local edit disturbed.

First-person narration, rhetorical questions, idioms, colon reveals, trailing analysis, formatted emphasis, and deliberate cadence can remain. Do not manufacture personality or smooth intentional roughness merely because it differs from engineering prose.

Remove an exact or near-exact duplicate when it adds no fact, progression, or identifiable deliberate effect. Minimum effective editing does not mean retaining an accidental repeat.

Before preserving personal prose, compare repeated sentences and clauses. Remove an accidental duplicate before deciding that the artifact needs no edits.

### Personal construction diagnosis

Check each class across the artifact. These cues identify a construction to evaluate, not a reason to rewrite it. For each match, ask whether it obscures meaning, repeats without effect, adds unsupported emphasis, or impedes the reader. Keep a clear source-grounded use that carries voice.

1. **Mirrored rhythm:** neighboring clauses or sentences repeat a shape for contrast or emphasis.
2. **Stance sentences:** a sentence tells the reader how to weigh the next point instead of making it.
3. **Stance headings:** a heading frames the author's attitude instead of locating the content.
4. **Author-state narration:** the author reports their own thinking, discovery, or change of mind.
5. **Signpost nominalization:** an abstract label announces the next idea instead of stating it.
6. **Decorative contrast:** a tidy `not X, but Y` form supplies polish without a needed distinction.
7. **Free-relative antithesis:** contrasting `what` clauses hide the actual relationship.
8. **Rule-of-three or escalating enumeration:** a three-part list climbs in intensity or abstraction.
9. **Aphoristic close:** a memorable final sentence restates the section without adding meaning.
10. **Em-dash appositive:** a dash adds an aside or label that may interrupt the thought.

A matched class may still belong in a personal draft. Judge its effect in the local passage and preserve a deliberate cadence, admission, joke, or useful aside when the reader can follow it.

### Personal final gates

- Every changed span has a concrete editing reason and retains the source’s relevant voice trait.
- The result preserves facts, uncertainty, protected material, and the author’s progression.
- A construction is changed only for reader impact, not because it matches a class name.
- Do not introduce a new opinion, example, certainty, enthusiasm, joke, or reference voice.
- Do not report an engineering-oriented lint candidate as a mandatory personal change or as a passed check when it did not apply.

## Deletion and portability diagnostics

Run both diagnostics in context. They diagnose prose; they do not authorize blind cuts.

**Deletion test:** Remove a sentence. Cut it when no fact, decision, constraint, risk, necessary transition, or intentional personal effect disappears. In personal mode, a useful digression, joke, admission, or cadence can be an intentional effect.

**Portability diagnostic:** Ask whether the sentence could describe almost any subject without change. Flag it only when it adds no supported content in context. Keep useful abstractions, necessary transitions, supported conclusions, and protected material.

- Weak: `This approach creates a better outcome for everyone.`
- Keep when supported: `The timeout belongs in the worker because the API has no cancellation endpoint.`
- Keep when necessary: `That constraint changes the rollout order.`

## Targeted pattern context

Diagnose form in context. These examples show why a match is not a verdict in personal mode.

| Pattern | Repair when it does harm | Keep when it carries meaning or voice |
| --- | --- | --- |
| Colon reveal | `The lesson is clear: we need to do better.` hides the actual lesson. State it. | `The result surprised me: the old note had the answer.` can retain a personal discovery beat. |
| Colon list | `The plan has three benefits: speed, safety, and alignment.` substitutes labels for evidence. State the concrete benefit. | `I brought three things: gloves, a flashlight, and the bad map.` can retain a natural personal list. |
| Trailing `-ing` analysis | `The build failed, showing that release discipline matters.` adds unsupported emphasis. State evidence or remove it. | `I stood in the rain, wondering whether the letter had arrived.` can retain reflection. |
| Formatting | Bold every claim or use headings as a performance of rigor. | Evaluate each emphasis span in its own sentence and local context. Preserve a useful single-word focus, quotation layout, or short personal aside. Do not use distant emphasis to condemn it. |
| Mirrored rhetoric | `It is not a feature. It is a movement.` replaces content with polish. | Personal mode can retain a clear, source-grounded rhetorical line when it is not misleading or repetitive. |

## Final response gate

Return the requested artifact first. Do not preface it with the selected mode, policy, compliance result, method, or an explanation of why it changed or stayed unchanged.

When an edit leaves the artifact unchanged, return the source artifact only. Do not append `no changes`, a preservation rationale, or a method walkthrough. When it changes, return the artifact only unless an evidence-supported correction or unavailable validation affects the result. You can quote an unresolved source span unchanged and ask for its exact missing fact. In a limited-span task, report an outside-span repair only when it corrects duplication, a dangling reference, or inconsistent pronouns. Do not add policy selection, compliance, completed-check, or protected-span reports.

For an audit, return findings only. A clean audit says `No actionable findings.` Do not append a retained draft, replacement draft, source recap, or an explanation of the audit method. Keep response framing distinct from source voice: apply shared output discipline to the response around the artifact without rewriting a personal source into engineering voice.

## Audit policy

Audit follows the recorded effective mode and purpose rules. Run that mode's sweep before a clean verdict. Do not edit the artifact or supply a replacement draft.

Report actionable findings only. Give the location or quoted span, the specific pattern or omission, reader consequence, and repair direction. Any repair direction or replacement wording must preserve the source facts and uncertainty. If the source is ambiguous, request the missing fact instead of supplying a possible interpretation. In personal mode, explain why the construction causes a reader problem; do not cite its form alone. For a missing item, identify the passage and what information it lacks without fabricating source wording. Do not append a keep-list, optional improvement, or other non-actionable advice.

If no finding is justified, say so plainly. Do not infer AI authorship or provide probabilities, scores, or a rewrite.

## Strict validation

Strict mode includes all semantic checks above. It adds an available, applicable mechanical check but does not replace editorial judgment.

- Engineering uses the engineering profile when a file target and repository wrapper are available.
- Personal uses only the personal profile’s narrow advisory candidates. A candidate can prompt review but cannot force an edit that violates this policy.
- An unavailable wrapper, Vale executable, configuration, or applicable check remains unavailable or inapplicable. Do not call it passed.
- A wrapper, configuration, or tool failure is an execution failure, not an editorial finding. Complete manual semantic validation when possible and state the relevant limitation accurately.

## STE-inspired discipline

Use these rules for engineering prose as a pressure system, without claiming ASD-STE100 compliance. Use short active sentences and one claim or instruction per sentence. Use one term for one thing, plain verbs, and numbers when known. Do not use idioms or punchlines in procedures or reference material. Do not describe output as STE-conformant.
