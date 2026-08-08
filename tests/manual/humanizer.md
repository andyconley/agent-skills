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

