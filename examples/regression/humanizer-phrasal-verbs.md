# Humanizer Regression: Phrasal Verbs in Reference Documents

## Bad Source

```md
## Before you deploy

Turn off the scheduler. Set up the replacement config, then carry out a
dry run. If the counts look off, find out which shard drifted and get rid
of the stale cache. Older than six months? It's expired. Grab a fresh one.
```

## Why It Fails

- `Turn off`, `Set up`, `carry out`, `find out`, and `get rid of` are phrasal verbs in a procedure.
- `look off` is idiomatic and does not survive translation.
- `Older than six months? It's expired.` is a question-as-condition. That move belongs in argument documents, not procedures.
- `Grab` is informal where the reader needs one unambiguous verb.

## Expected Shape

```md
## Before you deploy

1. Disable the scheduler.
2. Configure the replacement config.
3. Perform a dry run.
4. If the counts do not match, determine which shard drifted.
5. Remove the stale cache. A cache older than six months is expired.
   Generate a new one.
```

## Pass Checks

- No phrasal verbs remain.
- Each step is one instruction, written as a command.
- The texture move is gone because the document carries a procedure.
- `six months` survives as a number rather than becoming `old`.
- The step order and the technical meaning are unchanged.
