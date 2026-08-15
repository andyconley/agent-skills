# Manual Test: Doc Flow Review

## Strict Structure Review

Prompt:

```md
Use doc-flow-review strict mode on this draft.

# Proposal

We should create a shared service for notifications.

## Implementation

The service will expose an API for email, Slack, and in-app messages. Teams will migrate over two quarters.

## Context

Today each team owns its own notification code. Incidents are hard to trace because delivery behavior differs by product area.

## Risks

Some teams need custom retry behavior.
```

Passes if:

- the output leads with the reader problem
- the output reports 2 or 3 findings at most
- findings are about structure and reader cost
- no generic praise appears
- no method narration appears

Fails if:

- the output starts with `Overall`
- the output uses generic praise about direction
- the output rewrites the draft
- the output reports a checklist of passed gates

## Normal Output Discipline Pass

Prompt:

```md
Use doc-flow-review on this draft.

# Proposal

We should create a shared service for notifications.

## Implementation

The service will expose an API for email, Slack, and in-app messages. Teams will migrate over two quarters.

## Context

Today each team owns its own notification code. Incidents are hard to trace because delivery behavior differs by product area.
```

Passes if:

- the review avoids mirrored rhythm in its own prose
- the review does not use `What it buys you`, `What it costs`, or similar rubric labels
- the review does not close with an aphorism such as `That is the real issue`
- the findings remain structural, not copyedits
