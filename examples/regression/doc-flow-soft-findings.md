# Doc Flow Review Regression: Soft Findings

## Bad Output

```md
The document may want to consider making the risks more explicit. It could also be helpful to clarify the dependency order. There are opportunities to tighten the explanation.
```

## Why It Fails

- The findings are preferences, not reader costs.
- The fixes are vague.
- The wording sounds like the reviewer avoiding a call.

## Expected Shape

```md
The doc does not give the reader enough dependency order to act.

- [disclosure] Name the upstream dependency before the risk section. Right now the risk points at a failure mode the reader has not seen yet.
- [detail] Add the owner and trigger for the dependency. Without those, the reader cannot turn the risk into a Jira task.
```

## Pass Checks

- Each finding states what breaks for the reader.
- Each fix is concrete.
- No soft phrases such as `may want to consider` or `opportunities to tighten`.

