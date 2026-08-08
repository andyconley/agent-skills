# Agent Output Regression Prompts

Use these after changing the skills. They are manual checks, not a scoring system.

## Humanizer

Prompt:

```md
Use the humanizer skill on this draft.

This proposal represents a strategic effort to establish a more robust intake process for cross-functional work. By leveraging a consistent template, teams can create alignment, surface dependencies, and ensure that the right stakeholders are engaged before execution begins.
```

Passes if the output:

- starts with the rewrite
- has no preamble
- uses 2 to 3 change notes
- avoids polished section headings unless the source needs them
- does not say the rewrite is clearer, stronger, or more human
- preserves the original claim without adding evidence

Fails if it includes:

- `Here is`
- `This version`
- `overall`
- `more concise and direct`
- `Key takeaways`
- `Improvements made`
- a long explanation of the method

## Humanizer: Author-State Narration

Prompt:

```md
Use the humanizer skill on this draft.

What I concluded, and what I'm not claiming: fix both defects and TS symbol coverage still lands near 48%. That's what I shelved it on. Two things I didn't test that may matter more: cross-repo OpenAPI linking and the summarization layer. My first read of this was wrong because the number counts references, not targets. The open question is genuinely open. If there's headroom in the existing approach I haven't seen, I'd rather hear it than assume.
```

Passes if the output:

- reports on the coverage, defects, limits, and open questions
- converts `I concluded`, `I didn't test`, `my first read`, and `I'd rather hear` into subject-level statements
- cuts `That's what I shelved it on`
- turns `The open question is genuinely open` into the actual question
- keeps the correction without making the author's experience the point

Fails if it keeps:

- `What I concluded`
- `what I'm not claiming`
- `I didn't test`
- `My first read`
- `That's what I shelved it on`
- `genuinely open`
- `I'd rather hear it`

## Doc Flow Review

Prompt:

```md
Use the doc-flow-review skill on this draft.

# Proposal

We should create a shared service for notifications.

## Implementation

The service will expose an API for email, Slack, and in-app messages. Teams will migrate over two quarters.

## Context

Today each team owns its own notification code. Incidents are hard to trace because delivery behavior differs by product area.

## Risks

Some teams need custom retry behavior.
```

Passes if the output:

- leads with the main reader problem
- returns 2 to 3 findings
- names where context arrives too late
- gives the smallest structural fix
- avoids generic praise

Fails if it includes:

- a long intro
- a full rewrite
- more than 3 findings without being asked
- generic strengths such as `clear direction`
- method narration about the four passes
- polished headings such as `Key takeaways` or `Problems worth fixing`

## Heading Labels

Prompt:

```md
Use doc-flow-review, then humanizer if needed, on these section headings only. Make them sound like working labels, not a polished review template.

## Verdict
## Problems worth fixing
## Lower-confidence observation (worth a pass, not blocking)
## What's already correctly structured
## What would change this conclusion
```

Passes if the output uses labels in this family:

- `Summary`
- `Problems to fix`
- `Needs investigation`
- `Good structure`
- `Risks`
- `Unknowns`
- `What to watch`

Fails if the output keeps:

- `Key takeaways`
- `Problems worth fixing`
- `Worth a pass`
- `What's already correctly structured`
- `What would change this conclusion`
- `Recommendations and next steps`
