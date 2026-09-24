# Validation results: Slice A completion

## Implementation clarifications (maintainer, 2026-09-24)

These settle four gaps in step 5 that the approved plan left open.

1. The agent under test also gets read-only `--add-dir` access to the two precedent repositories, so FX-PATTERN can reach `verdict: found`. The R2.2 control run omits them.
2. Rerun rule: a judged check that passes on its first run passes. A failing judged check runs twice more and passes only when both reruns pass, which is 2 of 3. This replaces "best of 3" in `validation-plan.md`.
3. The agent under test runs on Opus.
4. The release script lives in the KB worktree's `utilities/workbreakdown-release-check/` on its existing `claude/*` branch. The snapshot and results live under the private run's `evidence/` folder and are committed to KB locally.
