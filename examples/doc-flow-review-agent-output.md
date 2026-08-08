# Doc Flow Review Agent Output Examples

These examples test whether the reviewer behaves like a reader, not a rubric.

## Source

```md
# Migration Plan

We should move the reporting jobs to the new pipeline next quarter.

## Risks

The dashboard depends on the old job format.

## Background

The current reporting jobs are owned by Data Platform. Finance consumes the dashboard every weekday morning. The new pipeline emits a different schema.

## Recommendation

Proceed with migration.
```

## Bad agent output

```md
## Key takeaways

Overall, the document has a clear direction and contains useful sections, but it would benefit from improved information flow and stronger argumentation. The background appears after the recommendation, which may make it harder for readers to understand the context. The risks section also introduces dependency information before the reader has enough background. Consider moving the background earlier and expanding the recommendation to better connect it to the stated risks.

## Problems worth fixing

- [structure] The background comes too late.
- [disclosure] The dashboard dependency is introduced before the schema change is explained.
- [argument] The recommendation is not fully supported by the preceding information.
```

Why it fails:

- Opens with padded evaluation.
- Turns one structural problem into three overlapping findings.
- Sounds like a rubric, not a reader.
- Uses polished review headings that agents overuse.

## Good agent output

```md
## Summary

The doc gives the recommendation before the reader knows enough to judge it.

## Problems to fix

- [structure] Move `Background` before `Risks` and `Recommendation`. Right now I hit "new pipeline" and "old job format" before I know who owns the jobs, who consumes the dashboard, or that the schema changes.
- [argument] The recommendation says "proceed," but the doc has not explained why the dashboard risk is acceptable. Add the reason, or change the recommendation.

## Good structure

The doc has the right raw pieces. They are just in the wrong order.
```
