# Simplified Technical English: Before and After

A worked example, produced by `humanizer` 4.7.0 against a draft written to be representative of the reference documents these rules target. It is not a captured customer artifact.

The draft below is mixed: it opens with an argument and ends with a procedure. Under the document-level rule, the whole thing takes the Simplified Technical English rules, including the opening.

## Before

```md
## Rotating the signing key

Key rotation is one of those things that everybody puts off until it
bites them. We've had two incidents this year that traced back to a key
nobody had touched in eighteen months, so we're tightening it up.

The gist: rotate on a schedule, not when something breaks.

### Steps

First you'll want to turn off the verifier so it doesn't start rejecting
things mid-rotation. Then set up the new keypair and carry out a smoke
test against staging. If the smoke test looks off, find out which
service is still holding the old public key — usually it's the edge
proxy, which caches aggressively. Get rid of the cached copy and try
again.

Older than ninety days? It's stale. Generate a fresh one.

Once everything's green, turn the verifier back on. The whole thing is
pretty quick if nothing goes wrong.
```

## After

```md
## Rotating the signing key

Rotate the signing key on a schedule, not in response to a failure. Two
incidents this year traced back to a key that had not been rotated in 18
months.

### Steps

1. Disable the verifier. A verifier that stays enabled rejects requests
   during the rotation.
2. Generate the new keypair.
3. Perform a smoke test against staging.
4. If the smoke test fails, determine which service still holds the old
   public key. The edge proxy is the most common cause because it caches
   public keys.
5. Remove the cached copy from the edge proxy, then repeat step 3.
6. Enable the verifier.

A key older than 90 days is stale. Generate a new key.

Expected duration: unknown. Record the elapsed time on the next rotation
and replace this line with the measured value.
```

## What changed and why

| Change | Rule |
| --- | --- |
| `turn off` to `Disable`, `set up` to `Generate`, `carry out` to `Perform`, `find out` to `determine`, `Get rid of` to `Remove` | Plain verbs, not phrasal verbs |
| `looks off` to `fails` | No idioms |
| `eighteen months` to `18 months`, `ninety days` to `90 days` | Numbers, not adjectives |
| `pretty quick` to an explicit unknown with a way to close it | Numbers, not adjectives. The number was never in the draft, so the rewrite names the gap instead of inventing one. |
| `Older than ninety days? It's stale.` to a statement | The texture move is dropped because the document carries a procedure |
| Prose paragraph to numbered steps | One instruction per step, written as commands |
| `everybody puts off until it bites them` cut | Rationale removed from a reference document |
| `try again` to `repeat step 3` | One instruction per step; the reader should not have to infer which step |

## What did not change

- The incident count and the 18-month figure survive as stated.
- The edge-proxy cause survives, including why it happens.
- The step order is unchanged.
- The rewrite does not invent a duration to satisfy the numbers rule.
