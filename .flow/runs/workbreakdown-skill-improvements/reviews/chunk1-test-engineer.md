# Chunk 1 review: test-engineer (coverage)

Reviewer: test-engineer agent (sonnet/medium), read-only, against commit a6b9eb4.

- Every negative case the plan requires maps to a test, and each one fires on its intended check for its intended reason. Schema gates run before the unknown-key rejection, and neither a shared fragment prefix nor an earlier check masks a case.
- **Gaps (low):** these are outside the plan's required list:
  - negative cases for `task_granularity`, `reviewers`, `source_order`, `jira_context`, `material`/`stale`, `question` and `precedent.searched`
  - no positive coverage of `amendments` in `existing_children.read`
- **Disposition:** all fixed in 7b58289. Negative cases were added for each gap, and the fixture now reads every source kind, which a new assertion pins.
