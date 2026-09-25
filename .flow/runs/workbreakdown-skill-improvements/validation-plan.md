# Validation plan: Slice A, chunk 1

Run from the worktree root.

1. `bash tests/workbreakdown-contract-test.sh` passes, which includes the new `require_text` checks.
2. `bash tests/workbreakdown/workbreakdown-template-contract-test.sh` (the Ruby suite) passes. Both schema-4 valid fixtures validate, and every negative case in `plan.md` raises its specific fragment.
3. **Regression.** `git diff main --stat -- tests/workbreakdown/fixtures/schema2-* tests/workbreakdown/fixtures/schema3-*` shows no changes, and every pre-existing assertion in the Ruby suite still runs and passes. Assertions are added to the suite only; none are removed.
4. **Mutation check.** Temporarily change the validator to accept `schema_version: 5`, confirm the suite fails on the `schema_version: 5` case, then revert. This proves the negative tests bite.
5. **Pinned phrases.** `grep -F "Manifest schema 2 remains child-only." skills/workbreakdown/SKILL.md` matches, and the version line still matches VERSION, which is unchanged at 1.4.0.
6. **Public-safety check.** `git diff main -- . ':(exclude).flow' | grep -nE 'AE-[0-9]+|ER-[0-9]+'` is empty, and no people's names or private project names appear.
7. Record the command outputs, pass or fail, in `validation-results.md`.
