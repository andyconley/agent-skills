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
- the output says the document has a clear direction
- the output rewrites the draft
- the output reports a checklist of passed gates

