# Humanizer Regression: Author-State Narration

## Bad Source

```md
What I concluded, and what I'm not claiming: fix both defects and TS symbol coverage still lands near 48%. That's what I shelved it on. Two things I didn't test that may matter more: cross-repo OpenAPI linking and the summarization layer. My first read of this was wrong because the number counts references, not targets.
```

## Why It Fails

- The author is the subject too often.
- The correction is framed around the writer's experience.
- `That's what I shelved it on` narrates analysis instead of adding evidence.

## Expected Shape

```md
Fixing both defects still leaves TS symbol coverage near 48%.

Limits:
- Untested: cross-repo OpenAPI linking and the summarization layer.
- The remaining gap may have other causes.

Correction:
- The earlier count used references, not targets.
```

## Pass Checks

- The subject is the coverage, limits, and correction.
- No sentence starts with `What I concluded`, `I didn't test`, or `My first read`.
- The correction keeps the fact without making the author the point.

