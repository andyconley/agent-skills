---
name: doc-flow-review
description: Reviews documents for structure and information flow rather than correctness or sentence-level style. Checks whether a document starts high and goes deep cleanly, each section builds on prior context, and each claim follows from established evidence or constraints. Use for readability, structural, developmental, clarity, organization, or pre-review feedback on design docs, PRDs, proposals, specs, runbooks, postmortems, RFCs, and long-form writing. Do not use for copyediting, grammar, fact-checking, or prose rewriting; use humanizer after structural decisions when both are needed. Version 1.2.0.
---

# Doc Flow Review

**Version: 1.2.0.** When asked which version is running, report this value exactly. Do not infer a version from Git history or the host application.

Review documents for **structure and information flow**, not correctness.

Correctness is a different review by a different person. This one asks whether the doc makes its case in an order a reader can follow. Typos are the least useful output — note them in passing, never spend the pass on them.

The review should sound like a capable reader giving useful notes, not a rubric reciting itself. Long introductions, generic strengths, and method narration make the feedback harder to use.

## Output discipline

Follow the shared contract in `../../shared/agent-output-discipline.md`. If that file is not available in the host environment, apply these rules directly:

- Lead with the biggest reader problem.
- Default to 2 or 3 findings.
- Do not explain the four passes unless the user asks.
- Do not open with generic praise or `overall`.
- Do not turn one problem into several overlapping findings.
- For each finding, give the place, what breaks, and the smallest fix.
- Keep the close short. Include what works only when it is specific and useful.
- Use plain working labels for sections. Prefer `Summary`, `Recommendation`, `Problems to fix`, `Needs investigation`, `Good structure`, `Risks`, `Unknowns`, and `What to watch`.

For output examples, see `../../examples/doc-flow-review-agent-output.md`.

## Two modes

**Mode A — Run the review.** The user has a doc and wants feedback. Do the four passes below and report findings.

**Mode B — Set the expectation.** The user is sending a doc out and wants to tell reviewers what to look for. Give them the reviewer block from `assets/reviewer-block.md`, lightly adapted to their doc type.

If it's ambiguous, assume Mode A.

When a document needs both structural and prose work, run this review first. Apply the structural decisions before using `humanizer` on the prose.

## What "good" looks like

**Progressive disclosure.** Starts with the shape of the thing, layers in detail. A reader can stop at any depth and not walk away misled. First page → what this is and why it matters. Whole doc → enough to act on.

**Each section stands on what came before.** No forward references, no undefined terms. If the reader has to scroll down to understand a paragraph, the order is wrong.

**Every claim traces back to something stated.** This is where docs usually break — they assert a conclusion without laying the ground for it. If a point doesn't connect to a problem, a constraint, or evidence already on the page, it's an unjustified leap.

## The four passes

Run these in order. Don't mix them — mixing is what turns a structural review into a pile of line edits.

### 1. Structural — is the order right?

- Can I read the first page and know what this is and why it exists?
- Is anything in the wrong place — detail in the summary, context buried at the end?
- Is there a section that could be cut entirely without loss?

### 2. Progressive disclosure — does each section assume only what came before?

- Where do I hit a term, system, or concept that hasn't been introduced?
- Where does the depth jump too fast?
- Where does it stay shallow too long before getting to the point?

### 3. Argument — does each point earn its place?

- Does the framing justify the conclusions?
- Where is there a claim presented as obvious that isn't?
- What objection would a reasonable reader raise, and is it addressed?
- What's asserted that should be shown?

### 4. Detail — is the deep material usable, and out of the way?

- Could someone act on this without a follow-up meeting?
- Is detail only a few readers need pushed into appendices or links?
- Are the tables and diagrams carrying weight, or decorating?

## Reporting findings

Lead with the two or three things that matter most. Don't open with a list of everything.

Then group findings by pass, tagged so the author knows what kind of fix is needed:

- `[structure]` — move it, cut it, reorder it
- `[disclosure]` — reader doesn't have what they need yet
- `[argument]` — claim isn't earned
- `[detail]` — too thin, too deep, or in the wrong place

For each finding: where it is, what breaks for the reader, and the smallest fix. Not a rewrite. The author owns the prose.

Close with what's working — specifically, so they don't undo it in revision.

If there is only one real issue, report one issue. Do not pad the review to fill the four passes.

## Calibration

- **Be a reader, not a rubric.** The passes are a checklist for your attention, not a form to fill in. If a doc is well structured, say so and stop. Five weak findings are worse than one real one.
- **Say where you got lost.** The single most useful thing in this kind of review is "I stopped understanding here." Name the sentence.
- **Respect the audience.** A runbook for on-call engineers and a proposal for a VP fail in different ways. Ask who reads this if it isn't obvious, and calibrate the depth expectations to them.
- **Don't confuse "I'd have written it differently" with a defect.** Only flag what costs the reader something.
- **Do not review your own review.** No recap of how the feedback is structured, no explanation that the comments are concise, and no praise for the document unless it protects something the author should keep.
- **Watch the labels.** `Problems worth fixing`, `Worth a pass`, `What's already correctly structured`, and `What would change this conclusion` sound like agent review headings now. Use plainer labels instead.

## Reference

`assets/reviewer-block.md` — the paste-in block for doc templates and review requests (Mode B).

`../../shared/agent-output-discipline.md` — shared output contract for short, human agent responses.

`../../examples/doc-flow-review-agent-output.md` — bad and good review-output examples.
