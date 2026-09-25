# Implementation handoff: Slice A, chunk 1

- **Where:** `~/agent-skills-worktrees/workbreakdown-slice-a`, branch `claude/workbreakdown-slice-a`, in the public repo `andyconley/agent-skills`. Do not touch the `~/agent-skills` main checkout. It holds another run's uncommitted work.
- **Plan:** `plan.md` in this run is the complete spec. Implement exactly its in-scope list.
- **Files:**
  - `skills/workbreakdown/references/manifest-contract.md`
  - `skills/workbreakdown/SKILL.md`
  - `tests/workbreakdown/workbreakdown-template-contract-test.rb`
  - `tests/workbreakdown-contract-test.sh`
  - `tests/workbreakdown/fixtures/schema4-minimal-valid.yaml`
  - `tests/workbreakdown/fixtures/schema4-full-valid.yaml`
- **Order:**
  1. Write the fixtures and negative tests first; they fail.
  2. Update the Ruby validator.
  3. Update the prose, then the shell `require_text` checks.
  4. Run the validation.
- **Constraints:**
  - Keep every `require_text` phrase currently pinned.
  - Do not modify the existing schema-2 and schema-3 fixtures.
  - Do not edit VERSION or the root CHANGELOG.
  - Public repo: no private identifiers. Use synthetic keys only, such as `INIT-100`, `EPIC-200` and `WORK-301`, matching the existing fixtures.
- **Commit:** a local conventional commit, `feat(workbreakdown): add manifest schema 4 foundation`, ending with the attribution line. Do not push. The maintainer decides when.
- **Done when:** every check in `validation-plan.md` passes, and the result is recorded in `validation-results.md`.
