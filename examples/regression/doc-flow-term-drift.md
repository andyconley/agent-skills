# Doc Flow Review Regression: Term Drift Finding

## Bad Review Output

```md
[disclosure] The document uses inconsistent terminology. I rewrote the
affected sentences to use "job" throughout:

  Each job writes its output to a directory under the run root. When a
  job fails, the retry handler replays it from the last checkpoint.

I also fixed the comma splice in the second sentence.
```

## Why It Fails

- The review rewrote the prose. `doc-flow-review` reports structure and stops.
- The author no longer chooses the name. `job` was picked for them.
- The comma splice is a copyedit, which the scope gate excludes.

## Expected Shape

```md
[disclosure] Section 3 calls it a `job`; section 5 calls the same thing a
`task`, and section 6 uses `work item`. The reader cannot tell whether
the retry path handles the same unit that failed. Pick one name and use
it throughout.
```

## Pass Checks

- The finding names where the drift happens.
- The finding states the reader cost, not a style preference.
- The fix is the smallest one: pick a name. The review does not pick it.
- No prose is rewritten and no copyedits appear.
- One finding covers the drift rather than one finding per section.
