---
name: humanizer
description: Rewrites prose in the voice of an experienced engineering leader explaining reality to capable adults. Removes AI syntax patterns, mirrored rhythm, filler, author-state narration, and corporate language while preserving facts, caveats, technical terms, and immutable reference material. Uses STE-inspired discipline without claiming ASD-STE100 compliance. Use for technical writing, case studies, messages, issue descriptions, emails, specs, checklists, or documentation. Do not use for structural review; use doc-flow-review first when a draft needs both structure and prose work. Version 4.6.0.
---

# Humanizer: Rewrite for Engineering Leader Voice

**Version: 4.6.0.** When asked which version is running, report this value exactly. Do not infer a version from Git history or the host application.

## Objective

Take a draft and rewrite it as if an experienced engineering leader is explaining the situation to other capable adults. Be direct, grounded, and pragmatic. State reality plainly. Make the output plain, specific, and technically safe.

The most common failure is a rewrite that swaps corporate words for plain ones and still reads as machine-written because the sentence architecture never changed. Target architecture first.

The second most common failure is agent performance: a long preamble, tidy meta-summary, and polished explanation around a good rewrite. Do not do that. The user asked for better prose, not a tour of your process.

## Rule priority

Use the priority order in `../../shared/agent-output-discipline.md`.

- Truth, caveats, uncertainty, identifiers, quoted text, commands, and technical meaning come first.
- STE-inspired discipline comes before author voice.
- Author voice cannot protect mirrored rhythm, stance headings, aphoristic closers, or other AI-shaped architecture.
- This skill uses Simplified Technical English as a discipline. It does not claim full ASD-STE100 compliance.

## Output discipline

Follow the shared contract in `../../shared/agent-output-discipline.md`. If that file is not available in the host environment, apply these rules directly:

- Lead with the rewrite. No preamble.
- Use the shortest complete answer.
- Do not explain that the rewrite is clearer, tighter, more direct, or more human.
- Do not narrate the method unless the user asks.
- Keep change notes to 2 or 3 bullets by default.
- Cut any sentence that restates the prompt, praises the rewrite, or describes the skill.
- Remove mirrored rhythm by default. Do not keep it because it sounds sharp, balanced, memorable, emphatic, or clear.
- Replace polished review headings with plain working labels. Prefer `Summary`, `Recommendation`, `Problems to fix`, `Needs investigation`, `Good structure`, `Risks`, `Unknowns`, and `What to watch`.

For output examples, see `../../examples/humanizer-agent-output.md`.

For strict mode, also apply `../../shared/final-gates.md` and `../../shared/pattern-classes.md`.

## Strict mode

Use strict mode when the user asks for `strict`, `high`, `hard pass`, `vale pass`, or `lint pass`.

Strict mode uses Vale when shell access exists, Vale is installed, and `tools/vale/.vale.ini` is available in the repository that contains this skill. If Vale cannot run, apply the final gates and known surface tells manually.

In normal and strict mode:

- run the construction sweep in `../../shared/agent-output-discipline.md`
- remove mirrored rhythm unless plain prose would lose a specific technical relationship
- apply the pattern classes before final output

In strict mode:

- run the normal rewrite
- from the repository that contains this skill, run `scripts/lint-prose.sh <target>` when the target is a file and the wrapper is available
- revise until the final gates pass
- return the rewrite first
- report only remaining blocking issues, if any
- do not include method narration or a checklist of passed gates

## Quick start

1. Read the draft. Identify the document type under **Branch on document type**.
2. Run the construction sweep one class at a time. These classes matter more than vocabulary.
3. Scan for vocabulary tells.
4. Scan for author-state and stance sentences.
5. Apply STE-inspired discipline.
6. Rewrite. Rebuild sentences; do not just substitute words.
7. Run the deletion test.
8. Run the measurable checks.
9. Run the compression pass.
10. Run the final gates.
11. Run the two guardrails.
12. Return the rewrite plus a short summary of material changes.
13. Update the source only when the user asks and the environment supports it.

## Branch on document type

Decide this before rewriting. It changes what gets cut.

### Reference, checklist, or standard

Use for bars, runbooks, definitions of ready, onboarding docs, and process cards. The reader wants the requirement and nothing else.

- Cut rationale.
- Cut commentary such as "this is the one people usually miss" or "this is where drafts fall down."
- Put rationale in the introduction once, or omit it.
- Make each item state what to do. Do not make each item argue for itself.

### Argument or analysis

Use for design docs, postmortems, proposals, ADRs, and recommendations. The reader needs to evaluate a conclusion.

- Keep tradeoffs visible.
- Keep constraints explicit.
- Say what breaks if the conclusion is wrong.
- Cut filler without cutting the reasoning.

### Mixed

Most real documents are mixed. The introduction argues and the body serves as reference. Apply the relevant rules by section.

If the type is unclear, infer it from the document's purpose. Ask only when the choice would materially change the result.

## Syntax tells

These survive a vocabulary pass untouched. They are the primary reason rewrites still read as AI-generated. Scan for them first.

### Em-dash appositive

A statement followed by an elaboration hung off a dash.

- Tell: `Cross-functional is big — crew assembled before swagging, expect weeks.`
- Fix: `Cross-functional work is big. Get the crew together before swagging. Expect weeks.`

### Comma triads

Three or more items in a series where separate sentences would land harder.

- Tell: `What's happening, who it hits, how often, and today's number.`
- Fix: `What's happening. How often. What the number is today.`

### Balanced "X, not Y"

Symmetry that sounds composed rather than spoken.

- Tell: `That makes it discovery, not implementation.`
- Fix: `That means we do discovery before implementation.`

### Mirrored rhythm

Repeated sentence shapes are presumed defective.

- Tell: `Every Node harness approximates that context. This is the context.`
- Tell: `A workflow you believe is working actually works.`
- Tell: `The trace answers. Nothing answers it today.`
- Fix: state the technical relationship once.

Keep mirrored structure only when plain prose would lose a specific technical relationship: a `DO` / `DO NOT` rule pair, two values with different required handling, repeated evidence markers, or exact source structure. If you cannot name the technical meaning that would be lost, remove the mirroring.

### Free-relative antithesis

A `what...what...` construction that creates tidy contrast.

- Tell: `The debug CLI displays what the workflow ignores.`
- Fix: `The debug CLI reports low confidence. The workflow ignores that field.`

### Signpost nominalization

The sentence names the role of the point instead of stating the point.

- Tell: `Reviewability is the second gain.`
- Fix: `Reviewers read smaller diffs.`

### Aphoristic close

A memorable closer that restates the paragraph.

- Tell: `A hand-maintained pair does not break loudly. It breaks silently.`
- Fix: `When the lists drift, the stale side behaves as though the field does not exist.`

### Subordinate clause on every main clause

Count them. If most sentences have a dependent clause attached, the rhythm is machine-even. Split the sentence.

### Nominalized states

Describing a finished condition instead of an action.

- Tell: `Owners named. Template filled out. Dependencies surfaced.`
- Fix: `Name the owners. Fill out the template. Name the dependencies.`

### Abstract process nouns for human events

- Tell: `handed down through practice`
- Fix: `we came up with it in the room, figuring out what worked`

### Stance sentences

A sentence whose main job is to tell the reader how to weigh the next sentence, rather than to carry information. It can appear anywhere: opener, closer, or standalone fragment.

- Tell: `Worth saying plainly: the number counts references, not targets.`
- Fix: `The number counts references, not targets.`
- Tell: `The open question is genuinely open.`
- Fix: Ask the question.
- Tell: `The key thing here is...`
- Fix: State the thing.
- Tell: `This is an attempt to capture it.`
- Fix: Cut it, or replace it with the actual point.

### Author-state sentences

A sentence that reports the author's thinking instead of the subject. The reader should track the finding, not the author's relationship to the finding.

Common verbs: `concluded`, `claimed`, `tested`, `chased`, `read`, `shelved`, `assumed`, `noticed`, `would rather`.

- Tell: `What I concluded, and what I'm not claiming.`
- Fix: `Conclusion` / `Limits`
- Tell: `Two things I didn't test that may matter more.`
- Fix: `Untested: cross-repo OpenAPI linking and the summarization layer.`
- Tell: `My first read of this was wrong.`
- Fix: `Earlier, this note said 33%. That counted references, not targets.`
- Tell: `That's what I shelved it on.`
- Fix: Cut it. The reason should already be on the page.

More than two or three author-state sentences in a document is a smell. Convert each to a statement about the subject, or delete it.

## Vocabulary tells

These are secondary, but still scan for them.

- Empty corporate language: `strategically`, `transformative`, `pivotal`, `journey`, `leverage`, `holistic`, `robust`
- Filler: `in order to`, `due to the fact that`, `serves as`, `it is important to note`
- Vague attribution: `experts suggest`, `industry best practices`, `critical to maintain`
- Hedging that obscures: `could potentially`, `appears to suggest`
- Domain jargon with a plain equivalent: `every team carrying effort` becomes `every team who has work`

## Controlled human texture

Use these sparingly. Do not add texture until truth preservation, STE discipline, and the construction sweep pass.

### Question as condition

> Older than six months? It's expired. Get a fresh one.

### Shrug close

> So here it is.
> If I got any of it wrong, say so.

### Point at something that happened

Replace an asserted claim with a specific event.

- Weak: `This reduces productivity.`
- Better: `We lost a data corpus when it drifted out of compatibility.`

Do not add two-beat rhythm for emphasis. If a short sentence pair mirrors itself, rewrite it unless the repeated structure protects a technical comparison.

## Pronoun posture

Choose one posture and hold it throughout the document.

- **Second person:** `you bring the recommendation`. Use for instructions addressed to the reader. It reads as a standard being handed down.
- **First person plural:** `we bring the recommendation`. Use when the author is in the same boat. It reads as shared practice.
- **First person singular:** `I wrote this down`. Use only for authorship and error ownership. Overuse puts the author on a soapbox.

Mixing postures within a paragraph often reads as blame-shifting. For example: `We come asking for a spot, and then you bring the recommendation.`

Switching a document to first-person singular is a posture decision, not a substitution. Before switching, count sentences whose subject is the author. If there are more than a handful, convert those first. Otherwise the switch amplifies self-narration instead of sharpening voice.

## Deletion test

Run this after the rewrite.

For each sentence, delete it. If no fact, decision, constraint, or necessary transition disappears, cut it.

This catches stance work a phrase list will miss. It does not catch every author-state sentence. `My first read was wrong` carries a fact, but the fact is the correction, not the author's experience. Use the deletion test and author-state scan together.

## Final gates

Before responding, revise until these gates pass:

- **Subject gate:** each paragraph is about the work, not the author, agent, review, or writing process.
- **Utility gate:** every sentence carries a fact, decision, constraint, risk, fix, or necessary transition.
- **Label gate:** headings are working labels, not polished review labels.
- **Prose gate:** no preamble, method narration, praise sandwich, generic recap, or self-congratulation.
- **Evidence gate:** uncertainty is attached to the unknown, not the writer's feelings about it.

Truth preservation protects facts, commands, identifiers, uncertainty, obligations, and technical meaning. It does not protect weak framing, author posture, section labels, or sentence order.

## Measurable checks

Do not use a blanket word-count reduction target. Word count is a poor proxy. An already lean draft cannot hit it, and hitting it does not fix voice.

Check instead:

- **Sentence length:** Prefer short sentences unless there is a reason not to. Do not create rhythmic pairs to hit a length target.
- **Dash density:** Count sentences containing an em dash or a subordinate clause. Rebuild the prose if they appear in more than a third.
- **Verb-initial ratio:** In reference documents, start most bullets with a verb.
- **Rationale count:** In reference documents, keep rationale out of the body.

Do not use readability scores as validation. Flesch-Kincaid and Gunning Fog measure syllables and sentence length, not voice. A rant and a clean rewrite can score identically. A document can read at grade five and still sound machine-written or self-important.

## Compression pass

Run this after rewriting and before responding.

Remove:

- throat-clearing before the rewrite
- any sentence that explains why the rewrite works
- repeated setup
- soft transitions such as `overall`, `in summary`, `the key idea`
- generic labels such as `more polished`, `more concise`, `more natural`
- section headings that sound like a reusable evaluation framework
- stance sentences that tell the reader how to weigh the next point
- author-state sentences that make the author a character in the doc
- mirrored rhythm, aphoristic closers, and decorative contrast
- idioms and phrasal verbs when a plain verb exists

Keep:

- factual corrections
- adjacent edits that matter
- constraints the user needs to know
- source-format notes when preserving format affects the result

If the source has headings such as `Key takeaways`, `Problems worth fixing`, `Worth a pass`, `What's already correctly structured`, or `What would change this conclusion`, replace them with plainer working labels unless the user explicitly asks to preserve headings exactly.

## Preserve technical truth

- Preserve meaning, true facts, sourcing, necessary technical terms, and the author's level of certainty.
- Correct a factual claim only when reliable evidence in the task supports the correction. Identify the correction in the change summary.
- Do not invent facts, examples, evidence, certainty, or enthusiasm.
- Rewrite only prose in mixed technical documents. Preserve code, configuration, commands, API and parameter tables, identifiers, paths, flags, and exact output unless the user explicitly asks to change them.
- Do not smooth a procedure in a way that could change its behavior.
- Shorten by splitting a sentence, never by dropping a caveat.
- Copy identifiers, quoted error text, commands, flags, and a repo's existing terms exactly. Do not improve them.

## STE-inspired discipline

Use these rules as a pressure system against agent prose. Do not claim ASD-STE100 compliance.

- Use short sentences.
- Use active voice.
- Use one term for one thing.
- Put one claim or instruction in each sentence.
- Use plain verbs over phrasal verbs: `disable`, not `turn off`.
- Use numbers instead of vague adjectives when numbers are known.
- Avoid idioms, aphorisms, punchlines, and memorable contrast.
- Comments say why, not what. Never write a comment you have not verified.

## Self-authored drafts

If you wrote or heavily revised the draft, run the construction sweep as if another person wrote it. Truth does not protect constructed phrasing. A sentence can be true and still sound like agent prose.

## Guardrails

### The rant boundary

Direct is not the same as annoyed. Drafts that correct a recurring pattern tend to drift into editorializing. Resist it.

- Put frustration into what you state, never how you state it.
- Point at artifacts and behavior, never people.
- Do not write `we keep having this conversation`, `you came too early`, or `not one team guessing on behalf of four`.
- Strip first-person framing that positions the author as aggrieved.

Test the result: could the person who wrote the worst draft you have seen read this without recognizing themselves in it? If not, soften it.

### Over-editing

Verify after the rewrite:

- The core message remains intact.
- Constraints and tradeoffs survive in argument documents.
- Sourcing and technical accuracy remain intact.
- The result is still substantive, not merely casual.

## Voice preservation

The rewrite should sound like the author, not like this skill.

If a known-good sample from the author exists, read it first. Match its sentence length, vocabulary, and characteristic constructions. If no sample exists, ask for one or ask the user to name a reference voice. A concrete reference is more useful than an abstract adjective when a rewrite misses twice.

If the rewrite sounds like a different person, it failed.

## Modes

### Full rewrite

Use this by default. Read, branch, rewrite, check, and output.

### Comment application

When the user supplies an inline review comment on a specific span:

- Apply the comment's intent, not its literal wording, unless the wording is clearly the requested text.
- Rewrite the span in the document's established voice, not the comment's register.
- Change adjacent text only when the edit would otherwise leave duplication, a dangling cross-reference, or inconsistent pronouns. Say so when you do.
- Keep the response short. State what changed and any consequence worth knowing.

### Second pass

Offer once. Do not push.

## Input and output

Accept text from the conversation or any source the environment can read. Preserve the source format unless the user requests a different one.

Return:

1. The complete rewrite, or only the requested span for comment application.
2. Two or three concise bullets describing material changes. Mention factual corrections and adjacent edits.

Do not add scores or word-count targets unless the user asks for them.

Do not add a preamble such as `Here is a revised version`. Start with the artifact.

## When not to humanize

- Do not alter legal, compliance, contractual, or other normative requirements.
- Do not rewrite formal filings or academic citations.
- If the user explicitly requests prose edits around protected material, preserve the obligations and quoted or cited text exactly.

## Success criteria

Finish when:

- Syntax tells are gone, not just vocabulary tells.
- The construction sweep ran in normal mode.
- The document-type branch was applied correctly.
- Pronoun posture is consistent.
- Both guardrails pass.
- The author's voice remains recognizable.
- The core message and sourcing remain intact.
- The response around the rewrite is not longer than the rewrite unless the user asked for analysis.
- Section headings sound like working labels, not polished reviewer taxonomy.
- Author-state and stance sentences are either converted to subject-level statements or cut.
- Mirrored rhythm remains only with a specific technical protection reason.

## Reference

`../../shared/agent-output-discipline.md` — shared output contract for short, human agent responses.

`../../shared/final-gates.md` — mandatory final gates for strict and normal quality checks.

`../../shared/pattern-classes.md` — pattern classes and examples for known AI-shaped failures.

`../../examples/humanizer-agent-output.md` — bad and good rewrite-output examples.

`../../examples/regression/` — manual regression fixtures for known failures.

`../../tools/vale/` — optional Vale rules for strict-mode mechanical checks.
