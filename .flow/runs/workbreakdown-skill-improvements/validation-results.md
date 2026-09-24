# Validation results: Slice A, chunk 1

- Commits: a6b9eb4 (the feature), 7b58289 (implementation-review fixes), and 54f665a, cedeb73 and bafcc78 (acceptance-review fixes). All are local only, not pushed.
- Updated during flow-review. The final-state results are in "Acceptance-review update" below.
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

## Acceptance-review update (final state bafcc78)

- The contract suites, `validate-skills`, `install-test` (17/17) and Vale are all green.
- The schema-2/3 fixtures, VERSION (1.4.0) and the root CHANGELOG are unchanged.
- The leak grep is clean.
- The only removed lines are the same 5 validator lines as before.
- The Ruby suite now has 41 new rejection or positive-control calls beyond main.

### Correction: the mutation helper

The first round's helper judged each mutant by grepping the suite output for `FAIL` or `passed`. A mutant that crashes the suite with an uncaught `NoMethodError` prints neither word, so the helper could report it wrongly. Every mutant was re-run with a check on the suite's exit code, so non-zero means caught. Results:

| Mutant | Result |
| --- | --- |
| M1 accept schema 5 | caught |
| M2 drop `validate_placeholder_definers` | caught |
| M3 disable the schema-2/3 gate on `shaping`/`sources` | caught (see note) |
| M4 drop the `jira_context` enum | caught |
| M5 drop the `material`/`stale` boolean check | caught |
| M6 drop the `from_epic` Jira-key pattern | caught |
| M7 date check by format only (accepts 2026-13-45) | caught |
| M8 allow duplicate conflict source refs | caught |
| M9 revert the root check order (schema before unknown keys) | caught |
| M10 prose changes an enum value | caught by the vocabulary and rule pins |
| M11 prose deletes the `source` enum rule | caught by the rule pin |
| M12 prose deletes the boolean rule | caught by the rule pin |
| M13 allow default reviewers | caught |
| M14 drop the claim type check | caught (the suite crashes with NoMethodError) |
| M15 validator adds a verdict value without a prose update | caught by the rule pin, which is generated from the validator constants |

**Note on M3.** Two paths enforce `shaping`/`sources` on schema 2 and 3: the explicit gate and the schema-2/3 root key list. With the gate disabled, the root key check still rejects the manifest, but with the generic "manifest has unknown field" message, so the fragment assertion fails. The mutant proves that the specific error is load-bearing and that the rule is enforced twice. It does not prove the gate is the only enforcement.

**Prose pin limits.** The pin strips the worked example and then checks two things: each schema-4 key name and enum value appears in the rule text, and each enumerated rule sentence matches text generated from the validator constants. Free-text rules, such as "location is required when verdict is found", are pinned only by their negative tests, not by the prose.

## Date-check follow-up (maintainer request, after review acceptance)

The error for an impossible date now reads "conflict source date must be a valid YYYY-MM-DD date".

New cases:
- Impossible dates are rejected: 2026-13-45, 2026-02-29 and 2026-04-31.
- Other ISO 8601 forms are rejected: 20260203, 2026-W06-2 and 2026-034.
- A positive control accepts the leap day 2024-02-29.

These landed in commits b9d4bfc and 5816ae2. Mutants were judged by exit code at 5816ae2:

| Mutant | Result |
| --- | --- |
| M7: format-only check | caught |
| M16: drop the format regex | caught |
| M17: reject a valid leap day | caught |

**Correction.** At b9d4bfc, M16 survived: without the regex, `Date.iso8601` accepts the other ISO forms, and no test covered them. The first version of this note, committed in 8557497, wrongly recorded M16 as caught. Commit 5816ae2 added the other-form cases, and M16 is now caught.
