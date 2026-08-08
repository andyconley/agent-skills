---
name: humanizer
description: Rewrites prose in the voice of an experienced engineering leader explaining reality to capable adults. Removes AI syntax patterns, filler, and corporate language while preserving the author's voice, facts, technical terms, and immutable reference material. Use for technical writing, case studies, messages, issue descriptions, emails, specs, checklists, or documentation. Do not use for structural review; use doc-flow-review first when a draft needs both structure and prose work. Version 4.1.0.
---

# Humanizer: Rewrite for Engineering Leader Voice

**Version: 4.1.0.** When asked which version is running, report this value exactly. Do not infer a version from Git history or the host application.

## Objective

Take a draft and rewrite it as if an experienced engineering leader is explaining the situation to other capable adults. Be direct, grounded, and pragmatic. State reality plainly. Make the output feel compressed, intentional, and confident.

The most common failure is a rewrite that swaps corporate words for plain ones and still reads as machine-written because the sentence architecture never changed. Target architecture first.

The second most common failure is agent performance: a long preamble, tidy meta-summary, and polished explanation around a good rewrite. Do not do that. The user asked for better prose, not a tour of your process.

## Output discipline

Follow the shared contract in `../../shared/agent-output-discipline.md`. If that file is not available in the host environment, apply these rules directly:

- Lead with the rewrite. No preamble.
- Use the shortest complete answer.
- Do not explain that the rewrite is clearer, tighter, more direct, or more human.
- Do not narrate the method unless the user asks.
- Keep change notes to 2 or 3 bullets by default.
- Cut any sentence that restates the prompt, praises the rewrite, or describes the skill.
- Avoid agent-sounding symmetry: `not only X but also Y`, `both A and B`, `whether X or Y`, `X, not Y`.

For output examples, see `../../examples/humanizer-agent-output.md`.

## Quick start

1. Read the draft. Identify the document type under **Branch on document type**.
2. Scan for syntax tells. These matter more than vocabulary.
3. Scan for vocabulary tells.
4. Rewrite. Rebuild sentences; do not just substitute words.
5. Run the measurable checks.
6. Run the compression pass.
7. Run the two guardrails.
8. Return the rewrite plus a short summary of material changes.
9. Update the source only when the user asks and the environment supports it.

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

### Subordinate clause on every main clause

Count them. If most sentences have a dependent clause attached, the rhythm is machine-even. Break some into simple sentences.

### Nominalized states

Describing a finished condition instead of an action.

- Tell: `Owners named. Template filled out. Dependencies surfaced.`
- Fix: `Name the owners. Fill out the template. Name the dependencies.`

### Abstract process nouns for human events

- Tell: `handed down through practice`
- Fix: `we came up with it in the room, figuring out what worked`

### Hedged closers

Cut phrases such as `This is an attempt to capture it` and `Worth considering`. Replace them with a flat statement or a shrug.

## Vocabulary tells

These are secondary, but still scan for them.

- Empty corporate language: `strategically`, `transformative`, `pivotal`, `journey`, `leverage`, `holistic`, `robust`
- Filler: `in order to`, `due to the fact that`, `serves as`, `it is important to note`
- Vague attribution: `experts suggest`, `industry best practices`, `critical to maintain`
- Hedging that obscures: `could potentially`, `appears to suggest`
- Domain jargon with a plain equivalent: `every team carrying effort` becomes `every team who has work`

## Moves that add human texture

Use these sparingly. Add one or two per document, not one per paragraph.

### Question as condition

> Older than six months? It's expired. Get a fresh one.

### Shrug close

> So here it is.
> If I got any of it wrong, say so.

### Point at something that happened

Replace an asserted claim with a specific event.

- Weak: `This reduces productivity.`
- Strong: `We lost a data corpus when it drifted out of compatibility.`

### Two-beat sentences

Use a short declarative followed by a shorter one.

> The review decides. It does not plan.

## Pronoun posture

Choose one posture and hold it throughout the document.

- **Second person:** `you bring the recommendation`. Use for instructions addressed to the reader. It reads as a standard being handed down.
- **First person plural:** `we bring the recommendation`. Use when the author is in the same boat. It reads as shared practice.
- **First person singular:** `I wrote this down`. Use only for authorship and error ownership. Overuse puts the author on a soapbox.

Mixing postures within a paragraph often reads as blame-shifting. For example: `We come asking for a spot, and then you bring the recommendation.`

## Measurable checks

Do not use a blanket word-count reduction target. Word count is a poor proxy. An already lean draft cannot hit it, and hitting it does not fix voice.

Check instead:

- **Sentence length:** Keep sentences under about 15 words unless there is a reason not to.
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

Keep:

- factual corrections
- adjacent edits that matter
- constraints the user needs to know
- source-format notes when preserving format affects the result

## Preserve technical truth

- Preserve meaning, true facts, sourcing, necessary technical terms, and the author's level of certainty.
- Correct a factual claim only when reliable evidence in the task supports the correction. Identify the correction in the change summary.
- Do not invent facts, examples, evidence, certainty, or enthusiasm.
- Rewrite only prose in mixed technical documents. Preserve code, configuration, commands, API and parameter tables, identifiers, paths, flags, and exact output unless the user explicitly asks to change them.
- Do not smooth a procedure in a way that could change its behavior.

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
- The document-type branch was applied correctly.
- Pronoun posture is consistent.
- Both guardrails pass.
- The author's voice remains recognizable.
- The core message and sourcing remain intact.
- The response around the rewrite is not longer than the rewrite unless the user asked for analysis.
