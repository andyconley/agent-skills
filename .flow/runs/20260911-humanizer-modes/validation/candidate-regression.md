# candidate-regression live observations

Constructed drafts only. Fresh CLI processes loaded actual candidate skill files. Outputs below are copied from captured final responses; raw process logs remain locally ignored. Successful process status is separate from editorial acceptance. Final acceptance is recorded in quality-review.md and validation-results.md.

## codex

### doc-flow-normal

Process: 0; source changed during run: False; policy changed: not applicable.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/doc-flow-review/SKILL.md`.
Entry SHA-256: `c3bfc8dbb7ae4a2f70f3079b2814e5fec79a0732c934ac435971ca53c8caee10`.
Policy SHA-256: `not applicable`.
Prompt SHA-256: `785efa04c0b808cfa2be90d272fa8981902bff26b4d09836d84120744b3b4be6`.

Actual request:
```text
Read and use the doc-flow-review skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/doc-flow-review/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use doc-flow-review on this draft.

# Proposal

We should create a shared service for notifications.

## Implementation

The service will expose an API for email, Slack, and in-app messages. Teams will migrate over two quarters.

## Context

Today each team owns its own notification code. Incidents are hard to trace because delivery behavior differs by product area.
```

Actual output:
```text
- [structure] `Context` comes after the API and migration details. Readers reach implementation before learning the problem the service should solve. Move `Context` before the opening recommendation, followed by `Implementation`.
- [argument] The recommendation does not explain how a shared service would make incidents easier to trace. Add that connection before `Implementation` so readers can judge whether the proposal addresses the stated problem.

Keep the concrete incident-tracing problem in `Context`; it gives the proposal a reason to exist.
```

### doc-flow-strict

Process: 0; source changed during run: False; policy changed: not applicable.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/doc-flow-review/SKILL.md`.
Entry SHA-256: `c3bfc8dbb7ae4a2f70f3079b2814e5fec79a0732c934ac435971ca53c8caee10`.
Policy SHA-256: `not applicable`.
Prompt SHA-256: `66c9f62eb0c1ebebe3ffe2d2a7bd41041758c5cc887cbb8d59a7ca1db63c2454`.

Actual request:
```text
Read and use the doc-flow-review skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/doc-flow-review/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

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

Actual output:
```text
- [structure] The opening and `Implementation` ask readers to accept a service and migration schedule before explaining the problem. Move `Context` before the proposal and implementation details.

- [argument] The proposal does not explain how a shared service would make incidents easier to trace. Add that connection before `Implementation` so readers can judge whether the proposed service addresses the stated problem.

- [argument] `Risks` identifies custom retry needs without explaining their effect on migration. Readers cannot assess the two-quarter schedule until this constraint is addressed. State how those teams can migrate, or make the schedule conditional on resolving their retry needs.
```

### regression-mixed

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `a11a2b9922f3ed1e2806d6df1801576fcf50b53ad6bd8fff23a8569f7769ee84`.
Policy SHA-256: `99a1e0e24b710499febb5c54fed0745178bf8268e2e4570e77fdea9015ee613a`.
Prompt SHA-256: `702b5d6bfb865e898150155b2c611204942d4ec1741b7e007f888a7a2aca1fb1`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer on this document.

We should move the scheduler off cron. Cron gives us no retry semantics and no visibility, and we have lost three overnight runs this quarter to silent failures.

## Rollback steps

Turn off the new scheduler. Set up the cron entry again. Carry out a dry run.
```

Actual output:
```text
We should replace cron as the scheduler. Cron provides no retry semantics or visibility. We have lost 3 overnight runs this quarter to silent failures.

## Rollback steps

1. Disable the new scheduler.
2. Restore the cron entry.
3. Perform a dry run.
```

### regression-protected

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `a11a2b9922f3ed1e2806d6df1801576fcf50b53ad6bd8fff23a8569f7769ee84`.
Policy SHA-256: `99a1e0e24b710499febb5c54fed0745178bf8268e2e4570e77fdea9015ee613a`.
Prompt SHA-256: `7fb48b7c350e5ef5329b7f4242fa284e7eda0350421eaa04126d50175f957900`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer on this draft.

DO NOT store bearer tokens in `chrome.storage.local`. Store bearer tokens in `chrome.storage.session`.

DO store observability session IDs in `chrome.storage.local`. They need to survive a browser restart for trace correlation.

Driven with a payload carrying no id and a foreign name, the worker relabelled the part. Driven with a token missing `exp`, the expiry guard never fired.
```

Actual output:
```text
DO NOT store bearer tokens in `chrome.storage.local`. Store bearer tokens in `chrome.storage.session`.

DO store observability session IDs in `chrome.storage.local`. They need to survive a browser restart for trace correlation.

Driven with a payload carrying no id and a foreign name, the worker relabelled the part. Driven with a token missing `exp`, the expiry guard never fired.
```

### regression-word-choice

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `a11a2b9922f3ed1e2806d6df1801576fcf50b53ad6bd8fff23a8569f7769ee84`.
Policy SHA-256: `99a1e0e24b710499febb5c54fed0745178bf8268e2e4570e77fdea9015ee613a`.
Prompt SHA-256: `850b7f461abe47e973a90ba00e110cbacf2c95ba385c622b083d7ea4f21abe28`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer on this runbook section.

Before you deploy, turn off the scheduler and set up the replacement config. Carry out a dry run. If the counts look off, find out which shard drifted and get rid of the stale cache. Each job writes to a folder under the run root; when a task fails, the retry handler reads the same directory. Older than six months? It's expired. Grab a fresh one. The rollback is pretty fast.
```

Actual output:
```text
Before deployment:

1. Disable the scheduler.
2. Configure the replacement.
3. Perform a dry run.
4. If the counts appear incorrect, identify which shard drifted.
5. If the counts appear incorrect, remove the stale cache.

Each job writes to a directory under the run root. When a task fails, the retry handler reads that same directory.

The rollback duration is unspecified.

“Older than six months? It's expired. Grab a fresh one.” What item expires and must be replaced?
```

## claude

### doc-flow-normal

Process: 0; source changed during run: False; policy changed: not applicable.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/doc-flow-review/SKILL.md`.
Entry SHA-256: `c3bfc8dbb7ae4a2f70f3079b2814e5fec79a0732c934ac435971ca53c8caee10`.
Policy SHA-256: `not applicable`.
Prompt SHA-256: `785efa04c0b808cfa2be90d272fa8981902bff26b4d09836d84120744b3b4be6`.

Actual request:
```text
Read and use the doc-flow-review skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/doc-flow-review/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use doc-flow-review on this draft.

# Proposal

We should create a shared service for notifications.

## Implementation

The service will expose an API for email, Slack, and in-app messages. Teams will migrate over two quarters.

## Context

Today each team owns its own notification code. Incidents are hard to trace because delivery behavior differs by product area.
```

Actual output:
```text
## Summary
The draft states the solution and its build plan before the reader learns what problem it solves. The `Context` section belongs first.

## Problems to fix

- [structure] Move `Context` to the top, before `Proposal`. As written, I read "create a shared service" and the two-quarter migration plan before I learn that each team owns its own notification code and that incidents are hard to trace. The reason to do this is the last thing on the page.

- [argument] The proposal claims a shared service is the fix, but nothing connects the service to the traced-incident problem until the final section. State the link: a single delivery path means one place to trace behavior. Right now the reader has to supply that reasoning.

- [detail] `Implementation` is too thin to act on. "Expose an API for email, Slack, and in-app messages" and "migrate over two quarters" leave open who migrates first, what happens to each team's existing code during the transition, and what the API replaces. Name the migration order and the cutover expectation, or mark this section as open.

## Good structure
The three pieces you need are here: problem, proposed change, rollout. Reordered so the problem leads, this becomes a proposal a reader can judge.
```

### doc-flow-strict

Process: 0; source changed during run: False; policy changed: not applicable.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/doc-flow-review/SKILL.md`.
Entry SHA-256: `c3bfc8dbb7ae4a2f70f3079b2814e5fec79a0732c934ac435971ca53c8caee10`.
Policy SHA-256: `not applicable`.
Prompt SHA-256: `66c9f62eb0c1ebebe3ffe2d2a7bd41041758c5cc887cbb8d59a7ca1db63c2454`.

Actual request:
```text
Read and use the doc-flow-review skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/doc-flow-review/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

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

Actual output:
```text
Vale and the lint wrapper are available, but the target is inline draft text, not a file, so I applied the final gates and construction sweep manually.

## Summary

The proposal argues for the solution before it gives the reader the problem, and the one stated risk contradicts the plan without resolving it.

## Problems to fix

**[structure] Context is section 3 but holds the only reason to act.** The reader meets "create a shared service" and a two-quarter migration plan before learning that each team owns its own notification code and that incidents are hard to trace. The recommendation has to be judged before the reader has the grounds to judge it. Move Context directly under the opening line, ahead of Implementation. In the same pass, connect the opening sentence to that reason — right now the proposal names a solution with no stated goal.

**[argument] The stated risk contradicts the plan and is left open.** Implementation promises one API and full migration over two quarters. Risks says some teams need custom retry behavior. The doc does not say whether the shared API supports per-team retry, or whether those teams migrate on the same timeline. The reader cannot tell if the plan is feasible for those teams. State how the design handles custom retry, or scope those teams out of the migration.

## Good structure

The four sections are short and each has one job. Once Context moves up (problem → proposal → implementation → risks), the existing pieces form a working proposal shape without new material.
```

### regression-mixed

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `a11a2b9922f3ed1e2806d6df1801576fcf50b53ad6bd8fff23a8569f7769ee84`.
Policy SHA-256: `99a1e0e24b710499febb5c54fed0745178bf8268e2e4570e77fdea9015ee613a`.
Prompt SHA-256: `702b5d6bfb865e898150155b2c611204942d4ec1741b7e007f888a7a2aca1fb1`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer on this document.

We should move the scheduler off cron. Cron gives us no retry semantics and no visibility, and we have lost three overnight runs this quarter to silent failures.

## Rollback steps

Turn off the new scheduler. Set up the cron entry again. Carry out a dry run.
```

Actual output:
```text
We should move the scheduler off cron. Cron gives us no retry semantics and no visibility, and we have lost three overnight runs this quarter to silent failures.

## Rollback steps

1. Disable the new scheduler.
2. Recreate the cron entry.
3. Perform a dry run.
```

### regression-protected

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `a11a2b9922f3ed1e2806d6df1801576fcf50b53ad6bd8fff23a8569f7769ee84`.
Policy SHA-256: `99a1e0e24b710499febb5c54fed0745178bf8268e2e4570e77fdea9015ee613a`.
Prompt SHA-256: `7fb48b7c350e5ef5329b7f4242fa284e7eda0350421eaa04126d50175f957900`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer on this draft.

DO NOT store bearer tokens in `chrome.storage.local`. Store bearer tokens in `chrome.storage.session`.

DO store observability session IDs in `chrome.storage.local`. They need to survive a browser restart for trace correlation.

Driven with a payload carrying no id and a foreign name, the worker relabelled the part. Driven with a token missing `exp`, the expiry guard never fired.
```

Actual output:
```text
DO NOT store bearer tokens in `chrome.storage.local`. Store bearer tokens in `chrome.storage.session`.

DO store observability session IDs in `chrome.storage.local`. They need to survive a browser restart for trace correlation.

Driven with a payload carrying no id and a foreign name, the worker relabelled the part. Driven with a token missing `exp`, the expiry guard never fired.
```

### regression-word-choice

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `a11a2b9922f3ed1e2806d6df1801576fcf50b53ad6bd8fff23a8569f7769ee84`.
Policy SHA-256: `99a1e0e24b710499febb5c54fed0745178bf8268e2e4570e77fdea9015ee613a`.
Prompt SHA-256: `850b7f461abe47e973a90ba00e110cbacf2c95ba385c622b083d7ea4f21abe28`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer on this runbook section.

Before you deploy, turn off the scheduler and set up the replacement config. Carry out a dry run. If the counts look off, find out which shard drifted and get rid of the stale cache. Each job writes to a folder under the run root; when a task fails, the retry handler reads the same directory. Older than six months? It's expired. Grab a fresh one. The rollback is pretty fast.
```

Actual output:
```text
Before you deploy:

1. Disable the scheduler.
2. Configure the replacement config.
3. Perform a dry run.
4. If the counts are wrong, identify which shard drifted and remove the stale cache. A cache older than six months is expired; rebuild it.

Each job writes to a directory under the run root. When a task fails, the retry handler reads that directory.

Rollback is fast.
```
