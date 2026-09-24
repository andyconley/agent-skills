# Validation results: Slice A, chunk 1

- Commits: a6b9eb4 (`feat(workbreakdown): add manifest schema 4 foundation`) and 7b58289 (`fix(workbreakdown): tighten schema 4 prose and coverage from review`). Both are local only, not pushed.
- Validated against: the change itself, in the worktree `claude/workbreakdown-slice-a`. No surrogate was used.

| # | Check (validation-plan.md) | Result |
| --- | --- | --- |
| 1 | Shell contract test, including the new `require_text` pins | Pass |
| 2 | Ruby suite: both schema-4 fixtures valid; every plan negative case plus 10 extra cases raise their fragments | Pass |
| 3 | The schema-2 and schema-3 fixtures are unchanged. The only removed lines are the 5 replaced validator lines; no assertion was removed | Pass |
| 4 | Mutation checks (see below) | Pass: 5 of 5 caught |
| 5 | The pinned phrase is present, VERSION is 1.4.0, and neither VERSION nor the root CHANGELOG is in the diff | Pass |
| 6 | Public safety: no `AE-`/`ER-` keys, and no private names or projects in the diff outside `.flow` | Pass |
| 7 | Extra: `validate-skills.sh`, `install-test.sh` (17/17), and Vale strict on both changed prose files (0/0/0) | Pass |

## Mutation checks

Each mutant ran against committed code and was restored with `git checkout`, and the suite was green after each restore.

| Mutant | Test that caught it |
| --- | --- |
| Accept `schema_version: 5` | "unsupported schema" |
| Drop `validate_placeholder_definers` | "placeholder defined_by must name a Spike" |
| Disable the schema < 4 gate on `shaping`/`sources` | the `schema3_shaping` case (the generic unknown-field error replaced the specific fragment) |
| Drop the `jira_context` enum | "invalid jira_context" |
| Drop the `material`/`stale` boolean check | "conflict material must be true or false" |

## Command output (final state, 7b58289)

```
$ bash tests/workbreakdown-contract-test.sh
workbreakdown template contract tests passed
Workbreakdown contract checks passed.
$ bash scripts/validate-skills.sh
Validated 3 skills.
$ bash tests/install-test.sh
1..17
$ git diff main --stat -- tests/workbreakdown/fixtures/schema2-* tests/workbreakdown/fixtures/schema3-*
(no output: unchanged)
$ git diff main -U0 -- <ruby suite> | grep "^-[^-]"   # removed lines
-def validate_child(child, templates, set_version)
-  reject_unknown_keys(child, CHILD_KEYS, "child")
-  reject_unknown_keys(manifest, ROOT_KEYS, "manifest")
-  raise ArgumentError, "unsupported schema" unless [2, 3].include?(schema)
-  children.each { |child| validate_child(child, templates, set_version) }
$ grep -F "Manifest schema 2 remains child-only." skills/workbreakdown/SKILL.md | wc -l
1
$ cat skills/workbreakdown/VERSION; git diff main --stat -- skills/workbreakdown/VERSION CHANGELOG.md
1.4.0
(no output: unchanged)
$ git diff main -- . ":(exclude).flow" | grep -nE "AE-[0-9]+|ER-[0-9]+"
(no output: clean)
```
