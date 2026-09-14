# Selected-capsule candidate experiment — focused adjudication

Date: 2026-09-14. Status: **failed**. The current humanizer entry, common policy, and selected-mode capsules have the hashes in `validation-results.md`. This experiment tested the current split layout after the earlier combined-policy Claude failures.

## Evidence admission

Nine fresh calls returned status 0 and passed the source-read gate: all required worktree paths were read, their recorded SHA-256 values still match the source, the other mode capsule was not read, and no native installed `Skill` invocation occurred. Each call has `prompt.txt`, `output.md`, `events.jsonl`, `stderr.txt`, and `meta.json` under `validation/raw/candidate-v2-{gate,targeted,codex-controls}/<runtime>/<case>/`. Exit status and correct loading establish admissibility only; the semantic verdict below comes from inspecting outputs against the fixture checks.

## Claude

| Case | Result | Evidence |
| --- | --- | --- |
| `journal-default` | Pass on the motivating construction | Engineering audit identified `It kept going, and so did I.` as mirrored rhythm and gave a repair direction, without rewriting the draft. It also flagged two author-state sentences; the fixture allows concrete error ownership to remain, so these additional findings warrant caution but do not erase the required mirrored-close finding. |
| `audit-personal` | Pass | Same journal source returned `No actionable findings.` and no replacement draft. |
| `regression-word-choice` | **Fail** | The rewrite used plain verbs and kept `job` distinct from `task`; it normalized the same directory path. It ended `Rollback is fast.` The source only said `pretty fast` and gave no duration, so the output retains and arguably strengthens an unsupported operational speed claim instead of saying the duration is unknown. |
| `protection-engineering` | **Fail** | Exact technical spans survived, but the unprotected `I wanted **one** quiet evening.` remained unchanged in an engineering edit. |
| `protection-personal` | Pass | Exact technical spans and the purposeful personal emphasis survived. |

## Codex paired controls

`journal-default` identified the mirrored close in engineering audit; `audit-personal` returned no findings. `protection-engineering` removed the unprotected wish while preserving exact technical spans; `protection-personal` kept the purposeful personal line and exact spans. All four calls passed the source-read gate and their fixture assertions.

## Disposition

The first Claude battery failed on two source-correct, current-hash outputs. Under `implementation-architecture.md`'s bounded-experiment stop condition, the focused Claude repeats, full candidate suite, PR, release, and installation do not proceed. The selected-capsule layout did improve the observed default journal audit, but it did not resolve the rollback wording failure, and it exposed a protection-engineering failure that earlier evidence could not adjudicate because that run loaded installed 4.7. The split therefore has no acceptance pass. Return to architecture review before changing policy semantics; do not add case-specific warnings or treat the Codex passes as a release verdict.

Mutation coverage: the local lint routing mutation was run and caught by its test, as recorded in `validation/mechanical.md`. No semantic model mutation was attempted; this experiment directly exercised the current candidate against constructed cases.
