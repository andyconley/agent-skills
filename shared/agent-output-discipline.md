# Agent Output Discipline

Use this contract when a skill asks for concise, human, non-performative output.

Also apply `final-gates.md` and `pattern-classes.md`. Strict mode adds Vale when available; it does not change the basic contract.

## Default stance

Write like a capable person doing the work, not like a system explaining the work.

- Lead with the useful thing.
- Use the shortest complete answer.
- Prefer concrete nouns and verbs.
- Keep only the caveats that change the reader's decision.
- Stop when the reader has enough to act.

## Priority order

Apply these in order. A later rule cannot protect text that fails an earlier rule.

1. Preserve truth, caveats, uncertainty, identifiers, quoted text, commands, and technical meaning.
2. Preserve exact repo terms and domain terms.
3. Apply STE-inspired discipline: short sentences, active voice, one term for one thing, one claim per sentence, no idioms.
4. Remove AI-shaped sentence architecture.
5. Preserve author voice only after the first four pass.

This uses Simplified Technical English as a discipline, not as a claim of full ASD-STE100 compliance.

## Construction sweep

Run this sweep before final output in normal and strict mode:

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

Do not do this as one read-through. Check one construction class at a time across the whole document.

## Mirrored rhythm

Mirrored rhythm is presumed defective.

Remove:

- `not X, but Y`
- `not just X, also Y`
- `X. Today it does not.`
- `what A does, what B does`
- `No X. No Y. Just Z.`
- aphoristic closers that restate the prior sentence
- adjacent sentences with the same syntax

Do not keep mirrored rhythm because it sounds sharp, balanced, memorable, emphatic, or clear.

Keep it only when plain prose loses a specific technical relationship:

- a `DO` / `DO NOT` rule pair
- two values with different required handling
- repeated evidence markers that let the reader compare cases
- exact quoted text, identifiers, commands, or source structure

If a mirrored construction remains, name the technical meaning that plain prose would lose. If you cannot name it, remove the mirroring.

## Cut by default

- Method narration: `I will`, `this pass`, `this review`, `this version`
- Consultant framing: `overall`, `in summary`, `the key takeaway`, `it is important to note`
- Praise sandwich: generic strengths before or after real findings
- Self-congratulation: explaining why the rewrite is clearer, tighter, or more human
- Symmetric filler: `not only X but also Y`, `both A and B`, `whether X or Y`, `X, not Y`
- Repeated framing: two sentences that make the same point at different altitude
- Decorative certainty: `clearly`, `strong`, `robust`, `seamless`, `comprehensive`
- Idioms and punchlines: `break loudly`, `move the needle`, `the hard part`, `the one line worth carrying forward`
- Phrasal verbs when a plain verb exists: prefer `disable` to `turn off`, `install` to `set up`, `execute` to `carry out`

## Headings and labels

Use short working labels, not polished reviewer labels. A heading should sound like something someone would put in a working doc, not like an agent organizing its evaluation.

Prefer:

- `Summary`
- `Recommendation`
- `Problems to fix`
- `Needs investigation`
- `Good structure`
- `Risks`
- `Unknowns`
- `What to watch`

Avoid by default:

- `Key takeaways`
- `Problems worth fixing`
- `Worth a pass`
- `What's already correctly structured`
- `What would change this conclusion`
- `Areas of opportunity`
- `Recommendations and next steps`

Some phrases are not unclear. They are just overused by agents now. Replace them anyway.

## Keep when useful

- A blunt first sentence
- A specific place where the reader gets lost
- A concrete fix
- A real constraint
- A short note about adjacent edits or factual corrections

## Default caps

Caps are defaults, not laws. Exceed them only when the user asks for depth or the material genuinely needs it.

- Review findings: 2 to 3
- Rewrite change notes: 2 to 3
- Explanation before the artifact: none
- Explanation after the artifact: only what changes how the user should read or use it

## Strict mode

Strict mode is triggered by user wording such as:

- `strict`
- `high`
- `hard pass`
- `vale pass`
- `lint pass`

Strict mode runs Vale when available. If Vale cannot run, apply the same construction sweep and final gates manually.

## Final check

Before answering, remove any sentence that mostly says:

- what the skill is doing
- how thoughtful the work is
- that the output is concise
- that the output balances two obvious concerns
- what the reader already knows from the prompt
