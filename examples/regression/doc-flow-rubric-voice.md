# Doc Flow Review Regression: Rubric Voice

## Bad Output

```md
Overall, the document has a clear direction and would benefit from improved information flow. The background section appears after the recommendation, which may make it harder for readers to understand the context. Consider moving the background earlier.
```

## Why It Fails

- Starts with generic praise.
- Uses rubric language instead of reader cost.
- Softens the fix with `consider`.

## Expected Shape

```md
The recommendation comes before the reader has the context to judge it.

- [structure] Move `Background` before `Recommendation`. Right now the reader sees the decision before they know who owns the work, who depends on it, or what changes.
```

## Pass Checks

- Starts with the reader problem.
- Gives the smallest structural fix.
- Does not explain the review method.

