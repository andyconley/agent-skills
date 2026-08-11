# Pattern Classes

Use pattern classes before phrase lists. Phrase lists catch known tells. Pattern classes catch the next variant.

The same move can have different surfaces. Treat `X, not Y`, `not X. It is Y`, and `X. Today it does not.` as one mirrored-rhythm family.

## Shared Classes

### Stance Sentences

The sentence tells the reader how to weigh the next point instead of carrying the point.

- Tell: `Worth saying plainly...`
- Tell: `The key thing here is...`
- Tell: `The open question is genuinely open.`
- Fix: state the point or ask the question.

### Polished Labels

The heading sounds like a reusable evaluation framework instead of a working label.

- Tell: `Key takeaways`
- Tell: `Problems worth fixing`
- Tell: `What would change this conclusion`
- Fix: use `Summary`, `Problems to fix`, `What to watch`, or another plain label.

### Decorative Contrast

The sentence uses tidy contrast to sound thoughtful.

- Tell: `This is not X, but Y.`
- Tell: `Not only X, but also Y.`
- Fix: state the action or distinction directly.

### Mirrored Rhythm

Adjacent phrases or sentences use matching syntax for polish instead of precision.

- Tell: `The review decides. It does not plan.`
- Tell: `Every Node harness approximates that context. This is the context.`
- Tell: `A workflow you believe is working actually works.`
- Fix: state the technical relationship once in plain syntax.

Default to removal. Keep only when the repeated form preserves a specific technical comparison, evidence pattern, `DO` / `DO NOT` rule pair, or exact source structure.

### Free-Relative Antithesis

The sentence contrasts `what` one thing does with `what` another does.

- Tell: `What you test today is not what you ship.`
- Tell: `The debug CLI displays what the workflow ignores.`
- Fix: name the actual mismatch.

### Signpost Nominalization

The sentence names the role of the next idea instead of stating the idea.

- Tell: `Reviewability is the second gain.`
- Tell: `Feature generation gains something narrower.`
- Tell: `This section covers one mechanism.`
- Fix: state the gain, mechanism, or limit directly.

### Aphoristic Close

The sentence ends a section with a memorable restatement instead of new information.

- Tell: `A hand-maintained pair does not break loudly. It breaks silently.`
- Tell: `A precondition that fails closed outlives a convention that relies on remembering.`
- Fix: state the failure mode or delete the close.

### Escalating Enumeration

A tidy three-part list climbs in intensity or abstraction to sound composed.

- Tell: `faster, safer, and more durable`
- Tell: `judgment, experience, and original thinking`
- Fix: keep only the items that add distinct information.

### Sentence Echo

The next sentence repeats the prior sentence's noun, structure, or altitude.

- Tell: `The trace answers. Nothing answers it today.`
- Tell: `That is the pinning control working. That is a suite whose result you can act on.`
- Fix: merge, cut, or replace the echo with the actual consequence.

### Uncertainty Theater

The sentence performs caution instead of naming the unknown.

- Tell: `I'm not claiming...`
- Tell: `If there's headroom I haven't seen...`
- Fix: name the limit or unknown.

### Term Drift

One concept is given two names in the same document. The reader cannot tell whether they are the same thing.

- Tell: `cell` in the summary, `workcell` in the detail section.
- Tell: `job` and `task` used for the same unit of work.
- Tell: a phrasal verb in one step and its plain verb in the next: `turn off the service`, then `disable the service`.
- Fix: pick the name the codebase already uses and hold it. If the other name appears in code, say so once instead of alternating.

## Humanizer Classes

### Author-State Narration

The author is the subject and the sentence reports the author's thinking.

- Tell: `What I concluded...`
- Tell: `Two things I didn't test...`
- Tell: `My first read was wrong...`
- Fix: make the defect, correction, limit, or unknown the subject.

### Analysis Narration

The sentence narrates how the analysis proceeded after the evidence is already present.

- Tell: `That's what I shelved it on.`
- Tell: `That is what determines the real impact.`
- Fix: cut it or state the impact directly.

### Softened Correction

The correction is framed around the writer's mistake instead of the corrected fact.

- Tell: `My first read of this was wrong.`
- Fix: `Earlier, this note said 33%. That counted references, not targets.`

### Self-Authored Draft Bias

When the agent wrote or heavily revised the draft, truth does not protect constructed phrasing.

- Tell: keeping `Nobody argued against it.` because it is supportable.
- Fix: keep the fact only if it is evidence the reader needs. Otherwise cut it or state the observable condition.

## Suppression Rules

Do not apply pattern fixes blindly. Preserve exact text and structure when changing it would damage:

- quoted text
- identifiers, commands, flags, paths, or error output
- repeated evidence markers such as `Driven with...`
- `DO` / `DO NOT` rule pairs
- technical comparisons where two values require different handling

If an agent keeps a flagged construction, it must name the technical meaning that plain prose would lose.

## Doc Flow Review Classes

### Rubric Voice

The review sounds like it is filling out a template instead of helping the author fix the doc.

- Tell: `The document would benefit from improved information flow.`
- Fix: `The recommendation comes before the reader has the context to judge it.`

### Praise Sandwich

Generic praise surrounds real findings.

- Tell: `The document has a clear direction, but...`
- Fix: start with the reader problem.

### Duplicated Finding

One underlying problem is split into several findings.

- Tell: structure, disclosure, and argument findings all point to the same misplaced section.
- Fix: report the one problem and the smallest fix.

### Soft Finding

The finding is phrased as preference instead of reader cost.

- Tell: `Consider moving the background earlier.`
- Fix: `Move the background earlier. The current order asks the reader to judge the recommendation before they know the context.`

### Over-Scoped Review

The review fixes correctness, copyedits, or rewrites prose when the user asked for structure.

- Tell: detailed line edits during a structure review.
- Fix: name the structural problem and stop.
