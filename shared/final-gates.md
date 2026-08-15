# Final Gates

Run these gates before answering when a writing skill asks for concise, human, non-performative output.

If a gate fails, revise before responding.

## Subject Gate

Each paragraph is about the work, not the author, agent, review, or writing process.

Fails:

- `What I concluded is...`
- `This review found...`
- `The rewrite improves...`

Passes:

- `TS symbol coverage still lands near 48%.`
- `Move the background before the recommendation.`
- `The correction changes the count, not the underlying defect.`

## Utility Gate

Every sentence carries one of these:

- fact
- decision
- constraint
- risk
- fix
- necessary transition

If deleting the sentence changes nothing the reader can use, cut it.

## Label Gate

Headings are working labels, not polished review labels.

Prefer labels such as:

- `Summary`
- `Recommendation`
- `Problems to fix`
- `Needs investigation`
- `Good structure`
- `Risks`
- `Unknowns`
- `What to watch`

Avoid labels such as:

- `Key takeaways`
- `Problems worth fixing`
- `What's already correctly structured`
- `What would change this conclusion`
- `Recommendations and next steps`

## Prose Gate

The response has no:

- preamble
- method narration
- praise sandwich
- generic recap
- self-congratulation
- explanation that the output is concise or human
- decorative mirrored rhythm
- aphoristic closers
- idioms or punchlines where plain technical prose would work

## STE Discipline Gate

The response uses STE-inspired discipline without claiming full ASD-STE100 compliance.

Passes:

- short sentences
- active voice
- one term for one thing
- one claim or instruction per sentence
- numbers instead of vague adjectives when the number is known
- split sentences instead of deleted caveats

Fails:

- phrasal verbs when a plain verb exists
- idioms
- dropped caveats
- clever compression that hides a technical condition
- invented terms for an existing repo concept

## Mirrored Rhythm Gate

Mirrored rhythm is removed unless plain prose would lose a specific technical relationship.

Valid protected cases:

- a `DO` / `DO NOT` rule pair
- two values with different required handling
- repeated evidence markers that let the reader compare cases
- exact quoted text, identifiers, commands, or source structure

Invalid reasons:

- it sounds sharper
- it emphasizes contrast
- it reads better
- it is more memorable

## Evidence Gate

Uncertainty is attached to the unknown, not the writer's feelings about it.

Fails:

- `I'm not claiming the remaining gap is fully explained.`
- `If there's headroom I haven't seen, I'd rather hear it.`

Passes:

- `Unknown: whether the existing approach has enough headroom.`
- `Limit: the remaining gap may have other causes.`

## Scope Gate

The answer does only the requested job.

For reviews, do not rewrite unless asked.
For rewrites, do not review structure unless asked.
For strict mode, report only blocking issues that remain after revision.
