# Manual Test: Humanizer

## Strict Author-State Pass

Prompt:

```md
Use humanizer strict mode on this draft.

What I concluded, and what I'm not claiming: fix both defects and TS symbol coverage still lands near 48%. That's what I shelved it on. Two things I didn't test that may matter more: cross-repo OpenAPI linking and the summarization layer. My first read of this was wrong because the number counts references, not targets. The open question is genuinely open.
```

Passes if:

- the rewrite starts immediately
- author-state narration is converted or cut
- stance sentences are cut
- the correction is preserved as a fact
- remaining notes, if any, are short

Fails if:

- the output keeps `What I concluded`
- the output keeps `That's what I shelved it on`
- the output says it made the prose more human
- the output reports passed gates instead of just passing them

## Strict Heading Pass

Prompt:

```md
Use humanizer strict mode on these headings only.

## Key takeaways
## Problems worth fixing
## What's already correctly structured
## What would change this conclusion
```

Passes if the output uses short working labels such as `Summary`, `Problems to fix`, `Good structure`, and `What to watch`.

## Normal Mirrored Rhythm Pass

Prompt:

```md
Use humanizer on this draft.

The one line worth carrying forward is the assertReady call. Every Node harness approximates that context. This is the context. A workflow you believe is working actually works. This one has been failing since July. The cost of the bug is not the missing check. It is the false confidence. The trace answers. Nothing answers it today.
```

Passes if:

- the rewrite removes mirrored rhythm without being asked for strict mode
- the technical facts survive
- no aphoristic closer remains
- no stance heading remains

Fails if:

- the output keeps `This is the context`
- the output keeps `Nothing answers it today`
- the output explains that it ran a construction sweep

## Protected Parallelism Pass

Prompt:

```md
Use humanizer on this draft.

DO NOT store bearer tokens in `chrome.storage.local`. Store bearer tokens in `chrome.storage.session`.

DO store observability session IDs in `chrome.storage.local`. They need to survive a browser restart for trace correlation.

Driven with a payload carrying no id and a foreign name, the worker relabelled the part. Driven with a token missing `exp`, the expiry guard never fired.
```

Passes if:

- exact storage terms survive
- the `DO NOT` / `DO` distinction survives
- the `Driven with...` evidence survives or is replaced by equally explicit executed evidence
- any remaining parallelism has a technical reason

## Word Choice Pass

Prompt:

```md
Use humanizer on this runbook section.

Before you deploy, turn off the scheduler and set up the replacement config. Carry out a dry run. If the counts look off, find out which shard drifted and get rid of the stale cache. Each job writes to a folder under the run root; when a task fails, the retry handler reads the same directory. Older than six months? It's expired. Grab a fresh one. The rollback is pretty fast.
```

Passes if:

- phrasal verbs are replaced with plain verbs
- `job` and `task` collapse to one name, and `folder` and `directory` collapse to one name
- the question-as-condition is gone, because the document carries a procedure
- `pretty fast` becomes a number or an explicit unknown
- steps read as commands

Fails if:

- the output keeps `turn off`, `set up`, `carry out`, `find out`, or `get rid of`
- the output alternates between `job` and `task`
- the output keeps `Older than six months? It's expired.`
- the output keeps `pretty fast` without a number or an unknown
- the output applies the rules to only one section of the passage

## Mixed Document Pass

Prompt:

```md
Use humanizer on this document.

We should move the scheduler off cron. Cron gives us no retry semantics and no visibility, and we have lost three overnight runs this quarter to silent failures.

## Rollback steps

Turn off the new scheduler. Set up the cron entry again. Carry out a dry run.
```

Passes if:

- the rollback steps use plain verbs
- the argument paragraph also uses plain verbs, because the document carries a procedure section
- the tradeoff in the argument paragraph survives
- `three overnight runs this quarter` survives as a number

Fails if:

- the rules are applied to the rollback steps only
- the argument paragraph is flattened into a bare requirement and loses the reason
